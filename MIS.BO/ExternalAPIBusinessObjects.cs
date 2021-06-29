using System.Collections.Generic;
using System;
using System.Net;

namespace MIS.BO
{
    public class GeminiUsersBaseBO
    {
        public string EmployeeName { get; set; }
        public string EmployeeCode { get; set; }
        public string GeminiEmailId { get; set; }
        public string Designation { get; set; }
        public string Team { get; set; }
        public string Department { get; set; }
        public string JoiningDate { get; set; }
        public string RMName { get; set; }
        public string RMEmployeeCode { get; set; }
    }

    public class GeminiUsersForPnL : GeminiUsersBaseBO
    {
        public string ExitDate { get; set; }
        public string ImageUrl { get; set; }
        public bool IsPimcoUser { get; set; }
        public string PimcoId { get; set; }
        public bool IsActive { get; set; }
    }

}
