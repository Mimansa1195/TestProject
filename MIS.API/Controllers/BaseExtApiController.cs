using MIS.API.Filters;
using System.Web.Http;

namespace MIS.API.Controllers
{
    [AuthorizeExternalApi]
    public class BaseExtApiController : ApiController
    {

    }
}