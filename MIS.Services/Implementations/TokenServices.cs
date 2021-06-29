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
    public class TokenServices : ITokenServices
    {

        #region Private member variables.
        private readonly MISEntities _dbContext = new MISEntities();
        #endregion

        #region Public member methods.

        /// <summary>
        ///  Function to generate unique token with expiry against the provided userId.
        ///  Also add a record in database for generated token.
        /// </summary>
        /// <param name="userId">UserId</param>
        /// <param name="expiresInSeconds">Token expiration time in seconds</param>
        /// <returns></returns>
        public TokenBO GenerateToken(int userId, double expiresInSeconds)
        {
            //Delete all tokens of a user for single sign-on
            DeleteTokensByUserId(userId);

            //Insert New Token
            string token = Guid.NewGuid().ToString();
            DateTime issuedOn = DateTime.Now;
            DateTime expiredOn = DateTime.Now.AddSeconds(Convert.ToDouble(expiresInSeconds));
            var tokendomain = new Model.UsersToken
            {
                UserId = userId,
                AuthToken = token,
                IssuedOn = issuedOn,
                ExpiresOn = expiredOn,
                IsActive = true,
                LastActivityDate = DateTime.Now
            };

            _dbContext.UsersTokens.Add(tokendomain);
            _dbContext.SaveChanges();
            var tokenModel = new TokenBO()
            {
                UserId = userId,
                IssuedOn = issuedOn,
                ExpiresOn = expiredOn,
                AuthToken = token,
                IsActive = true,
                LastActivityDate = DateTime.Now
            };
            return tokenModel;
        }

        /// <summary>
        /// Method to validate token against expiry and existence in database.
        /// </summary>
        /// <param name="userAbrhs">UserAbrhs</param>
        /// <param name="tokenId">Auth Token</param>
        /// <param name="expiresInSeconds">Token expiration time in seconds</param>
        /// <returns>True/False</returns>
        public bool ValidateToken(string userAbrhs, string tokenId, double expiresInSeconds)
        {
            var reqUserId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out reqUserId);

            if (string.IsNullOrEmpty(tokenId) || !(reqUserId > 0))
                return false;

            var token = _dbContext.UsersTokens.FirstOrDefault(t => t.UserId == reqUserId && t.AuthToken == tokenId && t.ExpiresOn > DateTime.Now);
            if (token != null && !(DateTime.Now > token.ExpiresOn))
            {
                token.LastActivityDate = DateTime.Now;
                token.ExpiresOn = DateTime.Now.AddSeconds(Convert.ToDouble(expiresInSeconds));
                _dbContext.SaveChanges();
                return true;
            }
            return false;
        }

        /// <summary>
        /// Method to validate api permission for user.
        /// </summary>
        /// <param name="token">token</param>
        /// <param name="expiresInSeconds">ExpiresInSeconds</param>
        /// <param name="controllerName">ControllerName</param>
        /// <param name="actionName">ActionName</param>
        /// <param name="httpVerb">HttpVerb</param>
        /// <returns>True/False</returns>
        public bool ValidateApi(string token, Int64 expiresInSeconds, string controllerName, string actionName, string httpVerb)
        {
            if (string.IsNullOrEmpty(token) || !(expiresInSeconds > 0) || string.IsNullOrEmpty(controllerName))
                return false;

            // Validate Tookens & API Permissions
            //=> todo: Out param to validate token
            var apiPermissions = _dbContext.Proc_FetchAPIPermissions(token, expiresInSeconds).Select(x => new APIPermissionBO
            {
                APIId = x.APIId ?? 0,
                ControllerName = x.ControllerName,
                ActionName = x.ActionName,
                EndPoint = x.EndPoint,
                Verb = x.Verb,
                IsAllowed = x.IsAllowed ?? false
            }).ToList();

            var permission = apiPermissions.FirstOrDefault(x => x.ControllerName.Equals(controllerName, StringComparison.InvariantCultureIgnoreCase)
                   && x.ActionName.Equals(actionName, StringComparison.InvariantCultureIgnoreCase)
                   && x.Verb.Equals(httpVerb, StringComparison.InvariantCultureIgnoreCase)
                   && x.IsAllowed);

            return (permission != null);
        }

        /// <summary>
        /// Method to get UserId validating with token against expiry and existence in database.
        /// </summary>
        /// <param name="authToken">Auth Token</param>
        /// <param name="expiresInSeconds">Token expiration time in seconds</param>
        /// <returns>UserId</returns>
        public int GetUserId(string authToken)
        {
            var token = _dbContext.UsersTokens.FirstOrDefault(t => t.AuthToken == authToken && t.ExpiresOn > DateTime.Now);
            if (token != null && token.UserId > 0)
                return token.UserId;
            return 0;
        }

        /// <summary>
        /// Public method to kill the user session and sign off.
        /// </summary>
        /// <param name="token">token</param>
        /// <param name="userAbrhs">userAbrhs</param>
        /// <returns>True/False</returns>
        public bool SignOff(string token, string userAbrhs)
        {
            var success = false;
            if (!string.IsNullOrEmpty(token) && !string.IsNullOrEmpty(userAbrhs))
            {
                var tokenUserId = GetUserId(token);
                var reqUserId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out reqUserId);

                if (reqUserId == tokenUserId)
                {
                    var sessionKilled = Kill(token);
                    //var loggedOff = CommonServices.LogActivity(reqUserId);
                    //if (sessionKilled && loggedOff)
                    if (sessionKilled)
                        success = true;
                }
            }
            return success;
        }

        /// <summary>
        /// Method to kill the provided token id.
        /// </summary>
        /// <param name="tokenId">true for successful delete</param>
        public bool Kill(string tokenId)
        {
            var deletableTokens = _dbContext.UsersTokens.Where(x => x.AuthToken == tokenId);
            if (deletableTokens.Any())
            {
                foreach (var toekn in deletableTokens)
                {
                    _dbContext.UsersTokens.Remove(toekn);
                }
                _dbContext.SaveChanges();
            }

            var isNotDeleted = _dbContext.UsersTokens.Select(x => x.AuthToken == tokenId).Any();
            if (isNotDeleted) { return false; }
            return true;
        }

        /// <summary>
        /// Delete tokens for the specific deleted user
        /// </summary>
        /// <param name="userId"></param>
        /// <returns>true for successful delete</returns>
        public bool DeleteTokensByUserId(int userId)
        {
            //Delete all tokens of a user for single sign-on
            var deletableTokens = _dbContext.UsersTokens.Where(x => x.UserId == userId);
            if (deletableTokens.Any())
            {
                foreach (var toekn in deletableTokens)
                {
                    _dbContext.UsersTokens.Remove(toekn);
                }
                _dbContext.SaveChanges();
            }

            var isNotDeleted = _dbContext.UsersTokens.Select(x => x.UserId == userId).Any();
            if (isNotDeleted) { return false; }
            return true;
        }

        #endregion
    }
}
