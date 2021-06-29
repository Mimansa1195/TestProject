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
    
    public partial class AppraisalParameter
    {
        public AppraisalParameter()
        {
            this.CompetencyFormDetails = new HashSet<CompetencyFormDetail>();
        }
    
        public int ParameterId { get; set; }
        public string ParameterName { get; set; }
        public int Weightage { get; set; }
        public int CompetencyTypeId { get; set; }
        public int SequenceNo { get; set; }
        public bool IsFinalized { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public Nullable<System.DateTime> DeletedDate { get; set; }
        public Nullable<int> DeletedById { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public Nullable<int> CreatedById { get; set; }
        public Nullable<System.DateTime> ModifiedDate { get; set; }
        public Nullable<int> ModifiedById { get; set; }
    
        public virtual CompetencyType CompetencyType { get; set; }
        public virtual ICollection<CompetencyFormDetail> CompetencyFormDetails { get; set; }
    }
}
