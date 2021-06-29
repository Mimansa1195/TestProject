using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MIS.Services.Contracts
{
    public interface IProjectManagementServices
    {
        #region Gemini Project verticals

        List<BO.GeminiProjectVerticalInfo> ListActiveProjectVerticals(string userAbrhs);

        BO.GeminiProjectVertical FetchSelectedVerticalInfo(int verticalId);

        List<BO.UserDetail> ListActiveUsers(string userAbrhs);

        string FetchRoleforCurrentUser(string userAbrhs);

        List<BO.GeminiProjectVertical> ListActiveVerticals(string userAbrhs);

        List<BO.GeminiProjectIndustryType> ListActiveProjectIndustryType(string userAbrhs);

        List<BO.GeminiProjectStatus> ListActiveProjectStatus(string userAbrhs);

        List<BO.GeminiProject> ListProjects(long verticalId, long parentProjectId, string userAbrhs);

        List<BO.GeminiProjectInfo> FetchSelectedProjectInfo(long projectId, string userAbrhs);

        BO.GeminiProject FetchProjectInfo(long projectId, string userAbrhs);

        List<BO.GeminiTeamInfo> ListTeamMembersforSelectedProject(long projectId, string userAbrhs);

        List<BO.UserDetail> ListAllUsersAvailableForProject(long projectId, string userAbrhs);

        List<BO.UserDetail> ListAllUsersAssignedToProject(long projectId, string role, string userAbrhs);

        List<BO.GeminiProject> ListRootProjects(string userAbrhs);

        #endregion

        #region Gemini Project Management

        int SaveProjectVertical(BO.GeminiProjectVertical vertical);

        int UpdateProjectVertical(BO.GeminiProjectVertical vertical);

        int SaveProject(BO.GeminiProject project);

        int UpdateProject(BO.GeminiProject project);

        int AssignTeamMember(BO.GeminiProjectTeamMember teamMember);

        int UnAssignTeamMember(BO.GeminiProjectTeamMember teamMember);

        #endregion

        #region Pimco Project verticals

        List<BO.GeminiProjectVerticalInfo> ListPimcoActiveProjectVerticals(string userAbrhs);

        BO.GeminiProjectVertical FetchPimcoSelectedVerticalInfo(int verticalId);

        List<BO.UserDetail> ListPimcoActiveUsers(string userAbrhs);

        string FetchPimcoRoleforCurrentUser(string userAbrhs);

        List<BO.GeminiProjectVertical> ListPimcoActiveVerticals(string userAbrhs);

        List<BO.GeminiProjectIndustryType> ListPimcoActiveProjectIndustryType(string userAbrhs);

        List<BO.GeminiProjectStatus> ListPimcoActiveProjectStatus(string userAbrhs);

        List<BO.PimcoProject> ListPimcoProjects(long verticalId, long parentProjectId, string userAbrhs);

        List<BO.GeminiProjectInfo> FetchPimcoSelectedProjectInfo(long projectId, string userAbrhs);

        BO.PimcoProject FetchPimcoProjectInfo(long projectId, string userAbrhs);

        List<BO.GeminiTeamInfo> ListPimcoTeamMembersforSelectedProject(long projectId, string userAbrhs);

        List<BO.UserDetail> ListPimcoAllUsersAvailableForProject(long projectId, string userAbrhs);

        List<BO.UserDetail> ListPimcoAllUsersAssignedToProject(long projectId, string role, string userAbrhs);

        List<BO.PimcoProject> ListPimcoRootProjects(string userAbrhs);

        #endregion

        #region Pimco Project Management

        int SavePimcoProjectVertical(BO.GeminiProjectVertical vertical);

        int UpdatePimcoProjectVertical(BO.GeminiProjectVertical vertical);

        int SavePimcoProject(BO.PimcoProject project);

        int UpdatePimcoProject(BO.PimcoProject project);

        int AssignPimcoTeamMember(BO.PimcoProjectTeamMember teamMember);

        int UnAssignPimcoTeamMember(BO.PimcoProjectTeamMember teamMember);

        #endregion
    }
}
