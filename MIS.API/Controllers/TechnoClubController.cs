using MIS.BO;
using MIS.Services.Contracts;
using System.Configuration;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace MIS.API.Controllers
{
    public class TechnoClubController : BaseApiController
    {
        private readonly ITechnoClubServices _technoClubServices;


        public TechnoClubController(ITechnoClubServices technoClubServices)
        {
            _technoClubServices = technoClubServices;
        }

        [HttpPost]
        public HttpResponseMessage GetGSOCProjects()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _technoClubServices.GetGSOCProjects());
        }
        [HttpPost]
        //public HttpResponseMessage UploadMyForm(int formId, string formName, string base64FormData)
        //{
        //    var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
        //    return Request.CreateResponse(HttpStatusCode.OK, _formServices.UploadUserForm(formId, globalData.LoginUserId, globalData.UserAbrhs, formName, base64FormData));
        //}
        public HttpResponseMessage SubscribeForGSOCProject(int projectId, string title, string fileName, string base64FormData)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _technoClubServices.SubscribeForGSOCProject(projectId, title, fileName, base64FormData, globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetUserWiseSubscribedProjects()
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _technoClubServices.GetUserWiseSubscribedProjects(globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage ViewProjectPdf(string fileName)
        {
            var basePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["TechnoClubUploadPath"];
            return Request.CreateResponse(HttpStatusCode.OK, _technoClubServices.ViewProjectPdf(basePath, fileName));
        }

        [HttpPost]
        public HttpResponseMessage ViewUploadedDocInPopUp(string fileName)
        {
            var basePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["TechnoClubSubscriberUploadPath"];
            return Request.CreateResponse(HttpStatusCode.OK, _technoClubServices.ViewProjectPdf(basePath, fileName));
        }
        [HttpPost]
        public HttpResponseMessage GetProjectDetails(int projectId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _technoClubServices.GetProjectDetails(projectId));
        }
        [HttpPost]
        public HttpResponseMessage FetchUploadedDocument(string filePath)
        {
            var basePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["TechnoClubSubscriberUploadPath"];
            return Request.CreateResponse(HttpStatusCode.OK, _technoClubServices.FetchUploadedDocument(filePath, basePath));
        }
        [HttpPost]
        public HttpResponseMessage FetchSampleDocument(string filePath)
        {
            var basePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["TechnoClubSamplePath"];
            return Request.CreateResponse(HttpStatusCode.OK, _technoClubServices.FetchUploadedDocument(filePath, basePath));
        }
        
        [HttpPost]
        public HttpResponseMessage ChangeSubscriptionStatus(int gsocSubscriptionId)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _technoClubServices.ChangeSubscriptionStatus(gsocSubscriptionId, globalData.UserAbrhs));
        }
    }
}