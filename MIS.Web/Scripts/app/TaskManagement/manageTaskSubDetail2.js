$(document).ready(function () {
    getAllTaskSubDetail2();
});

function getAllTaskSubDetail2() {
    calltoAjax(misApiUrl.listAllTaskSubDetail2, "POST", '',
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#tblAllTaskSubDetail2").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                 {
                     filename: 'All Task SubDetail 2 List',
                     extend: 'collection',
                     text: 'Export',
                     buttons: [{ extend: 'copy' },
                                { extend: 'excel', filename: 'All Task SubDetail 2 List' },
                                { extend: 'pdf', filename: 'All Task SubDetail 2 List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                                { extend: 'print', filename: 'All Task SubDetail 2 List' },
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
                        "sTitle": "SubDetail2 Name",
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        "sClass": "text-center",
                        mRender: function (data, type, row) {
                            var html = '<div>';
                            html += '<button type="button" data-toggle="tooltip" class="btn btn-sm btn-success"' + 'onclick="editTaskSubDetail2(' + row.Id + ')" title="Edit"><i class="fa fa-edit" aria-hidden="true"></i></button>';
                            html += '&nbsp;<button type="button" data-toggle="tooltip" class="btn btn-sm btn-danger"' + 'onclick="deleteTaskSubDetail2(' + row.Id + ')" title="Delete"><i class="fa fa-trash" aria-hidden="true"></i></button></div>'
                            return html;
                        }
                    },
                ]
            });
        });
}

function deleteTaskSubDetail2(taskSubDetail2Id) {
    var reply = misConfirm("Are you sure you want to delete task sub detail2", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                taskSubDetail2Id: taskSubDetail2Id,
                userAbrhs: misSession.userabrhs,
            }
            calltoAjax(misApiUrl.deleteTaskSubDetail2, "POST", jsonObject,
                function (result) {
                    var resultData = $.parseJSON(JSON.stringify(result));
                    if (resultData) {
                        misAlert("Request processed successfully", "Success", "success");
                        getAllTaskSubDetail2();
                    }
                    else
                        misAlert("Unable to process request. Try again", "Error", "error");
                });
        }
    });
}

function editTaskSubDetail2(taskSubDetail2Id) {
    $("#modal-addTaskSubDetail2").modal('show');
    $("#addTaskSubDetail2Btn").hide();
    $("#editTaskSubDetail2Btn").show();
    $("#hdnTaskSubDetail2Id").val(taskSubDetail2Id);
    var jsonObject = {
        taskSubDetail2Id: taskSubDetail2Id,
    }
    calltoAjax(misApiUrl.fetchTaskSubDetail2ById, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#taskSubDetail2Name").val(resultData);
        });
}

function finalEditTaskSubDetail2() {
    if (!validateControls('modal-addTaskSubDetail2')) {
        return false;
    }
    var jsonObject = {
        taskSubDetail2Id: $("#hdnTaskSubDetail2Id").val(),
        taskSubDetail2Name: $("#taskSubDetail2Name").val(),
        userAbrhs: misSession.userabrhs,
    }
    calltoAjax(misApiUrl.updateTaskSubDetail2, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            if (resultData == 1) {
                $("#modal-addTaskSubDetail2").modal('hide');
                misAlert("Request processed successfully", "Success", "success");
                getAllTaskSubDetail2();
            }
            else if (resultData == 3)
                misAlert("Task sub detail2 name with same name already exists", "Warning", "warning");
            else
                misAlert("Unable to process request. Try again", "Error", "error");
        });
}

function addNewTaskSubDetail2() {
    $("#modal-addTaskSubDetail2").modal('show');
    $("#addTaskSubDetail2Btn").show();
    $("#editTaskSubDetail2Btn").hide();
    $("#taskSubDetail2Name").val("");
}

function finalAddTaskSubDetail2() {
    if (!validateControls('modal-addTaskSubDetail2')) {
        return false;
    }
    var jsonObject = {
        taskSubDetail2Name: $("#taskSubDetail2Name").val(),
        userAbrhs: misSession.userabrhs,
    }
    calltoAjax(misApiUrl.addNewTaskSubDetail2, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            if (resultData == 1) {
                $("#modal-addTaskSubDetail2").modal('hide');
                misAlert("Request processed successfully", "Success", "success");
                getAllTaskSubDetail2();
            }
            else if (resultData == 3)
                misAlert("Task sub detail2 name with same name already exists", "Warning", "warning");
            else
                misAlert("Unable to process request. Try again", "Error", "error");
        });
}

$("#btnClose").click(function () {
    $("#modal-addTaskSubDetail2").modal('hide');
});

