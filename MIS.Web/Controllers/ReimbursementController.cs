using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MIS.Web.Controllers
{
    public class ReimbursementController : Controller
    {
        // GET: Reimbursement

        #region Reimbursement Request
        public ActionResult MyReimbursement()
        {
            return View();
        }

        public PartialViewResult _ManageReimbursementRequest()
        {
            return PartialView();
        }

        public PartialViewResult _ViewReimbursementList()
        {
            return PartialView();
        }

        public PartialViewResult _ViewReimbursementFormDetail()
        {
            return PartialView();
        }
        #endregion

        #region Review Reimbursement
        public ActionResult ReviewReimbursement()
        {
            return View();
        }

        public PartialViewResult _ReviewReimbursementList()
        {
            return PartialView();
        }

        public PartialViewResult _ReviewReimbursementFormData()
        {
            return PartialView();
        }
        #endregion
    }

}