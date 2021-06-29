var _year, _startDate, _endDate, _selectedWeek, _currentWeek, _isEditable, _weekId, _projectList, _status, _selectedDate, _projectId, _timeSheetId, _selectedTeamId, _selectedTaskId, _selectedTemplateId, _userId, _weekNo, _subDetail1, _subDetail2, _selectedLoggedTaskId;

var days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
var months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
var tableApprovedTimesheet = "";
var rows_selected = [];
Date.prototype.getMonthName = function () {
    return months[this.getMonth()];
};

Date.prototype.getDayName = function () {
    return days[this.getDay()];
};

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

    $('#dvTimeSheet').hide();
    _isEditable = true;
    fetchTimeSheetPendingforApproval();

    $("#tabPendingTimeSheets").click(function (e) {
        fetchTimeSheetPendingforApproval();
    });

    $("#tabApprovedTimeSheets").click(function (e) {
        $('#dvTimeSheet').hide();
        bindYearDropDown();

    });

    _selectedTeamId = 0;
    _selectedTaskId = 0;

    $('#ddlLogTaskTaskTemplates').change(function () {
        _selectedTemplateId = $(this).val();
        if (_selectedTemplateId != 0) {
            fetchSelectedTemplateInfo();
        }
    });

    $('#ddlLogTaskTeamName').change(function () {
        _selectedTeamId = $(this).val();
        if (_selectedTeamId === 0) {
            fetchTaskTypes(0);
            fetchTaskSubDetails1(0);
            fetchTaskSubDetails2(0);
        } else {
            fetchTaskTypes(_selectedTeamId);
            fetchTaskSubDetails1(0);
            fetchTaskSubDetails2(0);
        }
    });

    $('#ddlLogTaskTaskType').change(function () {
        _selectedTaskId = $(this).val();
        fetchTaskSubDetails1(_selectedTaskId);
        fetchTaskSubDetails2(_selectedTaskId);
    });

    $("#btnPendingTimeSheets").click(function (e) {
        $("#btnReviewTimeSheet").click();
        e.preventDefault();
    });

    $('#btnLogTask').click(function (e) {
        if (!validateControls('addTaskTemplateDiv')) {
            return false;
        }
        var taskDate = $('#txtLogTaskDate').html();
        var description = $('#txtLogTaskDescription').val().trim().replace(/"/g, '\\"');
        var taskTeamId = $('#ddlLogTaskTeamName').val();
        var taskTypeId = $('#ddlLogTaskTaskType').val();
        var taskSubDetail1Id = $('#ddlLogTaskTaskSubDetail1').val();
        var taskSubDetail2Id = $('#ddlLogTaskTaskSubDetail2').val();
        var timeSpent = $('#ddlLogTaskTime').val();
        var endDateValue = $('#ddlCopyTillDate').val();
        if (description == "") {
            misAlert("Please enter description", "Error", "Error");
        }
        else if (taskTeamId == 0) {
            misAlert("Please select team", "Error", "Error");
        }
        else if (taskTypeId == 0) {
            misAlert("Please select type", "Error", "Error");
        }
        else {
            var mode = $('#btnLogTask').val();
            if (mode === "Add") {
                var startDate = new Date(taskDate);
                var endDate = new Date(endDateValue);
                var timesheetCollection = new Array();
                while (startDate <= endDate) {
                    timeSheetItems = new Object();
                    timeSheetItems.taskDate = moment(startDate).format("MM/DD/YYYY");
                    timeSheetItems.description = description;
                    timeSheetItems.taskTeamId = taskTeamId;
                    timeSheetItems.taskTypeId = taskTypeId;
                    timeSheetItems.taskSubDetail1Id = taskSubDetail1Id;
                    timeSheetItems.taskSubDetail2Id = taskSubDetail2Id;
                    timeSheetItems.timeSpent = timeSpent;

                    var newDate = startDate.setDate(startDate.getDate() + 1);
                    startDate = new Date(newDate);
                    timesheetCollection.push(timeSheetItems);
                }
                logTask(timesheetCollection);
            } else {
                updateLoggedTask(description, taskTeamId, taskTypeId, taskSubDetail1Id, taskSubDetail2Id, timeSpent);
            }
        }
    });

    $('#btnLogTaskCancelEdit').click(function (e) {
        e.preventDefault();
        clearData();
    });

    $('#btnApproveTimeSheet').click(function (e) {
        misConfirm("Are you sure you want to approve the timesheet !", "Confirm", function (isConfirmed) {
            if (isConfirmed) {
                var remarks = $('#txtApproverRemarks').val();
                approveTimeSheet(remarks);
            }
        });

    });

    $('#btnRejectTimeSheet').click(function (e) {
        var remarks = $('#txtApproverRemarks').val().trim();
        if (remarks == "") {
            misAlert("Please enter your comments", "Warning", "warning");
        } else {
            misConfirm("Are you sure you want to reject the timesheet !", "Confirm", function (isConfirmed) {
                if (isConfirmed) {
                    rejectTimeSheet(remarks);
                }
            });
        }
    });

    $('#ddlReportingUsers').multiselect({
        includeSelectAllOption: true,
        enableFiltering: true,
        enableCaseInsensitiveFiltering: true,
        buttonWidth: false,
        onDropdownHidden: function (event) {
        }
    });
    $('#weekSelect').multiselect({
        includeSelectAllOption: true,
        enableFiltering: true,
        enableCaseInsensitiveFiltering: true,
        buttonWidth: false,
        onDropdownHidden: function (event) {
        }
    });

    $("#btnSearchCompletedTimesheet").click(function () {
        fetchTimeSheetsApprovedByUser();
    });

    //multiselect at users(Approved Timesheet)
    // Handle click on checkbox
    $('body').on('click', '#tblApprovedTimeSheetList tbody input[type="checkbox"]', function (e) {
        var $row = $(this).closest('tr');
        // Get row data
        var data = tableApprovedTimesheet.row($row).data();
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
        updateDataTableSelectAllCtrlUn(tableApprovedTimesheet);
        // Prevent click event from propagating to parent
        e.stopPropagation();
    });

    // Handle click on "Select all " control
    $('body').on('click', '#ckbApprovedTimeSheet', function (e) {
        if (this.checked) {
            $('input[type="checkbox"]', '#tblApprovedTimeSheetList').prop('checked', true);
            var count = $('#tblApprovedTimeSheetList tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        } else {
            $('input[type="checkbox"]', '#tblApprovedTimeSheetList').prop('checked', false);
            var count = $('#tblApprovedTimeSheetList tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        }
        // Prevent click event from propagating to parent
        e.stopPropagation();
    })

    // Handle click on "Select all " control
    $('#tblApprovedTimeSheetList tbody').on('click', 'input[Name="UnCheckbox"]', function (e) {
        if (this.checked) {
            $('input[type="checkbox"]', '#tblApprovedTimeSheetList').prop('checked', true);
            var count = $('#tblApprovedTimeSheetList tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        } else {
            $('input[type="checkbox"]', '#tblApprovedTimeSheetList').prop('checked', false);
            var count = $('#tblApprovedTimeSheetList tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        }
        // Prevent click event from propagating to parent
        e.stopPropagation();
    })

    // Handle click on tableApprovedTimesheet cells with checkboxes
    $('#tblApprovedTimeSheetList tbody').on('click', 'input[type="checkbox"]', function (e) {
        if (e.target.name != "UnCheckbox") {
            $(this).parent().find('input[type="checkbox"]').trigger('click');
            var count = $('#tblApprovedTimeSheetList tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        }
        else {
            var count = $('#tblApprovedTimeSheetList tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        }
    });

    // Handle table draw event
    if (tableApprovedTimesheet) {
        tableApprovedTimesheet.on('draw', function () {
            // Update state of "Select all" control
            updateDataTableSelectAllCtrlUn(tableApprovedTimesheet);
        });
    }
});




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

function bindYearDropDown() {
    $('#yearSelect').empty();
    var jsonObject = {
        'userAbrhs': misSession.userabrhs,
    };
    calltoAjax(misApiUrl.listYears, "POST", jsonObject,
        function (result) {
            $("#yearSelect").append("<option value='0'>Select</option>");
            $.each(result, function (idx, item) {
                $("#yearSelect").append("<option>" + item + "</option>");
            });
            $('#yearSelect').val(result[0]);
            bindWeekList(1);
        });
}

function bindWeekList(actionId) {
    var jsonObject = {
        'year': $('#yearSelect').val()
    };
    calltoAjax(misApiUrl.listWeeks, "POST", jsonObject,
        function (result) {
            $('#weekSelect').multiselect("destroy");
            $('#weekSelect').empty();
            $.each(result, function (index, value) {
                $('<option selected>').val(value).text(value).appendTo('#weekSelect');
            });

            $('#weekSelect').multiselect({
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                buttonWidth: false,
                onDropdownHidden: function (event) {
                }
            });
            bindReportingUsers(actionId);
        });
}

$('#yearSelect').change(function () {
    bindWeekList(0);
});

function bindReportingUsers(actionId) {
    calltoAjax(misApiUrl.getReportingEmployeesToUser, "POST", '',
        function (result) {
            $('#ddlReportingUsers').multiselect("destroy");
            $('#ddlReportingUsers').empty();
            $.each(result, function (index, value) {
                $('<option selected>').val(value.EmployeeAbrhs).text(value.EmployeeName).appendTo('#ddlReportingUsers');
            });
            $('#ddlReportingUsers').multiselect({
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                buttonWidth: false,
                onDropdownHidden: function (event) {
                }
            });
            if (actionId == 1) {
                fetchTimeSheetsApprovedByUser();
            }
        });
}

function enableDisableControls() {
    $('#txtTimeSheetRemarks').prop('disabled', true);
    if (_isEditable === false) {
        $('#btnApproveTimeSheet').hide();
        $('#btnRejectTimeSheet').show();
    } else {
        $('#btnApproveTimeSheet').show();
        $('#btnRejectTimeSheet').show();
    }
}

function fetchTimeSheetPendingforApproval() {
    $('#dvTimeSheet').hide();
    var jsonObject = {
        'menuAbrhs': misPermissions.menuAbrhs,
        'userAbrhs': misSession.userabrhs,
    };
    calltoAjax(misApiUrl.fetchTimeSheetPendingforApproval, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblPendingforApprovalList").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'Pending TimeSheet List',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'Pending TimeSheet List' },
                        { extend: 'pdf', filename: 'Pending TimeSheet List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                        { extend: 'print', filename: 'Pending TimeSheet List' },
                        ]
                    }
                ],
                "responsive": true,
                "autoWidth": false,
                "paging": true,
                "bDestroy": true,
                "ordering": true,
                "order": [],
                "info": true,
                "deferRender": true,
                "aaData": data,
                "aoColumns": [
                    {
                        "mData": null,
                        "sTitle": "Employee Name",
                        mRender: function (data, type, row) {
                            var html = data.FirstName + " " + data.LastName;
                            return html;
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Week",
                        mRender: function (data, type, row) {
                            var html = "Week # " + data.WeekNo + " (" + data.DisplayStartDate + " to " + data.DisplayEndDate + ") ";
                            return html;
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Total Time Logged",
                        mRender: function (data, type, row) {
                            var html = data.TotalHoursLogged + " Hrs.";
                            return html;
                        }
                    },
                    {
                        "mData": "UserRemarks",
                        "sTitle": "User Remarks",
                    },
                    {
                        "mData": "DisplaySubmissionTime",
                        "sTitle": "Submission Time",
                    },
                    {
                        "mData": null,
                        "sTitle": "View",
                        'bSortable': false,
                        "sClass": "text-left",
                        mRender: function (data, type, row) {
                            var html = '';
                            html += '<button type="button" class="btn btn-sm teal" data-toggle"model" data-target="#myModal"' + 'onclick="fetchSelectedTimeSheetInfo(' + row.TimeSheetId + ',' + row.WeekNo + ',' + new Date(row.EndDate).getFullYear() + ',' + row.CreatedBy + ',1)" data-toggle="tooltip" title="View"><i class="fa fa-eye"> </i></button>';
                            return html;
                        }
                    },
                ],
                "fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                    if (aData.WeekDiffrence === 0) {
                        $('td', nRow).css('background-color', '#b2f3a0');
                    }
                    else if (aData.WeekDiffrence === 1) {
                        $('td', nRow).css('background-color', '#f3f3a0');
                    }
                    else {
                        $('td', nRow).css('background-color', '#f3a0a0');
                    }
                }
            });
        });
}

function fetchTimeSheetsApprovedByUser() {
    if (!validateControls('filterDiv')) {
        return false;
    }

    var weekIds = (($('#weekSelect').val() != null && typeof $('#weekSelect').val() != 'undefined' && $('#weekSelect').val().length > 0) ? $('#weekSelect').val().join(',') : '0');
    var reportingUserids = (($('#ddlReportingUsers').val() != null && typeof $('#ddlReportingUsers').val() != 'undefined' && $('#ddlReportingUsers').val().length > 0) ? $('#ddlReportingUsers').val().join(',') : '0');
    $('#dvTimeSheet').hide();
    var jsonObject = {
        'years': $('#yearSelect').val(),
        'weekNos': weekIds,
        'reportingUserIds': reportingUserids,
        'menuAbrhs': misPermissions.menuAbrhs,
        'userAbrhs': misSession.userabrhs,
    };
    calltoAjax(misApiUrl.fetchTimeSheetsApproved, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblApprovedTimeSheetList").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'Approved TimeSheet List',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'Approved TimeSheet List' },
                        { extend: 'pdf', filename: 'Approved TimeSheet List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                        { extend: 'print', filename: 'Approved TimeSheet List' },
                        ]
                    }
                ],
                "responsive": true,
                "autoWidth": false,
                "paging": true,
                "bDestroy": true,
                "ordering": true,
                "order": [],
                "info": true,
                "deferRender": true,
                "aaData": data,
                "aoColumns": [
                    {
                        'targets': 0,
                        'searchable': false,
                        'width': '1%',
                        'orderable': false,
                        'bSortable': false,
                        "sTitle": '<input name="select_all" value="1" id="ckbApprovedTimeSheet" type="checkbox" />',
                        'className': 'dt-body-center',
                        'render': function (data, type, full, meta) {
                            if (full.Selected) {
                                return '<input type="checkbox" name="id[' + full.TimeSheetId + ']" value="' + full.TimeSheetId + '" checked="' + full.TimeSheetId + '">';
                            }
                            else {
                                return '<input type="checkbox" name="id[' + full.TimeSheetId + ']" value="' + full.TimeSheetId + '">';
                            }

                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Employee Name",
                        mRender: function (data, type, row) {
                            var html = data.FirstName + " " + data.LastName;
                            return html;
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Week",
                        mRender: function (data, type, row) {
                            var html = "Week # " + data.WeekNo + " (" + data.DisplayStartDate + " to " + data.DisplayEndDate + ") ";
                            return html;
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Total Time Logged",
                        mRender: function (data, type, row) {
                            var html = data.TotalHoursLogged + " Hrs.";
                            return html;
                        }
                    },
                    {
                        "mData": "UserRemarks",
                        "sTitle": "User Remarks",
                    },
                    {
                        "mData": "ApproverRemarks",
                        "sTitle": "My Remarks",
                    },
                    {
                        "mData": null,
                        "sTitle": "View",
                        'bSortable': false,
                        "sClass": "text-left",
                        mRender: function (data, type, row) {
                            var html = '';
                            html += '<button type="button" class="btn btn-sm teal" data-toggle"model" data-target="#myModal"' + 'onclick="fetchSelectedTimeSheetInfo(' + row.TimeSheetId + ',' + row.WeekNo + ',' + row.Year + ',' + row.CreatedBy + ',0)" data-toggle="tooltip" title="View"><i class="fa fa-eye"> </i></button>';
                            return html;
                        }
                    },
                ], 'rowCallback': function (row, data, dataIndex) {
                    var rowId = data.TimeSheetId;
                    // If row ID is in the list of selected row IDs
                    if ($.inArray(rowId, rows_selected) !== -1) {
                    }
                }
            });
            tableApprovedTimesheet = $('#tblApprovedTimeSheetList').DataTable();
        });
    

}

function fetchSelectedTimeSheetInfo(timeSheetId, weekNo, year, userId, isEditable) {
    if (isEditable == 1) {
        _isEditable = true;
    } else {
        _isEditable = false;
    }
    _userId = userId;
    _weekNo = weekNo;
    _selectedWeek = weekNo;
    _year = year;
    _timeSheetId = timeSheetId;
    fetchTimeSheetInfo(weekNo, userId, year);
    enableDisableControls();
}

function fetchTimeSheetInfo(weekNo, userId, year) {
    var jsonObject = {
        'userId': userId,
        'weekNo': weekNo,
        'year': _year,
        'userAbrhs': misSession.userabrhs,
    };
    calltoAjax(misApiUrl.fetchTimeSheetInfoOtherUser, "POST", jsonObject,
        function (result) {
            $('#lblLoggedTime').html(result.TimeLogged);
            $('#lblStatus').html(result.Status);
            $('#txtTimeSheetRemarks').val(result.UserRemarks);
            $('#txtApproverRemarks').val(result.ApproverRemarks);
            _status = result.Status;
            _startDate = new Date(result.DisplayStartDate);
            _endDate = new Date(result.DisplayEndDate);
            _timeSheetId = result.TimeSheetId;
            enableDisableControls();
            fetchProjectsForTimeSheet(result.TimeSheetId, weekNo, userId, _year);
        });
}

function fetchProjectsForTimeSheet(timeSheetId, weekNo, userId, year) {
    var jsonObject = {
        'weekNo': weekNo,
        'userId': userId,
        'year': _year,
        'userAbrhs': misSession.userabrhs,
    };
    calltoAjax(misApiUrl.fetchProjectsForTimeSheetOtherUser, "POST", jsonObject,
        function (result) {
            if (result != undefined) {
                _projectList = result;
                bindTimeSheetHeaders(result);
                bindTimeSheet(result, timeSheetId, weekNo, _year, userId, _isEditable)
                $('#dvTimeSheetInfo').show(); // change
            } else {
                $('#dvTimeSheetInfo').hide(); // change
            }
        });
}

$("#btnDownloadAllUsersTimeSheetReport").click(function () {
    getTimeSheetInfoForAllSelectedUsers();
});


function getTimeSheetInfoForAllSelectedUsers() {

    var selectedTimeSheetIds = [];

    $("#tblApprovedTimeSheetList").dataTable().$('input[type="checkbox"]').each(function () {
        if (this.checked) {
            selectedTimeSheetIds.push($(this).val());
        }
    });
    var _selectedTimeSheetIds = "";

    if (selectedTimeSheetIds.length == 0) {
        misAlert("Please select atleast one user to get the report","Warning","warning");
    }
    else {
        _selectedTimeSheetIds = selectedTimeSheetIds.join();
    }

    var jsonObject = {
        timeSheetIds: _selectedTimeSheetIds
    };

    calltoAjax(misApiUrl.getTimeSheetInfoForAllSelectedUsers, "POST", jsonObject,
        function (data) {
        });
}

function showPopupLogTask(el, mode) {
    var selectedDate = $(el).attr('date');
    _selectedDate = $(el).attr('date');
    var day = new Date($(el).attr('date')).getDayName();
    _projectId = $(el).attr('projectId');
    $('#myLogNewTaskModal').modal('show');
    $('#txtLogTaskTimeSheetId').val(_timeSheetId);
    $('#txtLogTaskProjectId').val(_projectId);
    $('#txtLogTaskDate').html(selectedDate);
    $('#txtLogTaskDay').html(day);
    $('#txtLogTaskProject').html($(el).attr('projectName'));
    $('#lblLogTaskTaskSubDetail1').html("Sub Detail 1 *");
    $('#lblLogTaskTaskSubDetail2').html("Sub Detail 2 *");
    $('#ddlLogTaskTaskTemplates').empty();
    $('#ddlLogTaskTeamName').empty();
    $('#ddlLogTaskTaskType').empty();
    $('#ddlLogTaskTaskSubDetail1').empty();
    $('#ddlLogTaskTaskSubDetail2').empty();
    $('#txtLogTaskDescription').val('');
    $('#ddlLogTaskTime').empty();
    for (var h = 0.5; h < 24.5; h += 0.5) {
        $('#ddlLogTaskTime').append("<option value = '" + h.toString() + "'>" + h.toString() + "</option>");
    }
    $('#ddlLogTaskTime').val("8");
    fetchTaskTemplatesForOtherUser();
    fetchTaskTeams();
    fetchTaskTypes(0);
    fetchTaskSubDetails1(0, 0);
    fetchTaskSubDetails2(0, 0);
    fetchTasksLoggedForProject();
    $('#divLogTaskSubDetail1Info').hide();
    $('#ddlLogTaskTaskSubDetail1').val(0);
    $('#divLogTaskSubDetail2Info').hide();
    $('#ddlLogTaskTaskSubDetail2').val(0);
    loadCopyTillDates();
    $('#btnLogTask').val('Add');
    $('#divCopyDate').show();
    $('#btnLogTaskCancelEdit').hide();
    $('#btnLogTask').val('Add');
    $('#divCopyDate').show();

    $('#spnLogTaskTemplate').html('Template Name *');
    $('#divLoggedTasksHeader').show();
    $('#divLoggedTasksGridView').show();
    $('#spnCopyTillDate').show();
    $('#ddlCopyTillDate').show();
    $('#spnLogTaskProject').show();
    $('#txtLogTaskProject').show();
}

function bindTimeSheetHeaders(result) {
    $("#tblTimeSheet").html("");
    var headerRow = "<tr id='trHeaderRow' style='font-weight:bold;text-align:center;height:50px'>" +
        "<td class='fixcolumn' style='width:120px;vertical-align:middle;background-color:#c3ec96;z-index:70' row='0' column='1' >Date</td>" +
        "<td class='fixcolumn' style='width:90px;vertical-align:middle;background-color:#f7d6da;color:#BA3C43;z-index:70' row='0' column='2'  >Day</td>";
    for (var i = 0; i < result.length; i++) {
        var columnNumber = parseInt(i + 4);
        headerRow += "<td style='width:220px;vertical-align:middle;background-color:#aed9ec;' row='0' column=" + columnNumber + " projectId=" + result[i].ProjectId + ">" + result[i].Name + "</td>";
    }
    $("#dvHeader").html(headerRow + "</tr>");
}

function bindTimeSheet(result, timeSheetId, weekNo, year, userId, isEditable) {
    var bodyRow = "";
    while (_startDate <= _endDate) {
        var m = 1;
        bodyRow += "<tr id='tr_" + m + "'>";
        for (var j = 1; j <= result.length + 3; j++) {
            var localDate = moment(_startDate).format('MM/DD/YYYY');
            var localDate1 = moment(localDate).format('MMDDYYYY');
            if (j == 1) {
                bodyRow += "<td class='fixcolumn' style='width:120px;text-align:center;background-color:#c3ec96;vertical-align:middle;font-weight:bold;'>" + localDate + "</td>";
            } else if (j == 2) {
                bodyRow += "<td class='fixcolumn' style='width:90px;text-align:center;background-color:#f7d6da;vertical-align:middle;font-weight:bold;color:#BA3C43'>" + _startDate.getDayName() + "</td>";
            } else if (j == 3) {
            } else {
                var k = parseInt(j - 4);
                var projectId = result[k].ProjectId;
                var projectName = $("#trHeaderRow td[projectId=" + projectId + "]").html();
                bodyRow += "<td id='td" + projectId + localDate1 + "' date=" + localDate + " row=" + m + " column=" + k + " projectName='" + projectName + "' projectId=" + projectId + " ";
                if (isEditable) {
                    bodyRow += "style='vertical-align:middle;cursor:pointer;height:60px;width:220px;word-wrap: break-word;' onclick='showPopupLogTask(this, 0)'" +
                        "title='Click to add tasks for " + projectName + " on " + _startDate.getDayName() + ", " + localDate + "'></td>";
                } else {
                    bodyRow += "style='vertical-align:middle;height:60px;width:220px;word-wrap: break-word;'></td>";
                }
            }
        }
        var newDate = _startDate.setDate(_startDate.getDate() + 1);
        _startDate = new Date(newDate);
        m = m + 1;
    }
    $("#tblTimeTable").html(bodyRow);
    var newDate1 = _startDate.setDate(_startDate.getDate() - 7);
    _startDate = new Date(newDate1);
    fetchTasksLoggedForTimeSheet(weekNo, userId);
}

function fetchTaskTemplatesForOtherUser() {
    var jsonObject = {
        'userId': _userId,
    };
    calltoAjax(misApiUrl.fetchTemplatesForOtherUser, "POST", jsonObject,
        function (result) {
            if (result != null && result.length > 0) {
                $('#ddlLogTaskTaskTemplates').append("<option value = 0>Select</option>");

                for (var x = 0; x < result.length; x++) {
                    $('#ddlLogTaskTaskTemplates').append("<option value = '" + result[x].TemplateId + "'>" + result[x].Name + "</option>");
                }
            } else {
                $('#ddlLogTaskTaskTemplates').append("<option value = 0>No templates created</option>");
            }
        });
}

function fetchSelectedTemplateInfo() {
    var jsonObject = {
        templateId: _selectedTemplateId,
        userAbrhs: misSession.userabrhs
    }
    calltoAjax(misApiUrl.fetchSelectedTemplateInfo, "POST", jsonObject,
        function (result) {
            if (result != null) {
                $('#txtLogTaskDescription').val(result.Description);
                $('#ddlLogTaskTeamName').val(result.TaskTeamId);
                fetchTaskTypes(result.TaskTeamId, result.TaskTypeId);
            }
        });
}

function fetchTaskTeams() {
    $('#ddlLogTaskTeamName').empty();
    calltoAjax(misApiUrl.fetchTaskTeams, "POST", null,
        function (result) {
            if (result != null && result.length > 0) {
                $('#ddlLogTaskTeamName').append("<option value = 0>Select</option>");
                for (var x = 0; x < result.length; x++) {
                    $('#ddlLogTaskTeamName').append("<option value = '" + result[x].Value + "'>" + result[x].Text + "</option>");
                }
            } else {
                $('#ddlLogTaskTeamName').append("<option value = 0>No teams found</option>");
            }

        });
}

function fetchTaskTypes(teamId, selectedId) {
    $('#ddlLogTaskTaskType').empty();
    if (teamId === 0) {
        $('#ddlLogTaskTaskType').append("<option value = 0>Select</option>");
    }
    else {
        var jsonObject = {
            'teamId': teamId,
        };
        calltoAjax(misApiUrl.fetchTaskTypes, "POST", jsonObject,
            function (result) {
                if (result != null && result.length > 0) {
                    $('#ddlLogTaskTaskType').append("<option value = 0>Select</option>");

                    for (var x = 0; x < result.length; x++) {
                        $('#ddlLogTaskTaskType').append("<option value = '" + result[x].Value + "'>" + result[x].Text + "</option>");
                    }
                    if (selectedId > 0) {
                        $('#ddlLogTaskTaskType').val(selectedId);
                    }
                } else {
                    $('#ddlLogTaskTaskType').append("<option value = 0>No tasks found</option>");
                }
            });
    }
}

function fetchSelectedTaskTypeInfo(taskTypeId) {
    if (taskTypeId === 0) {
        $('#lblLogTaskTaskSubDetail1').html("Sub Detail 1 *");
        $('#divLogTaskSubDetail1Info').hide();
        $('#lblLogTaskTaskSubDetail2').html("Sub Detail 2 *");
        $('#divLogTaskSubDetail2Info').hide();
    } else {
        var jsonObject = {
            'taskTypeId': taskTypeId
        }
        calltoAjax(misApiUrl.fetchSelectedTaskTypeInfo, "POST", jsonObject,
            function (result) {
                _subDetail1 = result.SubDetail1Name;
                _subDetail2 = result.SubDetail2Name;
                if (result.SubDetail1Name === "NA") {
                    $('#lblLogTaskTaskSubDetail1').html("Sub Detail 1 *");
                    $('#divLogTaskSubDetail1Info').hide();

                } else {
                    $('#lblLogTaskTaskSubDetail1').html(result.SubDetail1Name + " *");
                    $('#divLogTaskSubDetail1Info').show();
                    $('#ddlLogTaskTaskSubDetail1').val(0);
                }
                if (result.SubDetail2Name === "NA") {
                    $('#lblLogTaskTaskSubDetail2').html("Sub Detail 2 *");
                    $('#divLogTaskSubDetail2Info').hide();
                } else {
                    $('#lblLogTaskTaskSubDetail2').html(result.SubDetail2Name + " *");
                    $('#divLogTaskSubDetail2Info').show();
                    $('#ddlLogTaskTaskSubDetail2').val(0);
                }
            });
    }
}

function fetchTaskSubDetails1(taskId, selectedId) {
    $('#ddlLogTaskTaskSubDetail1').empty();
    if (taskId === 0) {
        $('#ddlLogTaskTaskSubDetail1').append("<option value='1'>-None-</option>");
    } else {
        var jsonObject = {
            'taskId': taskId,
        };
        calltoAjax(misApiUrl.fetchSubDetails1, "POST", jsonObject,
            function (result) {
                $('#ddlTaskSubDetail1').empty();
                if (result != null && result.length > 1) {
                    $('#divLogTaskSubDetail1Info').show();
                    for (var x = 0; x < result.length; x++) {
                        $('#ddlLogTaskTaskSubDetail1').append("<option value = '" + result[x].TaskSubDetail1Id + "'>" + result[x].TaskSubDetail1Name + "</option>");
                    }
                    $('#ddlLogTaskTaskSubDetail1').val(1);
                    if (selectedId > 0) {
                        $('#ddlLogTaskTaskSubDetail1').val(selectedId);
                    }
                }
                else {
                    $('#ddlLogTaskTaskSubDetail1').append("<option value='1'>-None-</option>");
                    $('#ddlLogTaskTaskSubDetail1').val(1);
                    $('#divLogTaskSubDetail1Info').hide();
                }
            });
    }
}

function fetchTaskSubDetails2(taskId, selectedId) {
    $('#ddlLogTaskTaskSubDetail2').empty();
    if (taskId === 0) {
        $('#ddlLogTaskTaskSubDetail2').append("<option value='1'>-None-</option>");
    } else {
        var jsonObject = {
            'taskId': taskId,
        };
        calltoAjax(misApiUrl.fetchSubDetails2, "POST", jsonObject,
            function (result) {
                $('#ddlTaskSubDetail2').empty();
                if (result != null && result.length > 1) {
                    $('#divLogTaskSubDetail2Info').show();
                    for (var x = 0; x < result.length; x++) {
                        $('#ddlLogTaskTaskSubDetail2').append("<option value = '" + result[x].TaskSubDetail2Id + "'>" + result[x].TaskSubDetail2Name + "</option>");
                    }
                    $('#ddlLogTaskTaskSubDetail2').val(1);
                    if (selectedId > 0) {
                        $('#ddlLogTaskTaskSubDetail2').val(selectedId);
                    }
                } else {
                    $('#ddlLogTaskTaskSubDetail2').append("<option value='1'>-None-</option>");
                    $('#ddlLogTaskTaskSubDetail2').val(1);
                    $('#divLogTaskSubDetail2Info').hide();
                }
            });
    }
}

//function fetchSelectedTemplateInfo(templateId) {
//    $("#hdnTemplateId").val(templateId);
//    var jsonObject = {
//        templateId: templateId,
//        userAbrhs: misSession.userabrhs
//    }
//    calltoAjax(misApiUrl.fetchSelectedTemplateInfo, "POST", jsonObject,
//       function (result) {
//           if (result != null) {
//               $('#txtLogTaskDescription').val(result.Description);
//               $('#ddlLogTaskTeamName').val(result.TaskTeamId);
//               fetchTaskTypes(result.TaskTeamId, result.TaskTypeId);
//               fetchTaskSubDetails1(result.TaskTypeId, result.TaskSubDetail1Id);
//               fetchTaskSubDetails2(result.TaskTypeId, result.TaskSubDetail2Id);
//           }
//       });
//}

function fetchTasksLoggedForTimeSheet(weekNo, userId) {
    var localDate = moment(_startDate).format('MM/DD/YYYY');
    var jsonObject = {
        'weekNo': weekNo,
        'startDate': localDate,
        'userId': userId,
        'userAbrhs': misSession.userabrhs
    };
    calltoAjax(misApiUrl.fetchTasksLoggedForTimeSheetOtherUser, "POST", jsonObject,
        function (result) {
            successFetchTasksLoggedForTimeSheet(result);
        });
}

function successFetchTasksLoggedForTimeSheet(msg) {
    if (msg != null && msg.length > 0) {
        for (var p1 = 0; p1 < msg.length; p1++) {
            var projectId = msg[p1].ProjectId;
            var date = moment(msg[p1].DisplayTaskDate).format('MMDDYYYY');
            var id = $('#td' + projectId + date);
            $(id).html("");
        }
        for (var p = 0; p < msg.length; p++) {
            projectId = msg[p].ProjectId;
            date = moment(msg[p].DisplayTaskDate).format('MMDDYYYY');
            var id = $('#td' + projectId + date);
            if ($(id).attr('projectId') == projectId) {
                var body = $(id).html();
                if (body !== "") {
                    body = body + "<br /><br />========================<br /><br />";
                }
                body = body + "Task Detail: " + msg[p].TeamName + " (" + msg[p].TaskType + ")";
                body = body + "<br /><br />Description: " + msg[p].Description;
                body = body + "<br /><br />Time Spent: " + msg[p].TimeSpent + " Hrs.";
                $(id).html(body);
            }
            $(id).css('background-color', '#92D050');
        }
    }
    $('#dvTimeSheet').show();
}

function fetchTasksLoggedForProject() {
    var jsonObject = {
        'date': _selectedDate,
        'projectId': _projectId,
        'timeSheetId': _timeSheetId
    };
    calltoAjax(misApiUrl.fetchTasksLoggedForProject, "POST", jsonObject,
        function (result) {
            successFetchTasksLoggedForProject(result);
        });
}

function successFetchTasksLoggedForProject(result) {
    var data = $.parseJSON(JSON.stringify(result));
    $("#tblLoggedTaskList").dataTable({
        "responsive": true,
        "autoWidth": false,
        "paging": false,
        "bDestroy": true,
        "ordering": false,
        "order": [],
        "info": false,
        "deferRender": false,
        "aaData": data,
        "aoColumns": [
            {
                "mData": "Description",
                "sTitle": "Description",
            },
            {
                "mData": "TeamName",
                "sTitle": "Team Name",
            },
            {
                "mData": "TaskType",
                "sTitle": "Task Type",
            },
            {
                "mData": "TaskSubDetail1",
                "sTitle": "Task Sub Detail 1",
            },
            {
                "mData": "TaskSubDetail2",
                "sTitle": "Task Sub Detail 2",
            },
            {
                "mData": "TimeSpent",
                "sTitle": "Time Spent",
            },
            {
                "mData": null,
                "sTitle": "Action",
                'bSortable': false,
                "sClass": "text-left",
                "sWidth": "100px",
                mRender: function (data, type, row) {

                    var html = '';
                    html += '<button type="button" class="btn btn-sm teal" data-toggle"model" data-target="#myModal"' + 'onclick="editLoggedTask(' + row.TaskId + ')" data-toggle="tooltip" title="Edit"><i class="fa fa-edit"> </i></button>';
                    html += '&nbsp;<button type="button" class="btn btn-sm btn-danger"' + 'onclick="deleteLoggedTask(' + row.TaskId + ')" data-toggle="tooltip" title="Delete"><i class="fa fa-trash-o"> </i> </button>';
                    return html;
                }
            },
        ]
    });
}

function logTask(timesheetCollection) {
    var localStartDate = moment(_startDate).format('MM/DD/YYYY');
    var localEndDate = moment(_endDate).format('MM/DD/YYYY');
    var jsonObject = {
        'weekNo': _selectedWeek,
        'startDate': localStartDate,
        'endDate': localEndDate,
        'projectId': _projectId,
        'TaskList': timesheetCollection,
        'UserId': _userId,
        'userAbrhs': misSession.userabrhs,
    };

    calltoAjax(misApiUrl.logTaskOtherUser, "POST", jsonObject,
        function (result) {
            if (result === 1) {
                fetchTimeSheetInfo(_weekNo, _userId, _year);
                fetchTasksLoggedForProject();
                fetchTasksLoggedForTimeSheet(_weekNo, _userId);
                fetchTimeSheetPendingforApproval();
                clearData();
                misAlert("Task has been added successfully.", 'Success', 'success');
            }
            if (result === 2) {
                misAlert("Task already logged.", 'Warning', 'warning');
            }
        });
}

function updateLoggedTask(description, taskTeamId, taskTypeId, taskSubDetail1Id, taskSubDetail2Id, timeSpent) {
    var jsonObject = {
        'timeSheetId': _timeSheetId,
        'taskId': _selectedLoggedTaskId,
        'description': description,
        'taskTeamId': taskTeamId,
        'taskTypeId': taskTypeId,
        'taskSubDetail1Id': taskSubDetail1Id,
        'taskSubDetail2Id': taskSubDetail2Id,
        'timeSpent': timeSpent
    };
    calltoAjax(misApiUrl.updateLoggedTask, "POST", jsonObject,
        function (result) {
            if (result === 1) {
                fetchTimeSheetInfo(_weekNo, _userId);
                fetchTasksLoggedForProject();
                fetchTasksLoggedForTimeSheet(_weekNo, _userId);
                fetchTimeSheetPendingforApproval();
                clearData();
                misAlert("Task has been updated successfully.", 'Success', 'success');
            }
            if (result === 2) {
                misAlert("Task already logged.", 'Warning', 'warning');
            }
        });
}

function editLoggedTask(taskId) {
    _selectedLoggedTaskId = taskId;
    $('#btnLogTask').val('Update');
    $('#divCopyDate').hide();
    fetchSelectedTaskInfo(taskId);
}

function deleteLoggedTask(taskId) {
    misConfirm("Are you sure you want to delete selected task !", "Confirm", function (isConfirmed) {
        if (isConfirmed) {
            var jsonObject = {
                'taskId': taskId
            };
            calltoAjax(misApiUrl.deleteLoggedTask, "POST", jsonObject,
                function (result) {
                    if (result == true) {
                        misAlert("Task has been deleted successfully.", 'Success', 'success');
                        fetchTasksLoggedForProject();
                        fetchTasksLoggedForTimeSheet(_weekNo, _userId);
                        fetchTimeSheetInfo(_weekNo, _userId);
                        fetchTimeSheetPendingforApproval();
                        clearData();
                    }
                    else {
                        misError();
                    }
                });
        }
    });
}

function approveTimeSheet(remarks) {
    var jsonObject = {
        'timeSheetId': _timeSheetId,
        'remarks': remarks,
        'userAbrhs': misSession.userabrhs
    };
    calltoAjax(misApiUrl.approveTimeSheet, "POST", jsonObject,
        function (result) {
            if (result != null) {
                misAlert("TimeSheet has been approved successfully.", 'Success', 'success');
                fetchTimeSheetPendingforApproval();
                //fetchTimeSheetsApprovedByUser();
            }
        });
}

function rejectTimeSheet(remarks) {
    var jsonObject = {
        'timeSheetId': _timeSheetId,
        'remarks': remarks,
        'userAbrhs': misSession.userabrhs
    };
    calltoAjax(misApiUrl.rejectTimeSheet, "POST", jsonObject,
        function (result) {
            if (result == true) {
                misAlert("TimeSheet has been rejected successfully.", 'Success', 'success');
                fetchTimeSheetPendingforApproval();
                //fetchTimeSheetsApprovedByUser();
            }
            else {
                misError();
            }

        });
}

function loadCopyTillDates() {
    $('#ddlCopyTillDate').empty();
    var taskDate = new Date(_selectedDate);
    var endDate = new Date(_endDate);
    while (taskDate <= endDate) {
        $('#ddlCopyTillDate').append("<option value = '" + moment(taskDate).format("MM/DD/YYYY") + "'>" + moment(taskDate).format("MM/DD/YYYY") + "</option>");
        var newDate = taskDate.setDate(taskDate.getDate() + 1);
        taskDate = new Date(newDate);
    }
    $('#ddlCopyTillDate').val(moment(_selectedDate).format("MM/DD/YYYY"));
}

function fetchSelectedTaskInfo(taskId) {
    var jsonObject = {
        'taskId': taskId
    };
    calltoAjax(misApiUrl.fetchSelectedTaskInfo, "POST", jsonObject,
        function (result) {
            if (result != undefined) {
                $('#txtLogTaskDescription').val(result.Description);
                $('#ddlLogTaskTeamName').val(result.TaskTeamId);
                fetchTaskTypes(result.TaskTeamId, result.TaskTypeId);
                fetchTaskSubDetails1(result.TaskTypeId, result.TaskSubDetail1Id);
                fetchTaskSubDetails2(result.TaskTypeId, result.TaskSubDetail2Id);
                $('#ddlLogTaskTime').val(result.TimeSpent);
            }
        });
}

function clearData() {
    $('#lblLogTaskTaskSubDetail1').html("Sub Detail 1 *");
    $('#lblLogTaskTaskSubDetail2').html("Sub Detail 2 *");;
    $('#txtLogTaskDescription').val('');
    fetchTaskTypes(0);
    fetchTaskSubDetails1(0, 1);
    fetchTaskSubDetails2(0, 1);
    $('#ddlLogTaskTaskTemplates').val(0);
    $('#ddlLogTaskTeamName').val(0);
    $('#divLogTaskSubDetail1Info').hide();
    $('#ddlLogTaskTaskSubDetail1').val(0);
    $('#divLogTaskSubDetail2Info').hide();
    $('#ddlLogTaskTaskSubDetail2').val(0);
    $('#btnLogTask').val('Add');
    $('#divCopyDate').show();
    $('#btnLogTaskCancelEdit').hide();
    $('#ddlLogTaskTime').val(8);
};

$("#btnLogTaskClose").click(function () {
    $("#myLogNewTaskModal").modal("hide");
});