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
    
    public partial class SeatCheckDetail
    {
        public int SeatCheckId { get; set; }
        public int SeatId { get; set; }
        public int ItemId { get; set; }
        public bool IsItemChecked { get; set; }
        public bool IsActive { get; set; }
        public int CreatedBy { get; set; }
        public System.DateTime CreatedOn { get; set; }
        public Nullable<int> ModifiedBy { get; set; }
        public Nullable<System.DateTime> ModifiedOn { get; set; }
    
        public virtual WPSCheckItemMaster WPSCheckItemMaster { get; set; }
        public virtual SeatMaster SeatMaster { get; set; }
    }
}
