using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Diagnostics;
using System.Configuration;
using MIS.Services.Contracts;
using MIS.BO;
using MIS.Model;
using MIS.Utilities.Helpers;
using System.Globalization;
using System.Xml.Linq;
using System.Data.Entity.Core.Objects;
using System.Net;
using MIS.Utilities;

namespace MIS.Services.Implementations
{
    public class EInvoiceServices : IEInvoiceServices
    {
        #region public

        public List<InvoiceClient> GetAllClients()
        {
            try
            {
                Trace.WriteLine(DateTime.Now + " |Information| Fetching All Clients Started...");
                MISEntities context = new MISEntities();
                var result = context.spGetAllClients().ToList();
                var clientList = result.Select(client => new InvoiceClient
                {
                    ClientId = client.ClientId,
                    ClientName = client.ClientName,
                    ClientAddress = client.Address,
                    City = client.City,
                    Country = client.Country,
                    IsActive = client.IsActive,
                    IsDeleted = client.IsDeleted
                }).ToList();
                Trace.WriteLine(DateTime.Now + " |Information| Records Returned - " + clientList.Count);
                Trace.WriteLine(DateTime.Now + " |Information| Fetching Records..." + Environment.NewLine + EInvoiceHelper.PrintElementsOfList(clientList));
                Trace.Flush();
                return clientList;
            }
            catch (Exception e)
            {
                Trace.TraceError(DateTime.Now + " Exception " + e.InnerException.ToString());
                Trace.Flush();
                return null;
            }
        }

        public List<ClientResource> GetAllClientResource()
        {
            try
            {
                Trace.WriteLine(DateTime.Now + " |Information| Fetching All Client Resources Started...");

                MISEntities context = new MISEntities();
                var result = context.spGetAllClientResource().ToList();
                var clientResourceList = result.Select(clientResource => new ClientResource
                {
                    ClientResourceId = clientResource.ClientResourceId,
                    ResourceName = clientResource.ResourceName,
                    FriendlyName = clientResource.FriendlyName,
                    ClientId = clientResource.ClientId,
                    ClientProjectName = clientResource.ClientProjectName,
                    ClientProjectCode = clientResource.ClientProjectCode,
                    ClientProjectDescription = clientResource.ClientProjectDescription,
                    IsActive = clientResource.IsActive,
                    IsDeleted = clientResource.IsDeleted
                }).ToList();
                Trace.WriteLine(DateTime.Now + " |Information| Records Returned - " + clientResourceList.Count);
                Trace.WriteLine(DateTime.Now + " |Information| Fetching Records..." + Environment.NewLine + EInvoiceHelper.PrintElementsOfList(clientResourceList));
                Trace.Flush();
                return clientResourceList;
            }
            catch (Exception e)
            {
                Trace.TraceError(DateTime.Now + " Exception " + e.InnerException.ToString());
                Trace.Flush();
                return null;
            }
        }

        public List<ClientSideManager> GetAllClientSideManager()
        {
            try
            {
                Trace.WriteLine(DateTime.Now + " |Information| Fetching All Client Side Mangers Started...");
                MISEntities context = new MISEntities();
                var result = context.spGetAllClientSideManager().ToList();
                var managerList = result.Select(x => new BO.ClientSideManager
                {
                    ClientSideManagerId = x.ClientSideManagerId,
                    ClientId = x.ClientId,
                    ManagerName = x.ManagerName,
                    IsActive = x.IsActive,
                    IsDeleted = x.IsDeleted
                }).ToList();
                Trace.WriteLine(DateTime.Now + " |Information| Records Returned - " + managerList.Count);
                Trace.WriteLine(DateTime.Now + " |Information| Fetching Records..." + Environment.NewLine + EInvoiceHelper.PrintElementsOfList(managerList));
                Trace.Flush();
                return managerList;
            }
            catch (Exception)
            {

                throw;
            }
        }

        public List<EmployeeMaster> GetAllEmployees()
        {
            try
            {
                Trace.WriteLine(DateTime.Now + " |Information| Fetching All Employees Started...");

                MISEntities db = new MISEntities();
                var result = db.spGetAllEmployees().ToList();
                List<EmployeeMaster> employeeList = new List<EmployeeMaster>();
                foreach (var employee in result)
                {
                    EmployeeMaster employeeObject = new EmployeeMaster();

                    employeeObject.EmployeeId = employee.EmployeeId;
                    employeeObject.MappingId = employee.MappingId;
                    employeeObject.EmployeeName = employee.EmployeeName;
                    employeeObject.EmailId = CryptoHelper.Decrypt(employee.EmailId);
                    employeeObject.ClientSideManagerId = employee.ClientSideManagerId;
                    employeeObject.ProjectId = employee.ProjectId;
                    employeeObject.IsBilled = employee.IsBilled;
                    employeeObject.IsActive = employee.IsActive;
                    employeeObject.IsDeleted = employee.IsDeleted;
                    employeeObject.PimcoEmployeeId = employee.PimcoEmployeeId;
                    employeeList.Add(employeeObject);
                }

                Trace.WriteLine(DateTime.Now + " |Information| Records Returned - " + Environment.NewLine + employeeList.Count);
                Trace.WriteLine(DateTime.Now + " |Information| Fetching Records..." + Environment.NewLine + EInvoiceHelper.PrintElementsOfList(employeeList));

                Trace.Flush();
                return employeeList;
            }
            catch (Exception e)
            {
                Trace.TraceError(DateTime.Now + " Exception " + e.InnerException.ToString());
                Trace.Flush();
                return null;
            }
        }

        public List<EmployeesBO> GetAllGeminiUser()
        {
            try
            {
                Trace.WriteLine(DateTime.Now + " |Information| Fetching All Gemini Users Started...");

                MISEntities db = new MISEntities();
                var result = db.vwAllUsers.ToList();
                var employeeList = result.Select(t=> new EmployeesBO() {
                    UserId = t.UserId,
                    EmployeeName = t.EmployeeName,
                    EmployeeCode = t.EmployeeCode,
                    EmailId = CryptoHelper.Decrypt(t.EmailId)
                }).ToList();
             

                Trace.WriteLine(DateTime.Now + " |Information| Records Returned - " + Environment.NewLine + employeeList.Count);
                Trace.WriteLine(DateTime.Now + " |Information| Fetching Records..." + Environment.NewLine + EInvoiceHelper.PrintElementsOfList(employeeList));

                Trace.Flush();
                return employeeList;
            }
            catch (Exception e)
            {
                Trace.TraceError(DateTime.Now + " Exception " + e.InnerException.ToString());
                Trace.Flush();
                return null;
            }
        }


        public List<InvoiceProject> GetAllProjects()
        {
            try
            {
                Trace.WriteLine(DateTime.Now + " |Information| Fetching Project Information Started...");

                MISEntities db = new MISEntities();
                var result = db.spGetAllProjects().ToList();
                List<BO.InvoiceProject> projectList = new List<BO.InvoiceProject>();
                foreach (var project in result)
                {
                    BO.InvoiceProject projectObject = new BO.InvoiceProject();

                    projectObject.ProjectId = project.ProjectId;
                    projectObject.ProjectName = project.ProjectName;
                    projectObject.FriendlyName = project.FriendlyName;
                    projectObject.ProjectCode = project.ProjectCode;
                    projectObject.Description = project.Description;
                    projectObject.ClientResourceId = project.ClientResourceId;
                    projectObject.IsActive = project.IsActive;
                    projectObject.IsDeleted = project.IsDeleted;

                    projectList.Add(projectObject);
                }
                Trace.WriteLine(DateTime.Now + " |Information| Records Returned - " + projectList.Count);
                Trace.WriteLine(DateTime.Now + " |Information| Fetching Records..." + Environment.NewLine + EInvoiceHelper.PrintElementsOfList(projectList));
                Trace.Flush();
                return projectList;
            }
            catch (Exception e)
            {
                Trace.TraceError(DateTime.Now + " Exception " + e.InnerException.ToString());
                Trace.Flush();
                return null;
            }
        }

        public List<Shift> GetAllShifts()
        {
            try
            {
                Trace.WriteLine(DateTime.Now + " |Information| Fetching Shift Information Started...");

                var db = new MISEntities();

                var result = db.spGetAllShifts().ToList();
                var shiftList = result.Select(shift => new Shift
                {
                    ShiftId = shift.ShiftId,
                    ShiftName = shift.ShiftName,
                    InTime = shift.InTime.Split('.')[0],
                    OutTime = shift.OutTime.Split('.')[0],
                    WorkingHours = shift.WorkingHours.Split('.')[0],
                    IsWeekEnd = shift.IsWeekEnd,
                    IsNight = shift.IsNight,
                    IsActive = shift.IsActive,
                    IsDeleted = shift.IsDeleted
                }).ToList();

                Trace.WriteLine(DateTime.Now + " |Information| Records Returned - " + shiftList.Count);
                Trace.WriteLine(DateTime.Now + " |Information| Fetching Records..." + Environment.NewLine + EInvoiceHelper.PrintElementsOfList(shiftList));
                Trace.Flush();
                return shiftList;
            }
            catch (Exception e)
            {
                Trace.TraceError(DateTime.Now + " Exception " + e.InnerException.ToString());
                Trace.Flush();
                return null;
            }
        }

        public List<CalenderMaster> GetCalender(DateTime startDate, DateTime endDate)
        {
            try
            {
                Trace.WriteLine(DateTime.Now + " |Information| Fetching Calender Information Started...");
                MISEntities db = new MISEntities();

                var result = db.spGetCalender(startDate, endDate).ToList();
                if (result.Any())
                {
                    List<CalenderMaster> calenderList = new List<CalenderMaster>();

                    foreach (var calender in result)
                    {
                        CalenderMaster calenderObject = new CalenderMaster();

                        calenderObject.DateId = calender.DateId;
                        calenderObject.Date = calender.Date;
                        calenderObject.Day = calender.Day;
                        calenderObject.IsHoliday = calender.IsHoliday;
                        calenderObject.IsWeekend = calender.IsWeekend;

                        calenderList.Add(calenderObject);
                    }
                    Trace.WriteLine(DateTime.Now + " |Information| Records Returned - " + calenderList.Count);
                    Trace.WriteLine(DateTime.Now + " |Information| Fetching Records..." + Environment.NewLine + EInvoiceHelper.PrintElementsOfList(calenderList));
                    Trace.Flush();
                    return calenderList;
                }
                else
                {
                    Trace.WriteLine(DateTime.Now + " |Information| No Records Returned");
                    Trace.Flush();
                    return null;
                }

            }
            catch (Exception e)
            {
                Trace.TraceError(DateTime.Now + " Exception " + e.InnerException.ToString());
                Trace.Flush();
                return null;
            }
        }

        public List<EmployeeAndShiftMapping> GetEmployeeShiftMapping(DateTime startDate, DateTime endDate)
        {
            try
            {
                Trace.WriteLine(DateTime.Now + " |Information| Fetching Employee Shift Mapping Information Started...");

                MISEntities db = new MISEntities();

                var result = db.spGetEmployeeShiftMapping(startDate, endDate).ToList();

                if (result.Any())
                {
                    var employeeShiftMappingList = new List<EmployeeAndShiftMapping>();

                    foreach (var employeeShiftMapping in result)
                    {
                        EmployeeAndShiftMapping employeeShiftMappingObject = new EmployeeAndShiftMapping();

                        employeeShiftMappingObject.MappingId = employeeShiftMapping.MappingId;
                        employeeShiftMappingObject.DateId = employeeShiftMapping.DateId;
                        employeeShiftMappingObject.UserId = employeeShiftMapping.UserId;
                        employeeShiftMappingObject.ShiftId = employeeShiftMapping.ShiftId;
                        employeeShiftMappingObject.IsActive = employeeShiftMapping.IsActive;
                        employeeShiftMappingObject.IsDeleted = employeeShiftMapping.IsDeleted;

                        employeeShiftMappingList.Add(employeeShiftMappingObject);
                    }
                    Trace.WriteLine(DateTime.Now + " |Information| Records Returned - " + employeeShiftMappingList.Count);
                    Trace.WriteLine(DateTime.Now + " |Information| Fetching Records..." + Environment.NewLine + EInvoiceHelper.PrintElementsOfList(employeeShiftMappingList));
                    Trace.Flush();
                    return employeeShiftMappingList;
                }
                else
                {
                    Trace.WriteLine(DateTime.Now + " |Information| No Records Returned");
                    Trace.Flush();
                    return null;
                }

            }
            catch (Exception e)
            {
                Trace.TraceError(DateTime.Now + " Exception " + e.InnerException.ToString());
                Trace.Flush();
                return null;
            }
        }

        public List<EmployeeTotalLoggedHours> GetEmployeeTotalLoggedHours(DateTime startDate, DateTime endDate)
        {
            try
            {
                Trace.WriteLine(DateTime.Now + " |Information| Fetching Employee Total Logged Hours Started...");

                MISEntities db = new MISEntities();

                var result = db.spGetEmployeeTotalLoggedHours(startDate, endDate).ToList();
                if (result.Any())
                {
                    List<EmployeeTotalLoggedHours> employeeTotalLoggedHoursList = new List<EmployeeTotalLoggedHours>();

                    foreach (var employee in result)
                    {
                        EmployeeTotalLoggedHours employeeObject = new EmployeeTotalLoggedHours();

                        employeeObject.EmployeeId = employee.UserId;
                        employeeObject.TotalLoggedHours = employee.TotalLoggedHours;
                        employeeObject.TotalLoginHours = employee.LoginHour;

                        employeeTotalLoggedHoursList.Add(employeeObject);
                    }
                    Trace.WriteLine(DateTime.Now + " |Information| Records Returned - " + employeeTotalLoggedHoursList.Count);
                    Trace.WriteLine(DateTime.Now + " |Information| Fetching Records..." + Environment.NewLine + EInvoiceHelper.PrintElementsOfList(employeeTotalLoggedHoursList));
                    Trace.Flush();
                    return employeeTotalLoggedHoursList;
                }
                else
                {
                    Trace.WriteLine(DateTime.Now + " |Information| No Records Returned");
                    Trace.Flush();
                    return null;
                }
            }
            catch (Exception e)
            {
                Trace.TraceError(DateTime.Now + " Exception " + e.InnerException.ToString());
                Trace.Flush();
                return null;
            }
        }

        public List<EmployeeLeaveDates> GetEmployeeLeaves(DateTime startDate, DateTime endDate)
        {
            try
            {
                Trace.WriteLine(DateTime.Now + " |Information| Fetching Employee Leaves Started...");

                MISEntities db = new MISEntities();

                var result = db.spGetEmployeeLeaves(startDate, endDate).ToList();

                if (result.Any())
                {
                    List<EmployeeLeaveDates> empLeaves = new List<EmployeeLeaveDates>();

                    foreach (var r in result)
                    {
                        if (!empLeaves.Exists(x => x.UserId == r.UserId))
                        {
                            EmployeeLeaveDates eLeaveDate = new EmployeeLeaveDates();
                            eLeaveDate.UserId = r.UserId;
                            List<DateTime> dt = new List<DateTime>();
                            foreach (var res in result)
                            {
                                if (res.UserId == r.UserId)
                                {
                                    dt.Add(res.Date);
                                }
                            }
                            eLeaveDate.Date = dt;
                            empLeaves.Add(eLeaveDate);
                        }
                    }
                    Trace.WriteLine(DateTime.Now + " |Information| Records Returned - " + empLeaves.Count);
                    Trace.WriteLine(DateTime.Now + " |Information| Fetching Records..." + Environment.NewLine + EInvoiceHelper.PrintElementsOfList(empLeaves));
                    Trace.Flush();
                    return empLeaves;
                }
                else
                {
                    Trace.WriteLine(DateTime.Now + " |Information| No Records Returned");
                    Trace.Flush();
                    return null;
                }

            }
            catch (Exception e)
            {
                Trace.TraceError(DateTime.Now + " Exception " + e.InnerException.ToString());
                Trace.Flush();
                return null;
            }
        }

        public List<ListHoliday> GetAllHolidays(DateTime startDate, DateTime endDate)
        {
            try
            {
                Trace.WriteLine(DateTime.Now + " |Information| Fetching Holidays Started...");

                MISEntities db = new MISEntities();

                var result = db.spGetAllHolidays(startDate, endDate).ToList();

                if (result.Any())
                {
                    List<ListHoliday> holidayList = new List<ListHoliday>();

                    foreach (var holiday in result)
                    {
                        ListHoliday holidayObject = new ListHoliday();

                        holidayObject.HolidayId = holiday.HolidayId;
                        holidayObject.DateId = holiday.DateId;
                        holidayObject.Occasion = holiday.Holiday;

                        holidayList.Add(holidayObject);
                    }
                    Trace.WriteLine(DateTime.Now + " |Information| Records Returned - " + holidayList.Count);
                    Trace.WriteLine(DateTime.Now + " |Information| Fetching Records..." + Environment.NewLine + EInvoiceHelper.PrintElementsOfList(holidayList));
                    Trace.Flush();
                    return holidayList;
                }
                else
                {
                    Trace.WriteLine(DateTime.Now + " |Information| No Records Returned");
                    Trace.Flush();
                    return null;
                }
            }
            catch (Exception e)
            {
                Trace.TraceError(DateTime.Now + " Exception " + e.InnerException.ToString());
                Trace.Flush();
                return null;
            }
        }

        public List<ProjectMappingJsonList> GetProjectMapping()
        {
            try
            {
                Trace.WriteLine(DateTime.Now + " |Information| Fetching project mapping Started...");
                MISEntities db = new MISEntities();
                var result = db.UserClientSideManagerAndProjectMappings.Where(P=>P.IsActive == true);
                if (result.Any())
                {
                    var projectList = result.Select(t=>new ProjectMappingJsonList{
                        MappingId = t.MappingId,
                        ClientSideManagerId = t.ClientSideManagerId,
                        ProjectId = t.ProjectId,
                        EmployeeId = db.UserDetails.FirstOrDefault(d=>d.UserId == t.UserId).EmployeeId,
                        IsActive = t.IsActive,
                        IsBilled = t.IsBilled
                    }).ToList();
                 
                    Trace.WriteLine(DateTime.Now + " |Information| Records Returned - " + projectList.Count);
                    Trace.WriteLine(DateTime.Now + " |Information| Fetching Records..." + Environment.NewLine + EInvoiceHelper.PrintElementsOfList(projectList));
                    Trace.Flush();
                    return projectList;
                }
                else
                {
                    Trace.WriteLine(DateTime.Now + " |Information| No Records Returned");
                    Trace.Flush();
                    return null;
                }
            }
            catch (Exception e)
            {
                Trace.TraceError(DateTime.Now + " Exception " + e.InnerException.ToString());
                Trace.Flush();
                return null;
            }
        }


        //public string TakeActionOnLeave(int applicationId, int userId, string status)
        //{
        //    try
        //    {
        //        MISEntities db = new MISEntities();

        //        var result = db.spTakeActionOnAppliedLeave(applicationId, status, "", userId, 0).FirstOrDefault();
        //        if (result.Equals("SUCCEED"))
        //            return "Operation Successfull";
        //        else if (result.Equals("DUPLICATE"))
        //            return "You have already taken action on this request";
        //        else
        //            return
        //                "Operation Unsuccessfull";
        //    }
        //    catch (Exception e)
        //    {
        //        return "Exception Occured";
        //    }
        //}

        #endregion

        #region admin

        public ResponseBO<string> AddOrUpdateEmployeeClientSideManagerAndProjectMapping(EmployeeProjectMappingBO data)
        {
            var response = new ResponseBO<string>()
            {
                IsSuccessful = false,
                Status = ResponseStatus.Error,
                StatusCode = HttpStatusCode.InternalServerError,
                Message = ResponseMessage.Error
            };

            try
            {
                var xmlData = new XElement("EmployeeProjectMapping",
                 from pxs in data.JsonDataList
                 select new XElement("Mapping",
                        new XAttribute("MappingId", pxs.MappingId),
                        new XAttribute("ClientSideManagerId", pxs.ClientSideManagerId),
                        new XAttribute("ProjectId", pxs.ProjectId),
                        new XAttribute("EmployeeId", pxs.EmployeeId),
                        new XAttribute("IsBilled", pxs.IsBilled),
                        new XAttribute("IsActive", pxs.IsActive)
                        ));

                using (var db = new MISEntities())
                {

                    var status = 0;
                    var success = new ObjectParameter("Success", typeof(int));
                    var message = new ObjectParameter("Message", typeof(string));
                    var newData = xmlData.ToString();
                    var res = db.spManageEmployeeClientSideProjectAndManagerMapping(newData, success, message);
                    Int32.TryParse(success.Value.ToString(), out status);
                    var resMsg = message.Value.ToString();
                    if (status == 1)
                    {
                        response.IsSuccessful = true;
                        response.Status = ResponseStatus.Success;
                        response.StatusCode = HttpStatusCode.OK;
                        response.Message = message.Value.ToString();
                    }
                    else
                    {
                        response.Message = message.Value.ToString();
                    }

                    Trace.WriteLine(DateTime.Now + " |Information| Result : " + resMsg + "..."); //res.Result

                }
            }
            catch(Exception ex)
            {
                GlobalServices.LogError(ex);
                response.Message = ex.Message;
            }
            return response;
        }

        public ResponseBO<string> AddOrUpdateUserShiftMapping(UserShiftMappingFilterBO data)
        {
            var response = new ResponseBO<string>() { IsSuccessful = false, Status = ResponseStatus.Error, 
                StatusCode = HttpStatusCode.InternalServerError, Message = ResponseMessage.Error };

            try
            {
                var fromDate = DateTime.ParseExact(data.StartDate, "yyyy-MM-dd", CultureInfo.InvariantCulture);
                var tillDate = DateTime.ParseExact(data.EndDate, "yyyy-MM-dd", CultureInfo.InvariantCulture);
                var xmlData = new XElement("ShiftMapping",
                 from pxs in data.JsonDataList
                 select new XElement("ShiftRecord",
                        new XAttribute("UserId", pxs.UserId),
                         new XAttribute("Shift", pxs.Shift)
                         ));

                using (var db = new MISEntities())
                {
                    
                    var status = 0;
                    var success = new ObjectParameter("Success", typeof(int));
                    var message = new ObjectParameter("Message", typeof(string));
                    var res = db.spImportUserShiftMapping(fromDate, tillDate, xmlData.ToString(), 0, success,message).ToList();
                    Int32.TryParse(success.Value.ToString(), out status);
                  
                    if (status == 1)
                    {
                        response.IsSuccessful = true;
                        response.Status = ResponseStatus.Success;
                        response.StatusCode = HttpStatusCode.OK;
                        response.Message = message.Value.ToString();
                    }
                    else
                    {
                        response.Message = message.Value.ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                GlobalServices.LogError(ex);
                response.Message = ex.Message;
            }

            return response;
        }

        #endregion
    }
}
