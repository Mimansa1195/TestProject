$(document).ready(function () {
    //var ToDate = new Date();
    //var FromDate = new Date();
    //$("#fromDate input").val(toddmmyyyDatePicker(FromDate));
    //$("#tillDate input").val(toddmmyyyDatePicker(ToDate));

    $('#fromDate').datepicker({
        format: "mm/dd/yyyy",
        autoclose: true,
        todayHighlight: true,
    }).datepicker('setEndDate', new Date()).on('changeDate', function (ev) {
        var fromStartDate = new Date(ev.date.valueOf());
        $('#tillDate input').val('');
        $('#tillDate').datepicker('setStartDate', $("#fromDate input").val()).trigger('change');
    });

    $('#tillDate').datepicker({
        format: "mm/dd/yyyy",
        autoclose: true,
        todayHighlight: true
    }).datepicker('setEndDate', new Date()).on('changeDate', function (ev) {
        onTillDateChange();
        });
});
function onTillDateChange() {
    if ($("#fromDate input").val() !== '' && $("#tillDate  input").val() !== '')
    {
        var jsonObject = {
            fromDate: $("#fromDate input").val(),
            tillDate: $("#tillDate input").val(),
            userAbrhs: misSession.userabrhs,
        };
        calltoAjax(misApiUrl.getConflictStatusOfLnsaPeriod, "POST", jsonObject,
            function (result) {
                if (result) {
                    $(".toggleDiv").hide();
                    misAlert("Date collision. Please Choose Again !", "Warning", "warning");
                    $("#fromDate input").val("");
                    $(".toggleDiv").hide();
                    $('#tillDate  input').val("");
                }
                else {
                    var fd = new Date($("#fromDate input").val());
                    var td = new Date($("#tillDate input").val());
                    var timediff = Math.abs(td.getTime() - fd.getTime());
                    var daysdiff = Math.ceil(timediff / (1000 * 3600 * 24)) + 1;

                    $(".toggleDiv").show();
                    $("#lnsaTotalDays").val(daysdiff);
                }
            });
    }
}

function saveLnsaRequest() {
    if (!validateControls('lnsaDiv')) {
        return false;
    }
    var jsonObject = {
        fromDate: $("#fromDate input").val(),
        tillDate: $("#tillDate input").val(),
        reason: $("#reason").val(),
        userAbrhs: misSession.userabrhs,
    };
    calltoAjax(misApiUrl.insertLnsaRequest, "POST", jsonObject,
        function (result) {
            if (result) {
                $("#fromDate input").val('');
                $("#tillDate input").val('');

                misAlert("Request processed successfully", "Success", "success");
            }
            else {
                misAlert("Unable to process request. Try again", "Error", "error");
            }
        });
}

