var misApp = angular.module('misApp', ['datatables']);

//-------------Start of Shift Master Controller--******************************************************************************************************************************************************//
//====================================================================================================================================================================================================//
misApp.controller('ShiftInformationController', ['$scope', 'ShiftInfoService', 'SaveShiftDetailsService', 'UpdateShiftDetailsService', 'DeleteShiftDetailsService', 'DTOptionsBuilder', function ($scope, ShiftInfoService, SaveShiftDetailsService, UpdateShiftDetailsService, DeleteShiftDetailsService, DTOptionsBuilder) {
   
   var userLoginAbrhs = misSession.userabrhs;
   $scope.shiftAbrhs = "";
   
   $scope.ShiftName = "";
   $scope.InTime = "0:00";
   $scope.OutTime = "0:00";
   $scope.WorkingHours = "0:00";
   $scope.IsWeekEnd = false;
   $scope.IsNight = false;
   $scope.show = false;

   $scope.showShiftUpdate = false;

    //--------- DataTables configurable options------------------------------------------------------------------------------------------------------------------------------------//
   $scope.dtOptions = DTOptionsBuilder.newOptions().withDisplayLength(10).withOption('bLengthChange', true).withOption('responsive', true).withOption('bAutoWidth', false);


  //---Get Mapped/UnMapped User List---------------------------------------------//
   $scope.GetShiftDetails = function (parms) {
       $scope.show = true;
       ShiftInfoService.GetShiftInfo(parms).success(function (data) {
           
           $scope.ShiftList = data;
           $scope.show = false;
       }).error(function (data) {
           misError();
       });
   }

    //Show popup of Add new Shift Details  ------------------------------------------------------------------------------------------------------------------------------------------------//
   $scope.AddNewShiftPopup = function () {
       
       $("#popupGeminiShiftInfo").modal();

       $scope.showShiftUpdate = false;
       $scope.ShiftId = 0;
       $scope.ShiftName = "";
       $scope.InTime = "0:00";
       $scope.OutTime = "0:00";
       $scope.WorkingHours = "0:00";
       $scope.IsWeekEnd = false;
       $scope.IsNight = false;

   }
    
    //Edit Shift Details  ------------------------------------------------------------------------------------------------------------------------------------------------//
   $scope.FillEditShiftDetails = function (i) {
      
       $("#popupGeminiShiftInfo").modal();

       $scope.showShiftUpdate = true;
       $scope.shiftAbrhs = $scope.ShiftList[i].ShiftAbrhs;
       $scope.ShiftName = $scope.ShiftList[i].ShiftName;
       $scope.InTime = $scope.ShiftList[i].InTime;
       $scope.OutTime = $scope.ShiftList[i].OutTime;
       $scope.WorkingHours = $scope.ShiftList[i].WorkingHours;
       $scope.IsWeekEnd = $scope.ShiftList[i].IsWeekEnd;
       $scope.IsNight = $scope.ShiftList[i].IsNight;

   }
  //Add New Shift Details  ------------------------------------------------------------------------------------------------------------------------------------------------//
   $scope.AddNewShiftDetails = function () {
      
       var valid = validateControls('divManageShift');
       if (!valid) {
           return false;
       }
       
       var ShiftInformation = {
           ShiftAbrhs: "",
           UserAbrhs: userLoginAbrhs,
           ShiftName: $scope.ShiftName,
           InTime: $scope.InTime,
           OutTime: $scope.OutTime,
           WorkingHours: $scope.WorkingHours,
           IsWeekEnd: $scope.IsWeekEnd,
           IsNight: $scope.IsNight          
       };
       SaveShiftDetailsService.SaveShiftDetails(ShiftInformation).then(function (data) {
                           
           if (data.data == "1") {
               $('#popupGeminiShiftInfo').modal('hide');
               misAlert("Shift Details Added Successfully !", 'Success', 'success');
               $scope.GetShiftDetails();
           }
           if (data.data == "2") {
               misAlert("Sorry ! This Shift is already present in our system.", 'Warning', 'warning');
           }
           if (data.data == "0") {
               misAlert('Error ! Unable to add Shift Details, Please try again.', 'Error', 'error');
           }
       });
   }
    //Update Shift Details  ------------------------------------------------------------------------------------------------------------------------------------------------//
   $scope.UpdateShiftDetails = function () {
      
       if (!validateControls('divManageShift')) {
           return false;
       }
       var ShiftInformation = {
           ShiftAbrhs: $scope.shiftAbrhs,
           UserAbrhs: userLoginAbrhs,
           ShiftName: $scope.ShiftName,
           InTime: $scope.InTime,
           OutTime: $scope.OutTime,
           WorkingHours: $scope.WorkingHours,
           IsWeekEnd: $scope.IsWeekEnd,
           IsNight: $scope.IsNight
       };
       UpdateShiftDetailsService.UpdateShiftDetails(ShiftInformation).then(function (data) {
                           
           if (data.data == "1") {
               $('#popupGeminiShiftInfo').modal('hide');
               misAlert("Shift Details Updated Successfully !", 'Success', 'success');
               $scope.GetShiftDetails();
           }
          
           if (data.data == "0") {
               misAlert('Error ! Unable to Update Shift Details, Please try again.', 'Error', 'error');
           }
       });
   }
    //Delete Shift Details  ------------------------------------------------------------------------------------------------------------------------------------------------//
   $scope.DeleteShiftDetails = function (shiftAbrhs) {

       misConfirm("Are you sure you want to delete ?", "Confirm", function (isConfirmed) {
           if (isConfirmed) {
               var delParms = { ShiftAbrhs: shiftAbrhs, userAbrhs: userLoginAbrhs };
               DeleteShiftDetailsService.DeleteShiftDetails(delParms).then(function (data) {
                                   
                   if (data.data == "true") {
                       misAlert("Shift Details Deleted Successfully !", 'Success', 'success');
                       $scope.GetShiftDetails();
                   }
                   if (data.data == "false") {
                       misAlert('Error ! Unable to delete Shift Details, Please try again.', 'Error', 'error');
                   }
               });
           }
       });
                  
   }

}]);

//--- To Get Data for Team Mapping List
misApp.service('ShiftInfoService', ['$http', 'UserService', function ($http, UserService) {
    this.GetShiftInfo = function () {
        return UserService.callToAngularApi(misApiUrl.listAllShift, 'POST');
    }
}]);
//---To Add/Update in Mapping Team with User details Details
misApp.service('SaveShiftDetailsService', ['$http', 'UserService', function ($http, UserService) {
    
    this.SaveShiftDetails = function (data) {
        return UserService.callToAngularApi(misApiUrl.addNewShift, 'POST', data);
    }
}]);
//---To Add/Update in Mapping Team with User details Details
misApp.service('UpdateShiftDetailsService', ['$http', 'UserService', function ($http, UserService) {
    
    this.UpdateShiftDetails = function (data) {
        return UserService.callToAngularApi(misApiUrl.updateShiftDetails, 'POST', data);
    }
}]);
//---To Add/Update in Mapping Team with User details Details
misApp.service('DeleteShiftDetailsService', ['$http', 'UserService', function ($http, UserService) {
    
    this.DeleteShiftDetails = function (data) {
        return UserService.callToAngularApi(misApiUrl.deleteShift, 'POST', data);
    }
}]);

//==============End of Shift Information Controller=====================================================================================================================================================//
//****************************************************************************************************************************************************************************************************//

misApp.service('UserService', ['$http', function ($http) {
    this.callToAngularApiWithHeader = function (url, method, data, headers) {
        return $http({
            url: url,
            method: method || 'GET',
            headers: headers || {},
            data: (typeof data != 'undefined') ? ((typeof method != 'undefined') ? (method.toLowerCase() == 'post' ? data : {}) : {}) : {},
            params: (typeof data != 'undefined') ? ((typeof method != 'undefined') ? (method.toLowerCase() == 'get' ? data : {}) : {}) : {},
            contentType: "application/json; charset=utf-8",
            dataType: "json",
        });
    }

    this.callToAngularApi = function (url, method, data) {
        var token = misSession.token;
        var userAbrhs = misSession.userabrhs;

        if (token && userAbrhs) {
            return this.callToAngularApiWithHeader(url, method, data, { 'Token': token, 'UserAbrhs': userAbrhs });
        }
        else {
            misSession.logout();
            redirectToURL(misAppUrl.login);
        }
    }
}]);