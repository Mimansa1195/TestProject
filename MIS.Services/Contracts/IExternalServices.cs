using MIS.BO;
using System.Collections.Generic;

namespace MIS.Services.Contracts
{
    public interface IExternalServices
    {
        List<UserSkillSet> GetUsersSkills();

        /// <summary>
        /// Get All Gemini users for P & L project
        /// </summary>
        /// <returns>List<GeminiUsersForPnL></returns>
        ResponseBO<List<GeminiUsersForPnL>> GetAllGeminiUsersForPnL();

        /// <summary>
        /// Get Gemini's active user(s)
        /// </summary>
        /// <param name="email">Email</param>
        /// <returns><List<GeminiUsersBaseBO></returns>
        ResponseBO<List<GeminiUsersBaseBO>> GetGeminiActiveUsers(string email = "");
    }
}
