//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace MIS.Model
{
    using System;
    
    public partial class Proc_GetEmpAppraisalForm_Result
    {
        public long EmpAppraisalSettingId { get; set; }
        public int UserId { get; set; }
        public string EmployeeName { get; set; }
        public string EmployeeCode { get; set; }
        public string DateOfJoin { get; set; }
        public string DesignationName { get; set; }
        public int AppraiserId { get; set; }
        public string AppraiserName { get; set; }
        public string AppraiserDesignation { get; set; }
        public int RMId { get; set; }
        public string RMName { get; set; }
        public Nullable<int> HRId { get; set; }
        public string HRName { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public int IsSelfAppraisal { get; set; }
        public Nullable<int> CompetencyFormId { get; set; }
        public string CompetencyFormName { get; set; }
        public Nullable<bool> IsRating { get; set; }
        public int AppraisalCycleId { get; set; }
        public string AppraisalCycleName { get; set; }
        public string ReviewFrom { get; set; }
        public string ReviewTo { get; set; }
        public int Approver1 { get; set; }
        public string Approver1Name { get; set; }
        public string Approver1Designation { get; set; }
        public Nullable<int> Approver2 { get; set; }
        public string Approver2Name { get; set; }
        public Nullable<int> Approver3 { get; set; }
        public string Approver3Name { get; set; }
        public int AppraisalStatusId { get; set; }
        public string AppraisalStatusName { get; set; }
        public string AppraiseeComment { get; set; }
        public string AppraiserComment { get; set; }
        public string ApproverComment { get; set; }
        public Nullable<long> EmpAppraisalId { get; set; }
        public Nullable<int> AppraiserRecommendedForDesignationId { get; set; }
        public Nullable<int> AppraiserRecommendedPercentage { get; set; }
        public string AppraiserRecommendationComment { get; set; }
        public Nullable<int> Approver1RecommendedForDesignationId { get; set; }
        public Nullable<int> Approver1RecommendedPercentage { get; set; }
        public string Approver1RecommendationComment { get; set; }
        public Nullable<bool> AppraiserMarkedHighPotential { get; set; }
        public string AppraiserHighPotentialComment { get; set; }
        public Nullable<bool> Approver1MarkedHighPotential { get; set; }
        public string Approver1HighPotentialComment { get; set; }
        public string AppraisalParameterDetail { get; set; }
        public string EmployeeGoals { get; set; }
        public string EmployeeAchievements { get; set; }
        public Nullable<bool> IsViewRight { get; set; }
        public Nullable<bool> IsModifyRight { get; set; }
        public Nullable<decimal> SelfOverallRatingWeighted { get; set; }
        public Nullable<decimal> AppraiserOverallRatingWeighted { get; set; }
        public Nullable<decimal> ApproverOverallRatingWeighted { get; set; }
        public Nullable<decimal> SelfOverallRatingNormal { get; set; }
        public Nullable<decimal> AppraiserOverallRatingNormal { get; set; }
        public Nullable<decimal> ApproverOverallRatingNormal { get; set; }
        public string SelfSubmitDate { get; set; }
    }
}
