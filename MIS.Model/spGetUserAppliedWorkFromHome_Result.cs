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
    
    public partial class spGetUserAppliedWorkFromHome_Result
    {
        public long WorkFromHomeId { get; set; }
        public System.DateTime ApplyDate { get; set; }
        public System.DateTime FromDate { get; set; }
        public System.DateTime TillDate { get; set; }
        public string LeaveType { get; set; }
        public string Reason { get; set; }
        public string Status { get; set; }
        public string StatusFullForm { get; set; }
        public string Remarks { get; set; }
        public bool IsHalfDay { get; set; }
    }
}