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
    
    public partial class TaskTypeTaskSubDetail2Mapping
    {
        public long MappingId { get; set; }
        public long TaskTypeId { get; set; }
        public long TaskSubDetail2Id { get; set; }
        public bool IsActive { get; set; }
        public Nullable<System.DateTime> CreatedDate { get; set; }
        public Nullable<int> CreatedBy { get; set; }
        public Nullable<System.DateTime> LastModifiedDate { get; set; }
        public Nullable<int> LastModifiedBy { get; set; }
    
        public virtual TaskSubDetail2 TaskSubDetail2 { get; set; }
        public virtual TaskType TaskType { get; set; }
        public virtual User User { get; set; }
    }
}