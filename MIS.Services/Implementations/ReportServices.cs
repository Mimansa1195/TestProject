using MIS.BO;
using MIS.Model;
using MIS.Services.Contracts;
using MIS.Utilities;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Core.Objects;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Configuration;

namespace MIS.Services.Implementations
{
    public class ReportServices : IReportServices

    {
        #region Private member variables
        private readonly IUserServices _userServices;
        private readonly MISEntities _dbContext = new MISEntities();

        public ReportServices(IUserServices userServices)
        {
            _userServices = userServices;
        }

        #endregion

        #region ClubbedReport

        public List<ClubbedReport> GetClubbedReport(string fromDate, string endDate, string empAbrhs, string reportToAbrhs, string departmentIds, string teamIds, string locationIds, string status)
        {
            if (string.IsNullOrEmpty(fromDate) || string.IsNullOrEmpty(endDate))
                return new List<ClubbedReport>();

            var from = DateTime.ParseExact(fromDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            var till = DateTime.ParseExact(endDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);

            using (var context = new MISEntities())
            {
                var empIds = string.Join(",", MIS.Utilities.CustomExtensions.SplitUseridsToIntList(empAbrhs).ToList());

                var reportToIds = string.Join(",", MIS.Utilities.CustomExtensions.SplitUseridsToIntList(reportToAbrhs).ToList());
                var TeamIds = string.Join(",", MIS.Utilities.CustomExtensions.SplitUseridsToIntList(teamIds).ToList());
                var locIds = string.Join(",", locationIds.ToList());
                var result = context.spGetClubbedReport(from, till, reportToIds, empIds, departmentIds, TeamIds, locIds, status).Select(x => new ClubbedReport
                {
                    EmpAbrhs = CryptoHelper.Encrypt(empIds.ToString()),
                    //UserId = x.UserId,

                    EmployeeName = x.EmployeeName,
                    ManagerName = x.ReportingManager,
                    Department = x.Department,
                    TeamName = x.Team,
                    CL = x.CL,
                    PL = x.PL,
                    WFH = x.WFH,
                    LNSA = x.LNSA,
                    COFF = x.COFF,
                    TotalDaysPresent = x.TotalDaysPresent,
                    TotalLoggedHours = x.TotalLoggedHours,
                    JoiningDate = x.JoiningDate,
                    RelievingDate = x.RelievingDate,
                    Status = x.Status,
                    Location = x.LocationName,
                    EmpCode = x.EmployeeId
                }).ToList();
                return result ?? new List<ClubbedReport>();
            }
        }

        #region CompOff

        public List<CompOffReport> GetCompOffReport(string fromDate, string endDate, string empAbrhs, string reportToAbrhs, string departmentIds, string locationIds)
        {
            if (string.IsNullOrEmpty(fromDate) || string.IsNullOrEmpty(endDate))
                return new List<CompOffReport>();

            var from = DateTime.ParseExact(fromDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            var till = DateTime.ParseExact(endDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            var locIds = "0";
            if (locationIds != "0")
            {
                locIds = string.Join(",", locationIds.ToList());
            }
            using (var context = new MISEntities())
            {
                var empIds = string.Join(",", MIS.Utilities.CustomExtensions.SplitUseridsToIntList(empAbrhs).ToList());
                var reportToIds = string.Join(",", MIS.Utilities.CustomExtensions.SplitUseridsToIntList(reportToAbrhs).ToList());
                var result = context.spGetCompOffReport(departmentIds, reportToIds, empIds, from, till, locIds).Select(x => new CompOffReport
                {
                    EmpAbrhs = CryptoHelper.Encrypt(x.UserId.ToString()),
                    //UserId = x.UserId,
                    EmpCode = x.EmployeeId,
                    EmployeeName = x.EmployeeName,
                    ManagerName = x.ReportingManager,
                    Department = x.DepartmentName,
                    Applied = x.Applied.GetValueOrDefault(),
                    PendingForApproval = x.PendingForApproval,
                    Approved = x.Approved,
                    Availed = x.Availed,
                    Balance = x.Balance,
                    Rejected = x.Rejected,
                    Location = x.LocationName
                }).ToList();
                return result ?? new List<CompOffReport>();
            }
        }

        /// <summary>
        /// Get Comp Off Report Details By User Id
        /// </summary>
        /// <param name="fromDate"></param>
        /// <param name="tillDate"></param>
        /// <param name="userId"></param>
        /// <param name="requestType"></param>
        /// <returns></returns>
        public List<ReportDetail> GetCompOffReportDetailsByUserId(string fromDate, string tillDate, string empAbrhs, int requestType) //requestType - 1:applied, 2:approved, 3:rejected, 4:pending, 5:availed
        {
            if (string.IsNullOrEmpty(fromDate) || string.IsNullOrEmpty(tillDate) || string.IsNullOrEmpty(empAbrhs) || !(requestType > 0))
                return new List<ReportDetail>();

            var from = DateTime.ParseExact(fromDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            var till = DateTime.ParseExact(tillDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);

            using (var context = new MISEntities())
            {
                var empid = 0;
                if (empAbrhs != "0")
                    Int32.TryParse(CryptoHelper.Decrypt(empAbrhs), out empid);
                int? userId = empid;

                var detailList = new List<ReportDetail>();

                switch (requestType)
                {
                    case 1: //applied
                        detailList = context.spGetAppliedCompOffDetailByUserId(from, till, userId).Select(x => new ReportDetail
                        {
                            Period = x.Date.ToString("dd-MMM-yyyy"),
                            Count = x.NoOfDays,
                            ReasonOfApplication = x.Reason,
                            Status = x.Status
                        }).ToList();
                        break;
                    case 2: //approved
                        detailList = context.spGetApprovedCompOffDetailByUserId(from, till, userId).Select(x => new ReportDetail
                        {
                            Period = x.Date.ToString("dd-MMM-yyyy"),
                            Count = x.NoOfDays,
                            ReasonOfApplication = x.Reason
                        }).ToList();
                        break;
                    case 3: //rejected
                        detailList = context.spGetRejectedCompOffDetailByUserId(from, till, userId).Select(x => new ReportDetail
                        {
                            Period = x.Date.ToString("dd-MMM-yyyy"),
                            Count = x.NoOfDays,
                            ReasonOfApplication = x.ReasonOfApplication,
                            RejectedBy = x.RejectedBy,
                            ReasonOfRejection = x.ReasonOfRejection
                        }).ToList();
                        break;
                    case 4: //pending
                        detailList = context.spGetPendingCompOffDetailByUserId(from, till, userId).Select(x => new ReportDetail
                        {
                            Period = x.Date.ToString("dd-MMM-yyyy"),
                            Count = x.NoOfDays,
                            ReasonOfApplication = x.Reason,
                            PendingWith = x.PendingWith
                        }).ToList();
                        break;
                    case 5: //availed
                        detailList = context.spGetAvailedCompOffDetailByUserId(from, till, userId).Select(x => new ReportDetail
                        {
                            Period = x.Date.ToString("dd-MMM-yyyy"),
                            Count = x.NoOfDays,
                            ReasonOfApplication = x.Reason,
                        }).ToList();
                        break;
                }
                return detailList;
            }
        }

        #endregion

        #region LNSA

        public List<LnsaReport> GetLnsaReport(string fromDate, string endDate, string empAbrhs, string reportToAbrhs, string departmentIds, string locationIds)
        {
            if (string.IsNullOrEmpty(fromDate) || string.IsNullOrEmpty(endDate))
                return new List<LnsaReport>();

            var from = DateTime.ParseExact(fromDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            var till = DateTime.ParseExact(endDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            var locIds = "0";
            if (locationIds != "0")
            {
                locIds = string.Join(",", locationIds.ToList());
            }
            using (var context = new MISEntities())
            {
                var empIds = string.Join(",", MIS.Utilities.CustomExtensions.SplitUseridsToIntList(empAbrhs).ToList());
                var reportToIds = string.Join(",", MIS.Utilities.CustomExtensions.SplitUseridsToIntList(reportToAbrhs).ToList());
                var result = context.spGetLnsaReport(departmentIds, reportToIds, empIds, from, till, locIds).Select(x => new LnsaReport
                {
                    EmpAbrhs = CryptoHelper.Encrypt(x.UserId.ToString()),
                    //UserId = x.UserId,
                    EmpCode = x.EmployeeId,
                    EmployeeName = x.EmployeeName,
                    ManagerName = x.Reporting_Manager,
                    Department = x.DepartmentName,
                    Approved = x.Approved,
                    Applied = x.Applied.GetValueOrDefault(),
                    PendingForApproval = x.Pending_For_Approval,
                    Rejected = x.Rejected,
                    Location = x.LocationName
                }).ToList();
                return result ?? new List<LnsaReport>();
            }
        }

        /// <summary>
        /// Get Lnsa Report Details By UserId
        /// </summary>
        /// <param name="fromDate"></param>
        /// <param name="tillDate"></param>
        /// <param name="userId"></param>
        /// <param name="requestType"></param>
        /// <returns></returns>
        public List<ReportDetail> GetLnsaReportDetailsByUserId(string fromDate, string tillDate, string empAbrhs, int requestType)
        {
            if (string.IsNullOrEmpty(fromDate) || string.IsNullOrEmpty(tillDate) || string.IsNullOrEmpty(empAbrhs) || !(requestType > 0))
                return new List<ReportDetail>();

            var from = DateTime.ParseExact(fromDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            var till = DateTime.ParseExact(tillDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);

            using (var context = new MISEntities())
            {
                var empid = 0;
                if (empAbrhs != "0")
                    Int32.TryParse(CryptoHelper.Decrypt(empAbrhs), out empid);

                int? userId = empid;

                var detailList = new List<ReportDetail>();

                switch (requestType)
                {
                    case 1: //applied
                        detailList = context.spGetAppliedLnsaDetailByUserId(from, till, userId).Select(x => new ReportDetail
                        {
                            Period = x.Period,
                            Count = x.NoOfDays,
                            ReasonOfApplication = x.Reason,
                            Status = x.Status,
                            CreatedDate = x.CreatedDate.ToString("dd-MMM-yyyy")
                        }).ToList();
                        break;
                    case 2: //approved
                        detailList = context.spGetApprovedLnsaDetailByUserId(from, till, userId).Select(x => new ReportDetail
                        {
                            Period = x.Period,
                            Count = x.NoOfDays,
                            ReasonOfApplication = x.Reason,
                            CreatedDate = x.CreatedDate.ToString("dd-MMM-yyyy"),
                            ModifiedDate = x.ApprovedDate.Value.ToString("dd-MMM-yyyy")
                        }).ToList();
                        break;
                    case 3: //rejected
                        detailList = context.spGetRejectedLnsaDetailByUserId(from, till, userId).Select(x => new ReportDetail
                        {
                            Period = x.Period,
                            Count = x.NoOfDays,
                            ReasonOfApplication = x.Reason,
                            RejectedBy = x.RejectedBy,
                            ReasonOfRejection = x.ReasonOfRejection,
                            CreatedDate = x.CreatedDate.ToString("dd-MMM-yyyy"),
                            ModifiedDate = x.RejectedOn.Value.ToString("dd-MMM-yyyy")
                        }).ToList();
                        break;
                    case 4: //pending
                        detailList = context.spGetPendingLnsaDetailByUserId(from, till, userId).Select(x => new ReportDetail
                        {
                            Period = x.Period,
                            Count = x.NoOfDays,
                            ReasonOfApplication = x.Reason,
                            PendingWith = x.PendingWith,
                            CreatedDate = x.CreatedDate.ToString("dd-MMM-yyyy")
                        }).ToList();
                        break;
                }
                return detailList;
            }
        }

        #endregion

        #region LWP

        public List<LwpReport> GetLwpReport(string fromDate, string endDate, string empAbrhs, string reportToAbrhs, string departmentIds, string locationIds)
        {
            if (string.IsNullOrEmpty(fromDate) || string.IsNullOrEmpty(endDate))
                return new List<LwpReport>();

            var from = DateTime.ParseExact(fromDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            var till = DateTime.ParseExact(endDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            var locIds = "0";
            if (locationIds != "0")
            {
                locIds = string.Join(",", locationIds.ToList());
            }
            using (var context = new MISEntities())
            {
                var empIds = string.Join(",", MIS.Utilities.CustomExtensions.SplitUseridsToIntList(empAbrhs).ToList());
                var reportToIds = string.Join(",", MIS.Utilities.CustomExtensions.SplitUseridsToIntList(reportToAbrhs).ToList());
                var result = context.spGetLwpReport(departmentIds, reportToIds, empIds, from, till, locIds).Select(x => new LwpReport
                {
                    EmpAbrhs = CryptoHelper.Encrypt(x.UserId.ToString()),
                    //UserId = x.UserId,
                    EmpCode = x.EmployeeId,
                    EmployeeName = x.EmployeeName,
                    ManagerName = x.ReportingManager,
                    Department = x.DepartmentName,
                    Applied = x.Applied.GetValueOrDefault(),
                    PendingForApproval = Convert.ToDouble(x.PendingForApproval),
                    Cancelled = Convert.ToDouble(x.Cancelled),
                    Availed = Convert.ToDouble(x.Availed),
                    Location = x.LocationName
                }).ToList();
                return result ?? new List<LwpReport>();
            }
        }

        /// <summary>
        /// Get Lwp Report Details By UserId
        /// </summary>
        /// <param name="fromDate"></param>
        /// <param name="tillDate"></param>
        /// <param name="userId"></param>
        /// <param name="requestType"></param>
        /// <returns></returns>
        public List<ReportDetail> GetLwpReportDetailsByUserId(string fromDate, string tillDate, string empAbrhs, int requestType)
        {
            if (string.IsNullOrEmpty(fromDate) || string.IsNullOrEmpty(tillDate) || string.IsNullOrEmpty(empAbrhs) || !(requestType > 0))
                return new List<ReportDetail>();

            var from = DateTime.ParseExact(fromDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            var till = DateTime.ParseExact(tillDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);

            using (var context = new MISEntities())
            {
                var empid = 0;
                if (empAbrhs != "0")
                    Int32.TryParse(CryptoHelper.Decrypt(empAbrhs), out empid);
                int? userId = empid;

                var detailList = new List<ReportDetail>();

                switch (requestType)
                {
                    case 1: //applied
                        detailList = context.spGetAppliedLwpDetailByUserId(from, till, userId).Select(x => new ReportDetail
                        {
                            Period = x.Period,
                            Count = x.NoOfDays,
                            ReasonOfApplication = x.Reason,
                            Status = x.Status,
                            CreatedDate = x.CreatedDate.ToString("dd-MMM-yyyy")
                        }).ToList();
                        break;
                    case 2: //cancelled
                        detailList = context.spGetCancelledLwpDetailByUserId(from, till, userId).Select(x => new ReportDetail
                        {
                            Period = x.Period,
                            Count = x.NoOfDays,
                            ReasonOfApplication = x.Reason,
                            CreatedDate = x.CreatedDate.ToString("dd-MMM-yyyy"),
                            ModifiedDate = x.CancelledOn.Value.ToString("dd-MMM-yyyy")
                        }).ToList();
                        break;
                    case 3: //availed
                        detailList = context.spGetAvailedLwpDetailByUserId(from, till, userId).Select(x => new ReportDetail
                        {
                            Period = x.Period,
                            Count = x.NoOfDays,
                            ReasonOfApplication = x.Reason,
                            CreatedDate = x.CreatedDate.ToString("dd-MMM-yyyy")
                        }).ToList();
                        break;
                }
                return detailList;
            }
        }

        #endregion

        #region VMS
        /// <summary>
        /// Get Visitor Details
        /// </summary>
        /// <param name="fromDate"></param>
        /// <param name="endDate"></param>
        /// <param name="empAbrhs"></param>
        /// <returns></returns>
        public List<VisitorReportDetail> GetVisitorDetails(string fromDate, string endDate, string userAbrhs)
        {
            if (string.IsNullOrEmpty(fromDate) || string.IsNullOrEmpty(endDate))
                return new List<VisitorReportDetail>();
            var from = DateTime.ParseExact(fromDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            var till = DateTime.ParseExact(endDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);

            using (var context = new MISEntities())
            {
                var empid = 0;
                if (userAbrhs != "0")
                {
                    Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out empid);
                }
                int? userId = empid;

                var VisitorReportDetail = new List<VisitorReportDetail>();
                if (empid > 0)
                {
                    var VisitorDetail = context.Proc_SelectVisitorDetailsForMIS(from, till).ToList();
                    if (VisitorDetail.Any())
                    {
                        foreach (var r in VisitorDetail)
                        {
                            VisitorReportDetail.Add(new VisitorReportDetail
                            {
                                VisitorId = r.VisitorId,
                                Visitor_FName = r.Visitor_FName,
                                Visitor_LName = r.Visitor_LName,
                                Visitor_Address = r.Visitor_Address,
                                Visitor_ContactNo = r.Visitor_ContactNo,
                                Visitor_Email = r.Visitor_Email,
                                EmployeeName = r.EmployeeName,
                                Visitor_Purpose = r.Visitor_Purpose,
                                Visitor_IdentityProof = r.Visitor_IdentityProof,
                                Visitor_TimeIn = r.Visitor_TimeIn,
                                Visitor_TimeOut = r.Visitor_TimeOut
                            });
                        }
                    }
                }
                return VisitorReportDetail;
            }
        }

        /// <summary>
        /// GetGetTempCardDetails
        /// </summary>
        /// <param name="fromDate"></param>
        /// <param name="tillDate"></param>
        /// <param name="empAbrhs"></param>
        /// <returns></returns>
        public List<TempCardReport> GetTempCardDetails(string fromDate, string tillDate, string userAbrhs)
        {
            if (string.IsNullOrEmpty(fromDate) || string.IsNullOrEmpty(tillDate))
                return new List<TempCardReport>();

            var from = DateTime.ParseExact(fromDate, "dd/MM/yyyy", CultureInfo.InvariantCulture);
            var till = DateTime.ParseExact(tillDate, "dd/MM/yyyy", CultureInfo.InvariantCulture);

            using (var context = new MISEntities())
            {
                var empid = 0;
                if (userAbrhs != "0")
                {
                    Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out empid);
                }
                int? userId = empid;

                var TempCardDetail = new List<TempCardReport>();
                if (empid > 0)
                {
                    var TempCardList = context.Proc_SelectTempCardDetailsForMIS(from, till).ToList();
                    if (TempCardList.Any())
                    {
                        foreach (var r in TempCardList)
                        {
                            TempCardDetail.Add(new TempCardReport
                            {
                                IssueId = r.IssueId,
                                EmployeeName = r.EmployeeName,
                                EmployeeAbrhs = CryptoHelper.Encrypt(r.UserId.ToString()),
                                AccessCardNo = r.AccessCardNo.ToString(),
                                IssueDate = r.IssueDate.HasValue ? r.IssueDate.Value.ToString("dd-MMM-yyyy hh:mm tt") : "NO",
                                ReturnDate = r.ReturnDate.HasValue ? r.ReturnDate.Value.ToString("dd-MMM-yyyy hh:mm tt") : "NO",
                                Reason = r.Reason,
                                IsReturn = r.IsReturn == true ? "YES" : "NO",
                            });
                        }
                    }
                }
                return TempCardDetail;
            }
        }
        //public int CheckIfUserEligibleToAddCards(int loginUserId)
        //{
        //    var userInfo = _dbContext.Users.FirstOrDefault(x => x.UserId == loginUserId);
        //    var roleId = 0;
        //    var status = 0;
        //    if (userInfo != null)
        //        roleId = userInfo.RoleId;
        //    if (roleId == 1 || roleId == 2) // for web admin and MIS admin
        //        status = 1;
        //    else if (roleId > 2)
        //    {
        //        var designationGroupInfo = _dbContext.vwActiveUsers.FirstOrDefault(x => x.UserId == loginUserId);
        //        if (designationGroupInfo != null)
        //        {
        //            if (designationGroupInfo.DesignationGroupId == 5 && designationGroupInfo.IsIntern == false)//for HR
        //                status = 1;
        //        }
        //    }
        //    else
        //        status = 2;
        //    return status;
        //}
        public TempCardReport GetTempCardDetailsForEdit(int issueId)
        {
            var cardDetails = new TempCardReport();
            var data = _dbContext.TempCardIssueDetails.FirstOrDefault(x => x.IssueId == issueId);
            if (data != null)
            {
                cardDetails.EmployeeId = CryptoHelper.Encrypt(data.EmployeeId.ToString());
                cardDetails.AccessCardId = data.AccessCardId.ToString();
                cardDetails.IssueDate = data.IssueDate.HasValue ? data.IssueDate.Value.ToString("dd/MM/yyyy HH:mm", CultureInfo.InvariantCulture) : "NA";
                cardDetails.ReturnDate = data.ReturnDate.HasValue ? data.ReturnDate.Value.ToString("dd/MM/yyyy HH:mm", CultureInfo.InvariantCulture) : "NA";
                cardDetails.Reason = data.Reason;
                cardDetails.IsReturn = data.IsReturn.ToString();
            }
            return cardDetails;
        }
        public int EditAccessCardDetails(TempCardReport input, string userAbrhs)
        {
            var status = 0;
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            var data = _dbContext.TempCardIssueDetails.FirstOrDefault(x => x.IssueId == input.IssueId);
            if (data == null)
            {
                status = 2;
            }
            if (data != null)
            {
                var issueDate = DateTime.ParseExact(input.IssueDate, "dd/MM/yyyy HH:mm", CultureInfo.InvariantCulture);
                if (input.ReturnDate != "")
                {
                    var returnDate = DateTime.ParseExact(input.ReturnDate, "dd/MM/yyyy HH:mm", CultureInfo.InvariantCulture);
                    data.ReturnDate = returnDate;
                }
                data.EmployeeId = Convert.ToInt32(CryptoHelper.Decrypt(input.EmployeeId));
                data.AccessCardId = Convert.ToInt32(input.AccessCardId);
                data.Reason = input.Reason;
                data.IssueDate = issueDate;
                data.IsReturn = input.IsReturn == "False" ? false : true;
                _dbContext.SaveChanges();
                _userServices.SaveUserLogs(ActivityMessages.EditAccessCardDetails, userId, 0);
                status = 1;
            }
            return status;
        }
        public int AddCardIssueDetail(TempCardReport input, string userAbrhs)
        {
            int status = 0;
            var UserId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out UserId);
            var empId = CryptoHelper.Decrypt(input.EmployeeId);
            var isReturn = false;
            if (input.IsReturn == "true")
                isReturn = true;
            var issueDate = DateTime.ParseExact(input.IssueDate, "dd/MM/yyyy HH:mm", CultureInfo.InvariantCulture);
            var returnDate = DateTime.ParseExact(input.ReturnDate, "dd/MM/yyyy HH:mm", CultureInfo.InvariantCulture);
            using (var _dbContext = new MISEntities())
            {
                var result = new ObjectParameter("Success", typeof(int));
                _dbContext.Proc_AddIssueCardDetails(Convert.ToInt32(empId), Convert.ToInt32(input.AccessCardId), issueDate, returnDate, //Convert.ToDateTime(input.IssueDate), Convert.ToDateTime(input.ReturnDate)
                     input.Reason, isReturn, UserId, result);
                Int32.TryParse(result.Value.ToString(), out status);
                _userServices.SaveUserLogs(ActivityMessages.AddIssueCradDetails, UserId, 0);
                return status;
            }
        }
        public int ChangeStatusOfIssuedCard(int issueId, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var data = _dbContext.TempCardIssueDetails.FirstOrDefault(x => x.IssueId == issueId);
            var status = 0;
            if (data != null)
            {
                data.IsActive = false;
                data.ModifiedDate = DateTime.Now;
                data.ModifiedBy = userId;
                _dbContext.SaveChanges();
                _userServices.SaveUserLogs(ActivityMessages.ChangeStatusOfIssuedCard, userId, 0);
                status = 1;
            }
            else
                status = 0;
            return status;
        }
        #endregion

        #region Skills

        /// <summary>
        /// Get Report Employee Skills
        /// </summary>
        /// <param name="skillsDetailBO"></param>
        /// <returns></returns>
        public List<SkillsDetailBO> GetReportEmployeeSkills(SkillsDetailBO skillsDetailBO)
        {
            using (var context = new MISEntities())
            {
                var SkillIdList = MIS.Utilities.CustomExtensions.SplitToIntList(skillsDetailBO.SkillIds);
                var SkillLevelIdList = MIS.Utilities.CustomExtensions.SplitToIntList(skillsDetailBO.SkillLevelIds);
                var SkillTypeIdList = MIS.Utilities.CustomExtensions.SplitToIntList(skillsDetailBO.SkillTypeIds);

                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(skillsDetailBO.UserAbrhs), out userId);
                if (userId > 0)
                {
                    //if (SkillTypeIdList.Count == 2)
                    //{
                    //    var skillsDetail1 = (from u in context.UserSkills.Where(x => SkillIdList.Contains(x.SkillId) && x.IsActive && (SkillLevelIdList.Contains(x.SkillLevelId)) && x.MonthsOfExperience > skillsDetailBO.ExperienceMonths && x.User.IsActive)
                    //                         join s in context.UserDetails on u.UserId equals s.UserId into list1
                    //                         from l1 in list1.DefaultIfEmpty()
                    //                         select new SkillsDetailBO
                    //                         {
                    //                             UserSkillId = u.UserSkillId,
                    //                             EmployeeName = l1.FirstName + " " + l1.LastName,
                    //                             SkillName = u.Skill.SkillName,
                    //                             SkillLevelName = u.SkillLevel.SkillLevelName,
                    //                             ExperienceMonths = u.MonthsOfExperience,
                    //                             SkillTypeId = u.SkillTypeId,
                    //                             SkillTypeName=u.SkillType.SkillTypeName,
                    //                             CreatedDate = u.ModifiedDate.HasValue ? u.ModifiedDate.Value : u.CreatedDate //.ToString("dd-MMM-yyyy")
                    //                         }).ToList();
                    //    return skillsDetail1;
                    //}
                    //else
                    //{
                    var SkillTypeId = SkillTypeIdList.FirstOrDefault();
                    var skillsDetail2 = (from u in context.UserSkills.Where(x => SkillIdList.Contains(x.SkillId) && x.IsActive && (SkillLevelIdList.Contains(x.SkillLevelId)) && x.MonthsOfExperience > skillsDetailBO.ExperienceMonths && x.User.IsActive && (SkillTypeIdList.Contains(x.SkillTypeId)))
                                         join s in context.UserDetails on u.UserId equals s.UserId into list1
                                         from l1 in list1.DefaultIfEmpty()
                                         select new SkillsDetailBO
                                         {
                                             UserSkillId = u.UserSkillId,
                                             EmployeeName = l1.FirstName + " " + l1.LastName,
                                             SkillName = u.Skill.SkillName,
                                             SkillLevelName = u.SkillLevel.SkillLevelName,
                                             ExperienceMonths = u.MonthsOfExperience,
                                             SkillTypeId = u.SkillTypeId,
                                             SkillTypeName = u.SkillType.SkillTypeName,
                                             CreatedDate = u.ModifiedDate.HasValue ? u.ModifiedDate.Value : u.CreatedDate //.ToString("dd-MMM-yyyy")
                                         }).ToList();
                    return skillsDetail2;
                    //}
                }
                return new List<SkillsDetailBO>();
            }
        }

        #endregion

        #region UserActivity

        public List<UserActivityLogging> GetUserActivity(DateTime fromDate, DateTime endDate, string empAbrhs, string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

                var empId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(empAbrhs), out empId);

                if (userId > 0)
                {
                    var datefull = endDate.Date.AddHours(23).AddMinutes(59).AddSeconds(59);
                    var UserActivityList = (from u in context.UserActivities.Where(x => x.ActivityDate >= fromDate && x.ActivityDate <= datefull && (x.VisitedByUserId == empId || empId == 0))
                                            join s in context.UserDetails on u.VisitedForUserId equals s.UserId into list1
                                            from l1 in list1.DefaultIfEmpty()
                                            join ud in context.UserDetails on u.VisitedByUserId equals ud.UserId into list2
                                            from l2 in list2.DefaultIfEmpty()
                                            select new UserActivityLogging
                                            {
                                                Activity = u.Activity,
                                                ActivityDate = u.ActivityDate,
                                                ForUser = l1.FirstName + " " + l1.LastName,
                                                ByUser = l2.FirstName + " " + l2.LastName,
                                            }).OrderByDescending(x => x.ActivityDate).ToList();
                    return UserActivityList;
                }
                return new List<UserActivityLogging>();
            }
        }

        #endregion

        #region Menu

        public List<MealOfTheDayBO> GetMealMenusData(string fromDate, string endDate, string userAbrhs)
        {
            if (string.IsNullOrEmpty(fromDate) || string.IsNullOrEmpty(endDate) || string.IsNullOrEmpty(userAbrhs))
                return new List<MealOfTheDayBO>();

            var from = DateTime.ParseExact(fromDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            var till = DateTime.ParseExact(endDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);

            List<MealOfTheDayBO> mealOfTheDayList = new List<MealOfTheDayBO>();
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

                if (userId > 0)
                {
                    var mealsdata = context.Proc_GetMealDishes(from, till).ToList();
                    if (mealsdata.Any())
                    {
                        foreach (var item in mealsdata)
                        {
                            MealOfTheDayBO mealOfTheDay = new MealOfTheDayBO();
                            mealOfTheDay.MealDate = item.MealDate.ToString("dd-MMM-yyyy");
                            mealOfTheDay.MealPackagesId = item.MealPackageId;
                            mealOfTheDay.Meal = item.MealDishes;
                            mealOfTheDay.MealPackage = item.MealPackageName;
                            mealOfTheDay.Date = item.MealDate;
                            mealOfTheDayList.Add(mealOfTheDay);
                        }
                    }
                }
            }
            return mealOfTheDayList;
        }

        public List<MealFeedbackReportBO> GetMealFeedbackData(string fromDate, string endDate, string userAbrhs)
        {
            if (string.IsNullOrEmpty(fromDate) || string.IsNullOrEmpty(endDate) || string.IsNullOrEmpty(userAbrhs))
                return new List<MealFeedbackReportBO>();

            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                var FromDate = DateTime.ParseExact(fromDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
                var TillDate = DateTime.ParseExact(endDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);

                if (userId > 0)
                {
                    var feedbackdata = context.Proc_GetMealFeedback(TillDate, FromDate).Select(x => new MealFeedbackReportBO
                    {
                        MealPackages = x.MealPackageName,
                        IsLike = x.Liked,
                        Comment = x.Comment,
                        FeedbackBy = x.EmployeeName,
                        FeedbackDate = x.FeedbackDate,
                    }).ToList();

                    return feedbackdata;
                }
            }
            return new List<MealFeedbackReportBO>();
        }

        #endregion

        #region Leave

        public List<AttendanceSummary> GetLeaveReport(string fromDate, string endDate, string empAbrhs, string reportToAbrhs, string departmentIds, string locationIds)
        {
            if (string.IsNullOrEmpty(fromDate) || string.IsNullOrEmpty(endDate))
                return new List<AttendanceSummary>();

            var from = DateTime.ParseExact(fromDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            var till = DateTime.ParseExact(endDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            var locIds = "0";
            if (locationIds != "0")
                locIds = string.Join(",", locationIds.ToList());
            using (var context = new MISEntities())
            {
                var empIds = string.Join(",", MIS.Utilities.CustomExtensions.SplitUseridsToIntList(empAbrhs).ToList());
                var reportToIds = string.Join(",", MIS.Utilities.CustomExtensions.SplitUseridsToIntList(reportToAbrhs).ToList());

                var lList = new List<AttendanceSummary>();
                var result = context.spGetEmployeeAttendanceSummary(departmentIds, reportToIds, empIds, from, till, locIds).ToList();
                if (result.Any())
                {
                    foreach (var r in result)
                    {
                        lList.Add(new AttendanceSummary
                        {
                            EmpCode = r.EmployeeId,
                            EmployeeName = r.EmployeeName,
                            ManagerName = r.ReportingManager,
                            Department = r.DepartmentName,
                            PresentDays = r.PresentDays,
                            WFH = r.WFH,
                            CL = r.CL,
                            PL = r.PL,
                            LWP = r.LWP,
                            COFF = r.COFF,
                            Location = r.LocationName
                        });
                    }
                    return lList;
                }
                return new List<AttendanceSummary>();
            }
        }

        #endregion

        #region Goal

        public List<UserManagementDetailBO> GetGoalsForReports(int goalCycleId, int statusId)
        {
            var List = new List<UserManagementDetailBO>();
            var result = _dbContext.Proc_GetGoalReport(goalCycleId, statusId).ToList();
            if (result.Any())
            {
                foreach (var r in result)
                {
                    List.Add(new UserManagementDetailBO
                    {
                        Name = r.EmployeeName,
                        Manager = r.ReportingManagerName,
                        Division = r.Division,
                        Department = r.Department,
                        Designation = r.Designation,
                        Team = r.Team
                    });
                }

            }
            return List;

        }

        public List<EmployeeReport> GetLnsaCompOffReport(string fromDate, string endDate, string reportType)
        {
            var employeeReports = new List<EmployeeReport>();
            if (string.IsNullOrEmpty(fromDate) || string.IsNullOrEmpty(endDate))
            {
                return employeeReports;
            }

            var from = DateTime.ParseExact(fromDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            var till = DateTime.ParseExact(endDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            using (var context = new MISEntities())
            {
                if(reportType =="LNSA")
                {
                    employeeReports.AddRange(context.Proc_GetLNSADataDateWise(from, till).Select(x => new LnsaReport
                    {
                        // EmpAbrhs = CryptoHelper.Encrypt(x.UserId.ToString()),
                        //UserId = x.UserId,
                        EmpCode = x.Emp_Code,
                        EmployeeName = x.Employee_Name,
                        Team = x.Team,
                        ManagerName = x.Reporting_Manager,
                        Department = x.Department,
                        Approved = x.Approved_LNSA,
                        Applied = x.Applied_LNSA,
                        PendingForApproval = x.Pending_For_Approval,
                        Rejected = x.Rejected_LNSA,
                        Cancelled = x.Cancelled_LNSA
                    }));
                }
                else
                {
                    employeeReports.AddRange(context.Proc_GetCOMPOffDataDateWise(from, till, null).Select(x => new CompOffReport
                    {
                        // EmpAbrhs = CryptoHelper.Encrypt(x.UserId.ToString()),
                        //UserId = x.UserId,
                        EmpCode = x.Emp_Code,
                        EmployeeName = x.Employee_Name,
                        Team = x.Team,
                        ManagerName = x.Reporting_Manager,
                        Department = x.Department,
                        Approved = x.Approved_COff,
                        Applied = x.Applied_COff,
                        PendingForApproval = x.PendingForApproval,
                        Rejected = x.Rejected_COff,
                        Lapsed =x.Lapsed_COff
                    }));
                }    
            }

            return employeeReports;
        }
        #endregion
    }
}
#endregion