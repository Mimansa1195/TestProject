using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MIS.Services.Contracts;
using MIS.Model;
using MIS.BO;
using MIS.Utilities;
using System.Xml.Linq;
using System.Data.Entity.Core.Objects;
using System.Configuration;
using System.Globalization;

namespace MIS.Services.Implementations
{
    public class TeamManagementServices : ITeamManagementServices
    {

        private readonly IUserServices _userServices;

        public TeamManagementServices(IUserServices userServices)
        {
            _userServices = userServices;
        }

        #region private member variable

        private readonly MISEntities _dbContext = new MISEntities();

        #endregion

        #region Team management


        public int AddUpdateTeamDetails(TeamInformationBO teamInformation) //1: success, 2: duplicate, 3: failure
        {
            var status = 0;

            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(teamInformation.UserAbrhs), out userId);

            var teamHeadId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(teamInformation.TeamHeadAbrhs), out teamHeadId);

            var xmlData = new XElement("Root",
                    from temp in teamInformation.TeamEmailTypeDetail
                    select new XElement("Data",
                            new XAttribute("TeamEmailTypeId", temp.TeamEmailTypeId),
                            new XAttribute("Sequence", temp.Sequence),
                            new XAttribute("Time", temp.Time.ToString()),
                            new XAttribute("WeekDayId", temp.WeekDayId),
                            new XAttribute("Week", temp.Week)
                            ));

            var result = new ObjectParameter("Success", typeof(int));

            _dbContext.spAddUpdateTeamDetails(teamInformation.TeamId, teamInformation.TeamName, teamInformation.TeamWeekDayId, teamInformation.IsReminderEmailEnabled,
                                        teamInformation.IsAttendanceEmailEnabled, teamHeadId, teamInformation.DepartmentId, teamInformation.ParentTeamId,
                                        xmlData.ToString(), userId, result); //.FirstOrDefault().Value;

            Int32.TryParse(result.Value.ToString(), out status);

            return status;
        }

        public List<TeamBO> ListAllTeams()
        {

            //var result = new List<TeamBO>();
            var teamData = _dbContext.Teams.Where(x => x.IsActive).ToList();
            var result = (from t in teamData

                          join w in _dbContext.WeekDays on t.WeekDayId equals w.WeekDayId into list1
                          from l1 in list1.DefaultIfEmpty()

                          join ud in _dbContext.UserDetails on t.TeamHeadId equals ud.UserId into list2
                          from l2 in list2.DefaultIfEmpty()

                          join d in _dbContext.Departments on t.DepartmentId equals d.DepartmentId into list3
                          from l3 in list3.DefaultIfEmpty()

                          select new TeamBO
                          {
                              TeamId = t.TeamId,
                              TeamAbrhs = CryptoHelper.Encrypt(t.TeamId.ToString()),
                              TeamName = t.TeamName,
                              WeekStartDay = l1.WeekDayName,
                              TeamHead = l2.FirstName + " " + l2.LastName,
                              Department = l3.DepartmentName,
                              ParentTeam = ((teamData.Where(x => x.TeamId == t.ParentTeamId).FirstOrDefault() == null) ? "" : teamData.Where(x => x.TeamId == t.ParentTeamId).FirstOrDefault().TeamName),
                              IsReminderEmailsEnabled = t.IsReminderEmailsEnabled,
                              IsAttendanceEmailsEnabled = t.IsAttendanceEmailsEnabled,
                              IsActive = t.IsActive,
                              IsDeleted = t.IsDeleted,

                              WeekStartDayId = t.WeekDayId,
                              DepartmentId = t.DepartmentId,
                              ParentTeamId = t.ParentTeamId,
                              TeamHeadAbrhs = CryptoHelper.Encrypt(t.TeamHeadId.ToString()),
                              UserAbrhs = CryptoHelper.Encrypt(l2.UserId.ToString())

                              //TeamEmailTypeDetail = (from te in _dbContext.TeamEmailTypeMappings.Where(x => x.IsActive && x.TeamId == t.TeamId).ToList()
                              //                       join tet in _dbContext.TeamEmailTypes on te.TeamEmailTypeId equals tet.TeamEmailTypeId into ilist1
                              //                       from il1 in ilist1.DefaultIfEmpty()
                              //                       select new TeamEmailTypeMappingTrn
                              //                           {
                              //                               TeamId = te.TeamId,
                              //                               MappingId = te.MappingId,
                              //                               TeamEmailTypeName = il1.TeamEmailTypeName,
                              //                               TeamEmailValue = l1.WeekDayName + " @ " + te.Time.ToString().Substring(0, 5) + " hrs",
                              //                               TeamEmailTypeId = te.TeamEmailTypeId,
                              //                               Sequence = te.Sequence,
                              //                               WeekDayId = te.WeekDayId,
                              //                               Week = te.Week,
                              //                               Time = te.Time
                              //                           }
                              //                        ).ToList()

                          }).OrderBy(x => x.TeamId).ToList();

            return result;

        }

        /// <summary>
        /// Method to fetch Team EmailType Mapping data by teamAbrhs
        /// </summary>
        /// <param name="teamAbrhs">teamAbrhs</param>
        /// <returns>TeamEmailTypeMappingTrn List</returns>
        public List<TeamEmailTypeMappingTrn> FetchTeamEmailTypeMapping(string teamAbrhs)
        {
            var teamId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(teamAbrhs), out teamId);

            var data = (from te in _dbContext.TeamEmailTypeMappings.Where(x => x.IsActive && x.TeamId == teamId).ToList()
                        join tet in _dbContext.TeamEmailTypes on te.TeamEmailTypeId equals tet.TeamEmailTypeId into ilist1
                        from il1 in ilist1.DefaultIfEmpty()
                        join w in _dbContext.WeekDays on te.WeekDayId equals w.WeekDayId into list1
                        from l1 in list1.DefaultIfEmpty()
                        select new TeamEmailTypeMappingTrn
                        {
                            TeamId = te.TeamId,
                            MappingId = te.MappingId,
                            TeamEmailTypeName = il1.TeamEmailTypeName,
                            TeamEmailValue = l1.WeekDayName + " @ " + te.Time.ToString().Substring(0, 5) + " hrs",
                            TeamEmailTypeId = te.TeamEmailTypeId,
                            Sequence = te.Sequence,
                            WeekDayId = te.WeekDayId,
                            Week = te.Week,
                            Time = te.Time
                        }).ToList();

            return data;
        }

        public TeamBO FetchTeamByTeamId(string teamAbrhs)
        {
            var teamId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(teamAbrhs), out teamId);

            var team = _dbContext.Teams.FirstOrDefault(f => f.IsActive && !f.IsDeleted && f.TeamId == teamId);
            if (team != null)
            {
                var user = _dbContext.Users.Where(a => a.IsActive && a.UserId == team.TeamHeadId).FirstOrDefault();
                if (user != null)
                {
                    var teamHeadId = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == team.TeamHeadId && x.TerminateDate == null);
                    var departmentId = _dbContext.Departments.FirstOrDefault(x => x.DepartmentId == team.DepartmentId);
                    var parentTeamId = _dbContext.Teams.FirstOrDefault(x => x.TeamId == team.ParentTeamId && x.IsActive);
                }

                //return new TeamBO {
                //    TeamName = team.TeamName,
                //    TeamId = team.TeamId,
                //    TeamAbrhs = CryptoHelper.Encrypt(team.TeamId.ToString()),
                //    WeekTypeId = team.WeekTypeId,
                //    AcknowledgementDay = team.AcknowledgementDay,
                //    AcknowledgementTime = team.AcknowledgementTime,
                //    Reminder1Day = team.Reminder1Day,
                //    Reminder1Time = team.Reminder1Time,
                //    Reminder1Week = team.Reminder2Week,
                //    Reminder1CopyToManager = team.Reminder1CopyToManager,
                //    Reminder2Day = team.Reminder2Day,
                //    Reminder2Time = team.Reminder2Time,
                //    Reminder2Week = team.Reminder2Week,
                //    Reminder2CopyToManager = team.Reminder2CopyToManager,
                //    Reminder3Day = team.Reminder3Day,
                //    Reminder3Time = team.Reminder3Time,
                //    Reminder3Week = team.Reminder3Week,
                //    Reminder3CopyToManager = team.Reminder3CopyToManager,
                //    DashboardDay = team.DashboardDay,
                //    DashboardTime = team.DashboardTime,
                //    DashboardWeek = team.DashboardWeek,
                //    ReportDay = team.ReportDay,
                //    ReportTime = team.ReportTime,
                //    ReportWeek = team.ReportWeek,
                //    ReportCCEmailIds = team.ReportCCEmailIds,
                //    TeamHeadAbrhs = CryptoHelper.Encrypt(teamHeadId.ToString()),
                //    TeamHeadName = teamHeadId.FirstName + " " + teamHeadId.LastName,
                //    DepartmentAbrhs = CryptoHelper.Encrypt(departmentId.ToString()),
                //    DepartmentName = departmentId.DepartmentName,
                //    ParentTeamAbrhs = CryptoHelper.Encrypt(parentTeamId.ToString()),
                //    ParentTeamName = parentTeamId.TeamName,
                //};

                return null;
            }

            return null;
        }

        public List<WeekTypeBO> ListAllWeekType()
        {

            var weekList = _dbContext.WeekDays.Where(f => f.IsActive && !f.IsDeleted);
            var result = weekList.Select(details => new WeekTypeBO
            {

                WeekTypeId = details.WeekDayId,
                WeekStartDay = details.WeekDayName,
                IsActive = true,
                IsDeleted = false,
                CreatedBy = details.CreatedBy,
                CreatedDate = details.CreatedDate,
                LastModifiedDate = DateTime.UtcNow
            }).ToList();
            return (result.Count == 0 ? null : result);

        }

        //public int AddNewTeam(TeamBO team) //1: success, 2: team with same name already exists, 3: failure
        //{
        //    try
        //    {
        //        var duplicateTeam = _dbContext.Teams.FirstOrDefault(f => f.IsActive && !f.IsDeleted && f.TeamName == team.TeamName);
        //        if (duplicateTeam == null)
        //        {
        //            var userId = 0;
        //            //Int32.TryParse(CryptoHelper.Decrypt(team.UserAbrhs), out userId);

        //            //_dbContext.Teams.Add(new Team {
        //            //    TeamName = team.TeamName,
        //            //    WeekTypeId = team.WeekTypeId,
        //            //    AcknowledgementDay = team.AcknowledgementDay,
        //            //    AcknowledgementTime = team.AcknowledgementTime,
        //            //    Reminder1Day = team.Reminder1Day,
        //            //    Reminder1Time = team.Reminder1Time,
        //            //    Reminder1Week = team.Reminder2Week,
        //            //    Reminder2Day = team.Reminder2Day,
        //            //    Reminder2Time = team.Reminder2Time,
        //            //    Reminder2Week = team.Reminder2Week,
        //            //    Reminder3Day = team.Reminder3Day,
        //            //    Reminder3Time = team.Reminder3Time,
        //            //    Reminder3Week = team.Reminder3Week,
        //            //    DashboardDay = team.DashboardDay,
        //            //    DashboardTime = team.DashboardTime,
        //            //    DashboardWeek = team.DashboardWeek,
        //            //    ReportDay = team.ReportDay,
        //            //    ReportTime = team.ReportTime,
        //            //    ReportWeek = team.ReportWeek,
        //            //    TeamHeadId = Convert.ToInt32(CryptoHelper.Decrypt(team.TeamAbrhs)),
        //            //    ParentTeamId = Convert.ToInt32(CryptoHelper.Decrypt(team.ParentTeamAbrhs)),
        //            //    DepartmentId = Convert.ToInt32(CryptoHelper.Decrypt(team.DepartmentAbrhs)),
        //            //    CreatedDate = DateTime.Now,
        //            //    CreatedBy = userId,
        //            //});                      
        //            //_dbContext.SaveChanges();

        //            // Logging 
        //            _userServices.SaveUserLogs(ActivityMessages.AddNewTeam, userId, 0);

        //            return 1;
        //        }
        //        return 2;
        //    }
        //    catch (Exception)
        //    {
        //        return 3;
        //    }
        //}

        //public int UpdateTeamDetails(TeamBO team)   //1: success, 2: team with same name already exists, 3: failure
        //{
        //    try
        //    {
        //        var teamId = 0;
        //        Int32.TryParse(CryptoHelper.Decrypt(team.TeamAbrhs), out teamId);

        //        var teamToUpdate = _dbContext.Teams.FirstOrDefault(f => f.TeamId == teamId && !f.IsDeleted);
        //        if (teamToUpdate != null)
        //        {
        //            var duplicateTeamName = _dbContext.Teams.FirstOrDefault(f => f.IsActive && !f.IsDeleted && f.TeamId != teamId && f.TeamName == team.TeamName);
        //            if (duplicateTeamName == null)
        //            {
        //                var userId = 0;
        //                //Int32.TryParse(CryptoHelper.Decrypt(team.UserAbrhs), out userId);

        //                //teamToUpdate.TeamName = team.TeamName;
        //                //teamToUpdate.WeekTypeId = team.WeekTypeId;
        //                //teamToUpdate.AcknowledgementDay = team.AcknowledgementDay;
        //                //teamToUpdate.AcknowledgementTime = team.AcknowledgementTime;
        //                //teamToUpdate.Reminder1Day = team.Reminder1Day;
        //                //teamToUpdate.Reminder1Time = team.Reminder1Time;
        //                //teamToUpdate.Reminder1Week = team.Reminder2Week;
        //                //teamToUpdate.Reminder1CopyToManager = team.Reminder1CopyToManager;
        //                //teamToUpdate.Reminder2Day = team.Reminder2Day;
        //                //teamToUpdate.Reminder2Time = team.Reminder2Time;
        //                //teamToUpdate.Reminder2Week = team.Reminder2Week;
        //                //teamToUpdate.Reminder2CopyToManager = team.Reminder2CopyToManager;
        //                //teamToUpdate.Reminder3Day = team.Reminder3Day;
        //                //teamToUpdate.Reminder3Time = team.Reminder3Time;
        //                //teamToUpdate.Reminder3Week = team.Reminder3Week;
        //                //teamToUpdate.Reminder3CopyToManager = team.Reminder3CopyToManager;
        //                //teamToUpdate.DashboardDay = team.DashboardDay;
        //                //teamToUpdate.DashboardTime = team.DashboardTime;
        //                //teamToUpdate.DashboardWeek = team.DashboardWeek;
        //                //teamToUpdate.ReportDay = team.ReportDay;
        //                //teamToUpdate.ReportTime = team.ReportTime;
        //                //teamToUpdate.ReportWeek = team.ReportWeek;
        //                //teamToUpdate.ReportCCEmailIds = team.ReportCCEmailIds;
        //                //teamToUpdate.TeamHeadId = Convert.ToInt32(CryptoHelper.Decrypt(team.TeamHeadAbrhs));
        //                //teamToUpdate.ParentTeamId = Convert.ToInt32(CryptoHelper.Decrypt(team.ParentTeamAbrhs));
        //                //teamToUpdate.DepartmentId = Convert.ToInt32(CryptoHelper.Decrypt(team.DepartmentAbrhs));
        //                //teamToUpdate.LastModifiedDate = DateTime.Now;
        //                //teamToUpdate.LastModifiedBy = userId;
        //                //_dbContext.SaveChanges();

        //                // Logging 
        //                _userServices.SaveUserLogs(ActivityMessages.UpdateTeamDetails, userId, 0);

        //                return 1;
        //            }
        //            return 2;
        //        }
        //        return 3;
        //    }
        //    catch (Exception ex)
        //    {
        //        return 3;
        //    }
        //}

        public int DeleteTeam(string teamAbrhs, string userAbrhs) //1: success, 2: user is mapped to team, 3: failure
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var teamId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(teamAbrhs), out teamId);

            var teamToDelete = _dbContext.Teams.FirstOrDefault(f => f.TeamId == teamId);
            if (teamToDelete != null)
            {
                var userMappedToTeam = _dbContext.UserTeamMappings.FirstOrDefault(t => t.TeamId == teamId);
                if (userMappedToTeam == null)
                {
                    teamToDelete.IsActive = false;
                    teamToDelete.IsDeleted = true;
                    teamToDelete.LastModifiedBy = userId;
                    _dbContext.SaveChanges();

                    // Logging 
                    _userServices.SaveUserLogs(ActivityMessages.DeleteTeam, userId, 0);

                    return 1;
                }
                return 2;
            }
            return 3;
        }

        #endregion

        #region User team mapping


        public List<TeamNameListBO> TeamsListforMapping()
        {
            var teamData = _dbContext.Proc_GetTeamMembersListForUserTeamMapping().ToList();
           var result = teamData.Select(t => new TeamNameListBO
            {
                TeamAbrhs = CryptoHelper.Encrypt(t.TeamId.ToString()),
                TeamName = t.TeamName,
                UserName = t.col2 == "0"?"":t.col2,
                EmployeeCount = t.col2=="0" ? Convert.ToInt32(t.col2) : (t.col2.Split(',')).Length,
                DepartmentName = t.DepartmentName
            }).ToList();

            return result ?? new List<TeamNameListBO>();
        }

        public List<TeamNameListByDeptIdBO> TeamsListforMappingByDeptId(string DeptAbrhs)
        {
            if (DeptAbrhs.Equals("0"))
            {
                var Data = _dbContext.Teams.Where(x => x.IsActive).ToList();

                var result1 = (from t in Data
                               select new TeamNameListByDeptIdBO
                               {
                                   TeamAbrhsById = CryptoHelper.Encrypt(t.TeamId.ToString()),
                                   TeamNameById = t.TeamName

                               }).OrderBy(x => x.TeamNameById).ToList();
                return result1;

            }
            else
            {
                var DeptId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(DeptAbrhs), out DeptId);
                var teamData = _dbContext.Teams.Where(x => x.IsActive && x.DepartmentId == DeptId).ToList();

                var result = (from t in teamData
                              select new TeamNameListByDeptIdBO
                              {
                                  TeamAbrhsById = CryptoHelper.Encrypt(t.TeamId.ToString()),
                                  TeamNameById = t.TeamName

                              }).OrderBy(x => x.TeamNameById).ToList();
                return result;
            }

        }

        public List<UserDetailForUserTeamMappingBO> ListMappedUserToTeam(string teamAbrhs)
        {
            var teamId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(teamAbrhs), out teamId);

            var usersData = _dbContext.UserDetails.Where(x => x.User.IsActive).ToList();
            var mappedUser = _dbContext.UserTeamMappings.Where(x => x.IsActive && x.TeamId == teamId).ToList();


            var result = (from t in usersData

                          select new UserDetailForUserTeamMappingBO
                          {
                              UserAbrhs = CryptoHelper.Encrypt(t.UserId.ToString()),
                              Name = t.FirstName + " " + t.LastName,
                              TeamAbrhs = CryptoHelper.Encrypt(teamId.ToString()),
                              ConsiderInClientReports = mappedUser.Select(x => x.UserId).Contains(t.UserId) ? mappedUser.Where(x => x.UserId == t.UserId).FirstOrDefault().ConsiderInClientReports : false,
                              IsMapped = mappedUser.Select(x => x.UserId).Contains(t.UserId) ? true : false,
                              IsSelected = false,
                              RoleAbrhs = CryptoHelper.Encrypt(mappedUser.Select(x => x.UserId).Contains(t.UserId) ? mappedUser.Where(x => x.UserId == t.UserId).FirstOrDefault().TeamRoleId.ToString() : "0")
                          }).OrderBy(x => x.Name).ToList();
            return result;
        }


        public ReturnTeamUserMappingBO InsertNewUserTeamMapping(ManageUserTeamMappingBO ManageUserTeamBO)
        {
            var status = 0;
            var ExistingUserAbrhs = "";
            var loginUserId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(ManageUserTeamBO.UserAbrhs), out loginUserId);

            var teamId = 0L;
            Int64.TryParse(CryptoHelper.Decrypt(ManageUserTeamBO.TeamAbrhs), out teamId);

            var usersXmlData = new XElement("Root",
               from temp in ManageUserTeamBO.UserTeamList
               select new XElement("Data",
                       new XAttribute("EmployeeId", CryptoHelper.Decrypt(temp.EmployeeAbrhs)),
                       new XAttribute("ConsiderInClientReports", temp.ConsiderInClientReports),
                       new XAttribute("RoleId", CryptoHelper.Decrypt(temp.RoleAbrhs))

                       )).ToString();

            var result = new ObjectParameter("Success", typeof(int));
            var ExistingIds = new ObjectParameter("ExistingIds", typeof(string));

            _dbContext.Proc_AddUpdateUserTeamMappings(ManageUserTeamBO.IsAdded, loginUserId, teamId, usersXmlData, result, ExistingIds);

            Int32.TryParse(result.Value.ToString(), out status);


            // Logging 
            if (status > 0)
                _userServices.SaveUserLogs(ActivityMessages.InsertNewUserTeamMapping, loginUserId, 0);

            string[] Ids = ExistingIds.Value.ToString().Split(',');

            for (int i = 0; i < Ids.Length; i++)
            {
                if (ExistingUserAbrhs == "")
                    ExistingUserAbrhs = CryptoHelper.Encrypt(Ids[i].ToString());
                else
                    ExistingUserAbrhs = ExistingUserAbrhs + "," + CryptoHelper.Encrypt(Ids[i].ToString());
            }

            ReturnTeamUserMappingBO obj = new ReturnTeamUserMappingBO();
            obj.Success = status;
            obj.ExistingIds = ExistingUserAbrhs == null ? "" : ExistingUserAbrhs;

            return obj;
        }

        public bool DeleteUserTeamMapping(int userId, long teamId)
        {
            //var result = _dbContext.UserTeamMappings.FirstOrDefault(s => s.UserId == userId && s.TeamId == teamId);
            //_dbContext.UserTeamMappings.DeleteObject(result);

            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.DeleteUserTeamMapping, userId, 0);

            _dbContext.SaveChanges();

            return true;

        }

        #endregion

        #region Shift management

        public List<ListAllShiftBO> ListAllShift()
        {
            var result = new List<BO.ListAllShiftBO>();
            var shiftList = _dbContext.ShiftMasters.Where(f => !f.IsDeleted).ToList();
            foreach (var a in shiftList)
            {
                var time = "";
                var weekType = "";
                var status = "";

                if (a.IsNight == true)
                    time = "Night";
                else
                    time = "Day";

                if (a.IsWeekEnd == true)
                    weekType = "Weekend";
                else
                    weekType = "Weekday";

                if (a.IsActive == true)
                    status = "Active";
                else
                    status = "Suspended";

                result.Add(new ListAllShiftBO
                {
                    ShiftName = a.ShiftName,
                    ShiftAbrhs = CryptoHelper.Encrypt(a.ShiftId.ToString()),
                    InTime = a.InTime.ToString(),
                    OutTime = a.OutTime.ToString(),
                    WorkingHours = a.WorkingHours.ToString(),
                    ShiftType = time + " || " + weekType,
                    Status = status,
                    IsWeekEnd = a.IsWeekEnd,
                    IsNight = a.IsNight
                });
            }
            return result.Count == 0 ? null : result.OrderBy(n => n.ShiftName).ThenBy(o => o.InTime).ToList();
        }

        public ShiftMasterBO ListShiftByShiftId(long shiftId)
        {
            var shift = _dbContext.ShiftMasters.FirstOrDefault(f => !f.IsDeleted && f.ShiftId == shiftId);
            if (shift != null)
            {
                var result = new BO.ShiftMasterBO()
                {
                    ShiftAbrhs = CryptoHelper.Encrypt(shift.ShiftId.ToString()),
                    ShiftName = shift.ShiftName,
                    InTime = shift.InTime.ToString(),
                    OutTime = shift.OutTime.ToString(),
                    WorkingHours = shift.WorkingHours.ToString(),
                    IsActive = shift.IsActive,
                    IsNight = shift.IsNight,
                    IsWeekEnd = shift.IsWeekEnd
                };
                return result;
            }
            return null;
        }

        public int AddNewShift(BO.ShiftMaster shift)
        {
            var shiftId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(shift.ShiftAbrhs), out shiftId);

            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(shift.UserAbrhs), out userId);

            var checkIfShiftAlreadyExists = _dbContext.ShiftMasters.FirstOrDefault(f => f.IsActive && f.ShiftName == shift.ShiftName);
            if (checkIfShiftAlreadyExists == null)
            {
                Model.ShiftMaster newShift = new Model.ShiftMaster()
                {
                    ShiftName = shift.ShiftName,
                    InTime = TimeSpan.Parse(shift.InTime),
                    OutTime = TimeSpan.Parse(shift.OutTime),
                    WorkingHours = TimeSpan.Parse(shift.WorkingHours),
                    IsNight = shift.IsNight,
                    IsWeekEnd = shift.IsWeekEnd,
                    IsActive = true,
                    IsDeleted = false,
                    CreatedBy = userId,
                    CreatedDate = DateTime.UtcNow
                };
                _dbContext.ShiftMasters.Add(newShift);
                _dbContext.SaveChanges();

                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.AddNewShift, userId, 0);

                return 1;
            }
            return 2;
        }

        public bool DeleteShift(string ShiftAbrhs, string UserAbrhs)
        {
            var shiftId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(ShiftAbrhs), out shiftId);

            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(UserAbrhs), out userId);



            var shiftToDelete = _dbContext.ShiftMasters.FirstOrDefault(f => f.ShiftId == shiftId);
            if (shiftToDelete != null)
            {
                shiftToDelete.IsActive = false;
                shiftToDelete.IsDeleted = true;
                shiftToDelete.LastModifiedBy = userId;
                shiftToDelete.LastModifiedDate = DateTime.UtcNow;
                _dbContext.SaveChanges();

                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.DeleteShift, userId, 0);

                return true;
            }
            return false;
        }

        public int UpdateShiftDetails(BO.ShiftMaster shift)
        {
            var shiftId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(shift.ShiftAbrhs), out shiftId);

            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(shift.UserAbrhs), out userId);

            var shiftToUpdate = _dbContext.ShiftMasters.FirstOrDefault(f => f.ShiftId == shiftId && !f.IsDeleted);

            if (shiftToUpdate != null)
            {
                shiftToUpdate.ShiftName = shift.ShiftName;
                shiftToUpdate.InTime = TimeSpan.Parse(shift.InTime);
                shiftToUpdate.OutTime = TimeSpan.Parse(shift.OutTime);
                shiftToUpdate.WorkingHours = TimeSpan.Parse(shift.WorkingHours);
                shiftToUpdate.IsWeekEnd = shift.IsWeekEnd;
                shiftToUpdate.IsNight = shift.IsNight;
                shiftToUpdate.IsDeleted = false;
                shiftToUpdate.LastModifiedBy = userId;
                shiftToUpdate.LastModifiedDate = DateTime.UtcNow;
                shiftToUpdate.IsActive = true;
                _dbContext.SaveChanges();

                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.UpdateShiftDetails, userId, 0);

                return 1;
            }
            return 2;
        }

        #endregion

        #region Shift User Mapping

        public List<UsersListBO> MappedUsersOfTeam(string teamAbrhs)
        {
            var teamId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(teamAbrhs), out teamId);

            List<ShiftsListBO> lst = new List<ShiftsListBO>();

            var usersData = _dbContext.UserDetails.Where(x => x.User.IsActive).ToList();
            var mappedUser = _dbContext.UserTeamMappings.Where(x => x.IsActive && x.TeamId == teamId).ToList();
            var data = (from u in usersData
                        join mp in mappedUser on u.UserId equals mp.UserId
                        select new UsersListBO
                        {
                            UserAbrhs = CryptoHelper.Encrypt(mp.UserId.ToString()),
                            Name = u.FirstName + " " + u.LastName,
                            IsSelected = false
                        }).OrderBy(x => x.Name).ToList();
            //var result = (from m in mappedUser
            //              select new UsersListBO
            //              {
            //                  UserAbrhs = CryptoHelper.Encrypt(m.UserId.ToString()),
            //                  Name = usersData.Where(x => x.UserId == m.UserId).FirstOrDefault().FirstName + " " + usersData.Where(x => x.UserId == m.UserId).FirstOrDefault().LastName,
            //                  IsSelected = false
            //                  // ShiftsList = lst  //GetShiftsList()


            //              }).OrderBy(x => x.Name).ToList();
            //return result;
            return data;
        }

        public List<ShiftsListBO> GetShiftsList()
        {
            var ShiftData = _dbContext.ShiftMasters.Where(x => x.IsActive).ToList();

            var result = (from S in ShiftData

                          select new ShiftsListBO
                          {
                              ShiftAbrhs = CryptoHelper.Encrypt(S.ShiftId.ToString()),
                              ShiftName = S.ShiftName

                          }).OrderBy(x => x.ShiftName).ToList();

            //ShiftsListBO empty=new ShiftsListBO();
            //empty.ShiftAbrhs="0";
            //empty.ShiftName="Select";

            //result.Insert(0, empty);

            return result;
        }

        public List<ShiftsUserMapList> GetShiftUserMappingList(string UserAbrhs)
        {

            DateTime currentDate = Convert.ToDateTime(System.DateTime.Now.ToString("yyyy-MM-dd"));

            //TimeSheetService obj=new TimeSheetService();
            //WeekMaster mod=new WeekMaster();
            //mod = obj.FetchWeekInfo(UserAbrhs,0);
            //var dateIds = _dbContext.DateMasters.Where(y => (y.Date >= mod.StartDate && y.Date <= mod.EndDate)).Select(y => y.DateId).ToList();

            var dateIds = _dbContext.DateMasters.Where(y => y.Date == currentDate).Select(y => y.DateId).ToList();

            var ShiftMappingData = _dbContext.UserShiftMappings.Where(x => dateIds.Contains(x.DateId) && x.IsActive == true).ToList();

            //.OrderByDescending(x => x.CreatedDate).ToList();

            var result = (from S in ShiftMappingData
                          join SM in _dbContext.ShiftMasters on S.ShiftId equals SM.ShiftId into list1
                          from l1 in list1.DefaultIfEmpty()

                          join D in _dbContext.DateMasters on S.DateId equals D.DateId into list2
                          from l2 in list2.DefaultIfEmpty()

                          join UM in _dbContext.UserTeamMappings on S.UserId equals UM.UserId into list3
                          from l3 in list3.DefaultIfEmpty()

                          select new ShiftsUserMapList
                          {
                              MappingId = S.MappingId,
                              TeamName = l3.Team.TeamName, // _dbContext.Teams.Where(x => x.TeamId == l3.TeamId).FirstOrDefault().TeamName,    
                              UserName = _dbContext.UserDetails.Where(x => x.UserId == S.UserId).FirstOrDefault().FirstName + " " + _dbContext.UserDetails.Where(x => x.UserId == S.UserId).FirstOrDefault().LastName,
                              ShiftName = l1.ShiftName,
                              DateId = S.DateId,
                              DateValue = l2.Date.ToString("dd MMM yyyy"),
                              WeekNo = _dbContext.spFetchWeekInfo(S.UserId, l2.Date).FirstOrDefault().WeekNo,
                              Day = l2.Day,
                              InTime = l1.InTime.ToString(),
                              OutTime = l1.OutTime.ToString(),
                              IsWeekEnd = l1.IsWeekEnd,
                              IsNight = l1.IsNight,
                              ShiftType = l1.IsNight ? (l1.IsWeekEnd ? "Night || Weekend" : "Night || Weekday") : (l1.IsWeekEnd ? "Day || Weekend" : "Day || Weekday"),
                              UserAbrhs = CryptoHelper.Encrypt(S.UserId.ToString()),
                              ShiftAbrhs = CryptoHelper.Encrypt(S.ShiftId.ToString())


                          }).OrderBy(x => x.TeamName).ToList();
            return result;

        }

        public List<ShiftsUserMapList> SearchShiftUserMappingList(ShiftUserMappingFilterBO filter)
        {
            var shiftId = "";
            if (filter.ShiftAbrhs == "0")
            {
                var ShiftIds = _dbContext.ShiftMasters.Where(y => y.IsActive).Select(y => y.ShiftId).ToList();
                for (int i = 0; i < ShiftIds.Count; i++)
                {
                    if (i == 0)
                        shiftId = ShiftIds[i].ToString();
                    else
                        shiftId = shiftId + "," + ShiftIds[i];
                }
            }
            else
                shiftId = CryptoHelper.Decrypt(filter.ShiftAbrhs);

            var teamId = (filter.TeamAbrhs == "0") ? "" : CryptoHelper.Decrypt(filter.TeamAbrhs);

            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(filter.UserAbrhs), out userId);

            var xmlString = new XElement("Root",
            from i in filter.DateList
            select new XElement("Row",
                         new XAttribute("FromDate", i.FromDate),
                         new XAttribute("EndDate", i.ToDate)
                         ));
            //DateTime startDate = Convert.ToDateTime(filter.DateList[0].FromDate);
            //DateTime endDate = Convert.ToDateTime(filter.DateList[0].ToDate);
            // DateTime startDate = DateTime.ParseExact(filter.DateList[0].FromDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            // DateTime endDate = DateTime.ParseExact(filter.DateList[0].ToDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            //var ShiftUserMappingLst = _dbContext.spGetShiftUserMappingList(teamId, shiftId, startDate, endDate, userId).Select(x => new ShiftsUserMapList

            var ShiftUserMappingLst = _dbContext.spGetShiftUserMappingList(teamId, shiftId, xmlString.ToString(), userId).Select(x => new ShiftsUserMapList
            {
                MappingId = x.MappingId.HasValue ? x.MappingId.Value : 0,
                TeamName = x.TeamName,
                UserName = x.UserName,
                ShiftName = x.ShiftName,
                DateId = x.DateId.HasValue ? x.DateId.Value : 0,
                DateValue = x.DateValue,
                WeekNo = _dbContext.spFetchWeekInfo(x.UserId, (_dbContext.DateMasters.FirstOrDefault(d => d.DateId == x.DateId.Value).Date)).FirstOrDefault().WeekNo,
                Day = x.Day,
                InTime = x.InTime,
                OutTime = x.OutTime,
                IsWeekEnd = x.IsWeekEnd ?? false,
                IsNight = x.IsNight ?? false,
                ShiftType = x.ShiftType.ToString(),
                UserAbrhs = x.UserId.HasValue ? CryptoHelper.Encrypt(x.UserId.Value.ToString()) : "",
                ShiftAbrhs = x.ShiftId.HasValue ? CryptoHelper.Encrypt(x.ShiftId.Value.ToString()) : "",

            }).ToList();



            return ShiftUserMappingLst;

            //List<long> AllDateIds = new List<long>();

            //for (int i = 0; i < filter.DateList.Count; i++)
            //{
            //    List<long> DateIds = new List<long>();

            //    DateTime startDate = Convert.ToDateTime(filter.DateList[i].FromDate);
            //    DateTime endDate = Convert.ToDateTime(filter.DateList[i].ToDate);
            //    DateIds = _dbContext.DateMasters.Where(y => (y.Date >= startDate && y.Date <= endDate)).Select(y => y.DateId).ToList();

            //    AllDateIds.AddRange(DateIds);
            //}
            //// var dateIds = _dbContext.DateMasters.Where(y => y.Date == currentDate).Select(y => y.DateId).ToList();

            //var ShiftMappingData = _dbContext.UserShiftMappings.Where(x => AllDateIds.Contains(x.DateId) && x.IsActive == true).ToList();

            ////.OrderByDescending(x => x.CreatedDate).ToList();

            //var result = (from S in ShiftMappingData
            //              join SM in _dbContext.ShiftMasters on S.ShiftId equals SM.ShiftId into list1
            //              from l1 in list1.DefaultIfEmpty()

            //              join D in _dbContext.DateMasters on S.DateId equals D.DateId into list2
            //              from l2 in list2.DefaultIfEmpty()

            //              join UM in _dbContext.UserTeamMappings on S.UserId equals UM.UserId into list3
            //              from l3 in list3.DefaultIfEmpty()

            //              select new ShiftsUserMapList
            //              {
            //                  MappingId = S.MappingId,
            //                  TeamName = l3.Team.TeamName, // _dbContext.Teams.Where(x => x.TeamId == l3.TeamId).FirstOrDefault().TeamName,    
            //                  UserName = _dbContext.UserDetails.Where(x => x.UserId == S.UserId).FirstOrDefault().FirstName + " " + _dbContext.UserDetails.Where(x => x.UserId == S.UserId).FirstOrDefault().LastName,
            //                  ShiftName = l1.ShiftName,
            //                  DateId = S.DateId,
            //                  DateValue = l2.Date.ToString("dd MMM yyyy"),
            //                  Day = l2.Day,
            //                  InTime = l1.InTime.ToString(),
            //                  OutTime = l1.OutTime.ToString(),
            //                  IsWeekEnd = l1.IsWeekEnd,
            //                  IsNight = l1.IsNight,
            //                  ShiftType = l1.IsNight ? (l1.IsWeekEnd ? "Night || Weekend" : "Night || Weekday") : (l1.IsWeekEnd ? "Day || Weekend" : "Day || Weekday"),
            //                  UserAbrhs = CryptoHelper.Encrypt(S.UserId.ToString()),
            //                  ShiftAbrhs = CryptoHelper.Encrypt(S.ShiftId.ToString())


            //              }).OrderBy(x => x.TeamName).ToList();
            // return result;
        }


        public List<long> GetDateIdList(string fromDate, string ToDate)
        {
            DateTime frmdt = new DateTime();
            DateTime todt = new DateTime();

            if (fromDate != "")
                frmdt = Convert.ToDateTime(fromDate);
            if (ToDate != "")
                todt = Convert.ToDateTime(ToDate);

            List<long> DateIds = _dbContext.DateMasters.Where(x => (x.Date >= frmdt && x.Date < todt)).Select(x => x.DateId).ToList();

            return DateIds;
        }

        public List<DepartmentMapList> DeptListforMapping()
        {
            var dept = _dbContext.Departments.Where(x => x.IsActive == true).ToList();
            var data = dept.Select(x => new DepartmentMapList
            {
                DeptAbrhs = CryptoHelper.Encrypt(x.DepartmentId.ToString()),
                DeptName = x.DepartmentName
            }).ToList();
            return data;
        }

        public int AddUpdateShiftUserMapping(List<UserShiftMappingList> ShiftUserList) //1: success, 2: duplicate, 3: failure
        {

            var status = 0;
            var LoginuserId = 0;
            if (ShiftUserList.Count > 0)
                Int32.TryParse(CryptoHelper.Decrypt(ShiftUserList[0].LoginUserAbrhs.ToString()), out LoginuserId);

            //var teamHeadId = 0;
            //Int32.TryParse(CryptoHelper.Decrypt(teamInformation.TeamHeadAbrhs), out teamHeadId);

            var xmlData = new XElement("Root",
                    from temp in ShiftUserList
                    select new XElement("Data",
                            new XAttribute("UserId", Int32.Parse(CryptoHelper.Decrypt(temp.UserAbrhs))),
                            new XAttribute("ShiftId", Int32.Parse(CryptoHelper.Decrypt(temp.ShiftAbrhs))),
                            new XAttribute("DateId", temp.DateId)
                            ));

            var result = new ObjectParameter("Success", typeof(int));

            _dbContext.Proc_AddUpdateShiftUserMapping(LoginuserId, xmlData.ToString(), result); //.FirstOrDefault().Value;

            Int32.TryParse(result.Value.ToString(), out status);

            if (status == 1)
            {
                var existingsenderData = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == LoginuserId);
                var senderFirstName = existingsenderData.FirstName;
                var senderLastName = existingsenderData.LastName;
                var userId = 0;
                var prevUserId = 0;
                foreach (var t in ShiftUserList)
                {
                    prevUserId = userId;
                    Int32.TryParse(CryptoHelper.Decrypt(t.UserAbrhs.ToString()), out userId);
                    var shiftId = Int32.Parse(CryptoHelper.Decrypt(t.ShiftAbrhs));
                    if (userId == prevUserId)
                        continue;

                    var existingReceiverData = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == userId);
                    var receiverFirstName = existingReceiverData.FirstName;
                    var receiverLastName = existingReceiverData.LastName;
                    var subject = " Regarding shift mapping ";
                    var shiftName = _dbContext.ShiftMasters.FirstOrDefault(x => x.ShiftId == shiftId);
                    var message = "You have been assigned the shift:  " + shiftName.ShiftName + t.Message;
                    var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == EmailTemplates.ShiftMap && f.IsActive && !f.IsDeleted);
                    var body = emailTemplate.Template
                            .Replace("[RECEIVERNAME]", receiverFirstName.ToTitleCase())
                            .Replace("[MSG]", message)
                            .Replace("[SENDERNAME]", senderFirstName.ToTitleCase() + " " + senderLastName.ToTitleCase());

                    // SEND MAIL 
                    Utilities.EmailHelper.SendEmailWithDefaultParameter(subject, body, true, true, CryptoHelper.Decrypt(existingReceiverData.EmailId), null, null, null);
                    _dbContext.SaveChanges();
                }
            }

            return status;
        }

        public bool DeleteShiftUserMapping(int MappingId, string UserAbrhs)
        {
            var msg = 0;
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(UserAbrhs), out userId);
            var shiftUserMappingToDelete = _dbContext.UserShiftMappings.FirstOrDefault(x => x.MappingId == MappingId);

            if (shiftUserMappingToDelete != null)
            {
                shiftUserMappingToDelete.IsActive = false;
                shiftUserMappingToDelete.IsDeleted = true;
                shiftUserMappingToDelete.LastModifiedBy = userId;
                shiftUserMappingToDelete.LastModifiedDate = DateTime.UtcNow;
                if (shiftUserMappingToDelete.ShiftId == 3)//for night shift i.e C shift
                {
                    var shiftUserId = shiftUserMappingToDelete.UserId;
                    var dateId = shiftUserMappingToDelete.DateId;
                    var tempUserShiftToDelete = _dbContext.TempUserShiftDetails.
                                         FirstOrDefault(s => s.CreatedBy == shiftUserId && s.DateId == dateId && s.StatusId == 4);
                    var shiftRequestDetailId = 0;
                    Int32.TryParse((tempUserShiftToDelete.TempUserShiftDetailId).ToString(), out shiftRequestDetailId);
                    var loginUserData = _dbContext.UserDetails.FirstOrDefault(f => f.UserId == userId);
                    var userData = _dbContext.UserDetails.FirstOrDefault(f => f.UserId == shiftUserId);
                    var requestedDate = (_dbContext.DateMasters.FirstOrDefault(s => s.DateId == dateId).Date).ToString("dd MMM yyyy", CultureInfo.InvariantCulture);
                    if (tempUserShiftToDelete != null)
                    {
                        var result = new ObjectParameter("Success", typeof(int));
                        _dbContext.Proc_TakeActionOnMapLnsaShift(userId, shiftRequestDetailId, "Cancelled", "CA", "Single", "", result);
                        Int32.TryParse(result.Value.ToString(), out msg);
                        if (msg == 1)//email for night shift user
                        {
                            if (loginUserData != null && userData != null && userId != shiftUserId)
                            {
                                var firstName = loginUserData.FirstName;
                                var lastName = loginUserData.LastName;
                                var emailId = CryptoHelper.Decrypt(userData.EmailId);
                                var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "LNSA Shift Rejected" && f.IsActive && !f.IsDeleted);
                                if (emailTemplate != null && userData != null)
                                {
                                    var body = emailTemplate.Template.Replace("[Name]", userData.FirstName)
                                        .Replace("[HEADER]", "LNSA SHIFT REQUEST CANCELLED")
                                        .Replace("[Action]", "cancelled")
                                        .Replace("[MsgWithDate]", "for the date " + requestedDate)
                                        .Replace("[ApproverName]", firstName + " " + lastName);
                                    Utilities.EmailHelper.SendEmailWithDefaultParameter("LNSA shift request cancelled", body, true, true, emailId, null, null, null);
                                }
                            }

                        }
                    }
                }
                _dbContext.SaveChanges();

                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.DeleteShiftUserMapping, userId, 0);

                return true;
            }
            return false;
        }


        #endregion
    }
}
