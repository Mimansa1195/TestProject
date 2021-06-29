using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MIS.Web.Controllers
{
    public class TeamManagementController : Controller
    {
        // GET: TeamManagement
        public ActionResult TeamInformation()
        {
            return View();
        }
        public ActionResult UserTeamMapping()
        {
            return View();
        }
        public ActionResult ShiftInformation()
        {
            return View();
        }
        public ActionResult UserShiftMapping()
        {
            return View();
        }
    }
}