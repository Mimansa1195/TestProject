var _halfday, currentTime = new Date();

$(document).ready(function () {
    if (currentTime.getMonth() === 0) {
        if (currentTime.getDate() > 24) {
            $('#leaveFromDate').datepicker({ autoclose: true, todayHighlight: true }).datepicker('setStartDate', new Date(currentTime.getFullYear(), currentTime.getMonth(), 25)).on('changeDate', function (ev) {
                onFromDateChange();
            });
        }
        else
            $('#leaveFromDate').datepicker({ autoclose: true, todayHighlight: true }).datepicker('setStartDate', new Date(currentTime.getFullYear() - 1, 11, 25)).on('changeDate', function (ev) {
                onFromDateChange();
            });
    } else {
        if (currentTime.getDate() > 24)
            $('#leaveFromDate').datepicker({ autoclose: true, todayHighlight: true }).datepicker('setStartDate', new Date(currentTime.getFullYear(), currentTime.getMonth(), 25)).on('changeDate', function (ev) {
                onFromDateChange();
            });
        else
            $('#leaveFromDate').datepicker({ autoclose: true, todayHighlight: true }).datepicker('setStartDate', new Date(currentTime.getFullYear(), currentTime.getMonth() - 1, 25)).on('changeDate', function (ev) {
                onFromDateChange();
            });
    }
    _halfday = 0;
    loadLastRecordDetail();
});

function loadLastRecordDetail() {
    var jsonObject = {
        type: 'LEAVE',
        userAbrhs: misSession.userabrhs
    };

    calltoAjax(misApiUrl.getLastRecordDetails, "POST", jsonObject,
        function (result) {
            if (result !== null) {
                $("#leaveContactNumber").val(result.PrimaryContactNo);
                $("#leaveAltContactNumber").val(result.AlternativeContactNo);
            }
        });
}
function onFromDateChange() {
    $(".toggleDiv").hide();
    $("#bothHalfShow").hide();
    $("#singleHalfShow").hide();
    $("#halfDayPreferenceShow").hide();
    var fromDate = $("#leaveFromDate input").val();
    $('#leaveTillDate input').val("");
    $('#leaveTillDate').datepicker({ autoclose: true, todayHighlight: true }).datepicker('setStartDate', fromDate).on('changeDate', function (ev) {
        onTillDateChange();
    });
    $("#isLeaveHalfDay").attr("checked", false);
    $("#isLeaveFirstHalfDay").attr("checked", false);
    $("#isLeaveLastHalfDay").attr("checked", false);
    $("#isFirstHalfLeave").attr("checked", false);
    $("#isSecondHalfLeave").attr("checked", false);
}
function onTillDateChange() {
    $("#isLeaveHalfDay").attr("checked", false);
    $("#isLeaveFirstHalfDay").attr("checked", false);
    $("#isLeaveLastHalfDay").attr("checked", false);
    $("#isFirstHalfLeave").attr("checked", false);
    $("#isSecondHalfLeave").attr("checked", false);

    if ($("#leaveFromDate input").val() !== '' && $("#leaveTillDate input").val() !== '') {
        var jsonObject = {
            fromDate: $("#leaveFromDate input").val(),
            toDate: $("#leaveTillDate input").val(),
            leaveIdToBeCancelled: 0,
            userAbrhs: misSession.userabrhs
        };
        calltoAjax(misApiUrl.fetchDaysOnBasisOfLeavePeriod, "POST", jsonObject,
            function (result) {
                $("#leaveType").empty();
                if (result.Status === "NA") {
                    misAlert("Date collision, Please reselect the leave period", "Warning", "warning");
                    $("#leaveFromDate input").val("");
                    onFromDateChange();
                }
                else if (result.Date != "") {
                    //var date = result.Date.split(" ");
                    misAlert("You have already applied leave for " + result.Date + ". Apply consecutive leaves in one go. Please try for another date.", "Warning", "warning");
                    $("#leaveFromDate input").val("");
                    onFromDateChange();
                }
                else {
                    if (result.WorkingDays === 0) {
                        misAlert("The leave period that you are applying for is already a calendar leave", "Warning", "warning");
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
                        if (result.WorkingDays === 1) {
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
                fetchAvailableLeave();
            });
    }
}

$("#isLeaveLastHalfDay").change(function () {
    if ($("#isLeaveLastHalfDay").is(':checked')) {
        _halfday = 0.5;
        fetchAvailableLeave();
    }
    else {
        _halfday = -0.5;
        fetchAvailableLeave();
    }
});

$("#isLeaveFirstHalfDay").change(function () {
    if ($("#isLeaveFirstHalfDay").is(':checked')) {
        _halfday = 0.5;
        fetchAvailableLeave();
    }
    else {
        _halfday = -0.5;
        fetchAvailableLeave();
    }
});

$("#isLeaveHalfDay").change(function () {
    if ($("#isLeaveHalfDay").is(':checked')) {
        _halfday = 0.5;
        fetchAvailableLeave();
        $("#halfDayPreferenceShow").show();
    } else {
        _halfday = -0.5;
        fetchAvailableLeave();
        $("#halfDayPreferenceShow").hide();
        $("#isFirstHalfLeave").attr("checked", false)// = false;
        $("#isSecondHalfLeave").attr("checked", false)//.checked = false;
    }
});

$("#leaveType").change(function () {
    selectedLeaveCombination = this.options[this.selectedIndex].text;
    var temp = selectedLeaveCombination.split(' ');
    if (temp[1] === 'CL' && temp[0] > 2) {
        misAlert("This leave will need approval from department head as well", "Info", "info");
    }
});

function fetchAvailableLeave() {
    var workingDays = $("#leaveWorkingDays").text() - _halfday;
    $("#leaveWorkingDays").html(workingDays);

    var jsonObject = {
        noOfWorkingDays: workingDays,
        leaveApplicationId: 0,
        userAbrhs: misSession.userabrhs,
        totalDays: $("#leaveTotalDays").text()
    };

    calltoAjax(misApiUrl.fetchAvailableLeaves, "POST", jsonObject,
        function (result) {
            $("#leaveType").empty();
            $("#leaveType").append("<option value='0'>Select</option>");
            $.each(result, function (index, item) {

                if (currentTime.getMonth() >= 0 && currentTime.getMonth() <= 2 && (new Date($("#leaveTillDate input").val()) <= new Date(currentTime.getFullYear(), 2, 31))) {
                    $("#leaveType").append("<option>" + item.LeaveCombination + "</option>");
                }

                else if (currentTime.getMonth() >= 3 && (new Date($("#leaveTillDate input").val()) <= new Date(currentTime.getFullYear() + 1, 2, 31))) {
                    $("#leaveType").append("<option>" + item.LeaveCombination + "</option>");
                }

                else {
                       if (item.LeaveCombination.toLowerCase().indexOf("cl") >= 0) {
                       }

                        else {
                               $("#leaveType").append("<option>" + item.LeaveCombination + "</option>");
                             }
                     }
            });
        });
}

function submitLeaveDetails() {
    if (!validateControls("tabApplyLeave"))
        return false;

    var isFirstDayHalfDayLeave = false, isLastDayHalfDayLeave = false;

    var phoneNo = $("#leaveContactNumber").val();
    var pattern = /^\d{10}$/;
    var Leavetype;

    if ($("#leaveAltContactNumber").val().length >0) {
        var altContactNumber = $("#leaveAltContactNumber").val();
        if (pattern.test(altContactNumber) === false) {
            misAlert("Invalid other contact number", "Warning", "warning");
            return false;
        }
    }

    if (pattern.test(phoneNo) === false)
        misAlert("Invalid contact number", "Warning", "warning");

    else {

        var isLwp, leaveCount, lwpCount = 0;
        var temp = selectedLeaveCombination.split(' ');
        Leavetype = temp[1];
        if (temp.length === 2) {
            isLwp = false;
            leaveCount = temp[0];
            lwpCount = 0;

        } else {
            isLwp = true;
            leaveCount = temp[0];
            lwpCount = temp[3];
        }

        var leaveFromDate = $("#leaveFromDate input").val();
        var leaveTillDate = $("#leaveTillDate input").val();

        //alert($("#isLeaveLastHalfDay").is(':checked'));

        if ($("#isLeaveFirstHalfDay").is(':checked'))
            isFirstDayHalfDayLeave = true;

        if ($("#isLeaveLastHalfDay").is(':checked'))
            isLastDayHalfDayLeave = true;

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
            EmployeeAbrhs: 'NA',
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
            switch (result) {
                case 0: //failure
                    misAlert("Unable to process request. Please try again", "Error", "error");
                    break;
                case 1: //date collision
                    misAlert("You have already applied for a leave in this period. Please try again", "Date collision", "warning");
                    break;
                case 2: //no combination present
                    misAlert("No combination present. Please try again", "Warning", "warning");
                    break;
                case 3: //combination supplied is invalid
                    misAlert("Combination supplied is invalid. Please try again", "Warning", "warning");
                    break;
                case 4: //success
                    misAlert("Leave applied successfully", "Success", "success");

                    $("#leaveFromDate input").val("");
                    $('#leaveTillDate input').val("");
                    $("#leaveReason").val("");
                    $("#leaveContactNumber").val("");
                    $("#leaveAltContactNumber").val("");
                    $("#isLeaveHalfDay").attr("checked", false);
                    $("#isLeaveFirstHalfDay").attr("checked", false);
                    $("#isLeaveLastHalfDay").attr("checked", false);
                    $("#isFirstHalfLeave").attr("checked", false);
                    $("#isSecondHalfLeave").attr("checked", false);
                    $("#avilableOnMobile").attr('checked', false);
                    $("#avilableOnEmail").attr('checked', false);

                    $(".toggleDiv").hide();
                    $("#bothHalfShow").hide();
                    $("#singleHalfShow").hide();
                    $("#halfDayPreferenceShow").hide();

                    //onFromDateChange();
                    loadLastRecordDetail();
                    break;
                case 5: //data supplied is incorrect
                    misAlert("Data supplied is incorrect. Please try again", "Warning", "warning");
                    break; 
                case 6: //Applied Leave Period is beyond the CompOff expiry date 
                    misAlert("Applied Coff leave is beyond lapsed date or availed. Please try for another date.", "Warning", "warning");
                //case 7:
                //    misAlert("Apply consecutive leaves in one go.Please try for another date", "Warning", "warning");
            }
        });
    }
}