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
    
    public partial class InvoiceTemplate
    {
        public int InvoiceTemplateId { get; set; }
        public int InvoiceCompanyId { get; set; }
        public string InvoiceTemplateTitle { get; set; }
        public string InvoiceTemplatePath { get; set; }
    
        public virtual Company Company { get; set; }
    }
}
