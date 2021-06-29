var _requestType; //1: active employee, 2: inactive employee, 3: new user
var _registrationId;
var personalDetail;

$(document).ready(function () {

    _registrationId = $("#hdnRegistrationId").val(),

        $("div.vertical-tab-menu>div.list-group>a").click(function (e) {
            e.preventDefault();
            $(this).siblings('a.active').removeClass("active");
            $(this).addClass("active");
            var index = $(this).index();
            $("div.vertical-tab>div.vertical-tab-content").removeClass("active");
            $("div.vertical-tab>div.vertical-tab-content").eq(index).addClass("active");
        });

    $('#btnBackToNewUserRegList').click(function () {
        loadNewUserRegistrationContainer();
    });

    $('#txtJoiningDateFromPicker').datepicker({
        autoclose: true,
        todayHighlight: true,
        endDate: toddmmyyyDatePicker(new Date()),
    }).on('changeDate', function (ev) {
       if ($("#empDesignationVerify").val()!=0) {
            var designationId = $("#empDesignationVerify").val();
            bindDataToBeUpdatedForNewUser(designationId);
        }
    });
    $("#txtJoiningDateFromPicker").datepicker("setDate", toddmmyyyDatePicker(new Date()));
    bindDesignationGroupDropDown();
    bindDesignationDropDown();
    bindDepartmentDropDown();
    bindRoleDropDown();
    //bindProbationPeriodDropDown();
    bindReportingManagerDropDown();
    loadUserRegistrationDetails();
    $("#actionDiv").hide();
});

function saveUserJoiningDetails() {
    if (!validateControls('verifyJoiningInfo')) {
        return false;
    }
    //alert(_registrationId + " " + $("#employeeId").val() + " " + $("#empDepartment").val() + " " + $("#empDesignation").val() + " " + $("#wsNo").val() + " " + $("#extensionNo").val() + " " + $("#accCardNo").val() + " " + $("#doj").val() + " " + $("#empReportingManager").val() + " " + $("#roleAbrhs").val());
    var jsonObject = {
        registrationId: _registrationId,//$("#hdnRegistrationId").val(),
        //misc details
        employeeId: $("#employeeIdVerify").val(),
        departmentAbrhs: $("#empDepartmentVerify").val(),
        designationAbrhs: $("#empDesignationVerify").val(),
        probationPeriod: $("#empProbationPeriodVerify").val(),
        teamId: $("#empTeamVerify").val(),
        wsNo: $("#wsNoVerify").val(),
        extensionNo: $("#extensionNoVerify").val(),
        //accCardNo: $("#accCardNoVerify").val(),
        doj: $("#dojVerify").val(),
        roleAbrhs: $("#empRoleVerify").val(),
        reportingManagerAbrhs: $("#empReportingManagerVerify").val(),
        redirectionLink: misAppUrl.passwordReset
    };
    calltoAjax(misApiUrl.saveNewUser, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            if (resultData.Success === 1) {
                misAlert("User joining detail and profile image have been saved", "Success", "success");
                $("#actionDiv").hide();
                $("#tblDataUpdatedForNewUser").html("");
                $("#verifyJoiningInfo :input").attr("disabled", true);
                personalDetail.UserId = resultData.UserId;
                personalDetail.IsUserCreated = resultData.IsUserCreated;
                personalDetail.DOJ = resultData.DOJ;
                personalDetail.EmployeeAbrhs = resultData.EmployeeAbrhs;
                $("#setDate").trigger("click");
            }
            else if (resultData.Success === 2) {
                misAlert("EmployeeId already exists. Please enter unique EmployeeId", "Warning", "warning");
            }
            else
                misAlert("Unable to process request. Please try again ", "Error", "error");
        });
}

function bindDepartmentDropDown() {
    $("#empDepartmentVerify").select2();
    $("#empDepartmentVerify").empty();
    $("#empDepartmentVerify").append("<option value=''>Select All</option>");
    calltoAjax(misApiUrl.getDepartments, "POST", '',
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $.each(resultData, function (idx, item) {
                $("#empDepartmentVerify").append($("<option></option>").val(item.DepartmentAbrhs).html(item.DepartmentName));
            });
        });

}

function bindDesignationGroupDropDown() {
    $("#empDesignationGroupVerify").select2();
    $("#empDesignationGroupVerify").empty();
    $("#empDesignationGroupVerify").append("<option value=''>Select All</option>");
    var jsonObject = {
        userAbrhs: misSession.userabrhs,
        isOnlyActive: true
    };
    calltoAjax(misApiUrl.getDesignationGroups, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $.each(resultData, function (idx, item) {
                $("#empDesignationGroupVerify").append($("<option></option>").val(item.EntityAbrhs).html(item.EntityName));
            });
        });

}

function onDesignationGroupChange() {
    bindDesignationDropDown();
}

function bindDesignationDropDown() {
    var jsonObject = {
        userAbrhs: misSession.userabrhs,
        desigGrpAbrhs: $("#empDesignationGroupVerify").val()
    };
    calltoAjax(misApiUrl.getDesignationsByDesigGrpId, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#empDesignationVerify").select2();
            $("#empDesignationVerify").empty();
            $("#empDesignationVerify").append("<option value=''>Select</option>");
            $.each(resultData, function (idx, item) {
                $("#empDesignationVerify").append($("<option></option>").val(item.DesignationAbrhs).html(item.Text));
            });
        });

}
function onDesignationChange() {
    var designationId = $('#empDesignationVerify').val()
    if(designationId!=0)
        bindProbationPeriodDropDown(designationId);
    $("#tblDataUpdatedForNewUser").empty();
    
}
function bindProbationPeriodDropDown(designationId) {
  var jsonObject = {
        designationAbrhs: designationId
    };
    calltoAjax(misApiUrl.getProbationPeriod, "POST", jsonObject,
        function (result) {
            $("#empProbationPeriodVerify").val(result);
        });
    bindDataToBeUpdatedForNewUser(designationId);
}
function bindDataToBeUpdatedForNewUser(designationId) {
    if (!designationId)
        return false;
   var jsonObject = {
        empDesignationAbrhs: designationId,
        joiningDate: $("#dojVerify").val()
    }
    calltoAjax(misApiUrl.lisLeaveBalanceForNewUser, "POST", jsonObject, function (result) {

        var resultdata = $.parseJSON(JSON.stringify(result));
       // var html = '<label class="control-label">Note:Old data to be replaced by new data</label>';
        html = '<table class="tbl-typical text-left">';
        if (resultdata) {
           html += '<tr class="bg-primary"><td>Leaves To Be Credited</td></tr>' +
                '<tr><td>CL: ' + (resultdata.NewClCount === null ? "NA" : resultdata.NewClCount) + '</td></tr>' +

                '<tr><td>PL: ' + (resultdata.NewPlCount === null ? "NA" : resultdata.NewPlCount) + '</td> </tr>' +

                '<tr><td>5 CLOY: ' + (resultdata.NewCloyAvailable === null ? "NA" : resultdata.NewCloyAvailable)  + '</td></tr>' 

                    }
        html += '</table>';
        $("#tblDataUpdatedForNewUser").html(html);
    });
}
function bindRoleDropDown() {
    calltoAjax(misApiUrl.getRoles, "POST", '',
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $.each(resultData, function (idx, item) {
                $("#empRoleVerify").append($("<option></option>").val(item.RoleAbrhs).html(item.RoleName));
            });
        });

}

function onDepartmentChange() {
    bindTeamDropDown();
    //bindReportingManagerDropDown();
}

function bindReportingManagerDropDown() {
    $("#empReportingManagerVerify").select2();
    $("#empReportingManagerVerify").empty();
    $("#empReportingManagerVerify").append("<option value=''>Select All</option>");
    //var jsonObject = {
    //    departmentAbrhs: $("#empDepartmentVerify").val(),
    //};
    calltoAjax(misApiUrl.listAllActiveUsers, "POST", ' ',
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $.each(resultData, function (idx, item) {
                $("#empReportingManagerVerify").append($("<option></option>").val(item.EmployeeAbrhs).html(item.EmployeeName));
            });
        });
}

function bindTeamDropDown() {
    $("#empTeamVerify").select2();
    $("#empTeamVerify").empty();

    var jsonObject = {
        departmentAbrhs: $("#empDepartmentVerify").val(),
    };
    calltoAjax(misApiUrl.getTeamsByDepartmentId, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $.each(resultData, function (idx, item) {
                $("#empTeamVerify").append($("<option></option>").val(item.Value).html(item.Text));
            });
        });

}

function loadUserRegistrationDetails() {

    var jsonObject = {
        registrationId: _registrationId,
    }
    calltoAjax(misApiUrl.getUserRegistrationDataById, "POST", jsonObject,
        function (result) {

            var resultData = $.parseJSON(JSON.stringify(result));

            if (resultData != null) {
                personalDetail = resultData.PersonalDetail;
                //populate personal details
                $("#userName").val(personalDetail.UserName);
                $("#officialEmail").val(personalDetail.OfficialEmailId);
                $("#personalEmail").val(personalDetail.PersonalEmailId);
                $("#firstName").val(personalDetail.FirstName);
                $("#middleName").val(personalDetail.MiddleName);
                $("#lastName").val(personalDetail.LastName);
                $("#mobileNo").val(personalDetail.MobileNumber);
                $("#emergencyNo").val(personalDetail.EmergencyContactNumber);
                $("#dob").val(personalDetail.DOB);
                $("#bloodGroup").val(personalDetail.BloodGroup);
                $("#gender").val(personalDetail.Gender);
                $("#maritalStatus").val(personalDetail.MaritalStatus);
                $("#EmpName").val(personalDetail.FirstName + ' ' + personalDetail.LastName);
                //populate bank details
                $("#panNo").val(personalDetail.PanNo);
                $("#aadhaarNo").val(personalDetail.AadhaarNo);
                $("#passportNo").val(personalDetail.PassportNo);
                $("#dLNo").val(personalDetail.DLNo);
                $("#voterIdNo").val(personalDetail.VoterIdNo);
                $("#photoVerify").fileinput({
                    //dropZoneEnabled: true,
                    initialPreviewAsData: true,
                    initialPreviewFileType: 'image',
                    //initialPreviewShowDelete: false,
                    //showUpload: false,
                    initialPreview: [personalDetail.PhotoFileName]
                });

                //$("#photoVerify").val(personalDetail.PhotoFileName);
                //$("#photoVerify").attr("data", personalDetail.PhotoFileName);
                //populate career details
                if (personalDetail.IsFresher != null) {
                    if (personalDetail.IsFresher == true) {
                        $("#jobExperience").val("Fresher");
                        $(".forExperienced").hide();
                        $("#lastEmployerName").removeClass("validation-required");
                        $("#lastEmployerLocation").removeClass("validation-required");
                        $("#lastJobDesignation").removeClass("validation-required");
                        $("#lastJobTenure").removeClass("validation-required");
                        $("#lastJobUan").removeClass("validation-required");
                        $("#jobLeavingReason").removeClass("validation-required");
                    }
                    else {
                        $("#jobExperience").val("Experienced");
                        $(".forExperienced").show();
                        $("#lastEmployerName").addClass("validation-required");
                        $("#lastEmployerLocation").addClass("validation-required");
                        $("#lastJobDesignation").addClass("validation-required");
                        $("#lastJobTenure").addClass("validation-required");
                        $("#lastJobUan").addClass("validation-required");
                        $("#jobLeavingReason").addClass("validation-required");

                        $("#lastEmployerName").val(personalDetail.LastEmployerName);
                        $("#lastEmployerLocation").val(personalDetail.LastEmployerLocation);
                        $("#lastJobDesignation").val(personalDetail.LastJobDesignation);
                        $("#lastJobTenure").val(personalDetail.LastJobTenure);
                        $("#lastJobUan").val(personalDetail.LastJobUAN);
                        $("#jobLeavingReason").val(personalDetail.JobLeavingReason);
                    }
                }


                //populate address details
                var addressDetail = resultData.AddressDetail;
                if (addressDetail.length > 0) {
                    for (var i = 0; i < addressDetail.length; i++) {
                        if (addressDetail[i].IsAddressPermanent == true) {
                            $("#permanentCountry").val(addressDetail[i].Country);
                            $("#permanentState").val(addressDetail[i].State);
                            $("#permanentCity").val(addressDetail[i].City);
                            $("#permanentAddress").val(addressDetail[i].Address);
                            $("#permanentPincode").val(addressDetail[i].PinCode);
                        }
                        else {
                            $("#presentCountry").val(addressDetail[i].Country);
                            $("#presentState").val(addressDetail[i].State);
                            $("#presentCity").val(addressDetail[i].City);
                            $("#presentAddress").val(addressDetail[i].Address);
                            $("#presentPincode").val(addressDetail[i].PinCode);
                        }
                    }
                }
            }
            else {
                misAlert("Unable to fetch data. Please try again ", "Error", "error");
            }
        });
}

function openPopupRejectUserRegDetails() {
    $("#popupRejectUserProfile").modal("show");
}

function rejectUserRegDetails() {
    if (!validateControls('modalRejectProfile')) {
        return false;
    }
    var jsonObject = {
        registrationId: _registrationId,
        reason: $("#rejectReason").val(),
        redirectionLink: misAppUrl.newUserRegistration
    };
    calltoAjax(misApiUrl.rejectUserProfile, "POST", jsonObject,
        function (result) {
            if (result) {
                $("#popupRejectUserProfile").modal("hide");
                loadNewUserRegistrationContainer();
                misAlert("Request processed successfully", "Success", "success");
                $('body').removeClass('modal-open');
                $('.modal-backdrop').remove();
            }
            else
                misAlert("Unable to process request. Try again", "Error", "error");
        });
}

function bindAccessCard() {
    $('#accessCardNo').select2();
    $('#accessCardNo').empty();
    $("#accessCardNo").append("<option value=''>Select</option>");

    calltoAjax(misApiUrl.getAllUnmappedAccessCard, "POST", '',
        function (result) {
            $.each(result, function (index, result) {
                $("#accessCardNo").append("<option value=" + result.Id + ">" + result.EntityName + "</option>");
            });
        });
}

//$("#btnClosePopupRejectUserProfile").click(function () {
//    $("#popupRejectUserProfile").modal("hide");
//})

$("#setJoiningInfo").click(function () {

    if (personalDetail.IsUserCreated === false) {
        $("#actionDiv").show();
    }
    else {
        $("#verifyJoiningInfo :input").attr("disabled", true);
        $("#actionDiv").hide();
        getUserJoiningDetail();
    }
});


$("#setDate").click(function () {
    if (personalDetail.UserId !== 0) {
        $('#assignDate').val(personalDetail.DOJ);
        $('#assignFromPicker').datepicker({
            autoclose: true,
            todayHighlight: true,
        }).datepicker('setStartDate', personalDetail.DOJ).datepicker('setEndDate', new Date());

        $("#hdnEmpId").val(personalDetail.EmployeeAbrhs);
        $("#empName").val(personalDetail.FirstName + ' ' + personalDetail.LastName);
        bindAccessCard();

    }

});

function verifyUserRegDetails() {
    var isPimco = false;
    if ($("#isPimco").is(':checked'))
        isPimco = true;
    if (!validateControls('accessCardMappingInfo')) {
        return false;
    }
    var jsonObject = {
        registrationId: _registrationId,
        accessCardId: $("#accessCardNo").val(),
        employeeAbrhs: $("#hdnEmpId").val(),
        fromDate: $('#assignDate').val(),
        isPimcoUser: isPimco,
        redirectionLink: misAppUrl.passwordReset
    };
    calltoAjax(misApiUrl.verifyUserRegDetails, "POST", jsonObject,
        function (result) {
            if (result === 1) {
                misAlert("User access card has been mapped successfully", "Success", "success");
                loadNewUserRegistrationContainer();
            }
            else
                misAlert("Unable to process request. Try again", "Error", "error");
        });

}


function getUserJoiningDetail() {
    var jsonObject = {
        employeeAbrhs: personalDetail.EmployeeAbrhs
    }
    calltoAjax(misApiUrl.getUserProfileDataByUserId, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            //populate joining details
            console.log(resultData.JoiningDetail);
            var joiningDetail = resultData.JoiningDetail;

            bindDepartmentDropDownNew(joiningDetail.DivisionId, joiningDetail.DepartmentId);
            bindTeamDropDownNew(joiningDetail.DepartmentId, joiningDetail.TeamId);
            bindDesigbationGroupDropDownNew(joiningDetail.DesignationGrpAbrhs);
            bindDesignationDropDownNew(joiningDetail.designationGroupAbrhs, joiningDetail.DesignationId)
            bindRoleDropDownNew(joiningDetail.RoleId);
            bindReportingManagerDropDownNew(joiningDetail.ReportingManagerId);
            $("#empProbationPeriodVerify").val(joiningDetail.ProbationPeriod);
            $("#employeeIdVerify").val(joiningDetail.EmployeeId);
            $("#dojVerify").val(joiningDetail.Doj);
            $("#wsNoVerify").val(joiningDetail.WsNo);
            $("#extensionNoVerify").val(joiningDetail.ExtensionNo);
            //$("#accCardNo").val(joiningDetail.AccCardNo);
        });
}




function bindDepartmentDropDownNew(divisionId, selectedId) {
   // $("#empDepartmentVerify").select2();
    $("#empDepartmentVerify").empty();
    var jsonObject = {
        divisionIds: divisionId,
    };
    calltoAjax(misApiUrl.getDepartmentByDivision, "POST", jsonObject,
        function (result) {
            $.each(result, function (idx, item) {
                $("#empDepartmentVerify").append($("<option></option>").val(item.Value).html(item.Text));
            });
            if (selectedId != 0) {
                $("#empDepartmentVerify").val(selectedId)
            }
        });
}

function bindTeamDropDownNew(departmentId, selectedId) {
    $("#empTeamVerify").empty();
    var jsonObject = {
        departmentIds: departmentId,
    };
    calltoAjax(misApiUrl.getTeamsByDepartment, "POST", jsonObject,
        function (result) {
            $.each(result, function (idx, item) {
                $("#empTeamVerify").append($("<option></option>").val(item.Value).html(item.Text));
            });
            if (selectedId != 0) {
                $("#empTeamVerify").val(selectedId)
            }
        });
}

function bindDesigbationGroupDropDownNew(desigGrpAbrhs) {
    var jsonObject = {
        userAbrhs: misSession.userabrhs,
        isOnlyActive: true
    };
    calltoAjax(misApiUrl.getDesignationGroups, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $.each(resultData, function (idx, item) {
                $("#empDesignationGroupVerify").append($("<option></option>").val(item.EntityAbrhs).html(item.EntityName));
            });

            $('#empDesignationGroupVerify').val(desigGrpAbrhs);
        });

}
function bindDesignationDropDownNew(desigGroupAbrhs, selectedId) {
    $("#empDesignationVerify").empty();
    $("#empDesignationVerify").append($("<option></option>").val(0).html("Select"));
    var jsonObject = {
        desigGrpAbrhs: desigGroupAbrhs,
    };
    calltoAjax(misApiUrl.getDesignationsByDesigGrpId, "POST", jsonObject,
        function (result) {
            $.each(result, function (idx, item) {
                $("#empDesignationVerify").append($("<option></option>").val(item.Value).html(item.Text));
            });
            if (selectedId != 0) {
                $("#empDesignationVerify").val(selectedId)
            }
        });

}

function bindRoleDropDownNew(selectedId) {
    $("#empRoleVerify").empty();
    calltoAjax(misApiUrl.getRoles, "POST", '',
        function (result) {
            $.each(result, function (idx, item) {
                $("#empRoleVerify").append($("<option></option>").val(item.RoleAbrhs).html(item.RoleName));
            });
            if (selectedId != 0) {
                $("#empRoleVerify").val(selectedId)
            }
        });
}

function bindReportingManagerDropDownNew(selectedId) {
    $("#empReportingManagerVerify").empty();
    calltoAjax(misApiUrl.listAllActiveUsers, "POST", '',
        function (result) {
            $.each(result, function (idx, item) {
                $("#empReportingManagerVerify").append($("<option></option>").val(item.EmployeeAbrhs).html(item.EmployeeName));
            });
            if (selectedId != 0) {
                $("#empReportingManagerVerify").val(selectedId)
            }
        });
}