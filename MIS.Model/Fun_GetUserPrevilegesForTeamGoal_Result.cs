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
    
    public partial class Fun_GetUserPrevilegesForTeamGoal_Result
    {
        public long TeamId { get; set; }
        public string TeamName { get; set; }
        public bool HasViewRights { get; set; }
        public bool HasAddRights { get; set; }
        public bool HasEditRights { get; set; }
        public bool HasReviewRights { get; set; }
    }
}
