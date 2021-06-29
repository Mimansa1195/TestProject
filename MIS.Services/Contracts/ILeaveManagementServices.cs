using System;
using System.Collections.Generic;
using MIS.BO;
namespace MIS.Services.Contracts
{
    public interface ILeaveManagementServices
    {

        #region Approver Remarks

        string GetApproverRemarks(long requestId, string type);

        #endregion

        #region Leave Review

        List<LeaveBO> GetLeaves(string userAbrhs, string Status, int year);

        LeaveBO GetLeaveApplicationByApplicationID(int ApplicationID);

        string TakeActionOnLeave(int RequestID, string userAbrhs, string Status, String Remark, string ForwardedAbrhs);

        #endregion

        #region Comp-Off

        List<RequestForCompOffBO> GetCompOffRequest(string userAbrhs, string Status, int year);

        List<DatesToRequestCompOffOrWfhBO> FetchDatesToRequestCompOff(string userAbrhs);

        bool RequestForCompOff(string date, int days, string reason, string userAbrhs);

        string TakeActionOnCompOff(int RequestID, string userAbrhs, string Status, String Remark);

        #endregion

        #region WorkFromHome
        List<RequestForWorkFromHomeBO> GetWFHRequest(string userAbrhs, string Status, int year);

        List<DatesToRequestCompOffOrWfhBO> FetchDatesToRequestWorkFromHome(string userAbrhs);

        string TakeActionOnWFH(int RequestID, string userAbrhs, string Status, string Remark, bool IsForwarded);

        //For outing request

        int ApplyOutingRequest(ApplyOutingRequestDetailBO input);

        int TakeActionOnOutingRequest(int OutingRequestId, string UserAbrhs, string Status, string Remark);

        List<OutingTypeBo> GetOutingType(bool checkEligibility);

        List<OutingRequestBO> ListApplyOutingRequest(string employeeAbrhs, int year);

        List<OutingRequestGetDateBo> GetDateToCancelOutingRequest(int OutingRequestId);

        string CancelOutingRequest(int outingRequestId, string userAbrhs, string statusCode, string remark, long outingRequestDetailId);

        string CancelAllOutingRequest(int OutingRequestId, string UserAbrhs, string Status, string Remark);

        List<RequestForReviewOutingBO> GetOutingReviewRequest(string userAbrhs, int year);

        //End  of outing request
        List<RequestForLegititmateBO> GetLegitimateRequest(string userAbrhs, int year);

        int RequestForWorkForHome(string date, string reason, bool isFirstHalfWfh, bool isLastHalfWfh, string mobileNo, string userAbrhs, int loginUserId);

        #endregion

        int TakeActionOnLegitimateRequest(int RequestId, string UserAbrhs, string Status, string Remark);

        #region Dashboard

        List<DataForAttendanceBO> FetchEmployeeAttendance(int userId, int year, int month);

        DataForLeaveBalanceBO ListLeaveBalanceByUserId(string employeeAbrhs);

        List<DataForLeaveBalanceBO> ListLeaveBalanceForAllUser(string employeeAbrhs);

        List<DataForAttendanceBO> FetchAllEmployeesAttendance(string date);

        EmployeeStatusDataForManagerBO FetchEmployeeAttendanceForToday(int userId);

        List<EmployeeStatusDataForManagerBO> FetchEmployeeStatusForManager(int userId, string date);

        List<RawDataForPunchTimingBO> FetchAllEmployeesRawAttendanceData(string date);

        #endregion

        #region Apply Leave

        int ApplyLeave(ApplyLeaveDetailBO newLeave); //1:date collision,2:no combination present,3:combination supplied is invalid,4:success,0:failure,5:data supplied is incorrect

        int SubmitLegitimateLeave(string employeeAbrhs, string userAbrhs, string fromDate, string type, string reason, int leaveId);

        LastRecordDetailBO GetLastRecordDetails(string type, string userAbrhs);

        DaysOnBasisOfLeavePeriodBO FetchDaysOnBasisOfLeavePeriod(string fromDate, string toDate, int leaveIdToBeCancelled, string userAbrhs);

        List<AvailableLeavesBO> FetchAvailableLeaves(double NoOfWorkingDays, long leaveApplicationId, string userAbrhs, int totalDays);

        List<LeavesBO> AvailableLeaveForLegitimate(double NoOfWorkingDays, long leaveApplicationId, string userAbrhs);

        int CancelLeave(long leaveApplicationId, string remarks, string userAbrhs, bool isCancelByHR, string forLeaveType, string type);

        #endregion

        #region DataChange Request

        List<RequestDataChangeBO> FetchDateForDataChange(string category, string userAbrhs);

        List<DataChangeRequestApplicationBO> GetDataChangeRequest(string userAbrhs, string Status, int year);

        bool InsertRequestForDataChange(string type, int recordId, string reason, string userAbrhs);

        string TakeActionOnDataChangeRequest(RequestDataChangeBO requestDataChange);

        List<LWPMarkedBySystemData> ListLWPMarkedBySystemByUserId(int userId);

        #endregion

        #region UpdateLeave

        List<DataForLeaveManagementBO> ListAvailedLeaveByUserId(string employeeAbrhs, int year);

        bool UpdateLeaveBalanceByHR(int type, string employeeAbrhs, double ClCount, double PlCount, double CompOffCount, double LwpCount, string Cloy, double mLCount, int allocationCount, string userAbrhs);

        int SubmitAdvanceLeave(string employeeAbrhs, string fromDate, string tillDate, string reason, int loginUserId);

        List<LnsaDateBO> GetDatesToCancelAdvanceLeave(long leaveId);

        #endregion

        #region Update Attendance

        List<AttendanceStatusDataBO> LoadRemarks();

        EmployeeAttendanceDetailsBO GetEmployeeAttendanceDetails(string employeeAbrhs, string date);

        bool UpdateEmployeeAttendanceDetails(string employeeAbrhs, long attendanceId, string inTime, string outTime, int statusId, string remarks, string userAbrhs);

        #endregion

        #region Status /History

        List<DataForLeaveManagementBO> ListLeaveByUserId(string userAbrhs, int year);
        List<DataForLeaveManagementBO> ListLegitimatetByUserId(string userAbrhs, int year);

        List<DataForLeaveManagementBO> ListWorkFromHomeByUserId(string userAbrhs, int year);

        List<DataForLeaveManagementBO> ListCompOffByUserId(string userAbrhs, int year);

        List<DataForLeaveManagementBO> ListDataChangeRequestByUserId(string userAbrhs, int year);

        #endregion

        #region View Attendance

        //List<LockedUserDetailBO> GetDepartmentOnReportToBasis(int userId);

        List<LockedUserDetailBO> GetEmployeeForAttendanceOnReportToBasis(string date, int departmentId, int userId);

        List<AttendanceDataBO> ProcessEmployeeAttendance(string fromDate, string tillDate, int departmentId, int forEmployeeId, int userId);

        #endregion

        #region Bulk Approve

        string TakeActionOnLeaveBulkApprove(string RequestID, string userAbrhs, string Status, String Remark, string ForwardedAbrhs);

        string TakeActionOnCompOffBulkApprove(string RequestID, string userAbrhs, string Status, String Remark);

        string TakeActionOnWFHBulkApprove(string RequestID, string userAbrhs, string Status, string Remark, bool IsForwarded);

        BulkApproveResponseList TakeActionOnOutingBulkApprove(string RequestID, string Userabrhs, string Status, String Remark);

        string TakeActionOnLWPChangeBulkApprove(string RequestID, string Userabrhs, string Status, String Remark);

        string TakeActionOnDataChangeBulkApprove(string RequestID, string userAbrhs, string Status, String Remark);

        #endregion
        #region Weekly Roster

        WeekOffCalenderBO GetCalendarForWeekOff(string userAbrhs, int month, int year, int type = 0);

        int AddWeekOffForEmployees(string userAbrhs, string dateIds, string loginUserAbrhs, int type=0);

        List<WeekOffUserDetails> GetWeekOffMarkedEmployeesInfo(string dateIds, string loginUserAbrhs, int type = 0);

        List<EmployeeBO> GetEligibleEmployeesReportingToUser(string dateIds, string userAbrhs, int type = 0);

        int BulkRemoveMarkedWeekOffUsers(string dateIds, string userAbrhs, string loginAbrhs);

        #endregion

    }
}
