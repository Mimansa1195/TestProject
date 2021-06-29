using MIS.API.Filters;
using System.Web.Http;

namespace MIS.API.Controllers
{
    [AuthorizeApi]
    public class BaseApiController : ApiController
    {

    }
}