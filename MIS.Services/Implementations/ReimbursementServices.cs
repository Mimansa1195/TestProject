using MIS.BO;
using MIS.Model;
using MIS.Services.Contracts;
using MIS.Utilities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.Entity.Core.Objects;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Xml.Linq;

namespace MIS.Services.Implementations
{
    public class ReimbursementServices : IReimbursementServices
    {
        private readonly IUserServices _userServices;

        public ReimbursementServices(IUserServices userServices)
        {
            _userServices = userServices;
        }

        private readonly MISEntities _dbContext = new MISEntities();

        public List<ReimbursementTypeBO> GetReimbursementType()
        {
            var result = _dbContext.ReimbursementTypes.Where(x => x.IsActive == true).ToList();
            var list = result.Select(s => new ReimbursementTypeBO
            {
                TypeId = s.ReimbursementTypeId,
                TypeName = s.ReimbursementTypeName
            }).ToList();
            return list ?? new List<ReimbursementTypeBO>();
        }

        public List<ReimbursementTypeBO> GetReimbursementCategory(int typeId)
        {
            var result = _dbContext.ReimbursementCategories.Where(x => x.ReimbursementTypeId == typeId && x.IsActive == true).ToList();
            var list = result.Select(s => new ReimbursementTypeBO
            {
                TypeId = s.ReimbursementCategoryId,
                TypeName = s.ReimbursementName
            }).ToList();
            return list ?? new List<ReimbursementTypeBO>();
        }

        public ReimbusrementResponse DraftReimbursementDetails(AddReimbursementBO obj, string userAbrhs)
        {
            var userId = 0;
            var msgId = 0;
            var requestId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var newFileName = "";
            var mY = _dbContext.Fun_GetReimbursementMonthYear(obj.TypeId).FirstOrDefault(x => x.MonthYear == obj.MonthYear);
            var month = (mY.MonthNumber < 10 ? "0" : "") + mY.MonthNumber;
            var m = Convert.ToInt32(month);
            var year = mY.Year;
            var typeName = _dbContext.ReimbursementTypes.FirstOrDefault(x => x.ReimbursementTypeId == obj.TypeId).ReimbursementTypeName;
            var reimbursementRequestId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(obj.ReimbursementRequestAbrhs), out reimbursementRequestId);
            foreach (var i in obj.DocumentList)
            {
                if (typeName == "Monthly")
                    typeName = "MO_";
                else
                    typeName = "OT_";
                var imageName = typeName + year + "" + month + "_" + Guid.NewGuid();
                var imageExtn = i.UploadedImageName.Split('.')[1];
                newFileName = imageName.ToString() + "." + imageExtn;
                i.ImageName = newFileName;
            }
            var xmlString = new XElement("Root",
            from i in obj.DocumentList
            select new XElement("Row",
                         new XAttribute("ReimbursementDetailId", i.ReimbursementDetailId),
                         new XAttribute("ImageName", i.UploadedImageName),
                         new XAttribute("ImagePath", i.ImageName),
                         new XAttribute("CategoryId", i.CategoryId),
                         new XAttribute("Date", i.Date),
                         new XAttribute("BillNo", i.BillNo),
                         new XAttribute("Amount", i.Amount)
                         ));
            var requestIdResponse = new ObjectParameter("NewReimbursementRequestId", typeof(int));
            var resultResponse = new ObjectParameter("Success", typeof(int));
            _dbContext.Proc_AddUpdateReimbursementRequest(userId, reimbursementRequestId, obj.TypeId, Convert.ToDecimal(obj.RequestedAmount), xmlString.ToString(), m, year, "Drafted", requestIdResponse, resultResponse);
            Int32.TryParse(requestIdResponse.Value.ToString(), out requestId);
            Int32.TryParse(resultResponse.Value.ToString(), out msgId);
            if (msgId == 1)
            {
                foreach (var i in obj.DocumentList)
                {
                    if (i.ReimbursementDetailId == 0)
                    {
                        var folder = "USR_" + userId;
                        var docBasePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["ReimbursementDocPath"] + folder + "\\";
                        if (!Directory.Exists(docBasePath))
                        {
                            Directory.CreateDirectory(docBasePath);
                        }
                        var filePath = docBasePath + i.ImageName;
                        byte[] decodedByteArray = Convert.FromBase64String(i.Base64ImageData.Split(',')[1]);
                        File.WriteAllBytes(filePath, decodedByteArray);
                    }
                }
            }
            _userServices.SaveUserLogs(ActivityMessages.DraftReimbursement, userId, 0);
            ReimbusrementResponse response = new ReimbusrementResponse
            {
                ReimbursementRequestAbrhs = CryptoHelper.Encrypt(requestId.ToString()),
                Result = msgId,
                ReimbursementRequestId = requestId
            };
            return response;
        }

        public ReimbusrementResponse SubmitReimbursementForm(AddReimbursementBO obj, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var reimbursementTypeData = _dbContext.ReimbursementTypes.FirstOrDefault(x => x.ReimbursementTypeId == obj.TypeId);
            var result = DraftReimbursementDetails(obj, userAbrhs);
            ReimbusrementResponse response = new ReimbusrementResponse();
            var msgId = 0;
            var nextApproverId = 0;
            if (result.Result == 1 && reimbursementTypeData != null)
            {
                var message = new ObjectParameter("Success", typeof(int));
                var approverId = new ObjectParameter("NextApproverId", typeof(int));
                _dbContext.Proc_SubmitReimbursementRequest(userId, result.ReimbursementRequestId, reimbursementTypeData.ReimbursementTypeName, approverId, message);
                Int32.TryParse(approverId.Value.ToString(), out nextApproverId);
                Int32.TryParse(message.Value.ToString(), out msgId);
                _userServices.SaveUserLogs(ActivityMessages.SubmitReimbursement, userId, 0);
                response = new ReimbusrementResponse
                {
                    ReimbursementRequestAbrhs = CryptoHelper.Encrypt(result.ReimbursementRequestId.ToString()),
                    Result = msgId,
                    ReimbursementRequestId = result.ReimbursementRequestId
                };
                var data = _dbContext.vwActiveUsers.FirstOrDefault(s => s.UserId == nextApproverId);
                if (data != null && reimbursementTypeData.ReimbursementTypeName == ReimbursementTypeName.Others)
                {
                    var rcvEmailId = data.EmailId;
                    var firstName = data.EmployeeFirstName;
                    var lastName = data.EmployeeLastName;
                    var userData = _dbContext.vwActiveUsers.FirstOrDefault(f => f.UserId == userId);
                    var emailId = CryptoHelper.Decrypt(rcvEmailId);
                    var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == EmailTemplates.ReimbursementRequest && f.IsActive && !f.IsDeleted);

                    if (emailTemplate != null && userData != null)
                    {
                        var contentMsg = string.Format("There is a reimbursement request from {0}, you are requested to take action on the same", userData.EmployeeName);
                        var body = emailTemplate.Template.Replace("[HEADING]", "REIMBURSEMENT REQUEST")
                            .Replace("[RECEIVERNAME]", firstName)
                            .Replace("[MSG]", contentMsg);
                        Utilities.EmailHelper.SendEmailWithDefaultParameter("Reimbursement Request", body, true, true, emailId, null, null, null);
                    }
                }
            }
            else
            {
                response = new ReimbusrementResponse
                {
                    ReimbursementRequestAbrhs = CryptoHelper.Encrypt(result.ReimbursementRequestId.ToString()),
                    Result = result.Result,
                    ReimbursementRequestId = result.ReimbursementRequestId
                };
            }
            return response;
        }

        public List<BaseDropDown> GetReimbursementMonthYearToAddNewRequest(int reimbursementTypeId, int loginUserId)
        {
            var monthYearList = _dbContext.Fun_GetReimbursementMonthYear(reimbursementTypeId).
               Select(s => new BaseDropDown
               {
                   Text = s.MonthYear
               }).ToList();
            return monthYearList ?? new List<BaseDropDown>();
        }

        public List<ReimbursementListBO> GetReimbursementListToView(int reimursementTypeId, int year, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            List<ReimbursementListBO> list = new List<ReimbursementListBO>();

            var result = _dbContext.Proc_GetReimbursementList(userId, reimursementTypeId, year);
            foreach (var s in result)
            {
                var data = new ReimbursementListBO
                {
                    ReimbursementRequestAbrhs = CryptoHelper.Encrypt(s.ReimbursementRequestId.ToString()),
                    ReimbursementRequestId = s.ReimbursementRequestId,
                    ReimursementType = s.ReimbursementTypeName,
                    MonthYear = s.MonthYear,
                    RequestedAmount = s.RequestedAmount.ToString(),
                    ApprovedAmount = s.ApprovedAmount==null?"0.00": s.ApprovedAmount.ToString(),
                    Remarks = s.Remarks,
                    Status = s.Status,
                    CreatedDate = s.CreatedDate,
                    IsActive = s.IsActive,
                    IsSubmitted = s.IsSubmitted == 1 ? true : false,
                    StatusCode = s.StatusCode
                };
                if (s.StatusCode == ReimbursementStatusCode.Cancelled || s.StatusCode == ReimbursementStatusCode.Rejected || s.StatusCode == ReimbursementStatusCode.ReferredBack)
                {
                    data.TotalAmount = "0.00";
                }
                else
                {
                    var amountData = _dbContext.ReimbursementDetails.Where(q => q.ReimbursementRequestId == s.ReimbursementRequestId && q.IsActive == true && q.IsDocumentValid == true).ToList();
                    if (amountData.Count != 0)
                    {
                        data.TotalAmount = amountData.Select(t => t.Amount).Sum().ToString();
                    }
                }
                list.Add(data);

            }
            return list ?? new List<ReimbursementListBO>();
        }

        public AddReimbursementBO GetReimbursementFormData(string reimbursementRequestAbrhs, string userAbrhs)
        {
            if (string.IsNullOrEmpty(reimbursementRequestAbrhs) || string.IsNullOrEmpty(userAbrhs))
                return new AddReimbursementBO();

            var reimbursementRequestId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(reimbursementRequestAbrhs), out reimbursementRequestId);

            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var result = _dbContext.Proc_GetReimbursementFormData(reimbursementRequestId).ToList();
            var data = _dbContext.ReimbursementRequests.FirstOrDefault(t => t.ReimbursementRequestId == reimbursementRequestId);
            List<DocumentDetailBo> dataList = new List<DocumentDetailBo>();
            if (result != null)
            {
                var reqUrl = HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + "/";
#if !DEBUG
                reqUrl = (new UriBuilder(reqUrl) { Port = -1 }).ToString();
#endif
                var folderName = "USR_" + data.UserId;
                var reimbursementDocPath = reqUrl + ConfigurationManager.AppSettings["ReimbursementDocPath"].Replace("\\", "/") + folderName + "/";
                foreach (var t in result)
                {
                    var list = new DocumentDetailBo
                    {
                        ReimbursementDetailId = t.ReimbursementDetailId,
                        ReimbursementDetailAbrhs = CryptoHelper.Encrypt(t.ReimbursementDetailId.ToString()),
                        Amount = t.Amount.ToString(),
                        ImageName = t.DocumentName,
                        BillNo = t.BillNo,
                        Date = t.Date.ToString("MM/dd/yyyy", CultureInfo.InvariantCulture),
                        CategoryId = t.ReimbursementCategoryId,
                        IsActive = t.IsActive,
                        ImagePath = reimbursementDocPath + t.DocumentPath,
                        IsDocumentValid = t.IsDocumentValid,
                        Remarks = t.Remarks,
                        CategoryName = t.ReimbusrementCategory,
                        DateName = t.Date.ToString("dd MMM yyyy", CultureInfo.InvariantCulture),
                    };
                    dataList.Add(list);
                }
            }
            var rs = new AddReimbursementBO();
            rs.DocumentList = dataList ?? new List<DocumentDetailBo>();
            rs.userAbrhs = userAbrhs.Trim();
            rs.ReimbursementRequestId = reimbursementRequestId;
            if (data != null)
            {
                rs.ApprovedAmount = data.ReimbApprovedAmt == null ?string.Empty: data.ReimbApprovedAmt.ToString();
                rs.RequestedAmount = data.ReimbRequestedAmt.ToString();
                rs.TypeId = data.ReimbursementTypeId;
                rs.MonthYear = _dbContext.Fun_GetReimbursementMonthYearToViewAndApprove().
                    FirstOrDefault(s => s.MonthNumber == data.Month && s.Year == data.Year).MonthYear;
            }
            return rs ?? new AddReimbursementBO();
        }

        public int CancelReimbursementRequest(string reimbursementRequestAbrhs, string userAbrhs)
        {
            var reimbursementRequestId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(reimbursementRequestAbrhs), out reimbursementRequestId);
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            int status = 0;
            var result = new ObjectParameter("Success", typeof(int));
            _dbContext.Proc_CancelReimbursementRequest(userId, reimbursementRequestId, result);
            Int32.TryParse(result.Value.ToString(), out status);
            return status;
        }

        public List<ReimbursementListBO> GetReimbursementListToReview(int reimursementTypeId, int year, int loginUserId, string userAbrhs)
        {
            string[] userAbrhsArray = userAbrhs.Split(',');
            var count = userAbrhsArray.Length;
            int[] userIdArray = new int[count];
            for (var i = 0; i < count; i++)
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhsArray[i]), out userId);
                userIdArray[i] = userId;
            }
            List<ReimbursementListBO> list = new List<ReimbursementListBO>();
            var result = _dbContext.Proc_GetReimbursementListToReview(loginUserId, year, reimursementTypeId).ToList();
            var resultList = from t in result where userIdArray.Contains(t.UserId) select t;
            foreach (var s in resultList)
            {
                var data = new ReimbursementListBO
                {
                    ReimbursementRequestAbrhs = CryptoHelper.Encrypt(s.ReimbursementRequestId.ToString()),
                    ReimbursementRequestId = s.ReimbursementRequestId,
                    ReimursementType = s.ReimbursementTypeName,
                    Department = s.Department,
                    RequestedAmount = s.RequestedAmount.ToString(),
                    ApprovedAmount = s.ApprovedAmount == null ? "0.00" : s.ApprovedAmount.ToString(),
                    MonthYear = s.MonthYear,
                    Remarks = s.Remarks,
                    Status = s.Status,
                    CreatedDate = s.SubmittedDate,
                    EmployeeName = s.EmployeeName,
                    StatusCode = s.StatusCode,
                    UserType = _dbContext.Fun_GetAccountApproverId().FirstOrDefault().UserId == loginUserId ? "Verifier" : "MGR"
                };
                if (s.StatusCode == ReimbursementStatusCode.Cancelled || s.StatusCode == ReimbursementStatusCode.Rejected || s.StatusCode == ReimbursementStatusCode.ReferredBack)
                {
                    data.TotalAmount = "0.00";
                }
                else
                {
                    var amountData = _dbContext.ReimbursementDetails.Where(q => q.ReimbursementRequestId == s.ReimbursementRequestId && q.IsActive == true && q.IsDocumentValid == true).ToList();
                    if (amountData.Count != 0)
                    {
                        data.TotalAmount = amountData.Select(t => t.Amount).Sum().ToString();
                    }
                }
                list.Add(data);
            }
            return list ?? new List<ReimbursementListBO>();
        }

        public int TakeActionOnReimbursementRequest(ReimbursementActionData obj, int loginUserId)
        {
            var reimbursementDetailId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(obj.ReimbursementDetailAbrhs), out reimbursementDetailId);
            var reimbursementRequestId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(obj.ReimbursementRequestAbrhs), out reimbursementRequestId);
            var status = 0;
            var result = new ObjectParameter("Success", typeof(int));
            _dbContext.Proc_TakeActionOnReimbursementRequest(reimbursementRequestId, reimbursementDetailId, Convert.ToDecimal(obj.ApprovedAmount), obj.ActionType, obj.Remarks, obj.ReimbursementTypeId, loginUserId, result);
            Int32.TryParse(result.Value.ToString(), out status);
            var requestData = _dbContext.ReimbursementRequests.FirstOrDefault(s => s.ReimbursementRequestId == reimbursementRequestId);
            var statusData = _dbContext.ReimbursementStatus.FirstOrDefault(s => s.StatusId == requestData.StatusId);
            if (status == 1 && requestData != null && statusData != null)
            {
                var action = statusData.StatusCode;
                var actionMsg = statusData.Status.ToLower();
                var userDetailData = _dbContext.vwActiveUsers.FirstOrDefault(f => f.UserId == requestData.UserId);
                var reimbursementType = _dbContext.ReimbursementTypes.FirstOrDefault(s => s.ReimbursementTypeId == requestData.ReimbursementTypeId);
                var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == EmailTemplates.ReimbursementRequest && f.IsActive && !f.IsDeleted);

                if (action == ReimbursementStatusCode.Rejected || action == ReimbursementStatusCode.ReferredBack || action == ReimbursementStatusCode.Verified)
                {
                    var requestedDate = requestData.CreatedDate.ToString("dd MMM yyyy", CultureInfo.InvariantCulture);
                    var rcvEmailId = userDetailData.EmailId;
                    var firstName = userDetailData.EmployeeFirstName;
                    var emailId = CryptoHelper.Decrypt(rcvEmailId);
                    var approverData = _dbContext.vwActiveUsers.FirstOrDefault(f => f.UserId == loginUserId);

                    if (emailTemplate != null && userDetailData != null && approverData != null)
                    {
                        var contentMsg = string.Format("Your reimbursement request created on {0}, has been {1} by {2}", requestedDate, actionMsg, approverData.EmployeeName);
                        var headerMsg = string.Format("Reimbursement request {0}", actionMsg);
                        var body = emailTemplate.Template.Replace("[HEADING]", headerMsg)
                            .Replace("[RECEIVERNAME]", firstName)
                            .Replace("[MSG]", contentMsg);
                        Utilities.EmailHelper.SendEmailWithDefaultParameter(headerMsg, body, true, true, emailId, null, null, null);
                    }
                }
                else if ((action == ReimbursementStatusCode.PendingForApproval || action == ReimbursementStatusCode.PendingForVerification)
                        && reimbursementType.ReimbursementTypeName == ReimbursementTypeName.Others && requestData.NextApproverId != null)
                {
                    var nextApproverData = _dbContext.vwActiveUsers.FirstOrDefault(f => f.UserId == requestData.NextApproverId);
                    if (nextApproverData != null)
                    {
                        var rcvEmailId = nextApproverData.EmailId;
                        var firstName = nextApproverData.EmployeeFirstName;
                        var emailId = CryptoHelper.Decrypt(rcvEmailId);
                        if (emailTemplate != null && userDetailData != null)
                        {
                            var contentMsg = string.Format("There is a reimbursement request from {0}, you are requested to take action on the same", userDetailData.EmployeeName);
                            var body = emailTemplate.Template.Replace("[HEADING]", "Reimbursement Request")
                                .Replace("[RECEIVERNAME]", firstName)
                                .Replace("[MSG]", contentMsg);
                            Utilities.EmailHelper.SendEmailWithDefaultParameter("Reimbursement Request", body, true, true, emailId, null, null, null);
                        }
                    }

                }
            }
            _userServices.SaveUserLogs(ActivityMessages.ReimbursementAction, loginUserId, 0);
            return status;
        }

        public ReimbursementDropDown GetReimbursementMonthYearToViewAndApprove()
        {
            ReimbursementDropDown listObject = new ReimbursementDropDown();
            var today = DateTime.Today;
            var monthNew = today.Month;
            var year = today.Year;
            if (monthNew <= 3)
            {
                year = today.Year - 1;
            }
            var dataNew = _dbContext.Fun_GetReimbursementMonthYearToViewAndApprove().Where(s => s.Year <= year).ToList();
            var data = _dbContext.Fun_GetReimbursementMonthYearToViewAndApprove();
            if (data != null && dataNew.Count != 0)
            {
                var list = dataNew.Select(m => new { m.Year }).Distinct().OrderByDescending(t => t.Year);
                var yearList = list.Select(x => new YearList()
                {
                    Year = x.Year.Value
                }).ToList();

                var monthYearList = data.Select(s => new MonthYearList()
                {
                    MonthYear = s.MonthYear
                }).ToList();
                listObject.YearText = yearList;
                listObject.MonthYearText = monthYearList;
            }
            return listObject ?? new ReimbursementDropDown();
        }

        public List<ReimbursementStatusHistory> GetReimbusrementStatusHistory(int reimbursementRequestId)
        {
            List<ReimbursementStatusHistory> listStatus = new List<ReimbursementStatusHistory>();
            var data = (from h in _dbContext.ReimbursementHistories.AsEnumerable()
                        join s in _dbContext.ReimbursementStatus on h.StatusId equals s.StatusId
                        join vw in _dbContext.vwActiveUsers on h.CreatedById equals vw.UserId
                        where h.ReimbursementRequestId == reimbursementRequestId
                        select new ReimbursementStatusHistory
                        {
                            Status = s.Status,
                            ApproverName = vw.EmployeeName,
                            Date = h.CreatedDate.ToString("dd MMM yyyy hh:mm tt"),
                            CreatedDate = h.CreatedDate,
                            Remarks = h.Remarks == "Submitted" || h.Remarks == "Cancelled" ? "" : h.Remarks,
                        }).OrderByDescending(p => p.CreatedDate).ToList();
            return data ?? new List<ReimbursementStatusHistory>();
        }

        public List<EmployeeBO> GetAllEmployeesForReimbursement()
        {

            var employees = _dbContext.vwActiveUsers.ToList();
            if (employees.Any())
            {
                var result = employees.Select(e => new EmployeeBO
                {
                    EmployeeName = e.EmployeeName,
                    EmployeeAbrhs = CryptoHelper.Encrypt(e.UserId.ToString()),
                }).ToList();

                return result.OrderBy(x => x.EmployeeName).ToList();
            }
            return null;
        }
    }
}
