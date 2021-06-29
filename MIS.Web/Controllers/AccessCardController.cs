using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MIS.Web.Controllers
{
    public class AccessCardController : Controller
    {
        // GET: AccessCard
        public ActionResult Manage()
        {
            return View();
        }
        public ActionResult UserCardMapping()
        {
            return View();
        }
    }
}