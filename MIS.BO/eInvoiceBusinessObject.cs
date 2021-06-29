using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MIS.BO
{
    public class InvoiceClient
    {
        public long ClientId { get; set; }
        public string ClientName { get; set; }
        public string ClientAddress { get; set; }
        public string City { get; set; }
        public string Country { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
    }

    public class ClientSideManager
    {
        public long ClientSideManagerId { get; set; }
        public long ClientId { get; set; }
        public string ManagerName { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
    }

    public class ClientResource
    {
        public long ClientResourceId { get; set; }
        public string ResourceName { get; set; }
        public string ClientProjectName { get; set; }
        public string FriendlyName { get; set; }
        public string ClientProjectCode { get; set; }
        public string ClientProjectDescription { get; set; }
        public long ClientId { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
    }

    public class EmployeeMaster
    {   
        public int EmployeeId { get; set; }
        public string PimcoEmployeeId { get; set; }
        public long MappingId { get; set; }
        public string EmployeeName { get; set; }
        public string EmailId { get; set; }
        public long ClientSideManagerId { get; set; }
        public long ProjectId { get; set; }
        public bool IsBilled { get; set; }
        public bool? IsActive { get; set; }
        public bool? IsDeleted { get; set; }
    }

    public class EmployeesBO
    {
        public int UserId { get; set; }
        public string EmployeeCode { get; set; }
        public string EmployeeName { get; set; }
        public string EmailId { get; set; }
    }


    public class CalenderMaster
    {
        public long DateId { get; set; }
        public DateTime Date { get; set; }
        public String Day { get; set; }
        public bool IsHoliday { get; set; }
        public bool IsWeekend { get; set; }
    }

    public class Shift
    {
        public long ShiftId { get; set; }
        public string ShiftName { get; set; }
        public string InTime { get; set; }
        public string OutTime { get; set; }
        public string WorkingHours { get; set; }
        public bool IsWeekEnd { get; set; }
        public bool IsNight { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
    }

    public class EmployeeAndShiftMapping
    {
        public long MappingId { get; set; }
        public long DateId { get; set; }
        public int UserId { get; set; }
        public long ShiftId { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
    }

    public class InvoiceProject
    {
        public long ProjectId { get; set; }
        public string ProjectName { get; set; }
        public string FriendlyName { get; set; }
        public string ProjectCode { get; set; }
        public string Description { get; set; }
        public long ClientResourceId { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
    }

    public class EmployeeTotalLoggedHours
    {
        public long EmployeeId { get; set; }
        public decimal TotalLoggedHours { get; set; }
        public decimal TotalLoginHours { get; set; } //Attendance
    }

    public class EmployeeLeaveDates
    {
        public int UserId { get; set; }
        public List<DateTime> Date { get; set; }
    }

    public class ListHoliday
    {
        public long HolidayId { get; set; }
        public long DateId { get; set; }
        public string Occasion { get; set; }
    }



    public class ConsolidatedMisData
    {
        public string Status { get; set; }
        public List<InvoiceClient> Client { get; set; }
        public List<ClientResource> ClientResource { get; set; }
        public List<ClientSideManager> ClientSideReportTo { get; set; }
        public List<EmployeeMaster> EmployeeMaster { get; set; }
        public List<CalenderMaster> CalenderMaster { get; set; }
        public List<Shift> Shift { get; set; }
        public List<EmployeeAndShiftMapping> EmployeeAndShiftMapping { get; set; }
        public List<InvoiceProject> Project { get; set; }
        public List<EmployeeTotalLoggedHours> EmployeeTotalLoggedHours { get; set; }
        public List<EmployeeLeaveDates> EmployeeLeaveDates { get; set; }
        public List<ListHoliday> ListHoliday { get; set; }
        public List<ProjectMappingJsonList> ListMappedProjects {get; set;}
        public List<EmployeesBO> ListGeminiUsers { get; set; }
    }

    public class ProjectMappingJsonList
    {
        public string EmployeeId { get; set; }
        public long MappingId { get; set; }
        public bool IsBilled { get; set; }
        public bool IsActive { get; set; }
        public long ProjectId { get; set; }
        public long ClientSideManagerId { get; set; }
    }

    public class EmployeeProjectMappingBO
    {
        public EmployeeProjectMappingBO()
        {
            this.JsonDataList = new List<ProjectMappingJsonList>();
        }

        public List<ProjectMappingJsonList> JsonDataList { get; set; }
    }

    public class UserShiftMappingFilterBO
    {
        public UserShiftMappingFilterBO()
        {
            this.JsonDataList = new List<ShiftMappingJsonList>();
        }
        
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public List<ShiftMappingJsonList> JsonDataList { get; set; }
    }

    public class ShiftMappingJsonList
    {
        public int UserId { get; set; }
        public string Shift { get; set; }
    }
}
