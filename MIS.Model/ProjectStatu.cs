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
    
    public partial class ProjectStatu
    {
        public ProjectStatu()
        {
            this.Projects = new HashSet<Project>();
            this.PimcoProjects = new HashSet<PimcoProject>();
        }
    
        public long ProjectStatusId { get; set; }
        public string ProjectStatus { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public Nullable<System.DateTime> LastModifiiedDate { get; set; }
        public Nullable<int> LastModifiedBy { get; set; }
    
        public virtual ICollection<Project> Projects { get; set; }
        public virtual ICollection<PimcoProject> PimcoProjects { get; set; }
        public virtual User User { get; set; }
    }
}
