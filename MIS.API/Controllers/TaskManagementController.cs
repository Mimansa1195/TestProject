using MIS.Services.Contracts;
using System;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace MIS.API.Controllers
{
    public class TaskManagementController : BaseApiController
    {
        // GET: TaskManagement
        private readonly ITaskManagementServices _taskManagementServices;

        public TaskManagementController(ITaskManagementServices taskManagementServices)
        {
            _taskManagementServices = taskManagementServices;
        }

        [HttpPost]
        public HttpResponseMessage ListAllTaskTeam()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _taskManagementServices.ListAllTaskTeam());
        }

        [HttpPost]
        public HttpResponseMessage FetchTaskTeamByTeamId(long taskTeamId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _taskManagementServices.FetchTaskTeamByTeamId(taskTeamId));
        }

        [HttpPost]
        public HttpResponseMessage ListAllTaskType()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _taskManagementServices.ListAllTaskType());
        }

        [HttpPost]
        public HttpResponseMessage FetchTaskTypeByTypeId(long taskTypeId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _taskManagementServices.FetchTaskTypeByTypeId(taskTypeId));
        }

        [HttpPost]
        public HttpResponseMessage ListAllTaskSubDetail1()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _taskManagementServices.ListAllTaskSubDetail1());
        }

        [HttpPost]
        public HttpResponseMessage FetchTaskSubDetail1ById(long taskSubDetail1Id)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _taskManagementServices.FetchTaskSubDetail1ById(taskSubDetail1Id));
        }

        [HttpPost]
        public HttpResponseMessage ListAllTaskSubDetail2()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _taskManagementServices.ListAllTaskSubDetail2());
        }

        [HttpPost]
        public HttpResponseMessage FetchTaskSubDetail2ById(long taskSubDetail2Id)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _taskManagementServices.FetchTaskSubDetail2ById(taskSubDetail2Id));
        }

        [HttpPost]
        public HttpResponseMessage ListAllMappedTypeTeam(int taskTeamId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _taskManagementServices.ListAllMappedTypeTeam(taskTeamId));
        }

        [HttpPost]
        public HttpResponseMessage ListMappedTypeToTeam(long taskTeamId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _taskManagementServices.ListMappedTypeToTeam(taskTeamId));
        }

        [HttpPost]
        public HttpResponseMessage AddNewTaskTeam(string taskTeamName, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _taskManagementServices.AddNewTaskTeam(taskTeamName, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage AddNewTaskType(string taskTypeName, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _taskManagementServices.AddNewTaskType(taskTypeName, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage AddNewTaskSubDetail1(string taskSubDetail1Name, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _taskManagementServices.AddNewTaskSubDetail1(taskSubDetail1Name, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage AddNewTaskSubDetail2(string taskSubDetail2Name, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _taskManagementServices.AddNewTaskSubDetail2(taskSubDetail2Name, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage UpdateTaskTeamDetails(long taskTeamId, string taskTeamName, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _taskManagementServices.UpdateTaskTeamDetails(taskTeamId, taskTeamName, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage UpdateTaskTypeDetails(long taskTypeId, string taskTypeName, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _taskManagementServices.UpdateTaskTypeDetails(taskTypeId, taskTypeName, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage UpdateTaskSubDetail1(long taskSubDetail1Id, string taskSubDetail1Name, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _taskManagementServices.UpdateTaskSubDetail1(taskSubDetail1Id, taskSubDetail1Name, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage UpdateTaskSubDetail2(long taskSubDetail2Id, string taskSubDetail2Name, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _taskManagementServices.UpdateTaskSubDetail2(taskSubDetail2Id, taskSubDetail2Name, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage DeleteTaskTeam(long taskTeamId, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _taskManagementServices.DeleteTaskTeam(taskTeamId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage DeleteTaskType(long taskTypeId, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _taskManagementServices.DeleteTaskType(taskTypeId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage DeleteTaskSubDetail1(long taskSubDetail1Id, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _taskManagementServices.DeleteTaskSubDetail1(taskSubDetail1Id, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage DeleteTaskSubDetail2(long taskSubDetail2Id, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _taskManagementServices.DeleteTaskSubDetail2(taskSubDetail2Id, userAbrhs));
        }
    }
}