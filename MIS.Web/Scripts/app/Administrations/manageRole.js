$(document).ready(function () {
    loadRoleGrid();
});

function loadRoleGrid() {
    calltoAjax(misApiUrl.getAllRoles, "POST", '',
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            _AllRoles = resultData
            $("#tblRoleList").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                 {
                     filename: 'User Roles',
                     extend: 'collection',
                     text: 'Export',
                     buttons: [{ extend: 'copy' },
                                { extend: 'excel', filename: 'User Roles' },
                                { extend: 'pdf', filename: 'User Roles' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                                { extend: 'print', filename: 'User Roles' },
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
                        "mData": "RoleName",
                        "sTitle": "Role Name",
                    },

                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        "sClass": "text-center",
                        mRender: function (data, type, row) {
                            var html = '<div>';
                            html += '<button type="button" class="btn btn-sm teal"' + 'onclick="editRole(\'' + row.RoleAbrhs + '\')" data-toggle="tooltip" title="Edit"><i class="fa fa-edit"></i></button>';
                            html += '&nbsp;<button type="button" data-toggle="tooltip" class="btn btn-sm btn-danger"' + 'onclick="deletedRole(\'' + row.RoleAbrhs + '\')"  title="Delete"><i class="fa fa-trash"></i></button>';
                            html += '</div>'
                            return html;
                        }
                    },
                ]
            });
        });
}

function addRole() {
    $("#modaladdRols").modal('show');
    $("#txtRole").val("");
}

$("#btnSaveRole").click(function () {
    if (!validateControls('modaladdRols')) {
        return false;
    }
    var jsonObject = {
        RoleAbrhs: "",
        RoleName: $("#txtRole").val()
    };

    calltoAjax(misApiUrl.addRole, "POST", jsonObject,
    function (result) {
        var resultData = $.parseJSON(JSON.stringify(result));
        switch (resultData) {
            case 1:
                misAlert("Role has been saved successfully", "Success", "success");
                $("#modaladdRols").modal('hide');
                loadRoleGrid();
                break;
            case 2:
                misAlert("Role Allready Exist.", "Warning", "warning");
                break;
        }
    });
});

$("#btnClose").click(function () {
    $("#modaladdRols").modal('hide');
});


$("#btnEditClose").click(function () {
    $("#modalEditRole").modal('hide');
});

function editRole(RoleAbrhs) {
    _RoleAbrhs = RoleAbrhs;
    var jsonObject = {
        RoleAbrhs: RoleAbrhs
    };

    calltoAjax(misApiUrl.getRole, "POST", jsonObject,
    function (result) {
        var resultData = $.parseJSON(JSON.stringify(result));
        $("#txtRoleEdit").val(resultData.RoleName);
        $("#modalEditRole").modal('show');
    });

}


function deletedRole(RoleAbrhs) {
    misConfirm("Are you sure you want to delete ?", "Confirm", function (isConfirmed) {
        if (isConfirmed) {
            var jsonObject = {
                RoleAbrhs: RoleAbrhs
            };

            calltoAjax(misApiUrl.deleteRole, "POST", jsonObject,
            function (result) {
                if (result == 1) {
                    misAlert("Role has been deleted successfully", "Success", "success");
                    loadRoleGrid();
                }
            });
        }
    });
}

$("#btnUpdateRole").click(function () {
    if (!validateControls('modalEditRole')) {
        return false;
    }
    var jsonObject = {
        RoleAbrhs: _RoleAbrhs,
        RoleName: $("#txtRoleEdit").val()
    };

    calltoAjax(misApiUrl.updateRole, "POST", jsonObject,
    function (result) {
        var resultData = $.parseJSON(JSON.stringify(result));
        switch (resultData) {
            case 1:
                misAlert("Role has been updated successfully", "Success", "success");
                $("#modalEditRole").modal('hide');
                loadRoleGrid();
                break;
            case 2:
                misAlert("Role not Exist.", "Warning", "warning");
                break;
        }
    });
});
