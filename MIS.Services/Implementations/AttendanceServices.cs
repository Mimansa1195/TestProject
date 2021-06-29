using MIS.BO;
using MIS.Model;
using MIS.Services.Contracts;
using MIS.Utilities;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Xml.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MIS.Services.Implementations
{
    public class AttendanceServices : IAttendanceServices
    {
        private readonly MISEntities _context = new MISEntities();
        #region Attendance Register

        /// <summary>
        /// Get Supporting Staff Members
        /// </summary>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<EmployeeInfo> GetSupportingStaffMembers(string userAbrhs)
        {
            try
            {
                using (var context = new MISEntities())
                {
                    var lList = new List<EmployeeInfo>();
                    var result = context.vwActiveStaffMembers.ToList();
                    if (result.Any())
                    {
                        foreach (var r in result)
                        {
                            lList.Add(new EmployeeInfo
                            {
                                EmployeeAbrhs = CryptoHelper.Encrypt(r.RecordId.ToString()),
                                EmployeeName = r.EmployeeName,
                            });
                        }
                        return (lList.OrderBy(o => o.EmployeeName).ToList());
                    }
                    return new List<EmployeeInfo>();
                }
            }
            catch (Exception)
            {
                return new List<EmployeeInfo>();
            }
        }

        /// <summary>
        /// Get Attendance Register For Supporting Staff Members
        /// </summary>
        /// <param name="fromDate"></param>
        /// <param name="tillDate"></param>
        /// <param name="forEmployeeId"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<AttendanceData> GetAttendanceRegisterForSupportingStaffMembers(string fromDate, string tillDate, string EmpAbrhs, string userAbrhs)
        {
            try
            {
                var attendanceData = new List<AttendanceData>();
                using (var context = new MISEntities())
                {
                    var forEmployeeId = 0;
                    if (EmpAbrhs != "0")
                    {
                        Int32.TryParse(CryptoHelper.Decrypt(EmpAbrhs), out forEmployeeId);
                    }
                    var startDate = DateTime.ParseExact(fromDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
                    var endDate = DateTime.ParseExact(tillDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
                    var data =
                        context.spGetAttendanceRegisterForSupportingStaffMembers(startDate,
                            endDate, forEmployeeId).ToList();
                    if (data.Any())
                    {
                        foreach (var temp in data)
                        {
                            AttendanceData t = new AttendanceData
                            {
                                Date = temp.Date,
                                EmployeeName = temp.EmployeeName,
                                EmployeeAbrhs = CryptoHelper.Encrypt(temp.StaffUserId.ToString()),
                                InTime = temp.InTime == null ? "NA" : temp.InTime,
                                OutTime = temp.OutTime == null ? "NA" : temp.OutTime,
                                LoggedInHours = temp.LoggedInHours == null ? "NA" : temp.LoggedInHours,
                                IsNightSift = temp.IsNightShift.HasValue ? temp.IsNightShift.Value : false
                            };
                            attendanceData.Add(t);
                        }
                        return attendanceData;
                    }
                    return new List<AttendanceData>();
                }
            }
            catch (Exception)
            {
                return new List<AttendanceData>();
            }
        }

        #endregion


        #region Employee Attendance

        /// <summary>
        /// Get Department On Report To Basis
        /// </summary>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<BO.LockedUserDetail> GetDepartmentOnReportToBasis(string userAbrhs, string menuAbrhs)
        {
            List<BO.LockedUserDetail> data = new List<BO.LockedUserDetail>();
            using (var context = new MISEntities())
            {
                List<int> UserIdsList = new List<int>();
                var userId = 0;
                var menuId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                if (menuAbrhs != null)
                {
                    Int32.TryParse(CryptoHelper.Decrypt(menuAbrhs), out menuId);
                }
                UserIdsList.Add(userId);
                //check and take User Ids.
                var UserIdList = context.MenusUserDelegations.Where(x => x.MenuId == menuId && x.DelegatedToUserId == userId && x.IsActive
                    && System.Data.Entity.DbFunctions.TruncateTime(DateTime.Now) >= System.Data.Entity.DbFunctions.TruncateTime(x.DelegatedFromDate)
                    && System.Data.Entity.DbFunctions.TruncateTime(DateTime.Now) <= System.Data.Entity.DbFunctions.TruncateTime(x.DelegatedTillDate)
                    ).Select(x => new { UserId = x.DelegatedFromUserId }).GroupBy(x => new { x.UserId }).ToList();
                if (UserIdList.Any())
                {
                    UserIdsList.AddRange(UserIdList.Select(x => x.Key.UserId));
                }

                foreach (var item in UserIdsList)
                {
                    var departments = context.spGetDepartmentForAttendanceRegisterByUserId(item, true).ToList();
                    if (departments.Any())
                    {
                        foreach (var temp in departments)
                        {
                            BO.LockedUserDetail t = new BO.LockedUserDetail()
                            {
                                EmployeeAbrhs = CryptoHelper.Encrypt(temp.DepartmentId.ToString()),
                                UserId = temp.DepartmentId,
                                UserName = temp.DepartmentName,
                            };
                            data.Add(t);
                        }

                    }
                }
                return data.OrderBy(f => f.UserName).ToList();
            }
        }

        /// <summary>
        /// Get Employee For Attendance On Report To Basis
        /// </summary>
        /// <param name="date"></param>
        /// <param name="departmentId"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<BO.LockedUserDetail> GetEmployeeForAttendanceOnReportToBasis(string date, int departmentId, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            List<BO.LockedUserDetail> data = new List<BO.LockedUserDetail>();
            using (var context = new MISEntities())
            {
                DateTime Date = DateTime.ParseExact(date, "MM/dd/yyyy", CultureInfo.InvariantCulture);
                var employees = context.spGetUsersForAttendanceRegisterByUserIdAndDepartmentId(userId, Date, departmentId).ToList();
                if (employees.Any())
                {
                    foreach (var temp in employees)
                    {
                        BO.LockedUserDetail t = new BO.LockedUserDetail()
                        {
                            UserId = temp.EmployeeId,
                            UserName = temp.EmployeeName
                        };
                        data.Add(t);
                    }
                    return data.OrderBy(f => f.UserName).ToList();
                }
                else
                    return new List<BO.LockedUserDetail>();
            }
        }

        /// <summary>
        /// Process Employee Attendance
        /// </summary>
        /// <param name="fromDate"></param>
        /// <param name="tillDate"></param>
        /// <param name="departmentId"></param>
        /// <param name="forEmployeeId"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<AttendanceData> ProcessEmployeeAttendance(string fromDate, string tillDate, int departmentId, int forEmployeeId, string userAbrhs)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            var attendanceData = new List<AttendanceData>();
            using (var context = new MISEntities())
            {
                var startDate = DateTime.ParseExact(fromDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
                var endDate = DateTime.ParseExact(tillDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
                var data =
                    context.spGeAttendanceRegisterByDepartmentIdOrEmployeeIdForEmployeesReportingToUser(startDate,
                        endDate, departmentId, forEmployeeId, userId).ToList();
                if (data.Any())
                {
                    foreach (var temp in data)
                    {
                        AttendanceData t = new AttendanceData
                        {
                            Date = temp.Date,
                            Department = temp.Department,
                            EmployeeName = temp.EmployeeName,
                            InTime = temp.InTime,
                            OutTime = temp.OutTime,
                            LoggedInHours = temp.LoggedInHours
                        };
                        attendanceData.Add(t);
                    }
                    return attendanceData;
                }
                else
                    return new List<AttendanceData>();
            }
        }

        /// <summary>
        /// Get Attendance Summary
        /// </summary>
        /// <param name="fromDate"></param>
        /// <param name="endDate"></param>
        /// <param name="userId"></param>
        /// <param name="reportToId"></param>
        /// <param name="departmentId"></param>
        /// <returns></returns>
        public List<AttendanceSummary> GetAttendanceSummary(DateTime fromDate, DateTime endDate, string empAbrhs, string reportToAbrhs, string departmentIds)
        {
            using (var context = new MISEntities())
            {

                var empIds = string.Join(",", MIS.Utilities.CustomExtensions.SplitUseridsToIntList(empAbrhs).ToList());
                var reportToIds = string.Join(",", MIS.Utilities.CustomExtensions.SplitUseridsToIntList(reportToAbrhs).ToList());
                var locId = "0";
                var lList = new List<AttendanceSummary>();
                var result = context.spGetEmployeeAttendanceSummary(departmentIds, reportToIds, empIds, fromDate, endDate, locId).ToList();
                if (result.Any())
                {
                    foreach (var r in result)
                    {
                        lList.Add(new AttendanceSummary
                        {
                            EmpCode = r.EmployeeId,
                            EmployeeName = r.EmployeeName,
                            ManagerName = r.ReportingManager,
                            Department = r.DepartmentName,
                            PresentDays = r.PresentDays,
                            WFH = r.WFH,
                            CL = r.CL,
                            PL = r.PL,
                            LWP = r.LWP,
                            COFF = r.COFF,
                        });
                    }
                    return lList;
                }
                return new List<AttendanceSummary>();
            }
        }

        public List<AttendanceData> GetAttendanceForEmployees(string fromDate, string tillDate, string empAbrhs, string departmentIds, string locationIds, string userAbrhs)
        {
            if (string.IsNullOrEmpty(fromDate) || string.IsNullOrEmpty(tillDate))
                return new List<AttendanceData>();

            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                var startDate = DateTime.ParseExact(fromDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
                var endDate = DateTime.ParseExact(tillDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
                var empIds = "0";
                if (empAbrhs != "0")
                {
                    empIds = string.Join(",", MIS.Utilities.CustomExtensions.SplitUseridsToIntList(empAbrhs).ToList());
                }
                //var locIds = "0";
                //if (locationIds != "0")
                //{
                //    locIds = string.Join(",", locationIds.ToList());
                //}

                //var reportToIds = string.Join(",", MIS.Utilities.CustomExtensions.SplitUseridsToIntList(reportToAbrhs).ToList());

                return context.spGetEmployeeAttendance(startDate, endDate, 0, empIds, userId, locationIds, false).Select(x => new AttendanceData
                {
                    EmployeeAbrhs = CryptoHelper.Encrypt(x.UserId.ToString()),
                    Date = x.Date,
                    Department = x.Department,
                    EmployeeName = x.EmployeeName,
                    InTime = x.InTime,
                    OutTime = x.OutTime,
                    IsNightSift = x.IsNightShift,
                    IsApproved = x.IsApproved,
                    IsPending = x.IsPending,
                    LoggedInHours = x.LoggedInHours,
                    Location = x.LocationName
                }).ToList();
            }
        }

        /// <summary>
        /// Method to user's punch in/out log
        /// </summary>
        /// <param name="empAbrhs"></param>
        /// <param name="attendanceDate"></param>
        /// <returns></returns>
        public List<UsersPunchInOutLogBO> GetPunchInOutLog(string empAbrhs, string attendanceDate)
        {
            if (string.IsNullOrEmpty(empAbrhs) || string.IsNullOrEmpty(attendanceDate))
                return new List<UsersPunchInOutLogBO>();

            int userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(empAbrhs), out userId);

            attendanceDate = attendanceDate.Substring(0, attendanceDate.IndexOf("(")).Trim();

            var result = _context.Proc_GetPunchInOutLog(userId, attendanceDate).Select(x => new UsersPunchInOutLogBO
            {
                PunchTime = x.PunchTime,
                DoorPoint = x.DoorPoint,
                Day = x.Day,
                CardType = x.CardType,
                CardDetail = x.CardDetails,
                Event = string.IsNullOrEmpty(x.DoorPoint) ? 2 : ((x.DoorPoint.ToUpper().Contains("OUT") ? 0 : 1))
            }).ToList();
            return result;
        }

        public List<UsersPunchInOutLogBO> GetPunchInOutLogForTempCard(string empAbrhs, string accessCardNo, string attendanceDate)
        {
            if (string.IsNullOrEmpty(empAbrhs) || string.IsNullOrEmpty(attendanceDate) || string.IsNullOrEmpty(accessCardNo))
                return new List<UsersPunchInOutLogBO>();

            int userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(empAbrhs), out userId);


            DateTime issueDate = DateTime.ParseExact(attendanceDate, "dd-MMM-yyyy hh:mm tt", CultureInfo.InvariantCulture);
            //var issueDateNew = DateTime.ParseExact(attendanceDate, "yyyy-MM-dd hh:mm tt", CultureInfo.InvariantCulture);

            var result = _context.Proc_GetPunchInOutLogForTempCard(userId, accessCardNo, issueDate).Select(x => new UsersPunchInOutLogBO
            {
                PunchTime = x.PunchTime,
                DoorPoint = x.DoorPoint,
                Day = x.Day,
                Event = string.IsNullOrEmpty(x.DoorPoint) ? 2 : ((x.DoorPoint.ToUpper().Contains("OUT") ? 0 : 1))
            }).ToList();
            return result;
        }

        public List<AccessCardDataBO> GetAllAccessCard(string cardType)
        {
            if (string.IsNullOrEmpty(cardType))
                return new List<AccessCardDataBO>();
            var isTempCard = false;

            if (cardType == "T")
            {
                isTempCard = true;
            }
            var result = _context.AccessCards.Where(t => t.IsActive == true && t.IsTemporary == isTempCard).Select(x => new AccessCardDataBO
            {
                AccessCardId = x.AccessCardId,
                AccessCardNo = x.AccessCardNo,
            }).ToList();
            return result;
        }

        public List<UsersPunchInOutLogBO> GetPunchInOutLogForAllCard(string accessCardNo, string fromDate, string tillDate)
        {
            if (string.IsNullOrEmpty(accessCardNo))
                return new List<UsersPunchInOutLogBO>();

            var fromDateTime = DateTime.ParseExact(fromDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);
            var tillDateTime = DateTime.ParseExact(tillDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);

            //var issueDateNew = DateTime.ParseExact(attendanceDate, "yyyy-MM-dd hh:mm tt", CultureInfo.InvariantCulture);

            var result = _context.Proc_GetPunchInOutLogForAllCard(accessCardNo, fromDateTime, tillDateTime).Select(x => new UsersPunchInOutLogBO
            {
                PunchTime = x.PunchTime,
                DoorPoint = x.DoorPoint,
                Event = string.IsNullOrEmpty(x.DoorPoint) ? 2 : ((x.DoorPoint.ToUpper().Contains("OUT") ? 0 : 1))
            }).ToList();
            return result;
        }

        public List<UsersPunchInOutLogBO> GetPunchInOutLogForStaff(string empAbrhs, string attendanceDate)
        {
            if (string.IsNullOrEmpty(empAbrhs) || string.IsNullOrEmpty(attendanceDate))
                return new List<UsersPunchInOutLogBO>();

            int userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(empAbrhs), out userId);

            attendanceDate = attendanceDate.Substring(0, attendanceDate.IndexOf("(")).Trim();

            var result = _context.Proc_GetPunchInOutLogForStaff(userId, attendanceDate).Select(x => new UsersPunchInOutLogBO
            {
                PunchTime = x.PunchTime,
                DoorPoint = x.DoorPoint,
                Day = x.Day,
                Event = string.IsNullOrEmpty(x.DoorPoint) ? 2 : ((x.DoorPoint.ToUpper().Contains("OUT") ? 0 : 1))
            }).ToList();

            return result;
        }
        #endregion

        #region ASquare Attendance Service

        public AddUpdateReturnBO AddAttendance(List<AttendanceBO> attendanceBOList, int deviceId, string userAbrhs)
        {
            AddUpdateReturnBO returnBO = new AddUpdateReturnBO();
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
            if (attendanceBOList.Any())
            {
                using (var _dbContext = new MISEntities())
                {
                    var AttendancexmlString = new XElement("root",
                       from pxs in attendanceBOList
                       select new XElement("row",
                              new XAttribute("JobId", pxs.JobId),
                               new XAttribute("InTime", pxs.InTime),
                               new XAttribute("OutTime", pxs.OutTime),
                               new XAttribute("AttendanceDate", pxs.AttendanceDate)
                               ));

                    var success = new System.Data.Entity.Core.Objects.ObjectParameter("Success", typeof(Int32));
                    _dbContext.Proc_AddUpdateASquareAttendance(deviceId, AttendancexmlString.ToString(), userId, success);
                    returnBO.Status = success.Value.ToString();
                    //if (returnBO.Status == "1")
                    //{
                    //    AttendanceUploadHistoryAsquare model = new AttendanceUploadHistoryAsquare();
                    //    model.AttendaceDate = Convert.ToDateTime(attendanceBOList[0].AttendanceDate);
                    //    model.CreatedBy = userId;
                    //    model.DeviceId = deviceId;
                    //    model.CreatedDate = DateTime.Now;
                    //    _dbContext.AttendanceUploadHistoryAsquares.Add(model);
                    //    _dbContext.SaveChanges();
                    //}
                }
                return returnBO;
            }
            return returnBO;
        }

        public List<AttendanceUpdateBO> GetAttendanceUpload(DateTime FromDate, DateTime ToDate)
        {
            List<AttendanceUpdateBO> returnBO = new List<AttendanceUpdateBO>();
            using (var _dbContext = new MISEntities())
            {
                var fromDate = FromDate.Date;
                var toDate = ToDate.Date;
                var data = _dbContext.AttendanceUploadHistoryAsquares.Where(x => System.Data.Entity.DbFunctions.TruncateTime(x.AttendaceDate) >= fromDate && System.Data.Entity.DbFunctions.TruncateTime(x.AttendaceDate) <= toDate).ToList();
                if (data.Any())
                {
                    foreach (var item in data)
                    {
                        var user = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == item.CreatedBy);
                        AttendanceUpdateBO attendanceUpdateBO = new AttendanceUpdateBO();
                        attendanceUpdateBO.AttendaceId = item.AttendaceId;
                        attendanceUpdateBO.DeviceId = item.DeviceId;
                        attendanceUpdateBO.AttendaceDate = item.AttendaceDate.ToString("dd-MMM-yyyy");
                        attendanceUpdateBO.CreatedDate = item.CreatedDate.ToString("dd-MMM-yyyy hh:mm tt");
                        attendanceUpdateBO.CreatedBy = user.FirstName + " " + ((user.MiddleName != null && user.MiddleName != "") ? (user.MiddleName + " ") : "") + user.LastName;
                        returnBO.Add(attendanceUpdateBO);
                    }
                }
            }
            return returnBO;
        }

        public List<AttendanceDetailBO> GetDetailAttendance(long AttendaceId)
        {
            List<AttendanceDetailBO> returnBO = new List<AttendanceDetailBO>();
            using (var _dbContext = new MISEntities())
            {
                if (AttendaceId > 0)
                {
                    var attendanceDate = _dbContext.AttendanceUploadHistoryAsquares.FirstOrDefault(x => x.AttendaceId == AttendaceId).AttendaceDate.Date;
                    if (attendanceDate != null)
                    {
                        var dateId = _dbContext.DateMasters.FirstOrDefault(x => System.Data.Entity.DbFunctions.TruncateTime(x.Date) == attendanceDate).DateId;
                        var data = _dbContext.DateWiseAttendanceAsquares.Where(x => x.DateId == dateId).ToList();
                        if (data.Any())
                        {
                            foreach (var item in data)
                            {
                                var user = _dbContext.UserDetails.FirstOrDefault(x => x.UserId == item.UserId);
                                AttendanceDetailBO attendanceDetailBO = new AttendanceDetailBO();
                                attendanceDetailBO.AttendaceDate = item.DateMaster.Date.ToString("dd-MMM-yyyy");
                                attendanceDetailBO.InTime = item.SystemGeneratedInTime.HasValue ? item.SystemGeneratedInTime.Value.ToString("HH:mm tt") : "";
                                attendanceDetailBO.OutTime = item.SystemGeneratedOutTime.HasValue ? item.SystemGeneratedOutTime.Value.ToString("HH:mm tt") : "";
                                attendanceDetailBO.TotalHours = item.SystemGeneratedTotalWorkingHours.HasValue ? item.SystemGeneratedTotalWorkingHours.Value.ToString("HH:mm") : "";
                                attendanceDetailBO.StaffName = user.FirstName + " " + ((user.MiddleName != null && user.MiddleName != "") ? (user.MiddleName + " ") : "") + user.LastName;
                                attendanceDetailBO.CreatedDate = item.CreatedDate.ToString("dd-MMM-yyyy hh:mm tt");
                                //attendanceDetailBO.CreatedBy = item.User.FirstName + " " + ((item.User.MiddleName != null && item.User.MiddleName != "") ? (item.User.MiddleName + " ") : "") + item.User.LastName;
                                returnBO.Add(attendanceDetailBO);
                            }
                        }
                    }
                }

            }
            return returnBO;
        }

        #endregion
    }
}
