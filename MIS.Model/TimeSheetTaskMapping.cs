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
    
    public partial class TimeSheetTaskMapping
    {
        public TimeSheetTaskMapping()
        {
            this.FinalLoggedTasks = new HashSet<FinalLoggedTask>();
        }
    
        public long RecordId { get; set; }
        public long TimeSheetId { get; set; }
        public long TaskId { get; set; }
        public bool ConsiderInClientReports { get; set; }
    
        public virtual ICollection<FinalLoggedTask> FinalLoggedTasks { get; set; }
        public virtual LoggedTask LoggedTask { get; set; }
        public virtual TimeSheet TimeSheet { get; set; }
    }
}