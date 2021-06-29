using MIS.BO;
using MIS.Services.Contracts;
using System;
using System.Globalization;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace MIS.API.Controllers
{
    public class LnsaController : BaseApiController
    {
        private readonly ILnsaServices _lnsaServices;

        public LnsaController(ILnsaServices lnsaServices)
        {
            _lnsaServices = lnsaServices;
        }

        [HttpPost]
        public HttpResponseMessage GetConflictStatusOfLnsaPeriod(string fromDate, string tillDate, string userAbrhs)
        {
            DateTime FromDate = DateTime.ParseExact(fromDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            DateTime TillDate = DateTime.ParseExact(tillDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            return Request.CreateResponse(HttpStatusCode.OK, _lnsaServices.GetConflictStatusOfLnsaPeriod(FromDate, TillDate, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetAllLnsaRequest(string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _lnsaServices.GetAllLnsaRequest(userAbrhs));
        }

        
        [HttpPost]
        public HttpResponseMessage GetAllPendingLnsaRequest(string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _lnsaServices.GetAllPendingLnsaRequest(userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetAllApprovedLnsaRequest(string fromDate, string tillDate, string userAbrhs)
        {
            var fromDateNew = Convert.ToDateTime(DateTime.ParseExact(fromDate, "MM/dd/yyyy", CultureInfo.InvariantCulture));
            var tillDateNew = Convert.ToDateTime(DateTime.ParseExact(tillDate, "MM/dd/yyyy", CultureInfo.InvariantCulture));
            return Request.CreateResponse(HttpStatusCode.OK, _lnsaServices.GetAllApprovedLnsaRequest(fromDateNew, tillDateNew, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetLastNApprovedLnsaRequest(string userAbrhs, int noOfRecords)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _lnsaServices.GetLastNApprovedLnsaRequest(userAbrhs, noOfRecords));
        }

        [HttpPost]
        public HttpResponseMessage InsertLnsaRequest(string fromDate, string tillDate, string reason, string userAbrhs)
        {
            var fromDateNew = Convert.ToDateTime(DateTime.ParseExact(fromDate, "MM/dd/yyyy", CultureInfo.InvariantCulture));
            var tillDateNew = Convert.ToDateTime(DateTime.ParseExact(tillDate, "MM/dd/yyyy", CultureInfo.InvariantCulture));
            return Request.CreateResponse(HttpStatusCode.OK, _lnsaServices.InsertLnsaRequest(fromDateNew, tillDateNew, reason, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage TakeActionOnLnsaRequest(int requestId, int status, string remarks, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _lnsaServices.TakeActionOnLnsaRequest(requestId, status, remarks, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage ApplyLnsaShift(string userAbrhs, string dateIds, string reason)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _lnsaServices.ApplyLnsaShift(userAbrhs, dateIds, reason));
        }


        [HttpPost]
        public HttpResponseMessage GetAllLnsaShiftRequest(string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _lnsaServices.GetAllLnsaShiftRequest(userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetAllLnsaShiftReviewRequest(string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _lnsaServices.GetAllLnsaShiftReviewRequest(userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage getDateToCancelLnsaRequest(long lnsaRequestId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _lnsaServices.getDateToCancelLnsaRequest(lnsaRequestId));
        }

        [HttpPost]
        public HttpResponseMessage GetDateLnsaRequest(long lnsaRequestId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _lnsaServices.GetDateLnsaRequest(lnsaRequestId));
        }

        [HttpPost]
        public HttpResponseMessage CancelAllLnsaRequest(int lnsaRequestId, string status, string action, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _lnsaServices.CancelAllLnsaRequest(lnsaRequestId, status, action, userAbrhs));
        }


        [HttpPost]
        public HttpResponseMessage CancelLnsaRequest(int lnsaRequestId, string status, string action, string userAbrhs, int lnsaRequestDetailId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _lnsaServices.CancelLnsaRequest(status, action, userAbrhs, lnsaRequestDetailId));
        }

        [HttpPost]
        public HttpResponseMessage RejectLnsaRequest(string status, string action, string remarks, string userAbrhs, int lnsaRequestDetailId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _lnsaServices.RejectLnsaRequest(status, action, remarks, userAbrhs, lnsaRequestDetailId));
        }


        [HttpPost]
        public HttpResponseMessage RejectAllLnsaRequest(int lnsaRequestId, string status, string action, string remarks, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _lnsaServices.RejectAllLnsaRequest(lnsaRequestId, status, action, remarks, userAbrhs));
        }


        [HttpPost]
        public HttpResponseMessage ApproveLnsaShiftRequest(int lnsaRequestId, string status, string action, string remarks, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _lnsaServices.ApproveLnsaShiftRequest(lnsaRequestId, status, action, remarks, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage BulkApproveLnsaRequest(string lnsaRequestIds, string remarks)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _lnsaServices.BulkApproveLnsaRequest(lnsaRequestIds, remarks, globalData.LoginUserId));
        }

        [HttpPost]
        public HttpResponseMessage GetShiftMappingDetails(string userAbrhs)
        {
            //25th of Previous month to 24th of Current month - runs on 25th of every month
            var today = DateTime.Today;
            var dayNew = today.Day;
            if (dayNew > 24)
            {
                today = today.AddMonths(1);
            }
            var prevMonthDate = new DateTime(today.Year, today.Month, 25).AddMonths(-1); //From 25th of Previous month
            var currentMonthDate = new DateTime(today.Year, today.Month, 24);            //Till 24th of Current month
            bool IsPreviousMonthDate = false;

            return Request.CreateResponse(HttpStatusCode.OK, _lnsaServices.GetShiftMappingDetails(prevMonthDate, currentMonthDate, IsPreviousMonthDate, userAbrhs));
        }
        [HttpPost]
        public HttpResponseMessage GetCalenderOnPrevButtonClick(int month, int year, string userAbrhs)
        {
            //25th of Previous month to 24th of Current month - runs on 25th of every month
            var currentDate = new DateTime(year, month, 24);
            var prevDate = currentDate;
            var prevMonthDate = new DateTime(currentDate.Year, currentDate.Month, 25).AddMonths(-1); //From 25th of Previous month
            var currentMonthDate = currentDate; //Till 24th of Current month
            bool IsPreviousMonthDate = true;
            return Request.CreateResponse(HttpStatusCode.OK, _lnsaServices.GetShiftMappingDetails(prevMonthDate, currentMonthDate, IsPreviousMonthDate, userAbrhs));
        }
        [HttpPost]
        public HttpResponseMessage GetCalenderOnNextButtonClick(int month, int year, string userAbrhs)
        {
            //25th of Previous month to 24th of Current month - runs on 25th of every month
            var prevDate = new DateTime(year, month, 25);
            var prevMonthDate = prevDate; //From 25th of Previous month
            var currentMonthDate = new DateTime(prevDate.Year, prevDate.Month, 24).AddMonths(1);            //Till 24th of Current month
            bool IsPreviousMonthDate = true;
            var today = DateTime.Today;
            var dayNew = today.Day;
            if (dayNew > 24)
            {
                today = today.AddMonths(1);
            }
            var prevMonthDateForCurrent = new DateTime(today.Year, today.Month, 25).AddMonths(-1); //From 25th of Previous month
            var currentMonthDateForCurrent = new DateTime(today.Year, today.Month, 24);            //Till 24th of Current month
            if (prevMonthDate >= prevMonthDateForCurrent && currentMonthDate >= currentMonthDateForCurrent)
            {
                prevMonthDate = prevMonthDateForCurrent;
                currentMonthDate = currentMonthDateForCurrent;
                IsPreviousMonthDate = false;
            }

            return Request.CreateResponse(HttpStatusCode.OK, _lnsaServices.GetShiftMappingDetails(prevMonthDate, currentMonthDate, IsPreviousMonthDate, userAbrhs));
        }

   
    }
}