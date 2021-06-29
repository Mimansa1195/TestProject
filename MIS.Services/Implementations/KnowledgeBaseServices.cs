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
    public class KnowledgeBaseServices : IKnowledgeBaseServices
    {
        private readonly IUserServices _userServices;

        public KnowledgeBaseServices(IUserServices userServices)
        {
            _userServices = userServices;
        }

        #region Document
        /// <summary>
        /// Get Shared Document By User
        /// </summary>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<BO.ShareDocumentInfo> GetSharedDocumentByToUser(string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                var sharedGroup = (from obj in context.SharedGroupDocuments
                                   join objgroup in context.DocumentPermissionGroupPermissions on obj.SharedGroupId equals
                                       objgroup.DocumentPermissionGroupId
                                   where objgroup.UserId == userId
                                   select new ShareDocumentInfo
                                   {
                                       UserId = obj.SharedById,
                                       DocId = obj.Document.DocId,
                                       Path = obj.Document.Path,
                                       Description = obj.Document.Description,
                                       //SharedBy = obj.User.UserName,
                                       Date = obj.DateCreated,
                                       Tags = obj.Document.Tags
                                   }).ToList();
                foreach (var users in sharedGroup)
                {
                    var sharedUserDetail = context.UserDetails.FirstOrDefault(a => a.UserId == users.UserId);
                    users.SharedBy = sharedUserDetail.FirstName + " " + sharedUserDetail.LastName;
                }

                var result = (from d in context.Documents
                              join s in context.ShareDocuments on d.DocId equals s.DocumentId
                              join u in context.Users.Where(x => x.IsActive) on s.ShareBy equals u.UserId
                              where s.ShareTo == userId && d.IsActive
                              orderby s.Date descending
                              select new BO.ShareDocumentInfo
                              {
                                  UserId = d.UserId,
                                  DocId = d.DocId,
                                  Path = d.Path,
                                  Description = d.Description,
                                  //SharedBy = u.UserName,
                                  Date = s.Date.Value.Year == 0001 ? DateTime.Now : s.Date,
                                  Tags = d.Tags
                              }).ToList();
                foreach (var users in result)
                {
                    var sharedUserDetail = context.UserDetails.FirstOrDefault(a => a.UserId == users.UserId);

                    users.SharedBy = sharedUserDetail.FirstName + " " + sharedUserDetail.LastName;
                }
                result.AddRange(sharedGroup);
                foreach (var r in result)
                {
                    string tagNames = string.Empty;
                    var tags = r.Tags.Split(',');
                    foreach (var tag in tags)
                    {
                        if (!string.IsNullOrEmpty(tag))
                        {
                            var tagId = Convert.ToInt32(tag.Trim());
                            var tagInfo = context.DocumentTags.FirstOrDefault(a => a.DocumentTagId == tagId);
                            if (tagInfo != null)
                            {
                                if (string.IsNullOrEmpty(tagNames))
                                {
                                    tagNames = tagInfo.Name;
                                }
                                else
                                {
                                    tagNames = tagNames + ", " + tagInfo.Name;
                                }
                            }
                        }
                    }
                    r.TagNames = tagNames;
                    r.ShowDate = r.Date.Value.ToString("dd-MMM-yyyy");
                    r.Path = (ConfigurationManager.AppSettings["UserDocumentPath"] + r.Path).Replace("\\", "\\\\");
                }

                result = result.GroupBy(t => t.DocId, (g, key) => key.First()).ToList();


                return result;
            }
        }

        /// <summary>
        /// Ge tDocument Groups By ParentId
        /// </summary>
        /// <param name="parentId"></param>
        /// <param name="currentUserId"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<BO.DocumentGroup> GetDocumentGroupsByParentId(int parentId, int currentUserId, string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                var group =
                    context.DocumentGroups.Where(
                        a => a.ParentId == parentId && a.DeleteFlag == false && a.UserID == userId)
                        .ToList();
                if (group.Count == 0)
                    return new List<BO.DocumentGroup>();
                return Convertor.Convert<BO.DocumentGroup, Model.DocumentGroup>(group);

            }
        }

        /// <summary>
        /// Get UserDetail By SharedDocId
        /// </summary>
        /// <param name="DocId"></param>
        /// <param name="currentUserId"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<BO.UserDetail> GetUserDetailBySharedDocId(int DocId, int currentUserId, string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                var shareToId =
                    context.ShareDocuments.Where(a => a.DocumentId == DocId && a.ShareBy == userId)
                        .Select(a => a.ShareTo)
                        .ToList();
                var result = (from u in context.UserDetails
                              where shareToId.Contains(u.UserId) && u.User.IsActive
                              select u)
                        .ToList();
                if (result.Count == 0)
                    return new List<BO.UserDetail>();
                return Convertor.Convert<BO.UserDetail, Model.UserDetail>(result);
            }
        }

        /// <summary>
        /// Get Document By GroupId
        /// </summary>
        /// <param name="groupId"></param>
        /// <param name="pageSize"></param>
        /// <param name="currentPage"></param>
        /// <param name="currentUserId"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<BO.documentsPaged> GetDocumentByGroupId(int groupId, int pageSize, int currentPage, int currentUserId, string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

                List<BO.documentsPaged> documentList;
                if (groupId > 0)
                    documentList = (from d in context.Documents
                                    where d.IsActive == true
                                    join g in context.DocumentGroups
                                        on d.GroupId equals g.DocGroupId
                                    where g.DocGroupId == groupId && g.DeleteFlag == false
                                    //  where g.DeleteFlag == false
                                    select new BO.documentsPaged()
                                    {
                                        DocId = d.DocId,
                                        Path = d.Path,
                                        Description = d.Description,
                                        GroupName = d.DocumentGroup.Name,
                                        Date = d.Date.Value.Year == 0001 ? DateTime.Now : d.Date,
                                    }).ToList();
                else
                    documentList = (from d in context.Documents
                                    where d.IsActive == true
                                    join g in context.DocumentGroups
                                        on d.GroupId equals g.DocGroupId
                                    where g.DeleteFlag == false && d.UserId == userId
                                    select new BO.documentsPaged()
                                    {
                                        DocId = d.DocId,
                                        Path = d.Path,
                                        Description = d.Description,
                                        GroupName = d.DocumentGroup.Name,
                                        Date = d.Date.Value.Year == 0001 ? DateTime.Now : d.Date,
                                    }).ToList();
                foreach (var r in documentList)
                {
                    r.ShowDate = r.Date.Value.ToString("dd-MMM-yyyy");
                    r.Path = (ConfigurationManager.AppSettings["UserDocumentPath"] + r.Path).Replace("\\", "\\\\");
                }

                if (documentList.Count == 0)
                    return new List<BO.documentsPaged>();
                return documentList;
            }
        }

        /// <summary>
        /// Get All Document Groups
        /// </summary>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<BO.DocumentGroup> GetAllDocumentGroups(string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var group = context.DocumentGroups.ToList();
                if (group.Count == 0)
                    return new List<BO.DocumentGroup>();
                return Convertor.Convert<BO.DocumentGroup, Model.DocumentGroup>(group);
            }
        }

        /// <summary>
        /// Get AllUsers To ShareDoc By DocId
        /// </summary>
        /// <param name="docId"></param>
        /// <param name="companyId"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<BO.UserDetail> GetAllUsersToShareDocByDocId(int docId, int companyLocationId, string userAbrhs)
        {
            using (var context = new MISEntities())
            {

                var sharedToUserId = context.ShareDocuments.Where(a => a.DocumentId == docId).Select(a => a.ShareTo).ToList();
                var result = (from u in context.UserDetails.Where(x => x.User.LocationId == companyLocationId && x.User.IsActive)
                              select u).
                        Except(from u in context.UserDetails.Where(y => y.User.IsActive)
                               where sharedToUserId.Contains(u.UserId)
                               select u).ToList();
                if (result.Count == 0)
                    return new List<BO.UserDetail>();
                return Convertor.Convert<BO.UserDetail, Model.UserDetail>(result);
            }
        }

        #region Doc Management

        /// <summary>
        /// Get AllDocument Tags
        /// </summary>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<BO.EmpsForSendMailSms> GetAllDocumentTags(string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                // var tagList = context.DocumentTags.ToList();
                var tags = context.DocumentTags.Select(documentTag => new BO.EmpsForSendMailSms
                {
                    id = (int)documentTag.DocumentTagId,
                    name = documentTag.Name
                }).ToList();


                return tags;
            }
        }

        /// <summary>
        /// Get All Document Permission Group
        /// </summary>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<BO.DocumentPermissionGroup> GetAllDocumentPermissionGroup(string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var group = context.DocumentPermissionGroups.OrderBy(a => a.Name).ToList();
                return Convertor.Convert<BO.DocumentPermissionGroup, Model.DocumentPermissionGroup>(@group);
            }
        }

        /// <summary>
        /// Get AllUser Except Own By PermissionGroupId
        /// </summary>
        /// <param name="groupId"></param>
        /// <param name="companyId"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<BO.UserDetail> GetAllUserExceptOwnByPermissionGroupId(int groupId, int companyLocationId, string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var sharedToUserId = context.DocumentPermissionGroupPermissions.Where(a => a.DocumentPermissionGroupId == groupId)
                        .Select(a => a.UserId)
                        .ToList();
                var result = (from u in context.UserDetails.Where(x => x.User.LocationId == companyLocationId && x.User.IsActive)
                              select u).
                        Except(from u in context.UserDetails.Where(x => x.User.IsActive)
                               where sharedToUserId.Contains(u.UserId)
                               select u).ToList();
                return Convertor.Convert<BO.UserDetail, Model.UserDetail>(result);
            }
        }

        /// <summary>
        /// Get AllUser By PermissionGroupId
        /// </summary>
        /// <param name="groupId"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<BO.UserDetail> GetAllUserByPermissionGroupId(int groupId, string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var sharedToUserId = context.DocumentPermissionGroupPermissions.Where(a => a.DocumentPermissionGroupId == groupId)
                        .Select(a => a.UserId).ToList();

                var result = (from u in context.UserDetails.Where(x => x.User.IsActive)
                              where sharedToUserId.Contains(u.UserId)
                              select u).ToList();
                return Convertor.Convert<BO.UserDetail, Model.UserDetail>(result);
            }
        }

        /// <summary>
        /// Get AllGroup Except Own By DocumentId
        /// </summary>
        /// <param name="documentId"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<BO.DocumentPermissionGroup> GetAllGroupExceptOwnByDocumentId(int documentId, string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var sharedToGroupId =
                    context.SharedGroupDocuments.Where(a => a.DocumentId == documentId)
                        .Select(a => a.SharedGroupId)
                        .ToList();
                var result = (from u in context.DocumentPermissionGroups select u).
                    Except(from u in context.DocumentPermissionGroups
                           where sharedToGroupId.Contains(u.DocumentPermissionGroupId)
                           select u).ToList();
                return Convertor.Convert<BO.DocumentPermissionGroup, Model.DocumentPermissionGroup>(result);
            }
        }

        /// <summary>
        /// Get All GroupBy DocumentId
        /// </summary>
        /// <param name="documentId"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<BO.DocumentPermissionGroup> GetAllGroupByDocumentId(int documentId, string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var sharedToGroupId =
                    context.SharedGroupDocuments.Where(a => a.DocumentId == documentId)
                        .Select(a => a.SharedGroupId)
                        .ToList();
                var result =
                    (from u in context.DocumentPermissionGroups
                     where sharedToGroupId.Contains(u.DocumentPermissionGroupId)
                     select u).ToList();
                return Convertor.Convert<BO.DocumentPermissionGroup, Model.DocumentPermissionGroup>(result);
            }
        }

        #endregion Doc Management

        #endregion Document

        #region Document CRUD

        /// <summary>
        /// Update Document Group
        /// </summary>
        /// <param name="docGroupObj"></param>
        /// <returns></returns>
        public bool UpdateDocumentGroup(BO.DocumentGroup docGroupObj)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(docGroupObj.UserAbrhs), out userId);

                Model.DocumentGroup obj =
                   context.DocumentGroups.Where(a => a.DocGroupId == docGroupObj.DocGroupId).FirstOrDefault();
                if (docGroupObj.action == "Delete")
                {
                    obj.DeleteFlag = true;
                }
                if (docGroupObj.action == "Rename")
                {
                    obj.Name = docGroupObj.Name;
                }
                if (docGroupObj.action == "Move")
                {
                    obj.ParentId = docGroupObj.ParentId;
                }
                context.SaveChanges();

                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.UpdateDocumentGroup, userId, 0);

                return true;
            }
        }

        /// <summary>
        /// Delete Document Group By GoupId
        /// </summary>
        /// <param name="groupId"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<string> DeleteDocumentGroupByGoupId(int groupId, string userAbrhs)
        {
            List<string> pathLst = new List<string>();
            List<int> groupIdLst = new List<int>();
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

                // var groupLst = context.GetAllChildsGroupByParentId(groupId).ToList();
                //foreach (var childDocumentGroup in groupLst)
                //{

                //    Model.DocumentGroup group =
                //       context.DocumentGroups.Where(a => a.DocGroupId == childDocumentGroup.GroupId).
                //          FirstOrDefault();
                //    group.DeleteFlag = true;
                //    var documentLst = (from d in context.Documents
                //                       where d.GroupId == childDocumentGroup.GroupId
                //                       select d).ToList();
                //    foreach (var d in documentLst)
                //    {
                //        d.DeleteFlag = 1;

                //        pathLst.Add(d.Path);

                //    }
                //}
                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.DeleteDocumentGroupByGoupId, userId, 0);

                context.SaveChanges();
                return pathLst;
            }
        }

        /// <summary>
        /// Delete Document
        /// </summary>
        /// <param name="documentId"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public bool DeleteDocument(int documentId, string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

                Model.Document obj = context.Documents.Where(a => a.DocId == documentId).FirstOrDefault();
                obj.IsActive = false;
                context.SaveChanges();

                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.DeleteDocument, userId, 0);

                return true;
            }
        }

        /// <summary>
        /// Save Group
        /// </summary>
        /// <param name="documentGroup"></param>
        /// <returns></returns>
        public int SaveGroup(BO.DocumentGroup documentGroup)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(documentGroup.UserAbrhs), out userId);
                documentGroup.UserID = userId;
                var document =
                   (from a in context.DocumentGroups
                    where
                       a.ParentId == documentGroup.ParentId && a.Name == documentGroup.Name && a.DeleteFlag == false &&
                       a.UserID == documentGroup.UserID
                    select a).FirstOrDefault();
                if (document == null)
                {
                    var obj = Convertor.Convert<Model.DocumentGroup, BO.DocumentGroup>(documentGroup);
                    context.DocumentGroups.Add(obj);
                    context.SaveChanges();

                    // Logging 
                    _userServices.SaveUserLogs(ActivityMessages.SaveGroup, userId, 0);

                    return obj.DocGroupId;
                }
                else
                {
                    var sr = 0;
                    //sr.Message = "Duplicate name  is not allowed.";
                    return sr;
                }

            }
        }

        /// <summary>
        /// Save Share Document
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public bool SaveShareDocument(BO.ShareDocument obj)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(obj.userAbrhs), out userId);
                obj.ShareBy = userId;
                obj.Date = DateTime.Now;
                Model.ShareDocument shareDocument = Convertor.Convert<Model.ShareDocument, BO.ShareDocument>(obj);
                context.ShareDocuments.Add(shareDocument);

                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.SaveShareDocument, userId, 0);

                context.SaveChanges();
                return true;
            }
        }

        /// <summary>
        /// Add New Document
        /// </summary>
        /// <param name="document"></param>
        /// <returns></returns>
        public bool AddNewDocument(BO.Document document)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(document.userAbrhs), out userId);
                document.UserId = userId;
                document.DeleteFlag = 0;
                document.Date = DateTime.Now;
                document.IsActive = true;
                var userdetail = context.UserDetails.FirstOrDefault(x => x.UserId == userId);
                var userName = userdetail.FirstName + "." + userdetail.LastName;
                // Select Folder Structure.
                string[] folderTree = new string[10];
                var folderId = document.GroupId;
                for (int i = 0; i < 10; i++)
                {
                    if (folderId != 0)
                    {
                        var folderDetails = context.DocumentGroups.FirstOrDefault(x => x.DocGroupId == folderId);
                        folderTree[i] = folderDetails.Name;
                        folderId = folderDetails.ParentId.Value;
                    }
                    else
                    {
                        break;
                    }
                }
                var folderPath = "";
                for (int i = folderTree.Length - 1; i >= 0; i--)
                {
                    if (folderTree[i] != null)
                    {
                        folderPath = folderPath + folderTree[i] + "\\";
                    }
                }


                if (document.FileBase64 != null)
                {
                    var filedetails = document.FileBase64.Split(',')[0];
                    var extn = filedetails.Replace("data:application/", "").Replace(";base64", "");//data:image/jpeg;base64 data:application/pdf;base64,
                    var FileName = Guid.NewGuid() + "." + extn;
                    var basePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["UserDocumentPath"] + userName + "\\" + folderPath;
                    if (!Directory.Exists(basePath))
                    {
                        Directory.CreateDirectory(basePath);
                    }
                    var pathwithFileName = basePath + document.Path;
                    byte[] decodedByteArray = Convert.FromBase64String(document.FileBase64.Split(',')[1]);
                    File.WriteAllBytes(pathwithFileName, decodedByteArray);
                    document.Path = userName + "\\" + folderPath + document.Path;
                }

                var existingDocument =
                    context.Documents.FirstOrDefault(
                        a => a.Description == document.Description && a.Path == document.Path && a.IsActive);
                if (existingDocument == null)
                {
                    context.Documents.Add(Convertor.Convert<Model.Document, BO.Document>(document));
                    context.SaveChanges();

                    // Logging 
                    _userServices.SaveUserLogs(ActivityMessages.AddNewDocument, userId, 0);

                    return true;
                }

               

                return true;
            }
        }

        /// <summary>
        /// Update Document
        /// </summary>
        /// <param name="document"></param>
        /// <returns></returns>
        public bool UpdateDocument(BO.Document document)
        {
            using (var context = new MISEntities())
            {

                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(document.userAbrhs), out userId);
                document.UserId = userId;
                document.DeleteFlag = 0;
                document.Date = DateTime.Now;
                var userdetail = context.UserDetails.FirstOrDefault(x => x.UserId == userId);
                var userName = userdetail.FirstName + "." + userdetail.LastName;
                // Select Folder Structure.
                string[] folderTree = new string[10];
                // Select Folder Id
                var groupId = context.Documents.FirstOrDefault(x => x.DocId == document.DocId).GroupId;
                var folderId = groupId;
                for (int i = 0; i < 10; i++)
                {
                    if (folderId != 0)
                    {
                        var folderDetails = context.DocumentGroups.FirstOrDefault(x => x.DocGroupId == folderId);
                        folderTree[i] = folderDetails.Name;
                        folderId = folderDetails.ParentId.Value;
                    }
                    else
                    {
                        break;
                    }
                }
                var folderPath = "";
                for (int i = folderTree.Length - 1; i >= 0; i--)
                {
                    if (folderTree[i] != null)
                    {
                        folderPath = folderPath + folderTree[i] + "\\";
                    }
                }


                if (document.FileBase64 != null)
                {
                    var filedetails = document.FileBase64.Split(',')[0];
                    var extn = filedetails.Replace("data:application/", "").Replace(";base64", "");//data:image/jpeg;base64 data:application/pdf;base64,
                    var FileName = Guid.NewGuid() + "." + extn;
                    var basePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["UserDocumentPath"] + userName + "\\" + folderPath;
                    if (!Directory.Exists(basePath))
                    {
                        Directory.CreateDirectory(basePath);
                    }
                    var pathwithFileName = basePath + document.Path;
                    byte[] decodedByteArray = Convert.FromBase64String(document.FileBase64.Split(',')[1]);
                    File.WriteAllBytes(pathwithFileName, decodedByteArray);
                    document.Path = userName + "\\" + folderPath + document.Path;
                }

                Model.Document obj = context.Documents.Where(a => a.DocId == document.DocId).FirstOrDefault();
                if (document.action == "rename")
                {
                    obj.Description = document.Description;
                }
                else
                {
                    obj.Description = document.Description;
                    obj.Path = document.Path;

                }

                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.UpdateDocument, userId, 0);

                context.SaveChanges();
                return true;
            }
        }

        /// <summary>
        /// Delete User From Share Document ByUserId
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="docId"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public bool DeleteUserFromShareDocumentByUserId(int userId, int docId, string userAbrhs)
        {
            using (var context = new MISEntities())
            {

                var LoginuserId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out LoginuserId);

                var result =
                   (from s in context.ShareDocuments where s.ShareTo == userId && s.DocumentId == docId select s)
                      .FirstOrDefault();
                context.ShareDocuments.Remove(result);
                context.SaveChanges();

                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.DeleteUserFromShareDocumentByUserId, LoginuserId, userId);

                return true;
            }
        }

        #region Doc Management

        /// <summary>
        /// Add Document Tag
        /// </summary>
        /// <param name="tagName"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public BO.EmpsForSendMailSms AddDocumentTag(string tagName, string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

                var newObj = new Model.DocumentTag
                {
                    Name = tagName
                };
                var existingTag = context.DocumentTags.FirstOrDefault(a => a.Name == tagName);
                if (existingTag == null)
                {
                    context.DocumentTags.Add(newObj);
                    context.SaveChanges();
                }
                var returningObj = new BO.EmpsForSendMailSms
                {
                    id = (int)newObj.DocumentTagId,
                    name = tagName
                };

                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.AddDocumentTag, userId, 0);

                return returningObj;
            }
        }

        /// <summary>
        /// Save Document PermissionGroup
        /// </summary>
        /// <param name="permissionGroup"></param>
        /// <returns></returns>
        public bool SaveDocumentPermissionGroup(BO.DocumentPermissionGroup permissionGroup)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(permissionGroup.userAbrhs), out userId);
                permissionGroup.CreatedByUserId = userId;
                permissionGroup.Name = permissionGroup.Name.Trim();
                var group = context.DocumentPermissionGroups.FirstOrDefault(a => a.Name == permissionGroup.Name);
                if (group != null)
                {
                    return true;
                }
                //var permissionGroupModel =
                //   Convertor.Convert<DocumentPermissionGroup, BO.DocumentPermissionGroup>(permissionGroup);
                var docGroup = new Model.DocumentPermissionGroup
                {
                    CreatedByUserId = permissionGroup.CreatedByUserId,
                    Name = permissionGroup.Name
                };
                context.DocumentPermissionGroups.Add(docGroup);

                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.SaveDocumentPermissionGroup, userId, 0);

                context.SaveChanges();
                return true;
            }
        }

        /// <summary>
        /// Save Document PermissionGroup Permissions
        /// </summary>
        /// <param name="permission"></param>
        /// <returns></returns>
        public bool SaveDocumentPermissionGroupPermissions(BO.DocumentPermissionGroupPermission permission)
        {
            using (var context = new MISEntities())
            {

                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(permission.userAbrhs), out userId);

                var groupPermission = Convertor.Convert<Model.DocumentPermissionGroupPermission, BO.DocumentPermissionGroupPermission>(
                      permission);
                context.DocumentPermissionGroupPermissions.Add(groupPermission);
                context.SaveChanges();

                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.SaveDocumentPermissionGroupPermissions, userId, 0);

                return true;
            }
        }

        /// <summary>
        /// Save Shared Group Document
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public bool SaveSharedGroupDocument(BO.SharedGroupDocument obj)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(obj.userAbrhs), out userId);
                obj.SharedById = userId;
                obj.DateCreated = DateTime.Now;
                obj.IsDeleted = false;
                var docObj = Convertor.Convert<Model.SharedGroupDocument, BO.SharedGroupDocument>(obj);
                context.SharedGroupDocuments.Add(docObj);
                context.SaveChanges();

                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.SaveSharedGroupDocument, userId, 0);

                return true;
            }
        }

        /// <summary>
        /// Delete User From Permission Group By UserId
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="groupId"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public bool DeleteUserFromPermissionGroupByUserId(int userId, int groupId, string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var loginuserId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out loginuserId);

                var result =
                   context.DocumentPermissionGroupPermissions.FirstOrDefault(
                      s => s.UserId == userId && s.DocumentPermissionGroupId == groupId);
                context.DocumentPermissionGroupPermissions.Remove(result);
                context.SaveChanges();

                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.DeleteUserFromPermissionGroupByUserId, loginuserId, userId);

                return true;
            }
        }

        /// <summary>
        /// Delete Group From Shared GroupBy GroupId
        /// </summary>
        /// <param name="groupId"></param>
        /// <param name="docId"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public bool DeleteGroupFromSharedGroupByGroupId(int groupId, int docId, string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

                var result = context.SharedGroupDocuments.FirstOrDefault(s => s.SharedGroupId == groupId && s.DocumentId == docId);
                context.SharedGroupDocuments.Remove(result);
                context.SaveChanges();

                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.DeleteGroupFromSharedGroupByGroupId, userId, 0);

                return true;
            }
        }

        #endregion

        #endregion Document

    }
}
