using MIS.BO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MIS.Services.Contracts
{
    public interface IHRPortalServices
    {
        #region Referral
        int AddReferral(ReferralBO refer);

        List<ReferralBO> GetReferral();

        List<ReferralBO> GetAllReferral();

        int AddRefereeByUser(int referralId, string refereeName, string relation, string resume, string base64FormData, string userAbrhs);

        List<ReferralBO> GetAllRequestedReferral(int referralId);

        string FetchAllRefereeDetails(int referralDetailId, int referredById);

        bool ChangeReferralStatus(int referralId, int status, string userAbrhs);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="referralId"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        ReferralBO ViewReferralDetails(int referralId, string userAbrhs);

        int UpdateReferrals(ReferralBO refer);

        int ForwardReferrals(int detailId, string resume, int referredById, string empIds, string message, string appLinkUrl, string userAbrhs);

        int MarkRelevantForReferral(string ActionData, string Reason);

        int MarkIrrelevantForReferral(string ActionData, string Reason);

        int SendReminderForReferral(int reviewId, int loginUserId);

        string ViewResume(string basePath, int detailId, int referredById);

        int ForwardAllReferrals(int referralId, string empIds, string message, string appLinkUrl, string userAbrhs);

        #endregion

        #region Training
        int AddTrainings(TrainingBO data);

        List<TrainingBO> GetAllTrainings();

        bool ChangeTrainingStatus(int trainingId, int status, string userAbrhs);

        TrainingBO ViewTrainingDetails(int trainingId, string userAbrhs);

        int UpdateTrainingDetails(TrainingBO data);

        List<TrainingBO> GetTrainings(string userAbrhs);

        int ApplyForTrainings(int trainingId, string userAbrhs);

        List<TrainingBO> ViewAppliedTrainingDetails(int trainingId, string userAbrhs);

        int TakeActionOnTrainingRequest(int trainingDetailId, int statusId, string remarks, string userAbrhs);

        List<TrainingBO> GetAllNomineesDetails(int trainingId, string userAbrhs);

        List<TrainingBO> GetPendingTrainingRequests(string userAbrhs);

        List<TrainingBO> GetReviwedTrainingRequests(string userAbrhs);

        string ViewDocument(string basePath, int trainingId);
        #endregion
        #region News
        int AddNews(NewsBO news);

        List<NewsBO> GetAllNews(string userAbrhs);

        int UpdateNews(NewsBO news);

        int ChangesNewsStatus(int newsId, string userAbrhs);

        int DeleteNews(int newsId, string userAbrhs);

        NewsBO GetNews(int newsId, string userAbrhs);

        #endregion
        #region
        List<PendingProfileRequests> GetAllProfilePendingRequests(string status);
        int VerifyUserProfile(int requestId, int status, string reason, string userAbrhs);

        int VerifyBulkUserProfile(string requestIds, string userAbrhs);
        #endregion

        #region Trainig & Probation Feedback Mail
        List<CompletionFeedbackBO> GetEmployeeListForFeedBackMail(string emailFromDate, string emailTillDate);
        int SendProbationAndTrainingCompletionEmail(string emailFromDate, string emailTillDate, string fillByDate, string emailIds);
        #endregion

        #region Health Insurance Card

        bool UploadHealthInsuranceCard(EmployeeHealthInsurance employeeHealthInsurance);

        IList<EmployeeHealthInsurance> GetEmployeesHealthInsuranceDetails();

        #endregion
    }
}
