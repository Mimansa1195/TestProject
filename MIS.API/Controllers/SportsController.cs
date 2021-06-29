using MIS.Services.Contracts;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace MIS.API.Controllers
{
    public class SportsController : BaseApiController
    {

        private readonly ISportService _sportService;

        public SportsController(ISportService sportService)
        {
            _sportService = sportService;
        }

        [HttpPost]
        public HttpResponseMessage GetTTTournamentData(string userAbrhs, string matchDate)
        {
            var MatchDate = DateTime.ParseExact(matchDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            return Request.CreateResponse(HttpStatusCode.OK, _sportService.GetTTTournamentData(userAbrhs, MatchDate));
        }

        [HttpPost]
        public HttpResponseMessage GetTournamentTeamDetails(int tournamentId, int tournamentCategoryId, int roundId, int teamId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _sportService.GetTournamentTeamDetails(tournamentId, tournamentCategoryId, roundId, teamId));
        }

        [HttpPost]
        public HttpResponseMessage GetTournaments()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _sportService.GetTournaments());
        }

        [HttpPost]
        public HttpResponseMessage GetTournamentCategories()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _sportService.GetTournamentCategories());
        }

        [HttpPost]
        public HttpResponseMessage GetTournamentTeams(int tournamentId, int tournamentCategoryId, int roundId, string MatchDate)
        {
            var matchDate = DateTime.ParseExact(MatchDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            return Request.CreateResponse(HttpStatusCode.OK, _sportService.GetTournamentTeams(tournamentId, tournamentCategoryId, roundId, matchDate));
        }

        [HttpPost]
        public HttpResponseMessage UpdateTeamsScore(int TournamentScheduleId, int TournamentTeamId, int GameId, int ScoreValue, string UserAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _sportService.UpdateTeamsScore(TournamentScheduleId, TournamentTeamId, GameId, ScoreValue, UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetTournamentTeamScore(int TournamentScheduleId, int GameId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _sportService.GetTournamentTeamScore(TournamentScheduleId, GameId));
        }

        [HttpPost]
        public HttpResponseMessage UpdateMatchStatus(int TournamentScheduleId, int Status, string UserAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _sportService.UpdateMatchStatus(TournamentScheduleId, Status, UserAbrhs));
        }

    }
}
