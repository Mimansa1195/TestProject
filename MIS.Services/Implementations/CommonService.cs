using MIS.BO;
using MIS.Model;
using MIS.Services.Contracts;
using MIS.Utilities;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Globalization;
using System.Linq;

namespace MIS.Services.Implementations
{
    public class CommonService : ICommonService
    {
        #region Private member variables

        private readonly MISEntities _dbContext = new MISEntities();

        #endregion

        public List<BaseDropDown> FetchGoalCategory()
        {
            var data = _dbContext.GoalCategories.Where(t => t.IsActive);
            var ddl = data.Select(t => new BaseDropDown
            {
                Text = t.Category,
                Value = t.GoalCategoryId,
                Selected = false
            }).AsQueryable();
            return ddl.OrderBy(t => t.Text).ToList();
        }

        public List<BaseDropDown> FetchTeamsToReviewGoals(int userId)
        {
            var data = _dbContext.Proc_GetTeamsToReviewGoals(userId);
            var teamList = new List<BaseDropDown>();
            foreach (var t in data)
            {
                var teamAbrhs = CryptoHelper.Encrypt(t.TeamId.ToString());
                var ddl = new BaseDropDown
                {
                    Text = t.DisplayTeam,
                    KeyValue = teamAbrhs,
                    Selected = false
                };

                teamList.Add(ddl);
            }
            var ddlList = teamList.OrderBy(t => t.Text).ToList();
            return ddlList ?? new List<BaseDropDown>();
        }

        public List<BaseDropDown> FetchTeamsToAddGoals(int userId, string type)
        {
            var data = _dbContext.Proc_GetTeamsToAddGoals(userId, type).ToList();
            var teamList = new List<BaseDropDown>();

            foreach (var t in data)
            {
                var teamAbrhs = CryptoHelper.Encrypt(t.TeamId.ToString());
                var ddl = new BaseDropDown
                {
                    Text = t.DisplayTeam,
                    KeyValue = teamAbrhs,
                    Selected = t.IsSelected
                };
                teamList.Add(ddl);
            }
            var ddlList = teamList.OrderBy(t => t.Text).ToList();
            return ddlList ?? new List<BaseDropDown>();
        }


        /// <summary>
        /// Fetch TaskTypes
        /// </summary>
        /// <param name="teamId"></param>
        /// <returns></returns>
        public List<BaseDropDown> FetchTaskTypes(long teamId)
        {
            using (var context = new MISEntities())
            {
                var ddl = (from t in context.TaskTeamTaskTypeMappings
                           where t.TaskTeamId == teamId && t.IsActive && t.TaskType.IsActive && !t.TaskType.IsDeleted
                           select new BaseDropDown
                           {
                               Text = t.TaskType.TaskTypeName,
                               Value = t.TaskType.TaskTypeId,
                               Selected = false
                           }).AsQueryable();
                return ddl.OrderBy(t => t.Text).ToList();
            }
        }

        /// <summary>
        /// Fetch TaskTeams
        /// </summary>
        /// <returns></returns>
        public List<BaseDropDown> FetchTaskTeams()
        {
            using (var context = new MISEntities())
            {
                var ddl = (from t in context.TaskTeams
                           where t.IsActive == true && !t.IsDeleted
                           select new BaseDropDown
                           {
                               Text = t.TeamName,
                               Value = t.TaskTeamId,
                               Selected = false
                           }).AsQueryable();
                return ddl.OrderBy(t => t.Text).ToList();
            }
        }

        /// <summary>
        /// Fetch Selected TaskType Info
        /// </summary>
        /// <param name="taskTypeId"></param>
        /// <returns></returns>
        public BO.TaskType FetchSelectedTaskTypeInfo(long taskTypeId)
        {
            using (var context = new MISEntities())
            {
                var taskInfo = context.TaskTypes.FirstOrDefault(a => a.TaskTypeId == taskTypeId);
                if (taskInfo != null)
                {
                    var result = Convertor.Convert<BO.TaskType, Model.TaskType>(taskInfo);
                    return result;
                }
                return null;
            }
        }

        /// <summary>
        /// Fetch SubDetails 1
        /// </summary>
        /// <param name="taskId"></param>
        /// <returns></returns>
        public List<BO.TaskSubDetail1> FetchSubDetails1(long taskId)
        {
            using (var context = new MISEntities())
            {
                var detailList = (from t in context.TaskTypeTaskSubDetail1Mapping
                                  where
                              t.TaskTypeId == taskId
                              && t.IsActive
                                && t.TaskSubDetail1.IsActive
                                && !t.TaskSubDetail1.IsDeleted
                                  select new BO.TaskSubDetail1
                                  {
                                      TaskSubDetail1Id = t.TaskSubDetail1.TaskSubDetail1Id,
                                      TaskSubDetail1Name = t.TaskSubDetail1.TaskSubDetail1Name,
                                      CreatedDate = t.TaskSubDetail1.CreatedDate
                                  }).OrderBy(a => a.TaskSubDetail1Name).ToList();

                return detailList;

            }
        }

        /// <summary>
        /// Fetch SubDetails 2
        /// </summary>
        /// <param name="taskId"></param>
        /// <returns></returns>
        public List<BO.TaskSubDetail2> FetchSubDetails2(long taskId)
        {
            using (var context = new MISEntities())
            {
                var detailList = (from t in context.TaskTypeTaskSubDetail2Mapping
                                  where
                              t.TaskTypeId == taskId
                              && t.IsActive
                              && t.TaskSubDetail2.IsActive
                              && !t.TaskSubDetail2.IsDeleted
                                  select new BO.TaskSubDetail2
                                  {
                                      TaskSubDetail2Id = t.TaskSubDetail2.TaskSubDetail2Id,
                                      TaskSubDetail2Name = t.TaskSubDetail2.TaskSubDetail2Name,
                                      CreatedDate = t.TaskSubDetail2.CreatedDate
                                  }).OrderBy(a => a.TaskSubDetail2Name).ToList();

                return detailList;

            }
        }

        /// <summary>
        /// List Team By UserId
        /// </summary>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<BaseDropDown> ListTeamByUserId(string userAbrhs, string menuAbrhs)
        {
            using (var context = new MISEntities())
            {
                List<int> UserIdsList = new List<int>();
                var userId = 0;
                var menuId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                if (menuAbrhs != null)
                {
                    Int32.TryParse(CryptoHelper.Decrypt(menuAbrhs), out menuId);
                }
                UserIdsList.Add(userId);
                //check and take User Ids.
                var UserIdList = context.MenusUserDelegations.Where(x => x.MenuId == menuId && x.DelegatedToUserId == userId && x.IsActive
                    && System.Data.Entity.DbFunctions.TruncateTime(DateTime.Now) >= System.Data.Entity.DbFunctions.TruncateTime(x.DelegatedFromDate)
                    && System.Data.Entity.DbFunctions.TruncateTime(DateTime.Now) <= System.Data.Entity.DbFunctions.TruncateTime(x.DelegatedTillDate)
                    ).Select(x => new { UserId = x.DelegatedFromUserId }).GroupBy(x => new { x.UserId }).ToList();
                if (UserIdList.Any())
                {
                    UserIdsList.AddRange(UserIdList.Select(x => x.Key.UserId));
                }

                var ddl = (from t in context.TimeSheetReportAccesses
                           where UserIdsList.Contains(t.UserId) && t.IsActive == true && !t.IsDeleted
                           select new BaseDropDown
                           {
                               Text = t.Team.TeamName,
                               Value = t.TeamId,
                               Selected = false
                           }).AsQueryable();
                return ddl.OrderBy(t => t.Text).ToList();
                //List<string> list = new List<string>();
                //var teamList = context.TimeSheetReportAccesses.Where(f => f.UserId == UserId);
                //foreach (var a in teamList)
                //{
                //    var teamName = context.Teams.FirstOrDefault(f => f.TeamId == a.TeamId);
                //    list.Add(teamName.TeamName);
                //}
                //return  list.OrderBy(o => o).ToList();
            }
        }

        /// <summary>
        /// Get all countries
        /// </summary>
        /// <returns>BaseDropDown</returns>
        public List<BaseDropDown> GetCountries()
        {
            var data = _dbContext.Countries.Select(x => new BaseDropDown
            {
                Text = x.CountryName,
                Value = x.CountryId,
                Selected = false
            }).OrderBy(t => t.Text).ToList();
            return data;
        }

        public List<BaseDropDown> GetFeedbackType()
        {
            var data = _dbContext.FeedbackTypes.Select(x => new BaseDropDown
            {
                Text = x.FeedbackTypeName,
                Value = x.FeedbackTypeId,
                Selected = false
            }).OrderBy(t => t.Text).ToList();
            return data;
        }

        /// <summary>
        /// Get states based on country
        /// </summary>
        /// <returns>BaseDropDown</returns>
        public List<BaseDropDown> GetStates(int countryId)
        {
            var data = _dbContext.States.Where(x => x.CountryId == countryId).Select(x => new BaseDropDown
            {
                Text = x.StateName,
                Value = x.StateId,
                Selected = false
            }).OrderBy(t => t.Text).ToList();
            return data;
        }

        /// <summary>
        /// Get cities based on state
        /// </summary>
        /// <returns>BaseDropDown</returns>
        public List<BaseDropDown> GetCities(int stateId)
        {
            var data = _dbContext.Cities.Where(x => x.StateId == stateId).Select(x => new BaseDropDown
            {
                Text = x.CityName,
                Value = x.CityId,
                Selected = false
            }).OrderBy(t => t.Text).ToList();
            return data;
        }

        /// <summary>
        /// Get genders list
        /// </summary>
        /// <returns>BaseDropDown</returns>
        public List<BaseDropDown> GetGender()
        {
            var data = _dbContext.Genders.Select(x => new BaseDropDown
            {
                Text = x.GenderType,
                Value = x.GenderId,
                Selected = false
            }).OrderBy(t => t.Text).ToList();
            return data;
        }

        /// <summary>
        /// Get marital status list
        /// </summary>
        /// <returns>BaseDropDown</returns>
        public List<BaseDropDown> GetMaritalStatus()
        {
            var data = _dbContext.MaritalStatus.Select(x => new BaseDropDown
            {
                Text = x.MaritalStatusType,
                Value = x.MaritalStatusId,
                Selected = false
            }).OrderBy(t => t.Text).ToList();
            return data;
        }

        /// <summary>
        /// Get occupations list
        /// </summary>
        /// <returns>BaseDropDown</returns>
        public List<BaseDropDown> GetOccupation()
        {
            var data = _dbContext.Occupations.Select(x => new BaseDropDown
            {
                Text = x.OccupationName,
                Value = x.OccupationId,
                Selected = false
            }).OrderBy(t => t.Text).ToList();
            return data;
        }

        /// <summary>
        /// Get relationship list
        /// </summary>
        /// <returns>BaseDropDown</returns>
        public List<BaseDropDown> GetRelationship()
        {
            var data = _dbContext.Relationships.Select(x => new BaseDropDown
            {
                Text = x.RelationshipName,
                Value = x.RelationshipId,
                Selected = false
            }).OrderBy(t => t.Text).ToList();
            return data;
        }

        public List<BaseDropDown> GetAssetTypes(int loginUserId)
        {
            var data = (from a in _dbContext.AssetTypes.Where(t => t.IsActive == true)
                        join
                        p in _dbContext.Fun_GetAssetsTypeRoleWise(loginUserId).Where(t => t.HasAllocateRights == true)
                        on a.TypeId equals p.AssetTypeId
                        select new BaseDropDown
                        {
                            Text = a.Type,
                            Value = a.TypeId,
                            Selected = false
                        }).OrderBy(t => t.Text).ToList();

            return data;
        }

        public List<BaseDropDown> GetAssetModels(int assetTypeId)
        {
            var data = _dbContext.Assets.Where(x => x.TypeId == assetTypeId).Select(x => new BaseDropDown
            {
                Text = x.Make + " - " + x.Model + "( " + x.Description + " )",
                Value = x.AssetId,
                Selected = false
            }).OrderBy(t => t.Text).ToList();
            return data;
        }

        /// <summary>
        /// List Years
        /// </summary>
        /// <returns></returns>
        public List<int> ListYears()
        {
            using (var context = new MISEntities())
            {
                var results = context.TimeSheets.Where(f => f.Status == 2).GroupBy(g => g.Year).Select(grp => grp.FirstOrDefault()).Select(s => s.Year).ToList();
                return results.OrderByDescending(s => s).ToList();
            }
        }

        /// <summary>
        /// List Weeks
        /// </summary>
        /// <param name="year"></param>
        /// <returns></returns>
        public List<int> ListWeeks(int year)
        {
            using (var context = new MISEntities())
            {
                var results = context.TimeSheets.Where(f => f.Year == year && f.Status == 2).GroupBy(g => g.WeekNo).Select(grp => grp.FirstOrDefault()).Select(s => s.WeekNo).ToList();

                return results.OrderByDescending(s => s).ToList();
            }
        }

        /// <summary>
        /// List All Active Users
        /// </summary>
        /// <returns></returns>
        public List<EmployeeBO> ListAllActiveUsers()
        {
            var result = new List<EmployeeBO>();
            var data = _dbContext.vwActiveUsers.OrderBy(t => t.EmployeeName).ToList();

            result = data.Select(x => new EmployeeBO
            {
                EmployeeAbrhs = CryptoHelper.Encrypt(x.UserId.ToString()),
                EmployeeName = x.EmployeeName + "(" + x.EmployeeId + ")"
            }).ToList();
            return result;
        }

        /// <summary>
        /// List All Active Users
        /// </summary>
        /// <returns></returns>
        public List<EmployeeBO> ListAllInActiveUsers()
        {
            var result = new List<EmployeeBO>();
            var data = _dbContext.vwAllUsers.Where(t => t.IsActive == false).OrderBy(t => t.EmployeeName).ToList();

            result = data.Select(x => new EmployeeBO
            {
                EmployeeAbrhs = CryptoHelper.Encrypt(x.UserId.ToString()),
                EmployeeName = x.EmployeeName + "(" + x.EmployeeId + ")"
            }).ToList();
            return result;
        }

        public List<EmployeeBO> ListAllReferralReviewersToFwd()
        {
            var result = new List<EmployeeBO>();
            var data = (from vw in _dbContext.vwActiveUsers.AsEnumerable()
                        join d in _dbContext.Designations on vw.DesignationId equals d.DesignationId
                        where !d.IsIntern
                        orderby vw.EmployeeName
                        select new EmployeeBO()
                        {
                            EmployeeName = vw.EmployeeName,
                            EmployeeAbrhs = CryptoHelper.Encrypt(vw.UserId.ToString())
                        }).ToList();
            result = data ?? new List<EmployeeBO>();
            return result;
        }

        public List<EmployeeBO> ListAllReferralReviewers(int detailId)
        {
            var result = new List<EmployeeBO>();
            var info = _dbContext.ReferralReviews.Where(x => x.ReferralDetailId == detailId).ToList();
            if (info.Any())
            {
                var data = (from vw in _dbContext.vwActiveUsers.AsEnumerable()
                            join d in _dbContext.Designations on vw.DesignationId equals d.DesignationId
                            where !d.IsIntern
                            orderby vw.EmployeeName
                            select new EmployeeBO()
                            {
                                EmployeeName = vw.EmployeeName,
                                EmployeeAbrhs = CryptoHelper.Encrypt(vw.UserId.ToString())
                            }).Where(p => !info.Any(p2 => (CryptoHelper.Encrypt(p2.ForwardedToId.ToString())) == p.EmployeeAbrhs)).ToList();

                result = data ?? new List<EmployeeBO>();
            }
            else
            {
                var data = (from vw in _dbContext.vwActiveUsers.AsEnumerable()
                            join d in _dbContext.Designations on vw.DesignationId equals d.DesignationId
                            where !d.IsIntern
                            orderby vw.EmployeeName
                            select new EmployeeBO()
                            {
                                EmployeeName = vw.EmployeeName,
                                EmployeeAbrhs = CryptoHelper.Encrypt(vw.UserId.ToString())
                            }).ToList();
                result = data ?? new List<EmployeeBO>();
            }
            return result;
        }
        public List<EmployeeBO> ListAllActiveUsersByDepartment(string departmentAbrhs)
        {
            var departmentId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(departmentAbrhs), out departmentId);
            var result = new List<EmployeeBO>();
            var data = (from ud in _dbContext.UserDetails.Where(x => x.User.IsActive)
                        join utm in _dbContext.UserTeamMappings on ud.UserId equals utm.UserId
                        join t in _dbContext.Teams on utm.TeamId equals t.TeamId
                        where t.DepartmentId == departmentId
                        orderby ud.FirstName, ud.LastName
                        select new
                        {
                            ud.FirstName,
                            ud.LastName,
                            ud.UserId,
                            ud.EmployeeId
                        }).ToList();

            result = data.Select(x => new EmployeeBO
            {
                EmployeeAbrhs = CryptoHelper.Encrypt(x.UserId.ToString()),
                EmployeeName = x.FirstName + " " + x.LastName + " ( " + x.EmployeeId + " ) ",
            }).OrderBy(t => t.EmployeeName).ToList();
            return result;
        }
        public int GetProbationPeriodInMonths(string designationAbrhs)
        {
            int designationId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(designationAbrhs), out designationId);
            var result = 0;
            if (designationId > 0)
            {
                var data = _dbContext.Designations.FirstOrDefault(x => x.DesignationId == designationId);
                if (data != null)
                    result = data.IsIntern ? 6 : 12;
            }
            return result;
        }
        public List<EmployeeBO> GetAllReportingManager()
        {
            var result = new List<EmployeeBO>();
            var data = _dbContext.spGetAllReportingManagers().ToList();

            foreach (var temp in data)
            {
                result.Add(new EmployeeBO
                {
                    EmployeeAbrhs = CryptoHelper.Encrypt(temp.UserId.ToString()),
                    EmployeeName = temp.EmployeeName
                });
            }
            return result.OrderBy(t => t.EmployeeName).ToList();
        }

        /// <summary>
        /// Method to fetch active roles
        /// </summary>
        /// <param name="userAbrhs">UserAbrhs</param>
        /// <returns>List of roles</returns>
        public List<RoleBO> GetRoles(string userAbrhs)
        {
            if (string.IsNullOrEmpty(userAbrhs))
                return new List<RoleBO>();

            var result = new List<RoleBO>();
            var userId = 0;
            var roleId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            if (userId > 0)
            {
                var userData = _dbContext.Users.FirstOrDefault(x => x.UserId == userId && x.IsActive);
                if (userData != null)
                    roleId = userData.RoleId;
                else
                    return new List<RoleBO>();
            }
            var roleData = _dbContext.Roles.Where(x => x.IsDeleted == false);
            if ((roleId != (int)Enums.Roles.WebAdministrator))
                roleData = roleData.Where(x => x.RoleId != (int)Enums.Roles.WebAdministrator);

            var roles = roleData.ToList();
            foreach (var role in roles)
            {
                result.Add(new RoleBO
                {
                    RoleAbrhs = CryptoHelper.Encrypt(role.RoleId.ToString()),
                    RoleName = role.RoleName,
                });
            }
            return result.OrderBy(t => t.RoleName).ToList();
        }

        /// <summary>
        /// Method to fetch team roles
        /// </summary>
        /// <returns>List of team roles</returns>
        public List<RoleBO> GetTeamRoles()
        {
            var RoleData = _dbContext.TeamRoles.Where(x => x.IsActive).ToList();

            var result = (from t in RoleData

                          select new RoleBO
                          {
                              RoleAbrhs = CryptoHelper.Encrypt(t.TeamRoleId.ToString()),
                              RoleName = t.TeamRoleName
                          }).OrderBy(x => x.RoleName).ToList();

            return result.OrderBy(t => t.RoleName).ToList();

        }

        public List<DepartmentBO> GetDepartments()
        {
            var result = new List<DepartmentBO>();
            var data = _dbContext.Departments.Where(x => x.DepartmentId > 0).ToList();
            foreach (var temp in data)
            {
                result.Add(new DepartmentBO
                {
                    DepartmentAbrhs = CryptoHelper.Encrypt(temp.DepartmentId.ToString()),
                    DepartmentName = temp.DepartmentName,
                });
            }
            return result.OrderBy(t => t.DepartmentName).ToList();
        }

        public List<BaseDropDown> GetUserMonthYear(string UserAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(UserAbrhs), out userId);
            var data = _dbContext.Fun_GetUserMonthYear(userId);
            var result = data.Select(x => new BaseDropDown() { Text = x.MonthYear }).ToList();

            return result ?? new List<BaseDropDown>();
        }
        public List<BaseDropDown> GetCabRequestMonthYear(string UserAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(UserAbrhs), out userId);
            var data = _dbContext.Fun_GetCabRequestMonthYear(userId).ToList();
            var result = new List<BaseDropDown>();
            if (data.Count != 0)
            {
                var maxMonthYear = (from m in data
                                    orderby m.Year descending, m.Month descending
                                    select m.MnthYr).FirstOrDefault();
                if (maxMonthYear != null)
                {
                    result = data.Select(x => new BaseDropDown()
                    {
                        Text = x.MonthYear,
                        KeyValue = x.MnthYr,
                        MaxValue = maxMonthYear
                    }).ToList();
                }
            }
            return result ?? new List<BaseDropDown>();
        }

        public List<ControllerBO> GetControllers()
        {
            var result = new List<ControllerBO>();
            var data = _dbContext.Menus.Where(x => x.ParentMenuId == 0).Select(x => x.ControllerName).ToList();

            foreach (var temp in data)
            {
                result.Add(new ControllerBO
                {
                    ControllerName = temp,
                });
            }
            return result.OrderBy(t => t.ControllerName).ToList();
        }

        public List<ControllerBO> GetActiveControllers()
        {
            var result = new List<ControllerBO>();
            var data = _dbContext.Menus.Where(x => x.ParentMenuId == 0 && x.IsActive).ToList();

            foreach (var temp in data)
            {
                result.Add(new ControllerBO
                {
                    ControllerName = temp.ControllerName,
                    MenuId = temp.MenuId
                });
            }
            return result.OrderBy(t => t.ControllerName).ToList();
        }

        public List<ControllerBO> GetActionsByControllerId(int controllerId)
        {
            var result = new List<ControllerBO>();
            var data = _dbContext.Menus.Where(x => x.ParentMenuId == controllerId && x.IsActive).ToList();

            foreach (var temp in data)
            {
                result.Add(new ControllerBO
                {
                    ControllerName = temp.ActionName,
                    MenuId = temp.MenuId
                });
            }
            return result.OrderBy(t => t.ControllerName).ToList();
        }
        public List<FYDropDown> GetFinancialYears()
        {
            var data = _dbContext.Fun_GetFinancialYear();
            var result = data.AsEnumerable().Select(x => new FYDropDown()
            {
                Text = x.FYStartDate.Value.ToString("dd MMM yyyy", CultureInfo.InvariantCulture) + " - " +
                x.FYEndDate.Value.ToString("dd MMM yyyy", CultureInfo.InvariantCulture),
                StartYear = x.StartYear.Value
            })
                           .OrderByDescending(x => x.StartYear)
                           .ToList();
            return result ?? new List<FYDropDown>();
        }

        public List<FYDropDown> GetFinancialYearsForUser(string UserAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(UserAbrhs), out userId);
            var data = _dbContext.Fun_GetUserWiseFinancialYear(userId);
            var result = data.AsEnumerable().Select(x => new FYDropDown()
            {
                Text = x.FYStartDate.Value.ToString("dd MMM yyyy", CultureInfo.InvariantCulture) + " - " +
                x.FYEndDate.Value.ToString("dd MMM yyyy", CultureInfo.InvariantCulture),
                StartYear = x.StartYear.Value
            })
                           .OrderByDescending(x => x.StartYear)
                           .ToList();
            return result ?? new List<FYDropDown>();
        }
        public List<FYDropDown> GetQuartersForFY(int year)
        {
            var data = _dbContext.Fun_GetQuartersForFY(year);
            var result = data.AsEnumerable().Select(x => new FYDropDown()
            {
                Text = x.QStartDate.Value.ToString("dd MMM yyyy", CultureInfo.InvariantCulture) + " - " +
                x.QEndDate.Value.ToString("dd MMM yyyy", CultureInfo.InvariantCulture),
                StartYear = x.QNumber.Value
            })
                           .OrderByDescending(x => x.StartYear)
                           .ToList();
            return result ?? new List<FYDropDown>();
        }
        public List<FYDropDown> GetFYMonths(int year)
        {
            string[] names = DateTimeFormatInfo.CurrentInfo.MonthNames;
            var details = new List<FYDropDown>();
            // to get Apr-Dec
            for (var i = 3; i < 12; i++)
            {
                var info = new FYDropDown
                {
                    Text = names[i].Substring(0, 3) + " " + year,
                    StartYear = i + 1,
                };
                details.Add(info);
            }
            //to get Jan-Mar
            for (var i = 0; i < 3; i++)
            {
                var newYear = year + 1;
                var info = new FYDropDown
                {
                    Text = names[i].Substring(0, 3) + " " + newYear,
                    StartYear = i + 1,
                };
                details.Add(info);
            }
            return details;
        }


        public List<CommonEntitiesBO> GetDesignationGroups(bool isOnlyActive = true)
        {
            var result = new List<CommonEntitiesBO>();
            var data = _dbContext.DesignationGroups.ToList();
            if (isOnlyActive)
                data = data.Where(x => x.IsActive).ToList();
            foreach (var temp in data)
            {
                result.Add(new CommonEntitiesBO
                {
                    EntityAbrhs = CryptoHelper.Encrypt(temp.DesignationGroupId.ToString()),
                    EntityName = temp.DesignationGroupName,
                });
            }
            return result.OrderBy(t => t.EntityName).ToList();
        }

        public List<DesignationBO> GetDesignations(string designationGroupAbrhs)
        {
            var data = new List<MIS.Model.Designation>();
            if (string.IsNullOrEmpty(designationGroupAbrhs))
                data = _dbContext.Designations.Where(x => x.DesignationId > 0).ToList();
            else
            {
                var designationGroupId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(designationGroupAbrhs), out designationGroupId);
                data = _dbContext.Designations.Where(x => x.DesignationId > 0 && x.DesignationGroupId == designationGroupId).ToList();
            }
            var result = new List<DesignationBO>();
            foreach (var temp in data)
            {
                result.Add(new DesignationBO
                {
                    DesignationAbrhs = CryptoHelper.Encrypt(temp.DesignationId.ToString()),
                    DesignationName = temp.DesignationName,
                });
            }
            return result.OrderBy(t => t.DesignationName).ToList();
        }

        #region User Activity Logging
        /// <summary>
        /// Method to log user activity for login attempt
        /// </summary>
        /// <param name="userId">UserId</param>
        /// <param name="userName">UserName</param>
        /// <param name="browserInfo">BrowserInfo</param>
        /// <param name="clientInfo">ClientInfo</param>
        /// <param name="activityStatus">ActivityStatus</param>
        /// <param name="activityDetail">ActivityDetail</param>
        /// <returns></returns>
        public bool LogUserActivity(int userId, string userName, string browserInfo, string clientInfo, string activityStatus, string activityDetail)
        {
            var activityLog = new UserActivityLog
            {
                UserId = userId,
                UserName = userName,
                BrowserInfo = browserInfo,
                ActivityStatus = activityStatus,
                ActivityDetail = activityDetail,
                LoginTime = DateTime.Now,
                LogoutTime = null,
                ClientInfo = (string.IsNullOrEmpty(clientInfo) || clientInfo.ToLower() == "null") ? null : clientInfo
            };

            if (!string.IsNullOrEmpty(clientInfo) && clientInfo.ToLower() != "null")
            {
                JToken token = JObject.Parse(clientInfo); // parse as object  
                activityLog.Device = (String)token.SelectToken("device");
                activityLog.Latitude = (String)token.SelectToken("lat");
                activityLog.Longitude = (String)token.SelectToken("lon");
                activityLog.TimeZone = (String)token.SelectToken("timezone");
                activityLog.City = (String)token.SelectToken("city");
                activityLog.Country = (String)token.SelectToken("country");
                activityLog.ISP = (String)token.SelectToken("isp");
                activityLog.IPAddress = (String)token.SelectToken("query");
            }

            _dbContext.UserActivityLogs.Add(activityLog);
            _dbContext.SaveChanges();
            return true;
        }

        #endregion

        /// <summary>
        /// Get Reporting Managers In A Department
        /// </summary>
        /// <param name="departmentId"></param>
        /// <returns></returns>
        public List<UserInADepartment> GetReportingManagersInADepartment(string departmentIds)
        {
            using (var context = new MISEntities())
            {
                List<UserInADepartment> lList = new List<UserInADepartment>();
                var result = context.spGetReportingManagerForADepartment(departmentIds).ToList();
                if (result.Any())
                {
                    foreach (var r in result)
                    {
                        lList.Add(new UserInADepartment
                        {
                            EmployeeAbrhs = CryptoHelper.Encrypt(r.UserId.ToString()),
                            EmployeeId = r.UserId,
                            Name = r.ReportingManagerName,
                        });
                    }
                    return lList.OrderBy(t => t.Name).ToList();
                }
                return new List<UserInADepartment>();
            }
        }
        public List<UserInADepartment> GetReportingManagersInATeam(string teamIds)
        {
            using (var context = new MISEntities())
            {
                var TeamIds = MIS.Utilities.CustomExtensions.SplitUseridsToIntList(teamIds);
                var reportTo = string.Join(",", TeamIds.ToList());
                List<UserInADepartment> lList = new List<UserInADepartment>();
                var result = context.spGetTeamWiseReportingManagers(reportTo).ToList();
                if (result.Any())
                {
                    foreach (var r in result)
                    {
                        lList.Add(new UserInADepartment
                        {
                            EmployeeAbrhs = CryptoHelper.Encrypt(r.UserId.ToString()),
                            EmployeeId = r.UserId,
                            Name = r.ReportingManagerName,
                        });
                    }
                    return lList.OrderBy(t => t.Name).ToList();
                }
                return new List<UserInADepartment>();
            }
        }
        public List<Teams> GetTeamNames(string departmentIds)
        {
            using (var context = new MISEntities())
            {
                List<Teams> lList = new List<Teams>();
                var result = context.spGetDepartmentWiseTeams(departmentIds).ToList();
                if (result.Any())
                {
                    foreach (var r in result)
                    {
                        lList.Add(new Teams
                        {
                            TeamAbrhs = CryptoHelper.Encrypt(r.TeamId.ToString()),
                            TeamId = r.TeamId.ToString(),
                            TeamName = r.TeamName,
                        });
                    }
                    return lList.OrderBy(t => t.TeamName).ToList();
                }
                return new List<Teams>();
            }
        }

        public bool GetPermissionToViewAttendance(int userId)
        {
            var vwUser = _dbContext.Fun_GetUserToViewAttendance(userId).FirstOrDefault();
            return vwUser.IsEligible.HasValue ? vwUser.IsEligible.Value : false;
        }
        /// <summary>
        /// Get Users For Reports By UserId And Department Id And Reporting Manager Wise
        /// </summary>
        /// <param name="userAbrhs"></param>
        /// <param name="date"></param>
        /// <param name="departmentId"></param>
        /// <param name="reportTo"></param>
        /// <returns></returns>
        /// 
        public EmployeeInfoForReports GetUsersForReports(string userAbrhs, string date, string departmentId, string reportToAbrhs, string menuAbrhs, string locationIds)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var response = GetPermissionToViewAttendance(userId);
            var output = new EmployeeInfoForReports();
            var lList = new List<UserInADepartment>();
            string[] locIds = locationIds.Split(',');
            int[] loIds = new int[locIds.Length];
            for (var i = 0; i < locIds.Length; i++)
            {
                Int32.TryParse(locIds[i], out loIds[i]);
            }
            var userDl = _dbContext.Users.Where(u => loIds.Contains(u.LocationId)).ToList();
            if (response)
            {
                var userAbrhsList = MIS.Utilities.CustomExtensions.SplitUseridsToIntList(reportToAbrhs);
                var reportTo = string.Join(",", userAbrhsList.ToList());

                //var departmentIdsList = MIS.Utilities.CustomExtensions.SplitUseridsToIntList(departmentId);
                //var departmentIds = string.Join(",", departmentIdsList.ToList());

                DateTime selectedDate = DateTime.ParseExact(date, "MM/dd/yyyy", CultureInfo.InvariantCulture);

                using (var context = new MISEntities())
                {
                    List<int> UserIdLists = new List<int>();
                    var menuId = 0;

                    if (menuAbrhs != null)
                    {
                        Int32.TryParse(CryptoHelper.Decrypt(menuAbrhs), out menuId);
                    }
                    UserIdLists.Add(userId);
                    //check and take User Ids.
                    var UserIdList = context.MenusUserDelegations.Where(x => x.MenuId == menuId && x.DelegatedToUserId == userId && x.IsActive
                        && System.Data.Entity.DbFunctions.TruncateTime(DateTime.Now) >= System.Data.Entity.DbFunctions.TruncateTime(x.DelegatedFromDate)
                        && System.Data.Entity.DbFunctions.TruncateTime(DateTime.Now) <= System.Data.Entity.DbFunctions.TruncateTime(x.DelegatedTillDate)
                        ).Select(x => new { UserId = x.DelegatedFromUserId }).GroupBy(x => new { x.UserId }).ToList();
                    if (UserIdList.Any())
                    {
                        UserIdLists.AddRange(UserIdList.Select(x => x.Key.UserId));
                    }

                    foreach (var item in UserIdLists)
                    {
                        var result = context.spGetUsersForReportsByUserIdAndDepartmentIdAndReportingManager(item, selectedDate, departmentId, reportTo, true).ToList();

                        var employees = from t in result
                                        join u in userDl on t.EmployeeId equals u.UserId
                                        select new { u.UserId, t.EmployeeName, t.EmployeeCode };

                        if (employees.Any())
                        {
                            lList = employees.Select(r => new UserInADepartment
                            {
                                EmployeeAbrhs = CryptoHelper.Encrypt(r.UserId.ToString()),
                                EmployeeId = r.UserId,
                                EmployeeCode = r.EmployeeCode,
                                Name = r.EmployeeName + '(' + r.EmployeeCode + ')',
                            }).ToList();
                            var EmployeeCode = lList.OrderBy(o => o.EmployeeCode).ToList();
                            var Name = lList.OrderBy(o => o.Name).ToList();
                            output.OrderedByEmployeeCode.AddRange(EmployeeCode);
                            output.OrderedByEmployeeName.AddRange(Name);
                        }
                    }
                }
            }
            else
            {
                var data = GetAllEmployeesReportingToUser(userAbrhs);
                if (data != null)
                {
                    var employeesNew = from t in data
                                       join u in userDl on t.EmployeeId equals u.UserId
                                       select new { u.UserId, t.EmployeeAbrhs, t.EmployeeName, t.EmployeeCode };

                    if (employeesNew != null)
                    {
                        lList = employeesNew.Select(r => new UserInADepartment
                        {
                            EmployeeAbrhs = r.EmployeeAbrhs,
                            Name = r.EmployeeName + '(' + r.EmployeeCode + ')',
                            EmployeeId = r.UserId,
                            EmployeeCode = r.EmployeeCode
                        }).ToList();
                        var EmployeeCode = lList.OrderBy(o => o.EmployeeCode).ToList();
                        var Name = lList.OrderBy(o => o.Name).ToList();
                        output.OrderedByEmployeeCode.AddRange(EmployeeCode);
                        output.OrderedByEmployeeName.AddRange(Name);
                    }
                }
            }
            return output ?? new EmployeeInfoForReports();
        }

        /// <summary>
        /// Get Skill Level list
        /// </summary>
        /// <returns>BaseDropDown</returns>
        public List<AppraisalStagesBaseDropDown> ListSkillLevel()
        {
            var data = _dbContext.SkillLevels.Where(i => i.IsActive).Select(x => new AppraisalStagesBaseDropDown
            {
                Text = x.SkillLevelName,
                Value = x.SkillLevelId,
                Selected = false,
                SequenceNo = x.Sequence
            }).OrderBy(t => t.SequenceNo).ToList();
            return data;
        }

        /// <summary>
        /// Get Skill list
        /// </summary>
        /// <returns>BaseDropDown</returns>
        public List<BaseDropDown> ListSkill()
        {
            var data = _dbContext.Skills.Where(i => i.IsActive).Select(x => new BaseDropDown
            {
                Text = x.SkillName,
                Value = x.SkillId,
                Selected = false
            }).OrderBy(t => t.Text).ToList();
            return data;
        }

        public List<BaseDropDown> ListSkillTypesForUser()
        {
            var data = _dbContext.SkillTypes.Where(i => i.IsActive && i.IsVisibleToUser).Select(x => new BaseDropDown
            {
                Text = x.SkillTypeName,
                Value = x.SkillTypeId,
                Selected = false
            }).OrderBy(t => t.Text).ToList();
            return data;
        }

        public List<BaseDropDown> ListSkillTypesForHR()
        {
            var data = _dbContext.SkillTypes.Where(i => i.IsActive).Select(x => new BaseDropDown
            {
                Text = x.SkillTypeName,
                Value = x.SkillTypeId,
                Selected = false
            }).OrderBy(t => t.Text).ToList();
            return data;
        }

        /// <summary>
        /// Get User Details By UserId
        /// </summary>
        /// <returns>BaseDropDown</returns>
        public UserDetailProfile GetUserDetailsByUserId(string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                var loginUserData = _dbContext.fnGetHRDetail(userId).FirstOrDefault();

                var currentdate = DateTime.Now;
                var user = (from a in context.Users.Where(x => x.IsActive && x.UserId == userId)
                            select new BO.UserDetailProfile
                            {
                                UserId = a.UserId,
                                UserName = a.UserName,
                                RoleId = a.RoleId,
                                CompanyLocationId = a.LocationId,
                                //CompanyId = a.CompanyId,
                                ImagePath = a.UserDetails.Where(b => b.UserId == a.UserId).FirstOrDefault().ImagePath,
                                FirstName = a.UserDetails.Where(b => b.UserId == a.UserId).FirstOrDefault().FirstName,
                                LastName = a.UserDetails.Where(b => b.UserId == a.UserId).FirstOrDefault().LastName,
                                Designation = loginUserData.DesignationName,
                                IsHRVerifier = loginUserData.IsHRVerifier.Value,
                                RoleName = a.Role.RoleName,
                                Email = a.UserDetails.Where(b => b.UserId == a.UserId).FirstOrDefault().EmailId,
                            }).FirstOrDefault();

                if (user == null)
                {
                    return new UserDetailProfile();
                }
                user.UserName = CryptoHelper.Decrypt(user.UserName.ToString());
                user.Email = CryptoHelper.Decrypt(user.Email.ToString());
                var email = user.Email.Split('@');
                user.Email = email[0] + "@ " + email[1];
                return user;
            }
        }

        #region Meal Managemet

        public List<BaseDropDown> GetMealDishes()
        {
            var data = _dbContext.MealDishes.Where(x => x.IsActive).Select(x => new BaseDropDown
            {
                Text = x.MealDishesName,
                Value = x.MealDishesId,
                Selected = false
            }).OrderBy(t => t.Text).ToList();
            return data;
        }

        public List<BaseDropDown> GetMealPeriod()
        {
            var data = _dbContext.MealPeriods.Where(x => x.IsActive).Select(x => new BaseDropDown
            {
                Text = x.MealPeriodName,
                Value = x.MealPeriodId,
                Selected = false
            }).OrderBy(t => t.Text).ToList();
            return data;
        }

        public List<BaseDropDown> GetMealType()
        {
            var data = _dbContext.MealTypes.Where(x => x.IsActive).Select(x => new BaseDropDown
            {
                Text = x.MealTypeName,
                Value = x.MealTypeId,
                Selected = false
            }).OrderBy(t => t.Text).ToList();
            return data;
        }

        public List<BaseDropDown> GetMealCategory()
        {
            var data = _dbContext.MealCategories.Where(x => x.IsActive).Select(x => new BaseDropDown
            {
                Text = x.MealCategoryName,
                Value = x.MealCategoryId,
                Selected = false
            }).OrderBy(t => t.Text).ToList();
            return data;
        }

        public List<BaseDropDown> GetMealPackages()
        {
            var data = _dbContext.MealPackages.Where(x => x.IsActive).Select(x => new BaseDropDown
            {
                Text = x.MealPackageName,
                Value = x.MealPackageId,
                Selected = false
            }).OrderBy(t => t.Text).ToList();
            return data;
        }

        #endregion

        #region Team Management

        public List<BaseDropDown> GetWeekDays()
        {
            var data = _dbContext.WeekDays.Where(x => x.IsActive).Select(x => new BaseDropDown
            {
                Text = x.WeekDayName,
                Value = x.WeekDayId,
                Selected = false
            }).OrderBy(t => t.Value).ToList();
            return data;
        }

        public List<BaseDropDown> GetTeams()
        {
            var data = _dbContext.Teams.Where(x => x.IsActive).Select(x => new BaseDropDown
            {
                Text = x.TeamName,
                Value = x.TeamId,
                Selected = false
            }).OrderBy(t => t.Text).ToList();
            return data;
        }

        public List<BaseDropDown> GetTeamsByDepartmentId(string departmentAbrhs)
        {
            var departmentId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(departmentAbrhs), out departmentId);

            var activeTeamData = _dbContext.Teams.Where(x => x.IsActive);
            if (departmentId > 0)
                activeTeamData = activeTeamData.Where(x => x.DepartmentId == departmentId);

            var data = activeTeamData.Select(x => new BaseDropDown
            {
                Text = x.TeamName,
                Value = x.TeamId,
                Selected = false
            }).OrderBy(t => t.Text).ToList();
            return data;
        }

        public List<BaseDropDown> GetTeamEmailTypes()
        {
            var data = _dbContext.TeamEmailTypes.Where(x => x.IsActive).Select(x => new BaseDropDown
            {
                Text = x.TeamEmailTypeName,
                Value = x.TeamEmailTypeId,
                Selected = false
            }).OrderBy(t => t.Text).ToList();
            return data;
        }

        public List<BaseDropDown> GetAllDepartments()
        {
            var data = _dbContext.Departments.Select(x => new BaseDropDown
            {
                Text = x.DepartmentName,
                Value = x.DepartmentId,
                Selected = false
            }).OrderBy(t => t.Text).ToList();
            return data;
        }
        public List<EmployeeBO> GetEmployeesReportingToUserByManagerId(string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            var result = new List<EmployeeBO>();
            var reportingEmployees = _dbContext.vwActiveUsers.Where(x => x.RMId == userId).ToList();
            if (reportingEmployees.Any())
            {
                foreach (var temp in reportingEmployees)
                {

                    result.Add(new EmployeeBO
                    {
                        EmployeeAbrhs = CryptoHelper.Encrypt(temp.EmployeeId.ToString()),
                        EmployeeName = temp.EmployeeName
                    });
                }
                return result.OrderBy(t => t.EmployeeName).ToList();
            }
            return result;
        }


        public IList<EmployeeBO> GetActiveEmployees()
        {
            var result = new List<EmployeeBO>();
            var allActiveEmployees = _dbContext.vwActiveUsers.ToList();
            if (allActiveEmployees.Any())
            {
                foreach (var emp in allActiveEmployees)
                {
                    result.Add(new EmployeeBO
                    {
                        EmployeeId = emp.UserId,
                        EmployeeName = emp.EmployeeName
                    });
                }
            }
            return result.OrderBy(t => t.EmployeeName).ToList();
        }


        #endregion

        #region Error Log
        /// <summary>
        /// private method to log error
        /// </summary>
        /// <param name="moduleName"></param>
        /// <param name="ex"></param>
        /// <param name="controllerName"></param>
        /// <param name="actionName"></param>
        /// <param name="iPAddress"></param>
        /// <param name="loginUserId"></param>
        /// <param name="authToken"></param>
        /// <returns>ErrorId</returns>
        private Int64 LogError(string moduleName, Exception ex, string controllerName, string actionName, int loginUserId, string authToken) //string iPAddress,
        {
            var errorId = 0L;
            var error = new ErrorLogBO
            {
                ModuleName = moduleName,
                Source = ex.Source,
                ControllerName = controllerName,
                ActionName = actionName,
                ErrorType = ex.GetType().Name,
                ErrorMessage = ex.InnerException == null ? ex.Message : ex.InnerException.Message,
                TargetSite = ex.TargetSite.Name,
                StackTrace = ex.StackTrace,
                ReportedByUserId = loginUserId,
                CreatedDate = DateTime.Now
            };
            using (var context = new MISEntities())
            {
                var result = new ObjectParameter("ErrorId", typeof(Int64));
                context.spInsertErrorLog(error.ModuleName, error.Source, error.ErrorType, error.ErrorMessage,
                    error.ControllerName, error.ActionName, error.TargetSite, error.StackTrace, error.ReportedByUserId, authToken, result);

                Int64.TryParse(result.Value.ToString(), out errorId);
                return errorId;
            }
        }

        /// <summary>
        ///  public method to log error
        /// </summary>
        /// <param name="ex"></param>
        /// <param name="controllerName"></param>
        /// <param name="actionName"></param>
        /// <param name="loginUserId"></param>
        /// <param name="authToken"></param>
        /// <returns>ErrorId</returns>
        public Int64 LogError(Exception ex, string controllerName, string actionName, int loginUserId, string authToken)
        {
            return LogError("MIS", ex, controllerName, actionName, loginUserId, authToken);
        }

        /// <summary>
        /// public method to log error
        /// </summary>
        /// <param name="ex"></param>
        /// <param name="loginUserId"></param>
        /// <param name="authToken"></param>
        /// <returns>ErrorId</returns>
        public Int64 LogError(Exception ex, int loginUserId, string authToken)
        {
            return LogError(ex, "", "", loginUserId, authToken);
        }

        /// <summary>
        /// public method to log error
        /// </summary>
        /// <param name="ex"></param>
        /// <returns>ErrorId</returns>
        public Int64 LogError(Exception ex)
        {
            return LogError(ex, 0, "");
        }
        #endregion

        public WeekAndDatesBO FetchWeekInfoByDateId(string userAbrhs, int dateId)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            return _dbContext.fnGetWeekInfoByDateId(userId, dateId).Select(x => new WeekAndDatesBO
            {
                StartDateId = x.StartDateId,
                EndDateId = x.EndDateId,
                WeekNo = x.WeekNo,
            }).FirstOrDefault();
        }

        #region Appraisal Common

        public List<BaseDropDown> GetCompanyLocation()
        {
            var data = _dbContext.Locations.Where(x => x.IsActive).Select(x => new BaseDropDown
            {
                Text = x.LocationName,
                Value = x.LocationId,
                Selected = false
            }).OrderBy(t => t.Text).ToList();
            return data;
        }

        public List<BaseDropDown> GetVertical()
        {
            var data = _dbContext.Verticals.Where(x => x.IsActive).Select(x => new BaseDropDown
            {
                Text = x.VerticalName,
                Value = x.VerticalId,
                Selected = false
            }).OrderBy(t => t.Text).ToList();
            return data;
        }

        public List<BaseDropDown> GetDivisionByVertical(int verticalId)
        {
            var data = _dbContext.Divisions.Where(x => x.IsActive && x.VerticalId == verticalId).Select(x => new BaseDropDown
            {
                Text = x.DivisionName,
                Value = x.DivisionId,
                Selected = false
            }).OrderBy(t => t.Text).ToList();
            return data;
        }

        public List<BaseDropDown> GetDepartmentByDivision(string divisionIds)
        {
            var divisionIdList = MIS.Utilities.CustomExtensions.SplitToIntList(divisionIds).ToList();
            var data = _dbContext.Departments.Where(x => x.IsActive && divisionIdList.Contains(x.DivisionId)).Select(x => new BaseDropDown
            {
                Text = x.DepartmentName,
                Value = x.DepartmentId,
                Selected = false
            }).OrderBy(t => t.Text).ToList();
            return data;
        }

        public List<BaseDropDown> GetTeamsByDepartment(string departmentIds)
        {
            var departmentIdList = MIS.Utilities.CustomExtensions.SplitToIntList(departmentIds).ToList();
            var data = _dbContext.Teams.Where(x => x.IsActive && departmentIdList.Contains(x.DepartmentId)).Select(x => new BaseDropDown
            {
                Text = x.TeamName,
                Value = x.TeamId,
                Selected = false
            }).OrderBy(t => t.Text).ToList();
            return data;
        }

        public List<BaseDropDown> GetDesignationsByTeams(string teamIds)
        {
            var data = _dbContext.Fun_GetDesignationListByTeam(teamIds).Select(x => new BaseDropDown
            {
                Text = x.DesignationName,
                Value = x.DesignationId.Value,
                Selected = false
            }).OrderBy(t => t.Text).ToList();
            return data;
        }

        public List<BaseDropDown> GetDesignationsByDepartments(string departments)
        {
            var data = _dbContext.Fun_GetDesignationListByDepartment(departments).Select(x => new BaseDropDown
            {
                Text = x.DesignationName,
                Value = x.DesignationId.Value,
                Selected = false
            }).OrderBy(t => t.Text).ToList();
            return data;
        }

        public List<DesignationByDesigGrpId> GetDesignationsByDesigGrpId(string desigGrpAbrhs)
        {
            var designationGroupId = CryptoHelper.Decrypt(desigGrpAbrhs);
            var data = _dbContext.PROC_GetDesignationListByDesignationGroup(designationGroupId).ToList();
            List<DesignationByDesigGrpId> dataNew = new List<DesignationByDesigGrpId>();
            if (data != null)
            {
                dataNew = data.Select(x => new DesignationByDesigGrpId
                {
                    Text = x.DesignationName,
                    Value = x.DesignationId,
                    DesignationAbrhs = CryptoHelper.Encrypt(x.DesignationId.ToString())
                }).OrderBy(t => t.Text).ToList();
            }


            return dataNew;
        }


        public List<BaseDropDown> GetAppraisalCycle()
        {
            var data = _dbContext.AppraisalCycles.Where(x => x.IsActive).Select(x => new BaseDropDown
            {
                Text = x.AppraisalCycleName,
                Value = x.AppraisalCycleId,
                Selected = false
            }).OrderBy(t => t.Text).ToList();
            return data;
        }

        public List<AppraisalStagesBaseDropDown> GetStageMaster()
        {
            var data = _dbContext.AppraisalStages.Where(x => x.IsActive).Select(x => new AppraisalStagesBaseDropDown
            {
                Text = x.AppraisalStageName,
                Value = x.AppraisalStageId,
                SequenceNo = x.SequenceNo,
                Selected = false
            }).OrderBy(t => t.SequenceNo).ToList();
            return data;
        }

        public List<BaseDropDown> GetCompetency()
        {
            var data = _dbContext.CompetencyTypes.Where(x => x.IsActive).Select(x => new BaseDropDown
            {
                Text = x.CompetencyTypeName,
                Value = x.CompetencyTypeId,
                Selected = false
            }).OrderBy(t => t.Text).ToList();
            return data;
        }

        public List<BaseDropDown> GetParameter(int competencyId)
        {
            var data = _dbContext.AppraisalParameters.Where(x => x.IsActive && x.IsFinalized && x.CompetencyTypeId == competencyId).Select(x => new BaseDropDown
            {
                Text = x.ParameterName,
                Value = x.ParameterId,
                Selected = false
            }).OrderBy(t => t.Text).ToList();
            return data;
        }

        public List<BaseDropDown> GetAppraisalParametersYears()
        {
            var lstYears = _dbContext.AppraisalParameters.Where(p => p.CreatedDate != null).Select(p => new BaseDropDown
            {
                Text = p.CreatedDate.Year.ToString(),
                Value = p.CreatedDate.Year,
                Selected = false
            }).Distinct().AsEnumerable().Select(x => new BaseDropDown
            {
                Text = x.Text,
                Value = x.Value,
                Selected = false
            }).ToList();

            return lstYears;
        }

        public List<BaseDropDown> GetCompetencyList(int feedbackTypeId, int locationId, int verticalId, int divisionId, int departmentId, int designationId, int competencyFormId)
        {
            var data = _dbContext.CompetencyForms.Where(x => !x.IsRetired.Value && x.FeedbackTypeId == feedbackTypeId && x.LocationId == locationId && x.IsFinalized && x.IsActive
                && x.VerticalId == verticalId && x.DivisionId == divisionId && x.DesignationId == designationId && (x.CompetencyFormId == competencyFormId || competencyFormId == 0)).Select(x => new BaseDropDown
                {
                    Text = x.CompetencyFormName,
                    Value = x.CompetencyFormId,
                    Selected = false
                }).OrderBy(t => t.Text).ToList();
            return data;
        }

        #endregion

        public List<EmployeeBO> GetAllEmployeesReportingToUser(string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            var result = new List<EmployeeBO>();
            var reportingEmployees = _dbContext.spGetEmployeesReportingToUser(userId, false, false).ToList();
            if (reportingEmployees.Any())
            {
                foreach (var temp in reportingEmployees)
                {
                    var user = _dbContext.UserDetails.Where(f => f.UserId == temp.EmployeeId).FirstOrDefault();
                    result.Add(new EmployeeBO
                    {
                        EmployeeAbrhs = CryptoHelper.Encrypt(temp.EmployeeId.ToString()),
                        EmployeeName = user.FirstName + " " + user.LastName,
                        EmployeeCode = user.EmployeeId,
                        EmployeeId = user.UserId
                    });
                }
                return result.OrderBy(t => t.EmployeeName).ToList();
            }
            return null;
        }
        #region goal
        public List<BaseDropDown> GetStatusForGoal()
        {
            var data = _dbContext.GoalStatus.Select(x => new BaseDropDown
            {
                Text = x.Status,
                Value = x.GoalStatusId,
                Selected = false
            }).OrderBy(t => t.Text).ToList();
            return data;
        }
        public List<BaseDropDown> GetStatusForGoalsReport()
        {
            var data = _dbContext.GoalStatus.Select(x => new BaseDropDown
            {
                Text = x.Status,
                Value = x.GoalStatusId,
            }).OrderBy(t => t.Text).ToList();
            var additionalData = new BaseDropDown { Text = "Not Submitted", Value = 100 };
            data.Add(additionalData);
            return data;
        }

        #endregion
        #region Invoice
        public List<BaseDropDown> GetAllClients()
        {
            var data = _dbContext.Clients.Where(t => t.IsActive == true).Select(x => new BaseDropDown
            {
                Text = x.ClientName,
                Value = x.ClientId,
                Selected = false
            }).OrderBy(t => t.Text).ToList();
            return data;
        }
        #endregion
        public List<BaseDropDown> GetAllTempCards()
        {
            var data = _dbContext.AccessCards.Where(t => t.IsActive == true && t.IsTemporary == true).Select(x => new BaseDropDown
            {
                Text = x.AccessCardNo,
                Value = x.AccessCardId,
                Selected = false
            }).ToList();
            return data;
        }
        #region VMS


        #endregion
    }
}
