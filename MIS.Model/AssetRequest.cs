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
    
    public partial class AssetRequest
    {
        public AssetRequest()
        {
            this.AssetTransactions = new HashSet<AssetTransaction>();
        }
    
        public long RequestId { get; set; }
        public long TypeId { get; set; }
        public string Reason { get; set; }
        public long RequiredFromDateId { get; set; }
        public Nullable<long> RequiredTillDateId { get; set; }
        public Nullable<int> StatusId { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public Nullable<System.DateTime> LastModifiedDate { get; set; }
        public Nullable<int> LastModifiedBy { get; set; }
    
        public virtual AssetStatu AssetStatu { get; set; }
        public virtual ICollection<AssetTransaction> AssetTransactions { get; set; }
        public virtual AssetType AssetType { get; set; }
        public virtual User User { get; set; }
    }
}
