using MIS.BO;
using MIS.Model;
using MIS.Services.Contracts;
using MIS.Utilities;
using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace MIS.Services.Implementations
{
    public class AccountsPortalServices : IAccountsPortalServices
    {
        #region Private member variables.
        private readonly MISEntities _dbContext = new MISEntities();

        //private readonly ICommonService _common;
        #endregion
        private readonly IUserServices _userServices;
        public AccountsPortalServices(IUserServices userServices)
        {
            _userServices = userServices;
        }
        public int CheckForRequestEligibility(int loginUserId)
        {
            int status = 0;
            var result = new ObjectParameter("Success", typeof(int));
            _dbContext.Proc_CheckIfEligibleToRequestInvoice(loginUserId, result);
            Int32.TryParse(result.Value.ToString(), out status);
            return status;
        }
        public int RequestInvoices(AddInvoiceRequestsBO invoiceRequestDetails)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(invoiceRequestDetails.UserAbrhs), out userId);
            var approverEmailList = _dbContext.Fun_GetRequiredUserDetailsToSendMail(TagsForSendingEmails.InvoiceRequest).ToList();
            //var emailIdsList = new List<string>();
            //if (approverEmailList != null)
            //{
            //    emailIdsList = approverEmailList.SingleOrDefault().Split(',').ToList();
            //}
            // invoiceRequestDetails.RequestList.RemoveAll(x => x.ClientId == null || x.NoOfInvoices == null);
            if (invoiceRequestDetails.RequestList != null)
            {
                var requestXmlString = new XElement("Root",
                    from requests in invoiceRequestDetails.RequestList
                    select new XElement("Row",
                           new XAttribute("ClientId", requests.ClientId),
                            new XAttribute("NoOfInvoices", requests.NoOfInvoices)
                            ));
                int status = 0;
                var result = new ObjectParameter("Success", typeof(int));
                _dbContext.Proc_RequestInvoice(requestXmlString.ToString(), userId, result);
                Int32.TryParse(result.Value.ToString(), out status);
                var data = _dbContext.InvoiceRequests.FirstOrDefault(x => x.UserId == userId && !x.IsRejected && !x.IsApproved);
                if (data != null)
                {
                    var requesterData = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == userId);
                    var requesterName = requesterData.FirstName + " " + requesterData.MiddleName + " " + requesterData.LastName;
                    var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == EmailTemplates.RequestedInvoiceAction && f.IsActive && !f.IsDeleted);
                    if (approverEmailList.Count > 0)
                    {
                        foreach (var emailId in approverEmailList)
                        {
                            if (emailTemplate != null && status != 2)
                            {
                                var subject = "Regarding review of invoice request.";
                                var message = "This is to inform you that user " + requesterName + " has requested permissions to book invoice for below mentioned clients. Kindly take action on same.";
                                var empId = emailId.UserId;
                                var receiverMailId = CryptoHelper.Decrypt(emailId.EmailId);
                                var dataForQueryString = userId + "&" + empId + "&" + data.InvoiceRequestId;
                                var key = CryptoHelper.Encrypt(dataForQueryString.ToString());
                                var AppoveRequestUrl = invoiceRequestDetails.AppLinkUrl + "?for=appr&encodedData=" + key + "";
                                var CancleRequestUrl = invoiceRequestDetails.AppLinkUrl + "?for=cancle&encodedData=" + key + "";
                                var detail = _dbContext.InvoiceRequestDetails.Where(x => x.InvoiceRequestId == data.InvoiceRequestId).ToList();
                                var table = "<table border='0' cellpadding='4' style='color:#000000;font:normal 11px arial,sans-serif;border:1px solid #abb2b7;width:50%'><thead><tr><th style='color:#434d52;font:bold 13px arial,sans-serif;white-space:nowrap;background-color:#ebeff1;border:1px solid #abb2b7'>Client</th><th style='color:#434d52;font:bold 13px arial,sans-serif;white-space:nowrap;background-color:#ebeff1;border:1px solid #abb2b7'>No Of Invoices</th></tr></thead><tbody>";
                                if (detail != null)
                                {
                                    foreach (var temp in detail)
                                    {
                                        var clientName = _dbContext.Clients.FirstOrDefault(x => x.ClientId == temp.ClientId).ClientName;
                                        table = table + "<tr><td style='border:1px solid #abb2b7;'>&nbsp;" + clientName + "</td><td style='border:1px solid #abb2b7;'>&nbsp;" + temp.RequestedCount + "</td></tr>";
                                    }
                                }
                                var body = emailTemplate.Template
                                          .Replace("[NAME]", "User")
                                          .Replace("[MESSAGE]", message)
                                          .Replace("[LINKAPPROVE]", AppoveRequestUrl)
                                          .Replace("[LINKREJECT]", CancleRequestUrl)
                                          .Replace("[DATA]", table)
                                          .Replace("[HEADING]", "Review Invoice Request")
                                          .Replace("[SenderName]", "Team MIS");
                                // SEND MAIL 
                                Utilities.EmailHelper.SendEmailWithDefaultParameter(subject, body, true, true, receiverMailId, null, null, null);

                            }
                        }
                    }
                }
                _userServices.SaveUserLogs(ActivityMessages.RequestInvoices, userId, 0);
                return status;
            }
            return 0;
        }
        public int ActionOnInvoiceRequest(string ActionData, string Reason, int Status)
        {
            try
            {
                using (var context = new MISEntities())
                {
                    var realdata = CryptoHelper.Decrypt(ActionData);
                    string[] substrings = realdata.Split('&');
                    int userId = Convert.ToInt32(substrings[0]);
                    int receiverID = Convert.ToInt32(substrings[1]);
                    int requestId = Convert.ToInt32(substrings[2]);
                    var requesterData = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == userId);
                    var requesterName = requesterData.FirstName;
                    var data = _dbContext.InvoiceRequests.FirstOrDefault(x => x.InvoiceRequestId == requestId && !x.IsApproved && !x.IsRejected);
                    if (data != null)
                    {
                        var requestDetail = _dbContext.InvoiceRequestDetails.Where(x => x.InvoiceRequestId == data.InvoiceRequestId).ToList();
                        if (Status == 1)
                        {
                            data.IsApproved = true;
                            data.ModifiedBy = receiverID;
                            data.ModifiedDate = DateTime.Now;
                            var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == EmailTemplates.InvoiceRequest && f.IsActive && !f.IsDeleted);
                            if (emailTemplate != null)
                            {
                                var subject = "Invoice request approved";
                                var message = "Your request for invoice permission has been granted. Now you can book invoices";
                                var receiverMailId = CryptoHelper.Decrypt(requesterData.EmailId);
                                var body = emailTemplate.Template
                                          .Replace("[Name]", requesterName)
                                          .Replace("[MessageContent]", message)
                                          .Replace("[Title]", "Status Of Invoice Request");
                                // SEND MAIL 
                                Utilities.EmailHelper.SendEmailWithDefaultParameter(subject, body, true, true, receiverMailId, null, null, null);
                            }
                        }
                        if (Status == 2)
                        {
                            data.IsRejected = true;
                            data.Comments = Reason;
                            data.ModifiedBy = receiverID;
                            data.ModifiedDate = DateTime.Now;
                            foreach (var temp in requestDetail)
                            {
                                temp.IsActive = false;
                                temp.ModifiedBy = receiverID;
                                temp.ModifiedDate = DateTime.Now;
                            }
                            var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == EmailTemplates.InvoiceRequest && f.IsActive && !f.IsDeleted);
                            if (emailTemplate != null)
                            {
                                var subject = "Invoice request rejected";
                                var message = "Your request for invoice permissions has been rejected." + Environment.NewLine + "Reason: " + Reason;
                                var receiverMailId = CryptoHelper.Decrypt(requesterData.EmailId);
                                var body = emailTemplate.Template
                                          .Replace("[Name]", requesterName)
                                          .Replace("[MessageContent]", message)
                                          .Replace("[Title]", "Status Of Invoice Request");
                                // SEND MAIL 
                                Utilities.EmailHelper.SendEmailWithDefaultParameter(subject, body, true, true, receiverMailId, null, null, null);
                            }
                        }

                        _dbContext.SaveChanges();
                        _userServices.SaveUserLogs(ActivityMessages.ReviewInvoice, receiverID, 0);
                        return 1;
                    }
                    else
                        return 2;
                }

            }
            catch (Exception e)
            {
                return 0;
            }
        }

        public List<InvoiceSummary> GetInvoicesForReview()
        {
            var invoicesForClients = _dbContext.InvoiceRequests.Where(x => !x.IsRejected && !x.IsApproved);
            var invoiceSummary = invoicesForClients.Select(a => new InvoiceSummary
            {
                InvoiceId = a.InvoiceRequestId,
                InvoiceList = a.InvoiceRequestDetails.Select(b => new InvoicesList
                {
                    ClientName = _dbContext.Clients.FirstOrDefault(y => y.ClientId == b.ClientId).ClientName,
                    NoOfInvoices = b.RequestedCount

                }).ToList(),
                CreatedBy = _dbContext.UserDetails.Where(x => x.UserId == a.UserId).Select(u => u.FirstName + " " + u.LastName).FirstOrDefault(),
                CreatedOn = a.CreatedDate,
                //IsApproved = a.IsApproved
            }).OrderByDescending(x => x.CreatedOn).ToList();
            return invoiceSummary ?? new List<InvoiceSummary>();
        }
        public GenerateInvoiceBO GenerateInvoices(int clientId, int loginUserId)
        {
            var invoiceSummary = new GenerateInvoiceBO();
            var data = _dbContext.Proc_GenerateInvoice(clientId, loginUserId).ToList();
            if (data.Count > 0)
            {
                invoiceSummary.InvoiceNumber = data.FirstOrDefault().InvoiceNumber;
                invoiceSummary.CreatedOn = data.FirstOrDefault().CreatedDate.ToLongDateString();
                invoiceSummary.ClientName = _dbContext.Clients.FirstOrDefault(x => x.ClientId == clientId).ClientName;
                _userServices.SaveUserLogs(ActivityMessages.GenerateInvoices, loginUserId, 0);
            }
            return invoiceSummary;
        }
        public int AddNewClient(GenerateInvoiceBO data)
        {
            int status = 0;
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(data.UserAbrhs), out userId);
            var result = new ObjectParameter("Success", typeof(int));
            _dbContext.Proc_AddClient(data.ClientName, userId, result);
            Int32.TryParse(result.Value.ToString(), out status);
            _userServices.SaveUserLogs(ActivityMessages.AddClients, userId, 0);
            return status;
        }
        public List<InvoiceSummary> GetInvoiceReport(string clientIds, int startYear, string months)
        {
            List<int> clientIdList = clientIds.Split(',').Select(int.Parse).ToList();
            List<int> monthList = months.Split(',').Select(int.Parse).ToList();
            //Jan, Feb, March
            List<int> jfmMonths = months.Split(',').Select(int.Parse).Where(m => m < 4).ToList();
            //Except Jan, Feb, March i.e. April-December
            List<int> aprToDecMonths = monthList.Except(jfmMonths).ToList();
            var invoicesForClients = (from c in _dbContext.Clients.Where(x => x.IsActive && clientIdList.Contains(x.ClientId))
                                      join ird in _dbContext.InvoiceRequestDetails.Where(x => x.IsActive
                                      && ((x.CreatedDate.Year == startYear && aprToDecMonths.Contains(x.CreatedDate.Month)) || (x.CreatedDate.Year == (startYear + 1) && jfmMonths.Contains(x.CreatedDate.Month))))
                                      on c.ClientId equals ird.ClientId
                                      into list1
                                      from l1 in list1.DefaultIfEmpty()
                                          //group l1 by c.ClientId into l2
                                      group l1 by new
                                      {
                                          c.ClientId,
                                          c.ClientName
                                      } into l2
                                      select new InvoiceSummary
                                      {
                                          ClientId = l2.Key.ClientId,
                                          ClientName = l2.Key.ClientName,
                                          InvoiceCount = l2.Sum(c => c.Invoices.Count),
                                          BookedCount = l2.Sum(c => c.Invoices.Where(x => !x.IsCancelled).Count()),
                                          CancelledCount = l2.Sum(c => c.Invoices.Where(x => x.IsCancelled).Count()),
                                          InvoiceList = _dbContext.Invoices.Where(x => x.IsActive && l2.Select(y => y.InvoiceRequestDetailId).ToList().Contains(x.InvoiceRequestDetailId))
                                                           .Select(t => new InvoicesList
                                                           {
                                                               InvoiceId = t.InvoiceId,
                                                               CreatedBy = _dbContext.UserDetails.Where(x => x.UserId == t.CreatedBy).Select(u => u.FirstName + " " + u.LastName).FirstOrDefault(),
                                                               CreatedOn = t.CreatedDate,
                                                               InvoiceNumber = t.InvoiceNumber,
                                                               Reason = t.Reason,
                                                               IsCancellable = t.IsCancelled
                                                           }).ToList()
                                      }).ToList();
            return invoicesForClients ?? new List<InvoiceSummary>();
        }
        public List<InvoicesList> GetInvoice(int loginUserId)
        {
            var invoiceSummary = new List<InvoicesList>();
            var invoicesForClients = _dbContext.Invoices.Where(x => x.IsActive).OrderByDescending(x => x.InvoiceId);
            invoiceSummary = invoicesForClients.AsEnumerable().Select(s => new InvoicesList
            {
                InvoiceId = s.InvoiceId,
                ClientId = s.InvoiceRequestDetail.ClientId,
                ClientName = s.InvoiceRequestDetail.Client.ClientName,
                InvoiceNumber = s.InvoiceNumber,
                CreatedBy = _dbContext.UserDetails.Where(x => x.UserId == s.CreatedBy).Select(u => u.FirstName + " " + u.LastName).FirstOrDefault(),
                CreatedOn = s.CreatedDate,
                IsCancelled = s.IsCancelled,
                IsCancellable = s.CreatedBy == loginUserId && !s.IsCancelled && new DateTime(s.CreatedDate.AddMonths(1).Year, s.CreatedDate.AddMonths(1).Month, 3).Date >= DateTime.Now.Date ? true : false
            }).OrderByDescending(x => x.CreatedOn).ToList();
            return invoiceSummary ?? new List<InvoicesList>();
        }
        public int TakeActionOnInvoice(long invoiceRequestId, string reason, int forApproval, int loginUserId)
        {
            var data = _dbContext.InvoiceRequests.FirstOrDefault(x => x.InvoiceRequestId == invoiceRequestId);
            var invoiceData = _dbContext.Invoices.FirstOrDefault(x => x.InvoiceId == invoiceRequestId);
            var result = 0;
            var approverEmailList = _dbContext.Fun_GetRequiredUserDetailsToSendMail(TagsForSendingEmails.InvoiceRequest).ToList();
            if (data != null && forApproval == 1)
            {
                data.IsApproved = true;
                data.ModifiedDate = DateTime.Now;
                data.ModifiedBy = loginUserId;
                var requesterData = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == data.UserId);
                var requesterName = requesterData.FirstName;
                var senderData = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == loginUserId);
                var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == EmailTemplates.InvoiceRequest && f.IsActive && !f.IsDeleted);
                if (emailTemplate != null)
                {
                    var subject = "Invoice request approved";
                    var message = "Your request for invoice permission has been granted. Now you can book invoices";
                    var receiverMailId = CryptoHelper.Decrypt(requesterData.EmailId);
                    var body = emailTemplate.Template
                              .Replace("[Name]", requesterName)
                              .Replace("[MessageContent]", message)
                              .Replace("[Title]", "Status Of Invoice Request");
                    // SEND MAIL 
                    Utilities.EmailHelper.SendEmailWithDefaultParameter(subject, body, true, true, receiverMailId, null, null, null);
                }
                result = 1;
            }
            if (data != null && forApproval == 2)
            {
                data.IsRejected = true;
                data.Comments = reason;
                data.ModifiedDate = DateTime.Now;
                data.ModifiedBy = loginUserId;
                var requestDetail = _dbContext.InvoiceRequestDetails.Where(x => x.InvoiceRequestId == data.InvoiceRequestId).ToList();
                foreach (var temp in requestDetail)
                {
                    temp.IsActive = false;
                    temp.ModifiedBy = loginUserId;
                    temp.ModifiedDate = DateTime.Now;
                }
                var requesterData = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == data.UserId);
                var requesterName = requesterData.FirstName;
                var senderData = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == loginUserId);
                var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == EmailTemplates.InvoiceRequest && f.IsActive && !f.IsDeleted);
                if (emailTemplate != null)
                {
                    var subject = "Invoice request rejected";
                    var message = "Your request for invoice permissions has been rejected." + Environment.NewLine + "Reason: " + reason;
                    var receiverMailId = CryptoHelper.Decrypt(requesterData.EmailId);
                    var body = emailTemplate.Template
                              .Replace("[Name]", requesterName)
                              .Replace("[MessageContent]", message)
                              .Replace("[Title]", "Status Of Invoice Request");
                    // SEND MAIL 
                    Utilities.EmailHelper.SendEmailWithDefaultParameter(subject, body, true, true, receiverMailId, null, null, null);
                }
                result = 2;
            }
            if (invoiceData != null && forApproval == 3)
            {
                invoiceData.IsCancelled = true;
                invoiceData.Reason = reason;
                invoiceData.ModifiedDate = DateTime.Now;
                invoiceData.ModifiedBy = loginUserId;
                if (invoiceData.CreatedBy == loginUserId)
                {
                    if (approverEmailList != null)
                    {
                        foreach (var emailId in approverEmailList)
                        {
                            var clientId = _dbContext.InvoiceRequestDetails.FirstOrDefault(x => x.InvoiceRequestDetailId == invoiceData.InvoiceRequestDetailId).ClientId;
                            var clientName = _dbContext.Clients.FirstOrDefault(x => x.ClientId == clientId).ClientName;
                            var requesterData = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == loginUserId);
                            var requesterName = requesterData.FirstName + " " + requesterData.MiddleName + " " + requesterData.LastName;
                            //var existingReceiverData = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == 1);
                            var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == EmailTemplates.InvoiceRequest && f.IsActive && !f.IsDeleted);
                            if (emailTemplate != null)
                            {
                                var subject = "Invoice cancelled";
                                var table = "<table border='0' cellpadding='4' style='color:#000000;font:normal 11px arial,sans-serif;border:1px solid #abb2b7;width:100%'><thead><tr><th style='color:#434d52;font:bold 13px arial,sans-serif;white-space:nowrap;background-color:#ebeff1;border:1px solid #abb2b7;text-align:center'>Cancelled by</th><th style='color:#434d52;font:bold 13px arial,sans-serif;white-space:nowrap;background-color:#ebeff1;border:1px solid #abb2b7;text-align:center'>Client</th><th style='color:#434d52;font:bold 13px arial,sans-serif;white-space:nowrap;background-color:#ebeff1;border:1px solid #abb2b7;text-align:center'>Invoice Number</th><th style='color:#434d52;font:bold 13px arial,sans-serif;white-space:nowrap;background-color:#ebeff1;border:1px solid #abb2b7;text-align:center'>Reason</th></tr></thead><tbody>";
                                table += "<tr><td style='border:1px solid #abb2b7;text-align:center;'>&nbsp;" + requesterName + "</td><td style='border:1px solid #abb2b7;text-align:center;'>&nbsp;" + clientName + "</td><td style='border:1px solid #abb2b7;text-align:center;'>&nbsp;" + invoiceData.InvoiceNumber + "</td><td style='border:1px solid #abb2b7;text-align:center;'>&nbsp;" + reason + "</td></tr>";
                                table += "</tbody></table>";
                                var message = "Following invoice has been cancelled." + Environment.NewLine + table;
                                var receiverMailId = CryptoHelper.Decrypt(emailId.EmailId);
                                var body = emailTemplate.Template
                                          .Replace("[Name]", emailId.FirstName)
                                          .Replace("[MessageContent]", message)
                                          .Replace("[Title]", "Status Of Invoice Request");
                                // SEND MAIL 
                                Utilities.EmailHelper.SendEmailWithDefaultParameter(subject, body, true, true, receiverMailId, null, null, null);
                            }
                        }
                    }
                }
                if (invoiceData.CreatedBy != loginUserId)
                {
                    var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == EmailTemplates.InvoiceRequest && f.IsActive && !f.IsDeleted);
                    if (emailTemplate != null)
                    {
                        var clientId = _dbContext.InvoiceRequestDetails.FirstOrDefault(x => x.InvoiceRequestDetailId == invoiceData.InvoiceRequestDetailId).ClientId;
                        var clientName = _dbContext.Clients.FirstOrDefault(x => x.ClientId == clientId).ClientName;
                        var requesterData = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == loginUserId);
                        var existingReceiverData = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == invoiceData.CreatedBy);
                        var requesterName = existingReceiverData.FirstName;
                        var subject = "Invoice cancelled";
                        var table = "<table border='0' cellpadding='4' style='color:#000000;font:normal 11px arial,sans-serif;border:1px solid #abb2b7;width:100%'><thead><tr><th style='color:#434d52;font:bold 13px arial,sans-serif;white-space:nowrap;background-color:#ebeff1;border:1px solid #abb2b7;text-align:center'>Cancelled by</th><th style='color:#434d52;font:bold 13px arial,sans-serif;white-space:nowrap;background-color:#ebeff1;border:1px solid #abb2b7;text-align:center'>Client</th><th style='color:#434d52;font:bold 13px arial,sans-serif;white-space:nowrap;background-color:#ebeff1;border:1px solid #abb2b7;text-align:center'>Invoice Number</th><th style='color:#434d52;font:bold 13px arial,sans-serif;white-space:nowrap;background-color:#ebeff1;border:1px solid #abb2b7;text-align:center'>Reason</th></tr></thead><tbody>";
                        table += "<tr><td style='border:1px solid #abb2b7;text-align:center;'>&nbsp;" + requesterData.FirstName + "</td><td style='border:1px solid #abb2b7;text-align:center;'>&nbsp;" + clientName + "</td><td style='border:1px solid #abb2b7;text-align:center;'>&nbsp;" + invoiceData.InvoiceNumber + "</td><td style='border:1px solid #abb2b7;text-align:center;'>&nbsp;" + reason + "</td></tr>";
                        table += "</tbody></table>";
                        var message = "Following invoice has been cancelled." + Environment.NewLine + table;
                        var receiverMailId = CryptoHelper.Decrypt(existingReceiverData.EmailId);
                        var body = emailTemplate.Template
                                  .Replace("[Name]", requesterName)
                                  .Replace("[MessageContent]", message)
                                  .Replace("[Title]", "Status Of Invoice Request");
                        // SEND MAIL 
                        Utilities.EmailHelper.SendEmailWithDefaultParameter(subject, body, true, true, receiverMailId, null, null, null);
                    }
                }
                result = 3;
            }
            _dbContext.SaveChanges();
            _userServices.SaveUserLogs(ActivityMessages.ReviewInvoice, loginUserId, 0);
            return result;
        }
        public List<InvoicesList> GetRequestedInvoiceInfo(int loginUserId)
        {
            var invoiceSummary = new List<InvoicesList>();
            var invoices = _dbContext.InvoiceRequests.Where(x => x.UserId == loginUserId).OrderByDescending(x => x.InvoiceRequestId).Take(1).FirstOrDefault();
            if (invoices != null)
            {
                invoiceSummary = invoices.InvoiceRequestDetails.Select(s => new InvoicesList
                {
                    InvoiceId = s.InvoiceRequestDetailId,
                    ClientId = s.ClientId,
                    ClientName = s.Client.ClientName,
                    NoOfInvoices = s.AvailableCount,
                    InvoiceCount = s.RequestedCount
                }).ToList();
            }
            return invoiceSummary ?? new List<InvoicesList>();
        }

        public List<FYDropDown> GetFinancialYearsForAccounts()
        {
            var data = _dbContext.Fun_GetFinancialYearForInvoice();
            var result = data.AsEnumerable().Select(x => new FYDropDown()
            {
                Text = x.StartYear.Value + " - " + x.EndYear.Value,
                StartYear = x.StartYear.Value
            })
                           .OrderByDescending(x => x.StartYear)
                           .ToList();
            return result ?? new List<FYDropDown>();
        }
    }
}
