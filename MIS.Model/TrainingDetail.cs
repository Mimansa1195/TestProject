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
    
    public partial class TrainingDetail
    {
        public int TrainingDetailId { get; set; }
        public int TrainingId { get; set; }
        public int EmployeeId { get; set; }
        public int StatusId { get; set; }
        public int ApproverId { get; set; }
        public string Remarks { get; set; }
        public int CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public Nullable<int> LastModifiedBy { get; set; }
        public Nullable<System.DateTime> LastModifiedDate { get; set; }
    
        public virtual Training Training { get; set; }
        public virtual TrainingStatu TrainingStatu { get; set; }
        public virtual User User { get; set; }
        public virtual User User1 { get; set; }
    }
}
