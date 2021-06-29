using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MIS.Web.Controllers
{
    public class AdministrationsController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }

        #region Role and User Role

        #region Manage Role
        public ActionResult ManageRole()
        {
            return View();
        }

        public PartialViewResult _AddRole()
        {
            return PartialView();
        }

        public PartialViewResult _EditRole()
        {
            return PartialView();
        }
        #endregion

        #region Manage User Role

        public ActionResult UserRole()
        {
            return View();
        }

        #endregion

        #endregion

        #region Menu and Permissions

        #region Manage menu
        public ActionResult ManageMenu()
        {
            return View();
        }

        public PartialViewResult _AddMenu()
        {
            return PartialView();
        }

        public PartialViewResult _EditMenu()
        {
            return PartialView();
        }
        #endregion

        #region Menu Permission
        public ActionResult MenuPermission()
        {
            return View();
        }

        public PartialViewResult _ManageRolePermission()
        {
            return PartialView();
        }

        public PartialViewResult _ManageUserPermission()
        {
            return PartialView();
        }
        #endregion

        #endregion

        #region Scheduler
        public ActionResult ManageScheduler()
        {
            return View();
        }
        #endregion

        #region Dashboard Widgets

        #region Manage Widget
        public ActionResult ManageWidget()
        {
            return View();
        }

        public PartialViewResult _AddWidget()
        {
            return PartialView();
        }

        public PartialViewResult _EditWidget()
        {
            return PartialView();
        }
        #endregion

        #region Widget Permission
        public ActionResult WidgetPermission()
        {
            return View();
        }

        public PartialViewResult _ManageWidgetRolePermission()
        {
            return PartialView();
        }

        public PartialViewResult _ManageWidgetUserPermission()
        {
            return PartialView();
        }
        #endregion

        #endregion

        #region Deligation

        public PartialViewResult _UserDelegation()
        {
            return PartialView();
        }
        public ActionResult ErrorLog()
        {
            return View();
        }
        
        #endregion
    }
}