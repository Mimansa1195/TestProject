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
    
    public partial class spGetErrorLogs_Result
    {
        public int ErrorId { get; set; }
        public string ModuleName { get; set; }
        public string Source { get; set; }
        public string ControllerName { get; set; }
        public string ActionName { get; set; }
        public string ErrorType { get; set; }
        public string ErrorMessage { get; set; }
        public string TargetSite { get; set; }
        public string ReportedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
    }
}
