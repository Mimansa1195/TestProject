var data;
var newReferId = 0;
var isTournamentRunning = false;
var _startDate = "";
var _endDate = "";
$(document).ready(function () {
    var intervalStart = "";
    var intervalEnd = "";
    $('#employeeCalendar').fullCalendar({
        firstDay: 1,
        header: {
            left: 'prev', //
            center: 'title today', //month
            right: 'next'
        },
        viewRender: function (view, element) {
            intervalStart = view.start;
            intervalEnd = view.end;
            _startDate = intervalStart._d;/*.getMonth() + 1;*/
            _endDate = intervalEnd._d;/*.getFullYear();*/
        },
        defaultView: 'month',
    });
    $(document).on("click", "button.fc-next-button", function () {
        getCalendarOnNavigation();
    });
    $(document).on("click", "button.fc-prev-button", function () {
        getCalendarOnNavigation();
    });
    $(document).on("click", "button.fc-today-button", function () {
        getCalendarOnNavigation();
    });
    $(document).on("click", "button.fc-month-button", function () {
        getCalendarOnNavigation();
    });
    bindDashboardSettings();
    getuserProfileData();
    getNewsScrollerData();
    getInOutTimeCurrentDayData();
    getCalendarOnNavigation(); // C for current month
    
    var popOverSettings = {
        selector: '[rel=popover]',
        trigger: 'hover',
        placement: 'left',
        container: 'body',
        html: true,
        content: function () {
            return $(this).attr("data-attr-JD");
        }
    }
    $('body').popover(popOverSettings);
});


function bindDashboardSettings() {

    calltoAjax(misApiUrl.getUserRoleDashboardSettings, "POST", '',
        function (result) {
            result = result.DashBoardSetting;
            for (var i = 0; i < result.length; i++) {
                if (result[i].DashboardWidgetName === "My Attendance" && result[i].IsActive) {
                    var html = '<div class="col-xl-6 dashboard-column"><section  id="MyAttendence" class="box-typical box-typical-dashboard panel panel-default scrollable"><header class="box-typical-header panel-heading">';
                    html += '<h3 class="panel-title">My Attendance</h3><div class="col-xl-6 col-md-6"><select id= "selectduration" class="form-control select2" onchange= "getAttendanceByMonthYear();" ></select ></div ></header><div class="box-typical-body panel-body" style="text-align: center;"  id="tblemployeesAttendence"><img src="../../img/dot-loader.gif" style="margin-top:50px">';
                    html += '</div></section></div>';

                    $("#divPanel").append(html).ready(function () {
                        $("#MyAttendence").lobiPanel();
                        $("#selectduration").select2();
                        $("#selectduration").empty();

                        calltoAjax(misApiUrl.getUserMonthYear, "POST", '', function (result) {
                            if (result !== null)
                                $.each(result, function (idx, item) {
                                    $("#selectduration").append($("<option></option>").val(item.Text).html(item.Text));
                                });
                            getAttendanceByMonthYear();
                        });
                    });
                }
                if (result[i].DashboardWidgetName === "Team Attendance" && result[i].IsActive) {
                    html = '<div class="col-xl-6 dashboard-column"><section  id="TeamAttendence" class="box-typical box-typical-dashboard panel panel-default scrollable"><header class="box-typical-header panel-heading">';
                    html += '<h3 class="panel-title">Team Attendance</h3></header><div class="box-typical-body panel-body" style="text-align: center;"  id="tblTeamAttendence"><img src="../../img/dot-loader.gif" style="margin-top:50px">';
                    html += '</div></section></div>';
                    $("#divPanel").append(html).ready(function () {
                        $("#TeamAttendence").lobiPanel();
                    });
                    getTeamAttendanceData();
                }
                if (result[i].DashboardWidgetName === "Holiday" && result[i].IsActive) {
                    html = '<div class="col-xl-6 dashboard-column"><section id="Holiday" class="box-typical box-typical-dashboard panel panel-default scrollable"><header class="box-typical-header panel-heading">';
                    html += '<h3 class="panel-title">Holiday</h3></header><div class="box-typical-body panel-body"  id="tblHoliday" style="text-align: center;"><img src="../../img/dot-loader.gif" style="margin-top:50px">';
                    html += '</div></section></div>';

                    $("#divPanel").append(html).ready(function () {
                        $("#Holiday").lobiPanel();
                    });

                    bindBirthDayHolidayList(1);
                }
                if (result[i].DashboardWidgetName === "Leave Balance" && result[i].IsActive) {
                    html = '<div class="col-xl-6 dashboard-column"><section id="LeaveBalance" class="box-typical box-typical-dashboard panel panel-default scrollable"><header class="box-typical-header panel-heading">';
                    html += '<h3 class="panel-title">Leave Balance</h3></header><div class="box-typical-body panel-body"  id="tblLeaveBalance" style="text-align: center;"><img src="../../img/dot-loader.gif" style="margin-top:50px">';
                    html += '</div></section></div>';
                    $("#divPanel").append(html).ready(function () {
                        $("#LeaveBalance").lobiPanel();
                    });
                    getLeaveBalanceData();
                }
                if (result[i].DashboardWidgetName === "Birthdays" && result[i].IsActive) {
                    html = ' <div class="col-xl-6 dashboard-column"><section id="Birthdays" class="box-typical box-typical-dashboard panel panel-default scrollable"><header class="box-typical-header panel-heading" style="background-image:url(../../img/birthday-bg.jpg)">';
                    html += '<h3 class="panel-title">Birthdays</h3></header><div class="box-typical-body panel-body"  id="tblBirthday" style="text-align: center;"><img src="../../img/dot-loader.gif" style="margin-top:50px">';
                    html += '</div></section></div>';

                    $("#divPanel").append(html).ready(function () {
                        $("#Birthdays").lobiPanel();
                    });
                    bindBirthDayHolidayList(2);
                }
                if (result[i].DashboardWidgetName === "Skills" && result[i].IsActive) {
                    html = '<div class="col-xl-6 dashboard-column"><section  id="SkillSet" class="box-typical box-typical-dashboard panel panel-default scrollable"><header class="box-typical-header panel-heading">';
                    html += '<h3 class="panel-title">My Skills</h3></header><div class="box-typical-body panel-body"  id="tblSkillSet"  style="text-align: center;"><img src="../../img/dot-loader.gif" style="margin-top:50px">';
                    html += '</div></section></div>';
                    $("#divPanel").append(html).ready(function () {
                        $("#SkillSet").lobiPanel();
                    });
                    getSkills();
                }
                if (result[i].DashboardWidgetName === "Meal Of The Day" && result[i].IsActive) {
                    getMealOfTheDay();
                }
                if (result[i].DashboardWidgetName === "Work Anniversary" && result[i].IsActive) {
                    html = '<div class="col-xl-6 dashboard-column"><section id="WorkAnniversary" class="box-typical box-typical-dashboard panel panel-default scrollable"><header class="box-typical-header panel-heading" style="background-image:url(../../img/birthday-bg.jpg)">';
                    html += '<h3 class="panel-title">Work Anniversary</h3></header><div class="box-typical-body panel-body" id="tblWorkAnniversary" style="text-align: center;"><img src="../../img/dot-loader.gif" style="margin-top:50px">';
                    html += '</div></section></div>';
                    $("#divPanel").append(html).ready(function () {
                        $("#WorkAnniversary").lobiPanel();
                    });
                    getWorkAnniversary();
                }
                if (result[i].DashboardWidgetName === "Team Leaves" && result[i].IsActive) {
                    getTeamLeaves();
                }
                if (result[i].DashboardWidgetName === "TT Tournament" && result[i].IsActive) {
                    html = '<div class="col-xl-6 dashboard-column"><section id="TournamentLiveScore" class="box-typical box-typical-dashboard panel panel-default scrollable"><header class="box-typical-header panel-heading" style="background-image:url(../../img/table-tennis.jpg?dummy=123);text-shadow: 1px 1px 1px #000, 3px 3px 5px blue;color: #fff;">';
                    html += '<h3 class="panel-title">TT Tournament - Score Board</h3></header><div class="box-typical-body panel-body" id="tblTournamentLiveScore" style="text-align: center;"><img src="../../img/dot-loader.gif" style="margin-top:50px">';
                    html += '</div></section></div>';
                    $("#divPanel").append(html).ready(function () {
                        $("#TournamentLiveScore").lobiPanel();
                    });
                    var showWidget = 1;
                    getTTTournamentData(showWidget);
                    setInterval(function () {
                        if (isTournamentRunning) {
                            getTTTournamentData(2);
                        }
                    }, 10000);
                }
                if (result[i].DashboardWidgetName === "Referral" && result[i].IsActive && result[i].IsReferral == true) {
                    getReferrals();
                }
                if (result[i].DashboardWidgetName === "Upcoming Trainings" && result[i].IsActive && result[i].IsTraining == true) {
                    getTrainings();
                }

                if (result[i].DashboardWidgetName === "Cab Request" && result[i].IsActive) {
                    html = '<div class="col-xl-6 dashboard-column"><section id="CabRequest" class="box-typical box-typical-dashboard panel panel-default scrollable"><header class="box-typical-header panel-heading">';
                    html += '<h4 class="panel-title">Cab Request</h4><div class="col-md-5"><select id= "txtMonth" class="form-control select2" onchange= "getCabRequestDetails();" ></select ></div><div class="col-md-3"><button id="bookCab" style="padding: 4px 5px;height: 30px;" onclick="getCabDetailsToBookCab();" class="btn btn-success"><i class="fa fa-taxi"> </i>&nbsp;Book Cab</button></div></header><div class="box-typical-body panel-body"  id="tblCabRequest" style="text-align: center;"><img src="../../img/dot-loader.gif" style="margin-top:50px">';
                    html += '</div></section></div>';
                    $("#divPanel").append(html).ready(function () {
                        $("#CabRequest").lobiPanel();
                        $("#txtMonth").select2();
                        $("#txtMonth").empty();
                        calltoAjax(misApiUrl.getCabRequestMonthYear, "POST", '', function (result) {
                            $("#txtMonth").empty();
                            $("#txtMonth").append("<option value='0'>Select</option>");
                            if (result !== null) {
                                $.each(result, function (idx, item) {
                                    $("#txtMonth").append($("<option></option>").val(item.KeyValue).html(item.Text));
                                });
                                $("#txtMonth").val(result[0].MaxValue);
                            }
                            getCabRequestDetails();
                        });

                    });
                }

                if (result[i].DashboardWidgetName === "Health Insurance" && result[i].IsActive) {
                    html = '<div class="col-xl-6 dashboard-column"><section id="HealthInsurance" class="box-typical box-typical-dashboard panel panel-default scrollable"><header class="box-typical-header panel-heading" >';
                    html += '<h3 class="panel-title">Health Insurance</h3></header><div class="box-typical-body panel-body" id="tblHealthInsurance" style="text-align: center;"><img src="../../img/dot-loader.gif" style="margin-top:50px">';
                    html += '</div></section></div>';
                    $("#divPanel").append(html).ready(function () {
                        $("#HealthInsurance").lobiPanel();
                    });
                    getHealthInsuranceDetail();
                }
            }
            $(".dashboard-column .box-typical-body").on("scroll", function () {
                var top = $(this).scrollTop();
                $(this).find(".fixed-header thead th").css("top", top);
            });
        });

}

function getHealthInsuranceDetail() {
    var html = '<div class="row"><div id ="pdfInsuranceContainer" class="col-md-12" style = "height: 1000px;margin-bottom: 20px;" ></div></div>';
    $("#tblHealthInsurance").html(html);
    calltoAjax(misApiUrl.getHealthInsuranceDetail, "POST", "",
        function (result) {
            if (result != null && result != '') {
                var resultData = result.link;
                if (resultData == "") {
                    $("#tblHealthInsurance").html('<div>No data available</div>');
                }
                else {
                    $("#pdfInsuranceContainer").html('<embed src="' + resultData + '" style="width: 100%;height:1000px" toolbar=0 />')
                    $('embed').load(function () {
                        $('embed').contents().find("#buttons").hide();
                    });
                }
            }
            else {
                $("#tblHealthInsurance").html('<div>No data available</div>');
            }
        });
}

function getCabRequestDetails() {
    var selectedMonthYear = $("#txtMonth").val();
    var selectedMonth = 0;
    var selectedYear = 0;
    var html = '<div class="row"><div class="col-md-12"><table class="tbl-typical fixed-header text-left" id= "cabRequestTable"></div></div></div>';
    html += '<thead><tr><th><div>Time</div></th><th><div>Service</div></th><th><div>Location</div></th><th><div>Status</div></th></th><th><div>Action</div></th></tr></thead><tbody>';//<th><div>Remarks</div></th>
    if (selectedMonthYear != "" && selectedMonthYear != "0") {
        selectedMonth = selectedMonthYear.split('-')[0];
        selectedYear = selectedMonthYear.split('-')[1];

        var jsonObject = {
            userAbrhs: misSession.userabrhs,
            Month: selectedMonth,
            Year: selectedYear
        };
        calltoAjax(misApiUrl.getCabRequestDetails, "POST", jsonObject, function (result) {
            if (result) {
                var resultdata = $.parseJSON(JSON.stringify(result));
                if (resultdata && resultdata.length > 0) {
                    for (var i = 0; i < resultdata.length; i++) {
                        if (resultdata[i].StatusCode == "CA" || resultdata[i].StatusCode == "RJ" || resultdata[i].StatusCode == "FD") {
                            html += '<tr class=' + resultdata[i].StatusCode + '><td>' + resultdata[i].DateText + '</td><td>' + resultdata[i].ServiceType + '</td><td>' + resultdata[i].LocationName + '</td><td><a style = "text-decoration: underline;" onclick = "showCabRemarksPopup(' + resultdata[i].CabRequestId + ')">' + resultdata[i].Status + '</a></td><td></td></tr>'; //<td>' + resultdata[i].Remarks + '</td>
                        }
                        else {
                            html += '<tr class=' + resultdata[i].StatusCode + '><td>' + resultdata[i].DateText + '</td><td>' + resultdata[i].ServiceType + '</td><td>' + resultdata[i].LocationName + '</td><td><a style = "text-decoration: underline;" onclick = "showCabRemarksPopup(' + resultdata[i].CabRequestId + ')">' + resultdata[i].Status + '</a></td><td><div><button title="Cancel" onclick="cancelCabRequest(' + resultdata[i].CabRequestId + ');" class="btn btn-danger btn-sm"><i class="fa fa-remove"></i></button></div></td></tr>'; //<td>' + resultdata[i].Remarks + '</td>
                           // html += '<tr class=' + resultdata[i].StatusCode + '><td>' + resultdata[i].DateText + '</td><td>' + resultdata[i].ShiftName + '</td><td>' + resultdata[i].ServiceType + '</td><td>' + resultdata[i].LocationName + '</td><td><a href="#" onclick = "showCabRemarksPopup(' + resultdata[i].CabRequestId + ')">' + resultdata[i].Status + '</a></td><td><div><button  title="Edit" onclick="viewCabRequestDetail(' + resultdata[i].CabRequestId + ', ' + resultdata[i].ShiftId + ', ' + resultdata[i].CabRouteId + ',' + resultdata[i].LocationId + ',\'' + resultdata[i].LocationDetail + '\',\'' + resultdata[i].Date + '\',\'' + resultdata[i].StatusCode + '\');" class="btn btn-success btn-sm"><i class="fa fa-edit"></i></button>&nbsp;<button title="Cancel" onclick="cancelCabRequest(' + resultdata[i].CabRequestId + ');" class="btn btn-danger btn-sm"><i class="fa fa-remove"></i></button></div></td></tr>'; //<td>' + resultdata[i].Remarks + '</td>
                        }
                    }
                }
                else {
                    html += '<tr><td colspan="5"><div class="text-danger text-center" style="padding-top:10px">No data available in table</div></td></tr>';
                }
            }
            else {
                html += '<tr><td colspan="5"><div class="text-danger text-center" style="padding-top:10px">No data available in table</div></td></tr>';
            }
            html += '</tbody></table>';
            $("#tblCabRequest").html(html);
        });

    }
    else {
        html += '<tr><td colspan="5"><div class="text-danger text-center" style="padding-top:10px">No data available in table</div></td></tr>';
        $("#tblCabRequest").html(html);
    }
}

function showCabRemarksPopup(requestId) {
    var jsonObject = {
        'requestId': requestId,
        'type': "CAB",
    };
    calltoAjax(misApiUrl.getApproverRemarks, "POST", jsonObject,
        function (result) {
            if (result !== "ERROR") {
                if (result === "") {
                    result = "NA";
                }
                $("#cabRequestRemark").val(result);
                $("#cabRequestRemark").attr('disabled', true);
                $("#mypopupCabRequestRemark").modal("show");
            }
        });
}

function getCabDetailsToBookCab() {
    var jsonObject = {
        forScreen: "USER"
    }
    calltoAjax(misApiUrl.isValidTimeForCabBooking, "POST", jsonObject,
        function (result) {
            if (result != null) {
                if (!result) {
                    misAlert("<span class='text-danger'>Deadline crossed. The cut off time for cab booking is 6 PM(Mon to Fri).</span>", "Oops", "warning");
                }
                else {
                    getCabServiceType();
                    getContactDetails();
                    $("#hiddenCabRequestId").val(0);
                    $('#contactType').prop('checked', true);
                    $("#pickUPEmpContactNo").attr("disabled", true);

                    $("#contactType").change(function () {
                        if ($("#contactType").is(':checked')) {
                            $("#pickUPEmpContactNo").attr("disabled", true);
                            $("#pickUPEmpContactNo").val($("#hdnEmpContactNo").val());
                        }
                        else {
                            $("#pickUPEmpContactNo").removeAttr("disabled");
                            $("#pickUPEmpContactNo").val("");
                        }
                    });

                    $('#contactTypeDrop').prop('checked', true);
                    $("#dropEmpContactNo").attr("disabled", true);

                    $("#contactTypeDrop").change(function () {
                        if ($("#contactTypeDrop").is(':checked')) {
                            $("#dropEmpContactNo").attr("disabled", true);
                            $("#dropEmpContactNo").val($("#hdnEmpContactNo").val());
                        }
                        else {
                            $("#dropEmpContactNo").val("");
                            $("#dropEmpContactNo").removeAttr("disabled");
                        }
                    });

                    $(".toggle").removeClass("off");
                    $("#pickUPLocationDetail").val(""),
                        $("#dropLocationDetail").val(""),

                        $("#btnBookOrUpdateForDrop").hide();
                    $("#btnBookOrUpdateForPickUp").show();

                    $('a[href="#tabDrop"]').removeClass("active");
                    $('a[href="#tabPickup"]').addClass("active");
                    $("#tabDrop").removeClass("active");
                    $("#tabPickup").addClass("active");

                    $("#ddlPickUPRoute").removeClass("error-validation");
                    $("#ddlPickUPDate").removeClass('error-validation');
                    $("#ddlCompanyLocation").removeClass('error-validation');
                    $("#ddlPickUPShift").removeClass('error-validation');
                    $("#ddlPickUPLocation").removeClass('error-validation');
                    $("#pickUPEmpContactNo").removeClass('error-validation');

                    $("#ddlDropRoute").removeClass('error-validation');
                    $("#ddlDropDate").removeClass('error-validation');
                    $("#ddlCompanyLocationForDrop").removeClass('error-validation');
                    $("#ddlDropShift").removeClass('error-validation');
                    $("#ddlDropLocation").removeClass('error-validation');
                    $("#dropEmpContactNo").removeClass('error-validation');

                    $(".select2").select2();

                    $('#mypopupCabRequest').modal('show');
                    $("#btnBookOrUpdate").html("<i class='fa fa-save'>&nbsp;Book");
                }
            }
        });
}

$('a[href="#tabPickup"]').on('click', function () {
    getCompanyLocation();
    bindDatesForPickup();
    $("#btnBookOrUpdateForDrop").hide();
    $("#btnBookOrUpdateForPickUp").show();
});

$('a[href="#tabDrop"]').on('click', function () {
    getCompanyLocationForDrop();
    bindDatesForDrop();
    $("#btnBookOrUpdateForDrop").show();
    $("#btnBookOrUpdateForPickUp").hide();


});

function getContactDetails() {
    var jsonObject =  {
        type: "CAB",
        userAbrhs: misSession.userabrhs
    }
    calltoAjax(misApiUrl.getLastRecordDetails, "POST", jsonObject,
        function (result) {
            if (result != null) {
                $("#hdnEmpContactNo").val(result.AlternativeContactNo);
                $("#pickUPEmpContactNo").val(result.AlternativeContactNo);
                $("#dropEmpContactNo").val(result.AlternativeContactNo);
            }
        });
}

// For Pick up
$("#ddlCompanyLocation").change(function () {
    bindCabRoutes();
});

$("#ddlPickUpDate").change(function () {
    bindCabShift();
});

$("#ddlPickUPRoute").change(function () {
    bindCabPickLocations();
});

//For Drop
$("#ddlCompanyLocationForDrop").change(function () {
    bindCabRoutesForDrop();
});

$("#ddlDropDate").change(function () {
    bindCabShiftForDrop();
});

$("#ddlDropRoute").change(function () {
    bindCabDropLocations();
});

function getCabServiceType() {
    calltoAjax(misApiUrl.getCabServiceType, "POST", '',
        function (result) {
            if (result.length > 0) {
                $.each(result, function (index, val) {
                    if (val.ServiceType === "Drop") {
                        $("#hdnDropServiceTypeId").val(val.ServiceTypeId);
                    }
                    else {
                        $("#hdnPickServiceTypeId").val(val.ServiceTypeId);
                    }
                });
                getCompanyLocation();
                bindDatesForPickup();
            }
        });
}

function bindMonthYear() {
    $("#txtMonth").empty();
    calltoAjax(misApiUrl.getCabRequestMonthYear, "POST", '', function (result) {
        if (result !== null) {
            $.each(result, function (idx, item) {
                $("#txtMonth").append($("<option></option>").val(item.KeyValue).html(item.Text));
            });
            var d = new Date();
            var month = d.getMonth() + 1;
            var year = d.getFullYear();
            var value = month + "-" + year;
            $("#txtMonth").val(value);
            getCabRequestDetails();
        }
    });
}

//For PickUps
function getCompanyLocation() {
    var locationId = parseInt(misSession.companylocationid);
    
    calltoAjax(misApiUrl.getCompanyLocation, "POST", '',
        function (result) {
            $("#ddlCompanyLocation").empty();
            $("#ddlCompanyLocation").append("<option value='0'>Select</option>");
            if (result.length > 0) {
                $.each(result, function (index, val) {
                    $("#ddlCompanyLocation").append("<option value=" + val.Value + ">" + val.Text + "</option>");
                });
            }
            $("#ddlCompanyLocation").val(locationId);
            bindCabRoutes();
        });
}

function bindDatesForPickup() {
    var jsonObject = {
        ServiceTypeId: $("#hdnPickServiceTypeId").val(), // for pickup
        ForScreen: "USER"
    };
    calltoAjax(misApiUrl.getDatesForPickAndDrop, "POST", jsonObject,
        function (result) {
            $("#ddlPickUpDate").empty();
            $("#ddlPickUpDate").append("<option value='0'>Select</option>");
            if (result.length > 0) {
                $.each(result, function (index, val) {
                    $("#ddlPickUpDate").append("<option value=" + val.Date + ">" + val.DateText + "</option>");
                });
            }
            $("#ddlPickUpDate").val(0);
            bindCabShift();
        });
}

function bindCabShift() {
    $("#ddlPickUPShift").empty();
    $("#ddlPickUPShift").append("<option value='0'>Select</option>");

    if ($("#ddlPickUpDate").val() !== "0") {
        var jsonObject = {
            ServiceTypeIds: $("#hdnPickServiceTypeId").val(),
            Dates: $("#ddlPickUpDate").val(),
            ForScreen: "USER"
        };
        calltoAjax(misApiUrl.getShiftDetails, "POST", jsonObject,
            function (result) {
                if (result.length > 0) {
                    $.each(result, function (key, value) {
                        $("#ddlPickUPShift").append("<option value=" + value.ShiftId + ">" + value.ShiftName + "</option>");
                    });
                }
                $("#ddlPickUPShift").val(0);
            });
    }
}

function bindCabRoutes() {
    $("#ddlPickUPRoute").empty();
    $("#ddlPickUPRoute").append("<option value='0'>Select</option>");

    var jsonObject = {
        CompanyLocationIds: $("#ddlCompanyLocation").val(),
        ServiceTypeIds: $("#hdnPickServiceTypeId").val() // for pickup:
    };
    calltoAjax(misApiUrl.getCabRoutes, "POST", jsonObject,
        function (result) {
            if (result.length > 0) {
                $.each(result, function (index, val) {
                    $("#ddlPickUPRoute").append("<option value=" + val.CabRouteId + ">" + val.CabRoute + "</option>");
                });
            }
            $("#ddlPickUPRoute").val(0);
            bindCabPickLocations();
        });
}

function bindCabPickLocations() {
    $("#ddlPickUPLocation").empty();
    $("#ddlPickUPLocation").append("<option value='0'>Select</option>");

    var jsonObject = {
        CompanyLocationId: $("#ddlCompanyLocation").val(),
        CabRouteId: $("#ddlPickUPRoute").val(),
        ServiceTypeId: $("#hdnPickServiceTypeId").val() // for pickup:
    }
    calltoAjax(misApiUrl.getCabDropLocations, "POST", jsonObject,
        function (result) {
            if (result.length > 0) {
                $.each(result, function (key, value) {
                    $("#ddlPickUPLocation").append("<option value=" + value.LocationId + ">" + value.LocationName + "</option>");
                });
            }
            $("#ddlPickUPLocation").val(0);
        });
}


//For Drop
function getCompanyLocationForDrop() {
    var locationId = parseInt(misSession.companylocationid);
    calltoAjax(misApiUrl.getCompanyLocation, "POST", '',
        function (result) {
            $("#ddlCompanyLocationForDrop").empty();
            $("#ddlCompanyLocationForDrop").append("<option value='0'>Select</option>");
            if (result.length > 0) {
                $.each(result, function (index, val) {
                    $("#ddlCompanyLocationForDrop").append("<option value=" + val.Value + ">" + val.Text + "</option>");
                });
            }
            $("#ddlCompanyLocationForDrop").val(locationId);
            bindCabRoutesForDrop();
        });
}

function bindDatesForDrop() {
    var jsonObject = {
        ServiceTypeId: $("#hdnDropServiceTypeId").val(), // for pickup
        ForScreen: "USER"
    };
    calltoAjax(misApiUrl.getDatesForPickAndDrop, "POST", jsonObject,
        function (result) {
            $("#ddlDropDate").empty();
            $("#ddlDropDate").append("<option value='0'>Select</option>");
            if (result.length > 0) {
                $.each(result, function (index, val) {
                    $("#ddlDropDate").append("<option value=" + val.Date + ">" + val.DateText + "</option>");
                });
            }
            $("#ddlDropDate").val(0);
            bindCabShiftForDrop();
        });
}

function bindCabShiftForDrop() {
    $("#ddlDropShift").empty();
    $("#ddlDropShift").append("<option value='0'>Select</option>");

    if ($("#ddlDropDate").val() !== "0") {
        var jsonObject = {
            ServiceTypeIds: $("#hdnDropServiceTypeId").val(),
            Dates: $("#ddlDropDate").val(),
            ForScreen: "USER"
        };
        calltoAjax(misApiUrl.getShiftDetails, "POST", jsonObject,
            function (result) {
                if (result.length > 0) {
                    $.each(result, function (key, value) {
                        $("#ddlDropShift").append("<option value=" + value.ShiftId + ">" + value.ShiftName + "</option>");
                    });
                }
                $("#ddlDropShift").val(0);
            });
    }
}

function bindCabRoutesForDrop() {
    $("#ddlDropRoute").empty();
    $("#ddlDropRoute").append("<option value='0'>Select</option>");

    var jsonObject = {
        CompanyLocationIds: $("#ddlCompanyLocationForDrop").val(),
        ServiceTypeIds: $("#hdnDropServiceTypeId").val() // for pickup:
    };
    calltoAjax(misApiUrl.getCabRoutes, "POST", jsonObject,
        function (result) {
            if (result.length > 0) {
                $.each(result, function (index, val) {
                    $("#ddlDropRoute").append("<option value=" + val.CabRouteId + ">" + val.CabRoute + "</option>");
                });
            }
            $("#ddlDropRoute").val(0);
            bindCabDropLocations();
        });
}

function bindCabDropLocations() {
    $("#ddlDropLocation").empty();
    $("#ddlDropLocation").append("<option value='0'>Select</option>");

    var jsonObject = {
        CompanyLocationId: $("#ddlCompanyLocationForDrop").val(),
        CabRouteId: $("#ddlDropRoute").val(),
        ServiceTypeId: $("#hdnDropServiceTypeId").val() // for pickup:
    }
    calltoAjax(misApiUrl.getCabDropLocations, "POST", jsonObject,
        function (result) {
            if (result.length > 0) {
                $.each(result, function (key, value) {
                    $("#ddlDropLocation").append("<option value=" + value.LocationId + ">" + value.LocationName + "</option>");
                });
            }
            $("#ddlDropLocation").val(0);
        });
}


$("#btnBookOrUpdateForPickUp").click(function () {
    bookOrUpdateCabPickUpRequest();
});

$("#btnBookOrUpdateForDrop").click(function () {
    bookOrUpdateCabDropRequest();
});

function bookOrUpdateCabPickUpRequest() {
    if (!validateControls('tabPickup'))
        return false;

    var contact = $("#pickUPEmpContactNo").val();
    var pattern = /^\d{10}$/;
  
    if (pattern.test(contact) === false)
        misAlert("Invalid contact number", "Warning", "warning");
    else {
        var data = {
            CabRequestId: $("#hiddenPickUPRequestId").val(),
            CompanyLocationId: $("#ddlCompanyLocation").val(),
            Date: $("#ddlPickUpDate").val(),
            ShiftId: $("#ddlPickUPShift").val(),
            CabRouteId: $("#ddlPickUPRoute").val(),
            LocationId: $("#ddlPickUPLocation").val(), // $("#cabTillDate").val(),
            LocationDetail: $("#pickUPLocationDetail").val(),
            ServiceTypeId: $("#hdnPickServiceTypeId").val(), // for pickup:
            EmpContactNo: contact,
            ShiftName: $("#ddlPickUPShift option:selected").html(),
            ReviewAppUrl: misAppUrl.reviewCabRequestAppUrl
        };
        calltoAjax(misApiUrl.bookOrUpdateCabRequest, "POST", data,
            function (data) {
                if (data.Result == 1) {
                    misAlert("Request processed successfully.", "Success", "success");
                    getCabRequestDetails();
                    $('#mypopupCabRequest').modal('hide');
                }
                else if (data.Result == 2)
                    misAlert("You have already booked cab for this shift.", "Warning", "warning");
                else if (data.Result == 3)
                    misAlert("Deadline crossed. Unable to fulfill your request.", "Oops", "warning");
                else if (data.Result = 4) {
                    misAlert(data.Message, "Warning", "warning");
                }
                else
                    misAlert("Unable to process request. Please try again", "Error", "error");
            });
    }
}

function bookOrUpdateCabDropRequest() {
    if (!validateControls('tabDrop'))
        return false;

    var phoneNo = $("#dropEmpContactNo").val();
    var pattern = /^\d{10}$/;

    if (pattern.test(phoneNo) === false)
        misAlert("Invalid contact number", "Warning", "warning");

    else {

        var data = {
            CabRequestId: $("#hiddenDropRequestId").val(),
            CompanyLocationId: $("#ddlCompanyLocationForDrop").val(), // $("#cabTillDate").val(),
            Date: $("#ddlDropDate").val(),
            ShiftId: $("#ddlDropShift").val(),
            CabRouteId: $("#ddlDropRoute").val(),
            LocationId: $("#ddlDropLocation").val(), // $("#cabTillDate").val(),
            LocationDetail: $("#dropLocationDetail").val(),
            ServiceTypeId: $("#hdnDropServiceTypeId").val(), // for pickup:
            EmpContactNo: phoneNo,
            ShiftName: $("#ddlDropShift option:selected").html(),
            ReviewAppUrl: misAppUrl.reviewCabRequestAppUrl
        };
        calltoAjax(misApiUrl.bookOrUpdateCabRequest, "POST", data,
            function (data) {
                if (data.Result == 1) {
                    misAlert("Request processed successfully.", "Success", "success");
                    getCabRequestDetails();
                    $('#mypopupCabRequest').modal('hide');
                }
                else if (data.Result == 2)
                    misAlert("You have already booked cab for this shift.", "Warning", "warning");
                else if (data.Result == 3)
                    misAlert("Deadline crossed. Unable to fulfill your request.", "Oops", "warning");
                else if (data.Result = 4) {
                    misAlert(data.Message, "Warning", "warning");
                }
                else
                    misAlert("Unable to process request. Please try again", "Error", "error");
            });
    }
}

$("#btnCloseCabRequest").click(function () {
    $('#mypopupCabRequest').modal('hide');

});

//function viewCabRequestDetail(cabRequestId, shiftId, routeId, dropLocationId, locationDetail, date, statusCode) {
//    if (statusCode == "CA" || statusCode == "RJ" ) {
//        $("#btnBookOrUpdate").hide();
//    }
//    else
//        $("#btnBookOrUpdate").show();
//    $("#hiddenCabRequestId").val(cabRequestId);
//    $("#cabShiftId").removeClass("error-validation");
//    $("#dropLocationId").removeClass("error-validation");
//    bindShiftDetails(shiftId);
//    bindCabRoutes(routeId, dropLocationId);
//    $("#locationDetail").val(locationDetail);
//    $('#mypopupCabRequest').modal('show');
//    $("#cabDate").datepicker().datepicker("setDate", date);
//    $("#cabDate input").attr("disabled", true);
//    $("#btnBookOrUpdate").html("<i class='fa fa-edit'>&nbsp;Update");
//}

$("#btnCloseViewCabRequest").click(function () {
    $('#mypopupViewCabRequestDetails').modal('hide');
});

function cancelCabRequest(cabRequestId) {
    var reply = misConfirm("Are you sure you want to cancel this request?", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                CabRequestId: cabRequestId,
                StatusCode: "CA",
                Remarks: "Cancelled",
                ForScreen: "USER"
            }
            calltoAjax(misApiUrl.takeActionOnCabRequest, "POST", jsonObject,
                function (result) {
                    if (result == 1) {
                        misAlert("Cab request has been cancelled successfully.", "Success", "success");
                        getCabRequestDetails();
                    }
                    else if (result == 3) {
                        misAlert("Deadline crossed. Unable to fulfill your request.", "Warning", "warning");
                    }
                    else {
                        misAlert("Unable to process request. Please try again", "Error", "error");
                    }
                });
        }
    });
}

//end of cab request module

function getAttendanceByMonthYear() {
    var ddlText = $("#selectduration option:selected").text();
    var month = moment().month(ddlText.split(' ')[0]).format("M");
    var year = ddlText.split(' ')[1];
    getEmpAttendanceData(month, year);
}

function getEmpAttendanceData(month, year) {
    var jsonObject = {
        userAbrhs: misSession.userabrhs,
        year: year,     //new Date().getFullYear(),
        month: month,    //new Date().getMonth() + 1,
    };
    calltoAjax(misApiUrl.getSelfAttendanceData, "POST", jsonObject, function (result) {
        var html = '<table class="tbl-typical fixed-header text-left" id="employeesAttendenceTable">';
        html += '<thead><tr><th><div>Date</div></th><th><div>In-Time</div></th><th><div>Out-Time</div></th><th><div>Working Hours</div></th></tr></thead><tbody>';//<th><div>Remarks</div></th>
        if (result) {
            var resultdata = $.parseJSON(JSON.stringify(result));
            if (resultdata && resultdata.length > 0) {
                for (var i = 0; i < resultdata.length; i++) {
                    var weekOff = "";
                    if (resultdata[i].IsWeekend) {
                        weekOff = "weekoff-row";
                    }
                    if (resultdata[i].IsNightShift && resultdata[i].IsApproved) {
                        html += '<tr class="' + weekOff + '"><td>' + resultdata[i].DisplayDate + '</td><td>' + resultdata[i].InTime + '</td><td>' + resultdata[i].OutTime + '</td><td><span>' + resultdata[i].WorkingHours + '<span>&nbsp;<span class="nightShift">N</span><span class="approved">A</span></td></tr>';
                    }
                    else if (resultdata[i].IsNightShift && resultdata[i].IsPending) {
                        html += '<tr class="' + weekOff + '"><td>' + resultdata[i].DisplayDate + '</td><td>' + resultdata[i].InTime + '</td><td>' + resultdata[i].OutTime + '</td><td><span>' + resultdata[i].WorkingHours + '<span>&nbsp;<span class="nightShift">N</span><span class="pending">P</span></td></tr>';
                    }
                    else {
                        html += '<tr class="' + weekOff + '"><td>' + resultdata[i].DisplayDate + '</td><td>' + resultdata[i].InTime + '</td><td>' + resultdata[i].OutTime + '</td><td>' + resultdata[i].WorkingHours + '</td></tr>'; //<td>' + resultdata[i].Remarks + '</td>
                    }

                }
            }
            else {
                html += '<tr><td colspan="5"><div class="text-danger text-center" style="padding-top:10px">No data available in table</div></td></tr>';
            }
        }
        else {
            html += '<tr><td colspan="5"><div class="text-danger text-center" style="padding-top:10px">No data available in table</div></td></tr>';
        }
        html += '</tbody></table>';
        $("#tblemployeesAttendence").html(html);
    });
}

function getTTTournamentData(showWidget) {
    var jsonObject = {
        userAbrhs: misSession.userabrhs,
        MatchDate: moment(new Date()).format('MM/DD/YYYY')
    }
    calltoAjaxWithoutLoader(misApiUrl.getTTTournamentData, "POST", jsonObject,
        function (result) {
            var resultdata = $.parseJSON(JSON.stringify(result));
            if (resultdata && resultdata.length > 0) {
                //if (showWidget == 1) {
                //    var html = '<div class="col-xl-6 dashboard-column"><section id="TournamentLiveScore" class="box-typical box-typical-dashboard panel panel-default scrollable"><header class="box-typical-header panel-heading" style="background-image:url(../../img/table-tennis.jpg);background-repeat: round;background-size: 100%;text-shadow: 1px 1px 1px #000,3px 3px 5px blue;color:#fff;">';
                //    html += '<h3 class="panel-title">TT Tournament - Score Board</h3></header><div class="box-typical-body panel-body" id="tblTournamentLiveScore" style="text-align: center;"><img src="../../img/dot-loader.gif" style="margin-top:50px">';
                //    html += '</div></section></div>';
                //    $("#divPanel").append(html).ready(function () {
                //        $("#TournamentLiveScore").lobiPanel();
                //    });
                //}
                isTournamentRunning = true;
                $("#tblTournamentLiveScore").html("");
                var html = '<table class="tbl-typical text-left">';
                html += '<tr><th><div>#</div></th><th><div>Team</div></th><th><div>G1</div></th><th><div>G2</div></th><th><div>G3</div></th><th><div>G4</div></th><th><div>G5</div></th></tr>';
                var count = 1;

                for (var j = 0; j < resultdata.length; j += 2) {
                    var counter = 1;
                    for (var i = 0; i < resultdata.length; i++) {
                        if (resultdata[i].TournamentScheduleId === resultdata[j].TournamentScheduleId) {
                            var liveContent = '';
                            if (resultdata[i].IsLive) {
                                liveContent = '</br><span style="background: red;padding: 2px 10px;border-radius: 5px;font-size: 9px;color: white;">live</span>'
                            }
                            var totalScore1 = 0;
                            var totalScore2 = 0;
                            if (resultdata[i].TournamentTeamId === resultdata[i].TeamId) {
                                totalScore1 = resultdata[i].G1Score + resultdata[i].G2Score + resultdata[i].G3Score;// + resultdata[i].G4Score + resultdata[i].G5Score;
                            }
                            if (resultdata[i].TournamentVSTeamId === resultdata[i].TeamId) {
                                totalScore2 = resultdata[i].G1Score + resultdata[i].G2Score + resultdata[i].G3Score;// + resultdata[i].G4Score + resultdata[i].G5Score;
                            }
                            if (resultdata[i].TournamentTeamId === resultdata[i].TeamId) {
                                if (totalScore1 > totalScore2) {
                                    if (counter === 1) {
                                        counter = counter + 1;
                                        html += '<tr><td rowspan="2" style="padding: 5px;text-align: center;border-bottom:2px solid #333">' + (count) + liveContent + '</td><td style="border-bottom:1px solid #333">' + resultdata[i].TournamentUsers + '&nbsp;<i class="fa fa-trophy" aria-hidden="true" style="color: gold !important;"></i></td><td style="border-bottom:1px solid #333">' + resultdata[i].G1Score + '</td><td style="border-bottom:1px solid #333">' + resultdata[i].G2Score + '</td><td style="border-bottom:1px solid #333">' + resultdata[i].G3Score + '</td><td style="border-bottom:1px solid #333">NA*</td><td style="border-bottom:1px solid #333">NA*</td></tr>';
                                        count = count + 1;
                                    }
                                    else {
                                        html += '<tr><td style="border-bottom:2px solid #333">' + resultdata[i].TournamentUsers + '&nbsp;<i class="fa fa-trophy" aria-hidden="true" style="color: gold !important;"></i></td><td style="border-bottom:2px solid #333">' + resultdata[i].G1Score + '</td><td style="border-bottom:2px solid #333">' + resultdata[i].G2Score + '</td><td style="border-bottom:2px solid #333">' + resultdata[i].G3Score + '</td><td style="border-bottom:2px solid #333">NA*</td><td style="border-bottom:2px solid #333">NA*</td></tr>';
                                    }
                                } else {
                                    if (counter === 1) {
                                        counter = counter + 1;
                                        html += '<tr><td rowspan="2" style="padding: 5px;text-align: center;border-bottom:2px solid #333">' + (count) + liveContent + '</td><td style="border-bottom:1px solid #333">' + resultdata[i].TournamentUsers + '</td><td style="border-bottom:1px solid #333">' + resultdata[i].G1Score + '</td><td style="border-bottom:1px solid #333">' + resultdata[i].G2Score + '</td><td style="border-bottom:1px solid #333">' + resultdata[i].G3Score + '</td><td style="border-bottom:1px solid #333">NA*</td><td style="border-bottom:1px solid #333">NA*</td></tr>';
                                        count = count + 1;
                                    }
                                    else {
                                        html += '<tr><td style="border-bottom:2px solid #333">' + resultdata[i].TournamentUsers + '</td><td style="border-bottom:2px solid #333">' + resultdata[i].G1Score + '</td><td style="border-bottom:2px solid #333">' + resultdata[i].G2Score + '</td><td style="border-bottom:2px solid #333">' + resultdata[i].G3Score + '</td><td style="border-bottom:2px solid #333">NA*</td><td style="border-bottom:2px solid #333">NA*</td></tr>';
                                    }
                                }
                            }
                            if (resultdata[i].TournamentVSTeamId === resultdata[i].TeamId) {
                                if (totalScore1 > totalScore2) {
                                    if (counter === 1) {
                                        counter = counter + 1;
                                        html += '<tr><td rowspan="2" style="padding: 5px;text-align: center;border-bottom:2px solid #333">' + (count) + liveContent + '</td><td style="border-bottom:1px solid #333">' + resultdata[i].TournamentVSUsers + '&nbsp;<i class="fa fa-trophy" aria-hidden="true" style="color: gold !important;"></i></td><td style="border-bottom:1px solid #333">' + resultdata[i].G1Score + '</td><td style="border-bottom:1px solid #333">' + resultdata[i].G2Score + '</td><td style="border-bottom:1px solid #333">' + resultdata[i].G3Score + '</td><td style="border-bottom:1px solid #333">NA*</td><td style="border-bottom:1px solid #333">NA*</td></tr>';
                                        count = count + 1;
                                    }
                                    else {
                                        html += '<tr><td style="border-bottom:2px solid #333">' + resultdata[i].TournamentVSUsers + '&nbsp;<i class="fa fa-trophy" aria-hidden="true" style="color: gold !important;"></i></td><td style="border-bottom:2px solid #333">' + resultdata[i].G1Score + '</td><td style="border-bottom:2px solid #333">' + resultdata[i].G2Score + '</td><td style="border-bottom:2px solid #333">' + resultdata[i].G3Score + '</td><td style="border-bottom:2px solid #333">NA*</td><td style="border-bottom:2px solid #333">NA*</td></tr>';
                                    }
                                } else {
                                    if (counter === 1) {
                                        counter = counter + 1;
                                        html += '<tr><td rowspan="2" style="padding: 5px;text-align: center;border-bottom:2px solid #333">' + (count) + liveContent + '</td><td style="border-bottom:1px solid #333">' + resultdata[i].TournamentVSUsers + '</td><td style="border-bottom:1px solid #333">' + resultdata[i].G1Score + '</td><td style="border-bottom:1px solid #333">' + resultdata[i].G2Score + '</td><td style="border-bottom:1px solid #333">' + resultdata[i].G3Score + '</td><td style="border-bottom:1px solid #333">NA*</td><td style="border-bottom:1px solid #333">NA*</td></tr>';
                                        count = count + 1;
                                    }
                                    else {
                                        html += '<tr><td style="border-bottom:2px solid #333">' + resultdata[i].TournamentVSUsers + '</td><td style="border-bottom:2px solid #333">' + resultdata[i].G1Score + '</td><td style="border-bottom:2px solid #333">' + resultdata[i].G2Score + '</td><td style="border-bottom:2px solid #333">' + resultdata[i].G3Score + '</td><td style="border-bottom:2px solid #333">NA*</td><td style="border-bottom:2px solid #333">NA*</td></tr>';
                                    }
                                }
                            }
                        }

                    }
                }
                html += '<tr><td colspan="7">&nbsp;&nbsp;*Game 4 & 5 scores only applicable for post Semifinal stages.</td></tr>';
                html += '</table>';
                $("#tblTournamentLiveScore").html(html);
            }
        });
}

function getuserProfileData() {
    var jsonObject = {
        userAbrhs: misSession.userabrhs
    }
    calltoAjax(misApiUrl.getUserPrfileData, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            var imagepath = data.ImagePath === "" ? "../img/avatar-sign.png" : misApiProfileImageUrl + data.ImagePath;
            var LoginUserName = data.FirstName + ' ' + data.LastName;
            $("#userImageProfile").attr("src", imagepath);
            $("#imagepath").attr("src", imagepath);
            $("#userName").html(LoginUserName);
            $("#designation").html(data.Designation),
                $("#emailId").html(data.EmailId);
            $("#mobileNumber").html(data.MobileNumber);
            $("#displayJoiningDate").html(data.DisplayJoiningDate);
            $("#mobileNumber").html(data.MobileNumber);
            $("#userLocation").html(data.UserLocation);
            _genderId = result.GenderId;
        });
}

var _birthdayData = null;
var _holidayData = null;

function bindBirthDayHolidayList(type) {
    if (_birthdayData === null && _holidayData === null) {
        var jsonObject = {
            userAbrhs: misSession.userabrhs
        }
        calltoAjax(misApiUrl.getUpComingBIrthdayandHolidayData, "POST", jsonObject,
            function (result) {
                if (type === 1) {
                    _holidayData = HolidayData($.parseJSON(JSON.stringify(result.HolidaysList)));
                }
                if (type === 2) {
                    _birthdayData = BirthdayData($.parseJSON(JSON.stringify(result.BirthDayUsersList)));
                }
            });
    }

}

function BirthdayData(_birthdayData) {
    resultdata = _birthdayData;
    var html = '<table class="tbl-typical fixed-header text-left"><thead><tr><th><div>&nbsp;</div></th><th><div>Date</div></th><th><div>Name</div></th><th><div></div></th></tr></thead>';
    for (var i = 0; i < resultdata.length; i++) {
        html += '<tr><td><img src="../../img/birthday.gif"></td><td>' + resultdata[i].DisplayDate + '</td><td>' + resultdata[i].UserName + '</td><td><a onClick="birthsdaywish(\'' + resultdata[i].EmpAbrhs + '\',1)"><i class="fa fa-envelope" aria-hidden="true" style="color: #b348ae;"></i> Wish Birthday</a></td></tr>';
    }
    html += '</table>';
    $("#tblBirthday").html(html);
}

function HolidayData(_holidayData) {
    resultdata = _holidayData;
    var html = '<table class="tbl-typical fixed-header text-left"><thead><tr><th><div>Holiday</div></th><th><div>Date</div></th><th><div>Day</div></th></tr></thead>';
    for (var i = 0; i < resultdata.length; i++) {
        html += '<tr><td>' + resultdata[i].Holiday + '</td><td>' + resultdata[i].DisplayDate + '</td><td>' + resultdata[i].Day + '</td></tr>';
    }
    html += '</table>';
    $("#tblHoliday").html(html);
}

function getInOutTimeCurrentDayData() {
    var jsonObject = {
        userAbrhs: misSession.userabrhs
    }
    calltoAjax(misApiUrl.getInOutTimeCurrentDayData, "POST", jsonObject, function (result) {
        var resultdata = $.parseJSON(JSON.stringify(result));
        var inTime = (!resultdata || resultdata.InTime === null) ? "0:00" : resultdata.InTime;
        var outTime = (!resultdata || resultdata.OutTime === null) ? "0:00" : resultdata.OutTime;
        var workingHours = (!resultdata || resultdata.WorkingHours === null) ? "0:00" : resultdata.WorkingHours;
        var yWorkingHours = (!resultdata || resultdata.YesterdayWorkingHours === null) ? "0:00" : resultdata.YesterdayWorkingHours;
        $("#inTime").html(inTime);
        $("#outTime").html(outTime);
        $("#workingHours").html(workingHours);
        $("#yWorkingHours").html(yWorkingHours);
    });
}

//function getEmpAttendanceData(month, year) {
//    var jsonObject = {
//        userAbrhs: misSession.userabrhs,
//        year: year,     //new Date().getFullYear(),
//        month: month,    //new Date().getMonth() + 1,
//    };
//    calltoAjax(misApiUrl.getSelfAttendanceData, "POST", jsonObject, function (result) {
//        var html = '<table class="tbl-typical fixed-header text-left" id="employeesAttendenceTable">';
//        html += '<thead><tr><th><div>Date</div></th><th><div>Day</div></th><th><div>In-Time</div></th><th><div>Out-Time</div></th><th><div>Working Hours</div></th></tr></thead><tbody>';//<th><div>Remarks</div></th>
//        if (result) {
//            var resultdata = $.parseJSON(JSON.stringify(result));
//            if (resultdata && resultdata.length > 0) {
//                for (var i = 0; i < resultdata.length; i++) {
//                    html += '<tr><td>' + resultdata[i].DisplayDate + '</td><td>' + resultdata[i].Day + '</td><td>' + resultdata[i].InTime + '</td><td>' + resultdata[i].OutTime + '</td><td>' + resultdata[i].WorkingHours + '</td></tr>'; //<td>' + resultdata[i].Remarks + '</td>
//                }
//            }
//            else {
//                html += '<tr><td colspan="5"><div class="text-danger text-center" style="padding-top:10px">No data available in table</div></td></tr>';
//            }
//        }
//        else {
//            html += '<tr><td colspan="5"><div class="text-danger text-center" style="padding-top:10px">No data available in table</div></td></tr>';
//        }
//        html += '</tbody></table>';
//        $("#tblemployeesAttendence").html(html);
//    });
//}

function getTeamAttendanceData() {
    var jsonObject = {
        userAbrhs: misSession.userabrhs
    };

    calltoAjax(misApiUrl.getTeamAttendanceData, "POST", jsonObject, function (result) {
        var html = '<table class="tbl-typical fixed-header text-left">';//<th><div>Status</div></th>  //<td>' + resultdata[i].Status + '</td>
        html += '<thead><tr><th><div>Name</div></th><th align="center"><div>In-Time</div></th><th align="center"><div>Out-Time</div></th><th><div>Working Hours</div></th></tr></thead>';
        if (result) {
            var resultdata = $.parseJSON(JSON.stringify(result));
            if (resultdata && resultdata.length > 0) {
                for (var i = 0; i < resultdata.length; i++) {
                    html += '<tr role="row" class="odd"><td tabindex="0">' + resultdata[i].Name + '</td><td>' + resultdata[i].InTime + '</td><td>' + resultdata[i].OutTime + '</td><td>' + resultdata[i].WorkingHours + '</td></tr>';
                }
            }
            else {
                html += '<tr><td colspan="5"><div class="text-danger text-center" style="padding-top:10px">No data available in table</div></td></tr>';
            }
        }
        else {
            html += '<tr><td colspan="5"><div class="text-danger text-center" style="padding-top:10px">No data available in table</div></td></tr>';
        }
        html += '</table>';
        $("#tblTeamAttendence").html(html);
    });
}

function getSkills() {
    var jsonObject = {
        userAbrhs: misSession.userabrhs,
    }
    calltoAjax(misApiUrl.getUserSkills, "POST", jsonObject, function (result) {
        var html = '<table class="tbl-typical fixed-header text-left">';
        html += '<thead><tr><th><div>Skill</div></th><th><div>Proficiency Level</div></th><th align="center"><div>Experience (In Months)</div></th><th align="center"><div>Skill Type</div></th><th align="center"><div>Updated On</div></th></tr></thead>';
        if (result) {
            var resultdata = $.parseJSON(JSON.stringify(result));
            if (resultdata && resultdata.length > 0) {
                for (var i = 0; i < resultdata.length; i++) {
                    html += '<tr><td><a  onclick="showEditSkillsPopup(' + resultdata[i].UserSkillId + ',' + resultdata[0].SkillTypeId + ')" style="text-decoration: underline !important;" data-toggle="tooltip" title="Update Skill">' + resultdata[i].SkillName + '</a></td><td>' + resultdata[i].SkillLevelName + '</td><td align="center">' + resultdata[i].ExperienceMonths + '</td><td>' + resultdata[i].SkillTypeName + '</td><td>' + resultdata[i].UpdatedOn + '</td></tr>';
                }
            }
            else {
                html += '<tr><td colspan="5"><div class="text-danger text-center" style="padding-top:10px">No data available in table</div></td></tr>';
            }
        }
        else {
            html += '<tr><td colspan="5"><div class="text-danger text-center" style="padding-top:10px">No data available in table</div></td></tr>';
        }
        html += '</table>';
        $("#tblSkillSet").html(html);
    });
}

function showEditSkillsPopup(userSkillId, skillTypeId) {
    $("#hdnSkillDetailId").val(userSkillId);
    $("#hdnSkillTypeId").val(skillTypeId);
    loadModal("mypopupEditSkills", "skillsSettingsEdit", misAppUrl.editSkills, true);
}

function getMealOfTheDay() {
    var jsonObject = {
        userAbrhs: misSession.userabrhs,
    }
    calltoAjax(misApiUrl.getMealOfTheDay, "POST", jsonObject, function (result) {
        if (result) {
            var resultdata = $.parseJSON(JSON.stringify(result));
            if (resultdata && resultdata.length > 0) {
                var html = '<div class="col-xl-6 dashboard-column"><section id="MealOfTheDay" class="box-typical box-typical-dashboard panel panel-default scrollable"><header class="box-typical-header panel-heading">';
                html += '<h3 class="panel-title">Meal Of The Day</h3></header><div class="box-typical-body panel-body"  id="tblMealOfTheDay" style="text-align: center;"><img src="../../img/dot-loader.gif" style="margin-top:50px">';
                html += '</div></section></div>';
                $("#divPanel").append(html).ready(function () {
                    $("#MealOfTheDay").lobiPanel();
                });

                html = '<table class="tbl-typical text-left"';
                var count = false;
                for (var i = 0; i < resultdata.length; i++) {

                    count = true;
                    html += '<tr><th align="center" colspan="2">' + resultdata[i].MealPackage + '</th><th align="center" style="font-size: 22px;"><a onClick="foodFeedback(true,' + resultdata[i].MealPackagesId + ')"><i class="fa fa-thumbs-up" aria-hidden="true" style="color: #99cc55;"></i></a>';
                    html += '&nbsp <a onClick="foodFeedback(false,' + resultdata[i].MealPackagesId + ')"><i class="fa fa-thumbs-down" aria-hidden="true" style="color: #e82078;"></i></a></th></tr>';
                    for (var j = 0; j < resultdata[i].DishMenuList.length; j++) {
                        html += '<tr><td style="width:10%;"><img src="../../img/cookie.png" style="width:50%;"></td><td>&nbsp;<b>' + resultdata[i].DishMenuList[j].MenuName + '</b><br />&nbsp;<span style="color:#a09595">(' + resultdata[i].DishMenuList[j].DishName + ')<span><td></tr>';
                    }
                }
                html += '</table>';
                $("#tblMealOfTheDay").html(html);
            }
        }
    });
}

function getTeamLeaves() {
    var html = '<div class="col-xl-6 dashboard-column"><section id="TeamLeaves" class="box-typical box-typical-dashboard panel panel-default scrollable"><header class="box-typical-header panel-heading"><h3 class="panel-title">Team Leaves</h3>';
    html += '</header><div class="box-typical-body panel-body" id="tblTeamLeaves" style="text-align: center;"><img src="../../img/dot-loader.gif" style="margin-top:50px">';
    html += '</div></section></div>';
    $("#divPanel").append(html).ready(function () {
        $("#TeamLeaves").lobiPanel();
    });

    var jsonObject = {
        userAbrhs: misSession.userabrhs,
    }
    calltoAjax(misApiUrl.getTeamLeaves, "POST", jsonObject, function (result) {
        var html = '<table class="tbl-typical fixed-header text-left">';
        // html += '<thead><tr><th><div>Name</div></th><th><div>From</div></th><th><div>To</div></th><th><div>Type Of Leave</div></th></tr></thead>';
        html += '<thead><tr><th><div>Name</div></th><th><div>From</div></th><th><div>To</div></th></tr></thead>';

        if (result) {
            var resultdata = $.parseJSON(JSON.stringify(result));
            if (resultdata && resultdata.length > 0) {
                for (var i = 0; i < resultdata.length; i++) {
                    //html += '<tr><td>' + resultdata[i].EmployeeName + '</td><td>' + resultdata[i].DateFrom + '</td><td>' + resultdata[i].DateTo + '</td><td>' + resultdata[i].TypeOfLeave + '</td></tr>';
                    html += '<tr><td>' + resultdata[i].EmployeeName + '</td><td>' + resultdata[i].DateFrom + '</td><td>' + resultdata[i].DateTo + '</td></tr>';
                }
            }
            else {
                html += '<tr><td colspan="4"><div class="text-danger text-center" style="padding-top:10px">No data available in table</div></td></tr>';
            }
        }
        else {
            html += '<tr><td colspan="4"><div class="text-danger text-center" style="padding-top:10px">No data available in table</div></td></tr>';
        }
        html += '</table>';
        $("#tblTeamLeaves").html(html);
    });
}

function getWorkAnniversary() {
    var jsonObject = {
        userAbrhs: misSession.userabrhs,
    }
    calltoAjax(misApiUrl.getWorkAnniversary, "POST", jsonObject, function (result) {
        if (result && result.length > 0) {
            //var resultdata = $.parseJSON(JSON.stringify(result.DashboardAnniversaryList));
            var html = '<table class="tbl-typical fixed-header text-left" >';
            html += '<thead><tr><th><div>Date</div></th><th><div>Name</div></th><th></th></tr></thead>';
            for (var i = 0; i < result.length; i++) {
                html += '<tr><td>' + result[i].DisplayDate + '</td><td>' + result[i].Name + '</td><td><a onClick="birthsdaywish(\'' + result[i].EmpAbrhs + '\',2)"><i class="fa fa-envelope" aria-hidden="true" style="color: #b348ae;"></i> Wish Anniversary</a></td></tr>';
            }
            html += '</table>';
            $("#tblWorkAnniversary").html(html);
        }
        else {
            $("#tblWorkAnniversary").html('<div class="text-danger" style="padding-top:10px">No data available in table</div>');
        }
    });
}

function birthsdaywish(empAbrhs, isBirthDayWish) {
    _empAbrhs = empAbrhs;
    _isBirthDayWish = isBirthDayWish;

    $("#mypopupBirthdayWish").modal("show");
    if (isBirthDayWish === 1) {
        $("#spnWishesHeader").html("Birthday Wishes");
        $("#txtMailBody").val("Wish you many many happy returns of the day.");
    }
    else {
        $("#spnWishesHeader").html("Work Anniversary Wishes");
        $("#txtMailBody").val("Congrats on your work anniversary!");
    }
}

function foodFeedback(type, mealPackageDetailId) {
    _mealPackageDetailId = mealPackageDetailId;
    _type = type;
    $("#mypopupFoodFeedBack").modal("show");
    if (type) {
        $("#txtFeedBack").val("Very Good :) !");
    }
    else {
        $("#txtFeedBack").val("Not Good :( !");
    }
}

function SendMail() {
    var jsonObject = {
        wishTo: _empAbrhs,
        wishType: _isBirthDayWish,
        message: $("#txtMailBody").val(),
        userAbrhs: misSession.userabrhs,
    }
    calltoAjax(misApiUrl.wishEmployees, "POST", jsonObject, function (result) {
        if (result === 1) {
            misAlert("Thank You for Wishing", "Success", "success");
        }
        $("#mypopupBirthdayWish").modal("hide");
    });
}

function SendFeedBack() {
    var jsonObject = {
        userAbrhs: misSession.userabrhs,
        isLiked: _type,
        mealPackageDetailId: _mealPackageDetailId,
        comment: $("#txtFeedBack").val(),
    }
    calltoAjax(misApiUrl.submitMealFeedback, "POST", jsonObject, function (result) {
        if (result === 1) {
            $("#mypopupFoodFeedBack").modal("hide");
            misAlert("Thank You for your Feedback", "Success", "success");
        }
        if (result === 2) {
            $("#mypopupFoodFeedBack").modal("hide");
            misAlert("You have already submitted feedback for this meal package.", "Warning", "warning");
        }
    });
}

$("#btnCloseMail").click(function () {
    $("#mypopupBirthdayWish").modal("hide");
});

$("#btnCloseFeedBack").click(function () {
    $("#mypopupFoodFeedBack").modal("hide");
});

function getNewsScrollerData() {
    var jsonObject = {
        userAbrhs: misSession.userabrhs,
    }
    calltoAjax(misApiUrl.getNewsForSlider, "POST", jsonObject, function (result) {
        var html = '';
        if (result && result.length > 0) {
            $("#newsContainer").show().addClass("dashboard-section-padding"); 
            for (var i = 0; i < result.length; i++) {
                var link = result[i].NewsLink;
                var target = '';
                if (link && link !== '') {
                    if (result[i].IsInternal === true)
                        link = misAppBaseUrl + "/" + link;
                    else {
                        link = link;
                        target = '_blank';
                    }
                }
                else {
                    link = 'javascript:void(0)'
                }

                html += '<div class="ti_news"><a href="' + link + '" target="' + target + '"><span>' + result[i].NewsTitle + '</span> : ' + result[i].NewsDescription + '</a></div>';
            }
            $("#newsHeader .ti_content").append(html);
            _Ticker = $("#newsHeader").newsTicker();
        }
    });
}
//function loadPageOnRedirect(newsId) {
//    var jsonObject = {
//        newsId: newsId,
//        userAbrhs: misSession.userabrhs
//    }
//    calltoAjax(misApiUrl.getNews, "POST", jsonObject, function (result) {
//        var html = '';
//        if (result && result.length > 0) {
//            if (result.Link != null) {
//                window.location.href(result.Link);
//            }
//        }
//    });
//}

function getLeaveBalanceData() {
    var jsonObject = {
        userAbrhs: misSession.userabrhs
    }
    calltoAjax(misApiUrl.getLeaveBalanceData, "POST", jsonObject, function (result) {
        var resultdata = $.parseJSON(JSON.stringify(result));
        var html = '<table class="tbl-typical text-left">';
        if (resultdata) {
            html += '<tr><td>CL</td><td><a  style="text-decoration: underline !important;" onclick="showLeavePopup(' + "'CL'" + ')" >' + (resultdata.ClCount === null ? "NA" : resultdata.ClCount) + '</a></td></tr>' +
                '<tr><td>PL</td><td><a style="text-decoration: underline !important;" onclick="showLeavePopup(' + "'PL'" + ')">' + (resultdata.PlCount === null ? "NA" : resultdata.PlCount) + '</a></td></tr>' +
                //'<tr><td>Old PL</td><td><span class="label label-info" style="margin:0">' + (resultdata.OldPlCount === null ? "NA" : resultdata.OldPlCount) + '</span></td></tr>' +
                //'<tr><td>New PL</td><td><a onclick="show">' + (resultdata.NewPlCount === null ? "NA" : resultdata.NewPlCount) + '</span></td></tr>' +
                '<tr><td>Comp Off</td><td><a style="text-decoration: underline !important;" onclick="showCompOffPopup(' + "'COFF'" + ')">' + (resultdata.CompOffCount === null ? "NA" : resultdata.CompOffCount) + '</a></td></tr>' +
                '<tr><td>WFH</td><td><a style="text-decoration: underline !important;" onclick="showLeavePopup(' + "'WFH'" + ')">' + (resultdata.WfhCount === null ? "NA" : resultdata.WfhCount) + '</a></td></tr>' +
                '<tr><td>LNSA</td><td><a style="text-decoration: underline !important;" onclick="showLeavePopup(' + "'LNSA'" + ')">' + (resultdata.LnsaCount === null ? "NA" : resultdata.LnsaCount) + '</a></td></tr>' +
                '<tr><td>LWP Counter</td><td><a style="text-decoration: underline !important;" onclick="showLWPPopup(' + "'LWP'" + ')">' + (resultdata.LwpCount === null ? "NA" : resultdata.LwpCount) + '</a></td></tr>' +
                '<tr><td>5 CL once in a year</td><td>' + (resultdata.CloyAvailable === null ? "NA" : resultdata.CloyAvailable) + '</td></tr>';
            if (resultdata.Code === "FL") {
                html += '<tr><td>ML</td><td><a style="text-decoration: underline !important;" onclick="showMLPopUp(' + "'ML'" + ')">' + (resultdata.MLCount === null ? "NA" : resultdata.MLCount) + '</a></td></tr>'
            }
            else if (resultdata.Code === "ME") {
                html += '<tr><td>PL(M)</td><td><a style="text-decoration: underline !important;" onclick="showPLMPopUp(' + "'PL(M)'" + ')">' + (resultdata.PLMCount === null ? "NA" : resultdata.PLMCount) + '</a></td></tr>'
            }
            if (resultdata.Code === "EL") {
                html += '<tr><td>EL</td><td><a style="text-decoration: underline !important;" onclick="showELPopup(' + "'EL'" + ')">' + (resultdata.ElCount === null ? "NA" : resultdata.ElCount) + '</a></td></tr>'
            }
        }
        html += '</table>';
        $("#tblLeaveBalance").html(html);
    });
}
$("#btnCompOffClose").click(function () {
    $("#myCompPopup").modal("hide");
});
$("#btnLWPClose").click(function () {
    $("#myLWPPopup").modal("hide");
});
$("#btnClose").click(function () {
    $("#myLeavePopup").modal("hide");
    $("#myLeavePopup").on('hidden.bs.modal', function () {
        $(this).data('bs.modal', null);
    });
});

function showMLPopUp(LeaveType) {
    $("#myMLPopUp").modal("show");
    var jsonObject = {
        leaveType: LeaveType,
        year: misSession.fystartdate,
        'userAbrhs': misSession.userabrhs,
    };
    calltoAjax(misApiUrl.listDashboardLeavesByUserId, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblMLGrid").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    //{
                    //    filename: 'Leave History List',
                    //    extend: 'collection',
                    //    text: 'Export',
                    //    buttons: [{ extend: 'copy' },
                    //    { extend: 'excel', filename: 'Leave History List' },
                    //    { extend: 'pdf', filename: 'Leave History List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                    //    { extend: 'print', filename: 'Leave History List' },
                    //    ]
                    //}
                ],
                "responsive": true,
                "autoWidth": false,
                "paging": true,
                "bLengthChange": false,
                "searching": false,
                "bDestroy": true,
                "ordering": true,
                "order": [],
                "info": true,
                "deferRender": true,
                "aaData": data,
                "aoColumns": [

                    {
                        "mData": "FromDate",
                        "sTitle": "From",
                    },
                    {
                        "mData": "TillDate",
                        "sTitle": "Till",

                    },
                    {
                        "mData": "LeaveType",
                        "sTitle": "Type",
                    },
                    {
                        "mData": "NoOfDays",
                        "sTitle": "Count",
                    },
                    {
                        "mData": "Status",
                        "sTitle": "Status"
                    }
                ]
            });
        });
}

function showPLMPopUp(LeaveType) {
    $("#myPLMPopUp").modal("show");
    var jsonObject = {
        leaveType: LeaveType,
        year: misSession.fystartdate,
        'userAbrhs': misSession.userabrhs,
    };
    calltoAjax(misApiUrl.listDashboardLeavesByUserId, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblPLMGrid").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    //{
                    //    filename: 'Leave History List',
                    //    extend: 'collection',
                    //    text: 'Export',
                    //    buttons: [{ extend: 'copy' },
                    //    { extend: 'excel', filename: 'Leave History List' },
                    //    { extend: 'pdf', filename: 'Leave History List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                    //    { extend: 'print', filename: 'Leave History List' },
                    //    ]
                    //}
                ],
                "responsive": true,
                "autoWidth": false,
                "paging": true,
                "bLengthChange": false,
                "searching": false,
                "bDestroy": true,
                "ordering": true,
                "order": [],
                "info": true,
                "deferRender": true,
                "aaData": data,
                "aoColumns": [

                    {
                        "mData": "FromDate",
                        "sTitle": "From",
                    },
                    {
                        "mData": "TillDate",
                        "sTitle": "Till",

                    },
                    {
                        "mData": "LeaveType",
                        "sTitle": "Type",
                    },
                    {
                        "mData": "NoOfDays",
                        "sTitle": "Count",
                    },
                    {
                        "mData": "Status",
                        "sTitle": "Status"
                    }
                ]
            });
        });
}

function showELPopup(LeaveType) {
    $("#myELPopup").modal("show");
    var jsonObject = {
        leaveType: LeaveType,
        year: misSession.fystartdate,
        'userAbrhs': misSession.userabrhs,
    };
    calltoAjax(misApiUrl.listDashboardLeavesByUserId, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblELGrid").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                ],
                "responsive": true,
                "autoWidth": false,
                "paging": true,
                "bLengthChange": false,
                "searching": false,
                "bDestroy": true,
                "ordering": true,
                "order": [],
                "info": true,
                "deferRender": true,
                "aaData": data,
                "aoColumns": [

                    {
                        "mData": "FromDate",
                        "sTitle": "From",
                    },
                    {
                        "mData": "TillDate",
                        "sTitle": "Till",

                    },
                    {
                        "mData": "LeaveType",
                        "sTitle": "Type",
                    },
                    {
                        "mData": "NoOfDays",
                        "sTitle": "Count",
                    },
                    {
                        "mData": "Status",
                        "sTitle": "Status"
                    }
                ]
            });
        });
}

function showLWPPopup(LeaveType) {
    $("#myLWPPopup").modal("show");
    var jsonObject = {
        leaveType: LeaveType,
        year: misSession.fystartdate,
        'userAbrhs': misSession.userabrhs,
    };
    calltoAjax(misApiUrl.listDashboardLeavesByUserId, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblLWPGrid").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    //{
                    //    filename: 'Leave History List',
                    //    extend: 'collection',
                    //    text: 'Export',
                    //    buttons: [{ extend: 'copy' },
                    //    { extend: 'excel', filename: 'Leave History List' },
                    //    { extend: 'pdf', filename: 'Leave History List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                    //    { extend: 'print', filename: 'Leave History List' },
                    //    ]
                    //}
                ],
                "responsive": true,
                "autoWidth": false,
                "paging": true,
                "bLengthChange": false,
                "searching": false,
                "bDestroy": true,
                "ordering": true,
                "order": [],
                "info": true,
                "deferRender": true,
                "aaData": data,
                "aoColumns": [

                    {
                        "mData": "FromDate",
                        "sTitle": "From",
                    },
                    {
                        "mData": "TillDate",
                        "sTitle": "Till",

                    },
                    {
                        "mData": "LeaveType",
                        "sTitle": "Type",
                    },
                    {
                        "mData": "NoOfDays",
                        "sTitle": "Count",
                    },
                    {
                        "mData": "Remarks",
                        "sTitle": "Remarks"
                    }
                ]
            });
        });
}
function showCompOffPopup(LeaveType) {
    $("#myCompPopup").modal("show");
    bindCompOffRequestGrids();
    bindCompOffLeaveGrids(LeaveType);
}
function bindCompOffRequestGrids() {
    var jsonObject = {
        'userAbrhs': misSession.userabrhs,
        'year': misSession.fystartdate,
    };
    calltoAjax(misApiUrl.listDashboardCompOffByUserId, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblRequestGrid").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    //{
                    //    filename: 'CompOff History List',
                    //    extend: 'collection',
                    //    text: 'Export',
                    //    buttons: [{ extend: 'copy' },
                    //    { extend: 'excel', filename: 'CompOff History List' },
                    //    { extend: 'pdf', filename: 'CompOff History List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                    //    { extend: 'print', filename: 'CompOff History List' },
                    //    ]
                    //}
                ],
                "responsive": true,
                "autoWidth": false,
                "paging": true,
                "bLengthChange": false,
                "searching": false,
                "bDestroy": true,
                "ordering": true,
                "order": [],
                "info": true,
                "deferRender": true,
                "aaData": data,
                "aoColumns": [
                    //{ "mData": "DisplayApplyDate", "sTitle": "Applied On" },
                    { "mData": "DisplayFromDate", "sTitle": "CompOff Date" },
                    { "mData": "NoOfDays", "sTitle": "Count" },
                    { "mData": "LapseDate", "sTitle": "Lapse Date" }
                    //{
                    //    "mData": "Status",
                    //    "sTitle": "Status"
                    //}
                ]
            });
        });
}
function bindCompOffLeaveGrids(LeaveType) {
    var jsonObject = {
        leaveType: LeaveType,
        year: misSession.fystartdate,
        'userAbrhs': misSession.userabrhs,
    };
    calltoAjax(misApiUrl.listDashboardLeavesByUserId, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblCompGrid").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    //{
                    //    filename: 'CompOff History List',
                    //    extend: 'collection',
                    //    text: 'Export',
                    //    buttons: [{ extend: 'copy' },
                    //        { extend: 'excel', filename: 'CompOff History List' },
                    //        { extend: 'pdf', filename: 'CompOff History List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                    //        { extend: 'print', filename: 'CompOff History List' },
                    //    ]
                    //}
                ],
                "responsive": true,
                "autoWidth": false,
                "paging": true,
                "bLengthChange": false,
                "searching": false,
                "bDestroy": true,
                "ordering": true,
                "order": [],
                "info": true,
                "deferRender": true,
                "aaData": data,
                "aoColumns": [
                    {
                        "mData": "FromDate",
                        "sTitle": "Leave Date",
                    },
                    //{
                    //    "mData": "LeaveType",
                    //    "sTitle": "Type",
                    //},
                    {
                        "mData": "NoOfDays",
                        "sTitle": "Count",
                    },
                    {
                        "mData": "Status",
                        "sTitle": "Status"
                    }
                ]
            });
        });
}
function showLeavePopup(LeaveType) {
    $("#myLeavePopup").modal("show");
    var jsonObject = {
        leaveType: LeaveType,
        year: misSession.fystartdate,
        'userAbrhs': misSession.userabrhs,
    };
    calltoAjax(misApiUrl.listDashboardLeavesByUserId, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblLeaveGrid").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    //{
                    //    filename: 'Leave History List',
                    //    extend: 'collection',
                    //    text: 'Export',
                    //    buttons: [{ extend: 'copy' },
                    //        { extend: 'excel', filename: 'Leave History List' },
                    //        { extend: 'pdf', filename: 'Leave History List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                    //        { extend: 'print', filename: 'Leave History List' },
                    //    ]
                    //}
                ],
                "responsive": true,
                "autoWidth": false,
                "paging": true,
                "bLengthChange": false,
                "searching": false,
                "bDestroy": true,
                "ordering": true,
                "order": [],
                "info": true,
                "deferRender": true,
                "aaData": data,
                "aoColumns": [

                    {
                        "mData": "FromDate",
                        "sTitle": "From",
                    },
                    {
                        "mData": "TillDate",
                        "sTitle": "Till",

                    },
                    {
                        "mData": "LeaveType",
                        "sTitle": "Type",
                    },
                    {
                        "mData": "NoOfDays",
                        "sTitle": "Count",
                    },
                    {
                        "mData": "Status",
                        "sTitle": "Status"
                    }
                ]
            });
        });
}
function getReferrals() {
    var html = '<div class="col-xl-6 dashboard-column"><section id="Referrals" class="box-typical box-typical-dashboard panel panel-default scrollable"><header class="box-typical-header panel-heading"><h3 class="panel-title">Referral</h3>';
    html += '</header><div class="box-typical-body panel-body" id="tblReferrals" style="text-align: center;"><img src="../../img/dot-loader.gif" style="margin-top:50px">';
    html += '</div></section></div>';
    $("#divPanel").append(html).ready(function () {
        $("#Referrals").lobiPanel();
    });

    calltoAjax(misApiUrl.getReferral, "POST", '', function (result) {
        var html = '<table class="tbl-typical fixed-header text-left">';
        html += '<thead><tr><th><div>Position</div></th><th><div>Key Skills</div></th><th><div>Action</div></th></tr></thead>';
        if (result) {
            var resultdata = $.parseJSON(JSON.stringify(result));
            if (resultdata && resultdata.length > 0) {
                for (var i = 0; i < resultdata.length; i++) {
                    var temp = addElipsis(result[i].Description, 25);
                    html += '<tr><td>' + resultdata[i].Position + '</td><td><span rel="popover"  data-toggle="popover" title="Key Skills" data-attr-JD="' + result[i].Description + '" class="text- color small- text - value">' + temp + '</span></td><td><div><button title="Refer" onclick="showAddReferralPopup(' + resultdata[i].ReferralId + ');"class="btn btn-success btn-sm"><i class="fa fa-user"></i></button></div></td></tr>';
                }
            }
            else {
                html += '<tr><td colspan="4"><div class="text-danger text-center" style="padding-top:10px">No data available in table</div></td></tr>';
            }
        }
        else {
            html += '<tr><td colspan="4"><div class="text-danger text-center" style="padding-top:10px">No data available in table</div></td></tr>';
        }
        html += '</table>';
        $("#tblReferrals").html(html);
    });
}
function showAddReferralPopup(id) {
    $("#modalRefer").modal("show");
    newReferId = id;
}
$("#btnCloseReferral").click(function () {
    $("#modalRefer").modal("hide");
    $("#refereeName").removeClass('error-validation');
    $("#relation").removeClass('error-validation');
    $("#resume").removeClass('error-validation');
    $("#refereeName").val("");
    $("#relation").val("");
    $("#resume").val("");
});
$("#buttonClose").click(function () {
    $("#modalRefer").modal("hide");
    $("#refereeName").removeClass('error-validation');
    $("#relation").removeClass('error-validation');
    $("#resume").removeClass('error-validation');
    $("#refereeName").val("");
    $("#relation").val("");
    $("#resume").val("");
});
var base64Data;
function checkValidFile(sender) {
    var validExts = new Array(".doc", ".docx", ".pdf");
    var fileExt = sender.value;
    fileExt = fileExt.substring(fileExt.lastIndexOf('.'));
    if (validExts.indexOf(fileExt) < 0) {
        misAlert("Invalid file selected. Supported extensions are " + validExts.toString(), "Warning", "warning");
        $("#resume").val("");
        return false;
    } else {
        ToBase64();
        return true;
    }
}

function ToBase64() {
    var selectedFile = document.getElementById("resume").files;
    if (selectedFile.length > 0) //Check File is not Empty
    {
        var fileToLoad = selectedFile[0];
        var fileReader = new FileReader();
        fileReader.onload = function (fileLoadedEvent) {
            base64Data = fileLoadedEvent.target.result;
        };
        fileReader.readAsDataURL(fileToLoad);
    }
}
$("#btnAddReferral").click(function () {
    var fileName = $("#resume").val().replace(/^.*\\/, "");

    if (!validateControls('modalRefer')) {
        return false;
    }
    var jsonObject = {
        referralId: newReferId,
        refereeName: $("#refereeName").val(),
        relation: $("#relation").val(),
        resume: fileName,
        base64FormData: base64Data,
        userAbrhs: misSession.userabrhs
    }
    calltoAjax(misApiUrl.addRefereeByUser, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            if (resultData == 1) {
                misAlert("Referred successfully", "Success", "success");
                getReferrals();
                $("#modalRefer").modal('hide');
                $("#refereeName").val("");
                $("#relation").val("");
                $("#resume").val("");
            }
            else if (resultData == 3)
                misAlert("File with same name already exists", "Warning", "warning");
            else
                misAlert("Unable to process request. Try again", "Error", "error");
        });
});
function getTrainings() {
    var html = '<div class="col-xl-6 dashboard-column"><section id="Trainings" class="box-typical box-typical-dashboard panel panel-default scrollable"><header class="box-typical-header panel-heading"><h3 class="panel-title">Upcoming Trainings</h3>';
    html += '</header><div class="box-typical-body panel-body" id="tblTrainings" style="text-align: center;"><img src="../../img/dot-loader.gif" style="margin-top:50px">';
    html += '</div></section></div>';
    $("#divPanel").append(html).ready(function () {
        $("#Trainings").lobiPanel();
    });

    calltoAjax(misApiUrl.getTrainings, "POST", '', function (result) {
        var html = '<table class="tbl-typical fixed-header text-left">';
        html += '<thead><tr><th><div>Title</div></th><th><div>Tentative Date</div></th><th><div>Action</div></th></tr></thead>';
        if (result) {
            var resultdata = $.parseJSON(JSON.stringify(result));
            if (resultdata && resultdata.length > 0) {
                for (var i = 0; i < resultdata.length; i++) {
                    //var temp = addElipsis(result[i].Description, 25);
                    //if(result[i].StatusId==true)
                    html += '<tr><td><span rel="popover" data-toggle="popover" title="Description" data-attr-JD="' + result[i].Description + '" class="text- color small- text - value">' + result[i].Title + '</span></td><td>' + resultdata[i].TentativeDate + '</td><td><div style="width:80px">';
                    if (resultdata[i].IsApplied == false && resultdata[i].IsDocumented == true)
                        html += '<button title="Apply" onclick="applyForTraining(' + resultdata[i].TrainingId + ');" class="btn btn-success btn-sm"><i class="fa fa-book"></i></button>&nbsp;<button type="button" class="btn btn-sm success" data-toggle"model" data-target="#mypopupViewDocModal" onclick="viewDocumentInPopup(\'' + result[i].TrainingId + '\',\'' + result[i].Document + '\')" data-toggle="tooltip" title="View Document"><i class="fa fa-eye"> </i></button>'
                    else if (resultdata[i].IsApplied == false && resultdata[i].IsDocumented == false)
                        html += '<button title="Apply" onclick="applyForTraining(' + resultdata[i].TrainingId + ');" class="btn btn-success btn-sm"><i class="fa fa-book"></i></button>'
                    else if (resultdata[i].IsApplied == true && resultdata[i].IsDocumented == true)
                        html += '<button title="View" onclick="showDetailPopup(\'' + result[i].TrainingId + '\',\'' + result[i].Title + '\');" class="btn btn-info btn-sm"><i class="fa fa-eye"></i></button>&nbsp;<button type="button" class="btn btn-sm success" data-toggle"model" data-target="#mypopupViewDocModal" onclick="viewDocumentInPopup(\'' + result[i].TrainingId + '\',\'' + result[i].Document + '\')" data-toggle="tooltip" title="View Document"><i class="fa fa-eye"> </i></button>'
                    else if (resultdata[i].IsApplied == true && resultdata[i].IsDocumented == false)
                        html += '<button title="View" onclick="showDetailPopup(\'' + result[i].TrainingId + '\',\'' + result[i].Title + '\');" class="btn btn-info btn-sm"><i class="fa fa-eye"></i></button></div ></td ></tr >';
                    //else
                    //html += '<tr><td><span rel="popover" data-toggle="popover" data-attr-JD="' + result[i].Description + '" class="text- color small- text - value">' + temp + '</span></td><td>' + resultdata[i].TentativeDate + '</td><td><div><button title="Apply" onclick="applyForTraining(' + resultdata[i].TrainingId + ');"class="btn btn-success btn-sm"><i class="fa fa-book"></i></button></div></td></tr>';

                }
            }
            else {
                html += '<tr><td colspan="4"><div class="text-danger text-center" style="padding-top:10px">No data available in table</div></td></tr>';
            }
        }
        else {
            html += '<tr><td colspan="4"><div class="text-danger text-center" style="padding-top:10px">No data available in table</div></td></tr>';
        }
        html += '</table>';
        $("#tblTrainings").html(html);
    });
}
function viewDocumentInPopup(trainingId, document) {
    var extention = getFileExtension(document);
    var jsonObject = {
        trainingId: trainingId
    }
    calltoAjax(misApiUrl.viewDocument, "POST", jsonObject,
        function (resultData) {
            if (resultData != null && resultData != '') {
                if (extention == "pdf") {
                    $("#myObjViewPdf").attr("data", resultData);
                    //document.getElementById("header1").innerHTML = document;
                    //$("#modalTitle").html(resume);
                    $("#viewTrainingDocumentModal").modal("show");
                }
                else {
                    downloadFileFromBase64(document, resultData);
                }
            }
            else {
                misAlert('The file you have requested does not exist. Please try after some time or contact to MIS team for further assistance.', 'Oops...', 'info');
            }
        });
}
function applyForTraining(trainingId) {
    var reply = misConfirm("Are you sure you want to request for this training session?", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                trainingId: trainingId
            }
            calltoAjax(misApiUrl.applyForTrainings, "POST", jsonObject,
                function (result) {
                    var resultData = $.parseJSON(JSON.stringify(result));
                    if (resultData == 1) {

                        misAlert("Request for training session recorded successfully.", "Success", "success");
                        getTrainings();
                        $("#modalViewTraining").modal("hide");
                    }
                    else if (resultData == 2) {
                        misAlert("Request for training session recorded successfully.", "Success", "success");
                        getTrainings();
                        $("#modalViewTraining").modal("hide");
                    }
                    else
                        misAlert("Unable to process request. Please try again", "Error", "error");
                });

        }
    });
}
function showDetailPopup(trainingId, title) {
    $("#modalViewTraining").modal("show");
    document.getElementById("header1").innerHTML = "View Request For " + title + "";
    viewAppliedTraining(trainingId);
}
$("#btnRequestClose").click(function () {
    $("#modalViewTraining").modal("hide");
});
function viewAppliedTraining(trainingId) {
    var jsonObject = {
        trainingId: trainingId
    }
    calltoAjax(misApiUrl.getAppliedTrainingDetails, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#tblUserAppliedTraining").dataTable({
                "responsive": true,
                "autoWidth": true,
                "paging": false,
                "bDestroy": true,
                "ordering": false,
                "searching": false,
                "info": false,
                "deferRender": false,
                "aaData": resultData,
                "aoColumns": [
                    {
                        "mData": "TentativeDate",
                        "sTitle": "Tentative Date",

                    },
                    {
                        "mData": "CreatedDate",
                        "sTitle": "Applied On",

                    },
                    {
                        "mData": "Remarks",
                        "sTitle": "Remarks",

                    },
                    {
                        "mData": "Status",
                        "sTitle": "Status",

                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        "sClass": "text-center",
                        mRender: function (data, type, row) {
                            var q = new Date();
                            var m = q.getMonth() + 1;
                            var d = q.getDate();
                            var y = q.getFullYear();
                            var tDate = (m > 9 ? '' : '0') + m + '/' + (d > 9 ? '' : '0') + d + '/' + y;
                            var tFullDate = new Date(tDate);
                            var myDate = row.TentativeDate;
                            var myFullDate = new Date(myDate);
                            var html = '<div>';
                            if (myFullDate >= tFullDate && row.StatusId != 4 && row.StatusId != 3) {
                                html += '&nbsp;<button type="button" class="btn btn-sm btn-danger" onclick="cancelAppliedTraining(\'' + row.TrainingDetailId + '\',4' + ')" data-toggle="tooltip" title="Cancel"><i class="fa fa-times"> </i></button>';
                            }
                            else if (myFullDate >= tFullDate && row.StatusId == 3) {
                                html += '&nbsp;<button title="Apply again" onclick="applyForTraining(' + row.TrainingId + ');" class="btn btn-success btn-sm"><i class="fa fa-book"></i></button>';
                            }
                            else
                                html += '&nbsp;</div>';
                            return html;
                        }
                    },
                ]
            });
        });
}
function cancelAppliedTraining(trainingDetailId, status) {
    var reply = misConfirm("Are you sure you want to cancel this request?", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                trainingDetailId: trainingDetailId,
                statusId: status
            }
            calltoAjax(misApiUrl.takeActionOnTrainingRequest, "POST", jsonObject,
                function (result) {
                    if (result == 1) {
                        misAlert("Training request has been cancelled successfully.", "Success", "success");
                        $("#modalViewTraining").modal("hide");
                        getTrainings();
                    }
                    else
                        misAlert("Unable to process request. Please try again", "Error", "error");
                });

        }
    });
}

function getCalendarOnNavigation() {
    var jsonObject = {
        startDate: moment(_startDate).format('YYYY/MM/DD'),
        endDate: moment(_endDate).format('YYYY/MM/DD')
    }
    var isWeekOff, isHoliday, isNightShift, onLeave, date;
    calltoAjaxWithoutLoader(misApiUrl.getUserWiseWeekDataInCalendar, "POST", jsonObject,
        function (result) {
            for (i = 0; i < result.length; i++) {
                date = result[i].Date;
                isWeekOff = result[i].IsWeekOff;
                isHoliday = result[i].IsHoliday;
                isNightShift = result[i].IsNightShift;
                onLeave = result[i].OnLeave;
                if (isWeekOff == true) {
                    $("td[data-date='" + date + "']").addClass("weekoff-date");
                    $("td[data-date='" + date + "']").attr('title', 'Week-Off');
                }
                else if (isHoliday == true) {
                    $("td[data-date='" + date + "']").addClass("holiday-date");
                    $("td[data-date='" + date + "']").attr('title', 'Holiday');
                }
                else if (isNightShift == true) {
                    $("td[data-date='" + date + "']").addClass("nightshift-date");
                    $("td[data-date='" + date + "']").attr('title', 'Night Shift');
                }
                else if (onLeave == true && result[i].LeaveType == 'LWP') {
                    $("td[data-date='" + date + "']").addClass("lwp-date");
                    $("td[data-date='" + date + "']").attr('title', result[i].LeaveType);
                    //$("td[data-date='" + date + "']").append('span title="' + result[i].Description + '" class="text- color small- text - value" >"' + result[i].Description + '"</span >');
                }
                else if (onLeave == true && result[i].LeaveType != 'LWP') {
                    $("td[data-date='" + date + "']").addClass("leave-date");
                    $("td[data-date='" + date + "']").attr('title', result[i].LeaveType);
                    //$("td[data-date='" + date + "']").append('span title="' + result[i].Description + '" class="text- color small- text - value" >"' + result[i].Description + '"</span >');
                }

            }
        });
}