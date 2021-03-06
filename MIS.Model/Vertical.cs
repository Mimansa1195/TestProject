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
    
    public partial class Vertical
    {
        public Vertical()
        {
            this.AppraisalSettings = new HashSet<AppraisalSetting>();
            this.CompetencyForms = new HashSet<CompetencyForm>();
            this.Divisions = new HashSet<Division>();
            this.EmpAppraisalSettings = new HashSet<EmpAppraisalSetting>();
            this.EmpAppraisalSettingLogs = new HashSet<EmpAppraisalSettingLog>();
        }
    
        public int VerticalId { get; set; }
        public string VerticalName { get; set; }
        public string Description { get; set; }
        public int VerticalHeadId { get; set; }
        public bool IsActive { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public Nullable<int> CreatedById { get; set; }
        public Nullable<System.DateTime> ModifiedDate { get; set; }
        public Nullable<int> ModifiedById { get; set; }
        public int DomainId { get; set; }
    
        public virtual ICollection<AppraisalSetting> AppraisalSettings { get; set; }
        public virtual ICollection<CompetencyForm> CompetencyForms { get; set; }
        public virtual ICollection<Division> Divisions { get; set; }
        public virtual Domain Domain { get; set; }
        public virtual ICollection<EmpAppraisalSetting> EmpAppraisalSettings { get; set; }
        public virtual ICollection<EmpAppraisalSettingLog> EmpAppraisalSettingLogs { get; set; }
        public virtual User User { get; set; }
    }
}
