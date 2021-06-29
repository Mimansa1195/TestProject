using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MIS.Web.Controllers
{
    public class HRPortalController : Controller
    {
        // GET: HRPortal
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult Referral()
        {
            return View();
        }
        public ActionResult ManageTraining()
        {
            return View();
        }
        public ActionResult ForwardReferral()
        {
            return View();
        }
        public ActionResult HRLeaveDashboard()
        {
            return View();
        }
        public ActionResult ManageNews()
        {
            return View();
        }
        public ActionResult PendingRequests()
        {
            return View();
        }

        public ActionResult ManageCompletionFeedbackMail()
        {
            return View();
        }

        public ActionResult ManageHealthInsuranceCard()
        {
            return View();
        }

        public ActionResult _UploadHealthInsuranceCard()
        {
            return PartialView();
        }
    }
}