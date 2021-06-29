using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MIS.Web.Controllers
{
    public class CabRequestController : Controller
    {
        // GET: CabRequest
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Review()
        {
            return View();
        }
     
        public ActionResult FinalizeRequest()
        {
            return View();
        }

        public ActionResult ReviewCabRequest()
        {
            return View();
        }
    }
}