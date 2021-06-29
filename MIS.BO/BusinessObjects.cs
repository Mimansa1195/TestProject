using System;
using System.Collections.Generic;
using System.Data.SqlTypes;
using System.Net.Mail;
using Microsoft.SqlServer.Server;

namespace MIS.BO
{
    public class ServiceResult<T>
    {
        public bool IsSessionExpired { get; set; }
        public bool IsSuccessful { get; set; }
        public T Result { get; set; }
        public string Message { get; set; }
    }

    public class GetGeminiUsersBo
    {
        public string EmployeeName { get; set; }
        public string EmployeeCode { get; set; }
        public string Email { get; set; }
        public string Designation { get; set; }
        public string DepartmentName { get; set; }
        public string MobileNumber { get; set; }
        public string ExtNo { get; set; }
        public string Location { get; set; }
        public string WsNo { get; set; }
        public string Team { get; set; }
        public string ReportingManager { get; set; }
        public string ImagePath { get; set; }
        public string ReportingManagerEmail { get; set; }
        public string TerminateDate { get; set; }
    }

    public class ManagePimcoUser
    {
        public string Key { get; set; }
        public string Value { get; set; }
        public string UserAbrhs { get; set; }
        public string PimcoEmployeeId { get; set; }
        public string UserValidFromDate { get; set; }
        public string UserValidTillDate { get; set; }
        public bool IsAcknowledged { get; set; }
        public string AcknowledgedBy { get; set; }
        public string AcknowledgedDate { get; set; }
        public string CreatedDate { get; set; }
        public string CreatedByUser { get; set; }
        public string ModifiedDate { get; set; }
        public string ModifiedByUser { get; set; }
    }

    public class GetPimcoUsersBo
    {
        public GetPimcoUsersBo()
        {
            this.PimcoEmpIdExpirationData = new List<GetPimcoIdExpirationData>();
        }
        public string EmployeeName { get; set; }
        public string PimcoEmployeeId { get; set; }
        public string GeminiReportingManager { get; set; }
        public string PimcoReportingManager { get; set; }
        public string CreatedBy { get; set; }
        public string CreatedDate { get; set; }
        public string ModifiedDate { get; set; }
        public string ModifiedBy { get; set; }
        public List<GetPimcoIdExpirationData> PimcoEmpIdExpirationData { get; set; }

    }

    public class GetPimcoIdExpirationData
    {
        public string PimcoEmpIdValidFromDate { get; set; }
        public string PimcoEmpIdValidToDate { get; set; }
        public bool IsAcknowledged { get; set; }
        public string AcknowledgedBy { get; set; }
        public string AcknowledgedDate { get; set; }
        public string CreatedBy { get; set; }
        public string CreatedDate { get; set; }
        public string ModifiedBy { get; set; }
        public string ModifiedDate { get; set; }
    }

    public class UserOnShoreManagerMapping
    {
        public string UserName { get; set; }
        public string UserAbrhs { get; set; }
        public string ClntSideEmpId { get; set; }
        public string OnshoreMgrAbrhs { get; set; }
        public string OnshoreMgrName { get; set; }
        public string OnshoreMgrEmailId { get; set; }
        public bool NotifyManager { get; set; }
        public string EnableNotification { get; set; }
        public string ValidFrom { get; set; }
        public string ValidTill { get; set; }
        public string ValidFromDate { get; set; }
        public string ValidTillDate { get; set; }
        public long MappingId { get; set; }
        public string CreatedDate { get; set; }
    }

    public class OnshoreManagerMappingResult
    {
        public int Status { get; set; }
        public long MappingId { get; set; }
    }

    public class AbroadUserBO
    {
        public string EmployeeName { get; set; }
        public string EmployeeAbrhs { get; set; }
        public string EmployeeCode { get; set; }
        public string Department { get; set; }
        public string Team { get; set; }
        public string RManager { get; set; }
        public string CompanyLocation { get; set; }
        public int CompanyLocationId { get; set; }
        public string ExtensionNo { get; set; }
        public string WSNo { get; set; }
        public bool ShiftedBy { get; set; }
        public string ShiftedOn { get; set; }
        public string ActionCode { get; set; }
        public string Country { get; set; }
        public int CountryId { get; set; }
    }

    public class MailerBO
    {
        public string RecipientName { get; set; }
        public string RecipientEmailAddress { get; set; }
        public string RecipientUserName { get; set; }
        public string RecipientPassword { get; set; }
        public string ActivationLink { get; set; }
        public string CompanyName { get; set; }
        public string MessageBody { get; set; }
        public List<MailAddress> MultipleRecipientsEmailAddresses { get; set; }
    }

    public class documentsPaged : Document
    {
        public int TotalRecords { get; set; }
        public string GroupName { get; set; }
        public string User { get; set; }
    }

    public class UserDetailPaged
    {
        public int TotalRecords { get; set; }
        public List<UserDetail> UserDetailsList { get; set; }
    }

    public class UserDetailPagedWithAttendenceStatus
    {
        public int TotalRecords { get; set; }
        public List<UserDetailWithAttendenceStatus> UserDetailsList { get; set; }
    }

    public class UserDetailWithAttendenceStatus
    {
        public int UserDetailId { get; set; }
        public int UserId { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastName { get; set; }
        public string strDOB { get; set; }
        public DateTime DOB { get; set; }
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

        public string AttendanceCode { get; set; }
        public int? AttendanceStatusId { get; set; }
    }

    public class AttendanceAnalytics
    {
        public string AttendanceType { get; set; }
        public string LeaveType { get; set; }
        public int? LeaveTypeId { get; set; }
        public string AttendanceCode { get; set; }
        public int AttendanceTypeId { get; set; }
        public double Percent { get; set; }
        public double Count { get; set; }
        public DateTime AttendanceDate { get; set; }
        public int UserId { get; set; }
    }

    public class TimelyAttendanceAnalysis
    {
        public List<AttendanceAnalytics> AttendanceList { get; set; }
        public List<AttendanceTypeCount> AttendanceTypeCount { get; set; }
        public List<int> WeeklyOffDays { get; set; }
        public List<DateTime> DateList { get; set; }
    }

    public class AttendanceAnalyticsForCalendarView
    {
        public List<AttendanceAnalytics> AttendanceList { get; set; }
        public List<int> WeeklyOffDays { get; set; }
        public List<DateTime> CompanyHolidayDate { get; set; }
        public List<DateTime> AttendanceDateList { get; set; }
    }

    public class AttendanceTypeCount
    {
        public string AttendanceCode { get; set; }
        public int Count { get; set; }
    }

    public class EmployeeAttendance
    {
        public string Name { get; set; }
        public string EmployeeId { get; set; }
        public List<AttendanceAnalytics> AttendanceList { get; set; }
    }

    public class EmployeeAttendanceForDashBoard
    {
        public string Name { get; set; }
        public int UserId { get; set; }
        public string EmployeeId { get; set; }
        public List<Attendance> AttendanceList { get; set; }
    }

    public class MyAssignedProjects
    {
        public long ProjectId { get; set; }
        public string ProjectName { get; set; }
        public string ParentProject { get; set; }
        public string Role { get; set; }
        public bool Selected { get; set; }
    }

    public class UserDetailType
    {
        public int UserDetailId { get; set; }
        public int UserId { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastName { get; set; }
        public DateTime DOB { get; set; }
        public string strDOB { get; set; }
        public int GenderId { get; set; }
        public int? MaritalStatusId { get; set; }
        public string BloodGroup { get; set; }
        public string MobileNumber { get; set; }
        public string EmailId { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public string PinCode { get; set; }
        public int? StateId { get; set; }
        public string State { get; set; }
        public int? CountryId { get; set; }
        public string Country { get; set; }
        public string EmployeeId { get; set; }
        public DateTime? JoiningDate { get; set; }
        public DateTime? TerminationDate { get; set; }
        public int? DesignationId { get; set; }
        public string Designation { get; set; }
        public string ImagePath { get; set; }
        public int? CreatedBy { get; set; }
        public int? DeletedBy { get; set; }
        public int? UserRoleId { get; set; }
        public string UserName { get; set; }
        public bool IsActive { get; set; }
        public string RoleName { get; set; }
        public DateTime? LastReviewDate { get; set; }
        public DateTime? NextReviewDate { get; set; }
        public string Manager { get; set; }
        public string Extension { get; set; }
        public string DisplayJoiningDate { get; set; }
        public string UserLocation { get; set; }
        public string WSNo { get; set; }
    }

    public class UserDetailForDirectory
    {
        public int UserId { get; set; }
        public string UserName { get; set; }
        public string EmailId { get; set; }
        public string Designation { get; set; }
        public string Department { get; set; }
        public string MobileNumber { get; set; }
        public string Extension { get; set; }
        public bool IsUserMe { get; set; }
    }

    public class UserDetailForBioPage
    {
        public int? ProfileId { get; set; }
        public int? UserId { get; set; }
        public string Name { get; set; }
        public bool? IsSelf { get; set; }
        public string About { get; set; }
        public string Skills { get; set; }
        public string Email { get; set; }
        public string Extension { get; set; }
        public string Mobile { get; set; }
    }

    public class EmployeeProfileDetailType : UserDetailType
    {
        public bool? Kids { get; set; }
        public string FatherName { get; set; }
        public string CurrentPackage { get; set; }
        public string PresentAddress { get; set; }
        public string Pan { get; set; }
        public int DepartmentId { get; set; }
        public string DepartmentName { get; set; }
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
        public string MyExtension { get; set; }
        public bool IsDeleted { get; set; }
        public string PunchId { get; set; }
    }

    public class RequestInbox
    {
        public DateTime RequestDate { get; set; }
        public int SenderUserId { get; set; }
        public string SenderName { get; set; }
        public int RequestDetailId { get; set; }
        public string CurrentResponseStatus { get; set; }
        public string RequestType { get; set; }
        public int RequestTypeId { get; set; }
        public int RecieverUserId { get; set; }
        public string RecieverName { get; set; }
        public string Description { get; set; }
    }

    public class SelectedRequestDetail
    {
        public string Description { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public DateTime SingleDate { get; set; }
        public string CurrentApplicationResponse { get; set; }
        public string CurrentAttendanceStatus { get; set; }
        public string ReplacedAttendanceStatus { get; set; }
        public int CurrentAttendanceStatusId { get; set; }
        public int ReplacedAttendanceStatusId { get; set; }
        public int LeaveTypeId { get; set; }
        public string LeaveType { get; set; }
    }

    public class UserDirectory
    {
        public List<UserDetailType> UserDirectoryList { get; set; }
        public int TotalResultCount { get; set; }
    }

    public class ShareDocumentDetails : Document
    {
        public string SharedBy { get; set; }
        public string SharedDate { get; set; }
    }

    public class ClientDetail
    {
        public int ClientId { get; set; }
        public string ClientName { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
        public string CountryName { get; set; }
        public int CountryId { get; set; }
        public int StateId { get; set; }
        public int TimeZoneId { get; set; }
        public string ClientSkypeId { get; set; }
        public string State { get; set; }
        public string City { get; set; }
        public string ClientAddress { get; set; }
        public string CurrentCompanyName { get; set; }
        public string CurrentCompanyLogo { get; set; }
        public string CurrentCompanyCode { get; set; }
        public string CurrentCompanyPhone { get; set; }
        public string CurrentCompanyEmail { get; set; }
        public string CurrentCompanyAddress { get; set; }
        public int TotalProjects { get; set; }
    }

    public class CareerDetail
    {
        public EmployeeAcademic AcademicsDetail { get; set; }
        public EmployeeProfessionalDetail ProfessionalDetail { get; set; }
    }

    public class EmployeeProjectDetail
    {
        public int ProjectId { get; set; }
        public string ProjectName { get; set; }
        public string ProjectDomain { get; set; }
        public string ProjectSubDomain { get; set; }
        public string ProjectTags { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public string IsAssigned { get; set; }
        public int? ProjectStatusId { get; set; }
        public bool IsActive { get; set; }
        public int? EmployeeId { get; set; }
    }

    public class ProjectDetails
    {
        public int EmployeeId { get; set; }
        public int ProjectTeamId { get; set; }
        public int ProjectId { get; set; }
        public string ProjectName { get; set; }
        public int ProjectTypeId { get; set; }
        public int? ManagerId { get; set; }
        public string ProjectType { get; set; }
        public string ProjectDomain { get; set; }
        public string ProjectSubDomain { get; set; }
        public string ProjectTags { get; set; }
        public int? ClientId { get; set; }
        public string ClientName { get; set; }
        public int CompanyId { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public bool IsActive { get; set; }
        public bool IsAssigned { get; set; }
        public int? IndustryId { get; set; }
        public int? TechnologyId { get; set; }
        public string Technology { get; set; }
        public int ProjectStatusId { get; set; }
        public string ProjectStatus { get; set; }
        public string ProjectManager { get; set; }
        public int TeamSize { get; set; }
        public int TotalInvoice { get; set; }
        public int ProjectRoleId { get; set; }
        public double ProjectShare { get; set; }
        public int ProjectInvoiceCount { get; set; }
    }

    public class ProjectDetailPaged
    {
        public int TotalResultCount { get; set; }
        public List<ProjectDetails> ProjectDetailList { get; set; }
    }

    public class ProjectHeadDetail
    {
        public int EmployeeId { get; set; }
        public string Name { get; set; }
        public string Designation { get; set; }
        public string Technology { get; set; }
        public string KeySkills { get; set; }
        public string EmployeeUniqueId { get; set; }
        public string EmployeeEmail { get; set; }
        public bool IsDatetimeRow { get; set; }
        public bool IsActive { get; set; }
    }

    public class ProjectTeamDetail
    {
        public int AutoId { get; set; }
        public int EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public int? ProjectRoleId { get; set; }
        public string ProjectRole { get; set; }
        public string EmployeeUniqueId { get; set; }
        public string EmployeeEmail { get; set; }
        public string EmployeeDesignation { get; set; }
        public int ProjectId { get; set; }
        public double ProjectShare { get; set; }
        public int? TechnologyId { get; set; }
        public string Technology { get; set; }
        public string KeySkills { get; set; }
        public int ProjectTypeId { get; set; }
        public double TotalEarn { get; set; }
        public DateTime StartDate { get; set; }
        public bool IsActive { get; set; }
        public bool IsActiveInWorkingTeam { get; set; }
    }

    public class ProjectExpenseDetail
    {
        public int ProjectId { get; set; }
        public string ProjectName { get; set; }
        public double TotalExpense { get; set; }
    }

    public class EmployeeProjectExpense
    {
        public int EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public double FixedEarning { get; set; }
        public double VariableEarning { get; set; }
        public double TotalHours { get; set; }
        public double RatePerHour { get; set; }
        public bool IsActive { get; set; }
        public double TotalEarning { get; set; }
    }

    public class EmployeeProjectContribution
    {
        public int ProjectId { get; set; }
        public string ProjectName { get; set; }
        public double RatePerHour { get; set; }
        public double TotalHours { get; set; }
        public double VariableEarning { get; set; }
        public double FixedEarning { get; set; }
        public double TotalEarning { get; set; }
    }

    public class ResourceDetail
    {
        public int ExpenseId { get; set; }
        public string AuthorisedPersonName { get; set; }
        public string ActivePersonName { get; set; }
        public string LastName { get; set; }
        public int? Quantity { get; set; }
        public string PaymentType { get; set; }
        public string ExpenseSummary { get; set; }
        public string ExpenseDate { get; set; }
        public int? ExpenseAmmount { get; set; }
        public int? TotalResourceCount { get; set; }
        public string VendorName { get; set; }
        public string VendorCompanyName { get; set; }
        public string VendorCompanyAddress { get; set; }
        public int? VendorCompanyCountry { get; set; }
        public int? VendorCompnayState { get; set; }
        public string VendorCompanyCity { get; set; }
        public string VendorCompanyContactNumber { get; set; }
        public string VendorCompanyEmail { get; set; }
        public string VendorType { get; set; }
        public int VendorId { get; set; }
        public string ExpenseTypeName { get; set; }
        public string ResourceName { get; set; }
    }

    public class EmployeeMonthlySalaryDetail
    {
        public string EmployeeName { get; set; }
        public int EmployeeId { get; set; }
        public string EmployeeUniqueId { get; set; }
        public string Designation { get; set; }
        public bool SalaryStatus { get; set; }
        public int PaymentMode { get; set; }
        public double? MonthlySalary { get; set; }
        public double? MonthlyGrossSalary { get; set; }
        public string DD_ChequeNumber { get; set; }
        public int IncentiveType { get; set; }
        public double IncentiveAmount { get; set; }
        public string PaymentModeName { get; set; }
        public string IncentiveTypeName { get; set; }
        public double MonthlyTaxableIncome { get; set; }
        public double MonthlyPaidTax { get; set; }
        public int? SalarySummaryId { get; set; }
        public double Bonus { get; set; }
        public double Deduction { get; set; }
        public double TakenLeave { get; set; }
        public string AccountNumber { get; set; }
        public string DebitCredit { get; set; }
        public string Narration { get; set; }
        public int SerialNo { get; set; }
        public double TotalMothlySalaryPaid { get; set; }
    }

    public class EmployeeSalarySummary : SalarySummary
    {
        public string EmployeeFirstName { get; set; }
        public string EmployeeLastName { get; set; }
        public string EmployeeName { get; set; }
        public string EmployeeId { get; set; }
        public string EmployeeUniqueId { get; set; }
        public string Designation { get; set; }
        public bool SalaryStatus { get; set; }
        public int PaymentMode { get; set; }
        public double MonthlySalary { get; set; }
        public string DD_ChequeNumber { get; set; }
        public int IncentiveType { get; set; }
        public double IncentiveAmount { get; set; }
    }

    public class SalarySummaryDetails : SalarySummary
    {
        public string EmployeeName { get; set; }
        public string EmployeeUniqueId { get; set; }
        public string Designation { get; set; }
        public int TotalDays { get; set; }
        public int TotalTakenLeave { get; set; }
        public int OneDaySalary { get; set; }
    }

    public class EmployeeMonthlySalaryResult
    {
        public List<EmployeeMonthlySalaryDetail> EmployeeMonthlySalaryList { get; set; }
        public int ResultCount;
    }

    public class ExpenseVsEarning
    {
        public string Month { get; set; }
        public double TotalExpense { get; set; }
        public double TotalEarned { get; set; }
    }

    public class ProjectTaskDetailType
    {
        public int TaskId { get; set; }
        public int ProjectId { get; set; }
        public string ProjectName { get; set; }
        public int TaskAssignedBy { get; set; }
        public int TaskAssignedTo { get; set; }
        public DateTime TaskAssignedDate { get; set; }
        public DateTime TaskStartDate { get; set; }
        public DateTime TaskEndDate { get; set; }
        public string TaskSummary { get; set; }
        public string AssigToName { get; set; }
        public string AssignByName { get; set; }
    }

    public class CompanyNewsDetailType
    {
        public int CompanyNewsId { get; set; }
        public int CompanyId { get; set; }
        public string News { get; set; }
        public int AddedBy { get; set; }
        public DateTime NewsDate { get; set; }
        public string NewsImagePath { get; set; }
        public bool IsActive { get; set; }
        public string AddedByName { get; set; }
    }

    public class CompanyEventDetailType
    {
        public int CompanyEventId { get; set; }
        public int CompanyId { get; set; }
        public string CompanyEventTitle { get; set; }
        public string EventDiscription { get; set; }
        public int EventAddedBy { get; set; }
        public string EventAddedByName { get; set; }
        public DateTime EventStartDate { get; set; }
        public DateTime EventEndDate { get; set; }
        public string EventImagePath { get; set; }
        public bool EventIsActive { get; set; }
    }

    public class DailyTimeSheetType
    {
        public int TimeSheetId { get; set; }
        public int SenderEmployeeId { get; set; }
        public int? ManagerId { get; set; }
        public int? ProjectId { get; set; }
        public string ProjectTask { get; set; }
        public DateTime? TimeSheetDate { get; set; }
        public double TotalHours { get; set; }
        public bool IsBillable { get; set; }
        public bool IsApproved { get; set; }
        public string SenderName { get; set; }
        public string EmployeeUniqueId { get; set; }
        public string ProjectName { get; set; }
    }

    public class PermissionType
    {
        public int PermissionId { get; set; }
        public bool IsPermitted { get; set; }
    }

    public class EmployeeAttendanceType
    {
        public int AttendanceId { get; set; }
        public int? AttendanceStatusId { get; set; }
        public int UserId { get; set; }
        public DateTime AttendanceDate { get; set; }
        public string Name { get; set; }
        public string EmployeeId { get; set; }
    }

    public class EmployeeAttendanceTypeList
    {
        public int TotalResultCount { get; set; }
        public List<EmployeeAttendanceType> AttendanceSubmationList { get; set; }
    }

    public class InvoiceDetails
    {
        public List<InvoiceAllDetails> InvoiceAllDetailList { get; set; }
        public List<InvoiceJobPaymentDetails> InvoiceJobPaymentList { get; set; }
    }

    public class InvoiceClientPaymentDetails
    {
        public string Name { get; set; }
        public long Id { get; set; }
        public double? PaymentDone { get; set; }
        public double? PaymentDue { get; set; }
    }

    public class InvoiceJobPaymentDetails
    {
        public int InvoicePaymentId { get; set; }
        public int InvoiceProjectId { get; set; }
        public string Discription { get; set; }
        public int Units { get; set; }
        public int UnitPrice { get; set; }
        public string Currency { get; set; }
        public string LineTotal { get; set; }
    }

    public class InvoiceAllDetails
    {
        public int InvoiceId { get; set; }
        public int CompanyId { get; set; }
        public int ClientId { get; set; }
        public int ProjectId { get; set; }
        public string ClientInvoiceId { get; set; }
        public string InvoiceReferenceId { get; set; }
        public DateTime InvoiceDate { get; set; }
        public int? PaymentTerms { get; set; }
        public string PaymentMethod { get; set; }
        public int InvoiceTemplate { get; set; }
        public string InvoiceType { get; set; }
        public string Message { get; set; }
        public int InvoiceJobId { get; set; }
        public int InvoiceClientId { get; set; }
        public string SalesPerson { get; set; }
        public string ProjectJob { get; set; }
        public DateTime InvoiceStartDate { get; set; }
        public DateTime InvoiceDueDate { get; set; }
        public int InvoiceStatus { get; set; }
        public string SubTotal { get; set; }
        public string ServiceTax { get; set; }
        public string Total { get; set; }
        public double? TotalPaid { get; set; }
        public string Comments { get; set; }
        public int InvoiceTemplateId { get; set; }
        public string InvoiceTemplateTitle { get; set; }
        public string InvoiceTemplatePath { get; set; }
        public string ClientName { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
        public string CountryName { get; set; }
        public string State { get; set; }
        public string City { get; set; }
        public string ClientAddress { get; set; }
        public string CurrentCompanyName { get; set; }
        public string CurrentCompanyLogo { get; set; }
        public string CurrentCompanyCode { get; set; }
        public string CurrentCompanyPhone { get; set; }
        public string CurrentCompanyEmail { get; set; }
        public string CurrentCompanyAddress { get; set; }
    }

    public class CustomReviewManagement
    {
        public int ReviewId { get; set; }
        public int ManagerId { get; set; }
        public int EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public DateTime? ReviewDate { get; set; }
        public int StatusId { get; set; }
        public string StatusType { get; set; }
        public string ManagerName { get; set; }
        public string ReviewMeetingTime { get; set; }
    }

    public class CustomReviewManagementWithPaging
    {
        public List<CustomReviewManagement> ReviewManagement { get; set; }
        public int TotalRecords { get; set; }
    }

    public class Sheet
    {
        public string SheetName { get; set; }
        public string SheetValue { get; set; }
    }

    public class SheetColumn
    {
        public string Header { get; set; }
        public string UniqeName { get; set; }
    }

    public class CompanyExpenseDhashboard
    {
        public double Salary { get; set; }
        public double Others { get; set; }
        public double Incentive { get; set; }
        public string ExpenseDate { get; set; }
        public string Duration { get; set; }
    }

    public class CompanyEarningDashBoard
    {
        public string Month { get; set; }
        public double TotalPrjectedEarning { get; set; }
        public double TotalActualEarning { get; set; }
    }

    public class CompanyExpenseVsEarningDhashboard
    {
        public double Expense { get; set; }
        public double ProjectedEarning { get; set; }
        public double ActualEarning { get; set; }
        public string MonthDate { get; set; }
        public string Duration { get; set; }
    }

    public class ProjectEarnDetailsWithTeam
    {
        public int AutoId { get; set; }
        public string EmployeeFirstName { get; set; }
        public string EmployeeLastName { get; set; }
        public string EmployeeDesignation { get; set; }
        public double TotalEarn { get; set; }
    }

    public class ProjectDashboardEarning
    {
        public int ProjectId { get; set; }
        public string ProjectName { get; set; }
        public double TotalEarn { get; set; }
        public string Duration { get; set; }
    }

    public class EmployeeEarningDashBoard
    {
        public int EmployeeUserId { get; set; }
        public string Month { get; set; }
        public double TotalEarning { get; set; }
    }

    public class EmployeeExpenseDashBoard
    {
        public int EmployeeUserId { get; set; }
        public string Month { get; set; }
        public double TotalExpense { get; set; }
        public double TotalIncentive { get; set; }
        public double TotalSalary { get; set; }
    }

    public class EmployeeAttendanceDashBoard
    {
        public int EmployeeUserId { get; set; }
        public string AttendanceDate { get; set; }
        public int TotalAttendance { get; set; }
        public string AttendanceShortCode { get; set; }
        public int AttendanceId { get; set; }
    }

    public class EmployeeAttendanceTypeDashBoard
    {
        public int AttendanceId { get; set; }
        public string AttendanceShortCode { get; set; }
    }

    public class TimelyAttendanceAnalysisEmployeeDashboard
    {
        public List<EmployeeAttendanceDashBoard> EmployeeAttendanceList { get; set; }

        public List<EmployeeAttendanceTypeDashBoard> EmployeeAttendanceType { get; set; }
    }

    public class EmployeePerformanceDashBoard
    {
        public int EmployeeUserId { get; set; }
        public string Month { get; set; }
        public double TotalExpense { get; set; }
        public double TotalIncentive { get; set; }
        public double TotalSalary { get; set; }
        public double TotalEarning { get; set; }
    }

    public class UDSPProjectExpenseVsEarning
    {
        public double TotalExpense { get; set; }
        public double TotalEarning { get; set; }
        public string ProjectName { get; set; }
        public string ClientName { get; set; }
        public string Duration { get; set; }
    }

    public class ProjectStatusTypeList
    {
        public int ProjectStatusId { get; set; }
        public string ProjectStatusType { get; set; }
    }

    public class UDSPEmployeeExpenseVsEarning
    {
        public int EmpId { get; set; }
        public string EmployeeName { get; set; }
        public double Expense { get; set; }
        public double Earning { get; set; }
    }

    public class ProjectWorkingTeamDetails
    {
        public int ProjectWorkingTeamId { get; set; }
        public string EmployeeName { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public int Days { get; set; }
    }

    public class TotalPaidSalaryDetails
    {
        public double TotalMonthlyTaxableIncome { get; set; }
        public double TotalPaidTax { get; set; }
        public int NumberOfPaidMonth { get; set; }
        public double RemainingMonthlyTaxableIncome { get; set; }
        public double RemainingMonthlyTax { get; set; }
    }

    public class DeductSalaryOnLeave
    {
        public int TakenLeave { get; set; }
        public double? OneDaySalary { get; set; }
        public double TotalDeduction { get; set; }
        public double? PaidTaxableIncome { get; set; }
        public double? PaidTax { get; set; }
        public int RemainingMonth { get; set; }
        public double? AnnualTaxableIncomeExecptCurrentMonth { get; set; }
        public int TotalDays { get; set; }
    }

    public class PaidSalaryDetails
    {
        public double? PaidTaxableIncome { get; set; }
        public double? PaidTax { get; set; }
        public int RemainingMonth { get; set; }
        public string FinancialYear { get; set; }
    }

    public class WeekDays
    {
        public const string Monday = "Monday";
        public const string Tuesday = "Tuesday";
        public const string Wednesday = "Wednesday";
        public const string Thusday = "Thusday";
        public const string Friday = "Friday";
        public const string Saturday = "Saturday";
        public const string Sunday = "Sunday";
    }

    public class MonthValue
    {
        public const string Jan = "Jan";
        public const string Feb = "Feb";
        public const string Mar = "Mar";
        public const string Apr = "Apr";
        public const string May = "May";
        public const string Jun = "Jun";
        public const string Jul = "Jul";
        public const string Aug = "Aug";
        public const string Sep = "Sep";
        public const string Oct = "Oct";
        public const string Nov = "Nov";
        public const string Dec = "Dec";
    }

    public class PresentLeaveType
    {
        public const int P = 1;
        public const int WFH = 5;
    }

    public class SalarySummayType
    {
        public const string Allowance = "A";
        public const string Deduction = "T";
    }

    public class EmpSalaryDetailsOfMonth
    {
        public int UserId { get; set; }
        public string EmployeeID { get; set; }
        public string EmployeeName { get; set; }
        public string Month { get; set; }
        public double? TakenLeave { get; set; }
        public string Designation { get; set; }
        public double? OneDaySalary { get; set; }
        public double? GrossMonthlySalary { get; set; }
        public double? TotalDeduction { get; set; }
        public int SalarySummaryId { get; set; }
        public double? AnnualTaxableIncomeExecptCurrentMonth { get; set; }
        public double? PaidTax { get; set; }
        public int RemainingMonth { get; set; }
        public double GrossEarning { get; set; }
        public double GrossDeduction { get; set; }
        public double NetPaySalary { get; set; }
        public int TotalDays { get; set; }
        public int FinancialYear { get; set; }
        public double? PFPercent { get; set; }
        public int? ActualPaidRent { get; set; }

        public double? PercentOfGsForBasic { get; set; }
        public double? HraPercentOfBs { get; set; }
        public double? HraPercentExcessOfBs { get; set; }
        public double? EducationCessOnTds { get; set; }
    }

    public class EmpSalaryDetailsOfYear
    {
        public int UserId { get; set; }
        public string EmployeeID { get; set; }
        public string EmployeeName { get; set; }
        public string Designation { get; set; }
        public string FinancialYear { get; set; }
        public DateTime? JoiningDate { get; set; }


        public double? PaidTaxabelIncome { get; set; }
        public double? PaidTax { get; set; }
        public int RemainingMonth { get; set; }

        public double? PercentOfGsForBasic { get; set; }
        public double? HraPercentOfBs { get; set; }
        public double? HraPercentExcessOfBs { get; set; }
        public double? EducationCessOnTds { get; set; }
    }

    public class MyPaySlipDetails
    {
        public string Field { get; set; }
        public double Jan { get; set; }
        public double Feb { get; set; }
        public double March { get; set; }
        public double April { get; set; }
        public double May { get; set; }
        public double Jun { get; set; }
        public double July { get; set; }
        public double August { get; set; }
        public double Sep { get; set; }
        public double Oct { get; set; }
        public double Nov { get; set; }
        public double Dec { get; set; }
        public double Total { get; set; }
    }

    public class MonthlySalaryDisbursementMonth
    {
        public string Field { get; set; }
        public string Jan { get; set; }
        public string Feb { get; set; }
        public string March { get; set; }
        public string April { get; set; }
        public string May { get; set; }
        public string Jun { get; set; }
        public string July { get; set; }
        public string August { get; set; }
        public string Sep { get; set; }
        public string Oct { get; set; }
        public string Nov { get; set; }
        public string Dec { get; set; }
        public string Total { get; set; }
    }

    public class AllowanceType
    {
        public const int BasicSalary = -1;
        public const int HRA = -2;
        public const int SpecialAllowance = -3;
        public const int Bonus = -4;
    }

    public class MonthlyTaxDetailWithTaxName
    {
        public string TaxName { get; set; }
        public double? TaxValue { get; set; }
        public double? Total { get; set; }
    }

    public class EmpsForSendMailSms
    {
        public int id { get; set; }
        public string name { get; set; }
    }

    public class EmpForReviewCycle
    {
        public int UserId { get; set; }
        public int TotalRecords { get; set; }
        public string EmployeeId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public int ReviewCycleId { get; set; }
        public string ReviewCycle { get; set; }
    }

    public class ReviewRequestDetail
    {
        public DateTime? ReviewDate { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public string ReviewStatus { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string EmployeeId { get; set; }
        public int ReviewRequestId { get; set; }
        public string FormDownloadUrl { get; set; }
        public string FilledFormDownloadUrl { get; set; }
        public int? FilledFormId { get; set; }
        public int UserId { get; set; }
        public bool IsLastManager { get; set; }
        public double? OldSalary { get; set; }
        public double? OfferSalary { get; set; }
        public double? ApprovedSalary { get; set; }
        public bool IsApprovedSalary { get; set; }
    }

    public class ReviewHistoryDetails
    {
        public string ManagerName { get; set; }
        public string ManagerDesignation { get; set; }
        public string PublicComments { get; set; }
        public string PrivateComments { get; set; }
        public double? Rating { get; set; }
    }

    public class ReviewRequestManagerDetails : ReviewRequest_Manger
    {
        public double OldSalary { get; set; }
        public double OfferSalary { get; set; }
        public int MeetingManagerId { get; set; }
    }

    public class EmpInfoForEmpPerformanceView
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string EmployeeId { get; set; }
        public int UserId { get; set; }
        public double? OldSalary { get; set; }
        public string Designation { get; set; }
    }

    public class ForgotPasswordDetail
    {
        public string EmailId { get; set; }
        public string LoginName { get; set; }
        public int? RandomCode { get; set; }
        public int UserId { get; set; }
    }

    public class UserDetailProfile : User
    {
        public string ImagePath { get; set; }
        public bool IsImagePath { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Designation { get; set; }
        public string RoleName { get; set; }
        public string Email { get; set; }
        public int CompanyLocationId { get; set; }
        public int DesignationGroupId { get; set; }
        public bool IsHRVerifier { get; set; }
    }

    public class Notification
    {
        public string PageUrl { get; set; }
        public string Detail { get; set; }
        public string Heading { get; set; }
    }

    public class TempUserPermissionDetail : TempUserPermission
    {
        public string PermissionName { get; set; }
        public string ModuleName { get; set; }
    }

    public class MonthlySalaryDisbursementDetail
    {
        public int SerialNo { get; set; }
        public string FullName { get; set; }
        public string AccountNumber { get; set; }
        public string DebitCredit { get; set; }
        public string Narration { get; set; }
        public double Amount { get; set; }
    }

    public class SuperAdmin
    {
        public const int SuperAdminId = -1;
    }

    public enum AttendanceStatuses
    {
        P = 1
    }

    public class ShareDocumentInfo : ShareDocumentDetails
    {
        public string TagNames { get; set; }
    }

    public class UserDetailForEmployeemanagement
    {
        public int UserId { get; set; }
        public string NickName { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string MobileNumber { get; set; }
        public string EmailId { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public string PinCode { get; set; }
        public string EmployeeId { get; set; }
    }

    #region Const Module name

    public class ModuleName
    {
        public const string CompanyDashboard = "CompanyDashboard";
        public const string EmployeeDashboard = "EmployeeDashboard";
        public const string ProjectDashboard = "ProjectDashboard";
        public const string ClientDashboard = "ClientDashboard";
        public const string MyTeamDashboard = "MyTeamDashboard";
        public const string ManageAttendance = "ManageAttendance";
        public const string ProjectInformation = "ProjectInformation";
        public const string MyProject = "MyProject";
        public const string ManageDocument = "ManageDocument";
        public const string ManageResource = "ManageResource";
        public const string UserManagement = "UserManagement";
        public const string PayrollManagement = "PayrollManagement";
        public const string PerformanceManagement = "PerformanceManagement";
        public const string LeaveManagement = "LeaveManagement";
        public const string Settings = "Settings";
        public const string MyPage = "MyPage";
        public const string Other = "Other";
        public const string TimeSheet = "TimeSheet";
        public const string Policy = "Policy";
        public const string Forms = "Forms";
        public const string Appraisal = "Appraisal";
        public const string ProjectManagement = "ProjectManagement";
        public const string TaskManagement = "TaskManagement";
        public const string ResourceManagement = "ResourceManagement";
        public const string TeamManagement = "TeamManagement";
        public const string ManpowerRequisition = "ManpowerRequisition";
        public const string Feedback = "Feedback";
        public const string Reimbursement = "Reimbursement";
        public const string AssetAllocation = "AssetAllocation";
        public const string LNSA = "LNSA";
        public const string EmployeeDirectory = "EmployeeDirectory";
        public const string Reports = "Reports";
        public const string AttendanceRegister = "AttendanceRegister";
        public const string AccessCard = "AccessCard";
    }

    #endregion

    #region Leave Type management

    public class LeaveApplicationDetail : LeaveApplication
    {
        public int LeaveApplicationApprovalLabelAsstId { get; set; }
        public string EmployeeName { get; set; }
        public string LeaveType { get; set; }
        public string Status { get; set; }
        //public int SeniorLabelId { get; set; }
        public double? SpecificLeavePending { get; set; }
        public int RoleId { get; set; }
    }

    public class ApprovalLevelDetail : UserRole
    {
        public bool IsSelected { get; set; }
        public int LevelNum { get; set; }
        public int LeaveTypeId { get; set; }
        public int LeaveApprovalLevelId { get; set; }
        // public string Password { get; set; }
    }

    public class GroupDetailForWeeklyOff : UserDetail
    {
        public string DepartmentName { get; set; }
        public string DeginationName { get; set; }
        public string EmployeeJobStatusDetails { get; set; }
        public string GradeName { get; set; }
        public string GroupName { get; set; }
        public int GroupId { get; set; }
        public bool IsSelected { get; set; }
        public int MinLeaveAccrual { get; set; }
        public int MaxLeaveAccrual { get; set; }
    }

    public class GroupDetailForAccuralRule : UserDetail
    {
        public int AccrualEmplyeeGroupId { get; set; }
        public string DepartmentName { get; set; }
        public string DeginationName { get; set; }
        public string EmployeeJobStatusDetails { get; set; }
        public string GradeName { get; set; }
        public string GroupName { get; set; }
        public int GroupId { get; set; }
        public bool IsSelected { get; set; }
        public int MinLeaveAccural { get; set; }
        public int MaxLeaveAccural { get; set; }
        public int LeaveTypeId { get; set; }
        public int AccrualFrequency { get; set; }
        public new bool IsDeleted { get; set; }
    }

    public class PendingLeaveDetail
    {
        public int EmployeeLeaveMangementId { get; set; }
        public int? LeaveTypeId { get; set; }
        public string LeaveType { get; set; }
        public float? AllowedLeave { get; set; }
        public double? TakenLeave { get; set; }
        public float? PendingLeave { get; set; }
        public string CarryForwardLeave { get; set; }
    }

    public class LeaveTypeCarryForwardRuleDetail : LeaveTypeCarryForwardRule
    {
        public string LeaveTypeShortName { get; set; }
    }

    public class PendingLeave
    {
        public int? countMonth { get; set; }
    }

    public class LeaveTypeDetailsForEditMode
    {
        public LeaveType LeaveType { get; set; }
        public List<LeaveTypeApply> LeaveTypeApplyList { get; set; }
        public LeaveTypeRestriction LeaveTypeRestriction { get; set; }
        public int? LeaveTypeStatusId { get; set; }
        public LeaveTypeCarryForwardRule LeaveTypeCarryForwardRule { get; set; }
    }

    #endregion

    #region Appraisal Management

    public enum AppraisalStatus
    {
        NoDataFound = 0,
        Submitted = 1,
        Appraised = 2,
        Reviewed = 3,
        RejectedByAppraiser = -1,
        RejectedByReviewer = -2
    }

    public class EmployeeHierarchy
    {
        public int EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public string EmployeeCode { get; set; }
        public string Location { get; set; }
        public string Designation { get; set; }
        public string Department { get; set; }
        public int AppraiserId { get; set; }
        public string AppraiserName { get; set; }
        public int ReviewerId { get; set; }
        public string ReviewerName { get; set; }
        public DateTime ReviewPeriodFrom { get; set; }
        public DateTime ReviewPeriodTo { get; set; }
        public DateTime? ReviewMeetingDate { get; set; }
        public DateTime? CreatedDate { get; set; }
        public DateTime? ApprovedDate { get; set; }
        public DateTime? ReviewedDate { get; set; }
        public string FinalComment { get; set; }
    }

    public class Comments
    {
        public long HeaderId { get; set; }
        public string OtherComments { get; set; }
        public string UserComments { get; set; }
    }

    public class Rating
    {
        public long CriteriaId { get; set; }
        public int RatingValue { get; set; }
    }

    public class AppraisalRating
    {
        public int TypeId { get; set; }
        public List<Rating> Value { get; set; }
    }

    public class AppraisalComments
    {
        public int TypeId { get; set; }
        public List<Comments> Value { get; set; }
    }

    public class AppraisalGoals
    {
        public List<string> Goals { get; set; }
    }

    public class PendingAppraisals
    {
        public long AppraisalId { get; set; }
        public string EmployeeName { get; set; }
        public string ManagerName { get; set; }
        public string ReviewerName { get; set; }
        public DateTime ReviewPeriodFrom { get; set; }
        public DateTime ReviewPeriodTo { get; set; }
        public string Type { get; set; }
        public int EmployeeId { get; set; }
        public DateTime? SubmitDate { get; set; }
        public string Status { get; set; }
        public int StatusInt { get; set; }
        public string ViewStatus { get; set; }
        public DateTime? JoiningDate { get; set; }
    }

    public class AppraisalReviews
    {
        public int TypeId { get; set; }
        public Appraisal Appraisal { get; set; }
        public List<AppraisalRating> Rating { get; set; }
        public List<AppraisalComments> Comments { get; set; }
        public AppraisalGoals Goals { get; set; }
        public AppraisalReviewComment ReviewComment { get; set; }
        public AppraisalGoals NextYearGoals { get; set; }
    }

    public class IncompleteReviewForm
    {
        public int EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public string ManagerName { get; set; }
        public string ReviewerName { get; set; }
        public string FilledFromApplicant { get; set; }
        public string FilledFromAppraiser { get; set; }
        public string FilledFromReviewer { get; set; }
    }

    public class CompletedReviewForm
    {
        public int EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public string ManagerName { get; set; }
        public string ReviewerName { get; set; }
        public int Rating { get; set; }
    }

    #endregion

    #region Gemini Project Management

    public class GeminiProjectVerticalInfo
    {
        public long VerticalId { get; set; }
        public string Name { get; set; }
        public string Owners { get; set; }
        public long NoofTotalProjects { get; set; }
        public long NoofTeamMembers { get; set; }
        public string VerticalAbrhs { get; set; }
    }

    public class GeminiProjectInfo
    {
        public long ProjectId { get; set; }
        public long ParentProjectId { get; set; }
        public long VerticalId { get; set; }
        public string ProjectName { get; set; }
        public string ProjectDescription { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public string CurrentStatus { get; set; }
        public string Owners { get; set; }
        public string Role { get; set; }
        public int NoofActiveTeamMembers { get; set; }
        public string ShowStartDate { get; set; }
        public string ShowEndDate { get; set; }
    }

    public class GeminiTeamInfo
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Role { get; set; }
        public DateTime StartedFrom { get; set; }
        public DateTime? LeftOn { get; set; }
        public int NoofTotalProjects { get; set; }
        public string Status { get; set; }
        public string ShowStartedFrom { get; set; }
    }

    #endregion

    #region Time Sheet Management

    public class TaskTemplateInfo
    {
        public long TemplateId { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string TeamName { get; set; }
        public string TaskType { get; set; }
        public string TaskSubDetail1 { get; set; }
        public string TaskSubDetail2 { get; set; }
    }

    public class TimesheetReportDataForMultipleUsers
    {
        public int WeekNo { get; set; }
        public string EmployeeName { get; set; }
        public string Date { get; set; }
        public string Project { get; set; }
        public string TeamName { get; set; }
        public string TaskType { get; set; }
        public string TaskDescription { get; set; }
        public string Time { get; set; }
    }

    public class LoggedTaskInfo
    {
        public long TaskId { get; set; }
        public DateTime TaskDate { get; set; }
        public string DisplayTaskDate { get; set; }
        public long ProjectId { get; set; }
        public string Description { get; set; }
        public string TeamName { get; set; }
        public string TaskType { get; set; }
        public string TaskSubDetail1 { get; set; }
        public string TaskSubDetail2 { get; set; }
        public decimal TimeSpent { get; set; }
    }

    public class OtherEmployeesTimeSheet : TimeSheet
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string DisplayStartDate { get; set; }
        public string DisplayEndDate { get; set; }
        public string DisplaySubmissionTime { get; set; }
        public int WeekDiffrence { get; set; }
    }

    public class PendingTimeSheets
    {
        public string EmployeeName { get; set; }
        public string ManagerName { get; set; }
        public string Applicant { get; set; }
        public string Reviewer { get; set; }
    }

    public class CompletedTimeSheets
    {
        public string EmployeeName { get; set; }
        public string ManagerName { get; set; }
        public decimal TotalHoursLogged { get; set; }
    }

    public class WeekMaster
    {
        public long WeekId { get; set; }
        public long WeekTypeId { get; set; }
        public int WeekNo { get; set; }
        public int Year { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public string DisplayStartDate { get; set; }
        public string DisplayEndDate { get; set; }
    }

    public class TimeSheetInfo
    {
        public long TimeSheetId { get; set; }
        public string Status { get; set; }
        public string UserRemarks { get; set; }
        public string ApproverRemarks { get; set; }
        public decimal TimeLogged { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public string DisplayStartDate { get; set; }
        public string DisplayEndDate { get; set; }
        public int RejectInWeekNumber { get; set; }
        public bool IsTimesheetEnabled { get; set; }
    }

    public class ApprovedTask
    {
        public long TaskId { get; set; }
        public long MappingId { get; set; }
        public DateTime Date { get; set; }
        public string UIDate { get; set; }
        public string Resource { get; set; }
        public string ResourceTeamName { get; set; }
        public string ProjectName { get; set; }
        public string Description { get; set; }
        public string TaskTeamName { get; set; }
        public string TaskTypeName { get; set; }
        public string TaskSubDetail1Name { get; set; }
        public string TaskSubDetail2Name { get; set; }
        public decimal TimeSpent { get; set; }
        public bool ConsiderInClientReports { get; set; }
    }

    public class TaskInfo : ApprovedTask
    {
        public long ProjectId { get; set; }
        public long TaskTeamId { get; set; }
        public long TaskTypeId { get; set; }
        public long TaskSubDetail1Id { get; set; }
        public long TaskSubDetail2Id { get; set; }
    }

    #endregion

    #region Team Management

    #region Shift Management Insert , Update , Delete

    public class ShiftInfo
    {
        public long PrefrenceId { get; set; }
        public long ShiftId { get; set; }
        public string ShiftName { get; set; }
        public string InTime { get; set; }
        public string OutTime { get; set; }
        public string WorkingHours { get; set; }
        public bool IsWeekEnd { get; set; }
        public bool IsSelected { get; set; }
    }

    public class ListAllShift : ShiftMaster
    {
        public string ShiftType { get; set; }
        public string Status { get; set; }
    }

    #endregion

    public class UserDetailForUserTeamMapping
    {
        public int UserId { get; set; }
        public string Name { get; set; }
    }

    public class vwUserTeamMapping
    {
        public string TeamName { get; set; }
        public string EmployeeName { get; set; }
        public long? TeamId { get; set; }
        public long? UserId { get; set; }
    }

    #endregion

    #region Organisation Chart

    public class UserDetailForOrganisationChart
    {
        public int UserId { get; set; }
        public int? ReportTo { get; set; }
        public string Name { get; set; }
    }

    #endregion

    #region Man Power Requistion Form

    public class DataForViewMRF
    {
        public long InviteId { get; set; }
        public string Name { get; set; }
        public string Position { get; set; }
        public int Version { get; set; }
        public string Status { get; set; }
        public string Department { get; set; }
        public DateTime LastInvitationDate { get; set; }
        public string DisplayETAofClosingHiring { get; set; }
        public string DisplayETAofJoining { get; set; }
        public string DisplayLastInvitationDate { get; set; }
        public string DisplaySubmittedDate { get; set; }
        public string ViewDisabled { get; set; }
    }

    public class MRFVersion
    {
        public int Version { get; set; }
        public long RecordId { get; set; }
        public string Date { get; set; }
    }


    public class MRFData : ManpowerRequisitionForm
    {
        public string Name { get; set; }
        public string Position { get; set; }
    }

    #endregion

    #region User Management

    public class UserLoginDetail
    {
        public string UserName { get; set; }
        public string IpAddress { get; set; }
        public string Browser { get; set; }
        public string Device { get; set; }
        public string LoginStatus { get; set; }
        public string ShowDate { get; set; }
        public DateTime ActivityDate { get; set; }
    }

    public class LockedUserDetail
    {
        public string UserName { get; set; }
        public int? UserId { get; set; }
        public string EmployeeAbrhs { get; set; }
    }

    public class UserAccountStatus
    {
        public int? LeftAttempts { get; set; }
        public bool IsLocked { get; set; }
        public bool IsRedirect { get; set; }
        public string PasswordResetCode { get; set; }
        public string UserAbrhs { get; set; }
    }

    public class IsAccountLocked
    {
        public bool Islocked { get; set; }
    }

    public class OldAndNewLeaveBalance
    {
        public double OldClCount { get; set; }
        public double OldPlCount { get; set; }
        public double NewClCount { get; set; }
        public double NewPlCount { get; set; }
        public string OldCloyAvailable { get; set; }
        public string NewCloyAvailable { get; set; }
        public string OldRole { get; set; }
        public string NewRole { get; set; }
        public int UserId { get; set; }
    }
    public class PendingDataForApprovals
    {
        public string Type { get; set; }
        public string Period { get; set; }
        public string ReportingManager { get; set; }
        public int RMId { get; set; }
    }

    public class FullnFinalDataBO
    {
        public string LeaveTypes { get; set; }
        public string Summary { get; set; }
    }

    #endregion

    #region Dashboard Notification

    public class DashboardNotification
    {
        public DashboardNotification()
        {
            this.BirthDayUsersList = new List<BirthDayUsers>();
            this.HolidaysList = new List<Holidays>();
        }
        public string Holiday { get; set; }
        public DateTime Date { get; set; }
        public string DisplayDate { get; set; }
        public string Day { get; set; }
        public string UserName { get; set; }
        public List<BirthDayUsers> BirthDayUsersList { get; set; }
        public List<Holidays> HolidaysList { get; set; }
    }

    public class Holidays
    {
        public string Holiday { get; set; }
        public DateTime Date { get; set; }
        public string DisplayDate { get; set; }
        public string Day { get; set; }
        public string UserName { get; set; }
    }

    public class BirthDayUsers
    {
        public string UserName { get; set; }
        public string Name { get; set; }
        public DateTime Date { get; set; }
        public string DisplayDate { get; set; }
        public string EmpAbrhs { get; set; }
    }

    public class UsersWorkAnniversary
    {
        public string UserName { get; set; }
        public string Name { get; set; }
        public DateTime Date { get; set; }
        public string DisplayDate { get; set; }
        public string EmpAbrhs { get; set; }
    }

    public class DashboardAnniversary
    {
        public DashboardAnniversary()
        {
            this.DashboardAnniversaryList = new List<UsersWorkAnniversary>();
        }
        public string Holiday { get; set; }
        public DateTime Date { get; set; }
        public string DisplayDate { get; set; }
        public string Day { get; set; }
        public string UserName { get; set; }
        public List<UsersWorkAnniversary> DashboardAnniversaryList { get; set; }
    }

    #endregion

    #region Anonymous Feedback

    public class DataForUserFeedback : UserFeedback
    {
        public string FeedbackCode { get; set; }
        public string DisplayDate { get; set; }
        public string FontWeight { get; set; }
    }

    #endregion

    #region Leave Management

    #region Leave Review
    public class Leave
    {
        public string LeaveType { get; set; }
        public string Department { get; set; }
        public string EmployeeName { get; set; }
        public string Status { get; set; }
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
    }

    #endregion

    #region Import shift and attendance

    public class EmployeeShiftMappingErrorData
    {
        public string EmployeeName { get; set; }
        public string ShiftName { get; set; }
        public string Remarks { get; set; }
        public string Date { get; set; }
    }

    public class AttendanceStatusData
    {
        public string Remarks { get; set; }
        public long AttendanceStatusId { get; set; }
    }

    public class EmployeeAttendanceDetails
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

    public class ApplyLeaveDetail : LeaveRequestApplication
    {
        public bool IsLwp { get; set; }
        public DateTime FromDate { get; set; }
        public DateTime TillDate { get; set; }
        public string LeaveType { get; set; }
        public double LwpCount { get; set; }
        public double LeaveCount { get; set; }
        public bool IsFirstDayHalfDayLeave { get; set; }
        public bool IsLastDayHalfDayLeave { get; set; }
        public string SelectedLeaveCombination { get; set; }

    }

    public class LastRecordDetail
    {
        public string PrimaryContactNo { get; set; }
        public string AlternativeContactNo { get; set; }
    }

    #endregion

    #region comp-off and WorkForHome

    public class RequestForCompOff
    {
        public int RequestID { get; set; }
        public string EmployeeName { get; set; }
        public string Status { get; set; }
        public DateTime? Date { get; set; }
        public string CompOffDate { get; set; }
        public string CreatedDate { get; set; }
        public int NoOfDays { get; set; }
        public string Reason { get; set; }
        public string Remark { get; set; }
        public int UserId { get; set; }
        public int StatusID { get; set; }
        public int? LastModifiedByID { get; set; }
    }

    public class RequestForWorkFromHome
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
        public int LastModifiedByID { get; set; }
        public string MobileNo { get; set; }
        public bool IsHalfDay { get; set; }
        public string CancelDisabled { get; set; }
    }

    public class DatesToRequestCompOffOrWfh
    {
        public long? DateId { get; set; }
        public string DateAndOcassion { get; set; }
    }

    public class DataForWorkFromHome : LeaveRequestApplication
    {
        public int NoOfDays { get; set; }
        public string DisplayApplyDate { get; set; }
        public string DisplayWFHDate { get; set; }
        public string Status { get; set; }
        public string CancelDisabled { get; set; }
    }

    #endregion

    #region Dashboard

    public class DataForAttendance
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
        public bool IsPending { get; set; }
        public bool IsApproved { get; set; }
        public bool IsNightShift { get; set; }
        public bool IsWeekend { get; set; }
    }

    public class DataForLeaveBalance
    {
        public double? ClCount { get; set; }
        public double? PlCount { get; set; }
        public double ElCount { get; set; }
        public double OldPlCount { get; set; }
        public int MLCount { get; set; }
        public int PLMCount { get; set; }
        public double NewPlCount { get; set; }
        public double? CompOffCount { get; set; }
        public double? LwpCount { get; set; }
        public double? LnsaCount { get; set; }
        public double? WfhCount { get; set; }
        public string CloyAvailable { get; set; }
        public string Name { get; set; }
        public int? UserId { get; set; }
        public bool IsBioPageFilled { get; set; }
        public string Code { get; set; }

    }

    public class EmployeeStatusDataForManager
    {
        public string Name { get; set; }
        public string InTime { get; set; }
        public string OutTime { get; set; }
        public string WorkingHours { get; set; }
        public string YesterdayWorkingHours { get; set; }
        public string Status { get; set; }
        public string Reason { get; set; }
    }

    public class RawDataForPunchTiming
    {
        public long? UserId { get; set; }
        public string Name { get; set; }
        public string Day { get; set; }
        public string PunchTiming { get; set; }
    }

    public class DaysOnBasisOfLeavePeriod
    {
        public int? TotalDays { get; set; }
        public int? WorkingDays { get; set; }
        public string Status { get; set; }
    }

    public class AvailableLeaves
    {
        public int? LeaveTypeId { get; set; }
        public bool? IsSpecial { get; set; }
        public string LeaveCombination { get; set; }
    }

    #endregion

    #region Data Change Request

    public class RequestDataChange
    {
        public String Period { get; set; }
        public long? Id { get; set; }
        public string Type { get; set; }
        public string Reason { get; set; }
        public string Status { get; set; }
        public string Remarks { get; set; }
    }

    public class DataChangeRequestApplication
    {
        public long DataChangeRequestApplicationId { get; set; }
        public string EmployeeName { get; set; }
        public string Category { get; set; }
        public string ChangePeriod { get; set; }
        public string Reason { get; set; }
        public string Remarks { get; set; }
        public string Status { get; set; }

    }

    #endregion

    #region Update Leave

    public class DataForLeaveManagement
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
        public bool IsAvilableOnMobile { get; set; }
        public bool IsAvilableOnEmail { get; set; }
        public string CancelDisabled { get; set; }
        public bool IsHalfDay { get; set; }
    }

    #endregion

    #region View Leave

    public class AttendanceData
    {
        public string Date { get; set; }
        public string EmployeeAbrhs { get; set; }
        public string EmployeeName { get; set; }
        public string Department { get; set; }
        public string InTime { get; set; }
        public string OutTime { get; set; }
        public bool IsNightSift { get; set; }
        public bool IsPending { get; set; }
        public bool IsApproved { get; set; }
        public string Location { get; set; }
        public string LoggedInHours { get; set; }
    }

    #endregion

    #endregion

    #region Shift Import

    public class WeekAndDates
    {
        public string WeekDateString { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public int WeekNo { get; set; }
    }

    #endregion

    #region Performance Review

    #region menu & submenu

    public class PerformanceReviewDetail
    {
        public long RecordId { get; set; }
        public string Description { get; set; }
        public int Status { get; set; }
    }

    #endregion

    #region Criteria

    public class PerformanceReviewQuestionsAndRating
    {
        public long UserQuestionMappingId { get; set; }
        public string Question { get; set; }
        public string Answer { get; set; }
        public int? SelfRating { get; set; }
        public int? ReviewerRating { get; set; }
        public int? AppraiserRating { get; set; }
    }

    public class CriteriaRating
    {
        public int? SelfRating { get; set; }
        public int? ReviewerRating { get; set; }
        public int? AppraiserRating { get; set; }
        public string SelfComment { get; set; }
        public string ReviewerComment { get; set; }
        public string AppraiserComment { get; set; }
    }

    public class LastYearGoal : PerformanceReviewQuestionsAndRating
    {
        public string SelfComment { get; set; }
        public string ReviewerComment { get; set; }
        public string AppraiserComment { get; set; }
        public string SelfOtherComment { get; set; }
        public string ReviewerOtherComment { get; set; }
        public string AppraiserOtherComment { get; set; }
    }

    public class NextYearGoal
    {
        public long GoalId { get; set; }
        public string Goal { get; set; }
    }

    #endregion

    #region Get PerformanceReview Form Status

    public class FormSubmitStatus
    {
        public int? Status { get; set; }
        public long? HeaderId { get; set; }
        public long? SectionId { get; set; }
    }

    public class PerformanceReviewFormCurrentStatus : FormSubmitStatus
    {
        public bool IsSelfVisible { get; set; }
        public bool IsSelfEnabled { get; set; }
        public bool IsReviewerVisible { get; set; }
        public bool IsReviewerEnabled { get; set; }
        public bool IsAppraiserVisible { get; set; }
        public bool IsAppraiserEnabled { get; set; }
    }

    #endregion

    #region Completed Form

    public class CompletedPerformanceReviewForm
    {
        public int EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public string ManagerName { get; set; }
        public string ReviewerName { get; set; }
    }

    public class Response
    {
        public long UserQuestionMappingId { get; set; }
        public int Rating { get; set; }

        public static void Clear()
        {
            throw new NotImplementedException();
        }
    }

    public class CriteriaInFormOfQuestionResponse
    {
        public long UserQuestionMappingId { get; set; }
        public string Response { get; set; }
    }
    public class GoalResponse : Response
    {
        public string Comment { get; set; }
    }

    #endregion

    #region Comments

    public class PerformanceReviewComments
    {
        public int UserRole { get; set; }
        public string Comments { get; set; }
        public string OtherComment { get; set; }
    }

    #endregion



    #endregion
    #region Reimbursement
    public class ReimbursementType
    {
        public int TypeId { get; set; }
        public string Type { get; set; }
        public string Description { get; set; }
        public bool? isActivated { get; set; }
        public bool? isDeleted { get; set; }
        public DateTime? CreatedDate { get; set; }
    }
    public class ReimbursementDetail
    {
        public int ReimbursementId { get; set; }
        public int UserId { get; set; }
        public decimal? Amount { get; set; }
        public string DocName { get; set; }
        public string Reason { get; set; }
        public string Type { get; set; }
        public bool? isActivated { get; set; }
        public bool? isDeleted { get; set; }
        public DateTime? CreatedDate { get; set; }
        public DateTime? Date { get; set; }
    }
    #endregion

    #region Asset Allocation
    public class AssetRequestDetail
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

    public class AssetData
    {
        public long RequestId { get; set; }
        public string EmployeeName { get; set; }
        public string Department { get; set; }
        public string ReportingManager { get; set; }
        public string Reason { get; set; }
        public string AssetTag { get; set; }
        public string Asset { get; set; }
        public string IssueFromDate { get; set; }
        public string ReturnDueDate { get; set; }
        public string Status { get; set; }
        public string StatusColour { get; set; }
    }

    public class DongleDetail
    {
        public long AssetDetailId { get; set; }
        public string SerialNumber { get; set; }
        public string SimNumber { get; set; }
        public string Make { get; set; }
        public string Model { get; set; }
        public bool? IsIssued { get; set; }
    }

    public class DongleReturnInfo
    {
        public long TransactionId { get; set; }
        public string EmployeeName { get; set; }
        public string AssetTag { get; set; }
        public string SerialNumber { get; set; }
        public string SimNumber { get; set; }
        public string ReturnDueDate { get; set; }
        public string IssueDate { get; set; }
    }

    public class AssetCount
    {
        public string Department { get; set; }
        public int TotalAvailable { get; set; }
        public int Allocated { get; set; }
        public double? Percentage { get; set; }
    }

    #endregion

    #region Bio Page

    public class ProfessionalEducationalData
    {
        public int? Type { get; set; }
        public string CompanyOrCollege { get; set; }
        public DateTime? FromDate { get; set; }
        public DateTime? TillDate { get; set; }
        public string DisplayFromDate { get; set; }
        public string DisplayTillDate { get; set; }
        public string DesignationOrField { get; set; }
        public string Role { get; set; }
    }

    public class CertificationAndReward
    {
        public int? Type { get; set; }
        public string Achievement { get; set; }
    }

    public class AchievementsAndExperiences
    {
        public List<BO.CertificationAndReward> Achievements { get; set; }
        public List<BO.ProfessionalEducationalData> Experiences { get; set; }
    }

    #endregion Bio Page

    #region LNSA

    public class LnsaData
    {
        public long RequestId { get; set; }
        public string EmployeeName { get; set; }
        public string Reason { get; set; }
        public string FromDate { get; set; }
        public string TillDate { get; set; }
        public int NoOfDays { get; set; }
        public string ApproverRemarks { get; set; }
        public string Status { get; set; }
    }

    #endregion

    #region LNSA LWP and comp-off report

    public class UserInADepartment
    {
        public int EmployeeId { get; set; }
        public string EmployeeCode { get; set; }
        public string Name { get; set; }
        public string EmployeeAbrhs { get; set; }

    }
    public class Teams
    {
        public int EmployeeId { get; set; }
        public string EmployeeCode { get; set; }
        public string TeamId { get; set; }
        public string TeamName { get; set; }
        public string TeamAbrhs { get; set; }
    }

    public class EmployeeInfoForReports
    {
        public EmployeeInfoForReports()
        {
            this.OrderedByEmployeeCode = new List<UserInADepartment>();
            this.OrderedByEmployeeName = new List<UserInADepartment>();
        }
        public List<UserInADepartment> OrderedByEmployeeCode { get; set; }
        public List<UserInADepartment> OrderedByEmployeeName { get; set; }
    }

    public class EmployeeReport
    {
        public string EmpAbrhs { get; set; }
        public int UserId { get; set; }
        public string EmpCode { get; set; }
        public string EmployeeName { get; set; }
        public string Department { get; set; }
        public string ManagerName { get; set; }
        public double Applied { get; set; }
        public string Location { get; set; }
        public string Team { get; set; }
    }
    public class CompOffReport : EmployeeReport
    {
        public double Availed { get; set; }
        public double Balance { get; set; }
        public int Approved { get; set; }
        public int PendingForApproval { get; set; }
        public int Rejected { get; set; }
        public int Lapsed { get; set; }
    }
    public class ClubbedReport : EmployeeReport

    {
        public string TeamName { get; set; }
        public string CL { get; set; }
        public string PL { get; set; }
        public string WFH { get; set; }
        public string COFF { get; set; }
        public string LNSA { get; set; }
        public string TotalDaysPresent { get; set; }
        public string TotalLoggedHours { get; set; }
        public string JoiningDate { get; set; }
        public string RelievingDate { get; set; }
        public string Status { get; set; }
    }


    public class LnsaReport : EmployeeReport
    {
        public int Approved { get; set; }
        public int PendingForApproval { get; set; }
        public int Rejected { get; set; }
        public int Cancelled { get; set; }
    }

    public class LwpReport : EmployeeReport
    {
        public double Availed { get; set; }
        public double Cancelled { get; set; }
        public double PendingForApproval { get; set; }
    }

    public class AttendanceSummary : EmployeeReport
    {
        public int PresentDays { get; set; }
        public double WFH { get; set; }
        public double CL { get; set; }
        public double PL { get; set; }
        public double LWP { get; set; }
        public double COFF { get; set; }
    }

    public class EmployeeInfo
    {
        public long EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public string EmployeeAbrhs { get; set; }
    }

    public class ReportDetail
    {
        public string ReasonOfApplication { get; set; }
        public string Period { get; set; }
        public string RejectedBy { get; set; }
        public string ReasonOfRejection { get; set; }
        public string PendingWith { get; set; }
        public string Status { get; set; }
        public double? Count { get; set; }
        public string CreatedDate { get; set; }
        public string ModifiedDate { get; set; }
    }

    #endregion

    #region AccessCard

    public class AccessCardData
    {
        public int AccessCardId { get; set; }
        public string AccessCardNo { get; set; }
        public bool IsActive { get; set; }
        public bool IsPimcoCard { get; set; }
        public bool IsTemporaryCard { get; set; }
        public string Status { get; set; }
        public bool? IsMapped { get; set; }
    }

    #endregion

    #region UserAccessCardMapping

    public class UserAccessCardData : UserAccessCardMapping
    {
        public int UserCardMappingId { get; set; }
        public bool IsActive { get; set; }
        public bool IsFinalised { get; set; }
        public string Status { get; set; }
        public string EmployeeId { get; set; }
    }

    public class UserAccessCardMapping
    {
        public int AccessCardId { get; set; }
        public string AccessCardNo { get; set; }
        public int UserId { get; set; }
        public bool IsPimcoUserCardMapping { get; set; }
        public string EmployeeName { get; set; }
    }

    #endregion

    #region Common DropDown List
    public class BaseDropDown
    {
        public string Text { get; set; }
        public string KeyValue { get; set; }
        public string MaxValue { get; set; }
        public bool Selected { get; set; }
        public long Value { get; set; }
        public int TextYear { get; set; }
        public bool HasAddRights { get; set; }
    }

    public class DesignationByDesigGrpId
    {
        public string Text { get; set; }
        public long Value { get; set; }
        public string DesignationAbrhs { get; set; }
    }

    public class AppraisalStagesBaseDropDown
    {
        public string Text { get; set; }
        public long Value { get; set; }
        public bool Selected { get; set; }
        public int SequenceNo { get; set; }
    }

    public class FYDropDown
    {
        public string Text { get; set; }
        public int StartYear { get; set; }
    }

    #endregion

    #region VMS
    public class VisitorReportDetail
    {
        public int VisitorId { get; set; }
        public string Visitor_FName { get; set; }
        public string Visitor_LName { get; set; }
        public string Visitor_Address { get; set; }
        public string Visitor_ContactNo { get; set; }
        public string Visitor_Email { get; set; }
        public string EmployeeName { get; set; }
        public string Visitor_Purpose { get; set; }
        public string Visitor_IdentityProof { get; set; }
        public string Visitor_TimeIn { get; set; }
        public string Visitor_TimeOut { get; set; }
    }

    public class TempCardReport
    {
        public int IssueId { get; set; }
        public string EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public string EmployeeAbrhs { get; set; }
        public string AccessCardNo { get; set; }
        public string AccessCardId { get; set; }
        public string IssueDate { get; set; }
        public string ReturnDate { get; set; }
        public string Reason { get; set; }
        public string IsReturn { get; set; }
    }
    #endregion

    #region Meal of the day

    public class MealOfTheDay
    {
        public MealOfTheDay()
        {
            DishMenuList = new List<DishMenu>();
        }
        public int MealPackagesId { get; set; }
        public DateTime MealDate { get; set; }
        public List<DishMenu> DishMenuList { get; set; }
        public string UserAbrhs { get; set; }
        public string Meal { get; set; }
    }

    public class DishMenu
    {
        public int DishId { get; set; }
        public string MenuName { get; set; }
    }

    public class MealOfTheDayBO
    {
        public MealOfTheDayBO()
        {
            DishMenuList = new List<DishMenuDashBoard>();
        }
        public List<DishMenuDashBoard> DishMenuList { get; set; }
        public int MealPackagesId { get; set; }
        public string MealDate { get; set; }
        public string Meal { get; set; }
        public int MyProperty { get; set; }
        public DateTime Date { get; set; }
        public string MealPackage { get; set; }
    }

    public class MealFeedbackReportBO
    {
        public string MealPackages { get; set; }
        public string FeedbackDate { get; set; }
        public bool IsLike { get; set; }
        public string Comment { get; set; }
        public string FeedbackBy { get; set; }
    }

    public class TeamMemberLeaveBO
    {
        public string EmployeeName { get; set; }
        public string TypeOfLeave { get; set; }
        public string DateFrom { get; set; }
        public string DateTo { get; set; }
    }

    public class NewsScrollerBO
    {
        public string NewsLink { get; set; }
        public string NewsTitle { get; set; }
        public string NewsDescription { get; set; }

        public bool IsInternal { get; set; }
    }

    public class DishMenuDashBoard
    {
        public int DishId { get; set; }
        public string DishName { get; set; }
        public string MenuName { get; set; }
    }

    public class MealPackagesBO
    {
        public int MealPackageId { get; set; }
        public string MealPackageName { get; set; }
        public int MealPeriodId { get; set; }
    }

    #endregion

    #region News

    public class NewsBO
    {
        public long NewsId { get; set; }
        public string NewsTitle { get; set; }
        public string NewsDescription { get; set; }
        public DateTime FromDate { get; set; }
        public DateTime TillDate { get; set; }
        public string UserAbrhs { get; set; }

        public bool IsActive { get; set; }
        public string CreatedBy { get; set; }
        public string CreatedDate { get; set; }
        public string FromDateDisplay { get; set; }
        public string TillDateDisplay { get; set; }

        public string Link { get; set; }

        public bool IsInternal { get; set; }
        public int ActionId { get; set; }
        public int ControllerId { get; set; }

    }

    #endregion

    #region Delegation

    public class DelegationBO
    {
        public DateTime FromDate { get; set; }
        public DateTime ToDate { get; set; }
        public string MenuAbrhs { get; set; }
        public string EmpAbrhs { get; set; }
        public string UserAbrhs { get; set; }
    }

    public class DelegationBOList
    {
        public int MenusUserDelegationId { get; set; }
        public DateTime FromDate { get; set; }
        public DateTime ToDate { get; set; }
        public string Employee { get; set; }
        public bool IsActive { get; set; }
        public string MenuAbrhs { get; set; }
    }

    public partial class MenusRights
    {
        public bool IsViewRights { get; set; }
        public bool IsAddRights { get; set; }
        public bool IsModifyRights { get; set; }
        public bool IsDeleteRights { get; set; }
        public bool IsAssignRights { get; set; }
        public bool IsApproveRights { get; set; }
    }

    #endregion

    #region Error Logs
    public partial class ErrorLogsBO
    {
        public long ErrorId { get; set; }
        public string ModuleName { get; set; }
        public string Source { get; set; }
        public string ControllerName { get; set; }
        public string ActionName { get; set; }
        public string ErrorType { get; set; }
        public string ErrorMessage { get; set; }
        public string TargetSite { get; set; }
        public string StackTrace { get; set; }
        public string ReportedBy { get; set; }
        public DateTime CreatedDate { get; set; }
    }
    #endregion

    #region Role

    public class RoleList
    {
        public string RoleAbrhs { get; set; }
        public string RoleName { get; set; }
        public string UserAbrhs { get; set; }
    }


    #endregion

    #region User Role

    public class UserRoleList
    {
        public string UserAbrhs { get; set; }
        public string RoleAbrhs { get; set; }
        public string EmployeeName { get; set; }
        public string RoleName { get; set; }
        public string EmpDesignation { get; set; }
        public string DesignationGroup { get; set; }
    }
    public class UserRoleBO
    {
        public string UserAbrhs { get; set; }
        public string EmployeeName { get; set; }
        public string RoleAbrhs { get; set; }
        public string DesignationAbrhs { get; set; }
        public string DesignationGroupAbrhs { get; set; }
        public string LoginUserAbrhs { get; set; }
    }

    #endregion

    #region Appraisal

    public class AppraisalParameterBO
    {
        public int ParameterId { get; set; }
        public string ParameterName { get; set; }
        public int Weightage { get; set; }
        public int CompetencyTypeId { get; set; }
        public bool IsFinalized { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedDate { get; set; }
        public string CompetencyTypeName { get; set; }
    }

    public class AppraisalParameterDetailList
    {
        public int AppraiserRatingId { get; set; }
        public string AppraiserComment { get; set; }
        public string ApproverComment { get; set; }
        public int ApproverRatingId { get; set; }
        public int CompetencyTypeId { get; set; }
        public string CompetencyTypeName { get; set; }
        public string EvaluationCriteria { get; set; }
        public string ParameterName { get; set; }
        public string SelfComment { get; set; }
        public int SelfRatingId { get; set; }
    }

    public class GoalsDetailList
    {
        public string Goal { get; set; }
        public string SelfComment { get; set; }
        public string AppraiserComment { get; set; }
        public string ApproverComment { get; set; }
    }

    public class AchievementDetailList
    {
        public string Achievement { get; set; }
        public string AppraiserComment { get; set; }
        public string ApproverComment { get; set; }
    }

    public class AddUpdateCompetencyFormBO
    {
        public AddUpdateCompetencyFormBO()
        {
            this.ParameterList = new List<ParameterListBO>();
            this.FeedbackTypeId = 1; // For Appraisal Only
            this.CompetencyFormId = 0; // at the case of Add Form
        }
        public int LocationId { get; set; }
        public int VerticalId { get; set; }
        public int DivisionId { get; set; }
        public int DepartmentId { get; set; }
        public int DesignationId { get; set; }
        public string FormName { get; set; }
        public List<ParameterListBO> ParameterList { get; set; }
        public bool IsFinalize { get; set; }
        public string UserAbrhs { get; set; }
        public int FeedbackTypeId { get; set; }
        public int CompetencyFormId { get; set; }

    }

    public class ParameterListBO
    {
        public int CompetencyTypeId { get; set; }
        public int ParameterId { get; set; }
        public string EvaluationCriteria { get; set; }
        public int CompetencyFormDetailId { get; set; }
        public int SequenceNo { get; set; }
    }

    public class AddUpdateReturnBO
    {
        public string Status { get; set; }
        public string Result { get; set; }
    }
    public class AppraisalGoalYearBO
    {
        public int AppraisalYear { get; set; }
        public int AppraisalCycleId { get; set; }
    }

    public class CompetencyFilterBO
    {
        public CompetencyFilterBO()
        {
            this.FeedbackTypeIds = "1";
        }
        public string UserAbrhs { get; set; }
        public string LocationIds { get; set; }
        public string FeedbackTypeIds { get; set; }
        public string VerticalIds { get; set; }
        public string DivisionIds { get; set; }
        public string DepartmentIds { get; set; }
        public string DesignationIds { get; set; }
        public string YearVal { get; set; }
        public int CompetencyFormId { get; set; }
    }


    public class CompetencyFormListBO
    {
        public int CompetencyFormId { get; set; }
        public int FeedbackTypeId { get; set; }
        public int LocationId { get; set; }
        public int VerticalId { get; set; }
        public int DivisionId { get; set; }
        public int DepartmentId { get; set; }
        public int DesignationId { get; set; }

        public string CompetencyFormName { get; set; }
        public string SpecializedFormName { get; set; }
        public string FeedbackTypeName { get; set; }
        public string LocationName { get; set; }
        public string VerticalName { get; set; }
        public string DivisionName { get; set; }
        public string DepartmentName { get; set; }
        public string DesignationName { get; set; }

        public bool IsRating { get; set; }
        public bool IsFinalized { get; set; }
        public bool IsRetired { get; set; }

        public string FinalizedDate { get; set; }
        public string RetiredDate { get; set; }
        public string CreatedDate { get; set; }
    }

    public class CompetencyFormForEditBO
    {
        public CompetencyFormForEditBO()
        {
            this.CompetencyAndParameterListBO = new List<CompetencyFormParameterForEditBO>();
        }
        public CompetencyFormListBO CompetencyFormData { get; set; }
        public List<CompetencyFormParameterForEditBO> CompetencyAndParameterListBO { get; set; }
    }

    public class CompetencyFormParameterForEditBO
    {
        public int CompetencyFormDetailId { get; set; }
        public int ParameterId { get; set; }
        public int CompetencyTypeId { get; set; }
        public string EvaluationCriteria { get; set; }
        public string Parameter { get; set; }
        public string CompetencyType { get; set; }
    }

    public class CloneCompetencyFormBO
    {
        public CloneCompetencyFormBO()
        {
            this.FeedbackTypeId = 1; // For Appraisal Only
        }
        public int CompetencyFormId { get; set; }
        public int LocationId { get; set; }
        public int VerticalId { get; set; }
        public int DivisionId { get; set; }
        public int DepartmentId { get; set; }
        public int DesignationId { get; set; }
        public string FormName { get; set; }
        public bool IsFinalize { get; set; }
        public string UserAbrhs { get; set; }
        public int FeedbackTypeId { get; set; }

    }

    public class AddAppraisalSettingsBO
    {
        public AddAppraisalSettingsBO()
        {
            this.AppraisalStagesList = new List<AppraisalStages>();
        }
        public int AppraisalSettingId { get; set; }
        public int AppraisalCycleId { get; set; }
        public int LocationId { get; set; }
        public int VerticalId { get; set; }
        public string DivisionIds { get; set; }
        public string DepartmentIds { get; set; }
        public string TeamIds { get; set; }
        public string DesignationIds { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public List<AppraisalStages> AppraisalStagesList { get; set; }
        public string UserAbrhs { get; set; }
    }

    public class AppraisalStages
    {
        public int AppraisalStageId { get; set; }
        public string EndDate { get; set; }
    }

    public class GetAppraisalSettingsBO
    {
        public int AppraisalSettingId { get; set; }
        public int AppraisalCycleId { get; set; }
        public int LocationId { get; set; }
        public int VerticalId { get; set; }
        public int DivisionId { get; set; }
        public int DepartmentId { get; set; }
        public long TeamId { get; set; }
        public int EmpSettingCount { get; set; }

        public string AppraisalMonth { get; set; }
        public string AppraisalCycleName { get; set; }
        public string LocationName { get; set; }
        public string VerticalName { get; set; }
        public string DivisionName { get; set; }
        public string DepartmentName { get; set; }
        public string DesignationName { get; set; }
        public string DesignationIds { get; set; }
        public string TeamName { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public string AppraisalStatges { get; set; }
    }

    public class AppraisalNotGeneratedList
    {
        public int EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public int? DesignationId { get; set; }
        public string DesignationName { get; set; }
        public int LocationId { get; set; }
        public int VerticalId { get; set; }
        public int DivisionId { get; set; }
        public int DepartmentId { get; set; }
        public long? TeamId { get; set; }
        public int? AppraiserId { get; set; }
        public int? RMId { get; set; }
        public string IsSelfAppraisal { get; set; }
        public int? CompetencyFormId { get; set; }
        public string CompetencyFormName { get; set; }
        public string Reason { get; set; }
        public int IsGenerate { get; set; }

        public int? AppraisalCycleId { get; set; }
        public string AppraisalCycleName { get; set; }

        public string LocationName { get; set; }
        public string VerticalName { get; set; }
        public string DivisionName { get; set; }
        public string DepartmentName { get; set; }
        public string TeamName { get; set; }
        public string AppraiserName { get; set; }
        public string RMName { get; set; }

    }

    public class AppraisalSettingsFilterBO
    {
        public int AppraisalCycleId { get; set; }
        public int? LocationId { get; set; }
        public int? AppraisalSettingId { get; set; }
        public string VerticalIds { get; set; }
        public string DivisionIds { get; set; }
        public string DepartmentIds { get; set; }
        public string TeamIds { get; set; }
        public string DesignationIds { get; set; }
        public string UserAbrhs { get; set; }
    }

    public class GenerateSettingsFilterBO
    {
        public int AppraisalSettingId { get; set; }
        public string UserAbrhs { get; set; }
    }

    public class UpdateAppraisalSettingsBO
    {
        public UpdateAppraisalSettingsBO()
        {
            this.AppraisalStagesList = new List<AppraisalStages>();
        }
        public int AppraisalSettingId { get; set; }
        public int AppraisalCycleId { get; set; }
        public int LocationId { get; set; }
        public int VerticalId { get; set; }
        public int DivisionId { get; set; }
        public int DepartmentId { get; set; }
        public int TeamId { get; set; }
        public string DesignationIds { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public List<AppraisalStages> AppraisalStagesList { get; set; }
        public string UserAbrhs { get; set; }
    }

    public class TeamAppraisalFilterBO
    {
        public int AppraisalCycleId { get; set; }
        public int LocationId { get; set; }
        public int VerticalId { get; set; }
        public string DivisionIds { get; set; }
        public string DepartmentIds { get; set; }
        public string TeamIds { get; set; }
        public string UserAbrhs { get; set; }
    }

    public class ManageTeamAppraisalFilterBO
    {
        public int AppraisalCycleId { get; set; }
        public int LocationId { get; set; }
        public int EmpAppraisalSettingId { get; set; }
        public string VerticalIds { get; set; }
        public string DivisionIds { get; set; }
        public string DepartmentIds { get; set; }
        public string TeamIds { get; set; }
        public string DesignationIds { get; set; }
        public int EmployeeId { get; set; }
        public string AppraisalStatusIds { get; set; }
        public string AppraiserIds { get; set; }
        public string ApproverIds { get; set; }
        public string UserAbrhs { get; set; }
        public bool IsTeamData { get; set; }
        public int FetchForId { get; set; }
    }

    public class ManageTeamAppraisalBO
    {
        public long EmpAppraisalSettingId { get; set; }
        public int EmployeeId { get; set; }
        public int LocationId { get; set; }
        public int VerticalId { get; set; }
        public int DivisionId { get; set; }
        public int DepartmentId { get; set; }
        public long TeamId { get; set; }
        public int? DesignationId { get; set; }
        public int AppraiserId { get; set; }
        public string AppraiserIdAbrhs { get; set; }
        public string Approver1Abrhs { get; set; }
        public int? RMId { get; set; }
        public int? HRId { get; set; }
        public int? CompetencyFormId { get; set; }
        public int AppraisalCycleId { get; set; }
        public int Approver1 { get; set; }
        public int? Approver2 { get; set; }
        public int? Approver3 { get; set; }
        public int AppraisalStatusId { get; set; }
        public int? LastPromotionDesignationId { get; set; }
        public string EmployeeName { get; set; }
        public string DesignationName { get; set; }
        public string AppraiserName { get; set; }
        public string RMName { get; set; }
        public string HRName { get; set; }
        public string CompetencyFormName { get; set; }
        public string AppraisalCycleName { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public string Approver1Name { get; set; }
        public string Approver2Name { get; set; }
        public string Approver3Name { get; set; }
        public string AppraisalStatusName { get; set; }
        public string LastPromotionDate { get; set; }
        public string LastAppraisalCycleName { get; set; }
        public string EmployeePhotoName { get; set; }
        public string AppraisalStatges { get; set; }
        public bool? IsHRBP { get; set; }
        public string AppraisalJsonStatges { get; set; }
        public string Reason { get; set; }
        public int IsSelfAppraisal { get; set; }
        public int? LastAppraisalCycleId { get; set; }
        public bool? IsSettingModified { get; set; }
        public bool? IsModifyRight { get; set; }
        public bool? IsVisible { get; set; }
        public bool? IsFinalized { get; set; }
    }

    public class UpdateAppraisalTeamSettingsBO
    {
        public UpdateAppraisalTeamSettingsBO()
        {
            this.AppraisalStagesList = new List<AppraisalStages>();
        }
        public int EmpAppraisalSettingId { get; set; }
        public int EmployeeId { get; set; }
        public int AppraisalCycleId { get; set; }
        public int CompetencyFormId { get; set; }
        public int Approver1 { get; set; }
        public int Approver2 { get; set; }
        public int Approver3 { get; set; }
        public int RMId { get; set; }
        public bool IsSelfAppraisal { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public List<AppraisalStages> AppraisalStagesList { get; set; }
        public string UserAbrhs { get; set; }
        public string AppraiserAbrhs { get; set; }
        public string Approver1Abrhs { get; set; }
    }

    #endregion

    public class test
    {
        public test()
        {
            this.DoDwtailList = new List<DoDwtail>();
        }
        public string Name { get; set; }
        public string Add { get; set; }
        List<DoDwtail> DoDwtailList { get; set; }
    }

    public class DoDwtail
    {
        public string Name { get; set; }
        public string Add { get; set; }
    }

    public class AppraisalLogModal
    {
        public int? RowNo { get; set; }
        public string Date { get; set; }
        public string FeedbackStatusName { get; set; }
        public string Description { get; set; }
        public string Comment { get; set; }
        public string UpdateBy { get; set; }
    }

    public class AppraisalFormBO
    {
        public long EmpAppraisalSettingId { get; set; }
        public int UserId { get; set; }
        public string EmployeeName { get; set; }
        public string EmployeeCode { get; set; }
        public string DateOfJoin { get; set; }
        public string DesignationName { get; set; }
        public int AppraiserId { get; set; }
        public string AppraiserName { get; set; }
        public string AppraiserDesignation { get; set; }
        public int RMId { get; set; }
        public string RMName { get; set; }
        public int? HRId { get; set; }
        public string HRName { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public int IsSelfAppraisal { get; set; }
        public int? CompetencyFormId { get; set; }
        public string CompetencyFormName { get; set; }
        public bool? IsRating { get; set; }
        public int AppraisalCycleId { get; set; }
        public string AppraisalCycleName { get; set; }
        public string ReviewTo { get; set; }
        public string ReviewFrom { get; set; }
        public int Approver1 { get; set; }
        public string Approver1Name { get; set; }
        public string Approver1Designation { get; set; }
        public int? Approver2 { get; set; }
        public string Approver2Name { get; set; }
        public int? Approver3 { get; set; }
        public string Approver3Name { get; set; }
        public int AppraisalStatusId { get; set; }
        public string AppraisalStatusName { get; set; }
        public string AppraiseeComment { get; set; }
        public string AppraiserComment { get; set; }
        public string ApproverComment { get; set; }
        public long? EmpAppraisalId { get; set; }
        public string AppraisalParameterDetail { get; set; }
        public bool? IsViewRight { get; set; }
        public bool? IsModifyRight { get; set; }

        // New Tabs.
        public string EmployeeGoals { get; set; }
        public string EmployeeAchievements { get; set; }

        public string AppraiseeAbrhs { get; set; }
        public string AppraiserAbrhs { get; set; }
        public string ApproverAbrhs { get; set; }

        //For Promotions
        public int? AppraiserRecommendedForDesignationId { get; set; }
        public int? AppraiserRecommendedPercentage { get; set; }
        public string AppraiserRecommendationComment { get; set; }
        public int? Approver1RecommendedForDesignationId { get; set; }
        public int? Approver1RecommendedPercentage { get; set; }
        public string Approver1RecommendationComment { get; set; }
        public bool? AppraiserMarkedHighPotential { get; set; }
        public string AppraiserHighPotentialComment { get; set; }
        public bool? Approver1MarkedHighPotential { get; set; }
        public string Approver1HighPotentialComment { get; set; }

        //For overall weighted rating
        public decimal? SelfOverallRatingWeighted { get; set; }
        public decimal? AppraiserOverallRatingWeighted { get; set; }
        public decimal? ApproverOverallRatingWeighted { get; set; }

        //For overall normal rating
        public decimal? SelfOverallRatingNormal { get; set; }
        public decimal? AppraiserOverallRatingNormal { get; set; }
        public decimal? ApproverOverallRatingNormal { get; set; }

        public string SelfSubmitDate { get; set; }
    }

    public class EmployeeAppraisalStatus
    {
        public string AppraiserIdAbrhs { get; set; }
        public string Approver1Abrhs { get; set; }
        public string EmployeeName { get; set; }
        public string DesignationName { get; set; }
        public string AppraiserName { get; set; }
        public string RMName { get; set; }
        public string AppraisalCycleName { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public string Approver1Name { get; set; }
        public string AppraisalStatusName { get; set; }
        public string LastAppraisalCycleName { get; set; }
        public string EmployeePhotoName { get; set; }
        public string TeamName { get; set; }
        public string DepartmentName { get; set; }
        public string DivisionName { get; set; }
        public string VerticalName { get; set; }
        public long EmpAppraisalSettingId { get; set; }
    }

    //TECHNOCLUB

    public class GSOCProjectBO
    {
        public int GSOCProjectId { get; set; }
        public int GSOCProjectSubscriberId { get; set; }
        public string Title { get; set; }
        public string Status { get; set; }
        public string ProjectName { get; set; }

        public string Description { get; set; }

        public string FilePath { get; set; }

        public DateTime SubscribedOn { get; set; }

    }

    public class EmployeeHealthInsurance
    {
        public int UserID { get; set; }
        public string EmployeeCode { get; set; }
        public string EmployeeName { get; set; }
        public string FileName { get; set; }
        public string FileData { get; set; }
        public DateTime CreatedDate { get; set; }
        public string CreatedByAbrs { get; set; }
    }
}


