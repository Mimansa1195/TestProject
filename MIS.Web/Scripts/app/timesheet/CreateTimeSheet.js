var _startDate, _endDate, _selectedWeek, _currentWeek, _dummyCurrentWeek, _isEditable = false, _weekId, _status,
    _selectedDate, _projectId, _timeSheetId, _selectedTeamId, _selectedTaskId, _selectedTemplateId, _subDetail1,
    _subDetail2, _selectedLoggedTaskId, _currentStartDate, _offset, _isIST, _timeZone, _changeWeek, _rejectInWeekNumber;
var _selectedYear, _currentYear, _lastWeekOfPreviousWeek, ajaxCallBasePath = window.location.pathname, _isTimesheetEnabled;

(function () {
    var days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    var months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

    Date.prototype.getMonthName = function () {
        return months[this.getMonth()];
    };
    Date.prototype.getDayName = function () {
        return days[this.getDay()];
    };
})();

$(document).ready(function () {
    _timeZone = new Date().toString().match(/\(.+\)/);
    _changeWeek = 0;
    noticeAlert();
    $('#dvTimeSheetInfo').hide();
    $('#tdApproverRemarks').hide();
   
    fetchCurrentWeek();
    _selectedTeamId = 0;
    _selectedTaskId = 0;
});

$('#ddlLogTaskTaskTemplates').change(function () {
    if ($(this).val() != 0) {
        fetchSelectedTemplateInfo($(this).val());
    }
    else {
        $('#lblLogTaskTaskSubDetail1').html("Sub Detail 1 *");
        $('#divLogTaskSubDetail1Info').hide();
        $('#lblLogTaskTaskSubDetail2').html("Sub Detail 2 *");
        $('#divLogTaskSubDetail2Info').hide();
    }
});

$('#btnPreviousWeek').click(function () {
    _changeWeek = _changeWeek - 1;
    _selectedWeek = _selectedWeek - 1;
    fetchPreviousWeek();
});

$('#btnNextWeek').click(function () {
    if (_selectedWeek === _currentWeek) {
        misAlert("You are already viewing latest week, unable to navigate next week", "Warning", "warning");
    } else {
        _changeWeek = _changeWeek + 1;
        _selectedWeek = _selectedWeek + 1;
        fetchNextWeek();
    }
});

function checkForValid() {

}

$('#btnLogTask').click(function (e) {
    enableDisableControls();

    if (!_isEditable) {
        misAlert("Unauthorized Access !", 'Warning', 'warning');
        return false;
    }

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

$(document).on('click', '#btnSubmitTimeSheet', function () {
    if (!_isEditable) {
        misAlert("Unauthorized Access !", 'Warning', 'warning');
        return false;
    }

    var reply = misConfirm("Are you sure you want to submit the timesheet?", "Confirm", function (reply) {
        if (reply) {
            var remarks = $('#txtRemarks').val();
            var localStartDate = moment(_startDate).format('MM/DD/YYYY');
            var jsonObject = {
                'Year': _selectedYear,
                'WeekNo': _selectedWeek,
                'UserRemarks': remarks,
                'StartDate': localStartDate,
                'EndDate': moment(_endDate).format('MM/DD/YYYY'),
                'userAbrhs': misSession.userabrhs
            };
            calltoAjax(misApiUrl.submitWeeklyTimeSheet, "POST", jsonObject,
                function (result) {
                    if (result == 1) {
                        misAlert("TimeSheet has been submitted successfully.", 'Success', 'success');
                        fetchTimeSheetInfo();
                    }
                    if (result == 2) {
                        misAlert("Don't be smart. Do some meaningful work !", 'Warning', 'warning');
                    }
                    if (result == 3) {
                        misAlert("Your TimeSheet is blank. Please fill, then save again !", 'Warning', 'warning');
                    }
                });
        }
    });

});

$('#btnLogTaskCancelEdit').click(function (e) {
    clearData();
});

$('#btnCopyFromWeek').click(function (e) {
    $("#yearCopyFrom").removeClass("error-validation");
    $("#weekCopyFrom").removeClass("error-validation");
    $("#yearCopyFrom").val(0);
    $("#weekCopyFrom").val(0);
    $("#mypopupCopyFromWeekModal").modal("show");
    bindYearDropDown();
});

$("#yearCopyFrom").change(function () {
    var jsonObject = {
        'year': $("#yearCopyFrom").val(),
        'week': _selectedWeek,
        'userAbrhs': misSession.userabrhs
    }
    calltoAjax(misApiUrl.listWeeksForCopyTimeSheet, "POST", jsonObject,
        function (result) {
            $("#weekCopyFrom").empty();
            $("#weekCopyFrom").append("<option value='0'>Select</option>");
            $.each(result, function (index, result) {
                $("#weekCopyFrom").append("<option>" + result + "</option>");
            });
        });
});

$('#btnCopy').click(function (e) {
    if (!validateControls('CopyTaskDiv')) {
        return false;
    }
    var reply = misConfirm("Are you sure you want to copy timesheet ?", "Confirm", function (reply) {
        if (reply) {
            var year = $('#yearCopyFrom').val();
            var WeekNo = $('#weekCopyFrom').val();
            var jsonObject = {
                'year': year,
                'fromWeek': WeekNo,
                'toWeek': _selectedWeek,
                'startDate': _startDate,
                'endDate': _endDate,
                'userAbrhs': misSession.userabrhs
            }
            calltoAjax(misApiUrl.copyTimeSheetFromWeek, "POST", jsonObject,
                function (result) {
                    misAlert("TimeSheet has been copied successfully.", 'Success', 'success');
                    fetchTimeSheetInfo();
                });
        }
    });

});

function ddlLogTaskTaskTypeChange(selectedTaskId, TaskSubDetails1Id, TaskSubDetails2Id) {
    fetchTaskSubDetails1(selectedTaskId, TaskSubDetails1Id);
    fetchTaskSubDetails2(selectedTaskId, TaskSubDetails2Id);
}

$("#ddlLogTaskTeamName").change(function myfunction() {
    ddlLogTaskTeamNameChange($("#ddlLogTaskTeamName").val(), 0, 0);
});

$("#ddlLogTaskTaskType").change(function myfunction() {
    ddlLogTaskTaskTypeChange($("#ddlLogTaskTaskType").val(), 0, 0);
});

function ddlLogTaskTeamNameChange(teamId, TaskSubDetails1Id, TaskSubDetails2Id) {

    if (teamId === 0) {
        fetchTaskTypes(0);
        fetchTaskSubDetails1(0, 0);
        fetchTaskSubDetails2(0, 0);
    } else {
        fetchTaskTypes(teamId);
        fetchTaskSubDetails1(teamId, TaskSubDetails1Id);
        fetchTaskSubDetails2(teamId, TaskSubDetails2Id);
    }
}

function noticeAlert() {
    var msg = '<div style="font-size: 14px;text-align: left;"><ul style="list-style-type: disc"><li>Standard time logging in case of holiday ( holiday/ML/CL ) - 8 hours.</li><li>Learning component is must - <i>10% of time should go in learning.</i></li><li>If meeting/session - MoM ( Minutes of Meeting ) is must.</li></ul></div>';
    swal({
        title: "Please note",
        text: msg,
        html: true
    });
}

function enableDisableControls() {
    if (_status === "Approved" || _status === "Submitted") {
        $("#btnCopyFromWeek").hide();
    }
    if (_isEditable === false) {
        $("#btnCopyFromWeek").hide();
        $('#txtRemarks').prop('disabled', true);
        $("#divBtnLogTimeSheet").html('');
    } else {
        $("#btnCopyFromWeek").show();
        $('#txtRemarks').prop('disabled', false);
        var html = '<input type="button" class="btn btn-success" value="Submit" id="btnSubmitTimeSheet">';
        $("#divBtnLogTimeSheet").html(html);
    }

    if (_status === "Approved" || _status === "Rejected") {
        $('#txtApproverRemarks').prop('disabled', true);
        $('#tdApproverRemarks').show();
    } else {
        $('#tdApproverRemarks').hide();
    }
}

function fetchCurrentWeek() {
    var jsonObject = {
        'userAbrhs': misSession.userabrhs,
        'changeWeek': _changeWeek,
    };
    calltoAjax(misApiUrl.fetchWeekInfo, "POST", jsonObject,
        function (result) {
            if (result != undefined) {
                $('#lblSelectedWeek').html("Week # " + result.WeekNo + " (" + result.DisplayStartDate + " - " + result.DisplayEndDate + ")");
                _currentWeek = result.WeekNo;
                _currentYear = result.Year;
                _selectedWeek = result.WeekNo;
                //_selectedYear = result.Year;
                _startDate = new Date(result.DisplayStartDate);
                _endDate = new Date(result.DisplayEndDate);
                _selectedYear = _endDate.getFullYear();
                _currentStartDate = new Date(result.DisplayStartDate);
                fetchTimeSheetInfo();
            }
        });
}

function fetchPreviousWeek() {
    var localDate = moment(_startDate).format('MM/DD/YYYY');
    var jsonObject = {
        'userAbrhs': misSession.userabrhs,
        'changeWeek': _changeWeek,
    };
    calltoAjax(misApiUrl.fetchWeekInfo, "POST", jsonObject,
        function (result) {
            successFetchWeek(result);
        });
}

function fetchNextWeek() {
    var localDate = moment(_startDate).format('MM/DD/YYYY');
    var jsonObject = {
        'userAbrhs': misSession.userabrhs,
        'changeWeek': _changeWeek,
    };
    calltoAjax(misApiUrl.fetchWeekInfo, "POST", jsonObject,
        function (result) {
            successFetchWeek(result);
        });
}

function successFetchWeek(msg) {
    var result = msg;
    if (result != undefined) {
        $('#lblSelectedWeek').html("Week # " + result.WeekNo + " (" + result.DisplayStartDate + " - " + result.DisplayEndDate + ")");
        _selectedWeek = result.WeekNo;
        _startDate = new Date(result.DisplayStartDate);
        //_selectedYear = result.Year;
        _endDate = new Date(result.DisplayEndDate);
        _selectedYear = _endDate.getFullYear();
        fetchTimeSheetInfo();
    }
}

function fetchTimeSheetInfo() {
    var localDate = moment(_startDate).format('MM/DD/YYYY');
    // var endDate = moment(_endDate).format('MM/DD/YYYY');
    var jsonObject = {
        'userAbrhs': misSession.userabrhs,
        'weekNo': _selectedWeek,
        'startDate': localDate
    };
    calltoAjax(misApiUrl.fetchTimeSheetInfo, "POST", jsonObject,
        function (result) {
            if (result != undefined) {
                $('#lblLoggedTime').html(result.TimeLogged);
                $('#lblStatus').html(result.Status);
                $('#txtRemarks').val(result.UserRemarks);
                $('#txtApproverRemarks').val(result.ApproverRemarks);
                _status = result.Status;
                _timeSheetId = result.TimeSheetId;
                _rejectInWeekNumber = result.RejectInWeekNumber;
                _isEditable = result.IsTimesheetEnabled ;
                enableDisableControls();
                fetchProjectsForTimeSheet();
            }
        });
}

function fetchTimeSheetInfoForFirstTime() {
    var localDate = moment(_startDate).format('MM/DD/YYYY');
    var jsonObject = {
        'userAbrhs': misSession.userabrhs,
        'weekNo': _selectedWeek,
        'startDate': localDate
    };
    calltoAjax(misApiUrl.fetchTimeSheetInfo, "POST", jsonObject,
        function (result) {
            if (result != undefined) {
                $('#lblLoggedTime').html(result.TimeLogged);
                $('#lblStatus').html(result.Status);
                $('#txtRemarks').val(result.UserRemarks);
                $('#txtApproverRemarks').val(result.ApproverRemarks);
                _status = result.Status;
                _timeSheetId = result.TimeSheetId;
                _rejectInWeekNumber = result.RejectInWeekNumber;
                enableDisableControls();
                fetchProjectsForTimeSheet();
                fetchTasksLoggedForProject();
                fetchTasksLoggedForTimeSheet();
            }
        });
}

function fetchProjectsForTimeSheet() {
    var localDate = moment(_startDate).format('MM/DD/YYYY');
    var jsonObject = {
        'userAbrhs': misSession.userabrhs,
        'weekNo': _selectedWeek,
        'startDate': localDate
    };
    calltoAjax(misApiUrl.fetchProjectsForTimeSheet, "POST", jsonObject,
        function (result) {
            if (result != undefined) {
                bindTimeSheetHeaders(result);
                bindTimeSheet(result);
                $('#dvTimeSheetInfo').show(); // change
            } else {
                misAlert("Unable to find any project to create a time sheet", "Error", "Error");
                $('#dvTimeSheetInfo').hide(); // change
            }
        });
}

function showPopupLogTask(el) {
    enableDisableControls();

    if (!_isEditable) {
        misAlert("Unauthorized Access !", 'Warning', 'warning');
        return false;
    }
    $('#btnLogTask').html('<i class="fa fa-save">&nbsp;Save</i>');
    var selectedDate = $(el).attr('date');
    _selectedDate = $(el).attr('date');
    var day = new Date($(el).attr('date')).getDayName();
    _projectId = $(el).attr('projectId');
    $('#myLogNewTaskModal').modal('show');
    // Remove Error Validation class
    $('#ddlLogTaskTeamName').removeClass("error-validation");
    $('#ddlLogTaskTaskType').removeClass("error-validation");
    $('#ddlLogTaskTaskSubDetail1').removeClass("error-validation");
    $('#ddlLogTaskTaskSubDetail2').removeClass("error-validation");
    $('#txtLogTaskDescription').removeClass("error-validation");

    // remove old date from Controls
    $('#ddlLogTaskTaskTemplates').empty();
    $('#ddlLogTaskTeamName').empty();
    $('#ddlLogTaskTaskType').empty();
    $('#ddlLogTaskTaskSubDetail1').empty();
    $('#ddlLogTaskTaskSubDetail2').empty();
    $('#txtLogTaskDescription').val('');


    $('#txtLogTaskTimeSheetId').val(_timeSheetId);
    $('#txtLogTaskProjectId').val(_projectId);
    $('#txtLogTaskDate').html(selectedDate);
    $('#txtLogTaskDay').html(day);
    $('#txtLogTaskProject').html($(el).attr('projectName'));

    $('#ddlLogTaskTime').empty();
    for (var h = 0.5; h < 24.5; h += 0.5) {
        $('#ddlLogTaskTime').append("<option value = '" + h.toString() + "'>" + h.toString() + "</option>");
    }
    $('#ddlLogTaskTime').val("8");
    fetchTaskTemplatesForCurrentUser();
    fetchTaskTeams();
    fetchTaskTypes(0);
    fetchTaskSubDetails1(0, 0);
    fetchTaskSubDetails2(0, 0);
    fetchTasksLoggedForProject();
    $('#divLogTaskSubDetail1Info').hide();
    $('#divLogTaskSubDetail2Info').hide();
    loadCopyTillDates();
    $('#btnLogTask').val('Add');
    $('#divCopyDate').show();
    $('#btnLogTaskCancelEdit').hide();
    $('#btnLogTask').val('Add');
    $('#divCopyDate').show();

    $('#spnLogTaskTemplate').html('Template Name *');
    $('#divLoggedTasksHeader').show();
    $('#divLoggedTasksGridView').show();
    $('#ddlCopyTillDate').show();
    $('#txtLogTaskProject').show();
}

function bindTimeSheetHeaders(projectList) {
    $("#tblTimeSheet").html("");
    var headerRow = "<tr id='trHeaderRow' style='font-weight:bold;text-align:center;height:50px'>" +
        "<td class='fixcolumn' style='width:100px !important;vertical-align:middle;background-color:#c3ec96;z-index:70' row='0' column='1' >Date</td>" +
        "<td class='fixcolumn' style='width:100px !important;vertical-align:middle;background-color:#f7d6da;color:#BA3C43;z-index:70' row='0' column='2'  >Day</td>";
    for (var i = 0; i < projectList.length; i++) {
        var columnNumber = parseInt(i + 4);
        headerRow += "<td style='width:220px;vertical-align:middle;background-color:#aed9ec;' row='0' column=" + columnNumber + " projectId=" + projectList[i].ProjectId + ">" + projectList[i].Name + "</td>";
    }
    $("#dvHeader").html(headerRow + "</tr>");
}

function bindTimeSheet(projectList) {
    if (projectList.length > 0) {
        var bodyRow = "";
        while (_startDate <= _endDate) {
            var m = 1;
            bodyRow += "<tr id='tr_" + m + "'>";
            for (var j = 1; j <= projectList.length + 3; j++) {
                var localDate = moment(_startDate).format('MM/DD/YYYY');
                var localDate1 = moment(localDate).format('MMDDYYYY');
                if (j == 1) {
                    bodyRow += "<td class='fixcolumn' style='width:120px;text-align:center;background-color:#c3ec96;vertical-align:middle;font-weight:bold;'>" + localDate + "</td>";
                } else if (j == 2) {
                    bodyRow += "<td class='fixcolumn' style='width:90px;text-align:center;background-color:#f7d6da;vertical-align:middle;font-weight:bold;color:#BA3C43'>" + _startDate.getDayName() + "</td>";
                } else if (j == 3) {

                }
                else {
                    var k = parseInt(j - 4);
                    var projectId = projectList[k].ProjectId;
                    var projectName = $("#trHeaderRow td[projectId=" + projectId + "]").html();
                    bodyRow += "<td id='td" + projectId + localDate1 + "' date=" + localDate + " row=" + m + " column=" + k + " projectName='" + projectName + "' projectId=" + projectId + " ";
                    if (_isEditable) {
                        bodyRow += "style='vertical-align:middle;cursor:pointer;height:50px !important;width:220px;word-wrap: break-word;' onclick='showPopupLogTask(this)'" +
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

        //$(".blockOverlay").css('display', 'none');
    } else {
        bodyRow += '<td colspan="2" style="text-align: center;font-size: 18px;font-weight: 600;color: #fd3737;">Please configure timesheet first to fill your timesheet.</td>';
        $("#divTimeSheetRemarks").hide();
    }
    $("#tblTimeTable").html(bodyRow);
    var newDate1 = _startDate.setDate(_startDate.getDate() - 7);
    _startDate = new Date(newDate1);
    fetchTasksLoggedForTimeSheet();
}

function fetchTaskTemplatesForCurrentUser() {
    var jsonObject = {
        userAbrhs: misSession.userabrhs
    }
    calltoAjax(misApiUrl.fetchTemplatesForUser, "POST", jsonObject,
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

function fetchTaskSubDetails1(taskId, selectedId) {
    $('#ddlLogTaskTaskSubDetail1').empty();
    if (taskId === 0) {
        $('#ddlLogTaskTaskSubDetail1').append("<option value='1'>None</option>");
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
                    $('#ddlLogTaskTaskSubDetail1').append("<option value='1'>None</option>");
                    $('#ddlLogTaskTaskSubDetail1').val(1);
                    $('#divLogTaskSubDetail1Info').hide();
                }
            });
    }
}

function fetchTaskSubDetails2(taskId, selectedId) {
    $('#ddlLogTaskTaskSubDetail2').empty();
    if (taskId === 0) {
        $('#ddlLogTaskTaskSubDetail2').append("<option value='1'>None</option>");
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
                    $('#ddlLogTaskTaskSubDetail2').append("<option value='1'>None</option>");
                    $('#ddlLogTaskTaskSubDetail2').val(1);
                    $('#divLogTaskSubDetail2Info').hide();
                }
            });
    }
}

function fetchSelectedTemplateInfo(templateId) {
    $("#hdnTemplateId").val(templateId);
    var jsonObject = {
        templateId: templateId,
        userAbrhs: misSession.userabrhs
    }
    calltoAjax(misApiUrl.fetchSelectedTemplateInfo, "POST", jsonObject,
        function (result) {
            if (result != null) {
                $('#txtLogTaskDescription').val(result.Description);
                $('#ddlLogTaskTeamName').val(result.TaskTeamId);
                fetchTaskTypes(result.TaskTeamId, result.TaskTypeId);
                fetchTaskSubDetails1(result.TaskTypeId, result.TaskSubDetail1Id);
                fetchTaskSubDetails2(result.TaskTypeId, result.TaskSubDetail2Id);
            }
        });
}

function fetchTasksLoggedForTimeSheet() {
    var localDate = moment(_startDate).format('MM/DD/YYYY');
    var jsonObject = {
        'weekNo': _selectedWeek,
        'startDate': localDate,
        'userAbrhs': misSession.userabrhs
    };
    calltoAjax(misApiUrl.fetchTasksLoggedForTimeSheet, "POST", jsonObject,
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
}

function fetchTasksLoggedForProject() {
    var jsonObject = {
        'date': _selectedDate,
        'projectId': _projectId,
        'timeSheetId': _timeSheetId
    };
    calltoAjax(misApiUrl.fetchTasksLoggedForProject, "POST", jsonObject,
        function (result) {
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
        });
}

function logTask(timesheetCollection) {
    var localStartDate = moment(_startDate).format('MM/DD/YYYY');
    var localEndDate = moment(_endDate).format('MM/DD/YYYY');
    var jsonObject = {
        'weekNo': _selectedWeek,
        'startDate': localStartDate,
        'projectId': _projectId,
        'TaskList': timesheetCollection,
        'endDate': localEndDate,
        'userAbrhs': misSession.userabrhs
    };
    calltoAjax(misApiUrl.logTask, "POST", jsonObject,
        function (result) {
            if (result === 1) {
                fetchTimeSheetInfoForFirstTime();
                clearData();
                misAlert("Task has been added successfully.", 'Success', 'success');
            }
            if (result === 2) {
                misAlert("Task already logged.", 'Warning', 'warning');
            }
            if (result === 3) {
                misAlert("You are too late to fill the timesheet for this week.", 'Warning', 'warning');
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
                fetchTimeSheetInfo();
                fetchTasksLoggedForProject();
                fetchTasksLoggedForTimeSheet();
                clearData();
                misAlert("Task has been updated successfully.", 'Success', 'success');
            }
            if (result === 2) {
                misAlert("Task already logged.", 'Warning', 'warning');
            }

        });
}

function editLoggedTask(taskId) {
    $('#btnLogTask').val('Update');
    $('#btnLogTask').html('<i class="fa fa-save">&nbsp;Update</i>');
    $('#divCopyDate').hide();
    $('#btnLogTaskCancelEdit').show();
    _selectedLoggedTaskId = taskId;
    fetchSelectedTaskInfo(taskId);
}

function deleteLoggedTask(taskId) {
    var reply = misConfirm("Are you sure you want to delete selected task ", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                'taskId': taskId
            };
            calltoAjax(misApiUrl.deleteLoggedTask, "POST", jsonObject,
                function (result) {
                    if (result != null) {
                        fetchTasksLoggedForProject();
                        fetchTasksLoggedForTimeSheet();
                        fetchTimeSheetInfo();
                        misAlert("Selected task has been deleted successfully", "Success", "success");
                        clearData();
                    }
                });
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

$("#btnCopyClose").click(function () {
    $("#mypopupCopyFromWeekModal").modal("hide");
});

$("#btnPopUpClose").click(function () {
    $("#mypopupAlertModal").modal("hide");
});

function bindYearDropDown() {
    $("#yearCopyFrom").empty();
    var year = [];
    var d = new Date();
    var n = d.getFullYear();
    year.push(n);
    //year.push(n - 1);
    $("#yearCopyFrom").append("<option value='0'>Select</option>");
    for (var i = 0; i < year.length; i++) {
        $("#yearCopyFrom").append("<option>" + year[i] + "</option>");
    }
}
