using System.Collections.Generic;
using MIS.BO;
using System;

namespace MIS.Services.Contracts
{
    public interface IAppraisalServices
    {
        #region Appraisal Cycle

        int AddAppraisalCycle(AppraisalCycleBO cycle);
        List<AppraisalCycleList> GetAllAppraisalCycles(string userAbrhs);
        int UpdateAppraisalCycle(AppraisalCycleBO cycle);
        int DeleteAppraisalCycle(string appraisalCycleAbrhs, string userAbrhs);
        AppraisalCycleBO GetAppraisalCycle(string AppraisalCycleAbrhs, string userAbrhs);

        #endregion

        #region Parameter

        int SaveParameter(int competencyTypeId, bool isFinalized, string parameterName, int weightage, string userAbrhs);

        List<AppraisalParameterBO> GetParameterList(int competencyTypeId, int year, int status, string userAbrhs);

        int UpdateParameter(int parameterId, int competencyTypeId, string parameterName, int weightage, string userAbrhs);

        int ChangeStatus(int parameterId, string userAbrhs);

        int DeleteParameter(int parameterId, string userAbrhs);

        int FinalizeParameter(int parameterId, string userAbrhs);

        #endregion

        #region Competency Form

        string GetAppraisalFormName(int departmentId, int designationId, string formSufix);

        AddUpdateReturnBO AddUpdateCompetencyForm(AddUpdateCompetencyFormBO addUpdateCompetencyFormBO);

        List<CompetencyFormListBO> GetCompetencyFormList(CompetencyFilterBO competencyListBO);

        int RetireCompetencyForm(int competencyFormId, string userAbrhs);

        int DeleteCompetencyForm(int competencyFormId, string userAbrhs);

        CompetencyFormForEditBO GetCompetencyFormDataForEdit(int competencyFormId, string userAbrhs);

        AddUpdateReturnBO CloneCompetencyForm(CloneCompetencyFormBO cloneCompetencyFormBO);

        #endregion

        #region Appraisal Settings 

        AddUpdateReturnBO AddAppraisalSettings(AddAppraisalSettingsBO data);

        List<GetAppraisalSettingsBO> GetAppraisalSettingList(AppraisalSettingsFilterBO data);

        int DeleteAppraisalSetting(int AppraisalSettingId, string userAbrhs);

        AddUpdateReturnBO GenerateAppraisalSettings(GenerateSettingsFilterBO data);

        AddUpdateReturnBO UpdateAppraisalSettings(UpdateAppraisalSettingsBO data);

        List<BaseDropDown> GetApproverListByIDs(TeamAppraisalFilterBO data);

        List<BaseDropDown> GetAppraiserListByIDs(TeamAppraisalFilterBO data);

        #endregion

        #region Goals

        List<GoalDetailBO> GetAllSelfGoals(string userAbrhs, int appraisalCycleId);

        int MarkGoalAsAchieved(string userAbrhs, DateTime date, string remarks, long goalId);

        bool DeleteGoal(long goalId, string remarks, string userAbrhs);

        int ApproveGoal(string goalIds, string userAbrhs);

        bool AddGoal(AddGoalBO goalDetails);

        bool SubmitGoal(string goalIds, string userAbrhs);

        bool DraftGoal(AddGoalBO goalDetails);

        bool EditGoal(GoalDetailBO goal);

        GoalDetailBO FetchGoalDetailById(long goalId);

        List<GoalDetailBO> FetchGoalHistoryById(int goalId);

        List<EmployeeBO> GetAllEmployeesReportingToUser(string userAbrhs);

        #region Team Goal
        List<GoalDetailBO> GetAllTeamGoals(int userId, string teamAbrhs, int appraisalCycleId);

        int MarkTeamGoalAsAchieved(string teamAbrhs, DateTime date, string remarks, long goalId);

        bool DeleteTeamGoal(long goalId, string remarks, string userAbrhs);

        int ApproveTeamGoal(string goalIds, string userAbrhs);

        bool AddTeamGoal(AddGoalBO goalDetails);

        bool SubmitTeamGoal(string goalIds, string userAbrhs);

        bool GetUserPrivilegesToAddTeamGoal(int userId, string teamAbrhs);

        int DraftTeamGoal(AddGoalBO goalDetails);

        int EditTeamGoal(GoalDetailBO goal);

        GoalDetailBO FetchTeamGoalDetailById(long goalId);

        List<GoalDetailBO> FetchTeamGoalHistoryById(int goalId);
      
        #endregion

        #endregion

        #region Manage Team Appraisal

        List<ManageTeamAppraisalBO> GetEmpAppraisalSetting(ManageTeamAppraisalFilterBO data);

        List<ManageTeamAppraisalBO> GetTeamAppraiselEditData(ManageTeamAppraisalFilterBO data);

        AddUpdateReturnBO UpdateAppraisalTeamSettings(UpdateAppraisalTeamSettingsBO data);

        AppraisalFormBO GetAppraisalFormDataForManagement(int empAppraisalSettingId, string digestKey, string userAbrhs);

        #endregion

        #region Appraisal view by management
        List<ManageTeamAppraisalBO> GetAllEmployeesAppraisal(ManageTeamAppraisalFilterBO data);
        #endregion

        #region Appraisal Not Generated

        List<AppraisalNotGeneratedList> GetAppraisalNotGeneratedList(AppraisalSettingsFilterBO data);

        int CreatePendingEmpAppraisalSetting(int? EmployeeId, int? AppraisalCycleId, string UserAbrhs);

        #endregion

        #region My Apprailsal

        List<ManageTeamAppraisalBO> GetSelfAppraiselData(ManageTeamAppraisalFilterBO data);

        List<AppraisalLogModal> GetStatusHistory(int? empAppraisalSettingId, string userAbrhs);

        AddUpdateReturnBO UpdateStatus(int empAppraisalSettingId, int statusId, string resonForDissmiss, string userAbrhs);

        #endregion

        #region Appraisal Form

        AppraisalFormBO GetAppraisalFormData(int empAppraisalSettingId, string digestKey, string userAbrhs);

        List<BaseDropDown> GetPromotionDesignationsByUserId(int empAppraisalSettingId, string userAbrhs);

        AppraisalFormReturnBO SaveEmployeeAppraisalForm(AppraisalFormXmlBO appraisalFormData);

        int SaveEmployeeAppraisalGoal(GoalXmlBO goalData);

        int SaveEmployeeAppraisalAchievement(AchievementXmlBO achievementData);

        List<AchievementCommentBO> SaveEmployeeAppraisalAchievementBySelf(AchievementXmlBO achievementData);

        int ChangeAppraisalFormStatusToNextLevel(int empAppraisalSettingId, string userAbrhs);

        int SaveEmployeeAppraisalPromotion(int empAppraisalSettingId, int recommendationPercentage, bool isPromoted, string promotionRemarks
                                                  , int promotionDesignationId, bool isHighPotential, string highPotentialRemarks, string userAbrhs);

        ValidateAndSubmitAppraisalFormBO ValidateAndSubmitAppraisalForm(int empAppraisalSettingId, string userAbrhs);

        bool ReferBackAppraisalForm(int empAppraisalSettingId, string comments, string userAbrhs);

        #endregion     

        #region Appraisal Report

        List<BaseDropDown> GetAppraisalStatus();

        List<EmployeeAppraisalStatus> GetEmployeeAppraisalStatusList(int appraisalCycleId, string appraisalStatusIds, string userAbrhs);

        List<AppraisalReportBO> GetAppraisalReport(int appraisalCycleId, string appraisalStatusIds, string userAbrhs);

        int DownloadAppraisalForm(int empAppraisalSettingId, string userAbrhs);

        int SendAppraisalFormOnMail(int empAppraisalSettingId, string userAbrhs);

        #endregion

        #region My Achievements

        List<UserRegularAchievementBO> GetAllMyAchievements(int loginUserId);

        int SubmitUserMidYearAchievement(SubmitAchievementBO achievement, int loginUserId);

        bool GetValidityFalgToAddAchievement(int goalCycleId, int userId);

        List<UserMidYearAchievementDataBO> GetUserMidYearAchievement(int achievementCycleId, int UserId);

        List<UserMidYearAchievementDataBO> GetTeamsAchievement(int achievementCycleId, string userAbrhs);

        List<AppraisalCycleIdForAchievementBO> getAllGoalCycleIdToViewAchievement(int userId, bool forTeam);


        #endregion

        #region Appraisal 2018

        AddUpdateReturnBO AddUpdateTechnicalCompetencyForm(AddUpdateCompetencyFormBO addUpdateCompetencyFormBO);

        #endregion

        #region BindFinancialYearForGoal
        List<AppraisalGoalYearBO> GetFinancialYearForMyGoal(string userAbrhs);
        #endregion

        #region BindFinancialYearForTeamGoal
        List<AppraisalGoalYearBO> GetFinancialYearForTeamGoal();
        #endregion

        #region Pimco Achievements

        #region Monthly
        int CheckIfAllowedToFillPimcoMonthlyAchievements(int year, int mNumber, string userAbrhs);

        int SubmitUserMonthlyAchievement(SubmitPimcoAchievementBO achievement, int loginUserId);

        List<UserQuarterlyPimcoAchievementBO> GetUserMonthlyAchievement(int year, int mNumber, int loginUserId);

        List<UserQuarterlyPimcoAchievementBO> GetTeamPimcoMonthlyAchievements(int fyYear, string months, string userAbrhs);

        List<PimcoAchievementDetailBO> GetPimcoMonthlyAchievementsOfTeamById(int pimcoAchievementId);

        List<PimcoProjectBO> GetPimcoProjects(string userAbrhs);

        
        #endregion

        #region Quarterly
        int CheckIfAllowedToFillPimcoAchievements(int year, int qNumber, string userAbrhs);

        int SubmitUserQuarterlyAchievement(SubmitPimcoAchievementBO achievement, int loginUserId);

        List<UserQuarterlyPimcoAchievementBO> GetUserQuarterlyAchievement(int year, int qNumber, int loginUserId);

        List<UserQuarterlyPimcoAchievementBO> GetTeamPimcoAchievements(int fyYear, string quarters, string userAbrhs);

        List<PimcoAchievementDetailBO> GetPimcoAchievementsOfTeamById(int pimcoAchievementId);

        int SubmitRMComments(string comments, bool toBeDiscussedWithHR, int pimcoAchievementId, string userAbrhs);
        #endregion

        #endregion
    }
}