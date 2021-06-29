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
    
    public partial class RequestLnsa
    {
        public RequestLnsa()
        {
            this.RequestLnsaHistories = new HashSet<RequestLnsaHistory>();
            this.DateWiseLNSAs = new HashSet<DateWiseLNSA>();
        }
    
        public long RequestId { get; set; }
        public long FromDateId { get; set; }
        public long TillDateId { get; set; }
        public int TotalNoOfDays { get; set; }
        public string Reason { get; set; }
        public string ApproverRemarks { get; set; }
        public int Status { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public Nullable<System.DateTime> LastModifiedDate { get; set; }
        public Nullable<long> LastModifiedBy { get; set; }
        public Nullable<int> ApproverId { get; set; }
        public long StatusId { get; set; }
    
        public virtual LNSAStatusMaster LNSAStatusMaster { get; set; }
        public virtual ICollection<RequestLnsaHistory> RequestLnsaHistories { get; set; }
        public virtual ICollection<DateWiseLNSA> DateWiseLNSAs { get; set; }
        public virtual DateMaster DateMaster { get; set; }
        public virtual DateMaster DateMaster1 { get; set; }
        public virtual User User { get; set; }
    }
}
