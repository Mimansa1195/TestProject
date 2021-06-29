using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MIS.Web.Controllers
{
    public class UserManagementController : Controller
    {
        // GET: UserManagement
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult ManageUser()
        {
            return View();
        }

        public PartialViewResult _ViewUsersList()
        {
            return PartialView();
        }

        public PartialViewResult _CreateUser()
        {
            return PartialView();
        }

        public ActionResult UserActivityLog()
        {
            return View();
        }

        public PartialViewResult _ViewUserLocation()
        {
            return PartialView();
        }

        public ActionResult UnlockUser()
        {
            return View();
        }

        public ActionResult NewUserRegistration()
        {
            return View();
        }

        
        public PartialViewResult _viewInactiveUserDetail()
        {
            return PartialView();
        }

        public PartialViewResult _ManageUserDetail()
        {
            return PartialView();
        }
        public PartialViewResult _VerifyUserDetail()
        {
            return PartialView();
        }

        public PartialViewResult _ListActiveUsers()
        {
            return PartialView();
        }

        public PartialViewResult _ManageFullNFinal()
        {
            return PartialView();
        }

        public PartialViewResult _PromoteUsers()
        {
            return PartialView();
        }

        public PartialViewResult _PromotionHistory()
        {
            return PartialView();
        }

        public PartialViewResult _ListInactiveUsers()
        {
            return PartialView();
        }

        public PartialViewResult _ListUserRegistration()
        {
            return PartialView();
        }

        public PartialViewResult _UserProfile()
        {
            return PartialView();
        }

        public PartialViewResult _UpdateProfile()
        {
            return PartialView();
        }

        public ActionResult UpdateContactDetails()
        {
            return View();
        }

        public ActionResult ForwardReferral()
        {
            return View();
        }

        public ActionResult UserOnboarding()
        {
            return View();
        }
    }
}