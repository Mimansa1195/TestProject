var misApiUrl = function () {
    return {
        'validateQueryStringForNewUserRegistration': misApiBaseUrl + 'Anonymous/ValidateQueryStringForUserRegistration',
        'submitUserRegistrationData': misApiBaseUrl + 'Anonymous/SubmitUserRegistrationData',
        'getCountries': misApiBaseUrl + 'Anonymous/GetCountries',
        'getStates': misApiBaseUrl + 'Anonymous/GetStates',
        'getCities': misApiBaseUrl + 'Anonymous/GetCities',
        'getGender': misApiBaseUrl + 'Anonymous/GetGender',
        'getMaritalStatus': misApiBaseUrl + 'Anonymous/GetMaritalStatus',
        'getOccupation': misApiBaseUrl + 'Anonymous/GetOccupation',
        'getRelationship': misApiBaseUrl + 'Anonymous/GetRelationship',
        'saveNewUserRegPersonalInfo': misApiBaseUrl + 'Anonymous/SaveNewUserRegPersonalInfo',
        'saveNewUserRegAddressInfo': misApiBaseUrl + 'Anonymous/SaveNewUserRegAddressInfo',
        'saveNewUserRegCareerInfo': misApiBaseUrl + 'Anonymous/SaveNewUserRegCareerInfo',
        'saveNewUserRegBankInfo': misApiBaseUrl + 'Anonymous/SaveNewUserRegBankInfo',
        'getExistingUserRegistrationData': misApiBaseUrl + 'Anonymous/GetExistingUserRegistrationData',
        'checkIfAllMandatoryFieldsAreSubmitted': misApiBaseUrl + 'Anonymous/CheckIfAllMandatoryFieldsAreSubmitted',
        //'submitUserRegistrationData': misApiBaseUrl + 'Anonymous/SubmitUserRegistrationData',
    }
}();

var _tempUserGuid, _base64PhotoData, _fileExtension;

$(document).ready(function () {
    blockContainer('One moment please while we collect your information...');
    
    var url = window.location.search;
    if (url == '') {
        misAlert("wrong");
        window.location = orgUrl;
    }
    else {
        url = url.replace("?", '');
        if (url.indexOf('=') === -1) {
            window.location = orgUrl;
        }
        else {
            if (url.split('=')[0] != "TempGuid") {
                window.location = orgUrl;
            }
            else {
                _tempUserGuid = url.split('=')[1];

                var jsonObject = {
                    tempUserGuid: _tempUserGuid,
                };
                $.ajax({
                    url: misApiUrl.validateQueryStringForNewUserRegistration,
                    type: "GET",
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    data: jsonObject,
                    success: function (result) {
                        if (result !== '') {
                            updateBlockedContainer(result);
                            setTimeout(function () { redirectToURL(orgUrl); }, 4500);
                        }
                        else {
                            $("#userRegContainer").show();
                            $("#txtDobFromPicker").datepicker({ autoclose: true, todayHighlight: true, format: 'mm/dd/yyyy' });
                            $("div.vertical-tab-menu>div.list-group>a").click(function (e) {
                                e.preventDefault();
                                $(this).siblings('a.active').removeClass("active");
                                $(this).addClass("active");
                                var index = $(this).index();
                                $("div.vertical-tab>div.vertical-tab-content").removeClass("active");
                                $("div.vertical-tab>div.vertical-tab-content").eq(index).addClass("active");
                            });
                            bindGenderDropDown(0);
                            bindMaritalStatusDropDown(0);
                            getExistingUserRegistrationData(_tempUserGuid);
                            unBlockContainer();
                        }

                    },
                    error: function () {
                        blockContainer('Your registration cannot be processed, please try after some time or contact to MIS team for further assistance.');
                        setTimeout(function () { redirectToURL(orgUrl); }, 4500);
                    }
                });
            }
        }
    }
});

$("#ifSameAdd").change(function () {
    if ($("#ifSameAdd").is(':checked')) {
        var CId = $("#presentCountry").val();
        var SId = $("#presentState").val();
        var CtyId = $("#presentCity").val();
        var Addss = $("#presentAddress").val();
        var PinCd = $("#presentPincode").val();
        $("#permanentCountry").val(CId);
        $("#permanentAddress").val(Addss);
        $("#permanentPincode").val(PinCd);
        bindStateDropDown("#permanentState", CId, SId);
        bindCityDropDown("#permanentCity", SId, CtyId);
    }
    else {
        $("#permanentCountry").val(0);
        $("#permanentState").val(0);
        $("#permanentCity").val(0);
        $("#permanentAddress").val("");
        $("#permanentPincode").val("");
    }
});

function validateEmail(sEmail) {
    var filter = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
    if (filter.test(sEmail)) {
        return true;
    }
    else {
        return false;
    }
}

function saveAndContinue(tabNumber) {
    var jsonObject = {
        tempUserGuid: _tempUserGuid,
    };
    $.ajax({
        url: misApiUrl.validateQueryStringForNewUserRegistration,
        type: "GET",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: jsonObject,
        success: function (result) {
            if (result !== '') {
                misAlert(result, "Warning", "warning");
            }
            else {
                switch (tabNumber) {
                    case 1:
                        if (!validateControls("personalInfo"))
                            return false;

                        if ($(".file-caption-name").val() == "" || $(".file-caption-name").val() == null) {
                            misAlert("Please upload Profile Photo", "Warning", "warning");
                            return false;
                        }

                        var pEmail = $("#personalEmail").val();
                        var isValid = validateEmail(pEmail);

                        if (isValid === false) {
                            misAlert("Please enter valid email id", "Warning", "warning");
                            return false;
                        }

                        var jsonObject = {

                            TempUserGuid: _tempUserGuid,
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
                            PhotoFileName: $("#userName").val() + _fileExtension,
                            Base64PhotoData: _base64PhotoData,
                        };
                        $.ajax({
                            url: misApiUrl.saveNewUserRegPersonalInfo,
                            type: "POST",
                            dataType: "json",
                            data: jsonObject,
                            //contentType: "application/json; charset=utf-8",
                            success: function (data) {
                                //console.log(data);
                                if (data === 1) {
                                    misAlert("Information saved successfully", "Success", "success");
                                    $($("div.vertical-tab-menu>div.list-group>a")[tabNumber]).trigger("click");
                                }
                                else if (data === 2) {
                                    misAlert("Profile image is empty. Please select profile image and try again.", "Warning", "warning");
                                }
                                else {
                                    misAlert("Unable to save data. Please try again", "Error", "error");
                                }
                            }
                        });
                        break;
                    case 2:
                        if (!validateControls("addressInfo"))
                            return false;
                        var jsonObject = [
                            {
                                TempUserGuid: _tempUserGuid,
                                CountryId: $("#presentCountry").val(),
                                StateId: $("#presentState").val(),
                                CityId: $("#presentCity").val(),
                                Address: $("#presentAddress").val(),
                                PinCode: $("#presentPincode").val(),
                                IsAddressPermanent: false,
                            },
                            {
                                TempUserGuid: _tempUserGuid,
                                CountryId: $("#permanentCountry").val(),
                                StateId: $("#permanentState").val(),
                                CityId: $("#permanentCity").val(),
                                Address: $("#permanentAddress").val(),
                                PinCode: $("#permanentPincode").val(),
                                IsAddressPermanent: true,
                            }
                        ];
                        $.ajax({
                            url: misApiUrl.saveNewUserRegAddressInfo,
                            type: "POST",
                            dataType: "json",
                            contentType: "application/json; charset=utf-8",
                            data: JSON.stringify(jsonObject),
                            success: function (data) {
                                //console.log(data);
                                if (data === 1) {
                                    misAlert("Information saved successfully", "Success", "success");
                                    $($("div.vertical-tab-menu>div.list-group>a")[tabNumber]).trigger("click");
                                }
                                else
                                    misAlert("Unable to save data. Please try again", "Error", "error");
                            }
                        });
                        break;
                    //case 3:
                    //    if (!validateControls("familyInfo"))
                    //        return false;
                    //    $($("div.vertical-tab-menu>div.list-group>a")[tabNumber]).trigger("click");
                    //    break;
                    case 3:
                        if (!validateControls("careerInfo"))
                            return false;
                        var jsonObject = {
                            TempUserGuid: _tempUserGuid,
                            IsFresher: $("#jobExperience").val() == 1 ? true : false,
                            LastEmployerName: $("#lastEmployerName").val(),
                            LastEmployerLocation: $("#lastEmployerLocation").val(),
                            LastJobDesignation: $("#lastJobDesignation").val(),
                            LastJobTenure: $("#lastJobTenure").val(),
                            LastJobUAN: $("#lastJobUan").val(),
                            JobLeavingReason: $("#jobLeavingReason").val(),
                        };
                        $.ajax({
                            url: misApiUrl.saveNewUserRegCareerInfo,
                            type: "POST",
                            dataType: "json",
                            data: jsonObject,
                            success: function (data) {
                                //console.log(data);
                                if (data) {
                                    misAlert("Information saved successfully", "Success", "success");
                                    $($("div.vertical-tab-menu>div.list-group>a")[tabNumber]).trigger("click");
                                }
                                else
                                    misAlert("Unable to save data. Please try again", "Error", "error");
                            }
                        });
                        break;
                    case 4:
                        if (!validateControls("bankInfo"))
                            return false;
                        var jsonObject = {
                            TempUserGuid: _tempUserGuid,
                            PanNo: $("#panNo").val(),
                            AadhaarNo: $("#aadhaarNo").val(),
                            PassportNo: $("#passportNo").val(),
                            DLNo: $("#dLNo").val(),
                            VoterIdNo: $("#voterIdNo").val(),
                        };
                        $.ajax({
                            url: misApiUrl.saveNewUserRegBankInfo,
                            type: "POST",
                            dataType: "json",
                            data: jsonObject,
                            success: function (data) {
                                //console.log(data);
                                if (data) {
                                    //misAlert("Information saved successfully", "Success", "success");
                                    checkIfAllMandatoryFieldsAreSubmitted();
                                }
                                else
                                    misAlert("Unable to save data. Please try again", "Error", "error");
                            }
                        });
                        break;
                }
            }
        },
        error: function () {
            blockContainer('Your registration cannot be processed, please try after some time or contact to MIS team for further assistance.');
            setTimeout(function () { redirectToURL(orgUrl); }, 4500);
        }
    });
}

function checkIfAllMandatoryFieldsAreSubmitted() {
    var jsonObject = {
        tempUserGuid: _tempUserGuid,
    };
    $.ajax({
        url: misApiUrl.checkIfAllMandatoryFieldsAreSubmitted,
        type: "POST",
        dataType: "json",
        data: jsonObject,
        success: function (data) {
            if (data == null)
                submitUserRegistrationData();
            else {
                var html = "<div>";
                var x = {};
                for (var i = 0; i < data.length; ++i) {
                    var obj = data[i];
                    if (x[obj.Category] === undefined)
                        x[obj.Category] = [obj.Category];
                    x[obj.Category].push(obj.Field);
                }

                $.each(x, function (k, v) {
                    html += "<div><h5><u><b>" + k + "</b></u></h5><p style='font-size:15'>";
                    for (var i = 1; i < v.length; i++) {
                        html += v[i] + ", "
                    }
                    html += "</p></div>"
                });
                html += "</div>";
                misAlert(html, "Please fill following mandatory fields before submitting", "warning");
            }
        }
    });
}

function submitUserRegistrationData() {
    var jsonObject = {
        tempUserGuid: _tempUserGuid,
    };
    $.ajax({
        url: misApiUrl.submitUserRegistrationData,
        type: "POST",
        dataType: "json",
        data: jsonObject,
        success: function (data) {
            if (data) {
                misCountdownAlert('User registration data has been saved successfully.', 'Success', 'success', function () {
                    redirectToURL(orgUrl);
                }, false, 5);
                misAlert("User registration data saved successfully", "Success", "success");
            }
            else
                misAlert("Unable to save data. Please try again", "Error", "error");
        }
    });
}

function getExistingUserRegistrationData(tempUserGuid){
    var jsonObject = {
        tempUserGuid: tempUserGuid,
    }
    $.ajax({
        url: misApiUrl.getExistingUserRegistrationData,
        type: "GET",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: jsonObject,
        success: function (data) {
            if (data != null) {
                var personalDetail = data.PersonalDetail;
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
                $("#bloodGroup").val(personalDetail.BloodGroup == null ? 0 : personalDetail.BloodGroup);
                $("#gender").val(personalDetail.GenderId == null ? 0 : personalDetail.GenderId);
                $("#maritalStatus").val(personalDetail.MaritalStatusId == null ? 0 : personalDetail.MaritalStatusId);
              //  bindGenderDropDown(personalDetail.GenderId == null ? 0 : personalDetail.GenderId);
               // bindMaritalStatusDropDown(personalDetail.MaritalStatusId == null ? 0 : personalDetail.MaritalStatusId);
                //$("#photoFileName").val(personalDetail.PhotoFileName);

                var tempImgUrl = misApiTempProfileImageUrl + personalDetail.PhotoFileName;
                if (personalDetail.PhotoFileName && personalDetail.PhotoFileName !== null && personalDetail.PhotoFileName !== '' && personalDetail.Base64PhotoData !== null && personalDetail.Base64PhotoData !== "") {
                    $("#photoFileName").fileinput({
                        dropZoneEnabled: true,
                        initialPreviewAsData: true,
                        initialPreviewFileType: 'image',
                        //initialPreviewShowDelete: false,
                        //showUpload: false,
                        initialPreview: [tempImgUrl]
                    });

                    _fileExtension = personalDetail.PhotoFileName.substring(personalDetail.PhotoFileName.lastIndexOf('.')).toLowerCase();
                    _base64PhotoData = personalDetail.Base64PhotoData;
                }
                else {
                    $("#photoFileName").fileinput({
                        dropZoneEnabled: true,
                        initialPreviewAsData: true,
                        initialPreviewFileType: 'image',
                        //initialPreviewShowDelete: false,
                        //showUpload: false,
                        initialPreview: true
                    });
                }

                //if (personalDetail.PhotoFileName && personalDetail.PhotoFileName != null && personalDetail.PhotoFileName !== '') {
                //    //$("#photoFileName").removeClass('validation-required');
                //    _fileExtension = personalDetail.PhotoFileName.substring(personalDetail.PhotoFileName.lastIndexOf('.')).toLowerCase();
                //    _base64PhotoData = personalDetail.Base64PhotoData;
                //}

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
                var addressDetail = data.AddressDetail;
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
                else {
                    bindCountryDropDown(0, 0);
                }
            }
            else {
                bindCountryDropDown(0, 0);
                bindGenderDropDown(0);
                bindMaritalStatusDropDown(0);
            }
        }
    });
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

function bindGenderDropDown(selectedId) {
    $("#gender").empty();
    $("#gender").append($("<option></option>").val(0).html("Select"));
    $.ajax({
        url: misApiUrl.getGender,
        type: "GET",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: '',
        success: function (data) {
            $.each(data, function (idx, item) {
                $("#gender").append($("<option></option>").val(item.Value).html(item.Text));
            });
            $("#gender").val(selectedId);
        }
    });
}

function bindMaritalStatusDropDown(selectedId) {
    $("#maritalStatus").empty();
    $("#maritalStatus").append($("<option></option>").val(0).html("Select"));
    $.ajax({
        url: misApiUrl.getMaritalStatus,
        type: "GET",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: '',
        success: function (data) {
            $.each(data, function (idx, item) {
                $("#maritalStatus").append($("<option></option>").val(item.Value).html(item.Text));
            });
            $("#maritalStatus").val(selectedId);
        }
    });
}

function bindCountryDropDown(percSelectedId, precSelectedId) {
    $("#presentCountry").empty();
    $("#presentCountry").append($("<option></option>").val(0).html("Select"));
    $("#permanentCountry").empty();
    $("#permanentCountry").append($("<option></option>").val(0).html("Select"));

    $.ajax({
        url: misApiUrl.getCountries,
        type: "GET",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: '',
        success: function (data) {
            $.each(data, function (idx, item) {
                $("#presentCountry").append($("<option></option>").val(item.Value).html(item.Text));
                $("#permanentCountry").append($("<option></option>").val(item.Value).html(item.Text));
            });
            if (precSelectedId > 0) {
                $("#presentCountry").val(precSelectedId)
            }
            if (percSelectedId > 0) {
                $("#permanentCountry").val(percSelectedId)
            }
        }
    });
}

function presentCountryChange(selectedId) {
    bindStateDropDown("#presentState", $("#presentCountry").val(), 0);
}

function permanentCountryChange() {
    bindStateDropDown("#permanentState", $("#permanentCountry").val(), 0);
}

function presentCountryChangeEdit(countryId, selectedId) {
    bindStateDropDown("#presentState", countryId, selectedId);
}

function permanentCountryChangeEdit(countryId, selectedId) {
    bindStateDropDown("#permanentState", countryId, selectedId);
}

function bindStateDropDown(controlId, countryId, selectedvalue) {
    $(controlId).empty();
    $(controlId).append($("<option></option>").val(0).html("Select"));

    var jsonObject = {
        'countryId': countryId,
    };
    $.ajax({
        url: misApiUrl.getStates,
        type: "GET",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: jsonObject,
        success: function (data) {
            $.each(data, function (idx, item) {
                $(controlId).append($("<option></option>").val(item.Value).html(item.Text));
            });
            if (selectedvalue > 0)
                $(controlId).val(selectedvalue);
        }
    });
}

function presentStateChange() {
    bindCityDropDown("#presentCity", $("#presentState").val(), 0);
}

function permanentStateChange() {
    bindCityDropDown("#permanentCity", $("#permanentState").val(), 0);
}

function presentStateChangeEdit(stateId, selectedId) {
    bindCityDropDown("#presentCity", stateId, selectedId);
}

function permanentStateChangeEdit(stateId, selectedId) {
    bindCityDropDown("#permanentCity", stateId, selectedId);
}

function bindCityDropDown(controlId, stateId, selectedvalue) {
    $(controlId).empty();
    $(controlId).append($("<option></option>").val(0).html("Select"));
    var jsonObject = {
        'stateId': stateId,
    };
    $.ajax({
        url: misApiUrl.getCities,
        type: "GET",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: jsonObject,
        success: function (data) {
            $.each(data, function (idx, item) {
                $(controlId).append($("<option></option>").val(item.Value).html(item.Text));
            });
            if (selectedvalue > 0)
                $(controlId).val(selectedvalue);
        }
    });
}

function validateControls(e) {
    $(function () {
        $("#" + e + " .validation-required").change(function () {
            var e = $(this),
                i = e.prop("tagName");
            "TEXTAREA" == i || "INPUT" == i ? "" == e.val().trim() ? e.addClass("error-validation") : e.removeClass("error-validation")
                : (l = e.hasClass("select-validate")) ? 0 == e.val() ? (a = !1, e.addClass("error-validation")) : e.removeClass("error-validation")
                    : (i = e.hasClass("select2")) ? 0 == e.val() ? (a = !1, e.closest("div").find(".select2-selection").addClass("error-validation")) : e.closest("div").find(".select2-selection").removeClass("error-validation")
                        : (i = e.hasClass("multipleSelect")) && ("undefined" == typeof e.find("option:selected").val() ? (a = !1, e.closest("div").find(".btn-group>.btn").addClass("error-validation")) : e.closest("div").find(".btn-group>.btn").removeClass("error-validation"))
        });
        $("#" + e + " .validation-required").keyup(function () {
            var e = $(this),
                i = e.prop("tagName");
            "TEXTAREA" == i || "INPUT" == i ? "" == e.val().trim() ? e.addClass("error-validation") : e.removeClass("error-validation")
                : (l = e.hasClass("select-validate")) ? 0 == e.val() ? (a = !1, e.addClass("error-validation")) : e.removeClass("error-validation")
                    : (i = e.hasClass("select2")) ? 0 == e.val() ? (a = !1, e.closest("div").find(".select2-selection").addClass("error-validation")) : e.closest("div").find(".select2-selection").removeClass("error-validation")
                        : (i = e.hasClass("multipleSelect")) && ("undefined" == typeof e.find("option:selected").val() ? (a = !1, e.closest("div").find(".btn-group>.btn").addClass("error-validation")) : e.closest("div").find(".btn-group>.btn").removeClass("error-validation"))
        });
    });
    var a = !0,
        i = $("#" + e + " .validation-required");
    return i.each(function (e, i) {
        var s = $(this),
            l = s.prop("tagName");
        "TEXTAREA" == l || "INPUT" == l ? "" == s.val().trim() ? (a = !1, s.addClass("error-validation")) : s.removeClass("error-validation")
            : (l = s.hasClass("select-validate")) ? 0 == s.val() ? (a = !1, s.addClass("error-validation")) : s.removeClass("error-validation")
                : (l = s.hasClass("select2")) ? 0 == s.val() ? (a = !1, s.closest("div").find(".select2-selection").addClass("error-validation")) : s.closest("div").find(".select2-selection").removeClass("error-validation")
                    : (l = s.hasClass("multipleSelect")) && ("undefined" == typeof s.find("option:selected").val() ? (a = !1, s.closest("div").find(".btn-group>.btn").addClass("error-validation")) : s.closest("div").find(".btn-group>.btn").removeClass("error-validation"))
    }), a
}

function misAlert(message, title, messageType, btnCallback, autoHide) {
    swal({
        title: title || "Oops...",
        text: message || "Something went wrong!",
        type: messageType || "error",
        html: true,
        allowOutsideClick: (autoHide !== false), //sets default true
        allowEscapeKey: (autoHide !== false),
        closeOnCancel: (autoHide !== false),
    }, function (result) {
        if (typeof btnCallback === 'function') {
            btnCallback(result);
        }
    });
}

function checkFileIsValid(sender) {
    var validExts = new Array(".png", ".jpg", "jpeg", ".JPG");
    _fileExtension = sender.value;
    _fileExtension = _fileExtension.substring(_fileExtension.lastIndexOf('.')).toLowerCase();
    if (validExts.indexOf(_fileExtension) < 0) {
        misAlert("Invalid file selected. supported extensions are " + validExts.toString(), "Warning", "warning");
        $("#photoFileName").val("");
        return false;
    } else {
        convertToBase64();
        return true;
    }
}

function convertToBase64() {
    var selectedFile = document.getElementById("photoFileName").files;
    if (selectedFile.length > 0) //Check File is not Empty
    {
        var fileToLoad = selectedFile[0]; // Select the very first file from list
        var fileReader = new FileReader(); // FileReader function for read the file.
        fileReader.onload = function (fileLoadedEvent) // Onload of file read the file content
        {
            _base64PhotoData = fileLoadedEvent.target.result;// Print data in console
            //$('#userImage').attr('src', _base64PhotoData);
            $('.kv-file-content img').attr('src', _base64PhotoData);
            //console.log(base64FormData);
        };
        fileReader.readAsDataURL(fileToLoad); // Convert data to base64
    }
}


