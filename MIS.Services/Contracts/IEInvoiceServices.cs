using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MIS.BO;

namespace MIS.Services.Contracts
{
    public interface IEInvoiceServices
    {
        #region public 

        List<InvoiceClient> GetAllClients();

        List<ClientResource> GetAllClientResource();

        List<ClientSideManager> GetAllClientSideManager();

        List<EmployeeMaster> GetAllEmployees();

        List<InvoiceProject> GetAllProjects();

        List<Shift> GetAllShifts();

        List<CalenderMaster> GetCalender(DateTime startDate, DateTime endDate);

        List<EmployeeAndShiftMapping> GetEmployeeShiftMapping(DateTime startDate, DateTime endDate);

        List<EmployeeTotalLoggedHours> GetEmployeeTotalLoggedHours(DateTime startDate, DateTime endDate);

        List<EmployeeLeaveDates> GetEmployeeLeaves(DateTime startDate, DateTime endDate);

        List<ListHoliday> GetAllHolidays(DateTime startDate, DateTime endDate);

        List<ProjectMappingJsonList> GetProjectMapping();

        List<EmployeesBO> GetAllGeminiUser();
        

        //string TakeActionOnLeave(int applicationId, int userId, string status);

        #endregion

        #region Admin

        ResponseBO<string> AddOrUpdateEmployeeClientSideManagerAndProjectMapping(EmployeeProjectMappingBO data);

        ResponseBO<string> AddOrUpdateUserShiftMapping(UserShiftMappingFilterBO data);
        #endregion
    }
}
