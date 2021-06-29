using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MIS.Web.Controllers
{
    public class TrainingController : Controller
    {
        // GET: Training
        public ActionResult ReviewTrainingRequest()
        {
            return View();
        }
    }
}