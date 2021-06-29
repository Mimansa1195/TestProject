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
    using System.Collections.Generic;
    
    public partial class EmpAppraisalParameterDetail
    {
        public long EAParameterDetailId { get; set; }
        public long EmpAppraisalId { get; set; }
        public int CompetencyFormDetailId { get; set; }
        public string SelfComment { get; set; }
        public Nullable<int> SelfRatingId { get; set; }
        public string AppraiserComment { get; set; }
        public Nullable<int> AppraiserRatingId { get; set; }
        public string ApproverComment { get; set; }
        public Nullable<int> ApproverRatingId { get; set; }
        public bool IsActive { get; set; }
        public int CreatedBy { get; set; }
        public System.DateTime CreatedOn { get; set; }
        public Nullable<int> ModifiedBy { get; set; }
        public Nullable<System.DateTime> ModifiedOn { get; set; }
    
        public virtual AppraisalRating AppraisalRating { get; set; }
        public virtual AppraisalRating AppraisalRating1 { get; set; }
        public virtual AppraisalRating AppraisalRating2 { get; set; }
        public virtual CompetencyFormDetail CompetencyFormDetail { get; set; }
        public virtual EmpAppraisal EmpAppraisal { get; set; }
    }
}