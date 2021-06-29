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
    
    public partial class Proc_GetEmpAppraisalSetting_Result
    {
        public long EmpAppraisalSettingId { get; set; }
        public int EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public int LocationId { get; set; }
        public int VerticalId { get; set; }
        public int DivisionId { get; set; }
        public int DepartmentId { get; set; }
        public long TeamId { get; set; }
        public Nullable<int> DesignationId { get; set; }
        public string DesignationName { get; set; }
        public int AppraiserId { get; set; }
        public string AppraiserName { get; set; }
        public int RMId { get; set; }
        public string RMName { get; set; }
        public Nullable<int> HRId { get; set; }
        public string HRName { get; set; }
        public int IsSelfAppraisal { get; set; }
        public Nullable<int> CompetencyFormId { get; set; }
        public string CompetencyFormName { get; set; }
        public Nullable<bool> IsFinalized { get; set; }
        public int AppraisalCycleId { get; set; }
        public string AppraisalCycleName { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public int Approver1 { get; set; }
        public string Approver1Name { get; set; }
        public Nullable<int> Approver2 { get; set; }
        public string Approver2Name { get; set; }
        public Nullable<int> Approver3 { get; set; }
        public string Approver3Name { get; set; }
        public int AppraisalStatusId { get; set; }
        public string AppraisalStatusName { get; set; }
        public string LastPromotionDate { get; set; }
        public Nullable<int> LastPromotionDesignationId { get; set; }
        public Nullable<int> LastAppraisalCycleId { get; set; }
        public string LastAppraisalCycleName { get; set; }
        public string EmployeePhotoName { get; set; }
        public string AppraisalStatges { get; set; }
        public string AppraisalJsonStatges { get; set; }
        public Nullable<bool> IsSettingModified { get; set; }
        public Nullable<bool> IsModifyRight { get; set; }
        public Nullable<bool> IsVisible { get; set; }
        public string Reason { get; set; }
    }
}
