var _category, _period;

$("#dataChangeCategory").change(function () {
    $("#dataChangePeriod").empty();
    if ($("#dataChangeCategory").val() == 0)
        return false;

    if ($("#dataChangeCategory").val() == 1)
        _category = "Leave";
    else
        _category = "Attendance";    
    fetchDatesForDataChangeRequest();
});

function fetchDatesForDataChangeRequest() {
    var jsonObject = {
        category: _category,
        userAbrhs: misSession.userabrhs,
    };
    calltoAjax(misApiUrl.fetchDateForDataChange, "POST", jsonObject,
        function (result) {
            console.log(result);
            //var resultData = $.parseJSON(JSON.stringify(result));
            $("#dataChangePeriod").empty();
            if (result == null && _category == "Leave") {
                $("#dataChangePeriod").append("<option value='0'>No availed leaves</option>");
            }
            else if (result == null && _category == "Attendance") {
                $("#dataChangePeriod").append("<option value='0'>No dates available</option>");
            }
            else {
                $("#dataChangePeriod").append("<option value='0'>Select</option>");
                $.each(result, function (index, result) {
                    $("#dataChangePeriod").append("<option value =" + result.Id + " >" + result.Period + "</option>");
                });
            }
        });
}

$("#dataChangePeriod").change(function() {
    _period = this.options[this.selectedIndex].text;
});

function submitDataChangeRequest() {
    if (!validateControls('tabDataChangeRequest'))
        return false;

    var jsonObject = {
        type: _category,
        recordId: $("#dataChangePeriod").val(),
        reason: $("#dataChangeReason").val(),
        //period: _period,
        userAbrhs: misSession.userabrhs,
    };
    calltoAjax(misApiUrl.insertRequestForDataChange, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            if (result) {
                misAlert("Request processed successfully", "Success", "success");
                $("#dataChangeCategory").val("");
                $("#dataChangePeriod").val("");
                $("#dataChangeReason").val("");
            }
            else
                misAlert("Unable to process request. Please try again", "Error", "error");
        });
}