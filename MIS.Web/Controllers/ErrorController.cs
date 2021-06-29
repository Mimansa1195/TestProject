using System.Web.Mvc;

namespace MIS.Web.Controllers
{
    public class ErrorController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Unauthorized()
        {
            return View();
        }

        public ActionResult Maintenance()
        {
            return View();
        }
    }
}