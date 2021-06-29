using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MIS.Services.Contracts
{
    public interface IKnowledgeBaseServices
    {
        #region Document

        List<BO.ShareDocumentInfo> GetSharedDocumentByToUser(string userAbrhs);

        List<BO.DocumentGroup> GetDocumentGroupsByParentId(int parentId, int userId, string userAbrhs);

        List<BO.UserDetail> GetUserDetailBySharedDocId(int DocId, int currentUserId, string userAbrhs);

        List<BO.documentsPaged> GetDocumentByGroupId(int groupId, int pageSize, int currentPage, int currentUserId, string userAbrhs);

        List<BO.DocumentGroup> GetAllDocumentGroups(string userAbrhs);

        //List<BO.UserDetail> GetAllUsersToShareDocByDocId(int docId, int companyId, string userAbrhs);
        List<BO.UserDetail> GetAllUsersToShareDocByDocId(int docId, int companyLocationId, string userAbrhs);

        #region Doc Management

        List<BO.EmpsForSendMailSms> GetAllDocumentTags(string userAbrhs);

        List<BO.DocumentPermissionGroup> GetAllDocumentPermissionGroup(string userAbrhs);

        //List<BO.UserDetail> GetAllUserExceptOwnByPermissionGroupId(int groupId, int companyId, string userAbrhs);
        List<BO.UserDetail> GetAllUserExceptOwnByPermissionGroupId(int groupId, int companyLocationId, string userAbrhs);

        List<BO.UserDetail> GetAllUserByPermissionGroupId(int groupId, string userAbrhs);

        List<BO.DocumentPermissionGroup> GetAllGroupExceptOwnByDocumentId(int documentId, string userAbrhs);

        List<BO.DocumentPermissionGroup> GetAllGroupByDocumentId(int documentId, string userAbrhs);

        #endregion Doc Management

        #endregion Document

        #region Document CRUD

        bool UpdateDocumentGroup(BO.DocumentGroup docGroupObj);

        List<string> DeleteDocumentGroupByGoupId(int groupId, string userAbrhs);

        bool DeleteDocument(int documentId, string userAbrhs);

        int SaveGroup(BO.DocumentGroup documentGroup);

        bool SaveShareDocument(BO.ShareDocument obj);

        bool AddNewDocument(BO.Document document);

        bool UpdateDocument(BO.Document document);

        bool DeleteUserFromShareDocumentByUserId(int userId, int docId, string userAbrhs);


        #region Doc Management

        BO.EmpsForSendMailSms AddDocumentTag(string tagName, string userAbrhs);

        bool SaveDocumentPermissionGroup(BO.DocumentPermissionGroup permissionGroup);

        bool SaveDocumentPermissionGroupPermissions(BO.DocumentPermissionGroupPermission permission);

        bool SaveSharedGroupDocument(BO.SharedGroupDocument obj);

        bool DeleteUserFromPermissionGroupByUserId(int userId, int groupId, string userAbrhs);

        bool DeleteGroupFromSharedGroupByGroupId(int groupId, int docId, string userAbrhs);

        #endregion

        #endregion Document

    }
}
