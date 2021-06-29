using MIS.BO;
using MIS.Model;
using MIS.Services.Contracts;
using MIS.Utilities;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Core.Objects;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Reflection;
using System.Web;
using MIS.Utilities.Helpers;
using System.Xml.Linq;
using System.Net.Mail;

namespace MIS.Services.Implementations
{
    public class UserServices : IUserServices
    {
        #region Private member variables.
        private readonly MISEntities _dbContext = new MISEntities();

        private readonly ICommonService _common;
        #endregion

        public UserServices()
        {
            this._common = new CommonService();
        }

        /// <summary>
        /// Public method to authenticate user by user name and password.
        /// </summary>
        /// <param name="userName">UserName</param>
        /// <param name="password">Password</param>
        /// <param name="browserInfo">BrowserInfo</param>
        /// <param name="clientInfo">ClientInfo</param>
        /// <returns>ResponseBO</returns>
        public ResponseBO<UserAccountStatus> Authenticate(string userName, string password, string browserInfo, string clientInfo)
        {
            var response = new ResponseBO<UserAccountStatus>() { IsSuccessful = false, Status = ResponseStatus.Error, StatusCode = HttpStatusCode.InternalServerError, Message = ResponseMessage.Error };
            var userAccountStatus = new UserAccountStatus() { UserAbrhs = CryptoHelper.Encrypt("0"), IsRedirect = false, IsLocked = false, PasswordResetCode = string.Empty };
            if (!string.IsNullOrEmpty(userName) && !string.IsNullOrEmpty(password))
            {
                var encryptedUserName = CryptoHelper.Encrypt(userName.ToLower());
                //var userEmail = _dbContext.UserDetails.FirstOrDefault(x => x.EmailId == encryptedUserName && x.TerminateDate == null);
                //    var userEmailId = 0;
                //if (userEmail != null)
                //    userEmailId = userEmail.UserId;
                //var userData = _dbContext.Users.FirstOrDefault(t => (t.UserName == encryptedUserName || t.UserId == userEmailId) && t.IsActive);// && !t.IsSuspended

                var userInfo = _dbContext.vwAllUsers.FirstOrDefault(t => (t.UserName == encryptedUserName || t.EmailId == encryptedUserName) && t.IsActive);

                if (userInfo == null) //user does not exists in DB in active state
                {

                    _common.LogUserActivity(0, userName, browserInfo, clientInfo, "Failure", "Login failed for the user : " + userName);

                    response.StatusCode = HttpStatusCode.Unauthorized; //401
                    response.Message = ResponseMessage.LoginFailed;
                    response.Result = userAccountStatus;
                }
                else   //user exists in DB in active state
                {
                    var userData = _dbContext.Users.FirstOrDefault(t => t.UserId == userInfo.UserId); // && !t.IsSuspended

                    var isCorrectPassword = CryptoHelper.VerifyPassword(userData.Password, password);
                    userAccountStatus.UserAbrhs = CryptoHelper.Encrypt(userData.UserId.ToString());

                    TimeSpan? lastPasswordChange = DateTime.UtcNow - userData.LastPasswordChanged; //diff between present datetime and last PasswordChanged datetime
                    //TimeSpan? lastLoginDate = DateTime.UtcNow - userData.LoginDate; //diff between present datetime and last successful LoginDate datetime
                    TimeSpan? lastUnsuccessfulLoginAttemptDate = DateTime.UtcNow - userData.LastUnsuccessfulLoginAttemptDate; //diff between present datetime and last successful LoginDate datetime

                    var passwordResetCode = Utilities.CommonUtility.GenerateRandomCode(10);
                    //var link = ConfigurationManager.AppSettings["PasswordResetUrl"] + passwordResetCode;

                    if (!isCorrectPassword) //wrong password
                    {
                        userData.LastUnsuccessfulLoginAttemptDate = DateTime.Now;

                        if (lastUnsuccessfulLoginAttemptDate.HasValue && lastUnsuccessfulLoginAttemptDate.Value.TotalMinutes > 5)
                        {
                            userAccountStatus.LeftAttempts = 4;
                            userData.UnsuccessfulLoginAttempt = 1;

                            response.StatusCode = HttpStatusCode.Unauthorized; //401
                            response.Status = ResponseStatus.Error;
                            response.Message = ResponseMessage.PasswordIncorrect;
                            _common.LogUserActivity(userData.UserId, userName, browserInfo, clientInfo, "Failure", "Login failed for the user : " + userName + ". Password is incorrect.");
                        }
                        else
                        {
                            var wrongAttempt = userData.UnsuccessfulLoginAttempt + 1;
                            var leftAttempt = 5 - wrongAttempt;
                            userAccountStatus.LeftAttempts = leftAttempt;

                            if (wrongAttempt == 5 || userData.IsLocked)
                            {
                                userData.IsLocked = true;
                                userData.UnsuccessfulLoginAttempt = 5;

                                response.StatusCode = HttpStatusCode.Forbidden; //403
                                response.Status = ResponseStatus.Warning;
                                response.Message = ResponseMessage.AccountLocked;
                                _common.LogUserActivity(userData.UserId, userName, browserInfo, clientInfo, "Failure", "Login failed for the user : " + userName + ". Account is locked.");

                                //send mail that account is locked
                            }
                            else
                            {
                                userData.UnsuccessfulLoginAttempt = wrongAttempt;

                                response.StatusCode = HttpStatusCode.Unauthorized; //401
                                response.Status = ResponseStatus.Error;
                                response.Message = ResponseMessage.PasswordIncorrect;
                                _common.LogUserActivity(userData.UserId, userName, browserInfo, clientInfo, "Failure", "Login failed for the user : " + userName + ". Password is incorrect.");
                            }

                            //send mail with last login device detail if leftAttempt == 2
                        }
                        userAccountStatus.IsLocked = userData.IsLocked;
                    }
                    else if (userData.IsSuspended)  //account id suspended
                    {
                        response.StatusCode = HttpStatusCode.Gone; //410
                        response.Status = ResponseStatus.Error;
                        response.Message = ResponseMessage.AccountSuspended;
                        _common.LogUserActivity(userData.UserId, userName, browserInfo, clientInfo, "Failure", "Login failed for the user : " + userName + ". Account is suspended");
                    }
                    else if (userData.IsLocked)    //account is locked
                    {
                        userAccountStatus.IsLocked = true;
                        if (lastUnsuccessfulLoginAttemptDate.HasValue && lastUnsuccessfulLoginAttemptDate.Value.TotalHours >= 24) //24 hrs have passed since account was locked so unlock it automatically
                        {
                            userAccountStatus.IsLocked = false;

                            if (lastPasswordChange != null && lastPasswordChange.HasValue && lastPasswordChange.Value.TotalDays > 30) //check if password is >30 days old then redirect
                            {
                                userData.PasswordResetCode = passwordResetCode;
                                userData.IsPasswordResetCodeExpired = false;

                                userAccountStatus.IsRedirect = true;//isCorrectPassword;
                                userAccountStatus.PasswordResetCode = passwordResetCode;

                                response.StatusCode = HttpStatusCode.Redirect; //302
                                response.Status = ResponseStatus.Warning;
                                response.Message = ResponseMessage.PasswordExpired;

                                _common.LogUserActivity(userData.UserId, userName, browserInfo, clientInfo, "Failure", "Login failed for the user : " + userName + ". Password expired.");
                            }
                            else //successfully login
                            {
                                response.IsSuccessful = true;
                                response.Status = ResponseStatus.Success;
                                response.StatusCode = HttpStatusCode.OK; //200
                                response.Message = ResponseMessage.Success;

                                userData.AccountLockCode = null;
                                userData.IsLocked = false;
                                userData.LoginDate = DateTime.UtcNow;
                                userData.UnsuccessfulLoginAttempt = 0;

                                _common.LogUserActivity(userData.UserId, userName, browserInfo, clientInfo, "Success", "Login successful");
                            }
                        }
                        else //account is currently locked
                        {
                            response.StatusCode = HttpStatusCode.Forbidden; //403
                            response.Status = ResponseStatus.Warning;
                            response.Message = ResponseMessage.AccountLocked;

                            _common.LogUserActivity(userData.UserId, userName, browserInfo, clientInfo, "Failure", "Login failed for the user : " + userName + ". Account is locked.");
                        }
                    }
                    else if (lastPasswordChange != null && lastPasswordChange.HasValue && lastPasswordChange.Value.TotalDays > 30) //if (userAccountStatus.IsRedirect)
                    {
                        //update entry in DB
                        userData.PasswordResetCode = passwordResetCode;
                        userData.IsPasswordResetCodeExpired = false;

                        userAccountStatus.IsRedirect = true;
                        userAccountStatus.PasswordResetCode = passwordResetCode;

                        response.StatusCode = HttpStatusCode.Redirect; //302
                        response.Status = ResponseStatus.Warning;
                        response.Message = ResponseMessage.PasswordExpired;

                        _common.LogUserActivity(userData.UserId, userName, browserInfo, clientInfo, "Failure", "Login failed for the user : " + userName + ". Password expired.");
                    }
                    else if (!userData.IsSuspended && !userData.IsLocked && isCorrectPassword)//&& !userAccountStatus.IsRedirect 
                    {
                        response.IsSuccessful = true;
                        response.Status = ResponseStatus.Success;
                        response.StatusCode = HttpStatusCode.OK; //200
                        response.Message = ResponseMessage.Success;

                        userData.AccountLockCode = null;
                        userData.IsLocked = false;
                        userData.LoginDate = DateTime.UtcNow;
                        userData.UnsuccessfulLoginAttempt = 0;

                        _common.LogUserActivity(userData.UserId, userName, browserInfo, clientInfo, "Success", "Login successful");
                    }
                    else
                    {
                        response.StatusCode = HttpStatusCode.InternalServerError; //500,
                        response.Status = ResponseStatus.Error;
                        response.Message = ResponseMessage.Error;

                        _common.LogUserActivity(userData.UserId, userName, browserInfo, clientInfo, "Failure", "Login failed for the user : " + userName + ResponseMessage.Error);
                    }
                    response.Result = userAccountStatus;
                }
            }
            else
            {
                response.Message = ResponseMessage.FieldsRequired;
                response.Result = userAccountStatus;
            }
            _dbContext.SaveChanges();
            return response;
            #region unused
            //var user = _dbContext.Users.FirstOrDefault(t => t.UserName == encryptedUserName && t.Password == encrytPwd && t.IsActive);
            //if (user != null && user.UserId > 0)
            //{
            //    //////////////////////////////////////////////////////////////


            //    //////////////////////////////////////////////////////////////
            //    //After success
            //    _common.LogUserActivity(user.UserId, userName, browserInfo, clientInfo, "Success", "Login successful");

            //    response.IsSuccessful = true;
            //    response.Status = ResponseStatus.Success;
            //    response.StatusCode = HttpStatusCode.OK;
            //    response.Message = ResponseMessage.LoginSuccess;
            //    response.Result = user.UserId;
            //}
            //else
            //{
            //    _common.LogUserActivity(0, userName, browserInfo, clientInfo, "Failure", "Login failed for the user : " + userName);
            //    response.StatusCode = HttpStatusCode.Unauthorized;
            //    response.Message = ResponseMessage.LoginFailed;
            //    response.Result = 0;
            //}
            #endregion
        }

        /// <summary>
        /// Public method to get user details by userId.
        /// </summary>
        /// <param name="userId">UserId</param>
        /// <returns>AuthenticateUserBO</returns>
        public AuthenticateUserBO GetUserDetails(int userId)
        {
            AuthenticateUserBO userBO = null;
            var reqUrl = HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + "/";
#if !DEBUG
            reqUrl = (new UriBuilder(reqUrl) { Port = -1 }).ToString();
#endif
            var baseImagePath = reqUrl + ConfigurationManager.AppSettings["ImagePath"];
            var profileImagePath = reqUrl + ConfigurationManager.AppSettings["ProfileImageUploadPath"].Replace("\\", "/");
            var maleImagePath = baseImagePath + "male-employee.png";
            var femaleImagePath = baseImagePath + "female-employee.png";
            var buildVersion = GlobalServices.GetBuildVersion();

            var user = _dbContext.Users.FirstOrDefault(t => t.UserId == userId && t.IsActive);

            if (user != null && user.UserId > 0)
            {
                var abrhs = CryptoHelper.Encrypt(user.UserId.ToString());
                userBO = (from ud in _dbContext.UserDetails
                          join r in _dbContext.Roles on user.RoleId equals r.RoleId into list1
                          from l1 in list1.DefaultIfEmpty()
                          join g in _dbContext.Genders on ud.GenderId equals g.GenderId into list2
                          from l2 in list2.DefaultIfEmpty()
                              //userBO = (from ud in _dbContext.vwActiveUsers
                          where ud.UserId == userId
                          select new AuthenticateUserBO
                          {
                              IsAuthenticated = true,
                              UserAbrhs = abrhs,
                              UserName = user.UserName,
                              //DisplayName = ud.DisplayName,
                              //RoleId = ud.RoleId,
                              //Role = ud.Role,
                              DisplayName = ud.FirstName + " " + ud.LastName,
                              RoleId = l1.RoleId,
                              Role = l1.RoleName,
                              CompanyId = user.Location.CompanyId,
                              Company = user.Location.Company.CompanyName,
                              CompanyLocationId = user.Location.LocationId,
                              CompanyLocation = user.Location.LocationName,
                              CountryId = user.Location.Country.CountryId,
                              StateId = user.Location.State.StateId,
                              CityId = user.Location.City.CityId,
                              //ImagePath = ((!string.IsNullOrEmpty(ud.ImagePath) ? (profileImagePath + ud.ImagePath) :
                              //          ((!string.IsNullOrEmpty(ud.Gender) ? ud.Gender.ToLower() : "") == "female" ? femaleImagePath : maleImagePath)) + "?v=" + buildVersion),
                              ImagePath = ((!string.IsNullOrEmpty(ud.ImagePath) ? (profileImagePath + ud.ImagePath) :
                                        ((!string.IsNullOrEmpty(l2.GenderType) ? l2.GenderType.ToLower() : "") == "female" ? femaleImagePath : maleImagePath)) + "?v=" + buildVersion),
                              AppVersion = buildVersion
                          }).FirstOrDefault();

                var userAddress = _dbContext.UserAddressDetails.Where(x => x.IsActive && x.IsAddressPermanent && x.UserId == userId).FirstOrDefault();
                if (userAddress != null)
                {
                    userBO.CountryId = userAddress.CountryId;
                    userBO.StateId = userAddress.StateId;
                    userBO.CityId = userAddress.CityId;
                }

                var appraisalCycleDetails = _dbContext.Fun_GetCurrentAppraisalCycle().FirstOrDefault();
                if (appraisalCycleDetails != null)
                {
                    userBO.CurrentAppraisalCycleId = appraisalCycleDetails.AppraisalCycleId;
                    userBO.GoalCycleId = appraisalCycleDetails.GoalCycleId;
                    userBO.FYStartDate = appraisalCycleDetails.FYStartDate.ToString();
                    userBO.FYEndDate = appraisalCycleDetails.FYEndDate.ToString();
                    userBO.FYStartYear = appraisalCycleDetails.FYStartDate.Year;
                    userBO.CurrentQuarter = appraisalCycleDetails.CurrentQuarter;
                }

                var userPermissions = _dbContext.spGetMenusPermissions(userId).Select(x => new UsersMenuBO
                {
                    //MenuId = x.MenuId ?? 0,
                    MenuAbrhs = x.MenuId.HasValue ? CryptoHelper.Encrypt(x.MenuId.Value.ToString()) : "",
                    MenuName = x.MenuName,
                    //ParentMenuId = x.ParentMenuId ?? 0,
                    IsParentMenu = x.ParentMenuId.HasValue ? (x.ParentMenuId.Value == 0) : false,
                    ParentMenuAbrhs = x.ParentMenuId.HasValue ? CryptoHelper.Encrypt(x.ParentMenuId.Value.ToString()) : "",
                    ControllerName = x.ControllerName,
                    ActionName = x.ActionName,
                    Sequence = x.Sequence ?? 0,
                    IsLinkEnabled = x.IsLinkEnabled ?? false,
                    IsTabMenu = x.IsTabMenu ?? false,
                    IsViewRights = x.IsViewRights ?? false,
                    IsAddRights = x.IsAddRights ?? false,
                    IsModifyRights = x.IsModifyRights ?? false,
                    IsDeleteRights = x.IsDeleteRights ?? false,
                    IsAssignRights = x.IsAssignRights ?? false,
                    IsApproveRights = x.IsApproveRights ?? false,
                    IsDelegatable = x.IsDelegatable ?? false,
                    IsDelegated = x.IsDelegated ?? false,
                    IsVisible = x.IsVisible ?? false,
                    CssClass = x.CssClass
                }).OrderBy(x => x.ParentMenuAbrhs).ThenBy(x => x.Sequence);

                //var userPermissions = _dbContext.MenusUserPermissions.Where(x => x.UserId == userId && x.IsActive == true);

                //if (userPermissions.Any()) //menu permissions by user
                //{
                //    var inactiveMenuIds = _dbContext.Menus.Where(x => x.ParentMenuId == 0 && x.IsActive == false).Select(t => t.MenuId).ToList();
                //    var menusList = (from p in userPermissions
                //                     join l1 in _dbContext.Menus.Where(x => x.IsActive == true) on p.MenuId equals l1.MenuId
                //                     where !inactiveMenuIds.Contains(l1.ParentMenuId)
                //                     select new UsersMenuBO
                //                     {
                //                         MenuId = p.MenuId,
                //                         MenuName = l1.MenuName,
                //                         ParentMenuId = l1.ParentMenuId,
                //                         ControllerName = l1.ControllerName,
                //                         ActionName = l1.ActionName,
                //                         Sequence = l1.Sequence,
                //                         IsLinkEnabled = l1.IsLinkEnabled,
                //                         IsViewRights = p.IsViewRights,
                //                         IsAddRights = p.IsAddRights,
                //                         IsModifyRights = p.IsModifyRights,
                //                         IsDeleteRights = p.IsDeleteRights,
                //                         IsAssignRights = p.IsAssignRights,
                //                         IsApproveRights = p.IsApproveRights,
                //                         IsVisible = l1.IsVisible,
                //                         CssClass = l1.CssClass
                //                     }).OrderBy(x => x.ParentMenuId).ThenBy(x => x.Sequence);
                //    userBO.Menus = menusList.ToList<UsersMenuBO>() ?? new List<UsersMenuBO>();
                //}
                //else //menu permissions by role
                //{
                //    var inactiveMenuIds = _dbContext.Menus.Where(x => x.ParentMenuId == 0 && x.IsActive == false).Select(t => t.MenuId).ToList();
                //    var menusList = (from p in _dbContext.MenusRolePermissions.Where(x => x.RoleId == userBO.RoleId && x.IsActive == true)
                //                     join l1 in _dbContext.Menus.Where(x => x.IsActive == true) on p.MenuId equals l1.MenuId
                //                     where !inactiveMenuIds.Contains(l1.ParentMenuId)
                //                     select new UsersMenuBO
                //                     {
                //                         MenuId = p.MenuId,
                //                         MenuName = l1.MenuName,
                //                         ParentMenuId = l1.ParentMenuId,
                //                         ControllerName = l1.ControllerName,
                //                         ActionName = l1.ActionName,
                //                         Sequence = l1.Sequence,
                //                         IsLinkEnabled = l1.IsLinkEnabled,
                //                         IsViewRights = p.IsViewRights,
                //                         IsAddRights = p.IsAddRights,
                //                         IsModifyRights = p.IsModifyRights,
                //                         IsDeleteRights = p.IsDeleteRights,
                //                         IsAssignRights = p.IsAssignRights,
                //                         IsApproveRights = p.IsApproveRights,
                //                         IsVisible = l1.IsVisible,
                //                         CssClass = l1.CssClass
                //                     }).OrderBy(x => x.ParentMenuId).ThenBy(x => x.Sequence);
                //    userBO.Menus = menusList.ToList<UsersMenuBO>() ?? new List<UsersMenuBO>();
                //}

                userBO.Menus = userPermissions.ToList<UsersMenuBO>() ?? new List<UsersMenuBO>();
            }
            else
            {
                userBO = new AuthenticateUserBO() { IsAuthenticated = false };
            }
            return userBO;
        }

        /// <summary>
        /// Method to get all active employee details for employee directory
        /// </summary>
        /// <returns>List<EmployeeDirectoryBO></returns>
        public List<EmployeeDirectoryBO> FetchDataForEmployeeDirectory()
        {
            var reqUrl = HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + "/";

#if !DEBUG
            reqUrl = (new UriBuilder(reqUrl) { Port = -1 }).ToString();
            //Uri uri = HttpContext.Current.Request.Url;
            //var url = uri.Scheme + Uri.SchemeDelimiter + uri.Host + ":" + uri.Port;
            //var url = uri.Scheme + Uri.SchemeDelimiter + uri.Host;
#endif
            var baseImagePath = reqUrl + ConfigurationManager.AppSettings["ImagePath"];
            var profileImagePath = reqUrl + ConfigurationManager.AppSettings["ProfileImageUploadPath"].Replace("\\", "/");

            var maleImagePath = baseImagePath + "male-employee.png";
            var femaleImagePath = baseImagePath + "female-employee.png";
            // var buildVersion = GlobalServices.GetBuildVersion();

            List<EmployeeDirectoryBO> resultList = new List<EmployeeDirectoryBO>();
            var data = _dbContext.spFetchAllActiveEmployees().ToList();
            foreach (var temp in data)
            {
                resultList.Add(new EmployeeDirectoryBO
                {
                    //UserId = temp.UserId,
                    // EmpAbrhs = CryptoHelper.Encrypt(temp.UserId.ToString()),
                    EmployeeName = temp.Name,
                    EmailId = CryptoHelper.Decrypt(temp.Email),
                    Designation = temp.Designation,
                    Department = temp.Department,
                    MobileNumber = CryptoHelper.Decrypt(temp.MobileNo),
                    Extension = temp.ExtensionNo,
                    Location = temp.Location,
                    WsNo = temp.WSNo,
                    Team = temp.Team,
                    JoiningDate = temp.JoiningDate.HasValue ? temp.JoiningDate.Value.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture) : "NA",
                    ReportingManager = temp.ReportingManagerName,
                    ImagePath = string.Format("{0}", (!string.IsNullOrEmpty(temp.ImagePath) ? (profileImagePath + temp.ImagePath) :
                           ((!string.IsNullOrEmpty(temp.Gender) ? temp.Gender.ToLower() : "") == "female" ? femaleImagePath : maleImagePath)))
                    //Location = string.IsNullOrEmpty(temp.Country) ? "Not available" : temp.Country + " (" + CryptoHelper.Decrypt(temp.City) + ")",
                });
            }
            return resultList;
        }

        public UserDetailType GetUserDetailsDashboard(string userAbrhs)
        {

            //string dob;
            //dob = CryptoHelper.Decrypt("tKz8XpUQqLQEqExR9mz1Ig==");
            //string dot;
            //dot = CryptoHelper.Decrypt("Lt0zwYXn1wokvbcdp3pF75e1mMl7eED4");
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            BO.UserDetailType userDetailType;

            var result = _dbContext.UserDetails.Where(a => a.UserId == userId && a.User.IsActive).FirstOrDefault();
            var manager = _dbContext.UserDetails.Where(a => a.UserId == result.ReportTo && a.User.IsActive).FirstOrDefault();
            var dob = CryptoHelper.Decrypt(result.DOB);
            if (result == null)
            {
                return null;
            }
            var userAddress = _dbContext.UserAddressDetails.Where(a => a.UserId == userId && a.IsActive && a.IsAddressPermanent).FirstOrDefault();

            userDetailType = new BO.UserDetailType
            {
                UserDetailId = result.UserDetailId,
                UserId = result.UserId,
                FirstName = result.FirstName,
                MobileNumber = CryptoHelper.Decrypt(result.MobileNumber),
                MiddleName = result.MiddleName,
                LastName = result.LastName,
                GenderId = result.GenderId,
                DOB = DateTime.ParseExact(dob.Replace("-", "/"), "MM/dd/yyyy", System.Globalization.CultureInfo.InvariantCulture),
                EmailId = CryptoHelper.Decrypt(result.EmailId),
                EmployeeId = result.EmployeeId,
                DesignationId = result.DesignationId,
                ImagePath = result.ImagePath,
                UserRoleId = result.User.RoleId,
                MaritalStatusId = result.MaritalStatusId,
                Designation = result.Designation.DesignationName,
                BloodGroup = CryptoHelper.Decrypt(result.BloodGroup),
                JoiningDate = result.JoiningDate,
                DisplayJoiningDate = result.JoiningDate.Value.ToString("dd-MMM-yyyy"),
                TerminationDate = result.TerminateDate,
                UserName = CryptoHelper.Decrypt(result.User.UserName),
                IsActive = result.User.IsActive,
                RoleName = result.User.Role.RoleName,
                Manager = manager != null ? manager.FirstName + " " + manager.LastName : "",
                UserLocation = result.User.Location.LocationName,
                WSNo = result.WorkStationNo,
                Extension = result.ExtensionNumber,
            };
            if (userAddress != null)
            {
                userDetailType.Address = (!string.IsNullOrEmpty(userAddress.Address) ? CryptoHelper.Decrypt(userAddress.Address) : "");
                userDetailType.StateId = userAddress.StateId;
                userDetailType.CountryId = userAddress.CountryId;
                userDetailType.City = ((userAddress.CityId > 0) ? CryptoHelper.Decrypt(userAddress.City.CityName) : "");
                userDetailType.State = userAddress.State.StateName;
                userDetailType.Country = userAddress.Country.CountryName;
                userDetailType.PinCode = (!string.IsNullOrEmpty(userAddress.PinCode) ? CryptoHelper.Decrypt(userAddress.PinCode) : "");
            }
            return userDetailType;
        }

        public AuthenticateUserBO GetData(string userAbrhs)
        {
            AuthenticateUserBO userBO = null;
            return userBO;
        }

        #region Dashboard
        public DashboardNotification DashboardNotification(string userAbrhs)
        {
            DashboardNotification result = new DashboardNotification();
            List<BirthDayUsers> bDayUsersList = new List<BirthDayUsers>();
            List<Holidays> Holidayslst = new List<Holidays>();

            var loginUserId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out loginUserId);

            DateTime currentISTTime = TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, TimeZoneInfo.FindSystemTimeZoneById("India Standard Time"));
            var holidayList = _dbContext.ListofHolidays.Where(f => f.DateId > 0).ToList().OrderBy(f => f.DateId);
            var activeUsers = (from a in _dbContext.UserDetails.Where(x => x.User.IsActive && x.UserId > 0 && x.IsDOBPublic)
                               join u in _dbContext.vwAllUsers on a.UserId equals u.UserId
                               where u.RoleId != (int)Enums.Roles.WebAdministrator
                               select new { a.FirstName, a.LastName, a.DOB, a.UserId, u.EmployeeName }).ToList();

            foreach (var data in holidayList)
            {
                var temp = _dbContext.DateMasters.FirstOrDefault(f => f.DateId == data.DateId);
                if (temp.Date.Year == currentISTTime.Year)
                {
                    var dataToAdd = new Holidays
                    {
                        UserName = "NA",
                        Holiday = data.Holiday,
                        Date = temp.Date,
                        Day = temp.Day,
                        DisplayDate = temp.Date.ToString("dd-MMM-yyyy")
                    };
                    Holidayslst.Add(dataToAdd);
                }
            }
            List<BirthDayUsers> bDayUsersListtemp = new List<BirthDayUsers>();
            foreach (var t in activeUsers)
            {
                var username = t.FirstName;
                var dob = t.DOB;
                try
                {
                    var date = CryptoHelper.Decrypt(t.DOB);
                    DateTime parsedDate;
                    var isParsed = DateTime.TryParse(date, out parsedDate); //Convert.ToDateTime(date);

                    if (isParsed && ((parsedDate.Month == currentISTTime.Month && parsedDate.Day >= currentISTTime.Day) || parsedDate.Month > currentISTTime.Month))
                    {
                        var sameYearDate = new DateTime(DateTime.Now.Year, Convert.ToDateTime(date).Month, Convert.ToDateTime(date).Day);
                        var data = new BirthDayUsers
                        {
                            EmpAbrhs = CryptoHelper.Encrypt(t.UserId.ToString()),
                            Name = t.EmployeeName,
                            DisplayDate = parsedDate.ToString("dd MMMM"),
                            Date = sameYearDate,
                        };
                        bDayUsersListtemp.Add(data);
                    }
                    if (!isParsed)
                    {
                        GlobalServices.LogError(new Exception("DOB is not valid for " + t.FirstName + " " + t.LastName), loginUserId, "");
                    }
                }
                catch (Exception ex)
                {
                    //GlobalServices.LogError(ex, loginUserId, "");
                }
            }
            var trimmedList = bDayUsersListtemp.OrderBy(x => x.Date).ThenBy(x => x.Name).Take(10);
            foreach (var t in trimmedList)
            {
                var user = new BirthDayUsers
                {
                    EmpAbrhs = t.EmpAbrhs,
                    UserName = t.Name,
                    Date = t.Date,
                    DisplayDate = t.DisplayDate,
                };
                bDayUsersList.Add(user);
            }
            result.BirthDayUsersList.AddRange(bDayUsersList);
            result.HolidaysList.AddRange(Holidayslst);
            return result;
        }

        //public DashboardAnniversary GetWorkAnniversary(string userAbrhs)
        //{
        //    DashboardAnniversary result = new DashboardAnniversary();
        //    List<UsersWorkAnniversary> anniversaryUsersList = new List<UsersWorkAnniversary>();
        //    DateTime currentISTTime = TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, TimeZoneInfo.FindSystemTimeZoneById("India Standard Time"));
        //    var activeUsers = (from a in _dbContext.UserDetails.Where(x => x.User.IsActive) select new { a.FirstName, a.LastName, a.JoiningDate, a.UserId }).ToList();

        //    List<UsersWorkAnniversary> anniversaryUsersListtemp = new List<UsersWorkAnniversary>();
        //    foreach (var t in activeUsers)
        //    {
        //        var date = t.JoiningDate;
        //        if ((Convert.ToDateTime(date).Month == currentISTTime.Month && Convert.ToDateTime(date).Day >= currentISTTime.Day) || Convert.ToDateTime(date).Month > currentISTTime.Month)
        //        {
        //            var sameYearDate = new DateTime(DateTime.Now.Year, Convert.ToDateTime(date).Month, Convert.ToDateTime(date).Day);
        //            var data = new UsersWorkAnniversary
        //            {
        //                EmpAbrhs = CryptoHelper.Encrypt(t.UserId.ToString()),
        //                Name = t.FirstName + " " + t.LastName,
        //                DisplayDate = date.Value.ToString("dd MMMM"),
        //                Date = sameYearDate,
        //            };
        //            anniversaryUsersListtemp.Add(data);
        //        }
        //    }
        //    var trimmedList = anniversaryUsersListtemp.OrderBy(x => x.Date).ThenBy(x => x.Name).Take(20);
        //    foreach (var t in trimmedList)
        //    {
        //        var user = new UsersWorkAnniversary
        //        {
        //            EmpAbrhs = t.EmpAbrhs,
        //            UserName = t.Name,
        //            Date = t.Date,
        //            DisplayDate = t.DisplayDate,
        //        };
        //        anniversaryUsersList.Add(user);
        //    }
        //    result.DashboardAnniversaryList.AddRange(anniversaryUsersList);
        //    return result;
        //}

        public List<UsersWorkAnniversary> GetWorkAnniversary(string userAbrhs)
        {
            var result = new List<UsersWorkAnniversary>();
            var users = _dbContext.spGetEmployesForWorkAnniversary(20).ToList();
            foreach (var item in users)
            {
                var date = item.JoiningDate;
                var sameYearDate = new DateTime(DateTime.Now.Year, Convert.ToDateTime(date).Month, Convert.ToDateTime(date).Day);
                result.Add(new UsersWorkAnniversary
                {
                    EmpAbrhs = CryptoHelper.Encrypt(item.UserId.ToString()),
                    Name = item.EmployeeName,
                    DisplayDate = date.Value.ToString("dd MMMM"),
                    Date = sameYearDate,
                });
            }
            return result.OrderBy(x => x.Date).ThenBy(x => x.Name).ToList();
        }

        public DataForLeaveBalance ListLeaveBalanceByUserId(string userAbrhs)
        {
            BO.DataForLeaveBalance balance = new BO.DataForLeaveBalance();
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            balance.UserId = userId;
            var userData = _dbContext.UserDetails.FirstOrDefault(s => s.UserId == userId); //to get marital status
            var vwData = _dbContext.vwActiveUsers.FirstOrDefault(v => v.UserId == userId);
            balance.Code = "UNMARRIED";
            if (userData.MaritalStatusId == 2)
            {
                balance.Code = userData.GenderId == 2 ? GenderCode.Female : GenderCode.Male;
            }
            if (vwData != null && vwData.Designation == DesignationDetails.TechnicalTrainee)
            {
                balance.Code = "EL";
            }
            var data = _dbContext.spGetLeaveBalanceForUser(userId).ToList();
            if (data.Any())
            {
                foreach (var d in data)
                {
                    switch (d.LeaveType)
                    {
                        case "CL":
                            balance.ClCount = Convert.ToDouble(d.LeaveCount);
                            break;
                        case "PL":
                            balance.PlCount = Convert.ToDouble(d.LeaveCount);
                            break;
                        case "EL":
                            balance.ElCount = Convert.ToDouble(d.LeaveCount);
                            break;
                        case "ML":
                            balance.MLCount = Convert.ToInt32(d.LeaveCount);
                            break;
                        case "PL(M)":
                            balance.PLMCount = Convert.ToInt32(d.LeaveCount);
                            break;
                        case "OLDPL":
                            balance.OldPlCount = Convert.ToDouble(d.LeaveCount);
                            break;
                        case "NEWPL":
                            balance.NewPlCount = Convert.ToDouble(d.LeaveCount);
                            break;
                        case "COFF":
                            balance.CompOffCount = Convert.ToDouble(d.LeaveCount);
                            break;
                        case "WFH":
                            balance.WfhCount = Convert.ToDouble(d.LeaveCount);
                            break;
                        case "LNSA":
                            balance.LnsaCount = Convert.ToDouble(d.LeaveCount);
                            break;
                        case "LWP":
                            balance.LwpCount = Convert.ToDouble(d.LeaveCount);
                            break;
                        case "5CLOY":
                            balance.CloyAvailable = (d.LeaveCount == 1 ? "Available" : "Availed");
                            break;
                    }
                }
            }
            else
            {
                balance.ClCount = 0;
                balance.CloyAvailable = "NA";
                balance.CompOffCount = 0;
                balance.LwpCount = 0;
                balance.PlCount = 0;
                balance.OldPlCount = 0;
                balance.NewPlCount = 0;
                balance.MLCount = 0;
                balance.PLMCount = 0;
                balance.ElCount = 0;
            }

            if (_dbContext.EmployeeProfiles.FirstOrDefault(f => f.UserId == userId) == null)
                balance.IsBioPageFilled = false;
            else
                balance.IsBioPageFilled = true;

            return balance;
        }

        public EmployeeStatusDataForManager FetchEmployeeAttendanceForToday(string userAbrhs)
        {
            try
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                var data = _dbContext.spGetAttendanceForTodayAndTommorrowByUserId(userId, DateTime.Now).FirstOrDefault();

                BO.EmployeeStatusDataForManager result = new EmployeeStatusDataForManager()
                {
                    InTime = data.TodayInTime.HasValue ? data.TodayInTime.Value.ToString("HH:mm") : "N.A.",
                    OutTime = data.TodayOutTime.HasValue ? data.TodayOutTime.Value.ToString("HH:mm") : "N.A.",
                    WorkingHours = data.TodayLoggedHours.HasValue ? data.TodayLoggedHours.Value.ToString("HH:mm") : "N.A.",
                    YesterdayWorkingHours = data.YesterdayLoggedHours.HasValue ? data.YesterdayLoggedHours.Value.ToString("HH:mm") : "N.A."
                };

                return result;
            }
            catch (Exception)
            {
                return new EmployeeStatusDataForManager();
            }
        }

        public EmployeeStatusDataForManager FetchEmployeeAttendanceDateWise(string userAbrhs, string forDate)
        {
            try
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                var date = DateTime.ParseExact(forDate, "yyyy-MM-dd", CultureInfo.InvariantCulture);
                var data = _dbContext.spGetAttendanceForTodayAndTommorrowByUserId(userId, date).FirstOrDefault();

                BO.EmployeeStatusDataForManager result = new EmployeeStatusDataForManager()
                {
                    InTime = data.TodayInTime.HasValue ? data.TodayInTime.Value.ToString("HH:mm") : "N.A.",
                    OutTime = data.TodayOutTime.HasValue ? data.TodayOutTime.Value.ToString("HH:mm") : "N.A.",
                    WorkingHours = data.TodayLoggedHours.HasValue ? data.TodayLoggedHours.Value.ToString("HH:mm") : "N.A.",
                    YesterdayWorkingHours = data.YesterdayLoggedHours.HasValue ? data.YesterdayLoggedHours.Value.ToString("HH:mm") : "N.A."
                };

                return result;
            }
            catch (Exception)
            {
                return new EmployeeStatusDataForManager();
            }
        }

        public List<MealOfTheDayBO> GetMealOfTheDay(string userAbrhs)
        {
            List<MealOfTheDayBO> mealOfTheDayList = new List<MealOfTheDayBO>();
            var TodayDate = DateTime.Today.Date;
            TimeSpan start = new TimeSpan(10, 0, 0); //10 o'clock
            TimeSpan now = DateTime.Now.TimeOfDay;
            if (now > start)
            {
                var mealPackages = _dbContext.MealPackageDetails.Where(x => x.MealDate == TodayDate && x.IsActive).Select(x => new
                {
                    MealPackageId = x.MealPackageId,
                    MealPackageName = x.MealPackage.MealPackageName,
                    MealPeriodId = x.MealPackage.MealPeriodId,
                }).GroupBy(item => new { MealPackageId = item.MealPackageId, MealPackageName = item.MealPackageName, MealPeriodId = item.MealPeriodId }).Select(group => new
                {
                    MealPackageId = group.Key.MealPackageId,
                    MealPackageName = group.Key.MealPackageName,
                    MealPeriodId = group.Key.MealPeriodId,
                });

                if (mealPackages.Any())
                {
                    foreach (var item in mealPackages)
                    {
                        MealOfTheDayBO mealOfTheDay = new MealOfTheDayBO();
                        mealOfTheDay.MealPackage = item.MealPackageName;
                        mealOfTheDay.MealPackagesId = item.MealPackageId;
                        mealOfTheDay.DishMenuList = _dbContext.MealPackageDetails.Where(x => x.MealDate == TodayDate && x.IsActive && x.MealPackageId == item.MealPackageId).Select(x => new DishMenuDashBoard
                        {
                            DishId = x.MealDishesId,
                            DishName = x.MealDish.MealDishesName,
                            MenuName = x.MealItemName,
                        }).OrderBy(x => x.DishId).ToList();
                        mealOfTheDayList.Add(mealOfTheDay);
                    }
                }
            }
            else
            {
                var mealPackages = _dbContext.MealPackageDetails.Where(x => x.MealDate == TodayDate && x.IsActive).Select(x => new
                {
                    MealPackageId = x.MealPackageId,
                    MealPackageName = x.MealPackage.MealPackageName,
                    MealPeriodId = x.MealPackage.MealPeriodId,
                }).GroupBy(item => new { MealPackageId = item.MealPackageId, MealPackageName = item.MealPackageName, MealPeriodId = item.MealPeriodId }).Select(group => new
                {
                    MealPackageId = group.Key.MealPackageId,
                    MealPackageName = group.Key.MealPackageName,
                    MealPeriodId = group.Key.MealPeriodId,
                }).OrderByDescending(item => item.MealPeriodId);

                if (mealPackages.Any())
                {
                    foreach (var item in mealPackages)
                    {
                        MealOfTheDayBO mealOfTheDay = new MealOfTheDayBO();
                        mealOfTheDay.MealPackage = item.MealPackageName;
                        mealOfTheDay.MealPackagesId = item.MealPackageId;
                        mealOfTheDay.DishMenuList = _dbContext.MealPackageDetails.Where(x => x.MealDate == TodayDate && x.IsActive && x.MealPackageId == item.MealPackageId).Select(x => new DishMenuDashBoard
                        {
                            DishId = x.MealDishesId,
                            DishName = x.MealDish.MealDishesName,
                            MenuName = x.MealItemName,
                        }).OrderBy(x => x.DishId).ToList();
                        mealOfTheDayList.Add(mealOfTheDay);
                    }

                }
            }
            return mealOfTheDayList;
        }

        public List<TeamMemberLeaveBO> GetTeamLeaves(string userAbrhs)
        {
            List<TeamMemberLeaveBO> TeamMemberLeaveBOList = new List<TeamMemberLeaveBO>();
            try
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                TeamMemberLeaveBOList = _dbContext.Proc_GetTeamLeaves(userId).Select(x => new TeamMemberLeaveBO
                {
                    EmployeeName = x.UserName,
                    DateFrom = x.DateFrom.ToString("dd-MMM-yyyy"),
                    DateTo = x.DateTo.ToString("dd-MMM-yyyy"),
                    TypeOfLeave = x.LeaveType,
                }).ToList();
                return TeamMemberLeaveBOList;
            }
            catch (Exception)
            {
                return TeamMemberLeaveBOList;
            }
        }

        public List<NewsScrollerBO> GetNewsForSlider(string userAbrhs)
        {
            var newsScrollerBOList = new List<NewsScrollerBO>();
            int userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var newsData = _dbContext.News.Where(x => x.IsActive && !x.IsDeleted && x.TillDate >= DateTime.Now).ToList();
            if (newsData.Any())
            {
                foreach (var item in newsData)
                {
                    var newsBO = new NewsScrollerBO();
                    newsBO.NewsTitle = item.NewsTitle;
                    newsBO.IsInternal = item.IsInternal;
                    newsBO.NewsDescription = item.NewsDescription;

                    if (!String.IsNullOrEmpty(item.Link))
                    {
                        if (item.IsInternal == true)
                        {
                            var menuId = Convert.ToInt32(item.Link);
                            var controllerDetail = _dbContext.Menus.FirstOrDefault(x => x.MenuId == menuId);
                            if (controllerDetail != null)
                                newsBO.NewsLink = controllerDetail.ControllerName + "/" + controllerDetail.ActionName;
                        }
                        else
                            newsBO.NewsLink = item.Link;
                    }
                    else
                    {
                        newsBO.NewsLink = string.Empty;
                    }

                    newsScrollerBOList.Add(newsBO);
                }
            }
            return newsScrollerBOList;
        }

        public List<DataForAttendance> FetchEmployeeAttendance(string userAbrhs, int year, int month)
        {
            var list = new List<DataForAttendance>();
            try
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

                DateTime startDate = new DateTime(year, month, 1);
                DateTime endDate = startDate.AddMonths(1).AddDays(-1);
                DateTime todayDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day);
                if (endDate.Date.CompareTo(todayDate.Date) > 0)
                {
                    endDate = todayDate;
                }
                var data = _dbContext.spGetAttendanceForUserOnDashboard(userId, startDate, endDate).ToList();
                foreach (var d in data)
                {
                    var o = new DataForAttendance
                    {
                        DisplayDate = d.Date,//("MM'/'dd'/'yyyy"),
                        InTime = d.InTime != null ? d.InTime : "N.A.",
                        OutTime = d.OutTime != null ? d.OutTime : "N.A.",
                        WorkingHours = d.LoggedInHours != null ? d.LoggedInHours : "N.A.",
                        IsApproved = d.IsApproved.HasValue ? d.IsApproved.Value : false,
                        IsNightShift = d.IsNightShift.HasValue ? d.IsNightShift.Value : false,
                        IsPending = d.IsPending.HasValue ? d.IsPending.Value : false,
                        IsWeekend = d.IsWeekend
                    };
                    list.Add(o);
                }
                return (list.Count == 0 ? null : list.OrderByDescending(r => r.DisplayDate).ToList());
            }
            catch (Exception)
            {
                return list;
            }
        }

        public List<EmployeeStatusDataForManager> FetchEmployeeStatusForManager(string userAbrhs)
        {
            List<BO.EmployeeStatusDataForManager> list = new List<BO.EmployeeStatusDataForManager>();

            try
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                DateTime date = DateTime.Now;
                var today = Convert.ToDateTime(date); // var firstDayOfMonth = new DateTime(date.Year, date.Month, 1);
                var data = _dbContext.spGetManagerResourceStatusByDate(userId, today).ToList();

                foreach (var temp in data)
                {
                    BO.EmployeeStatusDataForManager test = new BO.EmployeeStatusDataForManager()
                    {
                        Name = temp.Username,
                        Reason = temp.Reason,
                        Status = temp.Status,
                        InTime = temp.InTime != null ? temp.InTime.Value.ToString("dd-MMM-yyyy hh:mm tt") : "N.A.",
                        OutTime = temp.OutTime != null ? temp.OutTime.Value.ToString("dd-MMM-yyyy hh:mm tt") : "N.A.",
                        WorkingHours = temp.WorkingHours != null ? temp.WorkingHours.Value.ToString("HH:mm") : "N.A."
                    };
                    list.Add(test);
                }
                return (list.Count == 0 ? null : list.OrderBy(r => r.Name).ToList());
            }
            catch (Exception ex)
            {
                return list;
            }
        }
        #endregion

        #region User Management

        /// <summary>
        /// Method to get locked users list
        /// </summary>
        /// <param name="userAbrhs">UserAbrhs</param>
        /// <returns></returns>
        public List<LockedUserDetailBO> GetLockedUsersList(string userAbrhs)
        {
            List<LockedUserDetailBO> ListOfLockedUsers = null;
            var data = _dbContext.vwListLockedUsers.ToList();

            if (data.Any())
            {
                ListOfLockedUsers = data.Select(x => new LockedUserDetailBO
                {
                    UserName = x.FirstName + " " + x.LastName,
                    EmployeeAbrhs = CryptoHelper.Encrypt(x.UserId.ToString()),
                }).ToList();
            }
            return ListOfLockedUsers ?? new List<LockedUserDetailBO>();
        }

        /// <summary>
        /// Method to get logged-in users log history
        /// </summary>
        /// <param name="userAbrhs">UserAbrhs</param>
        /// <param name="employeeAbrhs">EmployeeAbrhs</param>
        /// <param name="fromDate">FromDate</param>
        /// <param name="toDate">ToDate</param>
        /// <returns>UserActivityLogBO List</returns>
        public List<UserActivityLogBO> GetUserActivityLogs(string userAbrhs, string employeeAbrhs, DateTime fromDate, DateTime toDate)
        {
            var today = DateTime.Now;

            List<UserActivityLogBO> activityLogs = null;
            var data = _dbContext.UserActivityLogs.AsQueryable();

            if (!string.IsNullOrEmpty(employeeAbrhs))
            {
                var employeeId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(employeeAbrhs), out employeeId);
                data = data.Where(x => x.UserId == employeeId);
            }
            data = data.Where(x => DbFunctions.TruncateTime(x.LoginTime) >= fromDate.Date && DbFunctions.TruncateTime(x.LoginTime) <= toDate.Date);

            if (data.Any())
            {
                activityLogs = data.Select(x => new UserActivityLogBO
                {
                    UserActivityLogId = x.UserActivityLogId,
                    EmployeeAbrhs = x.UserId.ToString(),//CryptoHelper.Encrypt(x.UserId.ToString()),
                    UserName = x.UserName,
                    IPAddress = x.IPAddress,
                    BrowserInfo = x.BrowserInfo,
                    ActivityStatus = x.ActivityStatus,
                    ActivityDetail = x.ActivityDetail,
                    LoginTime = x.LoginTime,
                    LogoutTime = x.LogoutTime,
                    ClientInfo = x.ClientInfo,
                    Device = x.Device,
                    Latitude = x.Latitude,
                    Longitude = x.Longitude,
                    TimeZone = x.TimeZone,
                    City = x.City,
                    Country = x.Country,
                    ISP = x.ISP
                }).OrderByDescending(t => t.LoginTime).ToList();

                activityLogs.ForEach(x =>
                {
                    x.EmployeeAbrhs = CryptoHelper.Encrypt(x.EmployeeAbrhs);
                });
            }
            return activityLogs ?? new List<UserActivityLogBO>();
        }

        /// <summary>
        /// Method to unlock user account
        /// </summary>
        /// <param name="userAbrhs">Login UserAbrhs</param>
        /// <param name="employeeAbrhs">Employee's UserAbrhs</param>
        /// <returns>True/False</returns>
        public bool UnlockUser(string userAbrhs, string employeeAbrhs)
        {
            var loginUserId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out loginUserId);

            var employeeUserId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(employeeAbrhs), out employeeUserId);

            var userToUnlock = _dbContext.Users.FirstOrDefault(f => f.UserId == employeeUserId);
            if (userToUnlock != null)
            {
                userToUnlock.IsLocked = false;
                userToUnlock.UnsuccessfulLoginAttempt = 0;
                userToUnlock.UnlockedBy = loginUserId;
                userToUnlock.LastModifiedBy = loginUserId;
                userToUnlock.LastModifiedDate = DateTime.Now;

                _dbContext.SaveChanges();

                // Logging
                SaveUserLogs(ActivityMessages.ViewingProfile, loginUserId, employeeUserId);

                return true;
            }
            return false;
        }

        public List<UserManagementDetailBO> GetAllEmployeesByStatus(int status)
        {
            var data = _dbContext.spFetchAllEmployeesByStatus(status).ToList();
            if (data.Any())
            {
                var result = new List<UserManagementDetailBO>();
                foreach (var temp in data)
                {
                    result.Add(new UserManagementDetailBO
                    {
                        EmployeeAbrhs = CryptoHelper.Encrypt(temp.UserId.ToString()),
                        Name = temp.Name,
                        EmployeeId = temp.EmployeeId,
                        EmailId = CryptoHelper.Decrypt(temp.EmailId),
                        DOJ = temp.JoiningDate.HasValue ? temp.JoiningDate.Value.ToString("dd/MM/yyyy", CultureInfo.InvariantCulture) : ""
                    });
                }
                return result;
            }
            return null;
        }

        public bool ChangeUserStatus(string employeeAbrhs, int status, DateTime terminationDate, string userAbrhs)
        {
            var employeeId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(employeeAbrhs), out employeeId);

            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var result = _dbContext.spChangeUserStatus(employeeId, status, terminationDate, userId).FirstOrDefault();

            var leaveBalanceData = _dbContext.Proc_GetUsersLeaveBalanceForFnF(employeeId, terminationDate, 2).ToList();

            var employeeData = _dbContext.vwAllUsers.FirstOrDefault(t => t.UserId == employeeId);
            var loginUserData = _dbContext.vwAllUsers.FirstOrDefault(t => t.UserId == userId);

            var leavingDate = terminationDate.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture);

            var leaveBalanceSummaryData = _dbContext.Proc_GetUsersLeaveBalanceForFnF(employeeId, terminationDate, 1).ToList();
            var leaveBalanceSummaryDataTable = leaveBalanceSummaryData.ToDataTable();

            DataTable dataResult = leaveBalanceData.ToDataTable();
            DataTable coff = new DataTable();
            DataTable lnsa = new DataTable();
            DataTable lwp = new DataTable();
            List<LeaveBalanceSummay> otherLeavesType = new List<LeaveBalanceSummay>();

            foreach (DataRow row in dataResult.Rows)
            {
                var leaveType = row.ItemArray[0].ToString();
                if (leaveType == "COFF")
                {
                    var parsedCoffJson = JsonConvert.DeserializeObject<List<balanceCOFFBO>>(row.ItemArray[1].ToString());
                    coff = parsedCoffJson.ToDataTable();
                }
                else if (leaveType == "LNSA")
                {
                    var parsedLnsaJson = JsonConvert.DeserializeObject<List<balanceLNSABO>>(row.ItemArray[1].ToString());
                    lnsa = parsedLnsaJson.ToDataTable();
                }
                else if (leaveType == "LWP")
                {
                    var parsedLwpJson = JsonConvert.DeserializeObject<List<balanceLWPBO>>(row.ItemArray[1].ToString());
                    lwp = parsedLwpJson.ToDataTable();
                }
                else
                {
                    var obj = new LeaveBalanceSummay
                    {
                        LeaveType = leaveType,
                        Count = row.ItemArray[1].ToString()
                    };

                    otherLeavesType.Add(obj);
                }

            }

            var htmlNewResult = "";
            if (leaveBalanceSummaryDataTable.Rows.Count > 0)
            {
                var coumns = new Dictionary<string, string>();
                coumns.Add("LeaveTypes", "Leave Type");
                coumns.Add("Summary", "Summary");
                var multipleTable = new Dictionary<string, DataTable>();
                multipleTable.Add("Leave Balance Summary", leaveBalanceSummaryDataTable);
                htmlNewResult = multipleTable.ToHtmlTableWithHeader(coumns);
            }

            if (coff.Rows.Count > 0)
            {
                var coumns = new Dictionary<string, string>();
                coumns.Add("Quarter", "Quarter");
                coumns.Add("FromDate", "From Date");
                coumns.Add("TillDate", "Till Date");
                coumns.Add("Pending", "Pending");
                coumns.Add("PendingDates", "Pending Dates");
                coumns.Add("Lapsed", "Lapsed");
                coumns.Add("LapsedDates", "Lapsed Dates");
                coumns.Add("Approved", "Approved");
                coumns.Add("ApprovedDates", "Approved Dates");
                coumns.Add("Available", "Available");
                coumns.Add("AvailableDates", "Available Dates");

                var multipleTable = new Dictionary<string, DataTable>();
                multipleTable.Add("COFF", coff);
                var resultData = multipleTable.ToHtmlTableWithHeader(coumns);

                htmlNewResult = htmlNewResult + "<br />" + resultData;

            }
            if (lnsa.Rows.Count > 0)
            {
                var coumns = new Dictionary<string, string>();
                coumns.Add("Quarter", "Quarter");
                coumns.Add("FromDate", "From Date");
                coumns.Add("TillDate", "Till Date");
                coumns.Add("Pending", "Pending");
                coumns.Add("PendingDates", "Pending Dates");
                coumns.Add("Approved", "Approved");
                coumns.Add("ApprovedDates", "Approved Dates");

                var multipleTable = new Dictionary<string, DataTable>();
                multipleTable.Add("LNSA", lnsa);
                var resultData = multipleTable.ToHtmlTableWithHeader(coumns);
                htmlNewResult = htmlNewResult + "<br />" + resultData;

            }
            if (lwp.Rows.Count > 0)
            {
                var coumns = new Dictionary<string, string>();
                coumns.Add("Month", "Month");
                coumns.Add("FromDate", "From Date");
                coumns.Add("TillDate", "Till Date   ");
                coumns.Add("Count", "Count");
                coumns.Add("Dates", "Dates");

                var multipleTable = new Dictionary<string, DataTable>();
                multipleTable.Add("LWP", lwp);
                var resultData = multipleTable.ToHtmlTableWithHeader(coumns);
                htmlNewResult = htmlNewResult + "<br />" + resultData;

            }
            var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(t => t.TemplateName == "LWP Report" && t.IsActive == true);
            var line1 = string.Format("Please note that the Employee Name: <b>{0}</b> with Employee Code: <b>{1}</b> has been deactivated from MIS as a part of the exit formality.The Last Working day was: <b>{2}</b>", employeeData.EmployeeName, employeeData.EmployeeCode, leavingDate);
            if (emailTemplate != null && loginUserData != null && employeeData != null)
            {
                var name = char.ToUpper(loginUserData.EmployeeFirstName[0]) + loginUserData.EmployeeFirstName.Substring(1);
                var toEmailId = ConfigurationManager.AppSettings["HrEmailId"];
                var ccEmailId = CryptoHelper.Decrypt(loginUserData.EmailId);
                var body = emailTemplate.Template.Replace("[Title]", "Details of FNF for " + employeeData.EmployeeName)
                    .Replace("[Name]", name)
                    .Replace("[Line1]", line1 + "<br/><br/>" + "Below is the leave summary:")
                    .Replace("[Data]", htmlNewResult);

                EmailHelper.SendEmailWithDefaultParameter("Full and Final Statement Summary", body, true, true, ccEmailId, toEmailId, null, null);
            }

            //assets email
            var assetEmailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "Assets Notification Mail" && f.IsActive && !f.IsDeleted);
            var activeAssets = _dbContext.Proc_GetUsersActiveAssets(employeeId).ToList();
            var particulars = "";
            if (activeAssets.Count > 0 && assetEmailTemplate != null)
            {
                var recivermailId = ConfigurationManager.AppSettings["PendingAsset"];

                var tableHtml = "<table style = 'border-collapse:collapse; width:100%; border: 1px solid #c5c4c4; padding: 8px;'><thead style = 'padding-top: 12px; padding-bottom: 12px;text-align: left;background-color: #d8e2e7; color: black;'><tr><th style = 'border: 1px solid #c5c4c4; padding: 8px;'><div>Particulars</div></th><th style = 'border: 1px solid #c5c4c4; padding: 8px;'><div>Assets</div></th><th style = 'border: 1px solid #c5c4c4; padding: 8px;'><div>Make</div></th><th style = 'border: 1px solid #c5c4c4; padding: 8px;'><div>Model</div></th><th style = 'border: 1px solid #c5c4c4; padding: 8px;'><div>S.No</div></th><th style = 'border: 1px solid #c5c4c4; padding: 8px;'><div>Status</div></th></tr></thead><tbody>";
                var temp = "";
                foreach (var asset in activeAssets)
                {
                    if (asset.Type == "Mobile")
                        particulars = "Admin Team";
                    else
                        particulars = "IT Team";

                    temp = temp + string.Format("<tr><td style = 'border: 1px solid #c5c4c4; padding: 8px;'>{0}</td><td style = 'border: 1px solid #c5c4c4; padding: 8px;'>{1}</td><td style = 'border: 1px solid #c5c4c4; padding: 8px;'>{2}</td><td style = 'border: 1px solid #c5c4c4; padding: 8px;'>{3}</td><td style = 'border: 1px solid #c5c4c4; padding: 8px;'>{4}</td><td style = 'border: 1px solid #c5c4c4; padding: 8px;'>{5}</td>", particulars, asset.Type, asset.BrandName, asset.Model, asset.SerialNo,"Pending");
                }

                tableHtml = tableHtml + temp;
                tableHtml = tableHtml + "</tbody></table>";

                var subject = "Pending Asset Summary";
                var body = assetEmailTemplate.Template
                 .Replace("[BGColor]", "#d8e2e7")
                 .Replace("[TextColor]", "#000000")
                 .Replace("[Title]", subject)
                 .Replace("[Name]", "Hi Team")
                 .Replace("[Line1]", line1 + "<br/><br/>" + "Below is a summary of the assets which are pending on the employee:")
                 .Replace("[Data]", tableHtml);
                EmailHelper.SendEmailWithDefaultParameter(subject, body, true, true, recivermailId, null, null, null);
            }

            // Logging
            SaveUserLogs(ActivityMessages.PromoteUsers, userId, employeeId);

            return result.Value;
        }

        #region Mail Content

        #endregion

        public List<FullnFinalDataBO> FetchUserLeaveBalanceDetail(string dol, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            DateTime fromDateNew = DateTime.ParseExact(dol, "dd/MM/yyyy", CultureInfo.InvariantCulture);
            var data = _dbContext.Proc_GetUsersLeaveBalanceForFnF(userId, fromDateNew, 1).ToList();
            if (data != null)
            {
                var response = data.Select(t => new FullnFinalDataBO
                {
                    LeaveTypes = t.LeaveTypes,
                    Summary = t.Summary != null ? t.Summary : ""
                }).ToList();
                return response;
            }
            else
                return new List<FullnFinalDataBO>();
        }

        //F&F
        public LeaveBalanceForFnF GetUserLeaveDetailForFnF(string userAbrhs, string fromDate, string tillDate)
        {
            int userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var reqUrl = HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + "/";
#if !DEBUG
            reqUrl = (new UriBuilder(reqUrl) { Port = -1 }).ToString();
#endif
            var baseImagePath = reqUrl + ConfigurationManager.AppSettings["ImagePath"];

            DateTime fromDateNew = DateTime.ParseExact(fromDate, "dd/MM/yyyy", CultureInfo.InvariantCulture);
            DateTime tillDateNew = DateTime.ParseExact(tillDate, "dd/MM/yyyy", CultureInfo.InvariantCulture);
            var data = _dbContext.Proc_GetLeaveHistoryForFullNFinal(userId, fromDateNew, tillDateNew, baseImagePath).FirstOrDefault();
            if (data != null)
            {
                var response = new LeaveBalanceForFnF
                {
                    Summary = data.Summary,
                    Detail = data.Detail
                };
                return response;
            }
            else
                return new LeaveBalanceForFnF();
        }


        // Promote Users
        public List<UserManagementDetailBO> GetAllEmployees()
        {
            var data = _dbContext.Proc_DetailsOfActiveEmployees().ToList();
            var result = new List<UserManagementDetailBO>();
            if (data.Any())
            {

                foreach (var temp in data)
                {
                    result.Add(new UserManagementDetailBO
                    {
                        EmployeeAbrhs = CryptoHelper.Encrypt(temp.UserId.ToString()),
                        Name = temp.EmployeeName,
                        EmployeeId = temp.EmployeeId,
                        DesignationGrpAbrhs = CryptoHelper.Encrypt(temp.DesignationGroupId.ToString()),
                        Manager = temp.ManagerName,
                        Designation = temp.DesignationName,
                        Team = temp.TeamName,
                        Department = temp.DepartmentName,
                        JoiningDate = Convert.ToDateTime(temp.JoiningDate),
                        IsIntern = temp.IsIntern
                    });
                }
                return result;
            }
            return result;
        }
        public int PromoteUsers(string employeeAbrhs, int newDesignationId, DateTime promotionDate, string newEmpCode, string userAbrhs)
        {
            //var newDesignation = _dbContext.Designations.FirstOrDefault(x => x.DesignationId == newDesignationId).DesignationName;
            var employeeId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(employeeAbrhs), out employeeId);
            var status = 0;
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var result = new ObjectParameter("Success", typeof(int));
            _dbContext.Proc_PromoteUsers(employeeId, newDesignationId, promotionDate, newEmpCode, userId, result);
            Int32.TryParse(result.Value.ToString(), out status);
            // Logging
            SaveUserLogs(ActivityMessages.PromoteUsers, userId, employeeId);

            return status;
        }
        public List<UserManagementDetailBO> GetPromotionHistory()
        {
            var data = _dbContext.UserPromotionHistories.ToList();
            var result = new List<UserManagementDetailBO>();
            if (data.Any())
            {

                foreach (var temp in data)
                {
                    result.Add(new UserManagementDetailBO
                    {
                        Name = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == temp.UserId).FirstName + ' ' + _dbContext.UserDetails.FirstOrDefault(x => x.UserId == temp.UserId).MiddleName + ' ' + _dbContext.UserDetails.FirstOrDefault(x => x.UserId == temp.UserId).LastName,
                        OldEmployeeId = temp.OldEmployeeCode,
                        NewEmployeeId = temp.NewEmployeeCode,
                        OldDesignation = _dbContext.Designations.FirstOrDefault(x => x.DesignationId == temp.OldDesignationId).DesignationName,
                        NewDesignation = _dbContext.Designations.FirstOrDefault(x => x.DesignationId == temp.NewDesignationId).DesignationName,
                        PromotionDate = Convert.ToDateTime(temp.PromotionDate),
                        CreatedByName = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == temp.CreatedBy).FirstName + ' ' + _dbContext.UserDetails.FirstOrDefault(x => x.UserId == temp.CreatedBy).MiddleName + ' ' + _dbContext.UserDetails.FirstOrDefault(x => x.UserId == temp.CreatedBy).LastName,
                        CreatedDate = temp.CreatedDate
                    });
                }
                return result;
            }
            return result;
        }

        /// <summary>
        /// Status = 1: link expired and user has not submitted, 2: pending for submission with user, 3: pending for verification with HR
        /// </summary>
        /// <returns></returns>
        public List<UserRegistationDataBO> GetAllUserRegistrations()
        {
            var data = _dbContext.spGetAllUserRegistrations().ToList();
            if (data.Any())
            {
                var result = new List<UserRegistationDataBO>();
                foreach (var temp in data)
                {
                    result.Add(new UserRegistationDataBO
                    {
                        RegistrationId = temp.RegistrationId,
                        EmailId = temp.EmailId,
                        Status = temp.IsSubmitted == true ? 3 : (temp.GuidExpiryDate < DateTime.Now ? 1 : 2),
                        ADUserName = temp.ADUserName,
                        CreatedBy = temp.EmployeeName,
                        CreatedOn = temp.CreatedOn
                    });
                }
                return result;
            }
            return null;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="registrationId"></param>
        /// <param name="status">1: Regenerate, 2: Deactivate</param>
        /// <param name="userAbrhs"></param>
        /// <param name="redirectionLink"></param>
        /// <returns></returns>
        public bool ChangeRegLinkStatus(int registrationId, int status, string userAbrhs, string redirectionLink)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var result = _dbContext.spChangeRegLinkStatus(registrationId, status, userId).FirstOrDefault();

            // Logging
            SaveUserLogs(ActivityMessages.ChangeRegLinkStatus, userId, 0);

            // For regenerate, send email
            if (status == 1)
            {
                var existingUserData = _dbContext.TempUserRegistrations.FirstOrDefault(x => x.RegistrationId == registrationId);
                var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == EmailTemplates.UserRegistrationNotification && f.IsActive && !f.IsDeleted);

                if (emailTemplate != null && existingUserData != null)
                {
                    var firstName = existingUserData.UserName.Split('.')[0];
                    var link = redirectionLink + existingUserData.TempUserGuid;
                    var body = emailTemplate.Template
                        .Replace("[NAME]", firstName.ToTitleCase())
                        .Replace("[LINK]", link)
                        .Replace("[HEADING]", "User Registration - Reminder");
                    EmailHelper.SendEmailWithDefaultParameter("Link for user registration", body, true, true, existingUserData.EmailId, null, null, null);
                }
            }

            _dbContext.SaveChanges();
            return result.Value;
        }

        public UserDetailBO GetUserRegistrationDataById(long registrationId)
        {

            var tempUserData = _dbContext.TempUserRegistrations.FirstOrDefault(x => x.RegistrationId == registrationId && x.IsActive == true);
            var reqUrl = HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + "/";
#if !DEBUG
               reqUrl = (new UriBuilder(reqUrl) { Port = -1 }).ToString();
#endif
            var finalBasePath = reqUrl + ConfigurationManager.AppSettings["TempProfileImageUploadPath"].Replace("\\", "/") + tempUserData.PhotoFileName;

            if (tempUserData != null)
            {
                var personalDetail = new UserPersonalDetailBO
                {
                    UserName = tempUserData.UserName,
                    OfficialEmailId = tempUserData.EmailId,
                    PersonalEmailId = tempUserData.PersonalEmailId,
                    FirstName = tempUserData.FirstName,
                    MiddleName = tempUserData.MiddleName,
                    LastName = tempUserData.LastName,
                    MobileNumber = tempUserData.MobileNumber,
                    EmergencyContactNumber = tempUserData.EmergencyContactNumber,
                    DOB = tempUserData.DOB.Value.ToString("MM/dd/yyyy", CultureInfo.InvariantCulture),
                    BloodGroup = tempUserData.BloodGroup,
                    GenderId = tempUserData.GenderId,
                    Gender = _dbContext.Genders.FirstOrDefault(x => x.GenderId == tempUserData.GenderId).GenderType,
                    MaritalStatusId = tempUserData.MaritalStatusId,
                    MaritalStatus = _dbContext.MaritalStatus.FirstOrDefault(x => x.MaritalStatusId == tempUserData.MaritalStatusId).MaritalStatusType,
                    IsFresher = tempUserData.IsFresher,
                    LastEmployerName = tempUserData.LastEmployerName,
                    LastEmployerLocation = tempUserData.LastEmployerLocation,
                    LastJobDesignation = tempUserData.LastJobDesignation,
                    LastJobTenure = tempUserData.LastJobTenure,
                    LastJobUAN = tempUserData.LastJobUAN,
                    JobLeavingReason = tempUserData.JobLeavingReason,
                    PanNo = tempUserData.PanCardId,
                    AadhaarNo = tempUserData.AadhaarCardId,
                    PassportNo = tempUserData.PassportId,
                    DLNo = tempUserData.DrivingLicenseId,
                    VoterIdNo = tempUserData.VoterCardId,
                    PhotoFileName = finalBasePath
                };
                var userEmailId = CryptoHelper.Encrypt(personalDetail.OfficialEmailId).ToLower();
                var existingUsers = _dbContext.UserDetails.FirstOrDefault(x => x.EmailId.ToLower() == userEmailId && x.TerminateDate == null);
                if (existingUsers != null)
                {
                    personalDetail.IsUserCreated = true;
                    personalDetail.UserId = existingUsers.UserId;
                    personalDetail.DOJ = (existingUsers.JoiningDate.HasValue && existingUsers.JoiningDate != null) ? existingUsers.JoiningDate.Value.ToString("MM/dd/yyyy", CultureInfo.InvariantCulture) : string.Empty;
                    personalDetail.EmployeeAbrhs = CryptoHelper.Encrypt(existingUsers.UserId.ToString());
                }

                var userAddressList = new List<UserAddressDetailBO>();
                var userAddressData = _dbContext.TempUserAddressDetails.Where(x => x.RegistrationId == registrationId).ToList();
                if (userAddressData.Any())
                {
                    foreach (var temp in userAddressData)
                    {
                        userAddressList.Add(new UserAddressDetailBO
                        {
                            CountryId = temp.CountryId.Value,
                            Country = _dbContext.Countries.FirstOrDefault(x => x.CountryId == temp.CountryId).CountryName,
                            CityId = temp.CityId.Value,
                            City = _dbContext.Cities.FirstOrDefault(x => x.CityId == temp.CityId).CityName,
                            StateId = temp.StateId.Value,
                            State = _dbContext.States.FirstOrDefault(x => x.StateId == temp.StateId).StateName,
                            PinCode = CryptoHelper.Decrypt(temp.PinCode),
                            Address = CryptoHelper.Decrypt(temp.Address),
                            IsAddressPermanent = temp.IsAddressPermanent.Value,
                        });
                    }
                }

                return new UserDetailBO
                {
                    PersonalDetail = personalDetail,
                    AddressDetail = userAddressList,

                };


            }
            return null;
        }

        public UserDetailBO GetUserProfileDataByUserId(string employeeAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(employeeAbrhs), out userId);

            var userData = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == userId);//&& x.TerminateDate == null
            var userRoleId = _dbContext.Users.FirstOrDefault(x => x.UserId == userId).RoleId;
            var userDeptData = (from utm in _dbContext.UserTeamMappings
                                join t in _dbContext.Teams on utm.TeamId equals t.TeamId
                                join dept in _dbContext.Departments on t.DepartmentId equals dept.DepartmentId
                                join div in _dbContext.Divisions on dept.DivisionId equals div.DivisionId
                                where utm.UserId == userId && utm.IsActive == true && t.IsActive == true && dept.IsActive == true && div.IsActive == true
                                select new { t.TeamId, dept.DepartmentId, div.DivisionId }).FirstOrDefault();

            if (userData != null)
            {

                var personalDetail = new UserPersonalDetailBO
                {

                    UserName = CryptoHelper.Decrypt(userData.EmailId).Split('@')[0],
                    OfficialEmailId = CryptoHelper.Decrypt(userData.EmailId),
                    PersonalEmailId = userData.PersonalEmailId,
                    FirstName = userData.FirstName,
                    MiddleName = userData.MiddleName,
                    LastName = userData.LastName,
                    MobileNumber = CryptoHelper.Decrypt(userData.MobileNumber),
                    EmergencyContactNumber = userData.EmergencyContactNumber,
                    DOB = CryptoHelper.Decrypt(userData.DOB),
                    BloodGroup = CryptoHelper.Decrypt(userData.BloodGroup),
                    GenderId = userData.GenderId,
                    Gender = _dbContext.Genders.FirstOrDefault(x => x.GenderId == userData.GenderId).GenderType,
                    MaritalStatusId = userData.MaritalStatusId,
                    MaritalStatus = _dbContext.MaritalStatus.FirstOrDefault(x => x.MaritalStatusId == userData.MaritalStatusId).MaritalStatusType,
                    IsFresher = userData.IsFresher,
                    LastEmployerName = userData.LastEmployerName,
                    LastEmployerLocation = userData.LastEmployerLocation,
                    LastJobDesignation = userData.LastJobDesignation,
                    LastJobTenure = userData.LastJobTenure,
                    LastJobUAN = userData.UAN,
                    JobLeavingReason = userData.JobLeavingReason,
                    PanNo = userData.PanCardId,
                    AadhaarNo = userData.AadhaarCardId,
                    PassportNo = userData.PassportId,
                    DLNo = userData.DrivingLicenseId,
                    VoterIdNo = userData.VoterCardId,
                };
                var userAddressList = new List<UserAddressDetailBO>();
                var userAddressData = _dbContext.UserAddressDetails.Where(x => x.UserId == userId).ToList();
                if (userAddressData.Any())
                {
                    foreach (var temp in userAddressData)
                    {
                        userAddressList.Add(new UserAddressDetailBO
                        {
                            CountryId = temp.CountryId,
                            CityId = temp.CityId,
                            StateId = temp.StateId,
                            PinCode = CryptoHelper.Decrypt(temp.PinCode),
                            Address = CryptoHelper.Decrypt(temp.Address),//temp.Address
                            IsAddressPermanent = temp.IsAddressPermanent,
                        });
                    }
                }

                var userJoiningDetail = new UserJoiningDetailBO
                {
                    EmployeeId = userData.EmployeeId,
                    DesignationGrpAbrhs = CryptoHelper.Encrypt((_dbContext.Designations.FirstOrDefault(x => x.DesignationId == userData.DesignationId.Value).DesignationGroupId).ToString()),
                    DesignationId = userData.DesignationId.ToString(),//CryptoHelper.Encrypt(userData.DesignationId.ToString()),
                    Doj = (userData.JoiningDate.HasValue ? userData.JoiningDate.Value.ToString("MM/dd/yyyy", CultureInfo.InvariantCulture) : null),  //userData.JoiningDate == null ? null : userData.JoiningDate.Value.ToString("MM/dd/yyyy"),
                    //WsNo = userData.AssignedWorkStation,
                    TerminationDate = (userData.TerminateDate.HasValue ? userData.TerminateDate.Value.ToString("MM/dd/yyyy", CultureInfo.InvariantCulture) : null),
                    ExtensionNo = userData.ExtensionNumber,
                    //AccCardNo = userData.PunchId,
                    RoleId = CryptoHelper.Encrypt(userRoleId.ToString()), // _dbContext.Users.FirstOrDefault(x => x.UserId == userId).RoleId,
                    ReportingManagerId = CryptoHelper.Encrypt(userData.ReportTo.ToString()),
                    ProbationPeriod = Convert.ToBoolean(userData.ProbationPeriodMonths) ? userData.ProbationPeriodMonths.Value : 0,

                    //WsNo=userData.
                };
                if (userDeptData != null)
                {
                    userJoiningDetail.DivisionId = userDeptData.DivisionId.ToString();
                    userJoiningDetail.DepartmentId = userDeptData.DepartmentId.ToString();//.Encrypt(userDeptData.DepartmentId.ToString()),
                    userJoiningDetail.TeamId = userDeptData.TeamId.ToString();//CryptoHelper.Encrypt(userDeptData.TeamId.ToString()),
                }

                return new UserDetailBO
                {
                    PersonalDetail = personalDetail,
                    AddressDetail = userAddressList,
                    JoiningDetail = userJoiningDetail,
                };
            }
            return null;
        }


        public int VerifyUserRegDetails(long registrationId, string sourceBasePath, string destinationBasePath, int accessCardId, string employeeAbrhs, bool isPimcoUserCardMapping, string userAbrhs, DateTime fromDate, string redirectionLink)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(employeeAbrhs), out userId);
            var status = 0;

            var result = new ObjectParameter("Success", typeof(int));
            var loginUserId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out loginUserId);
            var tempUserData = _dbContext.TempUserRegistrations.Where(x => x.RegistrationId == registrationId && x.IsActive == true).Select(x => new { x.UserName, x.EmailId, x.PhotoFileName }).FirstOrDefault();

            _dbContext.Proc_VerifyUserRegDetails(registrationId, accessCardId, userId, isPimcoUserCardMapping, loginUserId, false, fromDate, result);

            Int32.TryParse(result.Value.ToString(), out status);

            // Logging 
            SaveUserLogs(ActivityMessages.AddUserAccessCardMapping, loginUserId, 0);

            if (status == 1 && tempUserData != null)
            {
                if (tempUserData.PhotoFileName != null)
                {
                    sourceBasePath = sourceBasePath + tempUserData.PhotoFileName;
                    destinationBasePath = destinationBasePath + tempUserData.PhotoFileName;
                    var decodedByteArray = File.ReadAllBytes(sourceBasePath);
                    File.WriteAllBytes(destinationBasePath, decodedByteArray);
                    File.Delete(sourceBasePath);
                }

                var userData = _dbContext.Users.FirstOrDefault(x => x.UserId == userId);
                var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "MIS Activation Link" && f.IsActive && !f.IsDeleted);

                if (tempUserData != null && emailTemplate != null && userData != null)
                {
                    var firstName = tempUserData.UserName.Split('.')[0];
                    var link = redirectionLink + userData.PasswordResetCode;
                    var body = emailTemplate.Template
                        .Replace("[NAME]", firstName.ToTitleCase())
                        .Replace("[LINK]", link)
                        .Replace("[HEADING]", "MIS ACCOUNT ACTIVATION");
                    EmailHelper.SendEmailWithDefaultParameter("Link for MIS account activation", body, true, true, tempUserData.EmailId, null, null, null);
                }
                return status;
            }
            else
                return status;
        }

        public bool EditUserPersonalInfo(UserPersonalDetailBO userPersonalDetail)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userPersonalDetail.EmployeeAbrhs), out userId);

            var modifiedById = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userPersonalDetail.UserAbrhs), out modifiedById);

            var userData = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == userId && x.TerminateDate == null);
            if (userData != null)
            {
                userData.PersonalEmailId = userPersonalDetail.PersonalEmailId;
                userData.FirstName = userPersonalDetail.FirstName;
                userData.MiddleName = userPersonalDetail.MiddleName;
                userData.LastName = userPersonalDetail.LastName;
                userData.MobileNumber = CryptoHelper.Encrypt(userPersonalDetail.MobileNumber);
                userData.EmergencyContactNumber = userPersonalDetail.EmergencyContactNumber;
                userData.DOB = CryptoHelper.Encrypt(userPersonalDetail.DOB);
                userData.BloodGroup = CryptoHelper.Encrypt(userPersonalDetail.BloodGroup);
                userData.GenderId = userPersonalDetail.GenderId.Value;
                userData.MaritalStatusId = userPersonalDetail.MaritalStatusId;
                userData.LastModifiedBy = modifiedById;
                userData.LastModifiedDate = DateTime.Now;

                _dbContext.SaveChanges();

                // Logging
                SaveUserLogs(ActivityMessages.EditUserPersonalInfo, modifiedById, userId);

                return true;
            }
            return false;
        }

        public bool EditUserAddressInfo(List<UserAddressDetailBO> userAddressDetail)
        {
            if (userAddressDetail.Any())
            {
                foreach (var item in userAddressDetail)
                {
                    var userId = 0;
                    Int32.TryParse(CryptoHelper.Decrypt(item.EmployeeAbrhs), out userId);
                    var modifiedById = 0;
                    Int32.TryParse(CryptoHelper.Decrypt(item.UserAbrhs), out modifiedById);

                    var addressData = _dbContext.UserAddressDetails.FirstOrDefault(x => x.UserId == userId && x.IsActive == true && x.IsAddressPermanent == item.IsAddressPermanent);
                    if (addressData != null)
                    {
                        addressData.CountryId = item.CountryId;
                        addressData.StateId = item.StateId;
                        addressData.CityId = item.CityId;
                        addressData.Address = CryptoHelper.Encrypt(item.Address);
                        addressData.PinCode = CryptoHelper.Encrypt(item.PinCode);
                        addressData.IsAddressPermanent = item.IsAddressPermanent;
                        addressData.LastModifiedBy = modifiedById;
                        addressData.LastModifiedDate = DateTime.Now;
                        _dbContext.SaveChanges();
                        // Logging
                        SaveUserLogs(ActivityMessages.EditUserAddressInfo, modifiedById, userId);
                    }
                    else
                    {
                        _dbContext.UserAddressDetails.Add(new Model.UserAddressDetail
                        {
                            UserId = userId,
                            Address = CryptoHelper.Encrypt(item.Address),
                            CountryId = item.CountryId,
                            StateId = item.StateId,
                            CityId = item.CityId,
                            PinCode = CryptoHelper.Encrypt(item.PinCode),
                            IsAddressPermanent = item.IsAddressPermanent,
                            IsActive = true,
                        });
                    }
                    SaveUserLogs(ActivityMessages.EditUserAddressInfo, modifiedById, userId);
                }
                return true;
            }

            return false;
        }

        public bool EditUserCareerInfo(UserPersonalDetailBO userCareerDetail)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userCareerDetail.EmployeeAbrhs), out userId);
            var modifiedById = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userCareerDetail.UserAbrhs), out modifiedById);

            var userData = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == userId && x.TerminateDate == null);

            if (userData != null)
            {
                userData.IsFresher = userCareerDetail.IsFresher;
                userData.LastEmployerName = userCareerDetail.LastEmployerName;
                userData.LastEmployerLocation = userCareerDetail.LastEmployerLocation;
                userData.LastJobDesignation = userCareerDetail.LastJobDesignation;
                userData.LastJobTenure = userCareerDetail.LastJobTenure;
                userData.UAN = userCareerDetail.LastJobUAN;
                userData.JobLeavingReason = userCareerDetail.JobLeavingReason;
                userData.LastModifiedBy = modifiedById;
                userData.LastModifiedDate = DateTime.Now;
                _dbContext.SaveChanges();

                // Logging
                SaveUserLogs(ActivityMessages.EditUserCareerInfo, modifiedById, userId);

                return true;
            }
            return false;
        }

        public bool EditUserBankInfo(UserPersonalDetailBO userBankDetail)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userBankDetail.EmployeeAbrhs), out userId);
            var modifiedById = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userBankDetail.UserAbrhs), out modifiedById);

            var userData = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == userId && x.TerminateDate == null);

            if (userData != null)
            {
                userData.PanCardId = userBankDetail.PanNo;
                userData.AadhaarCardId = userBankDetail.AadhaarNo;
                userData.PassportId = userBankDetail.PassportNo;
                userData.DrivingLicenseId = userBankDetail.DLNo;
                userData.VoterCardId = userBankDetail.VoterIdNo;
                userData.LastModifiedBy = modifiedById;
                userData.LastModifiedDate = DateTime.Now;

                _dbContext.SaveChanges();

                // Logging
                SaveUserLogs(ActivityMessages.EditUserBankInfo, modifiedById, userId);

                return true;
            }
            return false;
        }

        public bool EditUserJoiningInfo(UserJoiningDetailBO userJoiningDetail)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userJoiningDetail.EmployeeAbrhs), out userId);
            var modifiedById = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userJoiningDetail.UserAbrhs), out modifiedById);
            var doj = DateTime.ParseExact(userJoiningDetail.Doj, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            var userData = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == userId && x.TerminateDate == null);
            var user = _dbContext.Users.FirstOrDefault(x => x.UserId == userId && x.IsActive == true);
            var utm = _dbContext.UserTeamMappings.FirstOrDefault(x => x.UserId == userId && x.IsActive == true);
            if (utm == null && userId != 0 && modifiedById != 0)
            {
                UserTeamMapping newObject = new UserTeamMapping
                {
                    UserId = userId,
                    TeamId = Convert.ToInt32(userJoiningDetail.TeamId),
                    TeamRoleId = 7,
                    IsActive = true,
                    ConsiderInClientReports = false,
                    CreatedBy = modifiedById,
                    CreatedDate = DateTime.Now,
                };
                _dbContext.UserTeamMappings.Add(newObject);
                _dbContext.SaveChanges();
            }

            utm = _dbContext.UserTeamMappings.FirstOrDefault(x => x.UserId == userId && x.IsActive == true);

            if (userData != null && user != null && utm != null)
            {
                userData.EmployeeId = userJoiningDetail.EmployeeId;
                userData.DesignationId = Convert.ToInt32(userJoiningDetail.DesignationId);//Convert.ToInt32(CryptoHelper.Decrypt(userJoiningDetail.DesignationId));
                //userData.AssignedWorkStation = userJoiningDetail.WsNo;
                userData.ExtensionNumber = userJoiningDetail.ExtensionNo;
                //userData.PunchId = userJoiningDetail.AccCardNo;
                userData.JoiningDate = doj; /*Convert.ToDateTime(userJoiningDetail.Doj);*/
                userData.ReportTo = Convert.ToInt32(CryptoHelper.Decrypt(userJoiningDetail.ReportingManagerId));
                //userData.TerminateDate = string.IsNullOrEmpty(userJoiningDetail.TerminationDate) ? (DateTime?)null : DateTime.ParseExact(userJoiningDetail.TerminationDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
                userData.LastModifiedBy = modifiedById;
                userData.LastModifiedDate = DateTime.Now;
                user.IsActive = string.IsNullOrEmpty(userJoiningDetail.TerminationDate) ? true : false;
                user.RoleId = Convert.ToInt32(CryptoHelper.Decrypt(userJoiningDetail.RoleId));
                userData.ProbationPeriodMonths = userJoiningDetail.ProbationPeriod;
                utm.TeamId = Convert.ToInt32(userJoiningDetail.TeamId);
                _dbContext.SaveChanges();

                // Logging
                SaveUserLogs(ActivityMessages.EditUserJoiningInfo, modifiedById, userId);
                return true;
            }
            return false;
        }

        public MappingInfoBo SaveNewUser(long registrationId, string employeeId, string departmentAbrhs, string designationAbrhs, int probationPeriod, long teamId, string wsNo, string extensionNo /*string accCardNo*/
                                , string doj, string roleAbrhs, string reportingManagerAbrhs, string userAbrhs, string redirectionLink)
        {
            var departmentId = 0;
            var designationId = 0;
            var roleId = 0;
            var reportingManagerId = 0;
            var loginUserId = 0;

            Int32.TryParse(CryptoHelper.Decrypt(departmentAbrhs), out departmentId);
            Int32.TryParse(CryptoHelper.Decrypt(designationAbrhs), out designationId);
            Int32.TryParse(CryptoHelper.Decrypt(roleAbrhs), out roleId);
            Int32.TryParse(CryptoHelper.Decrypt(reportingManagerAbrhs), out reportingManagerId);
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out loginUserId);
            var passwordResetCode = CommonUtility.GenerateRandomCode(10);

            var tempUserData = _dbContext.TempUserRegistrations.Where(x => x.RegistrationId == registrationId && x.IsActive == true).Select(x => new { x.UserName, x.DOB, x.BloodGroup, x.EmailId, x.MobileNumber, x.PhotoFileName }).FirstOrDefault();
            var userName = CryptoHelper.Encrypt(tempUserData.UserName);
            var dob = CryptoHelper.Encrypt(tempUserData.DOB.Value.ToString("MM/dd/yyyy", CultureInfo.InvariantCulture));
            var bloodGroup = CryptoHelper.Encrypt(tempUserData.BloodGroup);
            var emailId = CryptoHelper.Encrypt(tempUserData.EmailId);
            var mobileNumber = CryptoHelper.Encrypt(tempUserData.MobileNumber);

            var status = 0;
            var newUserId = 0;
            var result = new ObjectParameter("Success", typeof(int));
            var newUser = new ObjectParameter("NewUser", typeof(int));

            _dbContext.spSaveNewUser(registrationId, userName, dob, bloodGroup, emailId, mobileNumber, employeeId, departmentId, designationId, probationPeriod, teamId, wsNo, extensionNo, /*accCardNo,*/ doj, roleId, reportingManagerId, loginUserId, passwordResetCode, result, newUser);
            Int32.TryParse(result.Value.ToString(), out status);
            Int32.TryParse(newUser.Value.ToString(), out newUserId);

            if (status == 1)
            {
                //if (tempUserData.PhotoFileName != null)
                //{
                //    sourceBasePath = sourceBasePath + tempUserData.PhotoFileName;
                //    destinationBasePath = destinationBasePath + tempUserData.PhotoFileName;
                //    var decodedByteArray = File.ReadAllBytes(sourceBasePath);
                //    File.WriteAllBytes(destinationBasePath, decodedByteArray);
                //    File.Delete(sourceBasePath);
                //}

                //var link = ConfigurationManager.AppSettings["PasswordResetUrl"] + passwordResetCode;
                //var link = redirectionLink + passwordResetCode;
                //EmailHelper.SendEmailWithDefaultParameter("MIS account activation", "Dear user, you can use the following link to activate your MIS account. " + link, true, true, tempUserData.EmailId, null, null, null);
            }


            //Logging
            SaveUserLogs(ActivityMessages.SaveNewUser, loginUserId, 0);
            return new MappingInfoBo
            {
                DOJ = doj,
                UserId = newUserId,
                Success = status,
                IsUserCreated = (newUserId > 0),
                EmployeeAbrhs = CryptoHelper.Encrypt(newUserId.ToString()),
            };
        }
        public OldAndNewLeaveBalance LisLeaveBalanceForNewUser(string empDesignationAbrhs, DateTime joiningDate)
        {
            BO.OldAndNewLeaveBalance balance = new BO.OldAndNewLeaveBalance();
            var empDesignationId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(empDesignationAbrhs), out empDesignationId);
            var userId = 0;
            var data = _dbContext.Proc_FetchLeaveDetailsForPromotionAndNewUser(userId, empDesignationId, joiningDate).ToList();
            if (data.Any())
            {
                foreach (var d in data)
                {
                    switch (d.LeaveType)
                    {

                        case "CL":
                            balance.NewClCount = Convert.ToDouble(d.LeaveCount);
                            break;
                        case "PL":
                            balance.NewPlCount = Convert.ToDouble(d.LeaveCount);
                            break;
                        case "5CLOY":
                            balance.NewCloyAvailable = (d.LeaveCount == 1 ? "Available" : "Availed");
                            break;

                    }

                }
            }
            return balance;
        }
        public List<PendingDataForApprovals> ListPendingUnapprovedDataOfUser(string employeeAbrhs)
        {
            //PendingDataForApprovals balance = new PendingDataForApprovals();
            var info = new List<PendingDataForApprovals>();
            var employeeId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(employeeAbrhs), out employeeId);
            var data = _dbContext.Proc_FetchPendingApprovalsForUserId(employeeId).ToList();
            if (data.Any())
            {
                foreach (var temp in data)
                {
                    info.Add(new PendingDataForApprovals
                    {
                        Type = temp.Type,
                        Period = temp.Period,
                        ReportingManager = temp.ReportingManager
                    });
                }
            }
            return info;
        }
        public int SendReminderMailToPreviousManager(string employeeAbrhs)
        {
            var info = new List<PendingDataForApprovals>();
            var employeeId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(employeeAbrhs), out employeeId);
            var data = _dbContext.Proc_FetchPendingApprovalsForUserId(employeeId).ToList();
            var rmIds = data.Select(x => x.RMId).Distinct().ToList();
            foreach (var fwEmpUserId in rmIds)
            {
                var detail = data.Where(x => x.RMId == fwEmpUserId).ToList();
                var existingReceiverData = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == fwEmpUserId);
                var employeeName = _dbContext.vwActiveUsers.FirstOrDefault(x => x.UserId == employeeId).EmployeeName;
                var receiverFirstName = existingReceiverData.FirstName;
                var receiverLastName = existingReceiverData.LastName;
                var subject = "Regarding approval of pending activities";
                var message = "Reporting manager of " + employeeName + " will be changed and following approvals are pending on your end.Kindly approve them ASAP on priority.";
                var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "Pending Approvals" && f.IsActive && !f.IsDeleted);
                var table = "<table border='0' cellpadding='4' style='color:#000000;font:normal 11px arial,sans-serif;border:1px solid #abb2b7;width:100%'><thead><tr><th style='color:#434d52;font:bold 13px arial,sans-serif;white-space:nowrap;background-color:#ebeff1;border:1px solid #abb2b7'>Pending Activity</th><th style='color:#434d52;font:bold 13px arial,sans-serif;white-space:nowrap;background-color:#ebeff1;border:1px solid #abb2b7'>Related Information</th></tr></thead><tbody>";
                if (detail != null)
                {
                    foreach (var temp in detail)
                        table = table + "<tr><td style='border:1px solid #abb2b7;'>&nbsp;" + temp.Type + "</td><td style='border:1px solid #abb2b7;'>&nbsp;" + temp.Period + "</td></tr>";
                }
                if (emailTemplate != null && existingReceiverData != null)
                {
                    var body = emailTemplate.Template
                             .Replace("[Name]", receiverFirstName.ToTitleCase())
                             .Replace("[Title]", "PENDING APPROVALS")
                             .Replace("[Line1]", message)
                             .Replace("[Data]", table);
                    // SEND MAIL 
                    Utilities.EmailHelper.SendEmailWithDefaultParameter(subject, body, true, true, CryptoHelper.Decrypt(existingReceiverData.EmailId), null, null, null);
                    _dbContext.SaveChanges();
                }

            }
            return 1;
        }
        public int UpdateReportingManagerForApprovals(string employeeAbrhs, string rmAbrhs, string userAbrhs)
        {
            var employeeId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(employeeAbrhs), out employeeId);
            var rmId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(rmAbrhs), out rmId);
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            _dbContext.Proc_UpdateApproverIdOnManagerChange(employeeId, rmId, userId);
            return 1;
        }
        public bool RejectUserProfile(long registrationId, string reason, string userAbrhs, string redirectionLink)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            var passwordResetCode = CommonUtility.GenerateRandomCode(10);

            var userData = _dbContext.TempUserRegistrations.FirstOrDefault(x => x.RegistrationId == registrationId);

            userData.GuidExpiryDate = DateTime.Now.AddDays(2);
            userData.IsSubmitted = false;
            userData.IsVerified = false;
            userData.IsActive = true;
            userData.IsGuidExpired = false;
            _dbContext.SaveChanges();
            //var link = ConfigurationManager.AppSettings["NewUserRegistrationUrl"] + userData.TempUserGuid;
            var link = redirectionLink + userData.TempUserGuid;
            var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "Reject User Profile" && f.IsActive && !f.IsDeleted);

            if (emailTemplate != null && userData != null)
            {
                var emailId = userData.EmailId;
                var firstName = userData.UserName.Split('.')[0];

                var body = emailTemplate.Template
                    .Replace("[NAME]", firstName.ToTitleCase())
                    .Replace("[LINK]", link)
                    .Replace("[REASON]", reason)
                    .Replace("[HEADING]", "PROFILE REQUEST REJECTED");
                EmailHelper.SendEmailWithDefaultParameter("Profile request rejected", body, true, true, userData.EmailId, null, null, null);
            }
            // Logging
            SaveUserLogs(ActivityMessages.RejectUserRegistrationProfile, userId, 0);

            return true;
        }
        public OldAndNewLeaveBalance ListOldAndNewLeaveBalanceByUserId(string userAbrhs, int empDesignationId, DateTime promotionDate)
        {
            BO.OldAndNewLeaveBalance balance = new BO.OldAndNewLeaveBalance();
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            balance.UserId = userId;
            //var PromotionDate = Convert.ToDateTime(promotionDate);
            var data = _dbContext.Proc_FetchLeaveDetailsForPromotionAndNewUser(userId, empDesignationId, promotionDate).ToList();
            if (data.Any())
            {
                foreach (var d in data)
                {
                    switch (d.LeaveType)
                    {
                        case "OldCL":
                            balance.OldClCount = Convert.ToDouble(d.LeaveCount);
                            break;
                        case "OldPL":
                            balance.OldPlCount = Convert.ToDouble(d.LeaveCount);
                            break;
                        case "Old5CLOY":
                            balance.OldCloyAvailable = (d.LeaveCount == 1 ? "Available" : "Availed");
                            break;
                        case "NewCL":
                            balance.NewClCount = Convert.ToDouble(d.LeaveCount);
                            break;
                        case "NewPL":
                            balance.NewPlCount = Convert.ToDouble(d.LeaveCount);
                            break;
                        case "New5CLOY":
                            balance.NewCloyAvailable = (d.LeaveCount == 1 ? "Available" : "Availed");
                            break;
                        case "OldRole":
                            balance.OldRole = _dbContext.Roles.FirstOrDefault(x => x.RoleId == d.LeaveCount).RoleName;
                            break;
                        case "NewRole":
                            balance.NewRole = _dbContext.Roles.FirstOrDefault(x => x.RoleId == d.LeaveCount).RoleName;
                            break;
                    }

                }
            }
            return balance;
        }

        //public int SaveNewUser(long registrationId, string userName, string officialEmailId, string personalEmailId, string firstName, string middleName, string lastName, string mobileNumber, string emergencyContactNumber, string dob,
        //    string bloodGroup, int gender, int maritalStatus, string presentAddress, string permanentAddress, string fatherName, string fatherDOB, string motherName, string motherDOB, string insuranceAmount, string spouseName, string spouseDob,
        //    string spouseOccupation, string spouseCompany, string spouseDesignation, bool kids, string child1Name, string child1Dob, int child1Gender, string child2Name, string child2Dob, int child2Gender, string jobExperience, bool isFresher,
        //    string lastEmployerName, string lastEmployerLocation, string lastJobDesignation, string lastJobTenure, string lastJobUan, string jobLeavingReason, string panNo, string aadhaarNo, string passportNo, string dLNo, string voterIdNo,
        //    string bankAccNo, string employeeId, string departmentAbrhs, string designationAbrhs, string wsNo, string extensionNo, string accCardNo, string doj, string roleAbrhs, string reportingManagerAbrhs, string userAbrhs) //1:success,2:username already exists,3:fail
        //{
        //        var departmentId = 0;
        //        var designationId = 0;
        //        var roleId = 0;
        //        var reportingManagerId = 0;
        //        var userId = 0;

        //        Int32.TryParse(CryptoHelper.Decrypt(departmentAbrhs), out departmentId);
        //        Int32.TryParse(CryptoHelper.Decrypt(designationAbrhs), out designationId);
        //        Int32.TryParse(CryptoHelper.Decrypt(roleAbrhs), out roleId);
        //        Int32.TryParse(CryptoHelper.Decrypt(reportingManagerAbrhs), out reportingManagerId);
        //        Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
        //        var passwordResetCode = CommonUtility.GenerateRandomCode(10);

        //        var result = _dbContext.spSaveNewUser(registrationId, userName, officialEmailId, personalEmailId, firstName, middleName, lastName, mobileNumber, emergencyContactNumber, dob, bloodGroup, gender, maritalStatus,
        //    presentAddress, permanentAddress, fatherName, fatherDOB, motherName, motherDOB, insuranceAmount, spouseName, spouseDob, spouseOccupation, spouseCompany, spouseDesignation, kids, child1Name, child1Dob, child1Gender,
        //    child2Name, child2Dob, child2Gender, jobExperience, isFresher, lastEmployerName, lastEmployerLocation, lastJobDesignation, lastJobTenure, lastJobUan, jobLeavingReason, panNo, aadhaarNo, passportNo, dLNo, voterIdNo,
        //    bankAccNo, employeeId, departmentId, designationId, wsNo, extensionNo, accCardNo, doj, roleId, reportingManagerId, userId, passwordResetCode);
        //        return 1;
        //}


        #region New User Registration

        public int GenerateLinkForUserRegistration(string userName, string adUserName, string domain, string userAbrhs, string redirectionLink) //1: success, 2:duplicate userName in User Table, 3:duplicate userName in tempUserRegistration table, 4: error, 5: validation error
        {
            if (string.IsNullOrWhiteSpace(userName) || string.IsNullOrWhiteSpace(domain) || string.IsNullOrWhiteSpace(userAbrhs) || string.IsNullOrWhiteSpace(redirectionLink) || string.IsNullOrWhiteSpace(adUserName))
                return 5;
            var uName = userName.TrimAndLower();
            var encUserName = CryptoHelper.Encrypt(uName);
            var duplicateUserNameInMain = _dbContext.Users.FirstOrDefault(x => x.IsActive == true && x.UserName == encUserName);
            var duplicateADUserNameInMain = _dbContext.Users.FirstOrDefault(x => x.IsActive == true && x.ADUserName == adUserName);

            if (duplicateUserNameInMain == null && duplicateADUserNameInMain == null)
            {
                var duplicateUserNameInTemp = _dbContext.TempUserRegistrations.FirstOrDefault(x => x.UserName == uName);
                var duplicateADUserNameInTemp = _dbContext.TempUserRegistrations.FirstOrDefault(x => x.ADUserName == adUserName);

                if (duplicateUserNameInTemp == null && duplicateADUserNameInTemp == null)
                {
                    var userId = 0;
                    int.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                    var emailId = uName + "@" + domain.TrimAndLower();
                    var randomCode = CommonUtility.GenerateRandomCode(10);
                    //var link = ConfigurationManager.AppSettings["NewUserRegistrationUrl"] + randomCode; // "http:/localhost:6419/UserManagement/NewUserRegistration?TempGuid=" + randomCode;
                    var link = redirectionLink + randomCode;
                    var data = new Model.TempUserRegistration
                    {
                        UserName = uName,
                        EmailId = emailId,
                        TempUserGuid = randomCode,
                        GuidExpiryDate = DateTime.Now.AddDays(2),
                        CreatedBy = userId,
                        CreatedDate = DateTime.Now,
                        IsSubmitted = false,
                        IsVerified = false,
                        IsActive = true,
                        IsGuidExpired = false,
                        ADUserName = adUserName
                    };
                    _dbContext.TempUserRegistrations.Add(data);
                    var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == EmailTemplates.UserRegistrationNotification && f.IsActive && !f.IsDeleted);
                    if (emailTemplate != null)
                    {
                        var firstName = uName.Split('.')[0];
                        var body = emailTemplate.Template
                            .Replace("[NAME]", firstName.ToTitleCase())
                            .Replace("[LINK]", link)
                            .Replace("[HEADING]", "User Registration");
                        EmailHelper.SendEmailWithDefaultParameter("Link for user registration", body, true, true, emailId, null, null, null);
                    }

                    _dbContext.SaveChanges();

                    // Logging
                    SaveUserLogs(ActivityMessages.GenerateLinkForUserRegistration, userId, 0);

                    return 1;
                }
                else if (duplicateUserNameInTemp != null)
                    return 3; // duplicate userName in temp
                else
                    return 4; // duplicate adusername in temp
            }
            else if (duplicateUserNameInMain != null)
                return 2; // duplicate userName in main
            else
                return 0; //duplicate adusername in main
        }

        public string ValidateQueryStringForUserRegistration(string tempUserGuid)
        {
            var presentDataTime = DateTime.Now;
            var data = _dbContext.TempUserRegistrations.FirstOrDefault(f => f.TempUserGuid == tempUserGuid && f.IsActive == true && f.IsGuidExpired == false && f.GuidExpiryDate >= presentDataTime && f.IsSubmitted == false); //&& f.IsGuidExpired == false
            var msg = "";

            if (data == null)
            {
                var datatemp = _dbContext.TempUserRegistrations.FirstOrDefault(f => f.TempUserGuid == tempUserGuid && f.IsActive == true);
                if (datatemp != null)
                {
                    if (datatemp.IsSubmitted == true)
                        msg = "You have already submitted the registration form.";

                    else if (datatemp.IsGuidExpired == true)
                        msg = "The link provided is expired.";
                }

            }
            return msg;
        }

        public int SaveNewUserRegPersonalInfo(UserPersonalDetailBO userPersonalDetail, string basePath, string guId)
        {
            var statusId = 0;
            var dobNew = Convert.ToDateTime(DateTime.ParseExact(userPersonalDetail.DOB, "MM/dd/yyyy", CultureInfo.InvariantCulture));

            var userData = _dbContext.TempUserRegistrations.FirstOrDefault(x => x.IsSubmitted == false && x.IsActive == true && x.TempUserGuid == userPersonalDetail.TempUserGuid);
            if (userData != null)
            {
                if (!string.IsNullOrEmpty(userPersonalDetail.PhotoFileName) && !string.IsNullOrEmpty(userPersonalDetail.Base64PhotoData))
                {
                    userData.PersonalEmailId = userPersonalDetail.PersonalEmailId;
                    userData.FirstName = userPersonalDetail.FirstName.ToTitleCase();
                    userData.MiddleName = userPersonalDetail.MiddleName.ToTitleCase();
                    userData.LastName = userPersonalDetail.LastName.ToTitleCase();
                    userData.MobileNumber = userPersonalDetail.MobileNumber;
                    userData.EmergencyContactNumber = userPersonalDetail.EmergencyContactNumber;
                    //userData = Convert.ToDateTime(userPersonalDetail.DOB);
                    userData.DOB = dobNew;
                    userData.BloodGroup = userPersonalDetail.BloodGroup;
                    userData.GenderId = userPersonalDetail.GenderId;
                    userData.MaritalStatusId = userPersonalDetail.MaritalStatusId;

                    userData.PhotoFileName = guId;//userPersonalDetail.PhotoFileName;

                    //// remove already exists photo from temp prole image folder
                    //if (!string.IsNullOrEmpty(userData.PhotoFileName) && userData.PhotoFileName != userPersonalDetail.PhotoFileName)
                    //{
                    //    var existingImageBasePath = basePath + userData.PhotoFileName;
                    //    if (File.Exists(existingImageBasePath))
                    //    {
                    //        File.Delete(existingImageBasePath);
                    //    }
                    //}

                    var decodedByteArray = Convert.FromBase64String(userPersonalDetail.Base64PhotoData.Split(',')[1]);
                    if (!System.IO.Directory.Exists(basePath))
                        System.IO.Directory.CreateDirectory(basePath);
                    File.WriteAllBytes((basePath + guId), decodedByteArray);

                    var res = _dbContext.SaveChanges();

                    if (res > 0)
                    {
                        statusId = 1;
                    }
                }
                else
                    statusId = 2; // empty image
            }
            return statusId;
        }

        public int SaveNewUserRegAddressInfo(List<UserAddressDetailBO> userAddressDetail)
        {
            int statusId = 0;
            if (userAddressDetail.Any())
            {
                var tempUserGuid = userAddressDetail.FirstOrDefault().TempUserGuid;
                if (userAddressDetail != null)
                {
                    var addressXmlString = new XElement("Root",
                        from add in userAddressDetail
                        select new XElement("Row",
                               new XAttribute("CountryId", add.CountryId),
                                new XAttribute("StateId", add.StateId),
                                new XAttribute("CityId", add.CityId),
                                 new XAttribute("Address", CryptoHelper.Encrypt(add.Address)),
                                new XAttribute("PinCode", CryptoHelper.Encrypt(add.PinCode)),
                                new XAttribute("IsAddressPermanent", add.IsAddressPermanent)
                                ));

                    var result = new ObjectParameter("Success", typeof(int));
                    _dbContext.Proc_SaveNewUserRegAddressInfo(tempUserGuid, addressXmlString.ToString(), result);


                    Int32.TryParse(result.Value.ToString(), out statusId);
                }
            }
            return statusId;
        }

        //public bool SaveNewUserRegAddressInfo(List<UserAddressDetailBO> userAddressDetail)
        //{
        //    if (userAddressDetail.Any())
        //    {
        //        var tempUserGuid = userAddressDetail.FirstOrDefault().TempUserGuid;
        //        var userData = _dbContext.TempUserRegistrations.FirstOrDefault(x => x.IsSubmitted == false && x.IsActive == true && x.TempUserGuid == tempUserGuid);

        //        if (userData != null)
        //        {
        //            var permanentAddress = userAddressDetail.FirstOrDefault(x => x.IsAddressPermanent) ?? new UserAddressDetailBO();
        //            var presentAddress = userAddressDetail.FirstOrDefault(x => !x.IsAddressPermanent) ?? new UserAddressDetailBO();

        //            var addressData = _dbContext.TempUserAddressDetails.Where(x => x.RegistrationId == userData.RegistrationId);

        //            //Update
        //            if (addressData.Any())
        //            {
        //                foreach (var address in addressData)
        //                {
        //                    if (address.IsAddressPermanent == true)
        //                    {
        //                        address.CountryId = permanentAddress.CountryId;
        //                        address.StateId = permanentAddress.StateId;
        //                        address.CityId = permanentAddress.CityId;
        //                        address.Address = CryptoHelper.Encrypt(permanentAddress.Address);
        //                        address.PinCode = CryptoHelper.Encrypt(permanentAddress.PinCode);
        //                        address.IsAddressPermanent = permanentAddress.IsAddressPermanent;
        //                    }
        //                    else
        //                    {
        //                        address.CountryId = presentAddress.CountryId;
        //                        address.StateId = presentAddress.StateId;
        //                        address.CityId = presentAddress.CityId;
        //                        address.Address = CryptoHelper.Encrypt(presentAddress.Address);
        //                        address.PinCode = CryptoHelper.Encrypt(presentAddress.PinCode);
        //                        address.IsAddressPermanent = presentAddress.IsAddressPermanent;
        //                    }
        //                }
        //            }
        //            else //Add
        //            {
        //                foreach (var item in userAddressDetail)
        //                {
        //                    _dbContext.TempUserAddressDetails.Add(new TempUserAddressDetail
        //                    {
        //                        RegistrationId = userData.RegistrationId,
        //                        CountryId = item.CountryId,
        //                        StateId = item.StateId,
        //                        CityId = item.CityId,
        //                        Address = CryptoHelper.Encrypt(item.Address),
        //                        PinCode = CryptoHelper.Encrypt(item.PinCode),
        //                        IsAddressPermanent = item.IsAddressPermanent,
        //                    });
        //                }
        //            }
        //            _dbContext.SaveChanges();
        //            return true;
        //        }
        //        return false;
        //    }
        //    return false;
        //}

        public bool SaveNewUserRegCareerInfo(UserPersonalDetailBO userCareerDetail)
        {
            var userData = _dbContext.TempUserRegistrations.FirstOrDefault(x => x.IsSubmitted == false && x.IsActive == true && x.TempUserGuid == userCareerDetail.TempUserGuid);
            if (userData != null)
            {
                userData.IsFresher = userCareerDetail.IsFresher;
                userData.LastEmployerName = userCareerDetail.LastEmployerName;
                userData.LastEmployerLocation = userCareerDetail.LastEmployerLocation;
                userData.LastJobDesignation = userCareerDetail.LastJobDesignation;
                userData.LastJobTenure = userCareerDetail.LastJobTenure;
                userData.LastJobUAN = userCareerDetail.LastJobUAN;
                userData.JobLeavingReason = userCareerDetail.JobLeavingReason;

                _dbContext.SaveChanges();
                return true;
            }
            return false;
        }

        public bool SaveNewUserRegBankInfo(UserPersonalDetailBO userBankDetail)
        {
            var userData = _dbContext.TempUserRegistrations.FirstOrDefault(x => x.IsSubmitted == false && x.IsActive == true && x.TempUserGuid == userBankDetail.TempUserGuid);
            if (userData != null)
            {
                userData.PanCardId = userBankDetail.PanNo;
                userData.AadhaarCardId = userBankDetail.AadhaarNo;
                userData.PassportId = userBankDetail.PassportNo;
                userData.DrivingLicenseId = userBankDetail.DLNo;
                userData.VoterCardId = userBankDetail.VoterIdNo;

                _dbContext.SaveChanges();
                return true;
            }
            return false;
        }

        public UserDetailBO GetExistingUserRegistrationData(string tempUserGuid)
        {
            var userData = _dbContext.TempUserRegistrations.FirstOrDefault(x => x.IsSubmitted == false && x.IsActive == true && x.TempUserGuid == tempUserGuid);
            if (userData != null)
            {
                var personalDetail = new UserPersonalDetailBO
                {
                    UserName = userData.UserName,
                    OfficialEmailId = userData.EmailId,
                    PersonalEmailId = userData.PersonalEmailId,
                    FirstName = userData.FirstName,
                    MiddleName = userData.MiddleName,
                    LastName = userData.LastName,
                    MobileNumber = userData.MobileNumber,
                    EmergencyContactNumber = userData.EmergencyContactNumber,
                    DOB = ((userData.DOB.HasValue || userData.DOB != null) ? userData.DOB.Value.ToString("MM/dd/yyyy", CultureInfo.InvariantCulture) : null),
                    BloodGroup = userData.BloodGroup,
                    GenderId = userData.GenderId,
                    MaritalStatusId = userData.MaritalStatusId,
                    IsFresher = userData.IsFresher,
                    LastEmployerName = userData.LastEmployerName,
                    LastEmployerLocation = userData.LastEmployerLocation,
                    LastJobDesignation = userData.LastJobDesignation,
                    LastJobTenure = userData.LastJobTenure,
                    LastJobUAN = userData.LastJobUAN,
                    JobLeavingReason = userData.JobLeavingReason,
                    PanNo = userData.PanCardId,
                    AadhaarNo = userData.AadhaarCardId,
                    PassportNo = userData.PassportId,
                    DLNo = userData.DrivingLicenseId,
                    VoterIdNo = userData.VoterCardId,
                    PhotoFileName = userData.PhotoFileName
                };
                var basePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["TempProfileImageUploadPath"];
                if (!string.IsNullOrEmpty(userData.PhotoFileName))
                {
                    var finalBasePath = basePath + userData.PhotoFileName;
                    if (File.Exists(finalBasePath))
                    {
                        byte[] photoInByte = File.ReadAllBytes(finalBasePath);
                        var photoInBase64String = Convert.ToBase64String(photoInByte);
                        var fileExtension = userData.PhotoFileName.Substring(userData.PhotoFileName.LastIndexOf('.') + 1);
                        personalDetail.Base64PhotoData = CommonUtility.GetBase64MimeType(fileExtension) + "," + photoInBase64String;
                    }
                }

                var userAddressList = new List<UserAddressDetailBO>();
                var userAddressData = _dbContext.TempUserAddressDetails.Where(x => x.RegistrationId == userData.RegistrationId).ToList();
                if (userAddressData.Any())
                {
                    foreach (var temp in userAddressData)
                    {
                        userAddressList.Add(new UserAddressDetailBO
                        {
                            CountryId = temp.CountryId.Value,
                            CityId = temp.CityId.Value,
                            StateId = temp.StateId.Value,
                            PinCode = CryptoHelper.Decrypt(temp.PinCode),
                            Address = CryptoHelper.Decrypt(temp.Address),
                            IsAddressPermanent = temp.IsAddressPermanent.Value,
                        });
                    }
                }

                return new UserDetailBO
                {
                    PersonalDetail = personalDetail,
                    AddressDetail = userAddressList,
                };
            }

            return null;
        }

        public List<MandatoryFieldBO> CheckIfAllMandatoryFieldsAreSubmitted(string tempUserGuid)
        {
            var data = _dbContext.spGetAllEmptyMandatoryFieldsForUserRegistration(tempUserGuid).Select(x => new MandatoryFieldBO { Field = x.Field, Category = x.Category }).ToList();
            if (data.Any())
            {
                return data;
            }
            return null;
        }

        public bool SubmitUserRegistrationData(string tempUserGuid)
        {
            var data = _dbContext.TempUserRegistrations.FirstOrDefault(x => x.IsActive == true && x.IsSubmitted == false && x.TempUserGuid == tempUserGuid);
            if (data != null)
            {
                data.IsGuidExpired = true;
                data.IsSubmitted = true;
                data.SubmissionDate = DateTime.Now;

                _dbContext.SaveChanges();
                return true;
            }
            return false;
        }

        #endregion

        #endregion

        #region DashBoard Settings
        /// <summary>
        /// Get User Dashboard Settings
        /// </summary>
        /// <param name="userAbrhs"></param>
        /// <param name="roleAbrhs"></param>
        /// <returns></returns>
        public UserDashBoardSettingsListBO GetUserRoleDashboardSettings(string userAbrhs)
        {
            UserDashBoardSettingsListBO menuObj = new UserDashBoardSettingsListBO();
            menuObj.UserAbrhs = userAbrhs;
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var a = DateTime.Now.Date;
            var refData = _dbContext.Referrals.Where(x => x.IsPositionClosed == false && x.OpeningTill >= a).Count();
            var trainData = _dbContext.Trainings.Where(t => t.IsNominationClosed == false && t.NominationEndDate >= a).Count();
            if (userId > 0)
            {
                var menuList = _dbContext.spGetWidgetPermissions(userId).Select(x => new UserDashBoardSettingsBO
                {
                    DashboardWidgetPermissionId = x.DashboardWidgetUserPermissionId,
                    DashboardWidgetId = x.DashboardWidgetId,
                    DashboardWidgetName = x.DashboardWidgetName,
                    IsReferral = refData > 0 ? true : false,
                    IsTraining = trainData > 0 ? true : false,
                    Sequence = x.Sequence,
                    IsActive = x.IsActive
                }).OrderBy(x => x.Sequence).ToList();
                menuObj.DashBoardSetting = menuList.ToList<UserDashBoardSettingsBO>() ?? new List<UserDashBoardSettingsBO>();
            }
            return menuObj;
        }

        /// <summary>
        /// Add update Dashboard settings
        /// </summary>
        /// <param name="dashBoardSettings"></param>
        /// <returns></returns>
        public int AddUpdateDashboardSettings(ManageDashBoardSettingsBO dashBoardSettings)
        {
            var status = 0;
            if (dashBoardSettings != null && dashBoardSettings.DashBoardSetting.Any() && !string.IsNullOrWhiteSpace(dashBoardSettings.UserAbrhs))
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(dashBoardSettings.UserAbrhs), out userId);
                if (dashBoardSettings.IsUserPermission) // update user permission
                {
                    // Deactivate All Widgets and update Existing Data.
                    var existingdata = _dbContext.DashboardWidgetUserPermissions.Where(x => x.UserId == userId).ToList();
                    if (existingdata.Any())
                    {
                        foreach (var item in existingdata)
                        {
                            item.IsActive = false;
                            item.ModifiedById = userId;
                            item.ModifiedDate = DateTime.Now;
                            _dbContext.SaveChanges();
                        }
                        foreach (var item in dashBoardSettings.DashBoardSetting)
                        {
                            var data = _dbContext.DashboardWidgetUserPermissions.FirstOrDefault(x => x.UserId == userId && x.DashboardWidgetUserPermissionId == item.DashboardWidgetPermissionId);
                            if (data != null)
                            {
                                data.DashboardWidgetId = item.DashboardWidgetId;
                                data.Sequence = item.Sequence;
                                data.IsActive = item.IsActive;
                                data.UserId = userId;
                                data.CreatedDate = DateTime.Now;
                                data.CreatedById = userId;
                                _dbContext.SaveChanges();
                            }
                            else
                            {
                                MIS.Model.DashboardWidgetUserPermission userAndRoleDashBoardSettings = new MIS.Model.DashboardWidgetUserPermission();
                                userAndRoleDashBoardSettings.DashboardWidgetId = item.DashboardWidgetId;
                                userAndRoleDashBoardSettings.Sequence = item.Sequence;
                                userAndRoleDashBoardSettings.IsActive = item.IsActive;
                                userAndRoleDashBoardSettings.UserId = userId;
                                userAndRoleDashBoardSettings.CreatedDate = DateTime.Now;
                                userAndRoleDashBoardSettings.CreatedById = userId;
                                _dbContext.DashboardWidgetUserPermissions.Add(userAndRoleDashBoardSettings);
                                _dbContext.SaveChanges();
                            }

                        }
                        status = 1;
                    }
                    else
                    {
                        foreach (var item in dashBoardSettings.DashBoardSetting)
                        {
                            MIS.Model.DashboardWidgetUserPermission userAndRoleDashBoardSettings = new MIS.Model.DashboardWidgetUserPermission();
                            userAndRoleDashBoardSettings.DashboardWidgetId = item.DashboardWidgetId;
                            userAndRoleDashBoardSettings.Sequence = item.Sequence;
                            userAndRoleDashBoardSettings.IsActive = item.IsActive;
                            userAndRoleDashBoardSettings.UserId = userId;
                            userAndRoleDashBoardSettings.CreatedDate = DateTime.Now;
                            userAndRoleDashBoardSettings.CreatedById = userId;
                            _dbContext.DashboardWidgetUserPermissions.Add(userAndRoleDashBoardSettings);
                        }
                        _dbContext.SaveChanges();
                        status = 1;
                    }

                }
                // Logging
                SaveUserLogs(ActivityMessages.AddUpdateDashboardSettings, userId, 0);
            }
            else
            {
                return status;
            }
            return status;
        }

        #endregion

        #region Skills

        /// <summary>
        /// Add Skills
        /// </summary>
        /// <param name="skillsDetailBO"></param>
        /// <returns></returns>
        public int AddSkills(SkillsDetailBO skillsDetailBO)
        {
            var status = 0;
            using (var context = new MISEntities())
            {

                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(skillsDetailBO.UserAbrhs), out userId);
                if (skillsDetailBO.UserSkillId > 0)
                {
                    var count = context.UserSkills.Where(x => x.SkillId == skillsDetailBO.SkillId && x.IsActive && x.UserId == userId).ToList().Count;
                    if (count == 1)
                    {
                        var existingData = context.UserSkills.FirstOrDefault(x => x.UserSkillId == skillsDetailBO.UserSkillId && x.SkillId == skillsDetailBO.SkillId && x.IsActive && x.UserId == userId);
                        if (existingData != null)
                        {
                            if (skillsDetailBO.SkillTypeId != 1)
                            {
                                if (existingData.SkillTypeId == 1)
                                {
                                    existingData.MonthsOfExperience = skillsDetailBO.ExperienceMonths;
                                    existingData.ModifiedById = userId;
                                    existingData.ModifiedDate = DateTime.Now;
                                }
                                else
                                {
                                    existingData.SkillLevelId = skillsDetailBO.SkillLevelId;
                                    existingData.MonthsOfExperience = skillsDetailBO.ExperienceMonths;
                                    existingData.ModifiedById = userId;
                                    existingData.ModifiedDate = DateTime.Now;
                                    existingData.SkillTypeId = skillsDetailBO.SkillTypeId;
                                }
                                context.SaveChanges();
                                status = 1;
                            }
                            else
                            {
                                status = 4;
                            }
                        }
                        else
                        {
                            status = 3;
                        }
                    }
                    else
                    {
                        status = 2;
                    }
                }
                else
                {
                    if (skillsDetailBO.SkillId > 0 && skillsDetailBO.SkillLevelId > 0 && skillsDetailBO.ExperienceMonths > 0)
                    {
                        var checkExist = context.UserSkills.FirstOrDefault(x => x.SkillId == skillsDetailBO.SkillId && x.IsActive && x.UserId == userId);
                        if (checkExist == null)
                        {
                            var userSkill = new UserSkill();
                            userSkill.SkillId = skillsDetailBO.SkillId;
                            userSkill.SkillLevelId = skillsDetailBO.SkillLevelId;
                            userSkill.MonthsOfExperience = skillsDetailBO.ExperienceMonths;
                            userSkill.IsActive = true;
                            userSkill.UserId = userId;
                            userSkill.SkillTypeId = skillsDetailBO.SkillTypeId;
                            userSkill.CreatedById = userId;
                            userSkill.CreatedDate = DateTime.Now;
                            context.UserSkills.Add(userSkill);
                            context.SaveChanges();
                            status = 1;
                        }
                        else
                        {
                            status = 2;
                        }

                    }
                    else
                    {
                        status = 0;
                    }
                }
                return status;
            }
        }

        /// <summary>
        /// Get User Skills
        /// </summary>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<SkillsDetailBO> GetUserSkills(string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            if (userId > 0)
            {
                var skillsResult = _dbContext.UserSkills.Where(x => x.UserId == userId && x.IsActive).ToList();
                if (skillsResult.Any())
                {
                    var skillsDetailList = skillsResult.Select(item => new SkillsDetailBO
                    {
                        UserSkillId = item.UserSkillId,
                        SkillName = item.Skill.SkillName,
                        SkillLevelName = item.SkillLevel.SkillLevelName,
                        ExperienceMonths = item.MonthsOfExperience,
                        SkillTypeId = item.SkillTypeId,
                        SkillTypeName = item.SkillType.SkillTypeName,
                        SkillTypeSequence = item.SkillType.Sequence,
                        UpdatedOn = item.ModifiedDate.HasValue ? item.ModifiedDate.Value.ToString("dd-MMM-yyyy") : item.CreatedDate.ToString("dd-MMM-yyyy"),
                        Sequence = item.SkillLevel.Sequence
                    }).OrderBy(x => x.SkillTypeSequence).ToList();
                    return skillsDetailList;
                }
                else
                    return new List<SkillsDetailBO>();
            }
            return new List<SkillsDetailBO>();
        }

        /// <summary>
        ///  Get User Skills By Skill Detail Id
        /// </summary>
        /// <param name="userSkillId"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public SkillsDetailBO GetUserSkillsBySkillId(int userSkillId, string userAbrhs)
        {
            SkillsDetailBO skillsDetail = new SkillsDetailBO();
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            if (userId > 0)
            {
                var skillsResult = _dbContext.UserSkills.Where(x => x.UserId == userId && x.IsActive && x.UserSkillId == userSkillId).FirstOrDefault();
                if (skillsResult != null)
                {
                    skillsDetail.UserSkillId = skillsResult.UserSkillId;
                    skillsDetail.SkillId = skillsResult.SkillId;
                    skillsDetail.SkillLevelId = skillsResult.SkillLevelId;
                    skillsDetail.SkillTypeId = skillsResult.SkillTypeId;
                    skillsDetail.ExperienceMonths = skillsResult.MonthsOfExperience;
                    return skillsDetail;
                }
            }
            return new SkillsDetailBO();
        }

        /// <summary>
        /// Delete Skills
        /// </summary>
        /// <param name="userSkillId"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public int DeleteSkills(int userSkillId, string userAbrhs)
        {
            SkillsDetailBO skillsDetail = new SkillsDetailBO();
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            if (userId > 0)
            {
                var skillsResult = _dbContext.UserSkills.Where(x => x.UserId == userId && x.IsActive && x.UserSkillId == userSkillId).FirstOrDefault();
                if (skillsResult != null && skillsResult.SkillTypeId != 1)
                {
                    skillsResult.IsActive = false;
                    skillsResult.ModifiedById = userId;
                    skillsResult.ModifiedDate = DateTime.Now;
                    _dbContext.SaveChanges();
                    return 1;
                }
            }
            return 0;
        }

        #endregion

        #region User Profile

        public EmployeeProfileBO FetchDataForEmployeeProfile(string emailId, string UserAbrhs)
        {
            var employeeId = 0;
            //Int32.TryParse(CryptoHelper.Decrypt(EmpAbrhs), out employeeId);
            var emailAbrhs = CryptoHelper.Encrypt(emailId);
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(UserAbrhs), out userId);

            EmployeeProfileBO employeeProfile = new EmployeeProfileBO();
            var data = _dbContext.vwAllUsers.FirstOrDefault(t => t.EmailId == emailAbrhs && t.IsActive);
            if (data != null)
            {
                employeeId = data.UserId;
                var userDetail = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == employeeId);
                employeeProfile.Extension = userDetail.ExtensionNumber;
                employeeProfile.SeatNo = userDetail.WorkStationNo == null ? "NA" : userDetail.WorkStationNo;

                employeeProfile.EmployeeName = data.EmployeeName;
                employeeProfile.EmailId = CryptoHelper.Decrypt(data.EmailId);
                employeeProfile.Designation = data.Designation;
                employeeProfile.MobileNumber = CryptoHelper.Decrypt(data.MobileNumber);
                employeeProfile.Role = data.Role;
                employeeProfile.ReportingManager = data.ReportingManagerName;
                employeeProfile.DOJ = data.JoiningDate.Value.ToString("dd-MMM-yyyy");
                employeeProfile.EmployeeCode = data.EmployeeId;
                if (!string.IsNullOrEmpty(data.Department) && !string.IsNullOrEmpty(data.Team))
                {
                    employeeProfile.Department = !string.IsNullOrEmpty(data.Department) ? data.Department : "NA";
                    employeeProfile.Team = !string.IsNullOrEmpty(data.Team) ? data.Team : "NA";
                }
                else
                {
                    employeeProfile.Department = "Not Mapped";
                    employeeProfile.Team = "Not Mapped";
                }
                employeeProfile.ImageName = data.ImagePath;
            }
            var skills = _dbContext.UserSkills.Where(x => x.UserId == employeeId && x.IsActive).ToList();
            List<Skills> skillList = new List<Skills>();
            if (skills.Any())
            {
                foreach (var item in skills)
                {
                    Skills skill = new Skills();
                    skill.SkillName = item.Skill.SkillName;
                    skillList.Add(skill);
                }
            }
            employeeProfile.SkillList = skillList;

            // Logging
            SaveUserLogs(ActivityMessages.ViewingProfile, userId, employeeId);

            return employeeProfile;
        }

        public EmployeeUpdateProfileBO FetchDataForUpdateProfile(string UserAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(UserAbrhs), out userId);

            EmployeeUpdateProfileBO employeeProfile = new EmployeeUpdateProfileBO();
            var data = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == userId);
            var addressDetails = _dbContext.UserAddressDetails.FirstOrDefault(x => x.UserId == userId && x.IsActive && !x.IsAddressPermanent);
            var dataForExt = (from t in _dbContext.ChangeExtnRequests where t.CreatedById == userId orderby t.RequestId descending select t).FirstOrDefault();
            if (data != null)
            {
                employeeProfile.MobileNumber = CryptoHelper.Decrypt(data.MobileNumber);
                employeeProfile.Extension = data.ExtensionNumber;
                employeeProfile.ImageName = data.ImagePath;
                employeeProfile.IsVerified = (dataForExt != null) ? dataForExt.IsActionPerformed : true;
            }
            if (addressDetails != null)
            {
                employeeProfile.CountryId = addressDetails.CountryId;
                employeeProfile.StateId = addressDetails.StateId;
                employeeProfile.CityId = addressDetails.CityId;
                employeeProfile.Address = CryptoHelper.Decrypt(addressDetails.Address);
                employeeProfile.PinCode = CryptoHelper.Decrypt(addressDetails.PinCode);
            }

            // Logging
            SaveUserLogs(ActivityMessages.UpdateProfile, userId, userId);

            return employeeProfile;
        }

        public int UpdateUserProfile(EmployeeUpdateProfileBO employeeUpdateProfileBO)
        {
            var result = 0;
            var newFileName = "";
            var imageName = Guid.NewGuid();
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(employeeUpdateProfileBO.UserAbrhs), out userId);
            if (employeeUpdateProfileBO.base64FormData != null)
            {
                var filedetails = employeeUpdateProfileBO.base64FormData.Split(',')[0];
                var imageExtn = filedetails.Replace("data:image/", "").Replace(";base64", "");
                newFileName = imageName.ToString() + "." + imageExtn;
                var tempBasePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["TempProfileImageUploadPath"] + newFileName;
                byte[] decodedByteArray = Convert.FromBase64String(employeeUpdateProfileBO.base64FormData.Split(',')[1]);
                File.WriteAllBytes(tempBasePath, decodedByteArray);
            }

            var reqUrl = HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + "/";

#if !DEBUG
            reqUrl = (new UriBuilder(reqUrl) { Port = -1 }).ToString();
#endif

            var data = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == userId);
            //var addressDetails = _dbContext.UserAddressDetails.FirstOrDefault(x => x.UserId == userId && x.IsActive && !x.IsAddressPermanent);
            if (data != null)
            {
                if (employeeUpdateProfileBO.MobileNumber != null || employeeUpdateProfileBO.Extension != null || employeeUpdateProfileBO.base64FormData != null)
                {
                    //for Applicant Details.
                    var userDetail = _dbContext.UserDetails.FirstOrDefault(f => f.UserId == userId);
                    //for old extention and seat no details.
                    var EmployeeDetails = _dbContext.UserDetails.FirstOrDefault(f => f.UserId == userId);
                    var empDetails = _dbContext.Users.FirstOrDefault(f => f.UserId == userId);
                    var oldMobileNo = CryptoHelper.Decrypt(userDetail.MobileNumber);
                    var IsMobileNumberChange = (employeeUpdateProfileBO.MobileNumber != oldMobileNo);
                    var IsExtnChange = (EmployeeDetails.ExtensionNumber != employeeUpdateProfileBO.Extension);
                    var IsImageChange = (employeeUpdateProfileBO.base64FormData != null);
                    var changeContactDetail = new Model.ChangeExtnRequest();
                    changeContactDetail.OldImage = userDetail.ImagePath;
                    changeContactDetail.OldMobileNo = userDetail.MobileNumber;
                    if (IsMobileNumberChange || IsExtnChange || IsImageChange)
                    {

                        if (employeeUpdateProfileBO.MobileNumber != null && IsMobileNumberChange)
                        {

                            changeContactDetail.NewMobileNo = CryptoHelper.Encrypt(employeeUpdateProfileBO.MobileNumber);
                        }
                        if (employeeUpdateProfileBO.Extension != null && IsExtnChange)
                        {
                            changeContactDetail.NewExtnNo = employeeUpdateProfileBO.Extension;
                        }
                        if (employeeUpdateProfileBO.base64FormData != null && IsImageChange)
                        {

                            changeContactDetail.NewImage = newFileName;
                        }

                        changeContactDetail.IsActionPerformed = false;
                        changeContactDetail.IsVerified = false;
                        changeContactDetail.CreatedById = userId;
                        changeContactDetail.CreatedDate = DateTime.Now;
                        _dbContext.ChangeExtnRequests.Add(changeContactDetail);
                        _dbContext.SaveChanges();

                        if (changeContactDetail.RequestId > 0)
                        {

                            // Send Email to HR.
                            var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "Change Contact Details" && f.IsActive && !f.IsDeleted);
                            if (emailTemplate != null)
                            {
                                // ApplicantName
                                var ApplicantName = (userDetail.FirstName == "" ? "" : userDetail.FirstName) + " " + (userDetail.LastName == "" ? "" : userDetail.LastName);

                                //for HR details.
                                var hrEmailId = ConfigurationManager.AppSettings["HrEmailId"];
                                var encryptedEmailId = CryptoHelper.Encrypt(hrEmailId);
                                var hrDetail = _dbContext.UserDetails.FirstOrDefault(f => f.EmailId == encryptedEmailId);
                                if (hrDetail != null)
                                {
                                    var hrID = hrDetail.UserId;
                                    //security key and URL for accept and reject request.
                                    var dataForQueryString = userId + "&" + hrID + "&" + changeContactDetail.RequestId;
                                    var key = CryptoHelper.Encrypt(dataForQueryString.ToString());
                                    var AppoveRequestUrl = employeeUpdateProfileBO.AppLinkUrl + "?for=appr&encodedData=" + key + "";
                                    var CancleRequestUrl = employeeUpdateProfileBO.AppLinkUrl + "?for=cancle&encodedData=" + key + "";

                                    var body = emailTemplate.Template;
                                    var table = "<table border='0' cellpadding='4' style='color:#000000;font:normal 11px arial,sans-serif;border:1px solid #abb2b7;width:100%'><thead><tr><th style='color:#434d52;font:bold 13px arial,sans-serif;white-space:nowrap;background-color:#ebeff1;border:1px solid #abb2b7;text-align:center'>Change Request For</th><th style='color:#434d52;font:bold 13px arial,sans-serif;white-space:nowrap;background-color:#ebeff1;border:1px solid #abb2b7;text-align:center'>Old Record</th><th style='color:#434d52;font:bold 13px arial,sans-serif;white-space:nowrap;background-color:#ebeff1;border:1px solid #abb2b7;text-align:center'>New Record</th></tr></thead><tbody>";
                                    if (!String.IsNullOrEmpty(employeeUpdateProfileBO.MobileNumber) && IsMobileNumberChange)
                                    {
                                        table = table + "<tr><td style='border:1px solid #abb2b7;'>&nbsp;Mobile No</td><td style='border:1px solid #abb2b7;'>&nbsp;" + oldMobileNo + "</td><td style='border:1px solid #abb2b7;'>&nbsp;" + employeeUpdateProfileBO.MobileNumber + "</td></tr>";
                                    }
                                    if (!String.IsNullOrEmpty(employeeUpdateProfileBO.Extension) && IsExtnChange)
                                    {
                                        table = table + "<tr><td style='border:1px solid #abb2b7;'>&nbsp;Extn. No</td><td style='border:1px solid #abb2b7;'>&nbsp;" + EmployeeDetails.ExtensionNumber + "</td><td style='border:1px solid #abb2b7;'>&nbsp;" + employeeUpdateProfileBO.Extension + "</td></tr>";
                                    }
                                    if (!String.IsNullOrEmpty(employeeUpdateProfileBO.base64FormData) && IsImageChange)
                                    {
                                        var oldImageLink = reqUrl + ConfigurationManager.AppSettings["ProfileImageUploadPath"].Replace("\\", "/") + EmployeeDetails.ImagePath;
                                        var newImageUrl = reqUrl + ConfigurationManager.AppSettings["TempProfileImageUploadPath"].Replace("\\", "/") + newFileName;

                                        //var oldImageBasePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["ProfileImageUploadPath"] + EmployeeDetails.ImagePath;

                                        //var oldImageLink = "";
                                        //if (File.Exists(oldImageBasePath))
                                        //{
                                        //    byte[] imageInByte = File.ReadAllBytes(oldImageBasePath);

                                        //    var oldImageBase64Data = Convert.ToBase64String(imageInByte);

                                        //    var fileExtension = EmployeeDetails.ImagePath.Split('.')[1];
                                        //    oldImageLink = CommonUtility.GetBase64MimeType(fileExtension) + "," + oldImageBase64Data;

                                        //}
                                        table = table + string.Format("<tr><td style='border:1px solid #abb2b7;'>&nbsp;Image</td><td style='border:1px solid #abb2b7;'>&nbsp; <img alt='' title='' width='150px' src='{0}' /></td><td style='border:1px solid #abb2b7;'>&nbsp;<img alt='' title='' width='150px' src='{1}' /></td></tr>", oldImageLink, newImageUrl);

                                    }
                                    table = table + "</tbody></table>";
                                    body = body.Replace("[DATA]", table);
                                    body = body.Replace("[TITLE]", "Change Request : Contact Detail");
                                    body = body.Replace("[NAME],", hrDetail.FirstName);
                                    body = body.Replace("[APPLICANT]", ApplicantName);
                                    body = body.Replace("[LINKAPPROVE]", AppoveRequestUrl);
                                    body = body.Replace("[LINKREJECT]", CancleRequestUrl);
                                    Utilities.EmailHelper.SendEmailWithDefaultParameter("Change Contact Details", body, true, true, hrEmailId, null, null, null);
                                }
                            }
                        }

                        result = 1;
                    }
                    else
                        result = 2;


                }

            }
            else
            {
                result = 0;
            }

            // Logging
            SaveUserLogs(ActivityMessages.UpdateProfile, userId, userId);

            return result;
        }

        public int UpdateUserAddress(EmployeeUpdateProfileBO employeeUpdateProfileBO)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(employeeUpdateProfileBO.UserAbrhs), out userId);
            var addressDetails = _dbContext.UserAddressDetails.FirstOrDefault(x => x.UserId == userId && x.IsActive && !x.IsAddressPermanent);
            //Update Present Address.
            if (addressDetails != null)
                addressDetails.IsActive = false;

            var presentAddress = new Model.UserAddressDetail();
            presentAddress.CountryId = employeeUpdateProfileBO.CountryId;
            presentAddress.StateId = employeeUpdateProfileBO.StateId;
            presentAddress.CityId = employeeUpdateProfileBO.CityId;
            presentAddress.Address = CryptoHelper.Encrypt(employeeUpdateProfileBO.Address);
            presentAddress.PinCode = CryptoHelper.Encrypt(employeeUpdateProfileBO.PinCode);
            presentAddress.IsActive = true;
            presentAddress.UserId = userId;
            presentAddress.IsAddressPermanent = false;
            presentAddress.LastModifiedDate = DateTime.Now;
            presentAddress.LastModifiedBy = userId;

            _dbContext.UserAddressDetails.Add(presentAddress);
            _dbContext.SaveChanges();
            SaveUserLogs(ActivityMessages.UpdateProfile, userId, userId);
            return 1;

        }

        #endregion

        #region UserLogging Insert data

        public void SaveUserLogs(string Activity, int VisitedByUserId, int VisitedForUserId)
        {
            if (Activity != null && VisitedByUserId > 0)
            {
                UserActivity userActivity = new UserActivity();
                userActivity.Activity = Activity;
                userActivity.ActivityDate = DateTime.Now;
                userActivity.VisitedByUserId = VisitedByUserId;
                userActivity.VisitedForUserId = VisitedForUserId;
                _dbContext.UserActivities.Add(userActivity);
                _dbContext.SaveChanges();
            }
        }

        #endregion

        #region Password Reset

        /// <summary>
        /// 
        /// </summary>
        /// <param name="userName">userName</param>
        /// <param name="redirectionLink">redirectionLink</param>
        /// <param name="clientIP">clientIP</param>
        /// <returns>1: Unauthorised user, 2: Account is currently locked, 3: Error occured, 4: Success and password reset link sent to official email</returns>
        public int GenerateCodeForResetPassword(string userName, string redirectionLink, string clientIP) //1: user does not exists, 2:user account is locked, 3: error occured, 4: success
        {

            var eUserName = CryptoHelper.Encrypt(userName.ToLower());
            var userEmail = _dbContext.UserDetails.FirstOrDefault(x => x.EmailId == eUserName && x.TerminateDate == null);
            var userEmailId = 0;
            if (userEmail != null)
                userEmailId = userEmail.UserId;

            var checkIfUserExists = _dbContext.Users.FirstOrDefault(f => (f.UserName == eUserName || f.UserId == userEmailId) && !f.IsSuspended && f.IsActive);
            if (checkIfUserExists != null)
            {
                if (checkIfUserExists.IsLocked == true)
                    return 2;
                else
                {
                    var passwordResetCode = Utilities.CommonUtility.GenerateRandomCode(10);

                    //var link = ConfigurationManager.AppSettings["PasswordResetUrl"] + passwordResetCode;
                    var link = redirectionLink + passwordResetCode;

                    var userDetail = _dbContext.UserDetails.FirstOrDefault(f => f.UserId == checkIfUserExists.UserId);
                    var emailId = CryptoHelper.Decrypt(userDetail.EmailId);

                    checkIfUserExists.PasswordResetCode = passwordResetCode;
                    checkIfUserExists.IsPasswordResetCodeExpired = false;
                    _dbContext.SaveChanges();

                    //EmailHelper.SendEmailWithDefaultParameter("Link for password reset", "Dear user, you can use the following link to reset you MIS account password. " + link, true, true, emailId, null, null, null);
                    var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "Reset Password" && f.IsActive && !f.IsDeleted);
                    if (emailTemplate != null)
                    {
                        //var body = emailTemplate.Template.Replace("[Name]", userDetail.FirstName).Replace("[Password]", link);
                        var body = emailTemplate.Template
                            .Replace("[NAME]", userDetail.FirstName)
                            .Replace("[LINK]", link)
                            .Replace("[IP]", clientIP);


                        Utilities.EmailHelper.SendEmailWithDefaultParameter("Password reset for MIS", body, true, true, emailId, null, null, null);
                    }
                    return 4;
                }
            }
            return 1;
        }

        public string ValidateQueryStringForPasswordReset(string passwordResetCode)
        {
            var userDetail = _dbContext.Users.FirstOrDefault(f => f.PasswordResetCode == passwordResetCode && f.IsPasswordResetCodeExpired == false);
            if (userDetail != null)
                return CryptoHelper.Decrypt(userDetail.UserName);
            return null;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="passwordResetCode"></param>
        /// <param name="userName"></param>
        /// <param name="password"></param>
        /// <returns>1: success, 2: unauthorized user, 3: same password, 0: error</returns>
        public int ResetPassword(string passwordResetCode, string userName, string password)
        {
            var eUserName = CryptoHelper.Encrypt(userName.ToLower());
            var userDetail = _dbContext.UserDetails.FirstOrDefault(x => x.EmailId == eUserName && x.TerminateDate == null);
            var userId = 0;
            if (userDetail != null)
                userId = userDetail.UserId;

            var checkUserValid = _dbContext.Users.FirstOrDefault(f => (f.UserName == eUserName || f.UserId == userId) && f.IsActive && f.PasswordResetCode == passwordResetCode && f.IsPasswordResetCodeExpired == false);
            if (checkUserValid != null)
            {
                if (CryptoHelper.VerifyPassword(checkUserValid.Password, password)) //check if old password and new password is same
                    return 3;

                checkUserValid.Password = CryptoHelper.EncryptTDC(password);
                checkUserValid.IsPasswordResetRequired = false;
                checkUserValid.IsSuspended = false;
                checkUserValid.LoginDate = DateTime.UtcNow;
                checkUserValid.LastPasswordChanged = DateTime.UtcNow;
                checkUserValid.LastModifiedDate = DateTime.UtcNow;
                checkUserValid.LastModifiedBy = checkUserValid.UserId;
                checkUserValid.IsPasswordResetCodeExpired = true;

                _dbContext.SaveChanges();
                return 1;
            }
            return 2;
        }

        #endregion

        /// <summary>
        /// Method to change user password
        /// </summary>
        /// <param name="userAbrhs">userAbrhs</param>
        /// <param name="oldPassword">oldPassword</param>
        /// <param name="newPassword">newPassword</param>
        /// <returns>1: success, 2: unauthorized user, 3: invalid current password, 4: same password , 0 :error</returns>
        public int ChangePassword(string userAbrhs, string oldPassword, string newPassword)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var userData = _dbContext.Users.FirstOrDefault(x => x.IsActive && x.UserId == userId);
            if (userData != null)
            {
                var isCorrectPassword = CryptoHelper.VerifyPassword(userData.Password, oldPassword);
                if (!isCorrectPassword)
                {
                    return 3;
                }
                else if (CryptoHelper.VerifyPassword(userData.Password, newPassword))
                {
                    return 4;
                }
                else if (isCorrectPassword)
                {
                    userData.Password = CryptoHelper.EncryptTDC(newPassword);
                    userData.IsPasswordResetRequired = false;
                    userData.LastPasswordChanged = DateTime.UtcNow;
                    userData.IsPasswordResetCodeExpired = true;
                    _dbContext.SaveChanges();
                    return 1;
                }
                else
                {
                    return 0;
                }
            }
            return 2;
        }

        #region help document

        public string FetchHelpDocumentInformation(string basePath)
        {
            var fileName = "MISHelpDocument.pdf";
            var finalBasePath = basePath + fileName;
            if (!File.Exists(finalBasePath))
                return string.Empty;

            byte[] formInByte = File.ReadAllBytes(finalBasePath);
            var formInBase64String = Convert.ToBase64String(formInByte);

            var fileExtension = fileName.Split('.')[1];
            var link = "";
            link = CommonUtility.GetBase64MimeType(fileExtension) + "," + formInBase64String;
            return link;
        }

        #endregion

        #region Wishes

        public int WishEmployees(string wishTo, int wishType, string message, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            var wishToUserId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(wishTo), out wishToUserId);

            if (userId > 0 && wishToUserId > 0)
            {
                EmployeeWish modal = new EmployeeWish();
                modal.WishTypeId = wishType;
                modal.WishTo = wishToUserId;
                modal.Message = message;
                modal.CreatedBy = userId;
                modal.CreatedDate = DateTime.Now;
                _dbContext.EmployeeWishes.Add(modal);
                _dbContext.SaveChanges();
            }
            var existingsenderData = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == userId);
            var existingReceiverData = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == wishToUserId);
            var receiverFirstName = existingReceiverData.FirstName;
            var receiverLastName = existingReceiverData.LastName;
            var senderFirstName = existingsenderData.FirstName;
            var senderLastName = existingsenderData.LastName;
            var subject = "";
            if (wishType == 1)
                subject = "Happy Birthday : " + receiverFirstName + ' ' + receiverLastName + " From : " + senderFirstName + ' ' + senderLastName;
            if (wishType == 2)
                subject = "Happy Anniversary : " + receiverFirstName + ' ' + receiverLastName + " From : " + senderFirstName + ' ' + senderLastName;

            var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == EmailTemplates.Wish && f.IsActive && !f.IsDeleted);
            int t = 0;

            if (emailTemplate != null && existingsenderData != null && existingReceiverData != null)
            {
                if (wishType == 1)
                {
                    var body = emailTemplate.Template
                            .Replace("[RECEIVERNAME]", receiverFirstName.ToTitleCase())
                            .Replace("[MSG]", message)
                            .Replace("[SENDERNAME]", senderFirstName.ToTitleCase() + " " + senderLastName.ToTitleCase())
                            .Replace("[HEADING]", "Birthday Wishes");
                    // SEND MAIL 
                    Utilities.EmailHelper.SendEmailWithDefaultParameter(subject, body, true, true, CryptoHelper.Decrypt(existingReceiverData.EmailId), null, null, null);
                    _dbContext.SaveChanges();
                    t = 1;
                }
                else
                {
                    var body = emailTemplate.Template
                          .Replace("[RECEIVERNAME]", receiverFirstName.ToTitleCase())
                          .Replace("[MSG]", message)
                          .Replace("[SENDERNAME]", senderFirstName.ToTitleCase() + " " + senderLastName.ToTitleCase())
                          .Replace("[HEADING]", "Anniversary Wishes");
                    // SEND MAIL 
                    Utilities.EmailHelper.SendEmailWithDefaultParameter(subject, body, true, true, CryptoHelper.Decrypt(existingReceiverData.EmailId), null, null, null);
                    _dbContext.SaveChanges();
                    t = 2;
                }
            }

            return t;
        }
        #endregion

        #region Change Contact Details

        public int ApproveChangeContactDetailRequest(string ActionData, string Reason)
        {
            try
            {
                using (var context = new MISEntities())
                {
                    var realdata = CryptoHelper.Decrypt(ActionData);
                    string[] substrings = realdata.Split('&');
                    int userId = Convert.ToInt32(substrings[0]);
                    int hrID = Convert.ToInt32(substrings[1]);
                    int RequestId = Convert.ToInt32(substrings[2]);

                    var userDetailData = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == userId);

                    var result = context.spUpdateContactDetails(RequestId, userId, hrID).FirstOrDefault().Value;
                    if (result == 3)
                    {


                        var tempImageData = _dbContext.ChangeExtnRequests.FirstOrDefault(x => x.RequestId == RequestId);

                        var tempImageBasePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["TempProfileImageUploadPath"] + tempImageData.NewImage;
                        var newImageLink = "";

                        if (File.Exists(tempImageBasePath))
                        {

                            byte[] imageInByte = File.ReadAllBytes(tempImageBasePath);

                            var newImageBase64Data = Convert.ToBase64String(imageInByte);

                            var fileExtension = tempImageData.NewImage.Split('.')[1];
                            newImageLink = CommonUtility.GetBase64MimeType(fileExtension) + "," + newImageBase64Data;

                            var NewBasePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["ProfileImageUploadPath"] + tempImageData.NewImage;
                            byte[] decodedByteArray = Convert.FromBase64String(newImageLink.Split(',')[1]);
                            File.WriteAllBytes(NewBasePath, decodedByteArray);

                            File.Delete(tempImageBasePath);


                        }
                    }
                    return result;
                }
            }
            catch (Exception e)
            {
                return 0;
            }
        }

        public int RejectChangeContactDetailRequest(string ActionData, string Reason)
        {
            try
            {
                using (var context = new MISEntities())
                {
                    var realdata = CryptoHelper.Decrypt(ActionData);
                    string[] substrings = realdata.Split('&');
                    int userId = Convert.ToInt32(substrings[0]);
                    int hrID = Convert.ToInt32(substrings[1]);
                    int RequestId = Convert.ToInt32(substrings[2]);

                    var result = context.Proc_RejectContactUpdateRequest(Reason, RequestId, hrID).FirstOrDefault().Value;
                    if (result > 0)
                    {
                        var emailTemplate = context.EmailTemplates.FirstOrDefault(f => f.TemplateName == "Reject Contact Details Updation" && f.IsActive && !f.IsDeleted);
                        if (emailTemplate != null)
                        {
                            var userDetail = context.UserDetails.FirstOrDefault(f => f.UserId == userId);
                            //var EmailId = CryptoHelper.Decrypt(userDetail.EmailId);
                            var EmailId = CryptoHelper.Decrypt(userDetail.EmailId);
                            var body = emailTemplate.Template;
                            body = body.Replace("##RequesterName##", userDetail.FirstName);
                            body = body.Replace("##Reason##", Reason);
                            Utilities.EmailHelper.SendEmailWithDefaultParameter("Request Denied : For contact details updation", body, true, true, EmailId, null, null, null);
                        }
                    }
                    return result;
                }
            }
            catch (Exception e)
            {
                return 0;
            }
        }

        #endregion


        #region Organization Structure

        /// <summary>
        /// Method to fetch organization structure
        /// </summary>
        /// <param name="userAbrhs"></param>
        /// <param name="parentId"></param>
        /// <returns>OrganizationStructureBO List</returns>
        public List<OrganizationStructureBO> FetchOrganizationStructure(string userAbrhs, int parentId)
        {
            var loginUserId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out loginUserId);

            var reqUrl = HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + "/";

#if !DEBUG
            reqUrl = (new UriBuilder(reqUrl) { Port = -1 }).ToString();
            //Uri uri = HttpContext.Current.Request.Url;
            //var url = uri.Scheme + Uri.SchemeDelimiter + uri.Host + ":" + uri.Port;
            //var url = uri.Scheme + Uri.SchemeDelimiter + uri.Host;
#endif
            var baseImagePath = reqUrl + ConfigurationManager.AppSettings["ImagePath"];
            var profileImagePath = reqUrl + ConfigurationManager.AppSettings["ProfileImageUploadPath"].Replace("\\", "/");
            //var baseImagePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["ImagePath"];
            //var profileImagePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["ProfileImageUploadPath"];
            //var uri = new Uri(new Uri(reqUrl), ConfigurationManager.AppSettings["ProfileImageUploadPath"]);

            var maleImagePath = baseImagePath + "male-employee.png";
            var femaleImagePath = baseImagePath + "female-employee.png";
            var maleStaffImagePath = baseImagePath + "male-staff.png";
            var femaleStaffImagePath = baseImagePath + "female-staff.png";

            var orgData = _dbContext.Proc_FetchUserHierarchy(loginUserId, parentId).ToList();
            //var orgStructure = new List<OrganizationStructureBO>();
            //foreach (var x in orgData)
            //{
            //    var data = new OrganizationStructureBO
            //    {
            //        Id = x.Id.HasValue ? x.Id.Value : 0,
            //        ParentId = x.ParentId.HasValue ? x.ParentId.Value : 0,
            //        Name = !string.IsNullOrEmpty(x.Name) ? x.Name : "",
            //        Designation = x.Designation,
            //        ImagePath = (!string.IsNullOrEmpty(x.ImagePath) ? (profileImagePath + x.ImagePath) : (x.IsSupportingStaff.Value == true ? ((!string.IsNullOrEmpty(x.Gender) ? x.Gender.ToLower() : "") == "female" ? femaleStaffImagePath : maleStaffImagePath) : ((!string.IsNullOrEmpty(x.Gender) ? x.Gender.ToLower() : "") == "female" ? femaleImagePath : maleImagePath)))
            //    };
            //    orgStructure.Add(data);
            //}

            var buildVersion = GlobalServices.GetBuildVersion();
            var orgStructure = orgData.Select(x => new OrganizationStructureBO
            {
                Id = x.Id.HasValue ? x.Id.Value : 0,
                ParentId = x.ParentId.HasValue ? x.ParentId.Value : 0,
                Name = !string.IsNullOrEmpty(x.Name) ? x.Name : "",
                Designation = x.Designation,
                ImagePath = string.Format("{0}?v={1}", (!string.IsNullOrEmpty(x.ImagePath) ? (profileImagePath + x.ImagePath) : (x.IsSupportingStaff.Value == true ?
                            ((!string.IsNullOrEmpty(x.Gender) ? x.Gender.ToLower() : "") == "female" ? femaleStaffImagePath : maleStaffImagePath) :
                            ((!string.IsNullOrEmpty(x.Gender) ? x.Gender.ToLower() : "") == "female" ? femaleImagePath : maleImagePath))), buildVersion)
                //ParentName = x.ParentName,
                //IsSupportingStaff = x.IsSupportingStaff,
                //RM = x.RM,
                //PM = x.PM,
                //Gender = x.Gender,
                //MobileNumber = CryptoHelper.Decrypt(x.MobileNumber),
                //EmailId = CryptoHelper.Decrypt(x.EmailId),
                //EmployeeId = x.EmployeeId,
            }).OrderBy(x => x.Name); //.OrderBy(x => x.ParentName).ThenBy(x => x.Name);

            return orgStructure.ToList() ?? new List<OrganizationStructureBO>();
        }

        #endregion

        #region Cab Request
        public List<CabRequestBO> GetCabRequestDetails(string userAbrhs, int Month, int Year)
        {
            var employeeId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out employeeId);
            var data = _dbContext.Proc_GetCabRequestDetail(employeeId, Month, Year);
            var cab = data.Select(s => new CabRequestBO
            {
                CabRequestId = s.CabRequestId,
                Date = s.Date.ToString("MM/dd/yyyy", CultureInfo.InvariantCulture),
                DateText = s.Date.ToString("dd MMM yyyy", CultureInfo.InvariantCulture) + " " + s.Shift,
                Status = s.Status,
                ShiftName = s.Shift,
                ShiftId = s.ShiftId,
                CabRouteId = s.RouteNo,
                LocationId = s.RouteLocationId,
                LocationDetail = s.LocationDetail,
                LocationName = s.RouteLocation,
                CompanyLocationId = s.CompanyLocationId,
                ServiceType = s.ServiceType,
                ServiceTypeId = s.ServiceTypeId,
                ApproverName = s.Approver,
                EmpContactNo = s.EmpContactNo,
                StatusCode = s.StatusCode
            }).ToList();

            return cab ?? new List<CabRequestBO>();
        }

        public int EditCabRequest(CabRequestBO cab)
        {
            int status = 0;
            var employeeId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(cab.EmployeeAbrhs), out employeeId);
            var data = _dbContext.CabRequests.FirstOrDefault(x => x.CabRequestId == cab.CabRequestId);
            data.CabShiftId = cab.ShiftId;
            data.LastModifiedBy = employeeId;
            data.LastModifiedDate = DateTime.Now;
            status = _dbContext.SaveChanges();
            return status;
        }

        public int TakeActionOnCabRequestAnonymous(string encodedData, string actionCode, string remarks, string forScreen)
        {
            var realdata = CryptoHelper.Decrypt(encodedData);
            string[] substrings = realdata.Split('&');
            int loginUserId = Convert.ToInt32(substrings[0]);
            int cabRequestId = Convert.ToInt32(substrings[1]);
            string cabRequestIdStr = substrings[1];
            int msg = 0;
            var result = new ObjectParameter("Success", typeof(int));
            _dbContext.Proc_TakeActionOnCabRequestByMGR(cabRequestId, actionCode, remarks, loginUserId, result);
            Int32.TryParse(result.Value.ToString(), out msg);
            if (msg == 1 && actionCode == "RJ")
            {
                SendMailToUserForCabRequest(cabRequestIdStr, remarks, loginUserId);
            }
            return msg;
        }

        public int TakeActionOnCabRequest(CabRequestBO data)
        {
            int msg = 0;
            var result = new ObjectParameter("Success", typeof(int));

            if (data.ForScreen == "USER")
            {
                _dbContext.Proc_TakeActionOnCabRequestByUser(data.CabRequestId, data.StatusCode, data.Remarks, data.LoginUserId, result);
            }
            else if (data.ForScreen == "ADMIN")
            {
                _dbContext.Proc_TakeActionOnCabRequestByAdmin(data.CabRequestId, data.StatusCode, data.Remarks, data.LoginUserId, result);
            }
            else
            {
                _dbContext.Proc_TakeActionOnCabRequestByMGR(data.CabRequestId, data.StatusCode, data.Remarks, data.LoginUserId, result);
            }

            Int32.TryParse(result.Value.ToString(), out msg);

            if (msg == 1 && data.StatusCode == "RJ")
            {
                SendMailToUserForCabRequest(data.CabRequestId.ToString(), data.Remarks, data.LoginUserId);
            }

            return msg;
        }

        public void SendMailToUserForCabRequest(string cabRequestId, string remarks, int loginUserId)
        {
            var CabReqData = _dbContext.Proc_FetchCabInfoByCabRequestId(cabRequestId).FirstOrDefault();
            var loginUserName = "";
            var loginUserData = _dbContext.vwAllUsers.FirstOrDefault(t => t.UserId == loginUserId);
            if (loginUserData != null)
            {
                loginUserName = loginUserData.DisplayName;
            }

            if (CabReqData != null)
            {
                if (CabReqData.EmailId != null)
                {

                    var dateTime = CabReqData.Date + " @ " + CabReqData.Shift;
                    var service = CabReqData.ServiceType;
                    var locationName = service + " Location";
                    var childOneDic = new Dictionary<string, object>
                           {
                               { "Date & Time", dateTime},
                               { locationName,  CabReqData.RouteLocation},
                               {"Remarks", remarks },
                               {"Rejected by", loginUserName}
                           };

                    var tableHtml = childOneDic.ToDataTable().ToHtmlTable(false);
                    var dateNew = CabReqData.Date;
                    var subject = "Cab request rejected";
                    var firstName = CabReqData.EmployeeFirstName;
                    var emailId = CryptoHelper.Decrypt(CabReqData.EmailId);
                    var template = _dbContext.EmailTemplates.FirstOrDefault(e => e.TemplateName == EmailTemplates.ViewCabRequest);
                    var line = "Below mentioned cab request has been rejected. ";
                    var message = line + "<br/><br/>" + tableHtml;

                    if (template != null)
                    {
                        var body = template.Template.Replace("[BGColor]", "#fddddd")
                                                   .Replace("[HEADING]", subject)
                                                   .Replace("[RECEIVERNAME]", firstName)
                                                   .Replace("[MSG]", message);
                        Utilities.EmailHelper.SendEmailWithDefaultParameter(subject, body, true, true, emailId, null, null, null);
                    }
                }
            }
        }

        public List<CabRequestBO> GetDatesForPickAndDrop(CabRequestBO inputs, int userId)
        {
            List<CabRequestBO> dateList = new List<CabRequestBO>();
            var data = _dbContext.Proc_GetDatesForPickAndDrop(userId, inputs.ServiceTypeId, inputs.ForScreen).ToList();
            dateList = data.Select(X => new CabRequestBO
            {
                DateText = X.DateText,
                DateId = X.DateId,
                Date = X.Date.ToString("MM/dd/yyyy", CultureInfo.InvariantCulture)
            }).ToList();

            return dateList ?? new List<CabRequestBO>();

        }

        public List<CabRequestBO> GetShiftDetails(CabRequestBO inputs, int userId)
        {
            var shift = new List<CabRequestBO>();
            var data = _dbContext.Proc_GetCabShift(userId, inputs.Dates, inputs.ServiceTypeIds, inputs.ForScreen).ToList();
            shift = data.Select(X => new CabRequestBO
            {
                ShiftId = X.ShiftId,
                ShiftName = X.ShiftName,
                NewShiftId = X.NewShiftId
            }).ToList();

            return shift ?? new List<CabRequestBO>();
        }

        public List<CabRequestBO> GetShiftForFilter(CabRequestBO inputs, int userId)
        {
            string[] serviceTypeIds = inputs.ServiceTypeIds.Split(',');
            var shift = new List<CabRequestBO>();
            var data = _dbContext.CabShiftMasters.Where(t => serviceTypeIds.Contains(t.ServiceTypeId.ToString()) && t.IsActive).ToList();

            shift = data.Select(X => new CabRequestBO
            {
                ShiftId = X.CabShiftId,
                ShiftName = X.CabShiftName
            }).ToList();

            return shift ?? new List<CabRequestBO>();
        }

        public List<CabRequestBO> GetCabServiceType()
        {
            var service = new List<CabRequestBO>();
            var data = _dbContext.CabServiceTypes.Where(t => t.IsActive).ToList();
            service = data.Select(X => new CabRequestBO
            {
                ServiceTypeId = X.ServiceTypeId,
                ServiceType = X.ServiceType
            }).ToList();
            return service ?? new List<CabRequestBO>();
        }

        public List<CabRequestBO> GetCabRoutes(CabRequestBO inputs)
        {
            var data = _dbContext.Proc_GetRoutesForCab(inputs.CompanyLocationIds, inputs.ServiceTypeIds).ToList();
            var cabRoutes = data.Select(X => new CabRequestBO
            {
                CabRouteId = X.RouteNo,
                CabRoute = X.CabRoute,
                NewCabRouteId = X.NewRouteNo

            }).ToList();

            return cabRoutes ?? new List<CabRequestBO>();
        }

        public List<CabRequestBO> GetCabDropLocations(CabRequestBO inputs)
        {
            var data = _dbContext.Proc_GetRouteLocationForCab(inputs.CompanyLocationId, inputs.CabRouteId, inputs.ServiceTypeId).ToList();
            var dropLocations = data.Select(X => new CabRequestBO
            {
                LocationId = X.CabPDLocationId,
                LocationName = X.RouteLocation
            }).ToList();

            return dropLocations ?? new List<CabRequestBO>();
        }

        public List<CabDriverBO> GetDriverDetails(string locationIds)
        {
            string[] locationId = locationIds.Split(',');

            var data = _dbContext.SupportingStaffMembers.Where(t => t.IsActive == true && t.IsDeleted == false && locationId.Contains(t.LocationId.ToString()) && t.EmployeeName.Contains("Driver")).ToList();
            var staff = data.Select(X => new CabDriverBO
            {
                StaffName = X.EmployeeName,
                StaffId = X.RecordId
            });

            var newstaff = staff.OrderBy(t => t.StaffName).ToList();
            return newstaff ?? new List<CabDriverBO>();
        }

        public string GetDriverContactNo(CabDriverBO inputs)
        {
            var data = _dbContext.SupportingStaffMembers.FirstOrDefault(t => t.RecordId == inputs.StaffId);
            if (data != null)
            {
                return data.MobileNo;
            }
            else
            {
                return "";
            }
        }

        public List<CabDriverBO> GetVehicleDetails(string locationIds)
        {
            string[] locationId = locationIds.Split(',');
            var data = _dbContext.VehicleDetails.Where(t => t.IsActive == true && locationId.Contains(t.LocationId.ToString()));
            var cabInfo = data.Select(X => new CabDriverBO
            {
                VehicleId = X.VehicleId,
                VehicleName = X.Vehicle
            }).ToList();

            return cabInfo ?? new List<CabDriverBO>();
        }

        public CabRequestResponseBO BookOrUpdateCabRequest(CabRequestBO cab)
        {
            int status = 0;
            var message = "";
            var requestId = "";
            var result = new ObjectParameter("Success", typeof(int));
            var msg = new ObjectParameter("Message", typeof(string));
            var newRequet = new ObjectParameter("NewCabRequestId", typeof(string));
            DateTime date = DateTime.ParseExact(cab.Date, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            _dbContext.Proc_BookOrUpdateCabRequest(cab.CabRequestId, cab.LoginUserId, date, cab.ShiftId, cab.CabRouteId, cab.LocationId, cab.LocationDetail, cab.ServiceTypeId, cab.CompanyLocationId, cab.EmpContactNo, result, msg, newRequet);
            Int32.TryParse(result.Value.ToString(), out status);
            requestId = newRequet.Value.ToString();
            message = msg.Value.ToString();
            var todayDate = DateTime.Now.ToString("dd MMM yyyy", CultureInfo.InvariantCulture);
            if (status == 1)
            {
                var CabReqData = _dbContext.Proc_FetchCabInfoByCabRequestId(requestId).FirstOrDefault();
                if (CabReqData != null)
                {
                    var subject = "Cab approval request";
                    var line1 = string.Format("{0} has raised cab request. Please find below the summary and take action on the same latest by {1} 7:00 PM.", CabReqData.EmployeeName, todayDate);
                    var firstName = CabReqData.RMFirstName;
                    var rmId = CabReqData.RMId;

                    //security key and URL for accept and reject request.
                    var dataForQueryString = rmId + "&" + requestId;
                    var key = CryptoHelper.Encrypt(dataForQueryString.ToString());
                    var appoveRequestUrl = cab.ReviewAppUrl + "?for=appr&encodedData=" + key + "";
                    var rejectRequestUrl = cab.ReviewAppUrl + "?for=reject&encodedData=" + key + "";

                    if (CabReqData.RMEmailId != null)
                    {
                        var dateTime = CabReqData.Date + " @ " + CabReqData.Shift;
                        var service = CabReqData.ServiceType;
                        var locationName = service + " Location";

                        var childOneDic = new Dictionary<string, object>
                           {
                               { "Employee Name", CabReqData.EmployeeName},
                               { "Mobile No.", CabReqData.EmpContactNo},
                               { "Date & Time", dateTime},
                               { locationName,  CabReqData.RouteLocation},
                           };

                        var tableHtml = childOneDic.ToDataTable().ToHtmlTable(false);

                        var emailId = CryptoHelper.Decrypt(CabReqData.RMEmailId);
                        var template = _dbContext.EmailTemplates.FirstOrDefault(e => e.TemplateName == EmailTemplates.ReviewCabRequest);
                        if (template != null)
                        {
                            var body = template.Template.Replace("[HEADING]", subject)
                                                       .Replace("[NAME]", firstName)
                                                       .Replace("[MESSAGE]", line1)
                                                       .Replace("[LINKAPPROVE]", appoveRequestUrl)
                                                       .Replace("[LINKREJECT]", rejectRequestUrl)
                                                       .Replace("[DATA]", tableHtml)
                                                       .Replace("[BGColor]", "#ced3f5")
                                                       .Replace("[Color]", "#000000")
                                                       .Replace("[SenderName]", "Team Admin");

                            Utilities.EmailHelper.SendEmailWithDefaultParameter(subject, body, true, true, emailId, null, null, null);
                        }
                    }

                }

            }
            var response = new CabRequestResponseBO
            {
                Result = status,
                Message = message
            };

            return response ?? new CabRequestResponseBO();
        }

        public List<CabRequestBO> GetCabReviewRequest(string UserAbrhs)
        {
            var LoginUserId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(UserAbrhs), out LoginUserId);

            var result = _dbContext.Proc_GetCabReviewRequest(LoginUserId);

            var list = result.Select(s => new CabRequestBO
            {
                CabRequestId = s.CabRequestId,
                EmployeeName = s.EmployeeName,
                Date = s.Date.ToString("MM/dd/yyyy", CultureInfo.InvariantCulture),
                DateText = s.Date.ToString("dd MMM yyyy", CultureInfo.InvariantCulture),
                Status = s.Status,
                StatusCode = s.StatusCode,
                ShiftName = s.Shift,
                ShiftId = s.ShiftId,
                CabRouteId = s.RouteNo,
                LocationId = s.RouteLocationId,
                LocationDetail = s.LocationDetail,
                LocationName = s.RouteLocation,
                CompanyLocationId = s.CompanyLocationId,
                ServiceType = s.ServiceType,
                ServiceTypeId = s.ServiceTypeId,
                EmpContactNo = s.EmpContactNo,
                CreatedDate = s.CreatedDate
            }).ToList();

            return list ?? new List<CabRequestBO>();
        }

        public List<CabRequestBO> GetGroupedCabRequestToFinalize(CabRequestBO data, int loginUserId)
        {

            string routeNos = "";

            if (!String.IsNullOrEmpty(data.CabRouteIds))
            {
                string[] routeData = data.CabRouteIds.Split(',');
                string[] routeIds = new string[routeData.Length];
                for (var r = 0; r < routeData.Length; r++)
                {
                    var routeId = routeData[r].Split('-')[1];
                    routeIds[r] = routeId;
                }
                routeIds = routeIds.Distinct().ToArray();
                routeNos = string.Join(",", routeIds);
            }

            var shiftIdStr = "";

            if (!String.IsNullOrEmpty(data.ShiftIds))
            {
                string[] shiftIds = data.ShiftIds.Split(',');
                string[] newshiftIds = new string[shiftIds.Length];
                for (var s = 0; s < shiftIds.Length; s++)
                {
                    var shiftid = shiftIds[s].Split('-')[1];
                    newshiftIds[s] = shiftid;
                }
                newshiftIds = newshiftIds.Distinct().ToArray();
                shiftIdStr = string.Join(",", newshiftIds);
            }

            var reuslt = _dbContext.Proc_GetGroupedCabRequestToFinalize(data.Dates, data.CompanyLocationIds, data.ServiceTypeIds, shiftIdStr, routeNos, loginUserId).ToList();
            var cab = reuslt.Select(s => new CabRequestBO
            {
                Date = s.Date.ToString("MM/dd/yyyy", CultureInfo.InvariantCulture),
                DateText = s.Date.ToString("dd MMM yyyy", CultureInfo.InvariantCulture),
                ShiftName = s.Shift,
                ShiftId = s.ShiftId,
                CompanyLocationId = s.CompanyLocationId,
                CompanyLocation = s.CompanyLocation,
                ServiceType = s.ServiceType,
                ServiceTypeId = s.ServiceTypeId,
                RequestCount = s.RequestCount,
                CabRouteId = s.RouteNo
            }).ToList();
            return cab ?? new List<CabRequestBO>();
        }

        public List<CabRequestBO> GetGroupedFinalizedCabRequest(CabRequestBO data, int loginUserId)
        {

            string routeNos = "";

            if (!String.IsNullOrEmpty(data.CabRouteIds))
            {
                string[] routeData = data.CabRouteIds.Split(',');
                string[] routeIds = new string[routeData.Length];
                for (var r = 0; r < routeData.Length; r++)
                {
                    var routeId = routeData[r].Split('-')[1];
                    routeIds[r] = routeId;
                }
                routeIds = routeIds.Distinct().ToArray();
                routeNos = string.Join(",", routeIds);
            }
            var shiftIdStr = "";

            if (!String.IsNullOrEmpty(data.ShiftIds))
            {
                string[] shiftIds = data.ShiftIds.Split(',');
                string[] newshiftIds = new string[shiftIds.Length];
                for (var s = 0; s < shiftIds.Length; s++)
                {
                    var shiftid = shiftIds[s].Split('-')[1];
                    newshiftIds[s] = shiftid;
                }
                newshiftIds = newshiftIds.Distinct().ToArray();
                shiftIdStr = string.Join(",", newshiftIds);
            }


            var reuslt = _dbContext.Proc_GetGroupedFinalizedCabRequest(data.Dates, data.CompanyLocationIds, data.ServiceTypeIds, shiftIdStr, routeNos, loginUserId).ToList();
            var cab = reuslt.Select(s => new CabRequestBO
            {
                Date = s.Date.ToString("MM/dd/yyyy", CultureInfo.InvariantCulture),
                DateText = s.Date.ToString("dd MMM yyyy", CultureInfo.InvariantCulture),
                ShiftName = s.Shift,
                ShiftId = s.ShiftId,
                FCRequestId = s.FCRequestId,
                Status = s.Status,
                FinalizedOn = s.FinalizedOn,
                CompanyLocationId = s.LocationId,
                CompanyLocation = s.LocationName,
                ServiceType = s.ServiceType,
                ServiceTypeId = s.ServiceTypeId,
                RequestCount = s.RequestCount.Value,
                StaffName = s.StaffName,
                StaffMobileNo = s.StaffContactNo,
                VehicleName = s.Vehicle,
                CabRouteId = s.RouteNo
            }).ToList();
            return cab ?? new List<CabRequestBO>();
        }

        public List<CabRequestBO> GetCabRequestToFinalize(CabRequestBO data, int loginUserId)
        {
            var reuslt = _dbContext.Proc_GetCabRequestToFinalize(data.Date, data.CompanyLocationId, data.ShiftId, data.CabRouteId, loginUserId).ToList();
            var cab = reuslt.Select(s => new CabRequestBO
            {
                CabRequestId = s.CabRequestId,
                EmployeeName = s.EmployeeName,
                Date = s.Date.ToString("MM/dd/yyyy", CultureInfo.InvariantCulture),
                DateText = s.Date.ToString("dd MMM yyyy", CultureInfo.InvariantCulture),
                Status = s.Status,
                StatusCode = s.StatusCode,
                ShiftName = s.Shift,
                ShiftId = s.ShiftId,
                CabRouteId = s.RouteNo,
                LocationId = s.RouteLocationId,
                LocationDetail = s.LocationDetail,
                LocationName = s.RouteLocation,
                CompanyLocationId = s.CompanyLocationId,
                CompanyLocation = s.CompanyLocation,
                ServiceType = s.ServiceType,
                ServiceTypeId = s.ServiceTypeId,
                EmpContactNo = s.EmpContactNo,
                CreatedDate = s.CreatedDate,
                ReportingManager = s.RMName

            }).ToList();
            return cab ?? new List<CabRequestBO>();
        }

        public List<CabRequestBO> GetFinalizedCabRequest(CabRequestBO data, int loginUserId)
        {
            var reuslt = _dbContext.Proc_GetFinalizedCabRequestDetail(data.FCRequestId, data.ShiftId, data.CompanyLocationId, data.CabRouteId).ToList();
            var cab = reuslt.Select(s => new CabRequestBO
            {
                CabRequestId = s.CabRequestId,
                EmployeeName = s.EmployeeName,
                Date = s.Date.ToString("MM/dd/yyyy", CultureInfo.InvariantCulture),
                DateText = s.Date.ToString("dd MMM yyyy", CultureInfo.InvariantCulture),
                Status = s.Status,
                StatusCode = s.StatusCode,
                ShiftName = s.Shift,
                ShiftId = s.ShiftId,
                CabRouteId = s.RouteNo,
                LocationId = s.RouteLocationId,
                LocationDetail = s.LocationDetail,
                LocationName = s.RouteLocation,
                CompanyLocationId = s.CompanyLocationId,
                CompanyLocation = s.CompanyLocation,
                ServiceType = s.ServiceType,
                ServiceTypeId = s.ServiceTypeId,
                EmpContactNo = s.EmpContactNo,
                CreatedDate = s.CreatedDate,
                ReportingManager = s.RMName
            }).ToList();
            return cab ?? new List<CabRequestBO>();
        }

        public CabRequestResponseBO TakeActionOnCabBulkApprove(string requestIds, string statusCode, string remarks, int loginUserId)
        {
            var statusList = _dbContext.Proc_TakeActionOnCabBulkApprove(requestIds, statusCode, remarks, loginUserId).ToList();
            var beyondCutOffList = statusList.Where(t => t.Msg == 3).Select(t => t.EmployeeName).ToList();
            var actionAteknAlrdy = statusList.Where(t => t.Msg == 2).Select(t => t.EmployeeName).ToList();
            var errorList = statusList.Where(t => t.Msg == 0).Select(t => t.EmployeeName).ToList();
            var successlist = statusList.Where(t => t.Msg == 1).Select(t => t.EmployeeName).ToList();
            var errorCount = errorList.Count + actionAteknAlrdy.Count;

            var message = string.Format("Success Count: {0}, Deadline Crossed Count: {1}, Error Count: {2}", successlist.Count, beyondCutOffList.Count, errorCount);

            CabRequestResponseBO response = new CabRequestResponseBO
            {
                Result = successlist.Count > 0 ? 1 : 0,
                Message = message
            };

            SaveUserLogs(ActivityMessages.BulkTakeActionOnCabRequest, loginUserId, loginUserId);

            return response;
        }

        public int BulkFinalizeCabRequests(int loginUserId, CabDriverBO inputs)
        {
            var data = _dbContext.Proc_FinalizeCabRequest(inputs.CabRequestIds, inputs.StaffId, inputs.StaffName, inputs.MobileNo, inputs.VehicleId, loginUserId).ToList();
            var status = 0;
            var result = data.Where(t => t.FCRequestId > 0 && t.CabRequestId > 0 && t.Success == 1).ToList();
            if (result.Count > 0)
            {
                var line1 = "Your cab request has been approved. Please find below the summary.";
                var fcData = result.FirstOrDefault();
                var cabReqData = _dbContext.Proc_FetchCabRequestDetailByRequestId(fcData.FCRequestId).ToList();
                var excelDataList = _dbContext.Proc_FetchCabRequestDetailByRequestId(fcData.FCRequestId).ToList();
                var cabData = cabReqData.FirstOrDefault();

                if (cabData != null)
                {
                    var service = cabData.ServiceType;
                    var location = cabData.CompanyLocation;
                    var vehicle = cabData.Vehicle;
                    var locationName = service + " Location";
                    var datetime = cabData.DateAndTime;
                    var driver = cabData.Driver;

                    foreach (var rowData in cabReqData)
                    {
                        var childOneDic = new Dictionary<string, object>
                           {
                               { "Date & Time", datetime},
                               { locationName,  cabData.RouteLocation},
                               { "Driver", driver },
                               { "Vehicle No.", vehicle },
                           };

                        var adminContact = ConfigurationManager.AppSettings["AdminContact"];
                        var footer = string.Format("If you have any query, please contact to {0}", adminContact);

                        var tableHtml = childOneDic.ToDataTable().ToHtmlTable(false);
                        var message = line1 + "<br /><br />" + tableHtml;

                        var subject = "Cab request approved";
                        var firstName = rowData.EmployeeFirstName;
                        var emailId = CryptoHelper.Decrypt(rowData.EmailId);
                        var template = _dbContext.EmailTemplates.FirstOrDefault(e => e.TemplateName == EmailTemplates.ViewCabRequest);

                        if (template != null && emailId != null)
                        {
                            var body = template.Template.Replace("[BGColor]", "#ced3f5")
                                                       .Replace("[HEADING]", subject)
                                                       .Replace("[RECEIVERNAME]", firstName)
                                                       .Replace("[MSG]", message)
                                                       .Replace("[FooterText]", footer);

                            Utilities.EmailHelper.SendEmailWithDefaultParameter(subject, body, true, true, emailId, null, null, null);
                        }
                    }
                    var newChildOneDic = new Dictionary<string, object>
                           {
                               { "Date & Time", datetime},
                               { "Company Location",  location},
                               { "Driver", driver },
                               { "Vehicle No.", vehicle },
                           };

                    var newHtmlTable = newChildOneDic.ToDataTable().ToHtmlTable(false);

                    var templateForAdmin = _dbContext.EmailTemplates.FirstOrDefault(e => e.TemplateName == EmailTemplates.CabRequestReport);
                    var adminInfo = _dbContext.vwAllUsers.FirstOrDefault(u => u.UserId == loginUserId);
                    var line = "Cab requests have been finalized successfully. Please find below the summary.";

                    var msg = newHtmlTable;

                    var subjectForReport = "Cab Requests Finalized";
                    var adminMail = CryptoHelper.Decrypt(adminInfo.EmailId);
                    var cabRequestData = cabReqData.ToDataTable();
                    var excelData = excelDataList.ToDataTable();

                    if (cabRequestData.Rows.Count > 0)
                    {
                        cabRequestData.Columns.Remove("ServiceType");
                        cabRequestData.Columns.Remove("EmployeeFirstName");
                        cabRequestData.Columns.Remove("EmailId");
                        cabRequestData.Columns.Remove("CompanyLocation");
                        cabRequestData.Columns.Remove("Vehicle");
                        cabRequestData.Columns.Remove("DateAndTime");
                        cabRequestData.Columns.Remove("Driver");
                        cabRequestData.Columns.Remove("UserRemarks");

                        var columns = new Dictionary<string, string>();
                        var body = string.Empty;

                        columns.Add("EmployeeName", "Employee Name");
                        columns.Add("EmpContactNo", "Mobile No");
                        columns.Add("RMName", "Reporting Manager");
                        columns.Add("RouteLocation", locationName);
                        columns.Add("LocationDetail", "Location Detail");

                        var htmlResult = cabRequestData.ToHtmlTable(true, columns);

                        //Excel
                        excelData.Columns.Remove("ServiceType");
                        excelData.Columns.Remove("EmployeeFirstName");
                        excelData.Columns.Remove("EmailId");

                        var excelColumns = new Dictionary<string, string>();
                        excelColumns.Add("EmployeeName", "Employee Name");
                        excelColumns.Add("EmpContactNo", "Mobile No");
                        excelColumns.Add("RMName", "Reporting Manager");
                        excelColumns.Add("DateAndTime", "Date");
                        excelColumns.Add("RouteLocation", locationName);
                        excelColumns.Add("LocationDetail", "Location Detail");
                        excelColumns.Add("Driver", "Driver");
                        excelColumns.Add("Vehicle", "Vehicle No.");
                        excelColumns.Add("CompanyLocation", "Company Location");
                        excelColumns.Add("UserRemarks", "Remarks");

                        var multipleTable = new Dictionary<string, DataTable>();
                        multipleTable.Add("Cab Request", excelData);

                        //Prepare Attachment
                        var fileName = subjectForReport + "_on_" + datetime;
                        var ms = multipleTable.ToExcelWithStyle(excelColumns, fileName.Replace("_", " "), "Report", true, false);
                        var attachmentFile = new System.Net.Mail.Attachment(ms, fileName.Replace("_", " ") + ".xlsx", MediaTypes.Excel);


                        var newTable = msg + "<br/><br />" + htmlResult;
                        if (templateForAdmin != null && adminInfo != null)
                        {
                            var greetings = "Hi " + adminInfo.EmployeeFirstName;

                            body = templateForAdmin.Template
                                .Replace("[BGColor]", "#ced3f5")
                                .Replace("[TextColor]", "#000000")
                                .Replace("[Title]", "Finalized Cab Requests")
                                .Replace("[Name]", greetings)
                                .Replace("[Line1]", line)
                                .Replace("[Data]", newTable);
                            Utilities.EmailHelper.SendEmailWithAttachment(subjectForReport, body, true, true, adminMail, null, null, new List<Attachment> { attachmentFile });
                        }
                    }
                }

                status = 1;
            }
            else
            {
                status = 0;
            }
            SaveUserLogs(ActivityMessages.BulkFinalizedCabRequest, loginUserId, loginUserId);

            return status;
        }

        public bool IsValidTimeForCabBooking(string forScreen)
        {
            var date = DateTime.Now;
            var data = _dbContext.Fn_GetCutOffTimeValidityForCabBooking(date, forScreen).FirstOrDefault();
            var isValid = false;
            var currentTime = DateTime.Now;
            if (data != null)
            {
                isValid = data.HasValue ? data.Value : false;
            }
            return isValid;
        }

        public int GetCabRequestDetailsToTakeAction(string encodedData)
        {
            var realdata = CryptoHelper.Decrypt(encodedData);
            string[] substrings = realdata.Split('&');
            int loginUserId = Convert.ToInt32(substrings[0]);
            int cabRequestId = Convert.ToInt32(substrings[1]);
            int msg = 0;
            var result = new ObjectParameter("Response", typeof(int));
            _dbContext.Proc_ActionCutOffTimeInfo(cabRequestId, result);
            Int32.TryParse(result.Value.ToString(), out msg);
            return msg;
        }

        #endregion

        #region Dashborad Leaves
        public List<DataForLeaveManagementBO> ListDashboardLeavesByUserId(string leaveType, DateTime year, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            var leaveDataByUserId = new List<DataForLeaveManagementBO>();

            var data = _dbContext.Proc_GetLeaveBalanceHistoryByFY(year, leaveType, userId).ToList();
            foreach (var temp in data)
            {
                var leaveData = new DataForLeaveManagementBO
                {
                    DisplayApplyDate = temp.ApplyDate.ToString("dd MMM yyyy hh:mm tt"),
                    LeaveType = temp.LeaveInfo,
                    Status = temp.Status,
                    Remarks = temp.Remarks,
                    NoOfDays = temp.LeaveCount,
                    FromDate = temp.FromDate.ToString("dd MMM yyyy"),
                    TillDate = temp.TillDate.ToString("dd MMM yyyy"),
                };

                leaveDataByUserId.Add(leaveData);
            }
            return leaveDataByUserId;
        }
        public List<DataForLeaveManagementBO> ListDashboardCompOffByUserId(string userAbrhs, DateTime year)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            var result = new List<DataForLeaveManagementBO>();
            var data = _dbContext.Proc_GetUserDashboardCompOff(userId, year).ToList();

            if (data.Any())
            {
                foreach (var temp in data)
                {
                    result.Add(new DataForLeaveManagementBO
                    {
                        DisplayFromDate = temp.Date.ToString("dd-MMM-yyyy"),
                        NoOfDays = temp.NoOfDays,
                        Status = temp.Status,
                        StatusCode = temp.StatusCode,
                        DisplayApplyDate = temp.AppliedOn.ToString("dd-MMM-yyyy hh:mm tt"),
                        IsLapsed = temp.IsLapsed,
                        LapseDate = temp.LapseDate.ToString("dd-MMM-yyyy"),
                        StatusId = temp.StatusId,
                    });
                }

            }
            return result ?? new List<DataForLeaveManagementBO>();
        }
        #endregion

        #region Health Insurance
        public HealthInsurance GetHealthInsuranceDetail(int userId, string basePath)
        {
            var userData = _dbContext.UsersHealthInsurances.FirstOrDefault(t => t.UserId == userId && t.IsActive == true);
            var fileName = "";
            if (userData != null)
            {
                fileName = userData.InsurancePdfPath;
            }
            HealthInsurance obj = new HealthInsurance();
            var finalBasePath = basePath + "\\" + fileName;
            FileInfo fi = new FileInfo(finalBasePath);
            if (!File.Exists(finalBasePath))
                obj.link = string.Empty;
            else
            {
                byte[] formInByte = File.ReadAllBytes(finalBasePath);
                var formInBase64String = Convert.ToBase64String(formInByte);
                var fileExtension = fi.Extension;//fileName.Split('.')[1];
                obj.link = CommonUtility.GetBase64MimeType(fileExtension) + "," + formInBase64String;
            }
            obj.fileName = fileName;

            return obj;
        }

        #endregion

        #region Calendar Data

        public List<WeekOffDateDetailsOnDashboard> GetUsersDashboardCalendarData(string startDate, string endDate, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var sDate = DateTime.ParseExact(startDate, "yyyy/MM/dd", CultureInfo.InvariantCulture);
            var eDate = DateTime.ParseExact(endDate, "yyyy/MM/dd", CultureInfo.InvariantCulture);
            //var sDate = Convert.ToDateTime(startDate);
            //var eDate = Convert.ToDateTime(endDate);
            var dateList = _dbContext.Proc_GetUserWiseWeekDataInCalendar(userId, sDate, eDate).ToList();
            var dateDetails = new List<WeekOffDateDetailsOnDashboard>();
            if (dateList.Any())
            {
                foreach (var temp in dateList)
                {
                    dateDetails.Add(new WeekOffDateDetailsOnDashboard
                    {
                        DateId = temp.DateId,
                        Date = temp.Date.ToString("yyyy-MM-dd"),
                        IsWeekOff = temp.IsWeekOff,
                        WorkingHrs = temp.WorkingHrs,
                        TimesheetHrs = temp.TimesheetHrs,
                        IsHoliday = temp.IsHoliday,
                        IsNightShift = temp.IsNightShift,
                        OnLeave = temp.OnLeave,
                        LeaveType = temp.LeaveType,
                        DateFormat = "YYYY-MM-DD"
                    });
                }
            }
            return dateDetails ?? new List<WeekOffDateDetailsOnDashboard>();
        }
        #endregion

        #region OnshoreManagerMapping

        public List<UserOnShoreManagerMapping> FetchUsersOnshoreManagerData(string userAbrhsList)
        {
            string[] userAbrhsNew = userAbrhsList.Split(',');
            int len = userAbrhsNew.Length;
            string[] userIds = new string[len];
            for (var i = 0; i < len; i++)
            {
                userIds[i] = CryptoHelper.Decrypt(userAbrhsNew[i]);
            }
            string userIdsNew = string.Join(",", userIds);

            var result = _dbContext.Proc_FetchUsersOnshoreManagerData(userIdsNew).ToList();
            var dataList = result.Select(t => new UserOnShoreManagerMapping
            {
                UserName = t.EmployeeName,
                UserAbrhs = CryptoHelper.Encrypt(t.UserId.ToString()),
                OnshoreMgrName = t.ManagerName,
                OnshoreMgrAbrhs = CryptoHelper.Encrypt(t.OnshoreMgrId.ToString()),
                ClntSideEmpId = t.ClientSideEmpId,
                ValidFrom = t.ValidFrom,
                ValidTill = t.ValidTill,
                ValidFromDate = t.UserValidFromDate.HasValue ? t.UserValidFromDate.Value.ToString("MM/dd/yyyy", CultureInfo.InvariantCulture) : "",
                ValidTillDate = t.UserValidTillDate.HasValue ? t.UserValidTillDate.Value.ToString("MM/dd/yyyy", CultureInfo.InvariantCulture) : "",
                MappingId = t.MappingId,
                NotifyManager = t.NotifyOnshoreMgr,
                EnableNotification = t.NotifyOnshoreMgr == true ? "Yes" : "No",
                CreatedDate = t.CreatedDate

            }).ToList();
            return dataList ?? new List<UserOnShoreManagerMapping>();
        }

        public List<UserOnShoreManagerMapping> GetUsersToMapOnshoreManager()
        {
            var userData = _dbContext.vwActiveUsers.ToList();
            var pimcoUser = userData.Select(t => new UserOnShoreManagerMapping
            {
                UserName = t.EmployeeName,
                UserAbrhs = CryptoHelper.Encrypt(t.UserId.ToString())
            }).ToList();
            return pimcoUser ?? new List<UserOnShoreManagerMapping>();
        }

        public List<UserOnShoreManagerMapping> GetOnshoreManager()
        {
            var onshoreManagerData = _dbContext.OnshoreManagers.Where(p => p.IsActive == true && p.ClientId == 1).ToList(); // pimco);
            var onshoreManager = onshoreManagerData.Select(t => new UserOnShoreManagerMapping
            {
                OnshoreMgrName = t.ManagerName,
                OnshoreMgrAbrhs = CryptoHelper.Encrypt(t.OnshoreMgrId.ToString())
            }).ToList();
            return onshoreManager ?? new List<UserOnShoreManagerMapping>();
        }

        public OnshoreManagerMappingResult AddOrUpdateUsersOnshoreMgr(UserOnShoreManagerMapping data, int loginUserId)
        {
            int userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(data.UserAbrhs), out userId);
            int mgrId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(data.OnshoreMgrAbrhs), out mgrId);
            int status = 0;
            int mappingId = 0;
            var result = new ObjectParameter("Success", typeof(int));
            var mappingResult = new ObjectParameter("NewCreatedMappingId", typeof(long));
            string validFrom = null;
            string validTill = null;
            if (data.ValidFrom != "")
            {
                validFrom = data.ValidFrom;
            }
            if (data.ValidTill != "")
            {
                validTill = data.ValidTill;
            }
            _dbContext.Proc_AddOrUpdateUsersOnshoreMgr(userId, data.MappingId, data.ClntSideEmpId, mgrId, validFrom, validTill, data.NotifyManager, loginUserId, result, mappingResult);

            Int32.TryParse(result.Value.ToString(), out status);
            Int32.TryParse(mappingResult.Value.ToString(), out mappingId);
            SaveUserLogs(ActivityMessages.OnshoreManagerMapping, loginUserId, 0);

            var response = new OnshoreManagerMappingResult()
            {
                Status = status,
                MappingId = mappingId
            };

            return response ?? new OnshoreManagerMappingResult();
        }

        public int CancelOnshorManagerMapping(long mappingId, int loginUserId)
        {
            var result = _dbContext.UsersOnshoreMgrMappings.FirstOrDefault(t => t.MappingId == mappingId);

            result.IsActive = false;
            result.ModifiedBy = loginUserId;
            result.ModifiedDate = DateTime.Now;
            var response = _dbContext.SaveChanges();
            return response;
        }
        #endregion

        #region Abroad Users
        public List<AbroadUserBO> FetchOnshoreUsers()
        {
            List<AbroadUserBO> onshoreUsers = new List<AbroadUserBO>();
            var userData = _dbContext.Proc_FetchOnshoreUsers();
            onshoreUsers = userData.Select(t => new AbroadUserBO
            {
                EmployeeName = t.EmployeeName,
                EmployeeCode = t.EmployeeCode,
                EmployeeAbrhs = CryptoHelper.Encrypt(t.UserId.ToString()),
                RManager = t.ReportingManagerName,
                CompanyLocation = t.CompanyLocation,
                Department = t.Department,
                Team = t.Team,
                Country = t.CountryName
            }).ToList();
            return onshoreUsers ?? new List<AbroadUserBO>();
        }

        public List<AbroadUserBO> FetchOffshoreUsers()
        {
            List<AbroadUserBO> offshoreUsers = new List<AbroadUserBO>();
            var userData = _dbContext.Proc_FetchOffshoreUsers();
            offshoreUsers = userData.Select(t => new AbroadUserBO
            {
                EmployeeName = t.EmployeeName,
                EmployeeCode = t.EmployeeCode,
                EmployeeAbrhs = CryptoHelper.Encrypt(t.UserId.ToString()),
                RManager = t.ReportingManagerName,
                ExtensionNo = t.ExtensionNumber,
                WSNo = t.WorkStationNo,
                CompanyLocation = t.CompanyLocation,
                Department = t.Department,
                Team = t.Team,
                Country = t.CountryName
            }).ToList();
            return offshoreUsers ?? new List<AbroadUserBO>();
        }

        public List<AbroadUserBO> CountryList(string employeeAbrhs)
        {
            List<AbroadUserBO> countryList = new List<AbroadUserBO>();
            int userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(employeeAbrhs), out userId);

            var userData = _dbContext.Users.Where(t => t.UserId == userId).FirstOrDefault();
            int countryId = 0;

            if (userData != null)
            {
                var locationData = _dbContext.Locations.FirstOrDefault(t => t.LocationId == userData.LocationId);
                if (locationData != null)
                {
                    countryId = locationData.CountryId;
                }
                var countryIdList = _dbContext.Locations.Where(t => t.CountryId != countryId).GroupBy(t => t.CountryId).ToList();

                var data = (from l in countryIdList
                            join c in _dbContext.Countries on l.Key equals c.CountryId
                            select new AbroadUserBO
                            {
                                CountryId = c.CountryId,
                                Country = c.CountryName
                            }).ToList();

                countryList = data;
            }
            return countryList ?? new List<AbroadUserBO>();
        }

        public List<AbroadUserBO> CompanyLocationListByCountryId(int countryId)
        {
            List<AbroadUserBO> locationList = new List<AbroadUserBO>();
            var locationData = _dbContext.Locations.Where(t => t.CountryId == countryId).ToList();

            var data = locationData.Select(t => new AbroadUserBO
            {
                CompanyLocation = t.LocationName,
                CompanyLocationId = t.LocationId
            }).ToList();
            return data ?? new List<AbroadUserBO>();
        }

        public List<AbroadUserBO> CompanyLocationListByUserId(string employeeAbrhs)
        {
            int userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(employeeAbrhs), out userId);

            var countryId = 0;
            var country = _dbContext.Countries.FirstOrDefault(t => t.CountryName == "India");
            if (country != null)
            {
                countryId = country.CountryId;
            }

            var LocationLists = _dbContext.Locations.Where(t => t.CountryId == countryId).ToList();

            var data = LocationLists.Select(t => new AbroadUserBO
            {
                CompanyLocation = t.LocationName,
                CompanyLocationId = t.LocationId
            }).ToList();

            return data ?? new List<AbroadUserBO>();
        }

        public int ChangeUserLocationAndMapUserOnshore(AbroadUserBO inputs, int loginUserId)
        {
            List<AbroadUserBO> offshoreUsers = new List<AbroadUserBO>();
            int userId = 0;
            string wsNo;
            string extNo;
            string empCode;
            Int32.TryParse(CryptoHelper.Decrypt(inputs.EmployeeAbrhs), out userId);

            wsNo = string.IsNullOrEmpty(inputs.WSNo) ? null : inputs.WSNo;
            extNo = string.IsNullOrEmpty(inputs.ExtensionNo) ? null : inputs.ExtensionNo;
            empCode = string.IsNullOrEmpty(inputs.EmployeeCode) ? null : inputs.EmployeeCode;

            int res = 0;
            var result = new ObjectParameter("Success", typeof(int));
            _dbContext.Proc_ChangeUserLocationAndMapUserOnshore(userId, inputs.CompanyLocationId, empCode, extNo, wsNo, loginUserId, inputs.ActionCode, result);
            Int32.TryParse(result.Value.ToString(), out res);

            return res;
        }

        #endregion

        #region AD Password
        public string GetADUserName(int userId)
        {
            var userData = _dbContext.Users.FirstOrDefault(t => t.UserId == userId && t.IsActive == true);
            var adUserName = userData.ADUserName;

            return adUserName;
        }

        public ResponseBO<bool> ChangeADPassword(int userId, string currntADPassword, string newADPassword)
        {
            var response = new ResponseBO<bool>() { IsSuccessful = false, Status = ResponseStatus.Error, StatusCode = HttpStatusCode.InternalServerError, Message = ResponseMessage.Error };

            try
            {
                var adUserName = GetADUserName(userId);
                var validateResponse = LDAPClient.ValidateUser(adUserName, currntADPassword);

                //Check if current AD credentials is valid 
                if (validateResponse.IsSuccessful)
                {
                    var changePWDResponse = LDAPClient.ChangePassword(adUserName, currntADPassword, newADPassword);
                    response = changePWDResponse;

                    if (!changePWDResponse.IsSuccessful)
                        GlobalServices.LogError(new Exception(changePWDResponse.Message));
                }
                else
                {
                    response = validateResponse;
                }
            }
            catch (Exception ex)
            {
                GlobalServices.LogError(ex);
            }

            return response;
        }

        #endregion

    }
}
