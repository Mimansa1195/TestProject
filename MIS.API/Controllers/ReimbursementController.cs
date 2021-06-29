using MIS.BO;
using MIS.Services.Contracts;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace MIS.API.Controllers
{
    public class ReimbursementController : BaseApiController
    {
        private readonly IReimbursementServices _reimbursementServices;

        public ReimbursementController(IReimbursementServices reimbursementServices)
        {
            _reimbursementServices = reimbursementServices;
        }

        [HttpPost]
        public HttpResponseMessage GetReimbursementType()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _reimbursementServices.GetReimbursementType());
        }

        [HttpPost]
        public HttpResponseMessage GetReimbursementCategory(int typeId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _reimbursementServices.GetReimbursementCategory(typeId));
        }

        [HttpPost]
        public HttpResponseMessage DraftReimbursementDetails(AddReimbursementBO obj)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _reimbursementServices.DraftReimbursementDetails(obj, globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetReimbursementMonthYearToAddNewRequest(int typeId)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _reimbursementServices.GetReimbursementMonthYearToAddNewRequest(typeId, globalData.LoginUserId));
        }

        [HttpPost]
        public HttpResponseMessage GetReimbursementListToView(int reimursementTypeId, int year)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _reimbursementServices.GetReimbursementListToView(reimursementTypeId, year, globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetReimbursementFormData(string reimbursementRequestAbrhs)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _reimbursementServices.GetReimbursementFormData(reimbursementRequestAbrhs, globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage CancelReimbursementRequest(string reimbursementRequestAbrhs)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _reimbursementServices.CancelReimbursementRequest(reimbursementRequestAbrhs, globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage SubmitReimbursementForm(AddReimbursementBO obj)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _reimbursementServices.SubmitReimbursementForm(obj, globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetReimbursementListToReview(int reimursementTypeId, int year, string userAbrhs)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _reimbursementServices.GetReimbursementListToReview(reimursementTypeId, year, globalData.LoginUserId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage TakeActionOnReimbursementRequest(ReimbursementActionData obj)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _reimbursementServices.TakeActionOnReimbursementRequest(obj, globalData.LoginUserId));
        }

        [HttpPost]
        public HttpResponseMessage GetReimbursementMonthYearToViewAndApprove()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _reimbursementServices.GetReimbursementMonthYearToViewAndApprove());
        }

        [HttpPost]
        public HttpResponseMessage GetReimbusrementStatusHistory(int reimbursementRequestId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _reimbursementServices.GetReimbusrementStatusHistory(reimbursementRequestId));
        }

        [HttpPost]
        public HttpResponseMessage GetAllEmployeesForReimbursement()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _reimbursementServices.GetAllEmployeesForReimbursement());
        }
    }
}
