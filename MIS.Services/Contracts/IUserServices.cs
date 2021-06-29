using MIS.BO;
using System;
using System.Collections.Generic;

namespace MIS.Services.Contracts
{
    public interface IUserServices
    {
        /// <summary>
        /// Public method to authenticate user by user name and password.
        /// </summary>
        /// <param name="userName">UserName</param>
        /// <param name="password">Password</param>
        /// <param name="browserInfo">BrowserInfo</param>
        /// <param name="clientInfo">ClientInfo</param>
        /// <returns>ResponseBO</returns>
        ResponseBO<UserAccountStatus> Authenticate(string userName, string password, string browserInfo, string clientInfo);

        /// <summary>
        /// Public method to get user details by userId.
        /// </summary>
        /// <param name="userId">UserId</param>
        /// <returns>AuthenticateUserBO</returns>
        UserDetailType GetUserDetailsDashboard(string userAbrhs);

        AuthenticateUserBO GetUserDetails(int userId);
        /// <summary>
        /// Method to get all active employee details for employee directory
        /// </summary>
        /// <returns>List<EmployeeDirectoryBO></returns>
        List<EmployeeDirectoryBO> FetchDataForEmployeeDirectory();

        AuthenticateUserBO GetData(string userAbrhs);

        DashboardNotification DashboardNotification(string userAbrhs);

        List<UsersWorkAnniversary> GetWorkAnniversary(string userAbrhs);

        DataForLeaveBalance ListLeaveBalanceByUserId(string userAbrhs);

        List<DataForAttendance> FetchEmployeeAttendance(string userAbrhs, int year, int month);

        List<EmployeeStatusDataForManager> FetchEmployeeStatusForManager(string userAbrhs);

        EmployeeStatusDataForManager FetchEmployeeAttendanceForToday(string userAbrhs);

        EmployeeStatusDataForManager FetchEmployeeAttendanceDateWise(string userAbrhs, string forDate);


        List<MealOfTheDayBO> GetMealOfTheDay(string userAbrhs);

        List<TeamMemberLeaveBO> GetTeamLeaves(string userAbrhs);

        List<NewsScrollerBO> GetNewsForSlider(string userAbrhs);


        #region User Management

        /// <summary>
        /// Method to get locked users list
        /// </summary>
        /// <param name="userAbrhs">UserAbrhs</param>
        /// <returns></returns>
        List<LockedUserDetailBO> GetLockedUsersList(string userAbrhs);

        /// <summary>
        /// Method to unlock user account
        /// </summary>
        /// <param name="userAbrhs">Login UserAbrhs</param>
        /// <param name="employeeAbrhs">Employee's UserAbrhs</param>
        /// <returns>True/False</returns>
        bool UnlockUser(string userAbrhs, string employeeAbrhs);


        /// <summary>
        /// Method to get logged-in users log history
        /// </summary>
        /// <param name="userAbrhs">UserAbrhs</param>
        /// <param name="employeeAbrhs">EmployeeAbrhs</param>
        /// <param name="fromDate">FromDate</param>
        /// <param name="toDate">ToDate</param>
        /// <returns>UserActivityLogBO List</returns>
        List<UserActivityLogBO> GetUserActivityLogs(string userAbrhs, string employeeAbrhs, DateTime fromDate, DateTime toDate);

        List<UserManagementDetailBO> GetAllEmployeesByStatus(int status);

        List<UserManagementDetailBO> GetAllEmployees();

        LeaveBalanceForFnF GetUserLeaveDetailForFnF(string userAbrhs, string fromDate, string tillDate);

        int PromoteUsers(string employeeAbrhs, int newDesignationId, DateTime promotionDate, string newEmpCode, string userAbrhs);

        List<UserManagementDetailBO> GetPromotionHistory();

        bool ChangeUserStatus(string employeeAbrhs, int status, DateTime terminationDate, string userAbrhs);

        int GenerateLinkForUserRegistration(string userName, string adUserName, string domain, string userAbrhs, string redirectionLink);

        string ValidateQueryStringForUserRegistration(string tempUserGuid);

        List<UserRegistationDataBO> GetAllUserRegistrations();

        bool ChangeRegLinkStatus(int registrationId, int status, string userAbrhs, string redirectionLink);

        UserDetailBO GetUserRegistrationDataById(long registrationId);

        UserDetailBO GetUserProfileDataByUserId(string employeeAbrhs);

        bool EditUserPersonalInfo(UserPersonalDetailBO userPersonalDetail);

        bool EditUserAddressInfo(List<UserAddressDetailBO> userAddressDetail);

        bool EditUserCareerInfo(UserPersonalDetailBO userCareerDetail);

        bool EditUserBankInfo(UserPersonalDetailBO userBankDetail);

        bool EditUserJoiningInfo(UserJoiningDetailBO userJoiningDetail);

        MappingInfoBo SaveNewUser(long registrationId, string employeeId, string departmentAbrhs, string designationAbrhs, int probationPeriod, long teamId, string wsNo, string extensionNo, /*string accCardNo*/
                                 string doj, string roleAbrhs, string reportingManagerAbrhs, string userAbrhs, string redirectionLink);

        int VerifyUserRegDetails(long registrationId, string sourceBasePath, string destinationBasePath, int accessCardId, string employeeAbrhs, bool isPimcoUserCardMapping, string userAbrhs, DateTime fromDateNew, string redirectionLink);

        bool RejectUserProfile(long registrationId, string reason, string userAbrhs, string redirectionLink);

        //MappingInfoBo GetUserInfoForAccessCardMapping(long registrationId);

        int SaveNewUserRegPersonalInfo(UserPersonalDetailBO userPersonalDetail, string basePath, string guId);

        int SaveNewUserRegAddressInfo(List<UserAddressDetailBO> userAddressDetail);

        bool SaveNewUserRegCareerInfo(UserPersonalDetailBO userCareerDetail);

        bool SaveNewUserRegBankInfo(UserPersonalDetailBO userBankDetail);

        UserDetailBO GetExistingUserRegistrationData(string tempUserGuid);

        List<MandatoryFieldBO> CheckIfAllMandatoryFieldsAreSubmitted(string tempUserGuid);

        bool SubmitUserRegistrationData(string tempUserGuid);

        OldAndNewLeaveBalance ListOldAndNewLeaveBalanceByUserId(string userAbrhs, int empDesignationId, DateTime promotionDate);

        OldAndNewLeaveBalance LisLeaveBalanceForNewUser(string empDesignationAbrhs, DateTime joiningDate);

        List<PendingDataForApprovals> ListPendingUnapprovedDataOfUser(string employeeAbrhs);

        int SendReminderMailToPreviousManager(string employeeAbrhs);

        int UpdateReportingManagerForApprovals(string employeeAbrhs, string rmAbrhs, string userAbrhs);

        List<FullnFinalDataBO> FetchUserLeaveBalanceDetail(string dol, string userAbrhs);


        #endregion

        #region DashBoard Settings

        /// <summary>
        /// Method to get menu permissions by role
        /// </summary>
        /// <param name="userAbrhs">UserAbrhs</param>
        /// <param name="roleAbrhs">RoleAbrhs</param>
        /// <returns>ManageMenusPermissionBO</returns>
        UserDashBoardSettingsListBO GetUserRoleDashboardSettings(string userAbrhs);

        /// <summary>
        /// Method to add or update menus role's/user's permissions
        /// </summary>
        /// <param name="permission">ManageMenusPermissionBO</param>
        /// <returns>success : 1, error: 0, invalid: 2</returns>
        int AddUpdateDashboardSettings(ManageDashBoardSettingsBO dashBoardSettings);

        #endregion

        #region Skills

        int AddSkills(SkillsDetailBO skillsDetailBO);

        List<SkillsDetailBO> GetUserSkills(string userAbrhs);

        SkillsDetailBO GetUserSkillsBySkillId(int userSkillId, string userAbrhs);

        int DeleteSkills(int userSkillId, string userAbrhs);

        #endregion

        #region User Profile

        EmployeeProfileBO FetchDataForEmployeeProfile(string emailId, string UserAbrhs);

        EmployeeUpdateProfileBO FetchDataForUpdateProfile(string UserAbrhs);

        int UpdateUserProfile(EmployeeUpdateProfileBO employeeUpdateProfileBO);

        int UpdateUserAddress(EmployeeUpdateProfileBO employeeUpdateProfileBO);

        #endregion

        #region User Activity

        void SaveUserLogs(string Activity, int VisitedByUserId, int VisitedForUserId);

        #endregion

        #region password reset

        int GenerateCodeForResetPassword(string userName, string redirectionLink, string clientIP); //1: user does not exists, 2:user account is locked, 3: error occured, 4: success

        string ValidateQueryStringForPasswordReset(string passwordResetCode);

        int ResetPassword(string passwordResetCode, string userName, string password);//1: success, 2: unauthorised, 3: error

        #endregion

        int ChangePassword(string userAbrhs, string oldPassword, string newPassword);//1: success, 2: unauthorised user, 3: invalid current password, 4: error

        #region Wishes

        int WishEmployees(string wishTo, int wishType, string message, string userAbrhs);

        #endregion

        #region Dashboard Leaves
        List<DataForLeaveManagementBO> ListDashboardLeavesByUserId(string leaveType, DateTime year, string userAbrhs);

        List<DataForLeaveManagementBO> ListDashboardCompOffByUserId(string userAbrhs, DateTime year);
        #endregion

        #region Health Insurance

        HealthInsurance GetHealthInsuranceDetail(int userId, string basePath);

        #endregion

        #region ADPassword
        string GetADUserName(int userId);
        ResponseBO<bool> ChangeADPassword(int userId, string currntADPassword, string newADPassword);
        #endregion

        #region help document

        string FetchHelpDocumentInformation(string basePath);

        #endregion

        #region Change Contact Details

        int ApproveChangeContactDetailRequest(string ActionData, string Reason);

        int RejectChangeContactDetailRequest(string ActionData, string Reason);

        #endregion

        #region Org Str
        List<OrganizationStructureBO> FetchOrganizationStructure(string userAbrhs, int parentId);
        #endregion

        #region Cab Request

        List<CabRequestBO> GetCabRequestDetails(string userAbrhs, int Month, int Year);

        List<CabRequestBO> GetCabRequestToFinalize(CabRequestBO data, int loginUserId);

        List<CabRequestBO> GetFinalizedCabRequest(CabRequestBO data, int loginUserId);

        List<CabRequestBO> GetGroupedCabRequestToFinalize(CabRequestBO data, int loginUserId);

        List<CabRequestBO> GetGroupedFinalizedCabRequest(CabRequestBO data, int loginUserId);

        int BulkFinalizeCabRequests(int loginUserId, CabDriverBO inputs);

        List<CabRequestBO> GetDatesForPickAndDrop(CabRequestBO inputs, int userId);

        List<CabRequestBO> GetShiftDetails(CabRequestBO inputs, int userId);

        List<CabRequestBO> GetShiftForFilter(CabRequestBO inputs, int userId);

        List<CabRequestBO> GetCabRoutes(CabRequestBO inputs);

        List<CabRequestBO> GetCabDropLocations(CabRequestBO inputs);

        List<CabRequestBO> GetCabServiceType();

        bool IsValidTimeForCabBooking(string forScreen);

        List<CabDriverBO> GetDriverDetails(string locationIds);

        string GetDriverContactNo(CabDriverBO inputs);

        List<CabDriverBO> GetVehicleDetails(string locationIds);

        CabRequestResponseBO BookOrUpdateCabRequest(CabRequestBO cab);

        int EditCabRequest(CabRequestBO data);

        int TakeActionOnCabRequest(CabRequestBO data);

        int TakeActionOnCabRequestAnonymous(string encodedData, string actionCode, string remarks, string forScreen);

        int GetCabRequestDetailsToTakeAction(string encodedData);

        List<CabRequestBO> GetCabReviewRequest(string UserAbrhs);

        CabRequestResponseBO TakeActionOnCabBulkApprove(string requestIds, string statusCode, string remarks, int loginUserId);

        #endregion

        #region Calendar Data 
        List<WeekOffDateDetailsOnDashboard> GetUsersDashboardCalendarData(string startDate, string endDate, string userAbrhs);

        #endregion

        #region OnshoreManagerMapping
        List<UserOnShoreManagerMapping> FetchUsersOnshoreManagerData(string userAbrhsList);

        List<UserOnShoreManagerMapping> GetUsersToMapOnshoreManager();

        List<UserOnShoreManagerMapping> GetOnshoreManager();

        OnshoreManagerMappingResult AddOrUpdateUsersOnshoreMgr(UserOnShoreManagerMapping MappingData, int loginUserId);

        int CancelOnshorManagerMapping(long mappingId, int loginUserId);

        #endregion

        #region Abroad Users

        List<AbroadUserBO> FetchOnshoreUsers();

        List<AbroadUserBO> FetchOffshoreUsers();

        List<AbroadUserBO> CountryList(string employeeAbrhs);

        List<AbroadUserBO> CompanyLocationListByCountryId(int countryId);

        List<AbroadUserBO> CompanyLocationListByUserId(string employeeAbrhs);

        int ChangeUserLocationAndMapUserOnshore(AbroadUserBO inputs, int loginUserId);

        #endregion
    }
}