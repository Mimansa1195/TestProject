using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MIS.BO;

namespace MIS.Services.Contracts
{
    public interface IAccessCardServices
    {
        List<AccessCardDataBO> GetAllAccessCards();

        int ChangeAccessCardState(int accessCardId, int state, string userAbrhs);

        int AddAccessCard(string cardNo, bool isPimcoCard, bool isTemporaryCard, string userAbrhs);

        List<UserAccessCardDataBO> GetAllUserCardMapping();
        List<UserUnMappedCardDataBO> GetAllUserCardUnMappedHistory();

        List<EmployeeBO> GetAllUnmappedUser();

        List<EmployeeBO> GetAllUnmappedStaff();

        List<CommonEntitiesBO> GetAllUnmappedAccessCard();
      

        UserAccessCardMappingBO GetUserCardMappingInfoById(int userCardMappingId);

        int DeleteUserCardMapping(int userCardMappingId, string userAbrhs, DateTime aasignedTill);

        bool FinaliseUserCardMapping(int userCardMappingId, string userAbrhs);

        AccessCardMappingResponse AddUserAccessCardMapping(int accessCardId, string employeeAbrhs, bool isPimcoUserCardMapping, string userAbrhs, bool isStaff,DateTime fromDate);

        bool UpdateUserAccessCardMapping(int userCardMappingId, int accessCardId, bool isPimcoUserCardMapping, string userAbrhs, DateTime assignedFrom);

        string GetNextWorkingDate();
    }
}
