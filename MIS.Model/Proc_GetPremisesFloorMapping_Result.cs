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
    
    public partial class Proc_GetPremisesFloorMapping_Result
    {
        public int PremisesFloorId { get; set; }
        public int PremisesId { get; set; }
        public string PremisesName { get; set; }
        public int FloorId { get; set; }
        public string FloorName { get; set; }
        public int LocationId { get; set; }
        public string LocationName { get; set; }
        public Nullable<int> TotalBay { get; set; }
        public bool IsActive { get; set; }
    }
}
