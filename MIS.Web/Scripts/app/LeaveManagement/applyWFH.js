var selectedDate;

$("#WorkFromHomeDate").change(function () {
    selectedDate = this.options[this.selectedIndex].text;
});

function onWFHTabClick() {
    $("#isWFHHalfDay").attr('unchecked');
    loadDatesForWFH();
    loadLastWfhRecordDetail();
}

function loadLastWfhRecordDetail() {
    var jsonObject = {
        type: 'WFH',
        userAbrhs: misSession.userabrhs,
    };
    calltoAjax(misApiUrl.getLastRecordDetails, "POST", jsonObject,
        function (result) {
            if (result != null) {
                $("#mobileNo").val(result.PrimaryContactNo);
            }
        });
}

function loadDatesForWFH() {
    var jsonObject = {
        userAbrhs: misSession.userabrhs,
    };
    calltoAjax(misApiUrl.fetchDatesToRequestWorkFromHome, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#WorkFromHomeDate").empty();
            if (result == null) {
                $("#WorkFromHomeDate").append("<option value='0'>No dates available</option>");
            } else {
                $("#WorkFromHomeDate").append("<option value='0'>Select</option>");
                $.each(result, function (index, result) {
                    $("#WorkFromHomeDate").append("<option value =" + result.DateId + " >" + result.DateAndOcassion + "</option>");
                });
            }
        });
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
   
    var contactNo = $("#mobileNo").val().replace(/\D/g, '');
    $("#mobileNo").val(contactNo);
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
        mobileNo: $("#mobileNo").val(),
        userAbrhs: misSession.userabrhs,
    };
    calltoAjax(misApiUrl.requestForWorkForHome, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            if (result == 1) {
                misAlert("Request processed successfully", "Success", "success");
                $("#WorkFromHomeDate").val("");
                $("#WFHReason").val("");
                $("#isWFHHalfDay").attr('checked', false);
                $("#isFirstHalfWfh").attr('checked', false);
                $("#isSecondHalfWfh").attr('checked', false);
                $("#halfDayPreferenceWfhShow").hide();
                //$("#mobileNo").val("");
                loadDatesForWFH();
                loadLastRecordDetail();
            }
            else if (result == 2) {
                misAlert("You have already applied WFH or other types of leave for this date.", "Warning", "warning");
            }
            else if (result == 3) {
                misAlert("Invalid Date.", "Warning", "warning");
            }
            else
                misAlert("Unable to process request. Please try again", "Error", "error");
        });
}