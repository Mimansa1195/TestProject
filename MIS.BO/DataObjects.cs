using System;
using System.Collections.Generic;

namespace MIS.BO
{
    public class MonthlySalaryDisbursement
    {
        public int MonthlySalaryDisbursementId { get; set; }
        public string DocFile { get; set; }
        public string ExcelFile { get; set; }
        public string PdfFile { get; set; }
        public DateTime SubmitDate { get; set; }
        public DateTime? CreateDate { get; set; }
        public bool? IsDeleted { get; set; }
        public double? TotalPaid { get; set; }
    }

    public class MonthlyTaxDetail
    {
        public int MonthlyTaxDetailId { get; set; }
        public int? EmpMonthlySalaryId { get; set; }
        public int? TaxDetailId { get; set; }
        public double? TaxDetailValue { get; set; }
    }

    public class EmailTemplate
    {
        public long RecordId { get; set; }
        public string TemplateName { get; set; }
        public string Template { get; set; }
        public bool IsHTML { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class MonthTbl
    {
        public int MonthId { get; set; }
        public string MonthName { get; set; }
    }

    /// <summary>
    /// Enum of Table MonthTbl
    /// </summary>		
    public enum MonthTbls
    {
        Jan = 1,
        Feb = 2,
        March = 3,
        April = 4,
        May = 5,
        Jun = 6,
        July = 7,
        August = 8,
        Sep = 9,
        Oct = 10,
        Nov = 11,
        Dec = 12,
    }

    public class PaymentCycle
    {
        public int PaymentCycleId { get; set; }
        public string PaymentCycleType { get; set; }
    }

    public class PaymentMode
    {
        public int PaymentModeId { get; set; }
        public string PaymentModeType { get; set; }
    }

    public class LoggedTask
    {
        public long TaskId { get; set; }
        public DateTime Date { get; set; }
        public long ProjectId { get; set; }
        public string Description { get; set; }
        public long TaskTeamId { get; set; }
        public long TaskTypeId { get; set; }
        public long TaskSubDetail1Id { get; set; }
        public long TaskSubDetail2Id { get; set; }
        public decimal TimeSpent { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
        public string userAbrhs { get; set; }
    }

    public class PercentOfGsForBasicSalary
    {
        public int PercentOfGsForBasicId { get; set; }
        public double? PercentValue { get; set; }
        public int? FinancialYear { get; set; }
    }

    public class Permission
    {
        public int PermissionId { get; set; }
        public string PermissionName { get; set; }
        public string Module { get; set; }
        public bool? IsDeleted { get; set; }
    }

    /// <summary>
    /// Enum of Table Permission
    /// </summary>		
    public enum Permissions
    {
        CreateCompany = 1,
        MarkAttendance = 2,
        EditAttendance = 3,
        AttendanceDashboard = 4,
        DeleteProfile = 5,
        ViewEmployee = 6,
        CreateAccount = 7,
        AddNewProject = 8,
        ViewAttendanceOld = 9,
        ViewProjectDashboard = 10,
        AssignProject = 11,
        ProjectEarning = 12,
        ViewSharedDocumentsDeleted = 13,
        ViewResourceList = 14,
        AddNewResource = 15,
        AddCompanyNews = 16,
        ManagePermissionnRole = 17,
        InvoiceManagement = 18,
        ManageSalaryTax = 19,
        PayMonthlySalary = 20,
        CreateProjectTeam = 21,
        AssignProjectTask = 22,
        ViewProjectAndTask = 23,
        ManageExpenses = 24,
        ViewCompanyDashboard = 25,
        ViewEmployeeDashboard = 26,
        ViewProjectDashboard1 = 27,
        ViewClientDashboard = 28,
        ManageActualEarn = 29,
        EmployeePaySlip = 30,
        ViewEmployees = 31,
        EditProjectAndClient = 32,
        ManageProjectEarning = 33,
        ReviewManagement = 34,
        ViewAllReview = 35,
        ExpenseDashboard = 36,
        ExpenseVsEarning = 37,
        CompanyProfitAndLoss = 38,
        AllDashboard = 39,
        AllProjectDashboard = 40,
        ProjectEarningDashboard = 41,
        ProjectExpenseVsEarning = 42,
        ClientExpenseVsEarning = 43,
        CompanyProfitAndLossDELETED = 44,
        SalaryManagement = 45,
        SalaryManagementDeleted1 = 46,
        SalaryManagementDeleted = 47,
        ManageProjectTeam = 48,
        Directory = 49,
        CompanyHolidayDeleted = 50,
        LeaveTypedeleted = 51,
        AllEmployeeLeaveApplication = 52,
        AllEmployeeLeaveStatus = 53,
        SendCustomMail = 54,
        AllEmployeePaySlip = 55,
        CompanyHoliday = 73,
        ViewCompanyHoliday = 74,
        LeaveType = 75,
        ApplyForLeave = 76,
        LeaveAcceptReject = 77,
        MyLeaveApplication = 78,
        EmployeeLeaveApplication = 79,
        MyLeaveStatus = 80,
        EmployeeLeaveStatus = 81,
        MyPerformance = 82,
        GiveReview = 83,
        AllTeamDashboard = 84,
        ViewDocuments = 85,
        ViewSharedDocument = 86,
        DocumentPermissionGroup = 87,
        CreateTimeSheet = 88,
        Policy = 89,
        FillAppraisalForm = 90,
        ReviewAppraisalForm = 91,
        ReviewTimeSheet = 92,
        ProjectInformation = 93,
        TeamInformation = 94,
        VerticalInformation = 95,
        ViewFinalRatings = 96,
        ManageTaskTemplate = 97,
        ConfigureTimeSheet = 98,
        TimeSheetDashboard = 99,
        Forms = 100,
        DataVerification = 101,
        UserTeamMapping = 102,
        ManageTaskTeam = 1102,
        ManageTaskType = 1103,
        ManageTaskSubDetails1 = 1104,
        ManageTaskSubDetails2 = 1105,
        Invite = 1106,
        View = 1107,
        OrganisationChart = 1108,
        LoginDetails = 1109,
        UnlockUserAccount = 1110,
        ApplyLeave = 1111,
        ReviewLeave = 1112,
        Dashboard = 1113,
        RequestCompOff = 1114,
        SubmitFeedback = 1115,
        ViewFeedback = 1116,
        ShiftInformation = 1117,
        Reports = 1118,
        ApplyWFH = 1119,
        LeaveStatus = 1120,
        RequestDataChange = 1121,
        UpdateAttendance = 1122,
        UpdateLeave = 1123,
        RequestAssetAllocation = 1124,
        ViewAssetAllocation = 1125,
        ReviewAssetAllocation = 1126,
        AllocateAssetRequest = 1127,
        ViewGoals = 1128,
        Apply = 1129,
        Review = 1130,
        Status = 1131,
        EmployeeDirectory = 1132,
        ViewAttendance = 1133,
        LWP = 1134,
        LNSA = 1135,
        COMPOFF = 1136,
        AttendanceSummary = 1137,
        SupportingStaff = 1138,
        ManageAccessCard = 1139,
        UserAccessCardMapping = 1140,
    }

    public class Project
    {
        public int ProjectId { get; set; }
        public string ProjectName { get; set; }
        public int ProjectTypeId { get; set; }
        public string ProjectDomain { get; set; }
        public string ProjectSubDomain { get; set; }
        public string ProjectTags { get; set; }
        public int? IndustryId { get; set; }
        public int? TechnologyId { get; set; }
        public int? ClientId { get; set; }
        public int CompanyId { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public bool IsActive { get; set; }
        public bool IsAssigned { get; set; }
        public int? ProjectStatusId { get; set; }
        public bool? IsDelete { get; set; }
    }

    public class ProjectExpense
    {
        public int ProjectExpenseId { get; set; }
        public int ProjectId { get; set; }
        public int? ProjectTypeId { get; set; }
        public int? PaymentCycleId { get; set; }
        public DateTime Date { get; set; }
        public int EmployeeId { get; set; }
        public int ProjectRoleId { get; set; }
        public int ExpenseCurrencyId { get; set; }
        public double? RatePerHour { get; set; }
        public double? TotalhoursPerDay { get; set; }
        public double TotalEarned { get; set; }
        public DateTime? CreateDate { get; set; }
    }

    public class TempCardIssueDetail
    {
        public int IssueId { get; set; }
        public int? EmployeeId { get; set; }
        public int? AccessCardId { get; set; }
        public DateTime? IssueDate { get; set; }
        public DateTime? ReturnDate { get; set; }
        public string Reason { get; set; }
        public bool? IsReturn { get; set; }
    }

    public class ProjectPartialPaymentDetail
    {
        public int ClientPartialPaymentId { get; set; }
        public int ClientTotalPaymentId { get; set; }
        public DateTime? PaymentDate { get; set; }
        public double? PaymentAmount { get; set; }
        public string PaymentMode { get; set; }
        public string DetailNumber { get; set; }
        public string BankName { get; set; }
    }

    public class ProjectRole
    {
        public int ProjectRoleId { get; set; }
        public string ProjectRoleType { get; set; }
    }

    /// <summary>
    /// Enum of Table ProjectRole
    /// </summary>		
    public enum ProjectRoles
    {
        ProjectManager = 1,
        TeamLeader = 2,
        SeniorDeveloper = 3,
        Developer = 4,
        QA = 5,
    }

    public class ProjectStatus
    {
        public int ProjectStatusId { get; set; }
        public string ProjectStatusType { get; set; }
    }

    /// <summary>
    /// Enum of Table ProjectStatus
    /// </summary>		
    public enum ProjectStatuses
    {
    }

    public class ProjectTaskDetail
    {
        public int TaskId { get; set; }
        public int ProjectId { get; set; }
        public int TaskAssignedBy { get; set; }
        public int TaskAssignedTo { get; set; }
        public DateTime TaskAssignedDate { get; set; }
        public DateTime TaskStartDate { get; set; }
        public DateTime TaskEndDate { get; set; }
        public string TaskSummary { get; set; }
    }

    public class DateMaster
    {
        public long DateId { get; set; }
        public DateTime Date { get; set; }
        public string Day { get; set; }
        public bool IsHoliday { get; set; }
        public bool IsWeekend { get; set; }
    }

    public class ProjectTeam
    {
        public int ProjectTeamId { get; set; }
        public int ProjectId { get; set; }
        public int EmployeeId { get; set; }
        public int ProjectRoleId { get; set; }
        public double? ProjectShare { get; set; }
        public bool IsActive { get; set; }
    }

    public class ManpowerRequisitionForm
    {
        public long ManpowerRequisitionFormDataId { get; set; }
        public long InviteId { get; set; }
        public string FormSubmittedTo { get; set; }
        public string Department { get; set; }
        public bool? IsReplacement { get; set; }
        public string ReplacedEmployeeName { get; set; }
        public string ReplacedEmployeeDesignation { get; set; }
        public bool? IsPlacementNew { get; set; }
        public long? NumberOfNewPlacement { get; set; }
        public string FixedCTC { get; set; }
        public string GrossBudget { get; set; }
        public string JobRequirement { get; set; }
        public DateTime ETAofClosingHiring { get; set; }
        public DateTime ETAofJoining { get; set; }
        public string EducationalQualification { get; set; }
        public string JobDescription { get; set; }
        public long MinExperienceRequired { get; set; }
        public long MaxExperienceRequired { get; set; }
        public string SpecialSkillRequirement { get; set; }
        public string SupervisorName { get; set; }
        public string SupervisorDesignation { get; set; }
        public string TechnologyRequired { get; set; }
        public string TechnologyLevelRequired { get; set; }
        public int Version { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
    }

    public class ChangeExtnRequest
    {
        public int RequestId { get; set; }
        public string NewMobileNo { get; set; }
        public string NewExtnNo { get; set; }
        public string NewSeatNo { get; set; }
        public int? UserId { get; set; }
        public bool? IsVarify { get; set; }
        public DateTime? DateCreated { get; set; }
        public DateTime? ApprovedDate { get; set; }
        public int? ApprovedBy { get; set; }
        public int? IsManagerApproved { get; set; }
        public string Reason { get; set; }
        public DateTime? RejectDate { get; set; }
        public bool? ActionperFormed { get; set; }
    }

    public class ProjectTotalPaymentDetail
    {
        public int ClientTotalPaymentId { get; set; }
        public int ClientID { get; set; }
        public int CompanyId { get; set; }
        public int ProjectId { get; set; }
        public double TotalProjectPayment { get; set; }
        public double PaymentDone { get; set; }
        public double DuePayment { get; set; }
    }

    public class GeminiProjectPrefrence
    {
        public long RecordId { get; set; }
        public int UserId { get; set; }
        public long ProjectId { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class ProjectType
    {
        public int ProjectTypeId { get; set; }
        public string ProjectTypeName { get; set; }
    }

    public class AccrualCrediting
    {
        public int AccrualCreditingId { get; set; }
        public string Details { get; set; }
    }

    public class ProjectWorkingTeam
    {
        public int ProjectWorkingTeamId { get; set; }
        public int ProjectId { get; set; }
        public int EmployeeId { get; set; }
        public int ProjectRoleId { get; set; }
        public bool IsActive { get; set; }
        public DateTime? startDate { get; set; }
        public DateTime? endDate { get; set; }
        public int CompanyId { get; set; }
    }

    public class AccrualFrequency
    {
        public int AccrualFrequencyId { get; set; }
        public string Details { get; set; }
    }

    public class Request
    {
        public int RequestId { get; set; }
        public int RequestDetailId { get; set; }
        public int RequestTypeId { get; set; }
        public int SenderUserId { get; set; }
        public int RecipientUserId { get; set; }
        public DateTime? TimeStamp { get; set; }
        public bool IsActive { get; set; }
        public int ApplicationResponseTypeId { get; set; }
    }

    public class TaskSubDetail1
    {
        public long TaskSubDetail1Id { get; set; }
        public string TaskSubDetail1Name { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime? CreatedDate { get; set; }
        public int? CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class AllCompanyDetail
    {
        public int CompanyDetailId { get; set; }
        public int CompanyId { get; set; }
        public string CompanyCode { get; set; }
        public string CompanyLogo { get; set; }
        public string CompanyAddress { get; set; }
        public string CompanyEmail { get; set; }
        public string CompanyContact { get; set; }
    }

    public class RequestDetail
    {
        public int RequestDetailId { get; set; }
        public int? LeaveRequestId { get; set; }
        public int? AttendanceRequestId { get; set; }
        public int? MeetingRequestId { get; set; }
    }

    public class Allowance
    {
        public int AllowanceId { get; set; }
        public string AllowanceName { get; set; }
        public int? CompanyId { get; set; }
    }

    public class RequestType
    {
        public int RequestTypeId { get; set; }
        public string RequestTitle { get; set; }
    }

    /// <summary>
    /// Enum of Table RequestType
    /// </summary>		
    public enum RequestTypes
    {
        ApplyLeave = 1,
        EditAttendance = 2,
        Meeting = 3,
    }

    public class TaskSubDetail2
    {
        public long TaskSubDetail2Id { get; set; }
        public string TaskSubDetail2Name { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime? CreatedDate { get; set; }
        public int? CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class AnnualEmpSalary
    {
        public int EmpSalaryId { get; set; }
        public string Tax { get; set; }
        public double? Value { get; set; }
        public string Type { get; set; }
        public bool? IsFixed { get; set; }
        public DateTime? Date { get; set; }
        public int? SalarySummaryId { get; set; }
        public int? NetValue { get; set; }
        public int? taxCode { get; set; }
    }

    public class ResourceType
    {
        public int ResourceTypeId { get; set; }
        public string ResourceName { get; set; }
    }

    public class AnnualSalary
    {
        public int EmpSalaryId { get; set; }
        public int EmployeeId { get; set; }
        public double BasicAndDa { get; set; }
        public double? HRA { get; set; }
        public double? SpecialAllowance { get; set; }
        public double? Conveyance { get; set; }
        public double? MedicalReimbursement { get; set; }
        public double? Arrears { get; set; }
        public double? ProvidentFund { get; set; }
        public double? ESI { get; set; }
        public double? Loan { get; set; }
        public double? ProfessionTax { get; set; }
        public double? TDS { get; set; }
        public double TotalAnnualSalary { get; set; }
    }

    public class ReviewCycle
    {
        public int ReviewCycleId { get; set; }
        public string TimePeriod { get; set; }
    }

    /// <summary>
    /// Enum of Table ReviewCycle
    /// </summary>		
    public enum ReviewCycles
    {
        ThreeMonths = 1,
        SixMonths = 2,
        Oneyear = 3,
    }

    public class TaskTeam
    {
        public long TaskTeamId { get; set; }
        public string TeamName { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime? CreatedDate { get; set; }
        public int? CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class ApplicationResponseType
    {
        public int ApplicationResponseTypeId { get; set; }
        public string ApplicationResponseStatusType { get; set; }
    }

    /// <summary>
    /// Enum of Table ApplicationResponseType
    /// </summary>		
    public enum ApplicationResponseTypes
    {
        Pending = 1,
        Approve = 2,
        Decline = 3,
        Processing = 4,
        OnHold = 5,
        Resend = 6,
        Kill = 7,
    }

    public class ReviewDetail
    {
        public int ReviewDetailId { get; set; }
        public int ReviewId { get; set; }
        public int UnfilledFormId { get; set; }
        public string FilledFormLocation { get; set; }
        public int? Rating { get; set; }
        public string PublicComment { get; set; }
        public string PrivateComment { get; set; }
    }

    public class AppraisalCriteriaHeader
    {
        public long HeaderId { get; set; }
        public string HeaderName { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class ReviewFilledForm
    {
        public int ReviewFilledFormId { get; set; }
        public string FileName { get; set; }
        public DateTime? CreateDate { get; set; }
    }

    public class GeminiLeaveStatus
    {
        public int StatusId { get; set; }
        public string StatusCode { get; set; }
        public string Status { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class TaskTeamTaskTypeMapping
    {
        public long MappingId { get; set; }
        public long TaskTeamId { get; set; }
        public long TaskTypeId { get; set; }
        public bool IsActive { get; set; }
        public DateTime? CreatedDate { get; set; }
        public int? CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class ReviewFormTemplate
    {
        public int ReviewFormId { get; set; }
        public string FormName { get; set; }
        public string FormLocation { get; set; }
        public int ComapnyId { get; set; }
        public int UploadedBy { get; set; }
        public bool IsDeleted { get; set; }
    }

    //public class Team
    //{
    //    public long TeamId { get; set; }
    //    public string TeamName { get; set; }
    //    public long WeekTypeId { get; set; }
    //    public string AcknowledgementDay { get; set; }
    //    public string AcknowledgementTime { get; set; }
    //    public int AcknowledgementWeek { get; set; }
    //    public string Reminder1Day { get; set; }
    //    public string Reminder1Time { get; set; }
    //    public int Reminder1Week { get; set; }
    //    public bool Reminder1CopyToManager { get; set; }
    //    public string Reminder2Day { get; set; }
    //    public string Reminder2Time { get; set; }
    //    public int Reminder2Week { get; set; }
    //    public bool Reminder2CopyToManager { get; set; }
    //    public string Reminder3Day { get; set; }
    //    public string Reminder3Time { get; set; }
    //    public int Reminder3Week { get; set; }
    //    public bool Reminder3CopyToManager { get; set; }
    //    public string DashboardDay { get; set; }
    //    public string DashboardTime { get; set; }
    //    public int DashboardWeek { get; set; }
    //    public string ReportDay { get; set; }
    //    public string ReportTime { get; set; }
    //    public int ReportWeek { get; set; }
    //    public string ReportCCEmailIds { get; set; }
    //    public bool IsReminderEmailsEnabled { get; set; }
    //    public string AttendanceDashboardDay { get; set; }
    //    public string AttendanceDashboardTime { get; set; }
    //    public int AttendanceDashboardWeek { get; set; }
    //    public bool IsAttendanceEmailsEnabled { get; set; }
    //    public bool IsActive { get; set; }
    //    public bool IsDeleted { get; set; }
    //    public DateTime CreatedDate { get; set; }
    //    public int CreatedBy { get; set; }
    //    public DateTime? LastModifiedDate { get; set; }
    //    public int? LastModifiedBy { get; set; }
    //}

    public class ReviewManagement
    {
        public int ReviewId { get; set; }
        public int ManagerId { get; set; }
        public int EmployeeId { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public DateTime? ReviewDate { get; set; }
        public string ReviewMeetingTime { get; set; }
        public int StatusId { get; set; }
    }

    public class TaskTemplate
    {
        public long TemplateId { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public long TaskTeamId { get; set; }
        public long TaskTypeId { get; set; }
        public long TaskSubDetail1Id { get; set; }
        public long TaskSubDetail2Id { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime? CreatedDate { get; set; }
        public int? CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
        public string userAbrhs { get; set; }
    }

    public class ReviewRequest
    {
        public int ReviewRequestId { get; set; }
        public int? EmpId { get; set; }
        public DateTime? ReviewDate { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public int? ReviewFormId { get; set; }
        public int? ReviewStatusId { get; set; }
        public int? ReviewFilledFormId { get; set; }
        public double? OldSalary { get; set; }
        public double? OfferSalary { get; set; }
        public bool? IsSalaryApproved { get; set; }
        public int? MeetingManagerId { get; set; }
        public double? ApprovedSalary { get; set; }
    }

    public class AppraisalCriteria
    {
        public long CriteriaId { get; set; }
        public long HeaderId { get; set; }
        public string Criteria { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class ReviewRequest_Manger
    {
        public int ReviewRequestManagerAsstId { get; set; }
        public int? ReviewRequestId { get; set; }
        public int? ManagerId { get; set; }
        public int? ReviewStatusId { get; set; }
        public DateTime? DoneDate { get; set; }
        public string PublicComments { get; set; }
        public string PrivateComments { get; set; }
        public double? Rating { get; set; }
    }

    public class TaskType
    {
        public long TaskTypeId { get; set; }
        public string TaskTypeName { get; set; }
        public string SubDetail1Name { get; set; }
        public string SubDetail2Name { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime? CreatedDate { get; set; }
        public int? CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class ReviewStatusName
    {
        public int ReviewStatusId { get; set; }
        public string ReviewStatus { get; set; }
    }

    /// <summary>
    /// Enum of Table ReviewStatusName
    /// </summary>		
    public enum ReviewStatusNames
    {
        Pending = 1,
        Completed = 2,
        InProgress = 3,
        Waiting = 4,
    }

    public class Appraisal
    {
        public long AppraisalId { get; set; }
        public int AppraiserId { get; set; }
        public int ReviewerId { get; set; }
        public DateTime ReviewPeriodFrom { get; set; }
        public DateTime ReviewPeriodTo { get; set; }
        public DateTime ReviewMeetingDate { get; set; }
        public int Status { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime? ApprovedDate { get; set; }
        public DateTime? ReviewedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
        public string ReviewerFinalComments { get; set; }
    }

    public class ReviewStatusType
    {
        public int ReviewStatusId { get; set; }
        public string ReviewStatusName { get; set; }
    }

    /// <summary>
    /// Enum of Table ReviewStatusType
    /// </summary>		
    public enum ReviewStatusTypes
    {
        IsDue = 1,
        Pending = 2,
        Awaiting = 3,
        InProgress = 4,
        Scheduled = 5,
        Completed = 6,
        InQueue = 7,
        Processing = 8,
    }

    public class TaskTypeTaskSubDetail1Mapping
    {
        public long MappingId { get; set; }
        public long TaskTypeId { get; set; }
        public long TaskSubDetail1Id { get; set; }
        public bool IsActive { get; set; }
        public DateTime? CreatedDate { get; set; }
        public int? CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class SalarySummary
    {
        public int SalarySammaryId { get; set; }
        public int? EmpId { get; set; }
        public int? BasicSalary { get; set; }
        public int? GrossSalary { get; set; }
        public int? PF { get; set; }
        public int? Tax { get; set; }
        public double? NetSalary { get; set; }
        public int? AnnualGrossSalary { get; set; }
        public DateTime? ModifyDate { get; set; }
        public double? SpecialAllowance { get; set; }
        public int? PaidRent { get; set; }
        public double? PFPercent { get; set; }
        public int? FinancialYear { get; set; }
        public double? MonthlyTaxableIncome { get; set; }
        public double? AnnualTaxableIncome { get; set; }
        public DateTime? ApplyDate { get; set; }
        public bool? IsDeleted { get; set; }
    }

    public class AppraisalRaitingHeader
    {
        public long AppraisalRatingHeaderId { get; set; }
        public long AppraisalId { get; set; }
        public long HeaderId { get; set; }
        public string Other { get; set; }
        public string SelfComments { get; set; }
        public string AppraiserComments { get; set; }
        public string ReviewerComments { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class SalarySummaryTaxDetail
    {
        public int SalarySummaryTaxDetailId { get; set; }
        public int? SalarySummaryId { get; set; }
        public int? TaxDetailId { get; set; }
        public double? TaxDetailValue { get; set; }
    }

    public class TaskTypeTaskSubDetail2Mapping
    {
        public long MappingId { get; set; }
        public long TaskTypeId { get; set; }
        public long TaskSubDetail2Id { get; set; }
        public bool IsActive { get; set; }
        public DateTime? CreatedDate { get; set; }
        public int? CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class SharedGroupDocument
    {
        public int SharedGroupDocumentId { get; set; }
        public int DocumentId { get; set; }
        public int SharedGroupId { get; set; }
        public int SharedById { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime DateCreated { get; set; }
        public DateTime? DateDeleted { get; set; }
        public string userAbrhs { get; set; }
    }

    public class TimeSheetTaskMapping
    {
        public long RecordId { get; set; }
        public long TimeSheetId { get; set; }
        public long TaskId { get; set; }
        public bool ConsiderInClientReports { get; set; }
    }

    public class AppraisalRatingCriterium
    {
        public long AppraisalRatingCriteriaId { get; set; }
        public long AppraisalId { get; set; }
        public long CriteriaId { get; set; }
        public int SelfRaiting { get; set; }
        public int? AppraiserRaiting { get; set; }
        public int? ReviewerRating { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class GeminiTimeSheetTask
    {
        public long RecordId { get; set; }
        public int UserId { get; set; }
        public string UserName { get; set; }
        public long WeekId { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public int WeekNo { get; set; }
        public int Year { get; set; }
        public DateTime TaskDate { get; set; }
        public long ProjectId { get; set; }
        public string ProjectName { get; set; }
        public string TaskDescription { get; set; }
        public string TaskTeamName { get; set; }
        public string TaskType { get; set; }
        public string TaskSubDetail1 { get; set; }
        public string TaskSubDetail2 { get; set; }
        public decimal TimeSpent { get; set; }
        public string TeamName { get; set; }
        public int Status { get; set; }
    }

    public class ShareDocument
    {
        public int ShareDocId { get; set; }
        public int? DocumentId { get; set; }
        public int? ShareTo { get; set; }
        public int? ShareBy { get; set; }
        public DateTime? Date { get; set; }
        public string userAbrhs { get; set; }
    }

    public class State
    {
        public int StateId { get; set; }
        public int? CountryId { get; set; }
        public string StateName { get; set; }
    }

    public class FinalLoggedTask
    {
        public long TaskId { get; set; }
        public long MappingId { get; set; }
        public DateTime? Date { get; set; }
        public long? ProjectId { get; set; }
        public string Description { get; set; }
        public long? TaskTeamId { get; set; }
        public long? TaskTypeId { get; set; }
        public long? TaskSubDetail1Id { get; set; }
        public long? TaskSubDetail2Id { get; set; }
        public decimal? TimeSpent { get; set; }
        public bool? IsActive { get; set; }
        public bool? IsDeleted { get; set; }
        public DateTime? CreatedDate { get; set; }
        public int? CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
        public string userAbrhs { get; set; }
    }

    public class TimeSheetTask
    {
        public TimeSheetTask()
        {
            this.TaskList = new List<TaskListBO>();
        }
        public int weekNo { get; set; }
        public long projectId { get; set; }
        public string startDate { get; set; } 
        public string userAbrhs { get; set; }
        public string endDate { get; set; }
        public List<TaskListBO> TaskList { get; set; }
    }

    public class TaskListBO
    {
        public string taskDate { get; set; }
        
        public string description { get; set; }
        public long taskTeamId { get; set; }
        public long taskTypeId { get; set; }
        public long taskSubDetail1Id { get; set; }
        public long taskSubDetail2Id { get; set; }
        public decimal timeSpent { get; set; }
    }

    public class TimeSheetTaskOtherUser
    {
        public TimeSheetTaskOtherUser()
        {
            this.TaskList = new List<TaskListBO>();
        }
        public int weekNo { get; set; }
        public long projectId { get; set; }
        public string startDate { get; set; }
        public string userAbrhs { get; set; }
        public int UserId { get; set; }
        public string endDate { get; set; }

        public List<TaskListBO> TaskList { get; set; }
    }

    public class TaxationRule
    {
        public int TaxationRuleId { get; set; }
        public int? FinancialYear { get; set; }
        public double? EducationCessInPercentOnTds { get; set; }
    }

    public class AppliedLeafe
    {
        public long AppliedLeavesId { get; set; }
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
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class TaxDetail
    {
        public int TaxDetailId { get; set; }
        public string TaxType { get; set; }
        public int? Percentage { get; set; }
        public bool? IsFixed { get; set; }
        public bool? IsAllowance { get; set; }
        public int? UserId { get; set; }
        public DateTime? ModifyDate { get; set; }
        public int? TaxReviewId { get; set; }
        public int? TaxCode { get; set; }
        public int? CompanyId { get; set; }
        public double? ExemptionValue { get; set; }
        public string ExemptionType { get; set; }
        public bool? IsActive { get; set; }
        public int? FinancialYear { get; set; }
    }

    public class AppraisalReviewComment
    {
        public long ReviewCommentsId { get; set; }
        public long AppraisalId { get; set; }
        public bool IsSelfSatisfactory { get; set; }
        public string SelfComments { get; set; }
        public bool IsAppraiserSatisfied { get; set; }
        public string AppraiserComments { get; set; }
        public bool IsReviewerSatisfied { get; set; }
        public string ReviewerComments { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class AttendanceDataChangeRequestApplication
    {
        public long RequestId { get; set; }
        public long RequestApplicationId { get; set; }
        public int RequestCategoryid { get; set; }
        public string Reason { get; set; }
        public long StatusId { get; set; }
        public int? ApproverId { get; set; }
        public string ApproverRemarks { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public bool? LastModifiedBy { get; set; }
    }

    public class TaxOnTaxableIncome
    {
        public int AutoId { get; set; }
        public double? GreaterThan { get; set; }
        public string CompareCode { get; set; }
        public double? LessThanOrEqual { get; set; }
        public double? Percentage { get; set; }
        public int? CompanyId { get; set; }
        public int? FinancialYear { get; set; }
    }

    public class TaxReview
    {
        public int TaxReviewId { get; set; }
        public int? CompanyId { get; set; }
        public DateTime? ModifyDate { get; set; }
        public string Type { get; set; }
    }

    public class AttendanceDataChangeRequestCategory
    {
        public int CategoryId { get; set; }
        public string CategoryCode { get; set; }
        public string Description { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class PerformanceReviewCriterium
    {
        public long CriteriaId { get; set; }
        public string Criteria { get; set; }
        public int Priority { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public bool IsRating { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class Technology
    {
        public int TechnologyId { get; set; }
        public string TechnologyName { get; set; }
        public int? JobCategoryId { get; set; }
    }

    public class TempUserPermission
    {
        public int SpecialPermissionId { get; set; }
        public int UserId { get; set; }
        public int PermissionId { get; set; }
        public bool IsPermitted { get; set; }
    }

    public class AttendanceDataChangeRequestHistory
    {
        public long RecordId { get; set; }
        public long RequestId { get; set; }
        public long StatusId { get; set; }
        public int? ApproverId { get; set; }
        public string ApproverRemarks { get; set; }
        public DateTime CreatedDate { get; set; }
    }

    public class AttendanceStatusMaster
    {
        public long StatusId { get; set; }
        public string StatusCode { get; set; }
        public string Status { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class AppraisalReviewGoal
    {
        public long ReviewGoalId { get; set; }
        public long AppraisalId { get; set; }
        public string Goal { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class Asset
    {
        public long AssetId { get; set; }
        public long TypeId { get; set; }
        public string Make { get; set; }
        public string Model { get; set; }
        public string Description { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class AppraisalNextYearGoal
    {
        public long GoalId { get; set; }
        public long AppraisalId { get; set; }
        public string Goal { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class Timezone
    {
        public int TimeZoneId { get; set; }
        public string BaseUTCOffset { get; set; }
        public string DayLightName { get; set; }
        public string DisplayName { get; set; }
        public string Id { get; set; }
        public string StatndardName { get; set; }
        public bool? SupportsDayLightSavingTime { get; set; }
    }

    public class CompOffDetail
    {
        public long RecordId { get; set; }
        public DateTime ApplyDate { get; set; }
        public DateTime CompOfDate { get; set; }
        public int NoOfDay { get; set; }
        public string Reason { get; set; }
        public int? StatusId { get; set; }
        public string Remarks { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public int? LastModifiedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
    }

    public class User
    {
        public int UserId { get; set; }
        public int CompanyId { get; set; }
        public int RoleId { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }
        public bool IsActive { get; set; }
        public int? RandomCode { get; set; }
        public DateTime? LoginDate { get; set; }
        public int UnsuccessfulLoginAttempt { get; set; }
        public bool IsLocked { get; set; }
        public int? UnlockedBy { get; set; }
        public string AccountLockCode { get; set; }
        public bool IsSuspended { get; set; }
        public bool IsPasswordResetRequired { get; set; }
        public DateTime? LastPasswordChanged { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
        public string PasswordResetCode { get; set; }
        public bool IsPasswordResetCodeExpired { get; set; }
    }

    public class PerformanceReviewCriteriaHeader
    {
        public long HeaderId { get; set; }
        public string Header { get; set; }
        public int Priority { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class UserDetail
    {
        public int UserDetailId { get; set; }
        public int UserId { get; set; }
        public string NickName { get; set; }
        public string PunchId { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastName { get; set; }
        public string DOB { get; set; }
        public int GenderId { get; set; }
        public int? MaritalStatusId { get; set; }
        public string BloodGroup { get; set; }
        public string MobileNumber { get; set; }
        public string EmailId { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public string PinCode { get; set; }
        public int? StateId { get; set; }
        public int? CountryId { get; set; }
        public string EmployeeId { get; set; }
        public DateTime? JoiningDate { get; set; }
        public int? DesignationId { get; set; }
        public string ImagePath { get; set; }
        public int? CreatedBy { get; set; }
        public int? DeletedBy { get; set; }
        public DateTime? TerminateDate { get; set; }
        public int? EmpJobStatusId { get; set; }
        public bool? IsDeleted { get; set; }
        public int? ReportTo { get; set; }
        public string Initials { get; set; }
        public string EmployeeAbrhs { get; set; }
        public string EmployeeName { get; set; }
    }

    public class UserRole
    {
        public int RoleId { get; set; }
        public string RoleName { get; set; }
        public string AuthorisedRoleId { get; set; }
        public bool IsDeleted { get; set; }
    }

    ///// <summary>
    ///// Enum of Table UserRole
    ///// </summary>		
    //public enum UserRoles
    //{
    //    SuperMasterAdmin = -1,
    //    Administrator = 2,
    //    Manager = 3,
    //    User = 4,
    //    MISAdministrator = 5,
    //    MISSupport = 6,
    //    Management = 7,
    //    UserAdminisrator = 8,
    //    ITAdministrator = 9,
    //    LeavesAdministrator = 10,
    //}

    public class PerformanceReviewFormReviewPeriod
    {
        public long RecordId { get; set; }
        public int Year { get; set; }
        public int UserRole { get; set; }
        public long ReviewPeriodFromDateId { get; set; }
        public long ReviewPeriodTillDateId { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class UserRolePermission
    {
        public int RolePermissionId { get; set; }
        public int RoleId { get; set; }
        public int PermissionId { get; set; }
        public bool IsPermitted { get; set; }
    }

    public class AssetDetail
    {
        public long AssetDetailId { get; set; }
        public long? AssetId { get; set; }
        public string SerialNo { get; set; }
        public string AssetTag { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class DateWiseLeaveType
    {
        public long RecordId { get; set; }
        public long LeaveRequestApplicationId { get; set; }
        public long DateId { get; set; }
        public long LeaveTypeId { get; set; }
        public bool IsHalfDay { get; set; }
    }

    public class VendorCompany
    {
        public int VendorCompanyId { get; set; }
        public string VendorCompanyName { get; set; }
        public string VendorCompanyAddress { get; set; }
        public string VendorCompanyCity { get; set; }
        public int? VendorCompnayState { get; set; }
        public int? VendorCompanyCountry { get; set; }
        public string VendorCompanyContactNumber { get; set; }
        public string VendorCompanyEmail { get; set; }
        public int CompanyId { get; set; }
        public bool IsActive { get; set; }
    }

    public class Attendance
    {
        public int AttendanceId { get; set; }
        public int UserId { get; set; }
        public DateTime AttendanceDate { get; set; }
        public int? LeaveTypeId { get; set; }
        public int? AttendanceStatusId { get; set; }
        public bool? IsDeleted { get; set; }
    }

    public class VendorInformation
    {
        public int VendorId { get; set; }
        public int VendorTypeId { get; set; }
        public string VendorName { get; set; }
        public int VendorCompanyId { get; set; }
    }

    public class AttendanceCorrectionRequest
    {
        public int AttendanceRequestId { get; set; }
        public DateTime AttendanceDate { get; set; }
        public int CurrentAttendanceStatusId { get; set; }
        public int ReplacedAttendanceStatus { get; set; }
        public string Description { get; set; }
    }

    public class DateWisePunchInDatum
    {
        public long RecordId { get; set; }
        public long DateId { get; set; }
        public int UserId { get; set; }
        public string Data { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class PerformanceReviewCriteriaHeaderPerformanceReviewSectionMapping
    {
        public long RecordId { get; set; }
        public long HeaderId { get; set; }
        public long SectionId { get; set; }
        public int Year { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class VendorTypeInfo
    {
        public int VendorTypeId { get; set; }
        public string VendorType { get; set; }
    }

    public class AttendanceStatus
    {
        public int AttendanceStatusId { get; set; }
        public string AttendanceStatusName { get; set; }
        public string AttendanceCode { get; set; }
    }

    public class WeeklyOffDay
    {
        public int WeeklyOffId { get; set; }
        public string Day { get; set; }
        public int? YearId { get; set; }
        public int? WeeklyOffGroupId { get; set; }
    }

    public class BasicSalary
    {
        public int? BasicSalaryId { get; set; }
        public int? EmpId { get; set; }
        public int? BasicSalaryX { get; set; }
    }

    public class ErrorLog
    {
        public long RecordId { get; set; }
        public DateTime TimeStamp { get; set; }
        public string ProcedureName { get; set; }
        public int LineNumber { get; set; }
        public int ErrorNumber { get; set; }
        public string ErrorMessage { get; set; }
        public int? ReportedBy { get; set; }
    }

    public class WeeklyOffGroup
    {
        public int WeeklyOffGroupId { get; set; }
        public string GroupName { get; set; }
        public bool? IsDeleted { get; set; }
    }

    public class CalendarHoliday
    {
        public int CalendarHolidayId { get; set; }
        public string FestivalName { get; set; }
        public DateTime? FestivalDate { get; set; }
        public int? CalendarYearId { get; set; }
        public string Day { get; set; }
    }

    public class AssetDetailAttribute
    {
        public long AttributeId { get; set; }
        public long AssetDetailId { get; set; }
        public string AttributeType { get; set; }
        public string AttributeValue { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class ClientMaster
    {
        public long ClientId { get; set; }
        public string ClientName { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public string Country { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class CalendarYear
    {
        public int CalendarYearId { get; set; }
        public int? CalenderYear { get; set; }
    }

    public class WeekType
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

    public class ExcludedUsersForAttendanceImport
    {
        public long ExclusionId { get; set; }
        public string Name { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class PerformanceReviewCriteriaPerformanceReviewCriteriaHeaderMapping
    {
        public long RecordId { get; set; }
        public long CriteriaId { get; set; }
        public long HeaderId { get; set; }
        public int Year { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class Client
    {
        public int ClientId { get; set; }
        public string ClientName { get; set; }
        public string ClientSkypeId { get; set; }
        public string ClientAddress { get; set; }
        public string City { get; set; }
        public int? StateId { get; set; }
        public int? CountryId { get; set; }
        public string PrefferedCommunicationType { get; set; }
        public int? TimezoneId { get; set; }
        public string LoginName { get; set; }
        public string Password { get; set; }
        public bool? IsDelete { get; set; }
        public int? CompanyId { get; set; }
    }

    public class ClientCommunication
    {
        public int CommunicationTypeId { get; set; }
        public string CommunicationTypeName { get; set; }
    }

    public class EmployeeWiseWeekOff
    {
        public long RecordId { get; set; }
        public int UserId { get; set; }
        public int WeekOffDay1 { get; set; }
        public int WeekOffDay2 { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class LeaveBalance
    {
        public long RecordId { get; set; }
        public int UserId { get; set; }
        public long LeaveTypeId { get; set; }
        public double Count { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class ClientContact
    {
        public int ContactId { get; set; }
        public int ClientId { get; set; }
        public string Name { get; set; }
        public string Phone { get; set; }
        public string Email { get; set; }
    }

    public class AssetRequest
    {
        public long RequestId { get; set; }
        public long TypeId { get; set; }
        public string Reason { get; set; }
        public long RequiredFromDateId { get; set; }
        public long? RequiredTillDateId { get; set; }
        public long StatusId { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class ClientMessenger
    {
        public int CommunicationId { get; set; }
        public int? ClientId { get; set; }
        public int? CommunicationTypeId { get; set; }
        public string LoginId { get; set; }
    }

    public class LeaveBalanceHistory
    {
        public long Id { get; set; }
        public long RecordId { get; set; }
        public double Count { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
    }

    public class PerformanceReviewForm
    {
        public long FormId { get; set; }
        public int UserId { get; set; }
        public int Year { get; set; }
        public long ReviewPeriodFromDateId { get; set; }
        public long ReviewPeriodTillDateId { get; set; }
        public int StatusId { get; set; }
        public int SelfOverAllRating { get; set; }
        public int AppraiserOverAllRating { get; set; }
        public int ReviewerOverAllRating { get; set; }
        public string SelfFinalComment { get; set; }
        public string AppraiserFinalComment { get; set; }
        public string ReviewerFinalComment { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class Company
    {
        public int CompanyId { get; set; }
        public string CompanyName { get; set; }
        public bool IsActive { get; set; }
    }

    public class ProjectMaster
    {
        public long ProjectId { get; set; }
        public long ClientId { get; set; }
        public long ClientResourceId { get; set; }
        public string ProjectName { get; set; }
        public string ProjectCode { get; set; }
        public string Description { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class CompanyActualEarn
    {
        public int CompanyActualEarnId { get; set; }
        public string ActualEarnTitle { get; set; }
        public string ActualEarnDescription { get; set; }
        public double? Amount { get; set; }
        public DateTime? ActualEarnDate { get; set; }
        public DateTime? ModifyDate { get; set; }
        public int? CompanyId { get; set; }
        public bool? DeleteFlag { get; set; }
        public int? RecurringCode { get; set; }
    }

    public class LeaveHistory
    {
        public long RecordId { get; set; }
        public long LeaveRequestApplicationId { get; set; }
        public long StatusId { get; set; }
        public int? ApproverId { get; set; }
        public string ApproverRemarks { get; set; }
        public DateTime CreatedDate { get; set; }
        public int? CreatedBy { get; set; }
    }

    public class CompanyEventDetail
    {
        public int CompanyEventId { get; set; }
        public int CompanyId { get; set; }
        public int EventAddedBy { get; set; }
        public string EventTitle { get; set; }
        public DateTime EventStartdate { get; set; }
        public DateTime EventEndDate { get; set; }
        public string EventDiscription { get; set; }
        public string EventImagePath { get; set; }
        public bool IsActive { get; set; }
    }

    public class AssetTransaction
    {
        public long TransactionId { get; set; }
        public long RequestId { get; set; }
        public long AssetDetailId { get; set; }
        public long IssueDateId { get; set; }
        public bool IsReturned { get; set; }
        public long? ReturnedOnDateId { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class CompanyExpense
    {
        public int CompanyExpenseId { get; set; }
        public string ExpenseTitle { get; set; }
        public string ExpenseDescription { get; set; }
        public double? Amount { get; set; }
        public DateTime? ExpenseDate { get; set; }
        public DateTime? ModifyDate { get; set; }
        public int? CompanyId { get; set; }
        public bool? DeleteFlag { get; set; }
        public int? RecurringCode { get; set; }
    }

    public class LeaveRequestApplication
    {
        public long LeaveRequestApplicationId { get; set; }
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
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
        public string LeaveCombination { get; set; }
    }

    public class CompanyNewsDetail
    {
        public int CompanyNewsId { get; set; }
        public int CompanyId { get; set; }
        public string News { get; set; }
        public int AddedBy { get; set; }
        public DateTime NewsDate { get; set; }
        public string NewsImagePath { get; set; }
        public bool IsActive { get; set; }
    }

    public class RequestLnsa
    {
        public long RequestId { get; set; }
        public long FromDateId { get; set; }
        public long TillDateId { get; set; }
        public int TotalNoOfDays { get; set; }
        public string Reason { get; set; }
        public string ApproverRemarks { get; set; }
        public int Status { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public long? LastModifiedBy { get; set; }
    }

    public class CompanySetting
    {
        public long SettingId { get; set; }
        public int CompanyId { get; set; }
        public string SettingName { get; set; }
        public string SettingValue { get; set; }
    }

    public class AssetType
    {
        public long TypeId { get; set; }
        public string Type { get; set; }
        public bool IsForTemporaryBasis { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class SupportingStaffMember
    {
        public long RecordId { get; set; }
        public string EmployeeName { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class LeaveRequestApplicationDetail
    {
        public long LeaveRequestApplicationDetailId { get; set; }
        public long LeaveRequestApplicationId { get; set; }
        public long LeaveTypeId { get; set; }
        public double Count { get; set; }
    }

    public class Country
    {
        public int CountryId { get; set; }
        public string CountryName { get; set; }
    }

    public class Currency
    {
        public int CurrencyId { get; set; }
        public string CurrencyName { get; set; }
    }

    public class LeaveStatusMaster
    {
        public long StatusId { get; set; }
        public string StatusCode { get; set; }
        public string Status { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class DailyTimeSheet
    {
        public int TimeSheetId { get; set; }
        public int EmployeeId { get; set; }
        public int? ManagerId { get; set; }
        public int? ProjectId { get; set; }
        public string ProjectTask { get; set; }
        public DateTime? TimeSheetDate { get; set; }
        public double TotalHours { get; set; }
        public bool IsBillable { get; set; }
        public int TimeSheetStatus { get; set; }
    }

    public class ClientSideManagerMaster
    {
        public long ClientSideManagerId { get; set; }
        public long ClientId { get; set; }
        public string ManagerName { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class GeminiTimeSheetFinalTasks1
    {
        public long RecordId { get; set; }
        public int UserId { get; set; }
        public string UserName { get; set; }
        public long WeekId { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public int WeekNo { get; set; }
        public int Year { get; set; }
        public DateTime TaskDate { get; set; }
        public long ProjectId { get; set; }
        public string ProjectName { get; set; }
        public string TaskDescription { get; set; }
        public string TaskTeamName { get; set; }
        public string TaskType { get; set; }
        public string TaskSubDetail1 { get; set; }
        public string TaskSubDetail2 { get; set; }
        public decimal TimeSpent { get; set; }
        public string TeamName { get; set; }
        public int Status { get; set; }
        public bool ConsiderInReports { get; set; }
    }

    public class PerformanceReviewFormStatus
    {
        public int StatusId { get; set; }
        public string Status { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public int? LastModifiedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
    }

    public class Department
    {
        public int DepartmentId { get; set; }
        public string DepartmentName { get; set; }
        public string Description { get; set; }
    }

    public class LeaveTypeMaster
    {
        public long TypeId { get; set; }
        public string ShortName { get; set; }
        public string Description { get; set; }
        public int Priority { get; set; }
        public bool IsAvailableForMarriedOnly { get; set; }
        public bool IsAvailableForMale { get; set; }
        public bool IsAvailableForFemale { get; set; }
        public int? MaximumNoForMale { get; set; }
        public int? MaximumNoForFemale { get; set; }
        public int? MaximumLimitForMale { get; set; }
        public int? MaximumLimitForFemale { get; set; }
        public string MaximumLimitPeriod { get; set; }
        public bool IsAutoIncremented { get; set; }
        public int? AutoIncrementPeriod { get; set; }
        public string AutoIncrementAfterType { get; set; }
        public DateTime? LastAutoIncrementDate { get; set; }
        public DateTime? NextAutoIncrementDate { get; set; }
        public int? DaysToIncrement { get; set; }
        public bool IsAutoExpire { get; set; }
        public int? AutoExpirePeriod { get; set; }
        public string AutoExpireAfterType { get; set; }
        public DateTime? LastAutoExpireDate { get; set; }
        public DateTime? NextAutoExpireDate { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class Designation
    {
        public int DesignationId { get; set; }
        public string DesignationName { get; set; }
        public bool IsIntern { get; set; }
    }

    /// <summary>
    /// Enum of Table Designation
    /// </summary>		
    public enum Designations
    {
        CEO = 1,
        SeniorManager = 2,
        SeniorAnalystL3 = 3,
        SeniorAnalystL2 = 4,
        SeniorAnalystL1 = 5,
        SeniorAnalyst = 6,
        SeniorAssociateAnalystL3 = 7,
        SeniorAssociateAnalystL2 = 8,
        SeniorAssociateAnalystL1 = 9,
        SeniorAssociateAnalyst = 10,
        AnalystL2 = 11,
        AnalystL1 = 12,
        SeniorAnalystL4 = 13,
        SeniorConsultantL2 = 14,
        SeniorConsultantL1 = 15,
        Consultant = 16,
        ConsultantL1 = 17,
        AssociateAnalystL3 = 18,
        AssociateAnalystL2 = 19,
        AssociateAnalystL1 = 20,
        AssistantManagerHR = 21,
        AdministrationManagerL1 = 22,
        SeniorWindowsAdministratorL1 = 23,
        SeniorQualityAssuranceAnalyst = 24,
        SeniorBusinessDevelopmentManager = 25,
        Intern = 26,
        ProbationaryIntern = 27,
        OfficeBoy = 28,
        Sweeper = 29,
        SeniorOracleDatabaseAdministrator = 30,
        SeniorSoftwareEngineerL1 = 31,
        AccountsExecutive = 32,
        SoftwareEngineerL1 = 33,
        SoftwareEngineerL2 = 34,
        AccountManagerL1 = 35,
        AccountManagerL2 = 36,
        BusinessAnalystL1 = 38,
        BusinessAnalystL2 = 39,
        BusinessHeadL1 = 40,
        BusinessHeadL2 = 41,
        ChiefIOTOfficerL1 = 42,
        ChiefIOTOfficerL2 = 43,
        ITAnalystNetworking = 44,
        LeadBusinessAnalystL1 = 45,
        LeadBusinessAnalystL2 = 46,
        LeadProjectManagerL1 = 47,
        LeadProjectManagerL2 = 48,
        ManagementInternL1 = 49,
        ManagementInternL2 = 50,
        ManagerAdministrationL1 = 51,
        ManagerHumanResourceL1 = 52,
        PresidentL1 = 53,
        PresidentL2 = 54,
        ProjectManagerL1 = 55,
        ProjectManagerL2 = 56,
        SeniorBusinessAnalystL1 = 57,
        SeniorBusinessAnalystL2 = 58,
        TechnicalInternL1 = 63,
        TechnicalInternL2 = 64,
        TechnologySolutionsArchitectL1 = 65,
        TechnologySolutionsArchitectL2 = 66,
        TechnologySolutionsLeadL1 = 67,
        TechnologySolutionsLeadL2 = 68,
        TechnologySolutionsManagerL1 = 69,
        TechnologySolutionsManagerL2 = 70,
        VicePresident = 71,
        SeniorVicePresident = 72,
        NetworkEngineerL1 = 73,
        NetworkEngineerL2 = 74,
        AdministrationExecutiveL1 = 75,
        ContentWriterL1 = 76,
        HumanResourceExecutiveL1 = 77,
        HumanResourceExecutiveL2 = 78,
        MarketingTrainee = 79,
        ChiefInformationOfficer = 80,
        ChiefTechnicalOfficer = 81,
        AssociateAcademicConsultantTrainee = 82,
        GET = 83,
        TechnicalTrainee = 84,
        AccountsTrainee = 85,
        ManagerAdministrationL2 = 88,
        SeniorSoftwareEngineerL2 = 89,
        ManagerHumanResourceL2 = 90,
        InformationTechnologyAnalystL1 = 91,
        InformationTechnologyAnalystL2 = 92,
        SeniorNetworkEngineerL1 = 93,
        SeniorNetworkEngineerL2 = 94,
        SeniorAccountsExecutiveL1 = 95,
        SeniorAccountsExecutiveL2 = 96,
        BusinessDevelopmentExecutiveL1 = 97,
        BusinessDevelopmentExecutiveL2 = 98,
        SeniorAdminExecutiveL1 = 100,
        SeniorAdminExecutiveL2 = 101,
        CreativeHeadL1 = 102,
        CreativeHeadL2 = 103,
        HumanResourceTrainee = 104,
    }

    public class DepartmentManagerMapping
    {
        public long MappingId { get; set; }
        public int DepartmentId { get; set; }
        public int UserId { get; set; }
        public int MaximumLimit { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class GeminiTimeSheetFinalTask
    {
        public long RecordId { get; set; }
        public int UserId { get; set; }
        public string UserName { get; set; }
        public long WeekId { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public int WeekNo { get; set; }
        public int Year { get; set; }
        public DateTime TaskDate { get; set; }
        public long ProjectId { get; set; }
        public string ProjectName { get; set; }
        public string TaskDescription { get; set; }
        public string TaskTeamName { get; set; }
        public string TaskType { get; set; }
        public string TaskSubDetail1 { get; set; }
        public string TaskSubDetail2 { get; set; }
        public decimal TimeSpent { get; set; }
        public string TeamName { get; set; }
        public int Status { get; set; }
        public bool? ConsiderInReports { get; set; }
    }

    public class Document
    {
        public int DocId { get; set; }
        public string Path { get; set; }
        public string Description { get; set; }
        public int? GroupId { get; set; }
        public string FileDiscription { get; set; }
        public string Tags { get; set; }
        public DateTime? Date { get; set; }
        public int? DeleteFlag { get; set; }
        public int? UserId { get; set; }
        public string ShowDate { get; set; }
        public string userAbrhs { get; set; }
        public string action { get; set; }
        public string FileBase64 { get; set; }
        public bool IsActive { get; set; }
    }

    public class TimeSheet
    {
        public long TimeSheetId { get; set; }
        public int WeekNo { get; set; }
        public int? CurrentWeekNo { get; set; }
        public int Year { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public decimal TotalHoursLogged { get; set; }
        public int Status { get; set; }
        public string UserRemarks { get; set; }
        public string ApproverRemarks { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
        public DateTime? SubmittedDate { get; set; }
        public string userAbrhs { get; set; }
    }

    public class RequestCompOff
    {
        public long RequestId { get; set; }
        public long DateId { get; set; }
        public int NoOfDays { get; set; }
        public string Reason { get; set; }
        public long StatusId { get; set; }
        public int? ApproverId { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class UserFeedback
    {
        public int FeedbackId { get; set; }
        public string Remarks { get; set; }
        public string RandomCode { get; set; }
        public bool IsExpired { get; set; }
        public bool? IsAcknowledged { get; set; }
        public int? AcknowledgedBy { get; set; }
        public DateTime? AcknowledgedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
    }

    public class DocumentGroup
    {
        public int DocGroupId { get; set; }
        public string Name { get; set; }
        public int? ParentId { get; set; }
        public int? UserID { get; set; }
        public bool? DeleteFlag { get; set; }
        public string UserAbrhs { get; set; }
        public string action { get; set; }
    }

    public class DepartmentWiseAssetLimit
    {
        public long LimitId { get; set; }
        public int DepartmentId { get; set; }
        public long TypeId { get; set; }
        public int MaximumLimit { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class DocumentPermissionGroup
    {
        public int DocumentPermissionGroupId { get; set; }
        public string Name { get; set; }
        public int CreatedByUserId { get; set; }
        public string userAbrhs { get; set; }
    }

    public class RequestCompOffHistory
    {
        public long RecordId { get; set; }
        public long RequestId { get; set; }
        public long StatusId { get; set; }
        public int ApproverId { get; set; }
        public string ApproverRemarks { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
    }

    public class PerformanceReviewHtmlTemplate
    {
        public int PerformanceReviewHtmlTemplateId { get; set; }
        public long SectionId { get; set; }
        public string TemplateName { get; set; }
        public string Template { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class DocumentPermissionGroupPermission
    {
        public int DocumentPermissionGroupPermissionsId { get; set; }
        public int DocumentPermissionGroupId { get; set; }
        public int UserId { get; set; }
        public bool IsDeleted { get; set; }
        public string userAbrhs { get; set; }
    }

    public class ClientResourceMaster
    {
        public long ClientResourceId { get; set; }
        public string ResourceName { get; set; }
        public long ClientId { get; set; }
        public string ClientProjectName { get; set; }
        public string ClientProjectCode { get; set; }
        public string ClientProjectDescription { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class ShiftMaster
    {
        public string ShiftAbrhs { get; set; }
        public string UserAbrhs { get; set; }
        public string ShiftName { get; set; }       
        public string InTime { get; set; }
        public string OutTime { get; set; }
        public string WorkingHours { get; set; }
        public bool IsWeekEnd { get; set; }
        public bool IsNight { get; set; }
       
    }

    public class DocumentTag
    {
        public long DocumentTagId { get; set; }
        public string Name { get; set; }
    }

    public class CardPunchinDatum
    {
        public long RecordId { get; set; }
        public string CardNo { get; set; }
        public string Name { get; set; }
        public long DateId { get; set; }
        public DateTime Date { get; set; }
        public DateTime InTime { get; set; }
        public DateTime? OutTime { get; set; }
    }

    public class Emp_ReviewCycle
    {
        public int EmpReviewCycleId { get; set; }
        public int? EmpId { get; set; }
        public int ReviewCycleId { get; set; }
    }

    public class UserShiftMapping
    {
        public long MappingId { get; set; }
        public long DateId { get; set; }
        public int UserId { get; set; }
        public long ShiftId { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }
    public class UserShiftMappingList
    {   
        public long DateId { get; set; }
        public string UserAbrhs { get; set; }
        public string ShiftAbrhs { get; set; }
        public string LoginUserAbrhs { get; set; }
        public string Message { get; set; }
    }

    public class DateWiseAttendance
    {
        public long RecordId { get; set; }
        public long DateId { get; set; }
        public int UserId { get; set; }
        public DateTime? SystemGeneratedInTime { get; set; }
        public DateTime? SystemGeneratedOutTime { get; set; }
        public DateTime? SystemGeneratedTotalWorkingHours { get; set; }
        public long SystemGeneratedStatusId { get; set; }
        public string SystemGeneratedRemarks { get; set; }
        public DateTime? UserGivenInTime { get; set; }
        public DateTime? UserGivenOutTime { get; set; }
        public DateTime? UserGivenTotalWorkingHours { get; set; }
        public long? UserGivenStatusId { get; set; }
        public string UserGivenRemarks { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class EmployeeAcademic
    {
        public int EducationalDetailId { get; set; }
        public int EmployeeId { get; set; }
        public string HighSchoolBoard { get; set; }
        public string HighSchoolPassoutYear { get; set; }
        public string HighSchoolPercentage { get; set; }
        public string IntermediateBoard { get; set; }
        public string IntermediateYear { get; set; }
        public string IntermediatePercentage { get; set; }
        public string GraduationUniversity { get; set; }
        public string GraduationYear { get; set; }
        public string GraduationPercentage { get; set; }
        public string GraduationCourse { get; set; }
        public string PostGraduationUniversity { get; set; }
        public string PosGraduationYear { get; set; }
        public string PostGraduationPercent { get; set; }
        public string PostGraduationCourse { get; set; }
    }

    public class PerformanceReviewNextYearGoal
    {
        public long GoalId { get; set; }
        public string Goal { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class EmployeeAsstWeeklyOffGroup
    {
        public int EmployeeAsstWeeklyOffGroupId { get; set; }
        public int? EmpId { get; set; }
        public int? WeeklyOffGroupId { get; set; }
        public int? UserId { get; set; }
        public bool? IsDeleted { get; set; }
    }

    public class EmployeeBankDetail
    {
        public int BankDetailId { get; set; }
        public int UserId { get; set; }
        public string BankName { get; set; }
        public string BranchAddress { get; set; }
        public string IFSCCode { get; set; }
        public string AccountType { get; set; }
        public string AccountNumber { get; set; }
        public string AccountHolderName { get; set; }
        public string PancardNumber { get; set; }
    }

    public class PerformanceReviewSection
    {
        public long SectionId { get; set; }
        public string Section { get; set; }
        public int Year { get; set; }
        public int Priority { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class EmployeeIncentive
    {
        public int EmployeeIncentiveId { get; set; }
        public int EmployeeId { get; set; }
        public int IncentiveId { get; set; }
        public double IncentiveValue { get; set; }
        public DateTime IncentiveDate { get; set; }
    }

    public class EmployeeJobStatus
    {
        public int EmployeeJobStatusId { get; set; }
        public string Details { get; set; }
    }

    public class UserClientSideManagerAndProjectMapping
    {
        public long MappingId { get; set; }
        public long ClientSideManagerId { get; set; }
        public long ProjectId { get; set; }
        public int UserId { get; set; }
        public bool IsBilled { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class EmployeeLeaveManagement
    {
        public int EmpLeaveManagementId { get; set; }
        public int LeaveApplicationId { get; set; }
        public int LeaveTypeId { get; set; }
        public double? NoOfLeave { get; set; }
        public double? PendingLeave { get; set; }
    }

    public class EmployeeManager
    {
        public int RelationshipId { get; set; }
        public int EmployeeId { get; set; }
        public int ManagerId { get; set; }
        public bool IsActive { get; set; }
    }

    public class EmployeeMonthlySalary
    {
        public int EmployeeSalaryId { get; set; }
        public int EmployeeId { get; set; }
        public DateTime SalaryDate { get; set; }
        public int PaymentMode { get; set; }
        public string DDChequeNumber { get; set; }
        public double MonthlySalary { get; set; }
        public int? ReviewIdTax { get; set; }
        public int? ReviewIdAllowance { get; set; }
        public double? MonthlyGrossSalary { get; set; }
        public double? TaxableMonthlyIncome { get; set; }
        public double? PaidMonthlyTax { get; set; }
        public int? FinancialYear { get; set; }
        public double? Bonus { get; set; }
        public double? Deduction { get; set; }
        public int? SalarySummaryId { get; set; }
        public int? MonthId { get; set; }
        public int? Year { get; set; }
        public double? NetPaySalary { get; set; }
        public double? LeaveToDeductSalary { get; set; }
    }

    public class UserAppraisalLastYearGoalRating
    {
        public long RecordId { get; set; }
        public long GoalId { get; set; }
        public int Rating { get; set; }
        public string Comment { get; set; }
        public string OtherComment { get; set; }
        public int UserRole { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class EmployeeProfessionalDetail
    {
        public int ProfessionalDetailId { get; set; }
        public int? EmployeeId { get; set; }
        public int? JobCategoryId { get; set; }
        public int? TechnologyId { get; set; }
        public string KeySkills { get; set; }
        public bool? IsExperienced { get; set; }
        public string ExperienceYears { get; set; }
        public string ExperienceMonths { get; set; }
    }

    public class ExpenseFactor
    {
        public int ExpenseFactorId { get; set; }
        public int CompanyId { get; set; }
        public DateTime ExpenseFactorDate { get; set; }
        public double ExpenseFactorValue { get; set; }
    }

    public class CertificationsAndReward
    {
        public long RecordId { get; set; }
        public long ProfileId { get; set; }
        public string CertificationAndReward { get; set; }
        public int Type { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class ExpenseType
    {
        public int ExpenseTypeId { get; set; }
        public string ExpenseTypeName { get; set; }
    }

    public class FinancialYear
    {
        public int FinancialYearId { get; set; }
        public string FY { get; set; }
    }

    public class EmployeeProfile
    {
        public long ProfileId { get; set; }
        public int UserId { get; set; }
        public string About { get; set; }
        public string Skills { get; set; }
        public bool IsDeleted { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class GeminiEmployeeAppraisal
    {
        public int GeminiEmployeeAppraisalId { get; set; }
        public int UserId { get; set; }
        public string LastAppraisalRedeemed { get; set; }
        public string LastAppraisalRating { get; set; }
        public string NextAppraisalDue { get; set; }
        public DateTime DateCreated { get; set; }
        public bool IsDeleted { get; set; }
    }

    public class UserPerformanceReviewCommentsForHeader
    {
        public int RecordId { get; set; }
        public long UserPerformanceReviewCriteriaHeaderMappingId { get; set; }
        public string Comments { get; set; }
        public string OtherComment { get; set; }
        public int UserRole { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public int? LastModifiedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
    }

    public class GeminiEmployeeDetail
    {
        public long GeminiEmployeeDetailId { get; set; }
        public int UserId { get; set; }
        public bool Kids { get; set; }
        public string FatherName { get; set; }
        public string CurrentPackage { get; set; }
        public string PresentAddress { get; set; }
        public string Pan { get; set; }
        public int DepartmentId { get; set; }
        public int? LastDesignationId { get; set; }
        public string SittingFloor { get; set; }
        public string AssignedWorkStation { get; set; }
        public string LockerNumber { get; set; }
        public string IssuedLaptopDetail { get; set; }
        public string IssuedDesktopDetail { get; set; }
        public string IssuedMobileDetail { get; set; }
        public string IssuedOtherMaterialDetail { get; set; }
        public string DocumentStatus { get; set; }
        public string PendingDocumentDetail { get; set; }
        public string IdCardStatus { get; set; }
        public string VisitingCardStatus { get; set; }
        public string InsuranceStatus { get; set; }
        public string InsuranceAmount { get; set; }
        public string BankAccountStatus { get; set; }
        public string ProductionStatus { get; set; }
        public bool IsDeleted { get; set; }
        public string Extension { get; set; }
    }

    public class UserPerformanceReviewCriteriaHeaderMapping
    {
        public long RecordId { get; set; }
        public int UserId { get; set; }
        public long HeaderId { get; set; }
        public int Year { get; set; }
        public int Status { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class ProfileRequest
    {
        public long RequestId { get; set; }
        public int RequestedById { get; set; }
        public int RequestedForId { get; set; }
        public string RandomCode { get; set; }
        public bool IsExpired { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
    }

    //public class UserTeamMapping
    //{
    //    public long RecordId { get; set; }
    //    public int UserId { get; set; }
    //    public long TeamId { get; set; }
    //    public bool ConsiderInClientReports { get; set; }
    //    public bool IsActive { get; set; }
    //    public DateTime CreatedDate { get; set; }
    //    public int CreatedBy { get; set; }
    //    public DateTime? LastModifiedDate { get; set; }
    //    public int? LastModifiedBy { get; set; }
    //}

    public class ManageUserTeamMappingBO
    {
        public ManageUserTeamMappingBO()
        {
            UserTeamList = new List<UserTeamBO>();
        }
        public string UserAbrhs { get; set; }
        public string TeamAbrhs { get; set; }
        public bool IsAdded { get; set; }  
        public List<UserTeamBO> UserTeamList { get; set; }
    }


    public class UserTeamBO
    {
        public string EmployeeAbrhs { get; set; }
        public bool ConsiderInClientReports { get; set; }
        public string RoleAbrhs { get; set; }
    }
    public class ReturnTeamUserMappingBO
    {
        public int Success { get; set; }
        public string ExistingIds { get; set; }
        
    }

    public class GeminiLoyaltyBonu
    {
        public int GeminiLoyaltyBonusId { get; set; }
        public int UserId { get; set; }
        public DateTime? LastAvailedDate { get; set; }
        public string BonusOutstanding { get; set; }
        public DateTime NextAvailDueDate { get; set; }
        public string BonusForRedemption { get; set; }
        public bool IsDeleted { get; set; }
    }

    public class VisitorDetail0
    {
        public int VisitorId { get; set; }
        public string Visitor_FName { get; set; }
        public string Visitor_LName { get; set; }
        public string Visitor_Address { get; set; }
        public string Visitor_ContactNo { get; set; }
        public string Visitor_Email { get; set; }
        public string Visitor_AppointmentWith { get; set; }
        public string Visitor_Purpose { get; set; }
        public string Visitor_IdentityProof { get; set; }
        public DateTime Visitor_TimeIn { get; set; }
        public DateTime? Visitor_timeOut { get; set; }
        public string Visitor_PhotoUrl { get; set; }
        public string Visitor_IdPhotoUrl { get; set; }
        public string otheridcard { get; set; }
    }

    public class Gender
    {
        public int GenderId { get; set; }
        public string GenderType { get; set; }
    }

    public class GeminiProjectIndustryType
    {
        public long IndustryTypeId { get; set; }
        public string IndustryType { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class UserPerformanceReviewCriteriaMapping
    {
        public long RecordId { get; set; }
        public int UserId { get; set; }
        public long CriteriaId { get; set; }
        public int Year { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class HRACalculation
    {
        public int HRACalculationId { get; set; }
        public double? PercentPaidRentExceedOfBS { get; set; }
        public double? PercentAmtOfBS { get; set; }
        public double? PercentAmtOfGrossSalary { get; set; }
        public int? FinancialYear { get; set; }
    }

    public class Incentive
    {
        public int IncentiveId { get; set; }
        public string IncentiveType { get; set; }
    }

    public class LoginDetail
    {
        public long LoginDetailId { get; set; }
        public int UserId { get; set; }
        public string IPAddress { get; set; }
        public string Browser { get; set; }
        public string Device { get; set; }
        public bool IsLoginSuccessful { get; set; }
        public DateTime LoginDate { get; set; }
    }

    public class Industry
    {
        public int IndustryTypeId { get; set; }
        public string IndustryType { get; set; }
    }

    public class GeminiProject
    {
        public long ProjectId { get; set; }
        public long? ParentProjectId { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public long VerticalId { get; set; }
        public long IndustryTypeId { get; set; }
        public long StatusId { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
        public string userAbrhs { get; set; }
        public string ShowStartDate { get; set; }
        public string ShowEndDate { get; set; }
    }


    public class PimcoProject
    {
        public int PimcoProjectId { get; set; }
        public int ParentProjectId { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public long VerticalId { get; set; }
        public long IndustryTypeId { get; set; }
        public long StatusId { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public int? ModifiedBy { get; set; }
        public string userAbrhs { get; set; }
        public string ShowStartDate { get; set; }
        public string ShowEndDate { get; set; }
    }

    public class AccessCard
    {
        public int AccessCardId { get; set; }
        public string AccessCardNo { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
        public bool IsTemporary { get; set; }
        public bool IsPimco { get; set; }
    }

    public class InvoiceClientDetail
    {
        public int InvoiceId { get; set; }
        public int CompanyId { get; set; }
        public int ClientId { get; set; }
        public string ClientInvoiceId { get; set; }
        public string InvoiceReferenceId { get; set; }
        public DateTime InvoiceDate { get; set; }
        public int? PaymentTerms { get; set; }
        public string PaymentMethod { get; set; }
        public int InvoiceTemplate { get; set; }
        public string InvoiceType { get; set; }
        public string Message { get; set; }
        public long InvoiceSuffixId { get; set; }
        public bool? IsInvoiceActive { get; set; }
        public bool? IsPaymentReceived { get; set; }
        public int? CurrencyId { get; set; }
        public DateTime InvoiceDueDate { get; set; }
    }

    public class UserPerformanceReviewCriteriaResponse
    {
        public int RecordId { get; set; }
        public long UserPerformanceReviewCriteriaMappingId { get; set; }
        public string Response { get; set; }
        public DateTime? CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
        public bool? IsActive { get; set; }
    }

    public class InvoicePaymentAmmount
    {
        public int InvoiceAmmountId { get; set; }
        public double SubTotalAmmount { get; set; }
        public double? ServiceTaxAmmount { get; set; }
        public double TotalAmmount { get; set; }
        public string Comments { get; set; }
        public double? PaidAmount { get; set; }
        public DateTime? PaymentDate { get; set; }
        public int? PaymentModeId { get; set; }
        public string DetailNumber { get; set; }
        public string BankName { get; set; }
        public int InvoiceId { get; set; }
    }

    public class InvoicePaymentDetail
    {
        public int InvoicePaymentId { get; set; }
        public int InvoiceProjectId { get; set; }
        public string Discription { get; set; }
        public double? Units { get; set; }
        public double? UnitPrice { get; set; }
        public double LineTotal { get; set; }
    }

    public class GeminiProjectStatus
    {
        public long ProjectStatusId { get; set; }
        public string ProjectStatus { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class UserPerformanceReviewRating
    {
        public int RecordId { get; set; }
        public long UserPerformanceReviewCriteriaMappingId { get; set; }
        public int? Rating { get; set; }
        public int UserRole { get; set; }
        public DateTime? CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
        public bool? isActive { get; set; }
        public bool? isDeleted { get; set; }
    }

    public class InvoiceProjectDetail
    {
        public int InvoiceJobId { get; set; }
        public int InvoiceClientId { get; set; }
        public string SalesPerson { get; set; }
        public string ProjectJob { get; set; }
        public int ProjectId { get; set; }
        public int InvoiceStatus { get; set; }
    }

    public class AttendanceReportAccess
    {
        public long RecordId { get; set; }
        public long TeamId { get; set; }
        public int UserId { get; set; }
        public bool SendAutomatedEmails { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class InvoiceTemplate
    {
        public int InvoiceTemplateId { get; set; }
        public int InvoiceCompanyId { get; set; }
        public string InvoiceTemplateTitle { get; set; }
        public string InvoiceTemplatePath { get; set; }
    }

    public class UserAccessCard
    {
        public int UserAccessCardId { get; set; }
        public int UserId { get; set; }
        public int AccessCardId { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
        public bool IsFinalised { get; set; }
        public bool IsPimco { get; set; }
    }

    public class UserPerformanceReviewSectionMapping
    {
        public long RecordId { get; set; }
        public int UserId { get; set; }
        public long SectionId { get; set; }
        public int Year { get; set; }
        public int Status { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class JobCategory
    {
        public int JobCategoryId { get; set; }
        public string JobCategoryType { get; set; }
    }

    public class ManpowerRequisitionInvite
    {
        public long InviteId { get; set; }
        public string ToEmailId { get; set; }
        public string Name { get; set; }
        public string Position { get; set; }
        public string RandomCode { get; set; }
        public int? Status { get; set; }
        public DateTime CreatedDate { get; set; }
        public long CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public long? LastModifiedBy { get; set; }
    }

    public class GeminiProjectTeamMember
    {
        public long RecordId { get; set; }
        public long ProjectId { get; set; }
        public int UserId { get; set; }
        public string Role { get; set; }
        public bool IsActive { get; set; }
        public DateTime AllocatedFrom { get; set; }
        public DateTime? AllocatedTill { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
        public string userAbrhs { get; set; }
        public string EmployeeAbrhs { get; set; }
    }

    public class PimcoProjectTeamMember
    {
        public long RecordId { get; set; }
        public int PimcoProjectId { get; set; }
        public int UserId { get; set; }
        public string ProjectRole { get; set; }
        public DateTime AllocatedFrom { get; set; }
        public DateTime? AllocatedTill { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedById { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public int? ModifiedById { get; set; }
        public string userAbrhs { get; set; }
        public string EmployeeAbrhs { get; set; }
    }


    public class LeaveApplication
    {
        public int LeaveApplicationId { get; set; }
        public int LeaveTypeId { get; set; }
        public DateTime FromDate { get; set; }
        public DateTime ToDate { get; set; }
        public double? WorkingDayLeave { get; set; }
        public int? ApprovingOfficerId { get; set; }
        public string AddressWhileOnLeave { get; set; }
        public string ContactNoWhileOnLeave { get; set; }
        public string Reason { get; set; }
        public DateTime? ApplyDate { get; set; }
        public int StatusId { get; set; }
        public int? YearId { get; set; }
        public DateTime? ReplyDate { get; set; }
        public string ReplyRemark { get; set; }
        public double? PendingLeave { get; set; }
        public double? SpecificLeave { get; set; }
        public bool? IsDeleted { get; set; }
        public int UserId { get; set; }
        public bool? IsFromDateHalfDay { get; set; }
        public bool? IsToDateHalfDay { get; set; }
        public int? CurrentApprovalLevel { get; set; }
        public int? TotalApprovalLevel { get; set; }
        public int? LeaveApprovalLevelId { get; set; }
    }

    public class GeminiProjectVertical
    {
        public long VerticalId { get; set; }
        public string Vertical { get; set; }
        public int OwnerId { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
        public string userAbrhs { get; set; }
        public string VerticalAbrhs { get; set; }
    }

    public class LeaveApplicationApprovalLabelAsst
    {
        public int LeaveApplicationApprovalLabelAsstId { get; set; }
        public int LeaveApplicationId { get; set; }
        public int ApprovalLevelId { get; set; }
        public int? EmpId { get; set; }
        public int ApplicationStatusId { get; set; }
        public DateTime? ReplyDate { get; set; }
        public string ReplyRemark { get; set; }
        public int? RoleId { get; set; }
        public int? CurrentApprovalLevel { get; set; }
        public int? TotalApprovalLevel { get; set; }
    }

    public class LeaveApplicationStatus
    {
        public int LeaveApplicationStatusId { get; set; }
        public string StatusName { get; set; }
    }

    /// <summary>
    /// Enum of Table LeaveApplicationStatus
    /// </summary>		
    public enum LeaveApplicationStatuses
    {
        Pending = 1,
        Approved = 2,
        Rejected = 3,
    }

    public class LeaveApprovalLabel
    {
        public int LeaveApprovalLabelId { get; set; }
        public string LabelName { get; set; }
        public int? SeniorLabelId { get; set; }
        public bool? IsDeleted { get; set; }
        public int? LabelNumber { get; set; }
        public int LeaveTypeId { get; set; }
    }

    public class LeaveApprovalLabelEmpAsst
    {
        public int ApprovalLabelEmpAsstId { get; set; }
        public int ApprovalLabelId { get; set; }
        public int EmpId { get; set; }
        public bool? IsDeleted { get; set; }
        public int UserId { get; set; }
    }

    public class LeaveApprovalLevel
    {
        public int LeaveApprovalLevelId { get; set; }
        public int LevelNum { get; set; }
        public int LeaveTypeId { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime? DateCreated { get; set; }
    }

    public class TimeSheetReportAccess
    {
        public long MappingId { get; set; }
        public long TeamId { get; set; }
        public int UserId { get; set; }
        public bool IsAvailableForAutomatedEmails { get; set; }
        public bool IsForAllTeamMembers { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class LeaveApprovalLevelRole
    {
        public int LeaveApprovalLevelRoleId { get; set; }
        public int RoleId { get; set; }
        public int LeaveApprovalLevelId { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime? DateCreated { get; set; }
    }

    public class LeaveRequest
    {
        public int LeaveRequestId { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public string Description { get; set; }
        public int? LeaveType { get; set; }
    }

    public class LeaveType
    {
        public int LeaveTypeId { get; set; }
        public string ShortName { get; set; }
        public string Detail { get; set; }
        public int? NumberOfLeave { get; set; }
        public int? CalendarYearId { get; set; }
        public double? NoOfLeaveInMonth { get; set; }
        public bool? IsDeleted { get; set; }
        public int? LeaveTypeStatusId { get; set; }
    }

    public class LeaveTypeAccrualEmployeeGroup
    {
        public int AccrualEmpGroupId { get; set; }
        public string GroupName { get; set; }
        public int? MinLeaveAccrual { get; set; }
        public int? MaxLeaveAccrual { get; set; }
        public int? LeaveTypeId { get; set; }
        public int? AccrualFrequencyId { get; set; }
        public int? AccrualCreditingId { get; set; }
        public bool IsDeleted { get; set; }
    }

    public class LeaveTypeAccrualGroupEmployeeRelation
    {
        public int LeaveTypeAccrualGroupEmployeId { get; set; }
        public int UserId { get; set; }
        public int LeaveTypeAccrualGroupId { get; set; }
        public bool IsDeleted { get; set; }
    }

    public class ProfessionalAndEducationalExperience
    {
        public long RecordId { get; set; }
        public long ProfileId { get; set; }
        public DateTime FromDate { get; set; }
        public DateTime TillDate { get; set; }
        public string OrganizationName { get; set; }
        public string DesignationOrField { get; set; }
        public string Role { get; set; }
        public int Type { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public int? LastModifiedBy { get; set; }
    }

    public class LeaveTypeApply
    {
        public int ApplyId { get; set; }
        public int? LeaveTypeId { get; set; }
        public int? DesignationId { get; set; }
        public int? JobStatusId { get; set; }
        public int? FromYearOfService { get; set; }
        public int? ToYearOfService { get; set; }
        public int? AccrualEmpGroupId { get; set; }
        public int? GradeId { get; set; }
        public int? DepartmentId { get; set; }
    }

    public class LeaveTypeCarryForwardRule
    {
        public int CarryForwardRuleId { get; set; }
        public int? TakeLeaveWithinMonths { get; set; }
        public int? MaxLeaveToCarryForward { get; set; }
        public int? LeaveTypeId { get; set; }
    }

    public class LeaveTypeGeneralRule
    {
        public int GeneralRuleId { get; set; }
        public bool CanAdminManage { get; set; }
        public bool CanSupervisorManage { get; set; }
        public bool CanEmployeeApply { get; set; }
        public bool IsEnableAccrual { get; set; }
        public bool IsEnableCarryForward { get; set; }
        public int? LeaveTypeId { get; set; }
    }

    public class LeaveTypeRestriction
    {
        public int ApplyRestrictionId { get; set; }
        public bool IsNotAllowedMoreThanLeaveBalance { get; set; }
        public bool IsNotAllowedPartialLeave { get; set; }
        public int? MinServicePeriodRequired { get; set; }
        public int? MaxConsecutiveLeave { get; set; }
        public int? LeaveTypeId { get; set; }
    }

    public class LeaveTypeStatus
    {
        public int LeaveTypeStatusId { get; set; }
        public string LeaveTypeStatusName { get; set; }
    }

    /// <summary>
    /// Enum of Table LeaveTypeStatus
    /// </summary>		
    public enum LeaveTypeStatuses
    {
        None = 1,
        PaidLeave = 2,
        CarryForwardLeave = 3,
    }

    public class LeaveTypeWhoWillApprove
    {
        public int LeaveTypeWhoWillApproveId { get; set; }
        public int? LeaveTypeId { get; set; }
        public int? UserRoleId { get; set; }
    }

    public class ListofHoliday
    {
        public long HolidayId { get; set; }
        public long DateId { get; set; }
        public string Holiday { get; set; }
        public DateTime CreatedDate { get; set; }
        public int? CreatedBy { get; set; }
    }

    public class ManageResource
    {
        public int ExpenseId { get; set; }
        public int ExpenseTypeId { get; set; }
        public int ResourceTypeId { get; set; }
        public int VendorId { get; set; }
        public string AuthorisedPersonName { get; set; }
        public string ActivePersonName { get; set; }
        public int? Quantity { get; set; }
        public string PaymentType { get; set; }
        public string ExpenseSummary { get; set; }
        public string ExpenseDate { get; set; }
        public int? ExpenseAmmount { get; set; }
        public int? TotalResourceCount { get; set; }
    }

    public class VisitorDetail
    {
        public int VisitorId { get; set; }
        public string Visitor_FName { get; set; }
        public string Visitor_LName { get; set; }
        public string Visitor_Address { get; set; }
        public string Visitor_ContactNo { get; set; }
        public string Visitor_Email { get; set; }
        public string Visitor_AppointmentWith { get; set; }
        public string Visitor_Purpose { get; set; }
        public string Visitor_IdentityProof { get; set; }
        public DateTime Visitor_TimeIn { get; set; }
        public DateTime? Visitor_timeOut { get; set; }
        public string Visitor_PhotoUrl { get; set; }
        public string Visitor_IdPhotoUrl { get; set; }
        public string otheridcard { get; set; }
        public string AccessoriesPhotoUrl { get; set; }
        public int? ReadPolicy { get; set; }
        public string OtherPurpose { get; set; }
        public string Colleagues { get; set; }
        public string Visitor_cardno { get; set; }
        public string CompanyName { get; set; }
    }

    public class MaritalStatus
    {
        public int MaritalStatusId { get; set; }
        public string MaritalStatusType { get; set; }
    }

}
