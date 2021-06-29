using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MIS.Web.Controllers
{
    public class MealManagementController : Controller
    {
        // GET: MealManagement
        public ActionResult MealManage()
        {
            return View();
        }

        public ActionResult MealPackage()
        {
            return View();
        }

        public ActionResult MealMenu()
        {
            return View();
        }
    }
}