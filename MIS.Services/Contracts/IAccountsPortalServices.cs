using MIS.BO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MIS.Services.Contracts
{
    public interface IAccountsPortalServices
    {
        // int RequestInvoices(int noOfInvoices, int loginUserId, string appLinkUrl);

        int RequestInvoices(AddInvoiceRequestsBO invoiceRequestDetails);

        int CheckForRequestEligibility(int loginUserId);

        GenerateInvoiceBO GenerateInvoices(int clientId, int loginUserId);

        int AddNewClient(GenerateInvoiceBO data);

        List<InvoiceSummary> GetInvoicesForReview();

        List<InvoicesList> GetInvoice(int loginUserId);

        List<InvoiceSummary> GetInvoiceReport(string clientIds,int year, string months);

        int TakeActionOnInvoice(long invoiceRequestId, string reason, int forApproval, int loginUserId);

        int ActionOnInvoiceRequest(string ActionData, string Reason, int Status);

        List<InvoicesList> GetRequestedInvoiceInfo(int loginUserId);

        List<FYDropDown> GetFinancialYearsForAccounts();
    }
}
