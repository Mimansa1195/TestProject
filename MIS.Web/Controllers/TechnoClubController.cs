using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MIS.Web.Controllers
{
    public class TechnoClubController : Controller
    {
        // GET: TechnoClub
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult GSOC()
        {
            return View();
        }

        public ActionResult GSOCProjects()
        {
            return View();
        }
    }
}