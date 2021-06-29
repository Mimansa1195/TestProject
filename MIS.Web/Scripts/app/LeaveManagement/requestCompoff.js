var selectedDate;

function onCompOffTabClick() {
    loadAvailableCompOffDates();
}

$("#CompOffDate").change(function () {
    selectedDate = this.options[this.selectedIndex].text;
    $("#CompOffDays").empty();    
    if (selectedDate.split('(')[1] == 'Weekoff)')
        $("#CompOffDays").append("<option value='1'>1</option><option value='2'>2</option>");
    else
        $("#CompOffDays").append("<option value='1'>1</option>");
});

function loadAvailableCompOffDates() {
    var jsonObject = {
        userAbrhs: misSession.userabrhs,
    };
    calltoAjax(misApiUrl.fetchDatesToRequestCompOff, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#CompOffDate").empty();
            if (result == null) {
                $("#CompOffDate").append("<option value='0'>No dates available</option>");
            } else {
                $("#CompOffDate").append("<option value='0'>Select</option>");
                $.each(result, function (index, result) {
                    $("#CompOffDate").append("<option value =" + result.DateId + " >" + result.DateAndOcassion + "</option>");
                });
            }
        });
}

function submitCompOff() {
    if (!validateControls('tabApplyCompOff'))
        return false;

    var jsonObject = {
        date: selectedDate,
        days: 1,                  // $("#CompOffDays").val(),
        reason: $("#CompOffReason").val(),
        userAbrhs: misSession.userabrhs,
    };
    calltoAjax(misApiUrl.requestForCompOff, "POST", jsonObject,
        function (result) {
            if (result) {
                misAlert("Request processed successfully", "Success", "success");
                $("#CompOffDate").val("");
                $("#CompOffReason").val("");
                $("#CompOffDays").val("1");
                loadAvailableCompOffDates();
            }
            else
                misAlert("Unable to process request. Please try again", "Error", "error");
        });
}
