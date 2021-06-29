using MIS.BO;
using System.Collections.Generic;

namespace MIS.Services.Contracts
{
    public interface IPimcoServices
    {
        ResponseBO<List<GetGeminiUsersBo>> GetGeminiUsers();

        ResponseBO<List<GetPimcoUsersBo>> GetPimcoUsers(bool isExpiration);

        List<PimcoOrganizationStructureBO> FetchPimcoOrganizationStructure(int parentId);

        ResponseBO<List<PimcoOrgData>> PimcoOrgData();

        ResponseBO<List<GeminiUserProfileData>> GeminiUserProfileData();

        ResponseBO<List<GeminiUsersForPimco>> AllGeminiUsersForPimco();
    }
}
