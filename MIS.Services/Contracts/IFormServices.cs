using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MIS.BO;

namespace MIS.Services.Contracts
{
    public interface IFormServices
    {
        List<FormBO> GetAllForms();

        List<FormBO> GetAllActiveForms(string basePath, string departmentAbrhs);

        bool ChangeFormStatus(int formId, int status, string userAbrhs);//status = 1:activate, 2:deactivate, 3:delete

        int AddForm(string formDepatmentAbrhs, string formTitle, string formName, string base64FormData, string userAbrhs, string basePath); //1: success, 2:failure, 3:form with same name already exists

        string FetchFormInformation(string basePath, int formId);

        List<UserFormBO> GetAllMyForms(int loginUserId);

        int UploadUserForm(int formId, int loginUserId, string employeeAbrhs, string formName, string base64FormData);

        bool ChangeUsersFormStatus(string userFormAbrhs, int loginUserId, int employeeId, int status);
        
        List<UserFormBO> GetAllUserForms(int loginUserId, int formId);

        string FetchUserForm(int loginUserId, string userFormAbrhs);

        string FetchAllUserForms(int loginUserId, int formId);
        

        string FetchOrganizationStructurePdf(string basePath);
    }
}
