using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MIS.Web.Controllers
{
    public class KnowledgeBaseController : Controller
    {
        // GET: KnowledgeBase
        public ActionResult ViewDoc()
        {
            return View();
        }
        public ActionResult ViewSharedDoc()
        {
            return View();
        }
        public ActionResult DocPermissionGroup()
        {
            return View();
        }
    }
}