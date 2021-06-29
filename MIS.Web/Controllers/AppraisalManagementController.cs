using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MIS.Web.Controllers
{
    public class AppraisalManagementController : Controller
    {
        //public ActionResult Index()
        //{
        //    return View();
        //}

        #region Competency Form
        public ActionResult CompetencyForm()
        {
            return View();
        }

        public PartialViewResult _AddAppraisalParameter()
        {
            return PartialView();
        }

        public PartialViewResult _CreateCompetencyForm()
        {
            return PartialView();
        }

        public PartialViewResult _EditCompetencyForm()
        {
            return PartialView();
        }

        public PartialViewResult _CloneCompetencyForm()
        {
            return PartialView();
        }

        #endregion

        #region Appraisal Management
        public ActionResult AppraisalCycle()
        {
            return View();
        }

        public ActionResult AppraisalSettings()
        {
            return View();
        }

        public ActionResult Index()
        {
            return View();
        }

        public PartialViewResult _AddAppraisalSettings()
        {
            return PartialView();
        }

        public PartialViewResult _EditAppraisalSettings()
        {
            return PartialView();
        }

        public ActionResult ParameterMaster()
        {
            return View();
        }


        public ActionResult TeamAppraisal()
        {
            return View();
        }

        public ActionResult EmployeesAppraisal()
        {
            return View();
        }
        

        public ActionResult ManageTeamAppraisal()
        {
            return View();
        }

        public ActionResult AppraisalNotGenerated()
        {
            return View();
        }

        public ActionResult MyAppraisal()
        {
            return View();
        }

        public PartialViewResult _AppraisalFormSelf()
        {
            return PartialView();
        }

        public PartialViewResult _AppraisalFormUpperlevel()
        {
            return PartialView();
        }
        public PartialViewResult _AppraisalFormForManagement()
        {
            return PartialView();
        }

        
        public ActionResult EmployeeAppraisalStatus()
        {
            return View();
        }

        public ActionResult ConsolidatedAppraisalReport()
        {
            return View();
        }

        public ActionResult AppraisalFormReport()
        {
            return View();
        }

        public ActionResult PimcoAchievements()
        {
            return View();
        }

        public ActionResult TeamPimcoAchievements()
        {
            return View();
        }

        #endregion

        #region Goal Settings
        public ActionResult SelfGoal()
        {
            return View();
        }

        public ActionResult TeamGoal()
        {
            return View();
        }
        #endregion

        #region Achievement Management
        public ActionResult MyAchievement()
        {
            return View();
        }

        public PartialViewResult _UploadMyAchievement()
        {
            return PartialView();
        }

        public ActionResult TeamAchievement()
        {
            return View();
        }
        #endregion

        #region New Changes for 2018 - Add Technical Parameter by the apraisee.

        public PartialViewResult _CreateTechnicalCompetencies()
        {
            return PartialView();
        }

        public PartialViewResult _AddAppraisalParameterByEmployee()
        {
            return PartialView();
        }

        #endregion
    }
}