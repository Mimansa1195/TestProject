using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MIS.Web.Controllers
{
    public class DashboardController : Controller
    {
        // GET: Dashboard
        public ActionResult Index()
        {
            return View();
        }

        public PartialViewResult _DashBoardSetting()
        {
            return PartialView();
        }

        public PartialViewResult _Skills()
        {
            return PartialView();
        }

        public PartialViewResult _HelpDocument()
        {
            return PartialView();
        }

        public PartialViewResult _EditSkills()
        {
            return PartialView();
        }
    }
}