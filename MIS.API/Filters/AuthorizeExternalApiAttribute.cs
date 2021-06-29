using MIS.BO;
using MIS.Services.Contracts;
using System;
using System.Configuration;
using System.Diagnostics.Contracts;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Controllers;
using System.Web.Http.Filters;

namespace MIS.API.Filters
{
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Method, Inherited = true, AllowMultiple = true)]
    public class AuthorizeExternalApiAttribute : AuthorizeAttribute, IAuthorizationFilter //ActionFilterAttribute
    {
        private const string Token = "Token";
        private const string WWWAuthenticateHeader = "WWW-Authenticate";


        //public override void OnActionExecuting(HttpActionContext actionContext)
        public override void OnAuthorization(HttpActionContext actionContext)
        {
            if (SkipAuthorization(actionContext)) return;

            if (actionContext.Request.Headers.Contains(Token))
            {
                var authResponse = Authorize(actionContext);
                if (authResponse.IsSuccessful)
                    return;
                else
                    HandleUnauthorizedRequest(actionContext, authResponse);
            }
            else
            {
                HandleUnauthorizedRequest(actionContext);
            }
        }

        private static void HandleUnauthorizedRequest(HttpActionContext actionContext, ResponseBO<string> authResponse = null)
        {
            var dnsHost = actionContext.Request.RequestUri.DnsSafeHost;
            var challengeMessage = new HttpResponseMessage();
            if (authResponse == null)
                challengeMessage = actionContext.Request.CreateResponse(HttpStatusCode.Unauthorized);
            else
                challengeMessage = actionContext.Request.CreateResponse(authResponse.StatusCode, authResponse);

            //return new HttpResponseMessage(HttpStatusCode.Created)
            //challengeMessage.Content = new ObjectContent<object>(authResponse, new JsonMediaTypeFormatter { UseDataContractJsonSerializer = true });
            //challengeMessage.Content = new ObjectContent<ResponseBO<string>>(authResponse, new JsonMediaTypeFormatter { UseDataContractJsonSerializer = true });
            //challengeMessage.Content = new ObjectContent<T>(T, myFormatter, "application/some-format");

            challengeMessage.Headers.Add(WWWAuthenticateHeader, string.Format("Basic realm=\"{0}\"", dnsHost));

            //throw new HttpResponseException(challengeMessage);
            actionContext.Response = challengeMessage;
            return;
        }

        private ResponseBO<string> Authorize(HttpActionContext actionContext)
        {
            var response = new ResponseBO<string>() { IsSuccessful = false, Status = ResponseStatus.Error, StatusCode = HttpStatusCode.Unauthorized, Message = ResponseMessage.Unauthorized };
            try
            {
                var token = actionContext.Request.Headers.GetValues(Token).FirstOrDefault();
                var tokenExpiry = Convert.ToInt64(ConfigurationManager.AppSettings["ExternalApiAuthTokenExpiry"]);

                string controllerName = actionContext.ControllerContext.ControllerDescriptor.ControllerName;
                string actionName = actionContext.ActionDescriptor.ActionName;
                string verb = Convert.ToString(actionContext.Request.Method);

                if (string.IsNullOrEmpty(token))
                    return new ResponseBO<string>() { IsSuccessful = false, Status = ResponseStatus.Error, StatusCode = HttpStatusCode.Unauthorized, Message = ResponseMessage.Unauthorized };

                //Check API Authorization
                var provider = actionContext.ControllerContext.Configuration.DependencyResolver.GetService(typeof(ITokenServices)) as ITokenServices;

                var isAuthorized = provider.ValidateApi(token, tokenExpiry, controllerName, actionName, verb);
                if (isAuthorized)
                {
                    response.IsSuccessful = true;
                    response.Status = ResponseStatus.Success;
                    response.StatusCode = HttpStatusCode.OK;
                    response.Message = ResponseMessage.Success;
                }
                else
                {
                    response.StatusCode = HttpStatusCode.Forbidden;
                    response.Message = ResponseMessage.Forbidden;
                }
            }
            catch (Exception ex)
            {
                response.StatusCode = HttpStatusCode.InternalServerError;
                response.Message = (ex.InnerException != null && !string.IsNullOrEmpty(ex.InnerException.Message)) ? ex.InnerException.Message : ex.Message;
            }

            return response;
        }

        private static bool SkipAuthorization(HttpActionContext actionContext)
        {
            Contract.Assert(actionContext != null);

            return actionContext.ActionDescriptor.GetCustomAttributes<AllowAnonymousAttribute>().Any()
                       || actionContext.ControllerContext.ControllerDescriptor.GetCustomAttributes<AllowAnonymousAttribute>().Any();
        }
    }
}