using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace MIS.BO
{
    public abstract class ServiceReturnType
    {
        #region Service Result Definitions

        public static ServiceResult<T> SessionExpiredResult<T>()
        {
            return new ServiceResult<T>
            {
                Message = "Session Expired",
                IsSessionExpired = true,
                IsSuccessful = false,
                Result = default(T),
            };
        }

        public static ServiceResult<bool> SuccessBoolResult
        {
            get
            {
                return new ServiceResult<bool>
                {
                    Message = "Operation Successful",
                    IsSessionExpired = false,
                    IsSuccessful = true,
                    Result = true
                };
            }
        }

        public static ServiceResult<bool> FailureBoolResult
        {
            get
            {
                return new ServiceResult<bool>
                {
                    Message = "Operation Unsuccessful",
                    IsSessionExpired = false,
                    IsSuccessful = false,
                    Result = false
                };
            }
        }

        public static ServiceResult<T> FailureNullDataResult<T>()
        {
            return new ServiceResult<T>
            {
                Message = "Operation Unsuccessful",
                IsSessionExpired = false,
                IsSuccessful = false,
                Result = default(T),
            };
        }

        public static ServiceResult<T> FailureWithDataResult<T>(object data)
        {
            return new ServiceResult<T>
            {
                IsSessionExpired = false,
                IsSuccessful = false,
                Message = "Failed",
                Result = data is T ? (T)data : default(T)
            };
        }

        public static ServiceResult<T> SuccessWithDataResult<T>(object data)
        {
            return new ServiceResult<T>
            {
                IsSessionExpired = false,
                IsSuccessful = true,
                Message = "Success",
                Result = data is T ? (T)data : default(T)
            };
        }

        public static ServiceResult<bool> DocumentPermissionGroupExist
        {
            get
            {
                return new ServiceResult<bool>
                {
                    Message = "This group is already added by another user. Try other.",
                    IsSessionExpired = false,
                    IsSuccessful = false,
                    Result = false
                };
            }
        }
        #endregion
    }
}
