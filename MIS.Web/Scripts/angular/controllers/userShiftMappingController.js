var misApp = angular.module('misApp', ['datatables']);
var _SelectedfromDate, _SelectedendDate;

//-------------Start of User Shift Mapping Controller--******************************************************************************************************************************************************//
//====================================================================================================================================================================================================//
misApp.controller('UserShiftMappingController', ['$scope', 'TeamMappingServiceByDeptId', 'TeamMappingService', 'DeptMappingService', 'AllMappedUsersService', 'AllMappedUsersService', 'AllShiftListService', 'WeekListService', 'SaveShiftUserMappingService', 'DateIdsListService', 'AllShiftUserMappedListService', 'DeleteShiftUserMappingService', 'SearchShiftUserMappedListService', 'DTOptionsBuilder', function ($scope, TeamMappingServiceByDeptId, TeamMappingService, DeptMappingService, AllMappedUsersService, AllMappedUsersService, AllShiftListService, WeekListService, SaveShiftUserMappingService, DateIdsListService, AllShiftUserMappedListService, DeleteShiftUserMappingService, SearchShiftUserMappedListService, DTOptionsBuilder) {

    var userLoginAbrhs = misSession.userabrhs;
    $scope.AllWeekList = [{ WeekNo: 0, WeekDateString: "Select" }];
    $scope.ShiftAbrhs = "0";
    $scope.TeamAbrhs = "0";
    $scope.ddlDeptAbrhs = "0";
    $scope.Year = 0;
    $scope.WeekNo = 0;
    $scope.msgValidation = "";
    $scope.borderClass = "form-control myValClass";
    $scope.show = false;
    $scope.DeptAbrhsSrch = "0";
    $scope.TeamAbrhsSrch = 0;
    $scope.ShiftAbrhsSrch = 0;
    var year = (new Date()).getFullYear();
    $scope.YearSrch = year;
    $('#ddlTeamNameSrch').select2();
    $('#ddlShiftNameSrch').select2();
    $('#ddlYearSrch').select2();
    $('#ddlTeamName').select2();
    var d = new Date();
    var currentYear = d.getFullYear();

    $scope.YearList = [{ Id: 0, Year: "Select" }, { Id: currentYear - 1, Year: currentYear - 1 }, { Id: currentYear, Year: currentYear }];


    //--------- DataTables configurable options------------------------------------------------------------------------------------------------------------------------------------//
    $scope.dtOptions = DTOptionsBuilder.newOptions().withDisplayLength(10).withOption('bLengthChange', true).withOption('responsive', true).withOption('bAutoWidth', false);


    //------Check all checkboxes---------//
    $scope.CheckAll = function () {

        for (var i = 0; i < $scope.AllMappedUsersList.length; i++) {
            if ($scope.IsAllSelected) {
                $scope.AllMappedUsersList[i].IsSelected = true;
                $scope.Mappedmsg = "";
            }
            else
                $scope.AllMappedUsersList[i].IsSelected = false;
        }
    }

    $scope.setvalues = function () {
        for (var i = 0; i < $scope.AllMappedUsersList.length; i++) {
            $scope.AllMappedUsersList[i].ShiftAbrhs = $scope.ShiftAbrhs;
        }
    }

    //------Single checkbox click to hide message displayed---------//
    $scope.CheckSingle = function () { $scope.Mappedmsg = ""; }
    //---Get Mapped/UnMapped User List---------------------------------------------//
    $scope.GetShiftMappingDetails = function () {

        $scope.show = true;
        //var params = { UserAbrhs: userLoginAbrhs };
        //AllShiftUserMappedListService.GetShiftUserMappedList(params).success(function (data) {
            $scope.GetAllDeptList();
            $scope.GetAllTeamList();
            $scope.GetTeamSearchByDeptId();
            $scope.GetShiftList();
            $scope.GetShiftListwithAll();
            $scope.GetWeekListbyYearSearchOnLoad();
            $scope.show = false;
       
    }

    //---Get Mapped/UnMapped User List---------------------------------------------//
    $scope.SearchResult = function () {
        var valid = validateControls('divSearch');
        if (!valid) {
            return false;
        }
        $scope.show = true;  //  show processing Div
        var WeekDateList = new Array();
        var data = $("#ddlWeekNameSrch").val();
        var fromDate, endDate;
        if (data != null) {
            for (var i = 0; i < data.length - 1; i++) {
                for (var j = 0; j < $scope.AllWeekList.length; j++) {
                    if ($scope.AllWeekList[j].WeekNo == data[i]) {
                        indx = $scope.AllWeekList.indexOf($scope.AllWeekList[j]);
                        fromDate = $scope.AllWeekList[j].NewStartDate;
                        endDate = $scope.AllWeekList[j].NewEndDate;
                    }
                }
                var objWeek = { "WeekNo": data[i], "FromDate": fromDate, "ToDate": endDate };
                WeekDateList.push(objWeek);
            }
        }
        var params = { UserAbrhs: userLoginAbrhs, TeamAbrhs: $scope.TeamAbrhsSrch, ShiftAbrhs: $scope.ShiftAbrhsSrch, DateList: WeekDateList };
        //-----Search Records based on Team, Shift, Year and Week
        SearchShiftUserMappedListService.SearchShiftUserMappedList(params).success(function (data) {

            $scope.ShiftUserMappingList = data;

            $scope.GetAllTeamList();
            $scope.show = false;
        }).error(function (data) {
            misError();
        });

        //------Get Shift Name List with All option
    }

    $scope.GetShiftListwithAll = function () {

        AllShiftListService.GetAllShiftList().success(function (data) {

            $scope.AllMappedUsersListSearch = data;
            $scope.AllMappedUsersListSearch.unshift({ ShiftAbrhs: 0, ShiftName: "All" });

        }).error(function (data) {
            misError();
        });
    }
    //Show popup to Map Shift and User  ------------------------------------------------------------------------------------------------------------------------------------------------//
    $scope.ShowShiftMappingPopup = function () {

        $scope.GetAllDeptList();
        $scope.ddlDeptAbrhs = "0";

        $scope.GetTeamByDeptId();
        $scope.TeamAbrhs = "0";

        $scope.YearList = [{ Id: 0, Year: "Select" }, { Id: currentYear - 1, Year: currentYear - 1 }, { Id: currentYear, Year: currentYear }];
        $scope.Year = "0";

        $scope.AllWeekListData = 0;
        $scope.AllWeekListData=[{ WeekNo: 0, WeekDateString: "Select" }];
        $scope.WeekNo = "0";

        $("#popupGeminiShiftUserInfo").modal();
        $scope.IsAllSelected = false;
        $scope.TeamListPopup = $scope.TeamList;

        if ($scope.TeamListPopup.length > 0)
            $scope.TeamListPopup[0].TeamName = "Select";

        $scope.AllMappedUsersList = [];
        //$scope.showShiftUpdate = false;

       
      
       
     

        $scope.Mappedmsg = "";
    }

    $scope.GetWeekListbyYearForPopUp = function () {

        if ($scope.Year > 0) {
            var selectedYear = { userAbrhs: userLoginAbrhs, year: $scope.Year };

            WeekListService.GetWeekList(selectedYear).success(function (data) {

                $scope.AllWeekListData = data;
                $scope.AllWeekListData.unshift({ WeekNo: 0, WeekDateString: "Select" });
               
            }).error(function (data) {
                misError();
            });
        }
        else {
            misAlert('Please Select any Year to get weeks.', 'Warning', 'warning');
        }
    }

    //---Get All Team List---------------------------------------------//
    $scope.GetAllTeamList = function () {

        TeamMappingService.GetTeamMappingInformations().success(function (data) {

            $scope.TeamList = data;
            $scope.TeamList.unshift({ TeamAbrhs: 0, TeamName: "All" });


        }).error(function (data) {
            misError();
        });
    }

    $scope.GetTeamByDeptId = function () {
        var DeptIdAbrhs = $scope.ddlDeptAbrhs;
        var param = { DeptAbrhs: DeptIdAbrhs };
        TeamMappingServiceByDeptId.GetTeamMappingInformationsByDeptId(param).success(function (data) {

            $scope.TeamListByDept = data;
            $scope.TeamListByDept.unshift({ TeamAbrhsById: 0, TeamNameById: "Select" });


        }).error(function (data) {
            misError();
        });
    }

    $scope.GetTeamSearchByDeptId = function () {
        var DeptIdAbrhs = $scope.DeptAbrhsSrch;
        var param = { DeptAbrhs: DeptIdAbrhs };
        TeamMappingServiceByDeptId.GetTeamMappingInformationsByDeptId(param).success(function (data) {

            $scope.SearchTeamListByDept = data;
            $scope.SearchTeamListByDept.unshift({ TeamAbrhsById: 0, TeamNameById: "All" });

            $scope.TeamAbrhsSrch = "0";

        }).error(function (data) {
            misError();
        });
    }

    $scope.GetAllDeptList = function () {

        DeptMappingService.GetDeptMappingInformations().success(function (data) {

            $scope.DepartmentList = data;
            $scope.DepartmentList.unshift({ DeptAbrhs: 0, DeptName: "All" });

        }).error(function (data) {
            misError();
        });
    }

    //---Get Mapped User List based on TeamId---------------------------------------------//
    $scope.GetMappedUserDetails = function () {

        $scope.IsAllSelected = false;

        var selectedTeamId = { TeamAbrhs: $scope.TeamAbrhs };
        AllMappedUsersService.GetAllMappedUsers(selectedTeamId).success(function (data) {

            $scope.AllMappedUsersList = data;

            $scope.GetShiftList();

        }).error(function (data) {
            misError();
        });
    }

    //---Get Shift List to fill dropdown---------------------------------------------//
    $scope.GetShiftList = function () {

        AllShiftListService.GetAllShiftList().success(function (data) {

            $scope.AllShiftsList = data;
            $scope.AllShiftsList.unshift({ ShiftAbrhs: 0, ShiftName: "Select" });

            if ($scope.AllMappedUsersList != null) {
                for (var i = 0; i < $scope.AllMappedUsersList.length; i++) {
                    $scope.AllMappedUsersList[i].ShiftsList = $scope.AllShiftsList;
                    $scope.AllMappedUsersList[i].ShiftAbrhs = 0;
                }
            }

        }).error(function (data) {
            misError();
        });
    }

    $scope.GetWeekListbyYearSearchOnLoad = function () {
        $("#ddlWeekNameSrch").multiselect('destroy');
        $("#ddlWeekNameSrch").empty();
        $('#ddlWeekNameSrch').multiselect();
        if ($scope.YearSrch > 0) {
            var selectedYear = { userAbrhs: userLoginAbrhs, year: $scope.YearSrch };
            WeekListService.GetWeekList(selectedYear).success(function (result) {
                if (result != null && result.length > 0) {
                    for (var x = 0; x < result.length; x++) {
                        $("#ddlWeekNameSrch").append("<option value = '" + result[x].WeekNo + "'>" + result[x].WeekDateString + "</option>");
                    }
                    $scope.AllWeekList = result;
                    $('#ddlWeekNameSrch').multiselect("destroy");
                    $('#ddlWeekNameSrch').multiselect({
                        includeSelectAllOption: true,
                        enableFiltering: true,
                        enableCaseInsensitiveFiltering: true,
                        buttonWidth: false,
                        onDropdownHidden: function (event) {
                        }
                    });
                    $("#ddlWeekNameSrch").multiselect('selectAll', false);
                    $("#ddlWeekNameSrch").multiselect('updateButtonText');
                    $scope.SearchResult();
                }
                else {
                    $("#ddlWeekNameSrch").append("<option >No data found</option>");
                }

            }).error(function (result) {
                misError();
            });
        }

    }

    $scope.GetWeekListbyYearSearch = function () {
        $("#ddlWeekNameSrch").multiselect('destroy');
        $("#ddlWeekNameSrch").empty();
        $('#ddlWeekNameSrch').multiselect();
        if ($scope.YearSrch > 0) {
            var selectedYear = { userAbrhs: userLoginAbrhs, year: $scope.YearSrch };
            WeekListService.GetWeekList(selectedYear).success(function (result) {
                if (result != null && result.length > 0) {
                    for (var x = 0; x < result.length; x++) {
                        $("#ddlWeekNameSrch").append("<option value = '" + result[x].WeekNo + "'>" + result[x].WeekDateString + "</option>");
                    }
                    $scope.AllWeekList = result;
                    $scope.SearchResult();
                }
                else {
                    $("#ddlWeekNameSrch").append("<option >No data found</option>");
                }
                $('#ddlWeekNameSrch').multiselect("destroy");
                $('#ddlWeekNameSrch').multiselect({
                    includeSelectAllOption: true,
                    enableFiltering: true,
                    enableCaseInsensitiveFiltering: true,
                    buttonWidth: false,
                    onDropdownHidden: function (event) {
                    }
                });
                $("#ddlWeekNameSrch").multiselect('selectAll', false);
                $("#ddlWeekNameSrch").multiselect('updateButtonText');
            }).error(function (result) {
                misError();
            });
        }
    }

    //---Get Week List  by year to fill dropdown---------------------------------------------//
    $scope.DeleteUserShiftMappingDetails = function (MappingId) {

        misConfirm("Are you sure you want to delete?", "Confirm", function (isConfirmed) {
            if (isConfirmed) {
                var delParms = { MappingId: MappingId, userAbrhs: userLoginAbrhs };
                DeleteShiftUserMappingService.DeleteShiftUserMapping(delParms).then(function (data) {

                    if (data.data == "true") {
                        misAlert("User Shift Mapping Details Deleted Successfully!", 'Success', 'success');
                        $scope.GetShiftMappingDetails();
                    }
                    if (data.data == "false") {
                        misAlert('Error ! Unable to delete User Shift Mapping Details, Please try again.', 'Error', 'error');
                    }
                });
            }
        });

    }


    //---Save/Update Shift User Mapping details in Database---------------------------------------------//
    $scope.SaveShiftUserMappinginDB = function () {
        var valid = validateControls('divManageShiftUserMapping');
        if (!valid) {
            return false;
        }

        //------------Find out From Date and ToDate based on Week No selected-------------------------//
        var indx = 0;
        for (var j = 0; j < $scope.AllWeekList.length; j++) {
            if ($scope.AllWeekList[j].WeekNo == $scope.WeekNo)
                indx = $scope.AllWeekList.indexOf($scope.AllWeekList[j]);
        }
        _SelectedfromDate = $scope.AllWeekList[indx].StartDate;
        _SelectedendDate = $scope.AllWeekList[indx].EndDate;
        var variables = { fromDate: $scope.AllWeekList[indx].StartDate, ToDate: $scope.AllWeekList[indx].EndDate }
        //----------Get All Date Ids based on selected ween no or From Date to End Date--------------//
        DateIdsListService.GetDateIdsList(variables).success(function (data) {

            $scope.DateIdsList = data;
            //---Save in ShiftUserMapping Table after fetching all Date Ids---------------------------------//
            $scope.SaveShiftMappingList();

        }).error(function (data) {
            misError();
        });
    }

    $scope.SaveShiftMappingList = function () {
        var flag = false;
        var ShiftMapList = [{ DateId: 0, UserAbrhs: "", ShiftAbrhs: "", LoginUserAbrhs: userLoginAbrhs }];

        for (var i = 0; i < $scope.AllMappedUsersList.length; i++) {

            if ($scope.AllMappedUsersList[i].IsSelected) {
                $scope.Mappedmsg = "";
                for (var k = 0; k < $scope.DateIdsList.length; k++) {

                    var a = _SelectedfromDate.split("T");
                    var b = _SelectedendDate.split("T");
                    var date = a[0];
                    var date1 = b[0];

                    if (ShiftMapList.length == 1 && ShiftMapList[0].UserAbrhs == "")
                        ShiftMapList.splice(0, 1);
                    var message = " for the period " + date + "  to  " + date1;
                    ShiftMapList.push({ DateId: $scope.DateIdsList[k], DateF: date, DateT: date1, UserAbrhs: $scope.AllMappedUsersList[i].UserAbrhs, ShiftAbrhs: $scope.AllMappedUsersList[i].ShiftAbrhs, LoginUserAbrhs: userLoginAbrhs, Message: message });
                }
                flag = true;
            }
        }

        if (!flag) {
            $scope.Mappedmsg = "Please Select at least one user."
        }
        else {
            $scope.Mappedmsg = "";
            //----Call Add/Update function 
            SaveShiftUserMappingService.SaveShiftUserMapping(ShiftMapList).then(function (data) {

                if (data.data == "1") {
                    $('#popupGeminiShiftUserInfo').modal('hide');
                    misAlert("Shift User Mapping Added Successfully!", 'Success', 'success');
                    $scope.GetShiftMappingDetails();
                }
                if (data.data == "2") {
                    misAlert("Sorry ! Shift User Mapping Added Successfully!", 'Success', 'success');
                    $scope.GetShiftMappingDetails();
                }

                if (data.data == "0") {
                    misAlert('Error ! Unable to Shift User Mapping Details, Please try again.', 'Error', 'error');
                }
            });
        }
    }
}]);

//--- To Get All Mapped Users List based on selected Team 
misApp.service('AllShiftUserMappedListService', ['$http', 'UserService', function ($http, UserService) {
    this.GetShiftUserMappedList = function (data) {
        return UserService.callToAngularApi(misApiUrl.GetShiftUserMappingList, 'POST', data);
    }
}]);
//--- To Get Search Mapped Users List based on selected Search Items 
misApp.service('SearchShiftUserMappedListService', ['$http', 'UserService', function ($http, UserService) {
    this.SearchShiftUserMappedList = function (data) {
        return UserService.callToAngularApi(misApiUrl.SearchShiftUserMappingList, 'POST', data);
    }
}]);
//--- To Get All Mapped Users List based on selected Team 
misApp.service('AllMappedUsersService', ['$http', 'UserService', function ($http, UserService) {
    this.GetAllMappedUsers = function (data) {
        return UserService.callToAngularApi(misApiUrl.MappedUsersOfTeam, 'POST', data);
    }
}]);
//--- To Get All Shift List  
misApp.service('AllShiftListService', ['$http', 'UserService', function ($http, UserService) {
    this.GetAllShiftList = function () {
        return UserService.callToAngularApi(misApiUrl.GetShiftsList, 'POST', "");
    }
}]);
//--- Get Week List  by year to fill dropdown
misApp.service('WeekListService', ['$http', 'UserService', function ($http, UserService) {
    this.GetWeekList = function (data) {
        return UserService.callToAngularApi(misApiUrl.fetchWeekNoAndDates, 'POST', data);
    }
}]);
//--- To Get All DateIds List based on from Date and To Date  
misApp.service('DateIdsListService', ['$http', 'UserService', function ($http, UserService) {
    this.GetDateIdsList = function (data) {
        return UserService.callToAngularApi(misApiUrl.GetDateIdList, 'POST', data);
    }
}]);
//---To Add/Update in Shift User Mapping Details table
misApp.service('SaveShiftUserMappingService', ['$http', 'UserService', function ($http, UserService) {

    this.SaveShiftUserMapping = function (data) {
        return UserService.callToAngularApi(misApiUrl.AddUpdateShiftUserMapping, 'POST', data);
    }
}]);
//---To Delete single Shift mapping record based on MappingId
misApp.service('DeleteShiftUserMappingService', ['$http', 'UserService', function ($http, UserService) {

    this.DeleteShiftUserMapping = function (data) {
        return UserService.callToAngularApi(misApiUrl.DeleteShiftUserMapping, 'POST', data);
    }
}]);
//--- To Get Data for Team Mapping List
misApp.service('TeamMappingService', ['$http', 'UserService', function ($http, UserService) {
    this.GetTeamMappingInformations = function () {
        return UserService.callToAngularApi(misApiUrl.TeamsListforMapping, 'POST');
    }
}]);
misApp.service('TeamMappingServiceByDeptId', ['$http', 'UserService', function ($http, UserService) {
    this.GetTeamMappingInformationsByDeptId = function (data) {
        return UserService.callToAngularApi(misApiUrl.TeamsListforMappingByDeptId, 'POST', data);
    }
}]);

misApp.service('DeptMappingService', ['$http', 'UserService', function ($http, UserService) {
    this.GetDeptMappingInformations = function () {
        return UserService.callToAngularApi(misApiUrl.DeptListforMapping, 'POST');
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

