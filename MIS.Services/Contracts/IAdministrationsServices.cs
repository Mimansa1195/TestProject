using MIS.BO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MIS.Services.Contracts
{
    public interface IAdministrationsServices
    {
        #region Navigation Menu
        List<MenuBO> GetNavigationMenus(string userAbrhs);
        MenuBO GetDetailsOfNavigationMenu(int menuId, string userAbrhs);
        int AddNavigationMenu(NavigationMenuBO input);
        int ChangeMenuStatus(int menuId, string userAbrhs);
        int UpdateMenus(MenuBO menus);
        #endregion

        #region Scheduler
        List<SchedulerActionBO> GetSchedulerActions(string userAbrhs);

        int AddNewScheduler(SchedulerActionBO input, string userAbrhs);

        int ChangeStatusOfScheduler(int actionId, int type, string userAbrhs);

        SchedulerActionBO GetDetailsOfScheduler(int actionId);

        int UpdateSchedulerData(SchedulerActionBO input, string userAbrhs);
        #endregion

        #region Role Permissions
        /// <summary>
        /// Method to get menu permissions by role
        /// </summary>
        /// <param name="userAbrhs">UserAbrhs</param>
        /// <param name="roleAbrhs">RoleAbrhs</param>
        /// <returns>ManageMenusPermissionBO</returns>
        ManageMenusPermissionBO GetMenusRolePermissions(string userAbrhs, string roleAbrhs);

        /// <summary>
        /// Method to get menu permissions by user
        /// </summary>
        /// <param name="userAbrhs">UserAbrhs</param>
        /// <param name="employeeAbrhs">EmployeeAbrhs</param>
        /// <returns>ManageMenusPermissionBO</returns>
        ManageMenusPermissionBO GetMenusUserPermissions(string userAbrhs, string employeeAbrhs);

        /// <summary>
        /// Method to add or update menus role's/user's permissions
        /// </summary>
        /// <param name="permission">ManageMenusPermissionBO</param>
        /// <returns>success : 1, error: 0, invalid: 2</returns>
        int AddUpdateMenusPermissions(ManageMenusPermissionBO permission);
        #endregion

        #region Dashboard Widget Permissions

        /// <summary>
        /// Method to get dashboard widget permissions by role
        /// </summary>
        /// <param name="userAbrhs">UserAbrhs</param>
        /// <param name="roleAbrhs">RoleAbrhs</param>
        /// <returns>ManageDashboardWidgetPermissionBO</returns>
        ManageDashboardWidgetPermissionBO GetWidgetsRolePermissions(string userAbrhs, string roleAbrhs);

        /// <summary>
        /// Method to get dashboard widget permissions by user
        /// </summary>
        /// <param name="userAbrhs">UserAbrhs</param>
        /// <param name="employeeAbrhs">EmployeeAbrhs</param>
        /// <returns>ManageDashboardWidgetPermissionBO</returns>
        ManageDashboardWidgetPermissionBO GetWidgetsUserPermissions(string userAbrhs, string employeeAbrhs);

        /// <summary>
        /// Method to add or update dashboard widgets role's/user's permissions
        /// </summary>
        /// <param name="permission">ManageDashboardWidgetPermissionBO</param>
        /// <returns>success : 1, error: 0, invalid: 2</returns>
        int AddUpdateWidgetPermissions(ManageDashboardWidgetPermissionBO permission);

        #endregion

       

        int SaveMenuDelegation(DelegationBO delegationBO);

        List<DelegationBOList> GetMenuDelegation(string userAbrhs, string menuAbrhs);

        int DeleteMenuDelegation(int menusUserDelegationId, string userAbrhs);

        List<ErrorLogsBO> GetErrorLogs(DateTime date);

        ErrorLogsBO GetStackTraceById(int errorId);

        //---------Manage Role Functions--------------------//

        int AddRole(RoleList role);

        List<RoleList> GetAllRoles(string userAbrhs);

        int UpdateRole(RoleList role);

        int DeleteRole(string RoleAbrhs, string userAbrhs);

        RoleList GetRole(string RoleAbrhs, string userAbrhs);

        //---------Manage User Roles Functions--------------------//

        List<UserRoleList> GetAllUserRoles(string userAbrhs);

        int UpdateUserRole(UserRoleBO role);

        UserRoleBO GetUserRole(string userAbrhs, string LoginUserAbrhs);

    }
}
