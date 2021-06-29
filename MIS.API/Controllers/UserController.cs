using MIS.BO;
using MIS.Services.Contracts;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace MIS.API.Controllers
{
    public class UserController : BaseApiController
    {
        private readonly IUserServices _userServices;
        private readonly ITokenServices _tokenServices;

        public UserController(IUserServices userServices, ITokenServices tokenServices)
        {
            _userServices = userServices;
            this._tokenServices = tokenServices;
        }

        /// <summary>
        /// Check if token doesn't expired and alive
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public HttpResponseMessage Ping()
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            if (globalData.LoginUserId > 0)
                return Request.CreateResponse(HttpStatusCode.OK, new { IsAlive = true });
            else
                return Request.CreateResponse(HttpStatusCode.OK, new { IsAlive = false });
        }

        [HttpPost]
        public HttpResponseMessage GetUserInfo()
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"];
            //var token = Request.Headers.GetValues("Token").FirstOrDefault();
            if (globalData != null)
            {
                //var userId = _tokenServices.GetUserId(token);
                var userDetails = _userServices.GetUserDetails(globalData.LoginUserId);
                return Request.CreateResponse(HttpStatusCode.OK, userDetails);
            }
            else
            {
                return Request.CreateResponse(HttpStatusCode.Unauthorized);
            }
        }

        [HttpGet]
        public HttpResponseMessage FetchDataForEmployeeDirectory()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.FetchDataForEmployeeDirectory());
        }

        #region User Management

        [HttpGet]
        public HttpResponseMessage GetLockedUsersList()
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.GetLockedUsersList(globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage UnlockUser(string employeeAbrhs)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.UnlockUser(globalData.UserAbrhs, employeeAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetUserActivityLogs(string employeeAbrhs, string fromDate, string toDate)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            DateTime fromDateNew = DateTime.ParseExact(fromDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            DateTime toDateNew = DateTime.ParseExact(toDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.GetUserActivityLogs(globalData.UserAbrhs, employeeAbrhs, fromDateNew, toDateNew));
        }

        [HttpPost]
        public HttpResponseMessage GetAllEmployeesByStatus(int status)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.GetAllEmployeesByStatus(status));
        }

        [HttpPost]
        public HttpResponseMessage GetAllEmployees()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.GetAllEmployees());
        }

        [HttpPost]
        public HttpResponseMessage LoadFullNFinalData(string userAbrhs, string fromDate, string tillDate)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.GetUserLeaveDetailForFnF(userAbrhs, fromDate, tillDate));
        }

        [HttpPost]
        public HttpResponseMessage GetPromotionHistory()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.GetPromotionHistory());
        }

        [HttpPost]
        public HttpResponseMessage PromoteUsers(string employeeAbrhs, int newDesignationId, string promotionDate, string newEmpCode, string userAbrhs)
        {
            DateTime t = DateTime.ParseExact(promotionDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.PromoteUsers(employeeAbrhs, newDesignationId, t, newEmpCode, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage ListOldAndNewLeaveBalanceByUserId(string userAbrhs, int empDesignationId, string promotionDate)
        {
            DateTime t = DateTime.ParseExact(promotionDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.ListOldAndNewLeaveBalanceByUserId(userAbrhs, empDesignationId, t));
        }

        [HttpPost]
        public HttpResponseMessage LisLeaveBalanceForNewUser(string empDesignationAbrhs, string joiningDate)
        {
            DateTime t = DateTime.ParseExact(joiningDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.LisLeaveBalanceForNewUser(empDesignationAbrhs, t));
        }

        [HttpPost]
        public HttpResponseMessage ListPendingUnapprovedDataOfUser(string employeeAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.ListPendingUnapprovedDataOfUser(employeeAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage SendReminderMailToPreviousManager(string employeeAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.SendReminderMailToPreviousManager(employeeAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage UpdateReportingManagerForApprovals(string employeeAbrhs,string rmAbrhs)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.UpdateReportingManagerForApprovals(employeeAbrhs, rmAbrhs, globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage FetchUserLeaveBalanceDetail(string dol, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.FetchUserLeaveBalanceDetail(dol, userAbrhs));
        }
        
        [HttpPost]
        public HttpResponseMessage ChangeUserStatus(string employeeAbrhs, int status, string terminationDate)
        {
            if (string.IsNullOrEmpty(terminationDate))
                return null;
            DateTime terminationDateNew = DateTime.ParseExact(terminationDate, "dd/MM/yyyy", CultureInfo.InvariantCulture);
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.ChangeUserStatus(employeeAbrhs, status, terminationDateNew, globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GenerateLinkForUserRegistration(string userName, string adUserName, string domain, string redirectionLink)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();

            return Request.CreateResponse(HttpStatusCode.OK, _userServices.GenerateLinkForUserRegistration(userName, adUserName, domain, globalData.UserAbrhs, redirectionLink));
        }

        [HttpPost]
        public HttpResponseMessage GetAllUserRegistrations()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.GetAllUserRegistrations());
        }

        [HttpPost]
        public HttpResponseMessage ChangeRegLinkStatus(int registrationId, int status, string redirectionLink)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.ChangeRegLinkStatus(registrationId, status, globalData.UserAbrhs, redirectionLink));
        }

        [HttpPost]
        public HttpResponseMessage GetUserRegistrationDataById(long registrationId)
        {
            //var basePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["TempProfileImageUploadPath"];
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.GetUserRegistrationDataById(registrationId));
        }

        [HttpPost]
        public HttpResponseMessage GetUserProfileDataByUserId(string employeeAbrhs)
        {
          return Request.CreateResponse(HttpStatusCode.OK, _userServices.GetUserProfileDataByUserId(employeeAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage EditUserPersonalInfo(UserPersonalDetailBO userPersonalDetail)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.EditUserPersonalInfo(userPersonalDetail));
        }

        [HttpPost]
        public HttpResponseMessage EditUserAddressInfo(List<UserAddressDetailBO> userAddressDetail)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.EditUserAddressInfo(userAddressDetail));
        }

        [HttpPost]
        public HttpResponseMessage EditUserCareerInfo(UserPersonalDetailBO userCareerDetail)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.EditUserCareerInfo(userCareerDetail));
        }

        [HttpPost]
        public HttpResponseMessage EditUserBankInfo(UserPersonalDetailBO userBankDetail)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.EditUserBankInfo(userBankDetail));
        }

        [HttpPost]
        public HttpResponseMessage EditUserJoiningInfo(UserJoiningDetailBO userJoiningDetail)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.EditUserJoiningInfo(userJoiningDetail));
        }

        //[HttpPost]
        //public HttpResponseMessage SaveNewUser(long registrationId, string userName, string officialEmailId, string personalEmailId, string firstName, string middleName, string lastName, string mobileNumber, string emergencyContactNumber, string dob, 
        //    string bloodGroup, int gender, int maritalStatus, string presentAddress, string permanentAddress, string fatherName, string fatherDOB, string motherName, string motherDOB, string insuranceAmount, string spouseName, string spouseDob, 
        //    string spouseOccupation, string spouseCompany, string spouseDesignation, bool kids, string child1Name, string child1Dob, int child1Gender, string child2Name, string child2Dob, int child2Gender, string jobExperience, bool isFresher,
        //    string lastEmployerName, string lastEmployerLocation, string  lastJobDesignation, string lastJobTenure, string lastJobUan, string jobLeavingReason, string panNo, string aadhaarNo, string passportNo, string dLNo, string voterIdNo,
        //    string bankAccNo, string employeeId, string departmentAbrhs, string designationAbrhs, string wsNo, string extensionNo, string accCardNo, string doj, string roleAbrhs, string reportingManagerAbrhs, string userAbrhs)
        //{
        //    try
        //    {
        //        return Request.CreateResponse(HttpStatusCode.OK, _userServices.SaveNewUser(registrationId, userName, officialEmailId, personalEmailId, firstName, middleName, lastName, mobileNumber, emergencyContactNumber, dob, bloodGroup, gender, maritalStatus,
        //    presentAddress, permanentAddress, fatherName, fatherDOB, motherName, motherDOB, insuranceAmount, spouseName, spouseDob, spouseOccupation, spouseCompany, spouseDesignation, kids, child1Name, child1Dob, child1Gender,
        //    child2Name, child2Dob, child2Gender, jobExperience, isFresher, lastEmployerName, lastEmployerLocation, lastJobDesignation, lastJobTenure, lastJobUan, jobLeavingReason, panNo, aadhaarNo, passportNo, dLNo, voterIdNo,
        //    bankAccNo, employeeId, departmentAbrhs, designationAbrhs, wsNo, extensionNo, accCardNo, doj, roleAbrhs, reportingManagerAbrhs, userAbrhs));
        //    }
        //    catch (Exception)
        //    {
        //        return Request.CreateResponse(HttpStatusCode.InternalServerError);
        //    }
        //}

        [HttpPost]
        public HttpResponseMessage SaveNewUser(long registrationId, string employeeId, string departmentAbrhs, string designationAbrhs, int probationPeriod, long teamId, string wsNo, string extensionNo,/* string accCardNo,*/ string doj, string roleAbrhs, string reportingManagerAbrhs, string redirectionLink)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();

            //var sourceBasePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["TempProfileImageUploadPath"];
            //var destinationBasePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["ProfileImageUploadPath"];
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.SaveNewUser(registrationId, employeeId, departmentAbrhs, designationAbrhs, probationPeriod, teamId, wsNo, extensionNo, /*accCardNo,*/ doj, roleAbrhs, reportingManagerAbrhs, globalData.UserAbrhs, redirectionLink));
        }

        [HttpPost]
        public HttpResponseMessage VerifyUserRegDetails(long registrationId, int accessCardId, string employeeAbrhs, bool isPimcoUser, string fromDate, string redirectionLink)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            var fromDateNew = DateTime.ParseExact(fromDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            var sourceBasePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["TempProfileImageUploadPath"];
            var destinationBasePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["ProfileImageUploadPath"];

            return Request.CreateResponse(HttpStatusCode.OK, _userServices.VerifyUserRegDetails(registrationId, sourceBasePath, destinationBasePath, accessCardId, employeeAbrhs, isPimcoUser, globalData.UserAbrhs, fromDateNew, redirectionLink));
        }

        [HttpPost]
        public HttpResponseMessage RejectUserProfile(long registrationId, string reason, string redirectionLink)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.RejectUserProfile(registrationId, reason, globalData.UserAbrhs, redirectionLink));
        }

        #endregion

        #region DashBoard Settings

        [HttpPost]
        public HttpResponseMessage GetUserRoleDashboardSettings()
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.GetUserRoleDashboardSettings(globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage AddUpdateDashboardSettings(ManageDashBoardSettingsBO dashBoardSettings)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.AddUpdateDashboardSettings(dashBoardSettings));
        }

        #endregion

        #region UserProfile

        [HttpPost]
        public HttpResponseMessage FetchDataForEmployeeProfile(string emailId)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.FetchDataForEmployeeProfile(emailId, globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage FetchDataForUpdateProfile()
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.FetchDataForUpdateProfile(globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage UpdateUserProfile(EmployeeUpdateProfileBO employeeUpdateProfileBO)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.UpdateUserProfile(employeeUpdateProfileBO));
        }

        [HttpPost]
        public HttpResponseMessage UpdateUserAddress(EmployeeUpdateProfileBO employeeUpdateProfileBO)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.UpdateUserAddress(employeeUpdateProfileBO));
        }

        [HttpPost]
        public HttpResponseMessage ChangePassword(string oldPassword, string newPassword)//1: success, 2: unauthorised user, 3: invalid current password, 4: error
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.ChangePassword(globalData.UserAbrhs, oldPassword, newPassword));
        }
        #endregion

        #region OnshoreManagerMapping
        [HttpPost]
        public HttpResponseMessage FetchUsersOnshoreManagerData(string userAbrhsList)
        {
            var response = _userServices.FetchUsersOnshoreManagerData(userAbrhsList);
            return Request.CreateResponse(HttpStatusCode.OK, response);
        }

        [HttpGet]
        public HttpResponseMessage GetUsersToMapOnshoreManager()
        {
            var response = _userServices.GetUsersToMapOnshoreManager();
            return Request.CreateResponse(HttpStatusCode.OK, response);
        }

        [HttpGet]
        public HttpResponseMessage GetOnShoreManager()
        {
            var response = _userServices.GetOnshoreManager();
            return Request.CreateResponse(HttpStatusCode.OK, response);
        }

        [HttpPost]
        public HttpResponseMessage AddOrUpdateUsersOnshoreMgr(UserOnShoreManagerMapping mappingData)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            var response = _userServices.AddOrUpdateUsersOnshoreMgr(mappingData, globalData.LoginUserId);
            return Request.CreateResponse(HttpStatusCode.OK, response);
        }

        [HttpPost]
        public HttpResponseMessage CancelOnshorManagerMapping(long mappingId)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            var response = _userServices.CancelOnshorManagerMapping(mappingId, globalData.LoginUserId);
            return Request.CreateResponse(HttpStatusCode.OK, response);
        }

        #endregion

        #region Abroad User

        [HttpPost]
        public HttpResponseMessage FetchOnshoreUsers()
        {
            var response = _userServices.FetchOnshoreUsers();
            return Request.CreateResponse(HttpStatusCode.OK, response);
        }

        [HttpPost]
        public HttpResponseMessage FetchOffshoreUsers()
        {
            var response = _userServices.FetchOffshoreUsers();
            return Request.CreateResponse(HttpStatusCode.OK, response);
        }

        [HttpPost]
        public HttpResponseMessage CountryList(string employeeAbrhs)
        {
            var response = _userServices.CountryList(employeeAbrhs);
            return Request.CreateResponse(HttpStatusCode.OK, response);
        }

        [HttpPost]
        public HttpResponseMessage CompanyLocationListByCountryId(int countryId)
        {
            var response = _userServices.CompanyLocationListByCountryId(countryId);
            return Request.CreateResponse(HttpStatusCode.OK, response);
        }

        [HttpPost]
        public HttpResponseMessage CompanyLocationListByUserId(string employeeAbrhs)
        {
            var response = _userServices.CompanyLocationListByUserId(employeeAbrhs);
            return Request.CreateResponse(HttpStatusCode.OK, response);
        }

        [HttpPost]
        public HttpResponseMessage ChangeUserLocationAndMapUserOnshore(AbroadUserBO inputs)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            var response = _userServices.ChangeUserLocationAndMapUserOnshore(inputs, globalData.LoginUserId);
            return Request.CreateResponse(HttpStatusCode.OK, response);
        }

        #endregion


        #region Organization Structure
        [HttpGet]
        public HttpResponseMessage FetchOrganizationStructure(int parentId)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.FetchOrganizationStructure(globalData.UserAbrhs, parentId));
        }
        #endregion
    }
}