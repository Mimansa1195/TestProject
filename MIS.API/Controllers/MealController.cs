using MIS.BO;
using MIS.Services.Contracts;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace MIS.API.Controllers
{
    public class MealController : BaseApiController
    {
        private readonly IMealServices _mealServices;

        public MealController(IMealServices mealServices)
        {
            _mealServices = mealServices;
        }
        
        #region Meal Period

        [HttpPost]
        public HttpResponseMessage AddMealPeriod(string mealPeriodName, string userAbrhs)
        {
                return Request.CreateResponse(HttpStatusCode.OK, _mealServices.AddMealPeriod(mealPeriodName, userAbrhs));
        }
        
        [HttpPost]
        public HttpResponseMessage DeleteMealPeriod(int mealPeriodId, string userAbrhs)
        {
                return Request.CreateResponse(HttpStatusCode.OK, _mealServices.DeleteMealPeriod(mealPeriodId, userAbrhs));
        }
        
        [HttpPost]
        public HttpResponseMessage UpdateMealPeriod(int mealPeriodId, string mealPeriodName, string userAbrhs)
        {
                return Request.CreateResponse(HttpStatusCode.OK, _mealServices.UpdateMealPeriod(mealPeriodId, mealPeriodName, userAbrhs));
        }
        
        #endregion

        #region Meal category

        [HttpPost]
        public HttpResponseMessage AddMealCategory(string mealCategoryName, string userAbrhs)
        {
                return Request.CreateResponse(HttpStatusCode.OK, _mealServices.AddMealCategory(mealCategoryName, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage DeleteMealCategory(int mealCategoryId, string userAbrhs)
        {
                return Request.CreateResponse(HttpStatusCode.OK, _mealServices.DeleteMealCategory(mealCategoryId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage UpdateMealCategory(int mealCategoryId, string mealCategoryName, string userAbrhs)
        {
                return Request.CreateResponse(HttpStatusCode.OK, _mealServices.UpdateMealCategory(mealCategoryId, mealCategoryName, userAbrhs));
        }

        #endregion

        #region Meal type

        [HttpPost]
        public HttpResponseMessage AddMealType(string mealTypeName, string userAbrhs)
        {
                return Request.CreateResponse(HttpStatusCode.OK, _mealServices.AddMealType(mealTypeName, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage DeleteMealType(int mealTypeId, string userAbrhs)
        {
                return Request.CreateResponse(HttpStatusCode.OK, _mealServices.DeleteMealType(mealTypeId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage UpdateMealType(int mealTypeId, string mealTypeName, string userAbrhs)
        {
                return Request.CreateResponse(HttpStatusCode.OK, _mealServices.UpdateMealType(mealTypeId, mealTypeName, userAbrhs));
        }

        #endregion

        #region Meal dishes

        [HttpPost]
        public HttpResponseMessage AddMealDish(string mealDishName, string userAbrhs)
        {
                return Request.CreateResponse(HttpStatusCode.OK, _mealServices.AddMealDish(mealDishName, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage DeleteMealDish(int mealDishId, string userAbrhs)
        {
                return Request.CreateResponse(HttpStatusCode.OK, _mealServices.DeleteMealDish(mealDishId, userAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage UpdateMealDish(int mealDishId, string mealDishName, string userAbrhs)
        {
                return Request.CreateResponse(HttpStatusCode.OK, _mealServices.UpdateMealDish(mealDishId, mealDishName, userAbrhs));
        }

        #endregion

        #region Meal Packages

        [HttpPost]
        public HttpResponseMessage AddMealPackages(int MealPeriodId, int MealTypeId, int MealCategoryId, string UserAbrhs)
        {
                return Request.CreateResponse(HttpStatusCode.OK, _mealServices.AddMealPackages(MealPeriodId, MealTypeId, MealCategoryId, UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage DeleteMealPackages(int MealPackageId, string UserAbrhs)
        {
                return Request.CreateResponse(HttpStatusCode.OK, _mealServices.DeleteMealPackages(MealPackageId, UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage UpdateMealPackages(int MealPackageId, int MealPeriodId, int MealTypeId, int MealCategoryId, string UserAbrhs)
        {
                return Request.CreateResponse(HttpStatusCode.OK, _mealServices.UpdateMealPackages(MealPackageId, MealPeriodId, MealTypeId, MealCategoryId, UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetMealPackages()
        {
                return Request.CreateResponse(HttpStatusCode.OK, _mealServices.GetMealPackages());
        }

        [HttpPost]
        public HttpResponseMessage GetMealPackagesEdit(int MealPackageId)
        {
                return Request.CreateResponse(HttpStatusCode.OK, _mealServices.GetMealPackagesEdit(MealPackageId));
        }

        #endregion

        #region Meal feedback

        [HttpPost]
        public HttpResponseMessage SubmitMealFeedback(int mealPackageDetailId, string userAbrhs, bool isLiked, string comment)
        {
                return Request.CreateResponse(HttpStatusCode.OK, _mealServices.SubmitMealFeedback(mealPackageDetailId, userAbrhs, isLiked, comment));
        }

        //[HttpPost]
        //public HttpResponseMessage ViewAllMealFeedback()
        //{
        //        return Request.CreateResponse(HttpStatusCode.OK, _mealServices.ViewAllMealFeedback());
        //}
        #endregion

        #region Meal of the day

        [HttpPost]
        public HttpResponseMessage AddMealoftheDay(MealOfTheDay mealOfTheDay)
        {
                return Request.CreateResponse(HttpStatusCode.OK, _mealServices.AddMealoftheDay(mealOfTheDay));
        }

        [HttpPost]
        public HttpResponseMessage GetAllMeals()
        {
                return Request.CreateResponse(HttpStatusCode.OK, _mealServices.GetAllMeals());
        }

        [HttpPost]
        public HttpResponseMessage DeleteMeal(int MealPackagesId, DateTime Date, string UserAbrhs)
        {
                return Request.CreateResponse(HttpStatusCode.OK, _mealServices.DeleteMeal(MealPackagesId, Date, UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage GetMealEdit(int MealPackagesId, DateTime Date, string UserAbrhs)
        {
                return Request.CreateResponse(HttpStatusCode.OK, _mealServices.GetMealEdit(MealPackagesId, Date, UserAbrhs));
        }

        [HttpPost]
        public HttpResponseMessage UpdateMealoftheDay(MealOfTheDay mealOfTheDay)
        {
                return Request.CreateResponse(HttpStatusCode.OK, _mealServices.UpdateMealoftheDay(mealOfTheDay));
        }

        #endregion
    }
}