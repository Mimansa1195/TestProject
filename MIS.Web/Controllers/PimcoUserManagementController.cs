using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MIS.Web.Controllers
{
    public class PimcoUserManagementController : Controller
    {
        // GET: PimcoUserManagement
        public ActionResult Index()
        {
            return View();
        }
         public ActionResult ManageUser()
        {
            return View();
        }
    }
}