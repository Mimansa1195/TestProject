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
    
    public partial class ManpowerRequisitionInvite
    {
        public ManpowerRequisitionInvite()
        {
            this.ManpowerRequisitionForms = new HashSet<ManpowerRequisitionForm>();
        }
    
        public long InviteId { get; set; }
        public string ToEmailId { get; set; }
        public string Name { get; set; }
        public string Position { get; set; }
        public string RandomCode { get; set; }
        public Nullable<int> Status { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public long CreatedBy { get; set; }
        public Nullable<System.DateTime> LastModifiedDate { get; set; }
        public Nullable<long> LastModifiedBy { get; set; }
    
        public virtual ICollection<ManpowerRequisitionForm> ManpowerRequisitionForms { get; set; }
    }
}
