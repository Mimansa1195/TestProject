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
    
    public partial class DocumentGroup
    {
        public DocumentGroup()
        {
            this.Documents = new HashSet<Document>();
        }
    
        public int DocGroupId { get; set; }
        public string Name { get; set; }
        public Nullable<int> ParentId { get; set; }
        public Nullable<int> UserID { get; set; }
        public Nullable<bool> DeleteFlag { get; set; }
    
        public virtual ICollection<Document> Documents { get; set; }
    }
}
