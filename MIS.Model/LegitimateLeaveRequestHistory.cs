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
    
    public partial class LegitimateLeaveRequestHistory
    {
        public long LegitimateLeaveRequestHistoryId { get; set; }
        public long LegitimateLeaveRequestId { get; set; }
        public long DateId { get; set; }
        public string Reason { get; set; }
        public long StatusId { get; set; }
        public string Remarks { get; set; }
        public int CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
    
        public virtual LegitimateLeaveStatu LegitimateLeaveStatu { get; set; }
        public virtual LegitimateLeaveRequest LegitimateLeaveRequest { get; set; }
        public virtual DateMaster DateMaster { get; set; }
        public virtual User User { get; set; }
    }
}
