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
    
    public partial class AdvanceLeaveDetail
    {
        public long AdvanceLeaveDetailId { get; set; }
        public long AdvanceLeaveId { get; set; }
        public int DateId { get; set; }
        public bool IsActive { get; set; }
        public bool IsAdjusted { get; set; }
        public Nullable<long> AdjustedLeaveReqAppId { get; set; }
        public int CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public Nullable<int> LastModifiedBy { get; set; }
        public Nullable<System.DateTime> LastModifiedDate { get; set; }
    
        public virtual AdvanceLeave AdvanceLeave { get; set; }
        public virtual LeaveRequestApplication LeaveRequestApplication { get; set; }
    }
}
