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
    
    public partial class CabPickDropLocation
    {
        public CabPickDropLocation()
        {
            this.CabRequests = new HashSet<CabRequest>();
        }
    
        public int CabPDLocationId { get; set; }
        public int LocationId { get; set; }
        public int RouteNo { get; set; }
        public string RouteLocation { get; set; }
        public int Sequence { get; set; }
        public bool IsActive { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public Nullable<System.DateTime> ModifiedDate { get; set; }
        public Nullable<int> ModifiedBy { get; set; }
    
        public virtual Location Location { get; set; }
        public virtual ICollection<CabRequest> CabRequests { get; set; }
    }
}