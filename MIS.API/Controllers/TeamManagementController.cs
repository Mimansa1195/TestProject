using MIS.Services.Contracts;
using System;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Linq;
using System.Collections.Generic;
using MIS.Model;
using MIS.BO;

namespace MIS.API.Controllers
{
    public class TeamManagementController : ApiController
    {
        #region private member variable

        private readonly ITeamManagementServices _teamManagementServices;

        #endregion

        public TeamManagementController(ITeamManagementServices teamManagementServices)
        {
            _teamManagementServices = teamManagementServices;
        }

        #region Team management

        [HttpPost]
        public HttpResponseMessage AddUpdateTeamDetails(TeamInformationBO teamInformation)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _teamManagementServices.AddUpdateTeamDetails(teamInformation));
        }

        [HttpPost]
        public HttpResponseMessage ListAllTeams()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _teamManagementServices.ListAllTeams());
        }

        [HttpPost]
        public HttpResponseMessage FetchTeamEmailTypeMapping(string teamAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _teamManagementServices.FetchTeamEmailTypeMapping(teamAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage FetchTeamByTeamId(string teamAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _teamManagementServices.FetchTeamByTeamId(teamAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage ListAllWeekType()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _teamManagementServices.ListAllWeekType());
        }

        //[HttpPost]
        //public HttpResponseMessage AddNewTeam(TeamBO team)
        //{
        //        return Request.CreateResponse(HttpStatusCode.OK, _teamManagementServices.AddNewTeam(team));
        //}

        //[HttpPost]
        //public HttpResponseMessage UpdateTeamDetails(TeamBO team)
        //{
        //        return Request.CreateResponse(HttpStatusCode.OK, _teamManagementServices.UpdateTeamDetails(team));
        //}

        [HttpPost]
        public HttpResponseMessage DeleteTeam(string teamAbrhs, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _teamManagementServices.DeleteTeam(teamAbrhs, userAbrhs));
        }

        #endregion

        #region User team mapping

        [HttpPost]
        public HttpResponseMessage TeamsListforMapping()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _teamManagementServices.TeamsListforMapping());
        }

        [HttpPost]
        public HttpResponseMessage TeamsListforMappingByDeptId(string DeptAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _teamManagementServices.TeamsListforMappingByDeptId(DeptAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage DeptListforMapping()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _teamManagementServices.DeptListforMapping());
        }

        [HttpPost]
        public HttpResponseMessage ListMappedUserToTeam(string teamAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _teamManagementServices.ListMappedUserToTeam(teamAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage InsertNewUserTeamMapping(ManageUserTeamMappingBO UserTeamMapping)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _teamManagementServices.InsertNewUserTeamMapping(UserTeamMapping));
        }

        [HttpPost]
        public HttpResponseMessage DeleteUserTeamMapping(int userId, long teamId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _teamManagementServices.DeleteUserTeamMapping(userId, teamId));
        }

        #endregion

        #region Shift management

        [HttpPost]
        public HttpResponseMessage ListAllShift()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _teamManagementServices.ListAllShift());
        }

        [HttpPost]
        public HttpResponseMessage ListShiftByShiftId(long shiftId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _teamManagementServices.ListShiftByShiftId(shiftId));
        }

        [HttpPost]
        public HttpResponseMessage AddNewShift(BO.ShiftMaster shift)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _teamManagementServices.AddNewShift(shift));
        }

        [HttpPost]
        public HttpResponseMessage DeleteShift(string ShiftAbrhs, string UserAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _teamManagementServices.DeleteShift(ShiftAbrhs, UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage UpdateShiftDetails(BO.ShiftMaster shift)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _teamManagementServices.UpdateShiftDetails(shift));
        }

        #endregion



        #region Shift User Mapping based on Team


        [HttpPost]
        public HttpResponseMessage MappedUsersOfTeam(string TeamAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _teamManagementServices.MappedUsersOfTeam(TeamAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetShiftsList()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _teamManagementServices.GetShiftsList());
        }
        [HttpPost]
        public HttpResponseMessage GetDateIdList(string fromDate, string ToDate)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _teamManagementServices.GetDateIdList(fromDate, ToDate));
        }
        [HttpPost]
        public HttpResponseMessage GetShiftUserMappingList(string UserAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _teamManagementServices.GetShiftUserMappingList(UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage SearchShiftUserMappingList(ShiftUserMappingFilterBO filter) //string UserAbrhs, string TeamAbrhs, string ShiftAbrhs, List<WeekStDateToDate> DateList)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _teamManagementServices.SearchShiftUserMappingList(filter));
        }

        [HttpPost]
        public HttpResponseMessage AddUpdateShiftUserMapping(List<UserShiftMappingList> ShiftUserList)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _teamManagementServices.AddUpdateShiftUserMapping(ShiftUserList));
        }

        [HttpPost]
        public HttpResponseMessage DeleteShiftUserMapping(int MappingId, string UserAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _teamManagementServices.DeleteShiftUserMapping(MappingId, UserAbrhs));
        }
        #endregion
    }
}