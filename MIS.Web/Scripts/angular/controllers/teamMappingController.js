var misApp = angular.module('misApp', ['datatables']);

//-------------Start of Team Mapping Controller--******************************************************************************************************************************************************//
//====================================================================================================================================================================================================//
misApp.controller('TeamMappingController', ['$scope', 'TeamMappingService', 'AllMappedUserListService','SaveMappingDetailsService','TeamRoleService','DTOptionsBuilder', function ($scope, TeamMappingService, AllMappedUserListService,SaveMappingDetailsService,TeamRoleService, DTOptionsBuilder) {
    
    $scope.AllMappedUserList = [];
    $scope.msgsuccess = "";    
    $scope.custClass = "text-success";
    $scope.show = false;
        
    var userLoginAbrhs = misSession.userabrhs;
    
    //-------Datatabloe column settings
    $scope.dtOptions = DTOptionsBuilder.newOptions().withDisplayLength(10).withOption('bLengthChange', true).withOption('responsive', true).withOption('bAutoWidth', false);


    //Fetching data of All Mapping Teams------------------------------------------------------------------------------------------------------------------------------------------------//
    $scope.FillTealList = function () {
        $scope.show = true;
        TeamMappingService.GetTeamMappingInformations().success(function (data) {
            
            $scope.TeamMappingList = data;
            $scope.GetTeamRolsList();
            $scope.show = false;

        }).error(function (data) {
            misError();
        });
    }
    //----Bind RoleList on Page Load
   
   

    //Fetching All Mapped User data ------------------------------------------------------------------------------------------------------------------------------------------------//
    $scope.FillMappedUsers = function (TeamId,TeamName) {

        $("#popupGeminiTeamMapping").modal();
        var parms = { teamAbrhs: TeamId }
        $scope.MappedTeamName = TeamName;

        $scope.GetMappedUserDetails(parms);
       // $scope.GetUnMappedUserDetails(parms);       
    }
    //Fetching Team Role List ------------------------------------------------------------------------------------------------------------------------------------------------//
    $scope.GetTeamRolsList = function () {
       
        TeamRoleService.GetTeamRoleList().success(function (data) {
            
            $scope.TeamRoleList = data;
            $scope.TeamRoleList.unshift({ RoleAbrhs: 0, RoleName: "Select" });
        }).error(function (data) {
            misError();
        });
    }

    //---Get Mapped/UnMapped User List---------------------------------------------//
    $scope.GetMappedUserDetails = function (parms) {
        AllMappedUserListService.GetAllMappedUserList(parms).success(function (data) {
           
            $scope.AllMappedUserList = data;

            for (var i = 0; i < $scope.AllMappedUserList.length; i++)
            {   
                $scope.AllMappedUserList[i].RoleList = $scope.TeamRoleList;
                if (!$scope.AllMappedUserList[i].IsMapped)
                    $scope.AllMappedUserList[i].RoleAbrhs = 0;  
            }

        }).error(function (data) {
            misError();
        });
    }
   
    
    ///----------------Add Users in Mapped User List===============================================================================================================//
    $scope.AddinMappedUserlist = function () {
        
        var valid = validateControls('divManageTeamMapping');
        if (!valid) {
            return false;
        }
        var flag = false;
        var SelectedMappedUserList = [];

        for (var i = 0; i < $scope.AllMappedUserList.length; i++)
        {
            if ($scope.AllMappedUserList[i].IsSelected == true)
            {   
                SelectedMappedUserList.push($scope.AllMappedUserList[i])
                flag = true;
            }
        }
       
        //  Code To Update Mapped and Unmapped User list in Database-------------------------------------------------//
        if (!flag) {
            $scope.msgsuccess = "Please select atleast one User to Map.";
            $scope.custClass = "text-danger";
            return false;
        }
        else
            $scope.SaveTeamMappingDetail(SelectedMappedUserList);

    };

    ///--------------Remove Users from Mapped User List===============================================================================================================//
    $scope.RemoveFromMappedUserlist = function () {
        
        $scope.custClass = "text-danger";
        var SelectedMappedUserList = [];
        var flag = false;

         for (var i = 0; i < $scope.AllMappedUserList.length; i++) {
             if ($scope.AllMappedUserList[i].IsSelected==true)
             {
                 SelectedMappedUserList.push($scope.AllMappedUserList[i]);
                 flag = true;
             }
          
         }
        //  Code To Update Mapped and Unmapped User list in Database-------------------------------------------------//
         if (!flag) {
             $scope.msgsuccess = "Please select atleast one User to UnMap.";
             $scope.custClass = "text-danger";
             return false;
         }

        //--------------Update Mapping Table to Remove selected Users----------------------------------------------//
         $scope.custClass = "text-warning";
        
         var teamMappingInf = { UserAbrhs: userLoginAbrhs, TeamAbrhs: SelectedMappedUserList[0].TeamAbrhs, IsAdded: false, UserTeamList: [] };

         for (var i = 0; i < SelectedMappedUserList.length; i++) {

             teamMappingInf.UserTeamList.push({ EmployeeAbrhs: SelectedMappedUserList[i].UserAbrhs, ConsiderInClientReports: SelectedMappedUserList[i].ConsiderInClientReports, RoleAbrhs: SelectedMappedUserList[i].RoleAbrhs });
         }

         SaveMappingDetailsService.SaveTeamMappingDetails(teamMappingInf).then(function (data) {
           
             var result = data.data;
             if (result.Success == "1" ) {
                 $scope.msgsuccess = "User(s) has been unmapped successfully.";

                 for (var i = 0; i < SelectedMappedUserList.length; i++) {
                        var indx = $scope.AllMappedUserList.indexOf(SelectedMappedUserList[i])                                                  
                         $scope.AllMappedUserList[indx].IsMapped = false;
                         $scope.AllMappedUserList[indx].IsSelected = false;
                         $scope.AllMappedUserList[indx].ConsiderInClientReports = false;
                         $scope.AllMappedUserList[indx].RoleAbrhs = 0;                    
                 }
             }             
             if (result.Success == "0") {
                 misAlert('Error in processing, Please try again.', 'Error', 'error');
             }
         });
    };

    //---Add New User in User Team Mapping table in Database---------------------------------------------//
    $scope.SaveTeamMappingDetail = function (SelectedMappedUserList) {

        var teamMappingInf = { UserAbrhs: userLoginAbrhs, TeamAbrhs: SelectedMappedUserList[0].TeamAbrhs, IsAdded: true, UserTeamList: [] };

        for (var i = 0; i < SelectedMappedUserList.length; i++) {

            teamMappingInf.UserTeamList.push({ EmployeeAbrhs: SelectedMappedUserList[i].UserAbrhs, ConsiderInClientReports: SelectedMappedUserList[i].ConsiderInClientReports, RoleAbrhs: SelectedMappedUserList[i].RoleAbrhs });
        }

        SaveMappingDetailsService.SaveTeamMappingDetails(teamMappingInf).then(function (data) {
           
            var result = data.data;            

            if (result.Success == "1" && result.ExistingIds=="") {
                $scope.msgsuccess = "User(s) has been mapped successfully.";
                $scope.custClass = "text-success";
                for (var j = 0; j < SelectedMappedUserList.length; j++)
                {                   
                        var indx = $scope.AllMappedUserList.indexOf(SelectedMappedUserList[j])
                        $scope.AllMappedUserList[indx].IsMapped = true;
                        $scope.AllMappedUserList[indx].IsSelected = false;
                }
            }
            if (result.ExistingIds.length > 1) {

                var mapped = "";
                var unmapped = "";
                for (var j = 0; j < SelectedMappedUserList.length; j++) {
                    if (result.ExistingIds.indexOf(SelectedMappedUserList[j].UserAbrhs) < 0)
                    {
                        var indx = $scope.AllMappedUserList.indexOf(SelectedMappedUserList[j])
                        $scope.AllMappedUserList[indx].IsMapped = true;                        
                        $scope.AllMappedUserList[indx].IsSelected = false;
                        
                        if (mapped == "")
                            mapped = $scope.AllMappedUserList[indx].Name;
                        else
                            mapped = mapped + "," + $scope.AllMappedUserList[indx].Name;
                    }
                    else
                    {
                        var idx = $scope.AllMappedUserList.indexOf(SelectedMappedUserList[j])
                        $scope.AllMappedUserList[idx].IsSelected = false;
                        $scope.AllMappedUserList[idx].ConsiderInClientReports = false;
                        $scope.AllMappedUserList[idx].RoleAbrhs = 0;

                        if (unmapped == "")
                            unmapped = $scope.AllMappedUserList[idx].Name;
                        else
                            unmapped = unmapped + "," + $scope.AllMappedUserList[idx].Name;
                    }
                }

                if (mapped == "")
                    misAlert("User(s) (" + unmapped + ") already mapped with other Team, Please unmap selected user(s) before mapping to " + $scope.MappedTeamName + " team.", 'Warning', 'warning');
                else
                    misAlert("(" + mapped + ") is mapped with " + $scope.MappedTeamName + " team.<br />User(s) (" + unmapped + ") already mapped with other Team, Please unmap selected user(s) before mapping to " + $scope.MappedTeamName + " team.", 'Warning', 'warning');
            }
            if (result.Success == "0") {
                misAlert('Error in processing, Please try again.', 'Error', 'error');
            }
        });
    }

}]);


//--- To Get Data for Team Mapping List
misApp.service('TeamMappingService', ['$http', 'UserService', function ($http, UserService) {
    this.GetTeamMappingInformations = function () {
        return UserService.callToAngularApi(misApiUrl.TeamsListforMapping, 'POST');
    }
}]);
//--- To Get All Mapped Users List 
misApp.service('AllMappedUserListService', ['$http', 'UserService', function ($http, UserService) {
    this.GetAllMappedUserList = function (data) {
        return UserService.callToAngularApi(misApiUrl.listMappedUserToTeam, 'POST', data);
    }
}]);
//---To Add/Update in Mapping Team with User details Details
misApp.service('SaveMappingDetailsService', ['$http', 'UserService', function ($http, UserService) {
    
    this.SaveTeamMappingDetails = function (data) {
        return UserService.callToAngularApi(misApiUrl.insertNewUserTeamMapping, 'POST', data);
    }
}]);
//--- To Get Team Role List
misApp.service('TeamRoleService', ['$http', 'UserService', function ($http, UserService) {
    this.GetTeamRoleList = function () {
        return UserService.callToAngularApi(misApiUrl.GetTeamRoles, 'POST');
    }
}]);
//==============End of Team Mapping Controller=====================================================================================================================================================//
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