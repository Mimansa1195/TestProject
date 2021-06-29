using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MIS.Web.Controllers
{
    public class TaskManagementController : Controller
    {
        // GET: TaskManagement
        public ActionResult ManageTaskTeam()
        {
            return View();
        }
        public ActionResult ManageTaskType()
        {
            return View();
        }
        public ActionResult ManageTaskSubDetail1()
        {
            return View();
        }
        public ActionResult ManageTaskSubDetail2()
        {
            return View();
        }
    }
}