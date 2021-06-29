using MIS.BO;
using MIS.Model;
using MIS.Services.Contracts;
using MIS.Utilities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Web;

namespace MIS.Services.Implementations
{

    public class PimcoServices : IPimcoServices
    {
        private readonly MISEntities _dbContext = new MISEntities();

        public ResponseBO<List<GetGeminiUsersBo>> GetGeminiUsers()
        {
            var response = new ResponseBO<List<GetGeminiUsersBo>>()
            {
                IsSuccessful = false,
                Status = ResponseStatus.Error,
                StatusCode = HttpStatusCode.InternalServerError,
                Message = ResponseMessage.Error
            };
            try
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

                List<GetGeminiUsersBo> geminiUserData = new List<GetGeminiUsersBo>();
                var data = _dbContext.Proc_GetGeminiUsers().ToList();
                foreach (var temp in data)
                {
                    geminiUserData.Add(new GetGeminiUsersBo
                    {
                        EmployeeName = temp.EmployeeName,
                        EmployeeCode = temp.EmployeeCode,
                        Email = CryptoHelper.Decrypt(temp.EmailId),
                        Designation = temp.Designation,
                        DepartmentName = temp.Department,
                        MobileNumber = CryptoHelper.Decrypt(temp.MobileNo),
                        ExtNo = temp.ExtensionNo,
                        Location = temp.Location,
                        WsNo = temp.WSNo,
                        Team = temp.Team,
                        ReportingManager = temp.Manager,
                        ImagePath = string.Format("{0}", (!string.IsNullOrEmpty(temp.ImagePath) ? (profileImagePath + temp.ImagePath) :
                               ((!string.IsNullOrEmpty(temp.Gender) ? temp.Gender.ToLower() : "") == "female" ? femaleImagePath : maleImagePath))),
                        ReportingManagerEmail = !string.IsNullOrEmpty(temp.ManagerEmail) ? CryptoHelper.Decrypt(temp.ManagerEmail) : string.Empty,
                        TerminateDate = temp.TerminateDate != null ? temp.TerminateDate.ToString() : string.Empty
                    }) ;
                }

                response.IsSuccessful = true;
                response.Status = ResponseStatus.Success;
                response.StatusCode = HttpStatusCode.OK;
                response.Message = ResponseMessage.Success;
                response.Result = geminiUserData ?? new List<GetGeminiUsersBo>();
            }
            catch (Exception ex)
            {
                var errorId = GlobalServices.LogError(ex);
                response.Message = string.Format(ResponseMessage.DBError, errorId);
            }
            return response;
        }

        public ResponseBO<List<GetPimcoUsersBo>> GetPimcoUsers(bool isExpiration)
        {
            var response = new ResponseBO<List<GetPimcoUsersBo>>()
            {
                IsSuccessful = false,
                Status = ResponseStatus.Error,
                StatusCode = HttpStatusCode.InternalServerError,
                Message = ResponseMessage.Error
            };

            try
            {
                var pimcoList = new List<GetPimcoUsersBo>();
                var data = _dbContext.Proc_GetPimcoUsers().ToList();
                foreach (var s in data)
                {
                    var newData = new GetPimcoUsersBo
                    {
                        EmployeeName = s.EmployeeName,
                        PimcoEmployeeId = s.PimcoEmpId,
                        GeminiReportingManager = s.GeminiManager,
                        PimcoReportingManager = s.PimcoManager,
                        CreatedDate = s.CreatedDate,
                        CreatedBy = s.CreatedBy,
                        ModifiedDate = s.ModifiedDate,
                        ModifiedBy = s.ModifiedBy,
                    };
                    if (isExpiration)
                    {
                        var pimcoIdData = _dbContext.Proc_GetPimcoIdExpirationData(s.PimcoUserId).ToList();
                        var newPimcoIdData = pimcoIdData.Select(x => new GetPimcoIdExpirationData
                        {
                            PimcoEmpIdValidFromDate = x.ValidFromDate,
                            PimcoEmpIdValidToDate = x.ValidTillDate,
                            IsAcknowledged = x.IsAcknowledged,
                            AcknowledgedBy = x.AcknowledgedBy,
                            AcknowledgedDate = x.AcknowledgedDate,
                            CreatedBy = x.CreatedBy,
                            CreatedDate = x.CreatedDate,
                            ModifiedBy = x.ModifiedBy,
                            ModifiedDate = x.ModifiedDate,
                        }).ToList();

                        newData.PimcoEmpIdExpirationData = newPimcoIdData;
                    }
                    pimcoList.Add(newData);
                }

                response.IsSuccessful = true;
                response.Status = ResponseStatus.Success;
                response.StatusCode = HttpStatusCode.OK;
                response.Message = ResponseMessage.Success;
                response.Result = pimcoList ?? new List<GetPimcoUsersBo>();
            }
            catch (Exception ex)
            {
                var errorId = GlobalServices.LogError(ex);
                response.Message = string.Format(ResponseMessage.DBError, errorId);
            }
            return response;
        }

        /// <summary>
        /// Method to fetch organization structure for pimco
        /// </summary>
        /// <param name="userAbrhs"></param>
        /// <param name="parentId"></param>
        /// <returns>PimcoOrganizationStructureBO List</returns>
        public List<PimcoOrganizationStructureBO> FetchPimcoOrganizationStructure(int parentId)
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

            var orgData = _dbContext.Proc_FetchPimcoUserHierarchy(parentId).ToList();

            var buildVersion = GlobalServices.GetBuildVersion();
            var orgStructure = orgData.Select(x => new PimcoOrganizationStructureBO
            {
                Id = x.Id.HasValue ? x.Id.Value : 0,
                ParentId = x.ParentId,
                Name = !string.IsNullOrEmpty(x.Name) ? x.Name : "",
                ParentName = !string.IsNullOrEmpty(x.ParentName) ? x.ParentName : "",
                OffshoreManager = x.OffshoreManager,
                OnshoreManager = string.IsNullOrEmpty(x.OnshoreManager) ? "NA" : x.OnshoreManager,
                TeamName = x.TeamName,
                TotalExperience = x.TotalExperience.HasValue ? x.TotalExperience.Value : 0,
                PimcoTenure = x.PimcoTenure.HasValue ? x.PimcoTenure.Value : 0,
                TopNSkills = x.TopNSkills,
                ProfileSummary = x.ProfileSummary,
                RoleDetail = x.RoleDetail,
                ImagePath = string.Format("{0}?v={1}", (!string.IsNullOrEmpty(x.ImagePath) ? (profileImagePath + x.ImagePath) :
                            ((!string.IsNullOrEmpty(x.Gender) ? x.Gender.ToLower() : "") == "female" ? femaleImagePath : maleImagePath)), buildVersion)
            }).OrderBy(x => x.Name);

            return orgStructure.ToList() ?? new List<PimcoOrganizationStructureBO>();
        }

        /// <summary>
        /// Method to fetch organization structure for pimco
        /// </summary>
        /// <returns>PimcoOrgData List</returns>
        public ResponseBO<List<PimcoOrgData>> PimcoOrgData()
        {
            var response = new ResponseBO<List<PimcoOrgData>>() { IsSuccessful = false, Status = ResponseStatus.Error, StatusCode = HttpStatusCode.InternalServerError, Message = ResponseMessage.Error };

            try
            {
                var reqUrl = HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + "/";

#if !DEBUG
                reqUrl = (new UriBuilder(reqUrl) { Port = -1 }).ToString();
#endif
                var baseImagePath = reqUrl + ConfigurationManager.AppSettings["ImagePath"];
                var profileImagePath = reqUrl + ConfigurationManager.AppSettings["ProfileImageUploadPath"].Replace("\\", "/");

                var maleImagePath = baseImagePath + "male-employee.png";
                var femaleImagePath = baseImagePath + "female-employee.png";

                var orgData = _dbContext.Proc_FetchPimcoOrgData().ToList();

                var buildVersion = GlobalServices.GetBuildVersion();
                var orgStructure = orgData.Select(x => new PimcoOrgData
                {
                    PimcoId = x.PimcoId,
                    PimcoParentId = x.PimcoParentId,
                    Name = !string.IsNullOrEmpty(x.Name) ? x.Name : "",
                    Designation = !string.IsNullOrEmpty(x.Designation) ? x.Designation : "",
                    PimcoTenure = x.PimcoTenure.ToString(),
                    OnshoreManager = x.OnshoreManager,
                    OrgManagerName = x.OrgManagerName,
                    Team = !string.IsNullOrEmpty(x.Team) ? x.Team : "",
                    Role = x.Role,
                    RoleDetail = x.RoleDetail,
                    ImagePath = string.Format("{0}?v={1}", (!string.IsNullOrEmpty(x.ImagePath) ? (profileImagePath + x.ImagePath) :
                                ((!string.IsNullOrEmpty(x.Gender) ? x.Gender.ToLower() : "") == "female" ? femaleImagePath : maleImagePath)), buildVersion),
                    Achievements = x.Achievements,
                    ProfileSummary = x.ProfileSummary,
                    TopNSkills = x.TopNSkills,
                    TotalExperience = x.TotalExperience.ToString()
                   }).OrderBy(x => x.Name);

                response.IsSuccessful = true;
                response.Status = ResponseStatus.Success;
                response.StatusCode = HttpStatusCode.OK;
                response.Message = ResponseMessage.Success;
                response.Result = orgStructure.ToList() ?? new List<PimcoOrgData>();
            }
            catch (Exception ex)
            {
                GlobalServices.LogError(ex);
                response.Message = ex.Message;
            }
            return response;
        }

        /// <summary>
        /// To Fetch Gemini user profile data
        /// </summary>
        /// <returns>GeminiUserProfileData List</returns>
        public ResponseBO<List<GeminiUserProfileData>> GeminiUserProfileData()
        {
            var response = new ResponseBO<List<GeminiUserProfileData>>() { IsSuccessful = false, Status = ResponseStatus.Error, StatusCode = HttpStatusCode.InternalServerError, Message = ResponseMessage.Error };

            try
            {
                var reqUrl = HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + "/";

#if !DEBUG
                reqUrl = (new UriBuilder(reqUrl) { Port = -1 }).ToString();
#endif
                var baseImagePath = reqUrl + ConfigurationManager.AppSettings["ImagePath"];
                var profileImagePath = reqUrl + ConfigurationManager.AppSettings["ProfileImageUploadPath"].Replace("\\", "/");

                var maleImagePath = baseImagePath + "male-employee.png";
                var femaleImagePath = baseImagePath + "female-employee.png";

                var orgData = _dbContext.vwActiveUsers.ToList();

                var buildVersion = GlobalServices.GetBuildVersion();
                var orgStructure = orgData.Select(x => new GeminiUserProfileData
                {
                   EmployeeCode = x.EmployeeId,
                   ImagePath = string.Format("{0}?v={1}", (!string.IsNullOrEmpty(x.ImagePath) ? (profileImagePath + x.ImagePath) :
                                ((!string.IsNullOrEmpty(x.Gender) ? x.Gender.ToLower() : "") == "female" ? femaleImagePath : maleImagePath)), buildVersion),
                }).ToList();

                response.IsSuccessful = true;
                response.Status = ResponseStatus.Success;
                response.StatusCode = HttpStatusCode.OK;
                response.Message = ResponseMessage.Success;
                response.Result = orgStructure?? new List<GeminiUserProfileData>();
            }
            catch (Exception ex)
            {
                GlobalServices.LogError(ex);
                response.Message = ex.Message;
            }
            return response;
        }


        public ResponseBO<List<GeminiUsersForPimco>> AllGeminiUsersForPimco()
        {
            var response = new ResponseBO<List<GeminiUsersForPimco>>() { IsSuccessful = false, Status = ResponseStatus.Error, StatusCode = HttpStatusCode.InternalServerError, Message = ResponseMessage.Error };
            try
            {
                var orgData = _dbContext.Proc_FetchAllGeminiUsersForPimco().ToList();
                var buildVersion = GlobalServices.GetBuildVersion();
                var orgStructure = orgData.Select(x => new GeminiUsersForPimco
                {
                    EmployeeName = x.EmployeeName,
                    EmployeeId = x.EmployeeCode,
                    IsActive = x.IsActive,
                    ExitDate = x.DOL,
                    IsPimcoUser = x.IsPimcoUser,
                    PimcoId = x.PimcoId,
                    MonthsOfExperience = x.MonthsOfExperience,
                    Designation = x.Designation,
                    ReportingMgrId = x.RMId,
                    Department = x.Department,
                    Team = x.Team,
                    JoiningDate = x.Team,
                    GeminiEmailId = CryptoHelper.Decrypt(x.GeminiEmailId),
                    DOB = CryptoHelper.Decrypt(x.DOB),
                    ExtNo = x.EXT,
                    WSNo = x.WS,
                    MobileNumber =CryptoHelper.Decrypt(x.MobileNumber),
                    Skills = x.Skills
                }).OrderBy(x => x.EmployeeName);

                response.IsSuccessful = true;
                response.Status = ResponseStatus.Success;
                response.StatusCode = HttpStatusCode.OK;
                response.Message = ResponseMessage.Success;
                response.Result = orgStructure.ToList() ?? new List<GeminiUsersForPimco>();
            }
            catch (Exception ex)
            {
                GlobalServices.LogError(ex);
                response.Message = ex.Message;
            }
            return response;
        }

    }
}
