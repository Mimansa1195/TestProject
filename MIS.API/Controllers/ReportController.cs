using MIS.BO;
using MIS.Services.Contracts;
using System;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace MIS.API.Controllers
{
    public class ReportController : BaseApiController
    {
        private readonly IReportServices _reportServices;

        public ReportController(IReportServices reportServices)
        {
            _reportServices = reportServices;
        }
        [HttpPost]
        public HttpResponseMessage GetClubbedReport(string fromDate, string endDate, string empAbrhs, string reportToAbrhs, string departmentIds, string teamIds, string locationIds, string status)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _reportServices.GetClubbedReport(fromDate, endDate, empAbrhs, reportToAbrhs, departmentIds, teamIds, locationIds, status));
        }

        [HttpPost]
        public HttpResponseMessage GetLnsaReport(string fromDate, string endDate, string empAbrhs, string reportToAbrhs, string departmentIds, string locationIds)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _reportServices.GetLnsaReport(fromDate, endDate, empAbrhs, reportToAbrhs, departmentIds, locationIds));
        }

        [HttpPost]
        public HttpResponseMessage GetLwpReport(string fromDate, string endDate, string empAbrhs, string reportToAbrhs, string departmentIds, string locationIds)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _reportServices.GetLwpReport(fromDate, endDate, empAbrhs, reportToAbrhs, departmentIds, locationIds));
        }

        [HttpPost]
        public HttpResponseMessage GetCompOffReport(string fromDate, string endDate, string empAbrhs, string reportToAbrhs, string departmentIds, string locationIds)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _reportServices.GetCompOffReport(fromDate, endDate, empAbrhs, reportToAbrhs, departmentIds, locationIds));
        }

        [HttpPost]
        public HttpResponseMessage GetLnsaCompOffReport(string fromDate, string endDate, string report)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _reportServices.GetLnsaCompOffReport(fromDate, endDate, report));
        }

        [HttpPost]
        public HttpResponseMessage GetCompOffReportDetailsByUserId(string fromDate, string endDate, string empAbrhs, int requestType)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _reportServices.GetCompOffReportDetailsByUserId(fromDate, endDate, empAbrhs, requestType));
        }

        [HttpPost]
        public HttpResponseMessage GetLnsaReportDetailsByUserId(string fromDate, string endDate, string empAbrhs, int requestType)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _reportServices.GetLnsaReportDetailsByUserId(fromDate, endDate, empAbrhs, requestType));
        }

        [HttpPost]
        public HttpResponseMessage GetLwpReportDetailsByUserId(string fromDate, string endDate, string empAbrhs, int requestType)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _reportServices.GetLwpReportDetailsByUserId(fromDate, endDate, empAbrhs, requestType));
        }

        [HttpPost]
        public HttpResponseMessage GetVisitorDetails(string fromDate, string endDate, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _reportServices.GetVisitorDetails(fromDate, endDate, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetTempCardDetails(string fromDate, string endDate, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _reportServices.GetTempCardDetails(fromDate, endDate, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetTempCardDetailsForEdit(int issueId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _reportServices.GetTempCardDetailsForEdit(issueId));
        }
        [HttpPost]
        public HttpResponseMessage ChangeStatusOfIssuedCard(int issueId)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _reportServices.ChangeStatusOfIssuedCard(issueId, globalData.UserAbrhs));
        }
        [HttpPost]
        public HttpResponseMessage EditAccessCardDetails(TempCardReport input)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _reportServices.EditAccessCardDetails(input, globalData.UserAbrhs));
        }
        [HttpPost]
        public HttpResponseMessage GetReportEmployeeSkills(SkillsDetailBO skillsDetailBO)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _reportServices.GetReportEmployeeSkills(skillsDetailBO));
        }
        [HttpPost]
        public HttpResponseMessage AddCardIssueDetail(TempCardReport input)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _reportServices.AddCardIssueDetail(input, globalData.UserAbrhs));
        }
        [HttpPost]
        public HttpResponseMessage GetUserActivity(DateTime fromDate, DateTime endDate, string empAbrhs, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _reportServices.GetUserActivity(fromDate, endDate, empAbrhs, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetMealMenusData(string fromDate, string endDate, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _reportServices.GetMealMenusData(fromDate, endDate, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetMealFeedbackData(string fromDate, string endDate, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _reportServices.GetMealFeedbackData(fromDate, endDate, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetLeaveReport(string fromDate, string endDate, string empAbrhs, string reportToAbrhs, string departmentIds, string locationIds)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _reportServices.GetLeaveReport(fromDate, endDate, empAbrhs, reportToAbrhs, departmentIds, locationIds));
        }
        [HttpPost]
        public HttpResponseMessage GetGoalsForReports(int goalCycleId, int statusId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _reportServices.GetGoalsForReports(goalCycleId, statusId));
        }
    }
}
