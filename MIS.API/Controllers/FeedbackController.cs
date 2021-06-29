using MIS.Services.Contracts;
using System;
using System.Configuration;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace MIS.API.Controllers
{
    public class FeedbackController : BaseApiController
    {
        private readonly IFeedbackServices _feedbackServices;

        public FeedbackController(IFeedbackServices feedbackServices)
        {
            _feedbackServices = feedbackServices;
        }

        [HttpPost]
        public HttpResponseMessage FetchAllFeedbacks()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _feedbackServices.FetchAllFeedbacks());
        }

        [HttpPost]
        public HttpResponseMessage SubmitFeedback(string remarks, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _feedbackServices.SubmitFeedback(remarks, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage AcknowledgeFeedback(int feedbackId, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _feedbackServices.AcknowledgeFeedback(feedbackId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage FetchFeedbackById(int feedbackId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _feedbackServices.FetchFeedbackById(feedbackId));
        }

        [HttpPost]
        public HttpResponseMessage FetchAllFeedbackByUserId(string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _feedbackServices.FetchAllFeedbackByUserId(userAbrhs));
        }
    }
}