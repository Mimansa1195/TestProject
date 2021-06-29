using System;
using System.Collections.Generic;
using System.Linq;
using MIS.Services.Contracts;
using MIS.BO;
using MIS.Utilities;
using System.Data.Entity.Core.Objects;
using MIS.Model;
using System.Globalization;

namespace MIS.Services.Implementations
{
    public class AccessCardServices : IAccessCardServices
    {
        private readonly IUserServices _userServices;

        public AccessCardServices(IUserServices userServices)
        {
            _userServices = userServices;
        }

        #region Private member variables

        private readonly MISEntities _dbContext = new MISEntities();

        #endregion

        #region AccessCard

        public List<AccessCardDataBO> GetAllAccessCards()
        {
            var result = _dbContext.spFetchAllAccessCards().ToList();
            if (result.Any())
            {
                List<AccessCardDataBO> list = new List<AccessCardDataBO>();
                foreach (var data in result)
                {
                    AccessCardDataBO temp = new AccessCardDataBO()
                    {
                        AccessCardId = data.AccessCardId,
                        AccessCardNo = data.AccessCardNo,
                        IsPimcoCard = data.IsPimco,
                        IsTemporaryCard = data.IsTemporary,
                        IsActive = data.IsActive,
                        Status = data.IsActive ? "Active" : "Inactive",
                        IsMapped = data.IsMapped,
                        EmployeeName= data.EmployeeName
                    };

                    list.Add(temp);
                }
                return list;
            }
            else
                return null;
        }

        public int ChangeAccessCardState(int accessCardId, int state, string userAbrhs) //result: 1-success, 2- user mapping with card exists, 0-failure
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var result = _dbContext.spChangeAccessCardState(accessCardId, state, userId).FirstOrDefault();

            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.ChangeAccessCardState, userId, 0);

            return result.Value;
        }

        public int AddAccessCard(string cardNo, bool isPimcoCard, bool isTemporaryCard, string userAbrhs) //result: 1-success, 2-card already exists, 0-failure
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var result = _dbContext.spAddAccessCard(cardNo, isPimcoCard, isTemporaryCard, userId).FirstOrDefault();

            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.AddAccessCard, userId, 0);

            return result.Value;
        }

        #endregion

        #region UserCardMapping

        public List<UserAccessCardDataBO> GetAllUserCardMapping()
        {
            var result = _dbContext.spFetchAllUserAccessCardMappings().ToList();
            if (result.Any())
            {
                List<UserAccessCardDataBO> list = new List<UserAccessCardDataBO>();
                foreach (var data in result)
                {
                    UserAccessCardDataBO temp = new UserAccessCardDataBO()
                    {
                        UserCardMappingId = data.UserCardMappingId,
                        AccessCardId = data.AccessCardId,
                        AccessCardNo = data.AccessCardNo,
                        EmployeeName = data.EmployeeName,
                        UserId = data.UserId.HasValue ? data.UserId.Value : 0,
                        EmployeeId = data.EmployeeId,
                        IsPimcoUserCardMapping = data.IsPimcoUserCardMapping,
                        IsFinalised = data.IsFinalised,
                        AssignedFrom = data.AssignedFrom,
                        AssignedOn = data.AssignedOn,
                        CreatedBy=data.CreatedBy,
                        AssignedDate = data.AssignedDate,
                        AssignedDateNew = data.AssignedDate.Value.ToString("MM/dd/yyyy",CultureInfo.InvariantCulture),
                        Status = data.IsFinalised ? "Finalised" : "Not Finalised"
                    };
                    list.Add(temp);
                }
                return list;
            }
            else
                return null;
        }

        public List<UserUnMappedCardDataBO> GetAllUserCardUnMappedHistory()
        {
            var result = _dbContext.Proc_GetAllUserUnMappedCardHistory().ToList();
            if (result.Any())
            {
                List<UserUnMappedCardDataBO> list = new List<UserUnMappedCardDataBO>();
                foreach (var data in result)
                {
                    UserUnMappedCardDataBO temp = new UserUnMappedCardDataBO()
                    {
                        UserCardMappingId = data.UserCardMappingId,
                        AccessCardId = data.AccessCardId,
                        AccessCardNo = data.AccessCardNo,
                        EmployeeName = data.EmployeeName,
                        UserId = data.UserId.HasValue ? data.UserId.Value : 0,
                        EmployeeId = data.EmployeeId,
                        AssignedFrom = data.AssignedFrom,
                        AssignedOn = data.AssignedOn,
                        AssignedTill = data.AssignedTill,
                        DeActivatedOn = data.DeActivatedOn,
                        DeActivatedBy = data.DeActivatedBy,
                        IsPimcoUserCardMapping = data.IsPimcoUserCardMapping,
                        IsFinalised = data.IsFinalised,
                        CreatedBy = data.CreatedBy,
                       
                        Status = data.IsFinalised ? "Finalised" : "Not Finalised"
                    };
                    list.Add(temp);
                }
                return list;
            }
            else
                return new List<UserUnMappedCardDataBO>();
        }

        public List<EmployeeBO> GetAllUnmappedUser()
        {
            var result = _dbContext.spFetchAllUnmappedUserToAccessCard().ToList();
            if (result.Any())
            {
                List<EmployeeBO> list = new List<EmployeeBO>();
                foreach (var data in result)
                {
                    EmployeeBO temp = new EmployeeBO()
                    {
                        //EmployeeId = data.UserId,
                        EmployeeAbrhs = CryptoHelper.Encrypt(data.UserId.ToString()),
                        EmployeeName = data.EmployeeName,
                        JoiningDate=data.JoiningDate
                    };

                    list.Add(temp);
                }
                return list;
            }
            else
                return null;
        }

        public List<EmployeeBO> GetAllUnmappedStaff()
        {
            var result = _dbContext.Proc_FetchAllUnmappedStaffToAccessCard().ToList();
            if (result.Any())
            {
                List<EmployeeBO> list = new List<EmployeeBO>();
                foreach (var data in result)
                {
                    EmployeeBO temp = new EmployeeBO()
                    {
                        //EmployeeId = data.UserId,
                        StaffAbrhs = CryptoHelper.Encrypt(data.StaffUserId.ToString()),
                        StaffName = data.StaffName,
                    };

                    list.Add(temp);
                }
                return list;
            }
            else
                return null;
        }

        public List<CommonEntitiesBO> GetAllUnmappedAccessCard()
        {
            var result = _dbContext.spFetchAllUnmappedAccessCard().ToList();
            if (result.Any())
            {
                List<CommonEntitiesBO> list = new List<CommonEntitiesBO>();
                foreach (var data in result)
                {
                    CommonEntitiesBO temp = new CommonEntitiesBO()
                    {
                        Id = data.CardId,
                        EntityName = data.CardNo,
                    };

                    list.Add(temp);
                }
                return list;
            }
            else
                return null;
        }

        public UserAccessCardMappingBO GetUserCardMappingInfoById(int userCardMappingId)
        {
            var result = _dbContext.spFetchUserCardMappingInfoById(userCardMappingId).FirstOrDefault();
            if (result != null)
            {
                UserAccessCardMappingBO temp = new UserAccessCardMappingBO();
                temp.UserId = result.UserId;
                temp.EmployeeName = result.EmployeeName;
                temp.AccessCardId = result.AccessCardId;
                temp.AccessCardNo = result.AccessCardNo;
                temp.IsPimcoUserCardMapping = result.IsPimcoUserCardMapping;
                return temp;
            }
            else
                return null;
        }

        public int DeleteUserCardMapping(int userCardMappingId, string userAbrhs, DateTime aasignedTill)
        {
            var userId = 0;
            int status = 0;

            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            var result = new ObjectParameter("Success", typeof(int));
            _dbContext.spDeleteUserAccessCardMapping(userCardMappingId, userId, aasignedTill, result);
            Int32.TryParse(result.Value.ToString(), out status);

            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.DeleteUserCardMapping, userId, 0);

            return status;
        }

        public bool FinaliseUserCardMapping(int userCardMappingId, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var result = _dbContext.spFinaliseUserAccessCardMapping(userCardMappingId, userId).FirstOrDefault();

            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.FinaliseUserCardMapping, userId, 0);

            return result.Value;
        }

        public AccessCardMappingResponse AddUserAccessCardMapping(int accessCardId, string employeeAbrhs, bool isPimcoUserCardMapping, string userAbrhs, bool isStaff, DateTime fromDate)
        {
            var userId = 0;
            int status = 0;
            long userMappingId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(employeeAbrhs), out userId);

            var loginUserId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out loginUserId);
            var result = new ObjectParameter("Success", typeof(int));
            var mappingId = new ObjectParameter("UserCardMappingId", typeof(long));
            _dbContext.spAddUserAccessCardMapping(accessCardId, userId, isPimcoUserCardMapping, loginUserId, isStaff, fromDate, mappingId, result);
            Int32.TryParse(result.Value.ToString(), out status);
            long.TryParse(mappingId.Value.ToString(), out userMappingId);
            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.AddUserAccessCardMapping, loginUserId, 0);
            var response = new AccessCardMappingResponse
            {
                Success = status,
                UserMappingId = userMappingId
            };
            return response ?? new AccessCardMappingResponse();
        }

        public bool UpdateUserAccessCardMapping(int userCardMappingId, int accessCardId, bool isPimcoUserCardMapping, string userAbrhs,DateTime assigedFrom) //,int userId
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var result = _dbContext.spUpdateUserAccessCardMapping(userCardMappingId, accessCardId, isPimcoUserCardMapping, userId, assigedFrom).FirstOrDefault();

            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.UpdateUserAccessCardMapping, userId, 0);

            return result.Value;
        }
        public string GetNextWorkingDate()
        {
            var currentDate = DateTime.Now;
            var date = _dbContext.Proc_GetNextWorkingDate().FirstOrDefault();
            var nextDate = (date.HasValue?date.Value:DateTime.Now).ToString("MM/dd/yyyy", CultureInfo.InvariantCulture);
            return nextDate;
        }

        #endregion
    }
}
