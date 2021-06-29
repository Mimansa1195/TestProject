using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MIS.Services.Contracts;
using MIS.Model;
using MIS.BO;
using MIS.Utilities;

namespace MIS.Services.Implementations
{
    public class TaskManagementServices : ITaskManagementServices
    {
        private readonly IUserServices _userServices;

        public TaskManagementServices(IUserServices userServices)
        {
            _userServices = userServices;
        }

        #region Private member variables

        public readonly MISEntities _dbContext = new MISEntities();

        #endregion

        public List<CommonEntitiesBO> ListAllTaskTeam()
        {
            var taskTeamList = _dbContext.TaskTeams.Where(f => f.IsActive && !f.IsDeleted);
            var result = taskTeamList.Select(details => new CommonEntitiesBO
            {
                Id = details.TaskTeamId,
                EntityName = details.TeamName,
            }).ToList();
            return result.Count == 0 ? null : result.OrderBy(o => o.EntityName).ToList();
        }

        public string FetchTaskTeamByTeamId(long taskTeamId)
        {
            var taskTeam = _dbContext.TaskTeams.FirstOrDefault(f => f.IsActive && !f.IsDeleted && f.TaskTeamId == taskTeamId);
            if (taskTeam != null)
                return taskTeam.TeamName;
            else
                return null;
        }

        public List<CommonEntitiesBO> ListAllTaskType()
        {
            var taskTypeList = _dbContext.TaskTypes.Where(f => f.IsActive && !f.IsDeleted);
            var result = taskTypeList.Select(details => new CommonEntitiesBO
            {
                Id = details.TaskTypeId,
                EntityName = details.TaskTypeName,
            }).ToList();
            return result.Count == 0 ? null : result.OrderBy(o => o.EntityName).ToList();
        }

        public string FetchTaskTypeByTypeId(long taskTypeId)
        {
            var taskType = _dbContext.TaskTypes.FirstOrDefault(f => f.IsActive && !f.IsDeleted && f.TaskTypeId == taskTypeId);
            if (taskType != null)
                return taskType.TaskTypeName;
            else
                return null;
        }

        public List<CommonEntitiesBO> ListAllTaskSubDetail1()
        {
            var taskSubDetail1List = _dbContext.TaskSubDetail1.Where(f => f.IsActive && !f.IsDeleted);
            var result = taskSubDetail1List.Select(details => new CommonEntitiesBO
            {
                Id = details.TaskSubDetail1Id,
                EntityName = details.TaskSubDetail1Name,
            }).ToList();
            return result.Count == 0 ? null : result.OrderBy(o => o.EntityName).ToList();
        }

        public string FetchTaskSubDetail1ById(long taskSubDetail1Id)
        {
            var taskSub1 = _dbContext.TaskSubDetail1.FirstOrDefault(f => f.IsActive && !f.IsDeleted && f.TaskSubDetail1Id == taskSubDetail1Id);
            if (taskSub1 != null)
                return taskSub1.TaskSubDetail1Name;
            else
                return null;
        }

        public List<CommonEntitiesBO> ListAllTaskSubDetail2()
        {
            var taskSubDetail2List = _dbContext.TaskSubDetail2.Where(f => f.IsActive && !f.IsDeleted);
            var result = taskSubDetail2List.Select(details => new CommonEntitiesBO
            {
                Id = details.TaskSubDetail2Id,
                EntityName = details.TaskSubDetail2Name,
            }).ToList();
            return result.Count == 0 ? null : result.OrderBy(o => o.EntityName).ToList();
        }

        public string FetchTaskSubDetail2ById(long taskSubDetail2Id)
        {
            var taskSub2 = _dbContext.TaskSubDetail2.FirstOrDefault(f => f.IsActive && !f.IsDeleted && f.TaskSubDetail2Id == taskSubDetail2Id);
            if (taskSub2 != null)
                return taskSub2.TaskSubDetail2Name;
            else
                return null;
        }

        public List<long> ListAllMappedTypeTeam(int taskTeamId)
        {
            var results = _dbContext.TaskTeamTaskTypeMappings.Where(f => f.TaskTeamId == taskTeamId && f.IsActive).GroupBy(g => g.TaskTypeId).Select(grp => grp.FirstOrDefault()).Select(s => s.TaskTypeId).ToList();

            return results.Count == 0 ? null : results.OrderByDescending(s => s).ToList();
        }

        public List<long> ListMappedTypeToTeam(long taskTeamId)
        {
            var result = _dbContext.TaskTeamTaskTypeMappings.Where(f => f.IsActive && f.TaskTeamId == taskTeamId).GroupBy(g => g.TaskTypeId).Select(grp => grp.FirstOrDefault()).Select(s => s.TaskTypeId).ToList();
            return result.Count > 0 ? result.ToList() : null;
        }

        public int AddNewTaskTeam(string taskTeamName, string userAbrhs) //1: success, 2: error, 3: duplicate
        {
            var checkIfAlreadyExists = _dbContext.TaskTeams.FirstOrDefault(f => f.IsActive && !f.IsDeleted && f.TeamName == taskTeamName);
            if (checkIfAlreadyExists == null)
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                var data = new Model.TaskTeam
                {
                    TeamName = taskTeamName,
                    IsActive = true,
                    CreatedBy = userId,
                    CreatedDate = DateTime.Now,
                };
                _dbContext.TaskTeams.Add(data);
                _dbContext.SaveChanges();

                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.AddNewTaskTeam, userId, 0);

                return 1;
            }
            return 3;
        }

        public int AddNewTaskType(string taskTypeName, string userAbrhs)   //1: success, 2: error, 3: duplicate
        {
            var checkIfAlreadyExists = _dbContext.TaskTypes.FirstOrDefault(f => f.IsActive && !f.IsDeleted && f.TaskTypeName == taskTypeName);
            if (checkIfAlreadyExists == null)
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                var data = new Model.TaskType
                {
                    TaskTypeName = taskTypeName,
                    IsActive = true,
                    CreatedBy = userId,
                    CreatedDate = DateTime.Now,
                };
                _dbContext.TaskTypes.Add(data);
                _dbContext.SaveChanges();

                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.AddNewTaskType, userId, 0);

                return 1;
            }
            return 3;
        }

        public int AddNewTaskSubDetail1(string taskSubDetail1Name, string userAbrhs)   //1: success, 2: error, 3: duplicate
        {
            var checkIfAlreadyExists = _dbContext.TaskSubDetail1.FirstOrDefault(f => f.IsActive && !f.IsDeleted && f.TaskSubDetail1Name == taskSubDetail1Name);
            if (checkIfAlreadyExists == null)
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                var data = new Model.TaskSubDetail1
                {
                    TaskSubDetail1Name = taskSubDetail1Name,
                    IsActive = true,
                    CreatedBy = userId,
                    CreatedDate = DateTime.Now,
                };
                _dbContext.TaskSubDetail1.Add(data);
                _dbContext.SaveChanges();

                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.AddNewTaskSubDetail1, userId, 0);

                return 1;
            }
            return 3;
        }

        public int AddNewTaskSubDetail2(string taskSubDetail2Name, string userAbrhs)   //1: success, 2: error, 3: duplicate
        {
            var checkIfAlreadyExists = _dbContext.TaskSubDetail2.FirstOrDefault(f => f.IsActive && !f.IsDeleted && f.TaskSubDetail2Name == taskSubDetail2Name);
            if (checkIfAlreadyExists == null)
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                var data = new Model.TaskSubDetail2
                {
                    TaskSubDetail2Name = taskSubDetail2Name,
                    IsActive = true,
                    CreatedBy = userId,
                    CreatedDate = DateTime.Now,
                };
                _dbContext.TaskSubDetail2.Add(data);
                _dbContext.SaveChanges();

                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.AddNewTaskSubDetail2, userId, 0);

                return 1;
            }
            return 3;
        }

        public int UpdateTaskTeamDetails(long taskTeamId, string taskTeamName, string userAbrhs)    //1: success, 2: error, 3: duplicate
        {
            var taskTeamToUpdate = _dbContext.TaskTeams.FirstOrDefault(f => f.TaskTeamId == taskTeamId && !f.IsDeleted);
            if (taskTeamToUpdate != null)
            {
                var checkForDuplicateTeamName = _dbContext.TaskTeams.FirstOrDefault(f => f.IsActive && !f.IsDeleted && f.TaskTeamId != taskTeamId && f.TeamName == taskTeamName);
                if (checkForDuplicateTeamName == null)
                {
                    var userId = 0;
                    Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

                    taskTeamToUpdate.TeamName = taskTeamName;
                    taskTeamToUpdate.LastModifiedBy = userId;
                    taskTeamToUpdate.LastModifiedDate = DateTime.Now;

                    _dbContext.SaveChanges();

                    // Logging 
                    _userServices.SaveUserLogs(ActivityMessages.UpdateTaskTeamDetails, userId, 0);

                    return 1;
                }
                return 3;
            }
            return 2;
        }

        public int UpdateTaskTypeDetails(long taskTypeId, string taskTypeName, string userAbrhs)   //1: success, 2: error, 3: duplicate
        {
            var taskTypeToUpdate = _dbContext.TaskTypes.FirstOrDefault(f => f.TaskTypeId == taskTypeId && !f.IsDeleted);
            if (taskTypeToUpdate != null)
            {
                var checkForDuplicateTypeName = _dbContext.TaskTypes.FirstOrDefault(f => f.IsActive && !f.IsDeleted && f.TaskTypeId != taskTypeId && f.TaskTypeName == taskTypeName);
                if (checkForDuplicateTypeName == null)
                {
                    var userId = 0;
                    Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

                    taskTypeToUpdate.TaskTypeName = taskTypeName;
                    taskTypeToUpdate.LastModifiedBy = userId;
                    taskTypeToUpdate.LastModifiedDate = DateTime.Now;

                    _dbContext.SaveChanges();

                    // Logging 
                    _userServices.SaveUserLogs(ActivityMessages.UpdateTaskTypeDetails, userId, 0);

                    return 1;
                }
                return 3;
            }
            return 2;
        }

        public int UpdateTaskSubDetail1(long taskSubDetail1Id, string taskSubDetail1Name, string userAbrhs)    //1: success, 2: error, 3: duplicate
        {
            var taskSub1ToUpdate = _dbContext.TaskSubDetail1.FirstOrDefault(f => f.TaskSubDetail1Id == taskSubDetail1Id && !f.IsDeleted);
            if (taskSub1ToUpdate != null)
            {
                var checkForDuplicateSub1Name = _dbContext.TaskSubDetail1.FirstOrDefault(f => f.IsActive && !f.IsDeleted && f.TaskSubDetail1Id != taskSubDetail1Id && f.TaskSubDetail1Name == taskSubDetail1Name);
                if (checkForDuplicateSub1Name == null)
                {
                    var userId = 0;
                    Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

                    taskSub1ToUpdate.TaskSubDetail1Name = taskSubDetail1Name;
                    taskSub1ToUpdate.LastModifiedBy = userId;
                    taskSub1ToUpdate.LastModifiedDate = DateTime.Now;

                    _dbContext.SaveChanges();

                    // Logging 
                    _userServices.SaveUserLogs(ActivityMessages.UpdateTaskSubDetail1, userId, 0);

                    return 1;
                }
                return 3;
            }
            return 2;
        }

        public int UpdateTaskSubDetail2(long taskSubDetail2Id, string taskSubDetail2Name, string userAbrhs)    //1: success, 2: error, 3: duplicate
        {
            var taskSub2ToUpdate = _dbContext.TaskSubDetail2.FirstOrDefault(f => f.TaskSubDetail2Id == taskSubDetail2Id && !f.IsDeleted);
            if (taskSub2ToUpdate != null)
            {
                var checkForDuplicateSub2Name = _dbContext.TaskSubDetail2.FirstOrDefault(f => f.IsActive && !f.IsDeleted && f.TaskSubDetail2Id != taskSubDetail2Id && f.TaskSubDetail2Name == taskSubDetail2Name);

                if (checkForDuplicateSub2Name == null)
                {
                    var userId = 0;
                    Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

                    taskSub2ToUpdate.TaskSubDetail2Name = taskSubDetail2Name;
                    taskSub2ToUpdate.LastModifiedBy = userId;
                    taskSub2ToUpdate.LastModifiedDate = DateTime.Now;

                    _dbContext.SaveChanges();

                    // Logging 
                    _userServices.SaveUserLogs(ActivityMessages.UpdateTaskSubDetail2, userId, 0);

                    return 1;
                }
                return 3;
            }
            return 2;
        }

        public bool DeleteTaskTeam(long taskTeamId, string userAbrhs)
        {
            var taskTeamToDelete = _dbContext.TaskTeams.FirstOrDefault(f => f.TaskTeamId == taskTeamId);
            if (taskTeamToDelete != null)
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

                taskTeamToDelete.IsActive = false;
                taskTeamToDelete.IsDeleted = true;
                taskTeamToDelete.LastModifiedBy = userId;
                taskTeamToDelete.LastModifiedDate = DateTime.Now;

                _dbContext.SaveChanges();

                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.DeleteTaskTeam, userId, 0);

                return true;
            }
            return false;
        }

        public bool DeleteTaskType(long taskTypeId, string userAbrhs)
        {
            var taskTypeToDelete = _dbContext.TaskTypes.FirstOrDefault(f => f.TaskTypeId == taskTypeId);
            if (taskTypeToDelete != null)
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

                taskTypeToDelete.IsActive = false;
                taskTypeToDelete.IsDeleted = true;
                taskTypeToDelete.LastModifiedBy = userId;
                taskTypeToDelete.LastModifiedDate = DateTime.Now;

                _dbContext.SaveChanges();

                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.DeleteTaskType, userId, 0);

                return true;
            }
            return false;
        }

        public bool DeleteTaskSubDetail1(long taskSubDetail1Id, string userAbrhs)
        {
            var taskSub1ToDelete = _dbContext.TaskSubDetail1.FirstOrDefault(f => f.TaskSubDetail1Id == taskSubDetail1Id);
            if (taskSub1ToDelete != null)
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

                taskSub1ToDelete.IsActive = false;
                taskSub1ToDelete.IsDeleted = true;
                taskSub1ToDelete.LastModifiedBy = userId;
                taskSub1ToDelete.LastModifiedDate = DateTime.Now;

                _dbContext.SaveChanges();


                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.DeleteTaskSubDetail1, userId, 0);

                return true;
            }
            return false;
        }

        public bool DeleteTaskSubDetail2(long taskSubDetail2Id, string userAbrhs)
        {
            var taskSub2ToDelete = _dbContext.TaskSubDetail2.FirstOrDefault(f => f.TaskSubDetail2Id == taskSubDetail2Id);
            if (taskSub2ToDelete != null)
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

                taskSub2ToDelete.IsActive = false;
                taskSub2ToDelete.IsDeleted = true;
                taskSub2ToDelete.LastModifiedBy = userId;
                taskSub2ToDelete.LastModifiedDate = DateTime.Now;

                _dbContext.SaveChanges();

                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.DeleteTaskSubDetail2, userId, 0);

                return true;
            }
            return false;
        }
    }
}
