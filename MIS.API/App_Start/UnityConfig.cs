using Microsoft.Practices.Unity;
using MIS.Services.Contracts;
using MIS.Services.Implementations;
using System.Web.Http;
using Unity.WebApi;

namespace MIS.API
{
    public static class UnityConfig
    {
        public static void RegisterComponents()
        {
            var container = new UnityContainer();

            container.RegisterType<ITokenServices, TokenServices>();
            container.RegisterType<IUserServices, UserServices>();
            container.RegisterType<ILnsaServices, LnsaServices>();
            container.RegisterType<ITimeSheetService, TimeSheetService>();
            container.RegisterType<ICommonService, CommonService>();
            container.RegisterType<IAssetServices, AssetServices>();
            container.RegisterType<IFormServices, FormServices>();
            container.RegisterType<ITaskManagementServices, TaskManagementServices>();
            container.RegisterType<IAttendanceServices, AttendanceServices>();
            container.RegisterType<IKnowledgeBaseServices, KnowledgeBaseServices>();
            container.RegisterType<ILeaveManagementServices, LeaveManagementServices>();
            container.RegisterType<IProjectManagementServices, ProjectManagementServices>();
            container.RegisterType<IAccessCardServices, AccessCardServices>();
            container.RegisterType<IReportServices, ReportServices>();
            container.RegisterType<ITeamManagementServices, TeamManagementServices>();
            container.RegisterType<IMealServices, MealServices>();
            container.RegisterType<IAdministrationsServices, AdministrationsServices>();
            container.RegisterType<IAppraisalServices, AppraisalServices>();
            container.RegisterType<IFeedbackServices, FeedbackServices>();
            container.RegisterType<IPolicyServices, PolicyServices>();
            container.RegisterType<IEInvoiceServices, EInvoiceServices>();
            container.RegisterType<ISportService, SportService>();
            container.RegisterType<IPimcoServices, PimcoServices>();
            container.RegisterType<IReimbursementServices, ReimbursementServices>();
            container.RegisterType<IHRPortalServices, HRPortalServices>();
            container.RegisterType<IAccountsPortalServices, AccountsPortalServices>();
            container.RegisterType<ITechnoClubServices, TechnoClubServices>();
            container.RegisterType<IExternalServices, ExternalServices>();
            GlobalConfiguration.Configuration.DependencyResolver = new UnityDependencyResolver(container);
        }
    }
}