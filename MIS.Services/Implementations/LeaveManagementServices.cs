using MIS.BO;
using MIS.Model;
using MIS.Services.Contracts;
using MIS.Utilities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.Entity.Core.Objects;
using System.Globalization;
using System.Linq;
using System.Web;

namespace MIS.Services.Implementations
{
    public class LeaveManagementServices : ILeaveManagementServices
    {
        private readonly IUserServices _userServices;
        public LeaveManagementServices(IUserServices userServices)
        {
            _userServices = userServices;
        }

        #region Private member variables.

        private readonly MISEntities _dbContext = new MISEntities();

        #endregion

        #region Leave Management

        #region Approver Remarks

        public string GetApproverRemarks(long requestId, string type)
        {
            string remarks = "";
            var data = _dbContext.spGetApproverRemarks(requestId, type).ToList();
            foreach (var d in data)
            {
                remarks = remarks + d + "\n";
            }
            return remarks;
        }

        #endregion

        #region Leave Review

        public List<LeaveBO> GetLeaves(string userAbrhs, string Status, int year)
        {
            var UserId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out UserId);
            string UserType = "M";
            // var UserDetail = GetUserDetailsByUserId(userAbrhs);
            var loginUserData = _dbContext.fnGetHRDetail(UserId).FirstOrDefault();
            var IsHRVerifier = loginUserData.IsHRVerifier.Value;
            if (IsHRVerifier)
            {
                UserType = "HR";
            }
            List<LeaveBO> list = new List<LeaveBO>();
            var requests = _dbContext.spGetLeaves(UserId, Status, UserType, year).ToList();
            //if (UserType == "HR")
            //{
            //    if (Status == "Pending")
            //        requests = requests.Where(r => r.StatusId == 2 || r.StatusId == 1 || r.StatusId == 6 || r.StatusId == 5).ToList();
            //    if (Status == "Approved")
            //        requests = requests.Where(r => r.StatusId == -1 || r.StatusId == 3 || r.StatusId == 4).ToList();
            //}
            //else
            //{
            //    if (Status == "Pending")
            //        requests = requests.Where(r => r.StatusId == 1 || r.StatusId == 5).ToList();
            //    if (Status == "Approved")
            //        requests = requests.Where(r => r.StatusId == 2 || r.StatusId == -1 || r.StatusId == 3 || r.StatusId == 4).ToList();
            //}

            list = requests.Select(item => new LeaveBO
            {
                LeaveApplicationId = item.ApplicationId,
                EmployeeName = item.EmployeeName,
                FromDate = item.FromDate.ToString("dd-MMM-yyyy"),//("MM'/'dd'/'yyyy"),
                ToDate = item.ToDate.ToString("dd-MMM-yyyy"),//("MM'/'dd'/'yyyy"),
                Reason = item.Reason,
                ApproverRemarks = item.ApproverRemarks,
                Status = item.Status,
                StatusCode = item.StatusCode,
                StatusId = Convert.ToInt32(item.StatusId),
                UserId = UserId,
                CreatedDate = item.CreatedDate,
                LeaveType = item.LeaveInfo,
                ApplicantID = item.ApplicantId,
                ApplicantAbrhs = CryptoHelper.Encrypt(item.ApplicantId.ToString()),
                CancelDisabled = "",
            }).ToList();
            return list ?? new List<LeaveBO>();
            //return list.OrderByDescending(o => o.FromDate).OrderBy(o => o.EmployeeName).ToList();
        }

        public LeaveBO GetLeaveApplicationByApplicationID(int ApplicationID)
        {
            var requests = _dbContext.spGetLeaveApplication(ApplicationID).FirstOrDefault();
            if (requests != null)
            {
                return new LeaveBO()
                {
                    LeaveApplicationId = ApplicationID,// Convert.ToInt32(requests.LeaveApplicationID),
                    EmployeeName = requests.EmployeeName,
                    FromDate = requests.FromDate.ToString("dd-MM-yyyy"),
                    ToDate = requests.ToDate.ToString("dd-MM-yyyy"),
                    Reason = requests.Reason,
                    ApproverRemarks = requests.ApproverRemarks,
                    Status = requests.Status,
                    PrimaryContactNo = requests.PrimaryContactNo,
                    CreatedDate = requests.CreatedDate,
                    NoOfWorkingDays = requests.NoOfWorkingDays,
                    NoOfTotalDays = requests.NoOfTotalDays,
                    LeaveType = requests.LeaveType,
                    AlternativeContactNo = requests.AlternativeContactNo,
                    IsAvailableOnEmail = requests.IsAvailableOnEmail,
                    IsAvailableOnMobile = requests.IsAvailableOnMobile,
                    Department = requests.DepartmentName

                };
            }
            return null;
        }

        public string TakeActionOnLeave(int RequestID, string Userabrhs, string Status, String Remark, string ForwardedAbrhs)
        {
            var UserID = 0;
            Int32.TryParse(CryptoHelper.Decrypt(Userabrhs), out UserID);
            var ForwardedID = 0;
            Int32.TryParse(CryptoHelper.Decrypt(ForwardedAbrhs), out ForwardedID);
            var status = _dbContext.spTakeActionOnAppliedLeave(RequestID, Status, Remark, UserID, ForwardedID).First();
            if (status.ToString().Equals("SUCCEED"))
            {
                if (Status.Equals("RJ"))
                {
                    var data = _dbContext.spGetLeaveInformation(RequestID, UserID).FirstOrDefault();

                    var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "Reject Leave" && f.IsActive && !f.IsDeleted);
                    if (emailTemplate != null && data != null)
                    {
                        var body = emailTemplate.Template.Replace("[Name]", data.ApplicantFirstName).Replace("[FromDate]", data.FromDate.ToString("dd-MM-yyyy")).Replace("[TillDate]", data.FromDate.ToString("dd-MM-yyyy")).Replace("[RejectedBy]", data.ApproverFullName);
                        Utilities.EmailHelper.SendEmailWithDefaultParameter("Leave Rejected", body, true, true, CryptoHelper.Decrypt(data.ApplicantEmailId), null, null, null);
                    }

                    var forClient = 1; // pimco enter null for all client
                    string userName = "";
                    var employeeData = new vwActiveUser();
                    var leaveData = _dbContext.LeaveRequestApplications.FirstOrDefault(g => g.LeaveRequestApplicationId == RequestID);
                    if (leaveData != null)
                    {
                        employeeData = _dbContext.vwActiveUsers.FirstOrDefault(v => v.UserId == leaveData.UserId);

                        if (employeeData != null)
                        {
                            userName = employeeData.EmployeeName;
                        }

                        var fromDate = data.FromDate.ToString("dd MMM yyyy", CultureInfo.InvariantCulture);
                        var tillDate = data.TillDate.ToString("dd MMM yyyy", CultureInfo.InvariantCulture);
                        var period = fromDate == tillDate ? fromDate : fromDate + " to " + tillDate;

                        var userMgrData = _dbContext.Fun_FetchUsersOnshoreMgr(leaveData.UserId, forClient).ToList();
                        var line1 = string.Format("This is to inform you that, {0}'s leave has been rejected for the period{1}. ", userName, period);
                        var emailTemplateNew = _dbContext.EmailTemplates.FirstOrDefault(t => t.TemplateName == EmailTemplates.LeaveMailToOnShoreMgr && t.IsActive == true && t.IsDeleted == false);
                        if (emailTemplate != null && userMgrData.Count > 0)
                        {
                            var body = emailTemplateNew.Template
                                                    .Replace("[Header]", "Employee's Leave Information")
                                                    .Replace("[Line1]", line1);
                            foreach (var t in userMgrData)
                            {
                                var mgrFirstName = t.OnshoreMgrName.Split(null)[0];
                                var mgrMail = t.EmailId;
                                body = body.Replace("[Name]", mgrFirstName);
                                Utilities.EmailHelper.SendEmailWithDefaultParameter("Employee's Leave Information", body, true, true, CryptoHelper.Decrypt(mgrMail), null, null, null);
                            }
                        }
                    }
                }
                else if (Status.Equals("PV") && ForwardedID != 0)
                {
                    var data = _dbContext.spGetLeaveInformation(RequestID, ForwardedID).FirstOrDefault();

                    var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "Forward Leave" && f.IsActive && !f.IsDeleted);
                    if (emailTemplate != null && data != null)
                    {
                        var body = emailTemplate.Template.Replace("[Name]", data.ApproverFirstName)
                                                        .Replace("[ApplicantName]", data.ApplicantFullName)
                                                        .Replace("[Type]", "Leave");
                        Utilities.EmailHelper.SendEmailWithDefaultParameter("Forwarded leave", body, true, true, CryptoHelper.Decrypt(data.ApproverEmailId), null, null, null);
                    }
                }
                //else if (Status.Equals("PV"))
                //{
                //    var data =
                //        _dbContext.LeaveRequestApplications.FirstOrDefault(
                //            x => x.LeaveRequestApplicationId == RequestID);
                //    if (data != null)
                //    {
                //        var leave = data.LeaveCombination.Split();
                //        if (leave[1].Equals("CL") && Convert.ToDouble(leave[0]) > 2) // int.Parse(leave[0])
                //        {
                //            var d = _dbContext.spGetLeaveInformation(RequestID, data.ApproverId).FirstOrDefault();
                //            var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "Forward Leave" && f.IsActive && !f.IsDeleted);
                //            if (emailTemplate != null && d != null)
                //            {
                //                var body = emailTemplate.Template.Replace("[Name]", d.ApproverName).Replace("[ApplicantName]", d.ApplicantName).Replace("[Type]", "Leave");
                //                Utilities.EmailHelper.SendEmailWithDefaultParameter("Forwarded leave", body, true, true, CryptoHelper.Decrypt(d.ApproverEmailId), null, null, null);
                //            }

                //        }

                //    }
                //}
            }

            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.TakeActionOnLeave, UserID, 0);
            return status;
        }

        #endregion

        #region Comp-Off

        public List<RequestForCompOffBO> GetCompOffRequest(string userAbrhs, string Status, int year)
        {
            var UserId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out UserId);
            var loginUserData = _dbContext.fnGetHRDetail(UserId).FirstOrDefault();
            var IsHRVerifier = loginUserData.IsHRVerifier.Value;
            string UserType = "M";
            // var UserDetail = GetUserDetailsByUserId(userAbrhs);
            if (IsHRVerifier)
            {
                UserType = "HR";
            }
            var list = new List<RequestForCompOffBO>();
            var requests = _dbContext.spGetCompOff(UserId, year).ToList();
            if (UserType == "HR")
            {
                if (Status == "Pending")
                    requests = requests.Where(r => r.StatusId == 2 || r.StatusId == 1).ToList();
                if (Status == "Approved")
                    requests = requests.Where(r => r.StatusId == -1 || r.StatusId == 3).ToList();
            }
            else
            {
                if (Status == "Pending")
                    requests = requests.Where(r => r.StatusId == 1).ToList();
                if (Status == "Approved")
                    requests = requests.Where(r => r.StatusId == 2 || r.StatusId == -1 || r.StatusId == 3).ToList();
            }
            foreach (var item in requests)
            {
                RequestForCompOffBO request = new RequestForCompOffBO()
                {

                    RequestID = item.RequestId,
                    EmployeeName = item.EmployeeName,
                    CompOffDate = item.Date.ToString("dd-MMM-yyyy"),//("MM'/'dd'/'yyyy"),
                    Reason = item.Reason,
                    Remark = item.Remarks,
                    Date = item.Date,
                    Status = item.Status,
                    NoOfDays = item.NoOfDays,
                    CreatedDate = item.CreatedDate
                };
                list.Add(request);
            }
            return list;
            //return (list.OrderBy(o => o.EmployeeName).OrderByDescending(o => o.CompOffDate).ToList());
        }

        public List<DatesToRequestCompOffOrWfhBO> FetchDatesToRequestCompOff(string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            List<DatesToRequestCompOffOrWfhBO> dates = new List<DatesToRequestCompOffOrWfhBO>();
            var data = _dbContext.spGetDatesToRequestCompOff(userId).ToList();
            dates.AddRange(from d in data
                           where d.DateId != null && d.Date != null
                           select new DatesToRequestCompOffOrWfhBO()
                           {
                               DateId = d.DateId.Value,
                               DateAndOcassion = d.Date + " (" + d.Ocassion + ")"
                           });
            //mail if comp successful.
            return dates;
        }

        public bool RequestForCompOff(string date, int days, string reason, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var d = date.Split(' ')[0];
            var data = _dbContext.spRequestCompOff(DateTime.ParseExact(d, "MM/dd/yyyy", CultureInfo.InvariantCulture), userId, days, reason).FirstOrDefault();
            if (data != null)
            {
                return true;
            }
            return false;
        }

        public string TakeActionOnCompOff(int RequestID, string Userabrhs, string Status, String Remark)
        {
            var UserID = 0;
            Int32.TryParse(CryptoHelper.Decrypt(Userabrhs), out UserID);
            var status = _dbContext.spTakeActionOnCompOff(RequestID, Status, Remark, UserID, false).First();
            if ((Status.Equals("AP") || Status.Equals("RJ")) && status.Equals("SUCCEED"))
            {
                var data = _dbContext.RequestCompOffs.FirstOrDefault(f => f.RequestId == RequestID);
                var rejectedBy = _dbContext.UserDetails.FirstOrDefault(f => f.UserId == UserID);
                var userDetail = _dbContext.UserDetails.FirstOrDefault(f => f.UserId == data.CreatedBy);
                var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == EmailTemplates.CompOffRequest && f.IsActive && !f.IsDeleted);

                if (data != null && (data.StatusId == 3 || data.StatusId == -1) && userDetail != null && emailTemplate != null)
                {
                    var body = emailTemplate.Template;
                    var currentStatus = data.StatusId == -1 ? "Rejected" : "Approved";

                    if (Status.Equals("RJ"))
                        body = body.Replace("[Name]", userDetail.FirstName + ' ' + userDetail.LastName).Replace("[Date]", data.DateMaster.Date.ToString("dd-MM-yyyy")).Replace("[Status]", Status.Equals("RJ") ? "rejected by " + rejectedBy.FirstName + " " + rejectedBy.LastName : "Approved").Replace("[Reason]", " due to following reason - " + Remark);
                    else
                        body = body.Replace("[Name]", userDetail.FirstName + ' ' + userDetail.LastName).Replace("[Date]", data.DateMaster.Date.ToString("dd-MM-yyyy")).Replace("[Status]", Status.Equals("RJ") ? "rejected by " + rejectedBy.FirstName + " " + rejectedBy.LastName : "Approved").Replace("[Reason]", "");
                    var emailId = CryptoHelper.Decrypt(userDetail.EmailId);
                    EmailHelper.SendEmailWithDefaultParameter("Comp-off Request " + currentStatus, body, false, true, emailId, "", "", "");
                }
            }
            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.TakeActionOnCompOff, UserID, 0);
            return status;
        }

        #endregion      

        #region WorkFromHome

        public List<RequestForWorkFromHomeBO> GetWFHRequest(string userAbrhs, string Status, int year)
        {
            var UserId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out UserId);
            var loginUserData = _dbContext.fnGetHRDetail(UserId).FirstOrDefault();
            var IsHRVerifier = loginUserData.IsHRVerifier.Value;
            string UserType = "M";

            // var UserDetail = GetUserDetailsByUserId(userAbrhs);

            if (IsHRVerifier)
            {
                UserType = "HR";
            }

            var list = new List<RequestForWorkFromHomeBO>();

            var requests = _dbContext.spGetWFHRequest(UserId, year).ToList();


            if (UserType == "HR")
            {
                if (Status == "Pending")
                    requests = requests.Where(r => r.StatusId == 2 || r.StatusId == 1 || r.StatusId == 6).ToList();
                if (Status == "Approved")
                    requests = requests.Where(r => r.StatusId == -1 || r.StatusId == 3).ToList();
            }
            else
            {
                if (Status == "Pending")
                    requests = requests.Where(r => r.StatusId == 1 || r.StatusId == 5).ToList();
                if (Status == "Approved")
                    requests = requests.Where(r => r.StatusId == 2 || r.StatusId == -1 || r.StatusId == 3).ToList();
            }
            foreach (var item in requests)
            {
                RequestForWorkFromHomeBO request = new RequestForWorkFromHomeBO()
                {

                    RequestID = Convert.ToInt32(item.ApplicationId),
                    EmployeeName = item.EmployeeName,
                    WFHDate = item.Date.ToString("dd-MMM-yyyy"),//("MM'/'dd'/'yyyy"),
                    Reason = item.Reason,
                    Remark = item.ApproverRemarks == null ? "NA" : item.ApproverRemarks,
                    Date = item.Date,
                    Status = item.Status,
                    StatusID = Convert.ToInt32(item.StatusId),
                    UserId = UserId,
                    IsHalfDay = item.IsHalfDay,
                    CancelDisabled = "",
                    CreatedDate = item.CreatedDate
                };
                //if (Status == "Pending" && UserType == "M")
                //{
                //    if (item.Date.CompareTo(DateTime.Now) < 0)
                //    {
                //        if ((DateTime.Now - item.Date).Days > 2)
                //            request.CancelDisabled = "disabled";
                //        else
                //            request.CancelDisabled = "";
                //    }
                //    else
                //        request.CancelDisabled = "";
                //}
                list.Add(request);
            }
            return list;
            //return (list.OrderBy(o => o.EmployeeName).OrderByDescending(o => o.WFHDate).ToList());
        }

        public List<DatesToRequestCompOffOrWfhBO> FetchDatesToRequestWorkFromHome(string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            List<DatesToRequestCompOffOrWfhBO> dates = new List<DatesToRequestCompOffOrWfhBO>();
            var data = _dbContext.spGetDateForWorkFromHome(userId).ToList();
            if (data.Count > 0)
            {
                dates.AddRange(from d in data
                               where d.Date != null
                               select new DatesToRequestCompOffOrWfhBO()
                               {
                                   DateId = d.DateId,
                                   DateAndOcassion = d.Date,
                               });
                return (dates);
            }
            return null;
        }

        public string TakeActionOnWFH(int RequestID, string userAbrhs, string Status, String Remark, bool IsForwarded)
        {
            var UserID = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out UserID);

            var status = _dbContext.spTakeActionOnWorkFromHome(RequestID, Status, Remark, UserID, IsForwarded).First();

            if (status.ToString().Equals("SUCCEED"))
            {
                if (Status.Equals("RJ"))
                {
                    var data = _dbContext.spGetLeaveInformation(RequestID, UserID).FirstOrDefault();

                    var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "Reject WFH" && f.IsActive && !f.IsDeleted);
                    if (emailTemplate != null && data != null)
                    {
                        var body = emailTemplate.Template.Replace("[Name]", data.ApplicantFirstName).Replace("[Date]", data.FromDate.ToString("dd-MM-yyyy")).Replace("[RejectedBy]", data.ApproverFullName);
                        Utilities.EmailHelper.SendEmailWithDefaultParameter("WFH Rejected", body, true, true, CryptoHelper.Decrypt(data.ApplicantEmailId), null, null, null);
                    }

                }
                else if (Status.Equals("AP"))
                {
                    var data = _dbContext.spGetLeaveInformation(RequestID, UserID).FirstOrDefault();

                    var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "Approve WFH" && f.IsActive && !f.IsDeleted);
                    if (emailTemplate != null)
                    {
                        var body = emailTemplate.Template.Replace("[Name]", data.ApplicantFirstName).Replace("[Date]", data.FromDate.ToString("dd-MM-yyyy")).Replace("[ApprovedBy]", data.ApproverFullName);
                        Utilities.EmailHelper.SendEmailWithDefaultParameter("WFH Approved", body, true, true, CryptoHelper.Decrypt(data.ApplicantEmailId), null, null, null);
                    }
                }
                //else if (Status.Equals("PV"))
                //{
                //    var d = _dbContext.spGetLeaveInformation(RequestID, 4).FirstOrDefault();
                //    var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "Forward Leave" && f.IsActive && !f.IsDeleted);
                //    if (emailTemplate != null && d != null)
                //    {
                //        var body = emailTemplate.Template.Replace("[Name]", d.ApproverName).Replace("[ApplicantName]", d.ApplicantName).Replace("[Type]", "Work From Home");
                //        Utilities.EmailHelper.SendEmailWithDefaultParameter("Forwarded Work From Home Request", body, true, true, CryptoHelper.Decrypt(d.ApproverEmailId), null, null, null);
                //    }
                //}

                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.TakeActionOnWFH, UserID, 0);

                return status;
            }

            return "FAILED";
        }

        public int RequestForWorkForHome(string date, string reason, bool isFirstHalfWfh, bool isLastHalfWfh, string mobileNo, string userAbrhs, int loginUserId)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            //var data = _dbContext.spRequestWorkFromHome(userId, DateTime.ParseExact(date, "MM/dd/yyyy", CultureInfo.InvariantCulture), reason, 1, 1, mobileNo, "WFH", isHalfDay).FirstOrDefault();
            var data = _dbContext.spRequestWorkFromHome(userId, DateTime.ParseExact(date, "MM/dd/yyyy", CultureInfo.InvariantCulture), reason, 1, 1, mobileNo, "WFH", isFirstHalfWfh, isLastHalfWfh, loginUserId).FirstOrDefault();
            if (data != null)
            {
                if (data.Success == 1)
                {
                    var userName = _dbContext.UserDetails.FirstOrDefault(f => f.UserId == userId);
                    var emailId = CryptoHelper.Decrypt(data.EmailId);
                    var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "Apply WFH" && f.IsActive && !f.IsDeleted);
                    if (emailTemplate != null && userName != null)
                    {
                        var body = emailTemplate.Template.Replace("[Name]", data.FirstName)
                            .Replace("[Date]", DateTime.ParseExact(date, "MM/dd/yyyy", CultureInfo.InvariantCulture).ToString("dd-MMM-yyyy"))
                            .Replace("[ApplicantName]", userName.FirstName + " " + userName.LastName).Replace("[Reason]", reason);
                        Utilities.EmailHelper.SendEmailWithDefaultParameter("Request for WFH", body, true, true, CryptoHelper.Decrypt(data.EmailId), null, null, null);
                    }
                    // Logging 
                    _userServices.SaveUserLogs(ActivityMessages.RequestForWorkForHome, userId, 0);
                }
            }
            return data.Success.HasValue ? data.Success.Value : 0;
        }

        #endregion

        #region Dashboard

        public List<DataForAttendanceBO> FetchEmployeeAttendance(int userId, int year, int month)
        {
            var data = _dbContext.spGetAttendanceForUser(userId, year, month).ToList();
            var list = new List<DataForAttendanceBO>();
            foreach (var d in data)
            {
                var o = new DataForAttendanceBO
                {
                    DisplayDate = d.Date.ToString("dd-MMM-yyyy"),//("MM'/'dd'/'yyyy"),
                    Day = d.Day.Substring(0, 3),
                    InTime = d.InTime.HasValue ? d.InTime.Value.ToString("dd-MMM-yyyy hh:mm tt") : "N.A.", //;("MM/dd/yyyy HH:mm")
                    OutTime = d.OutTime.HasValue ? d.OutTime.Value.ToString("dd-MMM-yyyy hh:mm tt") : "N.A.", //("MM/dd/yyyy HH:mm")
                    WorkingHours = d.WorkingHours.HasValue ? d.WorkingHours.Value.ToString("HH:mm") : "N.A.",
                    Remarks = d.Status
                };
                list.Add(o);
            }
            return (list.Count == 0 ? null : list.OrderByDescending(r => r.DisplayDate).ToList());
        }

        public DataForLeaveBalanceBO ListLeaveBalanceByUserId(string employeeAbrhs)
        {
            DataForLeaveBalanceBO balance = new DataForLeaveBalanceBO();
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(employeeAbrhs), out userId);
            balance.UserId = userId;
            var genderId = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == userId).GenderId;
            if (genderId == 1)
                balance.AllocationCount = _dbContext.LeaveBalances.FirstOrDefault(x => x.UserId == userId && x.LeaveTypeId == 7).AllocationFrequency;
            else
                balance.AllocationCount = _dbContext.LeaveBalances.FirstOrDefault(x => x.UserId == userId && x.LeaveTypeId == 6).AllocationFrequency;
            var data = _dbContext.spGetLeaveBalanceForUser(userId).ToList();
            foreach (var d in data)
            {
                if (d.LeaveType.Equals("CL"))
                {
                    balance.ClCount = Convert.ToDouble(d.LeaveCount);
                }
                else if (d.LeaveType.Equals("PL"))
                {
                    balance.PlCount = Convert.ToDouble(d.LeaveCount);
                }
                else if (d.LeaveType.Equals("COFF"))
                {
                    balance.CompOffCount = Convert.ToDouble(d.LeaveCount);
                }
                else if (d.LeaveType.Equals("LWP"))
                {
                    balance.LwpCount = Convert.ToDouble(d.LeaveCount);
                }
                else if (d.LeaveType.Equals("ML"))
                {
                    balance.MlCount = 180;
                }
                else if (d.LeaveType.Equals("PL(M)"))
                {
                    balance.PlmCount = 5;
                }
                else if (d.LeaveType.Equals("5CLOY"))
                {
                    if (d.LeaveCount == 1)
                        balance.CloyAvailable = "Available";
                    else
                        balance.CloyAvailable = "Availed";
                }
            }
            if (_dbContext.EmployeeProfiles.FirstOrDefault(f => f.UserId == userId) == null)
                balance.IsBioPageFilled = false;
            else
                balance.IsBioPageFilled = true;
            balance.GenderId = genderId;
            return balance;
        }

        public List<DataForLeaveBalanceBO> ListLeaveBalanceForAllUser(string employeeAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(employeeAbrhs), out userId);
            List<DataForLeaveBalanceBO> list = new List<DataForLeaveBalanceBO>();
            var data = _dbContext.spGetLeaveBalanceForAllUser().ToList();
            var newData = new List<spGetLeaveBalanceForAllUser_Result>();
            if (userId != 0)
            {
                newData = (from t in data where t.UserId == userId select t).ToList();
            }
            else
            {
                newData = data;
            }

            foreach (var d in newData)
            {
                DataForLeaveBalanceBO balance = new DataForLeaveBalanceBO()
                {
                    Name = d.UserName,
                    ClCount = d.CL,
                    PlCount = d.PL,
                    CompOffCount = d.CompOff,
                    LwpCount = d.LWP,
                    MlCount = d.ML,
                    PlmCount = d.PL_M_,
                    EmployeeAbrhs = CryptoHelper.Encrypt(d.UserId.ToString()),
                    GenderId = Convert.ToInt16(d.GenderId)
                };
                if (d.CloyAvailable == 1)
                    balance.CloyAvailable = "Available";
                else
                    balance.CloyAvailable = "Availed";
                list.Add(balance);
            }
            return list.Count == 0 ? null : list.OrderBy(r => r.Name).ToList();
        }

        public List<DataForAttendanceBO> FetchAllEmployeesAttendance(string date)
        {
            var list = new List<DataForAttendanceBO>();
            if (!string.IsNullOrEmpty(date))
            {
                DateTime fromDate = DateTime.ParseExact(date, "MM/dd/yyyy", CultureInfo.InvariantCulture);
                var data = _dbContext.spGetAttendanceForAllUsersByDate(fromDate).ToList();
                list = (from d in data
                        where d.Date != null
                        select new DataForAttendanceBO()
                        {
                            UserName = d.Username,
                            DisplayDate = d.Date.ToString("dd-MMM-yyyy"),//("MM'/'dd'/'yyyy"),
                            Day = d.Day,
                            InTime = d.InTime.HasValue ? d.InTime.Value.ToString("dd-MMM-yyyy hh:mm tt") : "N.A.", //("MM/dd/yyyy HH:mm")
                            OutTime = d.OutTime.HasValue ? d.OutTime.Value.ToString("dd-MMM-yyyy hh:mm tt") : "N.A.", //("MM/dd/yyyy HH:mm")
                            WorkingHours = d.WorkingHours.HasValue ? d.WorkingHours.Value.ToString("HH:mm") : "N.A.",
                            Remarks = d.Remarks,
                        }).ToList();
            }
            return list.OrderBy(r => r.DisplayDate).ToList();
        }

        public EmployeeStatusDataForManagerBO FetchEmployeeAttendanceForToday(int userId)
        {
            var data = _dbContext.spGetAttendanceForTodayAndTommorrowByUserId(userId, DateTime.Now).FirstOrDefault();
            EmployeeStatusDataForManagerBO result = new EmployeeStatusDataForManagerBO()
            {
                InTime = data.TodayInTime.HasValue ? data.TodayInTime.Value.ToString("HH:mm") : "N.A.",
                OutTime = data.TodayOutTime.HasValue ? data.TodayOutTime.Value.ToString("HH:mm") : "N.A.",
                WorkingHours = data.TodayLoggedHours.HasValue ? data.TodayLoggedHours.Value.ToString("HH:mm") : "N.A.",
                YesterdayWorkingHours = data.YesterdayLoggedHours.HasValue ? data.YesterdayLoggedHours.Value.ToString("HH:mm") : "N.A."
            };

            return result;
        }

        public List<EmployeeStatusDataForManagerBO> FetchEmployeeStatusForManager(int userId, string date)
        {
            List<EmployeeStatusDataForManagerBO> list = new List<EmployeeStatusDataForManagerBO>();
            var data = _dbContext.spGetManagerResourceStatusByDate(userId, Convert.ToDateTime(date)).ToList();
            foreach (var temp in data)
            {
                EmployeeStatusDataForManagerBO test = new EmployeeStatusDataForManagerBO()
                {
                    Name = temp.Username,
                    Reason = temp.Reason,
                    Status = temp.Status,
                    InTime = temp.InTime != null ? temp.InTime.Value.ToString("dd-MMM-yyyy hh:mm tt") : "N.A.",//("MM/dd/yyyy HH:mm")
                    OutTime = temp.OutTime != null ? temp.OutTime.Value.ToString("dd-MMM-yyyy hh:mm tt") : "N.A.", //("MM/dd/yyyy HH:mm")
                    WorkingHours = temp.WorkingHours != null ? temp.WorkingHours.Value.ToString("HH:mm") : "N.A."
                };
                list.Add(test);
            }
            return list.Count == 0 ? null : list.OrderBy(r => r.Name).ToList();
        }

        public List<RawDataForPunchTimingBO> FetchAllEmployeesRawAttendanceData(string date)
        {
            DateTime finalDate = DateTime.ParseExact(date, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            var data = _dbContext.SpGetAttendanceRawDataByDate(finalDate).ToList();
            List<RawDataForPunchTimingBO> list = data.Select(d => new RawDataForPunchTimingBO()
            {
                UserId = d.UserId,
                Name = d.Name,
                Day = d.Day,
                PunchTiming = d.PunchTiming,
            }).ToList();
            return list.Count == 0 ? null : list.OrderBy(r => r.Name).ToList();
        }

        #endregion

        #region Apply Leave

        public int ApplyLeave(ApplyLeaveDetailBO newLeave) //1:date collision,2:no combination present,3:combination supplied is invalid,4:success,0:failure,5:data supplied is incorrect
        {
            if (newLeave.EmployeeAbrhs == "NA")
                newLeave.EmployeeAbrhs = newLeave.UserAbrhs;
            var loginUserId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(newLeave.UserAbrhs), out loginUserId);
            var employeeId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(newLeave.EmployeeAbrhs), out employeeId);
            var status = 0;
            using (var _dbContext = new MISEntities())
            {
                var result = new ObjectParameter("Success", typeof(int));
                //var data = _dbContext.Fun_GetUserConsecutiveLeaves(loginUserId, newLeave.FromDate, newLeave.TillDate);
                //if (data.Count() > 0)
                //{
                //    status = 7;
                //}
                //else
                //{
                _dbContext.spApplyLeave(employeeId, loginUserId, newLeave.FromDate, newLeave.TillDate, newLeave.Reason
                               , newLeave.SelectedLeaveCombination, newLeave.PrimaryContactNo, newLeave.AlternativeContactNo
                               , newLeave.IsAvailableOnMobile, newLeave.IsAvailableOnEmail, newLeave.IsFirstDayHalfDayLeave
                               , newLeave.IsLastDayHalfDayLeave, result);
                Int32.TryParse(result.Value.ToString(), out status);
                if (status == 4)
                {
                    var forClient = 1; // pimco enter null for all client
                    var employeeData = _dbContext.vwActiveUsers.FirstOrDefault(v => v.UserId == employeeId);
                    var fromDate = newLeave.FromDate.ToString("dd MMM yyyy", CultureInfo.InvariantCulture);
                    var tillDate = newLeave.TillDate.ToString("dd MMM yyyy", CultureInfo.InvariantCulture);
                    var period = fromDate == tillDate ? fromDate : fromDate + " to " + tillDate;
                    string userName = "";
                    if (employeeData != null)
                    {
                        userName = employeeData.EmployeeName;
                    }
                    var userMgrData = _dbContext.Fun_FetchUsersOnshoreMgr(employeeId, forClient).ToList();
                    var line1 = string.Format("This is to inform you that, {0} has applied leave for the period {1}. ", userName, period);
                    var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(t => t.TemplateName == EmailTemplates.LeaveMailToOnShoreMgr && t.IsActive == true && t.IsDeleted == false);
                    if (emailTemplate != null && userMgrData.Count > 0)
                    {
                        var body = emailTemplate.Template
                                                .Replace("[Header]", "Employee's Leave Information")
                                                .Replace("[Line1]", line1);
                        foreach (var t in userMgrData)
                        {
                            var mgrFirstName = t.OnshoreMgrName.Split(null)[0];
                            var mgrMail = t.EmailId;
                            body = body.Replace("[Name]", mgrFirstName);
                            Utilities.EmailHelper.SendEmailWithDefaultParameter("Employee's Leave Information", body, true, true, CryptoHelper.Decrypt(mgrMail), null, null, null);
                        }
                    }
                }

                //}
                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.ApplyLeave, loginUserId, employeeId);
                return status;
            }
        }
        public int SubmitLegitimateLeave(string employeeAbrhs, string userAbrhs, string fromDate, string type, string reason, int leaveId)
        {
            if (employeeAbrhs == "NA")
                employeeAbrhs = userAbrhs;
            var loginUserId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out loginUserId);
            var employeeId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(employeeAbrhs), out employeeId);
            var past = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 24).AddMonths(-1);
            var fromDateN = DateTime.ParseExact(fromDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            var t = fromDateN;
            var date = new DateTime(t.Year, t.Month, t.Day);
            bool IsValid = true;
            using (var _dbContext = new MISEntities())
            {
                var result = _dbContext.Proc_ApplyLegitimateLeave(employeeId, loginUserId, fromDateN, type, reason, leaveId, IsValid).FirstOrDefault();
                _userServices.SaveUserLogs(ActivityMessages.ApplyLeave, loginUserId, employeeId);
                return result.Value;
            }
        }
        //For outing request

        public List<OutingTypeBo> GetOutingType(bool checkElgibility)
        {
            List<OutingTypeBo> objresult = new List<OutingTypeBo>();
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            var loginUserId = globalData.LoginUserId;
            var userEligibility = _dbContext.Fun_GetUserToViewAttendance(loginUserId).FirstOrDefault();
            bool isEligible = userEligibility != null ? Convert.ToBoolean(userEligibility.IsEligible) : false;
            //Int32.TryParse(CryptoHelper.Decrypt(), out loginUserId);
            using (var _dbContext = new MISEntities())
            {
                var res = from a in _dbContext.OutingTypes
                          select a;
                foreach (var n in res)
                {
                    if (n.OutingTypeName != "Others")
                    {
                        var obj = new OutingTypeBo
                        {
                            OutingTypeName = n.OutingTypeName,
                            OutingTypeId = n.OutingTypeId
                        };
                        objresult.Add(obj);
                    }
                }

                if (checkElgibility && isEligible)
                {
                    var item = res.FirstOrDefault(x => x.OutingTypeName == "Others");
                    if (item != null)
                    {
                        var obj = new OutingTypeBo
                        {
                            OutingTypeName = item.OutingTypeName,
                            OutingTypeId = item.OutingTypeId
                        };
                        objresult.Add(obj);
                    }
                }
            }
            
            return objresult;
        }

        public int ApplyOutingRequest(ApplyOutingRequestDetailBO input)
        {
            int status = 0;
            if (input.LoginUserAbrhs == "NA")
                input.LoginUserAbrhs = input.EmployeeAbrhs;
            var employeeId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(input.EmployeeAbrhs), out employeeId);
            var loginUserId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(input.LoginUserAbrhs), out loginUserId);
            using (var _dbContext = new MISEntities())
            {
                var result = new ObjectParameter("Success", typeof(int));
                _dbContext.Proc_ApplyOutingRequest(employeeId, input.FromDate, input.TillDate, input.Reason, input.OutingTypeId,
                             loginUserId, input.PrimaryContactNo, input.AlternativeContactNo, result);
                Int32.TryParse(result.Value.ToString(), out status);
                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.ApplyOuting, employeeId, loginUserId);
                return status;
            }
        }
        public List<OutingRequestBO> ListApplyOutingRequest(string employeeAbrhs, int year)
        {
            var employeeId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(employeeAbrhs), out employeeId);
            var outingData = new List<OutingRequestBO>();
            var data = _dbContext.Proc_GetOutingRequestByUserId(employeeId, year).ToList();
            foreach (var temp in data)
            {
                var result = new OutingRequestBO
                {
                    Period = temp.Period,
                    OutingType = temp.OutingType,
                    Status = temp.Status,
                    Remarks = temp.Remarks,
                    ApplyDate = Convert.ToString(temp.ApplyDate),
                    Reason = temp.Reason,
                    OutingRequestId = temp.OutingRequestId,
                    StatusCode = temp.StatusCode
                };
                if (!temp.StatusCode.Equals("CA") && !temp.StatusCode.Equals("RJM") && !temp.StatusCode.Equals("RJH"))
                {
                    DateTime todayDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day);
                    if (temp.TillDate >= todayDate)
                    {
                        result.IsCancellable = true;
                    }
                    else
                    {
                        result.IsCancellable = false;
                    }
                }
                else
                {
                    result.IsCancellable = false;
                }
                outingData.Add(result);
            }
            return outingData;
        }

        public List<RequestForReviewOutingBO> GetOutingReviewRequest(string userAbrhs, int year)
        {
            var loginUserId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out loginUserId);
            var loginUserData = _dbContext.fnGetHRDetail(loginUserId).FirstOrDefault();
            var IsHRVerifier = loginUserData.IsHRVerifier.Value;
            var userType = "MGR";
            if (IsHRVerifier == true)
                userType = "HR";
            var result = _dbContext.Proc_GetOutingReviewRequest(loginUserId, year).ToList();
            var list = result.Select(item => new RequestForReviewOutingBO
            {
                OutingRequestId = item.OutingRequestId,
                EmployeeName = item.EmployeeName,
                Period = item.Period,/*.ToString("dd-MMM-yyyy"),//("MM'/'dd'/'yyyy"),*/
                Reason = item.Reason,
                ApplyDate = item.ApplyDate,
                Status = item.Status,
                StatusCode = item.StatusCode,
                DutyType = item.DutyType,
                Remarks = item.Remarks,
                UserType = userType
            }).ToList();
            return list.Count > 0 ? list : new List<RequestForReviewOutingBO>();
        }

        public List<RequestForLegititmateBO> GetLegitimateRequest(string userAbrhs, int year)
        {
            var loginUserId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out loginUserId);
            var loginUserData = _dbContext.fnGetHRDetail(loginUserId).FirstOrDefault();
            var IsHRVerifier = loginUserData.IsHRVerifier.Value;
            var userType = "MGR";
            if (IsHRVerifier == true)
                userType = "HR";
            var result = _dbContext.Proc_GetLegitimateLeave(loginUserId, year).ToList();
            var list = result.Select(item => new RequestForLegititmateBO
            {
                RequestId = item.RequestId,
                EmployeeName = item.EmployeeName,
                Date = item.Date,/*.ToString("dd-MMM-yyyy"),//("MM'/'dd'/'yyyy"),*/
                Reason = item.Reason,
                ApplyDate = item.ApplyDate,
                Status = item.Status,
                StatusCode = item.StatusCode,
                LeaveInfo = item.LeaveInfo,
                Remarks = item.Remarks,
                UserType = userType
            }).ToList();
            return list.Count > 0 ? list : new List<RequestForLegititmateBO>();
        }

        public int TakeActionOnLegitimateRequest(int requestId, string userAbrhs, string statusCode, string remark)
        {
            var loginUserId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out loginUserId);
            var loginUserData = _dbContext.fnGetHRDetail(loginUserId).FirstOrDefault();
            var IsHRVerifier = loginUserData.IsHRVerifier.Value;
            var userType = "MGR";
            if (IsHRVerifier == true)
                userType = "HR";
            if (statusCode.Equals("RJ") && userType.Equals(UserTypeCode.Manager))
                statusCode = OutingRequestStatusCode.RejectedByMGR;
            else if (statusCode.Equals("RJ") && userType.Equals(UserTypeCode.HumanResource))
                statusCode = OutingRequestStatusCode.RejectedByHR;
            else if (statusCode.Equals(OutingRequestStatusCode.Approved) && userType.Equals(UserTypeCode.HumanResource))
                statusCode = OutingRequestStatusCode.Approved;
            else if (statusCode.Equals(OutingRequestStatusCode.Approved) && userType.Equals(UserTypeCode.Manager))
                statusCode = OutingRequestStatusCode.Approved;
            var status = 0;
            var result = new ObjectParameter("Success", typeof(int));
            _dbContext.Proc_TakeActionOnLegitimateLeave(requestId, statusCode, remark, loginUserId, userType, result);
            Int32.TryParse(result.Value.ToString(), out status);
            var isVerified = _dbContext.LegitimateLeaveRequests.FirstOrDefault(x => x.LegitimateLeaveRequestId == requestId && x.NextApproverId == null);
            if (status == 1)
            {
                var statusId = _dbContext.LegitimateLeaveRequests.FirstOrDefault(s => s.LegitimateLeaveRequestId == requestId).StatusId;
                statusCode = _dbContext.LegitimateLeaveStatus.FirstOrDefault(s => s.StatusId == statusId).StatusCode;
                if (statusCode.Equals("RJM") || statusCode.Equals("RJH"))
                {
                    var data = _dbContext.Proc_GetEmpInformationForLegitimateLeave(requestId, loginUserId).FirstOrDefault();

                    var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "LWP Change Request" && f.IsActive && !f.IsDeleted);
                    if (emailTemplate != null && data != null)
                    {
                        var body = emailTemplate.Template.Replace("[Name]", data.ApplicantFirstName).Replace("[Date]", data.FromDate).Replace("[RejectedBy]", data.ApproverFullName).Replace("[Action]", "rejected");
                        Utilities.EmailHelper.SendEmailWithDefaultParameter("LWP change request rejected", body, true, true, CryptoHelper.Decrypt(data.ApplicantEmailId), null, null, null);
                    }
                }
                else if (statusCode.Equals("VD") && isVerified != null && isVerified.UserId != 2166)
                {
                    var data = _dbContext.Proc_GetEmpInformationForLegitimateLeave(requestId, loginUserId).FirstOrDefault();
                    var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "LWP Change Request" && f.IsActive && !f.IsDeleted);
                    if (emailTemplate != null)
                    {
                        var body = emailTemplate.Template.Replace("[Name]", data.ApplicantFirstName).Replace("[Date]", data.FromDate).Replace("[RejectedBy]", data.ApproverFullName).Replace("[Action]", "approved");

                        Utilities.EmailHelper.SendEmailWithDefaultParameter("LWP change request approved", body, true, true, CryptoHelper.Decrypt(data.ApplicantEmailId), null, null, null);
                    }
                }
                _userServices.SaveUserLogs(ActivityMessages.TakeActionOnOuting, loginUserId, 0);
                return status;
            }
            return status;
        }

        public int TakeActionOnOutingRequest(int outingRequestId, string userAbrhs, string statusCode, string remark)
        {
            var loginUserId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out loginUserId);
            var loginUserData = _dbContext.fnGetHRDetail(loginUserId).FirstOrDefault();
            var IsHRVerifier = loginUserData.IsHRVerifier.Value;
            var userType = "MGR";
            if (IsHRVerifier == true)
                userType = "HR";
            if (statusCode.Equals("RJ") && userType.Equals(UserTypeCode.Manager))
                statusCode = OutingRequestStatusCode.RejectedByMGR;
            else if (statusCode.Equals("RJ") && userType.Equals(UserTypeCode.HumanResource))
                statusCode = OutingRequestStatusCode.RejectedByHR;
            else if (statusCode.Equals(OutingRequestStatusCode.Approved) && userType.Equals(UserTypeCode.HumanResource))
                statusCode = OutingRequestStatusCode.Verified;
            else if (statusCode.Equals(OutingRequestStatusCode.Approved) && userType.Equals(UserTypeCode.Manager))
                statusCode = OutingRequestStatusCode.Approved;
            var status = 0;
            var result = new ObjectParameter("Success", typeof(int));
            int outingRequestDetailId = 0;
            _dbContext.Proc_TakeActionOnOutingRequest(outingRequestId, statusCode, remark, loginUserId, userType, outingRequestDetailId, "", result);
            Int32.TryParse(result.Value.ToString(), out status);
            var isVerified = _dbContext.OutingRequests.FirstOrDefault(x => x.OutingRequestId == outingRequestId && x.NextApproverId == null);
            if (status == 1)
            {
                var statusId = _dbContext.OutingRequests.FirstOrDefault(s => s.OutingRequestId == outingRequestId).StatusId;
                statusCode = _dbContext.OutingRequestStatus.FirstOrDefault(s => s.StatusId == statusId).StatusCode;
                if (statusCode.Equals("RJM") || statusCode.Equals("RJH"))
                {
                    var data = _dbContext.Proc_GetEmpInformation(outingRequestId, loginUserId).FirstOrDefault();
                    var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "Outing Request" && f.IsActive && !f.IsDeleted);
                    if (emailTemplate != null && data != null)
                    {
                        var body = "";
                        if (data.FromDate == data.TillDate)
                        {
                            body = emailTemplate.Template.Replace("[Name]", data.ApplicantFirstName).Replace("[Date]", data.FromDate).Replace("[RejectedBy]", data.ApproverFullName).Replace("[Action]", "rejected");
                        }
                        else
                        {
                            body = emailTemplate.Template.Replace("[Name]", data.ApplicantFirstName).Replace("[Date]", data.FromDate + " To " + data.TillDate).Replace("[RejectedBy]", data.ApproverFullName).Replace("[Action]", "rejected");

                        }
                        Utilities.EmailHelper.SendEmailWithDefaultParameter("Out duty/tour leave request rejected", body, true, true, CryptoHelper.Decrypt(data.ApplicantEmailId), null, null, null);
                    }

                }
                else if (statusCode.Equals("VD") && isVerified != null && isVerified.UserId != 2166)
                {
                    var data = _dbContext.Proc_GetEmpInformation(outingRequestId, loginUserId).FirstOrDefault();

                    var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "Outing Request" && f.IsActive && !f.IsDeleted);
                    if (emailTemplate != null)
                    {
                        var body = "";
                        if (data.FromDate == data.TillDate)
                        {
                            body = emailTemplate.Template.Replace("[Name]", data.ApplicantFirstName).Replace("[Date]", data.FromDate).Replace("[RejectedBy]", data.ApproverFullName).Replace("[Action]", "approved");
                        }
                        else
                        {
                            body = emailTemplate.Template.Replace("[Name]", data.ApplicantFirstName).Replace("[Date]", data.FromDate + " To " + data.TillDate).Replace("[RejectedBy]", data.ApproverFullName).Replace("[Action]", "approved");
                        }
                        Utilities.EmailHelper.SendEmailWithDefaultParameter("Out duty/tour leave request approved", body, true, true, CryptoHelper.Decrypt(data.ApplicantEmailId), null, null, null);
                    }
                }

                _userServices.SaveUserLogs(ActivityMessages.TakeActionOnOuting, loginUserId, 0);
                return status;
            }
            return status;
        }

        public List<OutingRequestGetDateBo> GetDateToCancelOutingRequest(int outingRequestId)
        {
            var dateData = new List<OutingRequestGetDateBo>();
            var data = _dbContext.Proc_GetDateToCancelOutingRequest(outingRequestId).ToList();
            foreach (var temp in data)
            {
                var result = new OutingRequestGetDateBo
                {
                    OutingRequestDetailId = temp.OutingRequestDetailId,
                    OutingDate = temp.OutingDate,
                    DisplayOutingDate = temp.OutingDate.ToString("dd-MMM-yyyy"),
                    Status = temp.Status
                };
                if (!temp.StatusCode.Equals("CA") && !temp.StatusCode.Equals("RJM") && !temp.StatusCode.Equals("RJH") && !temp.StatusCode.Equals("VD"))
                {
                    DateTime todayDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day);
                    if (temp.OutingDate >= todayDate)
                        result.IsCancellable = true;
                    else
                        result.IsCancellable = false;
                }
                else
                {
                    result.IsCancellable = false;
                }
                dateData.Add(result);
            }
            return dateData;
        }

        public string CancelOutingRequest(int outingRequestId, string userAbrhs, string statusCode, string remark, long outingRequestDetailId)
        {
            string userType = "";
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var status = 0;
            var result = new ObjectParameter("Success", typeof(int));
            _dbContext.Proc_TakeActionOnOutingRequest(outingRequestId, statusCode, remark, userId, userType, outingRequestDetailId, "Single", result);
            Int32.TryParse(result.Value.ToString(), out status);
            _userServices.SaveUserLogs(ActivityMessages.CancelOuting, userId, 0);
            if (status == 1)
                return "Cancelled";
            else if (status == 2)
                return "Unprocessed";
            else
                return "Failed";
        }

        public string CancelAllOutingRequest(int outingRequestId, string userAbrhs, string statusCode, string remark)
        {
            int outingRequestDetailId = 0;
            string userType = "";
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var status = 0;
            var result = new ObjectParameter("Success", typeof(int));
            _dbContext.Proc_TakeActionOnOutingRequest(outingRequestId, statusCode, remark, userId, userType, outingRequestDetailId, "All", result);
            Int32.TryParse(result.Value.ToString(), out status);
            _userServices.SaveUserLogs(ActivityMessages.CancelOuting, userId, 0);
            if (status == 1)
                return "Cancelled";
            else if (status == 2)
                return "Unprocessed";
            else
                return "Failed";
        }
        //End of outing request

        public LastRecordDetailBO GetLastRecordDetails(string type, string userAbrhs)
        {
            var name = string.Empty;
            var rmName = string.Empty;
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var empNameDetails = _dbContext.vwActiveUsers.FirstOrDefault(a => a.UserId == userId);
            if (empNameDetails != null)
            {
                name = empNameDetails.EmployeeName;
                rmName = empNameDetails.ReportingManagerName;
            }
            var data = _dbContext.spGetLeaveOrWfhLastRecordDetail(userId, type).FirstOrDefault();
            if (data != null) { 
                return new LastRecordDetailBO
                {
                    AlternativeContactNo = data.AlternativeContactNo,
                    PrimaryContactNo = CryptoHelper.Decrypt(data.PrimaryContactNo),
                    Name = name,
                    RMName = rmName
                };
            }
            else
            {
                if(empNameDetails != null)
                {
                    return new LastRecordDetailBO
                    {
                        AlternativeContactNo = CryptoHelper.Decrypt(empNameDetails.MobileNumber),
                        PrimaryContactNo = CryptoHelper.Decrypt(empNameDetails.MobileNumber),
                        Name = name,
                        RMName = rmName
                    };
                }
                return null;
            }
               
        }

        public DaysOnBasisOfLeavePeriodBO FetchDaysOnBasisOfLeavePeriod(string fromDate, string toDate, int leaveIdToBeCancelled, string userAbrhs)
        {
            var days = new DaysOnBasisOfLeavePeriodBO();
            if (!string.IsNullOrEmpty(fromDate) && !string.IsNullOrEmpty(toDate))
            {
                var fromDateNew = DateTime.ParseExact(fromDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
                var toDateNew = DateTime.ParseExact(toDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);

                //var fromDateNew = Convert.ToDateTime(DateTime.ParseExact(fromDate, "MM/dd/yyyy", CultureInfo.InvariantCulture));
                //var toDateNew = Convert.ToDateTime(DateTime.ParseExact(toDate, "MM/dd/yyyy", CultureInfo.InvariantCulture));
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                var holidays = _dbContext.spGetTotalWorkingDays(fromDateNew, toDateNew, userId, leaveIdToBeCancelled).FirstOrDefault();
                var data = _dbContext.Fun_GetUserConsecutiveLeaves(userId, fromDateNew, toDateNew).ToList();
                var date2 = "";
                var date1 = "";
                if (data.Count() > 0)
                {
                    var fromDateStr = data.FirstOrDefault().FromDate.Value.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture);
                    var toDateStr = data.FirstOrDefault().TillDate.Value.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture);

                    var formattedFromDate = data.FirstOrDefault().FromDate.Value.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture);
                    var formattedTillDate = data.FirstOrDefault().TillDate.Value.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture);

                    date1 = (fromDateStr.Equals(toDateStr) ? formattedFromDate : (formattedFromDate + " To " + formattedTillDate));

                    foreach (var date in data)
                    {
                        var fromDateStr2 = date.FromDate.Value.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture);
                        var toDateStr2 = date.TillDate.Value.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture);

                        var formattedFromDate2 = date.FromDate.Value.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture);
                        var formattedTillDate2 = date.TillDate.Value.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture);

                        date2 = (fromDateStr2.Equals(toDateStr2) ? formattedFromDate2 : (formattedFromDate2 + " To " + formattedTillDate2));

                    }
                }
                if (holidays != null)
                {
                    if (holidays.Status.Equals("NA"))
                    {
                        days.WorkingDays = 0;
                        days.TotalDays = 0;
                        days.Status = "NA";
                        //days.Date = data.Count() == 1 ? date1 : data.Count() > 1 ? date1 + " " + ',' + " " + date2 : string.Empty;
                        days.Date = data.Count() == 1 ? date1 : data.Count() > 1 ? (date1 + ", " + date2) : string.Empty;
                    }
                    else
                    {
                        days.WorkingDays = holidays.WorkingDays;
                        days.TotalDays = holidays.TotalDays;
                        days.Status = "VALID";
                        //days.Date = data.Count() == 1 ? date1 : data.Count() > 1 ? date1 + ',' + date2 : string.Empty;
                        days.Date = data.Count() == 1 ? date1 : data.Count() > 1 ? (date1 + ", " + date2) : string.Empty;
                    }
                }
            }
            return days;
        }
        public List<AvailableLeavesBO> FetchAvailableLeaves(double NoOfWorkingDays, long leaveApplicationId, string userAbrhs, int totalDays)
        {
            var loginUserId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out loginUserId);
            using (var _dbContext = new MISEntities())
            {
                List<AvailableLeavesBO> availableLeavesList = null;
                var data = _dbContext.spGetAvailableLeaveCombination(loginUserId, NoOfWorkingDays, leaveApplicationId, totalDays).ToList();
                if (data.Any())
                {
                    availableLeavesList = data.Select(x => new AvailableLeavesBO
                    {
                        LeaveCombination = x
                    }).ToList();
                }
                return availableLeavesList ?? new List<AvailableLeavesBO>();
            }
        }

        public List<LeavesBO> AvailableLeaveForLegitimate(double noOfWorkingDays, long leaveApplicationId, string userAbrhs)
        {
            var loginUserId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out loginUserId);
            using (var _dbContext = new MISEntities())
            {
                var data = _dbContext.spGetAvailableLeaveCombination(loginUserId, noOfWorkingDays, leaveApplicationId, 1).ToList();
                var res = data
                    .Where(x => x.IndexOf("+") == -1 && !x.ToUpper().Contains("LWP"))
                    .Select(x => new LeavesBO
                    {
                        LeaveCombination = x
                    }).ToList();

                //if (res.Any())
                //{
                //    availableLeavesList = res.Select(x => new LeavesBO
                //    {
                //        LeaveCombination = x
                //    }).ToList();
                //}
                return res;
            }
        }

        public int CancelLeave(long leaveApplicationId, string remarks, string userAbrhs, bool isCancelByHR, string forLeaveType, string type)
        {
            var loginUserId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out loginUserId);
            int response = 0;

            if (forLeaveType == "LEAVE")
            {
                var leaveData = _dbContext.LeaveRequestApplications.FirstOrDefault(k => k.LeaveRequestApplicationId == leaveApplicationId);
                var todayDate = DateTime.Today;
                var dateNow = new DateTime(todayDate.Year, todayDate.Month, todayDate.Day);
                if (leaveData != null && leaveData.DateMaster.Date.CompareTo(dateNow) < 0 && !isCancelByHR)
                    response = 2;
                var x = _dbContext.spTakeActionOnAppliedLeave(leaveApplicationId, "CA", remarks, loginUserId, null).FirstOrDefault();
                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.CancelLeave, loginUserId, 0);
                if (x.Equals("SUCCEED"))
                {
                    response = 0;
                    var fromDate = "";
                    var tillDate = "";
                    string userName = "";
                    if (leaveData != null)
                    {
                        var employeeData = _dbContext.vwActiveUsers.FirstOrDefault(v => v.UserId == leaveData.UserId);
                        if (employeeData != null)
                        {
                            userName = employeeData.EmployeeName;
                            fromDate = _dbContext.DateMasters.FirstOrDefault(t => t.DateId == leaveData.FromDateId).Date.ToString("dd MMM yyyy", CultureInfo.InvariantCulture);
                            tillDate = _dbContext.DateMasters.FirstOrDefault(t => t.DateId == leaveData.TillDateId).Date.ToString("dd MMM yyyy", CultureInfo.InvariantCulture);
                        }
                        var forClient = 1;// pimco enter null for all client
                        var userMgrData = _dbContext.Fun_FetchUsersOnshoreMgr(leaveData.UserId, forClient).ToList();
                        var period = fromDate == tillDate ? fromDate : fromDate + " to " + tillDate;
                        var line1 = string.Format("This is to inform you that, {0} has cancelled the leave for the period {1}. ", userName, period);
                        var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(t => t.TemplateName == EmailTemplates.LeaveMailToOnShoreMgr && t.IsActive == true && t.IsDeleted == false);
                        if (emailTemplate != null && userMgrData.Count > 0)
                        {
                            var body = emailTemplate.Template
                                                    .Replace("[Header]", "Employee's Leave Information")
                                                    .Replace("[Line1]", line1);
                            foreach (var t in userMgrData)
                            {
                                var mgrFirstName = t.OnshoreMgrName.Split(null)[0];
                                var mgrMail = t.EmailId;
                                body = body.Replace("[Name]", mgrFirstName);
                                Utilities.EmailHelper.SendEmailWithDefaultParameter("Employee's Leave Information", body, true, true, CryptoHelper.Decrypt(mgrMail), null, null, null);
                            }
                        }
                    }
                }
                else if (x.Equals("CANCELLED"))
                {
                    response = 2;
                }
                else
                    response = 1;
            }
            else if (forLeaveType == "OUTING")
            {
                var outingRequestId = leaveApplicationId;
                var status = 0;
                var result = new ObjectParameter("Success", typeof(int));
                _dbContext.Proc_TakeActionOnOutingRequest(outingRequestId, "CA", remarks, loginUserId, "SPECIAL", 0, "All", result);
                Int32.TryParse(result.Value.ToString(), out status);
                _userServices.SaveUserLogs(ActivityMessages.CancelOuting, loginUserId, 0);
                //  if (status == 1)
                //return "Cancelled";
                //else if (status == 0)
                //    return "Failed";
                //else if (status == 2)
                //    return "Unprocessed";
                response = status;
            }
            else if (forLeaveType == "LNSA")
            {
                var status = "CA";
                var action = "All";
                var msg = 0;
                var lnsaRequestId = leaveApplicationId;
                var result = new ObjectParameter("Success", typeof(int));
                _dbContext.spTakeActionOnLnsaRequest(loginUserId, lnsaRequestId, remarks, status, action, result);
                Int32.TryParse(result.Value.ToString(), out msg);
                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.LnsaShiftCancel, loginUserId, msg);
                response = msg;
            }
            else if (forLeaveType == "AdvanceLeave")
            {
                var msg = 0;
                var result = new ObjectParameter("Success", typeof(int));
                _dbContext.Proc_CancelAdvanceLeave(leaveApplicationId, type, loginUserId, result);
                Int32.TryParse(result.Value.ToString(), out msg);
                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.AdvanceLeaveCancelled, loginUserId, 0);
                response = msg;
            }
            else if (forLeaveType == "LWPChangeRequest")
            {
                int status = 0;
                var userType = "HR";
                var statusCode = "CA";
                var legitimateLeaveRequestId = leaveApplicationId;
                var result = new ObjectParameter("Success", typeof(int));
                _dbContext.Proc_TakeActionOnLegitimateLeave(legitimateLeaveRequestId, statusCode, remarks, loginUserId, userType, result);
                Int32.TryParse(result.Value.ToString(), out status);

                response = status;
            }
            return response;
        }

        #endregion

        #region DataChange Request

        public List<RequestDataChangeBO> FetchDateForDataChange(string category, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            category = category.Equals("Leave") ? "LV" : "AT";
            List<RequestDataChangeBO> list = new List<RequestDataChangeBO>();
            var data = _dbContext.spGetDatesForDataChangeRequest(userId, category).ToList();
            foreach (var temp in data)
            {
                RequestDataChangeBO finalData = new RequestDataChangeBO
                {
                    Period = temp.Date,
                    Id = temp.RecordId,
                };
                list.Add(finalData);
            }
            return list.Count == 0 ? null : list;
        }

        public List<DataChangeRequestApplicationBO> GetDataChangeRequest(string userAbrhs, string Status, int year)
        {
            var UserId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out UserId);
            var loginUserData = _dbContext.fnGetHRDetail(UserId).FirstOrDefault();
            var IsHRVerifier = loginUserData.IsHRVerifier.Value;
            string UserType = "M";
            // var UserDetail = GetUserDetailsByUserId(userAbrhs);
            if (IsHRVerifier)
            {
                UserType = "HR";
            }
            List<DataChangeRequestApplicationBO> list = new List<DataChangeRequestApplicationBO>();
            var data = _dbContext.spGetDataChangeRequests(UserId, UserType, year).ToList();
            foreach (var temp in data)
            {
                if (UserType == "HR" && Status == "PA" && temp.StatusId == 2)
                {
                    DataChangeRequestApplicationBO finalData = new DataChangeRequestApplicationBO()
                    {
                        DataChangeRequestApplicationId = temp.ApplicationId,
                        Category = temp.Category,
                        ChangePeriod = temp.Period,
                        EmployeeName = temp.EmployeeName,
                        Remarks = temp.ApproverRemarks,
                        Reason = temp.Reason,
                        Status = temp.Status,
                        CreatedDate = temp.CreatedDate
                    };
                    list.Add(finalData);
                }
                if (UserType == "HR" && Status == "AP" && (temp.StatusId != 2))
                {
                    DataChangeRequestApplicationBO finalData = new DataChangeRequestApplicationBO()
                    {
                        DataChangeRequestApplicationId = temp.ApplicationId,
                        Category = temp.Category,
                        ChangePeriod = temp.Period,
                        EmployeeName = temp.EmployeeName,
                        Remarks = temp.ApproverRemarks,
                        Reason = temp.Reason,
                        Status = temp.Status,
                        CreatedDate = temp.CreatedDate
                    };
                    list.Add(finalData);
                }
                if (UserType == "M" && Status == "AP" && (temp.StatusId != 1))
                {
                    DataChangeRequestApplicationBO finalData = new DataChangeRequestApplicationBO()
                    {
                        DataChangeRequestApplicationId = temp.ApplicationId,
                        Category = temp.Category,
                        ChangePeriod = temp.Period,
                        EmployeeName = temp.EmployeeName,
                        Remarks = temp.ApproverRemarks,
                        Reason = temp.Reason,
                        Status = temp.Status,
                        CreatedDate = temp.CreatedDate
                    };
                    list.Add(finalData);
                }
                if (UserType == "M" && Status == "PA" && temp.StatusId == 1)
                {
                    DataChangeRequestApplicationBO finalData = new DataChangeRequestApplicationBO()
                    {
                        DataChangeRequestApplicationId = temp.ApplicationId,
                        Category = temp.Category,
                        ChangePeriod = temp.Period,
                        EmployeeName = temp.EmployeeName,
                        Remarks = temp.ApproverRemarks,
                        Reason = temp.Reason,
                        Status = temp.Status,
                        CreatedDate = temp.CreatedDate
                    };
                    list.Add(finalData);
                }
            }
            return list.Count == 0 ? list : list.OrderBy(o => o.EmployeeName).OrderByDescending(o => o.ChangePeriod).ToList();
        }

        public bool InsertRequestForDataChange(string type, int recordId, string reason, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var data = _dbContext.spInsertDataChangeRequest(userId, type, recordId, reason).FirstOrDefault();
            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.InsertRequestForDataChange, userId, 0);
            _dbContext.SaveChanges();
            if (data != null)
            {
                return true;
            }
            return false;
        }

        public string TakeActionOnDataChangeRequest(RequestDataChangeBO requestDataChange)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(requestDataChange.UserAbrhs), out userId);
            var data = _dbContext.spTakeActionOnDataVerificationRequest(requestDataChange.Id, requestDataChange.Status, requestDataChange.Remarks, userId).FirstOrDefault();
            if (data != null && data.Equals("SUCCEED"))
            {
                if (requestDataChange.Status.Equals("AP") || requestDataChange.Status.Equals("RJ"))
                {
                    var dataChange =
                        _dbContext.AttendanceDataChangeRequestApplications.FirstOrDefault(f => f.RequestId == requestDataChange.Id);
                    var userDetail = _dbContext.UserDetails.FirstOrDefault(f => f.UserId == dataChange.CreatedBy);
                    var currentStatus = requestDataChange.Status.Equals("RJ") ? "Rejected" : "Approved";
                    var email = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "DataChange" && f.IsActive && !f.IsDeleted);
                    if (email != null)
                    {
                        var body = email.Template;
                        if (userDetail != null)
                        {
                            body = body.Replace("[Name]", userDetail.FirstName + ' ' + userDetail.LastName).Replace("[Period]", requestDataChange.Period).Replace("[Status]", requestDataChange.Status.Equals("RJ") ? "Rejected" : "Approved");
                            var emailId = CryptoHelper.Decrypt(userDetail.EmailId);
                            EmailHelper.SendEmailWithDefaultParameter("Data Change Request " + currentStatus + " For Period :" + requestDataChange.Period, body, false, true, emailId, "", "", "");
                        }
                    }
                }
                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.TakeActionOnDataChangeRequest, userId, 0);
                return data;
            }
            return null;
        }

        public List<LWPMarkedBySystemData> ListLWPMarkedBySystemByUserId(int userId)
        {
            var data = _dbContext.spGetUserAppliedLeaveForLWPChangeRequest(userId).ToList();
            var LWPLeaveData = data.Select(s => new LWPMarkedBySystemData
            {
                LeaveDate = s.Date.ToString("MM/dd/yyyy", CultureInfo.InvariantCulture),
                LeaveId = s.LeaveId,
                IsApplied = s.IsApplied.HasValue ? s.IsApplied.Value : false
            }).ToList();

            return LWPLeaveData ?? new List<LWPMarkedBySystemData>();
        }

        #endregion

        #region UpdateLeave

        public List<DataForLeaveManagementBO> ListAvailedLeaveByUserId(string employeeAbrhs, int year)
        {
            List<DataForLeaveManagementBO> leaveDataByUserId = new List<DataForLeaveManagementBO>();
            var userId = 0;
            bool IsWFHData = true;
            bool isOutingData = true;
            bool isLnsaData = true;
            bool isAdvanceLeaveData = true;
            bool isLwpChangeReq = true;
            Int32.TryParse(CryptoHelper.Decrypt(employeeAbrhs), out userId);
            var data = _dbContext.spGetUserAppliedLeave(userId, year, IsWFHData, isOutingData, isLnsaData, isLwpChangeReq, isAdvanceLeaveData).ToList();
            foreach (var temp in data)
            {
                    var leaveData = new DataForLeaveManagementBO
                    {
                        DisplayFromDate = temp.FromDate.ToString("dd-MMM-yyyy"),//("MM'/'dd'/'yyyy"),
                        DisplayTillDate = temp.TillDate.ToString("dd-MMM-yyyy"),//("MM'/'dd'/'yyyy"),
                        DisplayApplyDate = temp.ApplyDate.ToString("dd-MMM-yyyy hh:mm tt"),
                        LeaveId = temp.LeaveRequestApplicationId,
                        Reason = temp.Reason,
                        LeaveType = temp.LeaveInfo,
                        Status = temp.StatusFullForm,
                        FetchLeaveType = temp.FetchLeaveType,
                        IsApplied = temp.IsLegitimateApplied,
                        LWPChangeRequestAppliedOn = temp.LegitimateAppliedOn,
                        RemarksLeaveType = temp.RemarksLeaveType,
                        CreatedBy = temp.CreatedBy,
                        StatusCode = temp.Status
                    };
                    if (temp.FetchLeaveType == "AdvanceLeave")
                    {
                        var advanceLeaveDetailData = _dbContext.AdvanceLeaveDetails.Where(a => a.AdvanceLeaveId == temp.LeaveRequestApplicationId && a.IsActive == true && a.IsAdjusted == false).ToList();
                        if (advanceLeaveDetailData.Count == 0)
                        {
                            leaveData.IsCancellable = false;
                        }
                        else
                        {
                            leaveData.IsCancellable = true;
                        }
                    }

                    leaveDataByUserId.Add(leaveData);
            }
            return leaveDataByUserId.Count == 0 ? new List<DataForLeaveManagementBO>() : leaveDataByUserId;
        }

        public bool UpdateLeaveBalanceByHR(int type, string employeeAbrhs, double ClCount, double PlCount, double CompOffCount, double LwpCount, string Cloy, double mLCount, int allocationCount, string userAbrhs)
        {
            var UserId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(employeeAbrhs), out UserId);
            var UpdatedBy = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out UpdatedBy);
            var data = _dbContext.spUpdateEmployeeLeaveBalanceByHR(type, UserId, ClCount, PlCount, CompOffCount, LwpCount, Cloy.Equals("Available"), mLCount, allocationCount, UpdatedBy).FirstOrDefault();
            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.UpdateLeaveBalanceByHR, UpdatedBy, UserId);
            if (data == 1)
                return true;
            return false;
        }

        public int SubmitAdvanceLeave(string employeeAbrhs, string fromDate, string tillDate, string reason, int loginUserId)
        {
            var fromDateTime = DateTime.ParseExact(fromDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            var tillDateTime = DateTime.ParseExact(tillDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);

            var employeeId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(employeeAbrhs), out employeeId);
            int status = 0;
            var result = new ObjectParameter("Success", typeof(int));
            _dbContext.Proc_SubmitAdvanceLeave(employeeId, fromDateTime, tillDateTime, reason, loginUserId, result);
            Int32.TryParse(result.Value.ToString(), out status);
            return status;
        }

        public List<LnsaDateBO> GetDatesToCancelAdvanceLeave(long leaveId)
        {
            var data = from t in _dbContext.AdvanceLeaveDetails.Where(s => s.AdvanceLeaveId == leaveId)
                       join d in _dbContext.DateMasters on t.DateId equals d.DateId
                       select new
                       {
                           d.Date,
                           t.AdvanceLeaveDetailId,
                           t.IsAdjusted,
                           t.IsActive
                       };
            var newResult = data.ToList();
            var newData = newResult.Select(t => new LnsaDateBO
            {
                Date = t.Date.ToString("dd MMM yyyy", CultureInfo.InvariantCulture),
                Status = t.IsActive == true && t.IsAdjusted == false ? "Active & Not Adjusted" : t.IsActive == true && t.IsAdjusted == true ? "Active & Adjusted" : "Cancelled",
                LnsaRequestDetailId = t.AdvanceLeaveDetailId,
                IsCancellable = t.IsActive == true && t.IsAdjusted == false ? true : false,
            }).ToList();


            return newData ?? new List<LnsaDateBO>();
        }

        #endregion

        #region Update Attendance

        public List<AttendanceStatusDataBO> LoadRemarks()
        {
            List<AttendanceStatusDataBO> statusData = new List<AttendanceStatusDataBO>();
            var data = _dbContext.spLoadAttendanceStatus().ToList();
            foreach (var d in data)
            {
                var temp = new AttendanceStatusDataBO()
                {
                    AttendanceStatusId = d.StatusId,
                    Remarks = d.Status
                };
                statusData.Add(temp);
            }
            return statusData.Count == 0 ? null : statusData;
        }

        public EmployeeAttendanceDetailsBO GetEmployeeAttendanceDetails(string employeeAbrhs, string date)
        {
            var result = new EmployeeAttendanceDetailsBO();
            if (!string.IsNullOrEmpty(date) && !string.IsNullOrEmpty(employeeAbrhs))
            {
                var employeeId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(employeeAbrhs), out employeeId);
                var dateNew = Convert.ToDateTime(DateTime.ParseExact(date, "MM/dd/yyyy", CultureInfo.InvariantCulture));
                var data = _dbContext.spGetEmployeeAttendanceDetailsByDate(employeeId, dateNew).FirstOrDefault();
                if (data != null)
                {
                    result.AttendanceId = data.RecordId;
                    result.InTime = data.InTime.Value.ToString("HH:mm");
                    result.OutTime = data.OutTime.Value.ToString("HH:mm");
                    result.Remarks = data.StatusRemarks;
                    result.StatusId = data.StatusId;
                    result.StatusRemarks = data.StatusRemarks;
                }
            }
            return result;
        }

        public bool UpdateEmployeeAttendanceDetails(string employeeAbrhs, long attendanceId, string inTime, string outTime, int statusId, string remarks, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var employeeId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(employeeAbrhs), out employeeId);

            var data = _dbContext.spUpdateEmployeeAttendanceDetails(employeeId, attendanceId, DateTime.Parse(inTime), DateTime.Parse(outTime), statusId, remarks, userId).FirstOrDefault();

            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.UpdateEmployeeAttendanceDetails, userId, employeeId);

            if (data != null && data.Equals("SUCCEED"))
                return true;
            return false;
        }

        #endregion

        #region Status /History

        public List<DataForLeaveManagementBO> ListLeaveByUserId(string userAbrhs, int year)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            bool isWFHData = false;
            bool isOutingData = false;
            bool isLnsaData = false;
            bool isAdvanceLeaveData = false;
            bool isLwpChangeReq = false;
            var leaveDataByUserId = new List<DataForLeaveManagementBO>();
            var data = _dbContext.spGetUserAppliedLeave(userId, year, isWFHData, isOutingData, isLnsaData, isLwpChangeReq, isAdvanceLeaveData).ToList();
            foreach (var temp in data)
            {
                var leaveData = new DataForLeaveManagementBO
                {
                    DisplayApplyDate = temp.ApplyDate.ToString("dd-MMM-yyyy hh:mm tt"),
                    DisplayFromDate = temp.FromDate.ToString("dd-MMM-yyyy"),//("MM'/'dd'/'yyyy"),
                    DisplayTillDate = temp.TillDate.ToString("dd-MMM-yyyy"),//("MM'/'dd'/'yyyy"),
                    LeaveId = temp.LeaveRequestApplicationId,
                    Reason = temp.Reason,
                    LeaveType = temp.LeaveInfo,
                    Status = temp.StatusFullForm,
                    StatusCode = temp.Status,
                    Remarks = temp.Remarks,
                    NoOfDays = temp.LeaveCount.Value,
                    FromDate = temp.FromDate.ToString("dd-MM-yyyy"),
                    TillDate = temp.TillDate.ToString("dd-MM-yyyy"),
                    IsApplied = temp.IsLegitimateApplied,
                    LWPChangeRequestAppliedOn = temp.LegitimateAppliedOn

                };
                var today = DateTime.Today;
                var dayNew = today.Day;
                if (dayNew > 24)
                {
                    today = today.AddMonths(1);
                }
                var prevMonthDate = new DateTime(today.Year, today.Month, 25).AddMonths(-1); //From 25th of Previous month
                var currentMonthDate = new DateTime(today.Year, today.Month, 24);            //Till 24th of Current month
                var t = temp.FromDate;
                var date = new DateTime(t.Year, t.Month, t.Day);

                if (!temp.Status.Equals("CA") && !temp.Status.Equals("RJ"))  //&& !temp.Status.Equals("AV")
                {
                    if (date >= prevMonthDate)
                    {
                        leaveData.CancelDisabled = "";
                    }
                    else
                    {
                        leaveData.CancelDisabled = "disabled";
                    }
                }
                else
                {
                    leaveData.CancelDisabled = "disabled";
                }
                leaveDataByUserId.Add(leaveData);
            }
            return leaveDataByUserId;
        }

        public List<DataForLeaveManagementBO> ListLegitimatetByUserId(string userAbrhs, int year)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var leaveDataByUserId = new List<DataForLeaveManagementBO>();
            var data = _dbContext.Proc_UserAppliedLegitimateLeave(userId, year).ToList();
            foreach (var temp in data)
            {
                var leaveData = new DataForLeaveManagementBO
                {
                    DisplayApplyDate = temp.ApplyDate.ToString(),
                    LeaveId = temp.LeaveApplicationId,
                    Reason = temp.Reason,
                    LeaveType = temp.LeaveInfo,
                    Status = temp.StatusFullForm,
                    StatusCode = temp.Status,
                    Remarks = temp.Remarks,
                    NoOfDays = temp.LeaveCount,
                    FromDate = temp.FromDate.ToString(),
                };
                leaveDataByUserId.Add(leaveData);
            }
            return leaveDataByUserId;
        }

        public List<DataForLeaveManagementBO> ListWorkFromHomeByUserId(string userAbrhs, int year)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var list = new List<DataForLeaveManagementBO>();
            var dataList = _dbContext.spGetUserAppliedWorkFromHome(userId, year).ToList();
            foreach (var temp in dataList)
            {
                DataForLeaveManagementBO data = new DataForLeaveManagementBO
                {
                    DisplayApplyDate = temp.ApplyDate.ToString("dd-MMM-yyyy hh:mm tt"),
                    DisplayFromDate = temp.FromDate.ToString("dd-MMM-yyyy"),//("MM'/'dd'/'yyyy"),
                    LeaveId = temp.WorkFromHomeId,
                    Reason = temp.Reason,
                    Status = temp.StatusFullForm,
                    StatusCode = temp.Status,
                    IsHalfDay = temp.IsHalfDay,
                    Remarks = temp.Remarks
                };
                var today = DateTime.Today;
                var dayNew = today.Day;
                if (dayNew > 24)
                {
                    today = today.AddMonths(1);
                }
                var prevMonthDate = new DateTime(today.Year, today.Month, 25).AddMonths(-1); //From 25th of Previous month
                var currentMonthDate = new DateTime(today.Year, today.Month, 24);            //Till 24th of Current month
                var t = temp.FromDate;
                var date = new DateTime(t.Year, t.Month, t.Day);
                if (!temp.Status.Equals("CA") && !temp.Status.Equals("RJ") && !temp.Status.Equals("AV"))
                {
                    if (date >= prevMonthDate && date <= currentMonthDate)
                    {
                        data.CancelDisabled = "";
                    }
                    else
                    {
                        data.CancelDisabled = "disabled";
                    }
                }
                else
                {
                    data.CancelDisabled = "disabled";
                }

                list.Add(data);
            }
            return list;
        }

        public List<DataForLeaveManagementBO> ListCompOffByUserId(string userAbrhs, int year)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var result = new List<DataForLeaveManagementBO>();
            var data = _dbContext.spGetUserAppliedCompOff(userId, year).ToList();
            if (data.Any())
            {
                foreach (var temp in data)
                {
                    result.Add(new DataForLeaveManagementBO
                    {
                        LeaveId = temp.RequestId,
                        DisplayFromDate = temp.Date.ToString("dd-MMM-yyyy"),//("MM'/'dd'/'yyyy"),
                        Reason = temp.Reason,
                        NoOfDays = temp.NoOfDays,
                        Status = temp.Status,
                        StatusCode = temp.StatusCode,
                        Remarks = temp.ApproverRemarks,
                        DisplayApplyDate = temp.AppliedOn.ToString("dd-MMM-yyyy hh:mm tt"),
                        IsLapsed = temp.IsLapsed,
                        LapseDate = temp.LapseDate.ToString("dd-MMM-yyyy"),
                        AvailabilityStatus = temp.AvailabilityStatus,
                        StatusId = temp.StatusId,
                    });
                }
            }
            return result ?? new List<DataForLeaveManagementBO>();
        }

        public List<DataForLeaveManagementBO> ListDataChangeRequestByUserId(string userAbrhs, int year)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var result = new List<DataForLeaveManagementBO>();
            var data = _dbContext.spGetUserAppliedDataChangeRequest(userId, year).ToList();
            if (data.Any())
            {
                foreach (var temp in data)
                {
                    result.Add(new DataForLeaveManagementBO
                    {
                        LeaveId = temp.RequestId,
                        Category = temp.Category,
                        Reason = temp.Reason,
                        Status = temp.Status,
                        Remarks = temp.ApproverRemarks,
                        DisplayApplyDate = temp.AppliedOn.ToString("dd-MMM-yyyy hh:mm tt"),
                    });
                }
            }
            return result;
        }

        #endregion

        #region View Attendance

        //public List<LockedUserDetailBO> GetDepartmentOnReportToBasis(int userId)
        //{
        //    List<LockedUserDetailBO> data = new List<LockedUserDetailBO>();
        //    var departments = _dbContext.spGetDepartmentForAttendanceRegisterByUserId(userId).ToList();
        //    if (departments.Any())
        //    {
        //        foreach (var temp in departments)
        //        {
        //            LockedUserDetailBO t = new LockedUserDetailBO()
        //            {
        //                //UserId = temp.DepartmentId,
        //                UserName = temp.DepartmentName,
        //            };
        //            data.Add(t);
        //        }
        //        return data.OrderBy(f => f.UserName).ToList();
        //    }
        //    else
        //        return null;
        //}

        public List<LockedUserDetailBO> GetEmployeeForAttendanceOnReportToBasis(string date, int departmentId, int userId)
        {
            List<LockedUserDetailBO> data = new List<LockedUserDetailBO>();
            DateTime Date = DateTime.ParseExact(date, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            var employees = _dbContext.spGetUsersForAttendanceRegisterByUserIdAndDepartmentId(userId, Date, departmentId).ToList();
            if (employees.Any())
            {
                foreach (var temp in employees)
                {
                    LockedUserDetailBO t = new LockedUserDetailBO()
                    {
                        //UserId = temp.EmployeeId,
                        UserName = temp.EmployeeName
                    };
                    data.Add(t);
                }
                return data.OrderBy(f => f.UserName).ToList();
            }
            else
                return null;
        }

        public List<AttendanceDataBO> ProcessEmployeeAttendance(string fromDate, string tillDate, int departmentId, int forEmployeeId, int userId)
        {
            var attendanceData = new List<AttendanceDataBO>();
            var startDate = DateTime.ParseExact(fromDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            var endDate = DateTime.ParseExact(tillDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            var data =
                _dbContext.spGeAttendanceRegisterByDepartmentIdOrEmployeeIdForEmployeesReportingToUser(startDate,
                    endDate, departmentId, forEmployeeId, userId).ToList();
            if (data.Any())
            {
                foreach (var temp in data)
                {
                    AttendanceDataBO t = new AttendanceDataBO
                    {
                        Date = temp.Date,
                        Department = temp.Department,
                        EmployeeName = temp.EmployeeName,
                        InTime = temp.InTime,
                        OutTime = temp.OutTime,
                        LoggedInHours = temp.LoggedInHours
                    };
                    attendanceData.Add(t);
                }
                return attendanceData;
            }
            else
                return new List<AttendanceDataBO>();
        }

        #endregion

        public static UserDetailProfile GetUserDetailsByUserId(string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                var currentdate = DateTime.Now;
                var user = (from a in context.Users.Where(x => x.IsActive && x.UserId == userId)
                            select new BO.UserDetailProfile
                            {
                                DesignationGroupId = a.UserDetails.Where(b => b.UserId == a.UserId).FirstOrDefault().Designation.DesignationGroupId,
                                UserId = a.UserId,
                                UserName = a.UserName,
                                RoleId = a.RoleId,
                                CompanyLocationId = a.LocationId,
                                ImagePath = a.UserDetails.Where(b => b.UserId == a.UserId).FirstOrDefault().ImagePath,
                                FirstName = a.UserDetails.Where(b => b.UserId == a.UserId).FirstOrDefault().FirstName,
                                LastName = a.UserDetails.Where(b => b.UserId == a.UserId).FirstOrDefault().LastName,
                                Designation =
                                    a.UserDetails.Where(b => b.UserId == a.UserId)
                                        .FirstOrDefault()
                                        .Designation.DesignationName,
                                RoleName = a.Role.RoleName,
                                Email = a.UserDetails.Where(b => b.UserId == a.UserId).FirstOrDefault().EmailId,
                            }).FirstOrDefault();
                return user ?? new UserDetailProfile();
            }
        }
        #endregion

        #region Bulk Approve

        public string TakeActionOnLeaveBulkApprove(string RequestID, string Userabrhs, string Status, String Remark, string ForwardedAbrhs)
        {
            var UserID = 0;
            Int32.TryParse(CryptoHelper.Decrypt(Userabrhs), out UserID);
            var ForwardedID = 0;
            Int32.TryParse(CryptoHelper.Decrypt(ForwardedAbrhs), out ForwardedID);
            var statusList = _dbContext.Proc_BulkActionOnApproveLeave(RequestID, Status, Remark, UserID, ForwardedID).ToList();
            foreach (var item in statusList)
            {
                if (!string.IsNullOrEmpty(item.Msg) && item.Msg.ToString().Equals("SUCCEED"))
                {
                    return "SUCCEED";

                    //if (Status.Equals("PV"))
                    //{
                    //    var data = _dbContext.LeaveRequestApplications.FirstOrDefault(x => x.LeaveRequestApplicationId == item.ApplicationId);
                    //    if (data != null)
                    //    {
                    //        var leave = data.LeaveCombination.Split();
                    //        if (leave[1].Equals("CL") && float.Parse(leave[0]) > 2)
                    //        {
                    //            var d = _dbContext.spGetLeaveInformation(item.ApplicationId, data.ApproverId).FirstOrDefault();
                    //            var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "Forward Leave" && f.IsActive && !f.IsDeleted);
                    //            if (emailTemplate != null && d != null)
                    //            {
                    //                var body = emailTemplate.Template.Replace("[Name]", d.ApproverName).Replace("[ApplicantName]", d.ApplicantName).Replace("[Type]", "Leave");
                    //                Utilities.EmailHelper.SendEmailWithDefaultParameter("Forwarded leave", body, true, true, CryptoHelper.Decrypt(d.ApproverEmailId), null, null, null);
                    //            }

                    //        }

                    //    }
                    //}
                }
            }
            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.BulkTakeActionOnLeave, UserID, 0);
            return "SUCCEED";
        }

        public string TakeActionOnCompOffBulkApprove(string RequestID, string Userabrhs, string Status, String Remark)
        {
            var UserID = 0;
            Int32.TryParse(CryptoHelper.Decrypt(Userabrhs), out UserID);
            var statusList = _dbContext.Proc_BulkActionOnApproveCompOff(RequestID, Status, Remark, UserID, false).ToList();
            foreach (var item in statusList)
            {
                if (!string.IsNullOrEmpty(item.Msg) && item.Msg.Equals("SUCCEED"))
                {
                    var data = _dbContext.RequestCompOffs.FirstOrDefault(f => f.RequestId == item.ApplicationId);
                    var rejectedBy = _dbContext.UserDetails.FirstOrDefault(f => f.UserId == UserID);
                    var userDetail = _dbContext.UserDetails.FirstOrDefault(f => f.UserId == data.CreatedBy);
                    var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "Comp-Off" && f.IsActive && !f.IsDeleted);
                    if (data != null && userDetail != null && emailTemplate != null)
                    {
                        var body = emailTemplate.Template;
                        var currentStatus = Status.Equals("RJ") ? "Rejected" : "Approved";
                        body = body.Replace("[Name]", userDetail.FirstName + ' ' + userDetail.LastName).Replace("[Date]", data.DateMaster.Date.ToString("dd-MM-yyyy")).Replace("[Status]", Status.Equals("RJ") ? "rejected by " + rejectedBy.FirstName + " " + rejectedBy.LastName : "Approved").Replace("[Reason]", "");
                        var emailId = CryptoHelper.Decrypt(userDetail.EmailId);
                        EmailHelper.SendEmailWithDefaultParameter("Comp-off Request " + currentStatus + " For Date : " + data.DateMaster.Date.ToString("dd-MM-yyyy"), body, false, true, emailId, "", "", "");
                    }
                }
            }
            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.BulkTakeActionOnCompOff, UserID, 0);
            return "SUCCEED";
        }

        public string TakeActionOnWFHBulkApprove(string RequestID, string userAbrhs, string Status, String Remark, bool IsForwarded)
        {
            var UserID = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out UserID);
            var statusList = _dbContext.Proc_BulkActionOnApproveWFH(RequestID, Status, Remark, UserID, IsForwarded).ToList();
            foreach (var item in statusList)
            {
                if (!string.IsNullOrEmpty(item.Msg) && item.Msg.ToString().Equals("SUCCEED"))
                {
                    return "SUCCEED";

                    //if (Status.Equals("PV"))
                    //{
                    //    var d = _dbContext.spGetLeaveInformation(item.ApplicationId, 4).FirstOrDefault();
                    //    var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "Forward Leave" && f.IsActive && !f.IsDeleted);
                    //    if (emailTemplate != null && d != null)
                    //    {
                    //        var body = emailTemplate.Template.Replace("[Name]", d.ApproverName).Replace("[ApplicantName]", d.ApplicantName).Replace("[Type]", "Work From Home");
                    //        Utilities.EmailHelper.SendEmailWithDefaultParameter("Forwarded Work From Home Request", body, true, true, CryptoHelper.Decrypt(d.ApproverEmailId), null, null, null);
                    //    }
                    //}
                }
            }
            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.TakeActionOnWFH, UserID, 0);
            return "SUCCEED";
        }
        public BulkApproveResponseList TakeActionOnOutingBulkApprove(string RequestID, string Userabrhs, string Status, String Remark)
        {
            var UserID = 0;
            Int32.TryParse(CryptoHelper.Decrypt(Userabrhs), out UserID);
            var loginUserData = _dbContext.fnGetHRDetail(UserID).FirstOrDefault();
            var IsHRVerifier = loginUserData.IsHRVerifier.Value;
            var userType = "MGR";
            if (IsHRVerifier == true)
                userType = "HR";
            if (Status.Equals(OutingRequestStatusCode.Approved) && userType.Equals(UserTypeCode.HumanResource))
                Status = OutingRequestStatusCode.Verified;
            else if (Status.Equals(OutingRequestStatusCode.Approved) && userType.Equals(UserTypeCode.Manager))
                Status = OutingRequestStatusCode.Approved;
            var statusList = _dbContext.Proc_BulkActionOnApproveOuting(RequestID, Status, Remark, UserID, userType).ToList();

            var success = statusList.Where(t => t.Msg == 1).Select(m => m.EmployeeName).ToList();
            var actionNotTaken = statusList.Where(t => t.Msg == 2).Select(m => m.EmployeeName).ToList();
            var error = statusList.Where(t => t.Msg == 0 || t.Msg == null).Select(m => m.EmployeeName).ToList();

            var actionNotTakenEmployees = string.Join(",", actionNotTaken);
            var errorEmployees = string.Join(",", error);
            var successEmployees = string.Join(",", success);


            var response = new BulkApproveResponseList
            {
                ActionNotTaken = actionNotTakenEmployees,
                ErrorList = errorEmployees,
                SuccessList = successEmployees
            };

            //foreach (var item in statusList)
            //{
            //    if (!string.IsNullOrEmpty(item.Msg.ToString()))
            //    {
            //        return "SUCCEED";
            //    }
            //}
            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.TakeActionOnOuting, UserID, 0);
            return response;
        }
        public string TakeActionOnLWPChangeBulkApprove(string RequestID, string Userabrhs, string Status, String Remark)
        {
            var UserID = 0;
            Int32.TryParse(CryptoHelper.Decrypt(Userabrhs), out UserID);
            var loginUserData = _dbContext.fnGetHRDetail(UserID).FirstOrDefault();
            var IsHRVerifier = loginUserData.IsHRVerifier.Value;
            var userType = "MGR";
            if (IsHRVerifier == true)
                userType = "HR";
            if (Status.Equals(OutingRequestStatusCode.Approved) && userType.Equals(UserTypeCode.HumanResource))
                Status = OutingRequestStatusCode.Verified;
            else if (Status.Equals(OutingRequestStatusCode.Approved) && userType.Equals(UserTypeCode.Manager))
                Status = OutingRequestStatusCode.Approved;
            var statusList = _dbContext.Proc_BulkActionOnApproveLegitimateRequest(RequestID, Status, Remark, UserID, userType).ToList();
            foreach (var item in statusList)
            {
                if (!string.IsNullOrEmpty(item.Msg.ToString()))
                {
                    return "SUCCEED";

                }
            }
            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.TakeActionOnOuting, UserID, 0);
            return "SUCCEED";
        }
        public string TakeActionOnDataChangeBulkApprove(string RequestID, string userAbrhs, string Status, String Remark)
        {
            var UserID = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out UserID);
            var statusList = _dbContext.Proc_BulkActionOnApproveDataChange(RequestID, Status, Remark, UserID).ToList();
            foreach (var item in statusList)
            {
                if (!string.IsNullOrEmpty(item.Msg) && item.Msg.ToString().Equals("SUCCEED"))
                {
                    return "SUCCEED";

                }
            }
            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.TakeActionOnWFH, UserID, 0);
            return "SUCCEED";
        }
        #endregion

        #region Weekly Roster

        public WeekOffCalenderBO GetCalendarForWeekOff(string userAbrhs, int month, int year, int type = 0)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            if (type == 1)
            {
                var rmDetails = _dbContext.vwAllUsers.FirstOrDefault(x => x.UserId == userId);
                userId = rmDetails != null ? (int)rmDetails.RMId : 0;
            }
            var shiftData = new WeekOffCalenderBO();
            if (userId > 0)
            {
                var reqUrl = HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + "/";
#if !DEBUG
            reqUrl = (new UriBuilder(reqUrl) { Port = -1 }).ToString();
#endif
                var baseImagePath = reqUrl + ConfigurationManager.AppSettings["ImagePath"];
                var profileImagePath = reqUrl + ConfigurationManager.AppSettings["ProfileImageUploadPath"].Replace("\\", "/");
                var maleImagePath = baseImagePath + "male-employee.png";
                var femaleImagePath = baseImagePath + "female-employee.png";
                var buildVersion = GlobalServices.GetBuildVersion();
                var today = DateTime.Today;
                bool IsCalendarToBeDisabled = false;
                IsCalendarToBeDisabled = year >= today.Year && month >= today.Month ? false : true;
                // var name = _dbContext.vwActiveUsers.FirstOrDefault(x => x.UserId == userId).EmployeeName;
                //var today = DateTime.Now;
                //bool IsPreviousMonthDisabled = false;
                //if (month == today.Month && year == today.Year)
                //    IsPreviousMonthDisabled = true;
                var reporteeList = _dbContext.UserDetails.Where(x => x.ReportTo == userId).Select(x => x.UserId).ToList();
                var data = _dbContext.Proc_GetCalendarForWeekOff(userId, month, year).ToList();
                var WeekData = _dbContext.Proc_GetEmployeeWeekData(userId, Convert.ToDateTime(data.FirstOrDefault().StartDate), Convert.ToDateTime(data.FirstOrDefault().EndDate)).ToList();
                var dateIdsList = data.Select(x => x.DateId);

                var lnsaData = data.FirstOrDefault();
                var shiftInfo = new WeekOffCalenderDetailsBO
                {
                    StartDate = data.FirstOrDefault().StartDate,
                    EndDate = data.FirstOrDefault().EndDate,
                    CurrentMonthYear = DateTimeFormatInfo.CurrentInfo.GetMonthName(month) + " " + year,
                    IsMonthDisabled = IsCalendarToBeDisabled,
                    ActiveMonth = month,
                    ActiveYear = year
                    //ReporteesDetail = _dbContext.spGetEmployeesReportingToUser(userId, false, false).ToList().AsEnumerable().Select
                    //    (a => new ReporteesDetails
                    //    {
                    //        UserAbrhs = CryptoHelper.Encrypt(a.EmployeeId.ToString()),
                    //        EmployeeName = _dbContext.vwActiveUsers.FirstOrDefault(x => x.UserId == a.EmployeeId).EmployeeName
                    //    }).ToList(),

                };
                var newWeek = data.GroupBy(t => t.Week).Select(g => g.First()).ToList();
                var weekList = new List<WeekOffDetailsBO>();
                foreach (var i in newWeek)
                {
                    var weekInfo = new WeekOffDetailsBO
                    {
                        WeekNo = i.Week
                    };
                    var weekDetail = (from w in data where w.Week == i.Week select w).ToList();
                    var weeks = weekDetail.Select(m => new WeeksOffBO
                    {
                        MonthDate = m.DateInt,
                        Day = m.Day,
                        Date = m.FullDate,
                        DateId = m.DateId,
                        Month = m.Month.Substring(0, 3),
                        IsCurrentMonth = m.IsCurrentMonthYear,
                        UserWeekOffDetails = WeekData.Where(x => x.DateId == m.DateId).Select
                        (a => new WeekOffUserDetails
                        {
                            UserAbrhs = CryptoHelper.Encrypt(a.UserId.ToString()),
                            EmployeeName = _dbContext.vwActiveUsers.FirstOrDefault(x => x.UserId == a.UserId).EmployeeName,
                            ImageUrl = ((!string.IsNullOrEmpty(_dbContext.vwActiveUsers.FirstOrDefault(x => x.UserId == a.UserId).ImagePath) ? (profileImagePath + _dbContext.vwActiveUsers.FirstOrDefault(x => x.UserId == a.UserId).ImagePath) :
                                           ((!string.IsNullOrEmpty(_dbContext.vwActiveUsers.FirstOrDefault(x => x.UserId == a.UserId).GenderId.ToString()) ? _dbContext.vwActiveUsers.FirstOrDefault(x => x.UserId == a.UserId).GenderId.ToString() : "") == "2" ? femaleImagePath : maleImagePath)) + "?v=" + buildVersion),
                        }).ToList(),
                        Year = m.Year,
                    }).ToList();
                    weekInfo.Weeks = weeks;
                    weekList.Add(weekInfo);
                    shiftInfo.WeekDetails = weekList;
                }

                shiftData.WeekOffDetails = shiftInfo;

            }
            return shiftData ?? new WeekOffCalenderBO();
        }

        public int AddWeekOffForEmployees(string userAbrhs, string dateIds, string loginUserAbrhs, int type = 0)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(loginUserAbrhs), out userId);
            if (type == 1)
            {
                var rmDetails = _dbContext.vwAllUsers.FirstOrDefault(x => x.UserId == userId);
                userId = rmDetails != null ? (int)rmDetails.RMId : 0;
            }
            int status = 0;
            var result = new ObjectParameter("Success", typeof(int));
            var userIdsList = CustomExtensions.SplitUseridsToIntList(userAbrhs);
            string[] dateIdsList = dateIds.Split(',');
            var dateIdsCount = dateIdsList.Length;
            var key = ConfigurationManager.AppSettings["MaxWeekOffDays"];
            if (userId > 0)
            {
                if (dateIdsCount > Convert.ToInt16(key))
                {
                    status = 3;
                }
                else
                {
                    var splittedUserIds = string.Join(",", userIdsList);
                    _dbContext.Proc_AddWeekOffUsers(splittedUserIds, dateIds, userId, result);
                    _dbContext.SaveChanges();
                    Int32.TryParse(result.Value.ToString(), out status);
                }
            }
            return status;
        }

        public List<WeekOffUserDetails> GetWeekOffMarkedEmployeesInfo(string dateIds, string loginUserAbrhs, int type = 0)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(loginUserAbrhs), out userId);
            if (type == 1)
            {
                var rmDetails = _dbContext.vwAllUsers.FirstOrDefault(x => x.UserId == userId);
                userId = rmDetails != null ? (int)rmDetails.RMId : 0;
            }
            List<long> dateIdsList = dateIds.Split(',').Select(long.Parse).ToList();
            var sDate = dateIdsList[0];
            var eDate = dateIdsList[6];
            var startDate = _dbContext.DateMasters.FirstOrDefault(x => x.DateId == sDate).Date;
            var endDate = _dbContext.DateMasters.FirstOrDefault(x => x.DateId == eDate).Date;
            var userDetails = new List<WeekOffUserDetails>();
            if (userId > 0)
            {
                var weekData = _dbContext.Proc_GetEmployeeWeekData(userId, startDate, endDate).ToList();
                var details = weekData.GroupBy(t => t.UserId).Select(g => g.First()).ToList();

                foreach (var i in details)
                {
                    var info = new WeekOffUserDetails
                    {
                        UserAbrhs = CryptoHelper.Encrypt(i.UserId.ToString()),
                        EmployeeName = _dbContext.vwActiveUsers.FirstOrDefault(x => x.UserId == i.UserId).EmployeeName,
                    };
                    var dateDetails = (from w in weekData where w.UserId == i.UserId select w).ToList();
                    var dateInfo = dateDetails.Select(m => new WeekOffDateDetails
                    {
                        DateIds = m.DateId,
                        Date = m.Date.ToString("dd MMM yyyy"),
                        IsMarked = false
                    }).ToList();
                    var WeekDaysList = dateInfo.Select(x => x.DateIds).ToList();
                    for (int k = 0; k < dateIdsList.Count; k++)
                    {
                        if (!WeekDaysList.Contains(dateIdsList[k]))
                        {
                            var remainigDayData = new WeekOffDateDetails();
                            remainigDayData.DateIds = dateIdsList[k];
                            var dateId = dateIdsList[k];
                            remainigDayData.Date = _dbContext.DateMasters.FirstOrDefault(x => x.DateId == dateId).Date.ToString("dd MMM yyyy");
                            remainigDayData.IsMarked = true;
                            dateInfo.Add(remainigDayData);
                        }
                    }
                    info.DateDetails = dateInfo.OrderBy(x => x.DateIds).ToList();
                    userDetails.Add(info);
                }
            }
            return userDetails;
        }

        public List<EmployeeBO> GetEligibleEmployeesReportingToUser(string dateIds, string userAbrhs, int type = 0)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            if (type == 1)
            {
                var rmDetails = _dbContext.vwAllUsers.FirstOrDefault(x => x.UserId == userId);
                userId = rmDetails != null ? (int)rmDetails.RMId : 0;
            }

            var menu = _dbContext.Menus.FirstOrDefault(t => t.MenuName == "Weekly Roster");
            int menuId = 0;

            if (menu != null)
                menuId = menu.MenuId;

            var newUser = _dbContext.MenusUserDelegations.FirstOrDefault(t => t.MenuId == menuId && t.DelegatedToUserId == userId && t.DelegatedFromDate <= DateTime.Now && t.DelegatedTillDate >= DateTime.Now && t.IsActive);
            int delegatedUserId = 0;

            if (newUser != null)
                delegatedUserId = newUser.DelegatedFromUserId;

            List<long> dateIdsList = dateIds.Split(',').Select(long.Parse).ToList();
            var result = new List<EmployeeBO>();
            if (userId > 0)
            {
                var markedWeekOffUsers = _dbContext.EmployeeWiseWeekOffs.Where(x => dateIdsList.Contains(x.WeekOffDateId) && x.IsActive).Select(x => x.UserId).ToList();
                var reportingEmployees = _dbContext.spGetEmployeesReportingToUser(userId, false, false).AsEnumerable().Where(x => !markedWeekOffUsers.Contains(Convert.ToInt32(x.EmployeeId))).ToList();
                var delegatedReportingEmployees = _dbContext.spGetEmployeesReportingToUser(delegatedUserId, false, false).AsEnumerable().Where(x => !markedWeekOffUsers.Contains(Convert.ToInt32(x.EmployeeId))).ToList();

                if (reportingEmployees.Any())
                {
                    foreach (var temp in reportingEmployees)
                    {
                        var user = _dbContext.UserDetails.Where(f => f.UserId == temp.EmployeeId).FirstOrDefault();
                        result.Add(new EmployeeBO
                        {
                            EmployeeAbrhs = CryptoHelper.Encrypt(temp.EmployeeId.ToString()),
                            EmployeeName = user.FirstName + " " + user.LastName,
                            EmployeeCode = user.EmployeeId,
                            EmployeeId = user.UserId
                        });
                    }
                    
                }

                if (delegatedReportingEmployees.Any())
                {
                    foreach (var temp in delegatedReportingEmployees)
                    {
                        var user = _dbContext.UserDetails.Where(f => f.UserId == temp.EmployeeId).FirstOrDefault();
                        result.Add(new EmployeeBO
                        {
                            EmployeeAbrhs = CryptoHelper.Encrypt(temp.EmployeeId.ToString()),
                            EmployeeName = user.FirstName + " " + user.LastName,
                            EmployeeCode = user.EmployeeId,
                            EmployeeId = user.UserId
                        });
                    }
                  
                }

                return result.OrderBy(t => t.EmployeeName).ToList();
            }
            return null;
        }

        public int BulkRemoveMarkedWeekOffUsers(string dateIds, string userAbrhs, string loginAbrhs)
        {
            var userId = 0;
            var result = 0;
            Int32.TryParse(CryptoHelper.Decrypt(loginAbrhs), out userId);
            List<long> dateIdsList = dateIds.Split(',').Select(long.Parse).ToList();
            var userIdsList = CustomExtensions.SplitUseridsToIntList(userAbrhs);
            var data = _dbContext.EmployeeWiseWeekOffs.Where(x => userIdsList.Contains(x.UserId) && dateIdsList.Contains(x.WeekOffDateId) && x.IsActive);
            if (userId > 0)
            {
                foreach (var temp in data)
                {
                    temp.IsActive = false;
                    temp.ModifiedBy = userId;
                    temp.ModifiedDate = DateTime.Now;
                }
                result = 1;
                _dbContext.SaveChanges();
                _userServices.SaveUserLogs(ActivityMessages.BulkRemoveMarkedWeekOffUsers, userId, 0);
            }
            return result;
        }
       
        #endregion

    }
}