using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MIS.Web.Controllers
{
    public class LeaveManagementController : Controller
    {
        public ActionResult Apply() //Apply Leave, Apply WFH, Apply Comp Off
        {
            return View();
        }

        public ActionResult DataChangeRequest()
        {
            return View();
        }

        public ActionResult ReviewRequest()
        {
            return View();
        }

        public ActionResult UpdateAttendance()
        {
            return View();
        }
       
        public ActionResult Update()
        {
            return View();
        }
        public ActionResult LeaveRequestStatus()
        {
            return View();
        }
        public ActionResult WeeklyRoster()
        {
            return View();
        }

    }
}