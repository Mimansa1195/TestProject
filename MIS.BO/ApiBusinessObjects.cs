using System.Collections.Generic;
using System;
using System.Net;

namespace MIS.BO
{
    #region Common BOs

    public class EmployeeBO
    {
        public string EmployeeAbrhs { get; set; }
        public string EmployeeName { get; set; }
        public string EmployeeCode { get; set; }
        public int EmployeeId { get; set; }
        public string StaffAbrhs { get; set; }
        public string StaffName { get; set; }
        public string JoiningDate { get; set; }
        public int ProbationPeriod { get; set; }
    }

    public class UserSkillSet
    {
        public string EmployeeName { get; set; }
        public string EmailId { get; set; }
        public string Skills { get; set; }
    }

    public class CommonEntitiesBO
    {
        public long Id { get; set; }
        public string EntityName { get; set; }
        public string EntityAbrhs { get; set; }
    }

    public class RoleBO
    {
        public string RoleAbrhs { get; set; }
        public string RoleName { get; set; }
    }

    public class DepartmentBO
    {
        public string DepartmentAbrhs { get; set; }
        public string DepartmentName { get; set; }
    }

    public class ControllerBO
    {
        public int MenuId { get; set; }
        public string ControllerName { get; set; }
    }

    public class DesignationBO
    {
        public string DesignationAbrhs { get; set; }
        public string DesignationName { get; set; }
    }

    public class WeekAndDatesBO
    {
        public string WeekDateString { get; set; }
        public string NewStartDate { get; set; }
        public string NewEndDate { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }

        public int? StartDateId { get; set; }
        public int? EndDateId { get; set; }
        public int? WeekNo { get; set; }
        public int? CurrentWeekNo { get; set; }
    }

    public class WeekInfoBO
    {
        public long DateId { get; set; }
        public DateTime Date { get; set; }
        public string Day { get; set; }
    }
    #endregion

    #region Error Log
    public class ErrorLogBO
    {
        public int? ErrorId { get; set; }
        public string ModuleName { get; set; }
        public string Source { get; set; }
        public string ControllerName { get; set; }
        public string ActionName { get; set; }
        public string ErrorType { get; set; }
        public string ErrorMessage { get; set; }
        public string TargetSite { get; set; }
        public string StackTrace { get; set; }
        public int? ReportedByUserId { get; set; }
        public DateTime? CreatedDate { get; set; }
    }
    #endregion

    #region Request BO
    public class RequestBO
    {
        public RequestBO()
        {
            this.UserAbrhs = string.Empty;
            this.LoginUserId = default(int);
            this.Token = string.Empty;
        }
        public string UserAbrhs { get; set; }
        public int LoginUserId { get; set; }
        public string Token { get; set; }
    }
    #endregion

    #region Response BO
    public class ResponseBO<T>
    {
        public ResponseBO()
        {

        }
        public bool IsSuccessful { get; set; }
        public ResponseStatus Status { get; set; }
        public HttpStatusCode StatusCode { get; set; }
        public string Message { get; set; }
        public T Result { get; set; }
    }
    #endregion

    #region LDAP
    public class LDAPUserBO
    {

        public LDAPUserBO()
        {
            ADUsername = string.Empty;
            DisplayName = string.Empty;
            EmailId = string.Empty;

        }
        public string ADUsername { get; set; }
        public string DisplayName { get; set; }
        public string EmailId { get; set; }
    }
    #endregion

    #region Token Entities
    public class TokenBO
    {
        public int TokenId { get; set; }
        public int UserId { get; set; }
        public string AuthToken { get; set; }
        public System.DateTime IssuedOn { get; set; }
        public System.DateTime ExpiresOn { get; set; }
        public bool IsActive { get; set; }
        public DateTime LastActivityDate { get; set; }
    }

    public class APIPermissionBO
    {
        public int APIId { get; set; }
        public string ControllerName { get; set; }
        public string ActionName { get; set; }
        public string EndPoint { get; set; }
        public string Verb { get; set; }
        public bool IsAllowed { get; set; }
    }
    #endregion

    #region Menu Entities

    public class NavigationMenuBO
    {
        public string MenuName { get; set; }
        public string ActionName { get; set; }

        public string ControllerName { get; set; }
        public int Sequence { get; set; }
        public bool IsLinkEnabled { get; set; }
        public bool IsMenuVisible { get; set; }
        public string CssClass { get; set; }
        public bool IsDelegatable { get; set; }
        public bool IsTabMenu { get; set; }
        public string UserAbrhs { get; set; }
    }

    public class MenuBO
    {
        public int MenuId { get; set; }
        public string MenuName { get; set; }
        public int ParentMenuId { get; set; }
        public string ControllerName { get; set; }
        public string ActionName { get; set; }
        public int Sequence { get; set; }
        public bool IsLinkEnabled { get; set; }
        public bool IsMenuVisible { get; set; }
        public bool IsActive { get; set; }
        public string CssClass { get; set; }
        public bool IsDelegatable { get; set; }
        public bool IsTabMenu { get; set; }
        public string CreatedDate { get; set; }
        public string UserAbrhs { get; set; }
    }


    public class MenuPermissionBO
    {
        public int MenuPermissionId { get; set; }
        public int MenuId { get; set; }
        public int RoleId { get; set; }
        public bool IsViewRights { get; set; }
        public bool IsAddRights { get; set; }
        public bool IsModifyRights { get; set; }
        public bool IsDeleteRights { get; set; }
        public bool IsAssignRights { get; set; }
        public bool IsApproveRights { get; set; }
        public bool IsActive { get; set; }
    }

    public class UsersMenuBO
    {
        //public int MenuId { get; set; }
        public string MenuAbrhs { get; set; }
        public string MenuName { get; set; }
        //public int ParentMenuId { get; set; }
        public bool IsParentMenu { get; set; }
        public string ParentMenuAbrhs { get; set; }
        public string ControllerName { get; set; }
        public string ActionName { get; set; }
        public int Sequence { get; set; }
        public bool IsLinkEnabled { get; set; }
        public bool IsTabMenu { get; set; }
        public bool IsViewRights { get; set; }
        public bool IsAddRights { get; set; }
        public bool IsModifyRights { get; set; }
        public bool IsDeleteRights { get; set; }
        public bool IsAssignRights { get; set; }
        public bool IsApproveRights { get; set; }
        public bool IsDelegatable { get; set; }
        public bool IsDelegated { get; set; }
        public bool IsVisible { get; set; }
        public string CssClass { get; set; }
        public bool IsTaskPending { get; set; }
    }

    public class UserAndRoleMenusPermissionBO
    {
        public int? MenuPermissionId { get; set; }
        public int MenuId { get; set; }
        public string MenuName { get; set; }
        public int? ParentMenuId { get; set; }
        public string ControllerName { get; set; }
        public string ActionName { get; set; }
        public int? Sequence { get; set; }
        public bool? IsLinkEnabled { get; set; }
        public bool? IsViewRights { get; set; }
        public bool? IsAddRights { get; set; }
        public bool? IsModifyRights { get; set; }
        public bool? IsDeleteRights { get; set; }
        public bool? IsAssignRights { get; set; }
        public bool? IsApproveRights { get; set; }
        public bool? IsVisible { get; set; }
        public string CssClass { get; set; }
        public bool? IsActive { get; set; }
    }

    public class ManageMenusPermissionBO
    {
        public ManageMenusPermissionBO()
        {
            this.MenuPermission = new List<UserAndRoleMenusPermissionBO>();
        }
        public bool IsUserPermission { get; set; }
        public string UserAbrhs { get; set; }
        public string EmployeeAbrhs { get; set; }
        public string RoleAbrhs { get; set; }
        public virtual IList<UserAndRoleMenusPermissionBO> MenuPermission { get; set; }
    }
    #endregion

    #region Scheduler Entities
    public class SchedulerActionBO
    {
        public long ActionId { get; set; }
        public string SchedulerName { get; set; }
        public string Description { get; set; }
        public string FunctionName { get; set; }
        public int RepeatAfterPeriod { get; set; }
        public string RepeatAfterType { get; set; }
        public string LastRunTime { get; set; }
        public string LastRunResult { get; set; }
        public string NextRunTime { get; set; }
        public string NextRunResult { get; set; }
        public string RunFor { get; set; }
        public string Ids { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public bool IsCombinedEmail { get; set; }
        public string UserAbrhs { get; set; }
    }
    public class IdBO
    {
        public string UserAbrhs { get; set; }
    }
    #endregion

    #region Dashboard Widget Entities
    //public class DashboardWidgetBO
    //{

    //}

    //public class DashboardWidgetPermissionBO
    //{

    //}

    //public class UsersDashboardWidgetBO
    //{

    //}

    public class UserAndRoleDashboardWidgetPermissionBO
    {
        public int? WidgetPermissionId { get; set; }
        public int WidgetId { get; set; }
        public string WidgetName { get; set; }
        public int? Sequence { get; set; }
        public bool? IsViewRights { get; set; }
        public bool? IsActive { get; set; }
    }

    public class ManageDashboardWidgetPermissionBO
    {
        public ManageDashboardWidgetPermissionBO()
        {
            this.WidgetPermission = new List<UserAndRoleDashboardWidgetPermissionBO>();
        }
        public bool IsUserPermission { get; set; }
        public string UserAbrhs { get; set; }
        public string EmployeeAbrhs { get; set; }
        public string RoleAbrhs { get; set; }
        public virtual IList<UserAndRoleDashboardWidgetPermissionBO> WidgetPermission { get; set; }
    }
    #endregion

    #region DashBoard Settings

    public class ManageDashBoardSettingsBO
    {
        public ManageDashBoardSettingsBO()
        {
            this.DashBoardSetting = new List<UserAndRoleDashBoardSettingsBO>();
        }
        public bool IsUserPermission { get; set; }
        public string UserAbrhs { get; set; }
        public string RoleAbrhs { get; set; }
        public virtual IList<UserAndRoleDashBoardSettingsBO> DashBoardSetting { get; set; }
        public List<int> SequenceList { get; set; }
    }

    public class UserAndRoleDashBoardSettingsBO
    {
        public int DashboardWidgetId { get; set; }
        public int Sequence { get; set; }
        public bool IsActive { get; set; }
        public string DashboardWidgetName { get; set; }
        public int DashboardWidgetPermissionId { get; set; }
    }

    public class UserDashBoardSettingsListBO
    {
        public UserDashBoardSettingsListBO()
        {
            this.DashBoardSetting = new List<UserDashBoardSettingsBO>();
        }
        public bool IsUserPermission { get; set; }
        public string UserAbrhs { get; set; }
        public string RoleAbrhs { get; set; }
        public virtual IList<UserDashBoardSettingsBO> DashBoardSetting { get; set; }
        public List<int> SequenceList { get; set; }
    }

    public class UserDashBoardSettingsBO
    {
        public int? DashboardWidgetId { get; set; }
        public int? Sequence { get; set; }
        public bool? IsActive { get; set; }
        public string DashboardWidgetName { get; set; }
        public int? DashboardWidgetPermissionId { get; set; }
        public List<int> SequenceList { get; set; }
        public string UserAbrhs { get; set; }
        public bool IsReferral { get; set; }
        public bool IsTraining { get; set; }
    }

    #endregion

    #region Users Entities

    public class AuthenticateUserBO
    {
        public AuthenticateUserBO()
        {
            this.Menus = new List<UsersMenuBO>();
        }
        public bool IsAuthenticated { get; set; }
        public string UserAbrhs { get; set; }
        public string UserName { get; set; }
        public string DisplayName { get; set; }
        public int RoleId { get; set; }
        public string Role { get; set; }
        public int CompanyId { get; set; }
        public string Company { get; set; }
        public int CompanyLocationId { get; set; }
        public string CompanyLocation { get; set; }
        public int CountryId { get; set; }
        public int StateId { get; set; }
        public int CityId { get; set; }
        public int CurrentAppraisalCycleId { get; set; }
        public int GoalCycleId { get; set; }
        public string FYEndDate { get; set; }
        public string FYStartDate { get; set; }
        public int FYStartYear { get; set; }
        public int CurrentQuarter { get; set; }
        public string ImagePath { get; set; }
        public string AppVersion { get; set; }
        public virtual List<UsersMenuBO> Menus { get; set; }
    }

    #endregion

    #region Employee Directory

    public class EmployeeDirectoryBO
    {
        //public int UserId { get; set; }
        public string EmployeeName { get; set; }
        public string EmailId { get; set; }
        public string Designation { get; set; }
        public string Department { get; set; }
        public string MobileNumber { get; set; }
        public string Extension { get; set; }
        // public string EmpAbrhs { get; set; }
        public string Location { get; set; }
        public string WsNo { get; set; }
        public string JoiningDate { get; set; }
        public string Team { get; set; }
        public string ReportingManager { get; set; }
        public string ImagePath { get; set; }
        //public bool IsUserMe { get; set; }
    }

    #endregion

    #region Employee Profile

    public class EmployeeProfileBO
    {
        public EmployeeProfileBO()
        {
            this.ReportingManager = "NA";
        }
        public string EmployeeName { get; set; }
        public string EmailId { get; set; }
        public string Designation { get; set; }
        public string Department { get; set; }
        public string MobileNumber { get; set; }
        public string Extension { get; set; }

        public string Role { get; set; }
        public string SeatNo { get; set; }
        public string DOJ { get; set; }
        public string EmployeeCode { get; set; }
        public string BloodGroup { get; set; }
        public string Hobbies { get; set; }
        public string ImageName { get; set; }
        public string ReportingManager { get; set; }
        public string Team { get; set; }

        public List<Skills> SkillList { get; set; }
    }

    public class EmployeeUpdateProfileBO
    {

        public string MobileNumber { get; set; }
        public string Extension { get; set; }
        public string ImageName { get; set; }
        public string UserAbrhs { get; set; }
        public string base64FormData { get; set; }
        public bool? IsVerified { get; set; }
        public int CountryId { get; set; }
        public int StateId { get; set; }
        public int CityId { get; set; }
        public string Address { get; set; }
        public string PinCode { get; set; }
        public string AppLinkUrl { get; set; }
    }

    public class Skills
    {
        public string SkillName { get; set; }
    }

    #endregion

    #region Health Insurance
    public class HealthInsurance
    {
        public string fileName { get; set; }
        public string link { get; set; }
    }

    #endregion

    #region LNSA

    public class LnsaDataBO
    {
        public long RequestId { get; set; }
        public string EmployeeName { get; set; }
        public string Reason { get; set; }
        public string FromDate { get; set; }
        public string TillDate { get; set; }
        public int NoOfDays { get; set; }
        public string ApproverRemarks { get; set; }
        public string Status { get; set; }
        public string StatusCode { get; set; }
        public string ApplyDate { get; set; }
        public bool IsCancellable { get; set; }
    }
    public class LnsaShiftBO
    {
        public long TempUserShiftId { get; set; }
        public string EmployeeName { get; set; }
        public string CreatedDate { get; set; }
        public string ApproverRemarks { get; set; }
        public string Status { get; set; }
        public string StatusCode { get; set; }
        public bool IsCancellable { get; set; }
        public string UserType { get; set; }
    }

    public class LnsaDateBO
    {
        public long DateId { get; set; }
        public long LnsaRequestDetailId { get; set; }
        public string Date { get; set; }
        public bool IsCancellable { get; set; }
        public string Status { get; set; }
        public bool IsCancellableAfterApproval { get; set; }
    }
    public class ShiftMappingCalenderBO
    {
        public ShiftMappingDetailsBO ShiftMappingDetails { get; set; }
    }
    public class ShiftMappingDetailsBO
    {
        public string ShiftName { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public string ShiftMappingStartDate { get; set; }
        public string ShiftMappingEndDate { get; set; }
        public bool IsSubmitBtnActive { get; set; }
        public List<WeekDetailsBO> WeekDetails { get; set; }
        public bool IsCurrentMonthYear { get; set; }
    }
    public class WeekDetailsBO
    {
        public long WeekNo { get; set; }
        public List<WeeksBO> Weeks { get; set; }
    }
    public class WeeksBO
    {
        public long DateId { get; set; }
        public string Day { get; set; }
        public int MonthDate { get; set; }
        public string Month { get; set; }
        public int Year { get; set; }
        public string Date { get; set; }
        public bool IsApplied { get; set; }
        public bool IsApproved { get; set; }
        public bool IsEligible { get; set; }
    }
    public class WeekOffCalenderBO
    {
        public WeekOffCalenderDetailsBO WeekOffDetails { get; set; }
    }
    public class WeekOffCalenderDetailsBO
    {
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public string CurrentMonthYear { get; set; }
        public int ActiveMonth { get; set; }
        public int ActiveYear { get; set; }
        public List<WeekOffDetailsBO> WeekDetails { get; set; }
        public bool IsMonthDisabled { get; set; }
        // public List<ReporteesDetails> ReporteesDetail { get; set; }
    }
    public class WeekOffDetailsBO
    {
        public long WeekNo { get; set; }
        public List<WeeksOffBO> Weeks { get; set; }
    }
    public class WeeksOffBO
    {
        public long DateId { get; set; }
        public string Day { get; set; }
        public int MonthDate { get; set; }
        public string Month { get; set; }
        public int Year { get; set; }
        public string Date { get; set; }
        public bool IsCurrentMonth { get; set; }
        public List<WeekOffUserDetails> UserWeekOffDetails { get; set; }
    }
    public class WeekOffUserDetails
    {
        public string UserAbrhs { get; set; }
        public string EmployeeName { get; set; }
        public string ImageUrl { get; set; }
        public List<WeekOffDateDetails> DateDetails { get; set; }
    }
    public class WeekOffDateDetails
    {
        public long DateIds { get; set; }
        public string Date { get; set; }
        public bool IsMarked { get; set; }
    }
    public class WeekOffDateDetailsOnDashboard
    {
        public long DateId { get; set; }
        public string Date { get; set; }
        public bool IsWeekOff { get; set; }
        public bool IsNightShift { get; set; }
        public bool IsHoliday { get; set; }
        public bool OnLeave { get; set; }
        public string LeaveType { get; set; }
        public string DateFormat { get; set; }
        public string WorkingHrs { get; set; }
        public string TimesheetHrs { get; set; }
    }
    #endregion

    #region Leave Management

    #region Leave Review

    public class LeaveBO
    {
        public string LeaveType { get; set; }
        public string Department { get; set; }
        public string EmployeeName { get; set; }
        public string Status { get; set; }
        public string StatusCode { get; set; }
        public string FromDate { get; set; }
        public string ToDate { get; set; }
        public long LeaveApplicationId { get; set; }
        public int UserId { get; set; }
        public long FromDateId { get; set; }
        public long TillDateId { get; set; }
        public double NoOfTotalDays { get; set; }
        public double NoOfWorkingDays { get; set; }
        public string Reason { get; set; }
        public string PrimaryContactNo { get; set; }
        public string AlternativeContactNo { get; set; }
        public bool IsAvailableOnMobile { get; set; }
        public bool IsAvailableOnEmail { get; set; }
        public long StatusId { get; set; }
        public int? ApproverId { get; set; }
        public string ApproverRemarks { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public int ApplicantID { get; set; }
        public string CancelDisabled { get; set; }

        public int? LastModifiedBy { get; set; }
        public string ApplicantAbrhs { get; set; }
    }

    #endregion

    #region Import shift and attendance

    public class EmployeeShiftMappingErrorDataBO
    {
        public string EmployeeName { get; set; }
        public string ShiftName { get; set; }
        public string Remarks { get; set; }
        public string Date { get; set; }
    }

    public class AttendanceStatusDataBO
    {
        public string Remarks { get; set; }
        public long AttendanceStatusId { get; set; }
    }

    public class EmployeeAttendanceDetailsBO
    {
        public long EmployeeId { get; set; }
        public string InTime { get; set; }
        public string OutTime { get; set; }
        public long AttendanceId { get; set; }
        public string Remarks { get; set; }
        public string StatusRemarks { get; set; }
        public long StatusId { get; set; }
        public long HrId { get; set; }
    }

    #endregion

    #region Apply Leave

    public class ApplyLeaveDetailBO //: LeaveRequestApplication
    {
        public string UserAbrhs { get; set; }
        public string EmployeeAbrhs { get; set; }
        public DateTime FromDate { get; set; }
        public DateTime TillDate { get; set; }
        public string Reason { get; set; }
        //public double NoOfTotalDays { get; set; }
        //public double NoOfWorkingDays { get; set; }
        public string SelectedLeaveCombination { get; set; }
        public string PrimaryContactNo { get; set; }
        public string AlternativeContactNo { get; set; }
        public bool IsAvailableOnMobile { get; set; }
        public bool IsAvailableOnEmail { get; set; }
        //public string LeaveType { get; set; }
        //public double LeaveCount { get; set; }
        //public bool IsLwp { get; set; }
        //public double LwpCount { get; set; }
        public bool IsFirstDayHalfDayLeave { get; set; }
        public bool IsLastDayHalfDayLeave { get; set; }
    }

    public class LastRecordDetailBO
    {
        public string PrimaryContactNo { get; set; }
        public string AlternativeContactNo { get; set; }
        public string Name { get; set; }
        public string RMName { get; set; }
    }

    #endregion

    #region comp-off and WorkForHome

    public class RequestForCompOffBO
    {
        public long RequestID { get; set; }
        public string EmployeeName { get; set; }
        public string Status { get; set; }
        public DateTime? Date { get; set; }
        public string CompOffDate { get; set; }
        public DateTime CreatedDate { get; set; }
        public int NoOfDays { get; set; }
        public string Reason { get; set; }
        public string Remark { get; set; }
        public int UserId { get; set; }
        public int StatusID { get; set; }
        public int? LastModifiedByID { get; set; }
    }

    public class RequestForWorkFromHomeBO
    {
        public int RequestID { get; set; }
        public int StatusID { get; set; }
        public string EmployeeName { get; set; }
        public string WFHDate { get; set; }
        public string Remark { get; set; }
        public string Status { get; set; }
        public DateTime? Date { get; set; }
        public string Reason { get; set; }
        public int UserId { get; set; }
        public string UserAbrhs { get; set; }
        public int LastModifiedByID { get; set; }
        public string MobileNo { get; set; }
        public bool IsHalfDay { get; set; }
        public string CancelDisabled { get; set; }
        public DateTime CreatedDate { get; set; }
    }

    public class RequestForLegititmateBO
    {
        public int RequestId { get; set; }
        //public int StatusID { get; set; }
        public string EmployeeName { get; set; }
        public string Date { get; set; }
        public string Remarks { get; set; }
        public string Status { get; set; }
        public string StatusCode { get; set; }
        public string ApplyDate { get; set; }
        public string Reason { get; set; }
        public string LoginUserDesignation { get; set; }
        public string UserType { get; set; }
        public string LeaveInfo { get; set; }

    }

    //for outing request
    public class RequestForReviewOutingBO
    {
        public int OutingRequestId { get; set; }
        //public int StatusID { get; set; }
        public string EmployeeName { get; set; }
        public string Period { get; set; }
        public string Remarks { get; set; }
        public string Status { get; set; }
        public string StatusCode { get; set; }
        public string ApplyDate { get; set; }
        public string Reason { get; set; }
        public string LoginUserDesignation { get; set; }
        public string DutyType { get; set; }
        public string UserType { get; set; }

    }

    public class OutingTypeBo
    {
        public string OutingTypeName { get; set; }
        public int OutingTypeId { get; set; }
    }

    public class ApplyOutingRequestDetailBO //: LeaveRequestApplication
    {
        public string EmployeeAbrhs { get; set; }
        public string LoginUserAbrhs { get; set; }
        public DateTime FromDate { get; set; }
        public DateTime TillDate { get; set; }
        public string Reason { get; set; }
        public string PrimaryContactNo { get; set; }
        public string AlternativeContactNo { get; set; }
        public int OutingTypeId { get; set; }
    }
    public class BulkApproveResponseList
    {
        public string SuccessList { get; set; }
        public string ActionNotTaken { get; set; }
        public string ErrorList { get; set; }
    }

    public class OutingRequestBO
    {
        public String Period { get; set; }
        public String Reason { get; set; }
        public string Status { get; set; }
        public string Remarks { get; set; }
        public string ApplyDate { get; set; }
        public string OutingType { get; set; }
        public long OutingRequestId { get; set; }
        public bool IsCancellable { get; set; }
        public string StatusCode { get; set; }

    }

    public class OutingRequestGetDateBo
    {
        public DateTime OutingDate { get; set; }
        public string DisplayOutingDate { get; set; }
        public bool IsCancellable { get; set; }
        public long OutingRequestDetailId { get; set; }
        public string Status { get; set; }

    }

    public class DatesToRequestCompOffOrWfhBO
    {
        public long? DateId { get; set; }
        public string DateAndOcassion { get; set; }
    }

    public class DataForWorkFromHomeBO : LeaveRequestApplication
    {
        public int NoOfDays { get; set; }
        public string DisplayApplyDate { get; set; }
        public string DisplayWFHDate { get; set; }
        public string Status { get; set; }
        public string CancelDisabled { get; set; }
    }

    #endregion

    #region Dashboard

    public class DataForAttendanceBO
    {
        public int AttendanceId { get; set; }
        public string InTime { get; set; }
        public string OutTime { get; set; }
        public string WorkingHours { get; set; }
        public string DisplayDate { get; set; }
        public string Day { get; set; }
        public string Remarks { get; set; }
        public string Status { get; set; }
        public string UserName { get; set; }
    }

    public class DataForLeaveBalanceBO
    {
        public double? ClCount { get; set; }
        public double? PlCount { get; set; }
        public double? CompOffCount { get; set; }
        public double? LwpCount { get; set; }
        public double? MlCount { get; set; }
        public double? ELCount { get; set; }
        public double? PlmCount { get; set; }
        public string CloyAvailable { get; set; }
        public string IsEligibleForLeave { get; set; }
        public string IsTechnicalTrainee { get; set; }
        public string Name { get; set; }
        public int? UserId { get; set; }
        public bool IsBioPageFilled { get; set; }
        public string EmployeeAbrhs { get; set; }
        public int GenderId { get; set; }
        public int AllocationCount { get; set; }
    }

    public class EmployeeStatusDataForManagerBO
    {
        public string Name { get; set; }
        public string InTime { get; set; }
        public string OutTime { get; set; }
        public string WorkingHours { get; set; }
        public string YesterdayWorkingHours { get; set; }
        public string Status { get; set; }
        public string Reason { get; set; }
    }

    public class RawDataForPunchTimingBO
    {
        public long? UserId { get; set; }
        public string Name { get; set; }
        public string Day { get; set; }
        public string PunchTiming { get; set; }
    }

    public class DaysOnBasisOfLeavePeriodBO
    {
        public int? TotalDays { get; set; }
        public int? WorkingDays { get; set; }
        public string Status { get; set; }
        public string Date { get; set; }
    }

    public class AvailableLeavesBO
    {
        public int? LeaveTypeId { get; set; }
        public bool? IsSpecial { get; set; }
        public string LeaveCombination { get; set; }
    }
    public class LeavesBO
    {
        public string LeaveCombination { get; set; }
    }

    #endregion

    #region Data Change Request

    public class RequestDataChangeBO
    {
        public String Period { get; set; }
        public long? Id { get; set; }
        public string Type { get; set; }
        public string Reason { get; set; }
        public string Status { get; set; }
        public string Remarks { get; set; }
        public string UserAbrhs { get; set; }
    }

    public class DataChangeRequestApplicationBO
    {
        public long DataChangeRequestApplicationId { get; set; }
        public string EmployeeName { get; set; }
        public string Category { get; set; }
        public string ChangePeriod { get; set; }
        public string Reason { get; set; }
        public string Remarks { get; set; }
        public string Status { get; set; }
        public DateTime CreatedDate { get; set; }

    }
    public class LWPMarkedBySystemData
    {
        public string LeaveDate { get; set; }
        public long LeaveId { get; set; }
        public bool IsApplied { get; set; }
    }

    #endregion

    #region Update Leave

    public class DataForLeaveManagementBO
    {
        public string Remarks { get; set; }
        public double NoOfDays { get; set; }
        public long LeaveId { get; set; }
        public string DisplayApplyDate { get; set; }
        public string Reason { get; set; }
        public string DisplayFromDate { get; set; }
        public string DisplayTillDate { get; set; }
        public string LeaveType { get; set; }
        public string PrimaryContactNumber { get; set; }
        public string OtherContactNumber { get; set; }
        public string Status { get; set; }
        public string StatusCode { get; set; }
        public bool IsAvilableOnMobile { get; set; }
        public bool IsAvilableOnEmail { get; set; }
        public string CancelDisabled { get; set; }
        public bool IsHalfDay { get; set; }
        public string Category { get; set; }
        public bool IsLapsed { get; set; }
        public string LapseDate { get; set; }
        public int? AvailabilityStatus { get; set; }
        public long StatusId { get; set; }
        public string FromDate { get; set; }
        public string TillDate { get; set; }
        public bool IsValid { get; set; }
        public bool? IsApplied { get; set; }
        public string FetchLeaveType { get; set; }
        public string LWPChangeRequestAppliedOn { get; set; }
        public int CreatedBy { get; set; }
        public bool IsCancellable { get; set; }
        public string RemarksLeaveType { get; set; }
    }

    #endregion

    #region View Leave

    public class AttendanceDataBO
    {
        public string Date { get; set; }
        public string EmployeeName { get; set; }
        public string Department { get; set; }
        public string InTime { get; set; }
        public string OutTime { get; set; }
        public string LoggedInHours { get; set; }
    }

    #endregion

    #endregion

    #region Asset Allocation

    public class AssetRequestDetailBO
    {
        public int RequestId { get; set; }
        public int? UserId { get; set; }
        public DateTime? RequestDate { get; set; }
        public string RequiredAsset { get; set; }
        public string EmployeeName { get; set; }
        public string Status { get; set; }
        public string Comments { get; set; }
        public DateTime? IssueDate { get; set; }
        public DateTime? ReturnDue { get; set; }
        public string ReasonOfRequirement { get; set; }
        public int StatusId { get; set; }
        public bool isActive { get; set; }
        public bool isDeleted { get; set; }
        public int? LastUpdatedBy { get; set; }
        public int? ApproverId { get; set; }
        public DateTime? IssuedDate { get; set; }
        public string SerialNumber { get; set; }
        public string SimNumber { get; set; }
        public string OtherDetails { get; set; }
    }

    public class AssetDataBO
    {
        public int? StatusId { get; set; }
        public long RequestId { get; set; }
        public string EmployeeName { get; set; }
        public string Department { get; set; }
        public string ReportingManager { get; set; }
        public string Reason { get; set; }
        public string AssetTag { get; set; }
        public string Asset { get; set; }
        public string IssueFromDate { get; set; }
        public string ReturnDueDate { get; set; }
        public string AllocatedDate { get; set; }
        public string UserReturnDate { get; set; }
        public string Status { get; set; }
        public string StatusColour { get; set; }
    }

    public class DongleDetailBO
    {
        public long AssetDetailId { get; set; }
        public string SerialNumber { get; set; }
        public string SimNumber { get; set; }
        public string Make { get; set; }
        public string Model { get; set; }
        public bool? IsIssued { get; set; }
    }

    public class DongleReturnInfoBO
    {
        public long TransactionId { get; set; }
        public string EmployeeName { get; set; }
        public string AssetTag { get; set; }
        public string SerialNumber { get; set; }
        public string SimNumber { get; set; }
        public string ReturnDueDate { get; set; }
        public string IssueDate { get; set; }
    }

    public class AssetCountBO
    {
        public string AllotedToDepartment { get; set; }
        public string AllocatedToDepartment { get; set; }
        public string AllocatedToParentTeam { get; set; }
        public string AllocatedToSubTeam { get; set; }
        public double? DeptWisePercentageAllocation { get; set; }
    }

    public class AssetDetailBO
    {
        public long AssetTypeId { get; set; }
        public long AssetId { get; set; }
        public long AssetDetailId { get; set; }
        public int BrandId { get; set; }
        public string BrandName { get; set; }
        public string Make { get; set; }
        public string AssetType { get; set; }
        public string Model { get; set; }
        public string Description { get; set; }
        public string SerialNumber { get; set; }
        public string AssetTag { get; set; }
        public string AttributeType { get; set; }
        public string AttributeValue { get; set; }
        public string UserAbrhs { get; set; }
        public bool IsActive { get; set; }
        public string CreatedDate { get; set; }
        public string CreatedBy { get; set; }
        public string ModifiedOn { get; set; }
        public string ModifiedBy { get; set; }
        public bool IsFree { get; set; }
        public string AllocatedTo { get; set; }
        public string AllocatedOn { get; set; }
        public string DeAllocationRemarks { get; set; }
        public bool IsLost { get; set; }
    }
    public class AssetsBO
    {
        public string Assets { get; set; }
        public long AssetId { get; set; }
    }
    public class UserAssetDetail
    {
        public long AssetRequestId { get; set; }
        public string AssetRequestIds { get; set; }
        public long AssetId { get; set; }
        public string AssetIds { get; set; }
        public string AssetType { get; set; }
        public long AssetTypeId { get; set; }
        public string Model { get; set; }
        public string Brand { get; set; }
        public string UserAbrhs { get; set; }
        public string EmployeeName { get; set; }
        public string EmployeeCode { get; set; }
        public string Remarks { get; set; }
        public string SerialNo { get; set; }
        public string FromDate { get; set; }
        public string FromDateText { get; set; }
        public string TillDate { get; set; }
        public bool IsActive { get; set; }
        public string AssignedOn { get; set; }
        public string AssignedBy { get; set; }
        public string ModifiedOn { get; set; }
        public string ModifiedBy { get; set; }
        public string ActionCode { get; set; }
    }

    public class UserAssetRequest
    {
        public long AssetRequestId { get; set; }
        public long AssetId { get; set; }
        public string AssetType { get; set; }
        public long AssetTypeId { get; set; }
        public string Model { get; set; }
        public string Brand { get; set; }
        public string UserAbrhs { get; set; }
        public string EmployeeName { get; set; }
        public int AssetCount { get; set; }
        public string EmployeeCode { get; set; }
        public string Remarks { get; set; }
        public string Status { get; set; }
        public string SerialNo { get; set; }
        public string FromDate { get; set; }
        public string FromDateText { get; set; }
        public bool IsAssetLost { get; set; }
        public bool IsAssetClosed { get; set; }
        public string TillDate { get; set; }
        public bool IsActive { get; set; }
        public string AssignedOn { get; set; }
        public string AssignedBy { get; set; }
        public string ModifiedOn { get; set; }
        public string ModifiedBy { get; set; }
        public string CollectedOn { get; set; }
        public string CollectedBy { get; set; }
        public string DeAllocationRemarks { get; set; }
        public string ImagePath { get; set; }
        public List<AssetsSummary> GroupedAssets { get; set; }
        public bool HasAllocateRights { get; set; }
        public bool HasDeleteRights { get; set; }
        public bool HasViewRights { get; set; }
        public bool HasCollectRights { get; set; }
        public int UserId { get; set; }
    }


    public class AssetsSummary
    {
        public long AssetRequestId { get; set; }
        public long AssetId { get; set; }
        public string AssetType { get; set; }
        public long AssetTypeId { get; set; }
        public string Model { get; set; }
        public string Brand { get; set; }
        public string UserAbrhs { get; set; }
        public string EmployeeName { get; set; }
        public string EmployeeCode { get; set; }
        public string Remarks { get; set; }
        public string SerialNo { get; set; }
        public string FromDate { get; set; }
        public string FromDateText { get; set; }
        public string TillDate { get; set; }
        public bool IsActive { get; set; }
        public string AssignedOn { get; set; }
        public string AssignedBy { get; set; }
        public string ModifiedOn { get; set; }
        public string ModifiedBy { get; set; }
    }




    #endregion

    #region Form

    public class FormBO
    {
        public int FormId { get; set; }
        public string FormTitle { get; set; }
        public string Status { get; set; }
        public string FormName { get; set; }
        public string DepartmentName { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public string FilePath { get; set; }
    }

    public class UserFormBO
    {
        public string UserFormAbrhs { get; set; }
        public int FormId { get; set; }
        //public int UserId { get; set; }
        public string EmployeeAbrhs { get; set; }
        public string EmployeeName { get; set; }
        public string ActualFormName { get; set; }
        public string UsersFormName { get; set; }
        public string FormName { get; set; }
        public string FormPath { get; set; }
        public string Status { get; set; }
        public DateTime CreatedDate { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
    }

    #endregion

    #region Policy

    public class PolicyBO
    {
        public int PolicyId { get; set; }
        public string PolicyTitle { get; set; }
        public string Status { get; set; }
        public string PolicyName { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        //public string FilePath { get; set; }
    }

    #endregion

    #region Task Management

    public class TaskTeamBO
    {
        public long TaskTeamId { get; set; }
        public string TeamName { get; set; }
    }

    public class TaskTypeBO
    {
        public long TaskTypeId { get; set; }
        public string TaskTypeName { get; set; }
    }

    public class TaskSubDetail1BO
    {
        public long TaskSubDetail1Id { get; set; }
        public string TaskSubDetail1Name { get; set; }
    }

    public class TaskSubDetail2BO
    {
        public long TaskSubDetail2Id { get; set; }
        public string TaskSubDetail2Name { get; set; }
    }

    public class TaskTeamTaskTypeMappingBO
    {
        public long MappingId { get; set; }
        public long TaskTeamId { get; set; }
        public long TaskTypeId { get; set; }
    }

    public class TaskTypeTaskSubDetail1MappingBO
    {
        public long MappingId { get; set; }
        public long TaskTypeId { get; set; }
        public long TaskSubDetail1Id { get; set; }
    }

    public class TaskTypeTaskSubDetail2MappingBO
    {
        public long MappingId { get; set; }
        public long TaskTypeId { get; set; }
        public long TaskSubDetail2Id { get; set; }
    }

    #endregion

    #region AccessCard

    public class AccessCardDataBO
    {
        public long AccessCardId { get; set; }
        public string AccessCardNo { get; set; }
        public bool IsActive { get; set; }
        public bool IsPimcoCard { get; set; }
        public bool IsTemporaryCard { get; set; }
        public string Status { get; set; }
        public bool? IsMapped { get; set; }
        public string EmployeeName { get; set; }
    }

    public class UserAccessCardDataBO : UserAccessCardMappingBO
    {

        public int UserCardMappingId { get; set; }
        public bool IsActive { get; set; }
        public bool IsFinalised { get; set; }
        public string Status { get; set; }
        public string EmployeeId { get; set; }
        public string AssignedFrom { get; set; }
        public string AssignedOn { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? AssignedDate { get; set; }
        public string AssignedDateNew { get; set; }

    }

    public class UserUnMappedCardDataBO : UserAccessCardMappingBO
    {

        public int UserCardMappingId { get; set; }
        public bool IsActive { get; set; }
        public bool IsFinalised { get; set; }
        public string Status { get; set; }
        public string EmployeeId { get; set; }
        public string AssignedFrom { get; set; }
        public string AssignedTill { get; set; }
        public string AssignedOn { get; set; }
        public string DeActivatedBy { get; set; }
        public string DeActivatedOn { get; set; }
        public string CreatedBy { get; set; }

    }

    public class UserAccessCardMappingBO
    {
        public int AccessCardId { get; set; }
        public string AccessCardNo { get; set; }
        public int UserId { get; set; }
        public bool IsPimcoUserCardMapping { get; set; }
        public string EmployeeName { get; set; }
    }

    public class AccessCardMappingResponse
    {
        public int Success { get; set; }
        public long UserMappingId { get; set; }
    }
    #endregion

    #region File Upload Bugs Entity
    public class FileUploadBugsBO
    {
        public int RowNo { get; set; }
        public string ColumnName { get; set; }
        public string InvalidMessage { get; set; }
    }

    public class AttendanceBO
    {
        public string JobId { get; set; }
        public string InTime { get; set; }
        public string OutTime { get; set; }
        public string AttendanceDate { get; set; }
    }

    public class AttendanceUpdateBO
    {
        public long AttendaceId { get; set; }
        public string AttendaceDate { get; set; }
        public string CreatedBy { get; set; }
        public string CreatedDate { get; set; }
        public int DeviceId { get; set; }
    }

    public class AttendanceDetailBO
    {
        public string AttendaceDate { get; set; }
        public string InTime { get; set; }
        public string OutTime { get; set; }
        public string TotalHours { get; set; }
        public string StaffName { get; set; }
        public string CreatedBy { get; set; }
        public string CreatedDate { get; set; }
    }

    public class UsersPunchInOutLogBO
    {
        public string PunchTime { get; set; }
        public string DoorPoint { get; set; }
        public string Day { get; set; }
        public string CardType { get; set; }
        public string CardDetail { get; set; }
        public int Event { get; set; }
    }

    #endregion

    #region User Management

    public class LockedUserDetailBO
    {
        public string UserName { get; set; }
        public string EmployeeAbrhs { get; set; }
    }

    public class UserActivityLogBO
    {
        public Int64 UserActivityLogId { get; set; }
        //public Int64 UserId { get; set; }
        public string EmployeeAbrhs { get; set; }
        public string UserName { get; set; }
        public string IPAddress { get; set; }
        public string BrowserInfo { get; set; }
        public string ActivityStatus { get; set; }
        public string ActivityDetail { get; set; }
        public DateTime? LoginTime { get; set; }
        public DateTime? LogoutTime { get; set; }
        public string ClientInfo { get; set; }
        public string Device { get; set; }
        public string Latitude { get; set; }
        public string Longitude { get; set; }
        public string TimeZone { get; set; }
        public string City { get; set; }
        public string Country { get; set; }
        public string ISP { get; set; }
    }

    public class MappingInfoBo
    {
        public int Success { get; set; }
        public string DOJ { get; set; }
        public int UserId { get; set; }
        public bool IsUserCreated { get; set; }
        public string EmployeeAbrhs { get; set; }
    }
    //F&F
    public class LeaveBalanceForFnF
    {
        public string Summary { get; set; }
        public string Detail { get; set; }
    }

    public class LeaveBalanceSummay
    {
        public string LeaveType { get; set; }
        public string Count { get; set; }
    }
    public class balanceCOFFBO
    {
        public string Quarter { get; set; }
        public string FromDate { get; set; }
        public string TillDate { get; set; }
        public string Pending { get; set; }
        public string PendingDates { get; set; }
        public string Lapsed { get; set; }
        public string LapsedDates { get; set; }
        public string Available { get; set; }
        public string AvailableDates { get; set; }
        public string Approved { get; set; }
        public string ApprovedDates { get; set; }
    }

    public class balanceLNSABO
    {
        public string Quarter { get; set; }
        public string FromDate { get; set; }
        public string TillDate { get; set; }
        public string Pending { get; set; }
        public string PendingDates { get; set; }
        public string Approved { get; set; }
        public string ApprovedDates { get; set; }
    }

    public class balanceLWPBO
    {
        public string Month { get; set; }
        public string FromDate { get; set; }
        public string TillDate { get; set; }
        public string Count { get; set; }
        public string Dates { get; set; }
    }

    public class UserManagementDetailBO
    {
        public string Name { get; set; }
        public string EmployeeAbrhs { get; set; }
        public int UserId { get; set; }
        public string EmployeeId { get; set; }
        public string OldEmployeeId { get; set; }
        public string NewEmployeeId { get; set; }
        public string Manager { get; set; }
        public string Designation { get; set; }
        public string OldDesignation { get; set; }
        public string NewDesignation { get; set; }
        public string Division { get; set; }
        public string Team { get; set; }
        public string Department { get; set; }
        public string CreatedByName { get; set; }
        public DateTime JoiningDate { get; set; }
        public DateTime PromotionDate { get; set; }
        public DateTime CreatedDate { get; set; }
        public string EmailId { get; set; }
        public string DesignationGrpAbrhs { get; set; }
        public bool IsIntern { get; set; }
        public String DOJ { get; set; }
    }

    public class UserRegistationDataBO
    {
        public int Status { get; set; }
        public string EmailId { get; set; }
        public long RegistrationId { get; set; }
        public string TempUserGuid { get; set; }
        public string CreatedOn { get; set; }
        public string CreatedBy { get; set; }
        public string ADUserName { get; set; }


    }

    public class UserDetailBO
    {
        public UserDetailBO()
        {
            this.AddressDetail = new List<UserAddressDetailBO>();
        }
        public string UserAbrhs { get; set; }
        public UserPersonalDetailBO PersonalDetail { get; set; }
        public virtual IList<UserAddressDetailBO> AddressDetail { get; set; }
        public UserJoiningDetailBO JoiningDetail { get; set; }

    }

    public class MandatoryFieldBO
    {
        public string Field { get; set; }
        public string Category { get; set; }
    }

    public class ValidateAndSubmitAppraisalFormBO
    {
        public ValidateAndSubmitAppraisalFormBO()
        {
            this.MandatoryFieldsList = new List<MandatoryFieldBO>();
        }
        public bool IsValid { get; set; }
        public bool IsSubmitted { get; set; }
        public virtual IList<MandatoryFieldBO> MandatoryFieldsList { get; set; }
    }

    public class UserPersonalDetailBO
    {
        public string TempUserGuid { get; set; }
        public int UserId { get; set; }
        public string UserName { get; set; }
        public string OfficialEmailId { get; set; }
        public string PersonalEmailId { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastName { get; set; }
        public string MobileNumber { get; set; }
        public string EmergencyContactNumber { get; set; }
        public string DOB { get; set; }
        public string DOJ { get; set; }
        public string BloodGroup { get; set; }
        public int? GenderId { get; set; }
        public string Gender { get; set; }
        public int? MaritalStatusId { get; set; }
        public string MaritalStatus { get; set; }
        public string PresentAddress { get; set; }
        public string PermanentAddress { get; set; }
        public bool? IsFresher { get; set; }
        public string LastEmployerName { get; set; }
        public string LastEmployerLocation { get; set; }
        public string LastJobDesignation { get; set; }
        public string LastJobTenure { get; set; }
        public string LastJobUAN { get; set; }
        public string JobLeavingReason { get; set; }
        public string PanNo { get; set; }
        public string AadhaarNo { get; set; }
        public string PassportNo { get; set; }
        public string DLNo { get; set; }
        public string VoterIdNo { get; set; }
        public string PhotoFileName { get; set; }
        public string Base64PhotoData { get; set; }
        public string UserAbrhs { get; set; }
        public string EmployeeAbrhs { get; set; }
        public bool IsUserCreated { get; set; }

    }

    public class UserAddressDetailBO
    {
        public string TempUserGuid { get; set; }
        public string PinCode { get; set; }
        public int CityId { get; set; }
        public string City { get; set; }
        public int StateId { get; set; }
        public string State { get; set; }
        public int CountryId { get; set; }
        public string Country { get; set; }
        public string Address { get; set; }
        public bool IsAddressPermanent { get; set; }
        public string UserAbrhs { get; set; }
        public string EmployeeAbrhs { get; set; }
    }

    public class SkillsDetailBO
    {

        public int SkillId { get; set; }
        public int SkillLevelId { get; set; }
        public int SkillTypeId { get; set; }
        public int ExperienceMonths { get; set; }
        public int Sequence { get; set; }
        public int SkillTypeSequence { get; set; }
        public string UserAbrhs { get; set; }

        public string SkillLevelName { get; set; }
        public string SkillName { get; set; }
        public string SkillTypeName { get; set; }
        public string UpdatedOn { get; set; }
        public int UserSkillId { get; set; }
        public string EmployeeName { get; set; }
        public DateTime CreatedDate { get; set; }

        public string SkillIds { get; set; }
        public string SkillLevelIds { get; set; }
        public string SkillTypeIds { get; set; }
    }

    public class UserJoiningDetailBO
    {
        public string EmployeeId { get; set; }
        public string DivisionId { get; set; }
        public string DepartmentId { get; set; }
        public string TeamId { get; set; }
        public string DesignationId { get; set; }
        public string WsNo { get; set; }
        public string ExtensionNo { get; set; }
        public string AccCardNo { get; set; }
        public string Doj { get; set; }
        public string TerminationDate { get; set; }
        public string RoleId { get; set; }
        public string ReportingManagerId { get; set; }
        public string UserAbrhs { get; set; }
        public string EmployeeAbrhs { get; set; }
        public string DesignationGrpAbrhs { get; set; }
        public int ProbationPeriod { get; set; }
        //public string ImageLink { get; set; }
    }
    public class UserFamilyDetailBO
    {
        public long RegistrationId { get; set; }
        public string FatherName { get; set; }
        public string FatherDOB { get; set; }
        public string MotherName { get; set; }
        public string MotherDOB { get; set; }
        public string InsuranceAmount { get; set; }
        public string SpouseName { get; set; }
        public string SpouseDOB { get; set; }
        public string SpouseOccupation { get; set; }
        public string SpouseCompany { get; set; }
        public string SpouseDesignation { get; set; }
        public bool HasKids { get; set; }
        public string Child1Name { get; set; }
        public string Child1Gender { get; set; }
        public string Child1DOB { get; set; }
        public string Child2Name { get; set; }
        public string Child2Gender { get; set; }
        public string Child2DOB { get; set; }
    }

    #endregion

    #region Team Management

    public class TeamBO
    {
        //public TeamBO()
        //{
        //    this.TeamEmailTypeDetail = new List<TeamEmailTypeMappingTrn>();
        //}
        public long TeamId { get; set; }
        public string TeamAbrhs { get; set; }
        public string TeamName { get; set; }
        public string WeekStartDay { get; set; }
        public string TeamHead { get; set; }
        public string Department { get; set; }
        public string ParentTeam { get; set; }

        public bool IsReminderEmailsEnabled { get; set; }
        public bool IsAttendanceEmailsEnabled { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }

        public int WeekStartDayId { get; set; }
        public int DepartmentId { get; set; }
        public int ParentTeamId { get; set; }
        public string TeamHeadAbrhs { get; set; }
        public string UserAbrhs { get; set; }

        // public virtual IList<TeamEmailTypeMappingTrn> TeamEmailTypeDetail { get; set; }
    }

    public class TeamNameListBO
    {
        public string TeamAbrhs { get; set; }
        public string TeamName { get; set; }
        public string UserName { get; set; }
        public string DepartmentName { get; set; }
        public int EmployeeCount { get; set; }
    }
    public class TeamNameListByDeptIdBO
    {
        public string TeamAbrhsById { get; set; }
        public string TeamNameById { get; set; }
    }

    public class TeamEmailTypeMappingTrn
    {
        public int MappingId { get; set; }
        public long TeamId { get; set; }
        public string TeamEmailTypeName { get; set; }
        public string TeamEmailValue { get; set; }

        public long TeamEmailTypeId { get; set; }
        public int Sequence { get; set; }
        public int WeekDayId { get; set; }
        public int Week { get; set; }
        public TimeSpan Time { get; set; }
    }

    public class WeekTypeBO
    {
        public long WeekTypeId { get; set; }
        public string WeekStartDay { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class UserDetailForUserTeamMappingBO
    {
        public UserDetailForUserTeamMappingBO()
        {
            IsMapped = false;
        }
        public string UserAbrhs { get; set; }
        public string Name { get; set; }
        public string TeamAbrhs { get; set; }
        public bool ConsiderInClientReports { get; set; }
        public bool IsMapped { get; set; }
        public bool IsSelected { get; set; }
        public string RoleAbrhs { get; set; }
    }

    public class UsersListBO
    {
        //public UsersListBO()
        //{
        //    this.ShiftsList = new List<ShiftsListBO>();
        //}
        public string UserAbrhs { get; set; }
        public string Name { get; set; }
        public bool IsSelected { get; set; }

        //  public virtual IList<ShiftsListBO> ShiftsList { get; set; }

    }

    public class UserTeamMappingBO
    {
        public long RecordId { get; set; }
        public int UserId { get; set; }
        public long TeamId { get; set; }
        public bool ConsiderInClientReports { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class ShiftMasterBO
    {
        // public long ShiftId { get; set; }
        public string ShiftAbrhs { get; set; }
        public string ShiftName { get; set; }
        public string InTime { get; set; }
        public string OutTime { get; set; }
        public string WorkingHours { get; set; }
        public bool IsWeekEnd { get; set; }
        public bool IsNight { get; set; }
        public bool IsActive { get; set; }
    }

    public class ListAllShiftBO : ShiftMasterBO
    {
        public string ShiftType { get; set; }
        public string Status { get; set; }
    }

    public class ShiftsListBO
    {
        public string ShiftAbrhs { get; set; }
        public string ShiftName { get; set; }
    }
    public class DepartmentMapList
    {
        public string DeptName { get; set; }
        public string DeptAbrhs { get; set; }
    }
    public class ShiftsUserMapList
    {
        public long MappingId { get; set; }
        public string TeamName { get; set; }
        public string UserName { get; set; }
        public string ShiftName { get; set; }
        public long DateId { get; set; }
        public string DateValue { get; set; }
        public string Day { get; set; }
        public string InTime { get; set; }
        public string OutTime { get; set; }
        public bool IsWeekEnd { get; set; }
        public bool IsNight { get; set; }
        public string ShiftType { get; set; }
        public int? WeekNo { get; set; }
        public string UserAbrhs { get; set; }
        public string ShiftAbrhs { get; set; }

    }



    public class ShiftUserMappingFilterBO
    {
        public ShiftUserMappingFilterBO()
        {
            this.DateList = new List<WeekStDateToDate>();
        }
        public string UserAbrhs { get; set; }
        public string TeamAbrhs { get; set; }
        public string ShiftAbrhs { get; set; }
        public virtual IList<WeekStDateToDate> DateList { get; set; }
    }

    public class WeekStDateToDate
    {
        public string FromDate { get; set; }
        public string ToDate { get; set; }
    }

    public class TeamInformationBO
    {
        public TeamInformationBO()
        {
            this.TeamEmailTypeDetail = new List<TeamEmailTypeInformationBO>();
        }
        public long TeamId { get; set; }
        public string TeamName { get; set; }
        public int TeamWeekDayId { get; set; }
        public bool IsReminderEmailEnabled { get; set; }
        public bool IsAttendanceEmailEnabled { get; set; }
        public string TeamHeadAbrhs { get; set; }
        public int DepartmentId { get; set; }
        public int ParentTeamId { get; set; }
        public string UserAbrhs { get; set; }
        public virtual IList<TeamEmailTypeInformationBO> TeamEmailTypeDetail { get; set; }
    }

    public class TeamEmailTypeInformationBO
    {
        public int TeamEmailTypeId { get; set; }
        public string TeamEmailTypeName { get; set; }
        public int Sequence { get; set; }
        public int WeekDayId { get; set; }
        public int Week { get; set; }
        public TimeSpan Time { get; set; }
    }

    #endregion

    #region User Logging BO

    public class UserActivityLogging
    {
        public string Activity { get; set; }
        public string ByUser { get; set; }
        public DateTime ActivityDate { get; set; }
        public string ForUser { get; set; }
    }

    #endregion

    #region Meal Management

    public class MealPackageListBO
    {
        public int MealPackageId { get; set; }
        public string MealPackage { get; set; }
        public string MealType { get; set; }
        public string MealCategory { get; set; }
        public string MealPeriod { get; set; }
        public string CreatedDate { get; set; }
        public string CreatedBy { get; set; }
        public bool IsActive { get; set; }

        public int MealTypeId { get; set; }
        public int MealCategoryId { get; set; }
        public int MealPeriodId { get; set; }
    }

    #endregion

    #region MealDetail

    public class MealFeedbackBO
    {
        public string EmployeeName { get; set; }
        public string Feedback { get; set; }
    }

    #endregion

    #region Appraisal Management

    public class AppraisalCycleList
    {
        public string AppraisalCycleAbrhs { get; set; }
        public string AppraisalCycleName { get; set; }
        public string AppraisalTypeName { get; set; }
        public string Country { get; set; }
        public string UserAbrhs { get; set; }
    }

    public class AppraisalCycleBO
    {
        public string AppraisalCycleAbrhs { get; set; }
        public int CountryId { get; set; }
        //public int AppraisalTypeId { get; set; }
        public int AppraisalMonth { get; set; }
        public int AppraisalYear { get; set; }
        public string AppraisalCycleName { get; set; }
        public string UserAbrhs { get; set; }
    }

    #region Goal and Achievement

    public class GoalDetailBO
    {
        public long UserGoalId { get; set; }
        public int UserId { get; set; }
        public string Employee { get; set; }
        public long GoalId { get; set; }
        public string AppraisalCycleName { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public int GoalCategoryId { get; set; }
        public string GoalCategory { get; set; }
        public string Goal { get; set; }
        public string Status { get; set; }
        public bool IsGoalSelfCreated { get; set; }
        public bool IsGoalAchieved { get; set; }
        public string GoalAchievingDate { get; set; }
        public bool IsActive { get; set; }
        public bool IsFreezed { get; set; }
        public string Remark { get; set; }
        public string OtherRemark { get; set; }
        public string CreatedDate { get; set; }
        public string UserAbrhs { get; set; }
        public string CreatedBy { get; set; }
        public int AppraisalYear { get; set; }
        public string TeamName { get; set; }
        public string DepartmentName { get; set; }
        public string DepartmentHead { get; set; }
        public bool HasViewRights { get; set; }
        public bool HasAddRights { get; set; }
        public bool HasEditRights { get; set; }
        public bool HasDeleteRights { get; set; }
        public bool HasApproverRights { get; set; }

    }

    public class AddGoalBO
    {
        public AddGoalBO()
        {
            this.GoalList = new List<GoalDetailBO>();
        }
        public string UserAbrhs { get; set; }
        public string TeamAbrhs { get; set; }
        public string EmployeeAbrhs { get; set; }
        public List<GoalDetailBO> GoalList { get; set; }
        public int GoalCycleId { get; set; }
    }

    public class SubmitAchievementBO
    {
        public List<AchievementDetailBO> AchievementData { get; set; }
        public int GoalCycleId { get; set; }
    }

    public class AchievementDetailBO
    {
        public int SNo { get; set; }
        public string Achievement { get; set; }
        public string Purpose { get; set; }
        public string SubmittedDate { get; set; }
    }

    public class UserMidYearAchievementDataBO
    {
        public string SubmittedDate { get; set; }
        public List<AchievementDetailBO> AchievementData { get; set; }
        public string AppraisalYear { get; set; }
        public bool IsSubmitted { get; set; }
        public string ReportingManager { get; set; }
        public string EmployeePhotoName { get; set; }
        public string EmployeeName { get; set; }
        public string Team { get; set; }
        public string DesignationName { get; set; }
        public string Department { get; set; }
        public int AppraisalCycleId { get; set; }
        public string CreatedDate { get; set; }
    }
    public class AppraisalCycleIdForAchievementBO
    {
        public int AppraisalCycleId { get; set; }
        public DateTime FyStartDate { get; set; }
        public DateTime FyEndDate { get; set; }
        public int AppraisalYear { get; set; }
        public string AppraisalCycleName { get; set; }
        public int GoalCycleId { get; set; }
        public string FinancialYear { get; set; }
        public string FinancialYearName { get; set; }
    }
    public class GoalXmlBO
    {
        public GoalXmlBO()
        {
            this.DetailList = new List<GoalCommentBO>();
        }
        public int EmpAppraisalSettingId { get; set; }
        public string UserAbrhs { get; set; }
        public virtual IList<GoalCommentBO> DetailList { get; set; }
    }

    public class GoalCommentBO
    {
        public int UserGoalId { get; set; }
        public string Comment { get; set; }
    }

    public class AchievementXmlBO
    {
        public AchievementXmlBO()
        {
            this.DetailList = new List<AchievementCommentBO>();
        }
        public int EmpAppraisalSettingId { get; set; }
        public string UserAbrhs { get; set; }
        public virtual IList<AchievementCommentBO> DetailList { get; set; }
    }

    public class AchievementCommentBO
    {
        public long UserAchievementId { get; set; }
        public string Comment { get; set; }
    }

    public class SubmitPimcoAchievementBO
    {
        public List<PimcoAchievementDetailBO> AchievementData { get; set; }
        public int Year { get; set; }
        public int QNumber { get; set; }
        public int MNumber { get; set; }
        public string Comments { get; set; }
        public string UserAbrhs { get; set; }
    }

    public class PimcoAchievementDetailBO
    {
        public int SNo { get; set; }
        public string Achievement { get; set; }
        public string Purpose { get; set; }
        public string RMComments { get; set; }
        public bool DiscussWithHR { get; set; }
        public int ProjectId { get; set; }
        public string ProjectName { get; set; }
    }

    public class PimcoProjectBO
    {
        public int ProjectId { get; set; }
        public string ProjectName { get; set; }
    }

    public class UserQuarterlyPimcoAchievementBO
    {
        public long PimcoAchievementId { get; set; }
        public string SubmittedDate { get; set; }
        public List<PimcoAchievementDetailBO> AchievementData { get; set; }
        public string ReportingManager { get; set; }
        public string EmployeePhotoName { get; set; }
        public string EmployeeName { get; set; }
        public string Team { get; set; }
        public string DesignationName { get; set; }
        public string Department { get; set; }
        public bool IsSubmitted { get; set; }
        public string EmpComments { get; set; }
        public string RMComments { get; set; }
        public string CreatedDate { get; set; }
        public bool DiscussWithHR { get; set; }
    }
    #endregion

    public class AppraisalFormXmlBO
    {
        public AppraisalFormXmlBO()
        {
            this.AppraisalParameter = new List<AppraisalParameterDetailBO>();
        }
        public int EmpAppraisalId { get; set; }
        public int EmpAppraisalSettingId { get; set; }
        public string ReviewPeriod { get; set; }
        public string ExposerFromDate { get; set; }
        public string ExposerToDate { get; set; }
        public string UserAbrhs { get; set; }
        public virtual IList<AppraisalParameterDetailBO> AppraisalParameter { get; set; }
    }

    public class AppraisalParameterDetailBO
    {
        public int EAParameterDetailId { get; set; }
        public int CompetencyFormDetailId { get; set; }
        public int RatingId { get; set; }
        public string Comment { get; set; }
    }

    public class AppraisalFormReturnBO
    {
        public int EmpAppraisalId { get; set; }
        public string Result { get; set; }
        public string Ratings { get; set; }
    }

    public class AppraisalReportBO
    {
        public string EmployeeCode { get; set; }
        public string EmployeeName { get; set; }
        public string CurrentDesignation { get; set; }
        public string ReportingManager { get; set; }
        public string Appraiser { get; set; }
        public string Approver { get; set; }
        public string AppraiserRecommendedDesignation { get; set; }
        public string AppraiserRecommendedPercentage { get; set; }
        public string ApproverRecommendedDesignation { get; set; }
        public string ApproverRecommendedPercentage { get; set; }
        public bool? AppraiserMarkedHighPotential { get; set; }
        public bool? ApproverMarkedHighPotential { get; set; }
        public string SelfRating { get; set; }
        public string AppraiserRating { get; set; }
        public string ApproverRating { get; set; }
        public string AppraisalStatus { get; set; }
        public string EmployeePhotoName { get; set; }
    }

    public class UserRegularAchievementBO
    {
        public string UserFormAbrhs { get; set; }
        public int FormId { get; set; }
        public string EmployeeAbrhs { get; set; }
        public string EmployeeName { get; set; }
        public string DesignationName { get; set; }
        public string EmployeePhotoName { get; set; }
        public string ActualFormName { get; set; }
        public string UsersFormName { get; set; }
        public string FormName { get; set; }
        public string FormPath { get; set; }
        public string Status { get; set; }
        public DateTime CreatedDate { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
    }

    #endregion

    #region User Feedback

    public class UserFeedbackBO
    {
        public int FeedbackId { get; set; }
        public string Remarks { get; set; }
        public string UserAbrhs { get; set; }
        public string AcknowledgedBy { get; set; }
        public string EmployeeName { get; set; }
        public bool? IsAcknowledged { get; set; }
        public DateTime CreatedDate { get; set; }
        public string DisplayCreatedDate { get; set; }
    }

    #endregion

    #region Organization Structure
    public partial class OrganizationStructureBO
    {
        public int Id { get; set; }
        public int? ParentId { get; set; }
        public string Name { get; set; }
        public string Designation { get; set; }
        public string ImagePath { get; set; }

        //public string ParentName { get; set; }
        //public bool? IsSupportingStaff { get; set; }
        //public string RM { get; set; }
        //public string PM { get; set; }
        //public string Gender { get; set; }
        //public string MobileNumber { get; set; }
        //public string EmailId { get; set; }
        //public string EmployeeId { get; set; }
    }

    public partial class PimcoOrganizationStructureBO
    {
        public int Id { get; set; }
        public int ParentId { get; set; }
        public string Name { get; set; }
        public string ParentName { get; set; }
        public string OffshoreManager { get; set; }
        public string OnshoreManager { get; set; }
        public string TeamName { get; set; }
        public decimal TotalExperience { get; set; }
        public decimal PimcoTenure { get; set; }
        public string TopNSkills { get; set; }
        public string ProfileSummary { get; set; }
        public string RoleDetail { get; set; }
        public string ImagePath { get; set; }
    }


    public partial class PimcoOrgData
    {
        public string PimcoId { get; set; }
        public string PimcoParentId { get; set; }
        public string Name { get; set; }
        public string Designation { get; set; }
        public string PimcoTenure { get; set; }
        public string OnshoreManager { get; set; }
        public string OrgManagerName { get; set; }
        public string Team { get; set; }
        public string Role { get; set; }
        public string RoleDetail { get; set; }
        public string ImagePath { get; set; }
        public string Achievements { get; set; }
        public string ProfileSummary { get; set; }
        public string TopNSkills { get; set; }
        public string TotalExperience { get; set; }
    }

    public class GeminiUsersForPimco
    {
        public string EmployeeName { get; set; }
        public string EmployeeId { get; set; }
        public bool IsActive { get; set; }
        public string ExitDate { get; set; }
        public bool IsPimcoUser { get; set; }
        public string PimcoId { get; set; }
        public string MonthsOfExperience { get; set; }
        public string Designation { get; set; }
        public string ReportingMgrId { get; set; }
        public string Department { get; set; }
        public string Team { get; set; }
        public string JoiningDate { get; set; }
        public string GeminiEmailId { get; set; }
        public string DOB { get; set; }
        public string ExtNo { get; set; }
        public string WSNo { get; set; }
        public string MobileNumber { get; set; }
        public string Skills { get; set; }
    }



    public class GeminiUserProfileData
    {
        public string EmployeeCode { get; set; }
        public string ImagePath { get; set; }
    }

    #endregion

    #region Sports

    public class TournamentTeamBO
    {
        public long TournamentScheduleId { get; set; }
        public DateTime TournamentDate { get; set; }
        public int? TournamentCategoryId { get; set; }
        public string CategoryCode { get; set; }
        public string Category { get; set; }
        public long TournamentTeamId { get; set; }
        public long TournamentVSTeamId { get; set; }
        public string Group { get; set; }
        public string TournamentUserIds { get; set; }
        public string TournamentUsers { get; set; }
        public string TournamentVSUserIds { get; set; }
        public string TournamentVSUsers { get; set; }
        public int Round { get; set; }
    }

    public class TournamentTeamScoreBO
    {
        public long TournamentScheduleId { get; set; }
        public long TournamentTeamId { get; set; }
        public int? GameScore { get; set; }
    }

    public class TournamentScoreDetailBO : TournamentTeamBO
    {
        public int? G1Score { get; set; }
        public int? G2Score { get; set; }
        public int? G3Score { get; set; }
        public int? G4Score { get; set; }
        public int? G5Score { get; set; }
        public long TeamId { get; set; }
        public bool IsLive { get; set; }
    }

    #endregion

    #region Cab Request

    public class CabRequestBO
    {
        public long CabRequestId { get; set; }
        public string Date { get; set; }
        public string Status { get; set; }
        public string ShiftName { get; set; }
        public int ShiftId { get; set; }
        public string ShiftIds { get; set; }
        public string StatusCode { get; set; }
        public string DateText { get; set; }
        public long DateId { get; set; }
        public string ServiceType { get; set; }
        public string CompanyLocation { get; set; }
        public int CompanyLocationId { get; set; }
        public string CompanyLocationIds { get; set; }
        public int ServiceTypeId { get; set; }
        public string ServiceTypeIds { get; set; }
        public string LocationDetail { get; set; }
        public int LocationId { get; set; }
        public string LocationName { get; set; }
        public string Remarks { get; set; }
        public string EmployeeAbrhs { get; set; }
        public string EmployeeName { get; set; }
        public string ApproverName { get; set; }
        public string EmpContactNo { get; set; }
        public int LoginUserId { get; set; }
        public string CabRoute { get; set; }
        public int CabRouteId { get; set; }
        public string CabRouteIds { get; set; }
        public string CreatedDate { get; set; }
        public string ForScreen { get; set; }
        public string NewCabRouteId { get; set; }
        public string Dates { get; set; }
        public long FCRequestId { get; set; }
        public string FinalizedOn { get; set; }
        public int RequestCount { get; set; }
        public string StaffName { get; set; }
        public string StaffMobileNo { get; set; }
        public string VehicleName { get; set; }
        public string ReviewAppUrl { get; set; }
        public string EncodedData { get; set; }
        public string NewShiftId { get; set; }
        public string ReportingManager { get; set; }

    }

    public class CabDriverBO
    {
        public long StaffId { get; set; }
        public string StaffName { get; set; }
        public string MobileNo { get; set; }
        public string CabRequestIds { get; set; }
        public string StatusCode { get; set; }
        public string VehicleName { get; set; }
        public int VehicleId { get; set; }
    }
    public class CabRequestResponseBO
    {
        public long Result { get; set; }
        public string Message { get; set; }
    }
    #endregion

    #region Referral
    public class ReferralBO
    {
        public ReferralBO()
        {
            this.JsonDataList = new List<ReferralStatusList>();
        }
        public string FromDate { get; set; }
        public string EndDate { get; set; }
        public string Position { get; set; }
        public string Description { get; set; }
        public string UserAbrhs { get; set; }
        public int ReferralId { get; set; }
        public int ReferalDetailId { get; set; }
        public string RefereeName { get; set; }
        public string ForwardedTo { get; set; }
        public string ReferredBy { get; set; }
        public int ReferredById { get; set; }
        public string CreatedDate { get; set; }
        public string Resume { get; set; }
        public bool IsExpired { get; set; }
        public int Count { get; set; }
        public List<ReferralStatusList> JsonDataList { get; set; }
    }
    public class ReferralStatusList
    {
        public int ReferralReviewId { get; set; }
        public string ForwardedTo { get; set; }
        public int IsRelevant { get; set; }
        public string ForwardedOn { get; set; }
    }
    #endregion

    #region Pending Requests
    public class PendingProfileRequests
    {
        public int RequestId { get; set; }
        public string NewMobNo { get; set; }
        public string OldMobNo { get; set; }
        public string NewImage { get; set; }
        public string OldImage { get; set; }
        public string UserName { get; set; }
        public string CreatedDate { get; set; }

        public bool? IsVerified { get; set; }
        public string Reason { get; set; }
    }
    #endregion

    #region Trainig & Probation Feedback Mail
    public class CompletionFeedbackBO
    {
        public int UserId { get; set; }
        public string EmployeeName { get; set; }
        public string EmployeeEmailId { get; set; }
        public string EmployeeCode { get; set; }
        public string JoiningDate { get; set; }
        public string RMFirstName { get; set; }
        public string RMFullName { get; set; }
        public string RMId { get; set; }
        public string RMEmailId { get; set; }
        public string CcHREmailIds { get; set; }
        public string CompletionDate { get; set; }
        public string CompletionType { get; set; }
        public string Summary { get; set; }
        public string EmailDate { get; set; }
    }
    #endregion

    #region Reimbursement
    public class ReimbursementTypeBO
    {
        public int TypeId { get; set; }
        public string TypeName { get; set; }
    }
    public class AddReimbursementBO
    {
        public AddReimbursementBO()
        {
            this.DocumentList = new List<DocumentDetailBo>();
        }
        public List<DocumentDetailBo> DocumentList { get; set; }
        public string MonthYear { get; set; }
        public int TypeId { get; set; }
        public long ReimbursementRequestId { get; set; }
        public string ReimbursementRequestAbrhs { get; set; }
        public string userAbrhs { get; set; }
        public string RequestedAmount { get; set; }
        public string ApprovedAmount { get; set; }
    }
    public class ReimbusrementResponse
    {
        public int Result { get; set; }
        public long ReimbursementRequestId { get; set; }
        public String ReimbursementRequestAbrhs { get; set; }
    }
    public class DocumentDetailBo
    {
        public string ImageName { get; set; }
        public string Base64ImageData { get; set; }
        public string BillNo { get; set; }
        public string Date { get; set; }
        public string Amount { get; set; }
        public int CategoryId { get; set; }
        public long ReimbursementDetailId { get; set; }
        public string ReimbursementDetailAbrhs { get; set; }
        public string ImagePath { get; set; }
        public bool IsActive { get; set; }
        public bool IsDocumentValid { get; set; }
        public string Remarks { get; set; }
        public string UploadedImageName { get; set; }
        public string CategoryName { get; set; }
        public string DateName { get; set; }
    }
    public class ReimbursementMonthYearBO
    {
        public string Text { get; set; }
        public string CurrentMonthYear { get; set; }
    }
    public class ReimbursementListBO
    {
        public long ReimbursementRequestId { get; set; }
        public string EmployeeName { get; set; }
        public string ReimursementType { get; set; }
        public string MonthYear { get; set; }
        public string CreatedDate { get; set; }
        public string Department { get; set; }
        public string TotalAmount { get; set; }
        public string RequestedAmount { get; set; }
        public string ApprovedAmount { get; set; }
        public string Status { get; set; }
        public string Remarks { get; set; }
        public string SubmittedDate { get; set; }
        public string ReimbursementRequestAbrhs { get; set; }
        public bool IsActive { get; set; }
        public bool IsSubmitted { get; set; }
        public string StatusCode { get; set; }
        public string UserType { get; set; }
    }
    public class ReimbursementActionData
    {
        public string ReimbursementRequestAbrhs { get; set; }
        public string ApprovedAmount { get; set; }
        public int ReimbursementTypeId { get; set; }
        public string ActionType { get; set; }
        public string Remarks { get; set; }
        public string ReimbursementDetailAbrhs { get; set; }
    }

    public class ReimbursementStatusHistory
    {
        public string Date { get; set; }
        public DateTime CreatedDate { get; set; }
        public string Status { get; set; }
        public string ApproverName { get; set; }
        public string Remarks { get; set; }
    }
    public class ReimbursementDropDown
    {
        public int Text { get; set; }
        public List<YearList> YearText { get; set; }
        public List<MonthYearList> MonthYearText { get; set; }
    }

    public class YearList
    {
        public int? Year { get; set; }
    }
    public class MonthYearList
    {
        public string MonthYear { get; set; }
    }
    #endregion

    #region Training
    public class TrainingBO
    {
        public int TrainingId { get; set; }
        public int TrainingDetailId { get; set; }
        public int ApproverId { get; set; }
        public int UserId { get; set; }
        public string FromDate { get; set; }
        public string EndDate { get; set; }
        public string TentativeDate { get; set; }
        public string Description { get; set; }
        public string Title { get; set; }
        public bool IsNominationClosed { get; set; }
        public string CreatedDate { get; set; }
        public int StatusId { get; set; }
        public string Remarks { get; set; }
        public string Status { get; set; }
        public int Count { get; set; }
        public string AppliedBy { get; set; }
        public string UserAbrhs { get; set; }
        public bool IsApplied { get; set; }
        public string Document { get; set; }
        public string base64FormData { get; set; }
        public bool IsDocumented { get; set; }
        public string EmployeeCode { get; set; }
        public string EmailId { get; set; }
    }

    public class TrainingDetailsBO
    {
        public int TrainingId { get; set; }
        public DateTime TentativeDate { get; set; }
        public string Description { get; set; }
        public string Title { get; set; }
        public DateTime CreatedDate { get; set; }
        public bool IsApplied { get; set; }

    }

    #endregion

    #region Generate Invoice
    public class AddInvoiceRequestsBO
    {
        public AddInvoiceRequestsBO()
        {
            this.RequestList = new List<GenerateInvoiceBO>();
        }
        public string UserAbrhs { get; set; }
        public string AppLinkUrl { get; set; }
        public List<GenerateInvoiceBO> RequestList { get; set; }
        //public int GoalCycleId { get; set; }
    }

    public class GenerateInvoiceBO
    {
        public int ClientId { get; set; }
        public int NoOfInvoices { get; set; }
        public string ClientName { get; set; }
        public string UserAbrhs { get; set; }
        public string CreatedBy { get; set; }
        public string CreatedOn { get; set; }
        public string InvoiceNumber { get; set; }
        public List<InvoiceSummary> CountDataList { get; set; }
    }
    public class InvoiceSummary
    {
        public InvoiceSummary()
        {
            this.InvoiceList = new List<BO.InvoicesList>();
        }
        public long InvoiceId { get; set; }
        public int ClientId { get; set; }
        public string ClientName { get; set; }
        public int InvoiceCount { get; set; }
        public int BookedCount { get; set; }
        public int CancelledCount { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedOn { get; set; }
        public virtual List<InvoicesList> InvoiceList { get; set; }

    }
    public class InvoicesList
    {
        //public InvoicesList()
        //{
        //    this.InvoiceDetail = new List<BO.InvoiceDetailBO>();
        //}
        public long InvoiceId { get; set; }
        public int ClientId { get; set; }
        public int NoOfInvoices { get; set; }
        public int InvoiceCount { get; set; }
        public string InvoiceNumber { get; set; }
        public string ClientName { get; set; }
        public bool IsCancellable { get; set; }
        public bool IsCancelled { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedOn { get; set; }
        public int IsApproved { get; set; }
        public string Reason { get; set; }
    }
    #endregion
}


