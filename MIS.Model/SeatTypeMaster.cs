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
    
    public partial class SeatTypeMaster
    {
        public SeatTypeMaster()
        {
            this.SeatMasters = new HashSet<SeatMaster>();
        }
    
        public int SeatTypeId { get; set; }
        public string SeatTypeName { get; set; }
        public int SequenceNo { get; set; }
        public bool IsActive { get; set; }
        public int CreatedBy { get; set; }
        public System.DateTime CreatedOn { get; set; }
        public Nullable<int> ModifiedBy { get; set; }
        public Nullable<System.DateTime> ModifiedOn { get; set; }
    
        public virtual ICollection<SeatMaster> SeatMasters { get; set; }
    }
}