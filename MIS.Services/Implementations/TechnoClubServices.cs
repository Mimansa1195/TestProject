using MIS.BO;
using MIS.Model;
using MIS.Services.Contracts;
using MIS.Utilities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace MIS.Services.Implementations
{
    public class TechnoClubServices : ITechnoClubServices
    {
        public TechnoClubServices(IUserServices userServices)
        {
            _userServices = userServices;
        }
        #region Private member variables

        private readonly MISEntities _dbContext = new MISEntities();
        private readonly IUserServices _userServices;
        #endregion
        public List<BaseDropDown> GetGSOCProjects()
        {
            var result = new List<BaseDropDown>();
            var data = _dbContext.GSOCProjects.Where(x => x.IsActive).ToList();
            foreach (var temp in data)
            {
                result.Add(new BaseDropDown
                {
                    Text = temp.ProjectName,
                    Value = temp.GSOCProjectId
                });
            }
            return result.OrderBy(t => t.Text).ToList();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="subsciption"></param>
        /// <param name="userAbrhs"></param>
        /// <returns>1: , 2: </returns>
        public int SubscribeForGSOCProject(int projectId, string title, string fileName, string base64FormData, string userAbrhs)
        {
            if (projectId > 0 && !String.IsNullOrEmpty(base64FormData) && !String.IsNullOrEmpty(fileName))
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

                //check if form already uploaded.
                var checkExist = _dbContext.GSOCProjectSubscribers.Where(x => x.UserId == userId && x.GSOCProjectId == projectId && x.IsActive).ToList();
                var userDetail = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == userId).EmployeeId;
                if (checkExist.Any())
                {
                    return 2; //Already exist
                }

                var basePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["TechnoClubSubscriberUploadPath"] + "\\";
                if (!Directory.Exists(basePath))
                {
                    Directory.CreateDirectory(basePath);
                }

                byte[] decodedByteArray = Convert.FromBase64String(base64FormData.Split(',')[1]);
                var extsn = Path.GetExtension(fileName);
                var file = Path.GetFileNameWithoutExtension(fileName);
                var actualFileName = fileName;
                var filePath = basePath + fileName;
                if (!string.IsNullOrEmpty(userDetail))
                {
                    actualFileName = file + "_" + userDetail + extsn;
                    filePath = basePath + file + "_" + userDetail + extsn;
                }

                File.WriteAllBytes(filePath, decodedByteArray);

                var subsciptionModal = new GSOCProjectSubscriber()
                {
                    GSOCProjectId = projectId,
                    ProjectTitle = title,
                    UserId = userId,
                    FilePath = actualFileName,
                    IsActive = true,
                    CreatedDate = DateTime.Now,
                    CreatedById = userId
                };

                _dbContext.GSOCProjectSubscribers.Add(subsciptionModal);
                _dbContext.SaveChanges();
                _userServices.SaveUserLogs(ActivityMessages.SubscribedGSOCProject, userId, 0);
                return 1;
            }
            return 0;
        }

        public List<GSOCProjectBO> GetUserWiseSubscribedProjects(string userAbrhs)
        {
            List<GSOCProjectBO> SubscribedProjectsList = new List<GSOCProjectBO>();
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            if (userId > 0)
            {
                var projectDetail = _dbContext.GSOCProjectSubscribers.Where(x => x.UserId == userId).ToList();
                if (projectDetail.Any())
                {
                    foreach (var item in projectDetail)
                    {
                        GSOCProjectBO projectList = new GSOCProjectBO();
                        projectList.GSOCProjectSubscriberId = item.GSOCProjectSubscriberId;
                        projectList.Title = item.ProjectTitle;
                        projectList.FilePath = item.FilePath;
                        projectList.Status = item.IsActive && item.IsApproved ? "Approved" : !item.IsActive ? "Cancelled" : "Submitted";
                        //if (projectInfo != null)
                        //{
                        //    projectList.ProjectName = projectInfo.ProjectName;
                        //    projectList.Description = projectInfo.Description;
                        //    if (!string.IsNullOrEmpty(projectInfo.FilePath))
                        //        projectList.FilePath = projectInfo.FilePath;
                        //}
                        projectList.SubscribedOn = item.CreatedDate;
                        SubscribedProjectsList.Add(projectList);
                    }
                }

                _userServices.SaveUserLogs(ActivityMessages.VisitedGSOCSubscriptionUrl, userId, 0);
                return SubscribedProjectsList;
            }
            return SubscribedProjectsList;
        }

        public string ViewProjectPdf(string basePath, string fileName)
        {
            var finalBasePath = basePath + "\\" + fileName;
            FileInfo fi = new FileInfo(finalBasePath);
            if (!File.Exists(finalBasePath))
                return string.Empty;
            byte[] formInByte = File.ReadAllBytes(finalBasePath);
            var formInBase64String = Convert.ToBase64String(formInByte);
            var fileExtension = fi.Extension;//fileName.Split('.')[1];
            var link = "";
            link = CommonUtility.GetBase64MimeType(fileExtension) + "," + formInBase64String;
            return link;
        }

        public GSOCProjectBO GetProjectDetails(int projectId)
        {
            GSOCProjectBO projectList = new GSOCProjectBO();
            var projectDetail = _dbContext.GSOCProjects.FirstOrDefault(x => x.GSOCProjectId == projectId);
            if (projectDetail != null)
            {
                if (projectDetail.ProjectName != "Others")
                {
                    projectList.FilePath = projectDetail.FilePath;
                    projectList.ProjectName = projectDetail.ProjectName;
                    projectList.Description = projectDetail.Description;

                }
            }
            return projectList;
        }

        public string FetchUploadedDocument(string filePath, string basePath)
        {
            if (string.IsNullOrEmpty(filePath))
                return string.Empty;
            if (!File.Exists((basePath + "\\" + filePath)))
                return string.Empty;

            var formInByte = File.ReadAllBytes((basePath + "\\" + filePath));
            var formInBase64String = Convert.ToBase64String(formInByte);
            FileInfo fi = new FileInfo(filePath);
            var fileExtension = fi.Extension;//file.FormName.Split('.').Last();
            var link = CommonUtility.GetBase64MimeType(fileExtension) + "," + formInBase64String;
            return link;
        }

        public bool ChangeSubscriptionStatus(int gsocSubscriptionId, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var detail = _dbContext.GSOCProjectSubscribers.FirstOrDefault(x => x.GSOCProjectSubscriberId == gsocSubscriptionId);
            if (detail != null)
            {
                detail.IsActive = false;
                detail.ModifiedById = userId;
                detail.ModifiedDate = DateTime.Now;
                _dbContext.SaveChanges();
                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.UnsubscribedGSOCProject, userId, 0);

                return true;
            }
            return false;
        }
    }
}
