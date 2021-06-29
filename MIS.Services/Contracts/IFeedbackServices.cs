using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MIS.BO;

namespace MIS.Services.Contracts
{
    public interface IFeedbackServices
    {
        List<UserFeedbackBO> FetchAllFeedbacks();

        bool SubmitFeedback(string remarks, string userAbrhs);

        bool AcknowledgeFeedback(int feedbackId, string userAbrhs);

        UserFeedbackBO FetchFeedbackById(int feedbackId);

        List<UserFeedbackBO> FetchAllFeedbackByUserId(string userAbrhs);
    }
}
