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
    
    public partial class DocumentPermissionGroupPermission
    {
        public int DocumentPermissionGroupPermissionsId { get; set; }
        public int DocumentPermissionGroupId { get; set; }
        public int UserId { get; set; }
        public bool IsDeleted { get; set; }
    
        public virtual DocumentPermissionGroup DocumentPermissionGroup { get; set; }
        public virtual User User { get; set; }
    }
}
