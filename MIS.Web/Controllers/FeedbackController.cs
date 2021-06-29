using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MIS.Web.Controllers
{
    public class FeedbackController : Controller
    {
        public ActionResult SubmitFeedback()
        {
            return View();
        }
        public ActionResult ViewFeedback()
        {
            return View();
        }
    }
}