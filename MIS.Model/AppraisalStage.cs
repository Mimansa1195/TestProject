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
    
    public partial class AppraisalStage
    {
        public AppraisalStage()
        {
            this.AppraisalSettingStages = new HashSet<AppraisalSettingStage>();
            this.EmpAppraisalSettingStages = new HashSet<EmpAppraisalSettingStage>();
        }
    
        public int AppraisalStageId { get; set; }
        public string AppraisalStageName { get; set; }
        public string AppraisalStageCode { get; set; }
        public int SequenceNo { get; set; }
        public bool IsActive { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public Nullable<int> CreatedById { get; set; }
        public Nullable<System.DateTime> ModifiedDate { get; set; }
        public Nullable<int> ModifiedById { get; set; }
    
        public virtual ICollection<AppraisalSettingStage> AppraisalSettingStages { get; set; }
        public virtual ICollection<EmpAppraisalSettingStage> EmpAppraisalSettingStages { get; set; }
    }
}
