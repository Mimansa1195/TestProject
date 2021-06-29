using iTextSharp.text;
using iTextSharp.text.html.simpleparser;
using iTextSharp.text.pdf;
using iTextSharp.tool.xml;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;
using BO = MIS.BO;

namespace MIS.Utilities
{
    public static class EmailHelper
    {

        /// <summary>
        /// Method to send email to Recipient
        /// </summary>
        /// <param name="subject">email subject</param>
        /// <param name="body">email body</param    >
        /// <param name="isHighPriotity">priority</param>
        /// <param name="isBodyHTML">html mail</param>
        /// <param name="to">recipient seprated by ';'</param>
        /// <param name="cc">cc recipient seprated by ';'</param>
        /// <param name="bcc">cc recipient seprated by ';'</param>
        /// <param name="attachments">multiple attachment files seprated by ';'</param>
        public static async Task SendEmailWithDefaultParameter(string subject, string body, bool isHighPriority, bool isBodyHtml, string to, string cc, string bcc, string attachments)
        {
            string hostAddress = ConfigurationManager.AppSettings["Host"].Trim();
            int portNo = int.Parse(ConfigurationManager.AppSettings["Port"]);
            bool isSslEnabled = Convert.ToBoolean(ConfigurationManager.AppSettings["EnableSsl"]);
            string fromEmailAddress = ConfigurationManager.AppSettings["UserName"].Trim();
            const string senderName = "Team, MIS";
            string password = ConfigurationManager.AppSettings["Password"].Trim();
            bool isSendEmailEnabled = Convert.ToBoolean(ConfigurationManager.AppSettings["IsSendEmailEnabled"]);

            if (isSendEmailEnabled)
                //new Task(() => { SendMail(hostAddress, portNo, isSslEnabled, senderName, fromEmailAddress, password, subject, body, isHighPriority, isBodyHtml, to, cc, bcc, attachments); }).Start();
                await Task.Run(() => SendMail(hostAddress, portNo, isSslEnabled, senderName, fromEmailAddress, password, subject, body, isHighPriority, isBodyHtml, to, cc, bcc, attachments));
        }

        public static async Task SendEmailWithAttachment(string subject, string body, bool isHighPriority, bool isBodyHtml, string to, string cc, string bcc, IList<Attachment> attachments)
        {
            string hostAddress = ConfigurationManager.AppSettings["Host"].Trim();
            int portNo = int.Parse(ConfigurationManager.AppSettings["Port"]);
            bool isSslEnabled = Convert.ToBoolean(ConfigurationManager.AppSettings["EnableSsl"]);
            string fromEmailAddress = ConfigurationManager.AppSettings["UserName"].Trim();
            const string senderName = "Team, MIS";
            string password = ConfigurationManager.AppSettings["Password"].Trim();
            bool isSendEmailEnabled = Convert.ToBoolean(ConfigurationManager.AppSettings["IsSendEmailEnabled"]);

            if (isSendEmailEnabled)
                //new Task(() => { SendMail(hostAddress, portNo, isSslEnabled, senderName, fromEmailAddress, password, subject, body, isHighPriority, isBodyHtml, to, cc, bcc, attachments); }).Start();
                await Task.Run(() => SendEmailWithAttachment(hostAddress, portNo, isSslEnabled, senderName, fromEmailAddress, password, subject, body, isHighPriority, isBodyHtml, to, cc, bcc, attachments));
        
        }

        /// <summary>
        /// Send mail to Recipient
        /// </summary>
        /// <param name="hostAddress">address for SMTP host</param>
        /// <param name="portNo">SMTP port no</param>
        /// <param name="isSslEnabled">enable SSL</param>
        /// <param name="senderName">display name</param>
        /// <param name="fromEmailAddress">email address from which email would be delivered</param>
        /// <param name="password">password for email address</param>
        /// <param name="subject">email subject</param>
        /// <param name="body">email body</param>
        /// <param name="isHighPriotity">priority</param>
        /// <param name="isBodyHtml">html mail</param>
        /// <param name="to">recipient separated by ';'</param>
        /// <param name="cc">cc recipient separated by ';'</param>
        /// <param name="bcc">bcc recipient separated by ';'</param>
        /// <param name="attachments">multiple attachment files separated by ';'</param>
        private static void SendEmailWithAttachment(string hostAddress, int portNo, bool isSslEnabled, string senderName, string fromEmailAddress, string password, string subject, string body, bool isHighPriotity, bool isBodyHtml, string to, string cc, string bcc, IList<Attachment> attachments)
        {
            try
            {
                var client = new SmtpClient();
                var message = new MailMessage();

                // setup client
                client.Host = hostAddress.Trim();
                client.Port = portNo;
                client.EnableSsl = isSslEnabled;
                client.DeliveryMethod = SmtpDeliveryMethod.Network;
                client.UseDefaultCredentials = false;
                client.Credentials = new NetworkCredential(fromEmailAddress.Trim(), password.Trim());
                client.Timeout = 170000;

                // setup sender
                var senderInfo = new MailAddress(fromEmailAddress.Trim(), senderName.Trim());
                message.From = senderInfo;

                // setup message text
                message.Subject = subject;
                message.Body = body;
                message.IsBodyHtml = isBodyHtml;
                if (isHighPriotity)
                {
                    message.Priority = MailPriority.High;
                }

                // setup message recipients

                var toRecipient = to.Split(';');
                foreach (var emailId in toRecipient)
                {
                    if (string.IsNullOrEmpty(emailId)) continue;
                    if (isValidEmailId(emailId))
                    {
                        message.To.Add(emailId);
                    }
                }

                // setup cc
                if (!string.IsNullOrEmpty(cc))
                {
                    var ccRecipient = cc.Split(';');
                    // setup cc 
                    foreach (var emailId in ccRecipient)
                    {
                        if (!string.IsNullOrEmpty(emailId))
                        {
                            if (isValidEmailId(emailId))
                            {
                                message.CC.Add(emailId);
                            }
                        }
                    }
                }

                if (!string.IsNullOrEmpty(bcc))
                {
                    var bccRecipient = bcc.Split(';');
                    // setup bcc
                    foreach (var emailId in bccRecipient)
                    {
                        if (!string.IsNullOrEmpty(emailId))
                        {
                            if (isValidEmailId(emailId))
                            {
                                message.Bcc.Add(emailId);
                            }
                        }
                    }
                }

                // setup attachments
                if (attachments != null && attachments.Any())
                {
                    attachments.ToList().ForEach(x=>message.Attachments.Add(x));
                }

                client.Send(message);
                message.Attachments.Dispose();
               
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="hostAddress"></param>
        /// <param name="portNo"></param>
        /// <param name="isSSLEnabled"></param>
        /// <param name="senderName"></param>
        /// <param name="fromEmailAddress"></param>
        /// <param name="password"></param>
        /// <param name="subject"></param>
        /// <param name="body"></param>
        /// <param name="isHighPriotity"></param>
        /// <param name="isBodyHTML"></param>
        /// <param name="to"></param>
        /// <param name="cc"></param>
        /// <param name="bcc"></param>
        /// <param name="attachments"></param>
        public static void SendMail(string hostAddress, int portNo, bool isSSLEnabled, string senderName, string fromEmailAddress, string password, string subject, string body, bool isHighPriotity, bool isBodyHTML, string to, string cc, string bcc, string attachments)
        {
            try
            {
                System.Net.Mail.SmtpClient client = new System.Net.Mail.SmtpClient();
                System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();

                // setup client
                client.Host = hostAddress.Trim();
                client.Port = portNo;
                client.EnableSsl = isSSLEnabled;
                client.DeliveryMethod = System.Net.Mail.SmtpDeliveryMethod.Network;
                client.UseDefaultCredentials = false;
                client.Credentials = new System.Net.NetworkCredential(fromEmailAddress.Trim(), password.Trim());

                // setup sender
                var SenderInfo = new System.Net.Mail.MailAddress(fromEmailAddress.Trim(), senderName.Trim());
                message.From = SenderInfo;

                // setup message text
                message.Subject = subject;
                message.Body = body;
                message.IsBodyHtml = isBodyHTML;
                if (isHighPriotity)
                {
                    message.Priority = System.Net.Mail.MailPriority.High;
                }

                // setup message receiptents

                string[] toRecipient = to.Split(';');
                foreach (string emailId in toRecipient)
                {
                    if (!string.IsNullOrEmpty(emailId))
                    {
                        if (isValidEmailId(emailId))
                        {
                            message.To.Add(emailId);
                        }
                    }
                }

                // setup cc
                if (!string.IsNullOrEmpty(cc))
                {
                    string[] ccRecipient = cc.Split(';');
                    // setup cc 
                    foreach (string emailId in ccRecipient)
                    {
                        if (!string.IsNullOrEmpty(emailId))
                        {
                            if (isValidEmailId(emailId))
                            {
                                message.CC.Add(emailId);
                            }
                        }
                    }
                }

                if (!string.IsNullOrEmpty(bcc))
                {
                    string[] bccRecipient = bcc.Split(';');
                    // setup bcc
                    foreach (string emailId in bccRecipient)
                    {
                        if (!string.IsNullOrEmpty(emailId))
                        {
                            if (isValidEmailId(emailId))
                            {
                                message.Bcc.Add(emailId);
                            }
                        }
                    }
                }

                // setup attachments
                if (!string.IsNullOrEmpty(attachments))
                {
                    string[] attachFiles = attachments.Split(';');
                    foreach (string fileName in attachFiles)
                    {
                        if (!string.IsNullOrEmpty(fileName))
                        {
                            if (System.IO.File.Exists(fileName))
                            {
                                System.Net.Mail.Attachment attachFile;
                                attachFile = new System.Net.Mail.Attachment(fileName);
                                message.Attachments.Add(attachFile);
                            }
                        }
                    }
                }

                client.Send(message);
                message.Dispose();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static BO.ServiceResult<bool> sendReportsMail(string subject, string body, bool isHighPriotity, bool isBodyHTML, List<string> to, List<string> cc, List<string> bcc, string attachments)
        {
            try
            {
                string hostAddress = ConfigurationManager.AppSettings["Host"];
                int portNo = int.Parse(ConfigurationManager.AppSettings["Port"]);
                bool isSSLEnabled = Convert.ToBoolean(ConfigurationManager.AppSettings["EnableSsl"]);
                string fromEmailAddress = ConfigurationManager.AppSettings["UserName"];
                string senderName = "Team, MIS";
                string password = ConfigurationManager.AppSettings["Password"];

                System.Net.Mail.SmtpClient client = new System.Net.Mail.SmtpClient();
                System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();

                // setup client
                client.Host = hostAddress.Trim();
                client.Port = portNo;
                client.EnableSsl = isSSLEnabled;
                client.DeliveryMethod = System.Net.Mail.SmtpDeliveryMethod.Network;
                client.UseDefaultCredentials = false;
                client.Credentials = new System.Net.NetworkCredential(fromEmailAddress.Trim(), password.Trim());

                // setup sender
                var SenderInfo = new System.Net.Mail.MailAddress(fromEmailAddress.Trim(), senderName.Trim());
                message.From = SenderInfo;

                // setup message text
                message.Subject = subject;
                message.Body = body;
                message.IsBodyHtml = isBodyHTML;
                if (isHighPriotity)
                {
                    message.Priority = System.Net.Mail.MailPriority.High;
                }

                // setup message receiptents


                foreach (string emailId in to)
                {
                    if (!string.IsNullOrEmpty(emailId))
                    {
                        if (isValidEmailId(emailId))
                        {
                            message.To.Add(emailId);
                        }
                    }
                }

                // setup cc
                if (cc != null)
                {

                    // setup cc 
                    foreach (string emailId in cc)
                    {
                        if (!string.IsNullOrEmpty(emailId))
                        {
                            if (isValidEmailId(emailId))
                            {
                                message.CC.Add(emailId);
                            }
                        }
                    }
                }

                if (bcc != null)
                {

                    // setup bcc
                    foreach (string emailId in bcc)
                    {
                        if (!string.IsNullOrEmpty(emailId))
                        {
                            if (isValidEmailId(emailId))
                            {
                                message.Bcc.Add(emailId);
                            }
                        }
                    }
                }

                // setup attachments
                if (!string.IsNullOrEmpty(attachments))
                {
                    string[] attachFiles = attachments.Split(';');
                    foreach (string fileName in attachFiles)
                    {
                        if (!string.IsNullOrEmpty(fileName))
                        {
                            if (System.IO.File.Exists(fileName))
                            {
                                System.Net.Mail.Attachment attachFile;
                                attachFile = new System.Net.Mail.Attachment(fileName);
                                message.Attachments.Add(attachFile);
                            }
                        }
                    }
                }

                client.Send(message);
                return BO.ServiceReturnType.SuccessBoolResult;
            }
            catch (Exception ex)
            {
                return BO.ServiceReturnType.FailureBoolResult;
                //throw ex;
            }
        }

        private static bool isValidEmailId(string emailId)
        {
            try
            {
                var addr = new System.Net.Mail.MailAddress(emailId);
                return true;
            }
            catch
            {
                return false;
            }
        }

        public static async Task EmailWithPDF(string subject, string body, bool isHighPriority, bool isBodyHtml, string to, string cc, string bcc, string attachments1)
        {
            try
            {
                var ccEmail = cc != "" ? cc : null;
                new Task(() => { SendEmailWithPDF(subject, body, isHighPriority, isBodyHtml, to, cc, bcc, attachments1); }).Start();
            }
            catch (Exception ex)
            {
            }
        }

        public static void SendEmailWithPDF(string subject, string body, bool isHighPriority, bool isBodyHtml, string to, string cc, string bcc, string attachments1)
        {
            string hostAddress = ConfigurationManager.AppSettings["Host"].Trim();
            int portNo = int.Parse(ConfigurationManager.AppSettings["Port"]);
            bool isSslEnabled = Convert.ToBoolean(ConfigurationManager.AppSettings["EnableSsl"]);
            string fromEmailAddress = ConfigurationManager.AppSettings["UserName"].Trim();
            const string senderName = "Team, MIS";
            string password = ConfigurationManager.AppSettings["Password"].Trim();
            bool isSendEmailEnabled = Convert.ToBoolean(ConfigurationManager.AppSettings["IsSendEmailEnabled"]);
            SmtpClient client = new SmtpClient();
            MailMessage message = new MailMessage();

            // setup client
            client.Host = hostAddress.Trim();
            client.Port = portNo;
            client.EnableSsl = isSslEnabled;
            client.DeliveryMethod = System.Net.Mail.SmtpDeliveryMethod.Network;
            client.UseDefaultCredentials = false;
            client.Credentials = new System.Net.NetworkCredential(fromEmailAddress.Trim(), password.Trim());

            // setup sender
            var SenderInfo = new System.Net.Mail.MailAddress(fromEmailAddress.Trim(), senderName.Trim());
            message.From = SenderInfo;

            // setup message text
            message.Subject = subject;
            message.Body = body;
            message.IsBodyHtml = isBodyHtml;

            if (isSendEmailEnabled)
            {
                if (attachments1 != null)
                {
                    //Create a byte array that will eventually hold our final PDF
                    Byte[] bytes;
                    //Boilerplate iTextSharp setup here
                    //Create a stream that we can write to, in this case a MemoryStream
                    using (var ms = new MemoryStream())
                    {
                        //Create an iTextSharp Document which is an abstraction of a PDF but **NOT** a PDF
                        using (var doc = new Document())
                        {
                            //Create a writer that's bound to our PDF abstraction and our stream
                            using (var writer = PdfWriter.GetInstance(doc, ms))
                            {
                                //Open the document for writing
                                doc.Open();
                                //XMLWorker also reads from a TextReader and not directly from a string
                                using (var srHtml = new StringReader(attachments1))
                                {
                                    //Parse the HTML
                                    iTextSharp.tool.xml.XMLWorkerHelper.GetInstance().ParseXHtml(writer, doc, srHtml);
                                }
                                doc.Close();
                            }
                        }

                        //After all of the PDF "stuff" above is done and closed but **before** we
                        //close the MemoryStream, grab all of the active bytes from the stream
                        byte[] bytes1 = ms.ToArray();
                        ms.Close();
                        message.Attachments.Add(new Attachment(new MemoryStream(bytes1), "Report.pdf"));
                    }

                    //using (MemoryStream inputMemoryStream = new MemoryStream(Encoding.ASCII.GetBytes(attachments1)))
                    //{
                    //    using (TextReader textReader = new StreamReader(inputMemoryStream, Encoding.ASCII))
                    //    {
                    //        using (Document pdfDoc = new Document())
                    //        {
                    //            using (PdfWriter pdfWriter = PdfWriter.GetInstance(pdfDoc,inputMemoryStream))
                    //            {
                    //                XMLWorkerHelper helper = XMLWorkerHelper.GetInstance();
                    //                pdfDoc.Open();
                    //                helper.ParseXHtml( textReader);

                    //                byte[] bytes1 = inputMemoryStream.ToArray();
                    //                inputMemoryStream.Close();
                    //                message.Attachments.Add(new Attachment(new MemoryStream(bytes1), "cp.pdf"));
                    //            }
                    //        }
                    //    }
                    //}

                    //StringReader sr1 = new StringReader(attachments1);
                    //Document pdfDoc = new Document(PageSize.A4, 10f, 10f, 10f, 0f);
                    //XMLWorkerHelper xmlworker = new XMLWorkerHelper();
                    //var applicationformName = "Appraisal Form";
                    //using (MemoryStream memoryStream = new MemoryStream())
                    //{
                    //    var writer = PdfWriter.GetInstance(pdfDoc, memoryStream);
                    //    XMLWorkerHelper helper = XMLWorkerHelper.GetInstance();
                    //    pdfDoc.Open();
                    //    helper.ParseXHtml(pdfWriter, pdfDoc, textReader);

                    //    xmlworker.ParseXHtml(sr1);
                    //    pdfDoc.Close();
                    //    byte[] bytes1 = memoryStream.ToArray();
                    //    memoryStream.Close();
                    //    message.Attachments.Add(new Attachment(new MemoryStream(bytes1), applicationformName + ".pdf"));
                    //}
                }

                string[] toRecipient = to.Split(';');
                foreach (string emailId in toRecipient)
                {
                    if (!string.IsNullOrEmpty(emailId))
                    {
                        if (isValidEmailId(emailId))
                        {
                            message.To.Add(emailId);
                        }
                    }
                }

                // setup cc
                if (!string.IsNullOrEmpty(cc))
                {
                    string[] ccRecipient = cc.Split(';');
                    // setup cc 
                    foreach (string emailId in ccRecipient)
                    {
                        if (!string.IsNullOrEmpty(emailId))
                        {
                            if (isValidEmailId(emailId))
                            {
                                message.CC.Add(emailId);
                            }
                        }
                    }
                }
                if (bcc != null)
                {
                    string[] bccRecipient = bcc.Split(';');
                    // setup bcc
                    foreach (string emailId in bccRecipient)
                    {
                        if (!string.IsNullOrEmpty(emailId))
                        {
                            if (isValidEmailId(emailId))
                            {
                                message.Bcc.Add(emailId);
                            }
                        }
                    }
                }

                client.Send(message);
                message.Dispose();
            }
        }
    }
}