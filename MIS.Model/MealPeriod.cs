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
    
    public partial class MealPeriod
    {
        public MealPeriod()
        {
            this.MealPackages = new HashSet<MealPackage>();
        }
    
        public int MealPeriodId { get; set; }
        public string MealPeriodName { get; set; }
        public Nullable<System.TimeSpan> StartTime { get; set; }
        public bool IsActive { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public Nullable<int> CreatedById { get; set; }
        public Nullable<System.DateTime> ModifiedDate { get; set; }
        public Nullable<int> ModifiedById { get; set; }
    
        public virtual ICollection<MealPackage> MealPackages { get; set; }
    }
}
