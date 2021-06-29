using MIS.BO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MIS.Services.Contracts
{
    public interface ISportService
    {
        #region TT Tournament

        List<TournamentScoreDetailBO> GetTTTournamentData(string userAbrhs, DateTime matchDate);

        int GetTournamentTeamDetails(int tournamentId, int tournamentCategoryId, int roundId, int teamId);

        List<BaseDropDown> GetTournaments();

        List<BaseDropDown> GetTournamentCategories();

        //List<BaseDropDown> GetRounds(int tournamentId, int tournamentCategoryId);

        List<TournamentTeamBO> GetTournamentTeams(int tournamentId, int tournamentCategoryId, int roundId, DateTime matchDate);

        int UpdateTeamsScore(int TournamentScheduleId, int TournamentTeamId, int GameId, int ScoreValue, string UserAbrhs);

        List<TournamentTeamScoreBO> GetTournamentTeamScore(int TournamentScheduleId, int GameId);

        int UpdateMatchStatus(int TournamentScheduleId, int Status, string UserAbrhs);

        #endregion 
    }
}
