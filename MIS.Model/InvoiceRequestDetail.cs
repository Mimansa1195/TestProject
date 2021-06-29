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
    
    public partial class InvoiceRequestDetail
    {
        public InvoiceRequestDetail()
        {
            this.Invoices = new HashSet<Invoice>();
        }
    
        public long InvoiceRequestDetailId { get; set; }
        public long InvoiceRequestId { get; set; }
        public int ClientId { get; set; }
        public int RequestedCount { get; set; }
        public int AvailableCount { get; set; }
        public bool IsActive { get; set; }
        public int CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public Nullable<int> ModifiedBy { get; set; }
        public Nullable<System.DateTime> ModifiedDate { get; set; }
    
        public virtual Client Client { get; set; }
        public virtual ICollection<Invoice> Invoices { get; set; }
        public virtual InvoiceRequest InvoiceRequest { get; set; }
    }
}
