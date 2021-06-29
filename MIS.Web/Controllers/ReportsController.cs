using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MIS.Web.Controllers
{
    public class ReportsController : Controller
    {
        // GET: Reports
        public ActionResult AttendanceSummary()
        {
            return View();
        }
        public ActionResult CompOff()
        {
            return View();
        }
        public ActionResult ClubbedReport()
        {
           return View();
        }
        public ActionResult LNSA()
        {
            return View();
        }
        public ActionResult LWP()
        {
            return View();
        }

        public ActionResult VMSReport()
        {
            return View();
        }

        public ActionResult EmployeeSkills()
        {
            return View();
        }

        public ActionResult GetUserActivity()
        {
            return View();
        }

        public ActionResult MealMenuReport()
        {
            return View();
        }

        public ActionResult LeaveReport()
        {
            return View();
        }
        public ActionResult MealFeedbackReport()
        {
            return View();
        }
        public ActionResult Goals()
        {
            return View();
        }

        public ActionResult LNSACompoffReport()
        {
            return View();
        }
    }
}