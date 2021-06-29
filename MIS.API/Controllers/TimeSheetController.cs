using MIS.BO;
using MIS.Services.Contracts;
using System;
using System.Globalization;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace MIS.API.Controllers
{
    public class TimeSheetController : BaseApiController
    {
        private readonly ITimeSheetService _timeSheetServices;

        public TimeSheetController(ITimeSheetService timeSheetServices)
        {
            _timeSheetServices = timeSheetServices;
        }

        [HttpPost]
        public HttpResponseMessage FetchProjectsAssignedToUser(string userAbrhs)
        {
            var result = _timeSheetServices.FetchProjectsAssignedToUser(userAbrhs);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage SaveProjectPrefrences(string selectedProjects, string userAbrhs)
        {
            var result = _timeSheetServices.SavePrefrences(selectedProjects, userAbrhs);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        #region manage Task Templates

        [HttpPost]
        public HttpResponseMessage FetchTemplatesForUser(string userAbrhs)
        {
            var result = _timeSheetServices.FetchTemplatesAssociatedWithUser(userAbrhs);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage SaveTaskTemplate(BO.TaskTemplate taskTemplate)
        {
            string userAbrhs = taskTemplate.userAbrhs;
            var result = _timeSheetServices.SaveTaskTemplate(taskTemplate, userAbrhs);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage DeleteTaskTemplate(long templateId, string userAbrhs)
        {
            var result = _timeSheetServices.DeleteTaskTemplate(templateId, userAbrhs);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage FetchSelectedTemplateInfo(long templateId)
        {
            var result = _timeSheetServices.FetchSelectedTemplateInfo(templateId);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage UpdateTaskTemplate(BO.TaskTemplate taskTemplate)
        {
            string userAbrhs = taskTemplate.userAbrhs;
            var result = _timeSheetServices.UpdateTaskTemplate(taskTemplate, userAbrhs);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        #endregion

        #region Create TimeSheet

        [HttpPost]
        public HttpResponseMessage FetchWeekInfo(string userAbrhs, int changeWeek)
        {
            var result = _timeSheetServices.FetchWeekInfo(userAbrhs, changeWeek);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage FetchTimeSheetInfo(int weekNo, string startDate, string userAbrhs)
        {
            var result = _timeSheetServices.FetchTimeSheetInfo(weekNo, startDate, userAbrhs);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage FetchTimeSheetInfoOtherUser(int weekNo, int year, int userId)
        {
            var result = _timeSheetServices.FetchTimeSheetInfoOtherUser(weekNo, year, userId);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage FetchProjectsForTimeSheet(int weekNo, string startDate, string userAbrhs)
        {
            var result = _timeSheetServices.FetchProjectsForTimeSheet(weekNo, startDate, userAbrhs);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage FetchProjectsForTimeSheetOtherUser(int weekNo, int year, int userId)
        {
            var result = _timeSheetServices.FetchProjectsForTimeSheetOtherUser(weekNo, year, userId);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage FetchTasksLoggedForTimeSheet(int weekNo, string startDate, string userAbrhs)
        {
            var result = _timeSheetServices.FetchTasksLoggedForTimeSheet(weekNo, startDate, userAbrhs);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage FetchTasksLoggedForTimeSheetOtherUser(int weekNo, string startDate, int userId)
        {
            var result = _timeSheetServices.FetchTasksLoggedForTimeSheetOtherUser(weekNo, startDate, userId);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage FetchTasksLoggedForProject(string date, long projectId, long timeSheetId)
        {
            var dateNew = Convert.ToDateTime(DateTime.ParseExact(date, "MM/dd/yyyy", CultureInfo.InvariantCulture));
            var result = _timeSheetServices.FetchTasksLoggedForProject(dateNew, projectId, timeSheetId);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage FetchSelectedTaskInfo(long taskId)
        {
            var result = _timeSheetServices.FetchSelectedTaskInfo(taskId);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }


        [HttpPost]
        public HttpResponseMessage LogTask(TimeSheetTask timeSheetTask)
        {
            if (timeSheetTask.userAbrhs == null)
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest, false);
            }
            var timeSheet = new MIS.BO.TimeSheet
            {
                userAbrhs = timeSheetTask.userAbrhs,
                //CreatedBy = CurrentUser.UserId,
                CreatedDate = DateTime.UtcNow,
                Status = 0,
                WeekNo = timeSheetTask.weekNo,
                //Year = Convert.ToDateTime(startDate).Year,
                Year = Convert.ToDateTime(DateTime.ParseExact(timeSheetTask.endDate, "MM/dd/yyyy", CultureInfo.InvariantCulture)).Year,
                StartDate = Convert.ToDateTime(DateTime.ParseExact(timeSheetTask.startDate, "MM/dd/yyyy", CultureInfo.InvariantCulture))
            };
            var result = 0;
            if (timeSheetTask.TaskList.Count>0)
            {
                foreach (var item in timeSheetTask.TaskList)
                {
                    var loggedTask = new MIS.BO.LoggedTask
                    {
                        Date = Convert.ToDateTime(DateTime.ParseExact(item.taskDate, "MM/dd/yyyy", CultureInfo.InvariantCulture)),
                        ProjectId = timeSheetTask.projectId,
                        Description = item.description,
                        TaskTeamId = item.taskTeamId,
                        TaskTypeId = item.taskTypeId,
                        TaskSubDetail1Id = item.taskSubDetail1Id == 0 ? 1 : item.taskSubDetail1Id,
                        TaskSubDetail2Id = item.taskSubDetail2Id == 0 ? 1 : item.taskSubDetail2Id,
                        TimeSpent = item.timeSpent,
                        IsActive = true,
                        IsDeleted = false,
                        CreatedDate = DateTime.UtcNow,
                        userAbrhs = timeSheetTask.userAbrhs
                    };
                    result = _timeSheetServices.LogTask(timeSheet, loggedTask);
                }
            }
            
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage LogTaskOtherUser(TimeSheetTaskOtherUser timeSheetTaskOtherUser)
        {
            if (timeSheetTaskOtherUser.userAbrhs == null)
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest, false);
            }
            var timeSheet = new MIS.BO.TimeSheet
            {
                userAbrhs = timeSheetTaskOtherUser.userAbrhs,
                CreatedBy = timeSheetTaskOtherUser.UserId,
                CreatedDate = DateTime.UtcNow,
                Status = 1,
                WeekNo = timeSheetTaskOtherUser.weekNo,
                Year = Convert.ToDateTime(DateTime.ParseExact(timeSheetTaskOtherUser.endDate, "MM/dd/yyyy", CultureInfo.InvariantCulture)).Year,
                StartDate = Convert.ToDateTime(DateTime.ParseExact(timeSheetTaskOtherUser.startDate, "MM/dd/yyyy", CultureInfo.InvariantCulture))
            };
            var result = 0;
            if (timeSheetTaskOtherUser.TaskList.Count > 0)
            {
                foreach (var item in timeSheetTaskOtherUser.TaskList)
                {
                    var loggedTask = new MIS.BO.LoggedTask
                    {
                        Date = Convert.ToDateTime(DateTime.ParseExact(item.taskDate, "MM/dd/yyyy", CultureInfo.InvariantCulture)),
                        ProjectId = timeSheetTaskOtherUser.projectId,
                        Description = item.description,
                        TaskTeamId = item.taskTeamId,
                        TaskTypeId = item.taskTypeId,
                        TaskSubDetail1Id = item.taskSubDetail1Id == 0 ? 1 : item.taskSubDetail1Id,
                        TaskSubDetail2Id = item.taskSubDetail2Id == 0 ? 1 : item.taskSubDetail2Id,
                        TimeSpent = item.timeSpent,
                        IsActive = true,
                        IsDeleted = false,
                        LastModifiedDate = DateTime.UtcNow,
                        CreatedDate = DateTime.UtcNow,
                        userAbrhs = timeSheetTaskOtherUser.userAbrhs
                    };
                    result = _timeSheetServices.LogTask(timeSheet, loggedTask);
                }
            }

            return Request.CreateResponse(HttpStatusCode.OK, result);
        }


        [HttpPost]
        public HttpResponseMessage UpdateLoggedTask(long timeSheetId, BO.LoggedTask loggedTask)
        {
            var result = _timeSheetServices.UpdateLoggedTask(timeSheetId, loggedTask);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage DeleteLoggedTask(long taskId, string userAbrhs)
        {
            var result = _timeSheetServices.DeleteLoggedTask(taskId, userAbrhs);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage SubmitWeeklyTimeSheet(BO.TimeSheet timeSheet)
        {
            string userAbrhs = timeSheet.userAbrhs;
            var result = _timeSheetServices.SubmitWeeklyTimeSheet(timeSheet, userAbrhs);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage CopyTimeSheetFromWeek(int year, int fromWeek, int toWeek, string startDate, string endDate, string userAbrhs)
        {
            var result = _timeSheetServices.CopyTimeSheetFromWeek(year, fromWeek, toWeek, startDate, endDate, userAbrhs);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        #endregion

        [HttpPost]
        public HttpResponseMessage ListWeeksForCopyTimeSheet(int year, int week, string userAbrhs)
        {
            var result = _timeSheetServices.ListWeeksForCopyTimeSheet(year, week, userAbrhs);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        #region Reports

        [HttpPost]
        public HttpResponseMessage GenerateTimesheetReport(string team, int year, int week, string userAbrhs)
        {
            var result = _timeSheetServices.GenerateTimesheetReport(team, year, week, userAbrhs);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        #endregion

        #region TimeSheet DashBoard

        [HttpPost]
        public HttpResponseMessage FetchPendingTimeSheets(int weekNo, int year, string userAbrhs, string menuAbrhs)
        {
            var result = _timeSheetServices.FetchPendingTimeSheets(weekNo, year, userAbrhs, menuAbrhs);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage FetchCompletedTimeSheets(int weekNo, int year, string userAbrhs, string menuAbrhs)
        {
            var result = _timeSheetServices.FetchCompletedTimeSheets(weekNo, year, userAbrhs, menuAbrhs);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        #endregion

        #region TimeSheet DataVerification

        [HttpPost]
        public HttpResponseMessage ListApprovedTasks(int weekNo, int year, string userAbrhs, string menuAbrhs)
        {
            var result = _timeSheetServices.ListApprovedTasks(weekNo, year, userAbrhs, menuAbrhs);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage FetchApprovedTaskInfo(long mappingId)
        {
            var result = _timeSheetServices.FetchApprovedTaskInfo(mappingId);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage ListAllProjects()
        {
            var result = _timeSheetServices.ListAllProjects();
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage ChangeTaskStatus(long mappingId)
        {
            var result = _timeSheetServices.ChangeTaskStatus(mappingId);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage OverwriteLoggedTask(BO.FinalLoggedTask finalLoggedTask)
        {
            var result = _timeSheetServices.OverwriteLoggedTask(finalLoggedTask);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        #endregion

        #region Review TimeSheet

        [HttpPost]
        public HttpResponseMessage FetchTimeSheetPendingforApproval(string userAbrhs, string menuAbrhs)
        {
            var result = _timeSheetServices.FetchTimeSheetPendingforApproval(userAbrhs, menuAbrhs);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage FetchTimeSheetsApproved(int years,string weekNos,string reportingUserIds, string userAbrhs, string menuAbrhs)
        {
            var result = _timeSheetServices.FetchTimeSheetsApproved(years,weekNos,reportingUserIds, userAbrhs, menuAbrhs);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage ApproveTimeSheet(long timeSheetId, string remarks, string userAbrhs)
        {
            var result = _timeSheetServices.ApproveTimeSheet(timeSheetId, remarks, userAbrhs);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage RejectTimeSheet(long timeSheetId, string remarks, string userAbrhs)
        {
            var result = _timeSheetServices.RejectTimeSheet(timeSheetId, remarks, userAbrhs);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage FetchTemplatesForOtherUser(int userId)
        {
            var result = _timeSheetServices.FetchTemplatesForOtherUser(userId);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage GetTimeSheetInfoForAllSelectedUsers(string timeSheetIds)
        {
            var result = _timeSheetServices.GetTimeSheetInfoForAllSelectedUsers(timeSheetIds);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }


        [HttpPost]
        public HttpResponseMessage FetchWeekNoAndDates(string userAbrhs, string year)
        {
            var result = _timeSheetServices.FetchWeekNoAndDates(userAbrhs, year);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }
        #endregion

        #region timesheet subscription
        [HttpPost]
        public HttpResponseMessage ListEligibleUsersForTimesheeet()
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _timeSheetServices.ListEligibleUsersForTimesheeet(globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage ListExcludedUsersForTimesheeet()
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _timeSheetServices.ListExcludedUsersForTimesheeet(globalData.UserAbrhs));
        }
        [HttpPost]
        public HttpResponseMessage ExcludeUserForTimesheet(string employeeAbrhs)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _timeSheetServices.ExcludeUserForTimesheet(employeeAbrhs,globalData.UserAbrhs));
        }
        [HttpPost]
        public HttpResponseMessage ChangeUserToEligibleForTimesheet(string employeeAbrhs)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _timeSheetServices.ChangeUserToEligibleForTimesheet(employeeAbrhs,globalData.UserAbrhs));
        }
        #endregion
    }
}