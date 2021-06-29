using MIS.BO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MIS.Services.Contracts
{
    public interface ITimeSheetService
    {
        List<MyAssignedProjects> FetchProjectsAssignedToUser(string userAbrhs);

        bool SavePrefrences(string selectedProjects, string userAbrhs);

        List<TaskTemplateInfo> FetchTemplatesAssociatedWithUser(string userAbrhs);

        int SaveTaskTemplate(BO.TaskTemplate taskTemplate, string userAbrhs);

        bool DeleteTaskTemplate(long templateId, string userAbrhs);

        BO.TaskTemplate FetchSelectedTemplateInfo(long templateId);

        int UpdateTaskTemplate(BO.TaskTemplate taskTemplate, string userAbrhs);

        #region Create TimeSheet

        BO.WeekMaster FetchWeekInfo(string userAbrhs, int changeWeek);

        List<WeekAndDatesBO> FetchWeekNoAndDates(string userAbrhs, string year);

        List<WeekInfoBO> FetchWeekDetailByWeekNoAndYear(string userAbrhs, string year, int weekNo);

        TimeSheetInfo FetchTimeSheetInfo(int weekNo, string startDate, string userAbrhs);

        TimeSheetInfo FetchTimeSheetInfoOtherUser(int weekNo, int year, int userId);

        List<BO.GeminiProject> FetchProjectsForTimeSheet(int weekNo, string startDate, string userAbrhs);

        List<BO.GeminiProject> FetchProjectsForTimeSheetOtherUser(int weekNo, int year, int userId);

        List<LoggedTaskInfo> FetchTasksLoggedForTimeSheet(int weekNo, string startDate, string userAbrhs);

        List<LoggedTaskInfo> FetchTasksLoggedForTimeSheetOtherUser(int weekNo, string startDate, int userId);

        List<LoggedTaskInfo> FetchTasksLoggedForProject(DateTime date, long projectId, long timeSheetId);

        BO.LoggedTask FetchSelectedTaskInfo(long taskId);

        int LogTask(BO.TimeSheet timeSheet, BO.LoggedTask loggedTask);

        int LogTaskOtherUser(BO.TimeSheet timeSheet, BO.LoggedTask loggedTask);

        int UpdateLoggedTask(long timeSheetId, BO.LoggedTask loggedTask);

        bool DeleteLoggedTask(long taskId, string userAbrhs);

        int SubmitWeeklyTimeSheet(BO.TimeSheet timeSheet, string userAbrhs);

        bool CopyTimeSheetFromWeek(int year, int fromWeek, int toWeek, string startDate, string endDate, string userAbrhs);

        #endregion

        List<int> ListWeeksForCopyTimeSheet(int year, int week, string userAbrhs);

        #region Reports

        bool GenerateTimesheetReport(string team, int year, int week, string userAbrhs);
        
        #endregion

        #region TimeSheet DashBoard

        List<PendingTimeSheets> FetchPendingTimeSheets(int weekNo, int year, string userAbrhs, string menuAbrhs);

        List<CompletedTimeSheets> FetchCompletedTimeSheets(int weekNo, int year, string userAbrhs, string menuAbrhs);

        #endregion

        #region Data Verification

        List<BO.ApprovedTask> ListApprovedTasks(int weekNo, int year, string userAbrhs, string menuAbrhs);

        BO.TaskInfo FetchApprovedTaskInfo(long mappingId);

        List<BO.GeminiProject> ListAllProjects();

        bool ChangeTaskStatus(long mappingId);

        bool OverwriteLoggedTask(BO.FinalLoggedTask finalLoggedTask);

        #endregion

        #region Review TimeSheet

        List<OtherEmployeesTimeSheet> FetchTimeSheetPendingforApproval(string userAbrhs, string menuAbrhs);

        List<OtherEmployeesTimeSheet> FetchTimeSheetsApproved(int years, string weekNos, string reportingUserIds, string userAbrhs, string menuAbrhs);

        bool ApproveTimeSheet(long timeSheetId, string remarks, string userAbrhs);

        bool RejectTimeSheet(long timeSheetId, string remarks, string userAbrhs);

        List<TaskTemplateInfo> FetchTemplatesForOtherUser(int userId);

        bool GetTimeSheetInfoForAllSelectedUsers(string timeSheetIds);

        #endregion


        #region timesheet subscription
        List<BaseDropDown> ListEligibleUsersForTimesheeet(string userAbrhs);

        List<BaseDropDown> ListExcludedUsersForTimesheeet(string userAbrhs);

        int ExcludeUserForTimesheet(string employeeAbrhs, string userAbrhs);

        int ChangeUserToEligibleForTimesheet(string employeeAbrhs, string userAbrhs);
        #endregion
    }
}
