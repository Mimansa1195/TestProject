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
    
    public partial class VisitorDetail
    {
        public int VisitorId { get; set; }
        public string Visitor_FName { get; set; }
        public string Visitor_LName { get; set; }
        public string Visitor_Address { get; set; }
        public string Visitor_ContactNo { get; set; }
        public string Visitor_Email { get; set; }
        public string Visitor_AppointmentWith { get; set; }
        public string Visitor_Purpose { get; set; }
        public string Visitor_IdentityProof { get; set; }
        public System.DateTime Visitor_TimeIn { get; set; }
        public Nullable<System.DateTime> Visitor_timeOut { get; set; }
        public string Visitor_PhotoUrl { get; set; }
        public string Visitor_IdPhotoUrl { get; set; }
        public string otheridcard { get; set; }
        public string AccessoriesPhotoUrl { get; set; }
        public Nullable<int> ReadPolicy { get; set; }
        public string OtherPurpose { get; set; }
        public string Colleagues { get; set; }
        public string Visitor_cardno { get; set; }
        public string CompanyName { get; set; }
    }
}