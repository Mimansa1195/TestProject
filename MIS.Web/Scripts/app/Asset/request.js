$(document).ready(function () {
    var ToDate = new Date();
    var FromDate = new Date();
    $("#dongleIssueFromDate input").val(toddmmyyyDatePicker(FromDate));
    $("#tillDate input").val(toddmmyyyDatePicker(ToDate));

    $('#dongleIssueFromDate').datepicker({
        format: "mm/dd/yyyy",
        autoclose: true,
        todayHighlight: true,
    }).on('changeDate', function (ev) {
        $('#dongleReturnDueDate input').val('');
        $('#dongleReturnDueDate').datepicker('setStartDate', $("#dongleIssueFromDate input").val()).trigger('change');
    });

    $('#dongleReturnDueDate').datepicker({
        format: "mm/dd/yyyy",
        autoclose: true,
        todayHighlight: true
    }).on('changeDate', function (ev) {
        onTillDateChange();
    });

    getUserComment();   
});

function getUserComment() {
    var jsonObject = {
        userAbrhs: misSession.userabrhs,
    };
    calltoAjax(misApiUrl.getUserCommentForDongleAllocation, "POST", jsonObject,
        function (result) {
            $("#reason").val(result);
        });
}


function onTillDateChange() {
    if ($("#dongleIssueFromDate input").val() != "") {
        var jsonObject = {
            dongleIssueFromDate: $("#dongleIssueFromDate input").val(),
            dongleReturnDueDate: $("#dongleReturnDueDate input").val(),
            userAbrhs: misSession.userabrhs,
        };

        calltoAjax(misApiUrl.getConflictStatusOfDongleAllocationPeriod, "POST", jsonObject,
            function (result) {
                if (result) {
                    misAlert("Date collision. Please Choose Again !", "Warning", "warning");
                    $("#dongleIssueFromDate input").val("");
                    $("#dongleReturnDueDate input").val("");
                    //$('#dongleReturnDueDate').datepicker('setStartDate', $("#dongleIssueFromDate input").val()).trigger('change');
                }
            });
    }
}

function saveAssetRequest() {
    if (!validateControls("assetDiv"))
        return false;       
    var jsonObject = {
        issueDate: $("#dongleIssueFromDate input").val(),
        returnDate: $("#dongleReturnDueDate input").val(),
        reason: $("#reason").val(),
        userAbrhs: misSession.userabrhs,
    };
    calltoAjax(misApiUrl.createAssetRequest, "POST", jsonObject,
        function (result) {
            if (result) {
                $("#dongleIssueFromDate input").val('');
                $("#dongleReturnDueDate input").val('');
                $("#reason").val('');
                misAlert("Request processed succesfully", "Success", "success");
            }
            else {
                misAlert("Unable to process request", "Error", "error");
            }
        });
}
