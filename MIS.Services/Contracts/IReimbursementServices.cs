using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MIS.BO;

namespace MIS.Services.Contracts
{
    public interface IReimbursementServices
    {
        List<ReimbursementTypeBO> GetReimbursementType();

        List<ReimbursementTypeBO> GetReimbursementCategory(int typeId);

        ReimbusrementResponse DraftReimbursementDetails(AddReimbursementBO obj, string userAbrhs);

        List<BaseDropDown> GetReimbursementMonthYearToAddNewRequest(int typeId, int loginUserId);

        List<ReimbursementListBO> GetReimbursementListToView(int reimursementTypeId, int year, string userAbrhs);

        AddReimbursementBO GetReimbursementFormData(string reimbursementRequestAbrhs, string userAbrhs);

        int CancelReimbursementRequest(string reimbursementRequestAbrhs, string userAbrhs);

        ReimbusrementResponse SubmitReimbursementForm(AddReimbursementBO obj, string userAbrhs);

        List<ReimbursementListBO> GetReimbursementListToReview(int reimursementTypeId, int year,int loginUserId, string userAbrhs);

        int TakeActionOnReimbursementRequest(ReimbursementActionData obj, int loginUserId);

        ReimbursementDropDown GetReimbursementMonthYearToViewAndApprove();

        List<ReimbursementStatusHistory> GetReimbusrementStatusHistory(int reimbursementRequestId);

        List<EmployeeBO> GetAllEmployeesForReimbursement();

        
    }
}
