using MIS.BO;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using MIS.Services.Contracts;
using MIS.Services.Implementations;
using System.Web;
using MIS.Utilities;
using MIS.Services;
using System;

namespace MIS.API.Controllers
{
    public class AccountsPortalController : BaseApiController
    {
        private readonly IAccountsPortalServices _accountPortalServices;


        public AccountsPortalController(IAccountsPortalServices accountPortalServices)
        {
            _accountPortalServices = accountPortalServices;
        }
        [HttpPost]
        public HttpResponseMessage CheckForRequestEligibility()
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _accountPortalServices.CheckForRequestEligibility(globalData.LoginUserId));
        }
        [HttpPost]
        public HttpResponseMessage GenerateInvoices(int clientId)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _accountPortalServices.GenerateInvoices(clientId, globalData.LoginUserId));
        }
        //[HttpPost]
        //public HttpResponseMessage RequestInvoices(int noOfInvoices, string appLinkUrl)
        //{
        //    var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
        //    return Request.CreateResponse(HttpStatusCode.OK, _accountPortalServices.RequestInvoices(noOfInvoices, globalData.LoginUserId,appLinkUrl));
        //}
        [HttpPost]
        public HttpResponseMessage RequestInvoices(AddInvoiceRequestsBO invoiceRequestDetails)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _accountPortalServices.RequestInvoices(invoiceRequestDetails));
        }
        [HttpPost]
        public HttpResponseMessage AddNewClient(GenerateInvoiceBO data)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _accountPortalServices.AddNewClient(data));
        }
        [HttpPost]
        public HttpResponseMessage GetInvoicesForReview()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _accountPortalServices.GetInvoicesForReview());
        }
        [HttpPost]
        public HttpResponseMessage GetInvoiceReport(string clientIds, int year, string months)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _accountPortalServices.GetInvoiceReport(clientIds, year, months));
        }
        [HttpPost]
        public HttpResponseMessage GetInvoice()
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _accountPortalServices.GetInvoice(globalData.LoginUserId));
        }
        [HttpPost]
        public HttpResponseMessage TakeActionOnInvoice(long invoiceRequestId, string reason, int forApproval)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _accountPortalServices.TakeActionOnInvoice(invoiceRequestId, reason, forApproval, globalData.LoginUserId));
        }
        [HttpPost]
        public HttpResponseMessage GetRequestedInvoiceInfo()
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _accountPortalServices.GetRequestedInvoiceInfo(globalData.LoginUserId));
        }

        [HttpPost]
        public HttpResponseMessage GetFinancialYearsForAccounts()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _accountPortalServices.GetFinancialYearsForAccounts());
        }

        //[HttpPost]
        //public HttpResponseMessage GetInvoiceDetail(long invoiceId)
        //{
        //    return Request.CreateResponse(HttpStatusCode.OK, _accountPortalServices.GetInvoiceDetail(invoiceId));
        //}
        //[HttpPost]
        //public HttpResponseMessage CancelInvoice(long invoiceDetailId, string userAbrhs)
        //{
        //    return Request.CreateResponse(HttpStatusCode.OK, _accountPortalServices.CancelInvoice(invoiceDetailId, userAbrhs));

        #region Users Account

        [HttpPost]
        public HttpWebResponseResult GetAccountPortal()
        {
            var accountPortalUrl = "";
            var result = GlobalServices.GetExternal(accountPortalUrl);
            return result;
        }
        #endregion
    }
}