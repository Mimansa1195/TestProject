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
    public class PimcoController : ApiController
    {
        private readonly IPimcoServices _iPimcoServices;
        public static string[] apiKeys = ConfigurationManager.AppSettings["PimcoAPIKey"].Split(',');
        public static string[] accessToken = ConfigurationManager.AppSettings["PimcoAPIAccessToken"].Split(',');

        public PimcoController(IPimcoServices iPimcoServices)
        {
            _iPimcoServices = iPimcoServices;

        }

        #region PIMCO Token based API
        [HttpGet]
        public HttpResponseMessage GetGeminiUsers(string key, string token)
        {
            var response = CommonUtility.ValidateAPIKeys(new List<GetGeminiUsersBo>(), apiKeys, key, accessToken, token, true);
            if (response.IsSuccessful)
                response = _iPimcoServices.GetGeminiUsers();

            return Request.CreateResponse(HttpStatusCode.OK, response);
        }

        [HttpGet]
        public HttpResponseMessage GetPimcoUsers(string key, string token, bool isExpiration = false)
        {
            var response = CommonUtility.ValidateAPIKeys(new List<GetPimcoUsersBo>(), apiKeys, key, accessToken, token, true);
            if (response.IsSuccessful)
                response = _iPimcoServices.GetPimcoUsers(isExpiration);

            return Request.CreateResponse(HttpStatusCode.OK, response);
        }
        #endregion

        #region PIMCO Anonymous API



        [HttpPost]
        public HttpResponseMessage FetchPimcoOrganizationStructure(int parentId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _iPimcoServices.FetchPimcoOrganizationStructure(parentId));
        }

        [HttpGet]
        public HttpResponseMessage PimcoOrgData()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _iPimcoServices.PimcoOrgData());
        }

        [HttpGet]
        public HttpResponseMessage GeminiUserProfileData()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _iPimcoServices.GeminiUserProfileData());
        }

        [HttpGet]
        public HttpResponseMessage AllGeminiUsersForPimco()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _iPimcoServices.AllGeminiUsersForPimco());
        }

        #endregion
    }
}
