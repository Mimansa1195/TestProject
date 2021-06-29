using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MIS.Web.Controllers
{
    public class PolicyController : Controller
    {
        public ActionResult ManagePolicy()
        {
            return View();
        }

        public PartialViewResult _AddPolicy()
        {
            return PartialView();
        }

        public ActionResult ViewPolicy()
        {
            return View();
        }
    }
}