using MIS.BO;
using MIS.Services.Contracts;
using MIS.Utilities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http.Controllers;
using System.Web.Http.Filters;

namespace MIS.API.Filters
{
    public class AuthorizeApiAttribute : ActionFilterAttribute
    {
        private const string Token = "Token";
        private const string UserAbrhs = "UserAbrhs";

        public override void OnActionExecuting(HttpActionContext filterContext)
        {
            var provider = filterContext.ControllerContext.Configuration.DependencyResolver.GetService(typeof(ITokenServices)) as ITokenServices;

            if (filterContext.Request.Headers.Contains(Token) && filterContext.Request.Headers.Contains(UserAbrhs))
            {
                var tokenValue = filterContext.Request.Headers.GetValues(Token).First();
                var userAbrhs = filterContext.Request.Headers.GetValues(UserAbrhs).First();
                var tokenExpiry = Convert.ToDouble(ConfigurationManager.AppSettings["AuthTokenExpiry"]);
                var isTokenValid = provider.ValidateToken(userAbrhs, tokenValue, tokenExpiry);

                //////////////////////////
                //var controllerName = filterContext.ActionDescriptor.ControllerDescriptor.ControllerName;
                //var apiName = filterContext.ActionDescriptor.ActionName;
                //var isUserAuthorized = provider.ValidateApi(userAbrhs, controllerName, apiName);

                //var paramUserAbrhs = filterContext.ActionArguments["userAbrhs"];

                //Use any to set root value
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                filterContext.RequestContext.RouteData.Values.Add("GlobalData", new RequestBO
                {
                    Token = tokenValue,
                    UserAbrhs = userAbrhs,
                    LoginUserId = userId
                });
                //Access in ctrloller > RouteData.Values["GlobalData"];
                //filterContext.ControllerContext.RequestContext.RouteData.Values.Add(new KeyValuePair<string, object>("GlobalRequest", new RequestBO { UserAbrhs = userAbrhs }));

                //var queryParams = new Dictionary<string, string>(HtmlPage.Document.QueryString, StringComparer.InvariantCultureIgnoreCase);
                /////////////////////////

                // Validate Token
                if (provider != null && !isTokenValid)
                {
                    var responseMessage = new HttpResponseMessage(HttpStatusCode.Unauthorized) { ReasonPhrase = "Invalid Request" };
                    filterContext.Response = responseMessage;
                }
            }
            else
            {
                filterContext.Response = new HttpResponseMessage(HttpStatusCode.Unauthorized);
            }

            base.OnActionExecuting(filterContext);
        }
    }
}