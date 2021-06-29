using MIS.BO;
using MIS.Services.Contracts;
using System;
using System.Configuration;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web;
using System.Web.Http;

namespace MIS.API.Controllers
{
    public class DashboardController : BaseApiController
    {
        private readonly IUserServices _userServices;


        public DashboardController(IUserServices userServices)
        {
            _userServices = userServices;
        }

        #region Dashboard for User Landing

        [HttpPost]
        public HttpResponseMessage GetUserPrfileData(string userAbrhs)
        {
            var result = _userServices.GetUserDetailsDashboard(userAbrhs);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage GetLeaveBalanceData(string userAbrhs)
        {
            var result = _userServices.ListLeaveBalanceByUserId(userAbrhs);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage GetUpComingBIrthdayandHolidayData(string userAbrhs)
        {
            var result = _userServices.DashboardNotification(userAbrhs);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage GetWorkAnniversary(string userAbrhs)
        {
            var result = _userServices.GetWorkAnniversary(userAbrhs);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage GetTeamAttendanceData(string userAbrhs)
        {
            var result = _userServices.FetchEmployeeStatusForManager(userAbrhs);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage GetSelfAttendanceData(string userAbrhs, int year, int month)
        {
            var result = _userServices.FetchEmployeeAttendance(userAbrhs, year, month);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage GetInOutTimeCurrentDayData(string userAbrhs)
        {
            var result = _userServices.FetchEmployeeAttendanceForToday(userAbrhs);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage FetchEmployeeAttendanceDateWise(string userAbrhs, string forDate)
        {
            var result = _userServices.FetchEmployeeAttendanceDateWise(userAbrhs, forDate);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage GetMealOfTheDay(string userAbrhs)
        {
            var result = _userServices.GetMealOfTheDay(userAbrhs);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage GetTeamLeaves(string userAbrhs)
        {
            var result = _userServices.GetTeamLeaves(userAbrhs);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage GetNewsForSlider(string userAbrhs)
        {
            var result = _userServices.GetNewsForSlider(userAbrhs);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        #endregion

        #region Skills

        [HttpPost]
        public HttpResponseMessage AddSkills(SkillsDetailBO skillsDetailBO)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.AddSkills(skillsDetailBO));
        }

        [HttpPost]
        public HttpResponseMessage GetUserSkills(string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.GetUserSkills(userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetUserSkillsBySkillId(SkillsDetailBO skillsDetailBO)
        {
            var userSkillId = skillsDetailBO.UserSkillId;
            var userAbrhs = skillsDetailBO.UserAbrhs;
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.GetUserSkillsBySkillId(userSkillId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage DeleteSkills(SkillsDetailBO skillsDetailBO)
        {
            var userSkillId = skillsDetailBO.UserSkillId;
            var userAbrhs = skillsDetailBO.UserAbrhs;
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.DeleteSkills(userSkillId, userAbrhs));
        }

        #endregion

        #region help document

        [HttpPost]
        public HttpResponseMessage FetchHelpDocumentInformation()
        {
            var basePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["HelpDocumentPath"];
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.FetchHelpDocumentInformation(basePath));
        }

        #endregion

        #region Wishes

        [HttpPost]
        public HttpResponseMessage WishEmployees(string wishTo, int wishType, string message, string userAbrhs)
        {
            var result = _userServices.WishEmployees(wishTo, wishType, message, userAbrhs);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        #endregion

        #region Cab Request

        [HttpPost]
        public HttpResponseMessage GetCabRequestDetails(string userAbrhs, int Month, int Year)
        {
            var result = _userServices.GetCabRequestDetails(userAbrhs, Month, Year);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage GetCabRequestToFinalize(CabRequestBO data)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            var result = _userServices.GetCabRequestToFinalize(data, globalData.LoginUserId);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage GetFinalizedCabRequest(CabRequestBO data)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            var result = _userServices.GetFinalizedCabRequest(data, globalData.LoginUserId);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage GetGroupedCabRequestToFinalize(CabRequestBO data)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            var result = _userServices.GetGroupedCabRequestToFinalize(data, globalData.LoginUserId);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }


        [HttpPost]
        public HttpResponseMessage GetGroupedFinalizedCabRequest(CabRequestBO data)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            var result = _userServices.GetGroupedFinalizedCabRequest(data, globalData.LoginUserId);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }
   

        [HttpPost]
        public HttpResponseMessage BulkFinalizeCabRequests(CabDriverBO inputs)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            var result = _userServices.BulkFinalizeCabRequests(globalData.LoginUserId, inputs);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

  

        [HttpPost]
        public HttpResponseMessage BookOrUpdateCabRequest(CabRequestBO data)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            data.LoginUserId = globalData.LoginUserId;
            var result = _userServices.BookOrUpdateCabRequest(data);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage EditCabRequest(CabRequestBO data)
        {
            var result = _userServices.EditCabRequest(data);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage TakeActionOnCabRequest(CabRequestBO data)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            data.LoginUserId = globalData.LoginUserId;
            var result = _userServices.TakeActionOnCabRequest(data);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage GetCabReviewRequest(string UserAbrhs)
        {
            var result = _userServices.GetCabReviewRequest(UserAbrhs);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage TakeActionOnCabBulkApprove(string requestIds,  string statusCode, string remarks)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            var result = _userServices.TakeActionOnCabBulkApprove(requestIds, statusCode, remarks, globalData.LoginUserId);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage GetDatesForPickAndDrop(CabRequestBO inputs)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            var result = _userServices.GetDatesForPickAndDrop(inputs, globalData.LoginUserId);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage GetShiftDetails(CabRequestBO inputs)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            var result = _userServices.GetShiftDetails(inputs, globalData.LoginUserId);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

    
        [HttpPost]
        public HttpResponseMessage GetDriverDetails(string locationIds)
        {
            var result = _userServices.GetDriverDetails(locationIds);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage GetDriverContactNo(CabDriverBO inputs)
        {
            var result = _userServices.GetDriverContactNo(inputs);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage GetVehicleDetails(string locationIds)
        {
            var result = _userServices.GetVehicleDetails(locationIds);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage GetCabRoutes(CabRequestBO inputs)
        {
            var result = _userServices.GetCabRoutes(inputs);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage GetCabDropLocations(CabRequestBO inputs)
        {
            var result = _userServices.GetCabDropLocations(inputs);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage GetCabServiceType()
        {
            var result = _userServices.GetCabServiceType();
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage IsValidTimeForCabBooking(string forScreen)
        {
            var result = _userServices.IsValidTimeForCabBooking(forScreen);
            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        

        #endregion

        [HttpPost]
        public HttpResponseMessage ListDashboardLeavesByUserId(string leaveType, DateTime year, string userAbrhs)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.ListDashboardLeavesByUserId(leaveType, year, userAbrhs));
        }
        [HttpPost]
        public HttpResponseMessage ListDashboardCompOffByUserId(string userAbrhs, DateTime year)
        {
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.ListDashboardCompOffByUserId(userAbrhs, year));
        }
        #region Calendar Data 
        [HttpPost]
        public HttpResponseMessage GetUsersDashboardCalendarData(string startDate, string endDate)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.GetUsersDashboardCalendarData(startDate, endDate, globalData.UserAbrhs));
        }
        #endregion
        
        [HttpPost]
        public HttpResponseMessage GetHealthInsuranceDetail()
        {
            var basePath = HttpContext.Current.Server.MapPath("~") + ConfigurationManager.AppSettings["HealthInsurance"];
            var  globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.GetHealthInsuranceDetail(globalData.LoginUserId, basePath));
        }
        #region ADPassword
        [HttpPost]
        public HttpResponseMessage GetADUserName()
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.GetADUserName(globalData.LoginUserId));
        }

        [HttpPost]
        public HttpResponseMessage ChangeADPassword(string currntADPassword, string newADPassword)
        {
            var globalData = (RequestBO)HttpContext.Current.Request.RequestContext.RouteData.Values["GlobalData"] ?? new RequestBO();
            return Request.CreateResponse(HttpStatusCode.OK, _userServices.ChangeADPassword(globalData.LoginUserId, currntADPassword, newADPassword));
        }
        
        #endregion
    }
}
