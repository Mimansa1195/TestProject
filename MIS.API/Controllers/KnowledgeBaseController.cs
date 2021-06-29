using MIS.Services.Contracts;
using System;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace MIS.API.Controllers
{
    public class KnowledgeBaseController : BaseApiController
    {
        private readonly IKnowledgeBaseServices _knowledgeBaseServices;

        public KnowledgeBaseController(IKnowledgeBaseServices knowledgeBaseServices)
        {
            _knowledgeBaseServices = knowledgeBaseServices;
        }

        [HttpPost]
        public HttpResponseMessage GetSharedDocumentByToUser(string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _knowledgeBaseServices.GetSharedDocumentByToUser(userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetDocumentGroupsByParentId(int parentId, int userId, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _knowledgeBaseServices.GetDocumentGroupsByParentId(parentId, userId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetUserDetailBySharedDocId(int DocId, int currentUserId, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _knowledgeBaseServices.GetUserDetailBySharedDocId(DocId, currentUserId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetDocumentByGroupId(int groupId, int pageSize, int currentPage, int currentUserId, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _knowledgeBaseServices.GetDocumentByGroupId(groupId, pageSize, currentPage, currentUserId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetAllDocumentGroups(string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _knowledgeBaseServices.GetAllDocumentGroups(userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetAllUsersToShareDocByDocId(int docId, int companyLocationId, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _knowledgeBaseServices.GetAllUsersToShareDocByDocId(docId, companyLocationId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetAllDocumentPermissionGroup(string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _knowledgeBaseServices.GetAllDocumentPermissionGroup(userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetAllUserExceptOwnByPermissionGroupId(int groupId, int companyLocationId, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _knowledgeBaseServices.GetAllUserExceptOwnByPermissionGroupId(groupId, companyLocationId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetAllUserByPermissionGroupId(int groupId, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _knowledgeBaseServices.GetAllUserByPermissionGroupId(groupId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetAllGroupExceptOwnByDocumentId(int documentId, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _knowledgeBaseServices.GetAllGroupExceptOwnByDocumentId(documentId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetAllGroupByDocumentId(int documentId, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _knowledgeBaseServices.GetAllGroupByDocumentId(documentId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetAllDocumentTags(string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _knowledgeBaseServices.GetAllDocumentTags(userAbrhs));
        }

        #region Document CRUD

        [HttpPost]
        public HttpResponseMessage UpdateDocumentGroup(BO.DocumentGroup docGroupObj)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _knowledgeBaseServices.UpdateDocumentGroup(docGroupObj));
        }

        [HttpPost]
        public HttpResponseMessage DeleteDocumentGroupByGoupId(int groupId, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _knowledgeBaseServices.DeleteDocumentGroupByGoupId(groupId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage DeleteDocument(int documentId, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _knowledgeBaseServices.DeleteDocument(documentId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage SaveGroup(BO.DocumentGroup documentGroup)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _knowledgeBaseServices.SaveGroup(documentGroup));
        }

        [HttpPost]
        public HttpResponseMessage SaveShareDocument(BO.ShareDocument obj)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _knowledgeBaseServices.SaveShareDocument(obj));
        }

        [HttpPost]
        public HttpResponseMessage AddNewDocument(BO.Document document)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _knowledgeBaseServices.AddNewDocument(document));
        }

        [HttpPost]
        public HttpResponseMessage UpdateDocument(BO.Document document)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _knowledgeBaseServices.UpdateDocument(document));
        }

        [HttpPost]
        public HttpResponseMessage DeleteUserFromShareDocumentByUserId(int userId, int docId, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _knowledgeBaseServices.DeleteUserFromShareDocumentByUserId(userId, docId, userAbrhs));
        }
        #region Doc Management

        [HttpPost]
        public HttpResponseMessage AddDocumentTag(string tagName, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _knowledgeBaseServices.AddDocumentTag(tagName, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage SaveDocumentPermissionGroup(BO.DocumentPermissionGroup permissionGroup)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _knowledgeBaseServices.SaveDocumentPermissionGroup(permissionGroup));
        }

        [HttpPost]
        public HttpResponseMessage SaveDocumentPermissionGroupPermissions(BO.DocumentPermissionGroupPermission permission)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _knowledgeBaseServices.SaveDocumentPermissionGroupPermissions(permission));
        }

        [HttpPost]
        public HttpResponseMessage SaveSharedGroupDocument(BO.SharedGroupDocument obj)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _knowledgeBaseServices.SaveSharedGroupDocument(obj));
        }

        [HttpPost]
        public HttpResponseMessage DeleteUserFromPermissionGroupByUserId(int userId, int groupId, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _knowledgeBaseServices.DeleteUserFromPermissionGroupByUserId(userId, groupId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage DeleteGroupFromSharedGroupByGroupId(int groupId, int docId, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _knowledgeBaseServices.DeleteGroupFromSharedGroupByGroupId(groupId, docId, userAbrhs));
        }

        #endregion

        #endregion Document
    }
}
