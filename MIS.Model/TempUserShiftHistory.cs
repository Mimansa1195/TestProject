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
    
    public partial class TempUserShiftHistory
    {
        public long TempUserShiftHistoryId { get; set; }
        public long TempUserShiftId { get; set; }
        public long StatusId { get; set; }
        public string Remarks { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public int CreatedBy { get; set; }
    
        public virtual OutingRequestStatu OutingRequestStatu { get; set; }
        public virtual TempUserShift TempUserShift { get; set; }
    }
}
