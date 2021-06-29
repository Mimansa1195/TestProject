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
    
    public partial class UsersOnshoreMgrMapping
    {
        public long MappingId { get; set; }
        public int UserId { get; set; }
        public string ClientSideEmpId { get; set; }
        public long OnshoreMgrId { get; set; }
        public Nullable<System.DateTime> UserValidFromDate { get; set; }
        public Nullable<System.DateTime> UserValidTillDate { get; set; }
        public bool NotifyOnshoreMgr { get; set; }
        public bool IsActive { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public Nullable<System.DateTime> ModifiedDate { get; set; }
        public Nullable<int> ModifiedBy { get; set; }
    
        public virtual OnshoreManager OnshoreManager { get; set; }
        public virtual User User { get; set; }
    }
}