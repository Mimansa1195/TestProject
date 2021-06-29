using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MIS.Model;
using MIS.BO;

namespace MIS.Services.Contracts
{
    public interface ITeamManagementServices
    {
 #region team management

        int AddUpdateTeamDetails(TeamInformationBO teamInformation);

        List<TeamBO> ListAllTeams();

        List<TeamEmailTypeMappingTrn> FetchTeamEmailTypeMapping(string teamAbrhs);

        TeamBO FetchTeamByTeamId(string teamAbrhs);

        List<WeekTypeBO> ListAllWeekType();

        //int AddNewTeam(TeamBO team);

        //int UpdateTeamDetails(TeamBO team);

        int DeleteTeam(string teamAbrhs, string userAbrhs); //1: success, 2: user is mapped to team, 3: failure

 #endregion

 #region user team mapping


        List<TeamNameListBO> TeamsListforMapping();
        
        List<TeamNameListByDeptIdBO> TeamsListforMappingByDeptId(string DeptAbrhs);

        List<UserDetailForUserTeamMappingBO> ListMappedUserToTeam(string teamAbrhs);

        ReturnTeamUserMappingBO InsertNewUserTeamMapping(ManageUserTeamMappingBO ManageUserTeamBO);

        bool DeleteUserTeamMapping(int userId, long teamId);

 #endregion

 #region shift management

        List<ListAllShiftBO> ListAllShift();

        ShiftMasterBO ListShiftByShiftId(long shiftId);

        int AddNewShift(BO.ShiftMaster shift);

        bool DeleteShift(string ShiftAbrhs, string UserAbrhs);

        int UpdateShiftDetails(BO.ShiftMaster shift);

 #endregion

#region shift management

        List<UsersListBO> MappedUsersOfTeam(string TeamAbrhs);

        List<ShiftsListBO> GetShiftsList();

        List<ShiftsUserMapList> GetShiftUserMappingList(string UserAbrhs);

        List<ShiftsUserMapList> SearchShiftUserMappingList(ShiftUserMappingFilterBO filter);

        List<long> GetDateIdList(string fromDate, string ToDate);

        bool DeleteShiftUserMapping(int MappingId, string UserAbrhs);

        int AddUpdateShiftUserMapping(List<UserShiftMappingList> ShiftUserList);

        List<DepartmentMapList> DeptListforMapping();

        #endregion

    }
}
