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
    
    public partial class DateWiseAttendanceAsquare
    {
        public long RecordId { get; set; }
        public long DateId { get; set; }
        public int UserId { get; set; }
        public Nullable<System.DateTime> SystemGeneratedInTime { get; set; }
        public Nullable<System.DateTime> SystemGeneratedOutTime { get; set; }
        public Nullable<System.DateTime> SystemGeneratedTotalWorkingHours { get; set; }
        public long SystemGeneratedStatusId { get; set; }
        public string SystemGeneratedRemarks { get; set; }
        public Nullable<System.DateTime> UserGivenInTime { get; set; }
        public Nullable<System.DateTime> UserGivenOutTime { get; set; }
        public Nullable<System.DateTime> UserGivenTotalWorkingHours { get; set; }
        public Nullable<long> UserGivenStatusId { get; set; }
        public string UserGivenRemarks { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
        public Nullable<System.DateTime> LastModifiedDate { get; set; }
        public Nullable<int> LastModifiedBy { get; set; }
    
        public virtual AttendanceStatusMaster AttendanceStatusMaster { get; set; }
        public virtual DateMaster DateMaster { get; set; }
        public virtual User User { get; set; }
        public virtual User User1 { get; set; }
        public virtual User User2 { get; set; }
    }
}
