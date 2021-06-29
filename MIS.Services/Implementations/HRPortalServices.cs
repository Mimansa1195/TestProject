using MIS.BO;
using MIS.Model;
using MIS.Services.Contracts;
using MIS.Utilities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.Entity.Core.Objects;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Web;

namespace MIS.Services.Implementations
{
    public class HRPortalServices : IHRPortalServices
    {
        #region Private member variables.
        private readonly MISEntities _dbContext = new MISEntities();

        //private readonly ICommonService _common;
        #endregion
        private readonly IUserServices _userServices;

        public HRPortalServices(IUserServices userServices)
        {
            _userServices = userServices;
        }

        #region Referral
        public int AddReferral(ReferralBO refer)
        {
            int status = 0;
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(refer.UserAbrhs), out userId);
            var FromDate = DateTime.ParseExact(refer.FromDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            var TillDate = DateTime.ParseExact(refer.EndDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            var result = new ObjectParameter("Success", typeof(int));
            _dbContext.Proc_AddReferral(FromDate, TillDate, refer.Position, refer.Description, userId, result);
            Int32.TryParse(result.Value.ToString(), out status);
            _userServices.SaveUserLogs(ActivityMessages.AddReferral, userId, 0);
            return status;
        }
        public List<ReferralBO> GetReferral()
        {
            var a = DateTime.Now.Date;
            var data = _dbContext.Referrals.Where(x => x.IsPositionClosed == false && x.OpeningTill >= a).ToList();
            var list = data.Select(s => new ReferralBO
            {
                IsExpired = s.IsPositionClosed,
                Position = s.Profile,
                Description = s.Description,
                ReferralId = s.ReferralId,
                CreatedDate = s.CreatedDate.ToString()

            }).OrderByDescending(s => s.CreatedDate).ToList();
            return list ?? new List<ReferralBO>();

        }
        public List<ReferralBO> GetAllReferral()
        {
            var data = _dbContext.Referrals.ToList();
            var currentDate = DateTime.Now.Date;


            var list = data.Select(s => new ReferralBO
            {
                FromDate = s.OpeningFrom.ToString("MM/dd/yyyy"),
                EndDate = s.OpeningTill.ToString("MM/dd/yyyy"),
                IsExpired = (currentDate <= s.OpeningTill && s.IsPositionClosed == false) ? false : true,
                Count = _dbContext.ReferralDetails.Count(x => x.ReferralId == s.ReferralId),
                Position = s.Profile,
                Description = s.Description,
                ReferralId = s.ReferralId,
                CreatedDate = s.CreatedDate.ToString("MM/dd/yyyy")

            }).OrderByDescending(s => s.CreatedDate).ToList();
            return list ?? new List<ReferralBO>();

        }
        public int AddRefereeByUser(int referralId, string refereeName, string relation, string resume, string base64FormData, string userAbrhs)
        {
            int status = 0;
            var employeeId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out employeeId);
            var receiverMailId = ConfigurationManager.AppSettings["HrEmailId"];
            if (referralId > 0 && employeeId > 0 && !String.IsNullOrEmpty(userAbrhs) && !String.IsNullOrEmpty(base64FormData))
            {
                var basePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["ReferralDocumentPath"] + userAbrhs.Trim() + "\\";
                if (!Directory.Exists(basePath))
                {
                    Directory.CreateDirectory(basePath);
                }
                byte[] decodedByteArray = Convert.FromBase64String(base64FormData.Split(',')[1]);
                var filepath = basePath + resume;
                var existingFile = new FileInfo(filepath);
                var timeStamp = string.Format("{0:dd-MM-yyyy_hh-mm-ss-tt}", DateTime.Now);
                var newFileName = string.Format("{0}_{1}{2}", refereeName, timeStamp, existingFile.Extension);
                File.WriteAllBytes(basePath + newFileName, decodedByteArray);
                //Utilities.Helpers.WordToPDFConverter.ConvertWordToPDF(newFileName, basePath, basePath);
                var result = new ObjectParameter("Success", typeof(int));
                _dbContext.Proc_AddRefereeByUser(referralId, refereeName, relation, newFileName, employeeId, result);
                Int32.TryParse(result.Value.ToString(), out status);
                _userServices.SaveUserLogs(ActivityMessages.AddReferees, employeeId, 0);
                //Microsoft.Office.Interop.Word.Application appWord = new Microsoft.Office.Interop.Word.Application();
                //var wordDocument = appWord.Documents.Open(resume);
                //wordDocument.ExportAsFixedFormat(resume, WdExportFormat.wdExportFormatPDF);
            }

            var referral = _dbContext.Referrals.Single(x => x.ReferralId == referralId);
            var subject = "Refferal Added";
            var message = $"Candidate reffered for postion {referral.Profile}. Please visit MIS portal for further action.";
            var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == EmailTemplates.NotifyHR && f.IsActive && !f.IsDeleted);
            if (emailTemplate != null)
            {
                var body = emailTemplate.Template
                          .Replace("[MESSAGE]", message)
                          .Replace("[SenderName]", "HR Department")
                          .Replace("[HEADING]", $"Refferal Added for position {referral.Profile}");
                // SEND MAIL 
                Utilities.EmailHelper.SendEmailWithAttachment(subject, body, true, true, receiverMailId, null, null, null);
            }
                return status;
        }
        public List<ReferralBO> GetAllRequestedReferral(int referralId)
        {
            var data = _dbContext.ReferralDetails.Where(x => x.ReferralId == referralId).ToList();
            var list = data.Select(s => new ReferralBO
            {
                ReferalDetailId = s.ReferralDetailId,
                ReferralId = s.ReferralId,
                RefereeName = s.RefereeName,
                ReferredBy = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == s.ReferredById).FirstName + ' ' + _dbContext.UserDetails.FirstOrDefault(x => x.UserId == s.ReferredById).MiddleName + ' ' + _dbContext.UserDetails.FirstOrDefault(x => x.UserId == s.ReferredById).LastName,
                Resume = s.Resume,
                JsonDataList = _dbContext.ReferralReviews.Where(x => x.ReferralDetailId == s.ReferralDetailId /*&& x.RefereeName == s.RefereeName*/).Select(a => new ReferralStatusList
                {
                    ReferralReviewId = a.ReferralReviewId,
                    ForwardedTo = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == a.ForwardedToId).FirstName + " " + _dbContext.UserDetails.FirstOrDefault(x => x.UserId == a.ForwardedToId).MiddleName + " " + _dbContext.UserDetails.FirstOrDefault(x => x.UserId == a.ForwardedToId).LastName,
                    IsRelevant = a.IsRelevant ?? 2,
                    ForwardedOn = a.CreatedDate.ToString()
                }).ToList() ?? new List<ReferralStatusList>(),
                Position = _dbContext.Referrals.FirstOrDefault(x => x.ReferralId == referralId).Profile,
                CreatedDate = s.CreatedDate.ToString("MM/dd/yyyy"),
                ReferredById = s.ReferredById
            }).ToList();
            return list ?? new List<ReferralBO>();
        }
        public string FetchAllRefereeDetails(int referralDetailId, int referredById)
        {
            var referredByAbrhs = "";
            referredByAbrhs = CryptoHelper.Encrypt(Convert.ToString(referredById));
            var fileName = _dbContext.ReferralDetails.FirstOrDefault(x => x.ReferralDetailId == referralDetailId).Resume;
            var basePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["ReferralDocumentPath"] + referredByAbrhs.Trim() + "\\";
            var finalFilePath = basePath + fileName;
            if (!File.Exists(finalFilePath))
                return string.Empty;
            //var downloadPath = "";
            //var t = new Thread((ThreadStart)(() =>
            //{
            //    SaveFileDialog saveFileDialog1 = new SaveFileDialog();
            //    saveFileDialog1.InitialDirectory = Convert.ToString(Environment.SpecialFolder.MyDocuments);
            //    saveFileDialog1.Filter = "Your extension here (*.EXT)|*.ext|All Files (*.*)|*.*";
            //    saveFileDialog1.FilterIndex = 1;

            //    if (saveFileDialog1.ShowDialog() == DialogResult.OK)
            //    {
            //        Console.WriteLine(saveFileDialog1.FileName);//Do what you want here

            //        WebClient webClient = new WebClient();
            //        downloadPath = Path.GetFullPath(saveFileDialog1.FileName);
            //        webClient.DownloadFile(downloadPath, saveFileDialog1.FileName);
            //    }

            //}));
            //Response.Clear();
            //downloadPath = downloadPath + fileName;
            ////Response.ContentType = "application/pdf";
            ////Response.AppendHeader("Content-Disposition", "attachment; filename=foo.pdf");
            ////Response.TransmitFile(downloadPath);
            ////Response.End();
            byte[] formInByte = File.ReadAllBytes(finalFilePath);
            var formInBase64String = Convert.ToBase64String(formInByte);
            var fileExtension = fileName.Split('.')[1];
            var base64Data = CommonUtility.GetBase64MimeType(fileExtension) + "," + formInBase64String;
            return base64Data;
        }
        public bool ChangeReferralStatus(int referralId, int status, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var result = _dbContext.Proc_ChangeReferralStatus(referralId, status, userId).FirstOrDefault();
            _userServices.SaveUserLogs(ActivityMessages.ChangeReferralStatus, userId, 0);
            return result.Value;
        }
        public ReferralBO ViewReferralDetails(int referralId, string userAbrhs)
        {
            var data = new ReferralBO();
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            if (userId > 0)
            {
                var result = _dbContext.Referrals.Where(x => x.ReferralId == referralId).FirstOrDefault();
                //DateTime date = DateTime.ParseExact(result.From.ToString(), "dd/MM/yyyy", null);
                //string s = date.ToString("dd/M/yyyy", CultureInfo.InvariantCulture);
                data.ReferralId = result.ReferralId;
                data.FromDate = result.OpeningFrom.Date.ToString("MM/dd/yyyy");
                data.EndDate = result.OpeningTill.Date.ToString("MM/dd/yyyy");
                data.Position = result.Profile;
                data.Description = result.Description;
            }
            return data;
        }
        public int UpdateReferrals(ReferralBO refer)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(refer.UserAbrhs), out userId);


            var data = _dbContext.Referrals.FirstOrDefault(x => x.ReferralId == refer.ReferralId);
            var FromDate = DateTime.ParseExact(refer.FromDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            var TillDate = DateTime.ParseExact(refer.EndDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            if (data == null)
            {

                return 2;
            }
            data.OpeningFrom = FromDate;
            data.OpeningTill = TillDate;
            data.IsPositionClosed = false;
            data.Profile = refer.Position;
            data.Description = refer.Description;
            data.LastModifiedDate = DateTime.Now;
            data.LastModifiedBy = userId;
            _dbContext.SaveChanges();
            _userServices.SaveUserLogs(ActivityMessages.UpdateJobPositions, userId, 0);
            return 1;
        }
        public int ForwardReferrals(int detailId, string resume, int referredById, string empIds, string message, string appLinkUrl, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var userIdsList = CustomExtensions.SplitUseridsToIntList(empIds);
            var splittedUserIds = string.Join(",", userIdsList);
            if (detailId > 0 && referredById > 0)
            {
                int status = 0;
                var result = new ObjectParameter("Success", typeof(int));
                _dbContext.Proc_ForwardReferees(detailId, referredById, splittedUserIds, message, userId, result);
                _dbContext.SaveChanges();
                Int32.TryParse(result.Value.ToString(), out status);
            }
            int t = 0;
            //Prepare Attachment
            var referralByAbrhs = CryptoHelper.Encrypt(referredById.ToString());
            var basePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["ReferralDocumentPath"] + referralByAbrhs.Trim() + "\\";
            var filepath = basePath + resume;
            var fileName = resume;
            byte[] bytes = File.ReadAllBytes(filepath);
            MemoryStream ms = new MemoryStream();
            ms.Write(bytes, 0, bytes.Length - 1);
            var attachmentFile = new System.Net.Mail.Attachment(ms, fileName, MediaTypes.Pdf);

            //var data = _dbContext.ReferralStatus.Where(x => x.ReferralDetailId == detailId && x.IsRelevant == null).ToList();
            foreach (var fwEmpUserId in userIdsList)
            {
                var data = _dbContext.ReferralReviews.FirstOrDefault(x => x.ReferralDetailId == detailId && x.ForwardedToId == fwEmpUserId);
                var existingReceiverData = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == fwEmpUserId);
                var receiverFirstName = existingReceiverData.FirstName;
                var receiverLastName = existingReceiverData.LastName;
                //var senderFirstName = existingSenderData.FirstName;
                //var senderLastName = existingSenderData.LastName;
                
                var subject = "Reviewal of referrals";
                var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == EmailTemplates.ForwardedReferrals && f.IsActive && !f.IsDeleted);
                if (emailTemplate != null && existingReceiverData != null)
                {
                    var dataForQueryString = userId + "&" + existingReceiverData.UserId + "&" + data.ReferralReviewId;
                    var key = CryptoHelper.Encrypt(dataForQueryString.ToString());
                    var AppoveRequestUrl = appLinkUrl + "?for=appr&encodedData=" + key + "";
                    var CancleRequestUrl = appLinkUrl + "?for=cancle&encodedData=" + key + "";
                    var receiverMailId = CryptoHelper.Decrypt(existingReceiverData.EmailId);
                    var body = emailTemplate.Template
                              .Replace("[NAME]", receiverFirstName.ToTitleCase())
                              .Replace("[MESSAGE]", message)
                              .Replace("[LINKAPPROVE]", AppoveRequestUrl)
                              .Replace("[LINKREJECT]", CancleRequestUrl)
                              .Replace("[SenderName]", "HR Department")
                              .Replace("[HEADING]", "Review Referrals");
                    // SEND MAIL 
                    Utilities.EmailHelper.SendEmailWithAttachment(subject, body, true, true, receiverMailId, null, null, new List<Attachment> { attachmentFile });
                    _dbContext.SaveChanges();


                }
                t = 1;
            }
            return t;
        }

        public int ForwardAllReferrals(int referralId, string empIds, string message, string appLinkUrl, string userAbrhs)
        {
            int t = 0;
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var userIdsList = CustomExtensions.SplitUseridsToIntList(empIds);
            var splittedUserIds = string.Join(",", userIdsList);
            var profileName = _dbContext.Referrals.FirstOrDefault(x => x.ReferralId == referralId).Profile;
            var refDetail = _dbContext.ReferralDetails.Where(x => x.ReferralId == referralId).ToList();
            foreach (var detail in refDetail)
            {
                int status = 0;
                var result = new ObjectParameter("Success", typeof(int));
                _dbContext.Proc_ForwardReferees(detail.ReferralDetailId, detail.ReferredById, splittedUserIds, message, userId, result);
                _dbContext.SaveChanges();
                Int32.TryParse(result.Value.ToString(), out status);
            }
                      
            foreach (var fwEmpUserId in userIdsList)
            {
                var existingReceiverData = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == fwEmpUserId);
                var receiverFirstName = existingReceiverData.FirstName;
                var receiverLastName = existingReceiverData.LastName;
                var receiverMailId = CryptoHelper.Decrypt(existingReceiverData.EmailId);
                var subject = "Reviewal of referrals";
                var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "Pending Approvals" && f.IsActive && !f.IsDeleted);
                var table = "";
                table = "<table border='0' cellpadding='4' style='color:#000000;font:normal 11px arial,sans-serif;border:1px solid #abb2b7;width:100%'><thead><tr><th style='color:#434d52;font:bold 13px arial,sans-serif;white-space:nowrap;background-color:#ebeff1;border:1px solid #abb2b7'>Candidate</th><th style='color:#434d52;font:bold 13px arial,sans-serif;white-space:nowrap;background-color:#ebeff1;border:1px solid #abb2b7'>Profile</th><th style='color:#434d52;font:bold 13px arial,sans-serif;white-space:nowrap;background-color:#ebeff1;border:1px solid #abb2b7'>Action</th></tr></thead><tbody>";
                var resumes = new List<Attachment>();
                foreach (var det in refDetail)
                {
                    var data = _dbContext.ReferralReviews.FirstOrDefault(x => x.ReferralDetailId == det.ReferralDetailId && x.ForwardedToId == fwEmpUserId);

                    //Prepare Attachment
                    resumes.Add(PrepareAttachment(det));

                    if (emailTemplate != null && existingReceiverData != null)
                    {
                        var dataForQueryString = userId + "&" + existingReceiverData.UserId + "&" + data.ReferralReviewId;
                        var key = CryptoHelper.Encrypt(dataForQueryString.ToString());
                        var AppoveRequestUrl = appLinkUrl + "?for=appr&encodedData=" + key + "";
                        var CancleRequestUrl = appLinkUrl + "?for=cancle&encodedData=" + key + "";


                        table = table + "<tr style=height: 40px><td style='border:1px solid #abb2b7;width:50%'>&nbsp;" + det.RefereeName + "</td><td style='border:1px solid #abb2b7;width:30%'>&nbsp;" + profileName + "</td>";
                        table += "<td style='border:1px solid #abb2b7;width:20%;'>" +
                            "<a href=" + AppoveRequestUrl + "target=_blank>Relevant</a> &nbsp; &nbsp; &nbsp; &nbsp;" +
                            " <a href=" + CancleRequestUrl + "target=_blank>Irrelevant</a></td></tr>";

                    }
                }

                table = table + "</tbody>";
                var body = emailTemplate.Template
                         .Replace("[Name]", receiverFirstName.ToTitleCase())
                         .Replace("[Title]", "PENDING APPROVALS")
                         .Replace("[Line1]", message)
                         .Replace("[Data]", table);
                Utilities.EmailHelper.SendEmailWithAttachment(subject, body, true, true, receiverMailId, null, null, resumes);
                //_dbContext.SaveChanges();

            }

            t = 1;
            return t;
        }

        private static Attachment PrepareAttachment(ReferralDetail det)
        {
            var referralByAbrhs = CryptoHelper.Encrypt(det.ReferredById.ToString());
            var basePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["ReferralDocumentPath"] + referralByAbrhs.Trim() + "\\";
            var filepath = basePath + det.Resume;
            var fileName = det.Resume;
            byte[] bytes = File.ReadAllBytes(filepath);
            MemoryStream ms = new MemoryStream();
            ms.Write(bytes, 0, bytes.Length - 1);
            
            return new Attachment(ms, fileName, MediaTypes.Pdf);
        }

        public int MarkRelevantForReferral(string ActionData, string Reason)

        {
            try
            {
                using (var context = new MISEntities())
                {
                    var realdata = CryptoHelper.Decrypt(ActionData);
                    string[] substrings = realdata.Split('&');
                    int userId = Convert.ToInt32(substrings[0]);
                    int receiverID = Convert.ToInt32(substrings[1]);
                    int referralStatusId = Convert.ToInt32(substrings[2]);
                    var data = _dbContext.ReferralReviews.FirstOrDefault(x => x.ReferralReviewId == referralStatusId);
                    data.IsRelevant = 1;
                    data.CommentsByReviewer = Reason;
                    data.LastModifiedBy = receiverID;
                    data.LastModifiedDate = DateTime.Now;
                    _dbContext.SaveChanges();
                    var emailTemplate = context.EmailTemplates.FirstOrDefault(f => f.TemplateName == "Action On Referral" && f.IsActive && !f.IsDeleted);
                    if (emailTemplate != null)
                    {
                        var userDetail = context.UserDetails.FirstOrDefault(f => f.UserId == userId);
                        var receiverDetail = context.vwActiveUsers.FirstOrDefault(f => f.UserId == receiverID);
                        var refereeDetail = _dbContext.ReferralReviews.FirstOrDefault(f => f.ReferralReviewId == referralStatusId);
                        var refereeName = _dbContext.ReferralDetails.FirstOrDefault(f => f.ReferralDetailId == refereeDetail.ReferralDetailId);
                        var EmailId = CryptoHelper.Decrypt(userDetail.EmailId);
                        var subject = "Regarding review response on referral";
                        var body = emailTemplate.Template
                              .Replace("[Name]", userDetail.FirstName.ToTitleCase())
                              .Replace("[COMMENTS]", Reason)
                              .Replace("[RefereeName]", refereeName.RefereeName)
                              .Replace("[ACTION]", "RELEVANT")
                              .Replace("[COLOR]", "green")
                              .Replace("[ActionByName]", receiverDetail.EmployeeName)
                              .Replace("[Heading]", "REFERRAL REVIEW RESPONSE");
                        Utilities.EmailHelper.SendEmailWithDefaultParameter(subject, body, true, true, EmailId, null, null, null);
                    }
                    _userServices.SaveUserLogs(ActivityMessages.MarkRelevant, receiverID, 0);
                    return 1;
                }

            }
            catch (Exception e)
            {
                return 0;
            }
        }

        public int MarkIrrelevantForReferral(string ActionData, string Reason)
        {
            try
            {
                using (var context = new MISEntities())
                {
                    var realdata = CryptoHelper.Decrypt(ActionData);
                    string[] substrings = realdata.Split('&');
                    int userId = Convert.ToInt32(substrings[0]);
                    int receiverID = Convert.ToInt32(substrings[1]);
                    int referralStatusId = Convert.ToInt32(substrings[2]);
                    //int referredById = Convert.ToInt32(substrings[3]);
                    var data = _dbContext.ReferralReviews.FirstOrDefault(x => x.ReferralReviewId == referralStatusId);
                    data.IsRelevant = 0;
                    data.CommentsByReviewer = Reason;
                    data.LastModifiedBy = receiverID;
                    data.LastModifiedDate = DateTime.Now;
                    _dbContext.SaveChanges();
                    var emailTemplate = context.EmailTemplates.FirstOrDefault(f => f.TemplateName == "Action On Referral" && f.IsActive && !f.IsDeleted);
                    if (emailTemplate != null)
                    {
                        var refereeDetail = _dbContext.ReferralReviews.FirstOrDefault(f => f.ReferralReviewId == referralStatusId);
                        var refereeName = _dbContext.ReferralDetails.FirstOrDefault(f => f.ReferralDetailId == refereeDetail.ReferralDetailId);
                        var userDetail = context.UserDetails.FirstOrDefault(f => f.UserId == refereeDetail.ReferredById);
                        var receiverDetail = context.vwActiveUsers.FirstOrDefault(f => f.UserId == receiverID);
                        var EmailId = CryptoHelper.Decrypt(userDetail.EmailId);
                        var subject = "Regarding review response on referral";
                        var body = emailTemplate.Template
                              .Replace("[Name]", userDetail.FirstName.ToTitleCase())
                              .Replace("[COMMENTS]", Reason)
                              .Replace("[RefereeName]", refereeName.RefereeName)
                              .Replace("[ACTION]", "IRRELEVANT")
                              .Replace("[COLOR]", "red")
                              .Replace("[ActionByName]", receiverDetail.EmployeeName)
                              .Replace("[Heading]", "REFERRAL REVIEW RESPONSE");
                        Utilities.EmailHelper.SendEmailWithDefaultParameter(subject, body, true, true, EmailId, null, null, null);
                    }
                    _userServices.SaveUserLogs(ActivityMessages.MarkIrrelevant, receiverID, 0);
                    return 1;
                }
            }
            catch (Exception e)
            {
                return 0;
            }
        }
        public int SendReminderForReferral(int reviewId, int loginUserId)
        {

            var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "Referral Review Reminder" && f.IsActive && !f.IsDeleted);
            if (emailTemplate != null)
            {

                var referralDetail = _dbContext.ReferralReviews.FirstOrDefault(f => f.ReferralReviewId == reviewId);
                var receiverId = referralDetail.ForwardedToId;
                var refereeDetail = _dbContext.ReferralDetails.FirstOrDefault(x => x.ReferralDetailId == referralDetail.ReferralDetailId);
                var receiverDetail = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == receiverId);
                var EmailId = CryptoHelper.Decrypt(receiverDetail.EmailId);
                var subject = "Reminder for referral review";
                var body = emailTemplate.Template
                      .Replace("[Name]", receiverDetail.FirstName.ToTitleCase())
                      .Replace("[RefereeName]", refereeDetail.RefereeName)
                      .Replace("[HEADING]", "REMINDER FOR REFERRAL REVIEW");
                Utilities.EmailHelper.SendEmailWithDefaultParameter(subject, body, true, true, EmailId, null, null, null);
            }
            _userServices.SaveUserLogs(ActivityMessages.SendReminderForReferral, loginUserId, 0);
            return 1;
        }
        public string ViewResume(string basePath, int detailId, int referredById)
        {
            var referredByAbrhs = CryptoHelper.Encrypt(referredById.ToString());
            var newBasePath = basePath + referredByAbrhs.Trim() + "\\";
            var fileName = _dbContext.ReferralDetails.FirstOrDefault(x => x.ReferralDetailId == detailId).Resume;
            var finalBasePath = newBasePath + fileName;
            if (!File.Exists(finalBasePath))
                return string.Empty;

            byte[] formInByte = File.ReadAllBytes(finalBasePath);
            var formInBase64String = Convert.ToBase64String(formInByte);

            var fileExtension = fileName.Split('.')[1];
            var link = "";
            link = CommonUtility.GetBase64MimeType(fileExtension) + "," + formInBase64String;
            return link;
        }
        #endregion

        #region Training
        public int AddTrainings(TrainingBO data)
        {
            var status = 0;
            var userId = 0;
            var newFileName = "";
            Int32.TryParse(CryptoHelper.Decrypt(data.UserAbrhs), out userId);
            var FromDate = DateTime.ParseExact(data.FromDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            var TillDate = DateTime.ParseExact(data.EndDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            var TentativeDate = DateTime.ParseExact(data.TentativeDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            if (data.base64FormData != null)
            {
                var basePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["TrainingDocumentPath"] + data.UserAbrhs.Trim() + "\\";
                if (!Directory.Exists(basePath))
                {
                    Directory.CreateDirectory(basePath);
                }
                byte[] decodedByteArray = Convert.FromBase64String(data.base64FormData.Split(',')[1]);
                var filepath = basePath + data.Document;
                var existingFile = new FileInfo(filepath);
                var timeStamp = string.Format("{0:dd-MM-yyyy_hh-mm-ss-tt}", DateTime.Now);
                newFileName = string.Format("{0}_{1}{2}", data.Title, timeStamp, existingFile.Extension);
                File.WriteAllBytes(basePath + newFileName, decodedByteArray);
            }
            var result = new ObjectParameter("Success", typeof(int));
            _dbContext.Proc_AddTraining(data.Title, data.Description, TentativeDate, FromDate, TillDate, newFileName, userId, result);
            Int32.TryParse(result.Value.ToString(), out status);
            _userServices.SaveUserLogs(ActivityMessages.AddTrainings, userId, 0);
            return status;
        }
        public List<TrainingBO> GetAllTrainings()
        {
            var data = _dbContext.Trainings.ToList();
            var currentDate = DateTime.Now.Date;
            var list = data.Select(s => new TrainingBO
            {
                FromDate = s.NominationStartDate.ToString("dd MMM yyyy"),
                EndDate = s.NominationEndDate.ToString("dd MMM yyyy"),
                IsNominationClosed = (currentDate <= s.NominationEndDate && s.IsNominationClosed == false) ? false : true,
                Count = _dbContext.TrainingDetails.Count(x => x.TrainingId == s.TrainingId),
                TentativeDate = s.TentativeDate.ToString("dd MMM yyyy"),
                Title = s.Title,
                Description = s.Description,
                TrainingId = s.TrainingId,
                CreatedDate = s.CreatedDate.ToString("dd MMM yyyy hh:mm tt")

            }).OrderByDescending(s => s.CreatedDate).ToList();
            return list ?? new List<TrainingBO>();

        }
        public List<TrainingBO> GetTrainings(string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var currentDate = DateTime.Now.Date;
            var info = _dbContext.TrainingDetails;

            var data = (from t in _dbContext.Trainings.AsEnumerable()
                            //join td in _dbContext.TrainingDetails on t.TrainingId equals td.TrainingId into list1
                            //from l1 in list1.DefaultIfEmpty()
                        where t.IsNominationClosed == false && t.NominationEndDate >= currentDate //&& l1.EmployeeId == userId
                        select new TrainingBO
                        {
                            TentativeDate = t.TentativeDate.ToString("dd MMM yyyy"),
                            Description = t.Description,
                            TrainingId = t.TrainingId,
                            Title = t.Title,
                            CreatedDate = t.CreatedDate.ToString("dd MMM yyyy hh:mm tt"),
                            IsApplied = t.TrainingDetails.Where(x => x.TrainingId == t.TrainingId && x.EmployeeId == userId && x.StatusId != 4).Count() > 0,
                            IsDocumented = t.IsDocumented,
                            Document = t.Document
                        }).OrderByDescending(s => s.CreatedDate).ToList();
            return data ?? new List<TrainingBO>();
        }
        public TrainingBO ViewTrainingDetails(int trainingId, string userAbrhs)
        {
            var data = new TrainingBO();
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            if (userId > 0)
            {
                var result = _dbContext.Trainings.Where(x => x.TrainingId == trainingId).FirstOrDefault();
                data.TrainingId = result.TrainingId;
                data.FromDate = result.NominationStartDate.Date.ToString("MM/dd/yyyy");
                data.EndDate = result.NominationEndDate.Date.ToString("MM/dd/yyyy");
                data.TentativeDate = result.TentativeDate.Date.ToString("MM/dd/yyyy");
                data.Title = result.Title;
                data.Description = result.Description;
                //data.Document = result.Document;
            }
            return data;
        }
        public int UpdateTrainingDetails(TrainingBO data)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(data.UserAbrhs), out userId);
            var result = _dbContext.Trainings.FirstOrDefault(x => x.TrainingId == data.TrainingId);
            var FromDate = DateTime.ParseExact(data.FromDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            var TillDate = DateTime.ParseExact(data.EndDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            var TentativeDate = DateTime.ParseExact(data.TentativeDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            if (data == null)
            {
                return 2;
            }
            result.NominationStartDate = FromDate;
            result.NominationEndDate = TillDate;
            result.TentativeDate = TentativeDate;
            result.IsNominationClosed = false;
            result.Title = data.Title;
            //result.Document = data.Document;
            data.Description = data.Description;
            result.LastModifiedDate = DateTime.Now;
            result.LastModifiedBy = userId;
            _dbContext.SaveChanges();
            _userServices.SaveUserLogs(ActivityMessages.UpdateTrainingDetails, userId, 0);
            return 1;
        }
        public bool ChangeTrainingStatus(int trainingId, int status, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var result = _dbContext.Proc_ChangeTrainingStatus(trainingId, status, userId).FirstOrDefault();
            _userServices.SaveUserLogs(ActivityMessages.ChangeTrainingStatus, userId, 0);
            return result.Value;
        }
        public int ApplyForTrainings(int trainingId, string userAbrhs)
        {
            var status = 0;
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var result = new ObjectParameter("Success", typeof(int));
            _dbContext.Proc_ApplyForTrainingSession(trainingId, userId, result);
            Int32.TryParse(result.Value.ToString(), out status);
            _userServices.SaveUserLogs(ActivityMessages.ApplyForTrainings, userId, 0);
            return status;
        }

        public List<TrainingBO> ViewAppliedTrainingDetails(int trainingId, string userAbrhs)
        {

            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var result = _dbContext.TrainingDetails.Where(x => x.TrainingId == trainingId && x.EmployeeId == userId).ToList();
            var info = _dbContext.Trainings.FirstOrDefault(x => x.TrainingId == trainingId);
            var list = result.Select(s => new TrainingBO
            {
                TrainingId = trainingId,
                TentativeDate = info.TentativeDate.ToString("dd MMM yyyy"),
                Description = info.Description,
                CreatedDate = s.CreatedDate.ToString("dd MMM yyyy hh:mm tt"),
                TrainingDetailId = s.TrainingDetailId,
                Remarks = s.Remarks ?? _dbContext.TrainingStatus.FirstOrDefault(x => x.StatusId == s.StatusId).Status,
                Status = _dbContext.TrainingStatus.FirstOrDefault(x => x.StatusId == s.StatusId).Status,
                StatusId = s.StatusId
            }).OrderByDescending(s => s.CreatedDate).ToList();
            return list ?? new List<TrainingBO>();
        }
        public int TakeActionOnTrainingRequest(int trainingDetailId, int statusId, string remarks, string userAbrhs)
        {
            var employeeId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out employeeId);
            var data = _dbContext.TrainingDetails.FirstOrDefault(x => x.TrainingDetailId == trainingDetailId);
            if (data != null)
            {
                data.Remarks = remarks ?? _dbContext.TrainingStatus.FirstOrDefault(x => x.StatusId == statusId).Status;
                data.StatusId = statusId;
                data.LastModifiedBy = employeeId;
                data.LastModifiedDate = DateTime.Now;
                _dbContext.SaveChanges();
                _userServices.SaveUserLogs(ActivityMessages.ActionOnTrainingRequest, employeeId, 0);
            }
            return 1;
        }
        public List<TrainingBO> GetAllNomineesDetails(int trainingId, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var data = _dbContext.TrainingDetails.Where(x => x.TrainingId == trainingId).ToList();
            var info = _dbContext.Trainings.FirstOrDefault(x => x.TrainingId == trainingId);
            var list = data.Select(s => new TrainingBO
            {
                TrainingDetailId = s.TrainingDetailId,
                TrainingId = s.TrainingId,
                AppliedBy = _dbContext.vwAllUsers.FirstOrDefault(x => x.UserId == s.EmployeeId) != null ? _dbContext.vwAllUsers.FirstOrDefault(x => x.UserId == s.EmployeeId).EmployeeName : "",
                TentativeDate = info.TentativeDate.ToString("dd MMM yyyy"),
                Description = info.Description,
                Remarks = s.Remarks,
                CreatedDate = s.CreatedDate.ToString("dd MMM yyyy hh:mm tt"),
                Status = _dbContext.TrainingStatus.FirstOrDefault(x => x.StatusId == s.StatusId).Status,
                ApproverId = s.ApproverId,
                UserId = userId,
                EmployeeCode = _dbContext.vwAllUsers.FirstOrDefault(x => x.UserId == s.EmployeeId) != null ? _dbContext.vwAllUsers.FirstOrDefault(x => x.UserId == s.EmployeeId).EmployeeCode : "",
                EmailId = _dbContext.vwAllUsers.FirstOrDefault(x => x.UserId == s.EmployeeId) != null ? CryptoHelper.Decrypt(_dbContext.vwAllUsers.FirstOrDefault(x => x.UserId == s.EmployeeId).EmailId) : ""
            }).ToList();
            return list ?? new List<TrainingBO>();
        }
        public List<TrainingBO> GetPendingTrainingRequests(string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var data = _dbContext.TrainingDetails.Where(x => x.ApproverId == userId && x.StatusId == 1).ToList();
            //var info = _dbContext.Trainings.FirstOrDefault(x => x.TrainingId == trainingId);
            var list = data.Select(s => new TrainingBO
            {
                TrainingDetailId = s.TrainingDetailId,
                TrainingId = s.TrainingId,
                AppliedBy = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == s.EmployeeId).FirstName + ' ' + _dbContext.UserDetails.FirstOrDefault(x => x.UserId == s.EmployeeId).MiddleName + ' ' + _dbContext.UserDetails.FirstOrDefault(x => x.UserId == s.EmployeeId).LastName,
                TentativeDate = _dbContext.Trainings.FirstOrDefault(x => x.TrainingId == s.TrainingId).TentativeDate.ToString("dd MMM yyyy"),
                Description = _dbContext.Trainings.FirstOrDefault(x => x.TrainingId == s.TrainingId).Description,
                Title = _dbContext.Trainings.FirstOrDefault(x => x.TrainingId == s.TrainingId).Title,
                CreatedDate = s.CreatedDate.ToString("dd MMM yyyy hh:mm tt"),
                StatusId = s.StatusId,
                Status = _dbContext.TrainingStatus.FirstOrDefault(x => x.StatusId == s.StatusId).Status,
                ApproverId = s.ApproverId,
                UserId = userId
            }).ToList();
            return list ?? new List<TrainingBO>();
        }
        public List<TrainingBO> GetReviwedTrainingRequests(string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var data = _dbContext.TrainingDetails.Where(x => x.ApproverId == userId && x.StatusId != 1).ToList();
            //var info = _dbContext.Trainings.FirstOrDefault(x => x.TrainingId == trainingId);
            var list = data.Select(s => new TrainingBO
            {
                TrainingDetailId = s.TrainingDetailId,
                TrainingId = s.TrainingId,
                AppliedBy = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == s.EmployeeId).FirstName + ' ' + _dbContext.UserDetails.FirstOrDefault(x => x.UserId == s.EmployeeId).MiddleName + ' ' + _dbContext.UserDetails.FirstOrDefault(x => x.UserId == s.EmployeeId).LastName,
                TentativeDate = _dbContext.Trainings.FirstOrDefault(x => x.TrainingId == s.TrainingId).TentativeDate.ToString("dd MMM yyyy"),
                Description = _dbContext.Trainings.FirstOrDefault(x => x.TrainingId == s.TrainingId).Description,
                Title = _dbContext.Trainings.FirstOrDefault(x => x.TrainingId == s.TrainingId).Title,
                CreatedDate = s.CreatedDate.ToString("dd MMM yyyy hh:mm tt"),
                StatusId = s.StatusId,
                Remarks = s.Remarks,
                Status = _dbContext.TrainingStatus.FirstOrDefault(x => x.StatusId == s.StatusId).Status,
                ApproverId = s.ApproverId,
                UserId = userId
            }).ToList();
            return list ?? new List<TrainingBO>();
        }
        public string ViewDocument(string basePath, int trainingId)
        {
            var data = _dbContext.Trainings.FirstOrDefault(x => x.TrainingId == trainingId);
            var userAbrhs = CryptoHelper.Encrypt(data.CreatedBy.ToString());
            var newBasePath = basePath + userAbrhs.Trim() + "\\";
            var fileName = data.Document;
            var finalBasePath = newBasePath + fileName;
            if (!File.Exists(finalBasePath))
                return string.Empty;

            byte[] formInByte = File.ReadAllBytes(finalBasePath);
            var formInBase64String = Convert.ToBase64String(formInByte);

            var fileExtension = fileName.Split('.')[1];
            var link = "";
            link = CommonUtility.GetBase64MimeType(fileExtension) + "," + formInBase64String;
            return link;
        }
        #endregion

        #region News
        public int AddNews(NewsBO news)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(news.UserAbrhs), out userId);

            //check Exist.
            var checkExist = _dbContext.News.Where(x => x.NewsTitle == news.NewsTitle && (x.FromDate == news.FromDate) && (x.TillDate == news.TillDate)).ToList();

            if (checkExist.Any())
            {
                return 2;
            }
            News newsModal = new News();
            newsModal.NewsTitle = news.NewsTitle;
            newsModal.NewsDescription = news.NewsDescription;
            newsModal.FromDate = news.FromDate;
            newsModal.TillDate = news.TillDate;
            newsModal.IsActive = true;
            newsModal.CreatedBy = userId;
            newsModal.IsDeleted = false;
            newsModal.CreatedDate = DateTime.Now;
            newsModal.IsInternal = news.IsInternal;
            if (news.IsInternal == true)
                newsModal.Link = news.ActionId.ToString();
            else
                newsModal.Link = news.Link;
            _dbContext.News.Add(newsModal);
            _dbContext.SaveChanges();
            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.Addnews, userId, 0);
            return 1;
        }

        public List<NewsBO> GetAllNews(string userAbrhs)
        {
            List<NewsBO> NewsList = new List<NewsBO>();
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            if (userId > 0)
            {
                var newsData = _dbContext.News.Where(x => x.IsDeleted == false).ToList();
                if (newsData.Any())
                {
                    foreach (var item in newsData)
                    {
                        NewsBO newsBO = new NewsBO();
                        newsBO.NewsTitle = item.NewsTitle;
                        newsBO.NewsDescription = item.NewsDescription;
                        newsBO.FromDateDisplay = item.FromDate.ToString("dd-MMM-yyyy hh:mm tt");
                        newsBO.TillDateDisplay = item.TillDate.ToString("dd-MMM-yyyy hh:mm tt");
                        newsBO.IsActive = item.IsActive;
                        newsBO.CreatedDate = item.CreatedDate.ToString("dd-MMM-yyyy hh:mm tt");
                        newsBO.NewsId = item.NewsId;
                        NewsList.Add(newsBO);
                    }
                }
                return NewsList;
            }
            return NewsList;
        }

        public int UpdateNews(NewsBO news)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(news.UserAbrhs), out userId);

            //check Exist.
            var checkExist = _dbContext.News.FirstOrDefault(x => x.NewsId == news.NewsId);

            if (checkExist == null)
            {
                return 2;
            }
            checkExist.NewsTitle = news.NewsTitle;
            checkExist.NewsDescription = news.NewsDescription;
            checkExist.FromDate = news.FromDate;
            checkExist.TillDate = news.TillDate;
            checkExist.IsActive = true;
            checkExist.CreatedBy = userId;
            checkExist.IsDeleted = false;
            checkExist.CreatedDate = DateTime.Now;
            checkExist.IsInternal = news.IsInternal;
            if (news.IsInternal == true)
                checkExist.Link = news.ActionId.ToString();
            else
                checkExist.Link = news.Link;
            _dbContext.SaveChanges();

            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.UpdateNews, userId, 0);
            return 1;
        }

        public int ChangesNewsStatus(int newsId, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            //check Exist.
            var checkExist = _dbContext.News.FirstOrDefault(x => x.NewsId == newsId && !x.IsDeleted);

            if (checkExist == null)
            {
                return 2;
            }
            if (checkExist.IsActive)
            {
                checkExist.IsActive = false;
            }
            else
            {
                checkExist.IsActive = true;
            }
            checkExist.ModifiedBy = userId;
            checkExist.ModifiedDate = DateTime.Now;
            _dbContext.SaveChanges();

            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.ChangesNewsStatus, userId, 0);
            return 1;
        }

        public int DeleteNews(int newsId, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            //check Exist.
            var checkExist = _dbContext.News.FirstOrDefault(x => x.NewsId == newsId && !x.IsDeleted);

            if (checkExist == null)
            {
                return 2;
            }
            checkExist.IsDeleted = true;
            checkExist.ModifiedBy = userId;
            checkExist.ModifiedDate = DateTime.Now;
            _dbContext.SaveChanges();

            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.DeleteNew, userId, 0);
            return 1;
        }

        public NewsBO GetNews(int newsId, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            NewsBO newsBO = new NewsBO();
            if (userId > 0)
            {
                var newsData = _dbContext.News.FirstOrDefault(x => x.IsDeleted == false && x.NewsId == newsId);
                if (newsData != null)
                {
                    newsBO.NewsTitle = newsData.NewsTitle;
                    newsBO.NewsDescription = newsData.NewsDescription;
                    newsBO.FromDate = newsData.FromDate;
                    newsBO.TillDate = newsData.TillDate;
                    newsBO.IsInternal = newsData.IsInternal;
                    if (newsData.IsInternal == true)
                    {
                        if (newsData.Link != null)
                        {
                            var menuId = Convert.ToInt32(newsData.Link);
                            var controllerDetail = _dbContext.Menus.FirstOrDefault(x => x.MenuId == menuId);
                            if (controllerDetail != null)
                            {
                                newsBO.ActionId = menuId;
                                newsBO.ControllerId = controllerDetail.ParentMenuId;
                                newsBO.Link = controllerDetail.ControllerName + "/" + controllerDetail.ActionName;
                            }
                        }

                    }
                    else
                    {
                        newsBO.Link = newsData.Link;
                    }

                }
                return newsBO;
            }
            return newsBO;
        }

        #endregion

        #region
        public List<PendingProfileRequests> GetAllProfilePendingRequests(string status)
        {
            var reqUrl = HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + "/";

#if !DEBUG
            reqUrl = (new UriBuilder(reqUrl) { Port = -1 }).ToString();
#endif
            var data = _dbContext.ChangeExtnRequests.Where(x => x.IsActionPerformed == false).ToList();
            if (status == "Verified")
                data = _dbContext.ChangeExtnRequests.Where(x => x.IsActionPerformed == true).ToList();
            var tempPath = ConfigurationManager.AppSettings["TempProfileImageUploadPath"].Replace("\\", "/");
            var imagePath = ConfigurationManager.AppSettings["ProfileImageUploadPath"].Replace("\\", "/");
            var list = data.Select(s => new PendingProfileRequests
            {
                RequestId = s.RequestId,
                NewMobNo = CryptoHelper.Decrypt(s.NewMobileNo),
                NewImage = status == "Verified" && s.IsVerified == true ? reqUrl + imagePath + s.NewImage : reqUrl + tempPath + s.NewImage,
                UserName = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == s.CreatedById).FirstName + " " + _dbContext.UserDetails.FirstOrDefault(x => x.UserId == s.CreatedById).MiddleName + " " + _dbContext.UserDetails.FirstOrDefault(x => x.UserId == s.CreatedById).LastName,
                OldMobNo = CryptoHelper.Decrypt(s.OldMobileNo),//CryptoHelper.Decrypt(_dbContext.UserDetails.FirstOrDefault(x => x.UserId == s.CreatedById).MobileNumber),
                OldImage = reqUrl + imagePath + s.OldImage,
                IsVerified = s.IsVerified,
                Reason = s.Reason

            }).OrderByDescending(s => s.CreatedDate).ToList();
            return list ?? new List<PendingProfileRequests>();

        }
        public int VerifyUserProfile(int requestId, int status, string reason, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var data = _dbContext.ChangeExtnRequests.FirstOrDefault(x => x.RequestId == requestId);
            if (data == null)
            {
                return 2;
            }
            if (data != null)
            {
                if (status == 1)
                {
                    data.IsActionPerformed = true;
                    data.Reason = reason;
                    data.ActionDate = DateTime.Now;
                    data.ActionTakenById = userId;
                }
                if (status == 2)
                {
                    data.IsActionPerformed = true;
                    data.ActionDate = DateTime.Now;
                    data.ActionTakenById = userId;
                    data.IsVerified = true;
                    var userDetail = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == data.CreatedById);
                    if (userDetail != null)
                    {
                        if (!string.IsNullOrEmpty(data.NewMobileNo))
                            userDetail.MobileNumber = data.NewMobileNo;
                        if (!string.IsNullOrEmpty(data.NewImage))
                        {
                            userDetail.ImagePath = data.NewImage;
                            var tempImageBasePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["TempProfileImageUploadPath"] + data.NewImage;
                            var newImageLink = "";

                            if (File.Exists(tempImageBasePath))
                            {

                                byte[] imageInByte = File.ReadAllBytes(tempImageBasePath);

                                var newImageBase64Data = Convert.ToBase64String(imageInByte);

                                var fileExtension = data.NewImage.Split('.')[1];
                                newImageLink = CommonUtility.GetBase64MimeType(fileExtension) + "," + newImageBase64Data;

                                var NewBasePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["ProfileImageUploadPath"] + data.NewImage;
                                byte[] decodedByteArray = Convert.FromBase64String(newImageLink.Split(',')[1]);
                                File.WriteAllBytes(NewBasePath, decodedByteArray);

                                File.Delete(tempImageBasePath);


                            }


                        }
                    }
                }
            }

            _dbContext.SaveChanges();
            _userServices.SaveUserLogs(ActivityMessages.VerifyProfileRequests, userId, 0);
            return 1;
        }

        public int VerifyBulkUserProfile(string requestIds, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            List<int> TagIds = requestIds.Split(',').Select(int.Parse).ToList();
            foreach (var id in TagIds)
            {
                var data = _dbContext.ChangeExtnRequests.FirstOrDefault(x => x.RequestId == id);
                if (data == null)
                {
                    return 2;
                }
                if (data != null)
                {
                    data.IsActionPerformed = true;
                    data.IsVerified = true;
                    data.ActionDate = DateTime.Now;
                    data.ActionTakenById = userId;
                    var userDetail = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == data.CreatedById);
                    if (userDetail != null)
                    {
                        if (!string.IsNullOrEmpty(data.NewMobileNo))
                            userDetail.MobileNumber = data.NewMobileNo;
                        if (!string.IsNullOrEmpty(data.NewImage))
                        {
                            userDetail.ImagePath = data.NewImage;
                            var tempImageBasePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["TempProfileImageUploadPath"] + data.NewImage;
                            var newImageLink = "";

                            if (File.Exists(tempImageBasePath))
                            {

                                byte[] imageInByte = File.ReadAllBytes(tempImageBasePath);

                                var newImageBase64Data = Convert.ToBase64String(imageInByte);

                                var fileExtension = data.NewImage.Split('.')[1];
                                newImageLink = CommonUtility.GetBase64MimeType(fileExtension) + "," + newImageBase64Data;

                                var NewBasePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["ProfileImageUploadPath"] + data.NewImage;
                                byte[] decodedByteArray = Convert.FromBase64String(newImageLink.Split(',')[1]);
                                File.WriteAllBytes(NewBasePath, decodedByteArray);

                                File.Delete(tempImageBasePath);


                            }


                        }
                    }

                }

                _dbContext.SaveChanges();
                _userServices.SaveUserLogs(ActivityMessages.VerifyProfileRequests, userId, 0);
            }

            return 1;
        }

        #endregion

        #region Trainig & Probation Feedback Mail
        public List<CompletionFeedbackBO> GetEmployeeListForFeedBackMail(string emailFromDate, string emailTillDate)
        {
            var emailFDate = DateTime.ParseExact(emailFromDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            var emailTDate = DateTime.ParseExact(emailTillDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);

            var empList = _dbContext.Proc_GetProbationAndTrainingCompletionData(emailFDate, emailTDate).ToList();

            var response = empList.Select(e => new CompletionFeedbackBO
            {
                EmployeeName = e.EmployeeName,
                EmployeeEmailId = e.EmployeeEmailId,
                EmployeeCode = e.EmployeeCode,
                RMFullName = e.RMFullName,
                CompletionDate = e.CompletionDate.ToString("dd MMM yyyy", CultureInfo.InvariantCulture),
                JoiningDate = e.JoiningDate,
                CompletionType = e.CompletionType,
                Summary = e.Summary,
                EmailDate = e.EmailDate.HasValue ? e.EmailDate.Value.ToString("dd MMM yyyy", CultureInfo.InvariantCulture) : "NA",
            }).ToList();

            return response ?? new List<CompletionFeedbackBO>();
        }
        public int SendProbationAndTrainingCompletionEmail(string emailFromDate, string emailTillDate, string fillByDate, string emailIds)
        {
            var reqUrl = HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + "/";
#if !DEBUG
            reqUrl = (new UriBuilder(reqUrl) { Port = -1 }).ToString();
#endif
            var baseImagePath = reqUrl + ConfigurationManager.AppSettings["ImagePath"];

            string[] empEmailId = emailIds.Split(',');
            var emailFDate = DateTime.ParseExact(emailFromDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            var emailTDate = DateTime.ParseExact(emailTillDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);

            var empData = _dbContext.Proc_GetProbationAndTrainingCompletionData(emailFDate, emailTDate).ToList();
            var result = empData.Where(t => empEmailId.Contains(t.EmployeeEmailId)).ToList();
            var responseDate = DateTime.ParseExact(fillByDate, "MM/dd/yyyy", CultureInfo.InvariantCulture).ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture);  //DateTime.Now.AddDays(7).ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture);


            if (result.Count > 0)
            {
                var allRmDatas = result.Select(row => new
                {
                    RMId = row.RMId,
                    RMEmailId = row.RMEmailId,
                    RMFirstName = row.RMFirstName,
                    RMFullName = row.RMFullName,
                    CcHREmailIds = row.CcHREmailIds,
                }).Distinct();

                var probationSubject = "Probation Completion Feeback";
                var trainingSubject = "Training Completion Feeback";

                var probationTemplate = _dbContext.EmailTemplates.FirstOrDefault(t => t.TemplateName == EmailTemplates.ProbationCompletion);
                var trainingTemplate = _dbContext.EmailTemplates.FirstOrDefault(t => t.TemplateName == EmailTemplates.TrainingCompletion);

                var imagePath = baseImagePath + "ProbationFeedback.jpg";

                foreach (var t in allRmDatas)
                {
                    var toRMEmail = CryptoHelper.Decrypt(t.RMEmailId);
                    var emailIdList = t.CcHREmailIds.Split(',').Select(x => CryptoHelper.Decrypt(x.Trim())).ToList();
                    var cCHrEmailId = String.Join(";", emailIdList);
                    var rmFirstName = t.RMFirstName;
                    var rmFullName = t.RMFullName;
                    var rmsData = result.Where(r => r.RMId == t.RMId);

                    var probationGroupedData = rmsData.Where(r => r.CompletionType.ToLower() == "probation").ToList();
                    var probation = probationGroupedData.ToDataTable();

                    var trainingGroupedData = rmsData.Where(r => r.CompletionType.ToLower() == "training").ToList();
                    var training = trainingGroupedData.ToDataTable();

                    if (probation.Rows.Count > 0)
                    {
                        if (probationTemplate == null || string.IsNullOrEmpty(imagePath))
                            return 0;

                        var columns = new Dictionary<string, string>();
                        var body = string.Empty;

                        //Remove
                        probation.Columns.Remove("UserId");
                        probation.Columns.Remove("RMId");
                        probation.Columns.Remove("RMFirstName");
                        probation.Columns.Remove("RMEmailId");
                        probation.Columns.Remove("CcHREmailIds");
                        probation.Columns.Remove("CompletionDate");
                        probation.Columns.Remove("EmailDate");
                        probation.Columns.Remove("RMFullName");
                        probation.Columns.Remove("CompletionType");
                        probation.Columns.Remove("EmployeeEmailId");
                        probation.Columns.Remove("EmployeeCode");

                        //Add
                        columns.Add("EmployeeName", "Employee Name");
                        columns.Add("JoiningDate", "Joining Date");
                        columns.Add("Summary", "Summary");
                      
                        var htmlResult = probation.ToHtmlTable(true, columns);
                        body = probationTemplate.Template.Replace("[Link]", imagePath)
                            .Replace("[Manager]", rmFirstName)
                            .Replace("[Data]", htmlResult)
                            .Replace("[ResponseDate]", responseDate);

                        Utilities.EmailHelper.SendEmailWithAttachment(probationSubject, body, true, true, toRMEmail, cCHrEmailId, null, null);
                    }

                    if (training.Rows.Count > 0)
                    {
                        if (trainingTemplate == null || string.IsNullOrEmpty(imagePath)) 
                            return 0;

                        var columns = new Dictionary<string, string>();
                        var body = string.Empty;

                        //Remove
                        training.Columns.Remove("UserId");
                        training.Columns.Remove("RMId");
                        training.Columns.Remove("RMFirstName");
                        training.Columns.Remove("RMEmailId");
                        training.Columns.Remove("CcHREmailIds");
                        training.Columns.Remove("CompletionDate");
                        training.Columns.Remove("EmailDate");
                        training.Columns.Remove("RMFullName");
                        training.Columns.Remove("CompletionType");
                        training.Columns.Remove("EmployeeEmailId");
                        training.Columns.Remove("EmployeeCode");

                        //Add
                        columns.Add("EmployeeName", "Employee Name");
                        columns.Add("JoiningDate", "Joining Date");
                        columns.Add("Summary", "Summary");

                        var htmlResult = training.ToHtmlTable(true, columns);
                        body = trainingTemplate.Template.Replace("[Link]", imagePath)
                            .Replace("[Manager]", rmFirstName)
                            .Replace("[Data]", htmlResult)
                            .Replace("[ResponseDate]", responseDate);

                        Utilities.EmailHelper.SendEmailWithAttachment(trainingSubject, body, true, true, toRMEmail, cCHrEmailId, null, null);
                    }
                }

                return 1;
            }
            return 0;
        }

        #endregion


        #region Health Insurance Card
        public bool UploadHealthInsuranceCard(EmployeeHealthInsurance employeeHealthInsurance)
        {
            if (employeeHealthInsurance == null || string.IsNullOrEmpty(employeeHealthInsurance.FileName) || string.IsNullOrEmpty(employeeHealthInsurance.FileData))
            {
                return false;
            }

            //var creartedByUserName = CryptoHelper.Decrypt(employeeHealthInsurance.CreatedByAbrs);
            var creartedBy = _dbContext.vwActiveUsers.Single(x => x.UserName == employeeHealthInsurance.CreatedByAbrs).UserId;
            SaveHealthInsuranceCardPdf(employeeHealthInsurance.FileName, employeeHealthInsurance.FileData);
            MarkExsisitingRecordsInactive(employeeHealthInsurance.UserID);

            var usersHealthInsurance = new UsersHealthInsurance
            {
                User = _dbContext.Users.Single(x => x.UserId == employeeHealthInsurance.UserID),
                UserId = employeeHealthInsurance.UserID,
                InsurancePdfPath = employeeHealthInsurance.FileName,
                IsActive = true,
                CreatedDate = DateTime.Now,
                CreatedBy = creartedBy
            };

            _dbContext.UsersHealthInsurances.Add(usersHealthInsurance);
            _dbContext.SaveChanges();
            return true;
        }


        public IList<EmployeeHealthInsurance> GetEmployeesHealthInsuranceDetails()
        {
            var activeUserHealthInsurances = _dbContext.UsersHealthInsurances.ToList().Where(x => IsActiveRecord(x.IsActive));

            return activeUserHealthInsurances.Select(x => new EmployeeHealthInsurance
            {
                UserID = x.UserId,
                EmployeeCode = _dbContext.vwActiveUsers.Single(y => y.UserId == x.UserId).EmployeeCode,
                EmployeeName = _dbContext.vwActiveUsers.Single(y => y.UserId == x.UserId).EmployeeName,
                FileName = x.InsurancePdfPath,
                CreatedDate = x.CreatedDate
            }).ToList();
        }


        private void MarkExsisitingRecordsInactive(int userId)
        {
            var activeUserHealthInsurances = _dbContext.UsersHealthInsurances.ToList().Where(x => IsActiveRecord(x.IsActive));

            var exsitingRecords = activeUserHealthInsurances.Where(x => x.UserId == userId);

            if (exsitingRecords.Any())
            {
                foreach (var record in exsitingRecords)
                {
                    record.IsActive = false;
                }
            }
        }

        private static void SaveHealthInsuranceCardPdf(string fileName, string fileData)
        {
            var basePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["HealthInsurance"] + "\\";
            if (!Directory.Exists(basePath))
            {
                Directory.CreateDirectory(basePath);
            }

            byte[] decodedByteArray = Convert.FromBase64String(fileData.Split(',')[1]);

            var filePath = basePath + fileName;
            File.WriteAllBytes(filePath, decodedByteArray);
        }

        private static bool IsActiveRecord(bool? isActive)
        {
            return isActive.HasValue ? isActive.Value : false;

        }

        #endregion
    }
}