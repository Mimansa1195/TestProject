using MIS.BO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MIS.Services.Contracts
{
    public interface IPolicyServices
    {
        List<PolicyBO> GetAllPolicies();

        List<PolicyBO> GetAllActivePolicies(string basePath);

        bool ChangePolicyStatus(int policyId, int status, string userAbrhs);//status = 1:activate, 2:deactivate, 3:delete

        bool AddPolicy(string policyTitle, string policyName, string base64PolicyData, string userAbrhs, string basePath);

        string FetchPolicyInformation(string basePath, int policyId);
    }
}
