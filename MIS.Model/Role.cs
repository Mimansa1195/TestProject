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
    
    public partial class Role
    {
        public Role()
        {
            this.DashboardWidgetRolePermissions = new HashSet<DashboardWidgetRolePermission>();
            this.MenusRolePermissions = new HashSet<MenusRolePermission>();
            this.Users = new HashSet<User>();
            this.APIRolePermissions = new HashSet<APIRolePermission>();
        }
    
        public int RoleId { get; set; }
        public string RoleName { get; set; }
        public bool IsDeleted { get; set; }
        public int AccessSequence { get; set; }
        public bool IsActive { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public Nullable<int> CreatedById { get; set; }
        public Nullable<System.DateTime> ModifiedDate { get; set; }
        public Nullable<int> ModifiedById { get; set; }
    
        public virtual ICollection<DashboardWidgetRolePermission> DashboardWidgetRolePermissions { get; set; }
        public virtual ICollection<MenusRolePermission> MenusRolePermissions { get; set; }
        public virtual ICollection<User> Users { get; set; }
        public virtual ICollection<APIRolePermission> APIRolePermissions { get; set; }
    }
}
