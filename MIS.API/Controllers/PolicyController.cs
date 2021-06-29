using MIS.Services.Contracts;
using System.Configuration;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace MIS.API.Controllers
{
    public class PolicyController : BaseApiController
    {
        private readonly IPolicyServices _policyServices;

        public PolicyController(IPolicyServices policyServices)
        {
            _policyServices = policyServices;
        }

        [HttpPost]
        public HttpResponseMessage GetAllPolicies()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _policyServices.GetAllPolicies());
        }

        [HttpPost]
        public HttpResponseMessage GetAllActivePolicies(string departmentAbrhs)
        {
            var basePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["PolicyDocumentPath"];
            return Request.CreateResponse(HttpStatusCode.OK, _policyServices.GetAllActivePolicies(basePath));
        }

        [HttpPost]
        public HttpResponseMessage ChangePolicyStatus(int policyId, int status, string userAbrhs)//status = 1:activate, 2:deactivate, 3:delete
        {
            return Request.CreateResponse(HttpStatusCode.OK, _policyServices.ChangePolicyStatus(policyId, status, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage AddPolicy(string policyTitle, string policyName, string base64PolicyData, string userAbrhs)
        {
            var basePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["PolicyDocumentPath"] + policyName;
            return Request.CreateResponse(HttpStatusCode.OK, _policyServices.AddPolicy(policyTitle, policyName, base64PolicyData, userAbrhs, basePath));
        }

        [HttpPost]
        public HttpResponseMessage FetchPolicyInformation(int policyId)
        {
            var basePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["PolicyDocumentPath"];
            return Request.CreateResponse(HttpStatusCode.OK, _policyServices.FetchPolicyInformation(basePath, policyId));
        }
    }
}