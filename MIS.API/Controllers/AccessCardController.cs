using MIS.Services.Contracts;
using System;
using System.Configuration;
using System.Globalization;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace MIS.API.Controllers
{
    public class AccessCardController : ApiController
    {
        private readonly IAccessCardServices _accessCardServices;

        public AccessCardController(IAccessCardServices accessCardServices)
        {
            _accessCardServices = accessCardServices;
        }

        [HttpPost]
        public HttpResponseMessage GetAllAccessCards()
        {
                return Request.CreateResponse(HttpStatusCode.OK, _accessCardServices.GetAllAccessCards());
        }

        [HttpPost]
        public HttpResponseMessage ChangeAccessCardState(int accessCardId, int state, string userAbrhs)
        {
                return Request.CreateResponse(HttpStatusCode.OK, _accessCardServices.ChangeAccessCardState(accessCardId, state, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage AddAccessCard(string cardNo, bool isPimcoCard, bool isTemporaryCard, string userAbrhs)
        {
                return Request.CreateResponse(HttpStatusCode.OK, _accessCardServices.AddAccessCard(cardNo, isPimcoCard, isTemporaryCard, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetAllUserCardMapping()
        {
                return Request.CreateResponse(HttpStatusCode.OK, _accessCardServices.GetAllUserCardMapping());
        }

        
        [HttpPost]
        public HttpResponseMessage GetAllUserCardUnMappedHistory()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _accessCardServices.GetAllUserCardUnMappedHistory());
        }

        [HttpPost]
        public HttpResponseMessage GetAllUnmappedUser()
        {
                return Request.CreateResponse(HttpStatusCode.OK, _accessCardServices.GetAllUnmappedUser());
        }

        [HttpPost]
        public HttpResponseMessage GetAllUnmappedStaff()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _accessCardServices.GetAllUnmappedStaff());
        }

        [HttpPost]
        public HttpResponseMessage GetAllUnmappedAccessCard()
        {
                return Request.CreateResponse(HttpStatusCode.OK, _accessCardServices.GetAllUnmappedAccessCard());
        }

        
          
        [HttpPost]
        public HttpResponseMessage GetUserCardMappingInfoById(int userCardMappingId)
        {
                return Request.CreateResponse(HttpStatusCode.OK, _accessCardServices.GetUserCardMappingInfoById(userCardMappingId));
        }

        [HttpPost]
        public HttpResponseMessage DeleteUserCardMapping(int userCardMappingId, string userAbrhs,string aasignedTill)
        {
            var aasignedTillNew = DateTime.ParseExact(aasignedTill, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            return Request.CreateResponse(HttpStatusCode.OK, _accessCardServices.DeleteUserCardMapping(userCardMappingId, userAbrhs, aasignedTillNew));
        }

        [HttpPost]
        public HttpResponseMessage FinaliseUserCardMapping(int userCardMappingId, string userAbrhs)
        {
                return Request.CreateResponse(HttpStatusCode.OK, _accessCardServices.FinaliseUserCardMapping(userCardMappingId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage AddUserAccessCardMapping(int accessCardId, string employeeAbrhs, bool isPimcoUserCardMapping, string userAbrhs, bool isStaff, string fromDate)
        {
            var fromDateNew= DateTime.ParseExact(fromDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            return Request.CreateResponse(HttpStatusCode.OK, _accessCardServices.AddUserAccessCardMapping(accessCardId, employeeAbrhs, isPimcoUserCardMapping, userAbrhs, isStaff, fromDateNew));
        }

        [HttpPost]
        public HttpResponseMessage UpdateUserAccessCardMapping(int userCardMappingId, int accessCardId, bool isPimcoUserCardMapping, string userAbrhs,string assignedFrom)
        {
            var fromDateNew = DateTime.ParseExact(assignedFrom, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            return Request.CreateResponse(HttpStatusCode.OK, _accessCardServices.UpdateUserAccessCardMapping(userCardMappingId, accessCardId, isPimcoUserCardMapping, userAbrhs, fromDateNew));
        }

        [HttpPost]
        public HttpResponseMessage GetNextWorkingDate()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _accessCardServices.GetNextWorkingDate());
        }
        
    }
}