using MIS.BO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MIS.Services.Contracts
{
    public interface IReportServices
    {
        List<ClubbedReport> GetClubbedReport(string fromDate, string endDate, string empAbrhs, string reportToAbrhs, string departmentIds, string teamIds, string locationIds, string status);
        List<LnsaReport> GetLnsaReport(string fromDate, string endDate, string empAbrhs, string reportToAbrhs, string departmentIds, string locationIds);

        List<LwpReport> GetLwpReport(string fromDate, string endDate, string empAbrhs, string reportToAbrhs, string departmentIds, string locationIds);

        List<CompOffReport> GetCompOffReport(string fromDate, string endDate, string empAbrhs, string reportToAbrhs, string departmentIds, string locationIds);

        List<EmployeeReport> GetLnsaCompOffReport(string fromDate, string endDate, string reportType);

        List<ReportDetail> GetCompOffReportDetailsByUserId(string fromDate, string tillDate, string empAbrhs, int requestType);

        List<ReportDetail> GetLnsaReportDetailsByUserId(string fromDate, string tillDate, string empAbrhs, int requestType);

        List<ReportDetail> GetLwpReportDetailsByUserId(string fromDate, string tillDate, string empAbrhs, int requestType);

        List<VisitorReportDetail> GetVisitorDetails(string fromDate, string endDate, string userAbrhs);

        List<TempCardReport> GetTempCardDetails(string fromDate, string tillDate, string userAbrhs);

        TempCardReport GetTempCardDetailsForEdit(int issueId);

        int AddCardIssueDetail(TempCardReport input, string userAbrhs);

        int ChangeStatusOfIssuedCard(int issueId, string userAbrhs);

        int EditAccessCardDetails(TempCardReport input, string userAbrhs);

        List<SkillsDetailBO> GetReportEmployeeSkills(SkillsDetailBO skillsDetailBO);

        List<UserActivityLogging> GetUserActivity(DateTime fromDate, DateTime endDate, string empAbrhs, string userAbrhs);

        List<MealOfTheDayBO> GetMealMenusData(string fromDate, string endDate, string userAbrhs);

        List<MealFeedbackReportBO> GetMealFeedbackData(string fromDate, string endDate, string userAbrhs);

        List<AttendanceSummary> GetLeaveReport(string fromDate, string endDate, string empAbrhs, string reportToAbrhs, string departmentIds, string locationIds);

        List<UserManagementDetailBO> GetGoalsForReports(int goalCycleId, int statusId);
    }
}
