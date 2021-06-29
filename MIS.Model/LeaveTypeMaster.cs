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
    
    public partial class LeaveTypeMaster
    {
        public LeaveTypeMaster()
        {
            this.DateWiseLeaveTypes = new HashSet<DateWiseLeaveType>();
            this.LeaveRequestApplicationDetails = new HashSet<LeaveRequestApplicationDetail>();
            this.LeaveBalances = new HashSet<LeaveBalance>();
        }
    
        public long TypeId { get; set; }
        public string ShortName { get; set; }
        public string Description { get; set; }
        public int Priority { get; set; }
        public bool IsAvailableForMarriedOnly { get; set; }
        public bool IsAvailableForMale { get; set; }
        public bool IsAvailableForFemale { get; set; }
        public Nullable<int> MaximumNoForMale { get; set; }
        public Nullable<int> MaximumNoForFemale { get; set; }
        public Nullable<int> MaximumLimitForMale { get; set; }
        public Nullable<int> MaximumLimitForFemale { get; set; }
        public string MaximumLimitPeriod { get; set; }
        public bool IsAutoIncremented { get; set; }
        public Nullable<int> AutoIncrementPeriod { get; set; }
        public string AutoIncrementAfterType { get; set; }
        public Nullable<System.DateTime> LastAutoIncrementDate { get; set; }
        public Nullable<System.DateTime> NextAutoIncrementDate { get; set; }
        public Nullable<int> DaysToIncrement { get; set; }
        public bool IsAutoExpire { get; set; }
        public Nullable<int> AutoExpirePeriod { get; set; }
        public string AutoExpireAfterType { get; set; }
        public Nullable<System.DateTime> LastAutoExpireDate { get; set; }
        public Nullable<System.DateTime> NextAutoExpireDate { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public Nullable<System.DateTime> LastModifiedDate { get; set; }
        public Nullable<int> LastModifiedBy { get; set; }
    
        public virtual ICollection<DateWiseLeaveType> DateWiseLeaveTypes { get; set; }
        public virtual ICollection<LeaveRequestApplicationDetail> LeaveRequestApplicationDetails { get; set; }
        public virtual ICollection<LeaveBalance> LeaveBalances { get; set; }
        public virtual User User { get; set; }
        public virtual User User1 { get; set; }
    }
}
