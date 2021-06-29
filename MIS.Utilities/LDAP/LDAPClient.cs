using MIS.BO;
using System;
using System.Configuration;
using System.DirectoryServices.Protocols;
using System.Net;
using System.Security.Cryptography;
using DS = System.DirectoryServices;

namespace MIS.Utilities
{
    public static class LDAPClient
    {
        static LdapConnection connection;
        static string domain;
        static string serviceUser;
        static string servicePassword;
        static string aDUrl;

        /// <summary>
        /// Initialize LDAP connection
        /// </summary>
        static LDAPClient()
        {
            domain = CryptoHelper.Decrypt(ConfigurationManager.AppSettings["DomainName"]);
            serviceUser = CryptoHelper.Decrypt(ConfigurationManager.AppSettings["ServiceUser"]);
            servicePassword = CryptoHelper.Decrypt(ConfigurationManager.AppSettings["ServicePassword"]);
            aDUrl = CryptoHelper.Decrypt(ConfigurationManager.AppSettings["ADServerUrl"]);

            var credentials = new NetworkCredential(serviceUser, servicePassword, domain);
            var serverId = new LdapDirectoryIdentifier(aDUrl);

            connection = new LdapConnection(serverId, credentials);
            connection.Bind();
        }

        /// <summary>
        /// Validate User 
        /// </summary>
        /// <param name="adUserName">ADUserName</param>
        /// <param name="password">Password</param>
        /// <returns>ResponseBO</returns>
        public static ResponseBO<bool> ValidateUser(string adUserName, string password)
        {
            var response = new ResponseBO<bool>() { IsSuccessful = false, Status = ResponseStatus.Error, StatusCode = HttpStatusCode.InternalServerError, Message = ResponseMessage.Error };

            var credentials = new NetworkCredential(adUserName, password);
            var serverId = new LdapDirectoryIdentifier(connection.SessionOptions.HostName);

            var conn = new LdapConnection(serverId, credentials);
            try
            {
                conn.Bind();
                response.IsSuccessful = true;
                response.Status = ResponseStatus.Success;
                response.StatusCode = HttpStatusCode.OK;
                response.Message = ResponseMessage.Success;
            }
            catch (Exception ex)
            {
                response.Message = (ex.InnerException != null && !string.IsNullOrEmpty(ex.InnerException.Message)) ? ex.InnerException.Message : ex.Message;
            }
            finally
            {
                conn.Dispose();
            }
            return response;
        }

        /// <summary>
        /// Change AD Password
        /// </summary>
        /// <param name="adUserName">ADUserName</param>
        /// <param name="currentADPassword">CurrentADPassword</param>
        /// <param name="newADPassword">NewADPassword</param>
        /// <returns>ResponseBO</returns>
        public static ResponseBO<bool> ChangePassword(string adUserName, string currentADPassword, string newADPassword)
        {
            var response = new ResponseBO<bool>() { IsSuccessful = false, Status = ResponseStatus.Error, StatusCode = HttpStatusCode.InternalServerError, Message = ResponseMessage.Error };
            try
            {
                var domainUser = String.Format("{0}\\{1}", domain, adUserName);
                DS.DirectoryEntry directionEntry = new DS.DirectoryEntry(GetLDAPPath(), domainUser, currentADPassword);
                if (directionEntry != null)
                {
                    DS.DirectorySearcher search = new DS.DirectorySearcher(directionEntry);
                    search.Filter = string.Format("(SAMAccountName={0})", adUserName);
                    DS.SearchResult result = search.FindOne();
                    if (result != null)
                    {
                        DS.DirectoryEntry userEntry = result.GetDirectoryEntry();
                        if (userEntry != null)
                        {
                            userEntry.Invoke("ChangePassword", new object[] { currentADPassword, newADPassword });
                            userEntry.CommitChanges();

                            response.IsSuccessful = true;
                            response.Status = ResponseStatus.Success;
                            response.StatusCode = HttpStatusCode.OK;
                            response.Message = ResponseMessage.Success;
                        }
                    }
                    else
                    {
                        response.Message = "AD User not found.";
                        response.StatusCode = HttpStatusCode.NotFound;
                    }
                }
                else
                {
                    response.Message = "LDAP Directory Entry not found.";
                    response.StatusCode = HttpStatusCode.NotFound;
                }
            }
            catch (Exception ex)
            {
                response.Message = (ex.InnerException != null && !string.IsNullOrEmpty(ex.InnerException.Message)) ? ex.InnerException.Message : ex.Message;
            }

            return response;
        }

        /// <summary>
        /// Get LDAP Path
        /// </summary>
        /// <returns></returns>
        static string GetLDAPPath()
        {
            var lDAPNodesSearchCriteria = CryptoHelper.Decrypt(ConfigurationManager.AppSettings["LDAPNodesSearchCriteria"]);
            string ldapPath = string.Format("LDAP://{0}/{1}", aDUrl, lDAPNodesSearchCriteria);
            return ldapPath;
        }
    }
}
