using Microsoft.Owin;
using Owin;

[assembly: OwinStartup(typeof(MIS.API.Startup))]

namespace MIS.API
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
