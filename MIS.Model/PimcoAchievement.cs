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
    
    public partial class PimcoAchievement
    {
        public PimcoAchievement()
        {
            this.PimcoAchievementDetails = new HashSet<PimcoAchievementDetail>();
        }
    
        public int PimcoAchievementId { get; set; }
        public int UserId { get; set; }
        public int FYStartYear { get; set; }
        public int QuarterNo { get; set; }
        public System.DateTime QuarterStartDate { get; set; }
        public System.DateTime QuarterEndDate { get; set; }
        public bool IsActive { get; set; }
        public bool ToBeDiscussedWithHR { get; set; }
        public string EmpComments { get; set; }
        public string RMComments { get; set; }
        public int CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public Nullable<int> ModifiedBy { get; set; }
        public Nullable<System.DateTime> ModifiedDate { get; set; }
    
        public virtual ICollection<PimcoAchievementDetail> PimcoAchievementDetails { get; set; }
        public virtual User User { get; set; }
    }
}
