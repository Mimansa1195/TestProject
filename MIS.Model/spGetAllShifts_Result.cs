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
    
    public partial class spGetAllShifts_Result
    {
        public long ShiftId { get; set; }
        public string ShiftName { get; set; }
        public string InTime { get; set; }
        public string OutTime { get; set; }
        public string WorkingHours { get; set; }
        public bool IsWeekEnd { get; set; }
        public bool IsNight { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
    }
}