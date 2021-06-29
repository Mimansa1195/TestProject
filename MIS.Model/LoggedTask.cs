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
    
    public partial class LoggedTask
    {
        public LoggedTask()
        {
            this.TimeSheetTaskMappings = new HashSet<TimeSheetTaskMapping>();
        }
    
        public long TaskId { get; set; }
        public System.DateTime Date { get; set; }
        public long ProjectId { get; set; }
        public string Description { get; set; }
        public long TaskTeamId { get; set; }
        public long TaskTypeId { get; set; }
        public long TaskSubDetail1Id { get; set; }
        public long TaskSubDetail2Id { get; set; }
        public decimal TimeSpent { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public Nullable<System.DateTime> LastModifiedDate { get; set; }
        public Nullable<int> LastModifiedBy { get; set; }
    
        public virtual Project Project { get; set; }
        public virtual TaskSubDetail1 TaskSubDetail1 { get; set; }
        public virtual TaskSubDetail2 TaskSubDetail2 { get; set; }
        public virtual TaskTeam TaskTeam { get; set; }
        public virtual TaskType TaskType { get; set; }
        public virtual ICollection<TimeSheetTaskMapping> TimeSheetTaskMappings { get; set; }
        public virtual User User { get; set; }
    }
}
