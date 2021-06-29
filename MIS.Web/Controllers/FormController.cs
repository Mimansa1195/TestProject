using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MIS.Web.Controllers
{
    public class FormController : Controller
    {
        // GET: Form
        public ActionResult Manage()
        {
            return View();
        }
        public ActionResult ViewForm()
        {
            return View();
        }
        public PartialViewResult _AddForm()
        {
            return PartialView();
        }


        //UploadUserForm
        public ActionResult MyForm()
        {
            return View();
        }

        public PartialViewResult _UploadMyForm()
        {
            return PartialView();
        }

        public ActionResult TeamForm()
        {
            return View();
        }

    }
}