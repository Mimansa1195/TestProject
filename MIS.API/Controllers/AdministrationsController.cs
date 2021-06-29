using MIS.BO;
using MIS.Services.Contracts;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace MIS.API.Controllers
{
    public class AdministrationsController : BaseApiController
    {

        private readonly IAdministrationsServices _administrationsServices;

        public AdministrationsController(IAdministrationsServices administrationsServices)
        {
            _administrationsServices = administrationsServices;
        }

        #region Navigation Menu
        public HttpResponseMessage AddNavigationMenu(NavigationMenuBO input)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _administrationsServices.AddNavigationMenu(input));
        }

        [HttpGet]
        public HttpResponseMessage GetNavigationMenus()
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _administrationsServices.GetNavigationMenus(globalData.UserAbrhs));
        }
        [HttpPost]
        public HttpResponseMessage GetDetailsOfNavigationMenu(int menuId)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _administrationsServices.GetDetailsOfNavigationMenu(menuId, globalData.UserAbrhs));
        }
        [HttpPost]
        public HttpResponseMessage UpdateMenus(MenuBO menus)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _administrationsServices.UpdateMenus(menus));
        }


        [HttpPost]
        public HttpResponseMessage ChangeMenuStatus(int menuId)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _administrationsServices.ChangeMenuStatus(menuId, globalData.UserAbrhs));
        }

        #endregion

        #region Role Permissions
        [HttpPost]
        public HttpResponseMessage GetMenusRolePermissions(string roleAbrhs)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _administrationsServices.GetMenusRolePermissions(globalData.UserAbrhs, roleAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetMenusUserPermissions(string employeeAbrhs)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _administrationsServices.GetMenusUserPermissions(globalData.UserAbrhs, employeeAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage AddUpdateMenusPermissions(ManageMenusPermissionBO menuPermissions)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            menuPermissions.UserAbrhs = globalData.UserAbrhs;
            return Request.CreateResponse(HttpStatusCode.OK, _administrationsServices.AddUpdateMenusPermissions(menuPermissions));
        }

        #endregion

        #region Dashboard Widget Permissions
        [HttpPost]
        public HttpResponseMessage GetWidgetsRolePermissions(string roleAbrhs)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _administrationsServices.GetWidgetsRolePermissions(globalData.UserAbrhs, roleAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetWidgetsUserPermissions(string employeeAbrhs)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _administrationsServices.GetWidgetsUserPermissions(globalData.UserAbrhs, employeeAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage AddUpdateWidgetPermissions(ManageDashboardWidgetPermissionBO widgetPermissions)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            widgetPermissions.UserAbrhs = globalData.UserAbrhs;
            return Request.CreateResponse(HttpStatusCode.OK, _administrationsServices.AddUpdateWidgetPermissions(widgetPermissions));
        }

        #endregion

        

        #region Delegation

        [HttpPost]
        public HttpResponseMessage SaveMenuDelegation(DelegationBO delegationBO)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _administrationsServices.SaveMenuDelegation(delegationBO));
        }

        [HttpPost]
        public HttpResponseMessage GetMenuDelegation(string userAbrhs, string menuAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _administrationsServices.GetMenuDelegation(userAbrhs, menuAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage DeleteMenuDelegation(int menusUserDelegationId, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _administrationsServices.DeleteMenuDelegation(menusUserDelegationId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetErrorLogs(DateTime date)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _administrationsServices.GetErrorLogs(date));
        }

        [HttpPost]
        public HttpResponseMessage GetStackTraceById(int errorId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _administrationsServices.GetStackTraceById(errorId));
        }

        #endregion

        #region Role

        [HttpPost]
        public HttpResponseMessage AddRole(RoleList role)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            role.UserAbrhs = globalData.UserAbrhs;
            return Request.CreateResponse(HttpStatusCode.OK, _administrationsServices.AddRole(role));
        }

        [HttpPost]
        public HttpResponseMessage GetAllRoles()
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _administrationsServices.GetAllRoles(globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage UpdateRole(RoleList role)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            role.UserAbrhs = globalData.UserAbrhs;
            return Request.CreateResponse(HttpStatusCode.OK, _administrationsServices.UpdateRole(role));
        }

        [HttpPost]
        public HttpResponseMessage DeleteRole(string RoleAbrhs)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _administrationsServices.DeleteRole(RoleAbrhs, globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetRole(string RoleAbrhs)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _administrationsServices.GetRole(RoleAbrhs, globalData.UserAbrhs));
        }
        #endregion

        #region User Role


        [HttpPost]
        public HttpResponseMessage GetAllUserRoles()
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _administrationsServices.GetAllUserRoles(globalData.UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage UpdateUserRole(UserRoleBO user)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            user.LoginUserAbrhs = globalData.UserAbrhs;
            return Request.CreateResponse(HttpStatusCode.OK, _administrationsServices.UpdateUserRole(user));
        }

        [HttpPost]
        public HttpResponseMessage GetUserRole(string employeeAbrhs)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _administrationsServices.GetUserRole(employeeAbrhs, globalData.UserAbrhs));
        }
        #endregion

        #region Scheduler
        [HttpGet]
        public HttpResponseMessage GetSchedulerActions()
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _administrationsServices.GetSchedulerActions(globalData.UserAbrhs));
        }
        [HttpPost]
        public HttpResponseMessage AddNewScheduler(SchedulerActionBO input)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _administrationsServices.AddNewScheduler(input, globalData.UserAbrhs));
        }
        [HttpPost]
        public HttpResponseMessage ChangeStatusOfScheduler(int actionId, int type)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _administrationsServices.ChangeStatusOfScheduler(actionId, type, globalData.UserAbrhs));
        }
        [HttpPost]
        public HttpResponseMessage GetDetailsOfScheduler(int actionId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _administrationsServices.GetDetailsOfScheduler(actionId));
        }
        [HttpPost]
        public HttpResponseMessage UpdateSchedulerData(SchedulerActionBO input)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _administrationsServices.UpdateSchedulerData(input, globalData.UserAbrhs));
        }
        #endregion

    }
}