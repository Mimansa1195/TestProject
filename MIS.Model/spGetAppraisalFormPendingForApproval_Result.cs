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
    
    public partial class spGetAppraisalFormPendingForApproval_Result
    {
        public int EmployeeId { get; set; }
        public long FormId { get; set; }
        public string EmployeeName { get; set; }
        public System.DateTime ReviewPeriodFromDate { get; set; }
        public System.DateTime ReviewPeriodTillDate { get; set; }
        public Nullable<System.DateTime> SubmitDate { get; set; }
        public int Status { get; set; }
        public Nullable<System.DateTime> JoiningDate { get; set; }
    }
}
