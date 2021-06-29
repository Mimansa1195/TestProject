using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MIS.Services.Contracts;
using MIS.Model;
using MIS.BO;
using MIS.Utilities;
using System.IO;
using System.IO.Compression;
using System.Configuration;
using System.Web;

namespace MIS.Services.Implementations
{
    public class FormServices : IFormServices
    {
        private readonly IUserServices _userServices;

        public FormServices(IUserServices userServices)
        {
            _userServices = userServices;
        }

        #region Private member variables

        public readonly MISEntities _dbContext = new MISEntities();

        #endregion

        #region Forms
        public List<FormBO> GetAllForms()
        {
            var result = new List<FormBO>();
            var data = _dbContext.spGetAllForms().ToList();
            foreach (var temp in data)
            {
                result.Add(new FormBO
                {
                    FormId = temp.FormId,
                    FormTitle = temp.FormTitle,
                    FormName = temp.FormName,
                    DepartmentName = temp.DepartmentName,
                    IsActive = temp.IsActive,
                    Status = temp.IsActive == true ? "Active" : "Inactive",
                });
            }
            return result;
        }

        public List<FormBO> GetAllActiveForms(string basePath, string departmentAbrhs)
        {
            var departmentId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(departmentAbrhs), out departmentId);
            var result = new List<FormBO>();
            var data = _dbContext.spGetAllActiveForms(departmentId).ToList();
            foreach (var temp in data)
            {
                result.Add(new FormBO
                {
                    FormId = temp.FormId,
                    FormTitle = temp.FormTitle,
                    FormName = temp.FormName,
                    DepartmentName = temp.DepartmentName,
                    FilePath = (basePath + temp.FormName),
                });
            }
            return result;
        }

        public bool ChangeFormStatus(int formId, int status, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var result = _dbContext.spChangeFormStatus(formId, status, userId).FirstOrDefault();

            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.ChangeFormStatus, userId, 0);

            return result.Value;
        }

        public int AddForm(string formDepatmentAbrhs, string formTitle, string formName, string base64FormData, string userAbrhs, string basePath) //1: success, 2:failure, 3:form with same name already exists
        {
            if (!CheckIfSimilarFormNameExists(formName))
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                var departmentId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(formDepatmentAbrhs), out departmentId);
                byte[] decodedByteArray = Convert.FromBase64String(base64FormData.Split(',')[1]);

                //string filePath = ConfigurationManager.AppSettings["DocumentUploadPath"] + formName;
                File.WriteAllBytes(basePath, decodedByteArray);

                var result = _dbContext.spAddNewForm(departmentId, formTitle, formName, userId).FirstOrDefault();

                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.AddForm, userId, 0);

                if (result == true)
                    return 1;
                else
                    return 2;
            }
            else
                return 3;
        }

        public string FetchFormInformation(string basePath, int formId)
        {
            var fileName = _dbContext.Forms.FirstOrDefault(x => x.FormId == formId).FormName;
            var finalBasePath = basePath + fileName;
            if (!File.Exists(finalBasePath))
                return string.Empty;

            byte[] formInByte = File.ReadAllBytes(finalBasePath);
            var formInBase64String = Convert.ToBase64String(formInByte);

            var fileExtension = fileName.Split('.')[1];
            var base64Data = "";
            base64Data = CommonUtility.GetBase64MimeType(fileExtension) + "," + formInBase64String;
            return base64Data;
        }

        private bool CheckIfSimilarFormNameExists(string formName)
        {
            var result = _dbContext.Forms.FirstOrDefault(x => !x.IsDeleted && x.FormName == formName);
            if (result == null)
                return false;
            else
                return true;
        }
        #endregion

        #region Upload and download employee form
        /// <summary>
        /// Get all my uploaded forms
        /// </summary>
        /// <param name="loginUserAbrhs"></param>
        /// <returns></returns>
        public List<UserFormBO> GetAllMyForms(int loginUserId)
        {
            if (!(loginUserId > 0))
                return new List<UserFormBO>();

            var result = (from uf in _dbContext.UserForms.Where(x => !x.IsDeleted && x.UserId == loginUserId).AsEnumerable()
                          join f in _dbContext.Forms on uf.FormId equals f.FormId into list1
                          from l1 in list1.DefaultIfEmpty()
                          orderby uf.CreatedDate descending, uf.FormName
                          select new UserFormBO
                          {
                              UserFormAbrhs = CryptoHelper.Encrypt(uf.UserFormId.ToString()),
                              FormId = uf.FormId,
                              ActualFormName = l1.FormName,
                              UsersFormName = uf.FormName,
                              FormPath = uf.FormPath,
                              IsActive = uf.IsActive,
                              IsDeleted = uf.IsDeleted,
                              Status = uf.IsActive == true ? "Active" : "Inactive",
                              CreatedDate = uf.CreatedDate
                          }).ToList();

            return result ?? new List<UserFormBO>();
        }

        /// <summary>
        /// Method to upload user form
        /// </summary>
        /// <param name="formId"></param>
        /// <param name="loginUserId"></param>
        /// <param name="employeeId"></param>
        /// <param name="formName"></param>
        /// <param name="base64FormData"></param>
        /// <returns>0: failed, 1: success, 2:All Required fields needed, 3: Already exist</returns>
        public int UploadUserForm(int formId, int loginUserId, string employeeAbrhs, string formName, string base64FormData)
        {
            if (formId > 0 && loginUserId > 0 && !String.IsNullOrEmpty(employeeAbrhs) && !String.IsNullOrEmpty(base64FormData))
            {
                var employeeId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(employeeAbrhs), out employeeId);

                //check if form already uploaded.
                var formExists = _dbContext.UserForms.Where(x => x.IsActive && !x.IsDeleted && x.FormId == formId && x.UserId == employeeId);

                if (formExists.Any())
                {
                    return 3; //Already exist
                }

                var basePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["UserDocumentPath"] + employeeAbrhs.Trim() + "\\";
                if (!Directory.Exists(basePath))
                {
                    Directory.CreateDirectory(basePath);
                }

                byte[] decodedByteArray = Convert.FromBase64String(base64FormData.Split(',')[1]);

                var filePath = basePath + formName;
                File.WriteAllBytes(filePath, decodedByteArray);

                var usersFormData = new UserForm()
                {
                    FormId = formId,
                    UserId = employeeId,
                    FormName = formName,
                    FormPath = formName,
                    IsActive = true,
                    IsDeleted = false,
                    CreatedDate = DateTime.Now,
                    CreatedById = loginUserId
                };

                _dbContext.UserForms.Add(usersFormData);
                _dbContext.SaveChanges();

                // Logging 
                var msg = string.Format(ActivityMessages.UserFormStatus, "uploaded");
                _userServices.SaveUserLogs(msg, loginUserId, employeeId);

                if (usersFormData.UserFormId > 0)
                    return 1; //success
                else
                    return 0; // error occurred
            }
            else
                return 2;
        }

        /// <summary>
        /// Activate/Deactivate/Delete user form
        /// </summary>
        /// <param name="formId"></param>
        /// <param name="loginUserAbrhs"></param>
        /// <param name="employeeAbrhs"></param>
        /// <param name="status">1:activate, 2:deactivate, 3:delete</param>
        /// <returns>True/False</returns>
        public bool ChangeUsersFormStatus(string userFormAbrhs, int loginUserId, int employeeId, int status)
        {
            if (!string.IsNullOrEmpty(userFormAbrhs) && !(loginUserId > 0) && (employeeId > 0) && !(status > 0))
                return false;

            var userFormId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userFormAbrhs), out userFormId);

            var existingForm = _dbContext.UserForms.Where(x => x.UserFormId == userFormId && x.UserId == employeeId).FirstOrDefault();

            if (existingForm != null)
            {
                var fileStatus = (status == 1 ? "activated" : (status == 2 ? "deactivated" : "deleted"));
                //Rename Form in file system
                var basePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["UserDocumentPath"];
                var oldFilePath = (basePath + CryptoHelper.Encrypt(existingForm.UserId.ToString()).Trim() + "\\");
                var oldFile = (oldFilePath + existingForm.FormName);
                var timeStamp = string.Format("{0:dd-MM-yyyy_hh-mm-ss-tt}", DateTime.Now);
                var newFileName = existingForm.FormName;

                if (File.Exists(oldFile))
                {
                    var existingFile = new FileInfo(oldFile);
                    newFileName = string.Format("{0}_{1}_{2}{3}", (Path.GetFileNameWithoutExtension(existingFile.Name)), fileStatus, timeStamp, existingFile.Extension);
                    var newFile = (oldFilePath + newFileName);
                    File.Copy(oldFile, newFile, true);
                    File.Delete(oldFile);
                }

                existingForm.IsActive = (status == 1) ? true : false;
                if (existingForm.UserId == employeeId)
                    existingForm.IsDeleted = (status == 3) ? true : false;
                existingForm.ModifiedDate = DateTime.Now;
                existingForm.ModifiedById = loginUserId;
                existingForm.FormName = newFileName;
                _dbContext.SaveChanges();

                // Logging 
                var msg = string.Format(ActivityMessages.UserFormStatus, fileStatus);
                _userServices.SaveUserLogs(msg, loginUserId, employeeId);
            }

            return true;
        }

        /// <summary>
        /// Get all users uploaded form except achievemet form
        /// </summary>
        /// <param name="loginUserId"></param>
        /// <param name="formId"></param>
        /// <returns></returns>
        public List<UserFormBO> GetAllUserForms(int loginUserId, int formId)
        {
            if (!(loginUserId > 0))
                return new List<UserFormBO>();
            var usersForm = _dbContext.UserForms.Where(x => x.IsActive && !x.IsDeleted);

            if (formId > 0)
                usersForm = usersForm.Where(x => x.FormId == formId);

            var result = (from uf in usersForm.ToList()
                          join f in _dbContext.Forms on uf.FormId equals f.FormId into list1
                          from l1 in list1.DefaultIfEmpty()
                          join u in _dbContext.UserDetails.Where(x => x.TerminateDate == null) on uf.UserId equals u.UserId
                          orderby uf.CreatedDate descending, u.FirstName
                          //where l1.FormId != (int)Enums.Forms.EmployeeAchievementForm
                          select new UserFormBO
                          {
                              UserFormAbrhs = CryptoHelper.Encrypt(uf.UserFormId.ToString()),
                              FormId = uf.FormId,
                              EmployeeName = ((u.FirstName ?? "") + " " + (u.MiddleName == null ? "" : u.MiddleName + " ") + (u.LastName ?? "")),
                              ActualFormName = l1.FormName == null ? "" : l1.FormName,
                              UsersFormName = uf.FormName,
                              FormPath = uf.FormPath,
                              IsActive = uf.IsActive,
                              IsDeleted = uf.IsDeleted,
                              Status = uf.IsActive == true ? "Active" : "Inactive",
                              CreatedDate = uf.CreatedDate
                          }).ToList();

            return result ?? new List<UserFormBO>();
        }

        /// <summary>
        /// Fetch or download employee form
        /// </summary>
        /// <param name="loginUserId"></param>
        /// <param name="userFormAbrhs"></param>
        /// <returns></returns>
        public string FetchUserForm(int loginUserId, string userFormAbrhs)
        {
            if (!(loginUserId > 0) && string.IsNullOrEmpty(userFormAbrhs))
                return string.Empty;

            var userFormId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userFormAbrhs), out userFormId);

            var basePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["UserDocumentPath"];

            var file = _dbContext.UserForms.FirstOrDefault(x => x.UserFormId == userFormId && !x.IsDeleted); //&& x.IsActive 

            if (file == null || !File.Exists((basePath + CryptoHelper.Encrypt(file.UserId.ToString()).Trim() + "\\" + file.FormName)))
                return string.Empty;

            var formInByte = File.ReadAllBytes((basePath + CryptoHelper.Encrypt(file.UserId.ToString()).Trim() + "\\" + file.FormName));
            var formInBase64String = Convert.ToBase64String(formInByte);

            var fileExtension = file.FormName.Split('.').Last();
            var link = CommonUtility.GetBase64MimeType(fileExtension) + "," + formInBase64String;
            return link;
        }

        /// <summary>
        /// Fetch or download all employees form
        /// </summary>
        /// <param name="loginUserId"></param>
        /// <param name="formId"></param>
        /// <returns></returns>
        public string FetchAllUserForms(int loginUserId, int formId)
        {
            if (!(loginUserId > 0) && !(formId > 0))
                return string.Empty;
            var usersForms = _dbContext.UserForms.Where(x => x.IsActive && !x.IsDeleted && x.FormId == formId).ToList();

            var usersFormsData = (from uf in usersForms
                                  join f in _dbContext.Forms on uf.FormId equals f.FormId into list1
                                  from l1 in list1.DefaultIfEmpty()
                                  join u in _dbContext.UserDetails.Where(x => x.TerminateDate == null) on uf.UserId equals u.UserId
                                  select new UserFormBO
                                  {
                                      UserFormAbrhs = CryptoHelper.Encrypt(uf.UserFormId.ToString()),
                                      EmployeeAbrhs = CryptoHelper.Encrypt(uf.UserId.ToString()),
                                      FormId = uf.FormId,
                                      EmployeeName = ((u.FirstName ?? "") + " " + (u.MiddleName == null ? "" : u.MiddleName + " ") + (u.LastName ?? "")),
                                      ActualFormName = l1.FormName == null ? "" : l1.FormName,
                                      UsersFormName = uf.FormName,
                                      FormName = uf.FormName,
                                      //FormPath = uf.FormPath,
                                      //IsActive = uf.IsActive,
                                      //IsDeleted = uf.IsDeleted,
                                      //Status = uf.IsActive == true ? "Active" : "Inactive",
                                      //CreatedDate = uf.CreatedDate
                                  }).ToList();

            var basePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["UserDocumentPath"];
            //var formPaths = new List<String>();

            var zipFileName = "Forms.zip";
            var zipPath = basePath + "ZipFiles\\" + zipFileName;

            var fileP = new System.IO.FileInfo(zipPath);
            fileP.Directory.Create(); // If directory not exists, this method creates directory otherwise does nothing.

            if (File.Exists(zipPath))
                File.Delete(zipPath);

            ZipArchive zip = ZipFile.Open(zipPath, ZipArchiveMode.Create);
            foreach (var file in usersFormsData)
            {
                var filePath = basePath + file.EmployeeAbrhs + "\\" + file.FormName;
                if (!File.Exists(filePath)) continue;
                zip.CreateEntryFromFile(filePath, file.UsersFormName); //, CompressionLevel.Optimal
            }
            zip.Dispose();
            return zipPath; //File(zipPath, "application/zip", zipFileName);
        }

        #endregion

        #region Organization Structure
        public string FetchOrganizationStructurePdf(string basePath)
        {
            var fileName = "GeminiOrgChart.pdf";
            var finalBasePath = basePath + fileName;
            if (!File.Exists(finalBasePath))
                return string.Empty;

            //byte[] formInByte = File.ReadAllBytes(finalBasePath);
            //var formInBase64String = Convert.ToBase64String(formInByte);

            //var fileExtension = fileName.Split('.')[1];
            //var link = "";
            //link = CommonUtility.GetBase64MimeType(fileExtension) + "," + formInBase64String;
            //return link;
            return fileName;
        }
        #endregion
    }
}