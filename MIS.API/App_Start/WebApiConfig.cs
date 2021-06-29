using MIS.API.Binders;
using MIS.API.Filters;
using Newtonsoft.Json;
using System.Configuration;
using System.Linq;
using System.Web.Http;
using System.Web.Http.Cors;

namespace MIS.API
{
    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            // Web API configuration and services

            // Register exception filter
            config.Filters.Add(new HandleExceptionAttribute());

            // Configure Web API to use only bearer token authentication.
            config.SuppressDefaultHostAuthentication();
            //config.Filters.Add(new HostAuthenticationFilter(OAuthDefaults.AuthenticationType));

            // Parameter binding
            config.ParameterBindingRules.Add(SimplePostVariableParameterBinding.HookupParameterBinding);

            // Enable CORS
            var allowedOrigins = ConfigurationManager.AppSettings["AllowedOrigins"];
            var corsAttribute = new EnableCorsAttribute(string.IsNullOrEmpty(allowedOrigins) ? "*" : allowedOrigins, "*", "*");
            config.EnableCors(corsAttribute);

            // Remove XML formatting and intend default for json  
            var appXmlType = config.Formatters.XmlFormatter.SupportedMediaTypes.FirstOrDefault(t => t.MediaType == "application/xml");
            config.Formatters.XmlFormatter.SupportedMediaTypes.Remove(appXmlType);

            // Web API configuration and formatters
            var formatters = config.Formatters;
            var jsonFormatter = formatters.JsonFormatter;
            var settings = jsonFormatter.SerializerSettings;

            // Configure JSON output
            settings.Formatting = Formatting.Indented;
            settings.ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore;
            settings.PreserveReferencesHandling = Newtonsoft.Json.PreserveReferencesHandling.None;

            // Web API routes
            config.MapHttpAttributeRoutes();
            config.Routes.MapHttpRoute(
               name: "DefaultApi",
               routeTemplate: "api/{controller}/{action}/{id}",
               defaults: new { id = RouteParameter.Optional, action = RouteParameter.Optional }
           );
        }
    }
}
