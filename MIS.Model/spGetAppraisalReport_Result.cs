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
    
    public partial class spGetAppraisalReport_Result
    {
        public string EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public string EmployeePhotoName { get; set; }
        public string CurrentDesignation { get; set; }
        public string ReportingManager { get; set; }
        public string Appraiser { get; set; }
        public string Approver { get; set; }
        public string AppraiserRecommendedDesignation { get; set; }
        public string AppraiserRecommendedPercentage { get; set; }
        public string ApproverRecommendedDesignation { get; set; }
        public string ApproverRecommendedPercentage { get; set; }
        public Nullable<bool> AppraiserMarkedHighPotential { get; set; }
        public Nullable<bool> ApproverMarkedHighPotential { get; set; }
        public string SelfRating { get; set; }
        public string AppraiserRating { get; set; }
        public string ApproverRating { get; set; }
        public string AppraisalStatus { get; set; }
    }
}
