using MIS.BO;
using MIS.Services.Contracts;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace MIS.API.Controllers
{
    public class LeaveManagementController : BaseApiController
    {
        private readonly ILeaveManagementServices _leaveMgmtServices;

        public LeaveManagementController(ILeaveManagementServices leaveMgmtServices)
        {
            _leaveMgmtServices = leaveMgmtServices;
        }

        #region Approver Remarks

        [HttpPost]
        public HttpResponseMessage GetApproverRemarks(long requestId, string type)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.GetApproverRemarks(requestId, type));
        }

        #endregion

        #region Leave Review

        [HttpPost]
        public HttpResponseMessage GetLeaves(string userAbrhs, string Status, int year)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.GetLeaves(userAbrhs, Status, year));
        }

        [HttpPost]
        public HttpResponseMessage GetLeaveApplicationByApplicationID(int ApplicationID)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.GetLeaveApplicationByApplicationID(ApplicationID));
        }

        [HttpPost]
        public HttpResponseMessage TakeActionOnLeave(int RequestID, string Userabrhs, string Status, String Remark, string ForwardedAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.TakeActionOnLeave(RequestID, Userabrhs, Status, Remark, ForwardedAbrhs));
        }

        #endregion

        #region Comp-Off

        [HttpPost]
        public HttpResponseMessage GetCompOffRequest(string userAbrhs, string Status, int year)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.GetCompOffRequest(userAbrhs, Status, year));
        }

        [HttpPost]
        public HttpResponseMessage FetchDatesToRequestCompOff(string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.FetchDatesToRequestCompOff(userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage RequestForCompOff(string date, int days, string reason, string userAbrhs)
        {

            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.RequestForCompOff(date, days, reason, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage TakeActionOnCompOff(int RequestID, string UserAbrhs, string Status, string Remark)
        {

            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.TakeActionOnCompOff(RequestID, UserAbrhs, Status, Remark));
        }

        #endregion

        #region WorkFromHome

        [HttpPost]
        public HttpResponseMessage GetWFHRequest(string userAbrhs, string Status, int year)
        {

            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.GetWFHRequest(userAbrhs, Status, year));
        }

        [HttpPost]
        public HttpResponseMessage FetchDatesToRequestWorkFromHome(string userAbrhs)
        {

            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.FetchDatesToRequestWorkFromHome(userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage TakeActionOnWFH(int RequestID, string UserAbrhs, string Status, string Remark, bool IsForwarded)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.TakeActionOnWFH(RequestID, UserAbrhs, Status, Remark, IsForwarded));
        }

        [HttpPost]
        public HttpResponseMessage RequestForWorkForHome(string date, string reason, bool isFirstHalfWfh, bool isLastHalfWfh, string mobileNo, string userAbrhs)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.RequestForWorkForHome(date, reason, isFirstHalfWfh, isLastHalfWfh, mobileNo, userAbrhs, globalData.LoginUserId));
        }

        #endregion

        #region Dashboard

        [HttpPost]
        public HttpResponseMessage FetchEmployeeAttendance(int userId, int year, int month)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.FetchEmployeeAttendance(userId, year, month));
        }

        [HttpPost]
        public HttpResponseMessage ListLeaveBalanceByUserId(string employeeAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.ListLeaveBalanceByUserId(employeeAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage ListLeaveBalanceForAllUser(string employeeAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.ListLeaveBalanceForAllUser(employeeAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage FetchAllEmployeesAttendance(string date)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.FetchAllEmployeesAttendance(date));
        }

        [HttpPost]
        public HttpResponseMessage FetchEmployeeAttendanceForToday(int userId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.FetchEmployeeAttendanceForToday(userId));
        }

        [HttpPost]
        public HttpResponseMessage FetchEmployeeStatusForManager(int userId, string date)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.FetchEmployeeStatusForManager(userId, date));
        }

        [HttpPost]
        public HttpResponseMessage FetchAllEmployeesRawAttendanceData(string date)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.FetchAllEmployeesRawAttendanceData(date));
        }

        #endregion

        #region Apply Leave

        [HttpPost]
        public HttpResponseMessage ApplyLeave(ApplyLeaveDetailBO newLeave)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.ApplyLeave(newLeave));
        }


        [HttpPost]
        public HttpResponseMessage SubmitLegitimateLeave(string employeeAbrhs, string userAbrhs, string fromDate, string type, string reason, int leaveId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.SubmitLegitimateLeave(employeeAbrhs, userAbrhs, fromDate, type, reason, leaveId));
        }

        [HttpPost]
        public HttpResponseMessage GetLastRecordDetails(string type, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.GetLastRecordDetails(type, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage FetchDaysOnBasisOfLeavePeriod(string fromDate, string toDate, int leaveIdToBeCancelled, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.FetchDaysOnBasisOfLeavePeriod(fromDate, toDate, leaveIdToBeCancelled, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage FetchAvailableLeaves(double noOfWorkingDays, long leaveApplicationId, string userAbrhs, int totalDays)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.FetchAvailableLeaves(noOfWorkingDays, leaveApplicationId, userAbrhs, totalDays));
        }

        [HttpPost]
        public HttpResponseMessage AvailableLeaveForLegitimate(double noOfWorkingDays, long leaveApplicationId, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.AvailableLeaveForLegitimate(noOfWorkingDays, leaveApplicationId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage CancelLeave(long leaveApplicationId, string remarks, string userAbrhs, bool isCancelByHR, string forLeaveType, string type)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.CancelLeave(leaveApplicationId, remarks, userAbrhs, isCancelByHR, forLeaveType, type));
        }


        [HttpPost]
        public HttpResponseMessage GetLegitimateRequest(int year)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            var data = _leaveMgmtServices.GetLegitimateRequest(globalData.UserAbrhs, year); //, status
            return Request.CreateResponse(HttpStatusCode.OK, data);
        }


        [HttpPost]
        public HttpResponseMessage TakeActionOnLegitimateRequest(int RequestId, string UserAbrhs, string Status, string Remark)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.TakeActionOnLegitimateRequest(RequestId, UserAbrhs, Status, Remark));
        }


        #endregion

        #region Outing request Management
        [HttpPost]
        public HttpResponseMessage GetOutingType(bool checkEligibility)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.GetOutingType(checkEligibility));
        }

        [HttpPost]
        public HttpResponseMessage ListApplyOutingRequest(string employeeAbrhs, int year)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.ListApplyOutingRequest(employeeAbrhs, year));
        }

        [HttpPost]
        public HttpResponseMessage ApplyOutingRequest(ApplyOutingRequestDetailBO input)
        {

            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.ApplyOutingRequest(input));
        }
        [HttpPost]
        public HttpResponseMessage GetOutingReviewRequest(int year)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            var data = _leaveMgmtServices.GetOutingReviewRequest(globalData.UserAbrhs, year); //, status
            return Request.CreateResponse(HttpStatusCode.OK, data);
        }

        [HttpPost]
        public HttpResponseMessage TakeActionOnOutingRequest(int OutingRequestId, string UserAbrhs, string Status, string Remark)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.TakeActionOnOutingRequest(OutingRequestId, UserAbrhs, Status, Remark));
        }

        [HttpPost]
        public HttpResponseMessage GetDateToCancelOutingRequest(int OutingRequestId)
        {
            var data = _leaveMgmtServices.GetDateToCancelOutingRequest(OutingRequestId);
            return Request.CreateResponse(HttpStatusCode.OK, data);
        }

        [HttpPost]
        public HttpResponseMessage CancelAllOutingRequest(int OutingRequestId, string UserAbrhs, string Status, string Remark)
        {
            var data = _leaveMgmtServices.CancelAllOutingRequest(OutingRequestId, UserAbrhs, Status, Remark);
            return Request.CreateResponse(HttpStatusCode.OK, data);
        }
        [HttpPost]
        public HttpResponseMessage CancelOutingRequest(int OutingRequestId, string UserAbrhs, string Status, string Remark, long outingRequestDetailId)
        {
            var data = _leaveMgmtServices.CancelOutingRequest(OutingRequestId, UserAbrhs, Status, Remark, outingRequestDetailId);
            return Request.CreateResponse(HttpStatusCode.OK, data);
        }
        #endregion

        #region DataChange Request

        [HttpPost]
        public HttpResponseMessage FetchDateForDataChange(string category, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.FetchDateForDataChange(category, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetDataChangeRequest(string userAbrhs, string Status, int year)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.GetDataChangeRequest(userAbrhs, Status, year));
        }

        [HttpPost]
        public HttpResponseMessage InsertRequestForDataChange(string type, int recordId, string reason, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.InsertRequestForDataChange(type, recordId, reason, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage TakeActionOnDataChangeRequest(RequestDataChangeBO requestDataChange)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.TakeActionOnDataChangeRequest(requestDataChange));
        }

        [HttpPost]
        public HttpResponseMessage ListLWPMarkedBySystemByUserId()
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.ListLWPMarkedBySystemByUserId(globalData.LoginUserId));
        }

        #endregion

        #region UpdateLeave

        [HttpPost]
        public HttpResponseMessage ListAvailedLeaveByUserId(string employeeAbrhs, int year)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.ListAvailedLeaveByUserId(employeeAbrhs, year));
        }

        [HttpPost]
        public HttpResponseMessage UpdateLeaveBalanceByHR(int type, string employeeAbrhs, double ClCount, double PlCount, double CompOffCount, double LwpCount, string Cloy, double mLCount, int allocationCount, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.UpdateLeaveBalanceByHR(type, employeeAbrhs, ClCount, PlCount, CompOffCount, LwpCount, Cloy, mLCount, allocationCount, userAbrhs));
        }


        [HttpPost]
        public HttpResponseMessage SubmitAdvanceLeave(string employeeAbrhs, string fromDate, string tillDate, string reason)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.SubmitAdvanceLeave(employeeAbrhs, fromDate, tillDate, reason, globalData.LoginUserId));
        }

        [HttpPost]
        public HttpResponseMessage GetDatesToCancelAdvanceLeave(long leaveId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.GetDatesToCancelAdvanceLeave(leaveId));

        }


        #endregion

        #region Update Attendance

        [HttpPost]
        public HttpResponseMessage LoadRemarks()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.LoadRemarks());
        }

        [HttpPost]
        public HttpResponseMessage GetEmployeeAttendanceDetails(string employeeAbrhs, string date)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.GetEmployeeAttendanceDetails(employeeAbrhs, date));
        }

        [HttpPost]
        public HttpResponseMessage UpdateEmployeeAttendanceDetails(string employeeAbrhs, long attendanceId, string inTime, string outTime, int statusId, string remarks, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.UpdateEmployeeAttendanceDetails(employeeAbrhs, attendanceId, inTime, outTime, statusId, remarks, userAbrhs));
        }

        #endregion

        #region Status /History

        [HttpPost]
        public HttpResponseMessage ListLeaveByUserId(string userAbrhs, int year)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.ListLeaveByUserId(userAbrhs, year));
        }



        [HttpPost]
        public HttpResponseMessage ListLegitimatetByUserId(string userAbrhs, int year)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.ListLegitimatetByUserId(userAbrhs, year));
        }

        [HttpPost]
        public HttpResponseMessage ListWorkFromHomeByUserId(string userAbrhs, int year)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.ListWorkFromHomeByUserId(userAbrhs, year));
        }

        [HttpPost]
        public HttpResponseMessage ListCompOffByUserId(string userAbrhs, int year)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.ListCompOffByUserId(userAbrhs, year));
        }

        [HttpPost]
        public HttpResponseMessage ListDataChangeRequestByUserId(string userAbrhs, int year)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.ListDataChangeRequestByUserId(userAbrhs, year));
        }

        #endregion

        #region Bulk Approve

        [HttpPost]
        public HttpResponseMessage TakeActionOnLeaveBulkApprove(string RequestID, string Userabrhs, string Status, String Remark, string ForwardedAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.TakeActionOnLeaveBulkApprove(RequestID, Userabrhs, Status, Remark, ForwardedAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage TakeActionOnCompOffBulkApprove(string RequestID, string UserAbrhs, string Status, string Remark)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.TakeActionOnCompOffBulkApprove(RequestID, UserAbrhs, Status, Remark));
        }

        [HttpPost]
        public HttpResponseMessage TakeActionOnWFHBulkApprove(string RequestID, string UserAbrhs, string Status, string Remark, bool IsForwarded)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.TakeActionOnWFHBulkApprove(RequestID, UserAbrhs, Status, Remark, IsForwarded));
        }
        [HttpPost]
        public HttpResponseMessage TakeActionOnOutingBulkApprove(string RequestID, string UserAbrhs, string Status, string Remark)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.TakeActionOnOutingBulkApprove(RequestID, UserAbrhs, Status, Remark));
        }
        [HttpPost]
        public HttpResponseMessage TakeActionOnLWPChangeBulkApprove(string RequestID, string UserAbrhs, string Status, string Remark)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.TakeActionOnLWPChangeBulkApprove(RequestID, UserAbrhs, Status, Remark));
        }
        [HttpPost]
        public HttpResponseMessage TakeActionOnDataChangeBulkApprove(string RequestID, string UserAbrhs, string Status, string Remark)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.TakeActionOnDataChangeBulkApprove(RequestID, UserAbrhs, Status, Remark));
        }
        #endregion

        #region Weekly Roster
        [HttpPost]
        public HttpResponseMessage GetCalendarForWeekOff(int month, int year, string loginUserAbrhs, int type = 0)
        {
            // var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.GetCalendarForWeekOff(loginUserAbrhs, month, year, type));
        }
        [HttpPost]
        public HttpResponseMessage AddWeekOffForEmployees(string userAbrhs, string dateIds, string loginUserAbrhs, int type = 0)
        {
            //var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.AddWeekOffForEmployees(userAbrhs, dateIds, loginUserAbrhs, type));
        }
        [HttpPost]
        public HttpResponseMessage GetWeekOffMarkedEmployeesInfo(string dateIds, string loginUserAbrhs, int type = 0)
        {
            //var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.GetWeekOffMarkedEmployeesInfo(dateIds, loginUserAbrhs, type));
        }
        [HttpPost]
        public HttpResponseMessage GetEligibleEmployeesReportingToUser(string dateIds, string loginUserAbrhs, int type = 0)
        {
            //var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.GetEligibleEmployeesReportingToUser(dateIds, loginUserAbrhs, type));
        }
        [HttpPost]
        public HttpResponseMessage BulkRemoveMarkedWeekOffUsers(string dateIds, string empIds, string loginUserAbrhs)
        {
            //var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _leaveMgmtServices.BulkRemoveMarkedWeekOffUsers(dateIds, empIds, loginUserAbrhs));
        }
        #endregion

    }
}
