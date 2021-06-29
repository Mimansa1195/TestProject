using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MIS.Services.Contracts;
using MIS.Model;
using MIS.BO;
using System.Configuration;
using MIS.Utilities;
using System.Globalization;
using System.Data.Entity.Core.Objects;
using Newtonsoft.Json.Linq;
using System.Web;

namespace MIS.Services.Implementations
{
    public class LnsaServices : ILnsaServices
    {

        private readonly IUserServices _userServices;

        public LnsaServices(IUserServices userServices)
        {
            _userServices = userServices;
        }

        #region Private member variables

        private readonly MISEntities _dbContext = new MISEntities();

        #endregion

        /// <summary>
        /// Get Conflict Status Of Lnsa Period
        /// </summary>
        /// <param name="fromDate"></param>
        /// <param name="tillDate"></param>
        /// <param name="userId"></param>
        /// <returns>1- exists, 0 - does not exist</returns>
        public bool GetConflictStatusOfLnsaPeriod(DateTime fromDate, DateTime tillDate, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var result = _dbContext.spGetConflictStatusOfLnsaPeriod(fromDate, tillDate, userId).FirstOrDefault().GetValueOrDefault();
            return result;
        }

        /// <summary>
        /// Get All Lnsa Request
        /// </summary>
        /// <param name="userId"></param>
        /// <returns>List LnsaDataBO</returns>
        public List<LnsaDataBO> GetAllLnsaRequest(string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var result = _dbContext.spFetchAllLnsaRequestStatusByUserId(userId).ToList();
            if (result.Any())
            {
                List<BO.LnsaDataBO> list = new List<BO.LnsaDataBO>();
                foreach (var data in result)
                {
                    BO.LnsaDataBO temp = new BO.LnsaDataBO()
                    {
                        Status = data.Status,
                        FromDate = data.FromDate.ToString("dd-MMM-yyyy"),//("MM'/'dd'/'yyyy"),
                        TillDate = data.TillDate.ToString("dd-MMM-yyyy"),//("MM'/'dd'/'yyyy"),
                        NoOfDays = data.NoOfDays,
                        Reason = data.Reason,
                        ApproverRemarks = data.Remarks,
                        StatusCode = data.StatusCode,
                        RequestId = data.RequestId,
                        ApplyDate = data.ApplyDate
                    };
                    var tillDate = data.TillDate;
                    if (data.IsCancellable == true)
                    {
                        if (!data.StatusCode.Equals("CA") && !data.StatusCode.Equals("RJ"))
                        {
                            DateTime todayDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day);
                            if (tillDate >= todayDate)
                            {
                                temp.IsCancellable = true;
                            }
                            else
                            {
                                temp.IsCancellable = false;
                            }
                        }
                        else
                            temp.IsCancellable = false;
                    }
                    else
                        temp.IsCancellable = false;
                    list.Add(temp);

                }
                return list;
            }
            else
                return new List<LnsaDataBO>();
        }

        /// <summary>
        /// Get All Pending Lnsa Request
        /// </summary>
        /// <param name="userId"></param>
        /// <returns>List LnsaDataBO</returns>
        public List<LnsaDataBO> GetAllPendingLnsaRequest(string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var result = _dbContext.spFetchAllPendingLnsaRequestByManagerId(userId).ToList();
            if (result.Any())
            {
                List<BO.LnsaDataBO> list = new List<BO.LnsaDataBO>();
                foreach (var data in result)
                {
                    BO.LnsaDataBO temp = new BO.LnsaDataBO()
                    {
                        RequestId = data.RequestId,
                        EmployeeName = data.EmployeeName,
                        FromDate = data.FromDate.ToString("dd-MMM-yyyy"),//("MM'/'dd'/'yyyy"),
                        TillDate = data.TillDate.ToString("dd-MMM-yyyy"),//("MM'/'dd'/'yyyy"),
                        NoOfDays = data.NoOfDays,
                        Reason = data.Reason,
                        Status = data.Status,
                        ApplyDate = data.ApplyDate
                    };

                    list.Add(temp);
                }
                return list;
            }
            else
                return new List<LnsaDataBO>();
        }

        /// <summary>
        /// Get All Approved Lnsa Request
        /// </summary>
        /// <param name="fromDate"></param>
        /// <param name="tillDate"></param>
        /// <param name="userId"></param>
        /// <returns>List LnsaDataBO</returns>
        public List<LnsaDataBO> GetAllApprovedLnsaRequest(DateTime fromDate, DateTime tillDate, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var result = _dbContext.spFetchAllApprovedLnsaRequest(userId, fromDate, tillDate).ToList();
            if (result.Any())
            {
                List<BO.LnsaDataBO> list = new List<BO.LnsaDataBO>();
                foreach (var data in result)
                {
                    BO.LnsaDataBO temp = new BO.LnsaDataBO()
                    {
                        RequestId = data.RequestId,
                        EmployeeName = data.EmployeeName,
                        FromDate = data.FromDate.ToString("dd-MMM-yyyy"),//("MM'/'dd'/'yyyy"),
                        TillDate = data.TillDate.ToString("dd-MMM-yyyy"),//("MM'/'dd'/'yyyy"),
                        NoOfDays = data.NoOfDays,
                        Reason = data.Reason,
                        Status = data.Status,
                        StatusCode = data.StatusCode,
                        ApplyDate = data.ApplyDate

                    };
                    if (!data.StatusCode.Equals("CA") && !data.StatusCode.Equals("RJ"))
                    {
                        var dateLimit = new DateTime(data.FromDate.Year, data.FromDate.Month, 24);
                        if (data.FromDate.Date > dateLimit)
                            dateLimit = new DateTime(data.FromDate.Year, data.FromDate.Month, 24).AddMonths(1);

                        if (DateTime.Now.Date > dateLimit)
                        {
                            temp.IsCancellable = false;
                        }
                        else
                        {
                            temp.IsCancellable = true;
                        }
                    }
                    else
                        temp.IsCancellable = false;
                    list.Add(temp);
                }
                return list;
            }
            else
                return new List<LnsaDataBO>();
        }

        /// <summary>
        /// Get 25 Approved Lnsa Request
        /// </summary>
        /// <param name="fromDate"></param>
        /// <param name="tillDate"></param>
        /// <param name="userId"></param>
        /// <returns>List LnsaDataBO</returns>
        public List<LnsaDataBO> GetLastNApprovedLnsaRequest(string userAbrhs, int noOfRecords)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var result = _dbContext.spFetchLastNApprovedLnsa(userId, noOfRecords).ToList();
            if (result.Any())
            {
                List<BO.LnsaDataBO> list = new List<BO.LnsaDataBO>();
                foreach (var data in result)
                {
                    BO.LnsaDataBO temp = new BO.LnsaDataBO()
                    {
                        RequestId = data.RequestId,
                        EmployeeName = data.EmployeeName,
                        FromDate = data.FromDate.ToString("dd-MMM-yyyy"),//("MM'/'dd'/'yyyy"),
                        TillDate = data.TillDate.ToString("dd-MMM-yyyy"),//("MM'/'dd'/'yyyy"),
                        NoOfDays = data.NoOfDays,
                        Reason = data.Reason,
                        Status = data.Status,
                        StatusCode = data.StatusCode,
                        ApplyDate = data.ApplyDate
                    };
                    if (!data.StatusCode.Equals("CA") && !data.StatusCode.Equals("RJ"))
                    {
                        var dateLimit = new DateTime(data.FromDate.Year, data.FromDate.Month, 24);
                        if(data.FromDate.Date > dateLimit)
                           dateLimit = new DateTime(data.FromDate.Year, data.FromDate.Month, 24).AddMonths(1);

                        if (DateTime.Now.Date > dateLimit)
                        {
                            temp.IsCancellable = false;
                        }
                        else
                        {
                            temp.IsCancellable = true;
                        }
                    }
                    else
                        temp.IsCancellable = false;

                    list.Add(temp);
                }
                return list;
            }
            else
                return new List<LnsaDataBO>();
        }

        /// <summary>
        /// Insert Lnsa Request
        /// </summary>
        /// <param name="fromDate"></param>
        /// <param name="tillDate"></param>
        /// <param name="reason"></param>
        /// <param name="userId"></param>
        /// <returns>1 - success, 0 - failure</returns>
        public bool InsertLnsaRequest(DateTime fromDate, DateTime tillDate, string reason, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var result = _dbContext.spInsertLnsaRequest(fromDate, tillDate, reason, userId).FirstOrDefault();
            if (result == true)
            {
                var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "Apply LNSA" && f.IsActive && !f.IsDeleted);
                if (emailTemplate != null)
                {
                    var userDetail = _dbContext.UserDetails.FirstOrDefault(f => f.UserId == userId);
                    var managerDetail = _dbContext.UserDetails.FirstOrDefault(f => f.UserId == userDetail.ReportTo);
                    var managerEmailId = CryptoHelper.Decrypt(managerDetail.EmailId);
                    var body = emailTemplate.Template;
                    var period = (fromDate.ToString("dd-MMM-yyyy").Equals(tillDate.ToString("dd-MMM-yyyy"))) ? "for " + fromDate.ToString("dd-MMM-yyyy")
                                                            : "from " + fromDate.ToString("dd-MMM-yyyy") + " to " + tillDate.ToString("dd-MMM-yyyy");
                    body = body.Replace("[ManagerName]", managerDetail.FirstName).Replace("[ApplicantName]", userDetail.FirstName + " " + userDetail.LastName)
                        .Replace("[Reason]", reason).Replace("[Period]", period);

                    Utilities.EmailHelper.SendEmailWithDefaultParameter("LNSA Application", body, true, true, managerEmailId, null, null, null);
                }
            }

            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.InsertLnsaRequest, userId, 0);

            return result.Value;
        }

        /// <summary>
        /// Take Action On Lnsa Request
        /// </summary>
        /// <param name="requestId"></param>
        /// <param name="status"></param>
        /// <param name="remarks"></param>
        /// <param name="userId"></param>
        /// <returns>1 - success, 0 - failure</returns>
        public bool TakeActionOnLnsaRequest(int requestId, int status, string remarks, string userAbrhs)
        {
            //var userId = 0;
            //Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            //var approverId = 0;
            //var result = _dbContext.spTakeActionOnLnsaRequest(requestId, status, remarks, userId).FirstOrDefault();
            //var requestData = _dbContext.RequestLnsas.FirstOrDefault(s => s.RequestId == requestId);
            //if (requestData != null)
            //{
            //    approverId = requestData.ApproverId.HasValue? requestData.ApproverId.Value: 0;
            //}
            //if (result.Result == true && approverId ==0)
            //{
            //    var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "Review LNSA" && f.IsActive && !f.IsDeleted);
            //    if (emailTemplate != null)
            //    {
            //        var temp = _dbContext.RequestLnsas.FirstOrDefault(f => f.RequestId == requestId);
            //        var userDetail = _dbContext.UserDetails.FirstOrDefault(f => f.UserId == temp.CreatedBy);
            //        var userEmailId = CryptoHelper.Decrypt(userDetail.EmailId);
            //        var body = emailTemplate.Template;
            //        var period = (result.FromDate.ToString("dd-MMM-yyyy").Equals(result.TillDate.ToString("dd-MMM-yyyy"))) ? result.FromDate.ToString("dd-MMM-yyyy")
            //                                                : result.FromDate.ToString("dd-MMM-yyyy") + " to " + result.TillDate.ToString("dd-MMM-yyyy");

            //        if (status == 1)
            //            body = body.Replace("[Date]", period).Replace("[Name]", userDetail.FirstName).Replace("[Action]", "Approved");
            //        else
            //            body = body.Replace("[Date]", period).Replace("[Name]", userDetail.FirstName).Replace("[Action]", "Rejected because of following reason - " + remarks);

            //        Utilities.EmailHelper.SendEmailWithDefaultParameter("LNSA Application", body, true, true, userEmailId, null, null, null);
            //    }
            //}

            // Logging 
            //_userServices.SaveUserLogs(ActivityMessages.TakeActionOnLnsaRequest, userId, 0);

            //return result.Result.Value;
            return true;
        }

        public int ApplyLnsaShift(string userAbrhs, string dateIds, string reason)
        {
            var status = 0;
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var success = new ObjectParameter("Success", typeof(int));
            _dbContext.Proc_MapLnsaShift(userId, dateIds, reason, success);
            Int32.TryParse(success.Value.ToString(), out status);
            if (status == 1)
            {
                var data = _dbContext.Proc_GetApproverDetails(userId).FirstOrDefault();
                if (data != null)
                {
                    var rcvEmailId = data.EmailId;
                    var firstName = data.FirstName;
                    var lastName = data.LastName;
                    var userName = _dbContext.UserDetails.FirstOrDefault(f => f.UserId == userId);
                    var emailId = CryptoHelper.Decrypt(rcvEmailId);
                    var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "LNSA Shift Mapping" && f.IsActive && !f.IsDeleted);
                    if (emailTemplate != null && userName != null)
                    {
                        var body = emailTemplate.Template.Replace("[Name]", firstName)
                            .Replace("[ApplicantName]", userName.FirstName + " " + userName.LastName);
                        Utilities.EmailHelper.SendEmailWithDefaultParameter("LNSA request", body, true, true, emailId, null, null, null);
                    }
                }
            }
            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.LnsaShift, userId, userId);
            return status;
        }

        public List<LnsaShiftBO> GetAllLnsaShiftRequest(string userAbrhs)
        {

            var userId = 0;
            List<LnsaShiftBO> listData = new List<LnsaShiftBO>();
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var result = _dbContext.Proc_GetAllLnsaShiftRequest(userId).ToList();
            foreach (var s in result)
            {
                var list = new LnsaShiftBO
                {
                    ApproverRemarks = s.Remarks,
                    TempUserShiftId = s.TempUserShiftId,
                    Status = s.Status,
                    CreatedDate = s.CreatedDate,
                    StatusCode = s.StatusCode
                };
                var maxDateId = _dbContext.TempUserShiftDetails.Where(m => m.TempUserShiftId == s.TempUserShiftId).Max(c => c.DateId);
                var tillDate = _dbContext.DateMasters.FirstOrDefault(q => q.DateId == maxDateId).Date;
                if (!s.StatusCode.Equals("CA") && !s.StatusCode.Equals("RJM") && !s.StatusCode.Equals("RJH"))
                {
                    DateTime todayDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day);
                    if (tillDate >= todayDate)
                    {
                        list.IsCancellable = true;
                    }
                    else
                    {
                        list.IsCancellable = false;
                    }
                }
                else
                    list.IsCancellable = false;

                listData.Add(list);
            }

            return listData ?? new List<LnsaShiftBO>();
        }

        public List<LnsaShiftBO> GetAllLnsaShiftReviewRequest(string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var result = _dbContext.Proc_GetAllLnsaShiftReviewRequest(userId).ToList();
            var loginUserData = _dbContext.fnGetHRDetail(userId).FirstOrDefault();
            var IsHRVerifier = loginUserData.IsHRVerifier.Value;
            var userType = "MGR";
            if (IsHRVerifier == true)
                userType = "HR";
            List<LnsaShiftBO> list = new List<LnsaShiftBO>();
            foreach (var s in result)
            {
                var data = new LnsaShiftBO
                {
                    EmployeeName = s.EmployeeName,
                    ApproverRemarks = s.Remarks,
                    TempUserShiftId = s.TempUserShiftId,
                    Status = s.Status,
                    StatusCode = s.StatusCode,
                    CreatedDate = s.CreatedDate,
                    UserType = userType
                };
                if (!data.StatusCode.Equals("CA") && !data.StatusCode.Equals("RJM") && !data.StatusCode.Equals("RJH"))
                    data.IsCancellable = true;
                else
                    data.IsCancellable = false;
                list.Add(data);
            }
            return list ?? new List<LnsaShiftBO>();
        }

        public List<LnsaDateBO> GetDateLnsaRequest(long lnsaRequestId)
        {
            var result = _dbContext.DateWiseLNSAs.Where(s => s.RequestId == lnsaRequestId).ToList();

            List<LnsaDateBO> listData = new List<LnsaDateBO>();
            foreach (var s in result)
            {
                var statusData = _dbContext.LNSAStatusMasters.FirstOrDefault(t => t.StatusId == s.StatusId);
                var dateData = _dbContext.DateMasters.FirstOrDefault(d => d.DateId == s.DateId);
                var data = new LnsaDateBO
                {
                    Date = dateData.Date.ToString("dd MMM yyyy", CultureInfo.InvariantCulture),
                    DateId = s.DateId,
                    LnsaRequestDetailId = s.RecordId,
                    Status = statusData.Status
                };

                if (!statusData.StatusCode.Equals("CA") && !statusData.StatusCode.Equals("RJ"))
                {
                    data.IsCancellable = true;

                    var dateLimit = new DateTime(dateData.Date.Year, dateData.Date.Month, 24);
                    if (dateData.Date.Date > dateLimit)
                        dateLimit = new DateTime(dateData.Date.Year, dateData.Date.Month, 24).AddMonths(1);

                    if (DateTime.Now.Date > dateLimit)
                    {
                        data.IsCancellableAfterApproval = false;
                    }
                    else
                    {
                        data.IsCancellableAfterApproval = true;
                    }

                }
                else
                {
                    data.IsCancellable = false;
                    data.IsCancellableAfterApproval = false;
                }

                listData.Add(data);
            }
            return listData ?? new List<LnsaDateBO>();
        }

        public List<LnsaDateBO> getDateToCancelLnsaRequest(long lnsaRequestId)
        {
            var result = _dbContext.DateWiseLNSAs.Where(s => s.RequestId == lnsaRequestId).ToList();

            List<LnsaDateBO> listData = new List<LnsaDateBO>();
            foreach (var s in result)
            {
                var statusData = _dbContext.LNSAStatusMasters.FirstOrDefault(t => t.StatusId == s.StatusId);
                var dateData = _dbContext.DateMasters.FirstOrDefault(d => d.DateId == s.DateId);
                var data = new LnsaDateBO
                {
                    Date = dateData.Date.ToString("dd MMM yyyy", CultureInfo.InvariantCulture),
                    DateId = s.DateId,
                    LnsaRequestDetailId = s.RecordId,
                    Status = statusData.Status
                };
                if (!statusData.StatusCode.Equals("CA") && !statusData.StatusCode.Equals("AP") && !statusData.StatusCode.Equals("RJ"))
                {
                    DateTime todayDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day);
                    if (dateData.Date >= todayDate)
                    {
                        data.IsCancellable = true;
                    }
                    else
                    {
                        data.IsCancellable = false;
                    }
                }
                else
                {
                    data.IsCancellable = false;
                }

                listData.Add(data);
            }
            return listData ?? new List<LnsaDateBO>();

        }

        public int CancelAllLnsaRequest(int lnsaRequestId, string status, string action, string userAbrhs)
        {
            var result = CancelLnsaRequest(status, action, userAbrhs, lnsaRequestId);
            return result;
        }

        public int CancelLnsaRequest(string status, string action, string userAbrhs, int lnsaRequestDetailId)
        {
            var loginUserId = 0;

            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out loginUserId);
            var msg = 0;
            var result = new ObjectParameter("Success", typeof(int));
            _dbContext.spTakeActionOnLnsaRequest(loginUserId, lnsaRequestDetailId, "Cancelled", status, action, result);
            Int32.TryParse(result.Value.ToString(), out msg);
            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.LnsaShiftCancel, loginUserId, msg);
            return msg;
        }

        public int RejectLnsaRequest(string status, string action, string remarks, string userAbrhs, int lnsaRequestDetailId)
        {

            var loginUserId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out loginUserId);
            var msg = 0;
            var result = new ObjectParameter("Success", typeof(int));
            _dbContext.spTakeActionOnLnsaRequest(loginUserId, lnsaRequestDetailId, remarks, status, action, result);
            Int32.TryParse(result.Value.ToString(), out msg);
            var user = _dbContext.DateWiseLNSAs.FirstOrDefault(s => s.RecordId == lnsaRequestDetailId);
            var loginUserData = _dbContext.UserDetails.FirstOrDefault(f => f.UserId == loginUserId);
            var userData = _dbContext.UserDetails.FirstOrDefault(f => f.UserId == user.CreatedBy);
            var requestedDate = (_dbContext.DateMasters.FirstOrDefault(s => s.DateId == user.DateId).Date).ToString("dd MMM yyyy", CultureInfo.InvariantCulture);
            if (msg == 1)
            {
                if (loginUserData != null && userData != null)
                {
                    var firstName = loginUserData.FirstName;
                    var lastName = loginUserData.LastName;
                    var emailId = CryptoHelper.Decrypt(userData.EmailId);
                    var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "LNSA Shift Rejected" && f.IsActive && !f.IsDeleted);
                    if (emailTemplate != null && userData != null)
                    {
                        var body = emailTemplate.Template.Replace("[Name]", userData.FirstName)
                                       .Replace("[HEADER]", "LNSA REQUEST REJECTED")
                                       .Replace("[Action]", "rejected")
                                       .Replace("[MsgWithDate]", "for the date " + requestedDate)
                                       .Replace("[ApproverName]", firstName + " " + lastName + " for the following reason : " + remarks);
                        Utilities.EmailHelper.SendEmailWithDefaultParameter("LNSA request rejected", body, true, true, emailId, null, null, null);
                    }
                }

            }
            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.LnsaShiftReject, loginUserId, msg);
            return msg;

        }

        public int RejectAllLnsaRequest(int lnsaRequestId, string status, string action, string remarks, string userAbrhs)
        {
            var loginUserId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out loginUserId);
            var msg = 0;
            var result = new ObjectParameter("Success", typeof(int));
            _dbContext.spTakeActionOnLnsaRequest(loginUserId, lnsaRequestId, remarks, status, action, result);
            Int32.TryParse(result.Value.ToString(), out msg);

            var requestData = _dbContext.RequestLnsas.FirstOrDefault(s => s.RequestId == lnsaRequestId);
            var loginUserData = _dbContext.UserDetails.FirstOrDefault(f => f.UserId == loginUserId);
            var userData = _dbContext.UserDetails.FirstOrDefault(f => f.UserId == requestData.CreatedBy);
            var createdDate = requestData.CreatedDate.ToString("dd MMM yyyy", CultureInfo.InvariantCulture);

            if (msg == 1)
            {
                if (loginUserData != null && userData != null)
                {
                    var firstName = loginUserData.FirstName;
                    var lastName = loginUserData.LastName;
                    var emailId = CryptoHelper.Decrypt(userData.EmailId);
                    var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "LNSA Shift Rejected" && f.IsActive && !f.IsDeleted);
                    if (emailTemplate != null && userData != null)
                    {
                        var body = emailTemplate.Template.Replace("[Name]", userData.FirstName)
                                       .Replace("[HEADER]", "LNSA REQUEST REJECTED")
                                       .Replace("[Action]", "rejected")
                                       .Replace("[MsgWithDate]", "created on " + createdDate)
                                       .Replace("[ApproverName]", firstName + " " + lastName + " for the following reason : " + remarks);
                        Utilities.EmailHelper.SendEmailWithDefaultParameter("LNSA request rejected", body, true, true, emailId, null, null, null);
                    }
                }
            }

            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.LnsaShiftReject, loginUserId, msg);
            return msg;
        }

        public int ApproveLnsaShiftRequest(int lnsaRequestId, string status, string action, string remarks, string userAbrhs)
        {
            var loginUserId = 0;
            var approverId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out loginUserId);
            var msg = 0;
            var result = new ObjectParameter("Success", typeof(int));
            _dbContext.spTakeActionOnLnsaRequest(loginUserId, lnsaRequestId, remarks, status, action, result);
            Int32.TryParse(result.Value.ToString(), out msg);

            var requestData = _dbContext.RequestLnsas.FirstOrDefault(s => s.RequestId == lnsaRequestId);
            var loginUserData = _dbContext.UserDetails.FirstOrDefault(f => f.UserId == loginUserId);
            var userData = _dbContext.UserDetails.FirstOrDefault(f => f.UserId == requestData.CreatedBy);
            var createdDate = requestData.CreatedDate.ToString("dd MMM yyyy", CultureInfo.InvariantCulture);

            if (requestData != null)
            {
                approverId = requestData.ApproverId.HasValue ? requestData.ApproverId.Value : 0;
            }
            if (msg == 1 && approverId == 0)
            {
                if (loginUserData != null && userData != null)
                {
                    var firstName = loginUserData.FirstName;
                    var lastName = loginUserData.LastName;
                    var emailId = CryptoHelper.Decrypt(userData.EmailId);
                    var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "LNSA Shift Approved" && f.IsActive && !f.IsDeleted);
                    if (emailTemplate != null && userData != null)
                    {
                        var lines = string.Format("Your LNSA request created on {0} has been approved by {1}", createdDate, firstName + " " + lastName);
                        var body = emailTemplate.Template.Replace("[HEADER]", "LNSA SHIFT APPROVED")
                             .Replace("[NAME]", userData.FirstName)
                             .Replace("[DATA]", lines);
                        Utilities.EmailHelper.SendEmailWithDefaultParameter("LNSA request approved", body, true, true, emailId, null, null, null);
                    }
                }
            }
            else if (msg == 1 && approverId != 0)
            {
                var data = _dbContext.vwActiveUsers.Where(s => s.UserId == requestData.ApproverId).FirstOrDefault();
                if (data != null)
                {
                    var rcvEmailId = data.EmailId;
                    var firstName = data.EmployeeFirstName;
                    var lastName = data.EmployeeLastName;
                    var userName = _dbContext.UserDetails.FirstOrDefault(f => f.UserId == requestData.CreatedBy);
                    var emailId = CryptoHelper.Decrypt(rcvEmailId);
                    var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "LNSA Shift Mapping" && f.IsActive && !f.IsDeleted);
                    if (emailTemplate != null && userName != null)
                    {
                        var body = emailTemplate.Template.Replace("[Name]", firstName)
                            .Replace("[ApplicantName]", userName.FirstName + " " + userName.LastName);
                        Utilities.EmailHelper.SendEmailWithDefaultParameter("LNSA request", body, true, true, emailId, null, null, null);
                    }
                }
            }
            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.LnsaShiftApprove, loginUserId, msg);
            return msg;
        }

        public string BulkApproveLnsaRequest(string lnsaRequestIds, string remarks, int loginUserId)
        {
            var result = _dbContext.Proc_BulkApproveLnsaRequest(lnsaRequestIds, remarks, loginUserId).ToList();
            var newResult = result;
            var errorLnsaRequest = result.Where(t => t.Result != 1).Select(r => r.EmployeeName).ToList();

            var errorLnsaRequestEmpName = "";
            var msg = "";

            if (errorLnsaRequest.Count > 0)
            {
                errorLnsaRequestEmpName = string.Join(", ", errorLnsaRequest);
                msg = "for employee(s): " + errorLnsaRequestEmpName;
            }

            var approvedLnsaRequest = newResult.Where(t => t.Result == 1).Select(r => r.LnsaRequestId).ToList();

            if (approvedLnsaRequest.Count > 0)
            {
                var approvedLnsaRequestIds = string.Join(",", approvedLnsaRequest);
                var userData = _dbContext.Proc_GetUsersLnsaRequestsDetail(approvedLnsaRequestIds, loginUserId).ToList();
                var grpedUser = userData.Where(t=>t.ApproverId == 0).GroupBy(t => new { t.UserMailId, t.UserFirstName, t.ApproverId, t.LoginEmpFullName });
                var grpedApprover = userData.Where(t => t.ApproverId != 0).GroupBy(t => new { t.ApproverMailId, t.ApproverFirstName, t.ApproverId });
                var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "LNSA Shift Approved" && f.IsActive && !f.IsDeleted);

                foreach (var r in grpedUser)
                {
                    var usersRequests = userData.Where(u => u.UserMailId == r.Key.UserMailId && u.UserFirstName == r.Key.UserFirstName && u.ApproverId == 0).ToList().Select(t => t.AppliedForDate).ToList();
                    var distictData = usersRequests.Distinct();
                    var requests = string.Join(", ", distictData);

                    if (usersRequests.Count > 0)
                    {
                        if (r.Key.LoginEmpFullName != null && r.Key.UserFirstName != null)
                        {
                            var loginEmpName = r.Key.LoginEmpFullName;
                            var emailId = CryptoHelper.Decrypt(r.Key.UserMailId);
                            if (emailTemplate != null)
                            {
                                var data = string.Format("Your LNSA request for date {0} has been approved by {1}", requests, loginEmpName);
                                var body = emailTemplate.Template.Replace("[HEADER]", "LNSA SHIFT APPROVED")
                                     .Replace("[NAME]", r.Key.UserFirstName)
                                     .Replace("[DATA]", data);
                                Utilities.EmailHelper.SendEmailWithDefaultParameter("LNSA request approved", body, true, true, emailId, null, null, null);
                            }
                        }
                    }
                }
                foreach (var r in grpedApprover)
                {
                    var apprRequests = userData.Where(u => u.ApproverMailId == r.Key.ApproverMailId && u.ApproverFirstName == r.Key.ApproverFirstName && u.ApproverId != 0).Select(t => t.UserFullName).ToList();
                    var distictData = apprRequests.Distinct();
                    var users = string.Join(", ", distictData);
                    if (apprRequests.Count > 0)
                    {
                        if (r.Key.ApproverMailId != null && r.Key.ApproverFirstName != null)
                        {
                            var rcvEmailId = r.Key.ApproverMailId;
                            var firstName = r.Key.ApproverFirstName;
                            var emailId = CryptoHelper.Decrypt(rcvEmailId);
                            if (emailTemplate != null)
                            {
                                var data = string.Format("There is LNSA request from {0}. You are requested to take action on the same.", users);
                                var body = emailTemplate.Template.Replace("[HEADER]", "LNSA REQUEST")
                                    .Replace("[NAME]", firstName)
                                    .Replace("[DATA]", data);
                                Utilities.EmailHelper.SendEmailWithDefaultParameter("LNSA request", body, true, true, emailId, null, null, null);
                            }
                        }
                    }
                }
            }

            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.LnsaShiftApprove, loginUserId, 1);
            return msg;
        }

        //public string BulkApproveLnsaRequest(string lnsaRequestIds, string remarks, int loginUserId)
        //{
        //    var result = _dbContext.Proc_BulkApproveLnsaRequest(lnsaRequestIds, remarks, loginUserId).ToList();
        //    var newResult = result;
        //    var errorLnsaRequest = result.Where(t => t.Result != 1).Select(r => r.EmployeeName).ToList();

        //    var errorLnsaRequestEmpName = "";
        //    var msg = "";

        //    if (errorLnsaRequest.Count > 0)
        //    {
        //         errorLnsaRequestEmpName = string.Join(", ", errorLnsaRequest);
        //         msg = "for employee(s): " + errorLnsaRequestEmpName;
        //    }

        //    var approvedLnsaRequest = newResult.Where(t => t.Result == 1).Select(r => r.LnsaRequestId).ToList();

        //    if(approvedLnsaRequest.Count > 0)
        //    {
        //        var approvedLnsaRequestIds = string.Join(",", approvedLnsaRequest);
        //        var userData = _dbContext.Proc_GetUsersLnsaRequestsDetail(approvedLnsaRequestIds, loginUserId).ToList();

        //        var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "LNSA Shift Approved" && f.IsActive && !f.IsDeleted);
        //        foreach (var r in userData)
        //        {
        //            if (r.ApproverId == 0)
        //            {
        //                if (r.LoginEmpFullName != null && r.UserFirstName != null)
        //                {
        //                    var loginEmpName = r.LoginEmpFullName;
        //                    var emailId = CryptoHelper.Decrypt(r.UserMailId);
        //                    if (emailTemplate != null && userData != null)
        //                    {
        //                        var data = string.Format("Your LNSA request for date {0} has been approved by {1}", r.AppliedForDate, loginEmpName);
        //                        var body = emailTemplate.Template.Replace("[HEADER]", "LNSA SHIFT APPROVED")
        //                             .Replace("[NAME]", r.UserFirstName)
        //                             .Replace("[DATA]", data);
        //                        Utilities.EmailHelper.SendEmailWithDefaultParameter("LNSA request approved", body, true, true, emailId, null, null, null);
        //                    }
        //                }
        //            }
        //            else
        //            {
        //                if (r.ApproverMailId != null && r.ApproverFirstName != null)
        //                {

        //                    var rcvEmailId = r.ApproverMailId;
        //                    var firstName = r.ApproverFirstName;
        //                    var emailId = CryptoHelper.Decrypt(rcvEmailId);
        //                    if (emailTemplate != null && r.UserFullName != null)
        //                    {
        //                        var data = string.Format("There is a LNSA request from {0}, You are requested to take action on the same.", r.UserFullName);
        //                        var body = emailTemplate.Template.Replace("[HEADER]", "LNSA REQUEST")
        //                            .Replace("[NAME]", firstName)
        //                            .Replace("[DATA]", data);
        //                        Utilities.EmailHelper.SendEmailWithDefaultParameter("LNSA request", body, true, true, emailId, null, null, null);
        //                    }
        //                }
        //            }
        //        }
        //    }

        //    // Logging 
        //    _userServices.SaveUserLogs(ActivityMessages.LnsaShiftApprove, loginUserId, 1);
        //    return msg;
        //}

        public ShiftMappingCalenderBO GetShiftMappingDetails(DateTime startDate, DateTime endDate, bool IsPreviousMonthDate, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            var data = _dbContext.Proc_GetShiftMappingDetails(userId, startDate, endDate, IsPreviousMonthDate).ToList();

            var shiftData = new ShiftMappingCalenderBO();
            var lnsaData = data.FirstOrDefault();
            var shiftInfo = new ShiftMappingDetailsBO
            {
                ShiftName = "C",
                ShiftMappingStartDate = data.FirstOrDefault().MappingStartDate,
                ShiftMappingEndDate = data.FirstOrDefault().MappingEndDate,
                StartDate = startDate,
                EndDate = endDate,
                IsSubmitBtnActive = lnsaData.IsLNSAEnabled.HasValue ? lnsaData.IsLNSAEnabled.Value : false,
                IsCurrentMonthYear = IsPreviousMonthDate == false ? true : false
            };
            var newWeek = data.GroupBy(t => t.WeekNo)
                           .Select(g => g.First())
                           .ToList();
            var weekList = new List<WeekDetailsBO>();
            foreach (var i in newWeek)
            {

                var weekInfo = new WeekDetailsBO
                {
                    WeekNo = i.WeekNo

                };
                var weekDetail = (from w in data where w.WeekNo == i.WeekNo select w).ToList();
                var weeks = weekDetail.Select(m => new WeeksBO
                {
                    MonthDate = m.DateInt,
                    Day = m.Day,
                    Date = m.FullDate,
                    DateId = m.DateId,
                    Month = m.Month,
                    Year = m.Year,
                    IsApplied = m.IsApplied,
                    IsApproved = m.IsApproved,
                    IsEligible = m.IsLNSAEnabled.HasValue ? m.IsLNSAEnabled.Value : false
                }).ToList();
                weekInfo.Weeks = weeks;
                weekList.Add(weekInfo);
                shiftInfo.WeekDetails = weekList;
            }
            shiftData.ShiftMappingDetails = shiftInfo;

            return shiftData ?? new ShiftMappingCalenderBO();
        }
    }
}

