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
    
    public partial class Proc_GetCabRequestDetail_Result
    {
        public long CabRequestId { get; set; }
        public string EmployeeName { get; set; }
        public string StatusCode { get; set; }
        public string Status { get; set; }
        public int StatusId { get; set; }
        public System.DateTime Date { get; set; }
        public string CreatedDate { get; set; }
        public string Shift { get; set; }
        public int ShiftId { get; set; }
        public int ServiceTypeId { get; set; }
        public string ServiceType { get; set; }
        public int CompanyLocationId { get; set; }
        public string RouteLocation { get; set; }
        public int RouteNo { get; set; }
        public string LocationDetail { get; set; }
        public int RouteLocationId { get; set; }
        public string Approver { get; set; }
        public string EmpContactNo { get; set; }
    }
}
