using System.Web.Mvc;

namespace MIS.API.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            //return Json(new { Name = "Sudhanshu", Age = 20, Address = "Delhi" }, JsonRequestBehavior.AllowGet);
            return View();
        }

        //public System.Net.Http.HttpResponseMessage TestApi()
        //{

        //    var data = Json(new { Name = "Sudhanshu", Age = 20, Address = "Delhi" }, JsonRequestBehavior.AllowGet);
        //    return Request.CreateResponse(HttpStatusCode.OK, _testServices.GetTestPaperList(subjectIds, testLevelIds, testTypeIds, isPredefined));
        //}
    }
}
