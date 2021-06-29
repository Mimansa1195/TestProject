var _halfday, _leaveIdToBeCancelled = 0, currentTime = new Date(), selectedEmployeeAbrhs;
var data = [];
var validDates;
var weeklydata = [];
var emptyHtml;
var _data;
var values = [];
var rows_selected = [];
var tblMarkedEmployeesInfo = ""
var _selectedEmpIds;
var dates = [];
$(document).ready(function () {
    $("#leaveEmployeeName").select2();
    $("#employeeName").select2();
    $("#year").select2();
    bindYearDropDown();
    $('#leaveFromDate').datepicker({ autoclose: true, todayHighlight: true }).on('changeDate', function (ev) {
        onFromDateChange();
    });

    $('#WorkFromHomeDate').datepicker({ autoclose: true, todayHighlight: true });

    $('#advanceLeaveFromDate').datepicker({ autoclose: true, todayHighlight: true }).on('changeDate', function (ev) {
        onAdvanceLeaveFromDateChange();
    });

    $("#advanceLeaveReason").val("As per user request, advance leave applied with additional approval from HR which needs to be adjusted later.");

    $("#singleHalfShow").hide();
    $("#halfDayPreferenceShow").hide();
    $("#bothHalfShow").hide();
    $(".toggleDiv").hide();
    $('a[href="#tabApplyLnsa"]').on("click", function () {
        $("#teamRoaster").html("");
        loadUserShiftMapping();
    });

    $('a[href="#tabMapWeekOff"]').on("click", function () {
        $('#lnsaDetails').html("");
        loadCalendarForMarkingWeekOff();
    });
    $('#teamRoaster').html("Loading...");
    //loadCalendarForMarkingWeekOff();
    $("#btnWeekOffPreviousMonth").click(function () {
        navigateCalendar('P'); //Previous
    });

    $("#btnWeekOffNextMonth").click(function () {
        navigateCalendar('N');//Next
    });

    $("#saveWeekOffData").on("click", function () {
        if ($("#ddlUsers").find('option:selected').length > 0 && $("#ddlDates").find('option:selected').length > 0) {
            saveWeekOffUsers();
        }
        else
            misAlert("Please select employees and dates before saving.", "Warning", "warning");
    });

    $(document).on("click", ".selectEmp", function () {
        $("#tblMarkedEmployeesInfo").html("");
        $('#ddlUsers,#ddlDates').html('')
        $('#ddlUsers,#ddlDates').multiselect('destroy')
        $(this).toggleClass("active")
        values = [];
        var dateIds = [];
        $(this).parent().parent(".divCell").find("div[class*='month']").each(function () {
            var idx = $.inArray($(this).attr("data-attr-date"), values);
            var dates = $.inArray($(this).attr("data-attr-dateid"), values);
            if (idx == -1) {
                values.push($(this).attr("data-attr-date"));
            } else {
                values.splice(1);
            }
            if (dates == -1) {
                dateIds.push($(this).attr("data-attr-dateid"));
            } else {
                dateIds.splice(1);
            }
            //console.log(values)
        })
        var ddhtml = "";
        for (var dd = 0; dd < values.length; dd++) {
            $('<option>').val(dateIds[dd]).text(values[dd]).appendTo('#ddlDates');
        }
        $('#ddlDates').multiselect({
            buttonWidth: '100%',
        });
        bindReportees(dateIds);
        weekOffMarkedEmployeesInfo(dateIds);
    });
    var html = '<table class="tbl-typical roaster-info-section fixed-header text-left">';
    html += '<thead><tr><th><div>Guidelines To Use Week-Off Calendar</div></th></tr></thead>';
    html += '<tr><td>--> Click on the headers of calendar to map week-off for users. (Eg : Click on Week #1).</td></tr>';
    html += '<tr><td>--> Select users and dates for which week-off has to be mapped.</td></tr>';
    html += '<tr><td>--> Calendar displays user week days.</td></tr>';
    html += '<tr><td>--> Users week-off can be unmapped by clicking on remove button.</td></tr>';
    html += '</table>';
    var pos = "left";
    if ($(document).width() < 768) {
        pos = "bottom"
    }
    $("[data-toggle=popover]").each(function (i, obj) {
        $(this).popover({
            html: true,
            trigger: 'hover',
            placement: pos,
            content: html
        });
    });

    $("#btnSubmitAdvanceLeave").on('click', function () {
        submitAdvanceLeave();
    });

    loadActiveEmployees();
});

$("#btnPreviousMonth").click(function () {
    var jsonObject = {
        month: new Date($("#hdnStartDate").val()).getMonth() + 1,
        year: new Date($("#hdnStartDate").val()).getFullYear(),
        userAbrhs: selectedEmployeeAbrhs
    }
    calltoAjax(misApiUrl.getCalenderOnPrevButtonClick, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            bindLNSACalendar(data);
        });
});

$("#btnNextMonth").click(function () {
    var jsonObject = {
        month: new Date($("#hdnEndDate").val()).getMonth() + 1,
        year: new Date($("#hdnEndDate").val()).getFullYear(),
        userAbrhs: selectedEmployeeAbrhs
    }
    calltoAjax(misApiUrl.getCalenderOnNextButtonClick, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            bindLNSACalendar(data);
        });
});

function bindYearDropDown() {
    calltoAjax(misApiUrl.getFinancialYears, "POST", '',
        function (result) {
            if (result !== null)
                $.each(result, function (index, item) {
                    $("#year").append($("<option></option>").val(item.StartYear).html(item.Text));
                });
        });
}

$("#year").change(function () {
    getUserAllAvailedLeaves();
});

function onUpdateLeaveTabClicked() {
    $("#btnApplyLeaveOnUserBehalf").hide();
    _halfday = 0;
}


$("#ddlUserStatus").change(function () {
    $("#btnApplyLeaveOnUserBehalf").hide();
    var selectedStatus = $("#ddlUserStatus option:selected").text();
    if (selectedStatus === "Active") {
        loadActiveEmployees();
    }
    else {
        loadInActiveEmployees();
    }
});

function loadActiveEmployees() {
    $("#leaveEmployeeName").empty();
    $("#leaveEmployeeName").append("<option value = '0' > Select </option>");
    calltoAjax(misApiUrl.listAllActiveUsers, "POST", '',
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            if (result != null) {
                if (result.length > 0) {
                    $.each(result, function (index, result) {
                        $("#leaveEmployeeName").append("<option value =" + result.EmployeeAbrhs + " >" + result.EmployeeName + "</option>");
                    });
                }
                else {
                    $("#divUserLeaveList").hide();
                }
            }
        });
}

function loadInActiveEmployees() {
    $("#leaveEmployeeName").empty();
    $("#leaveEmployeeName").append("<option value = '0' > Select </option>");
    calltoAjax(misApiUrl.listAllInActiveUsers, "POST", '',
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            if (result != null) {
                if (result.length > 0) {
                    $.each(result, function (index, result) {
                        $("#leaveEmployeeName").append("<option value =" + result.EmployeeAbrhs + " >" + result.EmployeeName + "</option>");
                    });
                }
                else {
                    $("#divUserLeaveList").hide();
                }
            }
        });
}

$("#leaveEmployeeName").change(function () {
    var jsonObject = {
        employeeAbrhs: $("#employeeName").val(),
        date: $("#selectDate").val()
    };
    selectedEmployeeAbrhs = $("#leaveEmployeeName").val();
    $("#hiddenEmployeeAbrhs").val(selectedEmployeeAbrhs);
    var selectedStatus = $("#ddlUserStatus option:selected").text();
    if (selectedStatus === "Active") {
        $("#btnApplyLeaveOnUserBehalf").show();
    }
    else {
        $("#btnApplyLeaveOnUserBehalf").hide();
    }
  
    $("#leaveGrid").empty();
    $("#rejectedLeaveGrid").empty();
    $("#tblLeavebalanceGrid").empty();

    if (selectedEmployeeAbrhs !== "0") {
        $("#divUserLeaveList").show();
        loadLeaveBalanceGridForSelectedEmployee();
        getUserAllAvailedLeaves();
    }
    else {
        $("#divUserLeaveList").hide();
    }
});

function showRemarksPopup(applicationId, type) {
    var jsonObject = {
        'requestId': applicationId,
        'type': type
    };
    calltoAjax(misApiUrl.getApproverRemarks, "POST", jsonObject,
        function (result) {
            if (result != "ERROR") {
                if (result == "") {
                    result = "NA";
                }
                $('#modalTitleMyPopupReviewLeaveRemark').text('Approver\'s Remarks');
                $("#submitReviewLeaveRemark").hide();
                $("#mypopupReviewLeaveRemark").modal("show");
                $("#reviewLeaveRemark").val(result);
                $("#reviewLeaveRemark").attr('disabled', true);
            }
        });
}

function getUserAllAvailedLeaves() {
    if (!validateControls('updateLeaveGrid')) {
        return false;
    }
    var currentYear = new Date().getFullYear();
    var jsonObject = {
        employeeAbrhs: selectedEmployeeAbrhs,
        year: $("#year").val()
    };
    calltoAjax(misApiUrl.listAvailedLeaveByUserId, "POST", jsonObject,
        function (result) {
            if (result != null && result.length > 0) {
                var pendingReqData = [];
                var nonPendingReqData = [];
                var upv = getAllUnmatchedObject({ 'StatusCode': 'CA' }, result);
                pendingReqData = getAllUnmatchedObject({ 'StatusCode': 'RJ' }, upv);

                nonPendingReqData = getAllMatchedObject({ StatusCode: 'CA' }, result);
                var pa = getAllMatchedObject({ StatusCode: 'RJ' }, result);
                $.merge(nonPendingReqData, pa);
                getUserAvailedLeaves(pendingReqData);
                getRejectedUserAvailedLeaves(nonPendingReqData);
            }
            else {
                getUserAvailedLeaves(result);
                getRejectedUserAvailedLeaves(result);
            }
        });
}

function getUserAvailedLeaves(result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#leaveGrid").DataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'Availed Leave List',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'Availed Leave List' },
                        { extend: 'pdf', filename: 'Availed Leave List' },
                        { extend: 'print', filename: 'Availed Leave List' },
                        ]
                    }
                ],
                "responsive": true,
                "autoWidth": false,
                "paging": true,
                "bDestroy": true,
                "ordering": true,
                "order": [],
                "info": true,
                "deferRender": true,
                "aaData": data,
                "aoColumns": [
                    {
                        "mData": null,
                        "sTitle": "Period",
                        mRender: function (data, type, row) {
                            var html = data.DisplayFromDate + " to " + data.DisplayTillDate;
                            return html;
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Type",
                        mRender: function (data, type, row) {
                            if (data.LeaveType == "WFH") {
                                var html = '<span class="label label-success">' + data.LeaveType + '</span>';
                                return html;
                            }
                            else if (data.FetchLeaveType == "OUTING") {
                                var html = '<span class="label label-info">' + data.LeaveType + '</span>';
                                return html;
                            }
                            else if (data.CreatedBy == 1 && data.Reason === "No data found") {
                                var html = '<span class="label label-danger">' + data.LeaveType + '</span>';
                                return html;
                            }
                            else if (data.FetchLeaveType == "LNSA") {
                                var html = '<span class="label label-warning">' + data.LeaveType + '</span>';
                                return html;
                            }
                            else if (data.FetchLeaveType == "AdvanceLeave") {
                                var html = '<span class="label label-primary">' + data.LeaveType + '</span>';
                                return html;
                            }
                            else if (data.FetchLeaveType == "LWPChangeRequest") {
                                var html = '<span class="label label-default">' + data.LeaveType + '</span>';
                                return html;
                            }
                            else
                                return data.LeaveType;
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Remark/Status",
                        mRender: function (data, type, row) {
                            var html = '<a  onclick="showRemarksPopup(' + row.LeaveId + ', \'' + row.RemarksLeaveType+ '\')" >' + row.Status + '</a>';
                            return html;
                        }
                    },
                    {
                        "mData": "Reason",
                        "sTitle": "Reason",
                    },
                    {
                        "mData": null,
                        "sTitle": "Applied On",
                        mRender: function (data, type, row) {
                            var html = data.DisplayApplyDate;
                            return html;
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        "sWidth": "120px",
                        mRender: function (data, type, row) {
                            var html = "";
                            var period = data.DisplayFromDate + " to " + data.DisplayTillDate;
                            if (data.FetchLeaveType == "AdvanceLeave") {
                                var can = 1;
                                html += '<button type="button" class="btn btn-sm btn-info"' + 'onclick="getDatesToCancelAdvanceLeaves(' + row.LeaveId + ',' + can + ')" data-toggle="tooltip" title="View"><i class="fa fa-eye"></i></button>';
                                if (data.IsCancellable) {
                                    html += '&nbsp;<button type="button" class="btn btn-sm btn-danger"' + 'onclick="cancelLeaveByHR(' + row.LeaveId + ',\'' + row.FetchLeaveType + '\', \'' + period + '\',\'' + row.LeaveType + '\')" data-toggle="tooltip" title="Cancel All"><i class="fa fa-times"></i></button>';
                                }
                            }
                            else {
                                if (row.IsApplied === false || row.FetchLeaveType === "LWPChangeRequest") {

                                    if (row.FetchLeaveType === "LWPChangeRequest" && row.IsApplied === true) {
                                        html += '<button type="button" class="btn btn-sm btn-default"' + 'onclick="cancelLeaveByHR(' + row.LeaveId + ',\'' + row.FetchLeaveType + '\', \'' + period + '\',\'' + row.LeaveType + '\')" data-toggle="tooltip" style="background-color:#adb7be;" title="Cancel LWP Change Req"><i class="fa fa-times"></i></button>';
                                        //html += '&nbsp;<button type="button" class="btn btn-sm "' + 'onclick="cancelAndApplyLeave(' + row.LeaveId + ')" data-toggle="tooltip" title="Cancel & Apply"><i class="fa fa-check"></i></button>';
                                    }
                                    else {
                                        html += '<button type="button" class="btn btn-sm btn-danger"' + 'onclick="cancelLeaveByHR(' + row.LeaveId + ',\'' + row.FetchLeaveType + '\', \'' + period + '\',\'' + row.LeaveType + '\')" data-toggle="tooltip" title="Cancel"><i class="fa fa-times"></i></button>';

                                    }
                                }
                                else {
                                    html += "LWP change request applied on " + row.LWPChangeRequestAppliedOn;
                                }
                            }
                            return html;
                        }
                    },
                ]
            });
}

function getRejectedUserAvailedLeaves(result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#rejectedLeaveGrid").DataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'Availed Leave List',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'Availed Leave List' },
                        { extend: 'pdf', filename: 'Availed Leave List' },
                        { extend: 'print', filename: 'Availed Leave List' },
                        ]
                    }
                ],
                "responsive": true,
                "autoWidth": false,
                "paging": true,
                "bDestroy": true,
                "ordering": true,
                "order": [],
                "info": true,
                "deferRender": true,
                "aaData": data,
                "aoColumns": [
                    {
                        "mData": null,
                        "sTitle": "Period",
                        mRender: function (data, type, row) {
                            var html = data.DisplayFromDate + " to " + data.DisplayTillDate;
                            return html;
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Type",
                        mRender: function (data, type, row) {
                            if (data.LeaveType == "WFH") {
                                var html = '<span class="label label-success">' + data.LeaveType + '</span>';
                                return html;
                            }
                            else if (data.FetchLeaveType == "OUTING") {
                                var html = '<span class="label label-info">' + data.LeaveType + '</span>';
                                return html;
                            }
                            else if (data.CreatedBy == 1 && data.Reason === "No data found") {
                                var html = '<span class="label label-danger">' + data.LeaveType + '</span>';
                                return html;
                            }
                            else if (data.FetchLeaveType == "LNSA") {
                                var html = '<span class="label label-warning">' + data.LeaveType + '</span>';
                                return html;
                            }
                            else if (data.FetchLeaveType == "AdvanceLeave") {
                                var html = '<span class="label label-primary">' + data.LeaveType + '</span>';
                                return html;
                            }
                            else if (data.FetchLeaveType == "LWPChangeRequest") {
                                var html = '<span class="label label-default">' + data.LeaveType + '</span>';
                                return html;
                            }
                            else
                                return data.LeaveType;
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Remark/Status",
                        mRender: function (data, type, row) {
                            var html = '<a  onclick="showRemarksPopup(' + row.LeaveId + ',\'' + row.RemarksLeaveType + '\')" >' + row.Status + '</a>';
                            return html;
                        }
                    },
                    {
                        "mData": "Reason",
                        "sTitle": "Reason",
                    },
                    {
                        "mData": null,
                        "sTitle": "Applied On",
                        mRender: function (data, type, row) {
                            var html = data.DisplayApplyDate;
                            return html;
                        }
                    }
                ]
            });
}

function loadLeaveBalanceGridForSelectedEmployee() {
    var jsonObject = {
        employeeAbrhs: selectedEmployeeAbrhs,
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
                        "sTitle": "CL Count",
                    },
                    {
                        "mData": "PlCount",
                        "sTitle": "PL Count",
                    },
                    {
                        "mData": "CompOffCount",
                        "sTitle": "Comp Off Count",
                    },
                    {
                        "mData": "LwpCount",
                        "sTitle": "LWP Counter",
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
//---functions dependent on applyleave.js start here---//
function fetchAvailableLeave(leaveIdToBeCancelled) {
    var workingDays = $("#leaveWorkingDays").text() - _halfday;
    $("#leaveWorkingDays").html(workingDays);
    var jsonObject = {
        noOfWorkingDays: workingDays,
        leaveApplicationId: leaveIdToBeCancelled,
        userAbrhs: selectedEmployeeAbrhs,
        totalDays: $("#leaveTotalDays").text()
    };
    calltoAjax(misApiUrl.fetchAvailableLeaves, "POST", jsonObject,
        function (result) {
            $("#leaveType").empty();
            $("#leaveType").append("<option value='0'>Select</option>");
            $.each(result, function (index, item) {
                //if (currentTime.getMonth() >= 1 && currentTime.getMonth() <= 2 && (new Date($("#leaveTillDate").val()) <= new Date(currentTime.getFullYear(), 2, 31))) {
                //    $("#leaveType").append("<option>" + item.LeaveCombination + "</option>");
                //}
                //else if (currentTime.getMonth() >= 3 && (new Date($("#leaveTillDate").val()) <= new Date(currentTime.getFullYear() + 1, 2, 31))) {
                //    $("#leaveType").append("<option>" + item.LeaveCombination + "</option>");
                //}
                //else {
                $("#leaveType").append("<option>" + item.LeaveCombination + "</option>");
                //}
            });
        });
}

function onFromDateChange() {
    $(".toggleDiv").hide();
    $("#bothHalfShow").hide();
    $("#singleHalfShow").hide();
    $("#halfDayPreferenceShow").hide();
    $("#leaveTillDate").datepicker("destroy");
    var dateToday = new Date($("#leaveFromDate input").val());
    var fromDate = $("#leaveFromDate input").val();
    $("#leaveTillDate input").val("");
    $('#leaveTillDate').datepicker({ autoclose: true, todayHighlight: true }).datepicker('setStartDate', fromDate).on('changeDate', function (ev) {
        onTillDateChange();
    });
}

function onTillDateChange() {
    if ($("#leaveFromDate input").val() != '' && $("#leaveTillDate input").val() != '') {
        var jsonObject = {
            fromDate: $("#leaveFromDate input").val(),
            toDate: $("#leaveTillDate input").val(),
            leaveIdToBeCancelled: 0,
            userAbrhs: selectedEmployeeAbrhs
        };
        calltoAjax(misApiUrl.fetchDaysOnBasisOfLeavePeriod, "POST", jsonObject,
            function (result) {
                $("#leaveType").empty();
                if (result.Status == "NA") {
                    misAlert("Date collision, Please reselect the leave period", "Warning");
                    $("#leaveFromDate input").val("");
                    $("#leaveFromDate").datepicker("destroy");
                    $("#leaveFromDate").datepicker({ autoclose: true, todayHighlight: true });
                    onFromDateChange();
                }
                else {
                    if (result.WorkingDays == 0) {
                        misAlert("The leave period that you are applying for is already a calendar leave", "Warning");
                        $("#leaveTillDate input").val("");
                        $(".toggleDiv").hide();
                        $("#bothHalfShow").hide();
                        $("#singleHalfShow").hide();
                        $("#halfDayPreferenceShow").hide();
                    }
                    else {
                        $(".toggleDiv").show();
                        $("#leaveTotalDays").html(result.TotalDays);
                        $("#leaveWorkingDays").html(result.WorkingDays);
                        if (result.WorkingDays == 1) {
                            $("#isLeaveFirstHalfDay").attr("checked", false);
                            $("#isLeaveLastHalfDay").attr("checked", false);
                            $("#bothHalfShow").hide();
                            $("#singleHalfShow").show();
                        }
                        else if (result.WorkingDays > 1) {
                            $("#isLeaveHalfDay").attr("checked", false);
                            $("#isFirstHalfLeave").checked = false;
                            $("#isSecondHalfLeave").checked = false;
                            $("#singleHalfShow").hide();
                            $("#halfDayPreferenceShow").hide();
                            $("#bothHalfShow").show();
                        }
                    }
                }
                _halfday = 0;
                fetchAvailableLeave(_leaveIdToBeCancelled);
            });
    }
}

$("#isLeaveLastHalfDay").change(function () {
    if ($("#isLeaveLastHalfDay").is(':checked')) {
        _halfday = 0.5;
        fetchAvailableLeave(_leaveIdToBeCancelled);
    }
    else {
        _halfday = -0.5;
        fetchAvailableLeave(_leaveIdToBeCancelled);
    }
});

$("#isLeaveFirstHalfDay").change(function () {
    if ($("#isLeaveFirstHalfDay").is(':checked')) {
        _halfday = 0.5;
        fetchAvailableLeave(_leaveIdToBeCancelled);
    }
    else {
        _halfday = -0.5;
        fetchAvailableLeave(_leaveIdToBeCancelled);
    }
});

$("#isLeaveHalfDay").change(function () {
    if ($("#isLeaveHalfDay").is(':checked')) {
        _halfday = 0.5;
        fetchAvailableLeave(_leaveIdToBeCancelled);
        $("#halfDayPreferenceShow").show();
    } else {
        _halfday = -0.5;
        fetchAvailableLeave(_leaveIdToBeCancelled);
        $("#halfDayPreferenceShow").hide();
        $("#isFirstHalfLeave").attr("checked", false)// = false;
        $("#isSecondHalfLeave").attr("checked", false)//.checked = false;
    }
});

$("#leaveType").change(function () {
    selectedLeaveCombination = this.options[this.selectedIndex].text;
    var temp = selectedLeaveCombination.split(' ');
    if (temp[1] == 'CL' && temp[0] > 2) {
        misAlert("This leave will need approval from business head as well", "Info", "info");
    }
});
//---functions dependent on applyleave.js end here---//
function applyLeaveOnUserBehalf() {
    //$('#leaveFromDate').datepicker({ autoclose: true, todayHighlight: true });
    $("#leaveFromDate input").val("");
    $("#leaveTillDate input").val("");
    $("#singleHalfShow").hide();
    $("#halfDayPreferenceShow").hide();
    $("#bothHalfShow").hide();
    $(".toggleDiv").hide();
    $("#isLeaveHalfDay").prop('checked', false);
    $("#isFirstHalfLeave").prop('checked', false);
    $("#isSecondHalfLeave").prop('checked', false);
    $("#modalApplyLeaveOnUserBehalf").modal('show');
    $("#leaveReason").val("As per user request, applied from back-end.");
    $("#WFHReason").val("As per user request, applied from back-end.");
    $("#outingReason").val("As per user request, applied from back-end.");
    $("#btnSubmitleaveByHR").hide();
    $("#btnSubmitLeave").show();
    $("#showOnCancelLeaveByHR").hide();
    $("#cancelLeaveReason").removeClass("validation-required");
    var jsonObject = {
        type: 'LEAVE',
        userAbrhs: selectedEmployeeAbrhs,//misSession.userabrhs
    };
    calltoAjax(misApiUrl.getLastRecordDetails, "POST", jsonObject,
        function (result) {
            if (result != null) {
                $("#leaveContactNumber").val(result.PrimaryContactNo);
                $("#leaveAltContactNumber").val(result.AlternativeContactNo);
                $("#wfmMobileNo").val(result.PrimaryContactNo);
                $("#outingContactNumber").val(result.PrimaryContactNo);
                $("#outingAltContactNumber").val(result.AlternativeContactNo);
                $("#modalTitle").html("Update Leave Of " + result.Name);
                $("#note").html("Note : Manage " + result.Name + "'s weekly roster on behalf of RM <i><strong>" + result.RMName + "</i></strong>.");
            }
        });
    $("#leaveFromDate").datepicker("destroy");
    $("#leaveFromDate").datepicker({ autoclose: true, todayHighlight: true });

    getOutingType();
    $('#outingFromDatePicker').datepicker({
        autoclose: true,
        todayHighlight: true
    });

    $("#outingFromDate").val("");
    $("#outingTillDate").val("");
    $("#outingContactNumber").val("");
    $("#outingAltContactNumber").val("");
    $("#outingType").val(0);
}

function finalApplyLeaveOnUserBehalf() {
    if (!validateControls("tabApplyLeave"))
        return false;
    var isFirstDayHalfDayLeave = false, isLastDayHalfDayLeave = false;
    var phoneNo = $("#leaveContactNumber").val();
    var pattern = /^\d{10}$/;
    var Leavetype;
    if (pattern.test(phoneNo) == false)
        misAlert("Invalid contact number", "Warning", "warning");
    else {
        var leaveFromDate = $("#leaveFromDate input").val();
        var leaveTillDate = $("#leaveTillDate input").val();
        if ($("#isLeaveLastHalfDay").is(':checked'))
            isLastDayHalfDayLeave = true;
        if ($("#isLeaveFirstHalfDay").is(':checked'))
            isFirstDayHalfDayLeave = true;
        if ($("#isLeaveHalfDay").is(':checked')) {
            if ($("#isFirstHalfLeave").is(":checked"))
                isFirstDayHalfDayLeave = true;
            else if ($("#isSecondHalfLeave").is(":checked"))
                isLastDayHalfDayLeave = true;
            else {
                misAlert("Kindly fill preference for half day leave", "Warning", "warning");
                return false;
            }
        }
        var isAvailableOnMobile = false;
        if ($("#avilableOnMobile").is(':checked'))
            isAvailableOnMobile = true;
        var isAvailableOnEmail = false;
        if ($("#avilableOnEmail").is(':checked'))
            isAvailableOnEmail = true;
        var jsonObject = {
            EmployeeAbrhs: selectedEmployeeAbrhs,
            UserAbrhs: misSession.userabrhs,
            FromDate: leaveFromDate,
            TillDate: leaveTillDate,
            Reason: $("#leaveReason").val(),
            SelectedLeaveCombination: selectedLeaveCombination,
            PrimaryContactNo: $("#leaveContactNumber").val(),
            AlternativeContactNo: $("#leaveAltContactNumber").val(),
            IsAvailableOnMobile: isAvailableOnMobile,
            IsAvailableOnEmail: isAvailableOnEmail,
            IsFirstDayHalfDayLeave: isFirstDayHalfDayLeave,
            IsLastDayHalfDayLeave: isLastDayHalfDayLeave,
        };
        calltoAjax(misApiUrl.applyLeave, "POST", jsonObject,
            function (result) {
                if (result) {
                    switch (result) {
                        case 0: //failure
                            misAlert("Unable to process request. Please try again", "Error", "error");
                            break;
                        case 1: //date collision
                            misAlert("Leave already applied for this period. Please try again", "Date collision", "warning");
                            break;
                        case 2: //no combination present
                            misAlert("No combination present. Please try again", "Warning", "warning");
                            break;
                        case 3: //combination supplied is invalid
                            misAlert("Combination supplied is invalid. Please try again", "Warning", "warning");
                            break;
                        case 4: //success
                            misAlert("Leave applied successfully", "Success", "success");
                            $("#modalApplyLeaveOnUserBehalf").modal("hide");
                            misAlert("Request processed successfully", "Success", "success");
                            $("#leaveFromDate input").val("");
                            $("#leaveReason").val("");
                            $("#leaveContactNumber").val("");
                            $("#leaveAltContactNumber").val("");
                            $("#isLeaveHalfDay").attr("checked", false);
                            $("#isLeaveFirstHalfDay").attr("checked", false);
                            $("#isLeaveLastHalfDay").attr("checked", false);
                            $("#isLeaveFirstHalfDay").attr("checked", false);
                            $("#isLeaveLastHalfDay").attr("checked", false);
                            $("#avilableOnMobile").attr('checked', false);
                            $("#avilableOnEmail").attr('checked', false);
                            loadLeaveBalanceGridForSelectedEmployee();
                            getUserAllAvailedLeaves();
                            onFromDateChange();
                            break;
                        case 5: //data supplied is incorrect
                            misAlert("Data supplied is incorrect. Please try again", "Warning", "warning");
                            break;
                        case 6: //Applied Leave Period is beyond the CompOff expiry date 
                            misAlert("Applied Coff leave is beyond lapsed date or availed. Please try for another date.", "Warning", "warning");
                    }
                }
            });
    }
}

function cancelLeaveByHR(leaveId, forLeaveType, period, leaveType) {
    $("#modalCancelLeave").modal('show');
    var employeeName = $("#leaveEmployeeName option:selected").text();
    $("#modalCancelLeaveTitle").html("Cancel Leave Of " + employeeName);
    $("#txtPeriod").html(period);
    $("#txtLeaveType").html(leaveType);
    $("#hiddenLeaveApplicationId").val(leaveId);
    $("#hiddenForLeaveType").val(forLeaveType);
    $("#cancelLeaveReason").val("As per user request, cancelled from back-end.");
    $("#cancelLeaveReason").empty();
}

function cancelLeave() {
    var forLeaveType = $("#hiddenForLeaveType").val();
    if (!validateControls("modalCancelLeave"))
        return false;
    var reply = misConfirm("Are you sure you want to cancel this request ?", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                leaveApplicationId: $("#hiddenLeaveApplicationId").val(),
                remarks: $("#cancelLeaveReason").val(),
                userAbrhs: misSession.userabrhs,//selectedEmployeeAbrhs,
                isCancelByHR: true,
                forLeaveType: forLeaveType,
                type: "All"
            };
            calltoAjax(misApiUrl.cancelLeave, "POST", jsonObject,
                function (result) {
                    if (forLeaveType === "LEAVE") {
                        if (result == 0) {
                            $("#modalCancelLeave").modal("hide");
                            misAlert("Request processed successfully", "Success", "success");
                            loadLeaveBalanceGridForSelectedEmployee();
                            getUserAllAvailedLeaves();
                        }
                        else if (result == 2) {
                            misAlert("This leave is availed or has already been cancelled", "Warning", "warning");
                        }
                        else
                            misAlert("Unable to process request. Please try again", "Error", "error");
                    }
                    else if (forLeaveType === "OUTING") {
                        if (result === 1) {
                            $("#modalCancelLeave").modal("hide");
                            misAlert("Out Duty/Tour request has been cancelled successfully.", "Success", "success");
                            loadLeaveBalanceGridForSelectedEmployee();
                            getUserAllAvailedLeaves();
                        }
                        else if (result === 0) {
                            misAlert("Unable to process request, please try again.", "Error", "error");
                        }
                        else if (result === 2) {
                            misAlert("Your request can not be processed. Please contact MIS Team.", "Warning", "warning");
                        }
                    }
                    else if (forLeaveType === "LNSA") {
                        if (result === 1) {
                            $("#modalCancelLeave").modal("hide");
                            misAlert("LNSA request has been cancelled successfully.", "Success", "success");
                            getUserAllAvailedLeaves();
                        }
                        else if (result === 2) {
                            misAlert('Your request can not be processed. Please contact MIS Team.', "Warning", "warning");
                        }
                        else
                            misAlert("Unable to process request, please try again.", "Error", "error");
                    }
                    else if (forLeaveType === "AdvanceLeave") {
                        if (result === 1) {
                            $("#modalCancelLeave").modal("hide");
                            getUserAllAvailedLeaves();
                            misAlert("Advance leave has been cancelled successfully.", "Success", "success");
                        }
                        else
                            misAlert("Unable to process request, please try again.", "Error", "error");
                    }
                    else if (forLeaveType === "LWPChangeRequest") {
                        if (result === 1) {
                            $("#modalCancelLeave").modal("hide");
                            getUserAllAvailedLeaves();
                            misAlert("LWP change request has been cancelled successfully.", "Success", "success");
                        }
                        else if (result === 2) {
                            misAlert('Your request can not be processed. Please contact MIS Team.', "Warning", "warning");
                        }
                        else {
                            misAlert("Unable to process request. please try again", "Error", "error");
                        }
                    }
                });
        }
    });
}

function cancelAndApplyLeave(leaveId) {
    $("#modalApplyLeaveOnUserBehalf").modal('show');
    $("#btnSubmitleaveByHR").show();
    $("#btnSubmitLeave").hide();
    $("#showOnCancelLeaveByHR").show();
    $("#cancelLeaveReason").addClass("validation-required");
    var jsonObject = {
        type: 'LEAVE',
        userAbrhs: selectedEmployeeAbrhs,
    };
    calltoAjax(misApiUrl.getLastRecordDetails, "POST", jsonObject,
        function (result) {
            $("#leaveContactNumber").val(result.PrimaryContactNo);
            $("#leaveAltContactNumber").val(result.AlternativeContactNo);
        });
    $("#leaveFromDate").datepicker("destroy");
    $("#leaveFromDate").datepicker({ autoclose: true, todayHighlight: true });
    _leaveIdToBeCancelled = leaveId;
    leaveIdToCancel = leaveId;
}

function finalCancelAndApplyLeaveOnUserBehalf() {
    if (!validateControls("modalApplyLeaveOnUserBehalf"))
        return false;
    var jsonObject = {
        leaveApplicationId: leaveIdToCancel,
        remarks: $("#cancelLeaveReason").val(),
        userAbrhs: misSession.userabrhs,
        isCancelByHR: true,
        type: "All"
    };
    calltoAjax(misApiUrl.cancelLeave, "POST", '',
        function (result) {
            if (result == 0) {
                var isFirstDayHalfDayLeave = false, isLastDayHalfDayLeave = false;
                var phoneNo = $("#leaveContactNumber").val();
                var pattern = /^\d{10}$/;
                if (pattern.test(phoneNo) == false)
                    misAlert("Invalid contact number", "Warning", "warning");
                else {
                    var leaveFromDate = $("#leaveFromDate input").val();
                    var leaveTillDate = $("#leaveTillDate input").val();
                    if ($("#isLeaveLastHalfDay").is(':checked'))
                        isLastDayHalfDayLeave = true;
                    if ($("#isLeaveFirstHalfDay").is(':checked'))
                        isFirstDayHalfDayLeave = true;
                    if ($("#isLeaveHalfDay").is(':checked')) {
                        if ($("#isFirstHalfLeave").is(":checked"))
                            isFirstDayHalfDayLeave = true;
                        else if ($("#isSecondHalfLeave").is(":checked"))
                            isLastDayHalfDayLeave = true;
                        else {
                            misAlert("Kindly fill preference for half day leave", "Warning", "warning");
                            return false;
                        }
                    }
                    var isAvailableOnMobile = false;
                    if ($("#avilableOnMobile").is(':checked'))
                        isAvailableOnMobile = true;
                    var isAvailableOnEmail = false;
                    if ($("#avilableOnEmail").is(':checked'))
                        isAvailableOnEmail = true;
                    var jsonObject = {
                        EmployeeAbrhs: selectedEmployeeAbrhs,
                        UserAbrhs: misSession.userabrhs,
                        FromDate: leaveFromDate,
                        TillDate: leaveTillDate,
                        Reason: $("#leaveReason").val(),
                        SelectedLeaveCombination: selectedLeaveCombination,
                        PrimaryContactNo: $("#leaveContactNumber").val(),
                        AlternativeContactNo: $("#leaveAltContactNumber").val(),
                        IsAvailableOnMobile: isAvailableOnMobile,
                        IsAvailableOnEmail: isAvailableOnEmail,
                        IsFirstDayHalfDayLeave: isFirstDayHalfDayLeave,
                        IsLastDayHalfDayLeave: isLastDayHalfDayLeave,
                    };
                    calltoAjax(misApiUrl.applyLeave, "POST", jsonObject,
                        function (result) {
                            if (result) {
                                $("#modalApplyLeaveOnUserBehalf").modal("hide");
                                $("#leaveFromDate input").val("");
                                $("#leaveReason").val("");
                                $("#leaveContactNumber").val("");
                                $("#leaveAltContactNumber").val("");
                                $("#isLeaveHalfDay").attr("checked", false);
                                $("#isLeaveFirstHalfDay").attr("checked", false);
                                $("#isLeaveLastHalfDay").attr("checked", false);
                                $("#isLeaveFirstHalfDay").attr("checked", false);
                                $("#isLeaveLastHalfDay").attr("checked", false);
                                $("#avilableOnMobile").attr('checked', false);
                                $("#avilableOnEmail").attr('checked', false);
                                misAlert("Request processed successfully", "Success", "success");
                                loadLeaveBalanceGridForSelectedEmployee();
                                getUserAllAvailedLeaves();
                                onFromDateChange();
                            } else {
                                misAlert("Unable to process request. Please try again", "Error", "error");
                            }
                        });
                }
            }
            else if (result == 2) {
                misAlert("This leave is availed or has already been cancelled", "Warning", "warning");
            }
            else
                misAlert("Unable to process request. Please try again", "Error", "error");
        });
}

// ---- out duty/ tour leave module

function getOutingType() {
    var jsonObject = {
        checkEligibility: true
    };
    calltoAjax(misApiUrl.getOutingType, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            var n = 0;
            $("#outingType").empty();
            $("#outingType").append("<option value='0'>Select</option>");
            $.each(data, function (key, val) {
                $("#outingType").append("<option value =" + data[n].OutingTypeId + " >" + data[n].OutingTypeName + "</option>");
                n++;
            });
        }
    );
}

function OutingFromDateChange() {
    var fromDate = $("#outingFromDate").val();
    $("#outingTillDate").val("");
    $("#outingTillDatePicker").datepicker({ autoclose: true, todayHighlight: true }).datepicker('setStartDate', fromDate);
}

function submitOutingDetails() {
    if (!validateControls("tabApplyOuting"))
        return false;
    var phoneNo = $("#outingContactNumber").val();
    var pattern = /^\d{10}$/;

    if ($("#outingAltContactNumber").val().length > 0) {
        var altContactNumber = $("#outingAltContactNumber").val();
        if (pattern.test(altContactNumber) === false) {
            misAlert("Invalid other contact number", "Warning", "warning");
            return false;
        }
    }
    if (pattern.test(phoneNo) === false)
        misAlert("Invalid contact number", "Warning", "warning");
    else {
        var FromDate = $("#outingFromDate").val();
        var TillDate = $("#outingTillDate").val();
    }
    var jsonObject = {
        LoginUserAbrhs: misSession.userabrhs,
        EmployeeAbrhs: selectedEmployeeAbrhs,
        FromDate: FromDate,
        TillDate: TillDate,
        Reason: $("#outingReason").val(),
        PrimaryContactNo: $("#outingContactNumber").val(),
        AlternativeContactNo: $("#outingAltContactNumber").val(),
        OutingTypeId: $("#outingType").val()
    };

    calltoAjax(misApiUrl.applyOutingRequest, "POST", jsonObject,
        function (result) {
            switch (result) {
                case 0: //failure
                    misAlert("Unable to process request, please try again.", "Error", "error");
                    break;
                case 1: //date collision
                    misAlert("You have already applied for Out Duty/Tour request or other types of leave in this period, please try again.", "Date collision", "warning");
                    break;
                case 2: //success
                    misAlert("Out Duty/Tour request has been applied successfully.", "Success", "success");
                    $("#outingFromDate").val("");
                    $("#outingTillDate").val("");
                    $("#outingReason").val("");
                    $("#outingContactNumber").val("");
                    $("#outingAltContactNumber").val("");
                    $("#outingType").val(0);
                    loadLeaveBalanceGridForSelectedEmployee();
                    getUserAllAvailedLeaves();
            }
        });
}


// ----------------WFH -------------

var selectedDate;

$("#WorkFromHomeDate").change(function () {
    selectedDate = $("#WorkFromHomeDate input").val();
});

function onWFHTabClick() {
    $("#isWFHHalfDay").attr('unchecked');
    loadDatesForWFH();
}

$("#isWFHHalfDay").change(function () {
    if ($("#isWFHHalfDay").is(':checked')) {
        $("#halfDayPreferenceWfhShow").show();
    } else {
        $("#halfDayPreferenceWfhShow").hide();
        $("#isFirstHalfWfh").attr("checked", false)// = false;
        $("#isSecondHalfWfh").attr("checked", false)//.checked = false;
    }
});

function submitWFH() {
    if (!validateControls('tabApplyWFH'))
        return false;
    var contactNo = $("#wfmMobileNo").val().replace(/\D/g, '');
    $("#wfmMobileNo").val(contactNo);
    if (!contactNo.match('[0-9]{10}') && contactNo.length != 10) {
        misAlert("Please put 10 digit mobile number.", "Warning", "warning");
        return;
    }

    var isFirstHalfWfh = false, isLastHalfWfh = false;

    if ($("#isWFHHalfDay").is(':checked')) {
        if ($("#isFirstHalfWfh").is(":checked"))
            isFirstHalfWfh = true;
        else if ($("#isSecondHalfWfh").is(":checked"))
            isLastHalfWfh = true;
        else {
            misAlert("Kindly fill preference for half day WFH", "Warning", "warning");
            return false;
        }
    }

    var isWFHHalfDay = $("#isWFHHalfDay").attr('checked') ? true : false;
    var jsonObject = {
        date: selectedDate,
        reason: $("#WFHReason").val(),
        isFirstHalfWfh: isFirstHalfWfh,
        isLastHalfWfh: isLastHalfWfh,
        mobileNo: $("#wfmMobileNo").val(),
        userAbrhs: selectedEmployeeAbrhs,
    };
    calltoAjax(misApiUrl.requestForWorkForHome, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            if (result == 1) {
                misAlert("Request processed successfully", "Success", "success");
                getUserAllAvailedLeaves();
                loadLeaveBalanceGridForSelectedEmployee();
                $("#WorkFromHomeDate input").val("");
                $("#WFHReason").val("");
                $("#isWFHHalfDay").attr('checked', false);
                $("#isFirstHalfWfh").attr('checked', false);
                $("#isSecondHalfWfh").attr('checked', false);
                $("#halfDayPreferenceWfhShow").hide();
            }
            else if (result == 2) {
                misAlert("You have already applied WFH or other types of leave for this date.", "Date collision", "warning");
            }
            else
                misAlert("Unable to process request. Please try again", "Error", "error");
        });
}

// ----------------LNSA -------------

function loadUserShiftMapping() {
    var jsonObject = {
        userAbrhs: selectedEmployeeAbrhs
    };
    calltoAjax(misApiUrl.getShiftMappingDetails, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            bindLNSACalendar(data);
        });
}

function bindLNSACalendar(data) {
    $('#lnsaDetails').empty();
    let div = $('#lnsaDetails');
    let week = $('.week');
    let lnsaStatus;
    var emptyHtml;
    if (data.ShiftMappingDetails.IsCurrentMonthYear == true) {
        $('#btnNextMonth').attr("disabled", true);
    }
    else {
        $('#btnNextMonth').attr("disabled", false);
    }
    $("#hdnStartDate").val(data.ShiftMappingDetails.StartDate);
    $("#hdnEndDate").val(data.ShiftMappingDetails.EndDate);

    $("#startDate").html(data.ShiftMappingDetails.ShiftMappingStartDate);
    $("#endDate").html(data.ShiftMappingDetails.ShiftMappingEndDate);

    var weekCount = data.ShiftMappingDetails.WeekDetails.length;
    var weekWidthClass = 'divCellWidth' + weekCount;//(weekCount === 6) ? 'divCellWidth6' : 'divCellWidth5';
    for (var i = 0; i < weekCount; i++) {
        var lnsahtml = "";
        var blankhtml = "";
        var weekDet = data.ShiftMappingDetails.WeekDetails[i];
        div.append('<div class="divCell ' + weekWidthClass + '" > <div class="week-heading"><input type="checkbox" class="selectAll" id="selectAll' + weekDet.WeekNo + '"/><label class="select-label" for="selectAll' + weekDet.WeekNo + '"> Week #' + weekDet.WeekNo + '</label></div> <div class="week" id=' + weekDet.WeekNo + '></div>')
        for (var s = 0; s < 7; s++) {
            var weekData = weekDet.Weeks[s];
            if (weekData != undefined) {

                if (weekData.IsApplied == true && weekData.IsApproved == true) {
                    lnsaStatus = "approved";
                }
                else if (weekData.IsApplied == true) {
                    lnsaStatus = "lnsaApplied";
                }
                else {
                    lnsaStatus = "lnsaNotApplied";
                }
                //lnsaStatus += (weekData.IsEligible === false) ? ' notEligible' : '';
                lnsahtml += '<div data-attr-dateId="' + weekData.DateId + '" class="' + lnsaStatus + '"><div class="left"><span class="date">' + weekData.MonthDate + '</span></div><div class="right"><span class="day">' + weekData.Day + '</span><span class="month-year">' + weekData.Month + ', ' + weekData.Year + '</span></div></div>';
            }
            else {
                blankhtml += '<div class="empty"></div>';
            }
        }
        if (i == 0) {
            $("div[id= " + weekDet.WeekNo + "]").append(blankhtml + lnsahtml);
        }
        else {
            $("div[id= " + weekDet.WeekNo + "]").append(lnsahtml + blankhtml);
        }

        //if (data.ShiftMappingDetails.IsSubmitBtnActive == true) {
        //    $("#btnReasonPop").show();
        //    $(".selectAll").show();

        //}
        //else {
        //    $("#btnReasonPop").hide();
        //    $(".selectAll").hide();
        //}
    }
    $(".week div[class='lnsaNotApplied']").on("click", function () {
        $(this).toggleClass("active");
        var selectedCell = $(this).parent().find("div.active").length;
        var totalCell = $(this).parent().find("div[class*='lnsa']").length;
        if (totalCell == selectedCell) {
            $(this).parent().parent().find("input").prop("checked", true);
        }
        else {
            $(this).parent().parent().find("input").prop("checked", false);
        }
    });

    $(".selectAll").on("click", function () {
        if ($(this).is(":checked") == true) {
            $(this).parent().parent(".divCell").find("div[class*='lnsa']").addClass("active");
        }
        else {
            $(this).parent().parent(".divCell").find("div[class*='lnsa']").removeClass("active");
        }
    });
}

$("#btnReasonPop").click(function () {
    var activeElements = $("#lnsaDetails .lnsaNotApplied.active");
    var dateIds = [];
    for (var i = 0; i < activeElements.length; i++) {
        var dateId = $(activeElements[i]).attr('data-attr-dateid');
        dateIds.push(dateId);
    }
    validDates = dateIds.join(',');
    if (!validDates) {
        misAlert("Please select date.", "Warning", "warning");
        return false;
    }
    else {
        $("#mypopupviewLnsaReason").modal('show');
        $("#txtLnsaReason").val("As per user request, applied from back-end.");
    }
});

$("#submitRequest").click(function () {
    if (!validateControls('divLnsaReason')) {
        return false;
    }
    else {
        applyLnsaShift();
    }
});

function applyLnsaShift() {
    var reason = $("#txtLnsaReason").val();
    var jsonObject = {
        userAbrhs: selectedEmployeeAbrhs,
        dateIds: validDates,
        reason: reason
    };
    calltoAjax(misApiUrl.applyLnsaShift, "POST", jsonObject,
        function (result) {
            $("#mypopupviewLnsaReason").modal('hide');
            if (result == 1) {
                misAlert("LNSA request has been applied successfully.", "Success", "success");
                loadUserShiftMapping();
                getUserAllAvailedLeaves();
            }
            else if (result == 2) {
                misAlert("Date collision. Try for another date again", "Warning", "warning");
            }
            else if (result == 3)
                misAlert("Applied date is empty or null. Try for another date again", "Warning", "warning");
            else
                misAlert("Unable to process request. Try again", "Error", "error");
        });
}

//----------WeekOff Roster -------------------

function navigateCalendar(navType) {
    var activeMonth = $("#currentMonthYear").data("data-attr-monthNumber");
    var activeYear = $("#currentMonthYear").data("data-attr-year");
    var calendarDate = moment().date(1).month(activeMonth - 1).year(activeYear);
    var desiredCalendarDate = calendarDate;
    if (navType == 'P') //Previous
        desiredCalendarDate = calendarDate.subtract(1, 'months');
    else if (navType == 'N') //Next
        desiredCalendarDate = calendarDate.add(1, 'months');
    else if (navType == 'AM') //Active Month
        desiredCalendarDate = calendarDate;

    var jsonObject = {
        month: desiredCalendarDate.format('MM'),
        Year: desiredCalendarDate.format('YYYY'),
        loginUserAbrhs: selectedEmployeeAbrhs,
        type: 1 // in case of getting rm of login user
    }

    calltoAjax(misApiUrl.getCalendarForWeekOff, "POST", jsonObject,
        function (result) {
            var weeklydata = $.parseJSON(JSON.stringify(result));
            bindWeekOffCalendar(weeklydata);
        });
}

function bindReportees(dateIds) {
    var jsonObject = {
        dateIds: dateIds.join(','),
        loginUserAbrhs: selectedEmployeeAbrhs,
        type: 1
    }
    calltoAjax(misApiUrl.getEligibleEmployeesReportingToUser, "POST", jsonObject,
        function (result) {
            $('#ddlUsers').multiselect("destroy");
            $('#ddlUsers').empty();
            if (result !== null) {
                $.each(result, function (index, value) {
                    $('<option>').val(value.EmployeeAbrhs).text(value.EmployeeName).appendTo('#ddlUsers');
                });
            }
            else {
                $('<option>').val('0').text("Select").appendTo('#ddlUsers');
            }
            //getReportingManagersByTeamId();
            $('#ddlUsers').multiselect({
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                buttonWidth: '100%',
                onDropdownHidden: function (event) {
                }
            });
        });
}

function loadCalendarForMarkingWeekOff() {
    var date = new Date();
    var jsonObject = {
        month: date.getMonth() + 1,
        year: date.getFullYear(),
        loginUserAbrhs: selectedEmployeeAbrhs,
        type: 1 // in case of getting rm of login user
    };
    calltoAjax(misApiUrl.getCalendarForWeekOff, "POST", jsonObject,
        function (result) {
            var weeklydata = $.parseJSON(JSON.stringify(result));
            bindWeekOffCalendar(weeklydata);
        });
}

function getCurrentlyUsingCalendar() {
    navigateCalendar('AM'); //Current Month
}

function bindWeekOffCalendar(weeklydata) {
    _data = weeklydata;
    $('#teamRoaster').empty();
    let div = $('#teamRoaster');
    let week = $('.week');
    //if (weeklydata.WeekOffDetails.IsPreviousMonthDisabled == true) {
    //    $('#btnWeekOffPreviousMonth').attr("disabled", true);
    //}
    //else {
    //    $('#btnWeekOffPreviousMonth').attr("disabled", false);
    //}
    $("#hdnWeekOffStartDate").val(weeklydata.WeekOffDetails.StartDate);
    $("#hdnWeekOffEndDate").val(weeklydata.WeekOffDetails.EndDate);
    //$("#startDate").html(data.WeekOffDetails.StartDate);
    //$("#endDate").html(data.WeekOffDetails.EndDate);
    $("#currentMonthYear").html(weeklydata.WeekOffDetails.CurrentMonthYear);
    $("#currentMonthYear").data("data-attr-monthNumber", weeklydata.WeekOffDetails.ActiveMonth);
    $("#currentMonthYear").data("data-attr-monthNumber");
    $("#currentMonthYear").data("data-attr-year", weeklydata.WeekOffDetails.ActiveYear);
    var htmlday = "";
    var weekCount = weeklydata.WeekOffDetails.WeekDetails.length;
    var weekWidthClass = 'divCellWidth' + (weekCount + 1);//(weekCount === 6) ? 'divCellWidth6' : 'divCellWidth5';
    htmlday = '<div class="divCell ' + weekWidthClass + '"><div class="week weekdays"><div>Days</div><div>Monday</div><div>Tuesday</div><div>Wednesday</div><div>Thursday</div><div>Friday</div><div>Saturday</div><div>Sunday</div></div></div>'
    $("#teamRoaster").html(htmlday)
    for (var i = 0; i < weeklydata.WeekOffDetails.WeekDetails.length; i++) {
        var html = "";
        var blankhtml = "";
        //if (weeklydata.WeekOffDetails.IsMonthDisabled == true) {
        //    currentMonthCol = "disabled-header";
        //}
        //else {
        currentMonthCol = "header";
        //}
        div.append('<div class="divCell ' + weekWidthClass + '"> <div class="week-heading ' + currentMonthCol + '"><button type="button" data-toggle="modal" data-target="#myModalAddWeekOff" class="selectEmp" id="selectEmp' + weeklydata.WeekOffDetails.WeekDetails[i].WeekNo + '"><img width="40" src="../../../Content/Images/employeeRoaster.png"/> <span class="week-number">Week #' + weeklydata.WeekOffDetails.WeekDetails[i].WeekNo + '</span></button> </div> <div class="week" id=' + weeklydata.WeekOffDetails.WeekDetails[i].WeekNo + '></div>')
        for (var j = 0; j < 7; j++) {
            if (weeklydata.WeekOffDetails.WeekDetails[i].Weeks[j] != undefined) {
                if (weeklydata.WeekOffDetails.WeekDetails[i].Weeks[j].IsCurrentMonth == true) {
                    currentMonth = "active-month";
                }
                else {
                    currentMonth = "month";
                }
                html += '<div data-attr-dateid="' + weeklydata.WeekOffDetails.WeekDetails[i].Weeks[j].DateId + '" data-attr-date="' + weeklydata.WeekOffDetails.WeekDetails[i].Weeks[j].Day.slice(0, 3) + ' (' + weeklydata.WeekOffDetails.WeekDetails[i].Weeks[j].Date + ')' + '" class="' + currentMonth + '">\
                            <div class="left-sections">\
                                <span class="date">' + weeklydata.WeekOffDetails.WeekDetails[i].Weeks[j].MonthDate + '</span>\
                                <span class="month-year">' + weeklydata.WeekOffDetails.WeekDetails[i].Weeks[j].Month + '</span>\
                                </div>\
                            <div class="right-sections">';
                var imageHtml = '<div class="employee">';
                for (var m = 0; m < weeklydata.WeekOffDetails.WeekDetails[i].Weeks[j].UserWeekOffDetails.length; m++) {
                    imageHtml += "<img alt=" + weeklydata.WeekOffDetails.WeekDetails[i].Weeks[j].UserWeekOffDetails[m].EmployeeName + " title=" + weeklydata.WeekOffDetails.WeekDetails[i].Weeks[j].UserWeekOffDetails[m].EmployeeName + " src='" + weeklydata.WeekOffDetails.WeekDetails[i].Weeks[j].UserWeekOffDetails[m].ImageUrl + "'/>"
                }
                html += imageHtml + '</div ></div ></div >';
            }
            else {
                blankhtml += '<div class="empty"></div>';
            }

        }
        if (i == 0) {
            $("div[id= " + weeklydata.WeekOffDetails.WeekDetails[i].WeekNo + "]").append(blankhtml + html);
        }
        else {
            $("div[id= " + weeklydata.WeekOffDetails.WeekDetails[i].WeekNo + "]").append(html + blankhtml);
        }
    }
    // $('[data-toggle="tooltip"]').tooltip();
}

function saveWeekOffUsers() {
    var dateIds = (($('#ddlDates').val() !== null && typeof $('#ddlDates').val() !== 'undefined' && $('#ddlDates').val().length > 0) ? $('#ddlDates').val().join(',') : '0');
    var userAbrhs = (($('#ddlUsers').val() !== null && typeof $('#ddlUsers').val() !== 'undefined' && $('#ddlUsers').val().length > 0) ? $('#ddlUsers').val().join(',') : '0');

    if (userAbrhs === "0") {
        misAlert("Please select at least one user", "Warning", "warning");
        return false;
    }
    var jsonObject = {
        dateIds: dateIds,
        userAbrhs: userAbrhs,
        loginUserAbrhs: selectedEmployeeAbrhs,
        type: 1 // for rmid instead of login
    }
    calltoAjax(misApiUrl.addWeekOffForEmployees, "POST", jsonObject,
        function (result) {
            if (result === 1) {
                misAlert("Week-Off has been mapped successfully", "Success", "success");
                weekOffMarkedEmployeesInfo(dates);
                bindReportees(dates);
                getCurrentlyUsingCalendar();
            }
            else if (result === 2) {
                misAlert("You have already mapped week-off for this employee.", "Warning", "warning");
                //$("#myModalAddWeekOff").modal("hide");
                getCurrentlyUsingCalendar();
            }
            else if (result === 3) {
                misAlert("You cannot select more than 3 days in a week.", "Warning", "warning");
                //$("#myModalAddWeekOff").modal("hide");
                getCurrentlyUsingCalendar();
            }
            else {
                misAlert("Unable to process request. Please try again.", "Error", "error");
                //$("#myModalAddWeekOff").modal("hide");
                getCurrentlyUsingCalendar();
            }
        });
}

$('body').on('click', '#tblMarkedEmployeesInfo tbody input[type="checkbox"]', function (e) {
    var $row = $(this).closest('tr');
    // Get row data
    var data = tblMarkedEmployeesInfo.row($row).data();
    // Get row ID
    var rowId = data[0];
    // Determine whether row ID is in the list of selected row IDs
    var index = $.inArray(rowId, rows_selected);
    // If checkbox is checked and row ID is not in list of selected row IDs
    if (this.checked && index === -1) {
        rows_selected.push(rowId);
        //$(this).parent().parent("tr").addClass("selected");
        // Otherwise, if checkbox is not checked and row ID is in list of selected row IDs
    } else if (!this.checked && index !== -1) {
        rows_selected.splice(index, 1);
    }
    // Update state of "Select all" control
    updateDataTableSelectAllCtrlUn(tblMarkedEmployeesInfo);
    // Prevent click event from propagating to parent
    e.stopPropagation();
});

// Handle click on "Select all " control
$('body').on('click', '#WeekOffUsers', function (e) {
    if (this.checked) {
        $('input[type="checkbox"]', '#tblMarkedEmployeesInfo').prop('checked', true);
        var count = $('#tblMarkedEmployeesInfo tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    } else {
        $('input[type="checkbox"]', '#tblMarkedEmployeesInfo').prop('checked', false);
        var count = $('#tblMarkedEmployeesInfo tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    }
    // Prevent click event from propagating to parent
    e.stopPropagation();
})

// Handle click on "Select all " control
$('#tblMarkedEmployeesInfo tbody').on('click', 'input[Name="UnCheckbox"]', function (e) {
    if (this.checked) {
        $('input[type="checkbox"]', '#tblMarkedEmployeesInfo').prop('checked', true);
        var count = $('#tblMarkedEmployeesInfo tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    } else {
        $('input[type="checkbox"]', '#tblMarkedEmployeesInfo').prop('checked', false);
        var count = $('#tblMarkedEmployeesInfo tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    }
    // Prevent click event from propagating to parent
    e.stopPropagation();
})

// Handle click on tableLeaveReviewRequestPending cells with checkboxes
$('#tblMarkedEmployeesInfo tbody').on('click', 'input[type="checkbox"]', function (e) {
    if (e.target.name != "UnCheckbox") {
        $(this).parent().find('input[type="checkbox"]').trigger('click');
        var count = $('#tblMarkedEmployeesInfo tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    }
    else {
        var count = $('#tblMarkedEmployeesInfo tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    }
});

// Handle table draw event
if (tblMarkedEmployeesInfo) {
    tblMarkedEmployeesInfo.on('draw', function () {
        // Update state of "Select all" control
        updateDataTableSelectAllCtrlUn(tblMarkedEmployeesInfo);
    });
}
function updateDataTableSelectAllCtrlUn(tableAssigned) {
    var tableAssigned = tableAssigned.table().node();
    var $chkbox_all = $('tbody input[type="checkbox"]', tableAssigned);
    var $chkbox_checked = $('tbody input[type="checkbox"]:checked', tableAssigned);
    var chkbox_select_all = $('thead input[name="select_all"]', tableAssigned).get(0);

    // If none of the checkboxes are checked
    if ($chkbox_checked.length === 0) {
        chkbox_select_all.checked = false;
        if ('indeterminate' in chkbox_select_all) {
            chkbox_select_all.indeterminate = false;
        }

        // If all of the checkboxes are checked
    } else if ($chkbox_checked.length === $chkbox_all.length) {
        chkbox_select_all.checked = true;
        if ('indeterminate' in chkbox_select_all) {
            chkbox_select_all.indeterminate = false;
        }

        // If some of the checkboxes are checked
    } else {

        chkbox_select_all.checked = true;
        if ('indeterminate' in chkbox_select_all) {
            chkbox_select_all.indeterminate = true;
        }
    }
}

function weekOffMarkedEmployeesInfo(dateIds) {
    dates = dateIds;
    var jsonObject = {
        dateIds: dateIds.join(','),
        loginUserAbrhs: selectedEmployeeAbrhs,
        type: 1// for rmid instead of login
    };
    calltoAjax(misApiUrl.getWeekOffMarkedEmployeesInfo, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            ShowWeekOffMarkedUsers(data);
            if (data.length > 0) {
                var html = "<button type='button' class='btn btn-danger' onclick='showPopupOnBulkRemove()'><i class='fa fa-times'></i>&nbsp;Remove </button>";
                $("#divBulkRemoveWeekOff").html(html);
            }
        });
}

function ShowWeekOffMarkedUsers(data) {
    var data = $.parseJSON(JSON.stringify(data));
    var isHeaderCreated = false;
    $("#tblMarkedEmployeesInfo").dataTable({
        "dom": 'lBfrtip',
        "buttons": [],
        "responsive": true,
        "autoWidth": false,
        "paging": false,
        "bDestroy": true,
        "ordering": false,
        "searching": false,
        // "order": [],
        "info": false,
        "deferRender": true,
        "aaData": data,
        "aoColumns": [
            {
                'targets': 0,
                'searchable': false,
                'width': '1%',
                'orderable': false,
                'bSortable': false,
                "sTitle": '<input name="select_all" value="1" id="WeekOffUsers" type="checkbox" />',
                'className': 'dt-body-center',
                'render': function (data, type, full, meta) {
                    if (full.Selected) {
                        return '<input type="checkbox" name="id[' + full.UserAbrhs + ']" value="' + full.UserAbrhs + '" checked="' + full.UserAbrhs + '">';
                    }
                    else {
                        return '<input type="checkbox" name="id[' + full.UserAbrhs + ']" value="' + full.UserAbrhs + '">';
                    }

                }
            },
            {
                "mData": null,
                "sTitle": "Employee Name",
                "className": "all",
                mRender: function (data, type, row) {
                    var html = data.EmployeeName;
                    return html;
                }
            },
            {
                "mData": null,
                "sTitle": "Dates",
                "className": "all",
                mRender: function (data, type, row) {
                    //if (data.DateDetails.length > 0) {
                    //    var dates = new Array();
                    //    for (var j = 0; j < data.DateDetails.length; j++) {
                    //        dates[j] = data.DateDetails[j].Date;
                    //        var html = "<label class='badge badge-success'>" + dates[j] +"</label>";
                    //    }
                    //   //var newDates = dates.join(', ');
                    //    return html;
                    //}
                    if (data.DateDetails && data.DateDetails.length > 0) {
                        var html = "<table class='emp-week-roster-table'>";
                        var header = "<thead><tr>\
                                            <th>Mon</th>\
                                            <th>Tues</th>\
                                            <th>Wed</th>\
                                            <th>Thurs</th>\
                                            <th>Fri</th>\
                                            <th>Sat</th>\
                                            <th>Sun</th>\
                                        </tr></thead>";
                        if (isHeaderCreated === false) {
                            html += header;
                        }
                        isHeaderCreated = true;
                        html += "<tbody><tr>";
                        for (var j = 0; j < data.DateDetails.length; j++) {
                            if (data.DateDetails[j].IsMarked == false) {
                                html += "<td><label class='badge badge-success'>" + data.DateDetails[j].Date + "</label></td>";
                            }
                            else {
                                html += "<td><label class='badge badge-danger'>" + data.DateDetails[j].Date + "</label></td>";
                            }
                        }
                        html += "</tr></tbody></table>"
                        return html;
                    }

                }
            }
        ]
    });
    tblMarkedEmployeesInfo = $('#tblMarkedEmployeesInfo').DataTable();
}

function showPopupOnBulkRemove() {
    _selectedEmpIds;
    var selectedEmpIds = [];
    //var selectedEmployees = [];
    $("#tblMarkedEmployeesInfo").dataTable().$('input[type="checkbox"]').each(function () {
        if (this.checked) {
            selectedEmpIds.push($(this).val());
            // selectedEmployees.push(this.parentNode.nextElementSibling.firstChild.nodeValue.trim());
        }
    });
    //selectedEmployees = jQuery.unique(selectedEmployees);
    // var Names = selectedEmployees.join();
    _selectedEmpIds = selectedEmpIds.join();
    if (selectedEmpIds.length > 0) {
        misConfirm("Are you sure you want to cancel these week offs?", "Confirm", function (isConfirmed) {
            if (isConfirmed) {
                var jsonObject = {
                    dateIds: dates.join(','),
                    empIds: _selectedEmpIds,
                    loginUserAbrhs: misSession.userabrhs,
                }
                calltoAjax(misApiUrl.bulkRemoveMarkedWeekOffUsers, "POST", jsonObject,
                    function (result) {
                        var resultData = $.parseJSON(JSON.stringify(result));
                        if (resultData) {
                            switch (resultData) {
                                case 1:
                                    misAlert("Users week-off has been unmapped successfully.", "Success", "success");
                                    weekOffMarkedEmployeesInfo(dates);
                                    bindReportees(dates);
                                    getCurrentlyUsingCalendar();
                                    $("#divBulkRemoveWeekOff").html("");
                                    break;
                                case 0:
                                    misAlert("Unable to process request. Try again", "Error", "error");
                                    weekOffMarkedEmployeesInfo(dates);
                                    bindReportees(dates);
                                    getCurrentlyUsingCalendar();
                                    $("#divBulkRemoveWeekOff").html("");
                                    break;
                            }
                        }
                    });
            }
        });
    }
    else {
        misAlert("Please select atleast one user.", "Warning", "warning");
    }
}

//Advance Leave

function onAdvanceLeaveFromDateChange() {
    $("#advanceLeaveTillDate").datepicker("destroy");
    var fromDate = $("#advanceLeaveFromDate input").val();
    $("#advanceLeaveTillDate input").val("");
    $('#advanceLeaveTillDate').datepicker({ autoclose: true, todayHighlight: true }).datepicker('setStartDate', fromDate);
}

function submitAdvanceLeave() {
    var jsonObject = {
        employeeAbrhs: selectedEmployeeAbrhs,
        fromDate: $("#advanceLeaveFromDate input").val(),
        tillDate: $("#advanceLeaveTillDate input").val(),
        reason: $("#advanceLeaveReason").val()
    }
    calltoAjax(misApiUrl.submitAdvanceLeave, "POST", jsonObject,
        function (result) {
            if (result == 1) {
                getUserAllAvailedLeaves();
                $("#advanceLeaveFromDate input").val("");
                $("#advanceLeaveTillDate input").val("");
                misAlert("Advance leave applied successfully.", "Success", "success");
            }
            else if (result == 2) {
                misAlert("Already applied for this period.", "Warning", "warning");
            }
            else if (result == 0) {
                misAlert("Your request can not be processed.", "Error", "error");
            }
        });
}
var resizetableId;
var _advanceLeaveId;
function getDatesToCancelAdvanceLeaves(leaveId, can) {
    _advanceLeaveId = leaveId;
    var jsonObject = {
        leaveId: leaveId
    };
    $("#mypopupCancelAdvanceLeave").modal("show");
    calltoAjax(misApiUrl.getDatesToCancelAdvanceLeave, "POST", jsonObject,
        function (result) {
            var ReqData = [];
            var count = 0;
            ReqData = getAllMatchedObject({ 'IsCancellable': true }, result);
            count = ReqData.length;
            if (count == 0 && can == 0) {
                $("#mypopupCancelAdvanceLeave").modal("hide");
                getUserAllAvailedLeaves();
            }
            else {
                var data = $.parseJSON(JSON.stringify(result));
                resizetableId = "#tblAdvanceLeaveDataToCancel";
                $("#tblAdvanceLeaveDataToCancel").dataTable({
                    "responsive": true,
                    "autoWidth": true,
                    "paging": false,
                    // "lengthMenu": [[5, 10, 20, -1], [5, 10, 20, "All"]],
                    //"pageLength": 5,
                    "scrollY": "200px",
                    "scrollCollapse": true,
                    "bDestroy": true,
                    "ordering": true,
                    "order": [],
                    "info": false,
                    "deferRender": true,
                    "aaData": data,
                    "searching": false,
                    "aoColumns": [
                        {
                            "mData": "Date",
                            "sTitle": "Date",
                        },
                        {
                            "mData": "Status",
                            "sTitle": "Status",
                        },
                        {
                            "mData": null,
                            "sTitle": "Action",
                            "sWidth": "120px",
                            mRender: function (data, type, row) {
                                var html = "";
                                var period = data.Date;
                                var LeaveType = "Advance Leave";
                                var FetchLeaveType = "AdvanceLeave"
                                if (data.IsCancellable) {
                                    html += '<button type="button" class="btn btn-sm btn-danger"' + 'onclick="cancelAdvanceLeaveByHR(' + row.LnsaRequestDetailId + ',\'' + FetchLeaveType + '\')" data-toggle="tooltip" title="Cancel"><i class="fa fa-times"></i></button>';
                                }
                                return html;
                            }
                        },
                    ],
                });
                setTimeout(resizeDataTable, 200);
            }
        });
}

function resizeDataTable() {
    $(resizetableId).DataTable().order([[1, 'asc']]).draw(false);
}

function cancelAdvanceLeaveByHR(leaveId, forLeaveType) {
    $("#mypopupviewAdvanceLeaveRemark").modal('show');
    $("#advanceLeaveRemark").val("As per user request, cancelled from back-end.");
    $("#hiddenLeaveApplicationId").val(leaveId);
    $("#hiddenForLeaveType").val(forLeaveType);
}
$("#btnCancelAdvanceLeave").on('click', function () {
    cancelAdvanceLeave();
})

function cancelAdvanceLeave() {
    var forLeaveType = $("#hiddenForLeaveType").val();
    if (!validateControls("mypopupviewAdvanceLeaveRemark"))
        return false;

    var reply = misConfirm("Are you sure you want to cancel this request ?", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                leaveApplicationId: $("#hiddenLeaveApplicationId").val(),
                remarks: $("#advanceLeaveRemark").val(),
                userAbrhs: misSession.userabrhs,//selectedEmployeeAbrhs,
                isCancelByHR: true,
                forLeaveType: forLeaveType,
                type: "Single"
            };
            calltoAjax(misApiUrl.cancelLeave, "POST", jsonObject,
                function (result) {
                    $("#mypopupviewAdvanceLeaveRemark").modal("hide");
                    if (result === 1) {
                        getDatesToCancelAdvanceLeaves(_advanceLeaveId, 0);
                        misAlert("Advance leave has been cancelled successfully.", "Success", "success");
                    }
                    else
                        misAlert("Unable to process request, please try again.", "Error", "error");
                });
        }
    });
}

