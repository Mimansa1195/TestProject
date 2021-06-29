using MIS.Services.Contracts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace MIS.API.Controllers
{
    public class ProjectManagementController : BaseApiController
    {
        private readonly IProjectManagementServices _projectManagementServices;
        private readonly ICommonService _commonService;

        public ProjectManagementController(IProjectManagementServices projectManagementServices, ICommonService commonService)
        {
            _projectManagementServices = projectManagementServices;
            _commonService = commonService;
        }

        #region Gemini Project verticals

        [HttpPost]
        public HttpResponseMessage ListActiveProjectVerticals(string userAbrhs)
        {
                return Request.CreateResponse(HttpStatusCode.OK, _projectManagementServices.ListActiveProjectVerticals(userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage FetchSelectedVerticalInfo(int verticalId)
        {
                return Request.CreateResponse(HttpStatusCode.OK, _projectManagementServices.FetchSelectedVerticalInfo(verticalId));
        }

        [HttpPost]
        public HttpResponseMessage ListActiveUsers(string userAbrhs)
        {
                return Request.CreateResponse(HttpStatusCode.OK, _commonService.ListAllActiveUsers());
        }

        [HttpPost]
        public HttpResponseMessage FetchRoleforCurrentUser(string userAbrhs)
        {
                return Request.CreateResponse(HttpStatusCode.OK, _projectManagementServices.FetchRoleforCurrentUser(userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage ListActiveVerticals(string userAbrhs)
        {
                return Request.CreateResponse(HttpStatusCode.OK, _projectManagementServices.ListActiveVerticals(userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage ListActiveProjectIndustryType(string userAbrhs)
        {
                return Request.CreateResponse(HttpStatusCode.OK, _projectManagementServices.ListActiveProjectIndustryType(userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage ListActiveProjectStatus(string userAbrhs)
        {
                return Request.CreateResponse(HttpStatusCode.OK, _projectManagementServices.ListActiveProjectStatus(userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage ListProjects(long verticalId, long parentProjectId, string userAbrhs)
        {
                return Request.CreateResponse(HttpStatusCode.OK, _projectManagementServices.ListProjects(verticalId, parentProjectId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage FetchSelectedProjectInfo(long projectId, string userAbrhs)
        {
                return Request.CreateResponse(HttpStatusCode.OK, _projectManagementServices.FetchSelectedProjectInfo(projectId,userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage FetchProjectInfo(long projectId, string userAbrhs)
        {
                return Request.CreateResponse(HttpStatusCode.OK, _projectManagementServices.FetchProjectInfo(projectId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage ListTeamMembersforSelectedProject(long projectId, string userAbrhs)
        {
                return Request.CreateResponse(HttpStatusCode.OK, _projectManagementServices.ListTeamMembersforSelectedProject(projectId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage ListAllUsersAvailableForProject(long projectId, string userAbrhs)
        {
                return Request.CreateResponse(HttpStatusCode.OK, _projectManagementServices.ListAllUsersAvailableForProject(projectId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage ListAllUsersAssignedToProject(long projectId, string role, string userAbrhs)
        {
                return Request.CreateResponse(HttpStatusCode.OK, _projectManagementServices.ListAllUsersAssignedToProject(projectId, role, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage ListRootProjects(string userAbrhs)
        {
                return Request.CreateResponse(HttpStatusCode.OK, _projectManagementServices.ListRootProjects(userAbrhs));
        }


        #endregion

        #region Gemini Project Management

        [HttpPost]
        public HttpResponseMessage SaveProjectVertical(BO.GeminiProjectVertical vertical)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _projectManagementServices.SaveProjectVertical(vertical));
        }

        [HttpPost]
        public HttpResponseMessage UpdateProjectVertical(BO.GeminiProjectVertical vertical)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _projectManagementServices.UpdateProjectVertical(vertical));
        }

        [HttpPost]
        public HttpResponseMessage SaveProject(BO.GeminiProject project)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _projectManagementServices.SaveProject(project));
        }

        [HttpPost]
        public HttpResponseMessage UpdateProject(BO.GeminiProject project)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _projectManagementServices.UpdateProject(project));
        }

        [HttpPost]
        public HttpResponseMessage AssignTeamMember(BO.GeminiProjectTeamMember teamMember)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _projectManagementServices.AssignTeamMember(teamMember));
        }

        [HttpPost]
        public HttpResponseMessage UnAssignTeamMember(BO.GeminiProjectTeamMember teamMember)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _projectManagementServices.UnAssignTeamMember(teamMember));
        }

        #endregion

        #region Pimco Project verticals

        [HttpPost]
        public HttpResponseMessage ListPimcoActiveProjectVerticals(string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _projectManagementServices.ListPimcoActiveProjectVerticals(userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage FetchPimcoSelectedVerticalInfo(int verticalId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _projectManagementServices.FetchPimcoSelectedVerticalInfo(verticalId));
        }

        [HttpPost]
        public HttpResponseMessage ListPimcoActiveUsers(string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonService.ListAllActiveUsers());
        }

        [HttpPost]
        public HttpResponseMessage FetchPimcoRoleforCurrentUser(string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _projectManagementServices.FetchPimcoRoleforCurrentUser(userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage ListPimcoActiveVerticals(string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _projectManagementServices.ListPimcoActiveVerticals(userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage ListPimcoActiveProjectIndustryType(string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _projectManagementServices.ListPimcoActiveProjectIndustryType(userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage ListPimcoActiveProjectStatus(string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _projectManagementServices.ListPimcoActiveProjectStatus(userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage ListPimcoProjects(long verticalId, long parentProjectId, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _projectManagementServices.ListPimcoProjects(verticalId, parentProjectId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage FetchPimcoSelectedProjectInfo(long projectId, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _projectManagementServices.FetchPimcoSelectedProjectInfo(projectId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage FetchPimcoProjectInfo(long projectId, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _projectManagementServices.FetchPimcoProjectInfo(projectId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage ListPimcoTeamMembersforSelectedProject(long projectId, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _projectManagementServices.ListPimcoTeamMembersforSelectedProject(projectId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage ListPimcoAllUsersAvailableForProject(long projectId, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _projectManagementServices.ListPimcoAllUsersAvailableForProject(projectId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage ListPimcoAllUsersAssignedToProject(long projectId, string role, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _projectManagementServices.ListPimcoAllUsersAssignedToProject(projectId, role, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage ListPimcoRootProjects(string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _projectManagementServices.ListPimcoRootProjects(userAbrhs));
        }


        #endregion

        #region Pimco Project Management

        [HttpPost]
        public HttpResponseMessage SavePimcoProjectVertical(BO.GeminiProjectVertical vertical)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _projectManagementServices.SavePimcoProjectVertical(vertical));
        }

        [HttpPost]
        public HttpResponseMessage UpdatePimcoProjectVertical(BO.GeminiProjectVertical vertical)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _projectManagementServices.UpdatePimcoProjectVertical(vertical));
        }

        [HttpPost]
        public HttpResponseMessage SavePimcoProject(BO.PimcoProject project)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _projectManagementServices.SavePimcoProject(project));
        }

        [HttpPost]
        public HttpResponseMessage UpdatePimcoProject(BO.PimcoProject project)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _projectManagementServices.UpdatePimcoProject(project));
        }

        [HttpPost]
        public HttpResponseMessage AssignPimcoTeamMember(BO.PimcoProjectTeamMember teamMember)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _projectManagementServices.AssignPimcoTeamMember(teamMember));
        }

        [HttpPost]
        public HttpResponseMessage UnAssignPimcoTeamMember(BO.PimcoProjectTeamMember teamMember)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _projectManagementServices.UnAssignPimcoTeamMember(teamMember));
        }

        #endregion

    }
}
