var _currentAttendanceId, _selectedEmployeeUserId, _date;

$(document).ready(function () {
    if (misPermissions.isDelegatable) {
        var html = '';
        if (!misPermissions.isDelegated) {
            html = '<button id="btnUserDelegation" type="button" class="btn btn-success"><i class="fa fa-bolt"></i>&nbsp;Delegate</button>';
        }
        else {
            html = '<button id="btnUserDelegation" type="button" class="btn btn-success"><i class="fa fa-lightbulb-o" style="color: yellow;font-size: 20px;"></i>&nbsp;Delegate</button>';
        }
        $("#divDeligation").html(html);
    }

    $('#selectDate').datepicker({ autoclose: true, todayHighlight: true }).datepicker('setEndDate', new Date());

    myDate = new Date();
    date = ('0' + (myDate.getMonth() + 1)).slice(-2) + '/' + ('0' + myDate.getDate()).slice(-2) + '/' + myDate.getFullYear();
    $("#selectDate input").val(date);
    loadRemarks();
    loadActiveEmployees();
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
});

function loadRemarks() {
    calltoAjax(misApiUrl.loadRemarks, "POST", '',
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            if (result != null) {
                $("#newStatus").empty();
                $("#newStatus").append("<option value = '0' > Select </option>");
                $.each(result, function (index, result) {
                    $("#newStatus").append("<option value =" + result.AttendanceStatusId + " >" + result.Remarks + "</option>");
                });
            }
        });
}

function loadActiveEmployees() {
    calltoAjax(misApiUrl.listAllActiveUsers, "POST", '',
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            if (result != null) {
                $("#employeeName").empty();
                $("#leaveEmployeeName").empty();
                $("#employeeName").append("<option value = '0' > Select </option>");
                $("#leaveEmployeeName").append("<option value = '0' > Select </option>");
                $.each(result, function (index, result) {
                    $("#employeeName").append("<option value =" + result.EmployeeAbrhs + " >" + result.EmployeeName + "</option>");
                    $("#leaveEmployeeName").append("<option value =" + result.EmployeeAbrhs + " >" + result.EmployeeName + "</option>");
                });
            }
        });
}

function loadInActiveEmployees() {
    calltoAjax(misApiUrl.listAllInActiveUsers, "POST", '',
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            if (result != null) {
                $("#employeeName").empty();
                $("#leaveEmployeeName").empty();
                $("#employeeName").append("<option value = '0' > Select </option>");
                $("#leaveEmployeeName").append("<option value = '0' > Select </option>");
                $.each(result, function (index, result) {
                    $("#employeeName").append("<option value =" + result.EmployeeAbrhs + " >" + result.EmployeeName + "</option>");
                    $("#leaveEmployeeName").append("<option value =" + result.EmployeeAbrhs + " >" + result.EmployeeName + "</option>");
                });
            }
        });
}

$("#employeeName").change(function () {
    if ($("#selectDate input").val() != '') {
        var jsonObject = {
            employeeAbrhs: $("#employeeName").val(),
            date: $("#selectDate input").val()
        };

        calltoAjax(misApiUrl.getEmployeeAttendanceDetails, "POST", jsonObject,
            function (result) {
                if (result != null) {
                    $("#inTime").val(result.InTime);
                    $("#outTime").val(result.OutTime);
                    $("#previousRemarks").val(result.Remarks);
                    $("#previousStatus").val(result.StatusRemarks);
                    _currentAttendanceId = result.AttendanceId;
                }
                else
                    misAlert("No data present for the selected date", "Info", "info");
            });
    }
});

function submitUpdateAttendance() {
    if (!validateControls('tabUpdateAttendance'))
        return false;

    var jsonObject = {
        attendanceId: _currentAttendanceId,
        employeeAbrhs: $("#employeeName").val(),
        inTime: $("#userGivenInTime").val(),
        outTime: $("#userGivenOutTime").val(),
        statusId: $("#newStatus").val(),
        remarks: $("#newRemarks").val(),
        userAbrhs: misSession.userabrhs,
    };

    calltoAjax(misApiUrl.updateEmployeeAttendanceDetails, "POST", jsonObject,
        function (result) {
            if (result) {
                misAlert("Request processed successfully", "Success", "success");
                $("#selectDate input").val(date);
                $("#employeeName").val("");
                $("#inTime").val("");
                $("#userGivenInTime").val("");
                $("#outTime").val("");
                $("#userGivenOutTime").val("");
                $("#previousRemarks").val("");
                $("#previousStatus").val("");
                $("#newStatus").val("");
                $("#newRemarks").val("");
            }
        });
}