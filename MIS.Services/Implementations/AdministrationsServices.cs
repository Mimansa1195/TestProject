using MIS.BO;
using MIS.Model;
using MIS.Services.Contracts;
using MIS.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.Entity;
using System.Data.Entity.Core.Objects;
using System.Xml.Linq;
using System.Globalization;

namespace MIS.Services.Implementations
{
    public class AdministrationsServices : IAdministrationsServices
    {
        private readonly IUserServices _userServices;
        private readonly MISEntities _dbContext = new MISEntities();

        public AdministrationsServices(IUserServices userServices)
        {
            _userServices = userServices;
        }

        #region Navigation Menu

        public List<MenuBO> GetNavigationMenus(string userAbrhs)
        {
            var menuList = new List<MenuBO>();
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            if (userId > 0)
            {
                menuList = _dbContext.Menus.ToList().Select(m => new MenuBO
                {
                    MenuId = m.MenuId,
                    MenuName = m.MenuName,
                    ParentMenuId = m.ParentMenuId,
                    ControllerName = m.ControllerName,
                    ActionName = m.ActionName,
                    Sequence = m.Sequence,
                    IsLinkEnabled = m.IsLinkEnabled,
                    IsMenuVisible = m.IsVisible,
                    IsActive = m.IsActive,
                    CssClass = m.CssClass,
                    IsDelegatable = m.IsDelegatable,
                    IsTabMenu = m.IsTabMenu,
                    CreatedDate = m.CreatedDate.ToString("dd-MMM-yyyy hh:mm tt")
                }).OrderBy(x => x.ControllerName).ThenBy(x => x.Sequence).ToList();
                return menuList;
            }
            return menuList;
        }
        public MenuBO GetDetailsOfNavigationMenu(int menuId, string userAbrhs)
        {
            var menuDetails = new MenuBO();
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            if (userId > 0)
            {
                var menuData = _dbContext.Menus.Where(x => x.MenuId == menuId).FirstOrDefault();

                menuDetails.MenuId = menuData.MenuId;
                menuDetails.MenuName = menuData.MenuName;
                menuDetails.ParentMenuId = menuData.ParentMenuId;
                menuDetails.ControllerName = menuData.ControllerName;
                menuDetails.ActionName = menuData.ActionName;
                menuDetails.Sequence = menuData.Sequence;
                menuDetails.IsLinkEnabled = menuData.IsLinkEnabled;
                menuDetails.IsMenuVisible = menuData.IsVisible;
                menuDetails.IsActive = menuData.IsActive;
                menuDetails.CssClass = menuData.CssClass;
                menuDetails.IsDelegatable = menuData.IsDelegatable;
                menuDetails.IsTabMenu = menuData.IsTabMenu;
                menuDetails.CreatedDate = menuData.CreatedDate.ToString("dd-MMM-yyyy hh:mm tt");
            }
            return menuDetails;
        }

        public int AddNavigationMenu(NavigationMenuBO input)
        {
            int status = 0;
            var UserId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(input.UserAbrhs), out UserId);

            using (var _dbContext = new MISEntities())
            {
                var result = new ObjectParameter("Success", typeof(int));

                _dbContext.Proc_AddNavigationMenu(input.MenuName, input.ActionName, input.ControllerName, input.Sequence,
                              input.IsLinkEnabled, input.IsMenuVisible, input.CssClass, input.IsDelegatable, input.IsTabMenu, UserId, result);

                Int32.TryParse(result.Value.ToString(), out status);


                _userServices.SaveUserLogs(ActivityMessages.AddNavigationMenu, UserId, 0);

                return status;
            }
        }

        public int UpdateMenus(MenuBO menus)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(menus.UserAbrhs), out userId);


            var data = _dbContext.Menus.FirstOrDefault(x => x.MenuId == menus.MenuId);

            if (data == null)
            {

                return 2;
            }
            data.MenuName = menus.MenuName;
            data.ActionName = menus.ActionName;
            data.ControllerName = menus.ControllerName;
            data.CssClass = menus.CssClass;
            data.Sequence = menus.Sequence;
            data.IsLinkEnabled = menus.IsLinkEnabled;
            data.IsVisible = menus.IsMenuVisible;
            data.IsDelegatable = menus.IsDelegatable;
            data.IsTabMenu = menus.IsTabMenu;
            data.ModifiedDate = DateTime.Now;
            data.ModifiedById = userId;
            _dbContext.SaveChanges();

            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.UpdateMenu, userId, 0);
            return 1;
        }

        public int ChangeMenuStatus(int menuId, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            var data = _dbContext.Menus.FirstOrDefault(x => x.MenuId == menuId);

            if (data != null && data.IsActive)
            {
                data.IsActive = false;
                data.ModifiedDate = DateTime.Now;
                data.ModifiedById = userId;
                _dbContext.SaveChanges();

                _userServices.SaveUserLogs(ActivityMessages.InActiveMenu, userId, 0);
                return 2;
            }

            else
            {
                data.IsActive = true;
                data.ModifiedDate = DateTime.Now;
                data.ModifiedById = userId;
                _dbContext.SaveChanges();

                _userServices.SaveUserLogs(ActivityMessages.ActiveMenu, userId, 0);
                return 1;
            }

        }



        #endregion

        #region Scheduler

        public List<SchedulerActionBO> GetSchedulerActions(string userAbrhs)
        {
            var schedulerList = new List<SchedulerActionBO>();
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            if (userId > 0)
            {
                schedulerList = _dbContext.SchedulerActions.ToList().Select(s => new SchedulerActionBO
                {
                    ActionId = s.ActionId,
                    SchedulerName = s.Name,
                    Description = s.Description,
                    FunctionName = s.FunctionName,
                    RepeatAfterPeriod = Convert.ToInt32(s.RepeatAfterPeriod),
                    RepeatAfterType = s.RepeatAfterType,
                    LastRunTime = s.LastRunTime.HasValue ? s.LastRunTime.Value.ToString("dd-MMM-yyyy hh:mm tt") : "NA",
                    LastRunResult = s.LastRunResult,
                    NextRunTime = s.NextRunTime.HasValue ? s.NextRunTime.Value.ToString("dd-MMM-yyyy hh:mm tt") : "NA",
                    RunFor = CommonUtility.GetEnumDescription<MIS.BO.Enums.SchedulerRunsFor>(s.RunFor),
                    Ids = GetRunFor(s.RunFor, s.Ids),
                    IsActive = s.IsActive,
                    IsDeleted = s.IsDeleted,
                    IsCombinedEmail = s.IsCombinedEmail,
                }).OrderBy(x => x.SchedulerName).ThenBy(x => x.RepeatAfterType).ToList();

                return schedulerList;
            }
            return schedulerList;
        }

        private string GetRunFor(int runsFor, string ids)
        {
            var result = string.Empty;
            if (runsFor != (int)Enums.SchedulerRunsFor.All && !string.IsNullOrEmpty(ids))
            {
                if (runsFor == (int)Enums.SchedulerRunsFor.UserIds)
                {
                    var userIds = ids.Split(',').Select(int.Parse).ToList();
                    result = string.Join(", ", _dbContext.UserDetails.Where(x => userIds.Contains(x.UserId)).Select(u => u.FirstName + " " + u.LastName));
                }
                else if (runsFor == (int)Enums.SchedulerRunsFor.EmailIds)
                {
                    var encEmailIds = ids.Split(',');
                    result = string.Join(", ", encEmailIds.Select(x => CryptoHelper.Decrypt(x)));
                }
            }
            return result;
        }
        public int AddNewScheduler(SchedulerActionBO input, string userAbrhs)
        {
            int status = 0;
            var UserId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out UserId);
            using (var _dbContext = new MISEntities())
            {
                var ids = input.Ids;
                var runTime = DateTime.ParseExact(input.LastRunTime, "dd/MM/yyyy HH:mm", CultureInfo.InvariantCulture);
                var runFor = Convert.ToInt16(input.RunFor);
                if (runFor == 2)
                {
                    ids = string.Join(",", MIS.Utilities.CustomExtensions.SplitUseridsToIntList(ids).ToList());
                }
                if (runFor == 3)
                {
                    var newids = string.Join(",", MIS.Utilities.CustomExtensions.SplitUseridsToIntList(ids).ToList());
                    var userIds = newids.Split(',').Select(int.Parse).ToList();
                    var emailIds = _dbContext.vwActiveUsers.Where(x => userIds.Contains(x.UserId)).Select(x => x.EmailId).ToList();
                    ids = string.Join(",", emailIds);
                }
                var result = new ObjectParameter("Success", typeof(int));
                _dbContext.Proc_AddNewScheduler(input.SchedulerName, input.Description, input.FunctionName, input.RepeatAfterPeriod,
                              input.RepeatAfterType, runFor, ids, runTime, input.IsCombinedEmail, UserId, result);
                Int32.TryParse(result.Value.ToString(), out status);
                _userServices.SaveUserLogs(ActivityMessages.AddNewScheduler, UserId, 0);
                return status;
            }
        }
        public int ChangeStatusOfScheduler(int actionId, int type, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var data = _dbContext.SchedulerActions.FirstOrDefault(x => x.ActionId == actionId);
            var status = 0;
            if (data != null && type == 2)
            {
                data.IsActive = false;
                data.IsDeleted = true;
                data.LastModifiedDate = DateTime.Now;
                data.LastModifiedBy = userId;
                _dbContext.SaveChanges();
                _userServices.SaveUserLogs(ActivityMessages.ChangeStatusOfScheduler, userId, 0);
                status = 2;
            }
            else if (data != null && type == 1)
            {
                data.IsActive = true;
                data.IsDeleted = false;
                data.LastModifiedDate = DateTime.Now;
                data.LastModifiedBy = userId;
                _dbContext.SaveChanges();
                _userServices.SaveUserLogs(ActivityMessages.ChangeStatusOfScheduler, userId, 0);
                status = 1;
            }
            return status;
        }
        public SchedulerActionBO GetDetailsOfScheduler(int actionId)
        {
            var schedulerList = new SchedulerActionBO();
            var idsList = new List<IdBO>();
            var data = _dbContext.SchedulerActions.FirstOrDefault(x => x.ActionId == actionId);
            var ids = "0";
            if (data != null)
            {
                if (data.RunFor == 2)
                {
                    var userIds = data.Ids.Split(',');
                    ids = string.Join(", ", userIds.Select(x => CryptoHelper.Encrypt(x)));
                }
                if (data.RunFor == 3)
                {
                    var emailIds = data.Ids.Split(',').ToList();
                    var userIds = _dbContext.UserDetails.Where(x => emailIds.Contains(x.EmailId)).Select(x => x.UserId).ToList();
                    var newIds = string.Join(",", userIds).Split(',');
                    ids = string.Join(",", newIds.Select(x => CryptoHelper.Encrypt(x)));
                }
                schedulerList.ActionId = data.ActionId;
                schedulerList.SchedulerName = data.Name;
                schedulerList.Description = data.Description;
                schedulerList.FunctionName = data.FunctionName;
                schedulerList.RepeatAfterPeriod = Convert.ToInt32(data.RepeatAfterPeriod);
                schedulerList.RepeatAfterType = data.RepeatAfterType;
                schedulerList.LastRunTime = data.LastRunTime.HasValue ? data.LastRunTime.Value.ToString("dd/MM/yyyy HH:mm", CultureInfo.InvariantCulture) : "NA";
                schedulerList.NextRunTime = data.NextRunTime.HasValue ? data.NextRunTime.Value.ToString("dd/MM/yyyy HH:mm", CultureInfo.InvariantCulture) : "NA";
                schedulerList.RunFor = data.RunFor.ToString();
                schedulerList.Ids = data.RunFor > 1 ? ids : data.Ids;
                schedulerList.IsActive = data.IsActive;
                schedulerList.IsDeleted = data.IsDeleted;
                schedulerList.IsCombinedEmail = data.IsCombinedEmail;
            }
            return schedulerList;
        }
        public int UpdateSchedulerData(SchedulerActionBO input, string userAbrhs)
        {
            var status = 0;
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            var data = _dbContext.SchedulerActions.FirstOrDefault(x => x.ActionId == input.ActionId);
            if (data == null)
            {
                status = 2;
            }
            if (data != null)
            {
                var ids = input.Ids;
                //var formattedLastTime = (Convert.ToDateTime(input.LastRunResult)).ToString("hh:mm tt");
                //var lastRundate = input.LastRunTime + " " + formattedLastTime;

                if (!string.IsNullOrEmpty(input.LastRunTime))
                {
                    var lastRunTime = DateTime.ParseExact(input.LastRunTime, "dd/MM/yyyy HH:mm", CultureInfo.InvariantCulture);
                    data.LastRunTime = lastRunTime;
                }
                if (!string.IsNullOrEmpty(input.NextRunTime))
                {
                    var nextRunTime = DateTime.ParseExact(input.NextRunTime, "dd/MM/yyyy HH:mm", CultureInfo.InvariantCulture);
                    data.NextRunTime = nextRunTime;
                }
                var runFor = Convert.ToInt16(input.RunFor);
                if (runFor == 2)
                {
                    ids = string.Join(",", MIS.Utilities.CustomExtensions.SplitUseridsToIntList(ids).ToList());
                }
                if (runFor == 3)
                {
                    var newids = string.Join(",", MIS.Utilities.CustomExtensions.SplitUseridsToIntList(ids).ToList());
                    var userIds = newids.Split(',').Select(int.Parse).ToList();
                    var emailIds = _dbContext.vwActiveUsers.Where(x => userIds.Contains(x.UserId)).Select(x => x.EmailId).ToList();
                    ids = string.Join(",", emailIds);
                }
                data.Name = input.SchedulerName;
                data.Description = input.Description;
                data.FunctionName = input.FunctionName;
                data.RepeatAfterPeriod = input.RepeatAfterPeriod;
                data.RepeatAfterType = input.RepeatAfterType;
                //data.LastRunTime = lastRunTime;
                data.RunFor = Convert.ToInt16(input.RunFor);
                data.Ids = Convert.ToInt16(input.RunFor) > 1 ? ids : input.Ids;
                data.IsCombinedEmail = input.IsCombinedEmail;
                _dbContext.SaveChanges();
                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.UpdateScheduler, userId, 0);
                status = 1;
            }
            return status;
        }

        #endregion

        #region Role Permissions

        /// <summary>
        /// Method to get menu permissions by role
        /// </summary>
        /// <param name="userAbrhs">UserAbrhs</param>
        /// <param name="roleAbrhs">RoleAbrhs</param>
        /// <returns>ManageMenusPermissionBO</returns>
        public ManageMenusPermissionBO GetMenusRolePermissions(string userAbrhs, string roleAbrhs)
        {
            var menuObj = new ManageMenusPermissionBO();
            menuObj.UserAbrhs = userAbrhs;
            menuObj.RoleAbrhs = roleAbrhs;
            menuObj.IsUserPermission = false;
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            var roleId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(roleAbrhs), out roleId);

            if (userId > 0 && roleId > 0)
            {
                var user = _dbContext.Users.FirstOrDefault(t => t.UserId == userId && t.IsActive);
                var role = _dbContext.Roles.FirstOrDefault(t => t.RoleId == roleId && t.IsDeleted == false);

                //role wise menu access
                if (user != null && role != null && role.RoleId > 0)
                {
                    var inactiveMenuIds = _dbContext.Menus.Where(x => x.ParentMenuId == 0 && x.IsActive == false).Select(t => t.MenuId).ToList();

                    var menusList = (from m in _dbContext.Menus.Where(x => x.IsActive == true)
                                     join p in _dbContext.MenusRolePermissions.Where(x => x.RoleId == role.RoleId) on m.MenuId equals p.MenuId into list1
                                     from l1 in list1.DefaultIfEmpty()
                                     where !inactiveMenuIds.Contains(m.ParentMenuId)
                                     select new UserAndRoleMenusPermissionBO
                                     {
                                         MenuPermissionId = (l1.MenusRolePermissionId == null) ? 0 : l1.MenusRolePermissionId,
                                         MenuId = m.MenuId,
                                         MenuName = m.MenuName,
                                         ParentMenuId = m.ParentMenuId,
                                         ControllerName = m.ControllerName,
                                         ActionName = m.ActionName,
                                         Sequence = (m.ParentMenuId == 0) ? 0 : m.Sequence,
                                         IsLinkEnabled = m.IsLinkEnabled,
                                         IsViewRights = (l1.IsViewRights == null) ? false : l1.IsViewRights,
                                         IsAddRights = (l1.IsAddRights == null) ? false : l1.IsAddRights,
                                         IsModifyRights = (l1.IsModifyRights == null) ? false : l1.IsModifyRights,
                                         IsDeleteRights = (l1.IsDeleteRights == null) ? false : l1.IsDeleteRights,
                                         IsAssignRights = (l1.IsAssignRights == null) ? false : l1.IsAssignRights,
                                         IsApproveRights = (l1.IsApproveRights == null) ? false : l1.IsApproveRights,
                                         IsVisible = m.IsVisible,
                                         CssClass = m.CssClass,
                                         IsActive = (l1.IsActive == null) ? true : l1.IsActive
                                     }).OrderBy(x => x.ControllerName).ThenBy(x => x.Sequence);
                    menuObj.MenuPermission = menusList.ToList<UserAndRoleMenusPermissionBO>() ?? new List<UserAndRoleMenusPermissionBO>();
                }
            }
            return menuObj;
        }

        /// <summary>
        /// Method to get menu permissions by user
        /// </summary>
        /// <param name="userAbrhs">UserAbrhs</param>
        /// <param name="employeeAbrhs">EmployeeAbrhs</param>
        /// <returns>ManageMenusPermissionBO</returns>
        public ManageMenusPermissionBO GetMenusUserPermissions(string userAbrhs, string employeeAbrhs)
        {
            var menuObj = new ManageMenusPermissionBO();
            menuObj.UserAbrhs = userAbrhs;
            menuObj.EmployeeAbrhs = employeeAbrhs;
            menuObj.IsUserPermission = true;

            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            var employeeId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(employeeAbrhs), out employeeId);

            if (userId > 0 && employeeId > 0)
            {
                var user = _dbContext.Users.FirstOrDefault(t => t.UserId == userId && t.IsActive);
                var employee = _dbContext.Users.FirstOrDefault(t => t.UserId == employeeId && t.IsActive == true);
                //user wise menu access
                if (user != null && employee != null && employee.UserId > 0)
                {
                    var inactiveMenuIds = _dbContext.Menus.Where(x => x.ParentMenuId == 0 && x.IsActive == false).Select(t => t.MenuId).ToList();
                    var userPermissions = _dbContext.MenusUserPermissions.Where(x => x.UserId == employee.UserId);
                    var menusList = (from m in _dbContext.Menus.Where(x => x.IsActive == true)
                                     join p in userPermissions on m.MenuId equals p.MenuId into list1
                                     from l1 in list1.DefaultIfEmpty()
                                     where !inactiveMenuIds.Contains(m.ParentMenuId)
                                     select new UserAndRoleMenusPermissionBO
                                     {
                                         MenuPermissionId = (l1.MenusUserPermissionId == null) ? 0 : l1.MenusUserPermissionId,
                                         MenuId = m.MenuId,
                                         MenuName = m.MenuName,
                                         ParentMenuId = m.ParentMenuId,
                                         ControllerName = m.ControllerName,
                                         ActionName = m.ActionName,
                                         Sequence = (m.ParentMenuId == 0) ? 0 : m.Sequence,
                                         IsLinkEnabled = m.IsLinkEnabled,
                                         IsViewRights = (l1.IsViewRights != null) ? l1.IsViewRights : false,
                                         IsAddRights = (l1.IsAddRights != null) ? l1.IsAddRights : false,
                                         IsModifyRights = (l1.IsModifyRights != null) ? l1.IsModifyRights : false,
                                         IsDeleteRights = (l1.IsDeleteRights != null) ? l1.IsDeleteRights : false,
                                         IsAssignRights = (l1.IsAssignRights != null) ? l1.IsAssignRights : false,
                                         IsApproveRights = (l1.IsApproveRights != null) ? l1.IsApproveRights : false,
                                         IsVisible = m.IsVisible,
                                         CssClass = m.CssClass,
                                         IsActive = (l1.IsActive == null) ? true : l1.IsActive
                                     }).OrderBy(x => x.ControllerName).ThenBy(x => x.Sequence);

                    var userPermissionList = menusList.ToList<UserAndRoleMenusPermissionBO>();
                    if (!userPermissions.Any())
                    {
                        var dashboardUserPermission = userPermissionList.FirstOrDefault(x => x.ControllerName == "Dashboard" && x.ActionName == "Index");
                        var roleId = employee.RoleId;
                        var dashboardRolePermission = _dbContext.MenusRolePermissions.FirstOrDefault(x => x.RoleId == roleId && x.MenuId == dashboardUserPermission.MenuId);

                        foreach (var item in userPermissionList.Where(x => x.MenuId == dashboardUserPermission.MenuId))
                        {
                            if (dashboardRolePermission != null)
                            {
                                item.IsViewRights = dashboardRolePermission.IsViewRights;
                                item.IsAddRights = dashboardRolePermission.IsAddRights;
                                item.IsModifyRights = dashboardRolePermission.IsModifyRights;
                                item.IsDeleteRights = dashboardRolePermission.IsDeleteRights;
                                item.IsAssignRights = dashboardRolePermission.IsAssignRights;
                                item.IsApproveRights = dashboardRolePermission.IsApproveRights;
                                item.IsActive = dashboardRolePermission.IsActive;
                            }
                            else
                            {
                                item.IsViewRights = true;
                                item.IsActive = true;
                            }
                        }
                    }

                    menuObj.MenuPermission = userPermissionList ?? new List<UserAndRoleMenusPermissionBO>();
                }
            }
            return menuObj;
        }

        /// <summary>
        /// Method to add or update menus role's/user's permissions
        /// </summary>
        /// <param name="permission">ManageMenusPermissionBO</param>
        /// <returns>success : 1, error: 0, invalid: 2</returns>
        public int AddUpdateMenusPermissions(ManageMenusPermissionBO permission)
        {
            var status = 0;
            if (permission != null && permission.MenuPermission.Any() && !string.IsNullOrWhiteSpace(permission.UserAbrhs) && (!string.IsNullOrWhiteSpace(permission.EmployeeAbrhs) || !string.IsNullOrWhiteSpace(permission.RoleAbrhs)))
            {
                var userId = 0;
                var employeeId = 0;
                var roleId = 0;

                Int32.TryParse(CryptoHelper.Decrypt(permission.UserAbrhs), out userId);

                var xmlElements = new XElement("root",
                    from mp in permission.MenuPermission
                    select new XElement("row",
                            new XAttribute("MenuPermissionId", mp.MenuPermissionId),
                            new XAttribute("MenuId", mp.MenuId),
                            new XAttribute("IsViewRights", mp.IsViewRights),
                            new XAttribute("IsAddRights", mp.IsAddRights),
                            new XAttribute("IsModifyRights", mp.IsModifyRights),
                            new XAttribute("IsDeleteRights", mp.IsDeleteRights),
                            new XAttribute("IsAssignRights", mp.IsAssignRights),
                            new XAttribute("IsApproveRights", mp.IsApproveRights)
                            ));

                //  new XAttribute("MenuId", emp.MenuId) // will create attribute for each row
                //  new XElement("MenuId", emp.MenuId), // will create node for each row

                if (permission.IsUserPermission) // update user permission
                {
                    Int32.TryParse(CryptoHelper.Decrypt(permission.EmployeeAbrhs), out employeeId);
                    var result = new ObjectParameter("Success", typeof(int));
                    _dbContext.spAddUpdateMenusPermissions(true, userId, employeeId, 0, xmlElements.ToString(), result);

                    Int32.TryParse(result.Value.ToString(), out status);

                    // Logging
                    if (status == 1)
                        _userServices.SaveUserLogs(ActivityMessages.AddUpdateMenusUserPermissions, userId, employeeId);

                    return status;
                }
                else // update role permission
                {
                    Int32.TryParse(CryptoHelper.Decrypt(permission.RoleAbrhs), out roleId);
                    var result = new ObjectParameter("Success", typeof(int));
                    _dbContext.spAddUpdateMenusPermissions(false, userId, 0, roleId, xmlElements.ToString(), result);

                    Int32.TryParse(result.Value.ToString(), out status);

                    // Logging
                    if (status == 1)
                        _userServices.SaveUserLogs(ActivityMessages.AddUpdateMenusRolePermissions, userId, 0);

                    return status;
                }
            }
            else
            {
                return status;
            }
        }

        #endregion

        #region Dashboard Widget Permissions

        /// <summary>
        /// Method to get dashboard widget permissions by role
        /// </summary>
        /// <param name="userAbrhs">UserAbrhs</param>
        /// <param name="roleAbrhs">RoleAbrhs</param>
        /// <returns>ManageDashboardWidgetPermissionBO</returns>
        public ManageDashboardWidgetPermissionBO GetWidgetsRolePermissions(string userAbrhs, string roleAbrhs)
        {
            var widgetObj = new ManageDashboardWidgetPermissionBO();
            widgetObj.UserAbrhs = userAbrhs;
            widgetObj.RoleAbrhs = roleAbrhs;
            widgetObj.IsUserPermission = false;
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            var roleId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(roleAbrhs), out roleId);

            if (userId > 0 && roleId > 0)
            {
                var user = _dbContext.Users.FirstOrDefault(t => t.UserId == userId && t.IsActive);
                var role = _dbContext.Roles.FirstOrDefault(t => t.RoleId == roleId && t.IsDeleted == false);

                //role wise widget access
                if (user != null && role != null && role.RoleId > 0)
                {
                    var widgetsList = (from d in _dbContext.DashboardWidgets.Where(x => x.IsActive == true)
                                       join p in _dbContext.DashboardWidgetRolePermissions.Where(x => x.RoleId == role.RoleId) on d.DashboardWidgetId equals p.DashboardWidgetId into list1
                                       from l1 in list1.DefaultIfEmpty()
                                       select new UserAndRoleDashboardWidgetPermissionBO
                                       {
                                           WidgetPermissionId = (l1.DashboardWidgetRolePermissionId == null) ? 0 : l1.DashboardWidgetRolePermissionId,
                                           WidgetId = d.DashboardWidgetId,
                                           WidgetName = d.DashboardWidgetName,
                                           Sequence = l1.Sequence,
                                           IsViewRights = (l1.IsActive == null) ? false : l1.IsActive,
                                           IsActive = (l1.IsActive == null) ? true : l1.IsActive
                                       }).OrderBy(x => x.Sequence).ThenBy(x => x.WidgetName);
                    widgetObj.WidgetPermission = widgetsList.ToList<UserAndRoleDashboardWidgetPermissionBO>() ?? new List<UserAndRoleDashboardWidgetPermissionBO>();
                }
            }
            return widgetObj;
        }

        /// <summary>
        /// Method to get dashboard widget permissions by user
        /// </summary>
        /// <param name="userAbrhs">UserAbrhs</param>
        /// <param name="employeeAbrhs">EmployeeAbrhs</param>
        /// <returns>ManageDashboardWidgetPermissionBO</returns>
        public ManageDashboardWidgetPermissionBO GetWidgetsUserPermissions(string userAbrhs, string employeeAbrhs)
        {
            var widgetObj = new ManageDashboardWidgetPermissionBO();
            widgetObj.UserAbrhs = userAbrhs;
            widgetObj.EmployeeAbrhs = employeeAbrhs;
            widgetObj.IsUserPermission = true;

            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            var employeeId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(employeeAbrhs), out employeeId);

            if (userId > 0 && employeeId > 0)
            {
                var user = _dbContext.Users.FirstOrDefault(t => t.UserId == userId && t.IsActive);
                var employee = _dbContext.Users.FirstOrDefault(t => t.UserId == employeeId && t.IsActive == true);

                //user wise widget access
                if (user != null && employee != null && employee.UserId > 0)
                {
                    int i = 1;
                    var widgetsUserPermissions = _dbContext.DashboardWidgetUserPermissions.Where(x => x.UserId == employee.UserId);
                    var widgetsList = (from d in _dbContext.DashboardWidgets.Where(x => x.IsActive == true)
                                       join p in widgetsUserPermissions on d.DashboardWidgetId equals p.DashboardWidgetId into list1
                                       from l1 in list1.DefaultIfEmpty()
                                           //let seq = i++
                                       select new UserAndRoleDashboardWidgetPermissionBO
                                       {
                                           WidgetPermissionId = (l1.DashboardWidgetUserPermissionId == null) ? 0 : l1.DashboardWidgetUserPermissionId,
                                           WidgetId = d.DashboardWidgetId,
                                           WidgetName = d.DashboardWidgetName,
                                           Sequence = l1.Sequence,
                                           IsViewRights = (l1.IsActive == null) ? false : l1.IsActive,
                                           IsActive = (l1.IsActive == null) ? true : l1.IsActive
                                       }).OrderBy(x => x.Sequence).ThenBy(x => x.WidgetName);

                    var userPermissionList = widgetsList.ToList<UserAndRoleDashboardWidgetPermissionBO>();
                    //if (!widgetsUserPermissions.Any())
                    //{
                    //    var dashboardUserPermission = userPermissionList.FirstOrDefault(x => x.WidgetName == "Holiday");
                    //    var roleId = employee.RoleId;
                    //    var dashboardRolePermission = _dbContext.DashboardWidgetRolePermissions.FirstOrDefault(x => x.RoleId == roleId && x.DashboardWidgetId == dashboardUserPermission.WidgetId);

                    //    foreach (var item in userPermissionList.Where(x => x.WidgetId == dashboardUserPermission.WidgetId))
                    //    {
                    //        item.IsActive = dashboardRolePermission.IsActive;
                    //    }
                    //}

                    widgetObj.WidgetPermission = userPermissionList ?? new List<UserAndRoleDashboardWidgetPermissionBO>();
                }
            }
            return widgetObj;
        }

        /// <summary>
        /// Method to add or update dashboard widgets role's/user's permissions
        /// </summary>
        /// <param name="permission">ManageDashboardWidgetPermissionBO</param>
        /// <returns>success : 1, error: 0, invalid: 2</returns>
        public int AddUpdateWidgetPermissions(ManageDashboardWidgetPermissionBO permission)
        {
            var status = 0;
            if (permission != null && permission.WidgetPermission.Any() && !string.IsNullOrWhiteSpace(permission.UserAbrhs) && (!string.IsNullOrWhiteSpace(permission.EmployeeAbrhs) || !string.IsNullOrWhiteSpace(permission.RoleAbrhs)))
            {
                var userId = 0;
                var employeeId = 0;
                var roleId = 0;

                Int32.TryParse(CryptoHelper.Decrypt(permission.UserAbrhs), out userId);

                var xmlElements = new XElement("root",
                    from wp in permission.WidgetPermission
                    select new XElement("row",
                            new XAttribute("WidgetPermissionId", wp.WidgetPermissionId),
                            new XAttribute("DashboardWidgetId", wp.WidgetId),
                            new XAttribute("Sequence", wp.Sequence),
                            new XAttribute("IsViewRights", wp.IsViewRights)
                            ));

                if (permission.IsUserPermission) // update user permission
                {
                    Int32.TryParse(CryptoHelper.Decrypt(permission.EmployeeAbrhs), out employeeId);
                    var result = new ObjectParameter("Success", typeof(int));
                    _dbContext.spAddUpdateDashboardWidgetPermissions(true, userId, employeeId, 0, xmlElements.ToString(), result);

                    Int32.TryParse(result.Value.ToString(), out status);

                    // Logging
                    if (status == 1)
                        _userServices.SaveUserLogs(ActivityMessages.AddUpdateWidgetsUserPermissions, userId, employeeId);

                    return status;
                }
                else // update role permission
                {
                    Int32.TryParse(CryptoHelper.Decrypt(permission.RoleAbrhs), out roleId);
                    var result = new ObjectParameter("Success", typeof(int));
                    _dbContext.spAddUpdateDashboardWidgetPermissions(false, userId, 0, roleId, xmlElements.ToString(), result);

                    Int32.TryParse(result.Value.ToString(), out status);

                    // Logging
                    if (status == 1)
                        _userServices.SaveUserLogs(ActivityMessages.AddUpdateWidgetsRolePermissions, userId, 0);

                    return status;
                }
            }
            else
            {
                return status;
            }
        }

        #endregion



        #region Delegation

        public int SaveMenuDelegation(DelegationBO delegationBO)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(delegationBO.UserAbrhs), out userId);

            var empId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(delegationBO.EmpAbrhs), out empId);

            var menuId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(delegationBO.MenuAbrhs), out menuId);

            // Check User has Right to delegate this menu.
            bool hasRight = false;
            var checkRightUserWise = new MenusUserPermission();
            var checkRightRoleWise = new MenusRolePermission();
            var menuRights = new MenusRights();

            // Check For Already has the delegated menu form the same user.
            var checkExist = _dbContext.Proc_IsAlreadyMenuDelegated(menuId, userId, empId, delegationBO.FromDate, delegationBO.ToDate).FirstOrDefault();
            if (checkExist.Value == true)
            {
                return 3;
            }

            //User Wise.
            checkRightUserWise = _dbContext.MenusUserPermissions.FirstOrDefault(x => x.IsActive && x.MenuId == menuId && x.UserId == userId);
            if (checkRightUserWise != null)
            {
                hasRight = true;
                menuRights.IsViewRights = checkRightUserWise.IsViewRights;
                menuRights.IsAddRights = checkRightUserWise.IsAddRights;
                menuRights.IsModifyRights = checkRightUserWise.IsModifyRights;
                menuRights.IsDeleteRights = checkRightUserWise.IsDeleteRights;
                menuRights.IsAssignRights = checkRightUserWise.IsAssignRights;
                menuRights.IsApproveRights = checkRightUserWise.IsApproveRights;
            }
            else
            {
                //Role wise
                var RoleId = _dbContext.Users.FirstOrDefault(x => x.UserId == userId).RoleId;
                checkRightRoleWise = _dbContext.MenusRolePermissions.FirstOrDefault(x => x.IsActive && x.MenuId == menuId && x.RoleId == RoleId);
                if (checkRightRoleWise != null)
                {
                    hasRight = true;
                    menuRights.IsViewRights = checkRightRoleWise.IsViewRights;
                    menuRights.IsAddRights = checkRightRoleWise.IsAddRights;
                    menuRights.IsModifyRights = checkRightRoleWise.IsModifyRights;
                    menuRights.IsDeleteRights = checkRightRoleWise.IsDeleteRights;
                    menuRights.IsAssignRights = checkRightRoleWise.IsAssignRights;
                    menuRights.IsApproveRights = checkRightRoleWise.IsApproveRights;
                }
                else
                {
                    return 2;
                }
            }

            if (hasRight)
            {
                MenusUserDelegation menusUserDelegation = new MenusUserDelegation();
                menusUserDelegation.MenuId = menuId;
                menusUserDelegation.DelegatedFromUserId = userId;
                menusUserDelegation.DelegatedToUserId = empId;
                menusUserDelegation.DelegatedFromDate = delegationBO.FromDate;
                menusUserDelegation.DelegatedTillDate = delegationBO.ToDate;
                menusUserDelegation.CreatedById = userId;
                menusUserDelegation.CreatedDate = DateTime.Now;
                menusUserDelegation.IsActive = true;
                menusUserDelegation.IsViewRights = menuRights.IsViewRights;
                menusUserDelegation.IsAddRights = menuRights.IsAddRights;
                menusUserDelegation.IsModifyRights = menuRights.IsModifyRights;
                menusUserDelegation.IsDeleteRights = menuRights.IsDeleteRights;
                menusUserDelegation.IsAssignRights = menuRights.IsAssignRights;
                menusUserDelegation.IsApproveRights = menuRights.IsApproveRights;

                _dbContext.MenusUserDelegations.Add(menusUserDelegation);
                _dbContext.SaveChanges();

                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.SaveMenuDelegation, userId, 0);
                return 1;
            }
            return 0;
        }

        public List<DelegationBOList> GetMenuDelegation(string userAbrhs, string menuAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            var menuId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(menuAbrhs), out menuId);

            List<DelegationBOList> delegationBOList = new List<DelegationBOList>();

            delegationBOList = _dbContext.MenusUserDelegations.Where(x => x.MenuId == menuId && x.DelegatedFromUserId == userId).Select(x => new DelegationBOList
            {
                MenusUserDelegationId = x.MenusUserDelegationId,
                FromDate = x.DelegatedFromDate,
                ToDate = x.DelegatedTillDate,
                Employee = x.User1.UserDetails.FirstOrDefault().FirstName + " " + x.User1.UserDetails.FirstOrDefault().LastName,
                IsActive = x.IsActive,
            }).ToList();

            return delegationBOList;
        }

        public int DeleteMenuDelegation(int menusUserDelegationId, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            //check Exist.
            var checkExist = _dbContext.MenusUserDelegations.FirstOrDefault(x => x.MenusUserDelegationId == menusUserDelegationId && x.IsActive && x.DelegatedFromUserId == userId);

            if (checkExist == null)
            {
                return 2;
            }
            checkExist.IsActive = false;
            checkExist.ModifiedById = userId;
            checkExist.ModifiedDate = DateTime.Now;
            _dbContext.SaveChanges();

            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.DeleteMenuDelegation, userId, 0);
            return 1;
        }


        #endregion

        #region Error Logs

        public List<ErrorLogsBO> GetErrorLogs(DateTime date)
        {
            List<ErrorLogsBO> ErrorLogsList = new List<ErrorLogsBO>();

            ErrorLogsList = _dbContext.spGetErrorLogs(date).Select(x => new ErrorLogsBO
            {
                ErrorId = x.ErrorId,
                ModuleName = x.ModuleName,
                Source = x.Source,
                ControllerName = x.ControllerName,
                ActionName = x.ActionName,
                ErrorType = x.ErrorType,
                ErrorMessage = x.ErrorMessage,
                TargetSite = x.TargetSite,
                ReportedBy = x.ReportedBy,
                CreatedDate = x.CreatedDate
            }).ToList();

            return ErrorLogsList;
        }

        public ErrorLogsBO GetStackTraceById(int errorId)
        {
            ErrorLogsBO ErrorLogs = new ErrorLogsBO();

            var data = _dbContext.ErrorLogs.FirstOrDefault(x => x.ErrorId == errorId);
            if (data != null)
            {
                ErrorLogs.StackTrace = data.StackTrace;
                ErrorLogs.ErrorMessage = data.ErrorMessage;
                ErrorLogs.TargetSite = data.TargetSite;
            }

            return ErrorLogs;
        }

        #endregion

        #region Role

        public int AddRole(RoleList role)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(role.UserAbrhs), out userId);

            //check Exist.
            var checkExist = _dbContext.Roles.Where(x => x.IsActive && x.RoleName == role.RoleName).ToList();

            if (checkExist.Any())
            {
                return 2;
            }

            Role Modal = new Role();
            Modal.RoleName = role.RoleName;
            Modal.IsDeleted = false;
            Modal.AccessSequence = 1;
            Modal.IsActive = true;
            Modal.CreatedDate = DateTime.Now;
            Modal.CreatedById = userId;

            _dbContext.Roles.Add(Modal);
            _dbContext.SaveChanges();
            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.AddRole, userId, 0);
            return 1;
        }

        public List<RoleList> GetAllRoles(string userAbrhs)
        {
            if (string.IsNullOrEmpty(userAbrhs))
                return new List<RoleList>();

            var userId = 0;
            var roleId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            if (userId > 0)
            {
                var userData = _dbContext.Users.FirstOrDefault(x => x.UserId == userId && x.IsActive);
                if (userData != null)
                    roleId = userData.RoleId;
                else
                    return new List<RoleList>();
            }
            var roleData = _dbContext.Roles.Where(x => !x.IsDeleted && x.IsActive);
            if ((roleId != (int)Enums.Roles.WebAdministrator))
                roleData = roleData.Where(x => x.RoleId != (int)Enums.Roles.WebAdministrator);

            var roles = roleData.ToList();
            var result = (from R in roles
                          select new RoleList
                          {
                              RoleAbrhs = CryptoHelper.Encrypt(R.RoleId.ToString()),
                              RoleName = R.RoleName
                          }).OrderBy(x => x.RoleName).ToList();
            return result;
        }

        public int UpdateRole(RoleList role)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(role.UserAbrhs), out userId);

            var roleId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(role.RoleAbrhs), out roleId);

            //check Exist.
            var checkExist = _dbContext.Roles.FirstOrDefault(x => x.RoleId == roleId);
            if (checkExist == null)
            {
                return 2;
            }
            checkExist.RoleName = role.RoleName;
            checkExist.ModifiedDate = DateTime.Now;
            checkExist.ModifiedById = userId;

            _dbContext.SaveChanges();

            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.UpdateRole, userId, 0);
            return 1;
        }

        public int DeleteRole(string RoleAbrhs, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            var roleId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(RoleAbrhs), out roleId);

            //check Exist.
            var checkExist = _dbContext.Roles.FirstOrDefault(x => x.RoleId == roleId);

            if (checkExist == null)
            {
                return 2;
            }
            checkExist.IsActive = false;
            checkExist.IsDeleted = true;
            checkExist.ModifiedDate = DateTime.Now;
            checkExist.ModifiedById = userId;

            _dbContext.SaveChanges();

            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.DeleteRole, userId, 0);
            return 1;
        }

        public RoleList GetRole(string RoleAbrhs, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            var roleId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(RoleAbrhs), out roleId);

            RoleList modal = new RoleList();

            if (userId > 0)
            {
                var RoleData = _dbContext.Roles.FirstOrDefault(x => x.IsDeleted == false && x.RoleId == roleId);

                if (RoleData != null)
                {
                    modal.RoleAbrhs = CryptoHelper.Encrypt(RoleData.RoleId.ToString());
                    modal.RoleName = RoleData.RoleName;
                }
                return modal;
            }
            return modal;
        }


        #endregion

        #region User Role

        public List<UserRoleList> GetAllUserRoles(string userAbrhs)
        {
            if (string.IsNullOrEmpty(userAbrhs))
                return new List<UserRoleList>();

            var userId = 0;
            var roleId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            if (userId > 0)
            {
                var userData = _dbContext.Users.FirstOrDefault(x => x.UserId == userId && x.IsActive);
                if (userData != null)
                    roleId = userData.RoleId;

                var allUsersData = _dbContext.Users.Where(x => x.IsActive);
                if ((roleId != (int)Enums.Roles.WebAdministrator))
                    allUsersData = allUsersData.Where(x => x.RoleId != (int)Enums.Roles.WebAdministrator);
                var allUsers = allUsersData.ToList();

                var result = (from U in allUsers
                              join UD in _dbContext.UserDetails on U.UserId equals UD.UserId
                              join R in _dbContext.Roles on U.RoleId equals R.RoleId
                              join D in _dbContext.Designations on UD.DesignationId equals D.DesignationId
                              join dg in _dbContext.DesignationGroups on D.DesignationGroupId equals dg.DesignationGroupId
                              where UD.TerminateDate == null
                              select new UserRoleList
                              {
                                  UserAbrhs = CryptoHelper.Encrypt(Convert.ToString(U.UserId)),
                                  RoleAbrhs = CryptoHelper.Encrypt(Convert.ToString(U.RoleId)),
                                  EmployeeName = UD.FirstName + " " + UD.LastName,
                                  RoleName = R.RoleName,
                                  EmpDesignation = D.DesignationName,
                                  DesignationGroup = dg.DesignationGroupName
                              }).OrderBy(x => x.EmployeeName).ToList();
                return result;
            }
            else
            {
                return new List<UserRoleList>();
            }
        }

        public int UpdateUserRole(UserRoleBO user)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(user.UserAbrhs), out userId);

            var roleId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(user.RoleAbrhs), out roleId);

            var DesignationId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(user.DesignationAbrhs), out DesignationId);

            var LoginuserId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(user.LoginUserAbrhs), out LoginuserId);

            //-----Update User Role in User table------------------------------------------------------------------------------------------//
            //check Exist.
            var checkExist = _dbContext.Users.FirstOrDefault(x => x.UserId == userId);
            if (checkExist == null)
            {
                return 2;
            }
            checkExist.RoleId = roleId;
            checkExist.LastModifiedDate = DateTime.Now;
            checkExist.LastModifiedBy = LoginuserId;

            _dbContext.SaveChanges();

            //-----Update User Designation in Designation table------------------------------------------------------------------------//
            //check Exist.
            var checkUserDetails = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == userId);
            if (checkUserDetails == null)
            {
                return 2;
            }
            checkUserDetails.DesignationId = DesignationId;
            checkUserDetails.LastModifiedDate = DateTime.Now;
            checkUserDetails.LastModifiedBy = LoginuserId;

            _dbContext.SaveChanges();

            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.UpdateUserRole, LoginuserId, 0);
            return 1;
        }

        public UserRoleBO GetUserRole(string userAbrhs, string LoginUserAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            var LoginuserId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(LoginUserAbrhs), out LoginuserId);

            UserRoleBO modal = new UserRoleBO();

            if (LoginuserId > 0)
            {
                var UserData = _dbContext.Users.FirstOrDefault(x => x.UserId == userId && x.IsActive);
                var UserDetailData = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == userId);
                var designationData = _dbContext.Designations.FirstOrDefault(x => x.DesignationId == UserDetailData.DesignationId);
                var designationGroupData = _dbContext.DesignationGroups.FirstOrDefault(x => x.DesignationGroupId == designationData.DesignationGroupId);
                if (UserData != null)
                {
                    modal.UserAbrhs = CryptoHelper.Encrypt(UserData.UserId.ToString());
                    modal.EmployeeName = UserDetailData.FirstName + " " + UserDetailData.LastName;
                    modal.RoleAbrhs = CryptoHelper.Encrypt(UserData.RoleId.ToString());
                    modal.DesignationAbrhs = CryptoHelper.Encrypt(UserDetailData.DesignationId.ToString());
                    modal.DesignationGroupAbrhs = CryptoHelper.Encrypt(designationGroupData.DesignationGroupId.ToString());
                }
                return modal;
            }
            return modal;
        }


        #endregion
    }
}
