using System;
using System.Collections.Generic;
using System.Linq;
using MIS.Services.Contracts;
using MIS.Model;
using MIS.BO;
using MIS.Utilities;
using System.Xml.Linq;
using System.Data.Entity.Core.Objects;
using System.Configuration;
//using System.Runtime.Serialization.Formatters;
using System.Web.Script.Serialization;
using System.Globalization;
using System.Web;
using System.IO;

namespace MIS.Services.Implementations
{
    public class AppraisalServices : IAppraisalServices
    {
        private readonly IUserServices _userServices;

        public AppraisalServices(IUserServices userServices)
        {
            _userServices = userServices;
        }

        #region private member variable

        private readonly MISEntities _dbContext = new MISEntities();

        #endregion

        #region Appraisal management

        #region Appraisal Cycle
        public int AddAppraisalCycle(AppraisalCycleBO cycle)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(cycle.UserAbrhs), out userId);

            //check Exist.
            var checkExist = _dbContext.AppraisalCycles.Where(x => x.IsActive && (x.CountryId == cycle.CountryId && x.AppraisalMonth == cycle.AppraisalMonth && x.AppraisalYear == cycle.AppraisalYear)).ToList();
            if (checkExist.Any())
                return 2;

            var modal = new AppraisalCycle
            {
                CountryId = cycle.CountryId,
                AppraisalMonth = cycle.AppraisalMonth,
                AppraisalYear = cycle.AppraisalYear,
                //AppraisalCycleName = cycle.AppraisalCycleName,
                IsActive = true,
                CreatedDate = DateTime.Now,
                CreatedById = userId
            };
            _dbContext.AppraisalCycles.Add(modal);
            _dbContext.SaveChanges();
            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.AddAppraisalCycle, userId, 0);
            return 1;
        }

        public List<AppraisalCycleList> GetAllAppraisalCycles(string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            if (userId > 0)
            {
                var appraisalData = _dbContext.AppraisalCycles.Where(x => x.IsActive).ToList();

                var result = (from AC in appraisalData
                              join C in _dbContext.Countries on AC.CountryId equals C.CountryId
                              //join FT in _dbContext.FeedbackTypes on AC.FeedbackTypeId equals FT.FeedbackTypeId
                              select new AppraisalCycleList
                              {
                                  AppraisalCycleAbrhs = CryptoHelper.Encrypt(AC.AppraisalCycleId.ToString()),
                                  AppraisalCycleName = AC.AppraisalCycleName,
                                  //AppraisalTypeName = FT.AppraisalTypeName,
                                  Country = C.CountryName
                              }).OrderBy(x => x.AppraisalCycleName).ToList();
                return result;
            }
            else
                return new List<AppraisalCycleList>();
        }

        public int UpdateAppraisalCycle(AppraisalCycleBO cycle)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(cycle.UserAbrhs), out userId);

            var appraisalCycleId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(cycle.AppraisalCycleAbrhs), out appraisalCycleId);

            //check Exist.
            var existingCycle = _dbContext.AppraisalCycles.Where(x => (x.AppraisalYear == cycle.AppraisalYear && x.AppraisalMonth == cycle.AppraisalMonth && x.IsActive) && x.AppraisalCycleId != appraisalCycleId);
            if (existingCycle.Any())
                return 2;
            else
            {
                var apprCycle = _dbContext.AppraisalCycles.FirstOrDefault(x => x.AppraisalCycleId == appraisalCycleId && x.IsActive);
                apprCycle.CountryId = cycle.CountryId;
                apprCycle.AppraisalMonth = cycle.AppraisalMonth;
                apprCycle.AppraisalYear = cycle.AppraisalYear;

                apprCycle.ModifiedDate = DateTime.Now;
                apprCycle.ModifiedById = userId;

                _dbContext.SaveChanges();

                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.UpdateAppraisalCycle, userId, 0);
                return 1;
            }
        }

        /// <summary>
        /// Deactivate appraisal cycle
        /// </summary>
        /// <param name="appraisalCycleAbrhs"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public int DeleteAppraisalCycle(string appraisalCycleAbrhs, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            var AppraisalCycleId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(appraisalCycleAbrhs), out AppraisalCycleId);

            //check Exist.
            var existingObj = _dbContext.AppraisalCycles.FirstOrDefault(x => x.AppraisalCycleId == AppraisalCycleId);

            if (existingObj == null)
                return 2;

            existingObj.IsActive = false;
            existingObj.ModifiedDate = DateTime.Now;
            existingObj.ModifiedById = userId;

            _dbContext.SaveChanges();

            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.DeleteAppraisalCycle, userId, 0);
            return 1;
        }

        public AppraisalCycleBO GetAppraisalCycle(string AppraisalCycleAbrhs, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            var AppraisalCycleId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(AppraisalCycleAbrhs), out AppraisalCycleId);

            AppraisalCycleBO modal = new AppraisalCycleBO();

            if (userId > 0)
            {
                var AppraisalCycleData = _dbContext.AppraisalCycles.FirstOrDefault(x => x.IsActive && x.AppraisalCycleId == AppraisalCycleId);

                if (AppraisalCycleData != null)
                {
                    modal.AppraisalCycleAbrhs = CryptoHelper.Encrypt(AppraisalCycleData.AppraisalCycleId.ToString());
                    modal.CountryId = AppraisalCycleData.CountryId;
                    modal.AppraisalMonth = AppraisalCycleData.AppraisalMonth;
                    modal.AppraisalYear = AppraisalCycleData.AppraisalYear;
                    modal.AppraisalCycleName = AppraisalCycleData.AppraisalCycleName;
                }
                return modal;
            }
            return modal;
        }
        #endregion


        #endregion

        #region Parameter

        public int SaveParameter(int competencyTypeId, bool isFinalized, string parameterName, int weightage, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            //check Exist.
            var checkExist = _dbContext.AppraisalParameters.Where(x => x.IsActive && x.ParameterName == parameterName && x.CompetencyTypeId == competencyTypeId).ToList();

            if (checkExist.Any())
            {
                return 2;
            }

            AppraisalParameter Modal = new AppraisalParameter();

            Modal.ParameterName = parameterName;
            Modal.CompetencyTypeId = competencyTypeId;
            Modal.IsFinalized = isFinalized;
            Modal.IsActive = true;
            Modal.CreatedDate = DateTime.Now;
            Modal.CreatedById = userId;
            Modal.Weightage = weightage;
            _dbContext.AppraisalParameters.Add(Modal);
            _dbContext.SaveChanges();
            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.SaveParameter, userId, 0); // change message
            return 1;
        }

        public List<AppraisalParameterBO> GetParameterList(int competencyTypeId, int year, int status, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            if (userId > 0)
            {
                var parameterList = _dbContext.Proc_GetParameterList(competencyTypeId, year, status).Select(x => new AppraisalParameterBO
                {
                    ParameterId = x.ParameterId,
                    ParameterName = x.ParameterName,
                    CompetencyTypeName = x.CompetencyTypeName,
                    Weightage = x.Weightage,
                    CompetencyTypeId = x.CompetencyTypeId,
                    IsFinalized = x.IsFinalized,
                    IsActive = x.IsActive,
                }).ToList();

                return parameterList;
            }
            return new List<AppraisalParameterBO>();
        }

        public int UpdateParameter(int parameterId, int competencyTypeId, string parameterName, int weightage, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            //check Exist.
            var checkExist = _dbContext.AppraisalParameters.Where(x => x.IsActive && x.ParameterName == parameterName && x.CompetencyTypeId == competencyTypeId).ToList();
            if (checkExist.Any())
            {
                return 2;
            }
            var data = _dbContext.AppraisalParameters.FirstOrDefault(x => x.IsActive && x.ParameterId == parameterId);
            data.ParameterName = parameterName;
            data.CompetencyTypeId = competencyTypeId;
            data.ModifiedDate = DateTime.Now;
            data.ModifiedById = userId;
            data.Weightage = weightage;
            _dbContext.SaveChanges();
            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.UpdateParameter, userId, 0);
            return 1;
        }

        public int ChangeStatus(int parameterId, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            var data = _dbContext.AppraisalParameters.FirstOrDefault(x => x.ParameterId == parameterId && !x.IsFinalized);

            if (data != null && data.IsActive)
            {
                data.IsActive = false;
                data.ModifiedDate = DateTime.Now;
                data.ModifiedById = userId;
                _dbContext.SaveChanges();
                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.InActiveParameter, userId, 0);
            }
            else
            {
                data.IsActive = true;
                data.ModifiedDate = DateTime.Now;
                data.ModifiedById = userId;
                _dbContext.SaveChanges();
                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.AciveParameter, userId, 0);
            }
            return 1;
        }

        public int DeleteParameter(int parameterId, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            var data = _dbContext.AppraisalParameters.FirstOrDefault(x => x.IsActive && x.ParameterId == parameterId && !x.IsFinalized);
            if (data != null)
            {
                data.IsDeleted = true;
                data.DeletedDate = DateTime.Now;
                data.DeletedById = userId;
                _dbContext.SaveChanges();
            }
            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.DeleteParameter, userId, 0);
            return 1;
        }

        public int FinalizeParameter(int parameterId, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            var data = _dbContext.AppraisalParameters.FirstOrDefault(x => x.IsActive && x.ParameterId == parameterId);
            if (data != null)
            {
                data.IsFinalized = true;
                data.ModifiedDate = DateTime.Now;
                data.ModifiedById = userId;
                _dbContext.SaveChanges();
            }
            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.FinalizeParameter, userId, 0);
            return 1;
        }

        #endregion

        #region Competency Form

        public string GetAppraisalFormName(int departmentId, int designationId, string formSufix)
        {
            var formName = "";
            if (true)
            {
                formName = _dbContext.Fun_GetFormattedFormName(departmentId, designationId, formSufix).FirstOrDefault();

            }
            return formName;
        }

        public AddUpdateReturnBO AddUpdateCompetencyForm(AddUpdateCompetencyFormBO data)
        {
            AddUpdateReturnBO returnBO = new AddUpdateReturnBO();
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(data.UserAbrhs), out userId);
            if (data.ParameterList != null)
            {

                var ParameterxmlString = new XElement("root",
                    from pxs in data.ParameterList
                    select new XElement("row",
                           new XAttribute("CompetencyFormDetailId", pxs.CompetencyFormDetailId),
                            new XAttribute("CompetencyTypeId", pxs.CompetencyTypeId),
                            new XAttribute("ParameterId", pxs.ParameterId),
                            new XAttribute("EvaluationCriteria", pxs.EvaluationCriteria),
                            new XAttribute("SequenceNo", pxs.SequenceNo)
                            ));

                var success = new ObjectParameter("Success", typeof(string));
                var result = new ObjectParameter("DuplicateNames", typeof(string));
                _dbContext.Proc_AddUpdateCompetencyForm(data.CompetencyFormId, data.FormName, data.LocationId, data.VerticalId, data.DivisionId, data.DepartmentId, data.DesignationId, data.FeedbackTypeId, true, data.IsFinalize, ParameterxmlString.ToString(), userId, success, result);
                returnBO.Status = success.Value.ToString();
                returnBO.Result = result.Value.ToString();

            }
            return returnBO;
        }

        public List<CompetencyFormListBO> GetCompetencyFormList(CompetencyFilterBO data)
        {
            List<CompetencyFormListBO> returnBO = new List<CompetencyFormListBO>();
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(data.UserAbrhs), out userId);
            if (userId > 0)
            {
                returnBO = _dbContext.Proc_GetCompetencyForm(userId, data.FeedbackTypeIds, data.LocationIds, data.VerticalIds, data.DivisionIds, data.DepartmentIds, data.DesignationIds, data.YearVal, data.CompetencyFormId).Select(x => new CompetencyFormListBO
                {
                    CompetencyFormId = x.CompetencyFormId,
                    FeedbackTypeId = x.FeedbackTypeId,
                    LocationId = x.LocationId,
                    VerticalId = x.VerticalId,
                    DivisionId = x.DivisionId,
                    DepartmentId = x.DepartmentId,
                    DesignationId = x.DesignationId,
                    CompetencyFormName = x.CompetencyFormName,
                    SpecializedFormName = x.SpecializedFormName,
                    FeedbackTypeName = x.FeedbackTypeName,
                    LocationName = x.LocationName,
                    VerticalName = x.VerticalName,
                    DivisionName = x.DivisionName,
                    DepartmentName = x.DepartmentName,
                    DesignationName = x.DesignationName,
                    IsRating = x.IsRating,
                    IsFinalized = x.IsFinalized,
                    IsRetired = x.IsRetired.Value,
                    FinalizedDate = x.FinalizedDate,
                    RetiredDate = x.RetiredDate,
                    CreatedDate = x.CreatedDate
                }).ToList();
            }
            return returnBO;
        }

        public int RetireCompetencyForm(int competencyFormId, string userAbrhs)
        {
            var loginUserId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out loginUserId);

            var competencyFormData = _dbContext.CompetencyForms.FirstOrDefault(x => x.CompetencyFormId == competencyFormId);
            if (competencyFormData != null)
            {
                competencyFormData.IsRetired = true;
                competencyFormData.RetiredDate = DateTime.Now;
                competencyFormData.ModifiedById = loginUserId;
                competencyFormData.ModifiedDate = DateTime.Now;
                _dbContext.SaveChanges();

                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.CompetencyFormRetire, loginUserId, 0);
                return 1;
            }
            return 0;
        }

        public int DeleteCompetencyForm(int competencyFormId, string userAbrhs)
        {
            var loginUserId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out loginUserId);
            var competencyFormData = _dbContext.CompetencyForms.FirstOrDefault(x => x.CompetencyFormId == competencyFormId && !x.IsFinalized);
            if (competencyFormData != null)
            {
                competencyFormData.IsActive = false;
                competencyFormData.ModifiedById = loginUserId;
                competencyFormData.ModifiedDate = DateTime.Now;
                _dbContext.SaveChanges();

                // Logging 
                _userServices.SaveUserLogs(ActivityMessages.CompetencyFormDelete, loginUserId, 0);

                return 1;
            }
            return 0;
        }

        public CompetencyFormForEditBO GetCompetencyFormDataForEdit(int competencyFormId, string userAbrhs)
        {
            CompetencyFormForEditBO returnBO = new CompetencyFormForEditBO();
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            returnBO.CompetencyFormData = _dbContext.Proc_GetCompetencyForm(userId, "", "", "", "", "", "", "", competencyFormId).Select(x => new CompetencyFormListBO
            {
                CompetencyFormId = x.CompetencyFormId,
                FeedbackTypeId = x.FeedbackTypeId,
                LocationId = x.LocationId,
                VerticalId = x.VerticalId,
                DivisionId = x.DivisionId,
                DepartmentId = x.DepartmentId,
                DesignationId = x.DesignationId,
                CompetencyFormName = x.CompetencyFormName,
                SpecializedFormName = x.SpecializedFormName,
                FeedbackTypeName = x.FeedbackTypeName,
                LocationName = x.LocationName,
                VerticalName = x.VerticalName,
                DivisionName = x.DivisionName,
                DepartmentName = x.DepartmentName,
                DesignationName = x.DesignationName,
                IsRating = x.IsRating,
                IsFinalized = x.IsFinalized,
                IsRetired = x.IsRetired.Value,
                FinalizedDate = x.FinalizedDate,
                RetiredDate = x.RetiredDate,
                CreatedDate = x.CreatedDate
            }).FirstOrDefault();

            if (returnBO.CompetencyFormData != null)
            {
                returnBO.CompetencyAndParameterListBO = _dbContext.Proc_GetCompetencyFormDetail(competencyFormId).Select(x => new CompetencyFormParameterForEditBO
                {
                    CompetencyFormDetailId = x.CompetencyFormDetailId,
                    ParameterId = x.ParameterId,
                    CompetencyTypeId = x.CompetencyTypeId,
                    EvaluationCriteria = x.EvaluationCriteria,
                    Parameter = x.ParameterName,
                    CompetencyType = x.CompetencyTypeName
                }).ToList();
            }
            return returnBO;
        }

        public AddUpdateReturnBO CloneCompetencyForm(CloneCompetencyFormBO data)
        {
            AddUpdateReturnBO returnBO = new AddUpdateReturnBO();
            var loginUserId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(data.UserAbrhs), out loginUserId);
            if (data.CompetencyFormId != null && data.CompetencyFormId > 0)
            {
                var success = new ObjectParameter("Success", typeof(string));
                _dbContext.Proc_CreateCompetencyFormClone(data.CompetencyFormId, data.FormName, data.LocationId, data.VerticalId, data.DivisionId, data.DepartmentId, data.DesignationId, data.FeedbackTypeId, data.IsFinalize, loginUserId, success);
                returnBO.Status = success.Value.ToString();
            }

            // Logging 
            _userServices.SaveUserLogs(ActivityMessages.CompetencyFormClone, loginUserId, 0);

            return returnBO;
        }

        #endregion

        #region Appraisal Settings

        public AddUpdateReturnBO AddAppraisalSettings(AddAppraisalSettingsBO data)
        {
            AddUpdateReturnBO returnBO = new AddUpdateReturnBO();
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(data.UserAbrhs), out userId);
            if (data.DesignationIds != "" && data.DepartmentIds != "")
            {
                var ParameterxmlString = new XElement("root",
                  from pxs in data.AppraisalStagesList
                  select new XElement("row",
                         new XAttribute("AppraisalStageId", pxs.AppraisalStageId),
                          new XAttribute("EndDate", pxs.EndDate)
                          ));

                var success = new ObjectParameter("Success", typeof(string));
                var result = new ObjectParameter("DuplicateNames", typeof(string));
                _dbContext.Proc_AddAppraisalSetting(data.AppraisalCycleId, data.LocationId, data.VerticalId, data.DivisionIds, data.DepartmentIds, data.TeamIds, data.DesignationIds, data.StartDate, data.EndDate, ParameterxmlString.ToString(), userId, success, result);
                returnBO.Status = success.Value.ToString();
                returnBO.Result = result.Value.ToString();

            }
            return returnBO;
        }

        public List<GetAppraisalSettingsBO> GetAppraisalSettingList(AppraisalSettingsFilterBO data)
        {
            List<GetAppraisalSettingsBO> returnBO = new List<GetAppraisalSettingsBO>();
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(data.UserAbrhs), out userId);
            if (userId > 0)
            {
                returnBO = _dbContext.Proc_GetAppraisalSetting(userId, data.AppraisalCycleId, data.LocationId, data.VerticalIds, data.DivisionIds, data.DepartmentIds, data.TeamIds, data.AppraisalSettingId).Select(x => new GetAppraisalSettingsBO
                {
                    AppraisalSettingId = x.AppraisalSettingId,
                    AppraisalCycleId = x.AppraisalCycleId,
                    LocationId = x.LocationId,
                    VerticalId = x.VerticalId,
                    DivisionId = x.DivisionId,
                    DepartmentId = x.DepartmentId,
                    TeamId = x.TeamId,
                    EmpSettingCount = x.EmpSettingCount.Value,
                    AppraisalMonth = x.AppraisalMonth,
                    AppraisalCycleName = x.AppraisalCycleName,
                    LocationName = x.LocationName,
                    VerticalName = x.VerticalName,
                    DivisionName = x.DivisionName,
                    DepartmentName = x.DepartmentName,
                    DesignationName = x.DesignationName,
                    DesignationIds = x.DesignationIds,
                    TeamName = x.TeamName,
                    StartDate = x.StartDate,
                    EndDate = x.EndDate,
                    AppraisalStatges = x.AppraisalStatges,
                }).ToList();
            }
            return returnBO;
        }

        public int DeleteAppraisalSetting(int AppraisalSettingId, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            if (userId > 0)
            {
                var data = _dbContext.AppraisalSettings.FirstOrDefault(x => x.AppraisalSettingId == AppraisalSettingId);
                if (data != null)
                {
                    data.IsActive = false;
                    data.ModifiedById = userId;
                    data.ModifiedDate = DateTime.Now;
                    _dbContext.SaveChanges();
                    return 1;
                }
            }
            return 0;
        }

        public AddUpdateReturnBO GenerateAppraisalSettings(GenerateSettingsFilterBO data)
        {
            AddUpdateReturnBO returnBO = new AddUpdateReturnBO();
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(data.UserAbrhs), out userId);
            if (userId > 0)
            {
                var success = new ObjectParameter("Success", typeof(int));
                int result = _dbContext.Proc_GenerateEmpAppraisalSetting(data.AppraisalSettingId, userId, success);
                returnBO.Status = success.Value.ToString();
                return returnBO;
            }
            return returnBO;
        }

        public AddUpdateReturnBO UpdateAppraisalSettings(UpdateAppraisalSettingsBO data)
        {
            AddUpdateReturnBO returnBO = new AddUpdateReturnBO();
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(data.UserAbrhs), out userId);
            if (data.DesignationIds != "" && data.TeamId > 0)
            {
                var ParameterxmlString = new XElement("root",
                  from pxs in data.AppraisalStagesList
                  select new XElement("row",
                         new XAttribute("AppraisalStageId", pxs.AppraisalStageId),
                          new XAttribute("EndDate", pxs.EndDate)
                          ));

                var success = new ObjectParameter("Success", typeof(string));
                var result = new ObjectParameter("DuplicateNames", typeof(string));
                _dbContext.Proc_UpdateAppraisalSetting(data.AppraisalSettingId, data.AppraisalCycleId, data.LocationId, data.VerticalId, data.DivisionId, data.DepartmentId, data.TeamId, data.DesignationIds, data.StartDate, data.EndDate, ParameterxmlString.ToString(), userId, success, result);
                returnBO.Status = success.Value.ToString();
                returnBO.Result = result.Value.ToString();
            }
            return returnBO;
        }

        public List<BaseDropDown> GetApproverListByIDs(TeamAppraisalFilterBO data)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(data.UserAbrhs), out userId);
            List<BaseDropDown> ApproverList = new List<BaseDropDown>();
            if (userId > 0)
            {
                ApproverList = _dbContext.Proc_GetApproverListByIDs(data.AppraisalCycleId, data.LocationId, data.VerticalId, data.DivisionIds, data.DepartmentIds, data.TeamIds, 0).Select(x => new BaseDropDown
                {
                    Text = x.ApproverName,
                    Value = x.ApproverId,
                    Selected = false
                }).OrderBy(t => t.Text).ToList();
                return ApproverList;
            }
            return ApproverList;
        }

        public List<BaseDropDown> GetAppraiserListByIDs(TeamAppraisalFilterBO data)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(data.UserAbrhs), out userId);
            List<BaseDropDown> AppraiserList = new List<BaseDropDown>();
            if (userId > 0)
            {
                AppraiserList = _dbContext.Proc_GetAppraiserListByIDs(data.AppraisalCycleId, data.LocationId, data.VerticalId, data.DivisionIds, data.DepartmentIds, data.TeamIds, 0).Select(x => new BaseDropDown
                {
                    Text = x.AppraiserName,
                    Value = x.AppraiserId,
                    Selected = false
                }).OrderBy(t => t.Text).ToList();
                return AppraiserList;
            }
            return AppraiserList;
        }

        #endregion

        #region Goals

        public List<GoalDetailBO> GetAllSelfGoals(string userAbrhs, int appraisalCycleId)
        {
            string[] userAbrhsArray = userAbrhs.Split(',');

            var count = userAbrhsArray.Length;
            int[] userIdArray = new int[count];
            for (var i = 0; i < count; i++)
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhsArray[i]), out userId);
                userIdArray[i] = userId;
            }
            var userIds = String.Join(",", userIdArray);
            var data = _dbContext.spGetAllUserGoals(userIds, appraisalCycleId).ToList();

            var result = new List<GoalDetailBO>();
            if (data != null)
            {
                foreach (var temp in data)
                {
                    result.Add(new GoalDetailBO
                    {
                        GoalId = temp.GoalId,
                        AppraisalCycleName = temp.AppraisalCycleName,
                        Goal = temp.Goal,
                        StartDate = temp.StartDate.ToString("MM/dd/yyyy"),//("dd-MMM-yyyy"),
                        EndDate = temp.EndDate.ToString("MM/dd/yyyy"),//("dd-MMM-yyyy"),
                        Status = temp.Status,
                        GoalCategory= temp.Category,
                        GoalAchievingDate = temp.LastModifiedDate == null ? "NA" : temp.LastModifiedDate.Value.ToString("dd-MMM-yyyy"),
                        AppraisalYear = temp.AppraisalYear,
                        Employee = temp.Employee
                        //UserRemark = temp.UserRemark,
                        //OtherRemark = temp.OtherRemark,
                        //IsGoalAchieved = temp.IsGoalAchieved,
                        //CreatedBy = temp.CreatedBy,
                        //IsActive = temp.IsActive,
                        //IsFreezed = temp.IsGoalFreezed,
                    });
                }
                return result;
            }
            return null;
        }
        public int MarkGoalAsAchieved(string userAbrhs, DateTime date, string remarks, long goalId)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            var data = _dbContext.UserGoals.FirstOrDefault(x => x.UserGoalId == goalId && x.IsActive);
            if (data != null)
            {
                if (data.GoalStatusId == (long)Enums.GoalStatus.Approved) //goal is in approved state
                {
                    if (data.UserId == userId)
                    {
                        data.GoalStatusId = (long)Enums.GoalStatus.Achieved;
                        data.LastModifiedBy = userId;
                        data.LastModifiedDate = date;
                        _dbContext.UserGoalHistories.Add(new UserGoalHistory
                        {
                            UserGoalId = data.UserGoalId,
                            StartDateId = data.StartDateId,
                            EndDateId = data.EndDateId,
                            Goal = data.Goal,
                            GoalCategoryId = data.GoalCategoryId,
                            GoalStatusId = (long)Enums.GoalStatus.Achieved,
                            Remarks = remarks,
                            CreatedDate = DateTime.Now,
                            CreatedBy = userId,
                        });

                        _dbContext.SaveChanges();
                        return 1;
                    }
                    return 2;
                }
                return 3;
            }
            return 4;
        }
        public bool DeleteGoal(long goalId, string remarks, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var data = _dbContext.UserGoals.FirstOrDefault(x => x.UserGoalId == goalId && x.IsActive);
            if (data != null)
            {
                data.OtherRemark = remarks;
                data.IsActive = false;
                data.GoalStatusId = (long)Enums.GoalStatus.Deleted; //6 Deleted
                data.LastModifiedBy = userId;
                data.LastModifiedDate = DateTime.Now;

                if (userId != data.UserId)
                {
                    data.GoalStatusId = (long)Enums.GoalStatus.Rejected; //5 Rejected
                    _dbContext.UserGoalHistories.Add(new UserGoalHistory
                    {
                        UserGoalId = data.UserGoalId,
                        StartDateId = data.StartDateId,
                        EndDateId = data.EndDateId,
                        Goal = data.Goal,
                        GoalCategoryId = data.GoalCategoryId,
                        GoalStatusId = (long)Enums.GoalStatus.Rejected, //5 Rejected
                        Remarks = remarks,
                        CreatedDate = DateTime.Now,
                        CreatedBy = userId,
                    });
                }

                _dbContext.SaveChanges();

                return true;
            }
            return false;
        }
        public int ApproveGoal(string goalIds, string userAbrhs)
        {
            int statusId;
            int userId;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var result = new ObjectParameter("Success", typeof(int));
            _dbContext.Proc_ApproveGoal(goalIds, userId, result);
            Int32.TryParse(result.Value.ToString(), out statusId);
            return statusId;
        }

        public List<EmployeeBO> GetAllEmployeesReportingToUser(string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            var result = new List<EmployeeBO>();
            var reportingEmployees = _dbContext.spGetEmployeesReportingToUser(userId, false, false).ToList();
            if (reportingEmployees.Any())
            {
                foreach (var temp in reportingEmployees)
                {
                    var user = _dbContext.UserDetails.Where(f => f.UserId == temp.EmployeeId).FirstOrDefault();
                    result.Add(new EmployeeBO
                    {
                        EmployeeAbrhs = CryptoHelper.Encrypt(temp.EmployeeId.ToString()),
                        EmployeeName = user.FirstName + " " + user.LastName,
                    });
                }
                return result.OrderBy(x => x.EmployeeName).ToList();
            }
            return null;
        }
        public bool AddGoal(AddGoalBO goalDetails)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(goalDetails.UserAbrhs), out userId);

            var employeeId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(goalDetails.EmployeeAbrhs), out employeeId);
            goalDetails.GoalList.RemoveAll(x => x.StartDate == null || x.EndDate == null || x.Goal == null);
            if (goalDetails.GoalList != null)
            {
                var goalXmlString = new XElement("Root",
                    from goal in goalDetails.GoalList
                    select new XElement("Row",
                           new XAttribute("StartDate", goal.StartDate),
                            new XAttribute("EndDate", goal.EndDate),
                            new XAttribute("GoalCategoryId", goal.GoalCategoryId),
                            new XAttribute("Goal", goal.Goal)
                            ));
                var result = _dbContext.spAddGoals(employeeId, goalXmlString.ToString(), userId, goalDetails.GoalCycleId);
                return true;
            }
            return false;
        }
        public bool SubmitGoal(string goalIds, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            return _dbContext.spSubmitGoals(goalIds, userId).FirstOrDefault().Value;
        }
        public bool DraftGoal(AddGoalBO goalDetails)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(goalDetails.UserAbrhs), out userId);

            var employeeId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(goalDetails.EmployeeAbrhs), out employeeId);
            goalDetails.GoalList.RemoveAll(x => x.StartDate == null || x.EndDate == null || x.Goal == null);
            if (goalDetails.GoalList != null)
            {
                var goalXmlString = new XElement("Root",
                    from goal in goalDetails.GoalList
                    select new XElement("Row",
                           new XAttribute("StartDate", goal.StartDate),
                            new XAttribute("EndDate", goal.EndDate),
                            new XAttribute("GoalCategoryId", goal.GoalCategoryId),
                            new XAttribute("Goal", goal.Goal)
                            ));
                var result = _dbContext.spDraftGoals(employeeId, goalXmlString.ToString(), userId, goalDetails.GoalCycleId);
                return true;
            }
            return false;
        }
        public bool EditGoal(GoalDetailBO goal)
        {
            if (string.IsNullOrEmpty(goal.StartDate) || string.IsNullOrEmpty(goal.EndDate)
                || string.IsNullOrEmpty(goal.Goal) || string.IsNullOrEmpty(goal.UserAbrhs))
                return false;

            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(goal.UserAbrhs), out userId);
            var data = _dbContext.UserGoals.FirstOrDefault(x => x.UserGoalId == goal.GoalId && x.IsActive);
            if (data == null)
                return false;
            DateTime goalStartDate = DateTime.ParseExact(goal.StartDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            DateTime goalEndDate = DateTime.ParseExact(goal.EndDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            data.Goal = goal.Goal;
            data.GoalCategoryId = goal.GoalCategoryId;
            data.StartDateId = _dbContext.DateMasters.FirstOrDefault(x => x.Date == goalStartDate).DateId;
            data.EndDateId = _dbContext.DateMasters.FirstOrDefault(x => x.Date == goalEndDate).DateId;
            data.LastModifiedBy = userId;
            data.LastModifiedDate = DateTime.Now;

            if (userId != data.UserId)
            {
                _dbContext.UserGoalHistories.Add(new UserGoalHistory
                {
                    UserGoalId = data.UserGoalId,
                    StartDateId = _dbContext.DateMasters.FirstOrDefault(x => x.Date == goalStartDate).DateId,
                    EndDateId = _dbContext.DateMasters.FirstOrDefault(x => x.Date == goalEndDate).DateId,
                    Goal = goal.Goal,
                    GoalCategoryId = goal.GoalCategoryId,
                    GoalStatusId = data.GoalStatusId,
                    Remarks = "Edited",
                    CreatedDate = DateTime.Now,
                    CreatedBy = userId,
                });
            }
            _dbContext.SaveChanges();
            return true;
        }
        public GoalDetailBO FetchGoalDetailById(long goalId)
        {
            var data = _dbContext.UserGoals.FirstOrDefault(x => x.UserGoalId == goalId && x.IsActive);
            if (data == null)
                return null;
            string startDate = _dbContext.DateMasters.FirstOrDefault(x => x.DateId == data.StartDateId).Date.ToString("MM/dd/yyyy", CultureInfo.InvariantCulture);
            string endDate = _dbContext.DateMasters.FirstOrDefault(x => x.DateId == data.EndDateId).Date.ToString("MM/dd/yyyy", CultureInfo.InvariantCulture);
            return new GoalDetailBO
            {
                StartDate = startDate,
                EndDate = endDate,
                Goal = data.Goal,
                GoalCategoryId = data.GoalCategoryId,
                GoalCategory = data.GoalCategory.Category
            };
        }
        public List<GoalDetailBO> FetchGoalHistoryById(int goalId)
        {
            return _dbContext.spGetGoalHistoryById(goalId).Select(x => new GoalDetailBO
            {
                Goal = x.Goal,
                StartDate = x.StartDate,
                EndDate = x.EndDate,
                GoalCategory = x.Category,
                Status = x.Status,
                Remark = x.Remarks,
                CreatedBy = x.CreatedBy,
                CreatedDate = x.CreatedDate.ToString("dd-MMM-yyyy HH:mm tt")
            }).ToList();
        }

        #region Team Goal

        public List<GoalDetailBO> GetAllTeamGoals(int userId, string teamAbrhs, int appraisalCycleId)
        {
            string[] teamAbrhsArray = teamAbrhs.Split(',');

            var count = teamAbrhsArray.Length;
            int[] teamIdArray = new int[count];
            for (var i = 0; i < count; i++)
            {
                var teamId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(teamAbrhsArray[i]), out teamId);
                teamIdArray[i] = teamId;
            }
            var teamIds = String.Join(",", teamIdArray);
            var data = _dbContext.Proc_GetAllTeamGoals(teamIds, appraisalCycleId, userId).ToList();

            var result = new List<GoalDetailBO>();
            if (data != null)
            {
                foreach (var temp in data)
                {
                    result.Add(new GoalDetailBO
                    {
                        GoalId = temp.GoalId,
                        AppraisalCycleName = temp.AppraisalCycleName,
                        Goal = temp.Goal,
                        StartDate = temp.StartDate.ToString("MM/dd/yyyy"),//("dd-MMM-yyyy"),
                        EndDate = temp.EndDate.ToString("MM/dd/yyyy"),//("dd-MMM-yyyy"),
                        Status = temp.Status,
                        GoalCategory = temp.Category,
                        GoalAchievingDate = temp.LastModifiedDate == null ? "NA" : temp.LastModifiedDate.Value.ToString("dd-MMM-yyyy"),
                        AppraisalYear = temp.AppraisalYear,
                        HasAddRights = temp.HasAddRights,
                        HasViewRights = temp.HasViewRights,
                        HasApproverRights = temp.HasApproverRights,
                        TeamName = temp.TeamName,
                        DepartmentHead = temp.DepartmentHead,
                        DepartmentName = temp.DepartmentName
                    });
                }
                return result;
            }
            return null;
        }

        public int MarkTeamGoalAsAchieved(string userAbrhs, DateTime date, string remarks, long goalId)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            var data = _dbContext.TeamGoals.FirstOrDefault(x => x.TeamGoalId == goalId && x.IsActive);
            if (data != null)
            {
                if (data.GoalStatusId == (long)Enums.GoalStatus.Approved) //goal is in approved state
                {
                    if (data.CreatedBy == userId)
                    {
                        data.GoalStatusId = (long)Enums.GoalStatus.Achieved;
                        data.LastModifiedBy = userId;
                        data.LastModifiedDate = date;
                        _dbContext.TeamGoalHistories.Add(new TeamGoalHistory
                        {
                            TeamGoalId = data.TeamGoalId,
                            StartDateId = data.StartDateId,
                            EndDateId = data.EndDateId,
                            Goal = data.Goal,
                            GoalCategoryId = data.GoalCategoryId,
                            GoalStatusId = (long)Enums.GoalStatus.Achieved,
                            Remarks = remarks,
                            CreatedDate = DateTime.Now,
                            CreatedBy = userId,
                        });

                        _dbContext.SaveChanges();
                        return 1;
                    }
                    return 2;
                }
                return 3;
            }
            return 4;
        }

        public bool DeleteTeamGoal(long goalId, string remarks, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var data = _dbContext.TeamGoals.FirstOrDefault(x => x.TeamGoalId == goalId && x.IsActive);
            if (data != null)
            {
                data.OtherRemark = remarks;
                data.IsActive = false;
                data.GoalStatusId = (long)Enums.GoalStatus.Deleted; //6 Deleted
                data.LastModifiedBy = userId;
                data.LastModifiedDate = DateTime.Now;

                if (userId != data.CreatedBy)
                {
                    data.GoalStatusId = (long)Enums.GoalStatus.Rejected; //5 Rejected
                    _dbContext.TeamGoalHistories.Add(new TeamGoalHistory
                    {
                        TeamGoalId = data.TeamGoalId,
                        StartDateId = data.StartDateId,
                        EndDateId = data.EndDateId,
                        Goal = data.Goal,
                        GoalCategoryId = data.GoalCategoryId,
                        GoalStatusId = (long)Enums.GoalStatus.Rejected, //5 Rejected
                        Remarks = remarks,
                        CreatedDate = DateTime.Now,
                        CreatedBy = userId,
                    });
                }

                _dbContext.SaveChanges();

                return true;
            }
            return false;
        }

        public int ApproveTeamGoal(string goalIds, string userAbrhs)
        {
            int statusId = 0;
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var result = new ObjectParameter("Success", typeof(int));
            _dbContext.Proc_ApproveTeamGoal(goalIds, userId, result);
            Int32.TryParse(result.Value.ToString(), out statusId);

            return statusId;
        }

        public bool AddTeamGoal(AddGoalBO goalDetails)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(goalDetails.UserAbrhs), out userId);

            var teamId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(goalDetails.TeamAbrhs), out teamId);
            goalDetails.GoalList.RemoveAll(x => x.StartDate == null || x.EndDate == null || x.Goal == null);
            if (goalDetails.GoalList != null)
            {
                var goalXmlString = new XElement("Root",
                    from goal in goalDetails.GoalList
                    select new XElement("Row",
                           new XAttribute("StartDate", goal.StartDate),
                            new XAttribute("EndDate", goal.EndDate),
                            new XAttribute("GoalCategoryId", goal.GoalCategoryId),
                            new XAttribute("Goal", goal.Goal)
                            ));
                var result = _dbContext.Proc_AddTeamGoals(teamId, goalXmlString.ToString(), userId, goalDetails.GoalCycleId);
                return true;
            }
            return false;
        }

        public bool SubmitTeamGoal(string goalIds, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            return _dbContext.Proc_SubmitTeamGoals(goalIds, userId).FirstOrDefault().Value;
        }

        public int DraftTeamGoal(AddGoalBO goalDetails)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(goalDetails.UserAbrhs), out userId);

            var teamId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(goalDetails.TeamAbrhs), out teamId);
            goalDetails.GoalList.RemoveAll(x => x.StartDate == null || x.EndDate == null || x.Goal == null);
            var appraisalcycleData = _dbContext.AppraisalCycles.FirstOrDefault(t => t.AppraisalCycleId == goalDetails.GoalCycleId);

            if (appraisalcycleData == null)
                return 2;

            if (goalDetails.GoalList != null)
            {
                var goalXmlString = new XElement("Root",
                    from goal in goalDetails.GoalList
                    select new XElement("Row",
                           new XAttribute("StartDate", goal.StartDate),
                            new XAttribute("EndDate", goal.EndDate),
                            new XAttribute("GoalCategoryId", goal.GoalCategoryId),
                            new XAttribute("Goal", goal.Goal)
                            ));
                var result = _dbContext.Proc_DraftTeamGoals(teamId, goalXmlString.ToString(), userId, goalDetails.GoalCycleId);
                return 1;
            }
            return 0;
        }

        public int EditTeamGoal(GoalDetailBO goal)
        {
            int statusId = 0;

            if (string.IsNullOrEmpty(goal.StartDate) || string.IsNullOrEmpty(goal.EndDate)
                || string.IsNullOrEmpty(goal.Goal) || string.IsNullOrEmpty(goal.UserAbrhs))
                return statusId;

            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(goal.UserAbrhs), out userId);
            var data = _dbContext.TeamGoals.FirstOrDefault(x => x.TeamGoalId == goal.GoalId && x.IsActive);
            if (data == null)
                return statusId;

            DateTime goalStartDate = DateTime.ParseExact(goal.StartDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            DateTime goalEndDate = DateTime.ParseExact(goal.EndDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);

          
            var result = new ObjectParameter("Success", typeof(int));
            _dbContext.Proc_EditTeamGoal(goal.GoalId, goalStartDate, goalEndDate, goal.Goal, goal.GoalCategoryId, userId, result);
            Int32.TryParse(result.Value.ToString(), out statusId);
            return statusId;
        }

        public GoalDetailBO FetchTeamGoalDetailById(long goalId)
        {
            var data = _dbContext.TeamGoals.FirstOrDefault(x => x.TeamGoalId == goalId && x.IsActive);
            if (data == null)
                return null;
            string startDate = _dbContext.DateMasters.FirstOrDefault(x => x.DateId == data.StartDateId).Date.ToString("MM/dd/yyyy", CultureInfo.InvariantCulture);
            string endDate = _dbContext.DateMasters.FirstOrDefault(x => x.DateId == data.EndDateId).Date.ToString("MM/dd/yyyy", CultureInfo.InvariantCulture);
            return new GoalDetailBO
            {
                StartDate = startDate,
                EndDate = endDate,
                Goal = data.Goal,
                GoalCategoryId = data.GoalCategoryId,
                GoalCategory = data.GoalCategory.Category

            };
        }

        public List<GoalDetailBO> FetchTeamGoalHistoryById(int goalId)
        {
            return _dbContext.Proc_GetTeamGoalHistoryById(goalId).Select(x => new GoalDetailBO
            {
                Goal = x.Goal,
                StartDate = x.StartDate,
                EndDate = x.EndDate,
                GoalCategory = x.Category,
                Status = x.Status,
                Remark = x.Remarks,
                CreatedBy = x.CreatedBy,
                CreatedDate = x.CreatedDate.ToString("dd-MMM-yyyy HH:mm tt")
            }).ToList();
        }

        public bool GetUserPrivilegesToAddTeamGoal(int userId, string teamAbrhs)
        {
            var teamId = 0;
            var hasAddRights = false;

            Int32.TryParse(CryptoHelper.Decrypt(teamAbrhs), out teamId);
            var data = _dbContext.Fun_GetUserPrevilegesForTeamGoal(userId, teamId).FirstOrDefault();
            if (data != null)
            {
                hasAddRights = data.HasAddRights;
            }
            return hasAddRights;
        }

        #endregion

        #endregion

        #region Manage Team Appraisal

        public List<ManageTeamAppraisalBO> GetEmpAppraisalSetting(ManageTeamAppraisalFilterBO data)
        {
            List<ManageTeamAppraisalBO> returnBO = new List<ManageTeamAppraisalBO>();
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(data.UserAbrhs), out userId);

            if (data.FetchForId == 4)
            {
                data.AppraiserIds = string.Empty;
                data.ApproverIds = string.Empty;
            }
            else if (data.FetchForId == 1)
            {
                data.AppraiserIds = userId.ToString();
            }
            else if (data.FetchForId == 2)
            {
                data.ApproverIds = userId.ToString();
            }
            else if (data.FetchForId == 3)
            {
                data.AppraiserIds = userId.ToString();
                data.ApproverIds = userId.ToString();
            }

            if (userId > 0)
            {
                returnBO = _dbContext.Proc_GetEmpAppraisalSetting(data.IsTeamData, data.AppraisalCycleId, data.LocationId, data.VerticalIds, data.DivisionIds, data.DepartmentIds, data.TeamIds, data.DesignationIds, data.EmployeeId,
                                                                  data.AppraisalStatusIds, data.AppraiserIds, data.ApproverIds, data.EmpAppraisalSettingId, userId).Select(x => new ManageTeamAppraisalBO
                                                                  {
                                                                      EmpAppraisalSettingId = x.EmpAppraisalSettingId,
                                                                      EmployeeId = x.EmployeeId,
                                                                      EmployeeName = x.EmployeeName,
                                                                      LocationId = x.LocationId,
                                                                      VerticalId = x.VerticalId,
                                                                      DivisionId = x.DivisionId,
                                                                      DepartmentId = x.DepartmentId,
                                                                      TeamId = x.TeamId,
                                                                      DesignationId = x.DesignationId,
                                                                      DesignationName = x.DesignationName,
                                                                      AppraiserId = x.AppraiserId,
                                                                      AppraiserName = x.AppraiserName,
                                                                      RMId = x.RMId,
                                                                      RMName = x.RMName,
                                                                      HRId = x.HRId,
                                                                      HRName = x.HRName,
                                                                      IsSelfAppraisal = x.IsSelfAppraisal,
                                                                      CompetencyFormId = x.CompetencyFormId,
                                                                      CompetencyFormName = x.CompetencyFormName,
                                                                      AppraisalCycleId = x.AppraisalCycleId,
                                                                      AppraisalCycleName = x.AppraisalCycleName,
                                                                      StartDate = x.StartDate,
                                                                      EndDate = x.EndDate,
                                                                      Approver1 = x.Approver1,
                                                                      Approver1Name = x.Approver1Name,
                                                                      Approver2 = x.Approver2,
                                                                      Approver2Name = x.Approver2Name,
                                                                      Approver3 = x.Approver3,
                                                                      Approver3Name = x.Approver3Name,
                                                                      AppraisalStatusId = x.AppraisalStatusId,
                                                                      AppraisalStatusName = x.AppraisalStatusName,
                                                                      LastPromotionDate = x.LastPromotionDate,
                                                                      LastPromotionDesignationId = x.LastPromotionDesignationId,
                                                                      LastAppraisalCycleId = x.LastAppraisalCycleId,
                                                                      LastAppraisalCycleName = x.LastAppraisalCycleName,
                                                                      EmployeePhotoName = x.EmployeePhotoName,
                                                                      AppraisalStatges = x.AppraisalStatges,
                                                                      AppraisalJsonStatges = x.AppraisalJsonStatges,
                                                                      IsSettingModified = x.IsSettingModified,
                                                                      IsModifyRight = x.IsModifyRight,
                                                                      IsVisible = x.IsVisible,
                                                                      Reason = x.Reason,
                                                                      IsFinalized = x.IsFinalized,
                                                                  }).ToList().Where(x => x.EmployeeId != userId).ToList();
            }
            return returnBO;
        }

        public List<ManageTeamAppraisalBO> GetTeamAppraiselEditData(ManageTeamAppraisalFilterBO data)
        {
            List<ManageTeamAppraisalBO> returnBO = new List<ManageTeamAppraisalBO>();
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(data.UserAbrhs), out userId);
            if (userId > 0)
            {
                var result = _dbContext.Proc_GetEmpAppraisalSettingDetail(userId, data.EmpAppraisalSettingId, data.EmployeeId, data.AppraisalCycleId).ToList();
                if (result.Any())
                {
                    foreach (var x in result)
                    {
                        ManageTeamAppraisalBO manageTeamAppraisalBO = new ManageTeamAppraisalBO();
                        manageTeamAppraisalBO.EmpAppraisalSettingId = x.EmpAppraisalSettingId;
                        manageTeamAppraisalBO.EmployeeId = x.EmployeeId;
                        manageTeamAppraisalBO.EmployeeName = x.EmployeeName;
                        manageTeamAppraisalBO.LocationId = x.LocationId;
                        manageTeamAppraisalBO.VerticalId = x.VerticalId;
                        manageTeamAppraisalBO.DivisionId = x.DivisionId;
                        manageTeamAppraisalBO.DepartmentId = x.DepartmentId;
                        manageTeamAppraisalBO.TeamId = x.TeamId;
                        manageTeamAppraisalBO.DesignationId = x.DesignationId;
                        manageTeamAppraisalBO.DesignationName = x.DesignationName;
                        manageTeamAppraisalBO.AppraiserName = x.AppraiserName;
                        manageTeamAppraisalBO.RMId = x.RMId;
                        manageTeamAppraisalBO.RMName = x.RMName;
                        manageTeamAppraisalBO.IsHRBP = x.IsHRBP;
                        manageTeamAppraisalBO.IsSelfAppraisal = x.IsSelfAppraisal;
                        manageTeamAppraisalBO.CompetencyFormId = x.CompetencyFormId;
                        manageTeamAppraisalBO.CompetencyFormName = x.CompetencyFormName;
                        manageTeamAppraisalBO.AppraisalCycleId = x.AppraisalCycleId;
                        manageTeamAppraisalBO.AppraisalCycleName = x.AppraisalCycleName;
                        manageTeamAppraisalBO.StartDate = x.StartDate;
                        manageTeamAppraisalBO.EndDate = x.EndDate;
                        manageTeamAppraisalBO.Approver1 = x.Approver1;
                        manageTeamAppraisalBO.Approver1Name = x.Approver1Name;
                        manageTeamAppraisalBO.Approver2 = x.Approver2;
                        manageTeamAppraisalBO.Approver3 = x.Approver3;
                        manageTeamAppraisalBO.AppraisalStatusId = x.AppraisalStatusId;
                        manageTeamAppraisalBO.AppraisalStatusName = x.AppraisalStatusName;
                        manageTeamAppraisalBO.LastPromotionDate = x.LastPromotionDate;
                        manageTeamAppraisalBO.LastPromotionDesignationId = x.LastPromotionDesignationId;
                        manageTeamAppraisalBO.AppraisalJsonStatges = x.AppraisalJsonStatges;
                        manageTeamAppraisalBO.AppraiserIdAbrhs = CryptoHelper.Encrypt(x.AppraiserId.ToString());
                        manageTeamAppraisalBO.Approver1Abrhs = CryptoHelper.Encrypt(x.Approver1.ToString());
                        returnBO.Add(manageTeamAppraisalBO);
                    }

                }
            }
            return returnBO;
        }

        public AddUpdateReturnBO UpdateAppraisalTeamSettings(UpdateAppraisalTeamSettingsBO data)
        {
            AddUpdateReturnBO returnBO = new AddUpdateReturnBO();
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(data.UserAbrhs), out userId);

            var approver1 = 0;
            Int32.TryParse(CryptoHelper.Decrypt(data.Approver1Abrhs), out approver1);
            var appraiser = 0;
            Int32.TryParse(CryptoHelper.Decrypt(data.AppraiserAbrhs), out appraiser);

            if (data.CompetencyFormId > 0 && data.EmpAppraisalSettingId > 0 && userId > 0)
            {
                var ParameterxmlString = new XElement("root",
                  from pxs in data.AppraisalStagesList
                  select new XElement("row",
                         new XAttribute("AppraisalStageId", pxs.AppraisalStageId),
                          new XAttribute("EndDate", pxs.EndDate)
                          ));

                var success = new ObjectParameter("Success", typeof(string));
                _dbContext.Proc_AddUpdateEmpAppraisalSetting(data.EmpAppraisalSettingId, data.EmployeeId, data.AppraisalCycleId, true, 1, data.CompetencyFormId, data.StartDate, data.EndDate, appraiser, approver1, data.Approver2, data.Approver3, ParameterxmlString.ToString(), userId, success);
                returnBO.Status = success.Value.ToString();
            }
            return returnBO;
        }


        #endregion

        #region Appraisal form view by  management
        public List<ManageTeamAppraisalBO> GetAllEmployeesAppraisal(ManageTeamAppraisalFilterBO data)
        {
            List<ManageTeamAppraisalBO> returnBO = new List<ManageTeamAppraisalBO>();
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(data.UserAbrhs), out userId);
            if (userId > 0)
            {
                returnBO = _dbContext.Proc_GetEmpAppraisalSetting(data.IsTeamData, data.AppraisalCycleId, data.LocationId, data.VerticalIds, data.DivisionIds, data.DepartmentIds, data.TeamIds, data.DesignationIds, data.EmployeeId,
                                                                  data.AppraisalStatusIds, data.AppraiserIds, data.ApproverIds, data.EmpAppraisalSettingId, userId).Select(x => new ManageTeamAppraisalBO
                                                                  {
                                                                      EmpAppraisalSettingId = x.EmpAppraisalSettingId,
                                                                      EmployeeId = x.EmployeeId,
                                                                      EmployeeName = x.EmployeeName,
                                                                      LocationId = x.LocationId,
                                                                      VerticalId = x.VerticalId,
                                                                      DivisionId = x.DivisionId,
                                                                      DepartmentId = x.DepartmentId,
                                                                      TeamId = x.TeamId,
                                                                      DesignationId = x.DesignationId,
                                                                      DesignationName = x.DesignationName,
                                                                      AppraiserId = x.AppraiserId,
                                                                      AppraiserName = x.AppraiserName,
                                                                      RMId = x.RMId,
                                                                      RMName = x.RMName,
                                                                      HRId = x.HRId,
                                                                      HRName = x.HRName,
                                                                      IsSelfAppraisal = x.IsSelfAppraisal,
                                                                      CompetencyFormId = x.CompetencyFormId,
                                                                      CompetencyFormName = x.CompetencyFormName,
                                                                      AppraisalCycleId = x.AppraisalCycleId,
                                                                      AppraisalCycleName = x.AppraisalCycleName,
                                                                      StartDate = x.StartDate,
                                                                      EndDate = x.EndDate,
                                                                      Approver1 = x.Approver1,
                                                                      Approver1Name = x.Approver1Name,
                                                                      Approver2 = x.Approver2,
                                                                      Approver2Name = x.Approver2Name,
                                                                      Approver3 = x.Approver3,
                                                                      Approver3Name = x.Approver3Name,
                                                                      AppraisalStatusId = x.AppraisalStatusId,
                                                                      AppraisalStatusName = x.AppraisalStatusName,
                                                                      LastPromotionDate = x.LastPromotionDate,
                                                                      LastPromotionDesignationId = x.LastPromotionDesignationId,
                                                                      LastAppraisalCycleId = x.LastAppraisalCycleId,
                                                                      LastAppraisalCycleName = x.LastAppraisalCycleName,
                                                                      EmployeePhotoName = x.EmployeePhotoName,
                                                                      AppraisalStatges = x.AppraisalStatges,
                                                                      AppraisalJsonStatges = x.AppraisalJsonStatges,
                                                                      IsSettingModified = x.IsSettingModified,
                                                                      IsModifyRight = x.IsModifyRight,
                                                                      IsVisible = x.IsVisible,
                                                                      Reason = x.Reason,
                                                                      IsFinalized = x.IsFinalized,
                                                                  }).ToList().Where(x => x.EmployeeId != userId).ToList();
            }
            return returnBO;
        }

        #endregion

        #region Appraisal Not Generated

        public List<AppraisalNotGeneratedList> GetAppraisalNotGeneratedList(AppraisalSettingsFilterBO data)
        {
            List<AppraisalNotGeneratedList> returnBO = new List<AppraisalNotGeneratedList>();
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(data.UserAbrhs), out userId);
            if (userId > 0)
            {
                returnBO = _dbContext.Proc_GetEmpAppraisalSettingNotGenerated(userId, data.AppraisalCycleId, data.LocationId, data.VerticalIds, data.DivisionIds, data.DepartmentIds, data.TeamIds, data.DesignationIds, 0).Select(x => new AppraisalNotGeneratedList
                {
                    EmployeeId = x.EmployeeId,
                    EmployeeName = x.EmployeeName,
                    DesignationId = x.DesignationId,
                    DesignationName = x.DesignationName,
                    LocationId = x.LocationId,
                    VerticalId = x.VerticalId,
                    DivisionId = x.DivisionId,
                    DepartmentId = x.DepartmentId,
                    TeamId = x.TeamId,
                    AppraiserId = x.AppraiserId,
                    RMId = x.RMId,
                    IsSelfAppraisal = x.IsSelfAppraisal,
                    CompetencyFormId = x.CompetencyFormId,
                    CompetencyFormName = x.CompetencyFormName,
                    Reason = x.Reason,
                    IsGenerate = x.IsGenerate,

                    LocationName = x.LocationName,
                    VerticalName = x.VerticalName,
                    DivisionName = x.DivisionName,
                    DepartmentName = x.DepartmentName,
                    TeamName = x.TeamName,
                    AppraiserName = x.AppraiserName,
                    RMName = x.RMName,

                    AppraisalCycleId = x.AppraisalCycleId,
                    AppraisalCycleName = x.AppraisalCycleName,
                }).ToList();

            }
            return returnBO;
        }

        public int CreatePendingEmpAppraisalSetting(int? EmployeeId, int? AppraisalCycleId, string UserAbrhs)
        {
            //string returnBO = "0";
            var result = 0;
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(UserAbrhs), out userId);
            if (userId > 0)
            {
                var Status = new ObjectParameter("Success", typeof(int));
                var Result = _dbContext.Proc_CreatePendingEmpAppraisalSetting(AppraisalCycleId, EmployeeId, userId, Status);
                result = Convert.ToInt32(Status.Value);
            }
            return result;
            //return returnBO;
        }

        #endregion

        #region My Appraisal

        public List<ManageTeamAppraisalBO> GetSelfAppraiselData(ManageTeamAppraisalFilterBO data)
        {
            List<ManageTeamAppraisalBO> returnBO = new List<ManageTeamAppraisalBO>();
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(data.UserAbrhs), out userId);
            if (userId > 0)
            {
                returnBO = _dbContext.Proc_GetEmpAppraisalSetting(true, data.AppraisalCycleId, data.LocationId, data.VerticalIds, data.DivisionIds, data.DepartmentIds, data.TeamIds, data.DesignationIds, userId,
                                                                  data.AppraisalStatusIds, data.AppraiserIds, data.ApproverIds, data.EmpAppraisalSettingId, userId).Select(x => new ManageTeamAppraisalBO
                                                                  {
                                                                      EmpAppraisalSettingId = x.EmpAppraisalSettingId,
                                                                      EmployeeId = x.EmployeeId,
                                                                      EmployeeName = x.EmployeeName,
                                                                      LocationId = x.LocationId,
                                                                      VerticalId = x.VerticalId,
                                                                      DivisionId = x.DivisionId,
                                                                      DepartmentId = x.DepartmentId,
                                                                      TeamId = x.TeamId,
                                                                      DesignationId = x.DesignationId,
                                                                      DesignationName = x.DesignationName,
                                                                      AppraiserId = x.AppraiserId,
                                                                      AppraiserName = x.AppraiserName,
                                                                      RMId = x.RMId,
                                                                      RMName = x.RMName,
                                                                      HRId = x.HRId,
                                                                      HRName = x.HRName,
                                                                      IsSelfAppraisal = x.IsSelfAppraisal,
                                                                      CompetencyFormId = x.CompetencyFormId,
                                                                      CompetencyFormName = x.CompetencyFormName,
                                                                      AppraisalCycleId = x.AppraisalCycleId,
                                                                      AppraisalCycleName = x.AppraisalCycleName,
                                                                      StartDate = x.StartDate,
                                                                      EndDate = x.EndDate,
                                                                      Approver1 = x.Approver1,
                                                                      Approver1Name = x.Approver1Name,
                                                                      Approver2 = x.Approver2,
                                                                      Approver2Name = x.Approver2Name,
                                                                      Approver3 = x.Approver3,
                                                                      Approver3Name = x.Approver3Name,
                                                                      AppraisalStatusId = x.AppraisalStatusId,
                                                                      AppraisalStatusName = x.AppraisalStatusName,
                                                                      LastPromotionDate = x.LastPromotionDate,
                                                                      LastPromotionDesignationId = x.LastPromotionDesignationId,
                                                                      LastAppraisalCycleId = x.LastAppraisalCycleId,
                                                                      LastAppraisalCycleName = x.LastAppraisalCycleName,
                                                                      EmployeePhotoName = x.EmployeePhotoName,
                                                                      AppraisalStatges = x.AppraisalStatges,
                                                                      AppraisalJsonStatges = x.AppraisalJsonStatges,
                                                                      IsSettingModified = x.IsSettingModified,
                                                                      IsModifyRight = x.IsModifyRight,
                                                                      IsVisible = x.IsVisible,
                                                                      Reason = x.Reason,
                                                                      IsFinalized = x.IsFinalized,
                                                                  }).ToList();
            }
            return returnBO;
        }

        public List<AppraisalLogModal> GetStatusHistory(int? empAppraisalSettingId, string userAbrhs)
        {
            List<AppraisalLogModal> returnBO = new List<AppraisalLogModal>();
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            if (userId > 0)
            {
                returnBO = _dbContext.Proc_GetEmpAppraisalLog(empAppraisalSettingId).Select(x => new AppraisalLogModal
                {
                    RowNo = x.RowNo,
                    Date = x.Date,
                    FeedbackStatusName = x.FeedbackStatusName,
                    Description = x.Description,
                    Comment = x.Comment,
                    UpdateBy = x.UpdateBy,
                }).ToList();

            }
            return returnBO;
        }

        public AddUpdateReturnBO UpdateStatus(int empAppraisalSettingId, int statusId, string resonForDissmiss, string userAbrhs)
        {
            AddUpdateReturnBO returnBO = new AddUpdateReturnBO();
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            if (userId > 0)
            {
                var Status = new ObjectParameter("Success", typeof(int));
                var ActionDesc = new ObjectParameter("ActionDesc", typeof(string));
                //var result= _dbContext.Proc_UpdateEmpAppraisalStatus(empAppraisalSettingId, statusId, resonForDissmiss, userId, Status, ActionDesc);
                //returnBO.Status = result.Status.Value.ToString();
                //returnBO.Result = result.ActionDesc.Value.ToString();
            }
            return returnBO;
        }

        #endregion

        #region Appraisal Form

        public AppraisalFormBO GetAppraisalFormData(int empAppraisalSettingId, string digestKey, string userAbrhs)
        {
            AppraisalFormBO returnBO = new AppraisalFormBO();
            int userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            if (userId > 0)
            {
                var result = _dbContext.Proc_GetEmpAppraisalForm(userId, empAppraisalSettingId).FirstOrDefault();
                if (result != null)
                {
                    var x = result;
                    returnBO.EmpAppraisalSettingId = x.EmpAppraisalSettingId;
                    returnBO.UserId = x.UserId;
                    returnBO.EmployeeName = x.EmployeeName;
                    returnBO.EmployeeCode = x.EmployeeCode;
                    returnBO.DateOfJoin = x.DateOfJoin;
                    returnBO.DesignationName = x.DesignationName;
                    returnBO.AppraiserId = x.AppraiserId;
                    returnBO.AppraiserName = x.AppraiserName;
                    returnBO.AppraiserDesignation = x.AppraiserDesignation;
                    returnBO.RMId = x.RMId;
                    returnBO.RMName = x.RMName;
                    returnBO.HRId = x.HRId;
                    returnBO.HRName = x.HRName;
                    returnBO.StartDate = x.StartDate;
                    returnBO.EndDate = x.EndDate;
                    returnBO.IsSelfAppraisal = x.IsSelfAppraisal;
                    returnBO.CompetencyFormId = x.CompetencyFormId;
                    returnBO.CompetencyFormName = x.CompetencyFormName;
                    returnBO.IsRating = x.IsRating;
                    returnBO.AppraisalCycleId = x.AppraisalCycleId;
                    returnBO.AppraisalCycleName = x.AppraisalCycleName;
                    returnBO.ReviewFrom = x.ReviewFrom;
                    returnBO.ReviewTo = x.ReviewTo;
                    returnBO.Approver1 = x.Approver1;
                    returnBO.Approver1Name = x.Approver1Name;
                    returnBO.Approver1Designation = x.Approver1Designation;
                    returnBO.Approver2 = x.Approver2;
                    returnBO.Approver2Name = x.Approver2Name;
                    returnBO.Approver3 = x.Approver3;
                    returnBO.Approver3Name = x.Approver3Name;
                    returnBO.AppraisalStatusId = x.AppraisalStatusId;
                    returnBO.AppraisalStatusName = x.AppraisalStatusName;
                    returnBO.AppraiseeComment = x.AppraiseeComment;
                    returnBO.AppraiserComment = x.AppraiserComment;
                    returnBO.ApproverComment = x.ApproverComment;
                    returnBO.EmpAppraisalId = x.EmpAppraisalId;
                    returnBO.AppraisalParameterDetail = x.AppraisalParameterDetail;
                    returnBO.IsViewRight = x.IsViewRight;
                    returnBO.IsModifyRight = x.IsModifyRight;
                    returnBO.EmployeeGoals = x.EmployeeGoals;
                    returnBO.EmployeeAchievements = x.EmployeeAchievements;

                    returnBO.AppraiseeAbrhs = CryptoHelper.Encrypt((x.UserId).ToString());
                    returnBO.AppraiserAbrhs = CryptoHelper.Encrypt((x.AppraiserId).ToString());
                    returnBO.ApproverAbrhs = CryptoHelper.Encrypt((x.Approver1).ToString());

                    returnBO.AppraiserRecommendedForDesignationId = x.AppraiserRecommendedForDesignationId;
                    returnBO.AppraiserRecommendedPercentage = x.AppraiserRecommendedPercentage;
                    returnBO.AppraiserRecommendationComment = x.AppraiserRecommendationComment;
                    returnBO.Approver1RecommendedForDesignationId = x.Approver1RecommendedForDesignationId;
                    returnBO.Approver1RecommendedPercentage = x.Approver1RecommendedPercentage;
                    returnBO.Approver1RecommendationComment = x.Approver1RecommendationComment;
                    returnBO.AppraiserMarkedHighPotential = x.AppraiserMarkedHighPotential;
                    returnBO.AppraiserHighPotentialComment = x.AppraiserHighPotentialComment;
                    returnBO.Approver1MarkedHighPotential = x.Approver1MarkedHighPotential;
                    returnBO.Approver1HighPotentialComment = x.Approver1HighPotentialComment;

                    returnBO.SelfOverallRatingWeighted = x.SelfOverallRatingWeighted;
                    returnBO.AppraiserOverallRatingWeighted = x.AppraiserOverallRatingWeighted;
                    returnBO.ApproverOverallRatingWeighted = x.ApproverOverallRatingWeighted;
                    returnBO.SelfOverallRatingNormal = x.SelfOverallRatingNormal;
                    returnBO.AppraiserOverallRatingNormal = x.AppraiserOverallRatingNormal;
                    returnBO.ApproverOverallRatingNormal = x.ApproverOverallRatingNormal;

                    returnBO.SelfSubmitDate = x.SelfSubmitDate;
                }
                //.Select(x => new AppraisalFormBO
                //{

                //}).FirstOrDefault();
            }
            return returnBO;
        }

        public List<BaseDropDown> GetPromotionDesignationsByUserId(int empAppraisalSettingId, string userAbrhs)
        {
            var data = _dbContext.spGetPromotionDesignationsList(empAppraisalSettingId).Select(x => new BaseDropDown
            {
                Text = x.DesignationName,
                Value = x.DesignationId,
                Selected = false
            }).OrderBy(t => t.Text).ToList();
            return data;
        }

        public AppraisalFormBO GetAppraisalFormDataForManagement(int empAppraisalSettingId, string digestKey, string userAbrhs)
        {
            AppraisalFormBO returnBO = new AppraisalFormBO();
            int userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            if (userId > 0)
            {
                var result = _dbContext.Proc_GetEmpAppraisalFormForManagement(userId, empAppraisalSettingId).FirstOrDefault();
                if (result != null)
                {
                    var x = result;
                    returnBO.EmpAppraisalSettingId = x.EmpAppraisalSettingId;
                    returnBO.UserId = x.UserId;
                    returnBO.EmployeeName = x.EmployeeName;
                    returnBO.EmployeeCode = x.EmployeeCode;
                    returnBO.DateOfJoin = x.DateOfJoin;
                    returnBO.DesignationName = x.DesignationName;
                    returnBO.AppraiserId = x.AppraiserId;
                    returnBO.AppraiserName = x.AppraiserName;
                    returnBO.AppraiserDesignation = x.AppraiserDesignation;
                    returnBO.RMId = x.RMId;
                    returnBO.RMName = x.RMName;
                    returnBO.HRId = x.HRId;
                    returnBO.HRName = x.HRName;
                    returnBO.StartDate = x.StartDate;
                    returnBO.EndDate = x.EndDate;
                    returnBO.IsSelfAppraisal = x.IsSelfAppraisal;
                    returnBO.CompetencyFormId = x.CompetencyFormId;
                    returnBO.CompetencyFormName = x.CompetencyFormName;
                    returnBO.IsRating = x.IsRating;
                    returnBO.AppraisalCycleId = x.AppraisalCycleId;
                    returnBO.AppraisalCycleName = x.AppraisalCycleName;
                    returnBO.ReviewFrom = x.ReviewFrom;
                    returnBO.ReviewTo = x.ReviewTo;
                    returnBO.Approver1 = x.Approver1;
                    returnBO.Approver1Name = x.Approver1Name;
                    returnBO.Approver1Designation = x.Approver1Designation;
                    returnBO.Approver2 = x.Approver2;
                    returnBO.Approver2Name = x.Approver2Name;
                    returnBO.Approver3 = x.Approver3;
                    returnBO.Approver3Name = x.Approver3Name;
                    returnBO.AppraisalStatusId = x.AppraisalStatusId;
                    returnBO.AppraisalStatusName = x.AppraisalStatusName;
                    returnBO.AppraiseeComment = x.AppraiseeComment;
                    returnBO.AppraiserComment = x.AppraiserComment;
                    returnBO.ApproverComment = x.ApproverComment;
                    returnBO.EmpAppraisalId = x.EmpAppraisalId;
                    returnBO.AppraisalParameterDetail = x.AppraisalParameterDetail;
                    returnBO.IsViewRight = x.IsViewRight;
                    returnBO.IsModifyRight = x.IsModifyRight;
                    returnBO.EmployeeGoals = x.EmployeeGoals;
                    returnBO.EmployeeAchievements = x.EmployeeAchievements;

                    returnBO.AppraiseeAbrhs = CryptoHelper.Encrypt((x.UserId).ToString());
                    returnBO.AppraiserAbrhs = CryptoHelper.Encrypt((x.AppraiserId).ToString());
                    returnBO.ApproverAbrhs = CryptoHelper.Encrypt((x.Approver1).ToString());

                    returnBO.AppraiserRecommendedForDesignationId = x.AppraiserRecommendedForDesignationId;
                    returnBO.AppraiserRecommendedPercentage = x.AppraiserRecommendedPercentage;
                    returnBO.AppraiserRecommendationComment = x.AppraiserRecommendationComment;
                    returnBO.Approver1RecommendedForDesignationId = x.Approver1RecommendedForDesignationId;
                    returnBO.Approver1RecommendedPercentage = x.Approver1RecommendedPercentage;
                    returnBO.Approver1RecommendationComment = x.Approver1RecommendationComment;
                    returnBO.AppraiserMarkedHighPotential = x.AppraiserMarkedHighPotential;
                    returnBO.AppraiserHighPotentialComment = x.AppraiserHighPotentialComment;
                    returnBO.Approver1MarkedHighPotential = x.Approver1MarkedHighPotential;
                    returnBO.Approver1HighPotentialComment = x.Approver1HighPotentialComment;

                    returnBO.SelfOverallRatingWeighted = x.SelfOverallRatingWeighted;
                    returnBO.AppraiserOverallRatingWeighted = x.AppraiserOverallRatingWeighted;
                    returnBO.ApproverOverallRatingWeighted = x.ApproverOverallRatingWeighted;
                    returnBO.SelfOverallRatingNormal = x.SelfOverallRatingNormal;
                    returnBO.AppraiserOverallRatingNormal = x.AppraiserOverallRatingNormal;
                    returnBO.ApproverOverallRatingNormal = x.ApproverOverallRatingNormal;

                    returnBO.SelfSubmitDate = x.SelfSubmitDate;
                }
                //.Select(x => new AppraisalFormBO
                //{

                //}).FirstOrDefault();
            }
            return returnBO;
        }

        /// <summary>
        /// Save Appraisal Form Tab Data
        /// </summary>
        /// <param name="appraisalFormData"></param>
        /// <returns></returns>
        public AppraisalFormReturnBO SaveEmployeeAppraisalForm(AppraisalFormXmlBO appraisalFormData)
        {
            var appraisalFormReturnBO = new AppraisalFormReturnBO();
            if (appraisalFormData != null && appraisalFormData.AppraisalParameter.Any())
            {
                int userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(appraisalFormData.UserAbrhs), out userId);

                var xmlElements = new XElement("root",
                    from ap in appraisalFormData.AppraisalParameter
                    select new XElement("row",
                            new XAttribute("EAParameterDetailId", ap.EAParameterDetailId),
                            new XAttribute("CompetencyFormDetailId", ap.CompetencyFormDetailId),
                            new XAttribute("Comment", ap.Comment),
                            new XAttribute("RatingId", ap.RatingId)
                            ));

                var empAppraisalId = new ObjectParameter("EmpAppraisalId", typeof(int));
                var result = new ObjectParameter("Success", typeof(string));
                var ratings = new ObjectParameter("Ratings", typeof(string));
                var resultData = _dbContext.Proc_AddUpdateEmpAppraisalForm(appraisalFormData.EmpAppraisalSettingId
                                        , appraisalFormData.ReviewPeriod, Convert.ToDateTime(appraisalFormData.ExposerFromDate)
                                        , Convert.ToDateTime(appraisalFormData.ExposerToDate), xmlElements.ToString(), userId, empAppraisalId, result, ratings);

                //appraisalFormReturnBO.EmpAppraisalId = Convert.ToInt32(empAppraisalId.Value);
                appraisalFormReturnBO.Result = result.Value.ToString();
                appraisalFormReturnBO.Ratings = ratings.Value.ToString();
            }
            return appraisalFormReturnBO;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="goalData"></param>
        /// <returns>1: success; 2: unauthorised user, 0: error/exception from proc, 3: data missing</returns>
        public int SaveEmployeeAppraisalGoal(GoalXmlBO goalData)
        {
            if (goalData != null && goalData.DetailList.Any())
            {
                int userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(goalData.UserAbrhs), out userId);

                var xmlElements = new XElement("root",
                    from g in goalData.DetailList
                    select new XElement("row",
                            new XAttribute("UserGoalId", g.UserGoalId),
                            new XAttribute("Comment", g.Comment)
                            ));

                return _dbContext.spAddUpdateEmpAppraisalGoal(userId, goalData.EmpAppraisalSettingId, xmlElements.ToString())
                        .FirstOrDefault().Value;
            }
            return 3;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="achievementData"></param>
        /// <returns>1: success; 2: unauthorised user, 0: error/exception from proc, 3: data missing</returns>
        public int SaveEmployeeAppraisalAchievement(AchievementXmlBO achievementData)
        {
            if (achievementData != null && achievementData.DetailList.Any())
            {
                int userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(achievementData.UserAbrhs), out userId);

                var xmlElements = new XElement("root",
                    from g in achievementData.DetailList
                    select new XElement("row",
                            new XAttribute("UserAchievementId", g.UserAchievementId),
                            new XAttribute("Comment", g.Comment)
                            ));

                return _dbContext.spAddUpdateEmpAppraisalAchievement(userId, achievementData.EmpAppraisalSettingId, xmlElements.ToString())
                        .FirstOrDefault().Value;
            }
            return 3;
        }

        public List<AchievementCommentBO> SaveEmployeeAppraisalAchievementBySelf(AchievementXmlBO achievementData)
        {
            var result = new List<AchievementCommentBO>();
            if (achievementData != null)
            {
                int userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(achievementData.UserAbrhs), out userId);

                var xmlElements = new XElement("root",
                    from g in achievementData.DetailList
                    select new XElement("row",
                            new XAttribute("UserAchievementId", g.UserAchievementId),
                            new XAttribute("Comment", g.Comment)
                            ));

                var data = _dbContext.spAddUpdateEmpAppraisalAchievementBySelf(userId, achievementData.EmpAppraisalSettingId, xmlElements.ToString()).ToList();
                if (data.Any())
                {
                    foreach (var item in data)
                    {
                        result.Add(new AchievementCommentBO
                        {
                            UserAchievementId = item.UserAchievementId,
                            Comment = item.Achievement,

                        });
                    }
                }
            }
            return result;
        }

        public List<AppraisalCycleIdForAchievementBO> getAllGoalCycleIdToViewAchievement(int userId, bool forTeam)
        {
            var data = _dbContext.Fun_GetAllAppraisalCycleId().ToList();
            var doj = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == userId); //.Select(x=>x.JoiningDate);
            var appraisalDetail = new List<AppraisalCycleIdForAchievementBO>();
            if (forTeam == false)
            {
                if (doj == null || !doj.JoiningDate.HasValue)
                    return new List<AppraisalCycleIdForAchievementBO>();

                var dojnew = doj.JoiningDate.Value;
                var newData = from t in data where t.AppraisalYear >= dojnew.Year select t;
                appraisalDetail = newData.Select(s => new AppraisalCycleIdForAchievementBO
                {
                    AppraisalCycleId = s.AppraisalCycleId.Value,
                    AppraisalYear = s.AppraisalYear.Value,
                    FyStartDate = s.FYStartDate.Value,
                    FyEndDate = s.FYEndDate.Value,
                    AppraisalCycleName = s.AppraisalCycleName,
                    FinancialYear = s.FinancialYear,
                    FinancialYearName = s.FinancialYearName,
                    GoalCycleId = s.GoalCycleId.Value
                }).ToList();
            }
            else
            {
                appraisalDetail = data.Select(s => new AppraisalCycleIdForAchievementBO
                {
                    AppraisalCycleId = s.AppraisalCycleId.Value,
                    AppraisalYear = s.AppraisalYear.Value,
                    FyStartDate = s.FYStartDate.Value,
                    FyEndDate = s.FYEndDate.Value,
                    AppraisalCycleName = s.AppraisalCycleName,
                    FinancialYear = s.FinancialYear,
                    FinancialYearName = s.FinancialYearName,
                    GoalCycleId = s.GoalCycleId.Value
                }).ToList();
            }
            return appraisalDetail ?? new List<AppraisalCycleIdForAchievementBO>();

        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="empAppraisalSettingId"></param>
        /// <param name="userAbrhs"></param>
        /// <returns>1: success; 2: unauthorised user, 0: error/exception from proc</returns>
        public int ChangeAppraisalFormStatusToNextLevel(int empAppraisalSettingId, string userAbrhs)
        {
            int userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            return _dbContext.spChangeAppraisalFormStatusToNextLevel(userId, empAppraisalSettingId).FirstOrDefault().Value;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="empAppraisalSettingId"></param>
        /// <param name="recommendationPercentage"></param>
        /// <param name="isPromoted"></param>
        /// <param name="promotionRemarks"></param>
        /// <param name="promotionDesignationId"></param>
        /// <param name="isHighPotential"></param>
        /// <param name="highPotentialRemarks"></param>
        /// <param name="userAbrhs"></param>
        /// <returns>1: success; 2: unauthorised user; 3: bad input data</returns>
        public int SaveEmployeeAppraisalPromotion(int empAppraisalSettingId, int recommendationPercentage, bool isPromoted, string promotionRemarks
                                                  , int promotionDesignationId, bool isHighPotential, string highPotentialRemarks, string userAbrhs)
        {
            if (empAppraisalSettingId > 0 && !string.IsNullOrEmpty(userAbrhs))
            {
                int userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

                return _dbContext.spAddUpdateEmpAppraisalPromotions(empAppraisalSettingId, isPromoted, recommendationPercentage, promotionRemarks, promotionDesignationId
                                                                    , isHighPotential, highPotentialRemarks, userId).FirstOrDefault().Value;
            }
            return 3;
        }

        public ValidateAndSubmitAppraisalFormBO ValidateAndSubmitAppraisalForm(int empAppraisalSettingId, string userAbrhs)
        {
            var response = new ValidateAndSubmitAppraisalFormBO { IsSubmitted = false, IsValid = false, MandatoryFieldsList = null };
            int loginUserId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out loginUserId);
            var result = _dbContext.spValidateAppraisalForm(loginUserId, empAppraisalSettingId).Select(x => new MandatoryFieldBO { Field = x.Field, Category = x.Category }).ToList();
            response.MandatoryFieldsList = result;
            if (result.Count == 1)
            {
                if (result[0].Category.Equals("OverallRating"))
                {
                    response.IsValid = true;
                    var encRating = CryptoHelper.EncryptTRC(result[0].Field);
                    result.Clear();
                    var data = _dbContext.spSubmitAppraisalForm(loginUserId, empAppraisalSettingId, encRating).FirstOrDefault();
                    if (data != null && data.IsSubmitted.Value)
                    {
                        response.IsSubmitted = true;
                        //send email to concerned employee

                        switch (data.AppraisalStatusId) //4: pending with appraiser, 5: pending with approver, 6: closed
                        {
                            case 4:
                                {
                                    var emailTemplateForAppraisee = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "SelfAppraisalSubmitToSelf" && f.IsActive && !f.IsDeleted);
                                    var bodyForAppraisee = emailTemplateForAppraisee.Template.Replace("##AppraiseeName##", data.ActionByEmployeeName);
                                    Utilities.EmailHelper.SendEmailWithDefaultParameter("Self-Assessment Completed", bodyForAppraisee, true, true, CryptoHelper.Decrypt(data.AppraiseeEmailId), null, null, null);

                                    var emailTemplateForAppraiser = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "SelfAppraisalSubmitToAppraiser" && f.IsActive && !f.IsDeleted);
                                    var bodyForAppraiser = emailTemplateForAppraiser.Template.Replace("##AppraiseeName##", data.ActionByEmployeeName);
                                    Utilities.EmailHelper.SendEmailWithDefaultParameter("Employee Self-Assessment Completed", bodyForAppraiser, true, true, CryptoHelper.Decrypt(data.AppraiserEmailId), null, null, null);

                                    break;
                                }
                            case 5:
                                {
                                    var emailTemplateForApprover = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "AppraiserSubmitToApprover" && f.IsActive && !f.IsDeleted);
                                    var bodyForApprover = emailTemplateForApprover.Template.Replace("##AppraiseeName##", data.ActionByEmployeeName);
                                    Utilities.EmailHelper.SendEmailWithDefaultParameter("Appraiser-Review Completed", bodyForApprover, true, true, CryptoHelper.Decrypt(data.ApproverEmailId), null, null, null);

                                    break;
                                }
                            case 6:
                                {
                                    //Don't send email for closure - As per HR

                                    //var emailTemplateForApprover = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "Appraisal Management" && f.IsActive && !f.IsDeleted);
                                    //var body = emailTemplate.Template.Replace("[MailToEmployeeName]", data.MailToEmployeeName).Replace("[ActionByEmployeeName]", data.ActionByEmployeeName)
                                    //                                  .Replace("[Action]", "Appraisal closed");
                                    //Utilities.EmailHelper.SendEmailWithDefaultParameter("Appraisal has been closed", body, true, true, CryptoHelper.Decrypt(data.MailToEmailId), null, null, null);

                                    break;
                                }
                        }

                        // Logging 
                        var employeeData = _dbContext.EmpAppraisalSettings.FirstOrDefault(x => x.EmpAppraisalSettingId == empAppraisalSettingId);
                        _userServices.SaveUserLogs(ActivityMessages.AppraisalFormSubmission, loginUserId, (employeeData != null) ? employeeData.UserId : 0);
                    }
                }
                response.MandatoryFieldsList = result;
            }
            return response;
        }

        public bool ReferBackAppraisalForm(int empAppraisalSettingId, string comments, string userAbrhs)
        {
            int loginUserId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out loginUserId);

            var data = _dbContext.spReferBackAppraisalForm(loginUserId, empAppraisalSettingId, comments).FirstOrDefault();
            if (data.IsSuccessful.Value)
            {
                //AppraiseeName	AppraiserName	ApproverName	AppraiseeEmailId	AppraiserEmailId	ApproverEmailId	IsReferBackByAppraise
                if (data.IsReferBackByAppraiser.Value)
                {
                    //refer back by appraiser email                    
                    var emailTemplateForAppraisee = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "AppraisalReferBackToAppraisee" && f.IsActive && !f.IsDeleted);
                    var bodyForAppraisee = emailTemplateForAppraisee.Template.Replace("##AppraiseeName##", data.AppraiseeName);
                    Utilities.EmailHelper.SendEmailWithDefaultParameter("Appraisal Referred back to Appraisee", bodyForAppraisee, true, true, CryptoHelper.Decrypt(data.AppraiseeEmailId), null, null, null);
                }
                else if (!data.IsReferBackByAppraiser.Value)
                {
                    //refer back by approver email                    
                    var emailTemplateForAppraiser = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "AppraisalReferBackToAppraiser" && f.IsActive && !f.IsDeleted);
                    var bodyForAppraiser = emailTemplateForAppraiser.Template.Replace("##AppraiserName##", data.AppraiserName).Replace("##AppraiseeName##", data.AppraiseeName);
                    Utilities.EmailHelper.SendEmailWithDefaultParameter("Appraisal Referred back to Appraiser", bodyForAppraiser, true, true, CryptoHelper.Decrypt(data.AppraiserEmailId), null, null, null);
                }

                // Logging 
                var employeeData = _dbContext.EmpAppraisalSettings.FirstOrDefault(x => x.EmpAppraisalSettingId == empAppraisalSettingId);
                _userServices.SaveUserLogs(ActivityMessages.AppraisalFormReferBack, loginUserId, (employeeData != null) ? employeeData.UserId : 0);

                return true;
            }
            return false;
        }

        #endregion

        #region Appraisal Report

        public List<BaseDropDown> GetAppraisalStatus()
        {
            var data = _dbContext.FeedbackStatus.Where(x => x.FeedbackStatusId < 8 && x.IsActive).Select(x => new BaseDropDown
            {
                Text = x.FeedbackStatusName,
                Value = x.FeedbackStatusId,
                Selected = false
            }).OrderBy(t => t.Value).ToList();
            return data;
        }

        public List<EmployeeAppraisalStatus> GetEmployeeAppraisalStatusList(int appraisalCycleId, string appraisalStatusIds, string userAbrhs)
        {
            var result = new List<EmployeeAppraisalStatus>();
            if (appraisalCycleId > 0 && appraisalStatusIds != null)
            {
                int userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

                result = _dbContext.Proc_GetEmployeeAppraisalStatus(userId, appraisalCycleId, appraisalStatusIds).Select(x => new EmployeeAppraisalStatus
                {
                    EmployeeName = x.EmployeeName,
                    EmployeePhotoName = x.EmployeePhotoName,
                    DesignationName = x.DesignationName,
                    EmpAppraisalSettingId = x.EmpAppraisalSettingId,
                    AppraisalCycleName = x.AppraisalCycleName,
                    AppraiserName = x.AppraiserName,
                    Approver1Name = x.Approver1Name,
                    RMName = x.RMName,
                    AppraisalStatusName = x.FeedbackStatusName,
                    StartDate = x.StartDate,
                    EndDate = x.EndDate,
                    TeamName = x.TeamName,
                    DepartmentName = x.DepartmentName,
                    DivisionName = x.DivisionName,
                    VerticalName = x.VerticalName,
                }).ToList();
            }
            return result;
        }

        public List<AppraisalReportBO> GetAppraisalReport(int appraisalCycleId, string appraisalStatusIds, string userAbrhs)
        {
            var result = new List<AppraisalReportBO>();
            if (appraisalCycleId > 0 && !string.IsNullOrEmpty(appraisalStatusIds) && !string.IsNullOrEmpty(userAbrhs))
            {
                int userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

                result = _dbContext.spGetAppraisalReport(userId, appraisalCycleId, appraisalStatusIds).Select(x => new AppraisalReportBO
                {
                    EmployeeCode = x.EmployeeId,
                    EmployeeName = x.EmployeeName,
                    CurrentDesignation = x.CurrentDesignation,
                    ReportingManager = x.ReportingManager,
                    Appraiser = x.Appraiser,
                    Approver = x.Approver,
                    AppraiserRecommendedDesignation = x.AppraiserRecommendedDesignation,
                    AppraiserRecommendedPercentage = x.AppraiserRecommendedPercentage,
                    ApproverRecommendedDesignation = x.ApproverRecommendedDesignation,
                    ApproverRecommendedPercentage = x.ApproverRecommendedPercentage,
                    AppraiserMarkedHighPotential = x.AppraiserMarkedHighPotential,
                    ApproverMarkedHighPotential = x.ApproverMarkedHighPotential,
                    SelfRating = x.SelfRating.Equals("NA") ? "NA" : CryptoHelper.DecryptTRC(x.SelfRating),
                    AppraiserRating = x.AppraiserRating.Equals("NA") ? "NA" : CryptoHelper.DecryptTRC(x.AppraiserRating),
                    ApproverRating = x.ApproverRating.Equals("NA") ? "NA" : CryptoHelper.DecryptTRC(x.ApproverRating),
                    AppraisalStatus = x.AppraisalStatus,
                    EmployeePhotoName = x.EmployeePhotoName
                }).ToList();
            }
            return result;
        }

        public int DownloadAppraisalForm(int empAppraisalSettingId, string userAbrhs)
        {
            var result = 0;
            if (empAppraisalSettingId > 0 && !string.IsNullOrEmpty(userAbrhs))
            {
                int userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            }
            return result;
        }

        public int SendAppraisalFormOnMail(int empAppraisalSettingId, string userAbrhs)
        {
            var result = 0;
            if (empAppraisalSettingId > 0 && !string.IsNullOrEmpty(userAbrhs))
            {
                int userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "DownloadAppraisalForm" && f.IsActive && !f.IsDeleted);
                if (emailTemplate != null)
                {
                    //Fetch Form data From Database.
                    var formData = _dbContext.Proc_GetEmpAppraisalFormForPDF(userId, empAppraisalSettingId).FirstOrDefault();

                    var body = emailTemplate.Template;
                    //Replace Employee Information. 
                    body = body.Replace("##AppraiseeName##", formData.EmployeeName).Replace("##AppraiserName##", formData.AppraiserName).Replace("##ApproverName##", formData.Approver1Name).Replace("##AppraiseeDesig##", formData.DesignationName).Replace("##AppraiserDesig##", formData.AppraiserDesignation).Replace("##ApproverDesig##", formData.Approver1Designation);
                    body = body.Replace("##AppraiseeDOJ##", formData.DateOfJoin).Replace("##ReviewFrom##", formData.ReviewFrom).Replace("##ReviewTo##", formData.ReviewTo).Replace("##seflRating##", formData.SelfOverallRatingWeighted.ToString()).Replace("##AppraiserRating##", formData.AppraiserOverallRatingWeighted.ToString()).Replace("##ApproverRating##", formData.ApproverOverallRatingWeighted.ToString());//.Replace("##AppraiseeName##",);
                    var competencyTable = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "CompetencyTable" && f.IsActive && !f.IsDeleted);

                    JavaScriptSerializer serializer = new JavaScriptSerializer();
                    //Form Details 
                    List<AppraisalParameterDetailList> formDetailList = serializer.Deserialize<List<AppraisalParameterDetailList>>(formData.AppraisalParameterDetail);
                    //Goals Details list
                    List<GoalsDetailList> goalDetailList = serializer.Deserialize<List<GoalsDetailList>>(formData.EmployeeGoals);
                    //Achievement list
                    List<AchievementDetailList> achievementDetailList = serializer.Deserialize<List<AchievementDetailList>>(formData.EmployeeAchievements);

                    //Insert Technical Competency Data in Template.
                    var technicalCompetencyList = formDetailList.Where(x => x.CompetencyTypeId == 1).ToList();
                    var technicalCompetency = competencyTable;
                    var tr = "";
                    foreach (var item in technicalCompetencyList)
                    {
                        tr += "<tr><td>" + item.ParameterName + "</td><td>" + item.EvaluationCriteria + "</td><td>" + item.SelfComment + " Rating : " + item.SelfRatingId + "</td><td>" + item.AppraiserComment + " Rating : " + item.AppraiserRatingId + "</td><td>" + item.ApproverComment + " Rating : " + item.ApproverRatingId + "</td></tr>";
                    }
                    var technicalCompetencyhtml = technicalCompetency.Template.Replace("##CompetencyTypeName##", "Technical").Replace("##tbody##", tr);
                    body = body.Replace("##TecnnicalCompetenty##", technicalCompetencyhtml.ToString());

                    //Insert Behavioural Competency Data in Template.
                    var behaviouralCompetencyList = formDetailList.Where(x => x.CompetencyTypeId == 2).ToList();
                    var behaviouralCompetency = competencyTable;
                    var trbehavioural = "";
                    foreach (var item in behaviouralCompetencyList)
                    {
                        trbehavioural += "<tr><td>" + item.ParameterName + "</td><td>" + item.EvaluationCriteria + "</td><td>" + item.SelfComment + " Rating : " + item.SelfRatingId + "</td><td>" + item.AppraiserComment + " Rating : " + item.AppraiserRatingId + "</td><td>" + item.ApproverComment + " Rating : " + item.ApproverRatingId + "</td></tr>";
                    }
                    var behaviouralCompetencyhtml = behaviouralCompetency.Template.Replace("##CompetencyTypeName##", "Behavioural").Replace("##tbody##", trbehavioural);
                    body = body.Replace("##BehaviouralCompetenty##", behaviouralCompetencyhtml.ToString());

                    //Insert Goals Data in Template.
                    var goalsTable = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "GoalsTable" && f.IsActive && !f.IsDeleted).Template;
                    var trGoals = "";
                    foreach (var item in goalDetailList)
                    {
                        trGoals += "<tr><td>" + item.Goal + "</td><td>" + item.SelfComment + "</td><td>" + item.AppraiserComment + "</td><td>" + item.ApproverComment + "</td></tr>";
                    }
                    var goalshtml = goalsTable.Replace("##tbody##", trGoals);
                    body = body.Replace("##UserGoals##", goalshtml.ToString());

                    //Insert Goals Data in Template.
                    var achievementTable = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "GoalsTable" && f.IsActive && !f.IsDeleted).Template;
                    var trAchievement = "";
                    foreach (var item in achievementDetailList)
                    {
                        trAchievement += "<tr><td>" + item.Achievement + "</td><td>" + item.AppraiserComment + "</td><td>" + item.ApproverComment + "</td></tr>";
                    }
                    var achievementhtml = achievementTable.Replace("##tbody##", trAchievement);
                    body = body.Replace("##UserAchievement##", achievementhtml.ToString());

                    //Insert Promotions Data in Template.
                    var promotionsTable = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == "UserPromotions" && f.IsActive && !f.IsDeleted).Template;
                    var trPromotions = "";
                    var appraiserRecommendedForDesignation = _dbContext.Designations.FirstOrDefault(x => x.DesignationId == formData.AppraiserRecommendedForDesignationId).DesignationName;
                    var approver1RecommendedForDesignation = _dbContext.Designations.FirstOrDefault(x => x.DesignationId == formData.Approver1RecommendedForDesignationId).DesignationName;
                    trPromotions += "<tr><td><b>Recommended For Designation :</b>" + appraiserRecommendedForDesignation + "<br /><b>Comments :</b>" + formData.AppraiserRecommendationComment + "<br /><b>Recommended Percentage :</b>" + formData.AppraiserRecommendedPercentage + "<br /><b>Mark for High Potential :</b>" + ((formData.AppraiserMarkedHighPotential == true) ? "Yes" : "NA") + "<br /><b>Comments :</b>" + formData.AppraiserHighPotentialComment + "</td>";
                    trPromotions += "<td><b>Recommended For Designation :</b>" + approver1RecommendedForDesignation + "<br /><b>Comments :</b>" + formData.Approver1RecommendationComment + "<br /><b>Recommended Percentage :</b>" + formData.Approver1RecommendedPercentage + "<br /><b>Mark for High Potential :</b>" + ((formData.Approver1MarkedHighPotential == true) ? "Yes" : "NA") + "<br /><b>Comments :</b>" + formData.Approver1HighPotentialComment + "</td></tr>";
                    var promotionshtml = promotionsTable.Replace("##tbody##", trPromotions);
                    body = body.Replace("##UserPromotions##", promotionshtml.ToString());

                    var subject = "Test Subject";
                    var to = "sudhanshu.shekhar@geminisolutions.in";
                    //var cc = "sudhanshu.shekhar@geminisolutions.in";
                    //var bcc = "shubhra.upadhyay@geminisolutions.in";
                    Utilities.EmailHelper.EmailWithPDF(subject, body, true, true, to, null, null, body);
                }
            }
            return result;
        }

        #endregion

        #region My Achievements
        /// <summary>
        /// Get all my achievements
        /// </summary>
        /// <param name="loginUserId"></param>
        /// <returns></returns>
        public List<UserRegularAchievementBO> GetAllMyAchievements(int loginUserId)
        {
            if (!(loginUserId > 0))
                return new List<UserRegularAchievementBO>();

            var reqUrl = HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + "/";
#if !DEBUG
            reqUrl = (new UriBuilder(reqUrl) { Port = -1 }).ToString();
#endif
            var baseImagePath = reqUrl + ConfigurationManager.AppSettings["ImagePath"];
            var profileImagePath = reqUrl + ConfigurationManager.AppSettings["ProfileImageUploadPath"].Replace("\\", "/");
            var maleImagePath = baseImagePath + "male-employee.png";
            var femaleImagePath = baseImagePath + "female-employee.png";

            var result = (from uf in _dbContext.UserForms.Where(x => !x.IsDeleted && x.UserId == loginUserId).AsEnumerable()
                          join f in _dbContext.Forms on uf.FormId equals f.FormId into list1
                          from l1 in list1.DefaultIfEmpty()
                          join ud in _dbContext.UserDetails on uf.UserId equals ud.UserId into list2
                          from l2 in list2.DefaultIfEmpty()
                              //join d in _dbContext.Designations on l2.DesignationId equals d.DesignationId into list3
                              //from l3 in list3.DefaultIfEmpty()
                          orderby uf.CreatedDate descending, uf.FormName
                          where l1.DepartmentId == (int)Enums.Departments.HR

                          //where l1.FormId == (int)Enums.Forms.EmployeeAchievementForm
                          select new UserRegularAchievementBO
                          {
                              UserFormAbrhs = CryptoHelper.Encrypt(uf.UserFormId.ToString()),
                              //FormId = uf.FormId,
                              EmployeeName = l2.FirstName + " " + (!string.IsNullOrEmpty(l2.MiddleName) ? l2.MiddleName + " " : "") + l2.LastName,
                              DesignationName = l2.Designation.DesignationName, // l3.DesignationName,
                              //EmployeePhotoName = l2.ImagePath,
                              EmployeePhotoName = (!string.IsNullOrEmpty(l2.ImagePath) ? (profileImagePath + l2.ImagePath) : ((!string.IsNullOrEmpty(l2.Gender.GenderType) ? l2.Gender.GenderType.ToLower() : "") == "female" ? femaleImagePath : maleImagePath)),
                              ActualFormName = l1.FormName,
                              UsersFormName = uf.FormName,
                              FormPath = uf.FormPath,
                              IsActive = uf.IsActive,
                              IsDeleted = uf.IsDeleted,
                              Status = uf.IsActive == true ? "Active" : "Inactive",
                              CreatedDate = uf.CreatedDate
                          }).ToList();

            return result ?? new List<UserRegularAchievementBO>();
        }

        public int SubmitUserMidYearAchievement(SubmitAchievementBO achievement, int loginUserId)
        {
            var status = 0;
            if (achievement.AchievementData != null)
            {
                var achievementXmlString = new XElement("Root",
                from t in achievement.AchievementData
                select new XElement("Row",
                       new XAttribute("Achievement", t.Achievement)
                    ));
                var result = new ObjectParameter("Success", typeof(int));
                _dbContext.Proc_SubmitUserAchievementForMidYear(loginUserId, achievement.GoalCycleId, achievementXmlString.ToString(), result);
                _userServices.SaveUserLogs(ActivityMessages.AddAchievement, loginUserId, 0);
                Int32.TryParse(result.Value.ToString(), out status);
            }
            return status;
        }
        public List<UserMidYearAchievementDataBO> GetTeamsAchievement(int achievementCycleId, string userAbrhs)
        {
            string[] userAbrhsArray = userAbrhs.Split(',');
            var count = userAbrhsArray.Length;
            int[] userIdArray = new int[count];
            for (var i = 0; i < count; i++)
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhsArray[i]), out userId);
                userIdArray[i] = userId;
            }
            var reqUrl = HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + "/";
#if !DEBUG
            reqUrl = (new UriBuilder(reqUrl) { Port = -1 }).ToString();
#endif
            var baseImagePath = reqUrl + ConfigurationManager.AppSettings["ImagePath"];
            var profileImagePath = reqUrl + ConfigurationManager.AppSettings["ProfileImageUploadPath"].Replace("\\", "/");
            var maleImagePath = baseImagePath + "male-employee.png";
            var femaleImagePath = baseImagePath + "female-employee.png";
            List<UserMidYearAchievementDataBO> results = new List<UserMidYearAchievementDataBO>();

            if (achievementCycleId == 0 && userIdArray.Length > 0)
            {
                var achievementListAll = (from a in _dbContext.UserAchievementForMidYears
                                          where userIdArray.Contains(a.UserId) && a.IsActive == true
                                          select new
                                          {
                                              a.UserId,
                                              a.AppraisalCycleId,
                                              a.CreatedDate,
                                              a.Achievement
                                          }).ToList();
                if (achievementListAll.Count != 0)
                {
                    results = (from a in achievementListAll.GroupBy(g => new { g.UserId, g.AppraisalCycleId, CreatedDate = g.CreatedDate.Date })
                               join b in _dbContext.AppraisalCycles on a.Key.AppraisalCycleId equals b.AppraisalCycleId
                               join v in _dbContext.vwActiveUsers on a.Key.UserId equals v.UserId
                               select new UserMidYearAchievementDataBO
                               {
                                   AppraisalYear = b.AppraisalCycleName,
                                   SubmittedDate = a.Key.CreatedDate.ToString("dd MMM yyyy"),
                                   ReportingManager = v.ReportingManagerName,
                                   AchievementData =
                                   _dbContext.UserAchievementForMidYears.Where(t => t.UserId == a.Key.UserId && t.AppraisalCycleId == achievementCycleId && t.IsActive == true).Select(m => new AchievementDetailBO
                                   {
                                       Achievement = m.Achievement
                                   }).ToList(),
                                   Team = v.Team,
                                   Department = v.Department,
                                   EmployeeName = v.EmployeeName,
                                   DesignationName = v.Designation,
                                   EmployeePhotoName = (!string.IsNullOrEmpty(v.ImagePath) ? (profileImagePath + v.ImagePath) : ((!string.IsNullOrEmpty(v.Gender) ? v.Gender.ToLower() : "") == "female" ? femaleImagePath : maleImagePath)),

                               }).ToList();
                }
            }
            else
            {
                var achievementList = (from a in _dbContext.UserAchievementForMidYears
                                       where userIdArray.Contains(a.UserId) && a.AppraisalCycleId == achievementCycleId && a.IsActive == true
                                       select new
                                       {
                                           a.UserId,
                                           a.AppraisalCycleId,
                                           a.CreatedDate,
                                           a.Achievement
                                       }).ToList();
                if (achievementList.Count != 0)
                {
                    results = (from a in achievementList.GroupBy(g => new { g.UserId, g.AppraisalCycleId, CreatedDate = g.CreatedDate.Date })
                               join b in _dbContext.AppraisalCycles on a.Key.AppraisalCycleId equals b.AppraisalCycleId
                               join v in _dbContext.vwActiveUsers on a.Key.UserId equals v.UserId
                               select new UserMidYearAchievementDataBO
                               {
                                   AppraisalYear = b.AppraisalCycleName,
                                   SubmittedDate = a.Key.CreatedDate.ToString("dd MMM yyyy"),
                                   ReportingManager = v.ReportingManagerName,
                                   AchievementData =
                                   _dbContext.UserAchievementForMidYears.Where(t => t.UserId == a.Key.UserId && t.AppraisalCycleId == achievementCycleId && t.IsActive == true).Select(m => new AchievementDetailBO
                                   {
                                       Achievement = m.Achievement
                                   }).ToList(),
                                   Team = v.Team,
                                   Department = v.Department,
                                   EmployeeName = v.EmployeeName,
                                   DesignationName = v.Designation,
                                   EmployeePhotoName = (!string.IsNullOrEmpty(v.ImagePath) ? (profileImagePath + v.ImagePath) : ((!string.IsNullOrEmpty(v.Gender) ? v.Gender.ToLower() : "") == "female" ? femaleImagePath : maleImagePath)),

                               }).ToList();
                }
            }

            return results ?? new List<UserMidYearAchievementDataBO>();
        }

        public List<UserMidYearAchievementDataBO> GetUserMidYearAchievement(int achievementCycleId, int userId)
        {
            List<UserMidYearAchievementDataBO> achievementList = new List<UserMidYearAchievementDataBO>();
            var achievementData = _dbContext.UserAchievementForMidYears.Where(s => s.UserId == userId && s.AppraisalCycleId == achievementCycleId && s.IsActive == true).ToList();
            var appraisalData = _dbContext.AppraisalCycles.FirstOrDefault(s => s.AppraisalCycleId == achievementCycleId);
            if (achievementData.Count != 0 && appraisalData != null)
            {
                var submittedDate = achievementData.FirstOrDefault().CreatedDate.ToString("dd MMM yyyy hh:mm tt");

                List<AchievementDetailBO> objList = new List<AchievementDetailBO>();
                var i = 1;
                foreach (var s in achievementData)
                {
                    var obj = new AchievementDetailBO
                    {
                        SNo = i,
                        Achievement = s.Achievement
                    };
                    objList.Add(obj);
                    i++;
                }
                var achievementObj = new UserMidYearAchievementDataBO
                {
                    AppraisalYear = appraisalData.AppraisalCycleName,
                    SubmittedDate = submittedDate,
                    AchievementData = objList
                };
                achievementList.Add(achievementObj);
            }
            return achievementList ?? new List<UserMidYearAchievementDataBO>();
        }
        public bool GetValidityFalgToAddAchievement(int goalCycleId, int userId)
        {
            var achievementData = _dbContext.UserAchievementForMidYears.Where(s => s.UserId == userId && s.AppraisalCycleId == goalCycleId && s.IsActive == true).ToList();
            if (achievementData.Count == 0)
            {
                var currAppraisalCycle = _dbContext.Fun_GetCurrentAppraisalCycle().FirstOrDefault();
                int currentGoalCycleId = 0;
                if (currAppraisalCycle != null)
                {
                    currentGoalCycleId = currAppraisalCycle.AppraisalCycleId + 1;
                }
                if (goalCycleId == currentGoalCycleId)
                {
                    return true;
                }
                else
                    return false;
            }
            else
            {
                return false;
            }
        }


        #endregion

        #region Appraisal 2018

        public AddUpdateReturnBO AddUpdateTechnicalCompetencyForm(AddUpdateCompetencyFormBO data)
        {
            AddUpdateReturnBO returnBO = new AddUpdateReturnBO();
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(data.UserAbrhs), out userId);
            if (data.ParameterList != null)
            {

                var ParameterxmlString = new XElement("root",
                    from pxs in data.ParameterList
                    select new XElement("row",
                           new XAttribute("CompetencyFormDetailId", pxs.CompetencyFormDetailId),
                            new XAttribute("CompetencyTypeId", pxs.CompetencyTypeId),
                            new XAttribute("ParameterId", pxs.ParameterId),
                            new XAttribute("EvaluationCriteria", pxs.EvaluationCriteria),
                            new XAttribute("SequenceNo", pxs.SequenceNo)
                            ));

                var success = new ObjectParameter("Success", typeof(string));
                var result = new ObjectParameter("DuplicateNames", typeof(string));
                _dbContext.Proc_AddUpdateTechnicalCompetencyForm(data.CompetencyFormId, data.FormName, data.LocationId, data.VerticalId, data.DivisionId, data.DepartmentId, data.DesignationId, data.FeedbackTypeId, true, data.IsFinalize, ParameterxmlString.ToString(), userId, success, result);
                returnBO.Status = success.Value.ToString();
                returnBO.Result = result.Value.ToString();

            }
            return returnBO;
        }

        #endregion

        #region BindFinancialYearForGoal
        public List<AppraisalGoalYearBO> GetFinancialYearForMyGoal(string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var doj = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == userId); //.Select(x=>x.JoiningDate);
            if (doj == null || !doj.JoiningDate.HasValue)
                return new List<AppraisalGoalYearBO>();

            var dojnew = doj.JoiningDate.Value;
            var data = _dbContext.AppraisalCycles.Where(x => x.AppraisalYear >= dojnew.Year);
            var res = data.Select(x => new AppraisalGoalYearBO
            {
                AppraisalCycleId = x.AppraisalCycleId,
                AppraisalYear = x.AppraisalYear
            }).ToList();
            return res;

        }
        #endregion

        #region BindFinancialYearForTeamGoal
        public List<AppraisalGoalYearBO> GetFinancialYearForTeamGoal()
        {
            var data = from p in _dbContext.AppraisalCycles
                       select p;
            var res = data.Select(x => new AppraisalGoalYearBO
            {
                AppraisalCycleId = x.AppraisalCycleId,
                AppraisalYear = x.AppraisalYear
            }).ToList();
            return res;
        }
        #endregion

        #region Pimco Achievements

        #region Monthly
        public int CheckIfAllowedToFillPimcoMonthlyAchievements(int year, int mNumber, string userAbrhs)
        {
            int userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            if (mNumber == 1 || mNumber == 2 || mNumber == 3)
            {
                year = year + 1;
            }
            int status = 0;
            var result = new ObjectParameter("Success", typeof(int));
            _dbContext.Proc_CheckValidityForMonthlyAchievements(userId, year, mNumber, result);
            Int32.TryParse(result.Value.ToString(), out status);
            return status;
        }

        public int SubmitUserMonthlyAchievement(SubmitPimcoAchievementBO achievement, int loginUserId)
        {
            int userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(achievement.UserAbrhs), out userId);

            var status = 0;
            if (achievement.AchievementData != null)
            {
                var achievementXmlString = new XElement("Root",
                from t in achievement.AchievementData
                select new XElement("Row",
                       new XAttribute("ProjectId", t.ProjectId),
                       new XAttribute("Achievement", t.Achievement)
                    ));
                var result = new ObjectParameter("Success", typeof(int));
                _dbContext.Proc_SubmitUserMonthlyAchievement(userId, achievement.Year, achievement.MNumber, achievement.Comments, achievementXmlString.ToString(), result);
                _userServices.SaveUserLogs(ActivityMessages.AddPimcoAchievement, loginUserId, 0);
                Int32.TryParse(result.Value.ToString(), out status);
                var requesterData = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == userId);
                var receiverMail = "";
                var requesterName = "";
                var receiverName = "";
                if (requesterData != null)
                {
                    requesterName = requesterData.FirstName + " " + requesterData.MiddleName + " " + requesterData.LastName;
                    var receiverDetail = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == requesterData.ReportTo);
                    receiverMail = receiverDetail != null ? CryptoHelper.Decrypt(receiverDetail.EmailId) : "";
                    receiverName = receiverDetail != null ? receiverDetail.FirstName : "";
                }
                var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == EmailTemplates.InvoiceRequest && f.IsActive && !f.IsDeleted);
                if (emailTemplate != null)
                {
                    var subject = "User Monthly Pimco Achievement Submission.";
                    //var message = "This is to inform you that " + requesterName + " has submitted Pimco achievements for quarter Q" + achievement.QNumber + ".";
                    var message = string.Format("&#60;{0}&#62; has submitted monthly achievements.", requesterName);
                    var body = emailTemplate.Template
                            .Replace("[Name]", receiverName)
                            .Replace("[MessageContent]", message)
                            .Replace("[Title]", "Review Pimco Achievements");
                    // SEND MAIL 
                    Utilities.EmailHelper.SendEmailWithDefaultParameter(subject, body, true, true, receiverMail, null, null, null);

                }
            }
            return status;
        }

        public List<UserQuarterlyPimcoAchievementBO> GetUserMonthlyAchievement(int year, int mNumber, int loginUserId)
        {
            List<UserQuarterlyPimcoAchievementBO> achievementList = new List<UserQuarterlyPimcoAchievementBO>();
            var achievementData = _dbContext.PimcoMonthlyAchievements.FirstOrDefault(s => s.UserId == loginUserId && s.FYStartYear == year && s.Month == mNumber && s.IsActive == true);
            if (achievementData != null)
            {
                var achievementDetail = _dbContext.PimcoMonthlyAchievementDetails.Where(s => s.PimcoAchievementId == achievementData.PimcoAchievementId).ToList();
                if (achievementDetail != null)
                {
                    var submittedDate = achievementData.CreatedDate.ToString("dd MMM yyyy hh:mm tt");

                    List<PimcoAchievementDetailBO> objList = new List<PimcoAchievementDetailBO>();
                    var i = 1;
                    foreach (var s in achievementDetail)
                    {
                        var pimcoProject = _dbContext.PimcoProjects.FirstOrDefault(p => p.PimcoProjectId == s.PimcoProjectId);
                        var project = "";
                        if (pimcoProject != null)
                        {
                            var techTeam = _dbContext.PimcoProjectVerticals.FirstOrDefault(v => v.VerticalId == pimcoProject.VerticalId);
                            var team = "";
                            if (techTeam != null)
                            {
                                team = techTeam.Vertical;
                            }
                            project = pimcoProject.Name + "(" + team + ")";
                        }
                        var obj = new PimcoAchievementDetailBO
                        {
                            SNo = i,
                            Achievement = s.Achievement,
                            ProjectName = project
                        };
                        objList.Add(obj);
                        i++;
                    }
                    var achievementObj = new UserQuarterlyPimcoAchievementBO
                    {
                        EmpComments = achievementData.EmpComments,
                        RMComments = achievementData.RMComments,
                        SubmittedDate = submittedDate,
                        AchievementData = objList
                    };
                    achievementList.Add(achievementObj);
                }
            }
            return achievementList ?? new List<UserQuarterlyPimcoAchievementBO>();
        }

        public List<UserQuarterlyPimcoAchievementBO> GetTeamPimcoMonthlyAchievements(int fyYear, string months, string userAbrhs)
        {
            List<UserQuarterlyPimcoAchievementBO> achievementList = new List<UserQuarterlyPimcoAchievementBO>();
            List<int> userIdArray = userAbrhs.SplitUseridsToIntList(',');
            var reqUrl = HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + "/";
#if !DEBUG
                        reqUrl = (new UriBuilder(reqUrl) { Port = -1 }).ToString();
#endif
            var baseImagePath = reqUrl + ConfigurationManager.AppSettings["ImagePath"];
            var profileImagePath = reqUrl + ConfigurationManager.AppSettings["ProfileImageUploadPath"].Replace("\\", "/");
            var maleImagePath = baseImagePath + "male-employee.png";
            var femaleImagePath = baseImagePath + "female-employee.png";
            int[] prevMonths = new int[3] { 1, 2, 3 };

            if (months != "" && userIdArray.Count > 0)
            {
                List<int> arrayofMonths = months.Split(',').Select(int.Parse).ToList();
                List<int> monthsArray = arrayofMonths.Where(t => !prevMonths.Contains(t)).ToList();
                List<int> monthsArrayNew = arrayofMonths.Where(t => prevMonths.Contains(t)).ToList();

                var achievement = _dbContext.PimcoMonthlyAchievements.Where(x => x.IsActive && userIdArray.Contains(x.UserId) && ((monthsArray.Contains(x.Month) && x.FYStartYear == fyYear) || (monthsArrayNew.Contains(x.Month) && x.FYStartYear == fyYear + 1))).ToList();
                achievementList = (from c in achievement
                                   join v in _dbContext.vwAllUsers on c.UserId equals v.UserId
                                   select new UserQuarterlyPimcoAchievementBO
                                   {
                                       PimcoAchievementId = c.PimcoAchievementId,
                                       SubmittedDate = c.CreatedDate.ToString("dd MMM yyyy hh:mm tt"),
                                       //EmpComments = c.EmpComments == null ?? "N.A": c.EmpComments,
                                       //RMComments = c.RMComments == null ?? "N.A":  c.RMComments,
                                       ReportingManager = v.ReportingManagerName,
                                       DiscussWithHR = c.ToBeDiscussedWithHR,
                                       Team = v.Team,
                                       Department = v.Department,
                                       EmployeeName = v.EmployeeName,
                                       DesignationName = v.Designation,
                                       EmployeePhotoName = (!string.IsNullOrEmpty(v.ImagePath) ? (profileImagePath + v.ImagePath) : ((!string.IsNullOrEmpty(v.Gender) ? v.Gender.ToLower() : "") == "female" ? femaleImagePath : maleImagePath)),
                                       //AchievementData = c.PimcoMonthlyAchievementDetails.Select(t => new PimcoAchievementDetailBO
                                       //{
                                       //    Achievement = t.Achievement,
                                       //    ProjectName = _dbContext.PimcoProjects.FirstOrDefault(p => p.PimcoProjectId == t.PimcoProjectId).Name + "(" + _dbContext.PimcoProjects.FirstOrDefault(p => p.PimcoProjectId == t.PimcoProjectId).TechTeam + ")"
                                       //}).ToList()
                                   }).ToList();
            }
            return achievementList ?? new List<UserQuarterlyPimcoAchievementBO>();
        }

        public List<PimcoAchievementDetailBO> GetPimcoMonthlyAchievementsOfTeamById(int pimcoAchievementId)
        {
            List<PimcoAchievementDetailBO> objList = new List<PimcoAchievementDetailBO>();
            var achievementDetail = _dbContext.PimcoMonthlyAchievements.FirstOrDefault(s => s.PimcoAchievementId == pimcoAchievementId);
            if (achievementDetail != null)
            {
                var data = achievementDetail.PimcoMonthlyAchievementDetails.ToList();
                var i = 0;
                foreach (var s in data)
                {
                    var pimcoProject = _dbContext.PimcoProjects.FirstOrDefault(p => p.PimcoProjectId == s.PimcoProjectId);

                    var project = "";
                    if (pimcoProject != null)
                    {
                        var techTeam = _dbContext.PimcoProjectVerticals.FirstOrDefault(v => v.VerticalId == pimcoProject.VerticalId);
                        var team = "";
                        if (techTeam != null)
                        {
                            team = techTeam.Vertical;
                        }
                        project = pimcoProject.Name + "(" + team + ")";
                    }
                    i = i + 1;
                    var obj = new PimcoAchievementDetailBO
                    {
                        SNo = i,
                        Achievement = s.Achievement,
                        ProjectName = project
                    };

                    objList.Add(obj);
                }

            }
            return objList ?? new List<PimcoAchievementDetailBO>();
        }

        public List<PimcoProjectBO> GetPimcoProjects(string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            var projectLists = _dbContext.PimcoProjectTeamMembers.Where(t => t.UserId == userId && t.IsActive == true).ToList();

            List<PimcoProjectBO> objList = new List<PimcoProjectBO>();
            var projectData = (from l in projectLists
                               join p in _dbContext.PimcoProjects on l.PimcoProjectId equals p.PimcoProjectId
                               join v in _dbContext.PimcoProjectVerticals on p.VerticalId equals v.VerticalId
                               where p.IsActive == true
                               select new PimcoProjectBO
                               {
                                   ProjectId = p.PimcoProjectId,
                                   ProjectName = p.Name + "(" + v.Vertical + ")"
                               }).ToList();

            return projectData ?? new List<PimcoProjectBO>();
        }

        #endregion

        #region Quarterly
        public int CheckIfAllowedToFillPimcoAchievements(int year, int qNumber, string userAbrhs)
        {
            int userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            int status = 0;
            var result = new ObjectParameter("Success", typeof(int));
            _dbContext.Proc_CheckIfAllowedToFillPimcoAchievements(userId, year, qNumber, result);
            Int32.TryParse(result.Value.ToString(), out status);
            return status;
        }

        public int SubmitUserQuarterlyAchievement(SubmitPimcoAchievementBO achievement, int loginUserId)
        {
            int userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(achievement.UserAbrhs), out userId);

            var status = 0;
            if (achievement.AchievementData != null)
            {
                var achievementXmlString = new XElement("Root",
                from t in achievement.AchievementData
                select new XElement("Row",
                       new XAttribute("ProjectId", t.ProjectId),
                       new XAttribute("Achievement", t.Achievement),
                       new XAttribute("Purpose", t.Purpose)
                    ));
                var result = new ObjectParameter("Success", typeof(int));
                _dbContext.Proc_SubmitUserQuarterlyAchievement(userId, achievement.Year, achievement.QNumber, achievement.Comments, achievementXmlString.ToString(), result);
                _userServices.SaveUserLogs(ActivityMessages.AddPimcoAchievement, loginUserId, 0);
                Int32.TryParse(result.Value.ToString(), out status);
                var requesterData = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == userId);
                var receiverMail = "";
                var requesterName = "";
                var receiverName = "";
                if (requesterData != null)
                {
                    requesterName = requesterData.FirstName + " " + requesterData.MiddleName + " " + requesterData.LastName;
                    var receiverDetail = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == requesterData.ReportTo);
                    receiverMail = receiverDetail != null ? CryptoHelper.Decrypt(receiverDetail.EmailId) : "";
                    receiverName = receiverDetail != null ? receiverDetail.FirstName : "";
                }
                var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == EmailTemplates.InvoiceRequest && f.IsActive && !f.IsDeleted);
                if (emailTemplate != null)
                {
                    var subject = "User Pimco Achievement Submission.";
                    //var message = "This is to inform you that " + requesterName + " has submitted Pimco achievements for quarter Q" + achievement.QNumber + ".";
                    var message = string.Format("&#60;{0}&#62; has submitted achievements for the past quarter. Please enter your comments on the portal after your face to face discussion.", requesterName);
                    var body = emailTemplate.Template
                            .Replace("[Name]", receiverName)
                            .Replace("[MessageContent]", message)
                            .Replace("[Title]", "Review Pimco Achievements");
                    // SEND MAIL 
                    Utilities.EmailHelper.SendEmailWithDefaultParameter(subject, body, true, true, receiverMail, null, null, null);

                }
            }
            return status;
        }

        public List<UserQuarterlyPimcoAchievementBO> GetUserQuarterlyAchievement(int year, int qNumber, int loginUserId)
        {
            List<UserQuarterlyPimcoAchievementBO> achievementList = new List<UserQuarterlyPimcoAchievementBO>();
            var achievementData = _dbContext.PimcoAchievements.FirstOrDefault(s => s.UserId == loginUserId && s.FYStartYear == year && s.QuarterNo == qNumber && s.IsActive == true);
            if (achievementData != null)
            {
                var achievementDetail = _dbContext.PimcoAchievementDetails.Where(s => s.PimcoAchievementId == achievementData.PimcoAchievementId).ToList();
                if (achievementDetail != null)
                {
                    var submittedDate = achievementData.CreatedDate.ToString("dd MMM yyyy hh:mm tt");

                    List<PimcoAchievementDetailBO> objList = new List<PimcoAchievementDetailBO>();
                    var i = 1;
                    foreach (var s in achievementDetail)
                    {
                        var pimcoProject = _dbContext.PimcoProjects.FirstOrDefault(p => p.PimcoProjectId == s.ProjectId);
                        var project = "";
                        if (pimcoProject != null)
                        {
                            var techTeam = _dbContext.PimcoProjectVerticals.FirstOrDefault(v => v.VerticalId == pimcoProject.VerticalId);
                            var team = "";
                            if (techTeam != null)
                            {
                                team = techTeam.Vertical;
                            }

                            project = pimcoProject.Name + "(" + team + ")";
                        }

                        var obj = new PimcoAchievementDetailBO
                        {
                            SNo = i,
                            Achievement = s.Achievement,
                            Purpose = s.Purpose,
                            ProjectName = project
                        };
                        objList.Add(obj);
                        i++;
                    }
                    var achievementObj = new UserQuarterlyPimcoAchievementBO
                    {
                        EmpComments = achievementData.EmpComments,
                        RMComments = achievementData.RMComments,
                        SubmittedDate = submittedDate,
                        AchievementData = objList
                    };
                    achievementList.Add(achievementObj);
                }
            }
            return achievementList ?? new List<UserQuarterlyPimcoAchievementBO>();
        }

        public List<UserQuarterlyPimcoAchievementBO> GetTeamPimcoAchievements(int fyYear, string quarters, string userAbrhs)
        {
            List<UserQuarterlyPimcoAchievementBO> achievementList = new List<UserQuarterlyPimcoAchievementBO>();
            List<int> userIdArray = userAbrhs.SplitUseridsToIntList(',');
            var reqUrl = HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + "/";
#if !DEBUG
                        reqUrl = (new UriBuilder(reqUrl) { Port = -1 }).ToString();
#endif
            var baseImagePath = reqUrl + ConfigurationManager.AppSettings["ImagePath"];
            var profileImagePath = reqUrl + ConfigurationManager.AppSettings["ProfileImageUploadPath"].Replace("\\", "/");
            var maleImagePath = baseImagePath + "male-employee.png";
            var femaleImagePath = baseImagePath + "female-employee.png";
            if (quarters != "" && userIdArray.Count > 0)
            {
                List<int> quartersArray = quarters.Split(',').Select(int.Parse).ToList();
                achievementList = (from c in _dbContext.PimcoAchievements.AsEnumerable().Where(x => x.IsActive && userIdArray.Contains(x.UserId)
                                          && quartersArray.Contains(x.QuarterNo) && x.FYStartYear == fyYear)
                                   join v in _dbContext.vwAllUsers on c.UserId equals v.UserId
                                   select new UserQuarterlyPimcoAchievementBO
                                   {
                                       PimcoAchievementId = c.PimcoAchievementId,
                                       SubmittedDate = c.CreatedDate.ToString("dd MMM yyyy hh:mm tt"),
                                       EmpComments = c.EmpComments ?? "N.A",
                                       RMComments = c.RMComments ?? "N.A",
                                       ReportingManager = v.ReportingManagerName,
                                       DiscussWithHR = c.ToBeDiscussedWithHR,
                                       Team = v.Team,
                                       Department = v.Department,
                                       EmployeeName = v.EmployeeName,
                                       DesignationName = v.Designation,
                                       EmployeePhotoName = (!string.IsNullOrEmpty(v.ImagePath) ? (profileImagePath + v.ImagePath) : ((!string.IsNullOrEmpty(v.Gender) ? v.Gender.ToLower() : "") == "female" ? femaleImagePath : maleImagePath)),
                                       //AchievementData = c.PimcoAchievementDetails.Select(t => new PimcoAchievementDetailBO
                                       //{
                                       //    Achievement = t.Achievement,
                                       //    Purpose = t.Purpose,
                                       //    ProjectName = _dbContext.PimcoProjects.FirstOrDefault(p => p.PimcoProjectId == t.ProjectId).Name + "(" + _dbContext.PimcoProjects.FirstOrDefault(p => p.PimcoProjectId == t.ProjectId).TechTeam + ")"
                                       //}).ToList()
                                   }).ToList();
            }
            return achievementList ?? new List<UserQuarterlyPimcoAchievementBO>();
        }

        public List<PimcoAchievementDetailBO> GetPimcoAchievementsOfTeamById(int pimcoAchievementId)
        {
            List<PimcoAchievementDetailBO> objList = new List<PimcoAchievementDetailBO>();
            var achievementDetail = _dbContext.PimcoAchievements.FirstOrDefault(s => s.PimcoAchievementId == pimcoAchievementId);
            if (achievementDetail != null)
            {
                var data = achievementDetail.PimcoAchievementDetails.ToList();
                foreach (var s in data)
                {
                    var pimcoProject = _dbContext.PimcoProjects.FirstOrDefault(p => p.PimcoProjectId == s.ProjectId);
                    var project = "";
                    if (pimcoProject != null)
                    {
                        var techTeam = _dbContext.PimcoProjectVerticals.FirstOrDefault(v => v.VerticalId == pimcoProject.VerticalId);
                        var team = "";
                        if (techTeam != null)
                        {
                            team = techTeam.Vertical;
                        }
                        project = pimcoProject.Name + "(" + team + ")";
                    }
                    var obj = new PimcoAchievementDetailBO
                    {
                        Achievement = s.Achievement,
                        Purpose = s.Purpose,
                        ProjectName = project,
                        RMComments = achievementDetail.RMComments,
                        DiscussWithHR = achievementDetail.ToBeDiscussedWithHR
                    };
                    objList.Add(obj);
                }

            }
            return objList ?? new List<PimcoAchievementDetailBO>();
        }

        public int SubmitRMComments(string comments, bool toBeDiscussedWithHR, int pimcoAchievementId, string userAbrhs)
        {
            try
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                using (var context = new MISEntities())
                {
                    var achievementData = _dbContext.PimcoAchievements.FirstOrDefault(x => x.PimcoAchievementId == pimcoAchievementId);
                    if (achievementData != null)
                    {
                        achievementData.RMComments = comments;
                        achievementData.ToBeDiscussedWithHR = toBeDiscussedWithHR;
                        achievementData.ModifiedBy = userId;
                        achievementData.ModifiedDate = DateTime.Now;
                    }
                    _dbContext.SaveChanges();
                    if (toBeDiscussedWithHR == true)
                    {
                        var requesterData = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == userId);
                        var recieverMail = "";
                        var requesterName = "";
                        var recieverName = "";
                        var submittedBy = "";
                        var deptHeadId = 0;
                        if (requesterData != null)
                            requesterName = requesterData.FirstName + " " + requesterData.MiddleName + " " + requesterData.LastName;
                        var emailTemplate = _dbContext.EmailTemplates.FirstOrDefault(f => f.TemplateName == EmailTemplates.InvoiceRequest && f.IsActive && !f.IsDeleted);
                        var data = _dbContext.PimcoAchievements.FirstOrDefault(x => x.PimcoAchievementId == pimcoAchievementId);
                        if (data != null)
                        {
                            submittedBy = _dbContext.UserDetails.Where(x => x.UserId == data.UserId).Select(u => u.FirstName + " " + u.MiddleName + " " + u.LastName).FirstOrDefault();
                            var receiverDetail = _dbContext.vwActiveUsers.FirstOrDefault(a => a.UserId == data.UserId);
                            if (receiverDetail != null)
                            {
                                var dept = _dbContext.Departments.FirstOrDefault(x => x.DepartmentId == receiverDetail.DepartmentId);
                                deptHeadId = dept != null ? dept.DepartmentHeadId : 0;
                            }
                            if (deptHeadId != 0)
                            {
                                var info = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == deptHeadId);
                                recieverMail = info != null ? CryptoHelper.Decrypt(info.EmailId) : "";
                                recieverName = info != null ? info.FirstName : "";
                            }
                            if (emailTemplate != null)
                            {
                                var subject = "User Pimco Achievement Review.";
                                var detail = _dbContext.PimcoAchievementDetails.Where(x => x.PimcoAchievementId == data.PimcoAchievementId).ToList();
                                //var table = "<table border='0' cellpadding='4' style='color:#000000;font:normal 11px arial,sans-serif;border:1px solid #abb2b7;width:50%'><thead><tr><th style='color:#434d52;font:bold 13px arial,sans-serif;white-space:nowrap;background-color:#ebeff1;border:1px solid #abb2b7'>Achievement</th><th style='color:#434d52;font:bold 13px arial,sans-serif;white-space:nowrap;background-color:#ebeff1;border:1px solid #abb2b7'>Benefits</th></tr></thead><tbody>";
                                //if (detail != null)
                                //{
                                //    foreach (var temp in detail)
                                //    {
                                //        table = table + "<tr><td style='border:1px solid #abb2b7;'>&nbsp;" + temp.Achievement + "</td><td style='border:1px solid #abb2b7;'>&nbsp;" + temp.Purpose + "</td></tr>";
                                //    }
                                //}
                                //var message = "This is to inform you that " + requesterName + " has forwarded Pimco achievements submitted by " + submittedBy + " of the quarter Q" + data.QuarterNo + " to you for your review. Please review the details submitted." /*+ Environment.NewLine + table*/;
                                var message = string.Format("&#60;{0}&#62; wants to talk about &#60;{1}&#62; with you after the quarterly feedback. Please discuss immediately.", requesterName, submittedBy);
                                var body = emailTemplate.Template
                               .Replace("[Name]", recieverName)
                               .Replace("[MessageContent]", message)
                               .Replace("[Title]", "Review Pimco Achievements");
                                // SEND MAIL 
                                Utilities.EmailHelper.SendEmailWithDefaultParameter(subject, body, true, true, recieverMail, null, null, null);

                            }
                        }
                    }
                    return 1;
                }
            }
            catch (Exception e)
            {
                return 0;
            }
        }
        #endregion

        #endregion
    }
}