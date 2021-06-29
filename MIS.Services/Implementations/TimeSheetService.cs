using MIS.Utilities;
using MIS.BO;
using MIS.Model;
using MIS.Services.Contracts;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.Objects;
//using Telerik.Reporting.Processing;

namespace MIS.Services.Implementations
{
    public class TimeSheetService : ITimeSheetService
    {
        private readonly IUserServices _userServices;

        public TimeSheetService()
        {

        }

        #region private member variable

        private readonly MISEntities _dbContext = new MISEntities();

        #endregion

        public TimeSheetService(IUserServices userServices)
        {
            _userServices = userServices;
        }

        /// <summary>
        /// Fetch Assigned Projects To User
        /// </summary>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<MyAssignedProjects> FetchProjectsAssignedToUser(string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                var projectList = context.spFetchProjectsAssignedToUser(userId);
                var result = new List<MyAssignedProjects>();
                foreach (var project in projectList)
                {
                    var fr = new MyAssignedProjects
                    {
                        ProjectId = project.ProjectId.GetValueOrDefault(),
                        ProjectName = project.ProjectName,
                        ParentProject = project.ParentProject,
                        Role = project.Role,
                        Selected = project.Selected.GetValueOrDefault()
                    };
                    result.Add(fr);
                }
                return result;
            }
        }

        /// <summary>
        /// Save Prefrences
        /// </summary>
        /// <param name="selectedProjects"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public bool SavePrefrences(string selectedProjects, string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                List<long> prefrence = CustomExtensions.SplitToLongList(selectedProjects);
                var existingRecords = context.ProjectPrefrences.Where(a => a.UserId == userId);
                foreach (var r in existingRecords)
                {
                    r.IsActive = false;
                    r.IsDeleted = true;
                }
                context.SaveChanges();
                foreach (var p in prefrence)
                {
                    var existingRecord = context.ProjectPrefrences.FirstOrDefault(a => a.UserId == userId && a.ProjectId == p);
                    if (existingRecord != null)
                    {
                        existingRecord.IsActive = true;
                        existingRecord.IsDeleted = false;
                        context.SaveChanges();
                    }
                    else
                    {
                        //CPTIWARI
                        var geminiProjectPrefrence = new Model.ProjectPrefrence()
                        {
                            UserId = userId,
                            ProjectId = p,
                            IsActive = true,
                            IsDeleted = false,
                            CreatedDate = DateTime.Now,
                            CreatedBy = userId,
                        };
                        context.ProjectPrefrences.Add(geminiProjectPrefrence);
                        context.SaveChanges();
                    }
                }
                // Logging
                _userServices.SaveUserLogs(ActivityMessages.SavePrefrences, userId, 0);

                return true;
            }
        }

        /// <summary>
        /// Fetch Templates Associated WithUser
        /// </summary>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<TaskTemplateInfo> FetchTemplatesAssociatedWithUser(string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                var templateList = (from t in context.TaskTemplates
                                    where
                                        t.CreatedBy == userId &&
                                        t.IsActive &&
                                        !t.IsDeleted
                                    select new TaskTemplateInfo
                                    {
                                        TemplateId = t.TemplateId,
                                        Name = t.Name,
                                        Description = t.Description,
                                        TeamName = t.TaskTeam.TeamName,
                                        TaskType = t.TaskType.TaskTypeName,
                                        TaskSubDetail1 = t.TaskSubDetail1.TaskSubDetail1Name,
                                        TaskSubDetail2 = t.TaskSubDetail2.TaskSubDetail2Name
                                    }).ToList();
                return templateList;
            }
        }

        /// <summary>
        /// Save TaskTemplate
        /// </summary>
        /// <param name="taskTemplate"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public int SaveTaskTemplate(BO.TaskTemplate taskTemplate, string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                var taskInfo = context.TaskTemplates.FirstOrDefault(a => a.Name == taskTemplate.Name.Trim() && a.CreatedBy == userId && !a.IsDeleted && a.IsActive);
                if (taskInfo == null)
                {
                    var taskModel = new Model.TaskTemplate
                    {
                        Name = taskTemplate.Name,
                        Description = taskTemplate.Description,
                        TaskTeamId = taskTemplate.TaskTeamId,
                        TaskTypeId = taskTemplate.TaskTypeId,
                        TaskSubDetail1Id = taskTemplate.TaskSubDetail1Id == 0 ? 1 : taskTemplate.TaskSubDetail1Id,
                        TaskSubDetail2Id = taskTemplate.TaskSubDetail2Id == 0 ? 1 : taskTemplate.TaskSubDetail2Id,
                        IsActive = true,
                        IsDeleted = false,
                        CreatedDate = DateTime.Now,
                        CreatedBy = userId
                    };
                    context.TaskTemplates.Add(taskModel);
                    context.SaveChanges();

                    // Logging
                    _userServices.SaveUserLogs(ActivityMessages.SaveTaskTemplate, userId, 0);

                    return 1;
                }
                return 2;
            }
        }

        /// <summary>
        /// Delete TaskTemplate
        /// </summary>
        /// <param name="templateId"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public bool DeleteTaskTemplate(long templateId, string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                var taskInfo = context.TaskTemplates.FirstOrDefault(a => a.TemplateId == templateId);
                taskInfo.IsDeleted = true;
                taskInfo.IsActive = false;
                taskInfo.LastModifiedBy = userId;
                taskInfo.LastModifiedDate = DateTime.UtcNow;
                context.SaveChanges();

                // Logging
                _userServices.SaveUserLogs(ActivityMessages.DeleteTaskTemplate, userId, 0);
                return true;
            }
        }

        /// <summary>
        /// Fetch SelectedTemplateInfo
        /// </summary>
        /// <param name="templateId"></param>
        /// <returns></returns>
        public BO.TaskTemplate FetchSelectedTemplateInfo(long templateId)
        {
            using (var context = new MISEntities())
            {
                var temlateInfo = context.TaskTemplates.FirstOrDefault(a => a.TemplateId == templateId);
                return Convertor.Convert<BO.TaskTemplate, Model.TaskTemplate>(temlateInfo);
            }
        }

        /// <summary>
        /// Update TaskTemplate
        /// </summary>
        /// <param name="taskTemplate"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public int UpdateTaskTemplate(BO.TaskTemplate taskTemplate, string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                var taskInfo = context.TaskTemplates.FirstOrDefault(a => a.TemplateId == taskTemplate.TemplateId);
                var existTaskInfo = context.TaskTemplates.FirstOrDefault(a => a.Name == taskTemplate.Name && a.TaskSubDetail1Id == taskTemplate.TaskSubDetail1Id
                    && a.TaskTeamId == taskTemplate.TaskTeamId && a.TaskTypeId == taskTemplate.TaskTypeId
                    && a.TaskSubDetail2Id == taskTemplate.TaskSubDetail2Id && !a.IsDeleted && a.IsActive && a.CreatedBy == userId && a.Description == taskTemplate.Description);
                if (existTaskInfo != null)
                {
                    return 2;
                }
                else
                {
                    taskInfo.Name = taskTemplate.Name;
                    taskInfo.Description = taskTemplate.Description;
                    taskInfo.TaskTeamId = taskTemplate.TaskTeamId;
                    taskInfo.TaskTypeId = taskTemplate.TaskTypeId;
                    taskInfo.TaskSubDetail1Id = taskTemplate.TaskSubDetail1Id == 0 ? 1 : taskTemplate.TaskSubDetail1Id;
                    taskInfo.TaskSubDetail2Id = taskTemplate.TaskSubDetail2Id == 0 ? 1 : taskTemplate.TaskSubDetail2Id;
                    taskInfo.LastModifiedBy = userId;
                    taskInfo.LastModifiedDate = DateTime.Now;
                    context.SaveChanges();

                    // Logging 
                    _userServices.SaveUserLogs(ActivityMessages.UpdateTaskTemplate, userId, 0);

                    return 1;
                }
            }
        }

        #region Create TimeSheet

        /// <summary>
        /// Fetch WeekInfo
        /// </summary>
        /// <param name="userAbrhs"></param>
        /// <param name="changeWeek"></param>
        /// <returns></returns>
        public BO.WeekMaster FetchWeekInfo(string userAbrhs, int changeWeek)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                DateTime currentTime = DateTime.UtcNow.AddDays(7 * changeWeek);
                var weekInfo = context.spFetchWeekInfo(userId, currentTime).FirstOrDefault();
                if (weekInfo != null)
                {
                    var result = new BO.WeekMaster
                    {
                        EndDate = weekInfo.EndDate.GetValueOrDefault(),
                        StartDate = weekInfo.StartDate.GetValueOrDefault(),
                        WeekNo = weekInfo.WeekNo.GetValueOrDefault(),
                        Year = weekInfo.WeekNo == 1 && (weekInfo.StartDate.GetValueOrDefault().Year != weekInfo.EndDate.GetValueOrDefault().Year)? weekInfo.EndDate.GetValueOrDefault().Year: weekInfo.StartDate.GetValueOrDefault().Year,
                        //Year = weekInfo.EndDate.GetValueOrDefault().Year,
                        DisplayStartDate = weekInfo.StartDate.GetValueOrDefault().ToString("MM/dd/yyyy"),
                        DisplayEndDate = weekInfo.EndDate.GetValueOrDefault().ToString("MM/dd/yyyy"),
                    };
                    return result;
                }
                return null;
            }
        }

        public List<WeekAndDatesBO> FetchWeekNoAndDates(string userAbrhs, string sYear)
        {
            int userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            int year = Int32.Parse(sYear);
            var result = new List<WeekAndDatesBO>();

            var data = FetchWeekInfo(userAbrhs, -10);//FetchWeekInfo(79, -10);
            if (data == null)
            {
                return null;
            }
            DateTime dt = new DateTime(year, 12, 31);

            var tempStartDate = data.StartDate; //firstResult.StartDate;
            for (int i = data.WeekNo; tempStartDate.Date < dt.Date; i++)
            {
                var temp = new WeekAndDatesBO();
                var tempDateString = "Week # " + i + " (" + tempStartDate.ToString("dd MMM yyyy") + " to " + tempStartDate.AddDays(6).ToString("dd MMM yyyy") + ")";
                temp.WeekDateString = tempDateString;
                temp.NewStartDate = tempStartDate.ToString("MM/dd/yyyy", CultureInfo.InvariantCulture);
                tempStartDate = tempStartDate.AddDays(7);
                temp.NewEndDate = tempStartDate.AddDays(-1).ToString("MM/dd/yyyy", CultureInfo.InvariantCulture);
                temp.WeekNo = i;
                temp.CurrentWeekNo = _dbContext.spFetchWeekInfo(userId, DateTime.Now).FirstOrDefault().WeekNo;
                result.Add(temp);
            }
            return result;
        }

        public List<WeekInfoBO> FetchWeekDetailByWeekNoAndYear(string userAbrhs, string year, int weekNo)
        {
            var data = FetchWeekNoAndDates(userAbrhs, year).Where(x => x.WeekNo == weekNo).Select(x => new { x.StartDate, x.EndDate }).FirstOrDefault();
            return _dbContext.DateMasters.Where(x => x.Date >= data.StartDate && x.Date <= data.EndDate).Select(x => new WeekInfoBO
            {
                DateId = x.DateId,
                Date = x.Date,
                Day = x.Day,
            }).ToList();
        }

        /// <summary>
        /// Fetch TimeSheet Info
        /// </summary>
        /// <param name="weekNo"></param>
        /// <param name="startDate"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public TimeSheetInfo FetchTimeSheetInfo(int weekNo, string startDate, string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                var startDateTime = DateTime.ParseExact(startDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
                var timeSheetInfo = context.TimeSheets.FirstOrDefault(a => a.WeekNo == weekNo && a.StartDate == startDateTime && a.CreatedBy == userId);
                //var year = DateTime.ParseExact(startDate, "MM/dd/yyyy", CultureInfo.InvariantCulture).Year;
                //var timeSheetInfo = context.TimeSheets.FirstOrDefault(a => a.WeekNo == weekNo && a.Year == year && a.CreatedBy == userId);
                var rejectInWeekNumber = 0;
                var isManualEntry = false;
                //var isTimeSheetEnabled = timeSheetInfo.IsTimeSheetEnabled.HasValue ? timeSheetInfo.IsTimeSheetEnabled.Value : false;
                if (timeSheetInfo == null)
                {
                    var timesheetObj = new Model.TimeSheet
                    {
                        WeekNo = weekNo,
                        Year = startDateTime.Year,
                        StartDate = startDateTime,
                        TotalHoursLogged = 0M,
                        Status = (int)Enums.TimesheetStatus.Drafted,
                        CreatedBy = userId,
                        CreatedDate = DateTime.Now
                    };
                    //var timesheetDetail = Convertor.Convert<Model.TimeSheet, BO.TimeSheet>(timesheetObj);
                    context.TimeSheets.Add(timesheetObj);
                    context.SaveChanges();
                    timeSheetInfo = timesheetObj;
                    isManualEntry = true;
                }
                var status = CommonUtility.GetEnumDescription<Enums.TimesheetStatus>(timeSheetInfo.Status);
                if (timeSheetInfo.Status == (int)Enums.TimesheetStatus.Rejected)
                    rejectInWeekNumber = context.spFetchWeekInfo(userId, timeSheetInfo.LastModifiedDate).FirstOrDefault().WeekNo.Value;
                var isTimeSheetEnabled = timeSheetInfo.IsTimeSheetEnabled.HasValue ? timeSheetInfo.IsTimeSheetEnabled.Value : false;
                var result = new TimeSheetInfo
                {
                    TimeSheetId = timeSheetInfo.TimeSheetId,
                    ApproverRemarks = timeSheetInfo.ApproverRemarks,
                    StartDate = timeSheetInfo.StartDate,
                    EndDate = timeSheetInfo.EndDate.Value,
                    Status = isManualEntry ? "Not Submitted" : status,
                    DisplayStartDate = timeSheetInfo.StartDate.ToString("MM/dd/yyyy"),
                    DisplayEndDate = timeSheetInfo.EndDate.GetValueOrDefault().ToString("MM/dd/yyyy"),
                    TimeLogged = timeSheetInfo.TotalHoursLogged,
                    UserRemarks = timeSheetInfo.UserRemarks,
                    RejectInWeekNumber = rejectInWeekNumber,
                    // IsTimesheetEnabled = false
                };

                //check if timesheet is editable
                var selectedYear = Convert.ToDateTime(timeSheetInfo.EndDate).Year;
                //var currentYear = timeSheetInfo.StartDate.Year;
                var currentYear = DateTime.Now.Year;
                //var selectedYear = timeSheetInfo.StartDate.Year;
                var selectedWeek = timeSheetInfo.WeekNo;
                var currentWeek = context.spFetchWeekInfo(userId, DateTime.Now.Date).FirstOrDefault().WeekNo.Value;
                var isEditable = false;
                if (selectedYear == currentYear)
                {
                    if (currentWeek - selectedWeek > 1)
                    {
                        if (status.ToLower() == "rejected")
                            isEditable = true;
                        if (status.ToLower() == "drafted" && isTimeSheetEnabled)
                            isEditable = true;
                    }
                    else
                    {
                        if (status.ToLower() != "submitted" && status.ToLower() != "approved")
                            isEditable = true;
                    }
                }
                else
                {
                    if (status.ToLower() == "drafted" && isTimeSheetEnabled)
                        isEditable = true;
                    if (status.ToLower() == "rejected")
                        isEditable = true;
                    if (status.ToLower() == "drafted" && currentWeek == 1 && (selectedWeek == 52 || selectedWeek == 53))
                        isEditable = true;
                    //else
                    //{
                    //    if (status.ToLower() != "submitted" && status.ToLower() != "approved")
                    //        isEditable = true;
                    //}
                }
                result.IsTimesheetEnabled = isEditable;
                return result;
            }
        }

        /// <summary>
        /// Fetch TimeSheet Info OtherUser
        /// </summary>
        /// <param name="weekNo"></param>
        /// <param name="startDate"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public TimeSheetInfo FetchTimeSheetInfoOtherUser(int weekNo, int year, int userId)
        {
            using (var context = new MISEntities())
            {
                //var year = DateTime.ParseExact(startDate, "MM/dd/yyyy", CultureInfo.InvariantCulture).Year;
                var timeSheetInfo = context.TimeSheets.FirstOrDefault(a => a.WeekNo == weekNo && a.Year == year && a.CreatedBy == userId);
                if (timeSheetInfo != null)
                {
                    var status = CommonUtility.GetEnumDescription<Enums.TimesheetStatus>(timeSheetInfo.Status);
                    var result = new TimeSheetInfo
                    {
                        TimeSheetId = timeSheetInfo.TimeSheetId,
                        ApproverRemarks = timeSheetInfo.ApproverRemarks,
                        StartDate = timeSheetInfo.StartDate,
                        EndDate = timeSheetInfo.EndDate,
                        Status = status,
                        DisplayStartDate = timeSheetInfo.StartDate.ToString("MM/dd/yyyy"),
                        DisplayEndDate = timeSheetInfo.EndDate.GetValueOrDefault().ToString("MM/dd/yyyy"),
                        TimeLogged = timeSheetInfo.TotalHoursLogged,
                        UserRemarks = timeSheetInfo.UserRemarks
                    };
                    return result;
                }
                var r = new TimeSheetInfo
                {
                    TimeSheetId = 0,
                    ApproverRemarks = string.Empty,
                    Status = "Not Submitted",
                    TimeLogged = Convert.ToDecimal(0),
                    StartDate = DateTime.UtcNow,
                    EndDate = DateTime.UtcNow,
                    UserRemarks = string.Empty
                };
                return r;
            }
        }

        /// <summary>
        /// Fetch Projects For TimeSheet
        /// </summary>
        /// <param name="weekNo"></param>
        /// <param name="startDate"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<BO.GeminiProject> FetchProjectsForTimeSheet(int weekNo, string startDate, string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                //var year = DateTime.Parse(startDate).Year;
                var startDateTime = DateTime.ParseExact(startDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
                var projectList = new List<BO.GeminiProject>();
                var timeSheet =
                    context.TimeSheets.FirstOrDefault(
                        a => a.CreatedBy == userId && a.WeekNo == weekNo && a.StartDate == startDateTime);

                var prefrences = (from pp in context.ProjectPrefrences
                                  where pp.IsActive && pp.UserId == userId
                                  select new BO.GeminiProject
                                  {
                                      ProjectId = pp.Project.ProjectId,
                                      Name = pp.Project.Name,
                                      StartDate = pp.Project.StartDate,
                                      CreatedDate = pp.Project.CreatedDate
                                  }).OrderBy(p => p.Name).ToList();
                // get info for time sheet
                if (timeSheet != null)
                {
                    var loggedProjects = (from m in context.TimeSheetTaskMappings
                                          join p in context.Projects on m.LoggedTask.ProjectId equals p.ProjectId
                                          where
                                             m.TimeSheet.WeekNo == weekNo &&
                                             m.TimeSheet.StartDate == startDateTime &&
                                             m.TimeSheet.CreatedBy == userId &&
                                             m.LoggedTask.IsActive && !m.LoggedTask.IsDeleted
                                          select new BO.GeminiProject
                                          {
                                              ProjectId = p.ProjectId,
                                              Name = p.Name,
                                              StartDate = p.StartDate,
                                              CreatedDate = p.CreatedDate
                                          }).OrderBy(p => p.Name).ToList();

                    if (timeSheet.Status > (int)Enums.TimesheetStatus.Drafted)// > 0
                    {
                        projectList.AddRange(loggedProjects);
                    }
                    else
                    {
                        projectList.AddRange(loggedProjects);
                        projectList.AddRange(prefrences);
                    }
                }
                else
                {
                    projectList.AddRange(prefrences);
                }
                var result = projectList.GroupBy(t => t.Name, (g, key) => key.First()).OrderBy(a => a.Name).ToList();
                return result;
            }
        }

        /// <summary>
        /// Fetc hProjects For TimeSheet OtherUser
        /// </summary>
        /// <param name="weekNo"></param>
        /// <param name="startDate"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public List<BO.GeminiProject> FetchProjectsForTimeSheetOtherUser(int weekNo, int year, int userId)
        {
            using (var context = new MISEntities())
            {
                //var year = DateTime.Parse(startDate).Year;
                //var year = DateTime.ParseExact(startDate, "MM/dd/yyyy", CultureInfo.InvariantCulture).Year;
                var projectList = new List<BO.GeminiProject>();
                var timeSheet =
                    context.TimeSheets.FirstOrDefault(
                        a => a.CreatedBy == userId && a.WeekNo == weekNo && a.Year == year);

                var prefrences = (from pp in context.ProjectPrefrences
                                  where pp.IsActive && pp.UserId == userId
                                  select new BO.GeminiProject
                                  {
                                      ProjectId = pp.Project.ProjectId,
                                      Name = pp.Project.Name,
                                      StartDate = pp.Project.StartDate,
                                      CreatedDate = pp.Project.CreatedDate
                                  }).OrderBy(p => p.Name).ToList();
                // get info for time sheet
                if (timeSheet != null)
                {
                    var loggedProjects = (from m in context.TimeSheetTaskMappings
                                          join p in context.Projects on m.LoggedTask.ProjectId equals p.ProjectId
                                          where
                                             m.TimeSheet.WeekNo == weekNo &&
                                             m.TimeSheet.Year == year &&
                                             m.TimeSheet.CreatedBy == userId &&
                                             m.LoggedTask.IsActive && !m.LoggedTask.IsDeleted
                                          select new BO.GeminiProject
                                          {
                                              ProjectId = p.ProjectId,
                                              Name = p.Name,
                                              StartDate = p.StartDate,
                                              CreatedDate = p.CreatedDate
                                          }).OrderBy(p => p.Name).ToList();

                    if (timeSheet.Status > (int)Enums.TimesheetStatus.Drafted) //> 0
                    {
                        projectList.AddRange(loggedProjects);
                    }
                    else
                    {
                        projectList.AddRange(loggedProjects);
                        projectList.AddRange(prefrences);
                    }
                }
                else
                {
                    projectList.AddRange(prefrences);
                }
                var result = projectList.GroupBy(t => t.Name, (g, key) => key.First()).OrderBy(a => a.Name).ToList();
                return result;
            }
        }

        /// <summary>
        /// Fetch Tasks Logged For TimeSheet
        /// </summary>
        /// <param name="weekNo"></param>
        /// <param name="startDate"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<LoggedTaskInfo> FetchTasksLoggedForTimeSheet(int weekNo, string startDate, string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                var startDateTime = DateTime.ParseExact(startDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
                //int year = DateTime.ParseExact(startDate, "MM/dd/yyyy", CultureInfo.InvariantCulture).Year;
                long timeSheetId = 0;
                var timeSheetInfo =
                   context.TimeSheets.FirstOrDefault(
                      a => a.WeekNo == weekNo && a.StartDate == startDateTime && a.CreatedBy == userId);
                if (timeSheetInfo != null)
                {
                    timeSheetId = timeSheetInfo.TimeSheetId;
                }
                var loggedTask = (from l in context.TimeSheetTaskMappings
                                  where
                                     l.TimeSheetId == timeSheetId
                                     && !l.LoggedTask.IsDeleted
                                     && l.LoggedTask.IsActive
                                  select new LoggedTaskInfo
                                  {
                                      TaskId = l.TaskId,
                                      TaskDate = l.LoggedTask.Date,
                                      ProjectId = l.LoggedTask.ProjectId,
                                      Description = l.LoggedTask.Description,
                                      TeamName = l.LoggedTask.TaskTeam.TeamName,
                                      TaskType = l.LoggedTask.TaskType.TaskTypeName,
                                      TaskSubDetail1 = l.LoggedTask.TaskSubDetail1.TaskSubDetail1Name,
                                      TaskSubDetail2 = l.LoggedTask.TaskSubDetail2.TaskSubDetail2Name,
                                      TimeSpent = l.LoggedTask.TimeSpent
                                  }).ToList();
                foreach (var task in loggedTask)
                {
                    task.DisplayTaskDate = task.TaskDate.ToString("MM/dd/yyyy");
                }
                return loggedTask;
            }
        }


        public bool GetTimeSheetInfoForAllSelectedUsers(string timeSheetIds)
        {
            return true;
        }


        /// <summary>
        /// Fetch Tasks Logged For TimeSheet Other User
        /// </summary>
        /// <param name="weekNo"></param>
        /// <param name="startDate"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public List<LoggedTaskInfo> FetchTasksLoggedForTimeSheetOtherUser(int weekNo, string startDate, int userId)
        {
            var startDataTime = DateTime.ParseExact(startDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            using (var context = new MISEntities())
            {
                int year = DateTime.ParseExact(startDate, "MM/dd/yyyy", CultureInfo.InvariantCulture).Year;
                long timeSheetId = 0;
                var timeSheetInfo =
                   context.TimeSheets.FirstOrDefault(
                      a => a.WeekNo == weekNo && a.StartDate == startDataTime && a.CreatedBy == userId);
                if (timeSheetInfo != null)
                {
                    timeSheetId = timeSheetInfo.TimeSheetId;
                }
                var loggedTask = (from l in context.TimeSheetTaskMappings
                                  where
                                     l.TimeSheetId == timeSheetId
                                     && !l.LoggedTask.IsDeleted
                                     && l.LoggedTask.IsActive
                                  select new LoggedTaskInfo
                                  {
                                      TaskId = l.TaskId,
                                      TaskDate = l.LoggedTask.Date,
                                      ProjectId = l.LoggedTask.ProjectId,
                                      Description = l.LoggedTask.Description,
                                      TeamName = l.LoggedTask.TaskTeam.TeamName,
                                      TaskType = l.LoggedTask.TaskType.TaskTypeName,
                                      TaskSubDetail1 = l.LoggedTask.TaskSubDetail1.TaskSubDetail1Name,
                                      TaskSubDetail2 = l.LoggedTask.TaskSubDetail2.TaskSubDetail2Name,
                                      TimeSpent = l.LoggedTask.TimeSpent
                                  }).ToList();
                foreach (var task in loggedTask)
                {
                    task.DisplayTaskDate = task.TaskDate.ToString("MM/dd/yyyy");
                }
                return loggedTask;
            }
        }

        /// <summary>
        /// Fetch Tasks Logged For Project
        /// </summary>
        /// <param name="date"></param>
        /// <param name="projectId"></param>
        /// <param name="timeSheetId"></param>
        /// <returns></returns>
        public List<LoggedTaskInfo> FetchTasksLoggedForProject(DateTime date, long projectId, long timeSheetId)
        {
            using (var context = new MISEntities())
            {
                var loggedTask = (from l in context.TimeSheetTaskMappings
                                  where
                                     l.LoggedTask.Date == date
                                     && l.LoggedTask.ProjectId == projectId
                                     && l.TimeSheetId == timeSheetId
                                     && l.LoggedTask.IsActive && !l.LoggedTask.IsDeleted
                                  select new LoggedTaskInfo
                                  {
                                      TaskId = l.TaskId,
                                      TaskDate = l.LoggedTask.Date,
                                      ProjectId = l.LoggedTask.ProjectId,
                                      Description = l.LoggedTask.Description,
                                      TeamName = l.LoggedTask.TaskTeam.TeamName,
                                      TaskType = l.LoggedTask.TaskType.TaskTypeName,
                                      TaskSubDetail1 = l.LoggedTask.TaskSubDetail1.TaskSubDetail1Name,
                                      TaskSubDetail2 = l.LoggedTask.TaskSubDetail2.TaskSubDetail2Name,
                                      TimeSpent = l.LoggedTask.TimeSpent
                                  }).ToList();
                return loggedTask;
            }
        }

        /// <summary>
        /// Fetch Selected TaskInfo
        /// </summary>
        /// <param name="taskId"></param>
        /// <returns></returns>
        public BO.LoggedTask FetchSelectedTaskInfo(long taskId)
        {
            using (var context = new MISEntities())
            {
                var taskInfo = context.LoggedTasks.FirstOrDefault(a => a.TaskId == taskId);
                if (taskInfo != null)
                {
                    var result = Convertor.Convert<BO.LoggedTask, Model.LoggedTask>(taskInfo);
                    return result;
                }
                return null;
            }
        }

        #endregion

        #region Create TimeSheet

        /// <summary>
        /// Log Task
        /// </summary>
        /// <param name="timeSheet"></param>
        /// <param name="loggedTask"></param>
        /// <returns>1:Task has been added successfully.
        ///          2:Task already logged.
        ///          3:You are too late to fill the timesheet for this week.
        /// </returns>
        public int LogTask(BO.TimeSheet timeSheet, BO.LoggedTask loggedTask)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(timeSheet.userAbrhs), out userId);
                var isSelfTimesheet = false;
                if (timeSheet.CreatedBy == 0)
                {
                    isSelfTimesheet = true;
                    timeSheet.CreatedBy = userId;
                }

                loggedTask.CreatedBy = userId;
                long timeSheetId = 0;
                var timeSheetInfo = context.TimeSheets.FirstOrDefault(a => a.WeekNo == timeSheet.WeekNo && a.StartDate == timeSheet.StartDate && a.CreatedBy == timeSheet.CreatedBy);
                if (isSelfTimesheet)
                {
                    //check For Validate the timesheet is editable or not.
                    var timesheetWeek = timeSheet.WeekNo;
                    var currentWeek = context.spFetchWeekInfo(userId, DateTime.Now.Date).FirstOrDefault().WeekNo.Value;
                    var isTimesheetEnabled = timeSheetInfo.IsTimeSheetEnabled.HasValue ? timeSheetInfo.IsTimeSheetEnabled.Value : false;
                    if (timeSheetInfo == null)
                    {
                        if (currentWeek - timesheetWeek > 1)
                        {
                            return 3;
                        }
                    }
                    else
                    {
                        if (timeSheetInfo.Status == (int)Enums.TimesheetStatus.Rejected)
                        {
                            var rejectedInWeek = context.spFetchWeekInfo(userId, timeSheetInfo.LastModifiedDate).FirstOrDefault().WeekNo.Value;
                            if (!((currentWeek - rejectedInWeek) <= 1))
                            {
                                return 3;
                            }
                        }
                    }
                }

                if (timeSheetInfo == null)
                {
                    var modelTimeSheet = Convertor.Convert<Model.TimeSheet, BO.TimeSheet>(timeSheet);
                    context.TimeSheets.Add(modelTimeSheet);
                    modelTimeSheet.TotalHoursLogged = loggedTask.TimeSpent;
                    context.SaveChanges();
                    timeSheetId = modelTimeSheet.TimeSheetId;
                }
                else
                {
                    timeSheetId = timeSheetInfo.TimeSheetId;
                }

                var existTask =
                   context.TimeSheetTaskMappings.FirstOrDefault(
                      a =>
                         a.TimeSheetId == timeSheetId &&
                         a.LoggedTask.Date == loggedTask.Date &&
                         a.LoggedTask.ProjectId == loggedTask.ProjectId &&
                         a.LoggedTask.Description == loggedTask.Description &&
                         a.LoggedTask.TaskTeamId == loggedTask.TaskTeamId &&
                         a.LoggedTask.TaskTypeId == loggedTask.TaskTypeId &&
                         a.LoggedTask.TaskSubDetail1Id == (loggedTask.TaskSubDetail1Id == 0 ? 1 : loggedTask.TaskSubDetail1Id) &&
                         a.LoggedTask.TaskSubDetail2Id == (loggedTask.TaskSubDetail2Id == 0 ? 1 : loggedTask.TaskSubDetail2Id) &&
                         !a.LoggedTask.IsDeleted
                         && a.LoggedTask.IsActive);
                if (existTask != null)
                {
                    return 2;
                }
                var modelLoggedTask = Convertor.Convert<Model.LoggedTask, BO.LoggedTask>(loggedTask);
                var modelFinalLoggedTask = Convertor.Convert<Model.FinalLoggedTask, BO.LoggedTask>(loggedTask);
                context.LoggedTasks.Add(modelLoggedTask);
                var mapping = new BO.TimeSheetTaskMapping
                {
                    TaskId = modelLoggedTask.TaskId,
                    TimeSheetId = timeSheetId,
                    ConsiderInClientReports = true
                };
                var modelMapping = Convertor.Convert<Model.TimeSheetTaskMapping, BO.TimeSheetTaskMapping>(mapping);
                context.TimeSheetTaskMappings.Add(modelMapping);
                if (timeSheetInfo != null)
                {
                    timeSheetInfo.TotalHoursLogged = timeSheetInfo.TotalHoursLogged + loggedTask.TimeSpent;
                }
                modelFinalLoggedTask.MappingId = modelMapping.RecordId;
                context.FinalLoggedTasks.Add(modelFinalLoggedTask);

                context.SaveChanges();

                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.LogTimeSheet, userId, 0);

                return 1;
            }
        }

        /// <summary>
        /// LogTask Other User
        /// </summary>
        /// <param name="timeSheet"></param>
        /// <param name="loggedTask"></param>
        /// <returns></returns>
        public int LogTaskOtherUser(BO.TimeSheet timeSheet, BO.LoggedTask loggedTask)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(timeSheet.userAbrhs), out userId);
                timeSheet.LastModifiedBy = userId;
                loggedTask.CreatedBy = userId;
                timeSheet.LastModifiedDate = DateTime.Now;
                loggedTask.LastModifiedBy = userId;
                long timeSheetId = 0;
                var timeSheetInfo =
                   context.TimeSheets.FirstOrDefault(
                      a => a.WeekNo == timeSheet.WeekNo && a.StartDate == timeSheet.StartDate && a.CreatedBy == timeSheet.CreatedBy);
                if (timeSheetInfo == null)
                {
                    var modelTimeSheet = Convertor.Convert<Model.TimeSheet, BO.TimeSheet>(timeSheet);
                    context.TimeSheets.Add(modelTimeSheet);
                    modelTimeSheet.TotalHoursLogged = loggedTask.TimeSpent;
                    context.SaveChanges();
                    timeSheetId = modelTimeSheet.TimeSheetId;
                }
                else
                {
                    timeSheetId = timeSheetInfo.TimeSheetId;
                }

                var existTask =
                   context.TimeSheetTaskMappings.FirstOrDefault(
                      a =>
                         a.TimeSheetId == timeSheetId &&
                         a.LoggedTask.Date == loggedTask.Date &&
                         a.LoggedTask.ProjectId == loggedTask.ProjectId &&
                         a.LoggedTask.Description == loggedTask.Description &&
                         a.LoggedTask.TaskTeamId == loggedTask.TaskTeamId &&
                         a.LoggedTask.TaskTypeId == loggedTask.TaskTypeId &&
                         a.LoggedTask.TaskSubDetail1Id == (loggedTask.TaskSubDetail1Id == 0 ? 1 : loggedTask.TaskSubDetail1Id) &&
                         a.LoggedTask.TaskSubDetail2Id == (loggedTask.TaskSubDetail2Id == 0 ? 1 : loggedTask.TaskSubDetail2Id) &&
                         !a.LoggedTask.IsDeleted
                         );
                if (existTask != null)
                {
                    return 2;
                }
                var modelLoggedTask = Convertor.Convert<Model.LoggedTask, BO.LoggedTask>(loggedTask);
                var modelFinalLoggedTask = Convertor.Convert<Model.FinalLoggedTask, BO.LoggedTask>(loggedTask);


                context.LoggedTasks.Add(modelLoggedTask);
                var mapping = new BO.TimeSheetTaskMapping
                {
                    TaskId = modelLoggedTask.TaskId,
                    TimeSheetId = timeSheetId,
                    ConsiderInClientReports = true
                };
                var modelMapping = Convertor.Convert<Model.TimeSheetTaskMapping, BO.TimeSheetTaskMapping>(mapping);
                context.TimeSheetTaskMappings.Add(modelMapping);
                if (timeSheetInfo != null)
                {
                    timeSheetInfo.TotalHoursLogged = timeSheetInfo.TotalHoursLogged + loggedTask.TimeSpent;
                }
                modelFinalLoggedTask.MappingId = modelMapping.RecordId;
                context.FinalLoggedTasks.Add(modelFinalLoggedTask);

                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.LogTimeSheetToOtherUser, userId, timeSheet.CreatedBy);

                context.SaveChanges();
                return 1;
            }
        }

        /// <summary>
        /// Update Logged Task
        /// </summary>
        /// <param name="timeSheetId"></param>
        /// <param name="loggedTask"></param>
        /// <returns></returns>
        public int UpdateLoggedTask(long timeSheetId, BO.LoggedTask loggedTask)
        {
            using (var context = new MISEntities())
            {
                var loginUserId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(loggedTask.userAbrhs), out loginUserId);

                var timeSheetInfo = context.TimeSheets.FirstOrDefault(a => a.TimeSheetId == timeSheetId);
                var taskInfo = context.LoggedTasks.FirstOrDefault(a => a.TaskId == loggedTask.TaskId);
                var finalTaskId = context.TimeSheetTaskMappings.FirstOrDefault(f => f.TaskId == taskInfo.TaskId);
                var finalLoggedTaskInfo =
                    context.FinalLoggedTasks.FirstOrDefault(f => f.MappingId == finalTaskId.RecordId && !f.IsDeleted && f.IsActive);


                if (timeSheetInfo != null)
                {
                    timeSheetInfo.TotalHoursLogged = timeSheetInfo.TotalHoursLogged - taskInfo.TimeSpent;
                    timeSheetInfo.TotalHoursLogged = timeSheetInfo.TotalHoursLogged + loggedTask.TimeSpent;
                }

                var existTask =
                   context.TimeSheetTaskMappings.FirstOrDefault(
                      a =>
                         a.TimeSheetId == timeSheetId &&
                         a.LoggedTask.Date == loggedTask.Date &&
                         a.LoggedTask.ProjectId == loggedTask.ProjectId &&
                         a.LoggedTask.Description == loggedTask.Description &&
                         a.LoggedTask.TaskTeamId == loggedTask.TaskTeamId &&
                         a.LoggedTask.TaskTypeId == loggedTask.TaskTypeId &&
                         a.LoggedTask.TaskSubDetail1Id == (loggedTask.TaskSubDetail1Id == 0 ? 1 : loggedTask.TaskSubDetail1Id) &&
                         a.LoggedTask.TaskSubDetail2Id == (loggedTask.TaskSubDetail2Id == 0 ? 1 : loggedTask.TaskSubDetail2Id) &&
                         a.LoggedTask.TaskId != loggedTask.TaskId &&
                         !a.LoggedTask.IsDeleted
                          );
                if (existTask != null)
                {
                    return 2;
                }
                else
                {
                    taskInfo.Description = loggedTask.Description;
                    taskInfo.TaskTeamId = loggedTask.TaskTeamId;
                    taskInfo.TaskTypeId = loggedTask.TaskTypeId;
                    taskInfo.TaskSubDetail1Id = loggedTask.TaskSubDetail1Id == 0 ? 1 : loggedTask.TaskSubDetail1Id;
                    taskInfo.TaskSubDetail2Id = loggedTask.TaskSubDetail2Id == 0 ? 1 : loggedTask.TaskSubDetail2Id;
                    taskInfo.TimeSpent = loggedTask.TimeSpent;
                    taskInfo.LastModifiedBy = loginUserId;
                    taskInfo.LastModifiedDate = loggedTask.LastModifiedDate;

                    finalLoggedTaskInfo.Description = loggedTask.Description;
                    finalLoggedTaskInfo.TaskTeamId = loggedTask.TaskTeamId;
                    finalLoggedTaskInfo.TaskTypeId = loggedTask.TaskTypeId;
                    finalLoggedTaskInfo.TaskSubDetail1Id = loggedTask.TaskSubDetail1Id == 0 ? 1 : loggedTask.TaskSubDetail1Id;
                    finalLoggedTaskInfo.TaskSubDetail2Id = loggedTask.TaskSubDetail2Id == 0 ? 1 : loggedTask.TaskSubDetail2Id;
                    finalLoggedTaskInfo.TimeSpent = loggedTask.TimeSpent;
                    finalLoggedTaskInfo.LastModifiedBy = loginUserId;
                    finalLoggedTaskInfo.LastModifiedDate = loggedTask.LastModifiedDate;
                }
                context.SaveChanges();

                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.UpdateLoggedTask, loginUserId, 0);

                return 1;
            }
        }

        /// <summary>
        /// Delete Logged Task
        /// </summary>
        /// <param name="taskId"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public bool DeleteLoggedTask(long taskId, string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                var loggedTaskInfo = context.LoggedTasks.FirstOrDefault(t => t.TaskId == taskId);
                var finalTaskId = context.TimeSheetTaskMappings.FirstOrDefault(f => f.TaskId == taskId);
                var finalLoggedTaskInfo =
                    context.FinalLoggedTasks.FirstOrDefault(f => f.MappingId == finalTaskId.RecordId && !f.IsDeleted && f.IsActive);
                if (loggedTaskInfo != null)
                {
                    loggedTaskInfo.IsDeleted = true;
                    loggedTaskInfo.IsActive = false;
                    loggedTaskInfo.LastModifiedDate = DateTime.UtcNow;
                    loggedTaskInfo.LastModifiedBy = userId;
                    finalLoggedTaskInfo.IsDeleted = true;
                    finalLoggedTaskInfo.IsActive = false;
                    finalLoggedTaskInfo.LastModifiedDate = DateTime.UtcNow;
                    finalLoggedTaskInfo.LastModifiedBy = userId;
                    var timeSheetInfo = context.TimeSheetTaskMappings.FirstOrDefault(a => a.TaskId == taskId);
                    if (timeSheetInfo != null)
                        timeSheetInfo.TimeSheet.TotalHoursLogged = timeSheetInfo.TimeSheet.TotalHoursLogged -
                                                                   loggedTaskInfo.TimeSpent;

                }

                context.SaveChanges();

                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.DeleteLoggedTask, userId, 0);

                return true;
            }
        }

        /// <summary>
        /// Submit Weekly TimeSheet
        /// </summary>
        /// <param name="timeSheet"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public int SubmitWeeklyTimeSheet(BO.TimeSheet timeSheet, string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                var timeSheetInfo = context.TimeSheets.FirstOrDefault(t => t.WeekNo == timeSheet.WeekNo && t.StartDate == timeSheet.StartDate && t.CreatedBy == userId);

                if (timeSheetInfo != null)
                {
                    // Check TimeSheet is Blank or not.
                    var flag = false;
                    var getTimeSheetMapping = context.TimeSheetTaskMappings.Where(x => x.TimeSheetId == timeSheetInfo.TimeSheetId).ToList();
                    foreach (var item in getTimeSheetMapping)
                    {
                        var loggedTask = context.FinalLoggedTasks.Where(x => x.MappingId == item.RecordId && x.IsDeleted == false && x.IsActive == true).ToList();
                        if (loggedTask.Count > 0)
                        {
                            flag = true;
                            break;
                        }
                    }
                    if (!flag)
                        return 3;
                    if (timeSheetInfo.Status == (int)Enums.TimesheetStatus.Submitted)
                        return 2;

                    timeSheetInfo.Status = (int)Enums.TimesheetStatus.Submitted;
                    timeSheetInfo.UserRemarks = timeSheet.UserRemarks;
                    timeSheetInfo.SubmittedDate = DateTime.Now;
                    timeSheetInfo.IsTimeSheetEnabled = false;
                    //send acknowlengement email if timesheet is filled on time
                    var g = timeSheet.EndDate.Value.AddDays(-2).Date;
                    if (DateTime.Now.Date <= timeSheet.EndDate.Value.AddDays(-2).Date)
                    {
                        var weekDetail = string.Format("week # {0}", timeSheet.WeekNo);
                        var userInfo = context.UserDetails.FirstOrDefault(f => f.UserId == userId);
                        var toEmailId = CryptoHelper.Decrypt(userInfo.EmailId);
                        var employeeFirstName = userInfo.FirstName;
                        var emailTemplate = context.EmailTemplates.FirstOrDefault(f => f.TemplateName == "TimeSheet Submission Acknowledgement" && f.IsActive && !f.IsDeleted);
                        if (emailTemplate != null)
                        {
                            var body = emailTemplate.Template.Replace("[Name]", employeeFirstName).Replace("[WeekInfo]", weekDetail);
                            var subject = string.Format("Timesheet acknowledgment for {0}", weekDetail);
                            EmailHelper.SendEmailWithDefaultParameter(subject, body, true, true, toEmailId, null, null, null);
                        }
                    }
                    // Logging 
                    _userServices.SaveUserLogs(ActivityMessages.SubmitWeeklyTimeSheet, userId, 0);

                    context.SaveChanges();
                    return 1;
                }
                else
                    return 3;
            }
        }

        /// <summary>
        /// Copy TimeSheet From Week
        /// </summary>
        /// <param name="year"></param>
        /// <param name="fromWeek"></param>
        /// <param name="toWeek"></param>
        /// <param name="startDate"></param>
        /// <param name="endDate"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public bool CopyTimeSheetFromWeek(int year, int fromWeek, int toWeek, string startDate, string endDate, string userAbrhs)
        {
            int ToTimesheetYear = DateTime.Parse(endDate).Year;

            long toTimeSheetId = 0;
            long fromTimeSheetId = 0;
            //var tasks = new List<BO.LoggedTask>();

            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                var fromTimeSheet = context.TimeSheets.FirstOrDefault(f => f.WeekNo == fromWeek && f.Year == year && f.CreatedBy == userId);

                if (fromTimeSheet != null) // time sheet found for source week
                {
                    fromTimeSheetId = fromTimeSheet.TimeSheetId;
                }
                else  // time sheet not found for source week
                {
                    fromTimeSheetId = 0;
                }
                var modelTimeSheet = new Model.TimeSheet();
                var toTimeSheet = context.TimeSheets.FirstOrDefault(f => f.WeekNo == toWeek && f.Year == ToTimesheetYear && f.CreatedBy == userId);
                if (toTimeSheet == null) // time sheet not found for current week
                {
                    var weekInfo = context.spFetchWeekInfo(userId, TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, TimeZoneInfo.FindSystemTimeZoneById("India Standard Time"))).FirstOrDefault();
                    //var weekInfo = context.spFetchWeekInfo(userId, Convert.ToDateTime(startDate)).FirstOrDefault();
                    if (weekInfo != null)
                    {
                        var sDate = weekInfo.StartDate.GetValueOrDefault();
                        var eDate = weekInfo.EndDate;
                        if (weekInfo.WeekNo != toWeek)
                        {
                            if (weekInfo.WeekNo != null)
                            {
                                double sub = (toWeek - weekInfo.WeekNo.Value) * 7;
                                sDate = weekInfo.StartDate.GetValueOrDefault().AddDays(sub);
                                if (weekInfo.EndDate != null) eDate = weekInfo.EndDate.Value.AddDays(sub);
                            }
                        }
                        var timeSheetInfo = new BO.TimeSheet
                        {
                            WeekNo = toWeek,
                            Year = ToTimesheetYear,
                            TotalHoursLogged = 0,
                            StartDate = sDate,
                            EndDate = eDate,
                            CreatedDate = DateTime.UtcNow,
                            CreatedBy = userId
                        };
                        modelTimeSheet = Convertor.Convert<Model.TimeSheet, BO.TimeSheet>(timeSheetInfo);
                        context.TimeSheets.Add(modelTimeSheet);//AddObject
                        context.SaveChanges();
                        toTimeSheetId = modelTimeSheet.TimeSheetId;

                    }
                    else
                    {
                        return false;
                    }
                }
                else // time sheet found for current week
                {
                    modelTimeSheet = toTimeSheet;
                    toTimeSheetId = toTimeSheet.TimeSheetId;
                    var deleteTaskIds = context.TimeSheetTaskMappings.Where(f => f.TimeSheetId == toTimeSheetId).ToList();
                    foreach (var deleteTaskId in deleteTaskIds)
                    {
                        var loggedTask = context.LoggedTasks.FirstOrDefault(f => f.TaskId == deleteTaskId.TaskId);
                        var finalLoggedTask = context.FinalLoggedTasks.FirstOrDefault(f => f.MappingId == deleteTaskId.RecordId);
                        if (loggedTask != null)
                        {
                            loggedTask.IsActive = false;
                            loggedTask.IsDeleted = true;
                            loggedTask.TimeSpent = 0;
                        }
                        if (finalLoggedTask != null)
                        {
                            finalLoggedTask.IsActive = false;
                            finalLoggedTask.IsDeleted = true;
                            finalLoggedTask.TimeSpent = 0;
                        }
                    }
                    context.SaveChanges();
                }

                var taskIds = context.TimeSheetTaskMappings.Where(f => f.TimeSheetId == fromTimeSheetId).ToList();
                int weekDifference = 0;
                if (ToTimesheetYear != year)
                {
                    var weekData = context.Proc_GetCalendarForWeekOff(userId, 12, year).ToList();
                    var lastWeekOfPerviousMonth = (from t in weekData where t.Year == year select t).Max(t => t.Week);

                    if (lastWeekOfPerviousMonth != null)
                    {
                        weekDifference = ((int)lastWeekOfPerviousMonth - fromWeek) + toWeek;
                        //if (lastWeekOfPerviousMonth.EndDate.Value.Year == ToTimesheetYear)
                        //{
                        //    weekDifference--;
                        //}
                    }
                    else
                        return false;
                }
                else
                    weekDifference = toWeek - fromWeek;
                var addDays = (weekDifference) * 7;

                modelTimeSheet.TotalHoursLogged = 0;
                foreach (var taskId in taskIds)
                {
                    var loggedTaskInfo = context.LoggedTasks.FirstOrDefault(f => f.TaskId == taskId.TaskId && !f.IsDeleted && f.IsActive);
                    if (loggedTaskInfo != null)
                    {
                        var taskInfo = new BO.LoggedTask
                        {

                            Date = loggedTaskInfo.Date.AddDays(addDays),
                            ProjectId = loggedTaskInfo.ProjectId,
                            Description = loggedTaskInfo.Description,
                            TaskTeamId = loggedTaskInfo.TaskTeamId,
                            TaskTypeId = loggedTaskInfo.TaskTypeId,
                            TaskSubDetail1Id = (loggedTaskInfo.TaskSubDetail1Id == 0 ? 1 : loggedTaskInfo.TaskSubDetail1Id),
                            TaskSubDetail2Id = (loggedTaskInfo.TaskSubDetail2Id == 0 ? 1 : loggedTaskInfo.TaskSubDetail2Id),
                            TimeSpent = loggedTaskInfo.TimeSpent,
                            IsActive = true,
                            IsDeleted = false,
                            CreatedDate = DateTime.UtcNow,
                            CreatedBy = userId
                        };

                        var modelTask = Convertor.Convert<Model.LoggedTask, BO.LoggedTask>(taskInfo);
                        var modelFinalTask = Convertor.Convert<Model.FinalLoggedTask, BO.LoggedTask>(taskInfo);

                        modelTimeSheet.TotalHoursLogged = modelTimeSheet.TotalHoursLogged + loggedTaskInfo.TimeSpent;

                        context.LoggedTasks.Add(modelTask);//AddObject
                        context.SaveChanges();

                        var mapping = new BO.TimeSheetTaskMapping
                        {
                            TimeSheetId = toTimeSheetId,
                            TaskId = modelTask.TaskId,
                            ConsiderInClientReports = true
                        };
                        var modelMapping =
                            Convertor.Convert<Model.TimeSheetTaskMapping, BO.TimeSheetTaskMapping>(mapping);
                        modelFinalTask.MappingId = modelMapping.RecordId;
                        context.TimeSheetTaskMappings.Add(modelMapping); //AddObject
                        context.FinalLoggedTasks.Add(modelFinalTask); //AddObject
                        context.SaveChanges();
                    }
                }

                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.CopyTimeSheetFromWeek, userId, 0);

                return true;
            }
        }

        #endregion

        /// <summary>
        /// ListWeeks For Copy TimeSheet
        /// </summary>
        /// <param name="year"></param>
        /// <param name="week"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<int> ListWeeksForCopyTimeSheet(int year, int week, string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                var results = context.TimeSheets.Where(f => f.Year == year && f.WeekNo != week && f.CreatedBy == userId && f.TotalHoursLogged > 0).GroupBy(g => g.WeekNo).Select(grp => grp.FirstOrDefault()).Select(s => s.WeekNo).ToList();
                return results.OrderByDescending(s => s).ToList();
            }
        }

        #region Reports

        /// <summary>
        /// Generate Timesheet Report
        /// </summary>
        /// <param name="team"></param>
        /// <param name="year"></param>
        /// <param name="week"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public bool GenerateTimesheetReport(string team, int year, int week, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            string attachment = string.Empty;
            var teamIdList = CustomExtensions.SplitToLongList(team);
            var folderPath = Path.Combine("C:\\", "Reports", userId.ToString());
            if (!Directory.Exists(folderPath))
            {
                Directory.CreateDirectory(folderPath);
            }
            using (var context = new MISEntities())
            {
                //List<Model.TimeSheetReportAccess> teams = new List<Model.TimeSheetReportAccess>();
                //if (team != "All Teams")
                //{
                //     teams = context.TimeSheetReportAccesses.Where(f => f.UserId == userId && f.IsActive && teamIdList.Contains(f.TeamId)).ToList();
                //}
                //else
                //{
                //     teams = context.TimeSheetReportAccesses.Where(f => f.UserId == userId && f.IsActive).ToList();
                //}

                //    foreach (var t in teams)
                //    {
                //        var teamInfo = context.Teams.FirstOrDefault(f => f.TeamId == t.TeamId);

                //        if (teamInfo != null)
                //        {
                //            var weekInfo = context.spFetchTeamWeeks(teamInfo.TeamName).FirstOrDefault(f => f.WeekNo == week);

                //            var header = string.Format("Week # {0} ( {1} - {2} )", week, weekInfo.StartDate.GetValueOrDefault().ToString(" dd-MM-yyyy"),
                //            weekInfo.EndDate.GetValueOrDefault().ToString("dd-MM-yyyy"));

                //            Telerik.Reporting.Report teamWiseWeekWiseTimeSheetReportForClient = new MISScheduler.ReportingLibrary.Client.TeamWiseReportToWiseWeeklyActivityReport();

                //            teamWiseWeekWiseTimeSheetReportForClient.ReportParameters["WeekNo"].Value = week;
                //            teamWiseWeekWiseTimeSheetReportForClient.ReportParameters["Year"].Value = year;
                //            teamWiseWeekWiseTimeSheetReportForClient.ReportParameters["TeamName"].Value = teamInfo.TeamName;
                //            teamWiseWeekWiseTimeSheetReportForClient.ReportParameters["SubHeaderString"].Value = header;
                //            teamWiseWeekWiseTimeSheetReportForClient.ReportParameters["UserId"].Value = userId;
                //            ExportToPDF(teamWiseWeekWiseTimeSheetReportForClient, week, folderPath, true);

                //            Telerik.Reporting.Report teamWiseWeekWiseTimeSheetReportForInternal = new MISScheduler.ReportingLibrary.Internal.TeamWiseReportToWiseWeeklyActivityReport();

                //            teamWiseWeekWiseTimeSheetReportForInternal.ReportParameters["WeekNo"].Value = week;
                //            teamWiseWeekWiseTimeSheetReportForInternal.ReportParameters["Year"].Value = year;
                //            teamWiseWeekWiseTimeSheetReportForInternal.ReportParameters["TeamName"].Value = teamInfo.TeamName;
                //            teamWiseWeekWiseTimeSheetReportForInternal.ReportParameters["SubHeaderString"].Value = header;
                //            teamWiseWeekWiseTimeSheetReportForInternal.ReportParameters["UserId"].Value = userId;
                //            ExportToPDF(teamWiseWeekWiseTimeSheetReportForInternal, week, folderPath, false);

                //            if (string.IsNullOrWhiteSpace(attachment))
                //            {
                //                attachment = folderPath + "\\" + teamInfo.TeamName + "_Client_Week#" + week + ".pdf;" + folderPath + "\\" + teamInfo.TeamName + "_Internal_Week#" + week + ".pdf";
                //            }
                //            else
                //            {
                //                attachment = attachment + ";" + folderPath + "\\" + teamInfo.TeamName + "_Client_Week#" + week + ".pdf;" + folderPath + "\\" + teamInfo.TeamName + "_Internal_Week#" + week + ".pdf";
                //            }
                //        }
                //}
                //if (!string.IsNullOrWhiteSpace(attachment))
                //{
                //    var userDetail = context.UserDetails.FirstOrDefault(f => f.UserId == userId);

                //    var eEmailid ="chandra.prakash@geminisolutions.in";//CryptoHelper.Decrypt(userDetail.EmailId);

                //    var emailTemplate = context.EmailTemplates.FirstOrDefault(f => f.TemplateName == "Generate Timesheet Report" && f.IsActive && !f.IsDeleted);
                //    if (emailTemplate != null)
                //    {
                //        var body = emailTemplate.Template.Replace("[Name]", userDetail.FirstName).Replace("[Week]", week.ToString());
                //        Utilities.EmailHelper.sendMail("smtp.gmail.com", 587, true, "Team, MIS", "mis@geminisolutions.in", "Mis@12345", "Time Sheet Reports for Week # " + week, body, true, true, eEmailid, null, null, attachment);
                //        string[] files = Directory.GetFiles(folderPath, "*.*");
                //        foreach (var file in files)
                //        {
                //            File.Delete(file);
                //        }
                //    }
                //}
                return true;
            }
        }

        //void ExportToPDF(Telerik.Reporting.Report reportToExport, int week, string folderPath, bool isClient)
        //{
        //    ReportProcessor reportProcessor = new ReportProcessor();
        //    Telerik.Reporting.InstanceReportSource instanceReportSource = new Telerik.Reporting.InstanceReportSource();
        //    instanceReportSource.ReportDocument = reportToExport;
        //    RenderingResult result = reportProcessor.RenderReport("PDF", instanceReportSource, null);
        //    string fileName;
        //    if (isClient)
        //    {
        //        fileName = result.DocumentName + "_Client_Week#" + week + "." + result.Extension;
        //    }
        //    else
        //    {
        //        fileName = result.DocumentName + "_Internal_Week#" + week + "." + result.Extension;
        //    }
        //    string filePath = System.IO.Path.Combine(folderPath, fileName);

        //    using (System.IO.FileStream fs = new System.IO.FileStream(filePath, System.IO.FileMode.Create))
        //    {
        //        fs.Write(result.DocumentBytes, 0, result.DocumentBytes.Length);
        //    }
        //}

        #endregion

        #region DashBoard

        /// <summary>
        /// Fetch Pending TimeSheets
        /// </summary>
        /// <param name="weekNo"></param>
        /// <param name="year"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<PendingTimeSheets> FetchPendingTimeSheets(int weekNo, int year, string userAbrhs, string menuAbrhs)
        {
            using (var context = new MISEntities())
            {
                List<PendingTimeSheets> pendingTimeSheetsList = new List<BO.PendingTimeSheets>();

                List<int> ReportTo = new List<int>();
                var userId = 0;
                var menuId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                if (menuAbrhs != null)
                {
                    Int32.TryParse(CryptoHelper.Decrypt(menuAbrhs), out menuId);
                }
                ReportTo.Add(userId);
                //check and take User Ids.
                var UserIdList = context.MenusUserDelegations.Where(x => x.MenuId == menuId && x.DelegatedToUserId == userId && x.IsActive
                    && System.Data.Entity.DbFunctions.TruncateTime(DateTime.Now) >= System.Data.Entity.DbFunctions.TruncateTime(x.DelegatedFromDate)
                    && System.Data.Entity.DbFunctions.TruncateTime(DateTime.Now) <= System.Data.Entity.DbFunctions.TruncateTime(x.DelegatedTillDate)
                    ).Select(x => new { UserId = x.DelegatedFromUserId }).GroupBy(x => new { x.UserId }).ToList();
                if (UserIdList.Any())
                {
                    ReportTo.AddRange(UserIdList.Select(x => x.Key.UserId));
                }

                foreach (var item in ReportTo)
                {
                    var timeSheets = context.spFetchPendingTimeSheets(weekNo, year, item);
                    var result = new List<PendingTimeSheets>();
                    foreach (var timeSheet in timeSheets)
                    {
                        var fr = new PendingTimeSheets
                        {
                            EmployeeName = timeSheet.EmployeeName,
                            ManagerName = timeSheet.ManagerName,
                            Applicant = timeSheet.Applicant,
                            Reviewer = timeSheet.Reviewer
                        };
                        result.Add(fr);
                    }
                    pendingTimeSheetsList.AddRange(result);
                }

                return pendingTimeSheetsList;
            }
        }

        /// <summary>
        /// Fetch Completed TimeSheets
        /// </summary>
        /// <param name="weekNo"></param>
        /// <param name="year"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<CompletedTimeSheets> FetchCompletedTimeSheets(int weekNo, int year, string userAbrhs, string menuAbrhs)
        {
            using (var context = new MISEntities())
            {
                List<CompletedTimeSheets> completedTimeSheetsList = new List<CompletedTimeSheets>();

                List<int> ReportTo = new List<int>();
                var userId = 0;
                var menuId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                if (menuAbrhs != null)
                {
                    Int32.TryParse(CryptoHelper.Decrypt(menuAbrhs), out menuId);
                }
                ReportTo.Add(userId);
                //check and take User Ids.
                var UserIdList = context.MenusUserDelegations.Where(x => x.MenuId == menuId && x.DelegatedToUserId == userId && x.IsActive
                    && System.Data.Entity.DbFunctions.TruncateTime(DateTime.Now) >= System.Data.Entity.DbFunctions.TruncateTime(x.DelegatedFromDate)
                    && System.Data.Entity.DbFunctions.TruncateTime(DateTime.Now) <= System.Data.Entity.DbFunctions.TruncateTime(x.DelegatedTillDate)
                    ).Select(x => new { UserId = x.DelegatedFromUserId }).GroupBy(x => new { x.UserId }).ToList();
                if (UserIdList.Any())
                {
                    ReportTo.AddRange(UserIdList.Select(x => x.Key.UserId));
                }

                foreach (var item in ReportTo)
                {
                    var timeSheets = context.spFetchCompletedTimeSheets(weekNo, year, userId);
                    var result = new List<CompletedTimeSheets>();
                    foreach (var timeSheet in timeSheets)
                    {
                        var fr = new CompletedTimeSheets
                        {
                            EmployeeName = timeSheet.EmployeeName,
                            ManagerName = timeSheet.ManagerName,
                            TotalHoursLogged = timeSheet.TotalHoursLogged.GetValueOrDefault()
                        };
                        result.Add(fr);
                    }
                    completedTimeSheetsList.AddRange(result);
                }

                return completedTimeSheetsList;
            }
        }

        #endregion

        #region TimeSheet Data Verification

        /// <summary>
        /// List Approved Tasks
        /// </summary>
        /// <param name="weekNo"></param>
        /// <param name="year"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<BO.ApprovedTask> ListApprovedTasks(int weekNo, int year, string userAbrhs, string menuAbrhs)
        {
            using (var context = new MISEntities())
            {
                List<ApprovedTask> approvedTaskList = new List<ApprovedTask>();
                List<int> ReportTo = new List<int>();
                var userId = 0;
                var menuId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                if (menuAbrhs != null)
                {
                    Int32.TryParse(CryptoHelper.Decrypt(menuAbrhs), out menuId);
                }
                ReportTo.Add(userId);
                //check and take User Ids.
                var UserIdList = context.MenusUserDelegations.Where(x => x.MenuId == menuId && x.DelegatedToUserId == userId && x.IsActive
                    && System.Data.Entity.DbFunctions.TruncateTime(DateTime.Now) >= System.Data.Entity.DbFunctions.TruncateTime(x.DelegatedFromDate)
                    && System.Data.Entity.DbFunctions.TruncateTime(DateTime.Now) <= System.Data.Entity.DbFunctions.TruncateTime(x.DelegatedTillDate)
                    ).Select(x => new { UserId = x.DelegatedFromUserId }).GroupBy(x => new { x.UserId }).ToList();
                if (UserIdList.Any())
                {
                    ReportTo.AddRange(UserIdList.Select(x => x.Key.UserId));
                }

                foreach (var item in ReportTo)
                {
                    var approvedTasks = context.spFetchAppovedTasksForTaskVerification(item, weekNo, year).ToList();
                    var result = approvedTasks.Select(approvedTask => new ApprovedTask
                    {
                        Date = approvedTask.Date.GetValueOrDefault(),
                        MappingId = approvedTask.MappingId.GetValueOrDefault(),
                        UIDate = approvedTask.Date.GetValueOrDefault().ToString("dd-MMM-yyyy"),
                        Resource = approvedTask.Resource,
                        ResourceTeamName = approvedTask.ResourceTeamName,
                        ProjectName = approvedTask.ProjectName,
                        Description = approvedTask.Description,
                        TaskTeamName = approvedTask.TaskTeamName,
                        TaskTypeName = approvedTask.TaskTypeName,
                        TaskSubDetail1Name = approvedTask.TaskSubDetail1Name,
                        TaskSubDetail2Name = approvedTask.TaskSubDetail2Name,
                        TimeSpent = approvedTask.TimeSpent.GetValueOrDefault(),
                        ConsiderInClientReports = approvedTask.ConsiderInClientReports.GetValueOrDefault()
                    }).ToList();

                    approvedTaskList.AddRange(result);
                }

                return approvedTaskList.OrderBy(o => o.Date).ThenBy(o => o.Resource).ThenBy(o => o.Description).ToList();
            }
        }

        /// <summary>
        /// Fetch Approved TaskInfo
        /// </summary>
        /// <param name="mappingId"></param>
        /// <returns></returns>
        public BO.TaskInfo FetchApprovedTaskInfo(long mappingId)
        {
            using (var context = new MISEntities())
            {
                var approvedTask = context.vwTasksForTaskVerifications.FirstOrDefault(f => f.MappingId == mappingId);
                if (approvedTask != null)
                {
                    var taskInfo = new BO.TaskInfo
                    {
                        TaskId = approvedTask.TaskId,
                        MappingId = approvedTask.MappingId,
                        Date = approvedTask.Date.GetValueOrDefault(),
                        UIDate = approvedTask.Date.GetValueOrDefault().ToString("MM/dd/yyyy"),
                        Resource = approvedTask.Resource,
                        ProjectId = approvedTask.ProjectId,
                        ProjectName = approvedTask.ProjectName,
                        Description = approvedTask.Description,
                        TaskTeamId = approvedTask.TaskTeamId,
                        TaskTeamName = approvedTask.TaskTeamName,
                        TaskTypeId = approvedTask.TaskTypeId,
                        TaskTypeName = approvedTask.TaskTypeName,
                        TaskSubDetail1Id = approvedTask.TaskSubDetail1Id == 0 ? 1 : approvedTask.TaskSubDetail1Id,
                        TaskSubDetail1Name = approvedTask.TaskSubDetail1Name,
                        TaskSubDetail2Id = approvedTask.TaskSubDetail2Id == 0 ? 1 : approvedTask.TaskSubDetail2Id,
                        TaskSubDetail2Name = approvedTask.TaskSubDetail2Name,
                        TimeSpent = approvedTask.TimeSpent.GetValueOrDefault(),
                        ConsiderInClientReports = approvedTask.ConsiderInClientReports
                    };
                    return taskInfo;
                }
                return null;
            }
        }

        /// <summary>
        /// List All Projects
        /// </summary>
        /// <returns></returns>
        public List<BO.GeminiProject> ListAllProjects()
        {
            using (var context = new MISEntities())
            {

                var activeProjects = context.Projects.Where(f => f.IsActive && !f.IsDeleted);
                var result = activeProjects.Select(project => new BO.GeminiProject
                {
                    ProjectId = project.ProjectId,
                    Name = project.Name,
                    CreatedDate = project.CreatedDate,
                    StartDate = project.StartDate,
                    EndDate = project.EndDate,
                    Description = project.Description
                }).ToList();
                return result.OrderBy(o => o.Name).ToList();
            }
        }

        /// <summary>
        /// Change TaskStatus
        /// </summary>
        /// <param name="mappingId"></param>
        /// <returns></returns>
        public bool ChangeTaskStatus(long mappingId)
        {
            using (var context = new MISEntities())
            {
                var existingStatus = context.TimeSheetTaskMappings.FirstOrDefault(f => f.RecordId == mappingId);
                if (existingStatus != null)
                {
                    existingStatus.ConsiderInClientReports = !existingStatus.ConsiderInClientReports;
                }
                context.SaveChanges();
                return true;
            }
        }

        /// <summary>
        /// Overwrite Logged Task
        /// </summary>
        /// <param name="finalLoggedTask"></param>
        /// <returns></returns>
        public bool OverwriteLoggedTask(BO.FinalLoggedTask finalLoggedTask)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(finalLoggedTask.userAbrhs), out userId);
                finalLoggedTask.LastModifiedBy = userId;
                finalLoggedTask.LastModifiedDate = DateTime.Now;
                finalLoggedTask.CreatedBy = userId;
                var existingFinalTask =
                    context.FinalLoggedTasks.FirstOrDefault(f => f.MappingId == finalLoggedTask.MappingId && f.IsActive && !f.IsDeleted);
                // delete existing over written task
                if (existingFinalTask != null)
                {
                    existingFinalTask.IsActive = false;
                    existingFinalTask.IsDeleted = true;
                    existingFinalTask.LastModifiedBy = finalLoggedTask.CreatedBy;
                    existingFinalTask.LastModifiedDate = DateTime.UtcNow;
                }
                context.SaveChanges();

                // check for changed parameters and save data
                var finalTask = new BO.FinalLoggedTask
                {
                    Date = finalLoggedTask.Date,
                    MappingId = finalLoggedTask.MappingId,
                    ProjectId = finalLoggedTask.ProjectId,
                    Description = finalLoggedTask.Description,
                    TaskTeamId = finalLoggedTask.TaskTeamId,
                    TaskTypeId = finalLoggedTask.TaskTypeId,
                    TaskSubDetail1Id = finalLoggedTask.TaskSubDetail1Id == 0 ? 1 : finalLoggedTask.TaskSubDetail1Id,
                    TaskSubDetail2Id = finalLoggedTask.TaskSubDetail2Id == 0 ? 1 : finalLoggedTask.TaskSubDetail2Id,
                    TimeSpent = finalLoggedTask.TimeSpent,
                    IsActive = true,
                    IsDeleted = false,
                    CreatedDate = DateTime.UtcNow,
                    CreatedBy = finalLoggedTask.CreatedBy
                };

                var existingFinalTask1 =
                context.FinalLoggedTasks.FirstOrDefault(f => f.MappingId == finalLoggedTask.MappingId && f.IsActive && !f.IsDeleted);

                if (existingFinalTask1 == null)
                {
                    context.FinalLoggedTasks.Add(Convertor.Convert<Model.FinalLoggedTask, BO.FinalLoggedTask>(finalTask));
                }

                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.OverwriteLoggedTask, userId, 0);

                context.SaveChanges();
                return true;
            }
        }

        #endregion

        #region Review TimeSheet

        /// <summary>
        /// Fetch TimeSheet Pending for Approval
        /// </summary>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<OtherEmployeesTimeSheet> FetchTimeSheetPendingforApproval(string userAbrhs, string menuAbrhs)
        {
            using (var context = new MISEntities())
            {
                List<int> reportsToList = new List<int>();
                var userId = 0;
                var menuId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                if (menuAbrhs != null)
                {
                    Int32.TryParse(CryptoHelper.Decrypt(menuAbrhs), out menuId);
                }
                reportsToList.Add(userId);
                //check and take User Ids.
                var UserIdList = context.MenusUserDelegations.Where(x => x.MenuId == menuId && x.DelegatedToUserId == userId && x.IsActive
                    && System.Data.Entity.DbFunctions.TruncateTime(DateTime.Now) >= System.Data.Entity.DbFunctions.TruncateTime(x.DelegatedFromDate)
                    && System.Data.Entity.DbFunctions.TruncateTime(DateTime.Now) <= System.Data.Entity.DbFunctions.TruncateTime(x.DelegatedTillDate)
                    ).Select(x => new { UserId = x.DelegatedFromUserId }).GroupBy(x => new { x.UserId }).ToList();
                if (UserIdList.Any())
                {
                    reportsToList.AddRange(UserIdList.Select(x => x.Key.UserId));
                }

                var currentWeekInfo = context.spFetchWeekInfo(userId, DateTime.Now.Date).FirstOrDefault();
                int weekNo = 0;
                if (currentWeekInfo != null && currentWeekInfo.WeekNo.HasValue)
                    weekNo = currentWeekInfo.WeekNo.Value;
                var pendingTimeSheetList = (from t in context.TimeSheets
                                            join ud in context.UserDetails on t.CreatedBy equals ud.UserId
                                            where t.Status == (int)Enums.TimesheetStatus.Submitted && reportsToList.Contains(ud.ReportTo.HasValue ? ud.ReportTo.Value : 0)
                                            select new BO.OtherEmployeesTimeSheet
                                            {
                                                TimeSheetId = t.TimeSheetId,
                                                FirstName = ud.FirstName,
                                                LastName = ud.LastName,
                                                Year = t.Year,
                                                WeekNo = t.WeekNo,
                                                StartDate = t.StartDate,
                                                EndDate = t.EndDate,
                                                SubmittedDate = t.SubmittedDate,
                                                TotalHoursLogged = t.TotalHoursLogged,
                                                UserRemarks = t.UserRemarks,
                                                CreatedDate = t.CreatedDate,
                                                CreatedBy = t.CreatedBy,
                                                CurrentWeekNo = weekNo
                                            }).ToList().OrderByDescending(o => o.StartDate);
                foreach (var sheet in pendingTimeSheetList)
                {
                    sheet.DisplayStartDate = sheet.StartDate.ToString("dd-MMM-yyyy");
                    sheet.DisplayEndDate = sheet.EndDate.GetValueOrDefault().ToString("dd-MMM-yyyy");
                    sheet.DisplaySubmissionTime = (sheet.SubmittedDate != null) ? sheet.SubmittedDate < new DateTime(2016, 10, 12) ? sheet.SubmittedDate.Value.ToLocalTime().ToString("dd-MMM-yyyy HH:mm tt") : sheet.SubmittedDate.GetValueOrDefault().ToString("dd-MMM-yyyy HH:mm tt") : "NA";
                    sheet.WeekDiffrence = (sheet.SubmittedDate != null) ? (context.spFetchWeekInfo(userId, sheet.SubmittedDate).FirstOrDefault().WeekNo.Value - sheet.WeekNo) : 0;
                }
                var result = pendingTimeSheetList.ToList();
                return result;

            }
        }

        /// <summary>
        /// Fetch TimeSheets Approved
        /// </summary>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<OtherEmployeesTimeSheet> FetchTimeSheetsApproved(int years, string weekNos, string reportingUserIds, string userAbrhs, string menuAbrhs)
        {
            using (var context = new MISEntities())
            {
                List<int> ReportTo = new List<int>();
                var userId = 0;
                var menuId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                if (menuAbrhs != null)
                {
                    Int32.TryParse(CryptoHelper.Decrypt(menuAbrhs), out menuId);
                }
                ReportTo.Add(userId);
                //check and take User Ids.
                var UserIdList = context.MenusUserDelegations.Where(x => x.MenuId == menuId && x.DelegatedToUserId == userId && x.IsActive
                    && System.Data.Entity.DbFunctions.TruncateTime(DateTime.Now) >= System.Data.Entity.DbFunctions.TruncateTime(x.DelegatedFromDate)
                    && System.Data.Entity.DbFunctions.TruncateTime(DateTime.Now) <= System.Data.Entity.DbFunctions.TruncateTime(x.DelegatedTillDate)
                    ).Select(x => new { UserId = x.DelegatedFromUserId }).GroupBy(x => new { x.UserId }).ToList();
                if (UserIdList.Any())
                {
                    ReportTo.AddRange(UserIdList.Select(x => x.Key.UserId));
                }

                var empIds = MIS.Utilities.CustomExtensions.SplitUseridsToIntList(reportingUserIds).ToList();
                var weekNumbers = MIS.Utilities.CustomExtensions.SplitToIntList(weekNos).ToList();

                var pendingTimeSheetList = (from t in context.TimeSheets
                                            join ud in context.UserDetails on new { CreatedBy = t.CreatedBy } equals
                                                new { CreatedBy = ud.UserId }
                                            where t.Status == (int)Enums.TimesheetStatus.Approved && t.Year == years && empIds.Contains(t.CreatedBy) && weekNumbers.Contains(t.WeekNo)
                                            select new BO.OtherEmployeesTimeSheet
                                            {
                                                TimeSheetId = t.TimeSheetId,
                                                FirstName = ud.FirstName,
                                                LastName = ud.LastName,
                                                WeekNo = t.WeekNo,
                                                Year = t.Year,
                                                StartDate = t.StartDate,
                                                EndDate = t.EndDate,
                                                TotalHoursLogged = t.TotalHoursLogged,
                                                UserRemarks = t.UserRemarks,
                                                ApproverRemarks = t.ApproverRemarks,
                                                CreatedDate = t.CreatedDate,
                                                CreatedBy = t.CreatedBy
                                            }).OrderByDescending(o => o.StartDate).Take(25).ToList();
                foreach (var sheet in pendingTimeSheetList)
                {
                    sheet.DisplayStartDate = sheet.StartDate.ToString("dd-MMM-yyyy");
                    sheet.DisplayEndDate = sheet.EndDate.GetValueOrDefault().ToString("dd-MMM-yyyy");
                }
                var result = pendingTimeSheetList;
                return result;
            }
        }

        /// <summary>
        /// Approve TimeSheet
        /// </summary>
        /// <param name="timeSheetId"></param>
        /// <param name="remarks"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public bool ApproveTimeSheet(long timeSheetId, string remarks, string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                var timeSheetInfo = context.TimeSheets.FirstOrDefault(t => t.TimeSheetId == timeSheetId);
                if (timeSheetInfo != null)
                {
                    timeSheetInfo.Status = (int)Enums.TimesheetStatus.Approved;
                    timeSheetInfo.LastModifiedBy = userId;
                    timeSheetInfo.LastModifiedDate = DateTime.UtcNow;
                    if (!string.IsNullOrEmpty(remarks))
                    {
                        timeSheetInfo.ApproverRemarks = remarks;
                    }
                }

                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.ApproveTimeSheet, userId, 0);
                context.SaveChanges();
                return true;
            }
        }

        /// <summary>
        /// Reject TimeSheet
        /// </summary>
        /// <param name="timeSheetId"></param>
        /// <param name="remarks"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public bool RejectTimeSheet(long timeSheetId, string remarks, string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                var approverInfo = context.UserDetails.FirstOrDefault(f => f.UserId == userId);
                var timeSheetInfo = context.TimeSheets.FirstOrDefault(t => t.TimeSheetId == timeSheetId);
                if (timeSheetInfo != null)
                {
                    timeSheetInfo.Status = (int)Enums.TimesheetStatus.Rejected;
                    timeSheetInfo.LastModifiedBy = userId;
                    timeSheetInfo.LastModifiedDate = DateTime.Now;
                    timeSheetInfo.ApproverRemarks = remarks;
                    timeSheetInfo.IsTimeSheetEnabled = false;
                }
                //new code
                //var userDetail = context.UserDetails.FirstOrDefault(f => f.UserId == user.UserId);
                var user = timeSheetInfo.CreatedBy;
                var userInfo = context.UserDetails.FirstOrDefault(f => f.UserId == user);
                var email = CryptoHelper.Decrypt(userInfo.EmailId);
                var firstname = userInfo.FirstName;
                var weekno = timeSheetInfo.WeekNo;
                var emailTemplate = context.EmailTemplates.FirstOrDefault(f => f.TemplateName == EmailTemplates.RejectTimesheet && f.IsActive && !f.IsDeleted);
                var weekInfo = string.Format("Week # {0} ({1} to {2})", timeSheetInfo.WeekNo.ToString(), timeSheetInfo.StartDate.ToString("dd-MM-yyyy"), timeSheetInfo.EndDate.GetValueOrDefault().ToString("dd-MM-yyyy"));
                context.SaveChanges();
                if (emailTemplate != null)
                {
                    var body = emailTemplate.Template.Replace("[Name]", firstname).Replace("[Weeknumber]", weekInfo).Replace("[ApproverName]", approverInfo.FirstName + " " + approverInfo.LastName).Replace("[ReasonOfRejection]", timeSheetInfo.ApproverRemarks);
                    Utilities.EmailHelper.SendEmailWithDefaultParameter("Timesheet rejected for " + weekInfo, body, true, true, email, null, null, null);
                }

                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.RejectTimeSheet, userId, 0);

                return true;
            }
        }

        /// <summary>
        /// Fetch Templates For OtherUser
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public List<TaskTemplateInfo> FetchTemplatesForOtherUser(int userId)
        {
            using (var context = new MISEntities())
            {
                var templateList = (from t in context.TaskTemplates
                                    where
                                        t.CreatedBy == userId &&
                                        t.IsActive &&
                                        !t.IsDeleted
                                    select new TaskTemplateInfo
                                    {
                                        TemplateId = t.TemplateId,
                                        Name = t.Name,
                                        Description = t.Description,
                                        TeamName = t.TaskTeam.TeamName,
                                        TaskType = t.TaskType.TaskTypeName,
                                        TaskSubDetail1 = t.TaskSubDetail1.TaskSubDetail1Name,
                                        TaskSubDetail2 = t.TaskSubDetail2.TaskSubDetail2Name
                                    }).ToList();
                return templateList;
            }
        }

        #endregion

        #region timesheet subscription
        public List<BaseDropDown> ListEligibleUsersForTimesheeet(string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var category = 1;
            var data = _dbContext.Proc_FetchUserForTimesheets(userId, category).ToList();
            var result = data.Select(x => new BaseDropDown()
            {
                Text = x.EmployeeName,
                MaxValue = CryptoHelper.Encrypt(x.UserId.ToString())
            }).ToList();

            return result ?? new List<BaseDropDown>();
        }
        public List<BaseDropDown> ListExcludedUsersForTimesheeet(string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var category = 2;
            var data = _dbContext.Proc_FetchUserForTimesheets(userId, category).ToList();
            var result = data.Select(x => new BaseDropDown()
            {
                Text = x.EmployeeName,
                MaxValue = CryptoHelper.Encrypt(x.UserId.ToString())
            }).ToList();

            return result ?? new List<BaseDropDown>();
        }
        public int ChangeUserToEligibleForTimesheet(string employeeAbrhs, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var employeeId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(employeeAbrhs), out employeeId);
            var data = _dbContext.TimesheetExcludedUsers.FirstOrDefault(x => x.UserId == employeeId);
            if (data == null)
            {
                return 2;
            }
            data.IsActive = false;
            data.LastModifiedDate = DateTime.Now;
            data.LastModifiedBy = userId;
            _dbContext.SaveChanges();
            _userServices.SaveUserLogs(ActivityMessages.ChangedUserStatusForTimesheets, userId, 0);
            return 1;
        }
        public int ExcludeUserForTimesheet(string employeeAbrhs, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var employeeId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(employeeAbrhs), out employeeId);
            var data = _dbContext.TimesheetExcludedUsers.FirstOrDefault(x => x.UserId == employeeId);
            if (data == null)
            {
                var info = new BO.User
                {
                    UserId = employeeId,
                    IsActive = true,
                    CreatedDate = DateTime.Now,
                    CreatedBy = userId
                };
                _dbContext.TimesheetExcludedUsers.Add(Convertor.Convert<Model.TimesheetExcludedUser, BO.User>(info));
                _dbContext.SaveChanges();
            }
            else
            {
                data.IsActive = true;
                data.LastModifiedDate = DateTime.Now;
                data.LastModifiedBy = userId;
                _dbContext.SaveChanges();
            }
            _userServices.SaveUserLogs(ActivityMessages.ChangedUserStatusForTimesheets, userId, 0);
            return 1;
        }
        #endregion
    }
}
