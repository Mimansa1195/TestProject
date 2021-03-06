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
    
    public partial class Document
    {
        public Document()
        {
            this.ShareDocuments = new HashSet<ShareDocument>();
            this.SharedGroupDocuments = new HashSet<SharedGroupDocument>();
        }
    
        public int DocId { get; set; }
        public string Path { get; set; }
        public string Description { get; set; }
        public Nullable<int> GroupId { get; set; }
        public string FileDiscription { get; set; }
        public string Tags { get; set; }
        public Nullable<System.DateTime> Date { get; set; }
        public bool IsActive { get; set; }
        public Nullable<int> UserId { get; set; }
    
        public virtual ICollection<ShareDocument> ShareDocuments { get; set; }
        public virtual DocumentGroup DocumentGroup { get; set; }
        public virtual ICollection<SharedGroupDocument> SharedGroupDocuments { get; set; }
        public virtual User User { get; set; }
    }
}
