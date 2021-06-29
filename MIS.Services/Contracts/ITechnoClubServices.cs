using MIS.BO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MIS.Services.Contracts
{
    public interface ITechnoClubServices
    {
        List<BaseDropDown> GetGSOCProjects();

        int SubscribeForGSOCProject(int projectId,string title, string fileName, string base64FormData, string userAbrhs);

        List<GSOCProjectBO> GetUserWiseSubscribedProjects(string userAbrhs);

        string ViewProjectPdf(string basePath, string fileName);

        GSOCProjectBO GetProjectDetails(int projectId);

        string FetchUploadedDocument(string filePath, string basePath);

        bool ChangeSubscriptionStatus(int gsocSubscriptionId, string userAbrhs);

    }
}
