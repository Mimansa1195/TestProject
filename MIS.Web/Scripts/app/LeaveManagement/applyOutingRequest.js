var currentTime = new Date();
$(document).ready(function () {
    getOutingType();
    if (currentTime.getMonth() === 0) {
        if (currentTime.getDate() > 24) {
            $('#outingFromDatePicker').datepicker({ autoclose: true, todayHighlight: true }).datepicker('setStartDate', new Date(currentTime.getFullYear(), currentTime.getMonth(), 25));
        }
        else
            $('#outingFromDatePicker').datepicker({ autoclose: true, todayHighlight: true }).datepicker('setStartDate', new Date(currentTime.getFullYear() - 1, 11, 25));
    } else {
        if (currentTime.getDate() > 24)
            $('#outingFromDatePicker').datepicker({ autoclose: true, todayHighlight: true }).datepicker('setStartDate', new Date(currentTime.getFullYear(), currentTime.getMonth(), 25));
        else
            $('#outingFromDatePicker').datepicker({ autoclose: true, todayHighlight: true }).datepicker('setStartDate', new Date(currentTime.getFullYear(), currentTime.getMonth() - 1, 25));
    }
});

function getOutingType() {
    var jsonObject = {
        checkEligibility : false
    }
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
    $("#outingTillDatePicker").datepicker({autoclose: true, todayHighlight: true }).datepicker('setStartDate',fromDate);
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
        LoginUserAbrhs: 'NA',
        EmployeeAbrhs: misSession.userabrhs,                                      
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
                        break;
                }
            });
    }