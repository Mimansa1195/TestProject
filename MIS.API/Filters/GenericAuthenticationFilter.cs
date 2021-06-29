using MIS.BO;
using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Security.Principal;
using System.Text;
using System.Threading;
using System.Web.Http.Controllers;
using System.Web.Http.Filters;

namespace MIS.API.Filters
{
    /// <summary>
    /// Generic basic Authentication filter.
    /// </summary>
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Method, AllowMultiple = false)]
    public class GenericAuthenticationFilter : AuthorizationFilterAttribute
    {
        /// <summary>
        /// Public default Constructor
        /// </summary>
        public GenericAuthenticationFilter()
        {
        }

        private readonly bool _isActive = true;

        /// <summary>
        /// parameter isActive explicitly enables/disables this filter.
        /// </summary>
        /// <param name="isActive"></param>
        public GenericAuthenticationFilter(bool isActive)
        {
            _isActive = isActive;
        }

        /// <summary>
        /// Checks basic authentication request
        /// </summary>
        /// <param name="filterContext"></param>
        public override void OnAuthorization(HttpActionContext filterContext)
        {
            if (!_isActive) return;
            var identity = FetchAuthHeader(filterContext);
            if (identity == null)
            {
                ChallengeAuthRequest(filterContext, null);
                return;
            }
            var genericPrincipal = new GenericPrincipal(identity, null);
            Thread.CurrentPrincipal = genericPrincipal;
            var authResponse = OnAuthorizeUser(identity.Name, identity.Password, identity.BrowserInfo, identity.ClientInfo, filterContext);
            if (!authResponse.IsSuccessful)
            {
                ChallengeAuthRequest(filterContext, authResponse);
                return;
            }
            base.OnAuthorization(filterContext);
        }

        /// <summary>
        /// Virtual method.Can be overriden with the custom Authorization.
        /// </summary>
        /// <param name="user">user</param>
        /// <param name="pass">pass</param>
        /// <param name="browserInfo">browserInfo</param>
        /// <param name="clientInfo">clientInfo</param>
        /// <param name="filterContext">filterContext</param>
        /// <returns></returns>
        protected virtual ResponseBO<UserAccountStatus> OnAuthorizeUser(string user, string pass, string browserInfo, string clientInfo, HttpActionContext filterContext)
        {
            if (string.IsNullOrEmpty(user) || string.IsNullOrEmpty(pass))
                return new ResponseBO<UserAccountStatus>() { IsSuccessful = false, Status = ResponseStatus.Error, StatusCode = HttpStatusCode.Unauthorized, Message = ResponseMessage.Unauthorized, Result = new UserAccountStatus() };
            return new ResponseBO<UserAccountStatus>() { IsSuccessful = true, Status = ResponseStatus.Error, StatusCode = HttpStatusCode.OK, Message = ResponseMessage.Success, Result = new UserAccountStatus() };
        }

        /// <summary>
        /// Checks for autrhorization header in the request and parses it, creates user credentials and returns as BasicAuthenticationIdentity
        /// </summary>
        /// <param name="filterContext"></param>
        protected virtual BasicAuthenticationIdentity FetchAuthHeader(HttpActionContext filterContext)
        {
            string authHeaderValue = null;
            var authRequest = filterContext.Request.Headers.Authorization;
            if (authRequest != null && !String.IsNullOrEmpty(authRequest.Scheme) && authRequest.Scheme == "Basic")
                authHeaderValue = authRequest.Parameter;
            if (string.IsNullOrEmpty(authHeaderValue))
                return null;
            authHeaderValue = Encoding.Default.GetString(Convert.FromBase64String(authHeaderValue));
            var credentials = authHeaderValue.Split(':');

            //
            var browserInfo = "";
            var clientInfo = "";
            IEnumerable<string> values1;
            if (filterContext.Request.Headers.TryGetValues("BrowserInfo", out values1))
            {
                using (IEnumerator<string> enumer = values1.GetEnumerator())
                {
                    if (enumer.MoveNext())
                        browserInfo = enumer.Current;
                }
            }

            IEnumerable<string> values2;
            if (filterContext.Request.Headers.TryGetValues("ClientInfo", out values2))
            {
                using (IEnumerator<string> enumer = values2.GetEnumerator())
                {
                    if (enumer.MoveNext())
                        clientInfo = enumer.Current;
                }
            }

            return credentials.Length < 2 ? null : new BasicAuthenticationIdentity(credentials[0], credentials[1], browserInfo, clientInfo);
        }

        /// <summary>
        /// Send the Authentication Challenge request
        /// </summary>
        /// <param name="filterContext"></param>
        private static void ChallengeAuthRequest(HttpActionContext filterContext, ResponseBO<UserAccountStatus> authResponse)
        {
            var dnsHost = filterContext.Request.RequestUri.DnsSafeHost;
            if (authResponse == null)
                filterContext.Response = filterContext.Request.CreateResponse(HttpStatusCode.Unauthorized);
            else
                filterContext.Response = filterContext.Request.CreateResponse(authResponse.StatusCode, authResponse);

            //filterContext.Response = filterContext.Request.CreateResponse(HttpStatusCode.Unauthorized);
            filterContext.Response.Headers.Add("WWW-Authenticate", string.Format("Basic realm=\"{0}\"", dnsHost));
        }
    }
}