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
    
    public partial class DesignationGroup
    {
        public DesignationGroup()
        {
            this.Designations = new HashSet<Designation>();
            this.Designations1 = new HashSet<Designation>();
        }
    
        public int DesignationGroupId { get; set; }
        public string DesignationGroupName { get; set; }
        public bool IsActive { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public int CreatedById { get; set; }
        public Nullable<System.DateTime> ModifiedDate { get; set; }
        public Nullable<int> ModifiedById { get; set; }
    
        public virtual ICollection<Designation> Designations { get; set; }
        public virtual ICollection<Designation> Designations1 { get; set; }
    }
}
