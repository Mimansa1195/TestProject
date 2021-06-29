$(document).ready(function () {
    loadUserRoleGrid();
    $('#ddlRole').select2();
    $('#ddlDesignation').select2();
});

function loadUserRoleGrid() {
    calltoAjax(misApiUrl.getAllUserRoles, "POST", '',
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            _AllUserRoles = resultData
            $("#tblUserRoleList").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                 {
                     filename: 'All Users Role',
                     extend: 'collection',
                     text: 'Export',
                     buttons: [{ extend: 'copy' },
                                { extend: 'excel', filename: 'All Users Role' },
                                { extend: 'pdf', filename: 'All Users Role' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                                { extend: 'print', filename: 'All Users Role' },
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
                        "mData": "EmployeeName",
                        "sTitle": "Employee Name",
                    },
                    {
                        "mData": "RoleName",
                        "sTitle": "Role Name",
                    },
                    {
                        "mData": "DesignationGroup",
                        "sTitle": "Designation Group",
                    },
                    {
                        "mData": "EmpDesignation",
                        "sTitle": "Designation",
                    },                     
                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        "sClass": "text-center",
                        mRender: function (data, type, row) {
                            var html = '<div>';
                            html += '<button type="button" class="btn btn-sm teal"' + 'onclick="editRole(\'' + row.UserAbrhs + '\')" data-toggle="tooltip" title="Edit"><i class="fa fa-edit"></i></button>';
                            html += '</div>'
                            return html;
                        }
                    },
                ]
            });
        });
}

$("#btnEditClose").click(function () {
    $("#modalEditUserRole").modal('hide');
});

function listRoles(RoleAbrhs) {
    $('#ddlRole').empty();
    calltoAjax(misApiUrl.getAllRoles, "POST", '',
        function (result) {           
            if (result != null && result.length > 0) {
                for (t = 0; t < result.length; t++) {
                    $('#ddlRole').append("<option value = '" + result[t].RoleAbrhs + "'>" + result[t].RoleName + "</option>");
                }
                if (RoleAbrhs != null) {
                    $('#ddlRole').val(RoleAbrhs);
                }
            }
        });
}

function listDesignation(DesignationAbrhs, designationGroupAbrhs) {
    $('#ddlDesignation').empty();
    var jsonObject = {
        'userAbrhs': misSession.userabrhs,
        designationGroupAbrhs: designationGroupAbrhs,
    }
    calltoAjax(misApiUrl.getDesignations, "POST", jsonObject,
        function (result) {
           
            if (result != null && result.length > 0) {
                for (t = 0; t < result.length; t++) {
                    $('#ddlDesignation').append("<option value = '" + result[t].DesignationAbrhs + "'>" + result[t].DesignationName + "</option>");
                }
                if (DesignationAbrhs != null) {
                    $('#ddlDesignation').val(DesignationAbrhs);
                }
            }
        });
}

function listDesignationGroup(designationGroupAbrhs) {
    $('#ddlDesignationGroup').empty();
    var jsonObject = {
        'userAbrhs': misSession.userabrhs,
        isOnlyActive: true
    }
    calltoAjax(misApiUrl.getDesignationGroups, "POST", jsonObject,
        function (result) {            
            if (result != null && result.length > 0) {
                for (t = 0; t < result.length; t++) {
                    $('#ddlDesignationGroup').append("<option value = '" + result[t].EntityAbrhs + "'>" + result[t].EntityName + "</option>");
                }
                if (designationGroupAbrhs != null) {
                    $('#ddlDesignationGroup').val(designationGroupAbrhs);
                }
            }
        });
}

$("#ddlDesignationGroup").change(function () {
    $('#ddlDesignation').empty();
    listDesignation(null, $("#ddlDesignationGroup").val())
});

function editRole(UserAbrhs) {
    _UserAbrhs = UserAbrhs;
    var jsonObject = {
        employeeAbrhs: UserAbrhs,
    };

    calltoAjax(misApiUrl.getUserRole, "POST", jsonObject,
    function (result) {
   
        var resultData = $.parseJSON(JSON.stringify(result));
        $("#txtEmployeeName").val(resultData.EmployeeName);
       
        listRoles(resultData.RoleAbrhs);
        listDesignationGroup(resultData.DesignationGroupAbrhs);
        listDesignation(resultData.DesignationAbrhs, resultData.DesignationGroupAbrhs);

        $("#modalEditUserRole").modal('show');
    });

}

$("#btnUpdateUserRole").click(function () {
    if (!validateControls('modalEditUserRole')) {
        return false;
    }
    var jsonObject = {
        UserAbrhs: _UserAbrhs,
        EmployeeName: "",
        RoleAbrhs: $('#ddlRole').val(),
        DesignationAbrhs: $('#ddlDesignation').val()
    };

    calltoAjax(misApiUrl.updateUserRole, "POST", jsonObject,
    function (result) {
        var resultData = $.parseJSON(JSON.stringify(result));
        switch (resultData) {
            case 1:
                misAlert("User Details has been updated successfully", "Success", "success");
                $("#modalEditUserRole").modal('hide');
                loadUserRoleGrid();
                break;
            case 2:
                misAlert("User Details not Exist.", "Warning", "warning");
                break;
        }
    });
});
