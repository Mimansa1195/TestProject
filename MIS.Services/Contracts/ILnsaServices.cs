using System;
using MIS.BO;
using System.Collections.Generic;

namespace MIS.Services.Contracts
{
    public interface ILnsaServices
    {
        /// <summary>
        /// Get Conflict Status Of Lnsa Period
        /// </summary>
        /// <param name="fromDate"></param>
        /// <param name="tillDate"></param>
        /// <param name="userId"></param>
        /// <returns>1- exists, 0 - does not exist</returns>
        bool GetConflictStatusOfLnsaPeriod(DateTime fromDate, DateTime tillDate, string userAbrhs);

        /// <summary>
        /// Get All Lnsa Request
        /// </summary>
        /// <param name="userId"></param>
        /// <returns>List LnsaDataBO</returns>
        List<LnsaDataBO> GetAllLnsaRequest(string userAbrhs);

        /// <summary>
        /// Get All Pending Lnsa Request
        /// </summary>
        /// <param name="userId"></param>
        /// <returns>List LnsaDataBO</returns>
        List<LnsaDataBO> GetAllPendingLnsaRequest(string userAbrhs);

        /// <summary>
        /// Get All Approved Lnsa Request
        /// </summary>
        /// <param name="fromDate"></param>
        /// <param name="tillDate"></param>
        /// <param name="userId"></param>
        /// <returns>List LnsaDataBO</returns>
        List<LnsaDataBO> GetAllApprovedLnsaRequest(DateTime fromDate, DateTime tillDate, string userAbrhs);

        /// <summary>
        /// Get 25 Approved LNSA
        /// </summary>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        List<LnsaDataBO> GetLastNApprovedLnsaRequest(string userAbrhs, int noOfRecords);

        /// <summary>
        /// Insert Lnsa Request
        /// </summary>
        /// <param name="fromDate"></param>
        /// <param name="tillDate"></param>
        /// <param name="reason"></param>
        /// <param name="userId"></param>
        /// <returns>1 - success, 0 - failure</returns>
        bool InsertLnsaRequest(DateTime fromDate, DateTime tillDate, string reason, string userAbrhs);

        /// <summary>
        /// Take Action On Lnsa Request
        /// </summary>
        /// <param name="requestId"></param>
        /// <param name="status"></param>
        /// <param name="remarks"></param>
        /// <param name="userId"></param>
        /// <returns>1 - success, 0 - failure</returns>
        bool TakeActionOnLnsaRequest(int lnsaRequestId, int status, string remarks, string userAbrhs);

        int ApplyLnsaShift(string userAbrhs, string dateIds, string reason);

        List<LnsaShiftBO> GetAllLnsaShiftRequest(string userAbrhs);

        List<LnsaShiftBO> GetAllLnsaShiftReviewRequest(string userAbrhs);

        List<LnsaDateBO> getDateToCancelLnsaRequest(long lnsaRequestId);
        
        List<LnsaDateBO> GetDateLnsaRequest(long lnsaRequestId);

        int CancelAllLnsaRequest(int lnsaRequestId, string status, string action, string userAbrhs);
        
        int CancelLnsaRequest(string status, string action, string userAbrhs, int lnsaRequestDetailId);

        int RejectLnsaRequest(string status, string action, string remarks, string userAbrhs, int lnsaRequestDetailId);

        int RejectAllLnsaRequest(int lnsaRequestId, string status, string action, string remarks, string userAbrhs);

        int ApproveLnsaShiftRequest(int lnsaRequestId, string status, string action, string remarks, string userAbrhs);

       string BulkApproveLnsaRequest(string lnsaRequestIds, string remarks, int loginUserId);

        ShiftMappingCalenderBO GetShiftMappingDetails(DateTime startDate, DateTime endDate,bool IsPreviousMonthDate, string userAbrhs);

       
    }
}