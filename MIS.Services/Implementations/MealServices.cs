using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MIS.Services.Contracts;
using MIS.Model;
using MIS.BO;
using System.Configuration;
using MIS.Utilities;

namespace MIS.Services.Implementations
{
    public class MealServices : IMealServices
    {
        #region Private member variables

        private readonly MISEntities _dbContext = new MISEntities();

        #endregion

        #region Meal Period

        public List<CommonEntitiesBO> GetAllMealPeriod()
        {
            return _dbContext.MealPeriods.Where(x => x.IsActive == true).Select(x => new CommonEntitiesBO { EntityName = x.MealPeriodName, Id = x.MealPeriodId }).ToList();
        }

        public int AddMealPeriod(string mealPeriodName, string userAbrhs) //1:success, 2:duplicate, 3:failure
        {
            if (_dbContext.MealPeriods.FirstOrDefault(x => x.MealPeriodName == mealPeriodName && x.IsActive == true) != null)
                return 2;
            else
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

                _dbContext.MealPeriods.Add(new MealPeriod
                {
                    MealPeriodName = mealPeriodName,
                    IsActive = true,
                    CreatedDate = DateTime.Now,
                    CreatedById = userId,
                });
                _dbContext.SaveChanges();
                return 1;
            }
        }

        public bool DeleteMealPeriod(int mealPeriodId, string userAbrhs)
        {
            var data = _dbContext.MealPeriods.FirstOrDefault(x => x.MealPeriodId == mealPeriodId && x.IsActive == true);
            if (data != null)
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                data.IsActive = false;
                data.ModifiedDate = DateTime.Now;
                data.ModifiedById = userId;
                _dbContext.SaveChanges();

                return true;
            }
            return false;
        }

        public int UpdateMealPeriod(int mealPeriodId, string mealPeriodName, string userAbrhs) //1:success, 2:duplicate, 3:failure
        {
            if (_dbContext.MealPeriods.FirstOrDefault(x => x.MealPeriodName == mealPeriodName && x.IsActive == true && x.MealPeriodId != mealPeriodId) != null)
                return 2;
            else
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

                var data = _dbContext.MealPeriods.FirstOrDefault(x => x.MealPeriodId == mealPeriodId && x.IsActive == true);
                data.MealPeriodName = mealPeriodName;
                data.ModifiedDate = DateTime.Now;
                data.ModifiedById = userId;

                _dbContext.SaveChanges();
                return 1;
            }
        }

        #endregion

        #region Meal category

        public int AddMealCategory(string mealCategoryName, string userAbrhs) //1:success, 2:duplicate, 3:failure
        {
            if (_dbContext.MealCategories.FirstOrDefault(x => x.MealCategoryName == mealCategoryName && x.IsActive == true) == null)
                return 2;
            else
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

                _dbContext.MealCategories.Add(new MealCategory
                {
                    MealCategoryName = mealCategoryName,
                    IsActive = true,
                    CreatedDate = DateTime.Now,
                    CreatedById = userId,
                });
                _dbContext.SaveChanges();
                return 1;
            }
        }

        public bool DeleteMealCategory(int mealCategoryId, string userAbrhs)
        {
            var data = _dbContext.MealCategories.FirstOrDefault(x => x.MealCategoryId == mealCategoryId && x.IsActive == true);
            if (data != null)
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                data.IsActive = false;
                data.ModifiedDate = DateTime.Now;
                data.ModifiedById = userId;
                _dbContext.SaveChanges();

                return true;
            }
            return false;
        }

        public int UpdateMealCategory(int mealCategoryId, string mealCategoryName, string userAbrhs) //1:success, 2:duplicate, 3:failure
        {
            if (_dbContext.MealCategories.FirstOrDefault(x => x.MealCategoryName == mealCategoryName && x.IsActive == true && x.MealCategoryId != mealCategoryId) != null)
                return 2;
            else
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

                var data = _dbContext.MealCategories.FirstOrDefault(x => x.MealCategoryId == mealCategoryId && x.IsActive == true);
                data.MealCategoryName = mealCategoryName;
                data.ModifiedDate = DateTime.Now;
                data.ModifiedById = userId;

                _dbContext.SaveChanges();
                return 1;
            }
        }

        #endregion

        #region Meal type

        public int AddMealType(string mealTypeName, string userAbrhs) //1:success, 2:duplicate, 3:failure
        {
            if (_dbContext.MealTypes.FirstOrDefault(x => x.MealTypeName == mealTypeName && x.IsActive == true) != null)
                return 2;
            else
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

                _dbContext.MealTypes.Add(new MealType
                {
                    MealTypeName = mealTypeName,
                    IsActive = true,
                    CreatedDate = DateTime.Now,
                    CreatedById = userId,
                });
                _dbContext.SaveChanges();
                return 1;
            }
        }

        public bool DeleteMealType(int mealTypeId, string userAbrhs)
        {
            var data = _dbContext.MealTypes.FirstOrDefault(x => x.MealTypeId == mealTypeId && x.IsActive == true);
            if (data != null)
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                data.IsActive = false;
                data.ModifiedDate = DateTime.Now;
                data.ModifiedById = userId;
                _dbContext.SaveChanges();

                return true;
            }
            return false;
        }

        public int UpdateMealType(int mealTypeId, string mealTypeName, string userAbrhs) //1:success, 2:duplicate, 3:failure
        {
            if (_dbContext.MealTypes.FirstOrDefault(x => x.MealTypeName == mealTypeName && x.IsActive == true && x.MealTypeId != mealTypeId) != null)
                return 2;
            else
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

                var data = _dbContext.MealTypes.FirstOrDefault(x => x.MealTypeId == mealTypeId && x.IsActive == true);
                data.MealTypeName = mealTypeName;
                data.ModifiedDate = DateTime.Now;
                data.ModifiedById = userId;

                _dbContext.SaveChanges();
                return 1;
            }
        }

        #endregion

        #region Meal dishes

        public int AddMealDish(string mealDishName, string userAbrhs) //1:success, 2:duplicate, 3:failure
        {
            if (_dbContext.MealDishes.FirstOrDefault(x => x.MealDishesName == mealDishName && x.IsActive == true) != null)
                return 2;
            else
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

                _dbContext.MealDishes.Add(new MealDish
                {
                    MealDishesName = mealDishName,
                    IsActive = true,
                    CreatedDate = DateTime.Now,
                    CreatedById = userId,
                });
                _dbContext.SaveChanges();
                return 1;
            }
        }

        public bool DeleteMealDish(int mealDishId, string userAbrhs)
        {
            var data = _dbContext.MealDishes.FirstOrDefault(x => x.MealDishesId == mealDishId && x.IsActive == true);
            if (data != null)
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                data.IsActive = false;
                data.ModifiedDate = DateTime.Now;
                data.ModifiedById = userId;
                _dbContext.SaveChanges();

                return true;
            }
            return false;
        }

        public int UpdateMealDish(int mealDishId, string mealDishName, string userAbrhs) //1:success, 2:duplicate, 3:failure
        {
            if (_dbContext.MealDishes.FirstOrDefault(x => x.MealDishesName == mealDishName && x.IsActive == true && x.MealDishesId != mealDishId) != null)
                return 2;
            else
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

                var data = _dbContext.MealDishes.FirstOrDefault(x => x.MealDishesId == mealDishId && x.IsActive == true);
                data.MealDishesName = mealDishName;
                data.ModifiedDate = DateTime.Now;
                data.ModifiedById = userId;

                _dbContext.SaveChanges();
                return 1;
            }
        }

        #endregion

        #region Meal Packages

        public int AddMealPackages(int MealPeriodId, int MealTypeId, int MealCategoryId, string UserAbrhs) //1:success, 2:duplicate, 3:failure
        {
            if (_dbContext.MealPackages.FirstOrDefault(x => x.MealPeriodId == MealPeriodId && x.MealTypeId == MealTypeId && x.MealCategoryId == MealCategoryId && x.IsActive == true) != null)
                return 2;
            else
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(UserAbrhs), out userId);

                var MealPackageName = _dbContext.MealPeriods.FirstOrDefault(x => x.MealPeriodId == MealPeriodId).MealPeriodName + "_" + _dbContext.MealCategories.FirstOrDefault(x => x.MealCategoryId == MealCategoryId).MealCategoryName + "_" + _dbContext.MealTypes.FirstOrDefault(x => x.MealTypeId == MealTypeId).MealTypeName;

                _dbContext.MealPackages.Add(new MealPackage
                {
                    MealPackageName = MealPackageName,
                    MealPeriodId = MealPeriodId,
                    MealTypeId = MealTypeId,
                    MealCategoryId = MealCategoryId,
                    IsActive = true,
                    CreatedDate = DateTime.Now,
                    CreatedById = userId,
                });
                _dbContext.SaveChanges();
                return 1;
            }
        }

        public int DeleteMealPackages(int MealPackageId, string UserAbrhs)
        {
            var data = _dbContext.MealPackages.FirstOrDefault(x => x.MealPackageId == MealPackageId);
            if (data != null)
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(UserAbrhs), out userId);

                if (data.IsActive)
                {
                    data.IsActive = false;
                }
                else
                {
                    data.IsActive = true;
                }
                data.ModifiedDate = DateTime.Now;
                data.ModifiedById = userId;
                _dbContext.SaveChanges();
                return 1;
            }
            return 2;
        }

        public int UpdateMealPackages(int MealPackageId, int MealPeriodId, int MealTypeId, int MealCategoryId, string UserAbrhs) //1:success, 2:duplicate, 3:failure
        {
            if (_dbContext.MealPackages.FirstOrDefault(x => x.MealPackageId == MealPackageId) == null)
                return 2;
            else
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(UserAbrhs), out userId);

                var data = _dbContext.MealPackages.FirstOrDefault(x => x.MealPackageId == MealPackageId && x.IsActive == true);
                var MealPackageName = _dbContext.MealPeriods.FirstOrDefault(x => x.MealPeriodId == MealPeriodId).MealPeriodName + "_" + _dbContext.MealCategories.FirstOrDefault(x => x.MealCategoryId == MealCategoryId).MealCategoryName + "_" + _dbContext.MealTypes.FirstOrDefault(x => x.MealTypeId == MealTypeId).MealTypeName;
                if (data != null)
                {
                    data.MealPackageName = MealPackageName;
                    data.MealPeriodId = MealPeriodId;
                    data.MealTypeId = MealTypeId;
                    data.MealCategoryId = MealCategoryId;
                    data.IsActive = true;
                    data.ModifiedDate = DateTime.Now;
                    data.ModifiedById = userId;
                    _dbContext.SaveChanges();
                    return 1;
                }
                return 2;
            }
        }

        public List<MealPackageListBO> GetMealPackages()
        {
            List<MealPackageListBO> mealPackageListBO = new List<MealPackageListBO>();
            var mealPackage = _dbContext.MealPackages.ToList();
            if (mealPackage.Any())
            {
                foreach (var item in mealPackage)
                {
                    MealPackageListBO mealPackageBO = new MealPackageListBO();
                    mealPackageBO.MealPackageId = item.MealPackageId;
                    mealPackageBO.MealPackage = item.MealPackageName;
                    mealPackageBO.MealType = item.MealType.MealTypeName;
                    mealPackageBO.MealCategory = item.MealCategory.MealCategoryName;
                    mealPackageBO.MealPeriod = item.MealPeriod.MealPeriodName;
                    mealPackageBO.CreatedDate = item.CreatedDate.ToString("dd-MMM-yyyy");
                    mealPackageBO.IsActive = item.IsActive;

                    mealPackageListBO.Add(mealPackageBO);
                }
            }
            return mealPackageListBO;
        }

        public MealPackageListBO GetMealPackagesEdit(int MealPackageId)
        {
            MealPackageListBO mealPackageBO = new MealPackageListBO();
            var mealPackage = _dbContext.MealPackages.FirstOrDefault(x => x.MealPackageId == MealPackageId);
            if (mealPackage != null)
            {
                mealPackageBO.MealTypeId = mealPackage.MealTypeId;
                mealPackageBO.MealCategoryId = mealPackage.MealCategoryId;
                mealPackageBO.MealPeriodId = mealPackage.MealPeriodId;
                return mealPackageBO;
            }
            return mealPackageBO;
        }

        #endregion

        #region Meal feedback

        public int SubmitMealFeedback(int mealPackageDetailId, string userAbrhs, bool isLiked, string comment)  //1:success, 2:already submitted feedback, 3:failure
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

            if (_dbContext.MealPackageFeedbacks.FirstOrDefault(x => x.MealPackageId == mealPackageDetailId && x.CreatedByUserId == userId) != null)
                return 2;

            _dbContext.MealPackageFeedbacks.Add(new MealPackageFeedback
            {
                MealPackageId = mealPackageDetailId,
                CreatedByUserId = userId,
                CreatedDate = DateTime.Now,
                Liked = isLiked,
                Comment = comment,
            });

            _dbContext.SaveChanges();
            return 1;
        }

        #endregion

        #region  Meal of the day

        public int AddMealoftheDay(MealOfTheDay mealOfTheDay)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(mealOfTheDay.UserAbrhs), out userId);

            // check for duplicate meal for this date.
            foreach (var item in mealOfTheDay.DishMenuList)
            {
                if (_dbContext.MealPackageDetails.FirstOrDefault(x => x.MealDate == mealOfTheDay.MealDate && x.MealDishesId == item.DishId && x.MealItemName == item.MenuName && x.MealPackageId == mealOfTheDay.MealPackagesId && x.IsActive == true) != null)
                    return 2;
            }

            foreach (var item in mealOfTheDay.DishMenuList)
            {

                _dbContext.MealPackageDetails.Add(new MealPackageDetail
                {
                    MealPackageId = mealOfTheDay.MealPackagesId,
                    MealDate = mealOfTheDay.MealDate,
                    MealDishesId = item.DishId,
                    MealItemName = item.MenuName,
                    IsActive = true,
                    CreatedDate = DateTime.Now,
                    CreatedById = userId,
                });
            }
            _dbContext.SaveChanges();
            return 1;
        }

        public List<MealOfTheDayBO> GetAllMeals()
        {
            List<MealOfTheDayBO> mealOfTheDayList = new List<MealOfTheDayBO>();
            var mealsdata = _dbContext.Proc_GetMealDishes(DateTime.Today.AddDays(15), DateTime.Today.AddMonths(-1)).ToList();
            if (mealsdata.Any())
            {
                foreach (var item in mealsdata)
                {
                    MealOfTheDayBO mealOfTheDay = new MealOfTheDayBO();
                    mealOfTheDay.MealDate = item.MealDate.ToString("dd-MMM-yyyy");
                    mealOfTheDay.MealPackagesId = item.MealPackageId;
                    mealOfTheDay.Meal = item.MealDishes;
                    mealOfTheDay.MealPackage = item.MealPackageName;
                    mealOfTheDay.Date = item.MealDate;
                    mealOfTheDayList.Add(mealOfTheDay);
                }
            }
            return mealOfTheDayList;
        }

        public int DeleteMeal(int MealPackagesId, DateTime Date, string UserAbrhs)
        {
            var data = _dbContext.MealPackageDetails.Where(x => x.MealPackageId == MealPackagesId && x.MealDate == Date.Date && x.IsActive).ToList();
            if (data != null)
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(UserAbrhs), out userId);
                foreach (var item in data)
                {
                    if (item.IsActive)
                    {
                        item.IsActive = false;
                    }
                    else
                    {
                        item.IsActive = true;
                    }
                    item.ModifiedDate = DateTime.Now;
                    item.ModifiedById = userId;
                }
                _dbContext.SaveChanges();
                return 1;
            }
            return 2;
        }

        public MealOfTheDay GetMealEdit(int MealPackagesId, DateTime Date, string UserAbrhs)
        {
            MealOfTheDay mealOfTheDayBO = new MealOfTheDay();
            var mealList = _dbContext.MealPackageDetails.Where(x => x.MealPackageId == MealPackagesId && x.MealDate == Date.Date && x.IsActive).ToList();
            if (mealList.Any())
            {
                mealOfTheDayBO.MealPackagesId = mealList[0].MealPackageId;
                mealOfTheDayBO.MealDate = mealList[0].MealDate;

                mealOfTheDayBO.DishMenuList = mealList.Select(item => new DishMenu
                {
                    DishId = item.MealDishesId,
                    MenuName = item.MealItemName
                }).ToList();
                return mealOfTheDayBO;
            }
            return mealOfTheDayBO;
        }

        public int UpdateMealoftheDay(MealOfTheDay mealOfTheDay)
        {
            var userId = 0;
            Int32.TryParse(CryptoHelper.Decrypt(mealOfTheDay.UserAbrhs), out userId);

            // check for duplicate meal for this date.
            var existingMealdata = _dbContext.MealPackageDetails.Where(x => x.MealDate == mealOfTheDay.MealDate && x.MealPackageId == mealOfTheDay.MealPackagesId && x.IsActive == true).ToList();
            if (existingMealdata.Any())
            {
                foreach (var item in existingMealdata)
                {
                    if (item.IsActive)
                    {
                        item.IsActive = false;
                    }
                    else
                    {
                        item.IsActive = true;
                    }
                    item.ModifiedDate = DateTime.Now;
                    item.ModifiedById = userId;
                }
                _dbContext.SaveChanges();
            }

            // check for duplicate meal for this date.
            foreach (var item in mealOfTheDay.DishMenuList)
            {
                if (_dbContext.MealPackageDetails.FirstOrDefault(x => x.MealDate == mealOfTheDay.MealDate && x.MealDishesId == item.DishId && x.MealItemName == item.MenuName && x.MealPackageId == mealOfTheDay.MealPackagesId && x.IsActive == true) != null)
                    return 2;
            }

            foreach (var item in mealOfTheDay.DishMenuList)
            {
                _dbContext.MealPackageDetails.Add(new MealPackageDetail
                {
                    MealPackageId = mealOfTheDay.MealPackagesId,
                    MealDate = mealOfTheDay.MealDate,
                    MealDishesId = item.DishId,
                    MealItemName = item.MenuName,
                    IsActive = true,
                    CreatedDate = DateTime.Now,
                    CreatedById = userId,
                });
            }
            _dbContext.SaveChanges();
            return 1;
        }

        #endregion
    }
}
