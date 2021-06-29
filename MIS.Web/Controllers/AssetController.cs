using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MIS.Web.Controllers
{
    public class AssetController : Controller
    {
        // GET: Asset
        public ActionResult Request()
        {
            return View();
        }
        public ActionResult Review()
        {
            return View();
        }
        public ActionResult ViewStatus()
        {
            return View();
        }
        public ActionResult Allocate()
        {
            return View();
        }
        public PartialViewResult _AllocateAsset()
        {
            return PartialView();
        }
        public PartialViewResult _ReturnAsset()
        {
            return PartialView();
        }
        public ActionResult Manage()
        {
            return View();
        }
    }
}