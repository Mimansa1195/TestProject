var misApp = angular.module('misApp', ['datatables']);

//------------------Team Information Controller---******************************************************************************************************************************************************//
misApp.controller('TeamManagementController', ['$scope', 'TeamManagementService', 'DTOptionsBuilder', 'WeekDayListService', 'DepartmentListService', 'TeamHeadListService', 'ParientTeamListService', 'TeamEmailTypesListService', 'SaveTeamDetailsService', 'DeleteTeamDetailsService', 'TeamEmailTypeMappingService', function ($scope, TeamManagementService, DTOptionsBuilder, WeekDayListService, DepartmentListService, TeamHeadListService, ParientTeamListService, TeamEmailTypesListService, SaveTeamDetailsService, DeleteTeamDetailsService, TeamEmailTypeMappingService) {
    
    $scope.showLoader = false;
    $scope.TeamList = [];
    $scope.IsSubTeam = false; 
    $scope.ShowAddReminderreptr = true;
    $scope.msg = "";
    $scope.TeamId = 0;
    $scope.showUpdate = false;
    $scope.showEmptyuserMap = false;
    $scope.show = false;

    $('#ddlTeamHead').select2();
    $('#ddlDepartment').select2();
    
    $scope.EmailType = 0;
    $scope.TeamHead = 0;
    $scope.WeekStartDay = 0;
    $scope.ParientTeam = 0;
    $scope.Department = 0;

    var userAbrhs = misSession.userabrhs;
  //  $scope.TeamList = [{ TeamName: "", WeekStartDay: "", TeamHead: "", Department: "", ParentTeam: "", }];
   // $scope.ReminderList = [{ Id: 0, ReminderName: "", Day: "", Week: 0, Time: 0 }];
    $scope.ReminderList = [{ TeamEmailTypeId: 0, TeamEmailTypeName: "", Sequence: 0, WeekDayId: 0, Week: 0, Time: "0:00" }];
   

    if ($scope.ReminderList.length == 1 && $scope.ReminderList[0].TeamEmailTypeName == "")
        $scope.ShowAddReminderreptr = false;
    else
        $scope.ShowAddReminderreptr = true;

    //-------Datatabloe column settings
    $scope.dtOptions = DTOptionsBuilder.newOptions().withDisplayLength(10).withOption('bLengthChange', true).withOption('responsive', true).withOption('bAutoWidth', false);
    
    //-----------Fetching Team Information List data from API-----------------------------------------------------------------------------------------------------------------------//
    $scope.GetTeamDetails = function () {
        
         $scope.show = true;
       // $.blockUI();
        TeamManagementService.GetTeamInformations().success(function (data) {            
           
            $scope.TeamList = data;
            $scope.show = false;
           // $.unblockUI();
        }).error(function (data) { misError(); });
    };
   
         
    //--------- DataTables configurable options------------------------------------------------------------------------------------------------------------------------------------//
  //  $scope.dtOptions = DTOptionsBuilder.newOptions().withDisplayLength(25).withOption('bLengthChange', true).withOption('responsive', true).withOption('bAutoWidth', false);
       
       
    //---View Team Details in popup div---------------------------------------------//
    $scope.ViewTeamDetails = function (index) {
       
        $('#popupGeminiViewTeamInfo').modal();
        $scope.record = $scope.TeamList[index];

        $scope.TeamName_m = $scope.record.TeamName;
        $scope.WeekStartDay_m = $scope.record.WeekStartDay;
        $scope.TeamHead_m = $scope.record.TeamHead;
        $scope.Department_m = $scope.record.Department;
        $scope.ParentTeam_m = $scope.record.ParentTeam;

        var teamAbrhs ={ teamAbrhs: $scope.record.TeamAbrhs};
        //------To Get Records from Team EmailType Mapping for a selected team based on TeamId
        TeamEmailTypeMappingService.GetTeamEmailTypeMapping(teamAbrhs).success(function (data) {
           
            $scope.TeamEmailTypeDetailbyTeamId = data;

        }).error(function (data) {
            
            misError();
        });

    };

    //---Fill Popup to Edit/Update Team Details in popup div---------------------------------------------//
    $scope.FillEditTeamDetails = function (i) {
               
        $('#popupGeminiTeamInfo').modal();
        //------Fill all Dropdowns--------------------------------------------//
        $scope.GetWeekDayList();
        $scope.GetDepartmentList();
        $scope.GetTeamHeadsList();
        $scope.GetParientTeamList();
        $scope.GetEmailTypesList();
        $scope.ShowAddReminderreptr = true;
        $scope.EmailType = 0;
        $scope.showUpdate = true;
        //--------------------------------------------------------------------//
        $scope.TeamId=$scope.TeamList[i].TeamId;
        $scope.TeamName = $scope.TeamList[i].TeamName;
        $scope.WeekStartDay = $scope.TeamList[i].WeekStartDayId;
        $scope.Department = $scope.TeamList[i].DepartmentId;
        $scope.TeamHead = $scope.TeamList[i].TeamHeadAbrhs;
        
        if ($scope.TeamList[i].ParentTeam != 0) {
            $scope.ParientTeam = $scope.TeamList[i].ParentTeamId;
            $scope.myVar = true;
        }
        $scope.EnableReminder = $scope.TeamList[i].IsReminderEmailsEnabled;
        $scope.EnableAttendanceEmails = $scope.TeamList[i].IsAttendanceEmailsEnabled;
               

        var teamAbrhs = $scope.TeamList[i].TeamAbrhs;
        var teamData = { teamAbrhs: teamAbrhs };
        ///-------------To Bind Dynamic Reminder List fromTeamEmailTypeMapping Table based on TeamId
        //------To Get Records from Team EmailType Mapping for a selected team based on TeamId
        TeamEmailTypeMappingService.GetTeamEmailTypeMapping(teamData).success(function (data) {
           
            $scope.TeamEmailTypeDetailbyTeamId = data;

            $scope.ReminderList = [];
            var single = $scope.TeamEmailTypeDetailbyTeamId;
            for (var i = 0; i < single.length; i++) {
                $scope.ReminderList.push({ TeamEmailTypeId: single[i].TeamEmailTypeId, TeamEmailTypeName: single[i].TeamEmailTypeName, Sequence: single[i].Sequence, WeekDayId: single[i].WeekDayId, Week: single[i].Week, Time: single[i].Time });
            }

        }).error(function (data) {
            
            misError();
        });

        
      

    };
    //---Fill Popup to Edit/Update Team Details in popup div---------------------------------------------//
    $scope.UpdateTeamDetails = function () {
       
        if (!validateControls('divManageTeam')) {
            return false;
        }
        var teamInformation = {
            TeamId: $scope.TeamId,
            TeamName: $scope.TeamName,
            TeamWeekDayId: $scope.WeekStartDay,
            IsReminderEmailEnabled: $scope.EnableReminder,
            IsAttendanceEmailEnabled: $scope.EnableAttendanceEmails,
            TeamHeadAbrhs: $scope.TeamHead,
            DepartmentId: $scope.Department,
            ParentTeamId: $scope.ParientTeam,
            UserAbrhs: userAbrhs,
            TeamEmailTypeDetail: $scope.ReminderList
        };
        SaveTeamDetailsService.SaveTeamDetail(teamInformation).then(function (data) {
                            
            if (data.data == "1") {
                $('#popupGeminiTeamInfo').modal('hide');
                misAlert("Team Details Updated Successfully !", 'Success', 'success');
                $scope.GetTeamDetails();
            }          
            if (data.data == "0") {
                misAlert('Error ! Unable to update Team Details, Please try again.', 'Error', 'error');
            }
        });
    };
    //---Delete Team Details from Main Grid---------------------------------------------//
    $scope.DeleteTeamDetails = function (i) {
               
        misConfirm("Are you sure you want to delete ?", "Confirm", function (isConfirmed) {
            if (isConfirmed) {
                var delParms = { teamAbrhs: $scope.TeamList[i].TeamAbrhs, userAbrhs: $scope.TeamList[i].UserAbrhs };

                DeleteTeamDetailsService.DeleteTeamDetail(delParms).then(function (data) {
                                    
                    if (data.data == "1") {
                        misAlert("Team Details Deleted Successfully !", 'Success', 'success');
                        $scope.GetTeamDetails();
                    }
                    if (data.data == "0") {
                        misAlert('Error ! Unable to delete Team Details, Please try again.', 'Error', 'error');
                    }
                });
            }
        });


       

      
       

    };
    //---Add Record in Team Details in popup div---------------------------------------------//
    $scope.AddNewTeamDetails = function () {
      
        if (!validateControls('divManageTeam')) {           
            return false;
        }
        var teamInformation = {
            TeamId: 0,
            TeamName: $scope.TeamName,
            TeamWeekDayId: $scope.WeekStartDay,
            IsReminderEmailEnabled: $scope.EnableReminder,
            IsAttendanceEmailEnabled: $scope.EnableAttendanceEmails,
            TeamHeadAbrhs: $scope.TeamHead,
            DepartmentId: $scope.Department,
            ParentTeamId: $scope.ParientTeam,
            UserAbrhs: userAbrhs,
            TeamEmailTypeDetail: $scope.ReminderList
        };
        SaveTeamDetailsService.SaveTeamDetail(teamInformation).then(function (data) {
                            
            if (data.data == "1") {
                $('#popupGeminiTeamInfo').modal('hide');
                misAlert("Team Details Added Successfully !", 'Success', 'success');
                $scope.GetTeamDetails();
                
            }
            if (data.data == "2") {
                misAlert("Sorry ! This Team is already present in our system.",'Warning','warning');
            }
            if (data.data == "0") {
                misAlert('Error ! Unable to add Team Details, Please try again.', 'Error', 'error');
            }
        });
    }
    //---View Team Details in popup div---------------------------------------------//
    $scope.AddNewTeamPopup = function (index) {
               
        $('#popupGeminiTeamInfo').modal();
        $scope.showUpdate = false;
        
        $scope.ReminderList = [{ TeamEmailTypeId: 0, TeamEmailTypeName: "", Sequence: 0, WeekDayId: 0, Week: 0, Time: null }];
        $scope.ShowAddReminderreptr = false;
        
        $scope.GetWeekDayList();
        $scope.GetDepartmentList();
        $scope.GetTeamHeadsList();
        $scope.GetParientTeamList();
        $scope.GetEmailTypesList();

        $scope.TeamName = "";
        $scope.EmailType = 0;
        $scope.TeamHead = 0;
        $scope.WeekStartDay = 0;
        $scope.ParientTeam = 0;
        $scope.Department = 0;

        $scope.EnableReminder = false;
        $scope.EnableAttendanceEmails = false;
        $scope.myVar = false;
    };
   

    //----------Fetch Data from week Days to bind Week Start Day dropdown-----------------------//
    $scope.GetWeekDayList = function () {
        WeekDayListService.GetWeekDayList().success(function (data) {
           
            $scope.WeekDayList = data;
            $scope.WeekDayList.unshift({ Value: 0, Text: "Select" });
        }).error(function (data) {
           
            misError();
        });
    }
    //----------Fetch Data from Departments table to bind Departments dropdown-----------------------//
    $scope.GetDepartmentList = function () {
        DepartmentListService.GetDepartmentList().success(function (data) {
           
            $scope.DepartmentList = data;
            $scope.DepartmentList.unshift({ Value: 0, Text: "Select" });
        }).error(function (data) {
            
            misError();
        });
    }
    //----------Fetch Data from Team Heads table to bind Team Heads dropdown-----------------------//
    $scope.GetTeamHeadsList = function () {
        TeamHeadListService.GetTeamHeadList().success(function (data) {
          
            $scope.TeamHeadList = data;
            $scope.TeamHeadList.unshift({ EmployeeAbrhs: 0, EmployeeName: "Select" });
        }).error(function (data) {
           
            misError();
        });
    }
    //----------Fetch Data from Parient Team table to bind Parient Team dropdown-----------------------//
    $scope.GetParientTeamList = function () {
        ParientTeamListService.GetParientTeamList().success(function (data) {
          
            $scope.ParientTeamList = data;
            $scope.ParientTeamList.unshift({ Value: 0, Text: "Select" });
        }).error(function (data) {
            
            misError();
        });
    }
    //----------Fetch Data from TeamEmailType table to bind TeamEmailType dropdown-----------------------//
    $scope.GetEmailTypesList = function () {
        TeamEmailTypesListService.GetTeamEmailTypesList().success(function (data) {
            
            $scope.EmailTypesList = data;
            $scope.EmailTypesList.unshift({ Value: 0, Text: "Select" });
        }).error(function (data) {
            
            misError();
        });
    }

    


    //----------Show/Hide Is sub Team dropdown-----------------------//
    $scope.ShowIsSubTeamddl = function () {
       
        if ($scope.IsSubChecked)
            $scope.IsSubTeam = true;
        else
            $scope.IsSubTeam = false;
    }
    //----------Dynamic Add a reminder in Popup like Reminder 1 , Reminder 2 etc.------------------------------------//
    $scope.DynamicAddReminderinPopup = function () {
          
         if ($scope.EmailType == 0) {
             $scope.msg = "Please Select at least one Email Type.";
             return false;
         }
         else {
             $scope.msg = "";
             var cnt = 0;
             var flag = false;
             var indx = 0;

             for (var j = 0; j < $scope.EmailTypesList.length; j++) {
                 if ($scope.EmailTypesList[j].Value == $scope.EmailType)
                     indx = $scope.EmailTypesList.indexOf($scope.EmailTypesList[j]);
             }

             var TypeName = $scope.EmailTypesList[indx].Text;

             for (var i = 0; i < $scope.ReminderList.length; i++) {

                 if ($scope.ReminderList[i].TeamEmailTypeId == $scope.EmailType) {
                     flag = true;
                     cnt++;
                 }
             }

             if (flag) {
                 $scope.ReminderList.push({ TeamEmailTypeId: $scope.EmailType, TeamEmailTypeName: TypeName, Sequence: cnt + 1, WeekDayId: 0, Week: 0, Time: "0:00" });
             }
             else {

                 if ($scope.ReminderList.length == 1 && $scope.ReminderList[0].TeamEmailTypeName == "") {
                     $scope.ReminderList.splice(0, 1);
                     $scope.ReminderList.push({ TeamEmailTypeId: $scope.EmailType, TeamEmailTypeName: TypeName, Sequence: 1, WeekDayId: 0, Week: 0, Time: "0:00" });
                 }
                 else {
                     $scope.ReminderList.push({ TeamEmailTypeId: $scope.EmailType, TeamEmailTypeName: TypeName, Sequence: 1, WeekDayId: 0, Week: 0, Time: "0:00" });
                 }
             }
         }
        $scope.ShowAddReminderreptr = true;
    }
    ////----------Remove from Dynamic Added reminder in Popup like Reminder 1 , Reminder 2 etc.------------------------------------//
    $scope.RemoveDynamicReminder = function (indx) {
       
        var TypeName = $scope.ReminderList[indx].TeamEmailTypeName;

        $scope.ReminderList.splice(indx, 1);

        //-------code to decrease reminder Secquence if existing more than once in the list
        if ($scope.ReminderList.length > 0)
        {
            var seq = 0;
            for (var i = 0; i < $scope.ReminderList.length; i++) {
                if($scope.ReminderList[i].TeamEmailTypeName==TypeName)
                {
                    seq++;
                    $scope.ReminderList[i].Sequence = seq;
                }
            }
        }

        if ($scope.ReminderList.length == 0) {
             $scope.ReminderList.push([{ TeamEmailTypeId: 0, TeamEmailTypeName: "", Sequence: 0, WeekDayId: 0, Week: 0, Time: 0 }]);
             $scope.ShowAddReminderreptr = false;
         }
         
    }


}]);

//--- To Get Data for Team Information List-------------------------------------------------------------//
misApp.service('TeamManagementService', ['$http', 'UserService', function ($http, UserService) {
    this.GetTeamInformations = function () {
        return UserService.callToAngularApi(misApiUrl.listAllTeams, 'POST');
    }
}]);
//--- To Get Data for Week Day List to Bind Week Start Day from API--------------------------------------------------//
misApp.service('WeekDayListService', ['$http', 'UserService', function ($http, UserService) {
    this.GetWeekDayList = function () {
        return UserService.callToAngularApi(misApiUrl.getWeekDays, 'POST');
    }
}]);
//--- To Get Data for Departments list --------------------------------------------------//
misApp.service('DepartmentListService', ['$http', 'UserService', function ($http, UserService) {
    this.GetDepartmentList = function () {
        return UserService.callToAngularApi(misApiUrl.getAllDepartments, 'POST');
    }
}]);
//--- To Get Data for Team Head List to Bind Team Head dropdown from API--------------------------------------------------//
misApp.service('TeamHeadListService', ['$http', 'UserService', function ($http, UserService) {
    this.GetTeamHeadList = function () {
        return UserService.callToAngularApi(misApiUrl.listAllActiveUsers, 'POST');
    }
}]);
//--- To Get Data for Team Head List to Bind Team Head dropdown from API--------------------------------------------------//
misApp.service('ParientTeamListService', ['$http', 'UserService', function ($http, UserService) {
    this.GetParientTeamList = function () {
        return UserService.callToAngularApi(misApiUrl.getTeams, 'POST');
    }
}]);
//--- To Get All Email Types to fill dropdown from API--------------------------------------------------//
misApp.service('TeamEmailTypesListService', ['$http', 'UserService', function ($http, UserService) {
    this.GetTeamEmailTypesList = function () {
        return UserService.callToAngularApi(misApiUrl.getTeamEmailTypes, 'POST');
    }
}]);
//--- To Get Data for Team Information List-------------------------------------------------------------//
misApp.service('TeamEmailTypeMappingService', ['$http', 'UserService', function ($http, UserService) {
    this.GetTeamEmailTypeMapping = function (data) {
        return UserService.callToAngularApi(misApiUrl.FetchTeamEmailTypeMapping, 'POST', data);
    }
}]);
//--- To Get All Email Types to fill dropdown from API--------------------------------------------------//

//---To Add/Update  new Team Details
misApp.service('SaveTeamDetailsService', ['$http', 'UserService', function ($http, UserService) {
   
    this.SaveTeamDetail = function (data) {
        return UserService.callToAngularApi(misApiUrl.addUpdateTeamDetails, 'POST', data);
    }
}]);
//---To Add/Update  new Team Details
misApp.service('DeleteTeamDetailsService', ['$http', 'UserService', function ($http, UserService) {
    
    this.DeleteTeamDetail = function (data) {
        return UserService.callToAngularApi(misApiUrl.deleteTeam, 'POST', data);
    }
}]);

//==============End of Team Information Controller=====================================================================================================================================================//
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