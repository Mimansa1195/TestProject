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
    
    public partial class UserPromotionHistory
    {
        public int UserPromotionHistoryId { get; set; }
        public int UserId { get; set; }
        public int OldDesignationId { get; set; }
        public int NewDesignationId { get; set; }
        public System.DateTime PromotionDate { get; set; }
        public string OldEmployeeCode { get; set; }
        public string NewEmployeeCode { get; set; }
        public int CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public Nullable<int> LastModifiedBy { get; set; }
        public Nullable<System.DateTime> LastModifiedDate { get; set; }
    
        public virtual User User { get; set; }
    }
}
