var _isIntern = false;

$(function () {
    loadActiveEmployeeContainer();

    $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
        var tabName = $(e.target).attr("href"); // activated tab

        switch (tabName) {
            case '#tabActiveUserPartialContainer':
                $('#divInactiveUserPartialContainer').empty();
                $('#divNewUserRegPartialContainer').empty();
                $('#divPromoteUserPartialContainer').empty();
                loadActiveEmployeeContainer();
                break;
            case '#tabInactiveUserPartialContainer':
                $('#divActiveUserPartialContainer').empty();
                $('#divNewUserRegPartialContainer').empty();
                $('#divPromoteUserPartialContainer').empty();
                loadInactiveEmployeeContainer();
                break;
            case '#tabNewUserRegPartialContainer':
                $('#divActiveUserPartialContainer').empty();
                $('#divInactiveUserPartialContainer').empty();
                $('#divPromoteUserPartialContainer').empty();
                loadNewUserRegistrationContainer();
                break;
            case '#tabPromoteUserPartialContainer':
                $('#divActiveUserPartialContainer').empty();
                $('#divInactiveUserPartialContainer').empty();
                $('#divNewUserRegPartialContainer').empty();
                loadPromoteUserContainer();
                break;
            case '#tabAbroadUser':
                loadOffshoreUser();
                loadOnshoreUser();
                break;
            default:
                break;
        }
    });

});

//Full and Final Page events

/*Filter leave as per leave type*/
$(document).on("change", "#leavetype input[type='checkbox']", function (e) {
    var leave = $(this).attr("id");
    var items = $("#leavetype .leaveSelector");
    if (leave === "chkAll") {
        if ($("#chkAll").is(':checked')) {
            $.each(items, function (idx, item) {
                var activeLeave = $(item).find('input[type="checkbox"]').is(':checked');
                if (!activeLeave) {
                    $(item).find('input[type="checkbox"]').prop('checked', true);
                    $(item).find('input[type="checkbox"]').parent().toggleClass("active");
                    leave = $(item).find('input[type="checkbox"]').attr("id");
                    $("#boxes .section-" + leave + "").toggle();
                    $("#boxes div[class='section-" + leave + "']").toggle();
                }
            })
        }
        else {
            $.each(items, function (idx, item) {
                var activeLeave = $(item).find('input[type="checkbox"]').is(':checked');
                if (activeLeave) {
                    $(item).find('input[type="checkbox"]').prop('checked', false);
                    $(item).find('input[type="checkbox"]').parent().toggleClass("active");
                    leave = $(item).find('input[type="checkbox"]').attr("id");
                    $("#boxes .section-" + leave + "").toggle();
                    $("#boxes div[class='section-" + leave + "']").toggle();
                }
            })
        }
        $("#leavetype input[id='chkAll']").parent().toggleClass("active");
    }
    else {
        $(this).parent().toggleClass("active");
        $("#boxes .section-" + leave + "").toggle();
        var leave = $(this).attr("id");
        var isChecked = $(this).is(':checked');
        $("#boxes div[class='section-" + leave + "']").toggle();

        var totalLeave = $(".leaveSelector").length;
        var activeLeave = $(".active.leaveSelector").length;
        var notActiveLeave = totalLeave - activeLeave;

        if (totalLeave == activeLeave) {
            $("#chkAll").prop('checked', true);
            $("#leavetype input[id='chkAll']").parent().toggleClass("active");
        }
        else {
            if ((notActiveLeave == 1 && !isChecked) || (notActiveLeave == 0 && isChecked)) {
                $("#chkAll").prop('checked', false);
                $("#leavetype input[id='chkAll']").parent().toggleClass("active");
            }
        }
    }
});

/*Show/Hide leave dates*/
$(document).on("click", "a.toggle-dates-section", function (e) {
    $(this).parent().parent().find(".dates-section").toggle();
});
/*Show/Hide leave dates*/

/*Filter leave as per financial year*/
$(document).on("click", "#financialYears a", function (e) {
    e.preventDefault();
    $(this).toggleClass("active");
    if ($("#financialYears a.active").length <= 0) {
        $("#leavesdeatil").hide();
    }
    else {
        $("#leavesdeatil").show();
    }
    var year = $(this).attr("id");
    $("#boxes .card-body div[data-attr-id='" + year + "']").toggle();
});

//end of full and final page event

function loadActiveEmployeeContainer() {
    loadUrlToId(misAppUrl.listActiveUsers, 'divActiveUserPartialContainer');
}

function loadInactiveEmployeeContainer() {
    loadUrlToId(misAppUrl.listInactiveUsers, 'divInactiveUserPartialContainer');
}

function loadNewUserRegistrationContainer() {
    loadUrlToId(misAppUrl.listUserRegistration, 'divNewUserRegPartialContainer');
}
function loadPromoteUserContainer() {
    loadUrlToId(misAppUrl.listPromotionUsers, 'divPromoteUserPartialContainer');
}
function loadPromotionHistoryContainer() {
    loadUrlToId(misAppUrl.listPromotionHistory, 'divPromotionHistoryPartialContainer');
}
function changeRegLinkStatus(regitrationId, status) {
    if (status === 1) {
        var reply = misConfirm("Link regeneration will make the same link active for next 2 more days", "Confirm", function (reply) {
            if (reply) {
                var jsonObject = {
                    registrationId: regitrationId,
                    status: status,
                    redirectionLink: misAppUrl.newUserRegistration
                };
                calltoAjax(misApiUrl.changeRegLinkStatus, "POST", jsonObject,
                    function (result) {
                        var resultData = $.parseJSON(JSON.stringify(result));
                        if (resultData) {
                            misAlert("Request processed successfully", "Success", "success");
                            getAllUserRegistrations();
                        }
                        else
                            misAlert("Unable to process request. Try again", "Error", "error");
                    });
            }
        });
    }
    else {
        reply = misConfirm("Are you sure you want to deactivate link", "Confirm", function (reply) {
            if (reply) {
                var jsonObject = {
                    registrationId: regitrationId,
                    status: status,
                    redirectionLink: ""
                };
                calltoAjax(misApiUrl.changeRegLinkStatus, "POST", jsonObject,
                    function (result) {
                        var resultData = $.parseJSON(JSON.stringify(result));
                        if (resultData) {
                            misAlert("Request processed successfully", "Success", "success");
                            getAllUserRegistrations();
                        }
                        else
                            misAlert("Unable to process request. Try again", "Error", "error");
                    });
            }
        });
    }
}

//function inActivateEmployee(employeeAbrhs, empName) {
//    $("#InActivateEmployeeModal").modal('show');
//    getReporteesUnderManager(employeeAbrhs);
//    $("#hdnEmployeeId").val(employeeAbrhs);
//    $("#txtEmpName").val(empName);
//    $('#datetimepicker1').datepicker({
//        format: "mm/dd/yyyy",
//        autoclose: true,
//        todayHighlight: true
//    }).datepicker('setEndDate', new Date());
//}
//function getReporteesUnderManager(employeeAbrhs) {
//    var jsonObject = {
//        userAbrhs: employeeAbrhs
//    }
//    calltoAjax(misApiUrl.getEmployeesReportingToUserByManagerId, "POST", jsonObject, function (result) {
//        var resultdata = $.parseJSON(JSON.stringify(result));
//        html = '<table class="tbl-typical text-left">';
//        //html += '<span class="spnError"></span>'
//        if (resultdata.length > 0) {
//            //html = '<tr class="bg-primary"><td>Reportees Under This Employee</td></tr>';
//            html = '<tr class="bg-danger"><td>Update reporting manager of following employees before deactivating this employee.</td></tr>';
//            for (var i = 0; i < resultdata.length; i++) {
//                html += '<tr><td>' + (resultdata[i].EmployeeName === null ? "NA" : resultdata[i].EmployeeName) + '</td> </tr>'
//            }

//        }
//        html += '</table>';
//        $("#tblReportees").html(html);
//    });
//}

function changeUserStatus() {
    if (!validateControls('InActivateEmployeeModal')) {
        return false;
    }
    var jsonObject = {
        employeeAbrhs: $("#hdnEmployeeId").val(),
        status: 2,
        terminationDate: $("#txtDate").val()
    };
    calltoAjax(misApiUrl.changeUserStatus, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            if (resultData) {
                swal("Success!", "Employee has been inactivated successfully!", "success")
                $("#InActivateEmployeeModal").modal('hide');
                getActiveEmployees();
                getInactiveEmployees();
            }
        }
    );
}

//function generateNewUserLink() {
//    if (!validateControls('tabNewUserRegLink'))
//        return false;

//    var uName = $("#userName").val();
//    var dName = $("#domain").val();
//    var adUserName = $("#txtADUsername").val();

//    var jsonObject = {
//        userName: uName,
//        adUserName: adUserName,
//        domain: dName,
//        redirectionLink: misAppUrl.newUserRegistration
//    };

//    calltoAjax(misApiUrl.generateLinkForUserRegistration, "POST", jsonObject,
//        function (result) {
//            var resultData = $.parseJSON(JSON.stringify(result));
//            switch (resultData) {
//                case 1:
//                    misAlert("Request processed successfully", "Success", "success");
//                    getAllUserRegistrations();
//                    $("#userName").val("");
//                    break;
//                case 2:
//                    misAlert("An employee with this user name already exists. Please try another user name.", "Warning", "warning");
//                    break;
//                case 0:
//                    misAlert("An employee with this AD user name already exists. Please try another AD user name.", "Warning", "warning");
//                    break;
//                case 3:
//                    misAlert("Link for registration to the employee having this user name has already been sent. Please modify status of the same", "Warning", "warning");
//                    break;
//                case 4:
//                    misAlert("Link for registration to the employee having this AD user name has already been sent. Please modify status of the same", "Warning", "warning");
//                    break;
//                case 5:
//                    misAlert("Unable to process request. Try again", "Error", "error");
//                    break;
//            }
//        });
//}

function editEmployeePersonalDetail(employeeAbrhs) {
    var jsonObject = {
        employeeAbrhs: employeeAbrhs,
    };
}

function editEmployeeBankDetail(employeeAbrhs) {
    var jsonObject = {
        employeeAbrhs: employeeAbrhs,
    };
}

function editEmployeeCareerDetail(employeeAbrhs) {
    var jsonObject = {
        employeeAbrhs: employeeAbrhs,
    };
}

function loadOffshoreUser() {
    calltoAjax(misApiUrl.fetchOffshoreUsers, "POST", "",
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblOffshoreUser").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'Onshore user',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'Onshore user' },
                        { extend: 'pdf', filename: 'Onshore user' },
                        { extend: 'print', filename: 'Onshore user' },
                        ]
                    }
                ],
                "responsive": true,
                "autoWidth": false,
                "paging": true,
                "bDestroy": true,
                "ordering": true,
                "order": [], // disable default sorting
                "info": true,
                "deferRender": true,
                "aaData": data,
                "aoColumns": [
                    {
                        "mData": "EmployeeName",
                        "sTitle": "Employee Name",
                    },
                    {
                        "mData": "EmployeeCode",
                        "sTitle": "Employee Code",
                    },
                    {
                        "mData": "RManager",
                        "sTitle": "Manager"
                    },
                    {
                        "mData": "Department",
                        "sTitle": "Department",
                    },
                    {
                        "mData": "ExtensionNo",
                        "sTitle": "Ext. No"
                    },
                    {
                        "mData": "WSNo",
                        "sTitle": "WS. No."
                    },
                    {
                        "mData": "CompanyLocation",
                        "sTitle": "Location"
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        "sClass": "text-center",
                        "sWidth": "80px",
                        mRender: function (data, type, row) {
                            var html = '<div>';
                            html += '<button type="button" class="btn btn-sm btn-success" onclick="EditUsersLocation(\'' + data.EmployeeAbrhs + '\',\'' + data.EmployeeCode + '\',  \'' + data.EmployeeName + '\',\'' + data.ExtensionNo + '\',\'' + data.WSNo + '\',\'' + data.CompanyLocation + '\')"  title="Edit Location"><i  class="fa fa-pencil"></i></button>';
                            html += '&nbsp;<button type="button" class="btn btn-sm btn-info" onclick="mapAbroadUser(\'' + data.EmployeeAbrhs + '\',\'' + data.EmployeeCode + '\',  \'' + data.EmployeeName + '\',\'' + data.Country + '\',\'' + data.CompanyLocation + '\')"  title="Map Onshore"><i  class="fa fa-plane"></i></button>';
                            return html;
                        }
                    },
                ],
            });
        });
}

function loadOnshoreUser() {
    calltoAjax(misApiUrl.fetchOnshoreUsers, "POST", "",
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblOnshoreUser").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'Onshore user',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'Onshore user' },
                        { extend: 'pdf', filename: 'Onshore user' },
                        { extend: 'print', filename: 'Onshore user' },
                        ]
                    }
                ],
                "responsive": true,
                "autoWidth": false,
                "paging": true,
                "bDestroy": true,
                "ordering": true,
                "order": [], // disable default sorting
                "info": true,
                "deferRender": true,
                "aaData": data,
                "aoColumns": [
                    {
                        "mData": "EmployeeName",
                        "sTitle": "Employee Name",
                    },
                    {
                        "mData": "EmployeeCode",
                        "sTitle": "Employee Code",
                    },
                    {
                        "mData": "RManager",
                        "sTitle": "Manager"
                    },
                    {
                        "mData": "Department",
                        "sTitle": "Department",
                    },
                    {
                        "mData": "Country",
                        "sTitle": "Country"
                    },
                    {
                        "mData": "CompanyLocation",
                        "sTitle": "Company Location",
                    },

                ],
            });
        });
}

function EditUsersLocation(employeeAbrhs, employeeCode, employeeName, extensionNo, wSNo, companyLocation) {
    $(".select2").select2();
    $("#ddlNewCompanyLocation").removeClass('error-validation');
    $('#modalEditUserLocation').modal('show');
    $("#txtNewExtNo").val("");
    $("#txtNewWSNo").val("");
    $("#hdnUserAbrhs").val(employeeAbrhs);
    $("#empName").text(employeeName);
    $("#empCode").text(employeeCode);
    $("#txtCurrentLocation").val(companyLocation);
    $("#txtExtNo").val(extensionNo);
    $("#txtWSNo").val(wSNo);
    companyLocationListByUserId();
}

function fetchCountryList() {
    $("#ddlNewCountryA").empty();
    $("#ddlNewCountryA").append("<option value='0'>Select</option>");
    var jsonObject = {
        employeeAbrhs: $("#hdnUserAbrhsA").val()
    };
    calltoAjax(misApiUrl.countryList, "POST", jsonObject,
        function (result) {
            $.each(result, function (key, v) {
                $("#ddlNewCountryA").append("<option value=" + v.CountryId + ">" + v.Country + "</option>");
            });
            fetchCompanyLocationListByCountryId();
        });
}

$("#ddlNewCountryA").change(function () {
    fetchCompanyLocationListByCountryId();
});

function fetchCompanyLocationListByCountryId() {
    $("#ddlNewCompanyLocationA").empty();
    $("#ddlNewCompanyLocationA").append("<option value='0'>Select</option>");
    var jsonObject = {
        countryId: $("#ddlNewCountryA").val()
    };
    calltoAjax(misApiUrl.companyLocationListByCountryId, "POST", jsonObject,
        function (result) {
            $.each(result, function (key, v) {
                $("#ddlNewCompanyLocationA").append("<option value=" + v.CompanyLocationId + ">" + v.CompanyLocation + "</option>");
            });
        });
}

function companyLocationListByUserId() {
    $("#ddlNewCompanyLocation").empty();
    $("#ddlNewCompanyLocation").append("<option value='0'>Select</option>");
    var jsonObject = {
        employeeAbrhs: $("#hdnUserAbrhs").val()
    };
    calltoAjax(misApiUrl.companyLocationListByUserId, "POST", jsonObject,
        function (result) {
            $.each(result, function (key, v) {
                $("#ddlNewCompanyLocation").append("<option value=" + v.CompanyLocationId + ">" + v.CompanyLocation + "</option>");
            });
        });
}

$("#btnEditOffShoreUserDetail").click(function () {
    if (!validateControls('modalEditUserLocation'))
        return false;

    var jsonObject = {
        EmployeeAbrhs: $("#hdnUserAbrhs").val(),
        CompanyLocationId: $("#ddlNewCompanyLocation").val(),
        ExtensionNo: $("#txtNewExtNo").val(),
        WSNo: $("#txtNewWSNo").val(),
        ActionCode: "EDIT"
    };

    calltoAjax(misApiUrl.changeUserLocationAndMapUserOnshore, "POST", jsonObject,
        function (result) {
            if (result == 1) {
                $('#modalEditUserLocation').modal('hide');
                loadOffshoreUser();
                misAlert("Detail updated suceesfully", "Success", "success");
            }
            else {
                misAlert("Error occurred. Unable to process request.", "Error", "error");
            }
        });
});

function mapAbroadUser(employeeAbrhs, employeeCode, employeeName, country, companyLocation) {
    $('#modalOnshorMapping').modal('show');
    $("#txtNewEmpCodeA").val("");
    $(".select2").select2();
    $("#ddlNewCompanyLocationA").removeClass('error-validation');
    $("#hdnUserAbrhsA").val(employeeAbrhs);
    $("#empNameA").text(employeeName);
    $("#txtCurrentCountryA").val(country);
    $("#txtCurrentLocationA").val(companyLocation);
    $("#txtCurrentEmpCodeA").val(employeeCode);
    fetchCountryList();
    loadLeaveBalanceGridForSelectedEmployee(employeeAbrhs);
}

function loadLeaveBalanceGridForSelectedEmployee(employeeAbrhs) {
    var jsonObject = {
        employeeAbrhs: employeeAbrhs,
    }
    calltoAjax(misApiUrl.listLeaveBalanceForAllUser, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblLeavebalanceGrid").dataTable({
                "searching": false,
                "responsive": true,
                "autoWidth": false,
                "paging": false,
                "bDestroy": true,
                "ordering": true,
                "order": [],
                "info": false,
                "deferRender": true,
                "aaData": data,
                "aoColumns": [
                    {
                        "mData": "ClCount",
                        "sTitle": "CL",
                    },
                    {
                        "mData": "PlCount",
                        "sTitle": "PL",
                    },
                    {
                        "mData": "CompOffCount",
                        "sTitle": "COFF",
                    },
                    {
                        "mData": "LwpCount",
                        "sTitle": "LWP",
                    },
                    {
                        // "className": "none",
                        "mData": null,
                        "sTitle": "ML/PL(M)",
                        mRender: function (data, type, row) {
                            if (data.GenderId == 1)
                                return (data.PlmCount == null ? 0 : data.PlmCount)
                            else
                                return (data.MlCount == null ? 0 : data.MlCount)
                        }
                    },
                    {
                        "mData": "CloyAvailable",
                        "sTitle": "CLOY",
                    },
                ]
            });
        });
}

$("#btnMapOnshore").click(function () {
    if (!validateControls('modalOnshorMapping'))
        return false;

    var jsonObject = {
        EmployeeAbrhs: $("#hdnUserAbrhsA").val(),
        CompanyLocationId: $("#ddlNewCompanyLocationA").val(),
        EmployeeCode: $("#txtNewEmpCodeA").val(),
        ActionCode: "ABROAD"
    };

    calltoAjax(misApiUrl.changeUserLocationAndMapUserOnshore, "POST", jsonObject,
        function (result) {
            if (result == 1) {
                $('#modalOnshorMapping').modal('hide');
                loadOnshoreUser();
                misAlert("Detail updated suceesfully", "Success", "success");
            }
            else if (result == 2) {
                misAlert("Employee code already exists.", "Warning", "warning");
            }
            else {
                misAlert("Error occurred. Unable to process request.", "Error", "error");
            }
        });
});


