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
    
    public partial class AssetTransaction
    {
        public long TransactionId { get; set; }
        public long RequestId { get; set; }
        public long AssetDetailId { get; set; }
        public long IssueDateId { get; set; }
        public bool IsReturned { get; set; }
        public Nullable<long> ReturnedOnDateId { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public Nullable<System.DateTime> LastModifiedDate { get; set; }
        public Nullable<int> LastModifiedBy { get; set; }
        public Nullable<long> AcknowledgedOnDateId { get; set; }
    
        public virtual AssetDetail AssetDetail { get; set; }
        public virtual AssetRequest AssetRequest { get; set; }
        public virtual DateMaster DateMaster { get; set; }
        public virtual DateMaster DateMaster1 { get; set; }
        public virtual DateMaster DateMaster2 { get; set; }
        public virtual User User { get; set; }
    }
}
