using MIS.BO;
using MIS.Services.Contracts;
using System;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace MIS.API.Controllers
{
    public class CommonController : BaseApiController
    {
        private readonly ICommonService _commonService;

        public CommonController(ICommonService commonService)
        {
            _commonService = commonService;
        }

        [HttpPost]
        public HttpResponseMessage FetchGoalCategory()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.FetchGoalCategory());
        }

        [HttpPost]
        public HttpResponseMessage FetchTeamsToAddGoals(string type)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.FetchTeamsToAddGoals(globalData.LoginUserId, type));
        }

        [HttpPost]
        public HttpResponseMessage FetchTeamsToReviewGoals()
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.FetchTeamsToReviewGoals(globalData.LoginUserId));
        }



        [HttpPost]
        public HttpResponseMessage GetCountries()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetCountries());
        }

        [HttpPost]
        public HttpResponseMessage GetStates(int countryId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetStates(countryId));
        }

        [HttpPost]
        public HttpResponseMessage GetCities(int stateId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetCities(stateId));
        }

        [HttpPost]
        public HttpResponseMessage GetGender()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetGender());
        }

        [HttpPost]
        public HttpResponseMessage GetMaritalStatus()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetMaritalStatus());
        }

        [HttpPost]
        public HttpResponseMessage GetOccupation()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetOccupation());
        }

        [HttpPost]
        public HttpResponseMessage GetRelationship()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetRelationship());
        }

        [HttpPost]
        public HttpResponseMessage FetchTaskTypes(long teamId)
        {
            var result = _commonService.FetchTaskTypes(teamId);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage FetchTaskTeams()
        {
            var result = _commonService.FetchTaskTeams();
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage FetchSelectedTaskTypeInfo(long taskTypeId)
        {
            var result = _commonService.FetchSelectedTaskTypeInfo(taskTypeId);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage FetchSubDetails1(long taskId)
        {
            var result = _commonService.FetchSubDetails1(taskId);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage FetchSubDetails2(long taskId)
        {
            var result = _commonService.FetchSubDetails2(taskId);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage ListTeamByUserId(string userAbrhs, string menuAbrhs)
        {
            var result = _commonService.ListTeamByUserId(userAbrhs, menuAbrhs);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage ListYears()
        {
            var result = _commonService.ListYears();
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage ListWeeks(int year)
        {
            var result = _commonService.ListWeeks(year);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage GetReportingManagersInADepartment(string departmentIds)
        {
            var result = _commonService.GetReportingManagersInADepartment(departmentIds);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }
        [HttpPost]
        public HttpResponseMessage GetReportingManagersInATeam(string teamIds)
        {
            var result = _commonService.GetReportingManagersInATeam(teamIds);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }
        [HttpPost]
        public HttpResponseMessage GetTeamNames(string departmentIds)
        {
            var result = _commonService.GetTeamNames(departmentIds);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage GetUsersForReports(string date, string departmentId, string reportToAbrhs, string menuAbrhs, string locationIds)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            var result = _commonService.GetUsersForReports(globalData.UserAbrhs, date, departmentId, reportToAbrhs, menuAbrhs, locationIds);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage ListAllActiveUsers()
        {
            var result = _commonService.ListAllActiveUsers();
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage ListAllInActiveUsers()
        {
            var result = _commonService.ListAllInActiveUsers();
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage ListAllReferralReviewers(int detailId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.ListAllReferralReviewers(detailId));
        }

        [HttpPost]
        public HttpResponseMessage ListAllReferralReviewersToFwd()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.ListAllReferralReviewersToFwd());
        }

        [HttpPost]
        public HttpResponseMessage ListAllActiveUsersByDepartment(string departmentAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.ListAllActiveUsersByDepartment(departmentAbrhs));
        }
        [HttpPost]
        public HttpResponseMessage GetProbationPeriodInMonths(string designationAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetProbationPeriodInMonths(designationAbrhs));
        }


        [HttpPost]
        public HttpResponseMessage GetAllReportingManager()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetAllReportingManager());
        }

        [HttpPost]
        public HttpResponseMessage GetRoles()
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            var result = _commonService.GetRoles(globalData.UserAbrhs);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage GetDepartments()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetDepartments());
        }

        [HttpGet]
        public HttpResponseMessage GetActiveEmployees()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetActiveEmployees());
        }


        [HttpPost]
        public HttpResponseMessage GetControllers()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetControllers());
        }

        [HttpPost]
        public HttpResponseMessage GetActiveControllers()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetActiveControllers());
        }
        [HttpPost]
        public HttpResponseMessage GetActionsByControllerId(int controllerId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetActionsByControllerId(controllerId));
        }

        [HttpPost]
        public HttpResponseMessage GetUserMonthYear()
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetUserMonthYear(globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetFinancialYearsForUser()
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetFinancialYearsForUser(globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetFinancialYears()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetFinancialYears());
        }

        [HttpPost]
        public HttpResponseMessage GetQuartersForFY(int year)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetQuartersForFY(year));
        }


        [HttpPost]
        public HttpResponseMessage GetFYMonths(int year)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetFYMonths(year));
        }

        [HttpPost]
        public HttpResponseMessage GetCabRequestMonthYear()
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetCabRequestMonthYear(globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetDesignationGroups(string userAbrhs, bool isOnlyActive = true)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetDesignationGroups(isOnlyActive));
        }


        [HttpPost]
        public HttpResponseMessage GetDesignationsByDesigGrpId(string desigGrpAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetDesignationsByDesigGrpId(desigGrpAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetDesignations(string userAbrhs, string designationGroupAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetDesignations(designationGroupAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage ListSkillLevel()
        {
            var result = _commonService.ListSkillLevel();
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage ListSkill()
        {
            var result = _commonService.ListSkill();
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage ListSkillTypesForUser()
        {
            var result = _commonService.ListSkillTypesForUser();
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage ListSkillTypesForHR()
        {
            var result = _commonService.ListSkillTypesForHR();
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage GetUserDetailsByUserId(string userAbrhs)
        {
            var result = _commonService.GetUserDetailsByUserId(userAbrhs);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }
        [HttpPost]
        public HttpResponseMessage GetEmployeesReportingToUserByManagerId(string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetEmployeesReportingToUserByManagerId(userAbrhs));
        }

        #region Meal Management

        [HttpPost]
        public HttpResponseMessage GetMealCategory()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetMealCategory());
        }

        [HttpPost]
        public HttpResponseMessage GetMealPeriod()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetMealPeriod());
        }

        [HttpPost]
        public HttpResponseMessage GetMealType()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetMealType());
        }

        [HttpPost]
        public HttpResponseMessage GetMealDishes()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetMealDishes());
        }

        [HttpPost]
        public HttpResponseMessage GetMealPackages()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetMealPackages());
        }

        #endregion

        [HttpPost]
        public HttpResponseMessage GetWeekDays()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetWeekDays());
        }

        [HttpPost]
        public HttpResponseMessage GetTeams()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetTeams());
        }

        [HttpPost]
        public HttpResponseMessage GetTeamsByDepartmentId(string departmentAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetTeamsByDepartmentId(departmentAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetTeamEmailTypes()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetTeamEmailTypes());
        }

        [HttpPost]
        public HttpResponseMessage GetAllDepartments()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetAllDepartments());
        }

        [HttpPost]
        public HttpResponseMessage GetAssetTypes()
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();

            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetAssetTypes(globalData.LoginUserId));
        }

        [HttpPost]
        public HttpResponseMessage GetAssetModels(int assetTypeId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetAssetModels(assetTypeId));
        }

        [HttpPost]
        public HttpResponseMessage FetchWeekInfoByDateId(string userAbrhs, int dateId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.FetchWeekInfoByDateId(userAbrhs, dateId));
        }
        [HttpPost]
        public HttpResponseMessage GetTeamRoles()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetTeamRoles());
        }

        [HttpPost]
        public HttpResponseMessage GetFeedbackType()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetFeedbackType());
        }

        #region Appraisal Common

        [HttpPost]
        public HttpResponseMessage GetCompanyLocation()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetCompanyLocation());
        }

        [HttpPost]
        public HttpResponseMessage GetVertical()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetVertical());
        }

        [HttpPost]
        public HttpResponseMessage GetDivisionByVertical(int verticalId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetDivisionByVertical(verticalId));
        }

        [HttpPost]
        public HttpResponseMessage GetDepartmentByDivision(string divisionIds)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetDepartmentByDivision(divisionIds));
        }

        [HttpPost]
        public HttpResponseMessage GetTeamsByDepartment(string departmentIds)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetTeamsByDepartment(departmentIds));
        }

        [HttpPost]
        public HttpResponseMessage GetDesignationsByTeams(string teamIds)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetDesignationsByTeams(teamIds));
        }

        [HttpPost]
        public HttpResponseMessage GetDesignationsByDepartments(string departments)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetDesignationsByDepartments(departments));
        }

        [HttpPost]
        public HttpResponseMessage GetAppraisalCycle()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetAppraisalCycle());
        }

        [HttpPost]
        public HttpResponseMessage GetStageMaster()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetStageMaster());
        }

        [HttpPost]
        public HttpResponseMessage GetCompetency()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetCompetency());
        }

        [HttpPost]
        public HttpResponseMessage GetParameter(int competencyId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetParameter(competencyId));
        }

        [HttpPost]
        public HttpResponseMessage GetAppraisalParametersYears()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetAppraisalParametersYears());
        }

        [HttpPost]
        public HttpResponseMessage GetCompetencyList(int feedbackTypeId, int locationId, int verticalId, int divisionId, int departmentId, int designationId, int competencyFormId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetCompetencyList(feedbackTypeId, locationId, verticalId, divisionId, departmentId, designationId, competencyFormId));
        }

        #endregion

        [HttpPost]
        public HttpResponseMessage GetAllEmployeesReportingToUser()
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetAllEmployeesReportingToUser(globalData.UserAbrhs));
        }
        [HttpPost]
        public HttpResponseMessage GetPermissionToViewAttendance()
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetPermissionToViewAttendance(globalData.LoginUserId));
        }
        #region goal
        [HttpPost]
        public HttpResponseMessage GetStatusForGoal()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetStatusForGoal());
        }
        [HttpPost]
        public HttpResponseMessage GetStatusForGoalsReport()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetStatusForGoalsReport());
        }
        #endregion
        #region Invoice
        [HttpPost]
        public HttpResponseMessage GetAllClients()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetAllClients());
        }
        #endregion
        #region VMS
        [HttpPost]
        public HttpResponseMessage GetAllTempCards()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.GetAllTempCards());
        }
        #endregion
    }
}
