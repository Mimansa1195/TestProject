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
    public class AttendanceController : BaseApiController
    {
        private readonly IAttendanceServices _attendanceServices;

        public AttendanceController(IAttendanceServices attendanceServices)
        {
            _attendanceServices = attendanceServices;
        }

        [HttpPost]
        public HttpResponseMessage GetSupportingStaffMembers(string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _attendanceServices.GetSupportingStaffMembers(userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetAttSupportingStaff(string fromDate, string tillDate, string EmpAbrhs, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _attendanceServices.GetAttendanceRegisterForSupportingStaffMembers(fromDate, tillDate, EmpAbrhs, userAbrhs));
        }

        #region Employee Attendance

        [HttpPost]
        public HttpResponseMessage GetDepartmentOnReportToBasis(string userAbrhs, string menuAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _attendanceServices.GetDepartmentOnReportToBasis(userAbrhs, menuAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetEmployeeForAttendanceOnReportToBasis(string date, int departmentId, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _attendanceServices.GetEmployeeForAttendanceOnReportToBasis(date, departmentId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage ProcessEmployeeAttendance(string fromDate, string tillDate, int departmentId, int forEmployeeId, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _attendanceServices.ProcessEmployeeAttendance(fromDate, tillDate, departmentId, forEmployeeId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetAttendanceSummary(string fromDate, string endDate, string empAbrhs, string reportToAbrhs, string departmentIds)
        {
            var fromDatef = DateTime.ParseExact(fromDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            var endDatef = DateTime.ParseExact(endDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            return Request.CreateResponse(HttpStatusCode.OK, _attendanceServices.GetAttendanceSummary(fromDatef, endDatef, empAbrhs, reportToAbrhs, departmentIds));
        }

        [HttpPost]
        public HttpResponseMessage GetAttendanceForEmployees(string fromDate, string endDate, string empAbrhs, string departmentIds, string locationIds, string userAbrhs)
        {
            var fromDatef = DateTime.ParseExact(fromDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            var endDatef = DateTime.ParseExact(endDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            return Request.CreateResponse(HttpStatusCode.OK, _attendanceServices.GetAttendanceForEmployees(fromDate, endDate, empAbrhs, departmentIds, locationIds, userAbrhs));
        }
        #endregion

        [HttpPost]
        public HttpResponseMessage GetAttendanceUpload(DateTime fromDate, DateTime toDate)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _attendanceServices.GetAttendanceUpload(fromDate, toDate));
        }

        [HttpPost]
        public HttpResponseMessage GetDetailAttendance(long AttendaceId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _attendanceServices.GetDetailAttendance(AttendaceId));
        }

        [HttpPost]
        public HttpResponseMessage GetPunchInOutLog(string empAbrhs, string attendanceDate)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _attendanceServices.GetPunchInOutLog(empAbrhs, attendanceDate));
        }

        [HttpPost]
        public HttpResponseMessage GetAllAccessCard(string cardType)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _attendanceServices.GetAllAccessCard(cardType));
        }

        [HttpPost]
        public HttpResponseMessage GetPunchInOutLogForAllCard(string accessCardNo, string fromDate, string tillDate)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _attendanceServices.GetPunchInOutLogForAllCard(accessCardNo, fromDate, tillDate));
        }

        [HttpPost]
        public HttpResponseMessage GetPunchInOutLogForTempCard(string empAbrhs, string accessCardNo, string attendanceDate)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _attendanceServices.GetPunchInOutLogForTempCard(empAbrhs, accessCardNo, attendanceDate));
        }

        [HttpPost]
        public HttpResponseMessage GetPunchInOutLogForStaff(string empAbrhs, string attendanceDate)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _attendanceServices.GetPunchInOutLogForStaff(empAbrhs, attendanceDate));
        }

    }
}
