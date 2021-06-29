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
    
    public partial class WeekDay
    {
        public WeekDay()
        {
            this.Teams = new HashSet<Team>();
            this.TeamEmailTypeMappings = new HashSet<TeamEmailTypeMapping>();
        }
    
        public int WeekDayId { get; set; }
        public string WeekDayName { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public Nullable<System.DateTime> LastModifiedDate { get; set; }
        public Nullable<int> LastModifiedBy { get; set; }
    
        public virtual ICollection<Team> Teams { get; set; }
        public virtual ICollection<TeamEmailTypeMapping> TeamEmailTypeMappings { get; set; }
    }
}
