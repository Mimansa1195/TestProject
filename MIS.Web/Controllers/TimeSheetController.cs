using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MIS.Web.Controllers
{
    public class TimeSheetController : Controller
    {
        // GET: TimeSheet
        public ActionResult ConfigureTimeSheet()
        {
            return View();
        }

        public ActionResult ManageTaskTemplates()
        {
            return View();
        }

        public ActionResult CreateTimeSheet()
        {
            return View();
        }

        public ActionResult Reports()
        {
            return View();
        }

        public ActionResult Dashboard()
        {
            return View();
        }

        public ActionResult TeamDataUpdation()
        {
            return View();
        }

        public ActionResult ReviewTimeSheet()
        {
            return View();
        }

    }
}