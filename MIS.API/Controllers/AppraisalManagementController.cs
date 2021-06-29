using MIS.BO;
using MIS.Services.Contracts;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;

namespace MIS.API.Controllers
{
    public class AppraisalManagementController : BaseApiController
    {
        private readonly IAppraisalServices _appraisalServices;
        //private static RequestBO globalData;
        public AppraisalManagementController(IAppraisalServices appraisalServices)
        {
            _appraisalServices = appraisalServices;
            //var x = HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"];
            //globalData = ((x == null) ? new RequestBO() : (RequestBO)x);
        }

        #region Appraisal Cycle
        [HttpPost]
        public HttpResponseMessage AddAppraisalCycle(AppraisalCycleBO cycle)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.AddAppraisalCycle(cycle));
        }

        [HttpPost]
        public HttpResponseMessage GetAllAppraisalCycles()
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.GetAllAppraisalCycles(globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage UpdateAppraisalCycle(AppraisalCycleBO cycle)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.UpdateAppraisalCycle(cycle));
        }

        [HttpPost]
        public HttpResponseMessage DeleteAppraisalCycle(string AppraisalCycleAbrhs)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.DeleteAppraisalCycle(AppraisalCycleAbrhs, globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetAppraisalCycle(string AppraisalCycleAbrhs)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.GetAppraisalCycle(AppraisalCycleAbrhs, globalData.UserAbrhs));
        }
        #endregion

        #region Parameter

        [HttpPost]
        public HttpResponseMessage SaveParameter(int competencyTypeId, bool isFinalized, string parameterName, int weightage)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.SaveParameter(competencyTypeId, isFinalized, parameterName, weightage, globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetParameterList(int competencyTypeId, int year, int status)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.GetParameterList(competencyTypeId, year, status, globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage UpdateParameter(int parameterId, int competencyTypeId, string parameterName, int weightage)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.UpdateParameter(parameterId, competencyTypeId, parameterName, weightage, globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage ChangeStatus(int parameterId)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.ChangeStatus(parameterId, globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage DeleteParameter(int parameterId)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.DeleteParameter(parameterId, globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage FinalizeParameter(int parameterId)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.FinalizeParameter(parameterId, globalData.UserAbrhs));
        }

        #endregion

        #region Competency Form

        [HttpPost]
        public HttpResponseMessage GetAppraisalFormName(int departmentId, int designationId, string formSufix)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.GetAppraisalFormName(departmentId, designationId, formSufix));
        }

        [HttpPost]
        public HttpResponseMessage AddUpdateCompetencyForm(AddUpdateCompetencyFormBO addUpdateCompetencyFormBO)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            addUpdateCompetencyFormBO.UserAbrhs = globalData.UserAbrhs;
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.AddUpdateCompetencyForm(addUpdateCompetencyFormBO));
        }

        [HttpPost]
        public HttpResponseMessage GetCompetencyFormList(CompetencyFilterBO competencyListBO)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            competencyListBO.UserAbrhs = globalData.UserAbrhs;
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.GetCompetencyFormList(competencyListBO));
        }

        [HttpPost]
        public HttpResponseMessage RetireCompetencyForm(int competencyFormId)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.RetireCompetencyForm(competencyFormId, globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage DeleteCompetencyForm(int competencyFormId)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.DeleteCompetencyForm(competencyFormId, globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetCompetencyFormDataForEdit(int competencyFormId)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.GetCompetencyFormDataForEdit(competencyFormId, globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage CloneCompetencyForm(CloneCompetencyFormBO cloneCompetencyFormBO)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            cloneCompetencyFormBO.UserAbrhs = globalData.UserAbrhs;
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.CloneCompetencyForm(cloneCompetencyFormBO));
        }

        #endregion

        #region Appraisal Settings

        [HttpPost]
        public HttpResponseMessage AddAppraisalSettings(AddAppraisalSettingsBO data)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            data.UserAbrhs = globalData.UserAbrhs;
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.AddAppraisalSettings(data));
        }

        [HttpPost]
        public HttpResponseMessage GetAppraisalSettingList(AppraisalSettingsFilterBO data)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            data.UserAbrhs = globalData.UserAbrhs;
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.GetAppraisalSettingList(data));
        }

        [HttpPost]
        public HttpResponseMessage DeleteAppraisalSetting(int AppraisalSettingId)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.DeleteAppraisalSetting(AppraisalSettingId, globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GenerateAppraisalSettings(GenerateSettingsFilterBO data)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            data.UserAbrhs = globalData.UserAbrhs;
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.GenerateAppraisalSettings(data));
        }

        [HttpPost]
        public HttpResponseMessage UpdateAppraisalSettings(UpdateAppraisalSettingsBO data)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            data.UserAbrhs = globalData.UserAbrhs;
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.UpdateAppraisalSettings(data));
        }

        [HttpPost]
        public HttpResponseMessage GetApproverListByIDs(TeamAppraisalFilterBO data)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            data.UserAbrhs = globalData.UserAbrhs;
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.GetApproverListByIDs(data));
        }

        [HttpPost]
        public HttpResponseMessage GetAppraiserListByIDs(TeamAppraisalFilterBO data)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            data.UserAbrhs = globalData.UserAbrhs;
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.GetAppraiserListByIDs(data));
        }

        #endregion

        #region Goals

        [HttpPost]
        public HttpResponseMessage GetAllSelfGoals(string userAbrhs, int appraisalCycleId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.GetAllSelfGoals(userAbrhs, appraisalCycleId));
        }

        [HttpPost]
        public HttpResponseMessage GetAllEmployeesReportingToUser()
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.GetAllEmployeesReportingToUser(globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage MarkGoalAsAchieved(string userAbrhs, string date, string remarks, long goalId)
        {
            DateTime sdate = Convert.ToDateTime(DateTime.ParseExact(date, "MM/dd/yyyy", CultureInfo.InvariantCulture));
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.MarkGoalAsAchieved(userAbrhs, sdate, remarks, goalId));
        }

        [HttpPost]
        public HttpResponseMessage DeleteGoal(long goalId, string remarks, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.DeleteGoal(goalId, remarks, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage SubmitGoal(string goalIds, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.SubmitGoal(goalIds, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage ApproveGoal(string goalIds, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.ApproveGoal(goalIds, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage AddGoal(AddGoalBO goalDetails)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.AddGoal(goalDetails));
        }

        [HttpPost]
        public HttpResponseMessage DraftGoal(AddGoalBO goalDetails)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.DraftGoal(goalDetails));
        }

        [HttpPost]
        public HttpResponseMessage EditGoal(GoalDetailBO goal)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.EditGoal(goal));
        }

        [HttpPost]
        public HttpResponseMessage FetchGoalDetailById(long goalId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.FetchGoalDetailById(goalId));
        }

        [HttpPost]
        public HttpResponseMessage FetchGoalHistoryById(int goalId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.FetchGoalHistoryById(goalId));
        }

        #region Team Goal
        [HttpPost]
        public HttpResponseMessage MarkTeamGoalAsAchieved(string userAbrhs, string date, string remarks, long goalId)
        {
            DateTime sdate = Convert.ToDateTime(DateTime.ParseExact(date, "MM/dd/yyyy", CultureInfo.InvariantCulture));
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.MarkTeamGoalAsAchieved(userAbrhs, sdate, remarks, goalId));
        }

        [HttpPost]
        public HttpResponseMessage DeleteTeamGoal(long goalId, string remarks, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.DeleteTeamGoal(goalId, remarks, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage AddTeamGoal(AddGoalBO goalDetails)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.AddTeamGoal(goalDetails));
        }

        [HttpPost]
        public HttpResponseMessage GetAllTeamGoals(string teamAbrhs, int appraisalCycleId)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.GetAllTeamGoals(globalData.LoginUserId, teamAbrhs, appraisalCycleId));
        }

        [HttpPost]
        public HttpResponseMessage EditTeamGoal(GoalDetailBO goal)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.EditTeamGoal(goal));
        }

        [HttpPost]
        public HttpResponseMessage FetchTeamGoalDetailById(long goalId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.FetchTeamGoalDetailById(goalId));
        }

        [HttpPost]
        public HttpResponseMessage FetchTeamGoalHistoryById(int goalId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.FetchTeamGoalHistoryById(goalId));
        }

        [HttpPost]
        public HttpResponseMessage ApproveTeamGoal(string goalIds, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.ApproveTeamGoal(goalIds, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage DraftTeamGoal(AddGoalBO goalDetails)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.DraftTeamGoal(goalDetails));
        }
        [HttpPost]
        public HttpResponseMessage SubmitTeamGoal(string goalIds, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.SubmitTeamGoal(goalIds, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetUserPrivilegesToAddTeamGoal(string teamAbrhs)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.GetUserPrivilegesToAddTeamGoal(globalData.LoginUserId, teamAbrhs));
        }

        #endregion

        #endregion

        #region Manage Team Appraisal

        [HttpPost]
        public HttpResponseMessage GetEmpAppraisalSetting(ManageTeamAppraisalFilterBO data)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            data.UserAbrhs = globalData.UserAbrhs;
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.GetEmpAppraisalSetting(data));
        }

        [HttpPost]
        public HttpResponseMessage GetTeamAppraiselEditData(ManageTeamAppraisalFilterBO data)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            data.UserAbrhs = globalData.UserAbrhs;
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.GetTeamAppraiselEditData(data));
        }

        [HttpPost]
        public HttpResponseMessage UpdateAppraisalTeamSettings(UpdateAppraisalTeamSettingsBO data)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            data.UserAbrhs = globalData.UserAbrhs;
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.UpdateAppraisalTeamSettings(data));
        }

        #endregion


        #region Appraisal view by management

        [HttpPost]
        public HttpResponseMessage GetAllEmployeesAppraisal(ManageTeamAppraisalFilterBO data)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            data.UserAbrhs = globalData.UserAbrhs;
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.GetAllEmployeesAppraisal(data));
        }
        #endregion

        #region Appraisal Not Generated

        [HttpPost]
        public HttpResponseMessage GetAppraisalNotGeneratedList(AppraisalSettingsFilterBO data)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            data.UserAbrhs = globalData.UserAbrhs;
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.GetAppraisalNotGeneratedList(data));
        }

        [HttpPost]
        public HttpResponseMessage CreatePendingEmpAppraisalSetting(int EmployeeId, int AppraisalCycleId)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.CreatePendingEmpAppraisalSetting(EmployeeId, AppraisalCycleId, globalData.UserAbrhs));
        }

        #endregion

        #region My Appraisal

        [HttpPost]
        public HttpResponseMessage GetSelfAppraiselData(ManageTeamAppraisalFilterBO data)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            data.UserAbrhs = globalData.UserAbrhs;
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.GetSelfAppraiselData(data));
        }

        [HttpPost]
        public HttpResponseMessage GetStatusHistory(int empAppraisalSettingId)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.GetStatusHistory(empAppraisalSettingId, globalData.UserAbrhs));
        }

        #endregion

        #region Team Appraisal

        [HttpPost]
        public HttpResponseMessage UpdateStatus(int empAppraisalSettingId, int statusId, string resonForDissmiss)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.UpdateStatus(empAppraisalSettingId, statusId, resonForDissmiss, globalData.UserAbrhs));
        }

        #endregion

        #region Appraisal Form

        [HttpPost]
        public HttpResponseMessage GetAppraisalFormData(int empAppraisalSettingId, string digestKey)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.GetAppraisalFormData(empAppraisalSettingId, digestKey, globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetAppraisalFormDataForManagement(int empAppraisalSettingId, string digestKey)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.GetAppraisalFormDataForManagement(empAppraisalSettingId, digestKey, globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetPromotionDesignationsByUserId(int empAppraisalSettingId)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.GetPromotionDesignationsByUserId(empAppraisalSettingId, globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage SaveEmployeeAppraisalForm(AppraisalFormXmlBO appraisalFormData)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            appraisalFormData.UserAbrhs = globalData.UserAbrhs;
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.SaveEmployeeAppraisalForm(appraisalFormData));
        }

        [HttpPost]
        public HttpResponseMessage SaveEmployeeAppraisalGoal(GoalXmlBO goalData)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            goalData.UserAbrhs = globalData.UserAbrhs;
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.SaveEmployeeAppraisalGoal(goalData));
        }

        [HttpPost]
        public HttpResponseMessage SaveEmployeeAppraisalAchievement(AchievementXmlBO achievementData)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            achievementData.UserAbrhs = globalData.UserAbrhs;
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.SaveEmployeeAppraisalAchievement(achievementData));
        }

        [HttpPost]
        public HttpResponseMessage SaveEmployeeAppraisalAchievementBySelf(AchievementXmlBO achievementData)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            achievementData.UserAbrhs = globalData.UserAbrhs;
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.SaveEmployeeAppraisalAchievementBySelf(achievementData));
        }

        [HttpPost]
        public HttpResponseMessage ChangeAppraisalFormStatusToNextLevel(int empAppraisalSettingId)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.ChangeAppraisalFormStatusToNextLevel(empAppraisalSettingId, globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage SaveEmployeeAppraisalPromotion(int empAppraisalSettingId, int recommendationPercentage, bool isPromoted, string promotionRemarks, int promotionDesignationId, bool isHighPotential, string highPotentialRemarks)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.SaveEmployeeAppraisalPromotion(empAppraisalSettingId, recommendationPercentage, isPromoted, promotionRemarks, promotionDesignationId, isHighPotential, highPotentialRemarks, globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage ValidateAndSubmitAppraisalForm(int empAppraisalSettingId)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.ValidateAndSubmitAppraisalForm(empAppraisalSettingId, globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage ReferBackAppraisalForm(int empAppraisalSettingId, string comments)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.ReferBackAppraisalForm(empAppraisalSettingId, comments, globalData.UserAbrhs));
        }

        #region Auto Save Appraisal Data
        [HttpPost]
        public async Task<HttpResponseMessage> SaveEmployeeAppraisalFormAsync(AppraisalFormXmlBO appraisalFormData)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            appraisalFormData.UserAbrhs = globalData.UserAbrhs;
            var task = await Task.Run(() => _appraisalServices.SaveEmployeeAppraisalForm(appraisalFormData));
            return Request.CreateResponse(HttpStatusCode.OK, task);
        }

        [HttpPost]
        public async Task<HttpResponseMessage> SaveEmployeeAppraisalGoalAsync(GoalXmlBO goalData)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            goalData.UserAbrhs = globalData.UserAbrhs;
            var task = await Task.Run(() => _appraisalServices.SaveEmployeeAppraisalGoal(goalData));
            return Request.CreateResponse(HttpStatusCode.OK, task);
        }

        [HttpPost]
        public async Task<HttpResponseMessage> SaveEmployeeAppraisalAchievementBySelfAsync(AchievementXmlBO achievementData)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            achievementData.UserAbrhs = globalData.UserAbrhs;
            var task = await Task.Run(() => _appraisalServices.SaveEmployeeAppraisalAchievementBySelf(achievementData));
            return Request.CreateResponse(HttpStatusCode.OK, task);
        }

        //For Upper level
        [HttpPost]
        public async Task<HttpResponseMessage> SaveEmployeeAppraisalAchievementAsync(AchievementXmlBO achievementData)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            achievementData.UserAbrhs = globalData.UserAbrhs;
            var task = await Task.Run(() => _appraisalServices.SaveEmployeeAppraisalAchievement(achievementData));
            return Request.CreateResponse(HttpStatusCode.OK, task);
        }

        [HttpPost]
        public async Task<HttpResponseMessage> SaveEmployeeAppraisalPromotionAsync(int empAppraisalSettingId, int recommendationPercentage, bool isPromoted, string promotionRemarks, int promotionDesignationId, bool isHighPotential, string highPotentialRemarks)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            var task = await Task.Run(() => _appraisalServices.SaveEmployeeAppraisalPromotion(empAppraisalSettingId, recommendationPercentage, isPromoted, promotionRemarks, promotionDesignationId, isHighPotential, highPotentialRemarks, globalData.UserAbrhs));
            return Request.CreateResponse(HttpStatusCode.OK, task);
        }

        #endregion

        #endregion

        #region Appraisal Report

        [HttpPost]
        public HttpResponseMessage GetAppraisalStatus()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.GetAppraisalStatus());
        }

        [HttpPost]
        public HttpResponseMessage GetEmployeeAppraisalStatusList(int appraisalCycleId, string appraisalStatusIds)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.GetEmployeeAppraisalStatusList(appraisalCycleId, appraisalStatusIds, globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetAppraisalReport(int appraisalCycleId, string appraisalStatusIds)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.GetAppraisalReport(appraisalCycleId, appraisalStatusIds, globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage DownloadAppraisalForm(int empAppraisalSettingId)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.DownloadAppraisalForm(empAppraisalSettingId, globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage SendAppraisalFormOnMail(int empAppraisalSettingId)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.SendAppraisalFormOnMail(empAppraisalSettingId, globalData.UserAbrhs));
        }
        #endregion

        #region My Achievements
        [HttpGet]
        public HttpResponseMessage GetAllMyAchievements()
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.GetAllMyAchievements(globalData.LoginUserId));
        }

        [HttpPost]
        public HttpResponseMessage GetValidityFalgToAddAchievement(int goalCycleId)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.GetValidityFalgToAddAchievement(goalCycleId, globalData.LoginUserId));
        }
        [HttpPost]
        public HttpResponseMessage GetUserMidYearAchievement(int achievementCycleId)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.GetUserMidYearAchievement(achievementCycleId, globalData.LoginUserId));
        }

        [HttpPost]
        public HttpResponseMessage SubmitUserMidYearAchievement(SubmitAchievementBO achievementList)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.SubmitUserMidYearAchievement(achievementList, globalData.LoginUserId));
        }

        [HttpPost]
        public HttpResponseMessage GetTeamsAchievement(int achievementCycleId, string userAbrhs)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.GetTeamsAchievement(achievementCycleId, userAbrhs));
        }
        [HttpPost]
        public HttpResponseMessage getAllGoalCycleIdToViewAchievement(bool forTeam)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.getAllGoalCycleIdToViewAchievement(globalData.LoginUserId, forTeam));
        }


        #endregion

        #region Appraisal 2018

        [HttpPost]
        public HttpResponseMessage AddUpdateTechnicalCompetencyForm(AddUpdateCompetencyFormBO addUpdateCompetencyFormBO)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            addUpdateCompetencyFormBO.UserAbrhs = globalData.UserAbrhs;
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.AddUpdateTechnicalCompetencyForm(addUpdateCompetencyFormBO));
        }

        #endregion

        #region GetFinancialYearForMyGoal
        [HttpPost]
        public HttpResponseMessage GetFinancialYearForMyGoal(string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.GetFinancialYearForMyGoal(userAbrhs));
        }
        #endregion

        #region GetFinancialYearForTeamGoal
        [HttpPost]
        public HttpResponseMessage GetFinancialYearForTeamGoal()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.GetFinancialYearForTeamGoal());
        }
        #endregion

        #region Pimco Achievements

        #region Monthly
        [HttpPost]
        public HttpResponseMessage CheckIfAllowedToFillPimcoMonthlyAchievements(int year, int mNumber, string userAbrhs)
        {
            //var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.CheckIfAllowedToFillPimcoMonthlyAchievements(year, mNumber, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage SubmitUserMonthlyAchievement(SubmitPimcoAchievementBO achievementList)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.SubmitUserMonthlyAchievement(achievementList, globalData.LoginUserId));
        }

        [HttpPost]
        public HttpResponseMessage GetUserMonthlyAchievement(int year, int mNumber)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.GetUserMonthlyAchievement(year, mNumber, globalData.LoginUserId));
        }

        [HttpPost]
        public HttpResponseMessage GetTeamPimcoMonthlyAchievements(int fyYear, string months, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.GetTeamPimcoMonthlyAchievements(fyYear, months, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetPimcoMonthlyAchievementsOfTeamById(int pimcoAchievementId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.GetPimcoMonthlyAchievementsOfTeamById(pimcoAchievementId));
        }

        [HttpPost]
        public HttpResponseMessage GetPimcoProjects(string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.GetPimcoProjects(userAbrhs));
        }

        #endregion

        #region Quarterly
        [HttpPost]
        public HttpResponseMessage CheckIfAllowedToFillPimcoAchievements(int year, int qNumber, string userAbrhs)
        {
            //var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.CheckIfAllowedToFillPimcoAchievements(year, qNumber, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage SubmitUserQuarterlyAchievement(SubmitPimcoAchievementBO achievementList)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.SubmitUserQuarterlyAchievement(achievementList, globalData.LoginUserId));
        }

        [HttpPost]
        public HttpResponseMessage GetUserQuarterlyAchievement(int year, int qNumber)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.GetUserQuarterlyAchievement(year, qNumber, globalData.LoginUserId));
        }

        [HttpPost]
        public HttpResponseMessage GetTeamPimcoAchievements(int fyYear, string quarters, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.GetTeamPimcoAchievements(fyYear, quarters, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetPimcoAchievementsOfTeamById(int pimcoAchievementId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.GetPimcoAchievementsOfTeamById(pimcoAchievementId));
        }

        [HttpPost]
        public HttpResponseMessage SubmitRMComments(string comments, bool toBeDiscussedWithHR, int pimcoAchievementId)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _appraisalServices.SubmitRMComments(comments, toBeDiscussedWithHR, pimcoAchievementId, globalData.UserAbrhs));
        }
        #endregion

        #endregion
    }
}