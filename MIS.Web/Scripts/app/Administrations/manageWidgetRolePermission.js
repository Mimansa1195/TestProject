$(function () {
    $('#ddlRole').select2();

    $('#btnUpdateRolePermission').hide();
    bindRoles();

    $('#ddlRole').on('change', function () {
        bindWidgetRolePermissions($('#ddlRole').val());
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

var order = 0;

function bindWidgetRolePermissions(roleAbrhs) {
    var jsonObject = {
        roleAbrhs: roleAbrhs
    };

    calltoAjax(misApiUrl.getWidgetsRolePermissions, "POST", jsonObject, function (result) {
        var resultdata = $.parseJSON(JSON.stringify(result.WidgetPermission));
        if (resultdata && resultdata.length > 0) {
            $('#btnUpdateRolePermission').show();
        }
        else {
            $('#btnUpdateRolePermission').hide();
        }
        table = $("#roleWiseWidgetsGrid").dataTable({
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
            //rowReorder: {
            //    selector: 'tr'
            //},
            //"paging": false,
            //"bDestroy": false,
            //"searching": false,
            //"info": false,
            //"aoColumnDefs": [
            //    { "bSortable": false, "aTargets": [0, 2] }
            //],

            //"responsive": true,
            "autoWidth": false,
            "scrollY": "500px",
            "scrollX": true,
            "scrollCollapse": true,
            "paging": false,
            "bDestroy": true,
            "searching": false,
            "ordering": true,
            "order": [],
            "info": true,
            "deferRender": true,
            "aaData": resultdata,
            "aoColumns": [
                { "mData": "WidgetPermissionId", "sTitle": "WidgetPermissionId", "bVisible": false, "orderable": false },
                 {
                     "mData": "WidgetName", "sTitle": 'Dashboard Widget', "orderable": false,
                     mRender: function (data, type, row) {
                         var hidd = '';
                         hidd += '<input data-attr-WidgetPermissionId="' + row.WidgetPermissionId + '" data-attr-WidgetId="' + row.WidgetId + '" id="hdnWidgetPermissionId' + row.WidgetPermissionId + '" "hdnWidgetPermissionId' + row.WidgetPermissionId + '" type="hidden" value="' + row.WidgetPermissionId + '" />';
                         hidd += row.WidgetName;
                         return hidd;
                     }
                 },
                { "mData": "Sequence", "sTitle": "Sequence", "orderable": false },
                {
                    "mData": "IsViewRights",
                    "orderable": false,
                    "sTitle": '<input type="checkbox" class="chkHeader" name="chkViewAll" value="approve" id="chkViewAll" /> View',
                    mRender: function (data, type, row) {
                        var chk = (row.IsViewRights === true) ? 'checked' : '';
                        return '<input type="checkbox" ' + chk + ' class="chkView" name="chkView' + row.WidgetPermissionId + '" id="chkView' + row.WidgetPermissionId + '">';
                    }
                }
            ],
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
    var $tbl = $("#roleWiseWidgetsGrid").dataTable();

    var permission = function (widgetPermissionId, widgetId, sequence, isViewRights) {
        this.WidgetPermissionId = widgetPermissionId || 0;
        this.WidgetId = widgetId || 0;
        this.Sequence = sequence || 0;
        this.IsViewRights = isViewRights || false;
    };

    var permissionsList = [];
    $('#roleWiseWidgetsGrid tbody tr').each(function (index, item) {
        var $inputs = $(this).find(':input');
        var rowiDx = '';
        if ($inputs.length > 0) {
            var perObj = new permission();
            $inputs.each(function (idx, itm) {
                var id = $(this)[0].id;
                if ($(this)[0].type == 'hidden') {
                    rowiDx = $(this).val();
                    perObj.WidgetPermissionId = $(this).attr("data-attr-WidgetPermissionId");
                    perObj.WidgetId = $(this).attr("data-attr-WidgetId");
                }

                if ($(this)[0].type === 'checkbox' && id == 'chkView' + rowiDx) {
                    perObj.IsViewRights = $(this).is(':checked');
                }
                perObj.Sequence = $(item).find("td:nth-child(2)").html() == '' ? (index + 1) : $(item).find("td:nth-child(2)").html();
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
        WidgetPermission: permissionsList
    }
    calltoAjax(misApiUrl.addUpdateWidgetPermissions, "POST", jsonObject,
        function (result) {
            if (result == 1) {
                misAlert("Role permission has been saved successfully.", 'Success', 'success');
                bindWidgetRolePermissions($('#ddlRole').val());
            }
            else if (result == 2) {
                misError("Unable to save role permission .", 'Warning', 'warning');
            }
            else {
                misAlert();
            }
        });
}