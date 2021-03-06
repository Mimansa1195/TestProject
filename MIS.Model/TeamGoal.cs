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
    
    public partial class TeamGoal
    {
        public TeamGoal()
        {
            this.TeamGoalComments = new HashSet<TeamGoalComment>();
        }
    
        public long TeamGoalId { get; set; }
        public long TeamId { get; set; }
        public Nullable<int> AppraisalCycleId { get; set; }
        public long StartDateId { get; set; }
        public long EndDateId { get; set; }
        public string Goal { get; set; }
        public bool IsActive { get; set; }
        public string OtherRemark { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public Nullable<System.DateTime> LastModifiedDate { get; set; }
        public Nullable<int> LastModifiedBy { get; set; }
        public long GoalStatusId { get; set; }
        public int GoalCategoryId { get; set; }
    
        public virtual AppraisalCycle AppraisalCycle { get; set; }
        public virtual DateMaster DateMaster { get; set; }
        public virtual DateMaster DateMaster1 { get; set; }
        public virtual GoalCategory GoalCategory { get; set; }
        public virtual Team Team { get; set; }
        public virtual User User { get; set; }
        public virtual ICollection<TeamGoalComment> TeamGoalComments { get; set; }
    }
}
