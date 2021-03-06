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
    
    public partial class LegitimateLeaveStatu
    {
        public LegitimateLeaveStatu()
        {
            this.LegitimateLeaveRequestHistories = new HashSet<LegitimateLeaveRequestHistory>();
            this.LegitimateLeaveRequests = new HashSet<LegitimateLeaveRequest>();
        }
    
        public long StatusId { get; set; }
        public string Status { get; set; }
        public string StatusCode { get; set; }
        public string Description { get; set; }
        public bool IsActive { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public int CreatedById { get; set; }
        public Nullable<System.DateTime> ModifiedDate { get; set; }
        public Nullable<int> ModifiedById { get; set; }
    
        public virtual ICollection<LegitimateLeaveRequestHistory> LegitimateLeaveRequestHistories { get; set; }
        public virtual ICollection<LegitimateLeaveRequest> LegitimateLeaveRequests { get; set; }
        public virtual User User { get; set; }
        public virtual User User1 { get; set; }
    }
}
