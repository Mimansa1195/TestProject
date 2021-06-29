$(document).ready(function () {
    getAllTaskTeams();
});

function getAllTaskTeams() {
    calltoAjax(misApiUrl.listAllTaskTeam, "POST", '',
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#tblAllTaskTeam").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                 {
                     filename: 'All Team Task List',
                     extend: 'collection',
                     text: 'Export',
                     buttons: [{ extend: 'copy' },
                                { extend: 'excel', filename: 'All Team Task List' },
                                { extend: 'pdf', filename: 'All Team Task List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                                { extend: 'print', filename: 'All Team Task List' },
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
                "aaData": resultData,
                "aoColumns": [
                    {
                        "mData": "EntityName",
                        "sTitle": "Team Name",
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        "sClass": "text-center",
                        mRender: function (data, type, row) {
                            var html = '<div>';
                            html += '<button type="button" data-toggle="tooltip" class="btn btn-sm btn-success"' + 'onclick="editTaskTeam(' + row.Id + ')" title="Edit"><i class="fa fa-edit" aria-hidden="true"></i></button>';
                            html += '&nbsp;<button type="button" data-toggle="tooltip" class="btn btn-sm btn-danger"' + 'onclick="deleteTaskTeam(' + row.Id + ')" title="Delete"><i class="fa fa-trash" aria-hidden="true"></i></button></div>'
                            return html;
                        }
                    },
                ]
            });
        });
}

function deleteTaskTeam(taskTeamId) {
    var reply = misConfirm("Are you sure you want to delete task team", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                taskTeamId: taskTeamId,
                userAbrhs: misSession.userabrhs,
            }
            calltoAjax(misApiUrl.deleteTaskTeam, "POST", jsonObject,
                function (result) {
                    var resultData = $.parseJSON(JSON.stringify(result));
                    if (resultData) {
                        misAlert("Request processed successfully", "Success", "success");
                        getAllTaskTeams();
                    }
                    else
                        misAlert("Unable to process request. Try again", "Error", "error");
                });
        }
    });
}

function editTaskTeam(taskTeamId) {
    $("#modal-addTaskTeam").modal('show');
    $("#addTaskTeamBtn").hide();
    $("#editTaskTeamBtn").show();
    $("#hdnTaskTeamId").val(taskTeamId);
    var jsonObject = {
        taskTeamId: taskTeamId,
    }
    calltoAjax(misApiUrl.fetchTaskTeamByTeamId, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#taskTeamName").val(resultData);
        });
}

function finalEditTaskTeam() {
    if (!validateControls('modal-addTaskTeam')) {
        return false;
    }
    var jsonObject = {
        taskTeamId: $("#hdnTaskTeamId").val(),
        taskTeamName: $("#taskTeamName").val(),
        userAbrhs: misSession.userabrhs,
    }
    calltoAjax(misApiUrl.updateTaskTeamDetails, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            if (resultData == 1) {
                $("#modal-addTaskTeam").modal('hide');
                misAlert("Request processed successfully", "Success", "success");
                getAllTaskTeams();
            }
            else if (resultData == 3)
                misAlert("Task team name with same name already exists", "Warning", "warning");
            else
                misAlert("Unable to process request. Try again", "Error", "error");
        });
}

function addNewTaskTeam() {
    $("#modal-addTaskTeam").modal('show');
    $("#addTaskTeamBtn").show();
    $("#editTaskTeamBtn").hide();
    $("#taskTeamName").val("");
}

function finalAddTaskTeam() {
    if (!validateControls('modal-addTaskTeam')) {
        return false;
    }
    var jsonObject = {
        taskTeamName: $("#taskTeamName").val(),
        userAbrhs: misSession.userabrhs,
    }
    calltoAjax(misApiUrl.addNewTaskTeam, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            if (resultData == 1) {
                $("#modal-addTaskTeam").modal('hide');
                misAlert("Request processed successfully", "Success", "success");
                getAllTaskTeams();
            }
            else if(resultData == 3)
                misAlert("Task team name with same name already exists", "Warning", "warning");
            else
                misAlert("Unable to process request. Try again", "Error", "error");
        });
}

$("#btnClose").click(function () {
    $("#modal-addTaskTeam").modal('hide');
});

