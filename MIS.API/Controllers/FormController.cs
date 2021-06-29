using MIS.BO;
using MIS.Services.Contracts;
using System;
using System.Configuration;
using System.IO;
using System.IO.Compression;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web;
using System.Web.Http;
using System.Xml.Linq;

namespace MIS.API.Controllers
{
    public class FormController : BaseApiController
    {
        private readonly IFormServices _formServices;

        public FormController(IFormServices formServices)
        {
            _formServices = formServices;
        }

        [HttpPost]
        public HttpResponseMessage GetAllForms()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _formServices.GetAllForms());
        }

        [HttpPost]
        public HttpResponseMessage GetAllActiveForms(string departmentAbrhs)
        {
            var basePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["DocumentUploadPath"];
            return Request.CreateResponse(HttpStatusCode.OK, _formServices.GetAllActiveForms(basePath, departmentAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage ChangeFormStatus(int formId, int status, string userAbrhs)//status = 1:activate, 2:deactivate, 3:delete
        {
            return Request.CreateResponse(HttpStatusCode.OK, _formServices.ChangeFormStatus(formId, status, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage AddForm(string formDepatmentAbrhs, string formTitle, string formName, string base64FormData, string userAbrhs)
        {
            var basePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["DocumentUploadPath"] + formName;
            return Request.CreateResponse(HttpStatusCode.OK, _formServices.AddForm(formDepatmentAbrhs, formTitle, formName, base64FormData, userAbrhs, basePath));
        }

        [HttpPost]
        public HttpResponseMessage FetchFormInformation(int formId)
        {
            var basePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["DocumentUploadPath"];
            return Request.CreateResponse(HttpStatusCode.OK, _formServices.FetchFormInformation(basePath, formId));
        }

        #region Upload and download employee form

        [HttpGet]
        public HttpResponseMessage GetAllMyForms()
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _formServices.GetAllMyForms(globalData.LoginUserId));
        }

        [HttpPost]
        public HttpResponseMessage UploadMyForm(int formId, string formName, string base64FormData)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _formServices.UploadUserForm(formId, globalData.LoginUserId, globalData.UserAbrhs, formName, base64FormData));
        }

        [HttpPost]
        public HttpResponseMessage ChangeMyFormStatus(string userFormAbrhs, int status)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _formServices.ChangeUsersFormStatus(userFormAbrhs, globalData.LoginUserId, globalData.LoginUserId, status));
        }

        [HttpPost]
        public HttpResponseMessage GetAllUserForms(int formId)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _formServices.GetAllUserForms(globalData.LoginUserId, formId));
        }

        [HttpPost]
        public HttpResponseMessage FetchUserForm(string userFormAbrhs)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _formServices.FetchUserForm(globalData.LoginUserId, userFormAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage FetchAllUserForms(int formId)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            var zippedFilePath = _formServices.FetchAllUserForms(globalData.LoginUserId, formId);
            //var path = @"C:\Temp\file.zip";
            
            ////////////
            var result = new HttpResponseMessage(HttpStatusCode.OK);
            var stream = new FileStream(zippedFilePath, FileMode.Open);
            result.Content = new StreamContent(stream);
            result.Content.Headers.ContentType = new MediaTypeHeaderValue("application/zip"); //"application/octet-stream"
            result.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment")
            {
                FileName = "file.zip"
            };
            return result;
        }      

        #endregion

        [HttpPost]
        public HttpResponseMessage FetchOrganizationStructurePdf()
        {
            var basePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["DocumentUploadPath"];
            return Request.CreateResponse(HttpStatusCode.OK, _formServices.FetchOrganizationStructurePdf(basePath));
        }

    }
}