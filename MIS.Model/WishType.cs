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
    
    public partial class WishType
    {
        public WishType()
        {
            this.EmployeeWishes = new HashSet<EmployeeWish>();
        }
    
        public int WishTypeId { get; set; }
        public string WishType1 { get; set; }
    
        public virtual ICollection<EmployeeWish> EmployeeWishes { get; set; }
    }
}