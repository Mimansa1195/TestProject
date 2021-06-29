using MIS.BO;
using MIS.Services.Contracts;
using System;
using System.Globalization;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace MIS.API.Controllers
{
    public class AssetController : BaseApiController
    {
        private readonly IAssetServices _assetServices;

        public AssetController(IAssetServices assetServices)
        {
            _assetServices = assetServices;
        }

        [HttpPost]
        public HttpResponseMessage GetUserCommentForDongleAllocation(string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _assetServices.GetUserCommentForDongleAllocation(userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetConflictStatusOfDongleAllocationPeriod(string dongleIssueFromDate, string dongleReturnDueDate, string userAbrhs)
        {
            DateTime issueFromDate = DateTime.ParseExact(dongleIssueFromDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            DateTime returnDueDate = DateTime.ParseExact(dongleReturnDueDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);

            return Request.CreateResponse(HttpStatusCode.OK, _assetServices.GetConflictStatusOfDongleAllocationPeriod(issueFromDate, returnDueDate, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetAssetDetailsForReportingManager(int statusId, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _assetServices.GetAssetDetailsForReportingManager(statusId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetAssetDetailsForITDepartment(int statusId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _assetServices.GetAssetDetailsForITDepartment(statusId));
        }

        [HttpPost]
        public HttpResponseMessage GetAssetDetailOnBasisOfAssetTag(string assetTag)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _assetServices.GetAssetDetailOnBasisOfAssetTag(assetTag));
        }

        [HttpPost]
        public HttpResponseMessage GetAvailableAssetTag()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _assetServices.GetAvailableAssetTag());
        }

        [HttpPost]
        public HttpResponseMessage GetAssetDetailOnBasisOfRequestId(long requestId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _assetServices.GetAssetDetailOnBasisOfRequestId(requestId));
        }

        [HttpPost]
        public HttpResponseMessage GetAllAssetRequest(string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _assetServices.GetAllAssetRequest(userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetAllAssetCountData()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _assetServices.GetAllAssetCountData());
        }

        [HttpPost]
        public HttpResponseMessage GetAssetCountDataByManagerId(string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _assetServices.GetAssetCountDataByManagerId(userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage CreateAssetRequest(string reason, string issueDate, string returnDate, string userAbrhs)
        {
            DateTime issueDateNew = DateTime.ParseExact(issueDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            DateTime returnDateNew = DateTime.ParseExact(returnDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            return Request.CreateResponse(HttpStatusCode.OK, _assetServices.CreateAssetRequest(reason, issueDateNew, returnDateNew, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage TakeActionOnAssetRequest(int requestId, int statusId, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _assetServices.TakeActionOnAssetRequest(requestId, statusId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage AllocateAsset(long requestId, long assetDetailId, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _assetServices.AllocateAsset(requestId, assetDetailId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage ReturnAsset(long transactionId, string returnDate, string userAbrhs)
        {
            DateTime returnDateNew = DateTime.ParseExact(returnDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            return Request.CreateResponse(HttpStatusCode.OK, _assetServices.ReturnAsset(transactionId, returnDateNew, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage ReturnAssetByUser(long requestId, string returnDate, string userAbrhs)
        {
            DateTime returnDateNew = DateTime.ParseExact(returnDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            return Request.CreateResponse(HttpStatusCode.OK, _assetServices.ReturnAssetByUser(requestId, returnDateNew, userAbrhs));
        }

        //[HttpPost]
        //public HttpResponseMessage AssignDongle(string userAbrhs, int requestId, string serialNumber, string simNumber, string otherDetails, string comments)
        //{
        //    return Request.CreateResponse(HttpStatusCode.OK, _assetServices.AssignDongle(userAbrhs, requestId, serialNumber, simNumber, otherDetails, comments));
        //}

        [HttpPost]
        public HttpResponseMessage GetAllAssets()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _assetServices.GetAllAssets());
        }

        [HttpPost]
        public HttpResponseMessage AddAssetDetails(AssetDetailBO assetDetails)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _assetServices.AddAssetDetails(assetDetails));
        }

        [HttpPost]
        public HttpResponseMessage DeleteAssetDetails(long assetDetailId, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _assetServices.DeleteAssetDetails(assetDetailId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetAssetDetailsById(long assetDetailId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _assetServices.GetAssetDetailsById(assetDetailId));
        }

        [HttpPost]
        public HttpResponseMessage UpdateAssetDetails(AssetDetailBO assetDetails)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _assetServices.UpdateAssetDetails(assetDetails));
        }


        //[HttpPost]
        //public HttpResponseMessage GetAssetRequestByUserID(string userAbrhs, int? statusId)
        //{
        //        return Request.CreateResponse(HttpStatusCode.OK, _assetServices.GetAssetRequestByUserID(userAbrhs, statusId));
        //}

        //[HttpPost]
        //public HttpResponseMessage GetAssetRequestByApproverId(string userAbrhs, int statusId)
        //{
        //        return Request.CreateResponse(HttpStatusCode.OK, _assetServices.GetAssetRequestByApproverId(userAbrhs, statusId));
        //}

        //[HttpPost]
        //public HttpResponseMessage GetAssetDetailByRequestId(int requestId)
        //{
        //        return Request.CreateResponse(HttpStatusCode.OK, _assetServices.GetAssetDetailByRequestId(requestId));
        //}
        #region New Implementation

            
        [HttpPost]
        public HttpResponseMessage GetAllAssetTypes()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _assetServices.GetAllAssetTypes());
        }
        [HttpPost]
        public HttpResponseMessage AddUpdateAssetsDetail(AssetDetailBO assetDetails)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _assetServices.AddUpdateAssetsDetail(assetDetails, globalData.LoginUserId));
        }

        [HttpPost]
        public HttpResponseMessage GetAssetsBrand()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _assetServices.GetAssetsBrand());
        }

        [HttpPost]
        public HttpResponseMessage GetAllAssetsDetail()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _assetServices.GetAllAssetsDetail());
        }

        [HttpPost]
        public HttpResponseMessage AddUpdateUsersAssetsDetail(UserAssetDetail assetD)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();

            return Request.CreateResponse(HttpStatusCode.OK, _assetServices.AddUpdateUsersAssetsDetail(assetD, globalData.LoginUserId));
        }

        [HttpPost]
        public HttpResponseMessage GetAllUsersAssetsDetail(string actionCode)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _assetServices.GetAllUsersAssetsDetail(actionCode, globalData.LoginUserId));
        }

        [HttpPost]
        public HttpResponseMessage GetUsersActiveAssets(string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _assetServices.GetUsersActiveAssets(userAbrhs));
        }

        //[HttpPost]
        //public HttpResponseMessage GetAllUsersInActiveAssetsDetail()
        //{
        //    return Request.CreateResponse(HttpStatusCode.OK, _assetServices.GetAllUsersInActiveAssetsDetail());
        //}

        [HttpPost]
        public HttpResponseMessage GetAllUnAllocatedAssets(string assetTypeIds)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _assetServices.GetAllUnAllocatedAssets(assetTypeIds));
        }

        [HttpPost]
        public HttpResponseMessage GetAssetsByUserAbrhs(string userAbrhs, string actionCode)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _assetServices.GetAssetsByUserAbrhs(userAbrhs, actionCode, globalData.LoginUserId));
        }

        [HttpPost]
        public HttpResponseMessage GetSampleDocumentUrl(string sampleType)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _assetServices.GetSampleDocumentUrl(sampleType));
        }


        //[HttpPost]
        //public HttpResponseMessage GetPendingForDeAllocationAssetsRequest()
        //{
        //    return Request.CreateResponse(HttpStatusCode.OK, _assetServices.GetPendingForDeAllocationAssetsRequest());
        //}

        #endregion
    }
}