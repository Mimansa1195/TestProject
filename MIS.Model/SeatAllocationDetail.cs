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
    
    public partial class SeatAllocationDetail
    {
        public int SeatAllocationDetailId { get; set; }
        public int SeatId { get; set; }
        public Nullable<int> AllocationTypeId { get; set; }
        public Nullable<int> UserId { get; set; }
        public Nullable<System.DateTime> AllocationFrom { get; set; }
        public Nullable<int> OnboardingId { get; set; }
        public Nullable<System.DateTime> JoiningDate { get; set; }
        public Nullable<int> SystemRequirementId { get; set; }
        public string DatabaseName { get; set; }
        public string Remark { get; set; }
        public Nullable<System.DateTime> BlockingFrom { get; set; }
        public Nullable<int> BlockingReasonId { get; set; }
        public bool IsActive { get; set; }
        public int CreatedBy { get; set; }
        public System.DateTime CreatedOn { get; set; }
        public Nullable<int> ModifiedBy { get; set; }
        public Nullable<System.DateTime> ModifiedOn { get; set; }
    
        public virtual AllocationTypeMaster AllocationTypeMaster { get; set; }
        public virtual BlockingReasonMaster BlockingReasonMaster { get; set; }
        public virtual SeatItemMaster SeatItemMaster { get; set; }
        public virtual SeatMaster SeatMaster { get; set; }
    }
}