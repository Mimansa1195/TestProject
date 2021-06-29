using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MIS.Web.Controllers
{
    public class AttendanceController : Controller
    {
        // GET: Attendance
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult EmployeeAttendance()
        {
            return View();
        }

        public ActionResult StaffAttendance()
        {
            return View();
        }

        public ActionResult ASquareAttendance()
        {
            return View();
        }
    }
}