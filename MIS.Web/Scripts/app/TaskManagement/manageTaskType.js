$(document).ready(function () {
    getAllTaskTypes();
});

function getAllTaskTypes() {
    calltoAjax(misApiUrl.listAllTaskType, "POST", '',
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#tblAllTaskType").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                 {
                     filename: 'All Task Type List',
                     extend: 'collection',
                     text: 'Export',
                     buttons: [{ extend: 'copy' },
                                { extend: 'excel', filename: 'All Task Type List' },
                                { extend: 'pdf', filename: 'All Task Type List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                                { extend: 'print', filename: 'All Task Type List' },
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
                        "sTitle": "Type Name",
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        "sClass": "text-center",
                        mRender: function (data, type, row) {
                            var html = '<div>';
                            html += '<button type="button" data-toggle="tooltip" class="btn btn-sm btn-success"' + 'onclick="editTaskType(' + row.Id + ')" title="Edit"><i class="fa fa-edit" aria-hidden="true"></i></button>';
                            html += '&nbsp;<button type="button" data-toggle="tooltip" class="btn btn-sm btn-danger"' + 'onclick="deleteTaskType(' + row.Id + ')" title="Delete"><i class="fa fa-trash" aria-hidden="true"></i></button></div>'
                            return html;
                        }
                    },
                ]
            });
        });
}

function deleteTaskType(taskTypeId) {
    var reply = misConfirm("Are you sure you want to delete task type", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                taskTypeId: taskTypeId,
                userAbrhs: misSession.userabrhs,
            }
            calltoAjax(misApiUrl.deleteTaskType, "POST", jsonObject,
                function (result) {
                    var resultData = $.parseJSON(JSON.stringify(result));
                    if (resultData) {
                        misAlert("Request processed successfully", "Success", "success");
                        getAllTaskTypes();
                    }
                    else
                        misAlert("Unable to process request. Try again", "Error", "error");
                });
        }
    });
}

function editTaskType(taskTypeId) {
    $("#modal-addTaskType").modal('show');
    $("#addTaskTypeBtn").hide();
    $("#editTaskTypeBtn").show();
    $("#hdnTaskTypeId").val(taskTypeId);
    var jsonObject = {
        taskTypeId: taskTypeId,
    }
    calltoAjax(misApiUrl.fetchTaskTypeByTypeId, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#taskTypeName").val(resultData);
        });
}

function finalEditTaskType() {
    if (!validateControls('modal-addTaskType')) {
        return false;
    }
    var jsonObject = {
        taskTypeId: $("#hdnTaskTypeId").val(),
        taskTypeName: $("#taskTypeName").val(),
        userAbrhs: misSession.userabrhs,
    }
    calltoAjax(misApiUrl.updateTaskTypeDetails, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            if (resultData == 1) {
                $("#modal-addTaskType").modal('hide');
                misAlert("Request processed successfully", "Success", "success");
                getAllTaskTypes();
            }
            else if (resultData == 3)
                misAlert("Task type name with same name already exists", "Warning", "warning");
            else
                misAlert("Unable to process request. Try again", "Error", "error");
        });
}

function addNewTaskType() {
    $("#modal-addTaskType").modal('show');
    $("#addTaskTypeBtn").show();
    $("#editTaskTypeBtn").hide();
    $("#taskTypeName").val("");
}

function finalAddTaskType() {
    if (!validateControls('modal-addTaskType')) {
        return false;
    }
    var jsonObject = {
        taskTypeName: $("#taskTypeName").val(),
        userAbrhs: misSession.userabrhs,
    }
    calltoAjax(misApiUrl.addNewTaskType, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            if (resultData == 1) {
                $("#modal-addTaskType").modal('hide');
                misAlert("Request processed successfully", "Success", "success");
                getAllTaskTypes();
            }
            else if (resultData == 3)
                misAlert("Task type name with same name already exists", "Warning", "warning");
            else
                misAlert("Unable to process request. Try again", "Error", "error");
        });
}

$("#btnClose").click(function () {
    $("#modal-addTaskType").modal('hide');
});

