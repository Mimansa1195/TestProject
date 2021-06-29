$(document).ready(function () {
    fetchTaskTemplatesForCurrentUser();   
});

$('#btnAddNewTemplate').click(function () {
    fetchTaskTeams();
    fetchTaskTypes(0);
    $("#txtTemplateName").removeClass("error-validation");
    $("#txtTemplateDescription").removeClass("error-validation");
    $("#ddlTaskType").removeClass("error-validation");
    $("#ddlTeam").removeClass("error-validation");
    $("#ddlTaskSubDetail1").removeClass("error-validation");
    $("#ddlTaskSubDetail2").removeClass("error-validation");
    $("#txtTemplateName").val("");
    $("#txtTemplateDescription").val("");
    $('#divSubDetail1Info').hide();
    $('#divSubDetail2Info').hide();
    $("#myAddTaskTemplateModal").modal('show');  
});

$('#ddlTeam').change(function () {
    fetchTaskTypes($('#ddlTeam').val());
    $('#divSubDetail1Info').hide();
    $('#divSubDetail2Info').hide();
});

$('#ddlTaskType').change(function () {
   var selectedTaskId = $(this).val();
   if (selectedTaskId >0) {
       fetchTaskSubDetails1(selectedTaskId,0);
       fetchTaskSubDetails2(selectedTaskId,0);
   }
   else {
       $('#divSubDetail1Info').hide();
       $('#divSubDetail2Info').hide();
   }
});

$('#btnSaveTaskTemplate').click(function (e) {
    if (!validateControls('addTaskTemplateDiv')) {
        return false;
    }
    var templateName = $('#txtTemplateName').val().trim();
    var templateDescription = $('#txtTemplateDescription').val().trim().replace(/"/g, '\\"');
    var taskTeam = $('#ddlTeam').val();
    var taskType = $('#ddlTaskType').val();
    var taskSubDetail1 = $('#ddlTaskSubDetail1').val();
    var taskSubDetail2 = $('#ddlTaskSubDetail2').val();

    var jsonObject = {
        'name': templateName,
        'description': templateDescription,
        'taskTeamId': taskTeam,
        'taskTypeId': taskType,
        'taskSubDetail1Id': taskSubDetail1,
        'taskSubDetail2Id': taskSubDetail2,
        'userAbrhs': misSession.userabrhs
    };
    calltoAjax(misApiUrl.saveTaskTemplate, "POST", jsonObject,
        function (result) {
            if (result==1) {
                $("#myAddTaskTemplateModal").modal('hide');
                fetchTaskTemplatesForCurrentUser();
                misAlert("Template has been saved successfully.", 'Success', 'success');
            }
            if (result == 2) {
                misAlert("Duplicate template can't be save.", 'Warning', 'warning');
            }
           
           
        });
});

$('#btnUpdateTaskTemplate').click(function (e) {
    if (!validateControls('EditTaskTemplateDiv')) {
        return false;
    }
    var templateName = $('#txtTemplateNameEdit').val().trim();
    var templateDescription = $('#txtTemplateDescriptionEdit').val().trim().replace(/"/g, '\\"');
    var taskTeam = $('#ddlTeamEdit').val();
    var taskType = $('#ddlTaskTypeEdit').val();
    var taskSubDetail1 = $('#ddlTaskSubDetail1Edit').val();
    var taskSubDetail2 = $('#ddlTaskSubDetail2Edit').val();

    var jsonObject = {
        'templateId': $("#hdnTemplateId").val(),
        'name': templateName,
        'description': templateDescription,
        'taskTeamId': taskTeam,
        'taskTypeId': taskType,
        'taskSubDetail1Id': taskSubDetail1,
        'taskSubDetail2Id': taskSubDetail2,
        'userAbrhs': misSession.userabrhs
    };
    calltoAjax(misApiUrl.updateTaskTemplate, "POST", jsonObject,
        function (result) {
            if (result==1) {
            $("#myEditTaskTemplateModal").modal('hide');
            fetchTaskTemplatesForCurrentUser();
            misAlert("Template has been saved successfully.", 'Success', 'success');
            }
            if (result == 2) {
                misAlert("You are updating same template.", 'Warning', 'warning');
            }
        });
});

function fetchTaskTemplatesForCurrentUser() {
    var jsonObject = {
        userAbrhs: misSession.userabrhs
    }
    calltoAjax(misApiUrl.fetchTemplatesForUser, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblTaskTemplatesList").dataTable({
                "responsive": true,
                "autoWidth": false,
                "paging": false,
                "bDestroy": true,
                "ordering": false,
                "order": [],
                "info": false,
                "deferRender": true,
                "aaData": data,
                "aoColumns": [
                    {
                        "mData": "Name",
                        "sTitle": "Template Name",
                    },
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
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        "sClass": "text-left",
                        "sWidth": "100px",
                        mRender: function (data, type, row) {
                            var html = '';
                            html += '<button type="button" class="btn btn-sm teal" data-toggle"model" data-target="#myModal"' + 'onclick="editTaskTemplate(' + row.TemplateId + ')" data-toggle="tooltip" title="Edit"><i class="fa fa-edit"> </i></button>';
                            html += '&nbsp;<button type="button" class="btn btn-sm btn-danger"' + 'onclick="deleteTaskTemplate(' + row.TemplateId + ')" data-toggle="tooltip" title="Delete"><i class="fa fa-trash-o"> </i> </button>';
                            return html;
                        }
                    },
                ]
            });

        });

}

function fetchTaskTeams() {
    $('#ddlTeam').empty();
    calltoAjax(misApiUrl.fetchTaskTeams, "POST", null,
        function (result) {
            $('#ddlTeam').append($("<option value=0>Select</option>"));
            $.each(result, function (idx, item) {
                $('#ddlTeam').append($("<option></option>").val(item.Value).html(item.Text));
            });
        });
}

function fetchTaskTypes(teamId) {
    var jsonObject = {
        'teamId': teamId,
    };
    calltoAjax(misApiUrl.fetchTaskTypes, "POST", jsonObject,
        function (result) {
            if (result.length >0) {
                $('#ddlTaskType').empty();
                $('#ddlTaskType').append($("<option></option>").val(0).html("Select"));
                $.each(result, function (idx, item) {
                    $('#ddlTaskType').append($("<option></option>").val(item.Value).html(item.Text));
                });
            }
        });
}

function fetchTaskSubDetails1(taskId, selectedId) {
    $('#ddlTaskSubDetail1').empty();
    if (taskId === 0) {
        $('#ddlTaskSubDetail1').append("<option value='1'>-None-</option>");
    } else {
        var jsonObject = {
            'taskId': taskId,
        };
        calltoAjax(misApiUrl.fetchSubDetails1, "POST", jsonObject,
            function (result) {
                $('#ddlTaskSubDetail1').empty();
                if (result != null && result.length > 1) {
                    $('#divSubDetail1Info').show();
                    for (var x = 0; x < result.length; x++) {
                        $('#ddlTaskSubDetail1').append("<option value = '" + result[x].TaskSubDetail1Id + "'>" + result[x].TaskSubDetail1Name + "</option>");
                    }
                    $('#ddlTaskSubDetail1').val(1);
                    if (selectedId > 0) {
                        $('#ddlTaskSubDetail1').val(selectedId);
                    }
                }
                else {
                    $('#ddlTaskSubDetail1').append("<option value='1'>-None-</option>");
                    $('#ddlTaskSubDetail1').val(1);
                    $('#divSubDetail1Info').hide();
                }
            });
    }
}

function fetchTaskSubDetails2(taskId, selectedId) {
    $('#ddlTaskSubDetail2').empty();
    if (taskId === 0) {
        $('#ddlTaskSubDetail2').append("<option value='1'>-None-</option>");
    } else {
        var jsonObject = {
            'taskId': taskId,
        };
        calltoAjax(misApiUrl.fetchSubDetails2, "POST", jsonObject,
            function (result) {
                $('#ddlTaskSubDetail2').empty();
                if (result != null && result.length > 1) {
                    $('#divSubDetail2Info').show();
                    for (var x = 0; x < result.length; x++) {
                        $('#ddlTaskSubDetail2').append("<option value = '" + result[x].TaskSubDetail2Id + "'>" + result[x].TaskSubDetail2Name + "</option>");
                    }
                    $('#ddlTaskSubDetail2').val(1);
                    if (selectedId > 0) {
                        $('#ddlTaskSubDetail2').val(selectedId);
                    }
                }
                else {
                    $('#ddlTaskSubDetail2').append("<option value='1'>-None-</option>");
                    $('#ddlTaskSubDetail2').val(1);
                    $('#divSubDetail2Info').hide();
                }
            });
    }
}

function editTaskTemplate(templateId) {
    $("#hdnTemplateId").val(templateId);
    var jsonObject = {
        templateId: templateId,
        userAbrhs: misSession.userabrhs
    }
    calltoAjax(misApiUrl.fetchSelectedTemplateInfo, "POST", jsonObject,
       function (result) {
           if (result != null) {
               
               $("#myEditTaskTemplateModal").modal('show');
               $('#txtTemplateNameEdit').val(result.Name);
               $('#txtTemplateDescriptionEdit').val(result.Description);
               fetchTaskTeamsEdit(result.TaskTeamId);
               fetchTaskTypesEdit(result.TaskTeamId, result.TaskTypeId);
               bindSubTasks(result.TaskTypeId, result.TaskSubDetail1Id, result.TaskSubDetail2Id);
           }
       });
}

function bindSubTasks(selectedTaskId, TaskSubDetail1Id, TaskSubDetail2Id) {
    fetchTaskSubDetails1Edit(selectedTaskId, TaskSubDetail1Id);
    fetchTaskSubDetails2Edit(selectedTaskId, TaskSubDetail2Id);
}

function fetchTaskSubDetails1Edit(taskId, TaskSubDetail1Id) {
    $('#ddlTaskSubDetail1Edit').empty();
    if (taskId === 0) {
        $('#ddlTaskSubDetail1Edit').append("<option value='1'>-None-</option>");
    } else {
        var jsonObject = {
            'taskId': taskId,
        };
        calltoAjax(misApiUrl.fetchSubDetails1, "POST", jsonObject,
            function (result) {
                $('#ddlTaskSubDetail1Edit').empty();
                if (result != null && result.length > 1) {
                    $('#divSubDetail1InfoEdit').show();
                    for (var x = 0; x < result.length; x++) {
                        $('#ddlTaskSubDetail1Edit').append("<option value = '" + result[x].TaskSubDetail1Id + "'>" + result[x].TaskSubDetail1Name + "</option>");
                    }
                    $('#ddlTaskSubDetail1Edit').val(1);
                    if (TaskSubDetail1Id > 0) {
                        $('#ddlTaskSubDetail1Edit').val(TaskSubDetail1Id);
                    }
                } else {
                    $('#ddlTaskSubDetail1Edit').append("<option value='1'>-None-</option>");
                    $('#ddlTaskSubDetail1Edit').val(1);
                    $('#divSubDetail1InfoEdit').hide();
                }
            });
    }
}

function fetchTaskSubDetails2Edit(taskId, TaskSubDetail2Id) {
    $('#ddlTaskSubDetail2Edit').empty();
    if (taskId === 0) {
        $('#ddlTaskSubDetail2Edit').append("<option value='1'>-None-</option>");
    } else {
        var jsonObject = {
            'taskId': taskId,
        };
        calltoAjax(misApiUrl.fetchSubDetails2, "POST", jsonObject,
            function (result) {
                $('#ddlTaskSubDetail2Edit').empty();
                if (result != null && result.length > 1) {
                    $('#divSubDetail2InfoEdit').show();
                    for (var x = 0; x < result.length; x++) {
                        $('#ddlTaskSubDetail2Edit').append("<option value = '" + result[x].TaskSubDetail2Id + "'>" + result[x].TaskSubDetail2Name + "</option>");
                    }
                    $('#ddlTaskSubDetail2Edit').val(1);
                    if (TaskSubDetail2Id > 0) {
                        $('#ddlTaskSubDetail2Edit').val(TaskSubDetail2Id);
                    }
                } else {
                    $('#ddlTaskSubDetail2Edit').append("<option value='1'>-None-</option>");
                    $('#ddlTaskSubDetail2Edit').val(1);
                    $('#divSubDetail2InfoEdit').hide();
                }
            });
    }
}

$('#ddlTaskTypeEdit').change(function () {
    var selectedTaskId = $(this).val();
    if (selectedTaskId > 0 ) {
        fetchTaskSubDetails1Edit(selectedTaskId, 0);
        fetchTaskSubDetails2Edit(selectedTaskId, 0);
    }
    else {
        $('#divSubDetail1InfoEdit').hide();
        $('#divSubDetail2InfoEdit').hide();
    }
});

function fetchTaskTypesEdit(teamId,SelectedId) {
    $('#ddlTaskTypeEdit').empty();
    var jsonObject = {
        'teamId': teamId,
    };
    calltoAjax(misApiUrl.fetchTaskTypes, "POST", jsonObject,
        function (result) {
            $('#ddlTaskTypeEdit').append($("<option></option>").val(0).html("Select"));
            $.each(result, function (idx, item) {
                $('#ddlTaskTypeEdit').append($("<option></option>").val(item.Value).html(item.Text));
            });
            if (SelectedId > 0) {
                $('#ddlTaskTypeEdit').val(SelectedId);
            }
        });
}

function fetchTaskTeamsEdit(SelectedId) {
    $('#ddlTeamEdit').empty();
    calltoAjax(misApiUrl.fetchTaskTeams, "POST", null,
        function (result) {
            $.each(result, function (idx, item) {
                $('#ddlTeamEdit').append($("<option></option>").val(item.Value).html(item.Text));
            });
            if (SelectedId>0) {
                $('#ddlTeamEdit').val(SelectedId);
            }
        });
}

function deleteTaskTemplate(templateId) {
    misConfirm("Are you sure you want to delete this?", "Are you sure?", function (isConfirm) {
        if (isConfirm === true) {
            var jsonObject = {
                templateId: templateId,
                userAbrhs: misSession.userabrhs
            }
            calltoAjax(misApiUrl.deleteTaskTemplate, "POST", jsonObject,
               function (result) {
                   if (result == 1) {
                       misAlert("Template has been deleted successfully.", 'Success', 'success');
                       fetchTaskTemplatesForCurrentUser();
                   }
                   else {
                       misAlert();
                   }
               });
        }
    });
}

$("#ddlTeamEdit").change(function () {
    fetchTaskTypesEdit($("#ddlTeamEdit").val(), 0);
    $('#divSubDetail1InfoEdit').hide();
    $('#divSubDetail2InfoEdit').hide();
});

$("#btnAddClose").click(function () {
    $("#myAddTaskTemplateModal").modal('hide');
});

$("#btnEditClose").click(function () {
    $("#myEditTaskTemplateModal").modal('hide');
});
