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
    
    public partial class Client
    {
        public Client()
        {
            this.InvoiceRequestDetails = new HashSet<InvoiceRequestDetail>();
            this.OnshoreManagers = new HashSet<OnshoreManager>();
        }
    
        public int ClientId { get; set; }
        public string ClientName { get; set; }
        public bool IsActive { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public long CreatedBy { get; set; }
        public Nullable<System.DateTime> ModifiedDate { get; set; }
        public Nullable<long> ModifiedBy { get; set; }
    
        public virtual ICollection<InvoiceRequestDetail> InvoiceRequestDetails { get; set; }
        public virtual ICollection<OnshoreManager> OnshoreManagers { get; set; }
    }
}
