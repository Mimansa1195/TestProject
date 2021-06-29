var _mode = 0;
var _verticalId = 0;

$(document).ready(function () {
    listActiveProjectVerticals();
});

$("#btnAddNewVertical").click(function (e) {
    showVerticalPopup(0,0);
});

$("#btnVerticalPopup").click(function (e) {
    if (!validateControls('divManageVertical')) {
        return false;
    }
    var vertical = $("#txtVertical").val().trim();
    var verticalAbrhs = $("#ddlOwner").val();
        if (_mode === 0) {
            saveProjectVertical(vertical, verticalAbrhs);
        } else {
            updateProjectVertical(vertical, verticalAbrhs);
        }
});

function listActiveProjectVerticals() {
    var jsonObject = {
        'userAbrhs': misSession.userabrhs
    }
    calltoAjax(misApiUrl.listActiveProjectVerticals, "POST", jsonObject,
        function (result) {
            if (result != null && result.length > 0) {
                var data = $.parseJSON(JSON.stringify(result));
                $("#tblVerticalList").dataTable({
                    "responsive": true,
                    "autoWidth": false,
                    "paging": true,
                    "bDestroy": true,
                    "ordering": true,
                    "order": [],
                    "info": true,
                    "deferRender": false,
                    "aaData": data,
                    "aoColumns": [
                        {
                            "mData": "Name",
                            "sTitle": "Name",
                        },
                         {
                             "mData": "Owners",
                             "sTitle": "Owners",
                         },
                         {
                             "mData": "NoofTotalProjects",
                             "sTitle": "Total Projects",
                         },
                        {
                            "mData": "NoofTeamMembers",
                            "sTitle": "No. of Team Members",
                        },
                        {
                            "mData": null,
                            "sTitle": "View",
                            'bSortable': false,
                            "sClass": "text-left",
                            "sWidth": "100px",
                            mRender: function (data, type, row) {
                                html = '<button type="button" class="btn btn-sm teal" data-toggle"model" data-target="#mypopupViewDocModal"' + 'onclick="editVertical(' + row.VerticalId + ')" data-toggle="tooltip" title="Edit"><i class="fa fa-edit"> </i></button>';
                                return html;
                            }
                        },
                    ]
                });
            } else {
                $("#divVerticalsGridView").html('No verticals available in database');
            }
        });
}

function listActiveUsers(verticalAbrhs) {
    var jsonObject = {
        'userAbrhs': misSession.userabrhs
    }
    calltoAjax(misApiUrl.listActiveUsers, "POST", jsonObject,
        function (result) {
            if (result != null && result.length > 0) {
                for (t = 0; t < result.length; t++) {
                    $('#ddlOwner').append("<option value = '" + result[t].EmployeeAbrhs + "'>" + result[t].EmployeeName + "</option>");
                }
                if (verticalAbrhs != null) {
                    $('#ddlOwner').val(verticalAbrhs);
                }
            }
        });
}

function showVerticalPopup(mode, verticalAbrhs) {
    _mode = mode;
    $("#ddlOwner").empty();
    $('#ddlOwner').append("<option value = '0'>Select</option>");

    $("#txtVertical").removeClass("error-validation");
    $("#ddlOwner").removeClass("error-validation");

    listActiveUsers(verticalAbrhs);
    if (mode === 0) {
        $('#modalTitle').text("Add New Project Vertical");
        $("#txtVertical").val("");
        $("#ddlOwner").val(0);
        $("#btnVerticalPopup").text('Save');
    } else {
        $('#modalTitle').text("Modify Project Vertical");
        $("#btnVerticalPopup").text('Update');
    }
    $('#popupGeminiProjectVertical').modal("show");
}

function editVertical(verticalId) {
    _verticalId = verticalId;
    var jsonObject = {
        'verticalId': verticalId,
        'userAbrhs': misSession.userabrhs
    }
    calltoAjax(misApiUrl.fetchSelectedVerticalInfo, "POST", jsonObject,
        function (result) {
            showVerticalPopup(1, result.VerticalAbrhs);
            $("#txtVertical").val(result.Vertical);
        });
}

function saveProjectVertical(vertical, verticalAbrhs) {
    var jsonObject = {
        'vertical': vertical,
        'VerticalAbrhs': verticalAbrhs,
        'userAbrhs': misSession.userabrhs
    }
    calltoAjax(misApiUrl.saveProjectVertical, "POST", jsonObject,
        function (result) {
            if (result === 1) {
                $('#popupGeminiProjectVertical').modal("hide");
                listActiveProjectVerticals();
                misAlert("Project Vertical saved successfully", "Success", "success");
            }
            if (result === 2) {
                misAlert("Project Vertical allready exist !", "Warning", "warning");
            }
        });
}

function updateProjectVertical(vertical, verticalAbrhs) {
    var jsonObject = {
        'verticalId': _verticalId,
        'vertical': vertical,
        'VerticalAbrhs': verticalAbrhs,
        'userAbrhs': misSession.userabrhs
    }
    calltoAjax(misApiUrl.updateProjectVertical, "POST", jsonObject,
        function (result) {
            if (result === 1) {
                $('#popupGeminiProjectVertical').modal("hide");
                listActiveProjectVerticals();
                misAlert("Project Vertical saved successfully", "Success", "success");
            }
            if (result === 2) {
                misAlert("Project Vertical allready exist !", "Warning", "warning");
            }
        });
}

$("#btnCloseAddVertical").click(function () {
    $("#popupGeminiProjectVertical").modal("hide");
});
