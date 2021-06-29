using MIS.API.Filters;
using System;
using System.Configuration;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Threading;
using MIS.Services.Contracts;

namespace MIS.API.Controllers
{
    [ApiAuthenticationFilter]
    public class AuthenticateController : ApiController
    {
        private readonly ITokenServices _tokenServices;

        public AuthenticateController(ITokenServices tokenServices)
        {
            _tokenServices = tokenServices;
        }

        #region Private Methods
        /// <summary>
        /// Returns auth token for the validated user.
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        private HttpResponseMessage GetAuthToken(int userId, string userAbrhs)
        {
            var tokenExpiry = ConfigurationManager.AppSettings["AuthTokenExpiry"];
            var token = _tokenServices.GenerateToken(userId, Convert.ToDouble(tokenExpiry));
            var response = Request.CreateResponse(HttpStatusCode.OK, new { Token = token.AuthToken, UserAbrhs = userAbrhs });
            response.Headers.Add("Token", token.AuthToken);
            response.Headers.Add("TokenExpiry", tokenExpiry);
            response.Headers.Add("Access-Control-Expose-Headers", "Token,TokenExpiry");
            return response;
        }
        #endregion

        /// <summary>
        /// Authenticates user and returns token
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        public HttpResponseMessage Authenticate()
        {
            if (Thread.CurrentPrincipal != null && Thread.CurrentPrincipal.Identity.IsAuthenticated)
            {
                var basicAuthenticationIdentity = Thread.CurrentPrincipal.Identity as BasicAuthenticationIdentity;
                if (basicAuthenticationIdentity != null)
                {
                    var userId = basicAuthenticationIdentity.UserId;
                    var userAbrhs = basicAuthenticationIdentity.UserAbrhs;

                    return GetAuthToken(userId, userAbrhs);
                }
            }
            return null;
        }
                
    }
}