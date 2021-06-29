using System.Security.Principal;

namespace MIS.API.Filters
{
    /// <summary>
    /// Basic Authentication identity
    /// </summary>
    public class BasicAuthenticationIdentity : GenericIdentity
    {
        /// <summary>
        /// Get/Set for UserId
        /// </summary>
        public int UserId { get; set; }

        /// <summary>
        /// Get/Set for UserAbrhs
        /// </summary>
        public string UserAbrhs { get; set; }

        /// <summary>
        /// Get/Set for UserName
        /// </summary>
        public string UserName { get; set; }

        /// <summary>
        /// Get/Set for password
        /// </summary>
        public string Password { get; set; }

        /// <summary>
        /// Get/Set for BrowserInfo
        /// </summary>
        public string BrowserInfo { get; set; }

        /// <summary>
        /// Get/Set for ClientInfo
        /// </summary>
        public string ClientInfo { get; set; }

        /// <summary>
        /// Basic Authentication Identity Constructor
        /// </summary>
        /// <param name="userName">UserName</param>
        /// <param name="password">Password</param>
        /// <param name="browserInfo">browserInfo</param>
        /// <param name="clientInfo">clientInfo</param>
        public BasicAuthenticationIdentity(string userName, string password, string browserInfo, string clientInfo)
            : base(userName, "Basic")
        {
            Password = password;
            UserName = userName;
            BrowserInfo = browserInfo;
            ClientInfo = clientInfo;
        }
    }
}