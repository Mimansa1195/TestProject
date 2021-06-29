var weeklydata = [];
var emptyHtml;
var _data;
var values = [];
var rows_selected = [];
var tblMarkedEmployeesInfo = ""
var _selectedEmpIds;
var dates = [];
$(function () {
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
    $('#teamRoaster').html("Loading...");
    loadCalendarForMarkingWeekOff();
    $("#btnWeekOffPreviousMonth").click(function () {
        navigateCalendar('P'); //Previous
    });

    $("#btnWeekOffNextMonth").click(function () {
        navigateCalendar('N');//Next
    });

    $("#saveWeekOffData").on("click", function () {
        if ($("#ddlUsers").find('option:selected').length > 0 && $("#ddlDates").find('option:selected').length > 0) {
            saveWeekOffUsers();
        }
        else
            misAlert("Please select employees and dates before saving.", "Warning", "warning");
    });

    $(document).on("click", ".selectEmp", function () {
        $("#tblMarkedEmployeesInfo").html("");
        $('#ddlUsers,#ddlDates').html('')
        $('#ddlUsers,#ddlDates').multiselect('destroy')
        $(this).toggleClass("active")
        values = [];
        var dateIds = [];
        $(this).parent().parent(".divCell").find("div[class*='month']").each(function () {
            var idx = $.inArray($(this).attr("data-attr-date"), values);
            var dates = $.inArray($(this).attr("data-attr-dateid"), values);
            if (idx == -1) {
                values.push($(this).attr("data-attr-date"));
            } else {
                values.splice(1);
            }
            if (dates == -1) {
                dateIds.push($(this).attr("data-attr-dateid"));
            } else {
                dateIds.splice(1);
            }
            //console.log(values)
        })
        var ddhtml = "";
        for (var dd = 0; dd < values.length; dd++) {
            $('<option>').val(dateIds[dd]).text(values[dd]).appendTo('#ddlDates');
        }
        $('#ddlDates').multiselect({
            buttonWidth: '100%',
        });
        bindReportees(dateIds);
        weekOffMarkedEmployeesInfo(dateIds);
    });
    var html = '<table class="tbl-typical roaster-info-section fixed-header text-left">';
    html += '<thead><tr><th><div>Guidelines To Use Week-Off Calendar</div></th></tr></thead>';
    html += '<tr><td>--> Click on the headers of calendar to map week-off for users. (Eg : Click on Week #1).</td></tr>';
    html += '<tr><td>--> Select users and dates for which week-off has to be mapped.</td></tr>';
    html += '<tr><td>--> Calendar displays user week days.</td></tr>';
    html += '<tr><td>--> Users week-off can be unmapped by clicking on remove button.</td></tr>';
    html += '</table>';
    var pos = "left";
    if ($(document).width() < 768) {
        pos = "bottom"
    }
    $("[data-toggle=popover]").each(function (i, obj) {
        $(this).popover({
            html: true,
            trigger: 'hover',
            placement: pos,
            content: html
        });
    });
});
function navigateCalendar(navType) {
    var activeMonth = $("#currentMonthYear").data("data-attr-monthNumber");
    var activeYear = $("#currentMonthYear").data("data-attr-year");
    var calendarDate = moment().date(1).month(activeMonth - 1).year(activeYear);
    var desiredCalendarDate = calendarDate;
    if (navType == 'P') //Previous
        desiredCalendarDate = calendarDate.subtract(1, 'months');
    else if (navType == 'N') //Next
        desiredCalendarDate = calendarDate.add(1, 'months');
    else if (navType == 'AM') //Active Month
        desiredCalendarDate = calendarDate;

    var jsonObject = {
        month: desiredCalendarDate.format('MM'),
        Year: desiredCalendarDate.format('YYYY'),
        loginUserAbrhs: misSession.userabrhs,
        type : 0 // for login user
    }

    calltoAjax(misApiUrl.getCalendarForWeekOff, "POST", jsonObject,
        function (result) {
            var weeklydata = $.parseJSON(JSON.stringify(result));
            bindWeekOffCalendar(weeklydata);
        });
}
function bindReportees(dateIds) {
    var jsonObject = {
        dateIds: dateIds.join(','),
        loginUserAbrhs: misSession.userabrhs,
        type: 0 // for login user
    }
    calltoAjax(misApiUrl.getEligibleEmployeesReportingToUser, "POST", jsonObject,
        function (result) {
            $('#ddlUsers').multiselect("destroy");
            $('#ddlUsers').empty();
            $.each(result, function (index, value) {
                $('<option>').val(value.EmployeeAbrhs).text(value.EmployeeName).appendTo('#ddlUsers');
            });
            //getReportingManagersByTeamId();
            $('#ddlUsers').multiselect({
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                buttonWidth: '100%',
                onDropdownHidden: function (event) {
                }
            });
        });
}
function loadCalendarForMarkingWeekOff() {
    var date = new Date();
    var jsonObject = {
        month: date.getMonth() + 1,
        year: date.getFullYear(),
        loginUserAbrhs: misSession.userabrhs,
        type: 0 // for login user
    };
    calltoAjax(misApiUrl.getCalendarForWeekOff, "POST", jsonObject,
        function (result) {
            var weeklydata = $.parseJSON(JSON.stringify(result));
            bindWeekOffCalendar(weeklydata);
        });
}
function getCurrentlyUsingCalendar() {
    navigateCalendar('AM'); //Current Month
}
function bindWeekOffCalendar(weeklydata) {
    _data = weeklydata;
    $('#teamRoaster').empty();
    let div = $('#teamRoaster');
    let week = $('.week');
    //if (weeklydata.WeekOffDetails.IsPreviousMonthDisabled == true) {
    //    $('#btnWeekOffPreviousMonth').attr("disabled", true);
    //}
    //else {
    //    $('#btnWeekOffPreviousMonth').attr("disabled", false);
    //}
    $("#hdnWeekOffStartDate").val(weeklydata.WeekOffDetails.StartDate);
    $("#hdnWeekOffEndDate").val(weeklydata.WeekOffDetails.EndDate);
    //$("#startDate").html(data.WeekOffDetails.StartDate);
    //$("#endDate").html(data.WeekOffDetails.EndDate);
    $("#currentMonthYear").html(weeklydata.WeekOffDetails.CurrentMonthYear);
    $("#currentMonthYear").data("data-attr-monthNumber", weeklydata.WeekOffDetails.ActiveMonth);
    $("#currentMonthYear").data("data-attr-monthNumber");
    $("#currentMonthYear").data("data-attr-year", weeklydata.WeekOffDetails.ActiveYear);
    var htmlday = "";
    var weekCount = weeklydata.WeekOffDetails.WeekDetails.length;
    var weekWidthClass = (weekCount === 6) ? 'divCellWidth7' : 'divCellWidth6';
    htmlday = '<div class="divCell ' + weekWidthClass + '"><div class="week weekdays"><div>Days</div><div>Monday</div><div>Tuesday</div><div>Wednesday</div><div>Thursday</div><div>Friday</div><div>Saturday</div><div>Sunday</div></div></div>'
    $("#teamRoaster").html(htmlday)
    for (var i = 0; i < weeklydata.WeekOffDetails.WeekDetails.length; i++) {
        var html = "";
        var blankhtml = "";
        if (weeklydata.WeekOffDetails.IsMonthDisabled == true) {
            currentMonthCol = "disabled-header";
        }
        else {
            currentMonthCol = "header";
        }
        div.append('<div class="divCell ' + weekWidthClass + '"> <div class="week-heading ' + currentMonthCol + '"><button type="button" data-toggle="modal" data-target="#myModalAddWeekOff" class="selectEmp" id="selectEmp' + weeklydata.WeekOffDetails.WeekDetails[i].WeekNo + '"><img width="40" src="../../../Content/Images/employeeRoaster.png"/> <span class="week-number">Week #' + weeklydata.WeekOffDetails.WeekDetails[i].WeekNo + '</span></button> </div> <div class="week" id=' + weeklydata.WeekOffDetails.WeekDetails[i].WeekNo + '></div>')
        for (var j = 0; j < 7; j++) {
            if (weeklydata.WeekOffDetails.WeekDetails[i].Weeks[j] != undefined) {
                if (weeklydata.WeekOffDetails.WeekDetails[i].Weeks[j].IsCurrentMonth == true) {
                    currentMonth = "active-month";
                }
                else {
                    currentMonth = "month";
                }
                html += '<div data-attr-dateid="' + weeklydata.WeekOffDetails.WeekDetails[i].Weeks[j].DateId + '" data-attr-date="' + weeklydata.WeekOffDetails.WeekDetails[i].Weeks[j].Day.slice(0, 3) + ' (' + weeklydata.WeekOffDetails.WeekDetails[i].Weeks[j].Date + ')' + '" class="' + currentMonth + '">\
                            <div class="left-sections">\
                                <span class="date">' + weeklydata.WeekOffDetails.WeekDetails[i].Weeks[j].MonthDate + '</span>\
                                <span class="month-year">' + weeklydata.WeekOffDetails.WeekDetails[i].Weeks[j].Month + '</span>\
                                </div>\
                            <div class="right-sections">';
                var imageHtml = '<div class="employee">';
                for (var m = 0; m < weeklydata.WeekOffDetails.WeekDetails[i].Weeks[j].UserWeekOffDetails.length; m++) {
                    imageHtml += "<img alt=" + weeklydata.WeekOffDetails.WeekDetails[i].Weeks[j].UserWeekOffDetails[m].EmployeeName + " title=" + weeklydata.WeekOffDetails.WeekDetails[i].Weeks[j].UserWeekOffDetails[m].EmployeeName + " src='" + weeklydata.WeekOffDetails.WeekDetails[i].Weeks[j].UserWeekOffDetails[m].ImageUrl + "'/>"
                }
                html += imageHtml + '</div ></div ></div >';
            }
            else {
                blankhtml += '<div class="empty"></div>';
            }

        }
        if (i == 0) {
            $("div[id= " + weeklydata.WeekOffDetails.WeekDetails[i].WeekNo + "]").append(blankhtml + html);
        }
        else {
            $("div[id= " + weeklydata.WeekOffDetails.WeekDetails[i].WeekNo + "]").append(html + blankhtml);
        }
    }
    // $('[data-toggle="tooltip"]').tooltip();
}
function saveWeekOffUsers() {
    var dateIds = (($('#ddlDates').val() !== null && typeof $('#ddlDates').val() !== 'undefined' && $('#ddlDates').val().length > 0) ? $('#ddlDates').val().join(',') : '0');
    var userAbrhs = (($('#ddlUsers').val() !== null && typeof $('#ddlUsers').val() !== 'undefined' && $('#ddlUsers').val().length > 0) ? $('#ddlUsers').val().join(',') : '0');
    var jsonObject = {
        dateIds: dateIds,
        userAbrhs: userAbrhs,
        loginUserAbrhs: misSession.userabrhs,
        type: 0 // for login
    }
    calltoAjax(misApiUrl.addWeekOffForEmployees, "POST", jsonObject,
        function (result) {
            if (result === 1) {
                misAlert("Week-Off has been mapped successfully", "Success", "success");
                weekOffMarkedEmployeesInfo(dates);
                bindReportees(dates);
                getCurrentlyUsingCalendar();
            }
            else if (result === 2) {
                misAlert("You have already mapped week-off for this employee.", "Warning", "warning");
                //$("#myModalAddWeekOff").modal("hide");
                getCurrentlyUsingCalendar();
            }
            else if (result === 3) {
                misAlert("You cannot select more than 3 days in a week.", "Warning", "warning");
                //$("#myModalAddWeekOff").modal("hide");
                getCurrentlyUsingCalendar();
            }
            else {
                misAlert("Unable to process request. Please try again.", "Error", "error");
                //$("#myModalAddWeekOff").modal("hide");
                getCurrentlyUsingCalendar();
            }
        });
}

$('body').on('click', '#tblMarkedEmployeesInfo tbody input[type="checkbox"]', function (e) {
    var $row = $(this).closest('tr');
    // Get row data
    var data = tblMarkedEmployeesInfo.row($row).data();
    // Get row ID
    var rowId = data[0];
    // Determine whether row ID is in the list of selected row IDs
    var index = $.inArray(rowId, rows_selected);
    // If checkbox is checked and row ID is not in list of selected row IDs
    if (this.checked && index === -1) {
        rows_selected.push(rowId);
        //$(this).parent().parent("tr").addClass("selected");
        // Otherwise, if checkbox is not checked and row ID is in list of selected row IDs
    } else if (!this.checked && index !== -1) {
        rows_selected.splice(index, 1);
    }
    // Update state of "Select all" control
    updateDataTableSelectAllCtrlUn(tblMarkedEmployeesInfo);
    // Prevent click event from propagating to parent
    e.stopPropagation();
});

// Handle click on "Select all " control
$('body').on('click', '#WeekOffUsers', function (e) {
    if (this.checked) {
        $('input[type="checkbox"]', '#tblMarkedEmployeesInfo').prop('checked', true);
        var count = $('#tblMarkedEmployeesInfo tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    } else {
        $('input[type="checkbox"]', '#tblMarkedEmployeesInfo').prop('checked', false);
        var count = $('#tblMarkedEmployeesInfo tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    }
    // Prevent click event from propagating to parent
    e.stopPropagation();
})

// Handle click on "Select all " control
$('#tblMarkedEmployeesInfo tbody').on('click', 'input[Name="UnCheckbox"]', function (e) {
    if (this.checked) {
        $('input[type="checkbox"]', '#tblMarkedEmployeesInfo').prop('checked', true);
        var count = $('#tblMarkedEmployeesInfo tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    } else {
        $('input[type="checkbox"]', '#tblMarkedEmployeesInfo').prop('checked', false);
        var count = $('#tblMarkedEmployeesInfo tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    }
    // Prevent click event from propagating to parent
    e.stopPropagation();
})

// Handle click on tableLeaveReviewRequestPending cells with checkboxes
$('#tblMarkedEmployeesInfo tbody').on('click', 'input[type="checkbox"]', function (e) {
    if (e.target.name != "UnCheckbox") {
        $(this).parent().find('input[type="checkbox"]').trigger('click');
        var count = $('#tblMarkedEmployeesInfo tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    }
    else {
        var count = $('#tblMarkedEmployeesInfo tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    }
});

// Handle table draw event
if (tblMarkedEmployeesInfo) {
    tblMarkedEmployeesInfo.on('draw', function () {
        // Update state of "Select all" control
        updateDataTableSelectAllCtrlUn(tblMarkedEmployeesInfo);
    });
}
function updateDataTableSelectAllCtrlUn(tableAssigned) {
    var tableAssigned = tableAssigned.table().node();
    var $chkbox_all = $('tbody input[type="checkbox"]', tableAssigned);
    var $chkbox_checked = $('tbody input[type="checkbox"]:checked', tableAssigned);
    var chkbox_select_all = $('thead input[name="select_all"]', tableAssigned).get(0);

    // If none of the checkboxes are checked
    if ($chkbox_checked.length === 0) {
        chkbox_select_all.checked = false;
        if ('indeterminate' in chkbox_select_all) {
            chkbox_select_all.indeterminate = false;
        }

        // If all of the checkboxes are checked
    } else if ($chkbox_checked.length === $chkbox_all.length) {
        chkbox_select_all.checked = true;
        if ('indeterminate' in chkbox_select_all) {
            chkbox_select_all.indeterminate = false;
        }

        // If some of the checkboxes are checked
    } else {

        chkbox_select_all.checked = true;
        if ('indeterminate' in chkbox_select_all) {
            chkbox_select_all.indeterminate = true;
        }
    }
}
function weekOffMarkedEmployeesInfo(dateIds) {
    dates = dateIds;
    var jsonObject = {
        dateIds: dateIds.join(','),
        loginUserAbrhs: misSession.userabrhs,
        type : 0 // for login
    };
    calltoAjax(misApiUrl.getWeekOffMarkedEmployeesInfo, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            ShowWeekOffMarkedUsers(data);
            if (data.length > 0) {
                var html = "<button type='button' class='btn btn-danger' onclick='showPopupOnBulkRemove()'><i class='fa fa-times'></i>&nbsp;Remove </button>";
                $("#divBulkRemoveWeekOff").html(html);
            }
        });
}
function ShowWeekOffMarkedUsers(data) {
    var data = $.parseJSON(JSON.stringify(data));
    var isHeaderCreated = false;
    $("#tblMarkedEmployeesInfo").dataTable({
        "dom": 'lBfrtip',
        "buttons": [],
        "responsive": true,
        "autoWidth": false,
        "paging": false,
        "bDestroy": true,
        "ordering": false,
        "searching": false,
        // "order": [],
        "info": false,
        "deferRender": true,
        "aaData": data,
        "aoColumns": [
            {
                'targets': 0,
                'searchable': false,
                'width': '1%',
                'orderable': false,
                'bSortable': false,
                "sTitle": '<input name="select_all" value="1" id="WeekOffUsers" type="checkbox" />',
                'className': 'dt-body-center',
                'render': function (data, type, full, meta) {
                    if (full.Selected) {
                        return '<input type="checkbox" name="id[' + full.UserAbrhs + ']" value="' + full.UserAbrhs + '" checked="' + full.UserAbrhs + '">';
                    }
                    else {
                        return '<input type="checkbox" name="id[' + full.UserAbrhs + ']" value="' + full.UserAbrhs + '">';
                    }

                }
            },
            {
                "mData": null,
                "sTitle": "Employee Name",
                "className": "all",
                mRender: function (data, type, row) {
                    var html = data.EmployeeName;
                    return html;
                }
            },
            {
                "mData": null,
                "sTitle": "Dates",
                "className": "all",
                mRender: function (data, type, row) {
                    //if (data.DateDetails.length > 0) {
                    //    var dates = new Array();
                    //    for (var j = 0; j < data.DateDetails.length; j++) {
                    //        dates[j] = data.DateDetails[j].Date;
                    //        var html = "<label class='badge badge-success'>" + dates[j] +"</label>";
                    //    }
                    //   //var newDates = dates.join(', ');
                    //    return html;
                    //}
                    if (data.DateDetails && data.DateDetails.length > 0) {
                        var html = "<table class='emp-week-roster-table'>";
                        var header = "<thead><tr>\
                                            <th>Mon</th>\
                                            <th>Tues</th>\
                                            <th>Wed</th>\
                                            <th>Thurs</th>\
                                            <th>Fri</th>\
                                            <th>Sat</th>\
                                            <th>Sun</th>\
                                        </tr></thead>";
                        if (isHeaderCreated === false) {
                            html += header;
                        }
                        isHeaderCreated = true;
                        html += "<tbody><tr>";
                        for (var j = 0; j < data.DateDetails.length; j++) {
                            if (data.DateDetails[j].IsMarked == false) {
                                html += "<td><label class='badge badge-success'>" + data.DateDetails[j].Date + "</label></td>";
                            }
                            else {
                                html += "<td><label class='badge badge-danger'>" + data.DateDetails[j].Date + "</label></td>";
                            }
                        }
                        html += "</tr></tbody></table>"
                        return html;
                    }

                }
            }
        ]
    });
    tblMarkedEmployeesInfo = $('#tblMarkedEmployeesInfo').DataTable();
}
function showPopupOnBulkRemove() {
    _selectedEmpIds;
    var selectedEmpIds = [];
    //var selectedEmployees = [];
    $("#tblMarkedEmployeesInfo").dataTable().$('input[type="checkbox"]').each(function () {
        if (this.checked) {
            selectedEmpIds.push($(this).val());
            // selectedEmployees.push(this.parentNode.nextElementSibling.firstChild.nodeValue.trim());
        }
    });
    //selectedEmployees = jQuery.unique(selectedEmployees);
    // var Names = selectedEmployees.join();
    _selectedEmpIds = selectedEmpIds.join();
    if (selectedEmpIds.length > 0) {
        misConfirm("Are you sure you want to cancel these week offs?", "Confirm", function (isConfirmed) {
            if (isConfirmed) {
                var jsonObject = {
                    dateIds: dates.join(','),
                    empIds: _selectedEmpIds,
                    loginUserAbrhs: misSession.userabrhs,
                    type: 0 // for login
                }
                calltoAjax(misApiUrl.bulkRemoveMarkedWeekOffUsers, "POST", jsonObject,
                    function (result) {
                        var resultData = $.parseJSON(JSON.stringify(result));
                        if (resultData) {
                            switch (resultData) {
                                case 1:
                                    misAlert("Users week-off has been unmapped successfully.", "Success", "success");
                                    weekOffMarkedEmployeesInfo(dates);
                                    bindReportees(dates);
                                    getCurrentlyUsingCalendar();
                                    $("#divBulkRemoveWeekOff").html("");
                                    break;
                                case 0:
                                    misAlert("Unable to process request. Try again", "Error", "error");
                                    weekOffMarkedEmployeesInfo(dates);
                                    bindReportees(dates);
                                    getCurrentlyUsingCalendar();
                                    $("#divBulkRemoveWeekOff").html("");
                                    break;
                            }
                        }
                    });
            }
        });
    }
    else {
        misAlert("Please select atleast one user.", "Warning", "warning");
    }
}