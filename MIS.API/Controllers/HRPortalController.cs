using MIS.BO;
using MIS.Services.Contracts;
using System.Configuration;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace MIS.API.Controllers
{
    public class HRPortalController : BaseApiController
    {
        private readonly IHRPortalServices _hRPortalServices;


        public HRPortalController(IHRPortalServices hRPortalServices)
        {
            _hRPortalServices = hRPortalServices;
        }

        #region Referral

        [HttpPost]
        public HttpResponseMessage GetReferral()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.GetReferral());
        }

        [HttpPost]
        public HttpResponseMessage AddReferral(ReferralBO data)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.AddReferral(data));
        }

        [HttpPost]
        public HttpResponseMessage GetAllReferral()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.GetAllReferral());
        }

        [HttpPost]
        public HttpResponseMessage AddRefereeByUser(int referralId, string refereeName, string relation, string resume, string base64FormData, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.AddRefereeByUser(referralId, refereeName, relation, resume, base64FormData, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetAllRequestedReferral(int referralId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.GetAllRequestedReferral(referralId));
        }

        [HttpPost]
        public HttpResponseMessage FetchAllRefereeDetails(int referralDetailId, int referredById)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.FetchAllRefereeDetails(referralDetailId, referredById));
        }

        [HttpPost]
        public HttpResponseMessage ChangeReferralStatus(int referralId, int status, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.ChangeReferralStatus(referralId, status, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage ViewReferralDetails(int referralId, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.ViewReferralDetails(referralId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage UpdateReferrals(ReferralBO refer)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.UpdateReferrals(refer));
        }

        [HttpPost]
        public HttpResponseMessage ForwardReferrals(int detailId, string resume, int referredById, string empIds, string message, string appLinkUrl, string userAbrhs)
        {
            //var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.ForwardReferrals(detailId, resume, referredById, empIds, message, appLinkUrl, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage ForwardAllReferrals(int referralId, string empIds, string message, string appLinkUrl, string userAbrhs)
        {
            //var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.ForwardAllReferrals(referralId, empIds, message, appLinkUrl, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage SendReminderForReferral(int reviewId)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.SendReminderForReferral(reviewId, globalData.LoginUserId));
        }

        [HttpPost]
        public HttpResponseMessage ViewResume(int detailId, int referredById)
        {
            var basePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["ReferralDocumentPath"];
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.ViewResume(basePath, detailId, referredById));
        }

        #endregion

        #region Training

        [HttpPost]
        public HttpResponseMessage AddTrainings(TrainingBO data)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            data.UserAbrhs = globalData.UserAbrhs;
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.AddTrainings(data));
        }
        [HttpPost]
        public HttpResponseMessage GetAllTrainings()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.GetAllTrainings());
        }
        [HttpPost]
        public HttpResponseMessage GetTrainings()
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.GetTrainings(globalData.UserAbrhs));
        }
        [HttpPost]
        public HttpResponseMessage ViewTrainingDetails(int trainingId)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.ViewTrainingDetails(trainingId, globalData.UserAbrhs));
        }
        public HttpResponseMessage UpdateTrainingDetails(TrainingBO data)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            data.UserAbrhs = globalData.UserAbrhs;
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.UpdateTrainingDetails(data));
        }
        [HttpPost]
        public HttpResponseMessage ChangeTrainingStatus(int trainingId, int status)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.ChangeTrainingStatus(trainingId, status, globalData.UserAbrhs));
        }
        [HttpPost]
        public HttpResponseMessage ApplyForTrainings(int trainingId)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.ApplyForTrainings(trainingId, globalData.UserAbrhs));
        }
        [HttpPost]
        public HttpResponseMessage ViewAppliedTrainingDetails(int trainingId)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.ViewAppliedTrainingDetails(trainingId, globalData.UserAbrhs));
        }
        [HttpPost]
        public HttpResponseMessage TakeActionOnTrainingRequest(int trainingDetailId, int statusId, string remarks)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.TakeActionOnTrainingRequest(trainingDetailId, statusId, remarks, globalData.UserAbrhs));
        }
        [HttpPost]
        public HttpResponseMessage GetAllNomineesDetails(int trainingId)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.GetAllNomineesDetails(trainingId, globalData.UserAbrhs));
        }
        [HttpPost]
        public HttpResponseMessage GetPendingTrainingRequests()
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.GetPendingTrainingRequests(globalData.UserAbrhs));
        }
        [HttpPost]
        public HttpResponseMessage GetReviwedTrainingRequests()
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.GetReviwedTrainingRequests(globalData.UserAbrhs));
        }
        [HttpPost]
        public HttpResponseMessage ViewDocument(int trainingId)
        {
            var basePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["TrainingDocumentPath"];
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.ViewDocument(basePath, trainingId));
        }
        #endregion

        #region News

        [HttpPost]
        public HttpResponseMessage AddNews(NewsBO news)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.AddNews(news));
        }

        [HttpPost]
        public HttpResponseMessage GetAllNews(string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.GetAllNews(userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage UpdateNews(NewsBO news)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.UpdateNews(news));
        }

        [HttpPost]
        public HttpResponseMessage ChangesNewsStatus(int newsId, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.ChangesNewsStatus(newsId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage DeleteNews(int newsId, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.DeleteNews(newsId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetNews(int newsId, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.GetNews(newsId, userAbrhs));
        }

        #endregion

        #region pending requests
        [HttpPost]
        public HttpResponseMessage GetAllProfilePendingRequests(string status)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.GetAllProfilePendingRequests(status));
        }
        [HttpPost]
        public HttpResponseMessage VerifyUserProfile(int requestId, int status, string reason)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.VerifyUserProfile(requestId, status, reason, globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage VerifyBulkUserProfile(string requestIds)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.VerifyBulkUserProfile(requestIds, globalData.UserAbrhs));
        }
        #endregion

        #region Trainig & Probation Feedback Mail

        [HttpPost]
        public HttpResponseMessage GetEmployeeListForFeedBackMail(string emailFromDate, string emailTillDate)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.GetEmployeeListForFeedBackMail(emailFromDate, emailTillDate));
        }

        [HttpPost]
        public HttpResponseMessage SendProbationAndTrainingCompletionEmail(string emailFromDate, string emailTillDate, string fillByDate, string emailIds)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.SendProbationAndTrainingCompletionEmail(emailFromDate, emailTillDate, fillByDate, emailIds));
        }

        #endregion

        #region Medical Insurance

        [HttpGet]
        public HttpResponseMessage GetEmployeesHealthInsuranceDetails()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.GetEmployeesHealthInsuranceDetails());
        }

        [HttpPost]
        public HttpResponseMessage UploadHealthInsuranceCard(EmployeeHealthInsurance employeeHealthInsurance)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.UploadHealthInsuranceCard(employeeHealthInsurance));
        }

        #endregion
    }
}