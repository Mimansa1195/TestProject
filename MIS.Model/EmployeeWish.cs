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
    
    public partial class EmployeeWish
    {
        public long EmployeeWishId { get; set; }
        public long WishTo { get; set; }
        public int WishTypeId { get; set; }
        public string Message { get; set; }
        public long CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
    
        public virtual WishType WishType { get; set; }
    }
}