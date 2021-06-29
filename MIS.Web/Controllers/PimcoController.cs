using System.Web.Mvc;

namespace MIS.Web.Controllers
{
    //[RoutePrefix("Pimco")]
    public class PimcoController : Controller
    {
        //[Route("")]
        //[Route("Index")]
        public ActionResult OrganizationStructure()
        {
            return View();
        }
        
    }
}