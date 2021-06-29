var data = [];
var validDates;
$(function () {
    loadUserShiftMapping();
    $("#btnPreviousMonth").click(function () {
        var jsonObject = {
            month: new Date($("#hdnStartDate").val()).getMonth() + 1,
            year: new Date($("#hdnStartDate").val()).getFullYear(),
            userAbrhs: misSession.userabrhs
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
            userAbrhs: misSession.userabrhs
        }
        calltoAjax(misApiUrl.getCalenderOnNextButtonClick, "POST", jsonObject,
            function (result) {
                var data = $.parseJSON(JSON.stringify(result));
                bindLNSACalendar(data);
            });
    });
});

function loadUserShiftMapping() {
    var jsonObject = {
        userAbrhs: misSession.userabrhs
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
    var weekWidthClass = 'divCellWidth' + weekCount ;//(weekCount === 6) ? 'divCellWidth6' : 'divCellWidth5';
    for (var i = 0; i < weekCount; i++) {
        var lnsahtml = "";
        var blankhtml = "";
        var weekDet = data.ShiftMappingDetails.WeekDetails[i];
        div.append('<div class="divCell ' + weekWidthClass + '" > <div class="week-heading"><input type="checkbox" class="selectAll" id="selectAll' + weekDet.WeekNo + '"/><label class="select-label" for="selectAll' + weekDet.WeekNo + '"> Week #' + weekDet.WeekNo + '</label></div> <div class="week" id=' + weekDet.WeekNo + '></div>')
        for (var s = 0; s < 7; s++) { 
            var weekData = weekDet.Weeks[s]; 
            if (weekData != undefined) {
                //if (weekData.IsEligible == false && weekData.IsApproved == false && weekData.IsApplied == false) {
                //    lnsaStatus = "notEligible";
                //}
                //else
                if (weekData.IsApplied == true && weekData.IsApproved == true) {
                    lnsaStatus = "approved";
                }
                else if (weekData.IsApplied == true) {
                    lnsaStatus = "lnsaApplied";
                }
                else {
                    lnsaStatus = "lnsaNotApplied";
                }
                lnsaStatus += (weekData.IsEligible === false) ? ' notEligible' : '';
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

        if (data.ShiftMappingDetails.IsSubmitBtnActive == true) {
            $("#btnReasonPop").show();
            $(".selectAll").show();

        }
        else {
            $("#btnReasonPop").hide();
            $(".selectAll").hide();
        }
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
        userAbrhs: misSession.userabrhs,
        dateIds: validDates,
        reason: reason
    };
    calltoAjax(misApiUrl.applyLnsaShift, "POST", jsonObject,
        function (result) {
            $("#mypopupviewLnsaReason").modal('hide');
            if (result == 1) {
                misAlert("LNSA request has been applied successfully.", "Success", "success");
                loadUserShiftMapping();
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

