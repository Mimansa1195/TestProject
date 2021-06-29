using MIS.BO;
using System;
using System.Collections.Generic;

namespace MIS.Services.Contracts
{
    public interface ICommonService
    {
        List<BaseDropDown> FetchGoalCategory();
        List<BaseDropDown> FetchTeamsToAddGoals(int userId, string type);
        List<BaseDropDown> FetchTeamsToReviewGoals(int userId);
        List<BaseDropDown> FetchTaskTypes(long teamId);
        List<BaseDropDown> FetchTaskTeams();
        BO.TaskType FetchSelectedTaskTypeInfo(long taskTypeId);

        List<BO.TaskSubDetail1> FetchSubDetails1(long taskId);

        List<BO.TaskSubDetail2> FetchSubDetails2(long taskId);

        List<BaseDropDown> ListTeamByUserId(string userAbrhs, string menuAbrhs);

        List<BaseDropDown> GetFeedbackType();

        List<BaseDropDown> GetCountries();

        List<BaseDropDown> GetStates(int countryId);

        List<BaseDropDown> GetCities(int stateId);

        List<BaseDropDown> GetGender();

        IList<EmployeeBO> GetActiveEmployees();

        List<BaseDropDown> GetMaritalStatus();

        List<BaseDropDown> GetOccupation();

        List<BaseDropDown> GetRelationship();

        List<int> ListYears();

        List<int> ListWeeks(int year);

        List<EmployeeBO> ListAllActiveUsers();

        List<EmployeeBO> ListAllInActiveUsers();

        List<EmployeeBO> ListAllReferralReviewers(int detailId);

        List<EmployeeBO> ListAllReferralReviewersToFwd();

        List<EmployeeBO> ListAllActiveUsersByDepartment(string departmentAbrhs);

        int GetProbationPeriodInMonths(string designationAbrhs);

        List<EmployeeBO> GetAllReportingManager();

        List<RoleBO> GetRoles(string userAbrhs);

        List<DepartmentBO> GetDepartments();
        List<ControllerBO> GetControllers();

        List<ControllerBO> GetActiveControllers();

        List<ControllerBO> GetActionsByControllerId(int controllerId);
        List<BaseDropDown> GetUserMonthYear(string UserAbrhs);

        List<FYDropDown> GetFinancialYearsForUser(string UserAbrhs);

        List<FYDropDown> GetFinancialYears();

        List<FYDropDown> GetQuartersForFY(int year);

        List<FYDropDown> GetFYMonths(int year);

        List<CommonEntitiesBO> GetDesignationGroups(bool isOnlyActive = true);

        List<BaseDropDown> GetCabRequestMonthYear(string UserAbrhs);

        List<DesignationByDesigGrpId> GetDesignationsByDesigGrpId(string desigGrpAbrhs);

        List<DesignationBO> GetDesignations(string designationGroupAbrhs);

        bool LogUserActivity(int userId, string userName, string browserInfo, string clientInfo, string activityStatus, string activityDetail);

        List<UserInADepartment> GetReportingManagersInADepartment(string departmentIds);
        List<UserInADepartment> GetReportingManagersInATeam(string teamIds);


        List<Teams> GetTeamNames(string departmentIds);
        EmployeeInfoForReports GetUsersForReports(string userAbrhs, string date, string departmentId, string reportToAbrhs, string menuAbrhs, string locationIds);

        List<AppraisalStagesBaseDropDown> ListSkillLevel();

        List<BaseDropDown> ListSkill();

        List<BaseDropDown> ListSkillTypesForUser();

        List<BaseDropDown> ListSkillTypesForHR();

        UserDetailProfile GetUserDetailsByUserId(string userAbrhs);

        List<EmployeeBO> GetEmployeesReportingToUserByManagerId(string userAbrhs);

        #region Meal Management

        List<BaseDropDown> GetMealCategory();

        List<BaseDropDown> GetMealPeriod();

        List<BaseDropDown> GetMealType();

        List<BaseDropDown> GetMealDishes();

        List<BaseDropDown> GetMealPackages();

        #endregion

        #region Error Log
        Int64 LogError(Exception ex, string controllerName, string actionName, int loginUserId, string authToken);
        Int64 LogError(Exception ex, int loginUserId, string authToken);
        Int64 LogError(Exception ex);
        #endregion

        /// <summary>
        /// Method to fetch team roles
        /// </summary>
        /// <returns>List of team roles</returns>
        List<RoleBO> GetTeamRoles();

        List<BaseDropDown> GetWeekDays();

        List<BaseDropDown> GetTeams();

        List<BaseDropDown> GetTeamsByDepartmentId(string departmentAbrhs);

        List<BaseDropDown> GetTeamEmailTypes();

        List<BaseDropDown> GetAllDepartments();

        List<BaseDropDown> GetAssetTypes(int loginUserId);

        List<BaseDropDown> GetAssetModels(int assetTypeId);

        WeekAndDatesBO FetchWeekInfoByDateId(string userAbrhs, int dateId);

        #region Appraisal Common

        List<BaseDropDown> GetCompanyLocation();

        List<BaseDropDown> GetVertical();

        List<BaseDropDown> GetDivisionByVertical(int verticalId);

        List<BaseDropDown> GetDepartmentByDivision(string divisionIds);

        List<BaseDropDown> GetTeamsByDepartment(string departmentIds);

        List<BaseDropDown> GetDesignationsByTeams(string teamIds);

        List<BaseDropDown> GetDesignationsByDepartments(string departments);

        List<BaseDropDown> GetAppraisalCycle();

        List<AppraisalStagesBaseDropDown> GetStageMaster();

        List<BaseDropDown> GetCompetency();

        List<BaseDropDown> GetParameter(int competencyId);

        List<BaseDropDown> GetAppraisalParametersYears();

        List<BaseDropDown> GetCompetencyList(int feedbackTypeId, int locationId, int verticalId, int divisionId, int departmentId, int designationId, int competencyFormId);

        #endregion

        List<EmployeeBO> GetAllEmployeesReportingToUser(string userAbrhs);

        bool GetPermissionToViewAttendance(int userId);

        #region goal

        List<BaseDropDown> GetStatusForGoal();

        List<BaseDropDown> GetStatusForGoalsReport();

        #endregion
        #region
        List<BaseDropDown> GetAllClients();
        #endregion
        #region VMS
        List<BaseDropDown> GetAllTempCards();
        #endregion
    }
}
