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
    
    public partial class spGetLeaveApplication_Result
    {
        public string EmployeeName { get; set; }
        public string DepartmentName { get; set; }
        public System.DateTime FromDate { get; set; }
        public System.DateTime ToDate { get; set; }
        public double NoOfWorkingDays { get; set; }
        public double NoOfTotalDays { get; set; }
        public string PrimaryContactNo { get; set; }
        public string AlternativeContactNo { get; set; }
        public string LeaveType { get; set; }
        public string Reason { get; set; }
        public string ApproverRemarks { get; set; }
        public string Status { get; set; }
        public bool IsAvailableOnMobile { get; set; }
        public bool IsAvailableOnEmail { get; set; }
        public System.DateTime CreatedDate { get; set; }
    }
}