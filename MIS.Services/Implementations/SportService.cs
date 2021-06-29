using MIS.BO;
using MIS.Model;
using MIS.Services.Contracts;
using MIS.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MIS.Services.Implementations
{
    public class SportService : ISportService
    {
        #region Private member variables

        private readonly MISEntities _dbContext = new MISEntities();

        #endregion

        #region TT Tournament

        public List<TournamentScoreDetailBO> GetTTTournamentData(string userAbrhs, DateTime matchDate)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            List<TournamentScoreDetailBO> tournamentScoreDetail = new List<TournamentScoreDetailBO>();
            var result = _dbContext.Proc_GetTournamentScoreDetails(matchDate).ToList();
            if (result.Any())
            {
                foreach (var item in result)
                {
                    TournamentScoreDetailBO model = new TournamentScoreDetailBO();
                    model.TournamentScheduleId = item.TournamentScheduleId;
                    model.TournamentDate = item.TournamentDate;
                    model.CategoryCode = item.CategoryCode;
                    model.Category = item.Category;
                    model.TournamentTeamId = item.TournamentTeamId;
                    model.TournamentVSTeamId = item.TournamentVSTeamId;
                    model.Group = item.Group;
                    model.TournamentUsers = item.TournamentUsers;
                    model.TournamentVSUsers = item.TournamentVSUsers;
                    model.Round = item.Round;
                    model.G1Score = item.G1Score != null ? item.G1Score : 0;
                    model.G2Score = item.G2Score != null ? item.G2Score : 0;
                    model.G3Score = item.G3Score != null ? item.G3Score : 0;
                    model.G4Score = item.G4Score != null ? item.G4Score : 0;
                    model.G5Score = item.G5Score != null ? item.G5Score : 0;
                    model.TeamId = item.TeamId;
                    model.IsLive = item.IsLive;

                    tournamentScoreDetail.Add(model);
                }
            }
            return tournamentScoreDetail;
        }

        public int GetTournamentTeamDetails(int tournamentId, int tournamentCategoryId, int roundId, int teamId)
        {
            //var result = _dbContext.spGetUserCommentsForDongleAllocation(userId).FirstOrDefault();
            return 0;
        }

        /// <summary>
        /// Fetch Tournaments
        /// </summary>
        /// <returns></returns>
        public List<BaseDropDown> GetTournaments()
        {
            using (var context = new MISEntities())
            {
                var ddl = (from t in context.Tournaments
                           where t.IsActive == true
                           select new BaseDropDown
                           {
                               Text = t.TournamentName,
                               Value = t.TournamentId,
                               Selected = false
                           }).AsQueryable();
                return ddl.OrderBy(t => t.Text).ToList();
            }
        }

        /// <summary>
        /// Fetch Tournament Categories
        /// </summary>
        /// <returns></returns>
        public List<BaseDropDown> GetTournamentCategories()
        {
            using (var context = new MISEntities())
            {
                var ddl = (from t in context.TournamentCategories
                           where t.IsActive == true
                           select new BaseDropDown
                           {
                               Text = t.Category,
                               Value = t.TournamentCategoryId,
                               Selected = false
                           }).AsQueryable();
                return ddl.OrderBy(t => t.Text).ToList();
            }
        }

        /// <summary>
        /// Fetch Tournament Teams
        /// </summary>
        /// <returns></returns>
        public List<TournamentTeamBO> GetTournamentTeams(int tournamentId, int tournamentCategoryId, int roundId, DateTime fromDate)
        {
            using (var context = new MISEntities())
            {
                List<TournamentTeamBO> TournamentTeam = new List<TournamentTeamBO>();
                var data = context.Proc_GetTournamentSchedule(tournamentCategoryId, roundId, fromDate.Date);
                foreach (var item in data)
                {
                    TournamentTeamBO model = new TournamentTeamBO();
                    model.TournamentScheduleId = item.TournamentScheduleId;
                    model.TournamentDate = item.TournamentDate;
                    model.TournamentCategoryId = item.TournamentCategoryId;
                    model.CategoryCode = item.CategoryCode;
                    model.Category = item.Category;
                    model.TournamentTeamId = item.TournamentTeamId;
                    model.TournamentVSTeamId = item.TournamentVSTeamId;
                    model.Group = item.Group;
                    model.TournamentUserIds = item.TournamentUserIds;
                    model.TournamentUsers = item.TournamentUsers;
                    model.TournamentVSUserIds = item.TournamentVSUserIds;
                    model.TournamentVSUsers = item.TournamentVSUsers;
                    model.Round = item.Round;
                    TournamentTeam.Add(model);
                }
                return TournamentTeam;
            }
        }

        public int UpdateTeamsScore(int TournamentScheduleId, int TournamentTeamId, int GameId, int ScoreValue, string UserAbrhs)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(UserAbrhs), out userId);
                TournamentScore model = new TournamentScore();
                var checkExist = context.TournamentScores.FirstOrDefault(x => x.TournamentScheduleId == TournamentScheduleId && x.TournamentTeamId == TournamentTeamId);
                if (checkExist != null)
                {
                    if (GameId == 1)
                        checkExist.G1Score = checkExist.G1Score + ScoreValue;
                    if (GameId == 2)
                        checkExist.G2Score = (checkExist.G2Score == null ? 0 : checkExist.G2Score) + ScoreValue;
                    if (GameId == 3)
                        checkExist.G3Score = (checkExist.G3Score == null ? 0 : checkExist.G3Score) + ScoreValue;
                    if (GameId == 4)
                        checkExist.G4Score = (checkExist.G4Score == null ? 0 : checkExist.G4Score) + ScoreValue;
                    if (GameId == 5)
                        checkExist.G5Score = (checkExist.G5Score == null ? 0 : checkExist.G5Score) + ScoreValue;

                    checkExist.ModifiedDate = DateTime.Now;
                    checkExist.ModifiedById = userId;
                    context.SaveChanges();
                    return 1;
                }
                else
                {
                    if (ScoreValue > 0)
                    {
                        model.TournamentScheduleId = TournamentScheduleId;
                        model.TournamentTeamId = TournamentTeamId;
                        model.IsActive = true;
                        model.CreatedDate = DateTime.Now;
                        model.CreatedById = userId;

                        if (GameId == 1)
                            model.G1Score = ScoreValue;
                        if (GameId == 2)
                            model.G2Score = ScoreValue;
                        if (GameId == 3)
                            model.G3Score = ScoreValue;
                        if (GameId == 4)
                            model.G4Score = ScoreValue;
                        if (GameId == 5)
                            model.G5Score = ScoreValue;

                        context.TournamentScores.Add(model);
                        context.SaveChanges();
                        return 1;
                    }
                    return 0;
                }
            }
        }

        public List<TournamentTeamScoreBO> GetTournamentTeamScore(int TournamentScheduleId, int GameId)
        {
            using (var context = new MISEntities())
            {
                List<TournamentTeamScoreBO> result = new List<TournamentTeamScoreBO>();
                var data = context.TournamentScores.Where(x => x.TournamentScheduleId == TournamentScheduleId).ToList();
                if (data.Any())
                {
                    foreach (var item in data)
                    {
                        TournamentTeamScoreBO model = new TournamentTeamScoreBO();
                        model.TournamentScheduleId = item.TournamentScheduleId;
                        model.TournamentTeamId = item.TournamentTeamId;
                        if (GameId == 1)
                            model.GameScore = item.G1Score != null ? item.G1Score : 0;
                        if (GameId == 2)
                            model.GameScore = item.G2Score != null ? item.G2Score : 0;
                        if (GameId == 3)
                            model.GameScore = item.G3Score != null ? item.G3Score : 0;
                        if (GameId == 4)
                            model.GameScore = item.G4Score != null ? item.G4Score : 0;
                        if (GameId == 5)
                            model.GameScore = item.G5Score != null ? item.G5Score : 0;

                        result.Add(model);
                    }
                }
                return result;
            }
        }

        public int UpdateMatchStatus(int TournamentScheduleId, int Status, string UserAbrhs)
        {
            using (var context = new MISEntities())
            {
                if (Status == 1)
                {
                    var LiveMatch = context.TournamentScores.Where(x => x.IsActive).ToList();
                    if (LiveMatch.Any())
                    {
                        foreach (var item in LiveMatch)
                        {
                            item.IsActive = false;
                        }
                        context.SaveChanges();
                    }

                    var data = context.TournamentScores.Where(x => x.TournamentScheduleId == TournamentScheduleId).ToList();
                    if (data.Any())
                    {
                        foreach (var item in data)
                        {
                            item.IsActive = true;
                            item.ModifiedDate = DateTime.Now;
                        }
                        context.SaveChanges();
                    }
                }
                if (Status == 0)
                {
                    var LiveMatch = context.TournamentScores.Where(x => x.IsActive).ToList();
                    if (LiveMatch.Any())
                    {
                        foreach (var item in LiveMatch)
                        {
                            item.IsActive = false;
                        }
                        context.SaveChanges();
                    }
                }
                return 0;
            }
        }

        #endregion
    }
}
