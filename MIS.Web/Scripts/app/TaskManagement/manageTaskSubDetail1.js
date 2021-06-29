$(document).ready(function () {
    getAllTaskSubDetail1();
});

function getAllTaskSubDetail1() {
    calltoAjax(misApiUrl.listAllTaskSubDetail1, "POST", '',
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#tblAllTaskSubDetail1").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                 {
                     filename: 'All Task SubDetail 1 List',
                     extend: 'collection',
                     text: 'Export',
                     buttons: [{ extend: 'copy' },
                                { extend: 'excel', filename: 'All Task SubDetail 1 List' },
                                { extend: 'pdf', filename: 'All Task SubDetail 1 List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                                { extend: 'print', filename: 'All Task SubDetail 1 List' },
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
                        "sTitle": "SubDetail1 Name",
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        "sClass": "text-center",
                        mRender: function (data, type, row) {
                            var html = '<div>';
                            html += '<button type="button" data-toggle="tooltip" class="btn btn-sm btn-success"' + 'onclick="editTaskSubDetail1(' + row.Id + ')" title="Edit"><i class="fa fa-edit" aria-hidden="true"></i></button>';
                            html += '&nbsp;<button type="button" data-toggle="tooltip" class="btn btn-sm btn-danger"' + 'onclick="deleteTaskSubDetail1(' + row.Id + ')" title="Delete"><i class="fa fa-trash" aria-hidden="true"></i></button></div>'
                            return html;
                        }
                    },
                ]
            });
        });
}

function deleteTaskSubDetail1(taskSubDetail1Id) {
    var reply = misConfirm("Are you sure you want to delete task sub detail1", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                taskSubDetail1Id: taskSubDetail1Id,
                userAbrhs: misSession.userabrhs,
            }
            calltoAjax(misApiUrl.deleteTaskSubDetail1, "POST", jsonObject,
                function (result) {
                    var resultData = $.parseJSON(JSON.stringify(result));
                    if (resultData) {
                        misAlert("Request processed successfully", "Success", "success");
                        getAllTaskSubDetail1();
                    }
                    else
                        misAlert("Unable to process request. Try again", "Error", "error");
                });
        }
    });
}

function editTaskSubDetail1(taskSubDetail1Id) {
    $("#modal-addTaskSubDetail1").modal('show');
    $("#addTaskSubDetail1Btn").hide();
    $("#editTaskSubDetail1Btn").show();
    $("#hdnTaskSubDetail1Id").val(taskSubDetail1Id);
    var jsonObject = {
        taskSubDetail1Id: taskSubDetail1Id,
    }
    calltoAjax(misApiUrl.fetchTaskSubDetail1ById, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#taskSubDetail1Name").val(resultData);
        });
}

function finalEditTaskSubDetail1() {
    if (!validateControls('modal-addTaskSubDetail1')) {
        return false;
    }
    var jsonObject = {
        taskSubDetail1Id: $("#hdnTaskSubDetail1Id").val(),
        taskSubDetail1Name: $("#taskSubDetail1Name").val(),
        userAbrhs: misSession.userabrhs,
    }
    calltoAjax(misApiUrl.updateTaskSubDetail1, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            if (resultData == 1) {
                $("#modal-addTaskSubDetail1").modal('hide');
                misAlert("Request processed successfully", "Success", "success");
                getAllTaskSubDetail1();
            }
            else if (resultData == 3)
                misAlert("Task sub detail1 name with same name already exists", "Warning", "warning");
            else
                misAlert("Unable to process request. Try again", "Error", "error");
        });
}

function addNewTaskSubDetail1() {
    $("#modal-addTaskSubDetail1").modal('show');
    $("#addTaskSubDetail1Btn").show();
    $("#editTaskSubDetail1Btn").hide();
    $("#taskSubDetail1Name").val("");
}

function finalAddTaskSubDetail1() {
    if (!validateControls('modal-addTaskSubDetail1')) {
        return false;
    }
    var jsonObject = {
        taskSubDetail1Name: $("#taskSubDetail1Name").val(),
        userAbrhs: misSession.userabrhs,
    }
    calltoAjax(misApiUrl.addNewTaskSubDetail1, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            if (resultData == 1) {
                $("#modal-addTaskSubDetail1").modal('hide');
                misAlert("Request processed successfully", "Success", "success");
                getAllTaskSubDetail1();
            }
            else if (resultData == 3)
                misAlert("Task sub detail1 name with same name already exists", "Warning", "warning");
            else
                misAlert("Unable to process request. Try again", "Error", "error");
        });
}

$("#btnClose").click(function () {
    $("#modal-addTaskSubDetail1").modal('hide');
});

