using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MIS.BO;

namespace MIS.Services.Contracts
{
    public interface IMealServices
    {
        #region Meal Period

        int AddMealPeriod(string mealPeriodName, string userAbrhs); //1:success, 2:duplicate, 3:failure
        bool DeleteMealPeriod(int mealPeriodId, string userAbrhs);
        int UpdateMealPeriod(int mealPeriodId, string mealPeriodName, string userAbrhs); //1:success, 2:duplicate, 3:failure

        #endregion

        #region Meal category

        int AddMealCategory(string mealCategoryName, string userAbrhs); //1:success, 2:duplicate, 3:failure
        bool DeleteMealCategory(int mealCategoryId, string userAbrhs);
        int UpdateMealCategory(int mealCategoryId, string mealCategoryName, string userAbrhs); //1:success, 2:duplicate, 3:failure

        #endregion

        #region Meal type

        int AddMealType(string mealTypeName, string userAbrhs); //1:success, 2:duplicate, 3:failure
        bool DeleteMealType(int mealTypeId, string userAbrhs);
        int UpdateMealType(int mealTypeId, string mealTypeName, string userAbrhs); //1:success, 2:duplicate, 3:failure

        #endregion

        #region Meal dishes

        int AddMealDish(string mealDishName, string userAbrhs); //1:success, 2:duplicate, 3:failure
        bool DeleteMealDish(int mealDishId, string userAbrhs);
        int UpdateMealDish(int mealDishId, string mealDishName, string userAbrhs); //1:success, 2:duplicate, 3:failure

        #endregion

        #region Meal Packages

        int AddMealPackages(int MealPeriodId, int MealTypeId, int MealCategoryId, string UserAbrhs);

        int DeleteMealPackages(int MealPackageId, string UserAbrhs);

        int UpdateMealPackages(int MealPackageId, int MealPeriodId, int MealTypeId, int MealCategoryId, string UserAbrhs);

       List<MealPackageListBO> GetMealPackages();

       MealPackageListBO GetMealPackagesEdit(int MealPackageId);

        #endregion

        #region Meal feedback

        int SubmitMealFeedback(int mealPackageDetailId, string userAbrhs, bool isLiked, string comment);  //1:success, 2:already submitted feedback, 3:failure
        //List<MealFeedbackBO> ViewAllMealFeedback();

        #endregion

        #region Meal of the day

        int AddMealoftheDay(MealOfTheDay mealOfTheDay);

        List<MealOfTheDayBO> GetAllMeals();

        int DeleteMeal(int MealPackagesId, DateTime Date, string UserAbrhs);

        MealOfTheDay GetMealEdit(int MealPackagesId, DateTime Date, string UserAbrhs);

        int UpdateMealoftheDay(MealOfTheDay mealOfTheDay);

        #endregion
    }
}
