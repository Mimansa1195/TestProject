$(function () {
    $('#ddlRole').select2();

    $('#btnUpdateRolePermission').hide();
    bindRoles();

    $('#ddlRole').on('change', function () {
        bindMenusRolePermissions($('#ddlRole').val());
    });

    $('#btnUpdateRolePermission').click(function () {
        updateRolePermission();
    });
});

$(document).on('click', 'thead tr th input[type="checkbox"]', function (e) {
    if (this.id) {
        var chk = $(this).is(':checked');
        $('tbody tr td input.' + (this.id).replace('All', '') + '[type="checkbox"]').each(function () {
            $(this).prop('checked', chk);
        });
    }
});

function bindRoles() {
    $("#ddlRole").empty();
    calltoAjax(misApiUrl.getRoles, "POST", '',
        function (result) {
            $("#ddlRole").empty();
            $("#ddlRole").append("<option value='0'>Select</option>");

            if (result != null) {
                for (var i = 0; i < result.length ; i++) {
                    $("#ddlRole").append("<option value = '" + result[i].RoleAbrhs + "'>" + result[i].RoleName + "</option>");
                }
            }
        });
}

function bindMenusRolePermissions(roleAbrhs) {
    var jsonObject = {
        roleAbrhs: roleAbrhs
    };

    calltoAjax(misApiUrl.getMenusRolePermissions, "POST", jsonObject, function (result) {
        var resultdata = $.parseJSON(JSON.stringify(result.MenuPermission));
        if (resultdata && resultdata.length > 0) {
            $('#btnUpdateRolePermission').show();
        }
        else {
            $('#btnUpdateRolePermission').hide();
        }
        table = $("#roleWiseMenusGrid").dataTable({
            "dom": 'lBfrtip',
            "buttons": [
                 {
                     extend: 'collection',
                     text: 'Export',
                     buttons: [
                         'copy',
                         'excel',
                         'pdf',
                         'print'
                     ]
                 }
            ],
            //"responsive": true,
            "autoWidth": false,
            "scrollY": "500px",
            "scrollX": true,
            "scrollCollapse": true,
            "paging": false,
            //fixedColumns:   {
            //    leftColumns: 1
            //},
            "bDestroy": true,
            "searching": false,
            "ordering": true,
            "order": [],
            "info": true,
            "deferRender": true,
            "aaData": resultdata,
            "aoColumns": [
                { "mData": "MenuPermissionId", "sTitle": "MenuPermissionId", "bVisible": false, "orderable": false },
                 {
                     "mData": "MenuName", "sTitle": 'Menu', "orderable": false,
                     mRender: function (data, type, row) {
                         var hidd = '';
                         hidd += '<input data-attr-MenuPermissionId="' + row.MenuPermissionId + '" data-attr-MenuId="' + row.MenuId + '" id="hdnMenuPermissionId' + row.MenuPermissionId + '" "hdnMenuPermissionId' + row.MenuPermissionId + '" type="hidden" value="' + row.MenuPermissionId + '" />';
                         hidd += row.MenuName;
                         return hidd;
                     }
                 },
                { "mData": "ControllerName", "sTitle": "Controller", "orderable": false, "bVisible": false },
                { "mData": "ActionName", "sTitle": "Action Name", "orderable": false },
                { "mData": "Sequence", "sTitle": "#", "orderable": false },
                //{ "mData": "IsLinkEnabled", "sTitle": "IsLinkEnabled" },
                //{ "mData": "IsVisible", "sTitle": "IsVisible" },
                {
                    "mData": "IsViewRights",
                    "orderable": false,
                    "sTitle": '<input type="checkbox" class="chkHeader" name="chkViewAll" value="approve" id="chkViewAll" /> View',
                    mRender: function (data, type, row) {
                        var isDashboard = (row.ControllerName.toLowerCase() === 'dashboard' && row.ActionName.toLowerCase() === 'index');
                        var chk = (row.IsViewRights === true || isDashboard) ? 'checked' : '';
                        var disable = isDashboard ? ' disabled' : '';
                        return '<input type="checkbox" ' + chk + disable + ' class="chkView" name="chkView' + row.MenuPermissionId + '" id="chkView' + row.MenuPermissionId + '">';
                    }
                },
                {
                    "mData": "IsAddRights",
                    "orderable": false,
                    "sTitle": '<input type="checkbox" name="chkAddAll" value="approve" id="chkAddAll" /> Add',
                    mRender: function (data, type, row) {
                        var chk = (row.IsAddRights === true) ? 'checked' : '';
                        return '<input type="checkbox" ' + chk + ' class="chkAdd" name="chkAdd' + row.MenuPermissionId + '" id="chkAdd' + row.MenuPermissionId + '">';
                    }
                },
                {
                    "mData": "IsModifyRights",
                    "orderable": false,
                    "sTitle": '<input type="checkbox" name="chkModifyAll" value="approve" id="chkModifyAll" /> Modify',
                    mRender: function (data, type, row) {
                        var chk = (row.IsModifyRights === true) ? 'checked' : '';
                        return '<input type="checkbox" ' + chk + ' class="chkModify" name="chkModify' + row.MenuPermissionId + '" id="chkModify' + row.MenuPermissionId + '">';
                    }
                },
                {
                    "mData": "IsDeleteRights",
                    "orderable": false,
                    "sTitle": '<input type="checkbox" name="chkDeleteAll" value="approve" id="chkDeleteAll" /> Delete',
                    mRender: function (data, type, row) {
                        var chk = (row.IsDeleteRights === true) ? 'checked' : '';
                        return '<input type="checkbox" ' + chk + ' class="chkDelete" name="chkDelete' + row.MenuPermissionId + '" id="chkDelete' + row.MenuPermissionId + '">';
                    }
                },
                {
                    "mData": "IsAssignRights",
                    "orderable": false,
                    "sTitle": '<input type="checkbox" name="chkAssignAll" value="approve" id="chkAssignAll" /> Assign',
                    mRender: function (data, type, row) {
                        var chk = (row.IsAssignRights === true) ? 'checked' : '';
                        return '<input type="checkbox" ' + chk + ' class="chkAssign" name="chkAssign' + row.MenuPermissionId + '" id="chkAssign' + row.MenuPermissionId + '">';
                    }
                },
                {
                    "mData": "IsApproveRights",
                    "orderable": false,
                    "sTitle": '<input type="checkbox" name="chkApproveAll" value="approve" id="chkApproveAll" /> Approve',
                    mRender: function (data, type, row) {
                        var chk = (row.IsApproveRights === true) ? 'checked' : '';
                        //return '<input id="toggle-demo" type="checkbox" checked data-toggle="toggle" data-on="Ready" data-off="Not Ready" data-onstyle="success" data-offstyle="danger">';
                        return '<input type="checkbox" ' + chk + ' class="chkApprove" name="chkApprove' + row.MenuPermissionId + '" id="chkApprove' + row.MenuPermissionId + '">';
                    }
                }
            ],
            //"aoColumnDefs": [
            //     { "sClass": "dt_col_hide", "aTargets": [0,2] }
            //],
            "drawCallback": function (settings) {
                var api = this.api();
                var rows = api.rows({ page: 'current' }).nodes();
                var last = null;
                api.column(2, { page: 'current' }).data().each(function (group, i) {
                    if (last !== group) {
                        $(rows).eq(i).before(
                            '<tr class="group"><td colspan="9">' + group.formatWithSpace() + '</td></tr>'
                        );
                        last = group;
                    }
                });
            },
            "fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                if (aData.IsActive === false) {
                    $('td', nRow).css('background-color', 'rgb(255, 216, 214)');
                }
            }
        });
    });
}

function updateRolePermission() {
    if (!validateControls('permissionContainer')) {
        return false;
    }

    var $tbl = $("#roleWiseMenusGrid").dataTable();
    //$tbl.$('input[type="checkbox"]').each(function () {
    //    if (this.checked) {
    //        selectedIds.push($(this).val());
    //    }
    //});

    $tbl.$('tr').each(function () {
        //if (this.checked) {
        //    selectedIds.push($(this).val());
        //}
    });

    var permission = function (menuPermissionId, menuId, isViewRights, isAddRights, isModifyRights, isDeleteRights, isAssignRights, isApproveRights) {
        this.MenuPermissionId = menuPermissionId || 0;
        this.MenuId = menuId || 0;
        this.IsViewRights = isViewRights || false;
        this.IsAddRights = isAddRights || false;
        this.IsModifyRights = isModifyRights || false;
        this.IsDeleteRights = isDeleteRights || false;
        this.IsAssignRights = isAssignRights || false;
        this.IsApproveRights = isApproveRights || false;
    };

    var permissionsList = [];
    $('#roleWiseMenusGrid tbody tr:not(".group")').each(function (index, item) {
        var $inputs = $(this).find(':input');
        var rowiDx = '';
        if ($inputs.length > 0) {
            var perObj = new permission();
            $inputs.each(function (idx, itm) {
                var id = $(this)[0].id;
                if ($(this)[0].type == 'hidden') {
                    rowiDx = $(this).val();
                    perObj.MenuPermissionId = $(this).attr("data-attr-MenuPermissionId");
                    perObj.MenuId = $(this).attr("data-attr-MenuId");
                }

                if ($(this)[0].type === 'checkbox' && id == 'chkView' + rowiDx) {
                    perObj.IsViewRights = $(this).is(':checked');
                }

                if ($(this)[0].type === 'checkbox' && id == 'chkAdd' + rowiDx) {
                    perObj.IsAddRights = $(this).is(':checked');
                }

                if ($(this)[0].type === 'checkbox' && id == 'chkModify' + rowiDx) {
                    perObj.IsModifyRights = $(this).is(':checked');
                }

                if ($(this)[0].type === 'checkbox' && id == 'chkDelete' + rowiDx) {
                    perObj.IsDeleteRights = $(this).is(':checked');
                }

                if ($(this)[0].type === 'checkbox' && id == 'chkAssign' + rowiDx) {
                    perObj.IsAssignRights = $(this).is(':checked');
                }

                if ($(this)[0].type === 'checkbox' && id == 'chkApprove' + rowiDx) {
                    perObj.IsApproveRights = $(this).is(':checked');
                }
            });
            permissionsList.push(perObj);
        }
        else {
            // no chk selected
        }

    });

    var roleAbrhs = $('#ddlRole').val();
    var jsonObject = {
        IsUserPermission: false,
        EmployeeAbrhs: '',
        RoleAbrhs: roleAbrhs,
        MenuPermission: permissionsList
    }
    calltoAjax(misApiUrl.addUpdateMenusPermissions, "POST", jsonObject,
        function (result) {
            if (result == 1) {
                misAlert("Role permission has been saved successfully.", 'Success', 'success');
                bindMenusRolePermissions($('#ddlRole').val());
            }
            else if (result == 2) {
                misError("Unable to save role permission .", 'Warning', 'warning');
            }
            else {
                misAlert();
            }
        });
}

//$('#roleWiseMenusGrid').on('click', 'thead th input[type="checkbox"]', function (e) {

//});



//// Handle click on checkbox
//$('#roleWiseMenusGrid tbody').on('click', 'input[type="checkbox"]', function (e) {
//    var $row = $(this).closest('tr');

//    // Get row data
//    var data = table.row($row).data();

//    // Get row ID
//    var rowId = data[0];

//    // Determine whether row ID is in the list of selected row IDs 
//    var index = $.inArray(rowId, rows_selected);

//    // If checkbox is checked and row ID is not in list of selected row IDs
//    if (this.checked && index === -1) {
//        rows_selected.push(rowId);

//        // Otherwise, if checkbox is not checked and row ID is in list of selected row IDs
//    } else if (!this.checked && index !== -1) {
//        rows_selected.splice(index, 1);
//    }

//    if (this.checked) {
//        $row.addClass('selected');
//    } else {
//        $row.removeClass('selected');
//    }

//    // Update state of "Select all" control
//    updateDataTableSelectAllCtrl(table);

//    // Prevent click event from propagating to parent
//    e.stopPropagation();
//});

//$('#roleWiseMenusGrid').on('click', 'input[type="checkbox"]', function (e) {
//});

//$("table tr th.header").click(function () {
//    alert("Handler for .click() called.");
//});


//// Handle click on table cells with checkboxes
//$('#roleWiseMenusGrid').on('click', 'thead th', function (e) {
//    $(this).parent().find('input[type="checkbox"]').trigger('click');
//});


//$('#roleWiseMenusGrid thead').on('click', 'th', function () {
//    alert('Column clicked on: ');
//});

//// Handle click on table cells with checkboxes
//$('#roleWiseMenusGrid').on('click', 'tbody td, thead th:first-child', function (e) {
//    $(this).parent().find('input[type="checkbox"]').trigger('click');
//});

// Handle click on "Select all" control
//$('thead input[name="select_all"]', table.table().container()).on('click', function (e) {
//    if (this.checked) {
//        $('#example tbody input[type="checkbox"]:not(:checked)').trigger('click');
//    } else {
//        $('#example tbody input[type="checkbox"]:checked').trigger('click');
//    }

//    // Prevent click event from propagating to parent
//    e.stopPropagation();
//});