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
    
    public partial class DepartmentWiseAssetLimit
    {
        public long LimitId { get; set; }
        public int DepartmentId { get; set; }
        public long TypeId { get; set; }
        public int MaximumLimit { get; set; }
        public bool IsDeleted { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public Nullable<System.DateTime> LastModifiedDate { get; set; }
        public Nullable<int> LastModifiedBy { get; set; }
    
        public virtual Department Department { get; set; }
        public virtual AssetType AssetType { get; set; }
        public virtual User User { get; set; }
    }
}
