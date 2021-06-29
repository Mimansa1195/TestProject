using MIS.BO;
using MIS.Model;
using MIS.Services.Contracts;
using MIS.Utilities;
using MIS.Utilities.Helpers;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Entity.Core.Objects;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Xml.Linq;

namespace MIS.Services.Implementations
{
    public class AssetServices : IAssetServices
    {

        private readonly IUserServices _userServices;

        public AssetServices(IUserServices userServices)
        {
            _userServices = userServices;
        }

        #region Private member variables

        private readonly MISEntities _dbContext = new MISEntities();

        #endregion

        public string GetUserCommentForDongleAllocation(string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var result = _dbContext.spGetUserCommentsForDongleAllocation(userId).FirstOrDefault();
            return result;
        }

        public bool GetConflictStatusOfDongleAllocationPeriod(DateTime issueFromDate, DateTime returnDueDate, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var result = _dbContext.spGetConflictStatusOfDongleAllocationPeriod(issueFromDate, returnDueDate, userId).FirstOrDefault().GetValueOrDefault();
            return result;
        }

        public List<AssetDataBO> GetAssetDetailsForReportingManager(int statusId, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var result = _dbContext.spGetAssetDetailsForReportingManager(userId, statusId).ToList();
            if (result.Any())
            {
                List<AssetDataBO> list = new List<AssetDataBO>();
                foreach (var t in result)
                {
                    AssetDataBO data = new AssetDataBO()
                    {
                        RequestId = t.RequestId,
                        EmployeeName = t.EmployeeName,
                        Reason = t.Reason,
                        Asset = t.Asset,
                        IssueFromDate = t.IssueFromDate.ToString("dd-MMM-yyyy"),//"MM'/'dd'/'yyyy"),
                        ReturnDueDate = t.ReturnDueDate.ToString("dd-MMM-yyyy"),//"MM'/'dd'/'yyyy"),
                    };
                    list.Add(data);
                }
                return (list);
            }
            else
                return (null);
        }

        public List<AssetDataBO> GetAssetDetailsForITDepartment(int statusId)
        {
            var result = _dbContext.spGetAssetDetailsForITDepartment(statusId).ToList();
            if (result.Any())
            {
                List<AssetDataBO> list = new List<AssetDataBO>();
                foreach (var t in result)
                {
                    AssetDataBO data = new AssetDataBO()
                    {
                        RequestId = t.RequestId,
                        EmployeeName = t.EmployeeName,
                        Department = t.Department,
                        AssetTag = t.AssetTag,
                        ReportingManager = t.ReportingManager,
                        Reason = t.Reason,
                        Asset = t.Asset,
                        IssueFromDate = t.IssueFromDate.ToString("dd-MMM-yyyy"),//"MM'/'dd'/'yyyy"),
                        ReturnDueDate = t.ReturnDueDate.ToString("dd-MMM-yyyy"),//"MM'/'dd'/'yyyy"),
                        UserReturnDate = t.UserReturnDate == null ? "NA" : t.UserReturnDate.Value.ToString("dd-MMM-yyyy"),//("MM'/'dd'/'yyyy"),
                    };
                    list.Add(data);
                }
                return (list);
            }
            else
                return (null);
        }

        public DongleDetailBO GetAssetDetailOnBasisOfAssetTag(string assetTag)
        {
            var result = _dbContext.spGetAssetDetailOnBasisOfAssetTag(assetTag).FirstOrDefault();
            if (result != null)
            {
                BO.DongleDetailBO temp = new BO.DongleDetailBO()
                {
                    AssetDetailId = result.AssetDetailId,
                    SerialNumber = result.IMEINo,
                    SimNumber = result.PostpaidNo,
                    Make = result.Make,
                    Model = result.Model,
                    IsIssued = result.IsIssued,
                };
                return (temp);
            }
            else
                return (null);
        }

        public List<string> GetAvailableAssetTag()
        {
            var data = _dbContext.spGetAvailableAssetTag().ToList();
            if (data != null)
            {
                var result = new List<string>();
                foreach (var temp in data)
                {
                    result.Add(temp);
                }
                return result;
            }
            return null;
        }

        public DongleReturnInfoBO GetAssetDetailOnBasisOfRequestId(long requestId)
        {
            var result = _dbContext.spGetAssetDetailOnBasisOfRequestId(requestId).FirstOrDefault();
            if (result != null)
            {
                DongleReturnInfoBO temp = new BO.DongleReturnInfoBO()
                {
                    TransactionId = result.TransactionId,
                    EmployeeName = result.EmployeeName,
                    AssetTag = result.AssetTag,
                    SerialNumber = result.SerialNo,
                    SimNumber = result.SimNo,
                    ReturnDueDate = result.ReturnDueDate.ToString("dd-MMM-yyyy"),//"MM'/'dd'/'yyyy"),
                    IssueDate = result.IssueDate.ToString("dd-MMM-yyyy"),//"MM'/'dd'/'yyyy"),
                };
                return (temp);
            }
            else
                return (null);
        }

        public List<AssetDataBO> GetAllAssetRequest(string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var result = _dbContext.spGetAssetStatusForUser(userId).ToList();
            if (result.Any())
            {
                List<AssetDataBO> list = new List<AssetDataBO>();
                foreach (var data in result)
                {
                    AssetDataBO temp = new AssetDataBO()
                    {
                        RequestId = data.RequestId,
                        Asset = data.Asset,
                        StatusId = data.StatusId,
                        Status = data.Status,
                        IssueFromDate = data.IssueFromDate.ToString("dd-MMM-yyyy"),//("MM'/'dd'/'yyyy"),
                        ReturnDueDate = data.ReturnDueDate.ToString("dd-MMM-yyyy"),//("MM'/'dd'/'yyyy"),
                        AllocatedDate = data.AllocatedDate == null ? "NA" : data.AllocatedDate.Value.ToString("dd-MMM-yyyy"),//("MM'/'dd'/'yyyy"),
                        Reason = data.Reason,
                    };
                    switch (data.StatusId)
                    {
                        case -1:
                            temp.StatusColour = "black";
                            break;
                        case 0:
                            temp.StatusColour = "black";
                            break;
                        case 1:
                            temp.StatusColour = "black";
                            break;
                        case 2:
                            temp.StatusColour = "black";
                            break;
                        case 3:
                            temp.StatusColour = "black";
                            break;
                        case 4:
                            temp.StatusColour = "black";
                            break;
                    }
                    list.Add(temp);
                }
                return (list);
            }
            else
                return (null);
        }

        public List<AssetCountBO> GetAllAssetCountData()
        {
            var result = _dbContext.spGetAssetCountForAllDepartment().ToList();
            if (result.Any())
            {
                var list = new List<AssetCountBO>();
                foreach (var data in result)
                {
                    list.Add(new AssetCountBO()
                    {
                        AllotedToDepartment = data.AllotedToDepartment,
                        AllocatedToDepartment = data.AllocatedToDepartment,
                        AllocatedToParentTeam = data.AllocatedToParentTeam,
                        AllocatedToSubTeam = data.AllocatedToSubTeam,
                        DeptWisePercentageAllocation = data.DeptWisePercentageAllocation,
                    });
                }
                return list;
            }
            else
                return (null);
        }

        public List<AssetCountBO> GetAssetCountDataByManagerId(string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var result = _dbContext.spGetAssetCountForDepartmentByManagerId(userId).ToList();
            if (result.Any())
            {
                List<AssetCountBO> list = new List<AssetCountBO>();
                foreach (var data in result)
                {
                    list.Add(new AssetCountBO()
                    {
                        AllotedToDepartment = data.AllotedToDepartment,
                        AllocatedToDepartment = data.AllocatedToDepartment,
                        AllocatedToParentTeam = data.AllocatedToParentTeam,
                        AllocatedToSubTeam = data.AllocatedToSubTeam,
                        DeptWisePercentageAllocation = data.DeptWisePercentageAllocation,
                    });
                }
                return (list);
            }
            else
                return (null);

        }

        public bool CreateAssetRequest(string reason, DateTime issueDate, DateTime returnDate, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var result = _dbContext.spCreateAssetRequest(1, reason, issueDate, returnDate, userId).FirstOrDefault().Value;

            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.CreateAssetRequest, userId, 0);

            return result;
        }

        public bool TakeActionOnAssetRequest(int requestId, int statusId, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var result = _dbContext.spTakeActionOnAssetRequest(requestId, statusId, userId).FirstOrDefault().Value;

            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.TakeActionOnAssetRequest, userId, 0);

            return result;
        }

        public bool AllocateAsset(long requestId, long assetDetailId, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var result = _dbContext.spAllocateAsset(requestId, assetDetailId, userId).FirstOrDefault();
            if (result.Result == true)
            {
                if (result.SendEmailToManager.Equals("Yes"))
                {
                    var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "Dongle Alert" && f.IsActive && !f.IsDeleted);
                    if (emailTemplate != null)
                    {
                        var Departments = _dbContext.Departments.Where(f => f.DepartmentId == result.DepartmentId).ToList();
                        foreach (var temp in Departments)
                        {
                            var managerDetail = _dbContext.UserDetails.FirstOrDefault(f => f.UserId == temp.DepartmentHeadId);
                            var emailId = CryptoHelper.Decrypt(managerDetail.EmailId);
                            var body = emailTemplate.Template;

                            if (result.AllAllocated == true)
                                body = body.Replace("[Name]", managerDetail.FirstName).Replace("[Quantity]", "All");
                            else
                                body = body.Replace("[Name]", managerDetail.FirstName).Replace("[Quantity]", "Half");

                            Utilities.EmailHelper.SendEmailWithDefaultParameter("Alert for Dongle Allocated", body, true, true, emailId, null, null, null);
                            //Utilities.EmailHelper.SendEmailWithDefaultParameter("Alert for Dongle Allocated", body, true, true, emailId, null, null, null);
                        }
                    }
                }

                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.AllocateAsset, userId, 0);

                return true;
            }
            else
                return false;
        }

        public bool ReturnAsset(long transactionId, DateTime returnDate, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var result = _dbContext.spReturnAsset(transactionId, returnDate, userId).FirstOrDefault();

            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.ReturnAsset, userId, 0);

            if (result.Value == true)
                return true;
            else
                return false;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="requestId"></param>
        /// <param name="returnDate"></param>
        /// <param name="userAbrhs"></param>
        /// <returns>1: success, 2: return date cannot be prior to allocated date, 3: error</returns>
        public int ReturnAssetByUser(long requestId, DateTime returnDate, string userAbrhs)
        {
            if (_dbContext.AssetRequests.FirstOrDefault(x => x.RequestId == requestId).LastModifiedDate > returnDate)
                return 2;
            else
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                var result = _dbContext.spReturnAssetByUser(requestId, returnDate, userId).FirstOrDefault();

                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.ReturnAsset, userId, 0);

                if (result.Value == true)
                    return 1;
                else
                    return 3;
            }
        }

        //public string AssignDongle(string userAbrhs, int requestId, string serialNumber, string simNumber, string otherDetails, string comments)
        //{
        //    var userId = 0;
        //    Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
        //    var result = _dbContext.spAssignDongle(userId, requestId, serialNumber, simNumber, otherDetails, comments).ToString();

        //    // Logging 
        //    _userServices.SaveUserLogs(ActivityMessages.AssignDongle, userId, 0);

        //    return result;
        //}


        public List<AssetDetailBO> GetAllAssets()
        {
            return _dbContext.spGetAllAssets().Select(x => new AssetDetailBO
            {
                AssetDetailId = x.AssetDetailId,
                Make = x.Make,
                Model = x.Model,
                Description = x.Description,
                SerialNumber = x.SerialNo,
                AssetTag = x.AssetTag,
                AttributeType = x.AttributeType,
                AttributeValue = x.AttributeValue
            }).ToList();
        }

        public AssetDetailBO GetAssetDetailsById(long assetDetailId)
        {
            return (from ad in _dbContext.AssetDetails.Where(x => x.IsActive && x.AssetDetailId == assetDetailId)
                    join adt in _dbContext.AssetDetailAttributes.Where(x => x.IsActive) on ad.AssetDetailId equals adt.AssetDetailId
                    join a in _dbContext.Assets.Where(x => x.IsActive) on ad.AssetId equals a.AssetId
                    join at in _dbContext.AssetTypes.Where(x => x.IsActive) on a.TypeId equals at.TypeId
                    select new AssetDetailBO
                    {
                        AssetTypeId = at.TypeId,
                        AssetId = a.AssetId,
                        AssetDetailId = ad.AssetDetailId,
                        AssetType = at.Type,
                        Model = a.Make + " - " + a.Model + "( " + a.Description + " )",
                        SerialNumber = ad.SerialNo,
                        AssetTag = ad.AssetTag,
                        AttributeType = adt.AttributeType,
                        AttributeValue = adt.AttributeValue,
                    }).FirstOrDefault();
        }

        public bool AddAssetDetails(AssetDetailBO assetDetails)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(assetDetails.UserAbrhs), out userId);

            var result = _dbContext.spAddAssetDetails(assetDetails.AssetId, assetDetails.SerialNumber, assetDetails.AssetTag, assetDetails.AttributeType,
                                    assetDetails.AttributeValue, userId).FirstOrDefault().Value;
            return result;
        }

        public bool UpdateAssetDetails(AssetDetailBO assetDetails)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(assetDetails.UserAbrhs), out userId);

            var assetDetail = _dbContext.AssetDetails.FirstOrDefault(x => x.AssetDetailId == assetDetails.AssetDetailId && x.IsActive == true);
            assetDetail.SerialNo = assetDetails.SerialNumber;
            assetDetail.AssetTag = assetDetails.AssetTag;
            assetDetail.LastModifiedBy = userId;
            assetDetail.LastModifiedDate = DateTime.Now;
            var assetDetailAttribute = _dbContext.AssetDetailAttributes.FirstOrDefault(x => x.AssetDetailId == assetDetails.AssetDetailId && x.IsActive == true);
            assetDetailAttribute.AttributeType = assetDetails.AttributeType;
            assetDetailAttribute.AttributeValue = assetDetails.AttributeValue;
            assetDetailAttribute.LastModifiedBy = userId;
            assetDetailAttribute.LastModifiedDate = DateTime.Now;
            _dbContext.SaveChanges();
            return true;
        }

        public bool DeleteAssetDetails(long assetDetailId, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            var assetDetail = _dbContext.AssetDetails.FirstOrDefault(x => x.AssetDetailId == assetDetailId && x.IsActive == true);
            assetDetail.IsActive = false;
            assetDetail.LastModifiedBy = userId;
            assetDetail.LastModifiedDate = DateTime.Now;
            var assetDetailAttribute = _dbContext.AssetDetailAttributes.FirstOrDefault(x => x.AssetDetailId == assetDetailId && x.IsActive == true);
            assetDetailAttribute.IsActive = false;
            assetDetailAttribute.LastModifiedBy = userId;
            assetDetailAttribute.LastModifiedDate = DateTime.Now;
            _dbContext.SaveChanges();
            return true;
        }

        #region New Implementation
        public int AddUpdateAssetsDetail(AssetDetailBO assetD, int loginUserId)
        {
            int status = 0;
            var response = new ObjectParameter("Success", typeof(int));
            _dbContext.Proc_AddUpdateAssetsDetail(assetD.AssetId, assetD.AssetTypeId, assetD.BrandId, assetD.Model, assetD.SerialNumber, assetD.Description, assetD.IsActive, loginUserId, response);
            Int32.TryParse(response.Value.ToString(), out status);
            return status;
        }

        public List<AssetDetailBO> GetAssetsBrand()
        {
            var result = _dbContext.AssetsBrands.Where(test => test.IsActive == true);

            var response = result.Select(t => new AssetDetailBO
            {
                BrandId = t.BrandId,
                BrandName = t.BrandName
            }).ToList();
            return response ?? new List<AssetDetailBO>();
        }

        public List<AssetDetailBO> GetAllAssetsDetail()
        {
            var result = _dbContext.Proc_GetAllAssetsDetail().Select(x => new AssetDetailBO
            {
                AssetId = x.AssetId,
                AssetTypeId = x.TypeId,
                AssetType = x.Type,
                BrandId = x.BrandId,
                BrandName = x.BrandName,
                Model = x.Model,
                SerialNumber = x.SerialNo,
                Description = x.Description,
                IsActive = x.IsActive,
                CreatedBy = x.CreatedBy,
                CreatedDate = x.CreatedDate,
                ModifiedOn = x.ModifiedDate,
                ModifiedBy = x.ModifiedBy,
                AllocatedOn = x.AssignedOn,
                AllocatedTo = x.AssignedTo,
                IsFree = x.IsFree.HasValue ? x.IsFree.Value : false,
                IsLost = x.IsLost,
            }).ToList();

            return result ?? new List<AssetDetailBO>();
        }

        public int AddUpdateUsersAssetsDetail(UserAssetDetail assetD, int loginUserId)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(assetD.UserAbrhs), out userId);
            int status = 0;
            string assetRequestIds = "";
            var response = new ObjectParameter("Success", typeof(int));
            var requestId = new ObjectParameter("NewAssetRequestIds", typeof(long));
            _dbContext.Proc_AddUpdateUsersAsset(userId, assetD.AssetRequestIds, assetD.AssetIds, assetD.FromDate, assetD.TillDate, assetD.Remarks, assetD.ActionCode, assetD.IsActive, loginUserId, response, requestId);
            Int32.TryParse(response.Value.ToString(), out status);
            assetRequestIds = requestId.Value.ToString();
            var greetings = "Hi All";
            var subject = "";
            var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "Assets Notification Mail" && f.IsActive && !f.IsDeleted);
            if (status == 1 && assetD.ActionCode == "AS" && !string.IsNullOrEmpty(assetRequestIds) && assetRequestIds != "0")
            {
                var userAssetData = _dbContext.Proc_GetAssetsDetailsByRequestId(assetRequestIds).ToList();
                if (emailTemplate != null && userAssetData.Count() > 0 && assetD.AssetRequestId == 0)
                {
                    var userData = userAssetData.FirstOrDefault();

                    var empName = userData.EmployeeName;
                    var empCode = userData.EmployeeCode;
                    var rmName = userData.ReportingManagerName;
                    var mbNumber = CryptoHelper.Decrypt(userData.MobileNumber);

                    var line1 = "Asset has been allocated successfully. Please find below the summary.";
                    subject = "Asset Allocation Summary";
                    var recivermailId = ConfigurationManager.AppSettings["AssetAllocation"];

                    var userInfoHtml = String.Format("<label>Employee Name: </label><label><b>{0}</b></label><br/><label>Employee Code: </label><label><b>{1}</b></label><br/><label>Reporting Manager: </label><label><b>{2}</b></label><br/><label>Mobile No. : </label><label><b>{3}</b></label><br/>", empName, empCode, rmName, mbNumber);

                    var tableHtml = "<table style = 'border-collapse:collapse; width:100%; border: 1px solid #ddd; padding: 8px;'><thead style = 'padding-top: 12px; padding-bottom: 12px;text-align: left;background-color: #799c79; color: #ffffff;'><tr><th style = 'border: 1px solid #ddd; padding: 8px;'><div>Asset</div></th><th style = 'border: 1px solid #ddd; padding: 8px;'><div>Make</div></th><th style = 'border: 1px solid #ddd; padding: 8px;'><div>Model</div></th><th style = 'border: 1px solid #ddd; padding: 8px;'><div>S.No</div></th><th style = 'border: 1px solid #ddd; padding: 8px;'><div>Allocated From</div></th><th style = 'border: 1px solid #ddd; padding: 8px;'><div>Assigned On</div></th><th style = 'border: 1px solid #ddd; padding: 8px;'><div>Assigned By</div></th></tr></thead><tbody>";
                    var temp = "";
                    foreach (var userAssetInfo in userAssetData)
                    {
                        temp = temp + string.Format("<tr style= 'background-color: #f2f2f2;'><td style = 'border: 1px solid #ddd; padding: 8px;'>{0}</td><td style = 'border: 1px solid #ddd; padding: 8px;'>{1}</td><td style = 'border: 1px solid #ddd; padding: 8px;'>{2}</td><td style = 'border: 1px solid #ddd; padding: 8px;'>{3}</td><td style = 'border: 1px solid #ddd; padding: 8px;'>{4}</td><td style = 'border: 1px solid #ddd; padding: 8px;'>{5}</td><td style = 'border: 1px solid #ddd; padding: 8px;'>{6}</td> ", userAssetInfo.Type, userAssetInfo.BrandName, userAssetInfo.Model, userAssetInfo.SerialNo, userAssetInfo.AllocateFrom, userAssetInfo.CreatedDate, userAssetInfo.CreatedBy);
                    }

                    tableHtml = userInfoHtml + "<br />" + tableHtml + temp;
                    tableHtml = tableHtml + "</tbody></table>";

                    var body = emailTemplate.Template
                     .Replace("[BGColor]", "#caecca")
                     .Replace("[TextColor]", "#000000")
                     .Replace("[Title]", subject)
                     .Replace("[Name]", greetings)
                     .Replace("[Line1]", line1)
                     .Replace("[Data]", tableHtml);
                    EmailHelper.SendEmailWithDefaultParameter(subject, body, true, true, recivermailId, null, null, null);
                }
            }
            else if (status == 1 && assetD.ActionCode == "DA" && !string.IsNullOrEmpty(assetD.AssetRequestIds) && assetD.AssetRequestIds != "0") // when deallocated by IT Team
            {
                var userAssetData = _dbContext.Proc_GetAssetsDetailsByRequestId(assetD.AssetRequestIds).ToList();
                var loginUser = _dbContext.vwAllUsers.FirstOrDefault(t => t.UserId == loginUserId);
                int userDesignationGrpId = 0;
                if (loginUser != null)
                {
                    userDesignationGrpId = loginUser.DesignationGroupId;
                }

                if (userDesignationGrpId == (int)Enums.DesignationGroup.Administration)
                {
                    status = MarkAssetCollected(assetD, userId, loginUserId);
                }

                if ((userDesignationGrpId == (int)Enums.DesignationGroup.ITNetwork || userDesignationGrpId == (int)Enums.DesignationGroup.ITSystems) && emailTemplate != null && userAssetData != null && userAssetData.Count() > 0)
                {
                    var userData = userAssetData.FirstOrDefault();
                    var empName = userData.EmployeeName;
                    var empCode = userData.EmployeeCode;
                    var rmName = userData.ReportingManagerName;
                    var mbNumber = CryptoHelper.Decrypt(userData.MobileNumber);

                    var line1 = "Asset has been received from user. Please collect it from IT Team.";
                    subject = "Asset De-Allocation Summary";
                    var recivermailId = ConfigurationManager.AppSettings["AssetDeAllocation"];
                    var userInfoHtml = String.Format("<label>Employee Name: </label><label><b>{0}</b></label><br/><label>Employee Code: </label><label><b>{1}</b></label><br/><label>Reporting Manager: </label><label><b>{2}</b></label><br/><label>Mobile No. : </label><label><b>{3}</b></label><br/>", empName, empCode, rmName, mbNumber);

                    var tableHtml = "<table style = 'border-collapse:collapse; width:100%; border: 1px solid #ddd; padding: 8px;'><thead style = 'padding-top: 12px; padding-bottom: 12px;text-align: left;background-color: #bb6d6d; color:#ffffff;'><tr><th style = 'border: 1px solid #ddd; padding: 8px;'><div>Asset</div></th><th style = 'border: 1px solid #ddd; padding: 8px;'><div>Make</div></th><th style = 'border: 1px solid #ddd; padding: 8px;'><div>Model</div></th><th style = 'border: 1px solid #ddd; padding: 8px;'><div>S.No</div></th><th style = 'border: 1px solid #ddd; padding: 8px;'><div>Allocated From</div></th><th style = 'border: 1px solid #ddd; padding: 8px;'><div>Allocated Till</div></th><th style = 'border: 1px solid #ddd; padding: 8px;'><div>De Allocated on</div></th><th style = 'border: 1px solid #ddd; padding: 8px;'><div>De Allocated By</div></th></tr></thead><tbody>";
                    var temp = "";
                    foreach (var userAssetInfo in userAssetData)
                    {
                        temp = temp + string.Format("<tr style= 'background-color: #f2f2f2;'><td style = 'border: 1px solid #ddd; padding: 8px;'>{0}</td><td style = 'border: 1px solid #ddd; padding: 8px;'>{1}</td><td style = 'border: 1px solid #ddd; padding: 8px;'>{2}</td><td style = 'border: 1px solid #ddd; padding: 8px;'>{3}</td><td style = 'border: 1px solid #ddd; padding: 8px;'>{4}</td><td style = 'border: 1px solid #ddd; padding: 8px;'>{5}</td><td style = 'border: 1px solid #ddd; padding: 8px;'>{6}</td> <td style = 'border: 1px solid #ddd; padding: 8px;'>{7}</td>", userAssetInfo.Type, userAssetInfo.BrandName, userAssetInfo.Model, userAssetInfo.SerialNo, userAssetInfo.AllocateFrom, userAssetInfo.AllocateTill, userAssetInfo.ModifiedDate, userAssetInfo.ModifiedBy);
                    }
                    tableHtml = userInfoHtml + "<br />" + tableHtml + temp;
                    tableHtml = tableHtml + "</tbody></table>";

                    var body = emailTemplate.Template
                        .Replace("[BGColor]", "#fddddd")
                        .Replace("[TextColor]", "#000000")
                        .Replace("[Title]", subject)
                        .Replace("[Name]", greetings)
                        .Replace("[Line1]", line1)
                        .Replace("[Data]", tableHtml);
                    EmailHelper.SendEmailWithDefaultParameter(subject, body, true, true, recivermailId, null, null, null);
                }
            }
            else if (status == 1 && assetD.ActionCode == "AL" && !string.IsNullOrEmpty(assetD.AssetRequestIds) && assetD.AssetRequestIds != "0")
            {
                var userAssetData = _dbContext.Proc_GetAssetsDetailsByRequestId(assetD.AssetRequestIds).ToList();

                if (emailTemplate != null && userAssetData != null && userAssetData.Count() > 0)
                {
                    var userData = userAssetData.FirstOrDefault();
                    var empName = userData.EmployeeName;
                    var empCode = userData.EmployeeCode;
                    var rmName = userData.ReportingManagerName;
                    var mbNumber = CryptoHelper.Decrypt(userData.MobileNumber);

                    subject = "Lost Asset Summary";
                    var line1 = "Asset has been marked lost. Please find below the summary.";
                    var recivermailId = ConfigurationManager.AppSettings["AssetCollection"];

                    var userInfoHtml = String.Format("<label>Employee Name: </label><label><b>{0}</b></label><br/><label>Employee Code: </label><label><b>{1}</b></label><br/><label>Reporting Manager: </label><label><b>{2}</b></label><br/><label>Mobile No. : </label><label><b>{3}</b></label><br/>", empName, empCode, rmName, mbNumber);

                    var tableHtml = "<table style = 'border-collapse:collapse; width:100%; border: 1px solid #ddd; padding: 8px;'><thead style = 'padding-top: 12px; padding-bottom: 12px;text-align: left;background-color: #bb6d6d;color: #ffffff;'><tr><th style = 'border: 1px solid #ddd; padding: 8px;'><div>Asset</div></th><th style = 'border: 1px solid #ddd; padding: 8px;'><div>Make</div></th><th style = 'border: 1px solid #ddd; padding: 8px;'><div>Model</div></th><th style = 'border: 1px solid #ddd; padding: 8px;'><div>S.No</div></th><th style = 'border: 1px solid #ddd; padding: 8px;'><div>Allocated From</div></th><th style = 'border: 1px solid #ddd; padding: 8px;'><div>Allocated Till</div></th><th style = 'border: 1px solid #ddd; padding: 8px;'><div>Remarks</div></th><th style = 'border: 1px solid #ddd; padding: 8px;'><div>De Allocated on</div></th><th style = 'border: 1px solid #ddd; padding: 8px;'><div>De Allocated By</div></th></tr></thead><tbody>";
                    var temp = "";
                    foreach (var userAssetInfo in userAssetData)
                    {
                        temp = string.Format("<tr style= 'background-color: #f2f2f2;'><td style = 'border: 1px solid #ddd; padding: 8px;'>{0}</td><td style = 'border: 1px solid #ddd; padding: 8px;'>{1}</td><td style = 'border: 1px solid #ddd; padding: 8px;'>{2}</td><td style = 'border: 1px solid #ddd; padding: 8px;'>{3}</td><td style = 'border: 1px solid #ddd; padding: 8px;'>{4}</td><td style = 'border: 1px solid #ddd; padding: 8px;'>{5}</td><td style = 'border: 1px solid #ddd; padding: 8px;'>{6}</td> <td style = 'border: 1px solid #ddd; padding: 8px;'>{7}</td><td style = 'border: 1px solid #ddd; padding: 8px;'>{8}</td>", userAssetInfo.Type, userAssetInfo.BrandName, userAssetInfo.Model, userAssetInfo.SerialNo, userAssetInfo.AllocateFrom, userAssetInfo.AllocateTill, assetD.Remarks, userAssetInfo.ModifiedDate, userAssetInfo.ModifiedBy);
                    }

                    tableHtml = userInfoHtml + "<br />" + tableHtml + temp;
                    tableHtml = tableHtml + "</tbody></table>";

                    var body = emailTemplate.Template
                        .Replace("[BGColor]", "#fddddd")
                        .Replace("[TextColor]", "#000000")
                        .Replace("[Title]", subject)
                        .Replace("[Name]", greetings)
                        .Replace("[Line1]", line1)
                        .Replace("[Data]", tableHtml);
                    EmailHelper.SendEmailWithDefaultParameter(subject, body, true, true, recivermailId, null, null, null);
                }
            }
            else if (status == 1 && assetD.ActionCode == "AC" && !string.IsNullOrEmpty(assetD.AssetRequestIds) && assetD.AssetRequestIds != "0")
            {
                var userAssetData = _dbContext.Proc_GetAssetsDetailsByRequestId(assetD.AssetRequestIds).ToList();
                if (emailTemplate != null && userAssetData != null && userAssetData.Count() > 0)
                {

                    var userData = userAssetData.FirstOrDefault();
                    var empName = userData.EmployeeName;
                    var empCode = userData.EmployeeCode;
                    var rmName = userData.ReportingManagerName;
                    var mbNumber = CryptoHelper.Decrypt(userData.MobileNumber);
                    subject = "Asset Return Summary";
                    var line1 = "Asset has been collected by Admin Team. Please find below the summary.";
                    var recivermailId = ConfigurationManager.AppSettings["AssetCollection"];

                    var userInfoHtml = String.Format("<label>Employee Name: </label><label><b>{0}</b></label><br/><label>Employee Code: </label><label><b>{1}</b></label><br/><label>Reporting Manager: </label><label><b>{2}</b></label><br/><label>Mobile No. : </label><label><b>{3}</b></label><br/>", empName, empCode, rmName, mbNumber);

                    var tableHtml = "<table style = 'border-collapse:collapse; width:100%; border: 1px solid #ddd; padding: 8px;'><thead style = 'padding-top: 12px; padding-bottom: 12px;text-align: left;background-color: #6d77bb;color: #ffffff;'><tr><th style = 'border: 1px solid #ddd; padding: 8px;'><div>Asset</div></th><th style = 'border: 1px solid #ddd; padding: 8px;'><div>Make</div></th><th style = 'border: 1px solid #ddd; padding: 8px;'><div>Model</div></th><th style = 'border: 1px solid #ddd; padding: 8px;'><div>S.No</div></th><th style = 'border: 1px solid #ddd; padding: 8px;'><div>Allocated From</div></th><th style = 'border: 1px solid #ddd; padding: 8px;'><div>Allocated Till</div></th><th style = 'border: 1px solid #ddd; padding: 8px;'><div>De Allocated On</div></th><th style = 'border: 1px solid #ddd; padding: 8px;'><div>De Allocated By</div></th><th style = 'border: 1px solid #ddd; padding: 8px;'><div>Collected On</div></th><th style = 'border: 1px solid #ddd; padding: 8px;'><div>Collected By</div></th></tr></thead><tbody>";
                    var temp = "";
                    foreach (var userAssetInfo in userAssetData)
                    {
                        temp = temp + string.Format("<tr style= 'background-color: #f2f2f2;'><td style = 'border: 1px solid #ddd; padding: 8px;'>{0}</td><td style = 'border: 1px solid #ddd; padding: 8px;'>{1}</td><td style = 'border: 1px solid #ddd; padding: 8px;'>{2}</td><td style = 'border: 1px solid #ddd; padding: 8px;'>{3}</td><td style = 'border: 1px solid #ddd; padding: 8px;'>{4}</td><td style = 'border: 1px solid #ddd; padding: 8px;'>{5}</td><td style = 'border: 1px solid #ddd; padding: 8px;'>{6}</td><td style = 'border: 1px solid #ddd; padding: 8px;'>{7}</td><td style = 'border: 1px solid #ddd; padding: 8px;'>{8}</td><td style = 'border: 1px solid #ddd; padding: 8px;'>{9}</td>", userAssetInfo.Type, userAssetInfo.BrandName, userAssetInfo.Model, userAssetInfo.SerialNo, userAssetInfo.AllocateFrom, userAssetInfo.AllocateTill, userAssetInfo.ModifiedDate, userAssetInfo.ModifiedBy, userAssetInfo.CollectedOn, userAssetInfo.CollectedBy);
                    }

                    tableHtml = userInfoHtml + "<br />" + tableHtml + temp;
                    tableHtml = tableHtml + "</tbody></table>";

                    var body = emailTemplate.Template
                        .Replace("[BGColor]", "#ced3f5")
                        .Replace("[TextColor]", "#000000")
                        .Replace("[Title]", subject)
                        .Replace("[Name]", greetings)
                        .Replace("[Line1]", line1)
                        .Replace("[Data]", tableHtml);
                    EmailHelper.SendEmailWithDefaultParameter(subject, body, true, true, recivermailId, null, null, null);
                }
            }
            return status;
        }

        public int MarkAssetCollected(UserAssetDetail assetD, int userId, int loginUserId)
        {
            int status = 0;
            string assetRequestIds = "";
            var greetings = "Hi All";
            var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "Assets Notification Mail" && f.IsActive && !f.IsDeleted);

            var response = new ObjectParameter("Success", typeof(int));
            var requestId = new ObjectParameter("NewAssetRequestIds", typeof(long));
            _dbContext.Proc_AddUpdateUsersAsset(userId, assetD.AssetRequestIds, assetD.AssetIds, assetD.FromDate, assetD.TillDate, assetD.Remarks, "AC", assetD.IsActive, loginUserId, response, requestId);
            Int32.TryParse(response.Value.ToString(), out status);
            assetRequestIds = requestId.Value.ToString();

            if (status == 1 && !string.IsNullOrEmpty(assetD.AssetRequestIds) && assetD.AssetRequestIds != "0")
            {
                var userAssetData = _dbContext.Proc_GetAssetsDetailsByRequestId(assetD.AssetRequestIds).ToList();
                if (emailTemplate != null && userAssetData != null && userAssetData.Count() > 0)
                {
                    var userData = userAssetData.FirstOrDefault();
                    var empName = userData.EmployeeName;
                    var empCode = userData.EmployeeCode;
                    var rmName = userData.ReportingManagerName;
                    var mbNumber = CryptoHelper.Decrypt(userData.MobileNumber);
                    var subject = "Asset Return Summary";
                    var line1 = "Asset has been collected by Admin Team. Please find below the summary.";
                    var recivermailId = ConfigurationManager.AppSettings["AssetCollection"];

                    var userInfoHtml = String.Format("<label>Employee Name: </label><label><b>{0}</b></label><br/><label>Employee Code: </label><label><b>{1}</b></label><br/><label>Reporting Manager: </label><label><b>{2}</b></label><br/><label>Mobile No. : </label><label><b>{3}</b></label><br/>", empName, empCode, rmName, mbNumber);

                    var tableHtml = "<table style = 'border-collapse:collapse; width:100%; border: 1px solid #ddd; padding: 8px;'><thead style = 'padding-top: 12px; padding-bottom: 12px;text-align: left;background-color: #6d77bb;color: #ffffff;'><tr><th style = 'border: 1px solid #ddd; padding: 8px;'><div>Asset</div></th><th style = 'border: 1px solid #ddd; padding: 8px;'><div>Make</div></th><th style = 'border: 1px solid #ddd; padding: 8px;'><div>Model</div></th><th style = 'border: 1px solid #ddd; padding: 8px;'><div>S.No</div></th><th style = 'border: 1px solid #ddd; padding: 8px;'><div>Allocated From</div></th><th style = 'border: 1px solid #ddd; padding: 8px;'><div>Allocated Till</div></th><th style = 'border: 1px solid #ddd; padding: 8px;'><div>De Allocated On</div></th><th style = 'border: 1px solid #ddd; padding: 8px;'><div>De Allocated By</div></th><th style = 'border: 1px solid #ddd; padding: 8px;'><div>Collected On</div></th><th style = 'border: 1px solid #ddd; padding: 8px;'><div>Collected By</div></th></tr></thead><tbody>";
                    var temp = "";
                    foreach (var userAssetInfo in userAssetData)
                    {
                        temp = temp + string.Format("<tr style= 'background-color: #f2f2f2;'><td style = 'border: 1px solid #ddd; padding: 8px;'>{0}</td><td style = 'border: 1px solid #ddd; padding: 8px;'>{1}</td><td style = 'border: 1px solid #ddd; padding: 8px;'>{2}</td><td style = 'border: 1px solid #ddd; padding: 8px;'>{3}</td><td style = 'border: 1px solid #ddd; padding: 8px;'>{4}</td><td style = 'border: 1px solid #ddd; padding: 8px;'>{5}</td><td style = 'border: 1px solid #ddd; padding: 8px;'>{6}</td><td style = 'border: 1px solid #ddd; padding: 8px;'>{7}</td><td style = 'border: 1px solid #ddd; padding: 8px;'>{8}</td><td style = 'border: 1px solid #ddd; padding: 8px;'>{9}</td>", userAssetInfo.Type, userAssetInfo.BrandName, userAssetInfo.Model, userAssetInfo.SerialNo, userAssetInfo.AllocateFrom, userAssetInfo.AllocateTill, userAssetInfo.ModifiedDate, userAssetInfo.ModifiedBy, userAssetInfo.CollectedOn, userAssetInfo.CollectedBy);
                    }

                    tableHtml = userInfoHtml + "<br />" + tableHtml + temp;
                    tableHtml = tableHtml + "</tbody></table>";

                    var body = emailTemplate.Template
                        .Replace("[BGColor]", "#ced3f5")
                        .Replace("[TextColor]", "#000000")
                        .Replace("[Title]", subject)
                        .Replace("[Name]", greetings)
                        .Replace("[Line1]", line1)
                        .Replace("[Data]", tableHtml);
                    EmailHelper.SendEmailWithDefaultParameter(subject, body, true, true, recivermailId, null, null, null);
                }
            }
            return status;
        }

        public List<UserAssetRequest> GetAllUsersAssetsDetail(string actionCode, int loginUserId)
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
            var buildVersion = GlobalServices.GetBuildVersion();

            var activeAssets = _dbContext.Proc_GetAllUsersAssets(actionCode, loginUserId).Select(x => new UserAssetRequest
            {
                AssetRequestId = x.AssetsRequestId,
                AssetId = x.AssetId,
                FromDateText = DateTime.ParseExact(x.AllocateFrom, "dd MMM yyyy", CultureInfo.InvariantCulture).ToString("MM/dd/yyyy", CultureInfo.InvariantCulture),
                FromDate = x.AllocateFrom,
                TillDate = x.AllocateTill,
                EmployeeCode = x.EmployeeCode,
                EmployeeName = x.EmployeeName,
                UserAbrhs = CryptoHelper.Encrypt(x.UserId.ToString()),
                AssetType = x.Type,
                AssetTypeId = x.TypeId,
                Brand = x.BrandName,
                SerialNo = x.SerialNo,
                Model = x.Model,
                AssetCount = x.AssetCount,
                AssignedOn = x.CreatedDate,
                AssignedBy = x.CreatedBy,
                ModifiedBy = x.ModifiedBy,
                ModifiedOn = x.ModifiedDate,
                Remarks = x.Remarks,
                Status = x.Status,
                HasAllocateRights = x.HasAllocateRights.HasValue ? x.HasAllocateRights.Value : false,
                HasViewRights = x.HasViewRights.HasValue ? x.HasViewRights.Value : false,
                HasCollectRights = x.HasCollectRights.HasValue ? x.HasCollectRights.Value : false,
                HasDeleteRights = x.HasDeleteRights.HasValue ? x.HasDeleteRights.Value : false,
                DeAllocationRemarks = x.DeAllocationRemarks,
                ImagePath = string.Format("{0}?v={1}", (!string.IsNullOrEmpty(x.ImagePath) ? (profileImagePath + x.ImagePath) :
                           ((!string.IsNullOrEmpty(x.Gender) ? x.Gender.ToLower() : "") == "female" ? femaleImagePath : maleImagePath)), buildVersion)

            }).ToList();

            //List<UserAssetRequest> listgrpdAssets = new List<UserAssetRequest>();

            //var groupByEmployeeAssets = from s in activeAssets
            //                            group s by s.EmployeeName;
            //List<UserAssetRequest> listActiveAssets = new List<UserAssetRequest>();

            //foreach (var x in groupByEmployeeAssets)
            //{
            //    var employeeName = x.Key;

            //    var lp = activeAssets.FirstOrDefault(t => t.EmployeeName == employeeName && t.AssetType == "Laptop");
            //    var anyAssets = activeAssets.FirstOrDefault(t => t.EmployeeName == employeeName);
            //    UserAssetRequest obj= new UserAssetRequest();
            //    if (lp != null)
            //    {
            //        obj = new UserAssetRequest
            //        {
            //            AssetRequestId = lp.AssetRequestId,
            //            AssetId = lp.AssetId,
            //            FromDateText = lp.FromDateText,
            //            FromDate = lp.FromDate,
            //            TillDate = lp.TillDate,
            //            EmployeeCode = lp.EmployeeCode,
            //            EmployeeName = lp.EmployeeName,
            //            UserAbrhs = lp.UserAbrhs,
            //            AssetType = lp.AssetType,
            //            AssetTypeId = lp.AssetTypeId,
            //            Brand = lp.Brand,
            //            SerialNo = lp.SerialNo,
            //            Model = lp.Model,
            //            IsActive = lp.IsActive,
            //            AssignedOn = lp.AssignedOn,
            //            AssignedBy = lp.AssignedBy,
            //            ModifiedBy = lp.ModifiedBy,
            //            ModifiedOn = lp.ModifiedOn,
            //            Remarks = lp.Remarks
            //        };
            //    }
            //    else
            //    {
            //        obj = new UserAssetRequest
            //        {
            //            AssetRequestId = anyAssets.AssetRequestId,
            //            AssetId = anyAssets.AssetId,
            //            FromDateText = anyAssets.FromDateText,
            //            FromDate = anyAssets.FromDate,
            //            TillDate = anyAssets.TillDate,
            //            EmployeeCode = anyAssets.EmployeeCode,
            //            EmployeeName = anyAssets.EmployeeName,
            //            UserAbrhs = anyAssets.UserAbrhs,
            //            AssetType = anyAssets.AssetType,
            //            AssetTypeId = anyAssets.AssetTypeId,
            //            Brand = anyAssets.Brand,
            //            SerialNo = anyAssets.SerialNo,
            //            Model = anyAssets.Model,
            //            IsActive = anyAssets.IsActive,
            //            AssignedOn = anyAssets.AssignedOn,
            //            AssignedBy = anyAssets.AssignedBy,
            //            ModifiedBy = anyAssets.ModifiedBy,
            //            ModifiedOn = anyAssets.ModifiedOn,
            //            Remarks = anyAssets.Remarks
            //        };
            //    }

            //    List<AssetsSummary> list = x.Select(t => new AssetsSummary() {
            //        AssetRequestId = t.AssetRequestId,
            //        AssetId = t.AssetId,
            //        FromDateText = t.FromDateText,
            //        FromDate = t.FromDate,
            //        TillDate = t.TillDate,
            //        EmployeeCode = t.EmployeeCode,
            //        EmployeeName = t.EmployeeName,
            //        UserAbrhs = t.UserAbrhs,
            //        AssetType = t.AssetType,
            //        AssetTypeId = t.AssetTypeId,
            //        Brand = t.Brand,
            //        SerialNo = t.SerialNo,
            //        Model = t.Model,
            //        IsActive = t.IsActive,
            //        AssignedOn = t.AssignedOn,
            //        AssignedBy = t.AssignedBy,
            //        ModifiedBy = t.ModifiedBy,
            //        ModifiedOn = t.ModifiedOn,
            //        Remarks = t.Remarks
            //    }).ToList();

            //    obj.GroupedAssets = list;

            //    listActiveAssets.Add(obj);
            //}

            return activeAssets ?? new List<UserAssetRequest>();
        }

        public List<UserAssetRequest> GetAssetsByUserAbrhs(string userAbrhs, string actionCode, int loginUserId)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            var activeAssets = _dbContext.Proc_GetAllAssetsByUserId(actionCode, userId, loginUserId).Select(x => new UserAssetRequest
            {
                AssetRequestId = x.AssetsRequestId,
                AssetId = x.AssetId,
                FromDateText = DateTime.ParseExact(x.AllocateFrom, "dd MMM yyyy", CultureInfo.InvariantCulture).ToString("MM/dd/yyyy", CultureInfo.InvariantCulture),
                FromDate = x.AllocateFrom,
                TillDate = x.AllocateTill,
                EmployeeCode = x.EmployeeCode,
                EmployeeName = x.EmployeeName,
                UserAbrhs = CryptoHelper.Encrypt(x.UserId.ToString()),
                AssetType = x.Type,
                AssetTypeId = x.TypeId,
                Brand = x.BrandName,
                SerialNo = x.SerialNo,
                Model = x.Model,
                IsActive = x.IsActive,
                AssignedOn = x.CreatedDate,
                AssignedBy = x.CreatedBy,
                ModifiedBy = x.ModifiedBy,
                ModifiedOn = x.ModifiedDate,
                Remarks = x.Remarks,
                Status = x.Status,
                DeAllocationRemarks = x.DeAllocationRemarks,
                CollectedBy = x.CollectedBy,
                CollectedOn = x.CollectedOn,
                HasAllocateRights = x.HasAllocateRights.HasValue ? x.HasAllocateRights.Value : false,
                HasViewRights = x.HasViewRights.HasValue ? x.HasViewRights.Value : false,
                HasCollectRights = x.HasCollectRights.HasValue ? x.HasCollectRights.Value : false,
                HasDeleteRights = x.HasDeleteRights.HasValue ? x.HasDeleteRights.Value : false,
            }).ToList();

            return activeAssets ?? new List<UserAssetRequest>();
        }

        public List<UserAssetRequest> GetUsersActiveAssets(string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            var activeAssets = _dbContext.Proc_GetUsersActiveAssets(userId).Select(x => new UserAssetRequest
            {
                FromDate = x.AllocateFrom,
                TillDate = x.AllocateTill,
                AssetType = x.Type,
                Brand = x.BrandName,
                SerialNo = x.SerialNo,
                Model = x.Model,
                AssignedOn = x.CreatedDate,
                AssignedBy = x.CreatedBy,
                Remarks = x.Remarks,
                Status = x.Status,
                DeAllocationRemarks = x.DeAllocationRemarks,
            }).ToList();

            return activeAssets ?? new List<UserAssetRequest>();
        }

        

        public List<AssetsBO> GetAllUnAllocatedAssets(string assetTypeIds)
        {
            String[] assetTypeId = null;
            assetTypeId = assetTypeIds.Split(',');

            var data = _dbContext.Proc_GetAllAssetsDetail().ToList();
            var freeAssets = from t in data where (t.IsFree == true && t.IsLost == false && t.IsActive == true && assetTypeId.Contains(t.TypeId.ToString())) select t;
            List<AssetsBO> result = new List<AssetsBO>();
            result = freeAssets.Select(x => new AssetsBO
            {
                AssetId = x.AssetId,
                // Assets = string.Format("Type: {0}, Make: {1}, Model: {2}, S.No. : {3}", x.Type, x.BrandName, x.Model, x.SerialNo)
                Assets = x.BrandName + " - " + x.Model + " - (S.No.: " + x.SerialNo + ")"
            }).ToList();
            return result ?? new List<AssetsBO>();
        }

        public List<UserAssetDetail> GetAllUnAllocatedAssetsSerialNo()
        {
            var data = _dbContext.Proc_GetAllAssetsDetail().ToList();
            var freeAssets = from t in data where (t.IsFree == true && t.IsLost == false && t.IsActive == true) select t;
            List<UserAssetDetail> result = new List<UserAssetDetail>();
            result = freeAssets.Select(x => new UserAssetDetail
            {
                AssetId = x.AssetId,
                SerialNo = x.SerialNo
            }).ToList();
            return result ?? new List<UserAssetDetail>();
        }

        public List<UserAssetRequest> GetAllEmployeesForAssetAllocation()
        {
            var users = _dbContext.vwAllUsers.Select(t => new UserAssetRequest()
            {
                UserId = t.UserId,
                EmployeeCode = t.EmployeeId
            }).ToList();
            return users ?? new List<UserAssetRequest>();
        }

        public int CheckUsersAssetsDetail(int userId, long assetId)
        {
            var assetInfo = _dbContext.UsersAssetDetails.FirstOrDefault(t => t.UserId == userId && t.AssetId == assetId && (t.IsActive || (!t.IsActive && !t.IsCollected)));
            if (assetInfo != null)
            {
                return 1;
            }
            return 0;
        }

        public int AllocateExcelData(List<UserAssetRequest> userDataList, string userAbrhs)
        {
            int status = 0;
            string assetRequestIds = "";
            int loginUserId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out loginUserId);
            var response = new ObjectParameter("Success", typeof(int));
            var requestId = new ObjectParameter("NewAssetRequestIds", typeof(long));
            var xmlString = new XElement("Root",
                           from pxs in userDataList
                           select new XElement("Row",
                           new XAttribute("UserId", pxs.UserId),
                            new XAttribute("AssetId", pxs.AssetId),
                            new XAttribute("FromDate", pxs.FromDate),
                            new XAttribute("Remarks", pxs.Remarks)
                            ));

            _dbContext.Proc_BulkAllocateAssets(loginUserId, xmlString.ToString(), response, requestId);
            Int32.TryParse(response.Value.ToString(), out status);
            assetRequestIds = requestId.Value.ToString();

            var greetings = "Hi All";
            var subject = "";
            var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "Assets Notification Mail" && f.IsActive && !f.IsDeleted);
            if (status == 1 && !string.IsNullOrEmpty(assetRequestIds) && assetRequestIds != "0")
            {
                var userAssetData = _dbContext.Proc_GetAssetsDetailsByRequestId(assetRequestIds).ToList();
                var data = userAssetData.Select(t => new Proc_GetAssetsDetailsByRequestId_Result
                {
                   
                    AssetsRequestId = t.AssetsRequestId,
                    UserId = t.UserId,
                    AllocateTill = t.AllocateTill,
                    AssetId = t.AssetId,
                    TypeId = t.TypeId,
                    BrandId = t.BrandId,
                    Description = t.Description,
                    ModifiedBy = t.ModifiedBy,
                    ModifiedDate = t.ModifiedDate,
                    DeAllocationRemarks = t.DeAllocationRemarks,
                    ImagePath = t.ImagePath,
                    CollectedOn = t.CollectedOn,
                    CollectedBy = t.CreatedBy,
                    EmployeeName = t.EmployeeName,
                    MobileNumber = CryptoHelper.Decrypt(t.MobileNumber),
                    ReportingManagerName = t.ReportingManagerName,
                    AllocateFrom = t.AllocateFrom,
                    Type = t.Type,
                    BrandName = t.BrandName,
                    Model = t.Model,
                    SerialNo = t.SerialNo,
                    Remarks = t.Remarks,
                    CreatedDate = t.CreatedDate,
                    CreatedBy = t.CreatedBy
                }).ToList();

                var assetDataTbl = data.ToDataTable();
                if (emailTemplate != null && data.Count() > 0)
                {

                    var line1 = "Asset has been allocated successfully. Please find below the summary.";
                    subject = "Asset Allocation Summary";
                    var recivermailId = ConfigurationManager.AppSettings["AssetAllocation"];

                    var columns = new Dictionary<string, string>();
                    var body = string.Empty;

                    assetDataTbl.Columns.Remove("AssetsRequestId");
                    assetDataTbl.Columns.Remove("UserId");
                    assetDataTbl.Columns.Remove("AllocateTill");
                    assetDataTbl.Columns.Remove("AssetId");
                    assetDataTbl.Columns.Remove("TypeId");
                    assetDataTbl.Columns.Remove("BrandId");
                    assetDataTbl.Columns.Remove("Description");
                    assetDataTbl.Columns.Remove("ModifiedBy");
                    assetDataTbl.Columns.Remove("ModifiedDate");
                    assetDataTbl.Columns.Remove("DeAllocationRemarks");
                    assetDataTbl.Columns.Remove("ImagePath");
                    assetDataTbl.Columns.Remove("CollectedOn");
                    assetDataTbl.Columns.Remove("CollectedBy");


                    columns.Add("EmployeeName", "Employee Name");
                    columns.Add("MobileNumber", "Mobile No.");
                    columns.Add("ReportingManagerName", "Reporting Manager");
                    columns.Add("AllocateFrom", "Allocate From");
                    columns.Add("Type", "Type");
                    columns.Add("BrandName", "Make");
                    columns.Add("Model", "Model");
                    columns.Add("SerialNo", "Serial No");
                    columns.Add("Remarks", "Remarks");
                    columns.Add("CreatedDate", "Allocated On");
                    columns.Add("CreatedBy", "Allocated By");

                    var multipleTable = new Dictionary<string, DataTable>();
                    multipleTable.Add("Asset Allocation Summary", assetDataTbl);

                    //Prepare Attachment

                    var subjectForReport = "Asset Allocation Summary";
                    var fileName = "Asset Allocation Summary";
                    var ms = multipleTable.ToExcelWithStyle(columns, fileName.Replace("_", " "), "Report", true, false);
                    var attachmentFile = new System.Net.Mail.Attachment(ms, fileName.Replace("_", " ") + ".xlsx", MediaTypes.Excel);

                    var htmlResult = multipleTable.ToHtmlTableWithStyle(columns, false);

                    body = emailTemplate.Template
                   .Replace("[BGColor]", "#caecca")
                   .Replace("[TextColor]", "#000000")
                   .Replace("[Title]", subject)
                   .Replace("[Name]", greetings)
                   .Replace("[Line1]", line1)
                   .Replace("[Data]", htmlResult);
                    EmailHelper.SendEmailWithDefaultParameter(subject, body, true, true, recivermailId, null, null, null);

                }
            }
            return status;
        }

        public List<BaseDropDown> GetAllAssetTypes()
        {
            var data = _dbContext.AssetTypes.Where(t => t.IsActive == true).Select(a =>
                         new BaseDropDown
                         {
                             Text = a.Type,
                             Value = a.TypeId,
                             Selected = false
                         }).OrderBy(t => t.Text).ToList();
            return data;
        }

        #region FilePath
        public string GetSampleDocumentUrl(string sampleType)
        {
            var filePath = "";
            var reqUrl = HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + "/";
#if !DEBUG
            reqUrl = (new UriBuilder(reqUrl) { Port = -1 }).ToString();
#endif
            var baseFilePath = reqUrl + ConfigurationManager.AppSettings["Assets"];

            if (sampleType == "ALLOCATE")
            {
                filePath = baseFilePath + "UserAssetAllocation.xlsx";
            }
            else if (sampleType == "ASSET")
            {
                filePath = baseFilePath + "AssetInventory.xlsx";
            }
            return filePath;
        }
        #endregion

        #endregion

    }
}
