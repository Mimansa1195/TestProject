using MIS.BO;
using MIS.Utilities.Helpers;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Net;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;

namespace MIS.Utilities
{
    public static class CommonUtility
    {
        /// <summary>
        /// Generate random code
        /// </summary>
        /// <returns></returns>
        public static string GenerateRandomCode(int length)
        {
            try
            {
                string returnValue = string.Empty;
                var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
                var random = new Random();
                var result = new string(
                    Enumerable.Repeat(chars, length)
                              .Select(s => s[random.Next(s.Length)])
                              .ToArray());
                returnValue = result.ToString();
                return returnValue;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Method to convert image to base 64 string
        /// </summary>
        /// <param name="image">image</param>
        /// <param name="format">format</param>
        /// <returns>base 64 image string</returns>
        public static string ImageToBase64(Image image, ImageFormat format)
        {
            using (MemoryStream ms = new MemoryStream())
            {
                // Convert Image to byte[]
                image.Save(ms, format);
                byte[] imageBytes = ms.ToArray();

                // Convert byte[] to Base64 String
                string base64String = Convert.ToBase64String(imageBytes);
                return base64String;
            }
        }

        /// <summary>
        /// Method to convert base 64 string to image
        /// </summary>
        /// <param name="base64String">base64String</param>
        /// <returns></returns>
        public static Image Base64ToImage(string base64String)
        {
            // Convert Base64 String to byte[]
            byte[] imageBytes = Convert.FromBase64String(base64String);
            MemoryStream ms = new MemoryStream(imageBytes, 0,
              imageBytes.Length);

            // Convert byte[] to Image
            ms.Write(imageBytes, 0, imageBytes.Length);
            Image image = Image.FromStream(ms, true);
            return image;
        }

        /// <summary>
        /// Method to generate captcha
        /// </summary>
        /// <returns></returns>
        public static string GenerateCaptcha()
        {
            // Create a random code and store it in the Session object.
            var code = GenerateRandomCode(6);

            // Create a CAPTCHA image using the text stored in the Session object.
            ImageHelper ci = new ImageHelper(code, 300, 75);

            // Change the response headers to output a JPEG image.
            //this.Response.Clear();
            //this.Response.ContentType = "image/jpeg";
            // Write the image to the response stream in JPEG format.
            //ci.Image.Save(this.Response.OutputStream, ImageFormat.Jpeg);
            //// Dispose of the CAPTCHA image object.
            //ci.Dispose();

            //int height = 30;
            //int width = 100;
            //Bitmap bmp = new Bitmap(width, height);

            //RectangleF rectf = new RectangleF(10, 5, 0, 0);

            //Graphics g = Graphics.FromImage(bmp);
            //g.Clear(Color.White);
            //g.SmoothingMode = SmoothingMode.AntiAlias;
            //g.InterpolationMode = InterpolationMode.HighQualityBicubic;
            //g.PixelOffsetMode = PixelOffsetMode.HighQuality;
            //g.DrawString(Session["captcha"].ToString(), new Font("Thaoma", 12, FontStyle.Italic), Brushes.Green, rectf);
            //g.DrawRectangle(new Pen(Color.Red), 1, 1, width - 2, height - 2);
            //g.Flush();
            //Response.ContentType = "image/jpeg";
            //bmp.Save(Response.OutputStream, ImageFormat.Jpeg);
            //g.Dispose();
            //bmp.Dispose();

            return code;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="stringToEncrypt"></param>
        /// <returns></returns>
        internal static string EncryptTDC(string stringToEncrypt)
        {
            const string CRYPTO_KEY = "^J&P*X%W><:LPO&%^XW@~!@?";
            byte[] IV = new byte[16] { 12, 15, 105, 18, 89, 110, 17, 79, 05, 98, 87, 75, 49, 04, 55, 15 };
            byte[] inputBuffer = Encoding.UTF8.GetBytes(stringToEncrypt);

            AesManaged tDesProvider = new AesManaged();
            tDesProvider.IV = IV;
            tDesProvider.Key = UTF8Encoding.UTF8.GetBytes(CRYPTO_KEY);

            return Convert.ToBase64String(tDesProvider.CreateEncryptor().TransformFinalBlock(inputBuffer, 0, inputBuffer.Length));
        }

        /// <summary>
        /// Convert LINQ result to datatable
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="Linqlist"></param>
        /// <returns>DataTable</returns>
        public static System.Data.DataTable LINQResultToDataTable<T>(IEnumerable<T> Linqlist)
        {
            var dt = new System.Data.DataTable();

            System.Reflection.PropertyInfo[] columns = null;

            if (Linqlist == null) return dt;

            foreach (T Record in Linqlist)
            {
                if (columns == null)
                {
                    columns = ((Type)Record.GetType()).GetProperties();
                    foreach (System.Reflection.PropertyInfo GetProperty in columns)
                    {
                        Type colType = GetProperty.PropertyType;

                        if ((colType.IsGenericType) && (colType.GetGenericTypeDefinition() == typeof(Nullable<>)))
                            colType = colType.GetGenericArguments()[0];

                        dt.Columns.Add(new System.Data.DataColumn(GetProperty.Name, colType));
                    }
                }

                System.Data.DataRow dr = dt.NewRow();

                foreach (System.Reflection.PropertyInfo pinfo in columns)
                {
                    dr[pinfo.Name] = pinfo.GetValue(Record, null) == null ? DBNull.Value : pinfo.GetValue(Record, null);
                }

                dt.Rows.Add(dr);
            }
            return dt;
        }

        /// <summary>
        /// Static Method to return Mime Type in Base 64 format of a file extension
        /// </summary>
        /// <param name="Extension">File Extension</param>
        /// <returns></returns>
        public static string GetBase64MimeType(string extension)
        {
            var mimeType = GetMimeType(extension);
            return string.Format("{0}" + mimeType + "{1}", "data:", ";base64");
        }

        /// <summary>
        /// Static Method to return Mime Type of a file extension
        /// </summary>
        /// <param name="Extension">File Extension</param>
        /// <returns></returns>
        public static string GetMimeType(string Extension)
        {
            string mime = "application/octetstream";
            if (string.IsNullOrEmpty(Extension))
                return mime;

            Extension = Extension.Replace(".", "").ToLower();

            if (Extension == "apk")
                mime = "application/vnd.android.package-archive";
            else if (Extension == "docx")
                mime = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
            else if (Extension == "pdf")
                mime = "application/pdf";
            else if (Extension == "xls")
                mime = "application/vnd.ms-excel";
            else if (Extension == "xlsx")
                mime = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            else if (Extension == "doc")
                mime = "application/ms-word";
            else if (Extension == "jpg")
                mime = "image/jpeg";
            else if (Extension == "jpeg")
                mime = "image/jpeg";
            else if (Extension == "txt")
                mime = "text/plain";
            else if (Extension == "avi")
                mime = "video/x-msvideo";
            else if (Extension == "dif")
                mime = "video/x-dv";
            else if (Extension == "dv")
                mime = "video/x-dv";
            else if (Extension == "m4u")
                mime = "video/vnd.mpegurl";
            else if (Extension == "m4v")
                mime = "video/x-m4v";
            else if (Extension == "mov")
                mime = "video/quicktime";
            else if (Extension == "movie")
                mime = "video/x-sgi-movie";
            else if (Extension == "mp4")
                mime = "video/mp4";
            else if (Extension == "mpe")
                mime = "video/mpeg";
            else if (Extension == "mpeg")
                mime = "video/mpeg";
            else if (Extension == "mpg")
                mime = "video/mpeg";
            else if (Extension == "mxu")
                mime = "video/vnd.mpegurl";
            else if (Extension == "qt")
                mime = "video/quicktime";
            else if (Extension == "bmp")
                mime = "image/bmp";
            else if (Extension == "png")
                mime = "image/png";
            else if (Extension == "gif")
                mime = "image/gif";
            else
                mime = "application/octetstream";
            return mime;
        }

        #region Enums

        public static string GetEnumDescription<TEnum>(int value)
        {
            return GetEnumDescription((Enum)(object)((TEnum)(object)value));
        }

        /// <summary>
        /// Method to get enum description
        /// </summary>
        /// <param name="enumValue"></param>
        /// <param name="defDesc"></param>
        /// <returns></returns>
        public static string GetDescription(object enumValue, string defDesc)
        {
            FieldInfo fi = enumValue.GetType().GetField(enumValue.ToString());

            if (null != fi)
            {
                object[] attrs = fi.GetCustomAttributes(typeof(DescriptionAttribute), true);
                if (attrs != null && attrs.Length > 0)
                    return ((DescriptionAttribute)attrs[0]).Description;
            }

            return defDesc;
        }

        /// <summary>
        /// Method to get enum description
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static string GetEnumDescription(Enum value)
        {
            FieldInfo fi = value.GetType().GetField(value.ToString());

            DescriptionAttribute[] attributes =
                (DescriptionAttribute[])fi.GetCustomAttributes(
                typeof(DescriptionAttribute),
                false);

            if (attributes != null &&
                attributes.Length > 0)
                return attributes[0].Description;
            else
                return value.ToString();
        }

        /// <summary>
        /// Method to get Enum value
        /// </summary>
        /// <param name="enums"></param>
        /// <returns></returns>
        public static int GetEnumValue(Enum enums)
        {
            int enumVal = Convert.ToInt32(enums);
            return enumVal;
        }
        #endregion

        /// <summary>
        /// Method to validate API keys and tokens
        /// </summary>
        /// <typeparam name="T">Type</typeparam>
        /// <param name="data">Data</param>
        /// <param name="actualKeys">Actual Keys</param>
        /// <param name="matchKey">Match Key</param>
        /// <param name="actualToken">Actual Token</param>
        /// <param name="matchToken">Match Token</param>
        /// <param name="isEncryptedKey">isEncryptedKey</param>
        /// <param name="isEncryptedToken">isEncryptedToken</param>
        /// <returns>ResponseBO<T></returns>
        public static ResponseBO<T> ValidateAPIKeys<T>(this T data, string[] actualKeys, string matchKey, string[] actualToken, string matchToken, bool isEncryptedKey = false, bool isEncryptedToken = false)
        {
            var response = new ResponseBO<T>()
            {
                IsSuccessful = false,
                Status = ResponseStatus.Error,
                StatusCode = HttpStatusCode.InternalServerError,
                Message = ResponseMessage.Error
            };

            //try
            //{
            //    if (isEncryptedKey)
            //        matchKey = CryptoHelper.Decrypt(matchKey);

            //    if (isEncryptedToken)
            //        matchToken = CryptoHelper.Decrypt(matchToken);
            //}
            //catch (Exception)
            //{
            //    matchKey = string.Empty;
            //    matchToken = string.Empty;
            //}

            if (string.IsNullOrEmpty(matchKey) || string.IsNullOrEmpty(matchToken))
            {
                response.StatusCode = HttpStatusCode.BadRequest;
                response.Message = ResponseMessage.EmptyToken;
            }
            else if (!actualKeys.Contains(matchKey) || !actualToken.Contains(matchToken))
            {
                response.StatusCode = HttpStatusCode.BadRequest;
                response.Message = ResponseMessage.InvalidToken;
            }
            else
            {
                response.IsSuccessful = true;
                response.Status = ResponseStatus.Success;
                response.StatusCode = HttpStatusCode.OK;
                response.Message = ResponseMessage.Success;
            }
            return response;
        }
    }
}