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
    
    public partial class Menu
    {
        public Menu()
        {
            this.MenusApprovalLevels = new HashSet<MenusApprovalLevel>();
            this.MenusRolePermissions = new HashSet<MenusRolePermission>();
            this.MenusUserDelegations = new HashSet<MenusUserDelegation>();
            this.MenusUserPermissions = new HashSet<MenusUserPermission>();
        }
    
        public int MenuId { get; set; }
        public int ParentMenuId { get; set; }
        public string MenuName { get; set; }
        public string ControllerName { get; set; }
        public string ActionName { get; set; }
        public int Sequence { get; set; }
        public bool IsLinkEnabled { get; set; }
        public bool IsVisible { get; set; }
        public bool IsActive { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public Nullable<int> CreatedById { get; set; }
        public Nullable<System.DateTime> ModifiedDate { get; set; }
        public Nullable<int> ModifiedById { get; set; }
        public string CssClass { get; set; }
        public bool IsDelegatable { get; set; }
        public bool IsTabMenu { get; set; }
    
        public virtual ICollection<MenusApprovalLevel> MenusApprovalLevels { get; set; }
        public virtual ICollection<MenusRolePermission> MenusRolePermissions { get; set; }
        public virtual ICollection<MenusUserDelegation> MenusUserDelegations { get; set; }
        public virtual ICollection<MenusUserPermission> MenusUserPermissions { get; set; }
    }
}
