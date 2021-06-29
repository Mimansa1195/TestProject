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
    
    public partial class OfficeDutyRequest
    {
        public OfficeDutyRequest()
        {
            this.OfficeDutyRequestHistories = new HashSet<OfficeDutyRequestHistory>();
        }
    
        public long OfficeDutyRequestId { get; set; }
        public int OfficeDutyTypeId { get; set; }
        public int UserId { get; set; }
        public long FromDateId { get; set; }
        public long TillDateId { get; set; }
        public long StatusId { get; set; }
        public string Reason { get; set; }
        public Nullable<int> ApproverId { get; set; }
        public string ApproverRemarks { get; set; }
        public bool IsActive { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public int CreatedById { get; set; }
        public Nullable<System.DateTime> ModifiedDate { get; set; }
        public Nullable<int> ModifiedById { get; set; }
    
        public virtual DateMaster DateMaster { get; set; }
        public virtual DateMaster DateMaster1 { get; set; }
        public virtual LeaveStatusMaster LeaveStatusMaster { get; set; }
        public virtual OfficeDutyType OfficeDutyType { get; set; }
        public virtual User User { get; set; }
        public virtual User User1 { get; set; }
        public virtual User User2 { get; set; }
        public virtual ICollection<OfficeDutyRequestHistory> OfficeDutyRequestHistories { get; set; }
    }
}