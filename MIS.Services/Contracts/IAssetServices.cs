using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MIS.BO;

namespace MIS.Services.Contracts
{
    public interface IAssetServices
    {
        string GetUserCommentForDongleAllocation(string userAbrhs);

        bool GetConflictStatusOfDongleAllocationPeriod(DateTime issueFromDate, DateTime returnDueDate, string userAbrhs);

        List<AssetDataBO> GetAssetDetailsForReportingManager(int statusId, string userAbrhs);

        List<AssetDataBO> GetAssetDetailsForITDepartment(int statusId);

        DongleDetailBO GetAssetDetailOnBasisOfAssetTag(string assetTag);

        List<string> GetAvailableAssetTag();

        DongleReturnInfoBO GetAssetDetailOnBasisOfRequestId(long requestId);

        List<AssetDataBO> GetAllAssetRequest(string userAbrhs);

        List<AssetCountBO> GetAllAssetCountData();

        List<AssetCountBO> GetAssetCountDataByManagerId(string userAbrhs);

        bool CreateAssetRequest(string reason, DateTime issueDate, DateTime returnDate, string userAbrhs);

        bool TakeActionOnAssetRequest(int requestId, int statusId, string userAbrhs);

        bool AllocateAsset(long requestId, long assetDetailId, string userAbrhs);

        bool ReturnAsset(long transactionId, DateTime returnDate, string userAbrhs);

        int ReturnAssetByUser(long requestId, DateTime returnDate, string userAbrhs);

        //string AssignDongle(string userAbrhs, int requestId, string serialNumber, string simNumber, string otherDetails, string comments);

        List<AssetDetailBO> GetAllAssets();

        bool AddAssetDetails(AssetDetailBO assetDetails);

        bool DeleteAssetDetails(long assetDetailId, string userAbrhs);

        AssetDetailBO GetAssetDetailsById(long assetDetailId);

        bool UpdateAssetDetails(AssetDetailBO assetDetails);

        #region New Implementation
        int AddUpdateAssetsDetail(AssetDetailBO assetDetails, int loginUserId);

        List<AssetDetailBO> GetAssetsBrand();

        List<BaseDropDown> GetAllAssetTypes();

        List<AssetDetailBO> GetAllAssetsDetail();

        int AddUpdateUsersAssetsDetail(UserAssetDetail assetD, int loginUserId);

        List<UserAssetRequest> GetAllUsersAssetsDetail(string actionCode, int loginUserId);

        List<UserAssetRequest> GetUsersActiveAssets(string userAbrhs);

        //List<UserAssetRequest> GetAllUsersInActiveAssetsDetail();

        List<AssetsBO> GetAllUnAllocatedAssets(string assetTypeIds);

        List<UserAssetRequest> GetAllEmployeesForAssetAllocation();

        List<UserAssetDetail> GetAllUnAllocatedAssetsSerialNo();

        int CheckUsersAssetsDetail(int userId, long assetId);

        int AllocateExcelData(List<UserAssetRequest> userDataList, string userAbrhs);

        List<UserAssetRequest> GetAssetsByUserAbrhs(string userAbrhs, string actionCode, int loginUserId);

        string GetSampleDocumentUrl(string sampleType);

      //  List<UserAssetRequest> GetPendingForDeAllocationAssetsRequest();


        #endregion


    }
}
