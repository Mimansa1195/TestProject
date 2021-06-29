using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MIS.Services.Contracts;
using MIS.Model;
using MIS.BO;
using MIS.Utilities;
using System.IO;
using System.Configuration;
using System.Globalization;

namespace MIS.Services.Implementations
{
    public class FeedbackServices : IFeedbackServices
    {
        private readonly IUserServices _userServices;

        public FeedbackServices(IUserServices userServices)
        {
            _userServices = userServices;
        }

        #region Private member variables

        public readonly MISEntities _dbContext = new MISEntities();

        #endregion

        public List<UserFeedbackBO> FetchAllFeedbacks()
        {
            var result = new List<UserFeedbackBO>();

            var data = from f in _dbContext.UserFeedbacks
                       join u in _dbContext.UserDetails on f.CreatedBy equals u.UserId
                       select new { f.Remarks, f.FeedbackId, f.IsAcknowledged, f.CreatedDate, EmployeeName = u.FirstName + " " + u.LastName, };
            foreach(var temp in data.ToList())
            {
                result.Add(new UserFeedbackBO
                {
                    FeedbackId = temp.FeedbackId,
                    EmployeeName = temp.EmployeeName,
                    Remarks = temp.Remarks,
                    IsAcknowledged = temp.IsAcknowledged,
                    CreatedDate = temp.CreatedDate,
                    DisplayCreatedDate = temp.CreatedDate.ToString("dd-MMM-yyyy"),
                });
            }
            return result.OrderBy(x => x.CreatedDate).ToList();
        }

        public bool SubmitFeedback(string remarks, string userAbrhs)
        {
            if(!string.IsNullOrEmpty(userAbrhs) && !string.IsNullOrEmpty(remarks))
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

                _dbContext.UserFeedbacks.Add(new Model.UserFeedback
                {
                    Remarks = remarks,
                    CreatedBy = userId,
                    CreatedDate = DateTime.Now,
                });
                var result = _dbContext.SaveChanges();

                if(result > 0)
                {
                    var userDetail = _dbContext.vwActiveUsers.FirstOrDefault(f => f.UserId == userId);
                    var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == EmailTemplates.UserFeedback && f.IsActive && !f.IsDeleted);

                    if (userDetail != null && emailTemplate != null)
                    {
                        var body = emailTemplate.Template;
                        var msg = string.Format("There is a feedback submitted by {0} on Gemini MIS portal."+ System.Environment.NewLine, userDetail.EmployeeName);
                        msg = msg + "<p><strong>Submitted On: </strong>" + DateTime.Now.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture)+ "</p>";
                        body = body.Replace("[HEADING]", "Feedback")
                                   .Replace("[Name]", "User")
                                   .Replace("[MESSAGE]", msg)
                                   .Replace("[DATA]", remarks);

                        var emailId = ConfigurationManager.AppSettings["FeedbackMail"];
                        EmailHelper.SendEmailWithDefaultParameter("Feedback", body, false, true, emailId, "", "", "");
                    }
                }
                return true;
            }
            return false;
        }

        public bool AcknowledgeFeedback(int feedbackId, string userAbrhs)
        {
            if (!string.IsNullOrEmpty(userAbrhs) && feedbackId > 0)
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

                var data = _dbContext.UserFeedbacks.FirstOrDefault(x => x.FeedbackId == feedbackId);
                data.IsAcknowledged = true;
                data.AcknowledgedBy = userId;                
                _dbContext.SaveChanges();
                return true;
            }
            return false;
        }

        public UserFeedbackBO FetchFeedbackById(int feedbackId)
        {            
            if(feedbackId > 0)
            {
                var data = from f in _dbContext.UserFeedbacks
                           where f.FeedbackId == feedbackId
                           join u in _dbContext.UserDetails on f.CreatedBy equals u.UserId
                           join ud in _dbContext.UserDetails on f.AcknowledgedBy equals ud.UserId into t
                           from temp in t.DefaultIfEmpty()
                           select new
                           {
                               f.Remarks,
                               f.FeedbackId,
                               f.IsAcknowledged,
                               f.CreatedDate,
                               EmployeeName = u.FirstName + " " + u.LastName,
                               AcknowledgedBy = (temp == null ? String.Empty : temp.FirstName + " " + temp.LastName)
                           };
                foreach (var temp in data.ToList())
                {
                    return new UserFeedbackBO
                    {
                        FeedbackId = temp.FeedbackId,
                        EmployeeName = temp.EmployeeName,
                        Remarks = temp.Remarks,
                        IsAcknowledged = temp.IsAcknowledged,
                        CreatedDate = temp.CreatedDate,
                        DisplayCreatedDate = temp.CreatedDate.ToString("dd-MMM-yyyy"),
                        AcknowledgedBy = string.IsNullOrEmpty(temp.AcknowledgedBy) ? "NA" : temp.AcknowledgedBy,
                    };
                }
            }
            return null;
        }

        public List<UserFeedbackBO> FetchAllFeedbackByUserId(string userAbrhs)
        {
            if (!string.IsNullOrEmpty(userAbrhs))
            {
                var result = new List<UserFeedbackBO>();
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);                

                var data = from f in _dbContext.UserFeedbacks
                           where f.CreatedBy == userId
                           join u in _dbContext.UserDetails on f.CreatedBy equals u.UserId
                           join ud in _dbContext.UserDetails on f.AcknowledgedBy equals ud.UserId into t
                           from temp in t.DefaultIfEmpty()
                           select new
                           {
                               f.Remarks,
                               f.FeedbackId,
                               f.IsAcknowledged,
                               f.CreatedDate,
                               EmployeeName = u.FirstName + " " + u.LastName,
                               AcknowledgedBy = (temp == null ? String.Empty : temp.FirstName + " " + temp.LastName)
                           };
                foreach (var temp in data.ToList())
                {
                    result.Add(new UserFeedbackBO
                    {
                        FeedbackId = temp.FeedbackId,
                        EmployeeName = temp.EmployeeName,
                        Remarks = temp.Remarks,
                        IsAcknowledged = temp.IsAcknowledged,
                        CreatedDate = temp.CreatedDate,
                        DisplayCreatedDate = temp.CreatedDate.ToString("dd-MMM-yyyy"),
                        AcknowledgedBy = string.IsNullOrEmpty(temp.AcknowledgedBy) ? "NA" : temp.AcknowledgedBy,
                    });
                }
                return result.OrderBy(x => x.CreatedDate).ToList();
            }
            return null;
        }
    }
}
