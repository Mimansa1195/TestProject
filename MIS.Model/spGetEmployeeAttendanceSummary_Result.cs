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
    
    public partial class spGetEmployeeAttendanceSummary_Result
    {
        public string EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public string DepartmentName { get; set; }
        public string LocationName { get; set; }
        public string ReportingManager { get; set; }
        public int PresentDays { get; set; }
        public double WFH { get; set; }
        public double CL { get; set; }
        public double PL { get; set; }
        public double LWP { get; set; }
        public double COFF { get; set; }
    }
}
