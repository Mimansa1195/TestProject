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
    
    public partial class AttendanceDataChangeRequestCategory
    {
        public AttendanceDataChangeRequestCategory()
        {
            this.AttendanceDataChangeRequestApplications = new HashSet<AttendanceDataChangeRequestApplication>();
        }
    
        public int CategoryId { get; set; }
        public string CategoryCode { get; set; }
        public string Description { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public Nullable<System.DateTime> LastModifiedDate { get; set; }
        public Nullable<int> LastModifiedBy { get; set; }
    
        public virtual ICollection<AttendanceDataChangeRequestApplication> AttendanceDataChangeRequestApplications { get; set; }
        public virtual User User { get; set; }
        public virtual User User1 { get; set; }
    }
}