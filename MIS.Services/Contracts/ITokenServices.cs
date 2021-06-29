using MIS.BO;
using System;

namespace MIS.Services.Contracts
{
    public interface ITokenServices
    {
        #region Interface member methods.
        /// <summary>
        ///  Function to generate unique token with expiry against the provided userId.
        ///  Also add a record in database for generated token.
        /// </summary>
        /// <param name="userId">UserId</param>
        /// <param name="expiresInSeconds">Token expiration time in seconds</param>
        /// <returns>Token Entity</returns>
        TokenBO GenerateToken(int userId, double expiresInSeconds);

        /// <summary>
        /// Method to validate token against expiry and existence in database.
        /// </summary>
        /// <param name="userAbrhs">UserAbrhs</param>
        /// <param name="tokenId">Auth Token</param>
        /// <param name="expiresInSeconds">Token expiration time in seconds</param>
        /// <returns>True/False</returns>
        bool ValidateToken(string userAbrhs, string tokenId, double expiresInSeconds);

        /// <summary>
        /// Method to validate api permission for user.
        /// </summary>
        /// <param name="token">token</param>
        /// <param name="expiresInSeconds">ExpiresInSeconds</param>
        /// <param name="controllerName">ControllerName</param>
        /// <param name="actionName">ActionName</param>
        /// <param name="httpVerb">HttpVerb</param>
        /// <returns>True/False</returns>
        bool ValidateApi(string token, Int64 expiresInSeconds, string controllerName, string actionName, string httpVerb);

        /// <summary>
        /// Method to get UserId validating with token against expiry and existence in database.
        /// </summary>
        /// <param name="authToken">Auth Token</param>
        /// <param name="expiresInSeconds">Token expiration time in seconds</param>
        /// <returns>UserId</returns>
        int GetUserId(string authToken);

        /// <summary>
        /// Public method to kill the user session and sign off.
        /// </summary>
        /// <param name="token">token</param>
        /// <param name="userAbrhs">userAbrhs</param>
        /// <returns>True/False</returns>
        bool SignOff(string token, string userAbrhs);

        /// <summary>
        /// Method to kill the provided token id.
        /// </summary>
        /// <param name="tokenId"></param>
        bool Kill(string tokenId);

        /// <summary>
        /// Delete tokens for the specific deleted user
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        bool DeleteTokensByUserId(int userId);
        #endregion
    }
}
