$("#fromDt").change(function () {
    listAvailableLeaveForLegitimate();
});
function onLWPChangeTabClick() {
    listMarkedBySystemLWPDate();
}

function listMarkedBySystemLWPDate() {
        calltoAjax(misApiUrl.listLWPMarkedBySystemByUserId, "POST", "",
            function (result) {
                var data = $.parseJSON(JSON.stringify(result));
                var n = 0;
                $("#fromDt").empty();
                $("#fromDt").append("<option value='0'>Select</option>");
                $.each(data, function (key, val) {
                        if (data[n].IsApplied !== true) {
                            $("#fromDt").append("<option value =" + data[n].LeaveId + " >" + data[n].LeaveDate + "</option>");
                        }
                    n++;
                });
                listAvailableLeaveForLegitimate();
            });
}

function listAvailableLeaveForLegitimate() {
    if ($("#fromDt").val() !== "0" && $("#fromDt").val() !== undefined) {
        var jsonObject = {
            noOfWorkingDays: 1,
            leaveApplicationId: 0,
            userAbrhs: misSession.userabrhs
        };
        calltoAjax(misApiUrl.availableLeaveForLegitimate, "POST", jsonObject,
            function (result) {
                $("#legitimateType").empty();
                $("#legitimateType").append("<option value='0'>Select</option>");
                $.each(result, function (index, item) {
                    $("#legitimateType").append("<option>" + item.LeaveCombination + "</option>");
                });
            });
    }
    else {
        $("#legitimateType").empty();
        $("#legitimateType").append("<option value='0'>Select</option>");
    }
}

function submitLegitimateLeave() {
    if (!validateControls('tabLWPChangeRequest')) {
        return false;
    }
    var fromDate = $('#fromDt option:selected').text();
    jsonObject = {
        employeeAbrhs: 'NA',
        userAbrhs: misSession.userabrhs,
        fromDate: fromDate,
        type: $("#legitimateType").val(),
        reason: $("#legitimateReason").val(),
        leaveId: $("#fromDt").val()
    };
    calltoAjax(misApiUrl.submitLegitimateLeave, "POST", jsonObject,
        function (result) {
            switch (result) {
                case 0: //failure
                    misAlert("Unable to process request. Please try again", "Error", "error");
                    break;
                case 1://date collision
                    misAlert("Already applied for this period. Apply again", "Error", "error");
                    break;
                case 2: //no combination present
                    misAlert("No combination present. Please try again", "Warning", "warning");
                    break;
                case 3: //combination supplied is invalid
                    misAlert("Combination supplied is invalid. Please try again", "Warning", "warning");
                    break;
                case 4: //success
                    misAlert("LWP change request has been applied successfully.", "Success", "success");
                    listMarkedBySystemLWPDate();
                    $("#fromDt").val(0);
                    $("#legitimateType").val(0);
                    $("#legitimateReason").val('');
                    break;
                case 5: //can't aaply lwp change request for the date befor or on 24th of previous month
                    misAlert("Data can't apply before or on 24th of previous month. Please try again", "Warning", "warning");
                    break;
                case 6: //Applied Leave Period is beyond the CompOff expiry date 
                    misAlert("Applied Coff leave is beyond lapsed date or availed. Please try for another date.", "Warning", "warning");
                    break;
                case 7: //applied date doesn't exist 
                    misAlert("Invalid date. Please try for another date.", "Warning", "warning");
                    break;
                case 8: //applied date for lwp change request doesn't exist 
                    misAlert("lwp for the applied lwp change request date doesn't exists. Please try for another date.", "Warning", "warning");
                    break;
            }
        });
}




             