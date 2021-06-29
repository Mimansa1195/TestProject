var _requestType; //1: active employee, 2: inactive employee, 3: new user
var _employeeAbrhs;
var _rm = "";
$(document).ready(function () {
    _employeeAbrhs = $("#hdnEmployeeAbrhs").val(),
        _requestType = $("#requestType").val();

    if (_requestType == 2)
        $(".btnSaveUserProfile").hide();
    else
        $(".btnSaveUserProfile").show();
    $("div.vertical-tab-menu>div.list-group>a").click(function (e) {
        e.preventDefault();
        $(this).siblings('a.active').removeClass("active");
        $(this).addClass("active");
        var index = $(this).index();
        $("div.vertical-tab>div.vertical-tab-content").removeClass("active");
        $("div.vertical-tab>div.vertical-tab-content").eq(index).addClass("active");
    });

    $('#btnBackToActiveUserList').click(function () {
        loadActiveEmployeeContainer();
    });

    $('#btnBackToInActiveUserList').click(function () {
        loadInactiveEmployeeContainer();
    });

    loadUserProfileDetails();

});

function removeAlphabets(e) {
    $("#" + e.id).val($("#" + e.id).val().replace(/\D/g, ''));
}

function saveAndContinue(tabNumber) {
    switch (tabNumber) {
        case 1:
            if (!validateControls("personalInfoEdit"))
                return false;

            if ($("#mobileNo").val().length < 10) {
                misAlert("Please enter valid mobile number.", "Warning", "warning");
                return false;
            }

            if ($("#emergencyNo").val().length < 10) {
                misAlert("Please enter valid emergency number.", "Warning", "warning");
                return false;
            }

            var jsonObject = {
                UserName: $("#userName").val(),
                OfficialEmalId: $("#officialEmail").val(),
                PersonalEmailId: $("#personalEmail").val(),
                FirstName: $("#firstName").val(),
                MiddleName: $("#middleName").val(),
                LastName: $("#lastName").val(),
                MobileNumber: $("#mobileNo").val(),
                EmergencyContactNumber: $("#emergencyNo").val(),
                DOB: $("#dob").val(),
                BloodGroup: $("#bloodGroup").val(),
                GenderId: $("#gender").val(),
                MaritalStatusId: $("#maritalStatus").val(),
                UserAbrhs: misSession.userabrhs,
                EmployeeAbrhs: _employeeAbrhs,
            };
            calltoAjax(misApiUrl.editUserPersonalInfo, "POST", jsonObject,
                function (result) {
                    var resultData = $.parseJSON(JSON.stringify(result));
                    if (resultData) {
                        misAlert("Information saved successfully", "Success", "success");
                        $($("div.vertical-tab-menu>div.list-group>a")[tabNumber]).trigger("click");
                    }
                    else
                        misAlert("Unable to save data. Please try again", "Error", "error");
                });
            break;
        case 2:
            if (!validateControls("addressInfoEdit"))
                return false;

            if ($("#presentPincode").val().length < 6) {
                misAlert("Please enter valid present pincode.", "Warning", "warning");
                return false;
            }

            if ($("#permanentPincode").val().length < 6) {
                misAlert("Please enter valid permanent pincode.", "Warning", "warning");
                return false;
            }

            var jsonObject = [
                {

                    CountryId: $("#presentCountry").val(),
                    StateId: $("#presentState").val(),
                    CityId: $("#presentCity").val(),
                    Address: $("#presentAddress").val(),
                    PinCode: $("#presentPincode").val(),
                    IsAddressPermanent: false,
                    UserAbrhs: misSession.userabrhs,
                    EmployeeAbrhs: _employeeAbrhs,
                },
                {

                    CountryId: $("#permanentCountry").val(),
                    StateId: $("#permanentState").val(),
                    CityId: $("#permanentCity").val(),
                    Address: $("#permanentAddress").val(),
                    PinCode: $("#permanentPincode").val(),
                    IsAddressPermanent: true,
                    UserAbrhs: misSession.userabrhs,
                    EmployeeAbrhs: _employeeAbrhs,
                }
            ];
            calltoAjax(misApiUrl.editUserAddressInfo, "POST", jsonObject,
                function (result) {
                    var resultData = $.parseJSON(JSON.stringify(result));
                    if (resultData) {
                        misAlert("Information saved successfully", "Success", "success");
                        $($("div.vertical-tab-menu>div.list-group>a")[tabNumber]).trigger("click");
                    }
                    else
                        misAlert("Unable to save data. Please try again", "Error", "error");
                });
            break;
        case 3:
            if (!validateControls("careerInfoEdit"))
                return false;
            var jsonObject = {
                IsFresher: $("#jobExperience").val() == 1 ? true : false,
                LastEmployerName: $("#lastEmployerName").val(),
                LastEmployerLocation: $("#lastEmployerLocation").val(),
                LastJobDesignation: $("#lastJobDesignation").val(),
                LastJobTenure: $("#lastJobTenure").val(),
                LastJobUAN: $("#lastJobUan").val(),
                JobLeavingReason: $("#jobLeavingReason").val(),
                UserAbrhs: misSession.userabrhs,
                EmployeeAbrhs: _employeeAbrhs,
            };
            calltoAjax(misApiUrl.editUserCareerInfo, "POST", jsonObject,
                function (result) {
                    var resultData = $.parseJSON(JSON.stringify(result));
                    if (resultData) {
                        misAlert("Information saved successfully", "Success", "success");
                        $($("div.vertical-tab-menu>div.list-group>a")[tabNumber]).trigger("click");
                    }
                    else
                        misAlert("Unable to save data. Please try again", "Error", "error");
                });
            break;
        case 4:
            if (!validateControls("bankInfoEdit"))
                return false;
            var jsonObject = {
                PanNo: $("#panNo").val(),
                AadhaarNo: $("#aadhaarNo").val(),
                PassportNo: $("#passportNo").val(),
                DLNo: $("#dLNo").val(),
                VoterIdNo: $("#voterIdNo").val(),
                UserAbrhs: misSession.userabrhs,
                EmployeeAbrhs: _employeeAbrhs,
            };
            calltoAjax(misApiUrl.editUserBankInfo, "POST", jsonObject,
                function (result) {
                    var resultData = $.parseJSON(JSON.stringify(result));
                    if (resultData) {
                        misAlert("Information saved successfully", "Success", "success");
                        $($("div.vertical-tab-menu>div.list-group>a")[tabNumber]).trigger("click");
                    }
                    else
                        misAlert("Unable to save data. Please try again", "Error", "error");
                });
            break;
        case 5:
            if (!validateControls("joiningInfoEdit"))
                return false;
            var jsonObject = {
                EmployeeId: $("#employeeId").val(),
                TeamId: $("#empTeam").val(),
                DepartmentId: $("#empDepartment").val(),
                DesignationId: $("#empDesignation").val(),
                WsNo: $("#wsNo").val(),
                ExtensionNo: $("#extensionNo").val(),
                //AccCardNo: $("#accCardNo").val(),
                Doj: $("#doj").val(),
                //TerminationDate: $("#dot").val(),
                RoleId: $("#empRole").val(),
                ReportingManagerId: $("#empReportingManager").val(),
                ProbationPeriod: $("#empProbationPeriod").val(),
                UserAbrhs: misSession.userabrhs,
                EmployeeAbrhs: _employeeAbrhs,
            };
            calltoAjax(misApiUrl.editUserJoiningInfo, "POST", jsonObject,
                function (result) {
                    var resultData = $.parseJSON(JSON.stringify(result));
                    if (resultData) {
                        misAlert("Information saved successfully", "Success", "success");
                        $("#tblPendingData").empty();
                        //$($("div.vertical-tab-menu>div.list-group>a")[tabNumber]).trigger("click");
                    }
                    else
                        misAlert("Unable to save data. Please try again", "Error", "error");
                });
            break;
    }
}

function isNumber(event) {
    event = (event) ? event : window.event;
    var charCode = (event.which) ? event.which : event.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
        return false;
    }
    return true;
}

function onJobExperienceChange() {
    if ($("#jobExperience").val() == 2)    //for experienced
    {
        $(".forExperienced").show();
        $("#lastEmployerName").addClass("validation-required");
        $("#lastEmployerLocation").addClass("validation-required");
        $("#lastJobDesignation").addClass("validation-required");
        $("#lastJobTenure").addClass("validation-required");
        $("#lastJobUan").addClass("validation-required");
        $("#jobLeavingReason").addClass("validation-required");
    }
    else {    //for fresher
        $(".forExperienced").hide();
        $("#lastEmployerName").removeClass("validation-required");
        $("#lastEmployerLocation").removeClass("validation-required");
        $("#lastJobDesignation").removeClass("validation-required");
        $("#lastJobTenure").removeClass("validation-required");
        $("#lastJobUan").removeClass("validation-required");
        $("#jobLeavingReason").removeClass("validation-required");

        $("#lastEmployerName").val("");
        $("#lastEmployerLocation").val("");
        $("#lastJobDesignation").val("");
        $("#lastJobTenure").val("");
        $("#lastJobUan").val("");
        $("#jobLeavingReason").val("");
    }
}

function loadUserProfileDetails() {
    var jsonObject = {
        employeeAbrhs: _employeeAbrhs,
    }
    calltoAjax(misApiUrl.getUserProfileDataByUserId, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            if (resultData != null) {
                var personalDetail = resultData.PersonalDetail;
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
                $('#txtdobFromPicker').datepicker({
                    format: "mm/dd/yyyy",
                    autoclose: true,
                    todayHighlight: true
                }).datepicker('setEndDate', new Date())
                $("#bloodGroup").val(personalDetail.BloodGroup);
                bindGenderDropDown(personalDetail.GenderId);//$("#gender").val(personalDetail.GenderId);
                bindMaritalStatusDropDown(personalDetail.MaritalStatusId);//$("#maritalStatus").val(personalDetail.MaritalStatusId);

                //populate bank details
                $("#panNo").val(personalDetail.PanNo);
                $("#aadhaarNo").val(personalDetail.AadhaarNo);
                $("#passportNo").val(personalDetail.PassportNo);
                $("#dLNo").val(personalDetail.DLNo);
                $("#voterIdNo").val(personalDetail.VoterIdNo);

                //populate career details
                if (personalDetail.IsFresher != null) {
                    if (personalDetail.IsFresher == true) {
                        $("#jobExperience").val(1);
                        $(".forExperienced").hide();
                        $("#lastEmployerName").removeClass("validation-required");
                        $("#lastEmployerLocation").removeClass("validation-required");
                        $("#lastJobDesignation").removeClass("validation-required");
                        $("#lastJobTenure").removeClass("validation-required");
                        $("#lastJobUan").removeClass("validation-required");
                        $("#jobLeavingReason").removeClass("validation-required");
                    }
                    else {
                        $("#jobExperience").val(2);
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

                            bindCountryDropDown(addressDetail[i].CountryId, 0);
                            permanentCountryChangeEdit(addressDetail[i].CountryId, addressDetail[i].StateId);
                            permanentStateChangeEdit(addressDetail[i].StateId, addressDetail[i].CityId)

                            $("#permanentAddress").val(addressDetail[i].Address);
                            $("#permanentPincode").val(addressDetail[i].PinCode);
                        }
                        else {
                            bindCountryDropDown(0, addressDetail[i].CountryId);
                            presentCountryChangeEdit(addressDetail[i].CountryId, addressDetail[i].StateId);
                            presentStateChangeEdit(addressDetail[i].StateId, addressDetail[i].CityId)

                            $("#presentAddress").val(addressDetail[i].Address);
                            $("#presentPincode").val(addressDetail[i].PinCode);
                        }
                    }
                }
                //populate joining details
                var joiningDetail = resultData.JoiningDetail;
                // bindProbationPeriodDropDown(joiningDetail.DesignationId);
                _rm = joiningDetail.ReportingManagerId;
                bindDivisionDropDown(joiningDetail.DivisionId);
                bindDepartmentDropDown(joiningDetail.DivisionId, joiningDetail.DepartmentId);
                bindTeamDropDown(joiningDetail.DepartmentId, joiningDetail.TeamId);
                bindDesignationGrpDropDown(joiningDetail.DesignationGrpAbrhs);
                bindDesignationDropDown(joiningDetail.DesignationGrpAbrhs, joiningDetail.DesignationId)
                bindRoleDropDown(joiningDetail.RoleId);
                bindReportingManagerDropDown(joiningDetail.ReportingManagerId);
                $("#empProbationPeriod").val(joiningDetail.ProbationPeriod);
                $("#employeeId").val(joiningDetail.EmployeeId);
                $("#doj").val(joiningDetail.Doj);
                $("#wsNo").val(joiningDetail.WsNo);

                $("#extensionNo").val(joiningDetail.ExtensionNo);
                //$("#accCardNo").val(joiningDetail.AccCardNo);
                $("#dot").val(joiningDetail.TerminationDate);
                $('#txtDateOfJoining').datepicker({
                    format: "mm/dd/yyyy",
                    autoclose: true,
                    todayHighlight: true
                }).datepicker('setEndDate', new Date())/*.on('changeDate', function (ev) {*/
                //var fromStartDate = ev.date;
                //$('#dot').val('');
                //$('#dot').datepicker('setStartDate', fromStartDate).trigger('change');
                //});

                //$('#dot').datepicker({  
                //    format: "mm/dd/yyyy",
                //    autoclose: true,
                //    todayHighlight: true
                //}).datepicker('setStartDate', $('#doj').val()).datepicker('setEndDate', new Date());

            }
            else {
                misAlert("Unable to fetch data. Please try again ", "Error", "error")
            }
        });
}

//binding drop downs

$("#empDivision").change(function () {
    bindDepartmentDropDown($("#empDivision").val(), 0)

});

$("#empDepartment").change(function () {
    bindTeamDropDown($("#empDepartment").val(), 0)
});

function bindDivisionDropDown(selectedId) {
    $("#empDivision").select2();
    $("#empDivision").empty();
    $("#empDivision").append($("<option></option>").val(0).html("Select"));

    var jsonObject = {
        verticalId: 1,
    };
    calltoAjax(misApiUrl.getDivisionByVertical, "POST", jsonObject,
        function (result) {
            $.each(result, function (idx, item) {
                $("#empDivision").append($("<option></option>").val(item.Value).html(item.Text));
            });
            if (selectedId != 0) {
                $("#empDivision").val(selectedId)
            }
        });
}

function bindDepartmentDropDown(divisionId, selectedId) {
    $("#empDepartment").select2();
    $("#empDepartment").empty();
    $("#empDepartment").append($("<option></option>").val(0).html("Select"));
    var jsonObject = {
        divisionIds: divisionId,
    };
    calltoAjax(misApiUrl.getDepartmentByDivision, "POST", jsonObject,
        function (result) {
            $.each(result, function (idx, item) {
                $("#empDepartment").append($("<option></option>").val(item.Value).html(item.Text));
            });
            if (selectedId != 0) {
                $("#empDepartment").val(selectedId)
            }
        });
}
function bindTeamDropDown(departmentId, selectedId) {
    $("#empTeam").select2();
    $("#empTeam").empty();
    $("#empTeam").append($("<option></option>").val(0).html("Select"));
    var jsonObject = {
        departmentIds: departmentId,
    };
    calltoAjax(misApiUrl.getTeamsByDepartment, "POST", jsonObject,
        function (result) {
            $.each(result, function (idx, item) {
                $("#empTeam").append($("<option></option>").val(item.Value).html(item.Text));
            });
            if (selectedId != 0) {
                $("#empTeam").val(selectedId)
            }
        });
}

function bindDesignationGrpDropDown(DesigGrpAbrhs) {
    var jsonObject = {
        userAbrhs: misSession.userabrhs,
        isOnlyActive: false
    };
    calltoAjax(misApiUrl.getDesignationGroups, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $.each(resultData, function (idx, item) {
                $("#empDesignationGroup").append($("<option></option>").val(item.EntityAbrhs).html(item.EntityName));
            });

            $('#empDesignationGroup').val(DesigGrpAbrhs);
        });
}

function OnChangeDesigGroup() {
    var desigGroupAbrhs = $('#empDesignationGroup').val()
    bindDesignationDropDown(desigGroupAbrhs, 0);
}

function bindDesignationDropDown(desigGroupAbrhs, selectedId) {
    $("#empDesignation").select2();
    $("#empDesignation").empty();
    $("#empDesignation").append($("<option></option>").val(0).html("Select"));
    var jsonObject = {
        desigGrpAbrhs: desigGroupAbrhs,
    };
    calltoAjax(misApiUrl.getDesignationsByDesigGrpId, "POST", jsonObject,
        function (result) {
            $.each(result, function (idx, item) {
                $("#empDesignation").append($("<option></option>").val(item.Value).html(item.Text));
            });
            if (selectedId != 0) {
                $("#empDesignation").val(selectedId)
            }
            else {
                $("#empDesignation").val(0);
            }
        });

}

function bindRoleDropDown(selectedId) {
    $("#empRole").select2();
    $("#empRole").empty();
    $("#empRole").append($("<option></option>").val(0).html("Select"));

    calltoAjax(misApiUrl.getRoles, "POST", '',
        function (result) {
            $.each(result, function (idx, item) {
                $("#empRole").append($("<option></option>").val(item.RoleAbrhs).html(item.RoleName));
            });
            if (selectedId != 0) {
                $("#empRole").val(selectedId)
            }
        });
}

function bindReportingManagerDropDown(selectedId) {
    _rm = selectedId;
    $("#empReportingManager").select2();
    $("#empReportingManager").empty();
    $("#empReportingManager").append($("<option></option>").val(0).html("Select"));

    calltoAjax(misApiUrl.listAllActiveUsers, "POST", '',
        function (result) {
            $.each(result, function (idx, item) {
                $("#empReportingManager").append($("<option></option>").val(item.EmployeeAbrhs).html(item.EmployeeName));
            });
            if (selectedId != 0) {
                $("#empReportingManager").val(selectedId)
            }
        });

}
//function onDesignationChange() {
//    var designationId = $('#empDesignation').val()
//    //bindProbationPeriodDropDown(designationId);
//}
//function bindProbationPeriodDropDown(designationId) {
//   var jsonObject = {
//        designationId: designationId
//    };
//    calltoAjax(misApiUrl.getProbationPeriod, "POST", jsonObject,
//        function (result) {
//            $("#empProbationPeriod").val(result);
//            });
//}
function bindGenderDropDown(selectedId) {
    $("#gender").empty();
    $("#gender").append($("<option></option>").val(0).html("Select"));

    calltoAjax(misApiUrl.getGender, "POST", '',
        function (result) {
            $.each(result, function (idx, item) {
                $("#gender").append($("<option></option>").val(item.Value).html(item.Text));
            });
            if (selectedId > 0) {
                $("#gender").val(selectedId)
            }
        });
}

function bindMaritalStatusDropDown(selectedId) {
    $("#maritalStatus").empty();
    $("#maritalStatus").append($("<option></option>").val(0).html("Select"));

    calltoAjax(misApiUrl.getMaritalStatus, "POST", '',
        function (result) {
            $.each(result, function (idx, item) {
                $("#maritalStatus").append($("<option></option>").val(item.Value).html(item.Text));
            });
            if (selectedId > 0) {
                $("#maritalStatus").val(selectedId)
            }
        });
}

function bindCountryDropDown(percSelectedId, precSelectedId) {
    $("#presentCountry").select2();
    $("#presentCountry").empty();
    $("#presentCountry").append($("<option></option>").val(0).html("Select"));
    $("#permanentCountry").select2();
    $("#permanentCountry").empty();
    $("#permanentCountry").append($("<option></option>").val(0).html("Select"));

    calltoAjax(misApiUrl.getCountries, "POST", '',
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $.each(resultData, function (idx, item) {
                $("#presentCountry").append($("<option></option>").val(item.Value).html(item.Text));
                $("#permanentCountry").append($("<option></option>").val(item.Value).html(item.Text));
            });
            if (precSelectedId > 0) {
                $("#presentCountry").val(precSelectedId)
            }
            if (percSelectedId > 0) {
                $("#permanentCountry").val(percSelectedId)
            }
        });


}

function presentCountryChangeEdit(countryId, selectedId) {
    bindStateDropDown("#presentState", countryId, selectedId);
}

function permanentCountryChangeEdit(countryId, selectedId) {
    bindStateDropDown("#permanentState", countryId, selectedId);
}

function presentStateChangeEdit(stateId, selectedId) {
    bindCityDropDown("#presentCity", stateId, selectedId);
}

function permanentStateChangeEdit(stateId, selectedId) {
    bindCityDropDown("#permanentCity", stateId, selectedId);
}

function bindCityDropDown(controlId, stateId, selectedvalue) {
    $(controlId).select2();
    $(controlId).empty();
    $(controlId).append($("<option></option>").val(0).html("Select"));
    var jsonObject = {
        'stateId': stateId,
    };
    calltoAjax(misApiUrl.getCities, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $.each(resultData, function (idx, item) {
                $(controlId).append($("<option></option>").val(item.Value).html(item.Text));
            });
            if (selectedvalue > 0)
                $(controlId).val(selectedvalue);
        });
}

function bindStateDropDown(controlId, countryId, selectedvalue) {
    $(controlId).select2();
    $(controlId).empty();
    $(controlId).append($("<option></option>").val(0).html("Select"));

    var jsonObject = {
        'countryId': countryId,
    };
    calltoAjax(misApiUrl.getStates, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $.each(resultData, function (idx, item) {
                $(controlId).append($("<option></option>").val(item.Value).html(item.Text));
            });
            if (selectedvalue > 0)
                $(controlId).val(selectedvalue);
        });
}

function presentCountryChange() {
    bindStateDropDown("#presentState", $("#presentCountry").val(), 0);
}

function permanentCountryChange() {
    bindStateDropDown("#permanentState", $("#permanentCountry").val(), 0);
}

function presentStateChange() {
    bindCityDropDown("#presentCity", $("#presentState").val(), 0);
}
function permanentStateChange() {
    bindCityDropDown("#permanentCity", $("#permanentState").val(), 0);
}
$("#empReportingManager").change(function () {
    previousPendingData();
});
function previousPendingData() {
    var jsonObject = {
        employeeAbrhs: _employeeAbrhs
    }
    calltoAjax(misApiUrl.listPendingUnapprovedDataOfUser, "POST", jsonObject, function (result) {
        var resultdata = $.parseJSON(JSON.stringify(result));
        var html = '<label class="control-label">Pending Data</label>';
        html = '<table class="tbl-typical text-left">';
        if (resultdata.length > 0) {
            $("#modalViewPendingData").modal("show");
            html = '<tr class="bg-primary"><td>Activities Pending For Current Manager</td><td>Related Information</td><td>Pending On Manager</td></tr>';
            for (var i = 0; i < resultdata.length; i++) {
                html += '<tr><td>' + (resultdata[i].Type === null ? "NA" : resultdata[i].Type) + '</td><td>' + (resultdata[i].Period === null ? "NA" : resultdata[i].Period) + '</td><td>' + (resultdata[i].ReportingManager === null ? "NA" : resultdata[i].ReportingManager) + '</td> </tr>'
            }
        }
        html += '</table>';
        $("#tblPendingData").html(html);
    });
}
$("#btnClose").click(function () {
    $("#modalViewPendingData").modal("hide");
    bindReportingManagerDropDown(_rm);
});
$("#buttonClose").click(function () {
    $("#modalViewPendingData").modal("hide");
    bindReportingManagerDropDown(_rm);
});
$("#btnFwdActivities").click(function () {
    sendReminderMailToPreviousManager();
});
function sendReminderMailToPreviousManager() {
    var jsonObject = {
        employeeAbrhs: _employeeAbrhs
    }
    calltoAjax(misApiUrl.sendReminderMailToPreviousManager, "POST", jsonObject, function (result) {
        if (result === 1) {
            misAlert("Reminder mail has been sent successfully", "Success", "success");
            $("#modalViewPendingData").modal("hide");
        }
        loadUserProfileDetails();
    });
}
$("#btnUpdateData").click(function () {
    updateReportingManager();
});
function updateReportingManager() {
    var jsonObject = {
        employeeAbrhs: _employeeAbrhs,
        rmAbrhs: $('#empReportingManager').val()
    }
    calltoAjax(misApiUrl.updateReportingManagerForApprovals, "POST", jsonObject, function (result) {
        if (result === 1) {
            misAlert("Pending tasks have been forwarded to new manager successfully", "Success", "success");
            $("#modalViewPendingData").modal("hide");
        }
        loadUserProfileDetails();
    });
}