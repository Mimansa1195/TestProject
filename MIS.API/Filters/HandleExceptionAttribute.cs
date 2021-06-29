using MIS.Services.Contracts;
using System;
using System.Net;
using System.Linq;
using System.Net.Http;
using System.Web.Http.Filters;

namespace MIS.API.Filters
{
    public class HandleExceptionAttribute : ExceptionFilterAttribute
    {
        private const string Token = "Token";

        public override void OnException(HttpActionExecutedContext context)
        {
            if (context == null)
                throw new ArgumentNullException("filterContext");

            if (context.Exception != null)
            {
                var msg = new HttpResponseMessage();
                var userId = 0;
                var tokenValue = string.Empty;
                try
                {
                    if (context.Request.Headers.Contains(Token)) //if(context.Request.Headers.TryGetValues(Token, out keys))
                    {
                        tokenValue = context.Request.Headers.GetValues(Token).First();
                        //IEnumerable<string> keys = null;
                        //context.Request.Headers.TryGetValues(Token, out keys);
                        //tokenValue = keys.First();
                    }

                    // throw new ApplicationException("Test Exception ");
                    var controllerName = (string)context.ActionContext.ControllerContext.ControllerDescriptor.ControllerName;
                    var actionName = (string)context.ActionContext.ActionDescriptor.ActionName;

                    var logger = context.ActionContext.ControllerContext.Configuration.DependencyResolver.GetService(typeof(ICommonService)) as ICommonService;
                    var errorId = logger.LogError(context.Exception, controllerName, actionName, userId, tokenValue);

                    if (errorId > 0)
                    {
                        msg.Content = new StringContent("Your request cannot be processed, please try after some time or contact to MIS team with reference id: " + errorId + " for further assistance.");
                        msg.ReasonPhrase = "Your request cannot be processed, please try after some time or contact to MIS team with reference id: " + errorId + " for further assistance.";
                        msg.StatusCode = HttpStatusCode.InternalServerError; //500
                    }
                    else
                    {
                        msg.Content = new StringContent("Sorry for the inconvenience but we are performing some maintenance at the moment. The MIS service is currently unavailable, please try after some time. We will be back online shortly.");
                        msg.ReasonPhrase = "Sorry for the inconvenience but we are performing some maintenance at the moment. The MIS service is currently unavailable, please try after some time. We will be back online shortly.";
                        msg.StatusCode = HttpStatusCode.ServiceUnavailable; //503
                    }
                }
                catch (Exception ex)
                {
                    if (ex.Message != null && ex.Message.Contains("underlying"))
                    {
                        msg.Content = new StringContent("Unable to connect to the database, please check connection configuration.");
                        msg.ReasonPhrase = "Unable to connect to the database, please check connection configuration.";
                        msg.StatusCode = HttpStatusCode.ServiceUnavailable; //503
                    }
                }
                context.Response = msg;
            }
        }
    }
}