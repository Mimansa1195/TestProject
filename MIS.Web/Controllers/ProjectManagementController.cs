using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MIS.Web.Controllers
{
    public class ProjectManagementController : Controller
    {
        // GET: ProjectManagement
        public ActionResult ManageProjects()
        {
            return View();
        }

        public ActionResult ManageVerticals()
        {
            return View();
        }

        public PartialViewResult _ManageGeminiProject()
        {
            return PartialView();
        }

        public PartialViewResult _ManagePimcoProject()
        {
            return PartialView();
        }
    }
}