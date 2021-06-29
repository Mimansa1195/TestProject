using MIS.BO;
using MIS.Model;
using MIS.Services.Contracts;
using MIS.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;

namespace MIS.Services.Implementations
{
    public class ExternalServices : IExternalServices
    {
        #region Private member variables

        private readonly MISEntities _dbContext = new MISEntities();

        #endregion

        public List<UserSkillSet> GetUsersSkills()
        {
            var userData = _dbContext.Proc_GetAllGeminiUsersSkill().ToList();
            var userSkill = userData.Select(t => new UserSkillSet
            {
                EmployeeName = t.EmployeeName,
                EmailId = CryptoHelper.Decrypt(t.EmailId),
                Skills = t.Skills
            }).ToList();

            return userSkill ?? new List<UserSkillSet>();
        }

        /// <summary>
        /// Get All Gemini users (Active or Inactive users) for P & L project
        /// </summary>
        /// <returns>List<GeminiUsersForPnL></returns>
        public ResponseBO<List<GeminiUsersForPnL>> GetAllGeminiUsersForPnL()
        {
            var response = new ResponseBO<List<GeminiUsersForPnL>>() { IsSuccessful = false, Status = ResponseStatus.Error, StatusCode = HttpStatusCode.InternalServerError, Message = ResponseMessage.Error };
            try
            {
                var orgData = _dbContext.Proc_FetchAllGeminiUsersForPimco().ToList();
                var buildVersion = GlobalServices.GetBuildVersion();
                var orgStructure = orgData.Select(x => new GeminiUsersForPnL
                {
                    EmployeeName = x.EmployeeName,
                    EmployeeCode = x.EmployeeCode,
                    GeminiEmailId = CryptoHelper.Decrypt(x.GeminiEmailId),
                    Designation = x.Designation,
                    Team = x.Team,
                    Department = x.Department,
                    JoiningDate = x.JoiningDate,
                    ExitDate = x.DOL,
                    RMName = "",
                    RMEmployeeCode = x.RMId,
                    IsPimcoUser = x.IsPimcoUser,
                    PimcoId = x.PimcoId,
                    IsActive = x.IsActive
                }).OrderBy(x => x.EmployeeName);

                response.IsSuccessful = true;
                response.Status = ResponseStatus.Success;
                response.StatusCode = HttpStatusCode.OK;
                response.Message = ResponseMessage.Success;
                response.Result = orgStructure.ToList() ?? new List<GeminiUsersForPnL>();
            }
            catch (Exception ex)
            {
                GlobalServices.LogError(ex);
                response.Message = ex.Message;
            }
            return response;
        }

        /// <summary>
        /// Get Gemini's active user(s)
        /// </summary>
        /// <param name="email">Email</param>
        /// <returns><List<GeminiUsersBaseBO></returns>
        public ResponseBO<List<GeminiUsersBaseBO>> GetGeminiActiveUsers(string email = "")
        {
            var response = new ResponseBO<List<GeminiUsersBaseBO>>() { IsSuccessful = false, Status = ResponseStatus.Error, StatusCode = HttpStatusCode.InternalServerError, Message = ResponseMessage.Error };
            try
            {
                var data = _dbContext.Proc_FetchAllGeminiUsersForPimco().AsQueryable();
                if (!string.IsNullOrEmpty(email))
                {
                    var encryptedEmail = CryptoHelper.Encrypt(email.Trim());
                    data = data.Where(x => x.GeminiEmailId.ToLower() == encryptedEmail.ToLower());
                }
                var result = data.Select(x => new GeminiUsersBaseBO
                {
                    EmployeeName = x.EmployeeName,
                    EmployeeCode = x.EmployeeCode,
                    GeminiEmailId = CryptoHelper.Decrypt(x.GeminiEmailId),
                    Designation = x.Designation,
                    Team = x.Team,
                    Department = x.Department,
                    JoiningDate = x.JoiningDate,
                    RMName = "",
                    RMEmployeeCode = x.RMId,
                }).OrderBy(x => x.EmployeeName);

                response.IsSuccessful = true;
                response.Status = ResponseStatus.Success;
                response.StatusCode = HttpStatusCode.OK;
                response.Message = ResponseMessage.Success;
                response.Result = result.ToList() ?? new List<GeminiUsersBaseBO>();
            }
            catch (Exception ex)
            {
                GlobalServices.LogError(ex);
                response.Message = ex.Message;
            }
            return response;
        }
    }
}
