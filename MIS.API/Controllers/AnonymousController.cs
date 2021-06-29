using MIS.BO;
using MIS.Services.Contracts;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web;
using System.Web.Http;

namespace MIS.API.Controllers
{
    public class AnonymousController : ApiController
    {
        private readonly IUserServices _userServices;
        private readonly IAssetServices _assetServices;
        private readonly ICommonService _commonServices;
        private readonly IAttendanceServices _attendanceServices;
        private readonly IHRPortalServices _hRPortalServices;
        private readonly IAccountsPortalServices _accountsPortalServices;


        public AnonymousController(IAssetServices assetServices, IUserServices userServices, ICommonService commonServices, IAttendanceServices attendanceServices,IHRPortalServices hRPortalServices, IAccountsPortalServices accountsPortalServices)
        {
            _userServices = userServices;
            _commonServices = commonServices;
            _assetServices = assetServices;
            _attendanceServices = attendanceServices;
            _hRPortalServices = hRPortalServices;
            _accountsPortalServices = accountsPortalServices;
        }

        [HttpGet]
        public HttpResponseMessage ValidateQueryStringForUserRegistration(string tempUserGuid)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.ValidateQueryStringForUserRegistration(tempUserGuid));
        }

        //[HttpGet]
        //public HttpResponseMessage SubmitUserRegistrationData(string userName, string emailId, string tempUserGuid, string firstName, string middleName, string lastName, string dOB, bool gender, string bloodGroup, string mobileNumber, 
        //    string emergencyContactNumber, string personalEmailId, string fatherName, string fatherDOB, string motherName, string motherDOB, bool maritalStatus, string spouseName, string spouseDOB, string spouseOccupation, 
        //    string spouseCompany, string spouseDesignation, bool kids, string child1Name, bool child1Gender, string child1DOB, string child2Name, bool child2Gender, string child2DOB, string insuranceAmount, string presentAddress, 
        //    string permanentAddress, bool isFresher, string lastEmployerName, string lastEmployerLocation, string lastJobDesignation, string lastJobTenure, string jobLeavingReason, string lastJobUAN, string panNo, string aadhaarNo, 
        //    string passportNo, string dLNo, string voterIdNo, string userAbrhs)
        //{
        //        return Request.CreateResponse(HttpStatusCode.OK,null ); //_userServices.SubmitUserRegistrationData()
        //}

        [HttpGet]
        public HttpResponseMessage GetCountries()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonServices.GetCountries());
        }

        [HttpGet]
        public HttpResponseMessage GetStates(int countryId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonServices.GetStates(countryId));
        }

        [HttpGet]
        public HttpResponseMessage GetCities(int stateId)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonServices.GetCities(stateId));
        }

        [HttpGet]
        public HttpResponseMessage GetGender()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonServices.GetGender());
        }

        [HttpGet]
        public HttpResponseMessage GetMaritalStatus()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonServices.GetMaritalStatus());
        }

        [HttpGet]
        public HttpResponseMessage GetOccupation()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonServices.GetOccupation());
        }

        [HttpGet]
        public HttpResponseMessage GetRelationship()
        {
            return Request.CreateResponse(HttpStatusCode.OK, _commonServices.GetRelationship());
        }

        [HttpPost]
        public HttpResponseMessage SaveNewUserRegPersonalInfo(UserPersonalDetailBO userPersonalDetail)
        {
            var guId = "";
            if (!string.IsNullOrEmpty(userPersonalDetail.PhotoFileName))
                guId = Guid.NewGuid().ToString() + userPersonalDetail.PhotoFileName.Substring(userPersonalDetail.PhotoFileName.LastIndexOf('.'));
            var basePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["TempProfileImageUploadPath"]; //+ guId; //userPersonalDetail.PhotoFileName;            
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.SaveNewUserRegPersonalInfo(userPersonalDetail, basePath, guId));
        }
        [HttpPost]
        public HttpResponseMessage SaveNewUserRegAddressInfo(List<UserAddressDetailBO> userAddressDetail)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.SaveNewUserRegAddressInfo(userAddressDetail));
        }
        [HttpPost]
        public HttpResponseMessage SaveNewUserRegCareerInfo(UserPersonalDetailBO userCareerDetail)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.SaveNewUserRegCareerInfo(userCareerDetail));
        }
        [HttpPost]
        public HttpResponseMessage SaveNewUserRegBankInfo(UserPersonalDetailBO userBankDetail)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.SaveNewUserRegBankInfo(userBankDetail));
        }

        [HttpGet]
        public HttpResponseMessage GetExistingUserRegistrationData(string tempUserGuid)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.GetExistingUserRegistrationData(tempUserGuid));
        }

        [HttpPost]
        public HttpResponseMessage CheckIfAllMandatoryFieldsAreSubmitted(string tempUserGuid)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.CheckIfAllMandatoryFieldsAreSubmitted(tempUserGuid));
        }

        [HttpPost]
        public HttpResponseMessage SubmitUserRegistrationData(string tempUserGuid)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.SubmitUserRegistrationData(tempUserGuid));
        }

        [HttpPost]
        public HttpResponseMessage GenerateCodeForResetPassword(string userName, string redirectionLink, string clientIP)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.GenerateCodeForResetPassword(userName, redirectionLink, clientIP));
        }

        [HttpGet]
        public HttpResponseMessage ValidateQueryStringForPasswordReset(string passwordResetCode)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.ValidateQueryStringForPasswordReset(passwordResetCode));
        }

        [HttpGet]
        public HttpResponseMessage ResetPassword(string passwordResetCode, string userName, string password)//1: success, 2: unauthorised, 3: error
        {
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.ResetPassword(passwordResetCode, userName, password));
        }

        #region Excel Upload
        [HttpPost]
        public HttpResponseMessage UploadAllocatedAssets(string userAbrhs, string token)
        {
            try
            {
                var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
                var hfc = HttpContext.Current.Request.Files;
                var dsExcelData = GetExcelDataInDataset(hfc);

                var dtExcelUserData = new DataTable();
                //remove all empty rows from datatable
                dtExcelUserData = dsExcelData.Tables[0].Rows.Cast<DataRow>().Where(row => !row.ItemArray.All(field => field is System.DBNull || string.IsNullOrWhiteSpace(field as string ?? field.ToString()) || string.Compare((field as string ?? field.ToString()).Trim(), string.Empty) == 0)).CopyToDataTable();

                var UserDataList = new List<UserAssetRequest>();
                var bugsList = new List<FileUploadBugsBO>();

                //First Check for discrepencies in excel sheet
                ValidateExcelUserData(dtExcelUserData, UserDataList, bugsList);
                //If excel sheet is wrong, return formatted bugs message
                if (bugsList.Any())
                {
                    var message = GetFormattedMessageInHTMLTable(bugsList);
                    var response = GetHttpResponseMessageAsHTML(message);
                    response.StatusCode = HttpStatusCode.OK;
                    return response;
                }

                // Check for Duplicate Data in excel sheet
                CheckUserDataForDuplicateData(UserDataList, bugsList);
                //If excel sheet has duplicate records, again return with duplicate message
                if (bugsList.Any())
                {
                    var message = GetFormattedMessageInHTMLTable(bugsList);
                    var response = GetHttpResponseMessageAsHTML(message);
                    response.StatusCode = HttpStatusCode.OK;
                    return response;
                }
                else if (UserDataList.Any())
                {
                    var result = 0;
                    result = _assetServices.AllocateExcelData(UserDataList, userAbrhs);
                    if (result == 1)
                    {
                        //If saved successfully, return with success message
                        var response = GetHttpResponseMessageAsHTML("<div style='color:green;font-weight:bold;'>Allocated assets has been been uploaded successfully.</div>");
                        response.StatusCode = HttpStatusCode.OK;
                        return response;
                    }
                    else
                    {
                        //If saved successfully, return with success message
                        var response = GetHttpResponseMessageAsHTML("<div style='color:red;font-weight:bold;'>Allocated assets Exist in DataBase..</div>");
                        response.StatusCode = HttpStatusCode.OK;
                        return response;
                    }
                }
            }
            catch (Exception ex)
            {
                var errorResponse = GetHttpResponseMessageAsHTML("<div style='color:red;font-weight:bold;'>Your request cannot be processed, please try after some time or contact to MIS team.</div>" + "<div style='color:#fff;'>Error: " + ex.Message + ", Trace: " + ex.StackTrace + "</div>");
                errorResponse.StatusCode = HttpStatusCode.InternalServerError;
                return errorResponse;
            }
            var responseData = GetHttpResponseMessageAsHTML("<div style='color:green;font-weight:bold;'>Allocated assets has been been uploaded successfully.</div>");
            responseData.StatusCode = HttpStatusCode.OK;
            return responseData;
        }

        private void CheckUserDataForDuplicateData(List<UserAssetRequest> userDataList, List<FileUploadBugsBO> bugsList)
        {
            // Check for duplicate data in excel sheet
            if (userDataList.Any())
            {
                for (int i = 0; i < userDataList.Count; i++)
                {
                    var userData = userDataList[i];
                    //duplicate user if below criteria matches
                    var checkforExisting = userDataList.Where(x => x.UserId == userData.UserId);
                    var checkForExistingAsset = userDataList.Where(x => x.AssetId == userData.AssetId && userData.AssetId != 0);
                    if (checkforExisting.Count() > 1)
                    {
                        var bug = GetExcelFileBug(i, "Employee Code", "Duplicate Record in Excel Sheet.");
                        bugsList.Add(bug);
                    }

                    if (checkForExistingAsset.Count() > 1)
                    {
                        var bug = GetExcelFileBug(i, "Serial No", "Duplicate Record in Excel Sheet.");
                        bugsList.Add(bug);
                    }
                }
            }

            // Check for Duplicate data from DataBase.
            if (userDataList.Any())
            {
                var counter = 0;
                foreach (var userData in userDataList)
                {
                    var checkforExisting = _assetServices.CheckUsersAssetsDetail(userData.UserId, userData.AssetId);

                    if (checkforExisting == 1)
                    {
                        var bug = GetExcelFileBug(counter, "Asset", "Asset already allocated to user");
                        bugsList.Add(bug);
                    }
                    counter++;
                }
            }
        }

        /// <summary>
        /// Method to get formatted message with html table
        /// </summary>
        /// <param name="bugsList">List</param>
        /// <returns>Formatted HTML table</returns>
        private string GetFormattedMessageInHTMLTable(List<FileUploadBugsBO> bugsList)
        {
            var html = new System.Text.StringBuilder();

            if (bugsList.Any())
            {
                html.Append("<html><head><style type='text/css'>table.gridtable {font-family: verdana,arial,sans-serif;font-size:11px;color:#333333;border-width: 1px;border-color: #666666;border-collapse: collapse;}" +
                "table.gridtable th {border-width: 1px;padding: 8px;border-style: solid;border-color: #666666;background-color: #dedede;}table.gridtable td {border-width: 1px;padding: 8px;border-style: solid;border-color:#666666;background-color: #ffffff;}" +
                "</style></head><body><div style='margin-bottom: 10px;'><span style='color: red;'>*</span>There are some discrepancies in excel sheet. Please correct them.</div><table class='gridtable' style='width: 100%;text-align: left;'>");
                html.Append("<tr><th>RowNo</th><th>Column Name</th><th>Error Message</th></tr>");
                foreach (var bug in bugsList)
                {
                    html.AppendFormat("<tr><td>{0}</td><td>{1}</td><td>{2}</td></tr>", bug.RowNo, bug.ColumnName, bug.InvalidMessage);
                }
                html.Append("<table></body></html>");
            }
            return html.ToString();
        }

        /// <summary>
        /// Validate excel user data for any discrepencies
        /// </summary>
        /// <param name="centerId">centerId</param>
        /// <param name="sessionId">sessionId</param>
        /// <param name="userAbrhs">userAbrhs</param>
        /// <param name="dtExcelUserData">Excel Users In Datatable</param>
        /// <param name="userDataList">UserRegistration BO List</param>
        /// <param name="bugsList">FileUploadBugsBO List</param>
        private void ValidateExcelUserData(DataTable dtExcelUserData, List<UserAssetRequest> userDataList, List<FileUploadBugsBO> bugsList)
        {
            var employeeList = _assetServices.GetAllEmployeesForAssetAllocation();
            var employeeCodes = employeeList.Select(t => t.EmployeeCode).ToList();

            var assetList = _assetServices.GetAllUnAllocatedAssetsSerialNo();
            var serialNoList = assetList.Select(t => t.SerialNo).ToList();

            var xlCol = 0;
            var xlColNames = dtExcelUserData.Columns.Cast<DataColumn>().Select(x => x.ColumnName).ToList();
            foreach (DataRow dr in dtExcelUserData.Rows)
            {
                var UserData = new UserAssetRequest();

                // Validate Employee Code
                if (xlColNames.Contains("Employee Code") && !string.IsNullOrEmpty(dr["Employee Code"].ToString().Trim()))
                {
                    if (employeeCodes.Contains(dr["Employee Code"].ToString().Trim()))
                        UserData.UserId = employeeList.FirstOrDefault(x => x.EmployeeCode.Trim().ToLower() == dr["Employee Code"].ToString().Trim().ToLower()).UserId;
                    else
                    {
                        var bug = GetExcelFileBug(xlCol, "Employee Code", string.Format("User with employee code({0}) doesn't exists.", dr["Employee Code"].ToString().Trim()));
                        bugsList.Add(bug);
                    }
                }
                else
                {
                    var bug = GetExcelFileBug(xlCol, "Employee Code", "Employee Code can not be empty");
                    bugsList.Add(bug);
                }


                // Validate Serial No
                if (xlColNames.Contains("Serial No") && !string.IsNullOrEmpty(dr["Serial No"].ToString().Trim()))
                {
                    if (serialNoList.Contains(dr["Serial No"].ToString().Trim()))
                        UserData.AssetId = assetList.FirstOrDefault(x => x.SerialNo.Trim().ToLower() == dr["Serial No"].ToString().Trim().ToLower()).AssetId;
                    else
                    {
                        var bug = GetExcelFileBug(xlCol, "Serial No", string.Format("Assets with serial no.({0}) doesn't exists in inventory or already allocated to others", dr["Serial No"].ToString().Trim()));
                        bugsList.Add(bug);
                    }
                }
                else
                {
                    var bug = GetExcelFileBug(xlCol, "Serial No", "Serial No. can not be empty");
                    bugsList.Add(bug);
                }


                // Validate for Allocated From
                if (xlColNames.Contains("Allocate From") && !string.IsNullOrEmpty(dr["Allocate From"].ToString().Trim()))
                {
                    UserData.FromDate = dr["Allocate From"].ToString().Trim();
                }
                else
                {
                    var bug = GetExcelFileBug(xlCol, "Allocate From", "Allocate From can not be empty");
                    bugsList.Add(bug);
                }

                // Validate for Remarks
                if (xlColNames.Contains("Remarks"))
                {
                    UserData.Remarks = dr["Remarks"].ToString().Trim();
                }

                xlCol++;
                userDataList.Add(UserData);
            }
        }

        /// <summary>
        /// Method to get excel file bug object with data
        /// </summary>
        /// <param name="excelColumnIndex">ExcelColumnIndex</param>
        /// <param name="columnName">ColumnName</param>
        /// <param name="message">Message</param>
        /// <returns>FileUploadBugsBO</returns>
        private static FileUploadBugsBO GetExcelFileBug(int excelColumnIndex, string columnName, string message)
        {
            var bug = new FileUploadBugsBO
            {
                RowNo = excelColumnIndex + 2,
                ColumnName = columnName,
                InvalidMessage = message
            };
            return bug;
        }
        #endregion


        #region For Import Attendance Data

        [HttpPost]
        public HttpResponseMessage UploadAttendance(int deviceId, string userAbrhs) // need to validate session using token
        {
            try
            {
                var hfc = HttpContext.Current.Request.Files;
                var dsExcelData = GetExcelDataInDataset(hfc);

                var dtExcelAttendancePapers = new DataTable();
                //remove all empty rows from datatable
                dtExcelAttendancePapers = dsExcelData.Tables[0].Rows.Cast<DataRow>().Where(row => !row.ItemArray.All(field => field is System.DBNull || string.Compare((field as string).Trim(), string.Empty) == 0)).CopyToDataTable();

                var attendanceList = new List<AttendanceBO>();
                //Insert Data to List.
                var xlColNames = dtExcelAttendancePapers.Columns.Cast<DataColumn>().Select(x => x.ColumnName).ToList();
                foreach (DataRow dr in dtExcelAttendancePapers.Rows)
                {
                    var attendance = new AttendanceBO();

                    if (xlColNames.Contains("SlotCardTime") && !string.IsNullOrEmpty(dr["SlotCardTime"].ToString().Trim()))
                    {
                        if (xlColNames.Contains("JobId") && !string.IsNullOrEmpty(dr["JobId"].ToString().Trim()))
                        {
                            attendance.JobId = dr["JobId"].ToString().Trim();
                        }
                        if (xlColNames.Contains("SlotCardDate") && !string.IsNullOrEmpty(dr["SlotCardDate"].ToString().Trim()))
                        {
                            attendance.AttendanceDate = dr["SlotCardDate"].ToString().Trim();
                        }

                        var timings = dr["SlotCardTime"].ToString().Trim();
                        List<string> splitStrings = timings.Split(new[] { " " }, StringSplitOptions.RemoveEmptyEntries).Select(s => s.Trim()).ToList();

                        attendance.InTime = dr["SlotCardDate"].ToString().Trim() + " " + splitStrings[0] + ":00.000";
                        attendance.OutTime = dr["SlotCardDate"].ToString().Trim() + " " + splitStrings[splitStrings.Count - 1] + ":00.000";
                        attendanceList.Add(attendance);
                    }
                }

                if (attendanceList.Any())
                {
                    // Save Attendance into database
                    var data = _attendanceServices.AddAttendance(attendanceList, deviceId, userAbrhs);
                    //If saved successfully, return with success message
                    var response = GetHttpResponseMessageAsHTML("<div style='color:green;font-weight:bold;'>A-Square attendance data has been been uploaded successfully.</div>");
                    response.StatusCode = HttpStatusCode.OK;
                    return response;
                }
            }
            catch (Exception ex)
            {
                var errorResponse = GetHttpResponseMessageAsHTML("<div style='color:red;font-weight:bold;'>Your request cannot be processed, please try after some time or contact to MIS team.</div>" + "<div style='color:#fff;'>Error: " + ex.Message + ", Trace: " + ex.StackTrace + "</div>");
                errorResponse.StatusCode = HttpStatusCode.InternalServerError;
                return errorResponse;
            }
            var responseData = GetHttpResponseMessageAsHTML("<div style='color:green;font-weight:bold;'>A-Square attendance data has been been uploaded successfully.</div>");
            responseData.StatusCode = HttpStatusCode.OK;
            return responseData;
        }

        /// <summary>
        /// Method to read excel data into data set
        /// </summary>
        /// <param name="hfc">HttpFileCollection</param>
        /// <returns>DataSet</returns>
        private static DataSet GetExcelDataInDataset(HttpFileCollection hfc)
        {
            var ds = new DataSet();
            try
            {
                string fileName;
                // CHECK THE FILE COUNT.
                for (int iCnt = 0; iCnt <= hfc.Count - 1; iCnt++)
                {
                    System.Web.HttpPostedFile file = hfc[iCnt];
                    if (file.ContentLength > 0)
                    {
                        string fileExtension = System.IO.Path.GetExtension(file.FileName).Trim().ToLower();
                        if (fileExtension == ".xls" || fileExtension == ".xlsx")
                        {
                            string fileLocation = System.Web.Hosting.HostingEnvironment.MapPath("~/Content/") + file.FileName;
                            if (System.IO.File.Exists(fileLocation))
                            {
                                GC.Collect();
                                GC.WaitForPendingFinalizers();
                                FileInfo f = new FileInfo(fileLocation);
                                f.Delete();
                            }
                            Int32 fileLength = file.ContentLength;
                            fileName = file.FileName;
                            byte[] buffer = new byte[fileLength];
                            file.InputStream.Read(buffer, 0, fileLength);

                            using (FileStream newFile = new FileStream(fileLocation, FileMode.Create, FileAccess.Write))
                            {
                                newFile.Write(buffer, 0, buffer.Length);
                            }
                            string excelConnectionString = string.Empty;
                            //connection String for xls file format.
                            if (fileExtension == ".xls")
                            {
                                excelConnectionString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + fileLocation + ";Extended Properties=\"Excel 8.0;HDR=Yes;IMEX=2\"";
                            }
                            //connection String for xlsx file format.
                            else if (fileExtension == ".xlsx")
                            {
                                excelConnectionString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + fileLocation + ";Extended Properties=\"Excel 12.0;HDR=Yes;IMEX=2\"";
                            }
                            //Create Connection to Excel work book and add oledb namespace
                            OleDbConnection excelConnection = new OleDbConnection(excelConnectionString);
                            excelConnection.Open();
                            DataTable dt = new DataTable();
                            dt = excelConnection.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);
                            dt.Columns.Add("ErrorMessage", typeof(String));
                            String[] excelSheets = new String[dt.Rows.Count];
                            int t = 0;
                            //excel data saves in temp file here.
                            foreach (DataRow row in dt.Rows)
                            {
                                excelSheets[t] = row["TABLE_NAME"].ToString();
                                t++;
                            }
                            dt.Dispose();
                            string query = string.Format("Select * from [{0}]", excelSheets[0]);
                            using (OleDbDataAdapter dataAdapter = new OleDbDataAdapter(query, excelConnection))
                            {
                                dataAdapter.Fill(ds);
                            }
                        }
                    }
                }
            }
            catch (Exception)
            {
                throw;
            }
            return ds;
        }

        /// <summary>
        ///  Method to get string message as http response message in text/html format
        /// </summary>
        /// <param name="message">Message</param>
        /// <returns>HttpResponseMessage</returns>
        private HttpResponseMessage GetHttpResponseMessageAsHTML(string message)
        {
            var response = new HttpResponseMessage();
            response.Content = new StringContent(message);
            response.Content.Headers.ContentType = new MediaTypeHeaderValue("text/html");
            return response;
        }

        #endregion
        

        #region Change Contact Details

        [HttpPost]
        public HttpResponseMessage ApproveChangeContactDetailRequest(string ActionData, string Reason)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.ApproveChangeContactDetailRequest(ActionData, Reason));
        }

        [HttpPost]
        public HttpResponseMessage RejectChangeContactDetailRequest(string ActionData, string Reason)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.RejectChangeContactDetailRequest(ActionData, Reason));
        }

        #endregion
        #region Cab Requests

        [HttpPost]
        public HttpResponseMessage TakeActionOnCabRequest(string encodedData, string actionCode, string remarks, string forScreen)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.TakeActionOnCabRequestAnonymous(encodedData, actionCode, remarks, forScreen));
        }

        [HttpPost]
        public HttpResponseMessage GetCabRequestDetailsToTakeAction(string encodedData)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.GetCabRequestDetailsToTakeAction(encodedData));
        }

        #endregion

        #region referral
        [HttpPost]
        public HttpResponseMessage MarkRelevantForReferral(string ActionData, string Reason)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.MarkRelevantForReferral(ActionData, Reason));
        }

        [HttpPost]
        public HttpResponseMessage MarkIrrelevantForReferral(string ActionData, string Reason)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _hRPortalServices.MarkIrrelevantForReferral(ActionData, Reason));
        }

        #endregion

        #region Invoice Request
        [HttpPost]
        public HttpResponseMessage ActionOnInvoiceRequest(string ActionData, string Reason , int Status)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _accountsPortalServices.ActionOnInvoiceRequest(ActionData, Reason, Status));
        }
        #endregion
    }
}