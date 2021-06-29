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
using System.Configuration;

namespace MIS.Services.Implementations
{
    public class PolicyServices : IPolicyServices
    {
        private readonly IUserServices _userServices;

        public PolicyServices(IUserServices userServices)
        {
            _userServices = userServices;
        }

        #region Private member variables

        public readonly MISEntities _dbContext = new MISEntities();

        #endregion

        public List<PolicyBO> GetAllPolicies()
        {
            var result = _dbContext.Policies.Where(x => !x.IsDeleted).Select(x => new PolicyBO
                {
                    PolicyId = x.PolicyId,
                    PolicyTitle = x.PolicyTitle,
                    PolicyName = x.PolicyName,
                    IsActive = x.IsActive,
                    Status = x.IsActive == true ? "Active" : "Inactive",
                }).ToList();
            return result ?? new List<PolicyBO>();
        }

        public List<PolicyBO> GetAllActivePolicies(string basePath)
        {
            var result = new List<PolicyBO>();
            var data = _dbContext.Policies.Where(x => x.IsActive).ToList();
            foreach (var temp in data)
            {
                result.Add(new PolicyBO
                {
                    PolicyId = temp.PolicyId,
                    PolicyTitle = temp.PolicyTitle,
                    PolicyName = temp.PolicyName,
                    //FilePath = (basePath + temp.PolicyName),
                });
            }
            return result;
        }

        public bool ChangePolicyStatus(int policyId, int status, string userAbrhs)//status = 1:activate, 2:deactivate, 3:delete
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var result = _dbContext.Policies.FirstOrDefault(x => x.PolicyId == policyId);
            if (result != null)
            {
                switch (status)
                {
                    case 1:
                        result.IsActive = true;
                        break;
                    case 2:
                        result.IsActive = false;
                        break;
                    case 3:
                        result.IsActive = false;
                        result.IsDeleted = true;
                        break;
                }
                result.LastModifiedDate = DateTime.Now;
                result.LastModifiedBy = userId;
                _dbContext.SaveChanges();

                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.ChangePolicyStatus, userId, 0);
                return true;
            }
            return false;
        }

        public bool AddPolicy(string policyTitle, string policyName, string base64FormData, string userAbrhs, string basePath) //1: success, 2:failure, 3:policy with same name already exists
        {
            if (!CheckIfSimilarPolicyNameExists(policyName))
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

                _dbContext.Policies.Add(new Model.Policy
                {
                    PolicyTitle = policyTitle,
                    PolicyName = policyName,
                    IsActive = true,
                    IsDeleted = false,
                    CreatedDate = DateTime.Now,
                    CreatedBy = userId,
                });

                byte[] decodedByteArray = Convert.FromBase64String(base64FormData.Split(',')[1]);

                File.WriteAllBytes(basePath, decodedByteArray);

                _userServices.SaveUserLogs(ActivityMessages.AddPolicy, userId, 0);

                _dbContext.SaveChanges();
                return true;
            }
            else
                return false;
        }

        public string FetchPolicyInformation(string basePath, int policyId)
        {
            var fileName = _dbContext.Policies.FirstOrDefault(x => x.PolicyId == policyId && !x.IsDeleted).PolicyName;
            //var finalBasePath = basePath + fileName;
            //if (!File.Exists(finalBasePath))
            //    return string.Empty;

            //byte[] policyInByte = File.ReadAllBytes(finalBasePath);
            //var policyInBase64String = Convert.ToBase64String(policyInByte);

            //var fileExtension = fileName.Split('.')[1];
            //var base64String = CommonUtility.GetBase64MimeType(fileExtension) + "," + policyInBase64String;
            return fileName;
        }

        private bool CheckIfSimilarPolicyNameExists(string policyName)
        {
            var result = _dbContext.Policies.FirstOrDefault(x => !x.IsDeleted && x.PolicyName == policyName);
            if (result == null)
                return false;
            else
                return true;
        }
    }
}
