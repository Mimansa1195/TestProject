using MIS.BO;
using MIS.Services.Contracts;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace MIS.API.Controllers
{
    public class eInvoiceController : BaseExtApiController
    {
        private readonly IEInvoiceServices _eInvoiceServices;

        public eInvoiceController(IEInvoiceServices eInvoiceServices)
        {
            _eInvoiceServices = eInvoiceServices;
        }

        //public static bool AddToListener = true;
        //public static TextWriterTraceListener TextListener = new TextWriterTraceListener(new System.IO.FileStream("C:/Logs/eInvoiceAPI.log", System.IO.FileMode.Create));

        [HttpGet]
        public ConsolidatedMisData GetConsolidatedMisData(string startDate, string endDate)
        {
            if (string.IsNullOrEmpty(startDate) || string.IsNullOrEmpty(endDate))
                return new ConsolidatedMisData { Status = "startDate or endDate is mandatory ." };
            try
            {
                //if (AddToListener)
                //{
                //    Trace.Listeners.Add(TextListener);
                //    AddToListener = false;
                //}

                var fromDate = DateTime.ParseExact(startDate, "yyyy-MM-dd", CultureInfo.InvariantCulture);
                var tillDate = DateTime.ParseExact(endDate, "yyyy-MM-dd", CultureInfo.InvariantCulture);

                var client = _eInvoiceServices.GetAllClients();
                var clientResource = _eInvoiceServices.GetAllClientResource();
                var clientSideReportTo = _eInvoiceServices.GetAllClientSideManager();
                var employeeMaster = _eInvoiceServices.GetAllEmployees();
                var geminiUserMaster = _eInvoiceServices.GetAllGeminiUser();
                var project = _eInvoiceServices.GetAllProjects();
                var shift = _eInvoiceServices.GetAllShifts();
                var calenderMaster = _eInvoiceServices.GetCalender(fromDate, tillDate);
                var employeeAndShiftMapping = _eInvoiceServices.GetEmployeeShiftMapping(fromDate, tillDate);
                var employeeTotalLoggedHours = _eInvoiceServices.GetEmployeeTotalLoggedHours(fromDate, tillDate);
                var employeeLeaveDates = _eInvoiceServices.GetEmployeeLeaves(fromDate, tillDate);
                var listHoliday = _eInvoiceServices.GetAllHolidays(fromDate, tillDate);
                var projectMapping = _eInvoiceServices.GetProjectMapping();

                var data = new ConsolidatedMisData
                {
                    Status = "Success",
                    Client = client,
                    ClientResource = clientResource,
                    ClientSideReportTo = clientSideReportTo,
                    EmployeeMaster = employeeMaster,
                    ListGeminiUsers = geminiUserMaster,
                    Project = project,
                    Shift = shift,
                    CalenderMaster = calenderMaster,
                    ListHoliday = listHoliday ?? new List<ListHoliday>(),
                    ListMappedProjects = projectMapping ?? new List<ProjectMappingJsonList>(),
                    EmployeeAndShiftMapping = employeeAndShiftMapping ?? new List<EmployeeAndShiftMapping>(),
                    EmployeeLeaveDates = employeeLeaveDates ?? new List<EmployeeLeaveDates>(),
                    EmployeeTotalLoggedHours = employeeTotalLoggedHours ?? new List<EmployeeTotalLoggedHours>()
                };

                var result = data;
                return result;
            }
            catch (Exception e)
            {
                Trace.TraceError(DateTime.Now + " Exception " + e.InnerException.ToString());
                Trace.Flush();
                return new ConsolidatedMisData { Status = "Error - " + e.Message + ", Inner Exception- " + e.InnerException + ", Stack Trace- " + e.StackTrace };
            }
        }

        [HttpPost]
        public HttpResponseMessage UpdateEmployeeProjectMapping(EmployeeProjectMappingBO data)
        {
            try
            {
                var result = _eInvoiceServices.AddOrUpdateEmployeeClientSideManagerAndProjectMapping(data);
                return Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                Trace.TraceError(DateTime.Now + " Exception " + ex.InnerException.ToString());
                Trace.Flush();
                return Request.CreateResponse(HttpStatusCode.BadRequest, ex.Message);
            }
        }

        [HttpPost]
        public HttpResponseMessage AddOrUpdateUserShiftMapping(UserShiftMappingFilterBO data)
        {
            if (string.IsNullOrEmpty(data.StartDate.ToString()) || string.IsNullOrEmpty(data.EndDate.ToString()))
                return Request.CreateResponse(HttpStatusCode.BadRequest, "Invalid Token or parameters");
            try
            {

                var result = _eInvoiceServices.AddOrUpdateUserShiftMapping(data);
                return Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                Trace.TraceError(DateTime.Now + " Exception " + ex.InnerException.ToString());
                Trace.Flush();
                return Request.CreateResponse(HttpStatusCode.BadRequest, ex.Message);
            }
        }

        [HttpGet]
        public HttpResponseMessage GetEmployeeShiftMapping(string startDate, string endDate, string token)
        {
            if (string.IsNullOrEmpty(startDate) || string.IsNullOrEmpty(endDate))
                return Request.CreateResponse(HttpStatusCode.BadRequest, "Invalid Token or parameters");
            try
            {
                var fromDate = DateTime.ParseExact(startDate, "yyyy-MM-dd", CultureInfo.InvariantCulture);
                var tillDate = DateTime.ParseExact(endDate, "yyyy-MM-dd", CultureInfo.InvariantCulture);

                var result = _eInvoiceServices.GetEmployeeShiftMapping(fromDate, tillDate);
                return Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                Trace.TraceError(DateTime.Now + " Exception " + ex.InnerException.ToString());
                Trace.Flush();
                return Request.CreateResponse(HttpStatusCode.BadRequest, ex.Message);
            }
        }

        //[HttpGet]
        //public string TakeActionOnLeave(string encodedData)
        //{        
        //    try
        //    {
        //        var decodedData = CryptoHelper.Decrypt(encodedData).Split('-'); //SecurityHelper.SecurityHelper.Decode(encodedData).Split('-');
        //        var result = _eInvoiceServices.TakeActionOnLeave(int.Parse(decodedData[0]), int.Parse(decodedData[1]), decodedData[2]);
        //        return result;
        //    }
        //    catch (Exception e)
        //    {
        //        return "Exception Occured";
        //    }
        //}
    }
}