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
    
    public partial class vwTasksForTaskVerification
    {
        public long TaskId { get; set; }
        public long MappingId { get; set; }
        public int WeekNo { get; set; }
        public int Year { get; set; }
        public Nullable<System.DateTime> Date { get; set; }
        public int ResourceId { get; set; }
        public string Resource { get; set; }
        public string ResourceTeamName { get; set; }
        public long ProjectId { get; set; }
        public string ProjectName { get; set; }
        public string Description { get; set; }
        public long TaskTeamId { get; set; }
        public string TaskTeamName { get; set; }
        public long TaskTypeId { get; set; }
        public string TaskTypeName { get; set; }
        public long TaskSubDetail1Id { get; set; }
        public string TaskSubDetail1Name { get; set; }
        public long TaskSubDetail2Id { get; set; }
        public string TaskSubDetail2Name { get; set; }
        public Nullable<decimal> TimeSpent { get; set; }
        public bool ConsiderInClientReports { get; set; }
    }
}