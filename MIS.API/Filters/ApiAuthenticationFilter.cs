using MIS.BO;
using MIS.Services.Contracts;
using MIS.Utilities;
using System;
using System.Net;
using System.Threading;
using System.Web.Http.Controllers;

namespace MIS.API.Filters
{
    /// <summary>
    /// Custom Authentication Filter Extending basic Authentication
    /// </summary>
    public class ApiAuthenticationFilter : GenericAuthenticationFilter
    {
        /// <summary>
        /// Default Authentication Constructor
        /// </summary>
        public ApiAuthenticationFilter()
        {
        }

        /// <summary>
        /// AuthenticationFilter constructor with isActive parameter
        /// </summary>
        /// <param name="isActive">isActive</param>
        public ApiAuthenticationFilter(bool isActive)
            : base(isActive)
        {
        }

        /// <summary>
        /// Protected overriden method for authorizing user
        /// </summary>
        /// <param name="username">Username</param>
        /// <param name="password">Password</param>
        /// <param name="browserInfo">browserInfo</param>
        /// <param name="clientInfo">clientInfo</param>
        /// <param name="actionContext">actionContext</param>
        /// <returns>ResponseBO</returns>
        protected override ResponseBO<UserAccountStatus> OnAuthorizeUser(string username, string password, string browserInfo, string clientInfo, HttpActionContext actionContext)
        {
            var provider = actionContext.ControllerContext.Configuration.DependencyResolver.GetService(typeof(IUserServices)) as IUserServices;
            if (provider != null)
            {
                var response = provider.Authenticate(username, password, browserInfo, clientInfo);

                if (response.IsSuccessful)
                {
                    var userId = 0;
                    Int32.TryParse(CryptoHelper.Decrypt(response.Result.UserAbrhs), out userId);

                    var basicAuthenticationIdentity = Thread.CurrentPrincipal.Identity as BasicAuthenticationIdentity;
                    if (basicAuthenticationIdentity != null)
                    {
                        basicAuthenticationIdentity.UserId = userId;
                        basicAuthenticationIdentity.UserAbrhs = response.Result.UserAbrhs;
                    }
                }
                return response;
            }
            return new ResponseBO<UserAccountStatus>() { IsSuccessful = false, Status = ResponseStatus.Error, StatusCode = HttpStatusCode.Unauthorized, Message = ResponseMessage.Unauthorized, Result = new UserAccountStatus() };
        }
    }
}