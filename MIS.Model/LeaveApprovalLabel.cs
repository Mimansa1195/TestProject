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
    
    public partial class LeaveApprovalLabel
    {
        public LeaveApprovalLabel()
        {
            this.LeaveApprovalLabelEmpAssts = new HashSet<LeaveApprovalLabelEmpAsst>();
            this.LeaveApprovalLabel1 = new HashSet<LeaveApprovalLabel>();
        }
    
        public int LeaveApprovalLabelId { get; set; }
        public string LabelName { get; set; }
        public Nullable<int> SeniorLabelId { get; set; }
        public Nullable<bool> IsDeleted { get; set; }
        public Nullable<int> LabelNumber { get; set; }
        public int LeaveTypeId { get; set; }
    
        public virtual ICollection<LeaveApprovalLabelEmpAsst> LeaveApprovalLabelEmpAssts { get; set; }
        public virtual ICollection<LeaveApprovalLabel> LeaveApprovalLabel1 { get; set; }
        public virtual LeaveApprovalLabel LeaveApprovalLabel2 { get; set; }
    }
}