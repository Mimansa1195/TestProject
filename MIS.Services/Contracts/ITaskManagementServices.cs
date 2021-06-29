using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MIS.BO;

namespace MIS.Services.Contracts
{
    public interface ITaskManagementServices
    {
        List<CommonEntitiesBO> ListAllTaskTeam();

        string FetchTaskTeamByTeamId(long taskTeamId);

        List<CommonEntitiesBO> ListAllTaskType();

        string FetchTaskTypeByTypeId(long taskTypeId);

        List<CommonEntitiesBO> ListAllTaskSubDetail1();

        string FetchTaskSubDetail1ById(long taskSubDetail1Id);

        List<CommonEntitiesBO> ListAllTaskSubDetail2();

        string FetchTaskSubDetail2ById(long taskSubDetail2Id);

        List<long> ListAllMappedTypeTeam(int taskTeamId);

        List<long> ListMappedTypeToTeam(long taskTeamId);

        int AddNewTaskTeam(string taskTeamName, string userAbrhs);

        int AddNewTaskType(string taskTypeName, string userAbrhs);

        int AddNewTaskSubDetail1(string taskSubDetail1Name, string userAbrhs);

        int AddNewTaskSubDetail2(string taskSubDetail2Name, string userAbrhs);

        int UpdateTaskTeamDetails(long taskTeamId, string taskTeamName, string userAbrhs);

        int UpdateTaskTypeDetails(long taskTypeId, string taskTypeName, string userAbrhs);

        int UpdateTaskSubDetail1(long taskSubDetail1Id, string taskSubDetail1Name, string userAbrhs);

        int UpdateTaskSubDetail2(long taskSubDetail2Id, string taskSubDetail2Name, string userAbrhs);

        bool DeleteTaskTeam(long taskTeamId, string userAbrhs);

        bool DeleteTaskType(long taskTypeId, string userAbrhs);

        bool DeleteTaskSubDetail1(long taskSubDetail1Id, string userAbrhs);

        bool DeleteTaskSubDetail2(long taskSubDetail2Id, string userAbrhs);
    }
}
