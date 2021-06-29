using MIS.BO;
using MIS.Services.Contracts;
using MIS.Utilities;
using System.Collections.Generic;
using System.Configuration;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace MIS.API.Controllers
{
    public class ExternalController : BaseExtApiController
    {
        private readonly IExternalServices _externalAPI;
        private readonly IPimcoServices _iPimcoServices;

        public static string[] apiKeys = ConfigurationManager.AppSettings["GeminiAPIKey"].Split(',');
        public static string[] accessToken = ConfigurationManager.AppSettings["GeminiAPIAccessToken"].Split(',');

        public ExternalController(IExternalServices externalAPI, IPimcoServices iPimcoServices)
        {
            _externalAPI = externalAPI;
            _iPimcoServices = iPimcoServices;
        }

        [HttpGet]
        [AllowAnonymous]
        public HttpResponseMessage UsersSkills(string key, string token)
        {
            var response = CommonUtility.ValidateAPIKeys(new List<UserSkillSet>(), apiKeys, key, accessToken, token);
            if (response.IsSuccessful)
                response.Result = _externalAPI.GetUsersSkills();

            return Request.CreateResponse(HttpStatusCode.OK, response);
        }

        [HttpGet]
        [Route("api/External/GetGeminiUsers")]
        [Route("api/Gemini/Users")]
        [AllowAnonymous]
        public HttpResponseMessage GetGeminiUsers(string key, string token)
        {
            var response = CommonUtility.ValidateAPIKeys(new List<GetGeminiUsersBo>(), apiKeys, key, accessToken, token, true);
            if (response.IsSuccessful)
                response = _iPimcoServices.GetGeminiUsers();

            return Request.CreateResponse(HttpStatusCode.OK, response);
        }

        [HttpGet]
        public HttpResponseMessage AllGeminiUsers()
        {
            var response = _externalAPI.GetAllGeminiUsersForPnL();

            return Request.CreateResponse(HttpStatusCode.OK, response);
        }

        [HttpGet]
        [Route("api/External/GeminiUsers/{email?}")]
        public HttpResponseMessage GeminiUsers(string email = "")
        {
            var response = _externalAPI.GetGeminiActiveUsers(email);

            return Request.CreateResponse(HttpStatusCode.OK, response);
        }
    }
}