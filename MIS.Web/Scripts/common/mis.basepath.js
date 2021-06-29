var misApiRootUrl = 'http://localhost:4115/';
var misApiBaseUrl = misApiRootUrl + 'api/';
var misApiDocsUrl = misApiRootUrl + 'Documents/ReimbursementDocs/';
var misApiImageUrl = misApiRootUrl + 'Images/';
var misApiProfileImageUrl = misApiImageUrl + 'ProfileImage/';
var misApiTempProfileImageUrl = misApiImageUrl + 'TempProfileImage/';
var misApiPoliciesUrl = misApiRootUrl + 'Documents/Policies/';
var misApiFormsUrl = misApiRootUrl + 'Documents/Forms/';
var misApiHealthInsuranceCardUrl = misApiRootUrl + 'Documents/HealthInsurance/';
var orgUrl = "http://geminisolutions.in/";
var accountPortalUrl = 'https://geminisolutions.greythr.com/';
var clientIPUrl = "http://ip-api.com/json/";

var misAppBaseUrl = window.location.protocol + '//' + window.location.hostname + (window.location.port ? ':' + window.location.port : '');

var misApiUrl = function () {

    return {
        //Authenticate
        'authenticate': misApiBaseUrl + 'Authenticate/Authenticate',
        'ping': misApiBaseUrl + 'User/Ping',
        'userInfo': misApiBaseUrl + 'User/GetUserInfo',
        'signOff': misApiBaseUrl + 'User/SignOff',
        'generateCodeForResetPassword': misApiBaseUrl + 'Anonymous/GenerateCodeForResetPassword',
        'changePassword': misApiBaseUrl + 'User/ChangePassword',
        'validateQueryString': misApiBaseUrl + 'Anonymous/ValidateQueryStringForPasswordReset',
        'resetPassword': misApiBaseUrl + 'Anonymous/ResetPassword',

        'uploadAttendance': misApiBaseUrl + 'Anonymous/UploadAttendance',

        //Role Permission
        'getMenusRolePermissions': misApiBaseUrl + 'Administrations/GetMenusRolePermissions',
        'getMenusUserPermissions': misApiBaseUrl + 'Administrations/GetMenusUserPermissions',
        'addUpdateMenusPermissions': misApiBaseUrl + 'Administrations/AddUpdateMenusPermissions',

        //Widget Permission
        'getWidgetsRolePermissions': misApiBaseUrl + 'Administrations/GetWidgetsRolePermissions',
        'getWidgetsUserPermissions': misApiBaseUrl + 'Administrations/GetWidgetsUserPermissions',
        'addUpdateWidgetPermissions': misApiBaseUrl + 'Administrations/AddUpdateWidgetPermissions',

        //Delegation
        'saveMenuDelegation': misApiBaseUrl + 'Administrations/SaveMenuDelegation',
        'getMenuDelegation': misApiBaseUrl + 'Administrations/GetMenuDelegation',
        'deleteMenuDelegation': misApiBaseUrl + 'Administrations/DeleteMenuDelegation',

        //Dashboard Settings
        'getUserRoleDashboardSettings': misApiBaseUrl + 'User/GetUserRoleDashboardSettings',
        'addUpdateDashboardSettings': misApiBaseUrl + 'User/AddUpdateDashboardSettings',

        //Health Insurance
        'getHealthInsuranceDetail': misApiBaseUrl + 'Dashboard/GetHealthInsuranceDetail',

        //User Management
        'getLockedUsersList': misApiBaseUrl + 'User/GetLockedUsersList',
        'unlockUser': misApiBaseUrl + 'User/UnlockUser',
        'getUserActivityLogs': misApiBaseUrl + 'User/GetUserActivityLogs',
        'getAllEmployeesByStatus': misApiBaseUrl + 'User/GetAllEmployeesByStatus',
        'getAllEmployees': misApiBaseUrl + 'User/GetAllEmployees',
        'loadFullNFinalData': misApiBaseUrl + 'User/LoadFullNFinalData',
        'promoteUsers': misApiBaseUrl + 'User/PromoteUsers',
        'getPromotionHistory': misApiBaseUrl + 'User/GetPromotionHistory',
        'changeUserStatus': misApiBaseUrl + 'User/ChangeUserStatus',
        'generateLinkForUserRegistration': misApiBaseUrl + 'User/GenerateLinkForUserRegistration',
        'getAllUserRegistrations': misApiBaseUrl + 'User/GetAllUserRegistrations',
        'changeRegLinkStatus': misApiBaseUrl + 'User/ChangeRegLinkStatus',
        'getUserRegistrationDataById': misApiBaseUrl + 'User/GetUserRegistrationDataById',
        'saveNewUser': misApiBaseUrl + 'User/SaveNewUser',
        'rejectUserProfile': misApiBaseUrl + 'User/RejectUserProfile',
        'getUserProfileDataByUserId': misApiBaseUrl + 'User/GetUserProfileDataByUserId',
        'editUserPersonalInfo': misApiBaseUrl + 'User/EditUserPersonalInfo',
        'editUserAddressInfo': misApiBaseUrl + 'User/EditUserAddressInfo',
        'editUserCareerInfo': misApiBaseUrl + 'User/EditUserCareerInfo',
        'editUserBankInfo': misApiBaseUrl + 'User/EditUserBankInfo',
        'editUserJoiningInfo': misApiBaseUrl + 'User/EditUserJoiningInfo',
        'fetchDataForEmployeeProfile': misApiBaseUrl + 'User/FetchDataForEmployeeProfile',
        'fetchDataForUpdateProfile': misApiBaseUrl + 'User/FetchDataForUpdateProfile',
        'updateUserProfile': misApiBaseUrl + 'User/UpdateUserProfile',
        'updateUserAddress': misApiBaseUrl + 'User/UpdateUserAddress',
        'verifyUserRegDetails': misApiBaseUrl + 'User/VerifyUserRegDetails',
        'listOldAndNewLeaveBalanceByUserId': misApiBaseUrl + 'User/ListOldAndNewLeaveBalanceByUserId',
        'lisLeaveBalanceForNewUser': misApiBaseUrl + 'User/LisLeaveBalanceForNewUser',
        'listPendingUnapprovedDataOfUser': misApiBaseUrl + 'User/ListPendingUnapprovedDataOfUser',
        'sendReminderMailToPreviousManager': misApiBaseUrl + 'User/SendReminderMailToPreviousManager',
        'updateReportingManagerForApprovals': misApiBaseUrl + 'User/UpdateReportingManagerForApprovals',
        'fetchUserLeaveBalanceDetail': misApiBaseUrl + 'User/FetchUserLeaveBalanceDetail',
        'fetchOnshoreUsers': misApiBaseUrl + 'User/FetchOnshoreUsers',
        'fetchOffshoreUsers': misApiBaseUrl + 'User/FetchOffshoreUsers',
        'countryList': misApiBaseUrl + 'User/CountryList',
        'companyLocationListByCountryId': misApiBaseUrl + 'User/CompanyLocationListByCountryId',
        'companyLocationListByUserId': misApiBaseUrl + 'User/CompanyLocationListByUserId',
        'changeUserLocationAndMapUserOnshore': misApiBaseUrl + 'User/ChangeUserLocationAndMapUserOnshore',


        // Common DropDown Binding
        'fetchGoalCategory': misApiBaseUrl + 'Common/FetchGoalCategory',
        'fetchTeamsToAddGoals': misApiBaseUrl + 'Common/FetchTeamsToAddGoals',
        'fetchTeamsToReviewGoals': misApiBaseUrl + 'Common/FetchTeamsToReviewGoals',


        'listAllActiveUsers': misApiBaseUrl + 'Common/ListAllActiveUsers',
        'listAllInActiveUsers': misApiBaseUrl + 'Common/ListAllInActiveUsers',
        'getReviewers': misApiBaseUrl + 'Common/ListAllReferralReviewers',
        'getReviewersToForward': misApiBaseUrl + 'Common/ListAllReferralReviewersToFwd',
        'listAllActiveUsersByDepartment': misApiBaseUrl + 'Common/ListAllActiveUsersByDepartment',
        'getAllReportingManager': misApiBaseUrl + 'Common/GetAllReportingManager',
        'getProbationPeriod': misApiBaseUrl + 'Common/GetProbationPeriodInMonths',
        'getRoles': misApiBaseUrl + 'Common/GetRoles',
        'getDepartments': misApiBaseUrl + 'Common/GetDepartments',
        'getDesignationGroups': misApiBaseUrl + 'Common/GetDesignationGroups',
        'getDesignationsByDesigGrpId': misApiBaseUrl + 'Common/GetDesignationsByDesigGrpId',
        'getDesignations': misApiBaseUrl + 'Common/GetDesignations',
        'fetchTaskTeams': misApiBaseUrl + 'Common/FetchTaskTeams',
        'fetchTaskTypes': misApiBaseUrl + 'Common/FetchTaskTypes',
        'fetchSelectedTaskTypeInfo': misApiBaseUrl + 'Common/FetchSelectedTaskTypeInfo',
        'fetchSubDetails1': misApiBaseUrl + 'Common/FetchSubDetails1',
        'fetchSubDetails2': misApiBaseUrl + 'Common/FetchSubDetails2',
        'getAllTempCards': misApiBaseUrl + 'Common/GetAllTempCards',
        'getFeedbackType': misApiBaseUrl + 'Common/GetFeedbackType',

        'getCountries': misApiBaseUrl + 'Common/GetCountries',
        'getStates': misApiBaseUrl + 'Common/GetStates',
        'getCities': misApiBaseUrl + 'Common/GetCities',
        'getGender': misApiBaseUrl + 'Common/GetGender',
        'getMaritalStatus': misApiBaseUrl + 'Common/GetMaritalStatus',
        'getOccupation': misApiBaseUrl + 'Common/GetOccupation',
        'getRelationship': misApiBaseUrl + 'Common/GetRelationship',

        'listTeamByUserId': misApiBaseUrl + 'Common/ListTeamByUserId',
        'listYears': misApiBaseUrl + 'Common/ListYears',
        'listWeeks': misApiBaseUrl + 'Common/ListWeeks',
        'getReportingManagersInADepartment': misApiBaseUrl + 'Common/GetReportingManagersInADepartment',
        'getReportingManagersInATeam': misApiBaseUrl + 'Common/GetReportingManagersInATeam',
        'getEmployeesReportingToUserByManagerId': misApiBaseUrl + 'Common/GetEmployeesReportingToUserByManagerId',
        'getTeamNames': misApiBaseUrl + 'Common/GetTeamNames',
        'getUsersForReports': misApiBaseUrl + 'Common/GetUsersForReports',
        'listSkillLevel': misApiBaseUrl + 'Common/ListSkillLevel',
        'listSkill': misApiBaseUrl + 'Common/ListSkill',
        'listSkillTypesForUser': misApiBaseUrl + 'Common/ListSkillTypesForUser',
        'listSkillTypesForHR': misApiBaseUrl + 'Common/ListSkillTypesForHR',
        'getUserDetailsByUserId': misApiBaseUrl + 'Common/GetUserDetailsByUserId',
        'fetchWeekInfoByDateId': misApiBaseUrl + 'Common/FetchWeekInfoByDateId',
        'getReportingEmployeesToUser': misApiBaseUrl + 'Common/GetAllEmployeesReportingToUser',
        'getControllers': misApiBaseUrl + 'Common/GetControllers',
        'getActiveControllers': misApiBaseUrl + 'Common/GetActiveControllers',
        'getActionsByControllerId': misApiBaseUrl + 'Common/GetActionsByControllerId',
        'getUserMonthYear': misApiBaseUrl + 'Common/GetUserMonthYear',
        'getFinancialYearsForUser': misApiBaseUrl + 'Common/GetFinancialYearsForUser',
        'getFinancialYears': misApiBaseUrl + 'Common/GetFinancialYears',
        'getQuartersForFY': misApiBaseUrl + 'Common/GetQuartersForFY',
        'getMonths': misApiBaseUrl + 'Common/GetFYMonths',
        'getCabRequestMonthYear': misApiBaseUrl + 'Common/GetCabRequestMonthYear',
        'getStatusForGoal': misApiBaseUrl + 'Common/GetStatusForGoal',
        'getStatusForGoalsReport': misApiBaseUrl + 'Common/GetStatusForGoalsReport',
        'getClients': misApiBaseUrl + 'Common/GetAllClients',
        //Dashboard
        'getADUserName': misApiBaseUrl + 'Dashboard/GetADUserName',
        'changeADPassword': misApiBaseUrl + 'Dashboard/ChangeADPassword',
        'getUserPrfileData': misApiBaseUrl + 'Dashboard/GetUserPrfileData',
        'getUpComingBIrthdayandHolidayData': misApiBaseUrl + 'Dashboard/GetUpComingBIrthdayandHolidayData',
        'getWorkAnniversary': misApiBaseUrl + 'Dashboard/GetWorkAnniversary',
        'getInOutTimeCurrentDayData': misApiBaseUrl + 'Dashboard/GetInOutTimeCurrentDayData',
        'getLeaveBalanceData': misApiBaseUrl + 'Dashboard/GetLeaveBalanceData',
        'getSelfAttendanceData': misApiBaseUrl + 'Dashboard/GetSelfAttendanceData',
        'getTeamAttendanceData': misApiBaseUrl + 'Dashboard/GetTeamAttendanceData',
        'getMealOfTheDay': misApiBaseUrl + 'Dashboard/GetMealOfTheDay',
        'getTeamLeaves': misApiBaseUrl + 'Dashboard/GetTeamLeaves',
        'getNewsForSlider': misApiBaseUrl + 'Dashboard/GetNewsForSlider',
        'wishEmployees': misApiBaseUrl + 'Dashboard/WishEmployees',
        'listDashboardLeavesByUserId': misApiBaseUrl + 'Dashboard/ListDashboardLeavesByUserId',
        'listDashboardCompOffByUserId': misApiBaseUrl + 'Dashboard/ListDashboardCompOffByUserId',
        'getUserWiseWeekDataInCalendar': misApiBaseUrl + 'Dashboard/GetUsersDashboardCalendarData',
        // Referral
        'addReferral': misApiBaseUrl + 'HRPortal/AddReferral',
        'getReferral': misApiBaseUrl + 'HRPortal/GetReferral',
        'getAllReferral': misApiBaseUrl + 'HRPortal/GetAllReferral',
        'addRefereeByUser': misApiBaseUrl + 'HRPortal/AddRefereeByUser',
        'getAllRequestedReferrals': misApiBaseUrl + 'HRPortal/GetAllRequestedReferral',
        'fetchReferralInformation': misApiBaseUrl + 'HRPortal/FetchAllRefereeDetails',
        'changeReferralStatus': misApiBaseUrl + 'HRPortal/ChangeReferralStatus',
        'viewReferralDetails': misApiBaseUrl + 'HRPortal/ViewReferralDetails',
        'updateReferrals': misApiBaseUrl + 'HRPortal/UpdateReferrals',
        'forwardReferrals': misApiBaseUrl + 'HRPortal/ForwardReferrals',
        'forwardAllReferrals': misApiBaseUrl + 'HRPortal/ForwardAllReferrals',
        'sendReminder': misApiBaseUrl + 'HRPortal/SendReminderForReferral',
        'viewResume': misApiBaseUrl + 'HRPortal/ViewResume',
        // Training
        'addTrainings': misApiBaseUrl + 'HRPortal/AddTrainings',
        'getAllTrainings': misApiBaseUrl + 'HRPortal/GetAllTrainings',
        'getTrainings': misApiBaseUrl + 'HRPortal/GetTrainings',
        'changeTrainingStatus': misApiBaseUrl + 'HRPortal/ChangeTrainingStatus',
        'viewTrainingDetails': misApiBaseUrl + 'HRPortal/ViewTrainingDetails',
        'updateTrainingDetails': misApiBaseUrl + 'HRPortal/UpdateTrainingDetails',
        'applyForTrainings': misApiBaseUrl + 'HRPortal/ApplyForTrainings',
        'getAppliedTrainingDetails': misApiBaseUrl + 'HRPortal/ViewAppliedTrainingDetails',
        'takeActionOnTrainingRequest': misApiBaseUrl + 'HRPortal/TakeActionOnTrainingRequest',
        'getAllNomineesDetails': misApiBaseUrl + 'HRPortal/GetAllNomineesDetails',
        'getTrainingRequests': misApiBaseUrl + 'HRPortal/GetPendingTrainingRequests',
        'getReviwedTrainingRequests': misApiBaseUrl + 'HRPortal/GetReviwedTrainingRequests',
        'viewDocument': misApiBaseUrl + 'HRPortal/ViewDocument',
        //pending requests
        'getAllProfilePendingRequests': misApiBaseUrl + 'HRPortal/GetAllProfilePendingRequests',
        'verifyUserProfile': misApiBaseUrl + 'HRPortal/VerifyUserProfile',
        'verifyBulkUserProfile': misApiBaseUrl + 'HRPortal/VerifyBulkUserProfile',
        //News
        'addNews': misApiBaseUrl + 'HRPortal/AddNews',
        'getAllNews': misApiBaseUrl + 'HRPortal/GetAllNews',
        'updateNews': misApiBaseUrl + 'HRPortal/UpdateNews',
        'changesNewsStatus': misApiBaseUrl + 'HRPortal/ChangesNewsStatus',
        'deleteNews': misApiBaseUrl + 'HRPortal/DeleteNews',
        'getNews': misApiBaseUrl + 'HRPortal/GetNews',

        //Training & Probation completion
        'getEmployeeListForFeedBackMail': misApiBaseUrl + 'HRPortal/GetEmployeeListForFeedBackMail',
        'sendProbationAndTrainingCompletionEmail': misApiBaseUrl + 'HRPortal/SendProbationAndTrainingCompletionEmail',

        // HealthInsurance Card
        'uploadHealthInsuranceCard': misApiBaseUrl + 'HRPortal/UploadHealthInsuranceCard',
        'getHealthInsuranceDetails': misApiBaseUrl + 'HRPortal/GetEmployeesHealthInsuranceDetails',

        //cab request
        'getCabRequestDetails': misApiBaseUrl + 'Dashboard/GetCabRequestDetails',
        'getDatesForPickAndDrop': misApiBaseUrl + 'Dashboard/GetDatesForPickAndDrop',
        'getShiftDetails': misApiBaseUrl + 'Dashboard/GetShiftDetails',
        'getCabRoutes': misApiBaseUrl + 'Dashboard/GetCabRoutes',
        'getCabDropLocations': misApiBaseUrl + 'Dashboard/GetCabDropLocations',
        'bookOrUpdateCabRequest': misApiBaseUrl + 'Dashboard/BookOrUpdateCabRequest',
        'takeActionOnCabRequest': misApiBaseUrl + 'Dashboard/TakeActionOnCabRequest',
        'getCabReviewRequest': misApiBaseUrl + 'Dashboard/GetCabReviewRequest',
        'getCabRequestToFinalize': misApiBaseUrl + 'Dashboard/GetCabRequestToFinalize',
        'takeActionOnCabBulkApprove': misApiBaseUrl + 'Dashboard/TakeActionOnCabBulkApprove',
        'bulkFinalizeCabRequests': misApiBaseUrl + 'Dashboard/BulkFinalizeCabRequests',
        'getCabServiceType': misApiBaseUrl + 'Dashboard/GetCabServiceType',
        'getDriverDetails': misApiBaseUrl + 'Dashboard/GetDriverDetails',
        'getDriverContactNo': misApiBaseUrl + 'Dashboard/GetDriverContactNo',
        'getVehicleDetails': misApiBaseUrl + 'Dashboard/GetVehicleDetails',
        'getFinalizedCabRequest': misApiBaseUrl + 'Dashboard/GetFinalizedCabRequest',
        'getGroupedFinalizedCabRequest': misApiBaseUrl + 'Dashboard/GetGroupedFinalizedCabRequest',
        'getGroupedCabRequestToFinalize': misApiBaseUrl + 'Dashboard/GetGroupedCabRequestToFinalize',
        'isValidTimeForCabBooking': misApiBaseUrl + 'Dashboard/IsValidTimeForCabBooking', 


        //Time Sheet
        'fetchProjectsAssignedToUser': misApiBaseUrl + 'TimeSheet/FetchProjectsAssignedToUser',
        'saveProjectPrefrences': misApiBaseUrl + 'TimeSheet/SaveProjectPrefrences',
        'fetchTemplatesForUser': misApiBaseUrl + 'TimeSheet/FetchTemplatesForUser',
        'saveTaskTemplate': misApiBaseUrl + 'TimeSheet/SaveTaskTemplate',
        'deleteTaskTemplate': misApiBaseUrl + 'TimeSheet/DeleteTaskTemplate',
        'fetchSelectedTemplateInfo': misApiBaseUrl + 'TimeSheet/FetchSelectedTemplateInfo',
        'updateTaskTemplate': misApiBaseUrl + 'TimeSheet/UpdateTaskTemplate',
        'listExcludedUsersForTimesheeet': misApiBaseUrl + 'TimeSheet/ListExcludedUsersForTimesheeet',
        'listEligibleUsersForTimesheeet': misApiBaseUrl + 'TimeSheet/ListEligibleUsersForTimesheeet',
        'excludeUserForTimesheet': misApiBaseUrl + 'TimeSheet/ExcludeUserForTimesheet',
        'changeUserToEligibleForTimesheet': misApiBaseUrl + 'TimeSheet/ChangeUserToEligibleForTimesheet',
        //Create TimeSheet
        'fetchWeekInfo': misApiBaseUrl + 'TimeSheet/FetchWeekInfo',
        'fetchWeekNoAndDates': misApiBaseUrl + 'TimeSheet/FetchWeekNoAndDates',
        'fetchWeekDetailByWeekNoAndYear': misApiBaseUrl + 'TimeSheet/FetchWeekDetailByWeekNoAndYear',
        'fetchTimeSheetInfo': misApiBaseUrl + 'TimeSheet/FetchTimeSheetInfo',
        'fetchTimeSheetInfoOtherUser': misApiBaseUrl + 'TimeSheet/FetchTimeSheetInfoOtherUser',
        'fetchProjectsForTimeSheet': misApiBaseUrl + 'TimeSheet/FetchProjectsForTimeSheet',
        'fetchProjectsForTimeSheetOtherUser': misApiBaseUrl + 'TimeSheet/FetchProjectsForTimeSheetOtherUser',
        'fetchTasksLoggedForTimeSheet': misApiBaseUrl + 'TimeSheet/FetchTasksLoggedForTimeSheet',
        'fetchTasksLoggedForTimeSheetOtherUser': misApiBaseUrl + 'TimeSheet/FetchTasksLoggedForTimeSheetOtherUser',
        'fetchTasksLoggedForProject': misApiBaseUrl + 'TimeSheet/FetchTasksLoggedForProject',
        'fetchSelectedTaskInfo': misApiBaseUrl + 'TimeSheet/FetchSelectedTaskInfo',
        'listWeeksForCopyTimeSheet': misApiBaseUrl + 'TimeSheet/ListWeeksForCopyTimeSheet',

        'logTask': misApiBaseUrl + 'TimeSheet/LogTask',
        'logTaskOtherUser': misApiBaseUrl + 'TimeSheet/LogTaskOtherUser',
        'updateLoggedTask': misApiBaseUrl + 'TimeSheet/UpdateLoggedTask',
        'deleteLoggedTask': misApiBaseUrl + 'TimeSheet/DeleteLoggedTask',
        'submitWeeklyTimeSheet': misApiBaseUrl + 'TimeSheet/SubmitWeeklyTimeSheet',
        'copyTimeSheetFromWeek': misApiBaseUrl + 'TimeSheet/CopyTimeSheetFromWeek',

        //TimeSheet Reports 
        'generateTimesheetReport': misApiBaseUrl + 'TimeSheet/GenerateTimesheetReport',

        //TimeSheet DashBoard
        'fetchPendingTimeSheets': misApiBaseUrl + 'TimeSheet/FetchPendingTimeSheets',
        'fetchCompletedTimeSheets': misApiBaseUrl + 'TimeSheet/FetchCompletedTimeSheets',

        //TimeSheet DataVarification
        'listApprovedTasks': misApiBaseUrl + 'TimeSheet/ListApprovedTasks',
        'fetchApprovedTaskInfo': misApiBaseUrl + 'TimeSheet/FetchApprovedTaskInfo',
        'listAllProjects': misApiBaseUrl + 'TimeSheet/ListAllProjects',
        'changeTaskStatus': misApiBaseUrl + 'TimeSheet/ChangeTaskStatus',
        'overwriteLoggedTask': misApiBaseUrl + 'TimeSheet/OverwriteLoggedTask',

        //Review TimeSheet 
        'fetchTimeSheetPendingforApproval': misApiBaseUrl + 'TimeSheet/FetchTimeSheetPendingforApproval',
        'fetchTimeSheetsApproved': misApiBaseUrl + 'TimeSheet/FetchTimeSheetsApproved',
        'approveTimeSheet': misApiBaseUrl + 'TimeSheet/ApproveTimeSheet',
        'rejectTimeSheet': misApiBaseUrl + 'TimeSheet/RejectTimeSheet',
        'fetchTemplatesForOtherUser': misApiBaseUrl + 'TimeSheet/FetchTemplatesForOtherUser',
        'getTimeSheetInfoForAllSelectedUsers': misApiBaseUrl + 'TimeSheet/GetTimeSheetInfoForAllSelectedUsers',

        //Employee Derectory
        'employeeDirectory': misApiBaseUrl + 'User/FetchDataForEmployeeDirectory',

        //LNSA
        'getConflictStatusOfLnsaPeriod': misApiBaseUrl + 'Lnsa/GetConflictStatusOfLnsaPeriod',
        'getAllLnsaRequest': misApiBaseUrl + 'Lnsa/GetAllLnsaRequest',
        'getAllPendingLnsaRequest': misApiBaseUrl + 'Lnsa/GetAllPendingLnsaRequest',
        'getAllApprovedLnsaRequest': misApiBaseUrl + 'Lnsa/GetAllApprovedLnsaRequest',
        'getLastNApprovedLnsaRequest': misApiBaseUrl + 'Lnsa/GetLastNApprovedLnsaRequest',
        'insertLnsaRequest': misApiBaseUrl + 'Lnsa/InsertLnsaRequest',
        'takeActionOnLnsaRequest': misApiBaseUrl + 'Lnsa/TakeActionOnLnsaRequest',
        'applyLnsaShift': misApiBaseUrl + 'Lnsa/ApplyLnsaShift',
        'getAllLnsaShiftRequest': misApiBaseUrl + 'Lnsa/GetAllLnsaShiftRequest',
        'getAllLnsaShiftReviewRequest': misApiBaseUrl + 'Lnsa/GetAllLnsaShiftReviewRequest',
        'getDateToCancelLnsaRequest': misApiBaseUrl + 'Lnsa/GetDateToCancelLnsaRequest',
        'cancelAllLnsaRequest': misApiBaseUrl + 'Lnsa/CancelAllLnsaRequest',
        'cancelLnsaRequest': misApiBaseUrl + 'Lnsa/CancelLnsaRequest',
        'getDateLnsaRequest': misApiBaseUrl + 'Lnsa/GetDateLnsaRequest',
        'rejectLnsaRequest': misApiBaseUrl + 'Lnsa/RejectLnsaRequest',
        'rejectAllLnsaRequest': misApiBaseUrl + 'Lnsa/RejectAllLnsaRequest',
        'approveLnsaShiftRequest': misApiBaseUrl + 'Lnsa/ApproveLnsaShiftRequest',
        'getShiftMappingDetails': misApiBaseUrl + 'Lnsa/GetShiftMappingDetails',
        'getCalenderOnPrevButtonClick': misApiBaseUrl + 'Lnsa/GetCalenderOnPrevButtonClick',
        'getCalenderOnNextButtonClick': misApiBaseUrl + 'Lnsa/GetCalenderOnNextButtonClick',
        'bulkApproveLnsaRequest': misApiBaseUrl + 'Lnsa/BulkApproveLnsaRequest',

        // 'getCurrentlyUsingCalendar': misApiBaseUrl + 'Lnsa/GetCurrentlyUsingCalendar',
        //Asset Allocation
        'getUserCommentForDongleAllocation': misApiBaseUrl + 'Asset/GetUserCommentForDongleAllocation',
        'getConflictStatusOfDongleAllocationPeriod': misApiBaseUrl + 'Asset/GetConflictStatusOfDongleAllocationPeriod',
        'getAssetDetailsForReportingManager': misApiBaseUrl + 'Asset/GetAssetDetailsForReportingManager',
        'getAssetDetailsForITDepartment': misApiBaseUrl + 'Asset/GetAssetDetailsForITDepartment',
        'getAssetDetailOnBasisOfAssetTag': misApiBaseUrl + 'Asset/GetAssetDetailOnBasisOfAssetTag',
        'getAvailableAssetTag': misApiBaseUrl + 'Asset/GetAvailableAssetTag',
        'getAssetDetailOnBasisOfRequestId': misApiBaseUrl + 'Asset/GetAssetDetailOnBasisOfRequestId',
        'getAllAssetRequest': misApiBaseUrl + 'Asset/GetAllAssetRequest',
        'getAllAssetCountData': misApiBaseUrl + 'Asset/GetAllAssetCountData',
        'getAssetCountDataByManagerId': misApiBaseUrl + 'Asset/GetAssetCountDataByManagerId',
        'createAssetRequest': misApiBaseUrl + 'Asset/CreateAssetRequest',
        'takeActionOnAssetRequest': misApiBaseUrl + 'Asset/TakeActionOnAssetRequest',
        'allocateAsset': misApiBaseUrl + 'Asset/AllocateAsset',
        'returnAsset': misApiBaseUrl + 'Asset/ReturnAsset',
        'returnAssetByUser': misApiBaseUrl + 'Asset/ReturnAssetByUser',
        //'assignDongle': misApiBaseUrl + 'Asset/AssignDongle',
        'getAssetRequestByUserID': misApiBaseUrl + 'Asset/GetAssetRequestByUserID',
        'getAssetRequestByApproverId': misApiBaseUrl + 'Asset/GetAssetRequestByApproverId',
        'getAssetDetailByRequestId': misApiBaseUrl + 'Asset/GetAssetDetailByRequestId',

        'getAssetTypes': misApiBaseUrl + 'Common/GetAssetTypes',
        'getAssetTypesToManageAsset': misApiBaseUrl + 'Asset/GetAllAssetTypes',
        'getAssetModels': misApiBaseUrl + 'Common/GetAssetModels',
        'getAllAssets': misApiBaseUrl + 'Asset/GetAllAssets',
        'addAssetDetails': misApiBaseUrl + 'Asset/AddAssetDetails',
        'deleteAssetDetails': misApiBaseUrl + 'Asset/DeleteAssetDetails',
        'getAssetDetailsById': misApiBaseUrl + 'Asset/GetAssetDetailsById',
        'updateAssetDetails': misApiBaseUrl + 'Asset/UpdateAssetDetails',
        'addUpdateAssetsDetail': misApiBaseUrl + 'Asset/AddUpdateAssetsDetail',
        'getAssetsBrand': misApiBaseUrl + 'Asset/GetAssetsBrand',
        'getAllAssetsDetail': misApiBaseUrl + 'Asset/GetAllAssetsDetail',
        'addUpdateUsersAssetsDetail': misApiBaseUrl + 'Asset/AddUpdateUsersAssetsDetail',
        'getAllUnAllocatedAssets': misApiBaseUrl + 'Asset/GetAllUnAllocatedAssets',
        'getAllUsersInActiveAssetsDetail': misApiBaseUrl + 'Asset/GetAllUsersInActiveAssetsDetail',
        'getAssetsByUserAbrhs': misApiBaseUrl + 'Asset/GetAssetsByUserAbrhs', 
        'getPendingForDeAllocationAssetsRequest': misApiBaseUrl + 'Asset/GetPendingForDeAllocationAssetsRequest', 
        'uploadAllocatedAssets': misApiBaseUrl + 'Anonymous/UploadAllocatedAssets', 
        'getSampleDocumentUrl': misApiBaseUrl + 'Asset/GetSampleDocumentUrl',
        'getUsersActiveAssets': misApiBaseUrl + 'Asset/GetUsersActiveAssets',

        //Form
        'getAllForms': misApiBaseUrl + 'Form/GetAllForms',
        'getAllActiveForms': misApiBaseUrl + 'Form/GetAllActiveForms',
        'changeFormStatus': misApiBaseUrl + 'Form/ChangeFormStatus',
        'addForm': misApiBaseUrl + 'Form/AddForm',
        'fetchFormInformation': misApiBaseUrl + 'Form/FetchFormInformation',

        //Organization Structure
        'fetchOrganizationStructurePdf': misApiBaseUrl + 'Form/FetchOrganizationStructurePdf',
        'fetchOrganizationStructure': misApiBaseUrl + 'User/FetchOrganizationStructure',
        'fetchPimcoOrganizationStructure': misApiBaseUrl + 'Pimco/FetchPimcoOrganizationStructure',

        //Users Form
        'getAllMyForms': misApiBaseUrl + 'Form/GetAllMyForms',
        'uploadMyForm': misApiBaseUrl + 'Form/UploadMyForm',
        'changeMyFormStatus': misApiBaseUrl + 'Form/ChangeMyFormStatus',
        'getAllUserForms': misApiBaseUrl + 'Form/GetAllUserForms',
        'fetchUserForm': misApiBaseUrl + 'Form/FetchUserForm',
        'fetchAllUserForms': misApiBaseUrl + 'Form/FetchAllUserForms',

        //Policy
        'getAllPolicies': misApiBaseUrl + 'Policy/GetAllPolicies',
        'getAllActivePolicies': misApiBaseUrl + 'Policy/GetAllActivePolicies',
        'changePolicyStatus': misApiBaseUrl + 'Policy/ChangePolicyStatus',
        'addPolicy': misApiBaseUrl + 'Policy/AddPolicy',
        'fetchPolicyInformation': misApiBaseUrl + 'Policy/FetchPolicyInformation',

        //TaskManagement
        'listAllTaskTeam': misApiBaseUrl + 'TaskManagement/ListAllTaskTeam',
        'listAllTaskType': misApiBaseUrl + 'TaskManagement/ListAllTaskType',
        'listAllTaskSubDetail1': misApiBaseUrl + 'TaskManagement/ListAllTaskSubDetail1',
        'listAllTaskSubDetail2': misApiBaseUrl + 'TaskManagement/ListAllTaskSubDetail2',
        'listAllMappedTypeTeam': misApiBaseUrl + 'TaskManagement/ListAllMappedTypeTeam',
        'listMappedTypeToTeam': misApiBaseUrl + 'TaskManagement/ListMappedTypeToTeam',
        'fetchTaskTeamByTeamId': misApiBaseUrl + 'TaskManagement/FetchTaskTeamByTeamId',
        'fetchTaskTypeByTypeId': misApiBaseUrl + 'TaskManagement/FetchTaskTypeByTypeId',
        'fetchTaskSubDetail1ById': misApiBaseUrl + 'TaskManagement/FetchTaskSubDetail1ById',
        'fetchTaskSubDetail2ById': misApiBaseUrl + 'TaskManagement/FetchTaskSubDetail2ById',
        'addNewTaskTeam': misApiBaseUrl + 'TaskManagement/AddNewTaskTeam',
        'addNewTaskType': misApiBaseUrl + 'TaskManagement/AddNewTaskType',
        'addNewTaskSubDetail1': misApiBaseUrl + 'TaskManagement/AddNewTaskSubDetail1',
        'addNewTaskSubDetail2': misApiBaseUrl + 'TaskManagement/AddNewTaskSubDetail2',
        'updateTaskTeamDetails': misApiBaseUrl + 'TaskManagement/UpdateTaskTeamDetails',
        'updateTaskTypeDetails': misApiBaseUrl + 'TaskManagement/UpdateTaskTypeDetails',
        'updateTaskSubDetail1': misApiBaseUrl + 'TaskManagement/UpdateTaskSubDetail1',
        'updateTaskSubDetail2': misApiBaseUrl + 'TaskManagement/UpdateTaskSubDetail2',
        'deleteTaskTeam': misApiBaseUrl + 'TaskManagement/DeleteTaskTeam',
        'deleteTaskType': misApiBaseUrl + 'TaskManagement/DeleteTaskType',
        'deleteTaskSubDetail1': misApiBaseUrl + 'TaskManagement/DeleteTaskSubDetail1',
        'deleteTaskSubDetail2': misApiBaseUrl + 'TaskManagement/DeleteTaskSubDetail2',

        //Attendance
        'getSupportingStaffMembers': misApiBaseUrl + 'Attendance/GetSupportingStaffMembers',
        'getAttSupportingStaff': misApiBaseUrl + 'Attendance/GetAttSupportingStaff',

        'getDepartmentOnReportToBasis': misApiBaseUrl + 'Attendance/GetDepartmentOnReportToBasis',
        'getEmployeeForAttendanceOnReportToBasis': misApiBaseUrl + 'Attendance/GetEmployeeForAttendanceOnReportToBasis',
        'processEmployeeAttendance': misApiBaseUrl + 'Attendance/ProcessEmployeeAttendance',
        'getAttendanceSummary': misApiBaseUrl + 'Attendance/GetAttendanceSummary',
        'getAttendanceForEmployees': misApiBaseUrl + 'Attendance/GetAttendanceForEmployees',
        'getPunchInOutLog': misApiBaseUrl + 'Attendance/GetPunchInOutLog',
        'getPermissionToViewAttendance': misApiBaseUrl + 'Common/GetPermissionToViewAttendance',
        'getPunchInOutLogForStaff': misApiBaseUrl + 'Attendance/GetPunchInOutLogForStaff',
        'getPunchInOutLogForTempCard': misApiBaseUrl + 'Attendance/GetPunchInOutLogForTempCard',
        'getAllAccessCard': misApiBaseUrl + 'Attendance/GetAllAccessCard',
        'getPunchInOutLogForAllCard': misApiBaseUrl + 'Attendance/GetPunchInOutLogForAllCard',

        //KnowledgeBase
        'getSharedDocumentByToUser': misApiBaseUrl + 'KnowledgeBase/GetSharedDocumentByToUser',
        'getDocumentGroupsByParentId': misApiBaseUrl + 'KnowledgeBase/GetDocumentGroupsByParentId',
        'getUserDetailBySharedDocId': misApiBaseUrl + 'KnowledgeBase/GetUserDetailBySharedDocId',
        'getDocumentByGroupId': misApiBaseUrl + 'KnowledgeBase/GetDocumentByGroupId',
        'getAllDocumentGroups': misApiBaseUrl + 'KnowledgeBase/GetAllDocumentGroups',
        'getAllUsersToShareDocByDocId': misApiBaseUrl + 'KnowledgeBase/GetAllUsersToShareDocByDocId',
        'getAllDocumentTags': misApiBaseUrl + 'KnowledgeBase/GetAllDocumentTags',
        'getAllDocumentPermissionGroup': misApiBaseUrl + 'KnowledgeBase/GetAllDocumentPermissionGroup',
        'getAllUserExceptOwnByPermissionGroupId': misApiBaseUrl + 'KnowledgeBase/GetAllUserExceptOwnByPermissionGroupId',
        'getAllUserByPermissionGroupId': misApiBaseUrl + 'KnowledgeBase/GetAllUserByPermissionGroupId',
        'getAllGroupExceptOwnByDocumentId': misApiBaseUrl + 'KnowledgeBase/GetAllGroupExceptOwnByDocumentId',
        'getAllGroupByDocumentId': misApiBaseUrl + 'KnowledgeBase/GetAllGroupByDocumentId',

        //Leave Management
        'getApproverRemarks': misApiBaseUrl + 'LeaveManagement/GetApproverRemarks',
        'getLeaves': misApiBaseUrl + 'LeaveManagement/GetLeaves',
        'getLeaveApplicationByApplicationID': misApiBaseUrl + 'LeaveManagement/GetLeaveApplicationByApplicationID',
        'takeActionOnLeave': misApiBaseUrl + 'LeaveManagement/TakeActionOnLeave',
        'getCompOffRequest': misApiBaseUrl + 'LeaveManagement/GetCompOffRequest',
        'fetchDatesToRequestCompOff': misApiBaseUrl + 'LeaveManagement/FetchDatesToRequestCompOff',
        'requestForCompOff': misApiBaseUrl + 'LeaveManagement/RequestForCompOff',
        'takeActionOnCompOff': misApiBaseUrl + 'LeaveManagement/TakeActionOnCompOff',
        'getWFHRequest': misApiBaseUrl + 'LeaveManagement/GetWFHRequest',
        'fetchDatesToRequestWorkFromHome': misApiBaseUrl + 'LeaveManagement/FetchDatesToRequestWorkFromHome',
        'takeActionOnWFH': misApiBaseUrl + 'LeaveManagement/TakeActionOnWFH',
        'requestForWorkForHome': misApiBaseUrl + 'LeaveManagement/RequestForWorkForHome',
        'fetchEmployeeAttendance': misApiBaseUrl + 'LeaveManagement/FetchEmployeeAttendance',
        'listLeaveBalanceByUserId': misApiBaseUrl + 'LeaveManagement/ListLeaveBalanceByUserId',
        'listLeaveBalanceForAllUser': misApiBaseUrl + 'LeaveManagement/ListLeaveBalanceForAllUser',
        'fetchAllEmployeesAttendance': misApiBaseUrl + 'LeaveManagement/FetchAllEmployeesAttendance',
        'fetchEmployeeAttendanceForToday': misApiBaseUrl + 'LeaveManagement/FetchEmployeeAttendanceForToday',
        'fetchEmployeeStatusForManager': misApiBaseUrl + 'LeaveManagement/FetchEmployeeStatusForManager',
        'fetchAllEmployeesRawAttendanceData': misApiBaseUrl + 'LeaveManagement/FetchAllEmployeesRawAttendanceData',
        'getLastRecordDetails': misApiBaseUrl + 'LeaveManagement/GetLastRecordDetails',
        'fetchDaysOnBasisOfLeavePeriod': misApiBaseUrl + 'LeaveManagement/FetchDaysOnBasisOfLeavePeriod',
        'fetchAvailableLeaves': misApiBaseUrl + 'LeaveManagement/FetchAvailableLeaves',
        'applyLeave': misApiBaseUrl + 'LeaveManagement/ApplyLeave',
        'cancelLeave': misApiBaseUrl + 'LeaveManagement/CancelLeave',
        'fetchDateForDataChange': misApiBaseUrl + 'LeaveManagement/FetchDateForDataChange',
        'getDataChangeRequest': misApiBaseUrl + 'LeaveManagement/GetDataChangeRequest',
        'insertRequestForDataChange': misApiBaseUrl + 'LeaveManagement/InsertRequestForDataChange',
        'takeActionOnDataChangeRequest': misApiBaseUrl + 'LeaveManagement/TakeActionOnDataChangeRequest',
        'listAvailedLeaveByUserId': misApiBaseUrl + 'LeaveManagement/ListAvailedLeaveByUserId',
        'updateLeaveBalanceByHR': misApiBaseUrl + 'LeaveManagement/UpdateLeaveBalanceByHR',
        'loadRemarks': misApiBaseUrl + 'LeaveManagement/LoadRemarks',
        'getEmployeeAttendanceDetails': misApiBaseUrl + 'LeaveManagement/GetEmployeeAttendanceDetails',
        'updateEmployeeAttendanceDetails': misApiBaseUrl + 'LeaveManagement/UpdateEmployeeAttendanceDetails',
        'listLeaveByUserId': misApiBaseUrl + 'LeaveManagement/ListLeaveByUserId',
        'listWorkFromHomeByUserId': misApiBaseUrl + 'LeaveManagement/ListWorkFromHomeByUserId',
        'listCompOffByUserId': misApiBaseUrl + 'LeaveManagement/ListCompOffByUserId',
        'listDataChangeRequestByUserId': misApiBaseUrl + 'LeaveManagement/ListDataChangeRequestByUserId',
        'takeActionOnLeaveBulkApprove': misApiBaseUrl + 'LeaveManagement/TakeActionOnLeaveBulkApprove',
        'takeActionOnCompOffBulkApprove': misApiBaseUrl + 'LeaveManagement/TakeActionOnCompOffBulkApprove',
        'takeActionOnWFHBulkApprove': misApiBaseUrl + 'LeaveManagement/TakeActionOnWFHBulkApprove',
        'takeActionOnOutingBulkApprove': misApiBaseUrl + 'LeaveManagement/TakeActionOnOutingBulkApprove',
        'takeActionOnLWPChangeBulkApprove': misApiBaseUrl + 'LeaveManagement/TakeActionOnLWPChangeBulkApprove',
        'takeActionOnDataChangeBulkApprove': misApiBaseUrl + 'LeaveManagement/TakeActionOnDataChangeBulkApprove',
        'submitLegitimateLeave': misApiBaseUrl + 'LeaveManagement/SubmitLegitimateLeave',
        'availableLeaveForLegitimate': misApiBaseUrl + 'LeaveManagement/AvailableLeaveForLegitimate',
        'listLegitimatetByUserId': misApiBaseUrl + 'Leavemanagement/ListLegitimatetByUserId',
        'getLegitimateRequest': misApiBaseUrl + 'Leavemanagement/GetLegitimateRequest',
        'takeActionOnLegitimateRequest': misApiBaseUrl + 'Leavemanagement/TakeActionOnLegitimateRequest',
        'listLWPMarkedBySystemByUserId': misApiBaseUrl + 'Leavemanagement/ListLWPMarkedBySystemByUserId',
        'getCalendarForWeekOff': misApiBaseUrl + 'Leavemanagement/GetCalendarForWeekOff',
        //'getNextMonthCalendar': misApiBaseUrl + 'Lnsa/GetNextMonthCalendar',
        //'getPreviousMonthCalendar': misApiBaseUrl + 'Lnsa/GetPreviousMonthCalendar',
        'addWeekOffForEmployees': misApiBaseUrl + 'Leavemanagement/AddWeekOffForEmployees',
        'getWeekOffMarkedEmployeesInfo': misApiBaseUrl + 'Leavemanagement/GetWeekOffMarkedEmployeesInfo',
        'getEligibleEmployeesReportingToUser': misApiBaseUrl + 'Leavemanagement/GetEligibleEmployeesReportingToUser',
        'bulkRemoveMarkedWeekOffUsers': misApiBaseUrl + 'Leavemanagement/BulkRemoveMarkedWeekOffUsers',
        //Outing Request Management
        'applyOutingRequest': misApiBaseUrl + 'LeaveManagement/ApplyOutingRequest',
        'listApplyOutingRequest': misApiBaseUrl + 'LeaveManagement/ListApplyOutingRequest',
        'getOutingReviewRequest': misApiBaseUrl + 'LeaveManagement/GetOutingReviewRequest',
        'getDateToCancelOutingRequest': misApiBaseUrl + 'LeaveManagement/GetDateToCancelOutingRequest',
        'cancelAllOutingRequest': misApiBaseUrl + 'LeaveManagement/CancelAllOutingRequest',
        'cancelOutingRequest': misApiBaseUrl + 'LeaveManagement/CancelOutingRequest',
        'takeActionOnOutingRequest': misApiBaseUrl + 'LeaveManagement/TakeActionOnOutingRequest',
        'getOutingType': misApiBaseUrl + 'LeaveManagement/GetOutingType',

        //Advance Leave
        'submitAdvanceLeave': misApiBaseUrl + 'LeaveManagement/SubmitAdvanceLeave',
        'getDatesToCancelAdvanceLeave': misApiBaseUrl + 'LeaveManagement/GetDatesToCancelAdvanceLeave',

        //Pimco User Management
        'fetchUsersOnshoreManagerData': misApiBaseUrl + 'User/FetchUsersOnshoreManagerData',
        'getAllEmployeesToMapOnshoreManager': misApiBaseUrl + 'User/GetUsersToMapOnshoreManager',
        'getAllOnshoreManager': misApiBaseUrl + 'User/GetOnShoreManager',
        'addOrUpdateUsersOnshoreMgr': misApiBaseUrl + 'User/AddOrUpdateUsersOnshoreMgr',
        'cancelOnshorManagerMapping': misApiBaseUrl + 'User/CancelOnshorManagerMapping',

        //File or docs
        'updateDocumentGroup': misApiBaseUrl + 'KnowledgeBase/UpdateDocumentGroup',
        'deleteDocumentGroupByGoupId': misApiBaseUrl + 'KnowledgeBase/DeleteDocumentGroupByGoupId',
        'deleteDocument': misApiBaseUrl + 'KnowledgeBase/DeleteDocument',
        'saveGroup': misApiBaseUrl + 'KnowledgeBase/SaveGroup',
        'saveShareDocument': misApiBaseUrl + 'KnowledgeBase/SaveShareDocument',
        'addNewDocument': misApiBaseUrl + 'KnowledgeBase/AddNewDocument',
        'updateDocument': misApiBaseUrl + 'KnowledgeBase/UpdateDocument',
        'deleteUserFromShareDocumentByUserId': misApiBaseUrl + 'KnowledgeBase/DeleteUserFromShareDocumentByUserId',
        'addDocumentTag': misApiBaseUrl + 'KnowledgeBase/AddDocumentTag',
        'saveDocumentPermissionGroup': misApiBaseUrl + 'KnowledgeBase/SaveDocumentPermissionGroup',
        'saveDocumentPermissionGroupPermissions': misApiBaseUrl + 'KnowledgeBase/SaveDocumentPermissionGroupPermissions',
        'saveSharedGroupDocument': misApiBaseUrl + 'KnowledgeBase/SaveSharedGroupDocument',
        'deleteUserFromPermissionGroupByUserId': misApiBaseUrl + 'KnowledgeBase/DeleteUserFromPermissionGroupByUserId',
        'deleteGroupFromSharedGroupByGroupId': misApiBaseUrl + 'KnowledgeBase/DeleteGroupFromSharedGroupByGroupId',

        //Project Management.

        //Gemini project
        'listActiveProjectVerticals': misApiBaseUrl + 'ProjectManagement/ListActiveProjectVerticals',
        'fetchSelectedVerticalInfo': misApiBaseUrl + 'ProjectManagement/FetchSelectedVerticalInfo',
        'listActiveUsers': misApiBaseUrl + 'ProjectManagement/ListActiveUsers',
        'fetchRoleforCurrentUser': misApiBaseUrl + 'ProjectManagement/FetchRoleforCurrentUser',
        'listActiveVerticals': misApiBaseUrl + 'ProjectManagement/ListActiveVerticals',
        'listActiveProjectIndustryType': misApiBaseUrl + 'ProjectManagement/ListActiveProjectIndustryType',
        'listActiveProjectStatus': misApiBaseUrl + 'ProjectManagement/ListActiveProjectStatus',
        'listProjects': misApiBaseUrl + 'ProjectManagement/ListProjects',
        'fetchSelectedProjectInfo': misApiBaseUrl + 'ProjectManagement/FetchSelectedProjectInfo',
        'fetchProjectInfo': misApiBaseUrl + 'ProjectManagement/FetchProjectInfo',
        'listTeamMembersforSelectedProject': misApiBaseUrl + 'ProjectManagement/ListTeamMembersforSelectedProject',
        'listAllUsersAvailableForProject': misApiBaseUrl + 'ProjectManagement/ListAllUsersAvailableForProject',
        'listAllUsersAssignedToProject': misApiBaseUrl + 'ProjectManagement/ListAllUsersAssignedToProject',
        'listRootProjects': misApiBaseUrl + 'ProjectManagement/ListRootProjects',
        'saveProjectVertical': misApiBaseUrl + 'ProjectManagement/SaveProjectVertical',
        'updateProjectVertical': misApiBaseUrl + 'ProjectManagement/UpdateProjectVertical',
        'saveProject': misApiBaseUrl + 'ProjectManagement/SaveProject',
        'updateProject': misApiBaseUrl + 'ProjectManagement/UpdateProject',
        'assignTeamMember': misApiBaseUrl + 'ProjectManagement/AssignTeamMember',
        'unAssignTeamMember': misApiBaseUrl + 'ProjectManagement/UnAssignTeamMember',

        //Pimco Project
        'listPimcoActiveProjectVerticals': misApiBaseUrl + 'ProjectManagement/ListPimcoActiveProjectVerticals',
        'fetchPimcoSelectedVerticalInfo': misApiBaseUrl + 'ProjectManagement/FetchPimcoSelectedVerticalInfo',
        'listPimcoActiveUsers': misApiBaseUrl + 'ProjectManagement/ListPimcoActiveUsers',
        'fetchPimcoRoleforCurrentUser': misApiBaseUrl + 'ProjectManagement/FetchPimcoRoleforCurrentUser',
        'listPimcoActiveVerticals': misApiBaseUrl + 'ProjectManagement/ListPimcoActiveVerticals',
        'listPimcoActiveProjectIndustryType': misApiBaseUrl + 'ProjectManagement/ListPimcoActiveProjectIndustryType',
        'listPimcoActiveProjectStatus': misApiBaseUrl + 'ProjectManagement/ListPimcoActiveProjectStatus',
        'listPimcoProjects': misApiBaseUrl + 'ProjectManagement/ListPimcoProjects',
        'fetchPimcoSelectedProjectInfo': misApiBaseUrl + 'ProjectManagement/FetchPimcoSelectedProjectInfo',
        'fetchPimcoProjectInfo': misApiBaseUrl + 'ProjectManagement/FetchPimcoProjectInfo',
        'listPimcoTeamMembersforSelectedProject': misApiBaseUrl + 'ProjectManagement/ListPimcoTeamMembersforSelectedProject',
        'listPimcoAllUsersAvailableForProject': misApiBaseUrl + 'ProjectManagement/ListPimcoAllUsersAvailableForProject',
        'listPimcoAllUsersAssignedToProject': misApiBaseUrl + 'ProjectManagement/ListPimcoAllUsersAssignedToProject',
        'listPimcoRootProjects': misApiBaseUrl + 'ProjectManagement/ListPimcoRootProjects',
        'savePimcoProjectVertical': misApiBaseUrl + 'ProjectManagement/SavePimcoProjectVertical',
        'updatePimcoProjectVertical': misApiBaseUrl + 'ProjectManagement/UpdatePimcoProjectVertical',
        'savePimcoProject': misApiBaseUrl + 'ProjectManagement/SavePimcoProject',
        'updatePimcoProject': misApiBaseUrl + 'ProjectManagement/UpdatePimcoProject',
        'assignPimcoTeamMember': misApiBaseUrl + 'ProjectManagement/AssignPimcoTeamMember',
        'unAssignPimcoTeamMember': misApiBaseUrl + 'ProjectManagement/UnAssignPimcoTeamMember',

        //AccessCard
        'getAllAccessCards': misApiBaseUrl + 'AccessCard/GetAllAccessCards',
        'changeAccessCardState': misApiBaseUrl + 'AccessCard/ChangeAccessCardState',
        'addAccessCard': misApiBaseUrl + 'AccessCard/AddAccessCard',
        'getAllUserCardMapping': misApiBaseUrl + 'AccessCard/GetAllUserCardMapping',
        'getAllUnmappedUser': misApiBaseUrl + 'AccessCard/GetAllUnmappedUser',
        'getAllUnmappedAccessCard': misApiBaseUrl + 'AccessCard/GetAllUnmappedAccessCard',
        'getUserCardMappingInfoById': misApiBaseUrl + 'AccessCard/GetUserCardMappingInfoById',
        'deleteUserCardMapping': misApiBaseUrl + 'AccessCard/DeleteUserCardMapping',
        'finaliseUserCardMapping': misApiBaseUrl + 'AccessCard/FinaliseUserCardMapping',
        'addUserAccessCardMapping': misApiBaseUrl + 'AccessCard/AddUserAccessCardMapping',
        'updateUserAccessCardMapping': misApiBaseUrl + 'AccessCard/UpdateUserAccessCardMapping',
        'getAllUnmappedStaff': misApiBaseUrl + 'AccessCard/GetAllUnmappedStaff',
        'getAllUserCardUnMappedHistory': misApiBaseUrl + 'AccessCard/GetAllUserCardUnMappedHistory',
        'getNextWorkingDate': misApiBaseUrl + 'AccessCard/GetNextWorkingDate',

        //Report
        'getLnsaReport': misApiBaseUrl + 'Report/GetLnsaReport',
        'getLnsaCompOffReport': misApiBaseUrl + 'Report/GetLnsaCompOffReport',
        'getLwpReport': misApiBaseUrl + 'Report/GetLwpReport',
        'getCompOffReport': misApiBaseUrl + 'Report/GetCompOffReport',
        'getClubbedReport': misApiBaseUrl + 'Report/GetClubbedReport',
        'getCompOffReportDetailsByUserId': misApiBaseUrl + 'Report/GetCompOffReportDetailsByUserId',
        'getLnsaReportDetailsByUserId': misApiBaseUrl + 'Report/GetLnsaReportDetailsByUserId',
        'getLwpReportDetailsByUserId': misApiBaseUrl + 'Report/GetLwpReportDetailsByUserId',
        'getVisitorDetails': misApiBaseUrl + 'Report/GetVisitorDetails',
        'getTempCardDetails': misApiBaseUrl + 'Report/GetTempCardDetails',
        'getTempCardDetailsForEdit': misApiBaseUrl + 'Report/GetTempCardDetailsForEdit',
        'addCardIssueDetail': misApiBaseUrl + 'Report/AddCardIssueDetail',
        'changeStatusOfIssuedCard': misApiBaseUrl + 'Report/ChangeStatusOfIssuedCard',
        'editAccessCardDetails': misApiBaseUrl + 'Report/EditAccessCardDetails',
        'getReportEmployeeSkills': misApiBaseUrl + 'Report/GetReportEmployeeSkills',
        'getUserActivity': misApiBaseUrl + 'Report/GetUserActivity',
        'getMealMenusData': misApiBaseUrl + 'Report/GetMealMenusData',
        'getMealFeedbackData': misApiBaseUrl + 'Report/GetMealFeedbackData',
        'getLeaveReport': misApiBaseUrl + 'Report/GetLeaveReport',
        'getGoalsForReports': misApiBaseUrl + 'Report/GetGoalsForReports',
        //TeamManagement 
        //Team Informations
        'listAllTeams': misApiBaseUrl + 'TeamManagement/ListAllTeams',
        'FetchTeamEmailTypeMapping': misApiBaseUrl + 'TeamManagement/FetchTeamEmailTypeMapping',
        'fetchTeamByTeamId': misApiBaseUrl + 'TeamManagement/FetchTeamByTeamId',
        'listAllWeekType': misApiBaseUrl + 'TeamManagement/ListAllWeekType',
        //'addNewTeam': misApiBaseUrl + 'TeamManagement/AddNewTeam',
        //'updateTeamDetails': misApiBaseUrl + 'TeamManagement/UpdateTeamDetails',
        'addUpdateTeamDetails': misApiBaseUrl + 'TeamManagement/AddUpdateTeamDetails',
        'deleteTeam': misApiBaseUrl + 'TeamManagement/DeleteTeam',
        //User Team Mapping
        'TeamsListforMapping': misApiBaseUrl + 'TeamManagement/TeamsListforMapping',
        'TeamsListforMappingByDeptId': misApiBaseUrl + 'TeamManagement/TeamsListforMappingByDeptId',
        'DeptListforMapping': misApiBaseUrl + 'TeamManagement/DeptListforMapping',

        'listMappedUserToTeam': misApiBaseUrl + 'TeamManagement/ListMappedUserToTeam',
        'listAllUser': misApiBaseUrl + 'TeamManagement/ListAllUser',
        'insertNewUserTeamMapping': misApiBaseUrl + 'TeamManagement/InsertNewUserTeamMapping',
        'deleteUserTeamMapping': misApiBaseUrl + 'TeamManagement/DeleteUserTeamMapping',
        'listAllShift': misApiBaseUrl + 'TeamManagement/ListAllShift',
        'listShiftByShiftId': misApiBaseUrl + 'TeamManagement/ListShiftByShiftId',
        'addNewShift': misApiBaseUrl + 'TeamManagement/AddNewShift',
        'deleteShift': misApiBaseUrl + 'TeamManagement/DeleteShift',
        'updateShiftDetails': misApiBaseUrl + 'TeamManagement/UpdateShiftDetails',
        //Shift User Mapping
        'GetShiftUserMappingList': misApiBaseUrl + 'TeamManagement/GetShiftUserMappingList',
        'SearchShiftUserMappingList': misApiBaseUrl + 'TeamManagement/SearchShiftUserMappingList',
        'MappedUsersOfTeam': misApiBaseUrl + 'TeamManagement/MappedUsersOfTeam',
        'GetShiftsList': misApiBaseUrl + 'TeamManagement/GetShiftsList',
        'AddUpdateShiftUserMapping': misApiBaseUrl + 'TeamManagement/AddUpdateShiftUserMapping',
        'GetDateIdList': misApiBaseUrl + 'TeamManagement/GetDateIdList',
        'DeleteShiftUserMapping': misApiBaseUrl + 'TeamManagement/DeleteShiftUserMapping',

        'getWeekDays': misApiBaseUrl + 'Common/GetWeekDays',
        'getTeams': misApiBaseUrl + 'Common/GetTeams',
        'GetTeamRoles': misApiBaseUrl + 'Common/GetTeamRoles',
        'getTeamsByDepartmentId': misApiBaseUrl + 'Common/GetTeamsByDepartmentId',
        'getTeamEmailTypes': misApiBaseUrl + 'Common/GetTeamEmailTypes',
        'getAllDepartments': misApiBaseUrl + 'Common/GetAllDepartments',
        'getUserMonthYear': misApiBaseUrl + 'Common/getUserMonthYear',

        //Skills
        'addSkills': misApiBaseUrl + 'Dashboard/AddSkills',
        'getUserSkills': misApiBaseUrl + 'Dashboard/GetUserSkills',
        'getUserSkillsBySkillId': misApiBaseUrl + 'Dashboard/GetUserSkillsBySkillId',
        'deleteSkills': misApiBaseUrl + 'Dashboard/DeleteSkills',

        //helpDocument
        'fetchHelpDocumentInformation': misApiBaseUrl + 'Dashboard/FetchHelpDocumentInformation',

        //Meal Management
        'getMealCategory': misApiBaseUrl + 'Common/GetMealCategory',
        'getMealPeriod': misApiBaseUrl + 'Common/GetMealPeriod',
        'getMealType': misApiBaseUrl + 'Common/GetMealType',
        'getMealDishes': misApiBaseUrl + 'Common/GetMealDishes',
        'getMealPackages': misApiBaseUrl + 'Common/GetMealPackages',

        'addMealPackages': misApiBaseUrl + 'Meal/AddMealPackages',
        'deleteMealPackages': misApiBaseUrl + 'Meal/DeleteMealPackages',
        'updateMealPackages': misApiBaseUrl + 'Meal/UpdateMealPackages',
        'getMealPackagesList': misApiBaseUrl + 'Meal/GetMealPackages',
        'getMealPackagesEdit': misApiBaseUrl + 'Meal/GetMealPackagesEdit',
        'updateMealPackages': misApiBaseUrl + 'Meal/UpdateMealPackages',
        'addMealoftheDay': misApiBaseUrl + 'Meal/AddMealoftheDay',
        'getAllMeals': misApiBaseUrl + 'Meal/GetAllMeals',
        'deleteMeal': misApiBaseUrl + 'Meal/DeleteMeal',
        'getMealEdit': misApiBaseUrl + 'Meal/GetMealEdit',
        'updateMealoftheDay': misApiBaseUrl + 'Meal/UpdateMealoftheDay',

        'addMealPeriod': misApiBaseUrl + 'Meal/AddMealPeriod',
        'deleteMealPeriod': misApiBaseUrl + 'Meal/DeleteMealPeriod',
        'updateMealPeriod': misApiBaseUrl + 'Meal/UpdateMealPeriod',
        'addMealCategory': misApiBaseUrl + 'Meal/AddMealCategory',
        'deleteMealCategory': misApiBaseUrl + 'Meal/DeleteMealCategory',
        'updateMealCategory': misApiBaseUrl + 'Meal/UpdateMealCategory',
        'addMealType': misApiBaseUrl + 'Meal/AddMealType',
        'deleteMealType': misApiBaseUrl + 'Meal/DeleteMealType',
        'updateMealType': misApiBaseUrl + 'Meal/UpdateMealType',
        'addMealDish': misApiBaseUrl + 'Meal/AddMealDish',
        'deleteMealDish': misApiBaseUrl + 'Meal/DeleteMealDish',
        'updateMealDish': misApiBaseUrl + 'Meal/UpdateMealDish',
        'submitMealFeedback': misApiBaseUrl + 'Meal/SubmitMealFeedback',

       

        //Manage Navigation Menu 
        'getNavigationMenus': misApiBaseUrl + 'Administrations/GetNavigationMenus',
        'changeMenuStatus': misApiBaseUrl + 'Administrations/ChangeMenuStatus',
        'addNavigationMenu': misApiBaseUrl + 'Administrations/AddNavigationMenu',
        'getMenus': misApiBaseUrl + 'Administrations/GetDetailsOfNavigationMenu',
        'updateMenus': misApiBaseUrl + 'Administrations/UpdateMenus',
        //Scheduler Actions 
        'getSchedulerActions': misApiBaseUrl + 'Administrations/GetSchedulerActions',
        'addNewScheduler': misApiBaseUrl + 'Administrations/AddNewScheduler',
        'changeStatusOfScheduler': misApiBaseUrl + 'Administrations/ChangeStatusOfScheduler',
        'getDetailsOfScheduler': misApiBaseUrl + 'Administrations/GetDetailsOfScheduler',
        'updateSchedulerData': misApiBaseUrl + 'Administrations/UpdateSchedulerData',
        //Manage Role 
        'addRole': misApiBaseUrl + 'Administrations/AddRole',
        'getAllRoles': misApiBaseUrl + 'Administrations/GetAllRoles',
        'getRole': misApiBaseUrl + 'Administrations/GetRole',
        'updateRole': misApiBaseUrl + 'Administrations/UpdateRole',
        'deleteRole': misApiBaseUrl + 'Administrations/DeleteRole',

        //User Role        
        'getAllUserRoles': misApiBaseUrl + 'Administrations/GetAllUserRoles',
        'getUserRole': misApiBaseUrl + 'Administrations/GetUserRole',
        'updateUserRole': misApiBaseUrl + 'Administrations/UpdateUserRole',

        // Log Error Report.
        'getErrorLogs': misApiBaseUrl + 'Administrations/GetErrorLogs',
        'getStackTraceById': misApiBaseUrl + 'Administrations/GetStackTraceById',

        // Appraisal Common
        'getCompanyLocation': misApiBaseUrl + 'Common/GetCompanyLocation',
        'getVertical': misApiBaseUrl + 'Common/GetVertical',
        'getDivisionByVertical': misApiBaseUrl + 'Common/GetDivisionByVertical',
        'getDepartmentByDivision': misApiBaseUrl + 'Common/GetDepartmentByDivision',
        'getTeamsByDepartment': misApiBaseUrl + 'Common/GetTeamsByDepartment',
        'getDesignationsByTeams': misApiBaseUrl + 'Common/GetDesignationsByTeams',
        'getDesignationsByDepartments': misApiBaseUrl + 'Common/GetDesignationsByDepartments',
        'getAppraisalCycleList': misApiBaseUrl + 'Common/GetAppraisalCycle',
        'getStageMaster': misApiBaseUrl + 'Common/GetStageMaster',
        'getCompetency': misApiBaseUrl + 'Common/GetCompetency',
        'getParameter': misApiBaseUrl + 'Common/GetParameter',
        'getAppraisalParametersYears': misApiBaseUrl + 'Common/GetAppraisalParametersYears',
        'getParameterList': misApiBaseUrl + 'AppraisalManagement/GetParameterList',
        'saveParameter': misApiBaseUrl + 'AppraisalManagement/SaveParameter',
        // Appraisal Management
        //Appraisal Cycle 
        'addAppraisalCycle': misApiBaseUrl + 'AppraisalManagement/AddAppraisalCycle',
        'getAllAppraisalCycles': misApiBaseUrl + 'AppraisalManagement/GetAllAppraisalCycles',
        'getAppraisalCycle': misApiBaseUrl + 'AppraisalManagement/GetAppraisalCycle',
        'updateAppraisalCycle': misApiBaseUrl + 'AppraisalManagement/UpdateAppraisalCycle',
        'deleteAppraisalCycle': misApiBaseUrl + 'AppraisalManagement/DeleteAppraisalCycle',
        'updateParameter': misApiBaseUrl + 'AppraisalManagement/UpdateParameter',
        'changeStatus': misApiBaseUrl + 'AppraisalManagement/ChangeStatus',
        'deleteParameter': misApiBaseUrl + 'AppraisalManagement/DeleteParameter',
        'finalizeParameter': misApiBaseUrl + 'AppraisalManagement/FinalizeParameter',
        'getFinancialYearForMyGoal': misApiBaseUrl + 'AppraisalManagement/GetFinancialYearForMyGoal',
        'getFinancialYearForTeamGoal': misApiBaseUrl + 'AppraisalManagement/GetFinancialYearForTeamGoal',

        //Competency Form
        'getAppraisalFormName': misApiBaseUrl + 'AppraisalManagement/GetAppraisalFormName',
        'addUpdateCompetencyForm': misApiBaseUrl + 'AppraisalManagement/AddUpdateCompetencyForm',
        'getCompetencyFormList': misApiBaseUrl + 'AppraisalManagement/GetCompetencyFormList',

        'retireCompetencyForm': misApiBaseUrl + 'AppraisalManagement/RetireCompetencyForm',
        'deleteCompetencyForm': misApiBaseUrl + 'AppraisalManagement/DeleteCompetencyForm',
        'getCompetencyFormDataForEdit': misApiBaseUrl + 'AppraisalManagement/GetCompetencyFormDataForEdit',
        'cloneCompetencyForm': misApiBaseUrl + 'AppraisalManagement/CloneCompetencyForm',
      

        //Changes Appraisal Year 2018
        'addUpdateTechnicalCompetencyForm': misApiBaseUrl + 'AppraisalManagement/AddUpdateTechnicalCompetencyForm',

        // Appraisal Settings.
        'addAppraisalSettings': misApiBaseUrl + 'AppraisalManagement/AddAppraisalSettings',
        'updateAppraisalSettings': misApiBaseUrl + 'AppraisalManagement/UpdateAppraisalSettings',
        'getAppraisalSettingList': misApiBaseUrl + 'AppraisalManagement/GetAppraisalSettingList',
        'deleteAppraisalSetting': misApiBaseUrl + 'AppraisalManagement/DeleteAppraisalSetting',
        'generateAppraisalSettings': misApiBaseUrl + 'AppraisalManagement/GenerateAppraisalSettings',

        //Team Appraisal
        'getApproverListByIDs': misApiBaseUrl + 'AppraisalManagement/GetApproverListByIDs',
        'getAppraiserListByIDs': misApiBaseUrl + 'AppraisalManagement/GetAppraiserListByIDs',
        'getEmpAppraisalSetting': misApiBaseUrl + 'AppraisalManagement/GetEmpAppraisalSetting',
        'getTeamAppraiselEditData': misApiBaseUrl + 'AppraisalManagement/GetTeamAppraiselEditData',
        'updateAppraisalTeamSettings': misApiBaseUrl + 'AppraisalManagement/UpdateAppraisalTeamSettings',
        'getAllEmployeesAppraisal': misApiBaseUrl + 'AppraisalManagement/GetAllEmployeesAppraisal',
        'getCompetencyList': misApiBaseUrl + 'Common/GetCompetencyList',

        //Appraisal Not Generated.
        'getAppraisalNotGeneratedList': misApiBaseUrl + 'AppraisalManagement/GetAppraisalNotGeneratedList',
        'createPendingEmpAppraisalSetting': misApiBaseUrl + 'AppraisalManagement/CreatePendingEmpAppraisalSetting',

        //My Appraisal
        'getSelfAppraiselData': misApiBaseUrl + 'AppraisalManagement/GetSelfAppraiselData',
        'getStatusHistory': misApiBaseUrl + 'AppraisalManagement/GetStatusHistory',
        'updateStatus': misApiBaseUrl + 'AppraisalManagement/UpdateStatus',
        'empHistory': misApiBaseUrl + 'AppraisalManagement/EmpHistory',

        //Appraisal Form
        'getAppraisalFormData': misApiBaseUrl + 'AppraisalManagement/GetAppraisalFormData',
        'getAppraisalFormDataForManagement': misApiBaseUrl + 'AppraisalManagement/GetAppraisalFormDataForManagement',
        'getPromotionDesignationsByUserId': misApiBaseUrl + 'AppraisalManagement/GetPromotionDesignationsByUserId',
        'saveEmployeeAppraisalForm': misApiBaseUrl + 'AppraisalManagement/SaveEmployeeAppraisalForm',
        'saveEmployeeAppraisalGoal': misApiBaseUrl + 'AppraisalManagement/SaveEmployeeAppraisalGoal',
        'saveEmployeeAppraisalAchievement': misApiBaseUrl + 'AppraisalManagement/SaveEmployeeAppraisalAchievement',
        'saveEmployeeAppraisalAchievementBySelf': misApiBaseUrl + 'AppraisalManagement/SaveEmployeeAppraisalAchievementBySelf',
        'changeAppraisalFormStatusToNextLevel': misApiBaseUrl + 'AppraisalManagement/ChangeAppraisalFormStatusToNextLevel',
        'saveEmployeeAppraisalPromotion': misApiBaseUrl + 'AppraisalManagement/SaveEmployeeAppraisalPromotion',
        'validateAndSubmitAppraisalForm': misApiBaseUrl + 'AppraisalManagement/ValidateAndSubmitAppraisalForm',
        'referBackAppraisalForm': misApiBaseUrl + 'AppraisalManagement/ReferBackAppraisalForm',

        //Appraisal Form Async - User and Upper Level
        'saveEmployeeAppraisalFormAsync': misApiBaseUrl + 'AppraisalManagement/SaveEmployeeAppraisalFormAsync',
        'saveEmployeeAppraisalGoalAsync': misApiBaseUrl + 'AppraisalManagement/SaveEmployeeAppraisalGoalAsync',
        //Appraisal Form Async - User
        'saveEmployeeAppraisalAchievementBySelfAsync': misApiBaseUrl + 'AppraisalManagement/SaveEmployeeAppraisalAchievementBySelfAsync',

        //Appraisal Form Async - Upper Level
        'saveEmployeeAppraisalAchievementAsync': misApiBaseUrl + 'AppraisalManagement/SaveEmployeeAppraisalAchievementAsync',
        'saveEmployeeAppraisalPromotionAsync': misApiBaseUrl + 'AppraisalManagement/SaveEmployeeAppraisalPromotionAsync',

        // Appraisal Report
        'getAppraisalStatus': misApiBaseUrl + 'AppraisalManagement/GetAppraisalStatus',
        'getEmployeeAppraisalStatusList': misApiBaseUrl + 'AppraisalManagement/GetEmployeeAppraisalStatusList',
        'getAppraisalReport': misApiBaseUrl + 'AppraisalManagement/GetAppraisalReport',
        'downloadAppraisalForm': misApiBaseUrl + 'AppraisalManagement/DownloadAppraisalForm',
        'sendAppraisalFormOnMail': misApiBaseUrl + 'AppraisalManagement/SendAppraisalFormOnMail',

        //goals
        'getAllSelfGoals': misApiBaseUrl + 'AppraisalManagement/GetAllSelfGoals',
        'markGoalAsAchieved': misApiBaseUrl + 'AppraisalManagement/MarkGoalAsAchieved',
        'getAllEmployeesReportingToUser': misApiBaseUrl + 'AppraisalManagement/GetAllEmployeesReportingToUser',
        'deleteGoal': misApiBaseUrl + 'AppraisalManagement/DeleteGoal',
        'approveGoal': misApiBaseUrl + 'AppraisalManagement/ApproveGoal',
        'addGoals': misApiBaseUrl + 'AppraisalManagement/AddGoal',
        'draftGoals': misApiBaseUrl + 'AppraisalManagement/DraftGoal',
        'submitGoals': misApiBaseUrl + 'AppraisalManagement/SubmitGoal',
        'fetchGoalDetailById': misApiBaseUrl + 'AppraisalManagement/FetchGoalDetailById',
        'fetchGoalHistoryById': misApiBaseUrl + 'AppraisalManagement/FetchGoalHistoryById',
        'editGoal': misApiBaseUrl + 'AppraisalManagement/EditGoal',

        //Team Goals
        'getAllTeamGoals': misApiBaseUrl + 'AppraisalManagement/GetAllTeamGoals',
        'fetchTeamGoalHistoryById': misApiBaseUrl + 'AppraisalManagement/FetchTeamGoalHistoryById',
        'fetchTeamGoalDetailById': misApiBaseUrl + 'AppraisalManagement/FetchTeamGoalDetailById',
        'editTeamGoal': misApiBaseUrl + 'AppraisalManagement/EditTeamGoal',
        'deleteTeamGoal': misApiBaseUrl + 'AppraisalManagement/DeleteTeamGoal',
        'approveTeamGoal': misApiBaseUrl + 'AppraisalManagement/ApproveTeamGoal',
        'addTeamGoals': misApiBaseUrl + 'AppraisalManagement/AddTeamGoals',
        'draftTeamGoals': misApiBaseUrl + 'AppraisalManagement/DraftTeamGoal',
        'submitTeamGoals': misApiBaseUrl + 'AppraisalManagement/SubmitTeamGoal',
        'getUserPrivilegesToAddTeamGoal': misApiBaseUrl + 'AppraisalManagement/GetUserPrivilegesToAddTeamGoal',
        'markTeamGoalAsAchieved': misApiBaseUrl + 'AppraisalManagement/MarkTeamGoalAsAchieved',

        //Reimbursement
        'getReimbursementType': misApiBaseUrl + 'Reimbursement/GetReimbursementType',
        'getReimbursementCategory': misApiBaseUrl + 'Reimbursement/GetReimbursementCategory',
        'draftReimbursementDetails': misApiBaseUrl + 'Reimbursement/DraftReimbursementDetails',
        'getReimbursementMonthYearToAddNewRequest': misApiBaseUrl + 'Reimbursement/GetReimbursementMonthYearToAddNewRequest',
        'getReimbursementListToView': misApiBaseUrl + 'Reimbursement/GetReimbursementListToView',
        'getReimbursementFormData': misApiBaseUrl + 'Reimbursement/GetReimbursementFormData',
        'cancelReimbursementRequest': misApiBaseUrl + 'Reimbursement/CancelReimbursementRequest',
        'submitReimbursementForm': misApiBaseUrl + 'Reimbursement/SubmitReimbursementForm',
        'getReimbursementListToReview': misApiBaseUrl + 'Reimbursement/GetReimbursementListToReview',
        'takeActionOnReimbursementRequest': misApiBaseUrl + 'Reimbursement/TakeActionOnReimbursementRequest',
        'getReimbursementMonthYearToViewAndApprove': misApiBaseUrl + 'Reimbursement/GetReimbursementMonthYearToViewAndApprove',
        'getReimbusrementStatusHistory': misApiBaseUrl + 'Reimbursement/GetReimbusrementStatusHistory',
        'getAllEmployeesForReimbursement': misApiBaseUrl + 'Reimbursement/GetAllEmployeesForReimbursement',


        //My Achievements and Team Achievements
        'getAllMyAchievements': misApiBaseUrl + 'AppraisalManagement/GetAllMyAchievements',
        'submitUserMidYearAchievement': misApiBaseUrl + 'AppraisalManagement/SubmitUserMidYearAchievement',
        'getUserMidYearAchievement': misApiBaseUrl + 'AppraisalManagement/GetUserMidYearAchievement',
        'getValidityFalgToAddAchievement': misApiBaseUrl + 'AppraisalManagement/GetValidityFalgToAddAchievement',
        'getTeamsAchievement': misApiBaseUrl + 'AppraisalManagement/GetTeamsAchievement',
        'getAllGoalCycleIdToViewAchievement': misApiBaseUrl + 'AppraisalManagement/getAllGoalCycleIdToViewAchievement',

        //Pimco Achievements

        //Quarterly
        'checkIfAllowedToFillPimcoAchievements': misApiBaseUrl + 'AppraisalManagement/CheckIfAllowedToFillPimcoAchievements',
        'submitUserQuarterlyAchievement': misApiBaseUrl + 'AppraisalManagement/SubmitUserQuarterlyAchievement',
        'getUserQuarterlyAchievement': misApiBaseUrl + 'AppraisalManagement/GetUserQuarterlyAchievement',
        'getTeamPimcoAchievements': misApiBaseUrl + 'AppraisalManagement/GetTeamPimcoAchievements',
        'getPimcoAchievementsOfTeamById': misApiBaseUrl + 'AppraisalManagement/GetPimcoAchievementsOfTeamById',
        'submitRMComments': misApiBaseUrl + 'AppraisalManagement/SubmitRMComments',

        //Monthly
        'checkIfAllowedToFillPimcoMonthlyAchievements': misApiBaseUrl + 'AppraisalManagement/CheckIfAllowedToFillPimcoMonthlyAchievements',
        'submitUserMonthlyAchievement': misApiBaseUrl + 'AppraisalManagement/SubmitUserMonthlyAchievement',
        'getUserMonthlyAchievement': misApiBaseUrl + 'AppraisalManagement/GetUserMonthlyAchievement',
        'getTeamPimcoMonthlyAchievements': misApiBaseUrl + 'AppraisalManagement/GetTeamPimcoMonthlyAchievements',
        'getPimcoMonthlyAchievementsOfTeamById': misApiBaseUrl + 'AppraisalManagement/GetPimcoMonthlyAchievementsOfTeamById',
        'getPimcoProjects': misApiBaseUrl + 'AppraisalManagement/GetPimcoProjects',

        //anonymous feedback
        'fetchAllFeedbacks': misApiBaseUrl + 'Feedback/FetchAllFeedbacks',
        'submitFeedback': misApiBaseUrl + 'Feedback/SubmitFeedback',
        'acknowledgeFeedback': misApiBaseUrl + 'Feedback/AcknowledgeFeedback',
        'fetchFeedbackById': misApiBaseUrl + 'Feedback/FetchFeedbackById',
        'fetchAllFeedbackByUserId': misApiBaseUrl + 'Feedback/FetchAllFeedbackByUserId',

        // A-Square Attendance.
        'getAttendanceUpload': misApiBaseUrl + 'Attendance/GetAttendanceUpload',
        'getDetailAttendance': misApiBaseUrl + 'Attendance/GetDetailAttendance',


        // TT Tournament.
        'getTTTournamentData': misApiBaseUrl + 'Sports/GetTTTournamentData',

        'getTournaments': misApiBaseUrl + 'Sports/GetTournaments',
        'getTournamentCategories': misApiBaseUrl + 'Sports/GetTournamentCategories',
        'getTournamentTeams': misApiBaseUrl + 'Sports/GetTournamentTeams',
        'getTournamentTeamDetails': misApiBaseUrl + 'Sports/GetTournamentTeamDetails',
        'updateTeamsScore': misApiBaseUrl + 'Sports/UpdateTeamsScore',
        'getTournamentTeamScore': misApiBaseUrl + 'Sports/GetTournamentTeamScore',
        'updateMatchStatus': misApiBaseUrl + 'Sports/UpdateMatchStatus',

        //Accounts Portal
        'checkForRequestEligibility': misApiBaseUrl + 'AccountsPortal/CheckForRequestEligibility',
        'generateInvoice': misApiBaseUrl + 'AccountsPortal/GenerateInvoices',
        'requestInvoice': misApiBaseUrl + 'AccountsPortal/RequestInvoices',
        'addClient': misApiBaseUrl + 'AccountsPortal/AddNewClient',
        'getInvoicesForReview': misApiBaseUrl + 'AccountsPortal/GetInvoicesForReview',
        'cancelInvoice': misApiBaseUrl + 'AccountsPortal/CancelInvoice',
        'getInvoiceReport': misApiBaseUrl + 'AccountsPortal/GetInvoiceReport',
        'getInvoice': misApiBaseUrl + 'AccountsPortal/GetInvoice',
        'takeActionOnInvoiceRequest': misApiBaseUrl + 'AccountsPortal/TakeActionOnInvoice',
        'getRequestedInvoiceInfo': misApiBaseUrl + 'AccountsPortal/GetRequestedInvoiceInfo',
        'getFinancialYearsForAccounts': misApiBaseUrl + 'AccountsPortal/GetFinancialYearsForAccounts',
        'getAccountPortal': misApiBaseUrl + 'AccountsPortal/GetAccountPortal',

        //Techno Club
        'getGSOCProjects': misApiBaseUrl + 'TechnoClub/GetGSOCProjects',
        'subscribeForGSOCProject': misApiBaseUrl + 'TechnoClub/SubscribeForGSOCProject',
        'getUserWiseSubscribedProjects': misApiBaseUrl + 'TechnoClub/GetUserWiseSubscribedProjects',
        'viewProjectPdf': misApiBaseUrl + 'TechnoClub/ViewProjectPdf',
        'viewUploadedDocInPopUp': misApiBaseUrl + 'TechnoClub/ViewUploadedDocInPopUp',
        'getProjectDetails': misApiBaseUrl + 'TechnoClub/GetProjectDetails',
        'fetchUploadedDocument': misApiBaseUrl + 'TechnoClub/FetchUploadedDocument',
        'fetchSampleDocument': misApiBaseUrl + 'TechnoClub/FetchSampleDocument',
        'changeSubscriptionStatus': misApiBaseUrl + 'TechnoClub/changeSubscriptionStatus',

         //Common
        'getAllActiveEmployees': misApiBaseUrl + 'Common/GetActiveEmployees'
    };
}();

var misAppUrl = function () {
    return {
        'login': misAppBaseUrl + '/Account/Login',
        'changePassword': misAppBaseUrl + '/Account/ChangePassword',
        'home': misAppBaseUrl + '/Home/Index',

        //Error
        'error': misAppBaseUrl + '/Error/Index',
        'unauthorized': misAppBaseUrl + '/Error/Unauthorized',
        'maintenance': misAppBaseUrl + '/Error/Maintenance',

        //Dashboard
        'dashboard': misAppBaseUrl + '/Dashboard/Index',
       
        //Asset
        'allocateAsset': misAppBaseUrl + '/Asset/_AllocateAsset',
        'returnAsset': misAppBaseUrl + '/Asset/_ReturnAsset',

        //Form
        'addForm': misAppBaseUrl + '/Form/_AddForm',
        'uploadMyForm': misAppBaseUrl + '/Form/_UploadMyForm',

        //Policy
        'addPolicy': misAppBaseUrl + '/Policy/_AddPolicy',

        //UserManagement
        'createUser': misAppBaseUrl + 'UserManagement/_CreateUser',
        'viewUserList': misAppBaseUrl + 'UserManagement/_ViewUsersList',
        'viewUserLocation': misAppBaseUrl + '/UserManagement/_ViewUserLocation',

        //Configure DashBoard
        'dashBoardSetting': misAppBaseUrl + '/Dashboard/_DashBoardSetting',
        'skills': misAppBaseUrl + '/Dashboard/_Skills',
        'helpDocument': misAppBaseUrl + '/Dashboard/_HelpDocument',
        'editSkills': misAppBaseUrl + '/Dashboard/_EditSkills',
        'newUserRegistration': misAppBaseUrl + '/UserManagement/NewUserRegistration?TempGuid=',
        'passwordReset': misAppBaseUrl + '/Account/PasswordReset?RefId=',
        'changeContactDetailUrl': misAppBaseUrl + '/UserManagement/UpdateContactDetails',
        'actionOnForwardedReferral': misAppBaseUrl + '/HRPortal/ForwardReferral',
        'actionOnRequestedInvoice': misAppBaseUrl + '/AccountsPortal/RequestedInvoiceAction',
        //Administrations

        //Manage Menus User and Role permission
        'manageRolePermission': misAppBaseUrl + '/Administrations/_ManageRolePermission',
        'manageUserPermission': misAppBaseUrl + '/Administrations/_ManageUserPermission',

        //Manage Widgets User and Role permission
        'manageWidgetRolePermission': misAppBaseUrl + '/Administrations/_ManageWidgetRolePermission',
        'manageWidgetUserPermission': misAppBaseUrl + '/Administrations/_ManageWidgetUserPermission',


        'listActiveUsers': misAppBaseUrl + '/UserManagement/_ListActiveUsers',
        'listInactiveUsers': misAppBaseUrl + '/UserManagement/_ListInactiveUsers',
        'manageUserDetail': misAppBaseUrl + '/UserManagement/_ManageUserDetail',
        'fullNFinalDetailContainer': misAppBaseUrl +'/UserManagement/_ManageFullNFinal',
        'viewInactiveUserDetail': misAppBaseUrl + '/UserManagement/_viewInactiveUserDetail',
        'verifyUserDetail': misAppBaseUrl + '/UserManagement/_VerifyUserDetail',
        'listUserRegistration': misAppBaseUrl + '/UserManagement/_ListUserRegistration',
        'userProfile': misAppBaseUrl + '/UserManagement/_UserProfile',
        'updateProfile': misAppBaseUrl + '/UserManagement/_UpdateProfile',
        'userDelegation': misAppBaseUrl + '/Administrations/_UserDelegation',
        'listPromotionUsers': misAppBaseUrl + '/UserManagement/_PromoteUsers',
        'listPromotionHistory': misAppBaseUrl + '/UserManagement/_PromotionHistory',
        // Appraisal  
        'addAppraisalSettings': misAppBaseUrl + '/AppraisalManagement/_AddAppraisalSettings',
        'editAppraisalSettings': misAppBaseUrl + '/AppraisalManagement/_EditAppraisalSettings',

        'addAppraisalParameter': misAppBaseUrl + '/AppraisalManagement/_AddAppraisalParameter',
        'createCompetencyForm': misAppBaseUrl + '/AppraisalManagement/_CreateCompetencyForm',
        'editCompetencyForm': misAppBaseUrl + '/AppraisalManagement/_EditCompetencyForm',
        'cloneCompetencyForm': misAppBaseUrl + '/AppraisalManagement/_CloneCompetencyForm',
        'appraisalFormSelf': misAppBaseUrl + '/AppraisalManagement/_AppraisalFormSelf',
        'appraisalFormUpperlevel': misAppBaseUrl + '/AppraisalManagement/_AppraisalFormUpperlevel',
        'appraisalFormForManagement': misAppBaseUrl + '/AppraisalManagement/_AppraisalFormForManagement',

        //Changes Appraisal Year 2018
        'createTechnicalCompetencies': misAppBaseUrl + '/AppraisalManagement/_CreateTechnicalCompetencies',
        'addAppraisalParameterByEmployee': misAppBaseUrl + '/AppraisalManagement/_AddAppraisalParameterByEmployee',

        //Achievements
        'uploadMyAchievement': misAppBaseUrl + '/AppraisalManagement/_UploadMyAchievement',

        // Reimbursement
        'manageReimbursementRequest': misAppBaseUrl + '/Reimbursement/_ManageReimbursementRequest',
        'viewReimbursementList': misAppBaseUrl + '/Reimbursement/_ViewReimbursementList',
        'viewReimbursementFormDetail': misAppBaseUrl + '/Reimbursement/_ViewReimbursementFormDetail',
        'reviewReimbursementList': misAppBaseUrl + '/Reimbursement/_ReviewReimbursementList',
        'getReimbursementFormDataToReview': misAppBaseUrl + '/Reimbursement/_ReviewReimbursementFormData',

        //Cab Request
        'reviewCabRequestAppUrl': misAppBaseUrl + '/CabRequest/ReviewCabRequest',

        //Project Management

        'manageGeminiProject': misAppBaseUrl + '/ProjectManagement/_ManageGeminiProject',
        'managePimcoProject': misAppBaseUrl + '/ProjectManagement/_ManagePimcoProject',


        //HR Portal
        // 'userDetailOnHRDashboard': misAppBaseUrl + '/HRPortal/_UserDetail',
        'uploadHealthsuranceCard': misAppBaseUrl + '/HRPortal/_UploadHealthInsuranceCard',  
    }
}();