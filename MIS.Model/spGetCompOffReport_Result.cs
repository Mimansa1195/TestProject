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
    
    public partial class spGetCompOffReport_Result
    {
        public int UserId { get; set; }
        public string EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public string DepartmentName { get; set; }
        public string LocationName { get; set; }
        public string ReportingManager { get; set; }
        public Nullable<int> Applied { get; set; }
        public int Approved { get; set; }
        public int PendingForApproval { get; set; }
        public int Rejected { get; set; }
        public double Availed { get; set; }
        public double Balance { get; set; }
    }
}
