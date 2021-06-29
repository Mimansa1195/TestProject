using Microsoft.Practices.EnterpriseLibrary.Security;
using System.Configuration;

namespace MIS.Utilities
{
    public class CryptoHelper
    {
        private static readonly string CRYPTO_KEY = ConfigurationManager.AppSettings["EncDecKey"];

        /// <summary>
        /// Decrypt Method
        /// </summary>
        /// <param name="stringToDecrypt"></param>
        /// <returns></returns>
        public static string Decrypt(string stringToDecrypt)
        {
            return SecurityHelper.Decrypt(stringToDecrypt, CRYPTO_KEY);
        }

        /// <summary>
        /// Verify Password
        /// </summary>
        /// <param name="encryptedPassword"></param>
        /// <param name="plainPassword"></param>
        /// <returns>True/False</returns>
        public static bool VerifyPassword(string encryptedPassword, string plainPassword)
        {
#if DEBUG
            return Encrypt(plainPassword) == encryptedPassword;
#else
            return SecurityHelper.VerifyPassword(encryptedPassword, plainPassword);
#endif
        }

        /// <summary>
        /// Encrypt Method
        /// </summary>
        /// <param name="stringToEncrypt"></param>
        /// <returns></returns>
        public static string Encrypt(string stringToEncrypt)
        {
            return SecurityHelper.Encrypt(stringToEncrypt, CRYPTO_KEY);
        }

        /// <summary>
        /// Encrypt Method
        /// </summary>
        /// <param name="stringToEncrypt"></param>
        /// <returns></returns>
        public static string EncryptTDC(string stringToEncrypt)
        {
#if DEBUG
            return Encrypt(stringToEncrypt);
#else
            return SecurityHelper.EncryptTDC(stringToEncrypt);
#endif
        }

        /// <summary>
        /// Encrypt Method
        /// </summary>
        /// <param name="stringToEncrypt"></param>
        /// <returns></returns>
        public static string EncryptTRC(string stringToEncrypt)
        {
#if DEBUG
            return SecurityHelper.Encrypt(stringToEncrypt, CRYPTO_KEY);
#else
            return SecurityHelper.EncryptTRC(stringToEncrypt);
#endif
        }

        /// <summary>
        /// Decrypt Method
        /// </summary>
        /// <param name="stringToDecrypt"></param>
        /// <returns></returns>
        public static string DecryptTRC(string stringToDecrypt)
        {
#if DEBUG
            return SecurityHelper.Decrypt(stringToDecrypt, CRYPTO_KEY);
#else
            return SecurityHelper.DecryptTRC(stringToDecrypt);
#endif
        }
    }
}
