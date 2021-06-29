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
    
    public partial class LegitimateLeaveRequest
    {
        public LegitimateLeaveRequest()
        {
            this.LegitimateLeaveRequestHistories = new HashSet<LegitimateLeaveRequestHistory>();
            this.RequestCompOffDetails = new HashSet<RequestCompOffDetail>();
        }
    
        public long LegitimateLeaveRequestId { get; set; }
        public long LeaveRequestApplicationId { get; set; }
        public int UserId { get; set; }
        public long DateId { get; set; }
        public string Reason { get; set; }
        public string LeaveCombination { get; set; }
        public long StatusId { get; set; }
        public Nullable<int> NextApproverId { get; set; }
        public string Remarks { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public Nullable<System.DateTime> LastModifiedDate { get; set; }
        public Nullable<int> LastModifiedBy { get; set; }
    
        public virtual LeaveRequestApplication LeaveRequestApplication { get; set; }
        public virtual LegitimateLeaveStatu LegitimateLeaveStatu { get; set; }
        public virtual ICollection<LegitimateLeaveRequestHistory> LegitimateLeaveRequestHistories { get; set; }
        public virtual ICollection<RequestCompOffDetail> RequestCompOffDetails { get; set; }
        public virtual DateMaster DateMaster { get; set; }
        public virtual User User { get; set; }
        public virtual User User1 { get; set; }
        public virtual User User2 { get; set; }
        public virtual User User3 { get; set; }
        public virtual User User4 { get; set; }
    }
}