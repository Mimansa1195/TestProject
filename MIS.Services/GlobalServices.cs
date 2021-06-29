using MIS.BO;
using MIS.Model;
using System;
using System.Data.Entity.Core.Objects;
using System.Configuration;
using MIS.Utilities;
using System.Net;

namespace MIS.Services
{
    public static class GlobalServices
    {
        #region Error Log
        /// <summary>
        /// private method to log error
        /// </summary>
        /// <param name="moduleName"></param>
        /// <param name="ex"></param>
        /// <param name="controllerName"></param>
        /// <param name="actionName"></param>
        /// <param name="loginUserId"></param>
        /// <param name="authToken"></param>
        /// <returns>ErrorId</returns>
        private static long LogError(string moduleName, Exception ex, string controllerName, string actionName, int loginUserId, string authToken) //string iPAddress,
        {
            var errorId = 0L;
            var error = new ErrorLogBO
            {
                ModuleName = moduleName,
                Source = ex.Source,
                ControllerName = controllerName,
                ActionName = actionName,
                ErrorType = ex.GetType() != null ? ex.GetType().Name : "",
                ErrorMessage = ex.InnerException == null ? ex.Message : ex.InnerException.Message,
                TargetSite = ex.TargetSite != null ? ex.TargetSite.Name : "",
                StackTrace = ex.StackTrace,
                ReportedByUserId = loginUserId,
                CreatedDate = DateTime.Now
            };
            using (var context = new MISEntities())
            {
                var result = new ObjectParameter("ErrorId", typeof(Int64));
                context.spInsertErrorLog(error.ModuleName, error.Source, error.ErrorType, error.ErrorMessage,
                    error.ControllerName, error.ActionName, error.TargetSite, error.StackTrace, error.ReportedByUserId, authToken, result);

                Int64.TryParse(result.Value.ToString(), out errorId);
                return errorId;
            }
        }

        /// <summary>
        ///  public method to log error
        /// </summary>
        /// <param name="ex"></param>
        /// <param name="controllerName"></param>
        /// <param name="actionName"></param>
        /// <param name="loginUserId"></param>
        /// <param name="authToken"></param>
        /// <returns>ErrorId</returns>
        public static long LogError(Exception ex, string controllerName, string actionName, int loginUserId, string authToken)
        {
            return LogError("MIS", ex, controllerName, actionName, loginUserId, authToken);
        }

        /// <summary>
        /// public method to log error
        /// </summary>
        /// <param name="ex"></param>
        /// <param name="loginUserId"></param>
        /// <param name="authToken"></param>
        /// <returns>ErrorId</returns>
        public static long LogError(Exception ex, int loginUserId, string authToken)
        {
            return LogError(ex, "", "", loginUserId, authToken);
        }

        /// <summary>
        /// public method to log error
        /// </summary>
        /// <param name="ex"></param>
        /// <returns>ErrorId</returns>
        public static long LogError(Exception ex)
        {
            return LogError(ex, 0, "");
        }
        #endregion

        #region App Settings

        /// <summary>
        /// Public method to get applicatiion buld version
        /// </summary>
        /// <returns></returns>
        public static string GetBuildVersion()
        {
            return ConfigurationManager.AppSettings["BuildVersion"] ?? DateTime.Now.ToTimestamp();
        }
        #endregion

        #region Get JSON Configurations

        //public static dynamic GetConfigData(string configKey)
        //{
        //    var configFilePath = ConfigurationManager.AppSettings["ConfigFile"];
        //    if (!File.Exists(configFilePath))
        //        throw new Exception("Configuration file is missing.");

        //    var configData = File.ReadAllBytes(configFilePath);


        //}

        #endregion

        #region External Response

        /// <summary>
        /// Get external URL response.
        /// </summary>
        public static HttpWebResponseResult GetExternal(string url)
        {
            var getRequest = (HttpWebRequest)WebRequest.Create(url);
            HttpStatusCode statuscode;
            try
            {

                var getResponse = (HttpWebResponse)getRequest.GetResponse();
                statuscode = getResponse.StatusCode;

                return new HttpWebResponseResult(getResponse);
            }
            catch (WebException ex)
            {
                HttpWebResponse httpResponse = (HttpWebResponse)ex.Response;
                return new HttpWebResponseResult(httpResponse);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        #endregion
    }
}