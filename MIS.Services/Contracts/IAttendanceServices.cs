using MIS.BO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MIS.Services.Contracts
{
    public interface IAttendanceServices
    {
        List<EmployeeInfo> GetSupportingStaffMembers(string userAbrhs);

        List<AttendanceData> GetAttendanceRegisterForSupportingStaffMembers(string fromDate, string tillDate, string EmpAbrhs, string userAbrhs);

        #region Employee Attendance

        List<BO.LockedUserDetail> GetDepartmentOnReportToBasis(string userAbrhs, string menuAbrhs);

        List<BO.LockedUserDetail> GetEmployeeForAttendanceOnReportToBasis(string date, int departmentId, string userAbrhs);

        List<AttendanceData> ProcessEmployeeAttendance(string fromDate, string tillDate, int departmentId, int forEmployeeId, string userAbrhs);

        List<AttendanceSummary> GetAttendanceSummary(DateTime fromDate, DateTime endDate, string empAbrhs, string reportToAbrhs, string departmentIds);

        List<AttendanceData> GetAttendanceForEmployees(string fromDate, string tillDate, string empAbrhs, string departmentIds, string locationIds, string userAbrhs);

        List<UsersPunchInOutLogBO> GetPunchInOutLog(string empAbrhs, string attendanceDate);

        List<AccessCardDataBO> GetAllAccessCard(string cardType);

        List<UsersPunchInOutLogBO> GetPunchInOutLogForAllCard(string accessCardNo, string fromDate, string tillDate);

        List<UsersPunchInOutLogBO> GetPunchInOutLogForTempCard(string empAbrhs, string accessCardNo, string attendanceDate);
       
        List<UsersPunchInOutLogBO> GetPunchInOutLogForStaff(string empAbrhs, string attendanceDate);

        #endregion

        #region ASquare Attendance Service

        AddUpdateReturnBO AddAttendance(List<AttendanceBO> attendanceBOList, int deviceId, string userAbrhs);

        List<AttendanceUpdateBO> GetAttendanceUpload(DateTime FromDate, DateTime ToDate);

        List<AttendanceDetailBO> GetDetailAttendance(long AttendaceId);

        #endregion
    }
}
