var _result;
var _selectedYear;
var ajaxCallBasePath = window.location.pathname;
var _selectedMappingId;
var _selectedTaskId;
var _selectedTaskId1;

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

    bindYearDropDown();
    weekselectchange();

    $('#ddlLogTaskProject').change(function () {
        _selectedTemplateId = $(this).val();
        if (_selectedTemplateId != 0) {
            fetchSelectedTemplateInfo();
        }
    });

    $('#ddlLogTaskTeamName').change(function () {
        _selectedTeamId = $(this).val();
        if (_selectedTeamId === 0) {
            fetchTaskTypes(0);
            fetchTaskSubDetails1(0, 0);
            fetchTaskSubDetails2(0, 0);
        } else {
            fetchTaskTypes(_selectedTeamId);
            fetchTaskSubDetails1(0, 0);
            fetchTaskSubDetails2(0, 0);
        }
    });

    $('#ddlLogTaskTaskType').change(function () {
        _selectedTaskId = $(this).val();
        fetchSelectedTaskTypeInfo($(this).val());
        fetchTaskSubDetails1($(this).val(), 0);
        fetchTaskSubDetails2($(this).val(), 0);
    });

});

function bindYearDropDown() {
    $('#yearSelect').empty();
    var jsonObject = {
        'userAbrhs': misSession.userabrhs,
    };
    calltoAjax(misApiUrl.listYears, "POST", jsonObject,
        function (result) {
            $("#yearSelect").append("<option selected disabled>Select</option>");
            $.each(result, function (idx, item) {
                $("#yearSelect").append("<option>" + item + "</option>");
            });
        });
}

$('#yearSelect').change(function () {
    $('#weekSelect').empty();
    var jsonObject = {
        'year': $('#yearSelect').val()
    };
    calltoAjax(misApiUrl.listWeeks, "POST", jsonObject,
        function (result) {
            $("#weekSelect").append("<option selected disabled>Select</option>");
            $.each(result, function (idx, item) {
                $("#weekSelect").append("<option>" + item + "</option>");
            });
        });
});

function weekselectchange() {
    var jsonObject = {
        'year': $('#yearSelect').val() || 0,
        'weekNo': $('#weekSelect').val() || 0,
        'userAbrhs': misSession.userabrhs,
        'menuAbrhs': misPermissions.menuAbrhs
    };
    calltoAjax(misApiUrl.listApprovedTasks, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblDataVerificationList").dataTable({
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
                        "mData": "UIDate",
                        "sTitle": "Date",
                        "sWidth": "100px"
                    },
                    {
                        "mData": "Resource",
                        "sTitle": "Resource Name",
                    },
                    {
                        "mData": "ResourceTeamName",
                        "sTitle": "Team Name",
                    },
                      {
                          "mData": "ProjectName",
                          "sTitle": "Project Name",
                      },
                      {
                          "mData": "Description",
                          "sTitle": "Description",
                      },
                      {
                          "mData": "TaskTeamName",
                          "sTitle": "Task Team",
                          "className": "none"
                      },
                       {
                           "mData": "TaskTypeName",
                           "sTitle": "Task Type",
                           "className": "none"
                       },
                      {
                          "mData": "TaskSubDetail1Name",
                          "sTitle": "SubDetail 1",
                          "className": "none"
                      },
                      {
                          "mData": "TaskSubDetail2Name",
                          "sTitle": "SubDetail 2",
                          "className": "none"
                      },
                      {
                          "mData": "TimeSpent",
                          "sTitle": "Time",
                      },
                       {
                           "mData": null,
                           "sTitle": "Action",
                           'bSortable': false,
                           "sClass": "text-left",
                           "sWidth": "70px",
                           mRender: function (data, type, row) {
                               var html = '';
                               html += '<button type="button" class="btn btn-sm teal" data-toggle"model" data-target="#myModal"' + 'onclick="showPopupLogTask(' + row.MappingId + ')" data-toggle="tooltip" title="Edit"><i class="fa fa-edit"> </i></button>';
                               return html;
                           }
                       },
                       {
                           'targets': 0,
                           "sTitle": "Consider In Client Report",
                           'searchable': false,
                           'width': '1%',
                           'orderable': false,
                           'bSortable': false,
                           'className': 'none dt-body-center',
                           'render': function (data, type, full, meta) {
                               if (full.ConsiderInClientReports) {
                                   return '<input type="checkbox" name="id[' + full.MappingId + ']" value="' + full.MappingId + '" onclick="onClickCheckbox(' + full.MappingId + ')" checked>';
                               }
                               else {
                                   return '<input type="checkbox" name="id[' + full.MappingId + ']" value="' + full.MappingId + '" onclick="onClickCheckbox(' + full.MappingId + ')">';
                               }

                           }
                       },
                ]
            });
        });
}

function onClickCheckbox(mappingId) {
    var data = new Object();
    data.mappingId = mappingId;
    var jsonData = JSON.stringify(data);

    var jsonObject = {
        'mappingId': mappingId,
    };
    calltoAjax(misApiUrl.changeTaskStatus, "POST", jsonObject,
        function (result) {
            misAlert("Status has been changed successfully.", 'Success', 'success');
        });
}

function showPopupLogTask(mappingId) {
    $('#myLogNewTaskModal').modal('show');
    $('#txtLogTaskTimeSheetId').val(0);
    $('#txtLogTaskProject').val(0);
    $('#lblLogTaskTaskSubDetail1').html("Sub Detail 1 *");
    $('#lblLogTaskTaskSubDetail2').html("Sub Detail 2 *");
    $('#ddlLogTaskProject').empty();
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
    fetchTaskTeams();
    _selectedMappingId = mappingId;
    fetchApprovedTaskInfo(mappingId);
}

function fetchProjectsForTimeSheet(projectId) {

    calltoAjax(misApiUrl.listAllProjects, "POST", '',
        function (result) {
            if (result != undefined) {
                $('#ddlLogTaskProject').empty();
                for (var x = 0; x < result.length; x++) {
                    $('#ddlLogTaskProject').append("<option value = '" + result[x].ProjectId + "'>" + result[x].Name + "</option>");
                }
                if (projectId > 0) {
                    $('#ddlLogTaskProject').val(projectId);
                }
            }
        });
}

function fetchTaskTeams() {
    $('#ddlTeam').empty();
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

function fetchSelectedTaskTypeInfo(taskId) {
    if (taskId === 0) {
        $('#lblLogTaskTaskSubDetail1').html("Sub Detail 1 *");
        $('#divLogTaskSubDetail1Info').hide();
        $('#lblLogTaskTaskSubDetail2').html("Sub Detail 2 *");
        $('#divLogTaskSubDetail2Info').hide();
    } else {
        var jsonObject = {
            'taskTypeId': taskId
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

function fetchApprovedTaskInfo(mappingId) {
    var jsonObject = {
        'mappingId': mappingId,
    };
    calltoAjax(misApiUrl.fetchApprovedTaskInfo, "POST", jsonObject,
        function (result) {
            if (result != undefined) {
                $('#txtLogTaskDescription').val(result.Description);
                $('#ddlLogTaskTeamName').val(result.TaskTeamId);
                fetchProjectsForTimeSheet(result.ProjectId);
                fetchTaskTypes(result.TaskTeamId, result.TaskTypeId);
                fetchTaskSubDetails1(result.TaskTypeId, result.TaskSubDetail1Id);
                fetchTaskSubDetails2(result.TaskTypeId, result.TaskSubDetail2Id);
                $('#txtLogTaskProject').html(result.ProjectName);
                var jsonDate = result.Date;
                var date = new Date(result.UIDate);
                $('#txtLogTaskDate').html(result.UIDate);
                var day = date.getDayName();
                $('#txtLogTaskDay').html(day);
            }
        });
}

$('#btnLogTask').click(function (e) {
    if (!validateControls('addTaskTemplateDiv')) {
        return false;
    }
    var taskId = _selectedTaskId1 || 0;
    var mappingId = _selectedMappingId;
    var projectId = $('#ddlLogTaskProject').val();
    var description = $('#txtLogTaskDescription').val();
    var taskTeamId = $('#ddlLogTaskTeamName').val();
    var taskTypeId = $('#ddlLogTaskTaskType').val();
    var taskSubDetail1Id = $('#ddlLogTaskTaskSubDetail1').val();
    var taskSubDetail2Id = $('#ddlLogTaskTaskSubDetail2').val();
    var timeSpent = $('#ddlLogTaskTime').val();
    var jsonObject = {
        'Date': $('#txtLogTaskDate').html(),
        'TaskId': taskId,
        'MappingId': mappingId,
        'ProjectId': projectId,
        'Description': description,
        'TaskTeamId': taskTeamId,
        'TaskTypeId': taskTypeId,
        'TaskSubDetail1Id': taskSubDetail1Id,
        'TaskSubDetail2Id': taskSubDetail2Id,
        'TimeSpent': timeSpent,
        'userAbrhs': misSession.userabrhs,
    };
    calltoAjax(misApiUrl.overwriteLoggedTask, "POST", jsonObject,
        function (result) {
            weekselectchange();
            misAlert("Data has been updated successfully.", 'Success', 'success');
        });
});

var days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
var months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

Date.prototype.getMonthName = function () {
    return months[this.getMonth()];
};
Date.prototype.getDayName = function () {
    return days[this.getDay()];
};

$("#btnLogTaskClose").click(function () {
    $("#myLogNewTaskModal").modal("hide");
});