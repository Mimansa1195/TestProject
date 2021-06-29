using System.ComponentModel;
namespace MIS.BO
{
    public class Enums
    {
        public enum Roles
        {
            WebAdministrator = 1,
            MISAdministrator = 2,
            Manager = 3,
            User = 4,
            Trainee = 5
        }


        public enum GoalStatus
        {
            Drafted = 1,
            Submitted = 2,
            Approved = 3,
            Achieved = 4,
            Rejected = 5,
            Deleted = 6
        }

        public enum TimesheetStatus
        {
            [Description("Rejected")]
            Rejected = -1,

            [Description("Drafted")]
            Drafted = 0,

            [Description("Submitted")]
            Submitted = 1,

            [Description("Approved")]
            Approved = 2
        }

        public enum SchedulerRunsFor
        {
            [Description("All")]
            All = 1,

            [Description("Users")]
            UserIds = 2,

            [Description("Emails")]
            EmailIds = 3
        }

        public enum Departments
        {
            [Description("Human Resource")]
            HR = 34
        }

        public enum DesignationGroup
        {
            Technical = 1,
            Business = 2,
            Instructional = 3,
            Product = 4,
            HumanResource = 5,
            Administration = 6,
            Accounts = 7,
            IT = 8,
            General = 9,
            Other = 10,
	        ITNetwork  =  11,
	        ITSystems = 12,
	        Seekhley = 13,
	        TechnicalInfra = 14
        }
    }

    #region Outing Status Code

    public class OutingRequestStatusCode
    {
        public const string Applied = "AD";
        public const string PendingForApproval = "PA";
        public const string PendingForVerification = "PV";
        public const string Approved = "AP";
        public const string Verified = "VD";
        public const string RejectedByMGR = "RJM";
        public const string RejectedByHR = "RJH";
        public const string Cancelled = "CA";
    }

    public class UserTypeCode
    {
        public const string Manager = "MGR";
        public const string HumanResource = "HR";
    }
    #endregion

    #region Reimbursement
    public class ReimbursementStatusCode
    {
        public const string Applied = "AD";
        public const string PendingForApproval = "PA";
        public const string PendingForVerification = "PV";
        public const string Approved = "AP";
        public const string Verified = "VD";
        public const string Rejected = "RJ";
        public const string ReferredBack = "RB";
        public const string Cancelled = "CA";
    }
    public class ReimbursementTypeName
    {
        public const string Monthly = "Monthly";
        public const string Others = "Others";
    }
    #endregion

    #region Gender
    public class GenderCode
    {
        public const string Male = "ME";
        public const string Female = "FL";
    }
    #endregion

    #region DesignationDetails
    public class DesignationDetails
    {
        public const string TechnicalTrainee = "Technical Trainee";
    }
    #endregion

    public class ActivityMessages
    {
        #region UserProfile
        public const string ViewingProfile = "Viewing Profile";
        public const string UpdateProfile = "Profile Updated";
        public const string UpdateAddress = "Address Updated";
        #endregion

        #region VMS
        public const string EditAccessCardDetails = "Edit Access Card Details";
        public const string AddIssueCradDetails = "Add Access Card Details";
        public const string ChangeStatusOfIssuedCard = "Deactivated assigned card";
        #endregion

        #region Navigation Menu
        public const string AddNavigationMenu = "New Navigation Menu added successfully";
        public const string InActiveMenu = "Menu deactivated successfully";
        public const string ActiveMenu = "Menu activated successfully";

        public const string UpdateMenu = "Menu updated successfully";

        #endregion

        #region Manage Scheduler

        public const string AddNewScheduler = "New Scheduler added successfully";
        public const string ChangeStatusOfScheduler = "Status of scheduler changed";
        public const string UpdateScheduler = "Scheduler updated successfully";

        #endregion

        #region Time Sheet Msg

        public const string SavePrefrences = "Project Prefrences Saved.";
        public const string SaveTaskTemplate = "Task Template Saved.";
        public const string DeleteTaskTemplate = "Task Template Deleted";
        public const string UpdateTaskTemplate = "Task Template Updated.";
        public const string LogTimeSheet = "Time Sheet Task Logged";
        public const string LogTimeSheetToOtherUser = "Time Sheet Task Logged to Other User";
        public const string UpdateLoggedTask = "Logged Task Updated.";

        public const string DeleteLoggedTask = "Logged Task Deleted.";
        public const string SubmitWeeklyTimeSheet = "Weekly TimeSheet Submit.";
        public const string CopyTimeSheetFromWeek = "TimeSheet Copy From Week.";
        public const string OverwriteLoggedTask = "Logged Task Overwrite Updated .";
        public const string ApproveTimeSheet = "Time Sheet Approved.";
        public const string RejectTimeSheet = "Time Sheet Rejected.";
        public const string ChangedUserStatusForTimesheets = "Changed user status for timesheets.";
        #endregion

        #region AccessCard Msg

        public const string ChangeAccessCardState = "Access Card State Change.";
        public const string AddAccessCard = "Access Card Saved.";
        public const string DeleteUserCardMapping = "User Card Mapping Deleted.";
        public const string FinaliseUserCardMapping = "User Card Mapping Finalised.";
        public const string AddUserAccessCardMapping = "Access Card Mapping User Added.";
        public const string UpdateUserAccessCardMapping = "Access Card Mapping User Updated.";

        #endregion

        #region Asset Msg

        public const string CreateAssetRequest = "Asset Request Created.";
        public const string TakeActionOnAssetRequest = "Action Taken On Asset Request.";
        public const string AllocateAsset = "Asset Allocated.";
        public const string ReturnAsset = "Asset Return.";
        public const string AssignDongle = "Dongle Assigned.";

        #endregion

        #region Form Msg
        public const string AddForm = "Departmental form has been added.";
        public const string ChangeFormStatus = "Departmental form status has been changed.";

        public const string UserFormStatus = "User has {0} form";
        #endregion

        #region Policy Msg

        public const string ChangePolicyStatus = "Policy Status Changed.";
        public const string AddPolicy = "Policy Added.";

        #endregion

        #region Knowladge Base Msg

        public const string UpdateDocumentGroup = "Document Group Updated.";
        public const string DeleteDocumentGroupByGoupId = "Document Group Deleted.";
        public const string DeleteDocument = "Document Deleted.";
        public const string SaveGroup = "Group Saved.";
        public const string SaveShareDocument = "Share Document Saved.";
        public const string AddNewDocument = "New Document Added.";
        public const string UpdateDocument = "Document Updated.";
        public const string DeleteUserFromShareDocumentByUserId = "User From Share Document Deleted.";

        public const string AddDocumentTag = "Document Tag Added.";
        public const string SaveDocumentPermissionGroup = "Document Permission Group Saved.";
        public const string SaveDocumentPermissionGroupPermissions = "Document Permission Group Permissions Saved.";

        public const string SaveSharedGroupDocument = "Shared Group Document Saved.";
        public const string DeleteUserFromPermissionGroupByUserId = "User removed from Group Permissions.";
        public const string DeleteGroupFromSharedGroupByGroupId = "Group removed from Document Permissions.";

        #endregion

        #region LNSA Msg

        public const string InsertLnsaRequest = "Lnsa Request Saved.";
        public const string TakeActionOnLnsaRequest = "Action Taken On LNSA Request.";
        public const string BulkRemoveMarkedWeekOffUsers = "Unmarked user weekoff.";

        #endregion

        #region Project Management Msg

        public const string SaveProjectVertical = "Project Vertical Saved.";
        public const string UpdateProjectVertical = "Project Vertical Updated.";
        public const string SaveProject = "Project Saved.";
        public const string UpdateProject = "Project Updated.";
        public const string AssignTeamMember = "Team Member Assigned.";
        public const string UnAssignTeamMember = "Team Member UnAssigned.";

        #endregion

        #region Task Management Msg

        public const string AddNewTaskTeam = "New Task Team Added.";
        public const string AddNewTaskType = "New Task Type Added.";
        public const string AddNewTaskSubDetail1 = "New Task SubDetail 1 Added.";
        public const string AddNewTaskSubDetail2 = "New Task SubDetail 2 Added.";
        public const string UpdateTaskTeamDetails = "Task Team Details Updated.";
        public const string UpdateTaskTypeDetails = "Task Type Details Updated.";
        public const string UpdateTaskSubDetail1 = "Task SubDetail 1 Updated.";
        public const string UpdateTaskSubDetail2 = "Task SubDetail 2 Updated.";
        public const string DeleteTaskTeam = "Task Team Deleted.";
        public const string DeleteTaskType = "Task Type Deleted.";

        public const string DeleteTaskSubDetail1 = "Task SubDetail 1 Deleted.";
        public const string DeleteTaskSubDetail2 = "Task SubDetail 2 Deleted.";

        #endregion

        #region Team Management Msg

        public const string AddNewTeam = "New Team Added.";
        public const string UpdateTeamDetails = "Team Details Updated.";
        public const string DeleteTeam = "Team Deleted.";
        public const string InsertNewUserTeamMapping = "New User and Team Mapping Inserted.";
        public const string DeleteUserTeamMapping = "User and Team Mapping Deleted.";
        public const string AddNewShift = "New Shift Added.";
        public const string DeleteShift = "Shift Deleted.";
        public const string UpdateShiftDetails = "Shift Details Updated.";
        public const string DeleteShiftUserMapping = "Shift User Mapping Deleted.";

        #endregion

        #region User Services Msg

        public const string UnlockUser = "User Unlocked.";
        public const string ChangeUserStatus = "User Status Changed.";
        public const string PromoteUsers = "User Has Been Promoted.";
        //public const string InActivateEmployee = "User TerminationDate Updated.";
        public const string ChangeRegLinkStatus = "Registered Link Status Changed.";
        public const string EditUserPersonalInfo = "User Personal Info Edited.";
        public const string EditUserAddressInfo = "User Address Info Edited.";
        public const string EditUserCareerInfo = "User Career Info Edited.";
        public const string EditUserBankInfo = "User Bank Info Edited.";
        public const string EditUserJoiningInfo = "User Joining Info Edited.";
        public const string SaveNewUser = "New User Saved.";
        public const string GenerateLinkForUserRegistration = "Link For User Registration Generated.";
        public const string RejectUserRegistrationProfile = "User Registration Profile Rejected.";

        public const string AddUpdateMenusUserPermissions = "Menus User Permissions Updated.";
        public const string AddUpdateMenusRolePermissions = "Menus Role Permissions Updated.";
        public const string AddUpdateWidgetsUserPermissions = "Dashboard Widgets User Permissions Updated.";
        public const string AddUpdateWidgetsRolePermissions = "Dashboard Widgets Role Permissions Updated.";

        public const string AddUpdateDashboardSettings = "Dashboard Settings Updated.";

        #endregion

        #region LMS Msg

        public const string TakeActionOnLeave = "Action Taken On Leave.";
        public const string TakeActionOnCompOff = "Action Taken On Comp Off.";
        public const string TakeActionOnWFH = "Action Taken On Work From Home (WFH).";
        public const string TakeActionOnOuting = "Action Taken On Outing Request (OUTING).";
        public const string CancelOuting = "Outing Request cancelled successfully.";
        public const string RequestForWorkForHome = "Request For Work From Home.";
        public const string ApplyLeave = "Leave Applied.";
        public const string ApplyOuting = "Outing duty request applied.";
        public const string LnsaShiftCancel = "Lnsa shift request cancelled.";
        public const string LnsaShift = "Lnsa shift request applied.";
        public const string LnsaShiftReject = "Lnsa shift request rejected.";
        public const string LnsaShiftApprove = "Lnsa shift request approved.";
        public const string AdvanceLeaveCancelled = "Advance leave cancelled.";

        public const string CancelLeave = "Leave Canceled.";
        public const string InsertRequestForDataChange = "Request For Data Change Saved.";
        public const string TakeActionOnDataChangeRequest = "Action Taken On Data Change Request.";
        public const string UpdateLeaveBalanceByHR = "Leave Balance By HR Updated.";
        public const string UpdateEmployeeAttendanceDetails = "Employee Attendance Details Updated.";

        public const string BulkTakeActionOnLeave = "Leave Bulk Approve performed.";
        public const string BulkTakeActionOnCompOff = "Comp Off Bulk Approve performed.";
        public const string BulkTakeActionOnWFH = "WFH Bulk Approve performed.";

        public const string SubscribedGSOCProject = "GSOC Project has been subscribed.";
        public const string VisitedGSOCSubscriptionUrl = "GSOC Subscription Url has been visited.";
        public const string UnsubscribedGSOCProject = "GSOC Subscription has been cancelled.";
        #endregion Cab Request

        #region Reimbursement
        public const string SubmitReimbursement = "Reimbursement Request Submitted";
        public const string DraftReimbursement = "Reimbursement Request Drafted";
        public const string ReimbursementAction = "Taken Action On Reimbursement Request";



        #endregion


        public const string BulkTakeActionOnCabRequest = "Cab Request Bulk Approve performed.";

        public const string BulkFinalizedCabRequest = "Cab Request Bulk Finalized performed.";

        #region

        #endregion

        #region News

        public const string Addnews = "News has been saved.";
        public const string UpdateNews = "News has been Updated.";
        public const string ChangesNewsStatus = "News Status has been Updated.";
        public const string DeleteNew = "News Status has been Deleted.";

        #endregion

        #region Role

        public const string AddRole = "Role has been saved.";
        public const string UpdateRole = "Role has been Updated.";
        public const string DeleteRole = "Role has been Deleted.";

        #endregion

        #region User Role

        public const string UpdateUserRole = "User Role or Designation has been Updated.";

        #endregion

        #region Appraisal Management

        public const string AddAppraisalCycle = "Appraisal Cycle has been saved.";
        public const string UpdateAppraisalCycle = "Appraisal Cycle has been updated.";
        public const string DeleteAppraisalCycle = "Appraisal Cycle has been deleted.";
        public const string AddAchievement = "Achievement has been submitted.";

        public const string SaveParameter = "Parameter has been added.";
        public const string UpdateParameter = "Parameter has been updated.";

        public const string InActiveParameter = "Parameter has been deactivated.";
        public const string AciveParameter = "Parameter has been activated.";
        public const string DeleteParameter = "Parameter has been deleted.";
        public const string FinalizeParameter = "Parameter has been finalized.";

        public const string CompetencyFormClone = "Competency form has been cloned.";
        public const string CompetencyFormRetire = "Competency form has been retired.";
        public const string CompetencyFormDelete = "Competency form has been deleted.";

        public const string AppraisalFormSubmission = "Appraisal form has been submitted.";
        public const string AppraisalFormReferBack = "Appraisal form has been referred back.";

        public const string AddPimcoAchievement = "Pimco achievement has been submitted.";

        #endregion

        #region User Delegations


        public const string SaveMenuDelegation = "Menu Delegation Performed.";
        public const string DeleteMenuDelegation = "Menu Delegation Deleted.";

        #endregion

        #region referral
        public const string AddReferral = "Adding job posts.";
        public const string AddReferees = "Adding referrals.";
        public const string ChangeReferralStatus = "Opening and closing referral positions.";
        public const string UpdateJobPositions = "Updating job positions.";
        public const string MarkRelevant = "Marked referral relevant.";
        public const string MarkIrrelevant = "Marked referral irrelevant.";
        public const string SendReminderForReferral = "Reminder sent for referral.";

        #endregion
        #region pending requests
        public const string VerifyProfileRequests = "Verify Profile Requests.";
        #endregion
        #region Training
        public const string AddTrainings = "Training session added.";
        public const string ChangeTrainingStatus = "Status of training session changed.";
        public const string UpdateTrainingDetails = "Updated trainings ession details.";
        public const string ApplyForTrainings = "Applied for training session.";
        public const string ActionOnTrainingRequest = "Action taken on training request.";

        #endregion

        #region Generate Invoices
        public const string RequestInvoices = "Requesting invoices for client.";
        public const string GenerateInvoices = "Generating invoices for client.";
        public const string AddClients = "Adding new clients.";
        public const string ReviewInvoice = "Review invoice.";
        #endregion

        #region PimcoManagerMapping
        public const string OnshoreManagerMapping = " User's Onshore Manager Mapping";
        #endregion
    }

    public class ResponseStatus
    {
        private ResponseStatus(string value) { Value = value; }

        public string Value { get; set; }

        public static ResponseStatus Success { get { return new ResponseStatus("success"); } }
        public static ResponseStatus Warning { get { return new ResponseStatus("warning"); } }
        public static ResponseStatus Error { get { return new ResponseStatus("error"); } }
        //public static ResponseStatus Expired { get { return new ResponseStatus("expired"); } }

    }

    public class ResponseMessage
    {
        public const string Unauthorized = "Unauthorized";
        public const string Forbidden = "You do not have sufficient privileges or permissions to access the requested asset. Please contact the MIS administrator to verify your privileges and the permissions for this asset.";

        public const string Success = "Operation successful";
        public const string Error = "Error occurred";
        public const string EmptyToken = "Empty key or token.";
        public const string InvalidToken = "Invalid key or token.";

        public const string DBError = "Your request cannot be processed, please try after some time or contact to MIS team with reference id: {0} for further assistance.";

        public const string LoginSuccess = "Login successful";
        public const string LoginFailed = "Login failed";
        public const string FieldsRequired = "Required fields error";
        public const string PasswordExpired = "Password Expired";
        public const string PasswordIncorrect = "Password Incorrect";
        public const string AccountLocked = "Account Locked";
        public const string AccountSuspended = "Account Suspended";
    }

    public class EmailTemplates
    {
        public const string MonthlyAttendanceData = "Monthly Attendance Data";
        public const string DailyLeaveReport = "Daily Leave Report";
        public const string RejectLeave = "Reject Leave";
        public const string RejectTimesheet = "Reject Timesheet";
        public const string UserRegistrationNotification = "User Registration";
        public const string Wish = "Birthday And Anniversary Wishes";
        public const string ShiftMap = "User Shift Mapping";
        public const string ForwardedReferrals = "Forward Referrals";
        public const string ReimbursementRequest = "Reimbursement Request";
        public const string InvoiceRequest = "TimeSheet Submission Reminder";
        public const string RequestedInvoiceAction = "Requested Invoice Action";
        public const string CompOffRequest = "Comp-Off";
        public const string LeaveMailToOnShoreMgr = "Leave Mail To OnShore Mgr";
        public const string CabRequestReport = "Cab Request Report";
        public const string ViewCabRequest = "View Cab Request";
        public const string ReviewCabRequest = "Review Cab Request";
        public const string ProbationCompletion = "Probation Completion Feedback";
        public const string TrainingCompletion = "Training Completion Feedback";
        public const string UserFeedback = "Feedback";
        public const string NotifyHR = "Notify HR";
    }
    public class TagsForSendingEmails
    {
        public const string InvoiceRequest = "InvoiceRequest";
    }

    public class MediaTypes
    {
        public const string Excel = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
        public const string Pdf = "application/pdf";
    }

}
