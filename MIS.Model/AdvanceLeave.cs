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
    
    public partial class AdvanceLeave
    {
        public AdvanceLeave()
        {
            this.AdvanceLeaveDetails = new HashSet<AdvanceLeaveDetail>();
        }
    
        public long AdvanceLeaveId { get; set; }
        public long UserId { get; set; }
        public int FromDateId { get; set; }
        public int TillDateId { get; set; }
        public string Reason { get; set; }
        public bool IsActive { get; set; }
        public int CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public Nullable<int> LastModifiedBy { get; set; }
        public Nullable<System.DateTime> LastModifiedDate { get; set; }
    
        public virtual ICollection<AdvanceLeaveDetail> AdvanceLeaveDetails { get; set; }
    }
}
