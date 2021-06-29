$(function () {
    $('#ddlEmployee').select2();
    $('#btnUpdateUserPermission').hide();
    bindUsers();

    $('#ddlEmployee').on('change', function () {
        bindWidgetUserPermissions($('#ddlEmployee').val());
    });

    $('#btnUpdateUserPermission').click(function () {
        updateUserPermission();
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

function bindUsers() {
    $("#ddlEmployee").empty();
    var jsonObject = {
        userAbrhs: misSession.userabrhs
    }
    calltoAjax(misApiUrl.listAllActiveUsers, "POST", jsonObject,
        function (result) {
            $("#ddlEmployee").empty();
            $("#ddlEmployee").append("<option value='0'>Select</option>");

            if (result != null) {
                for (var i = 0; i < result.length ; i++) {
                    $("#ddlEmployee").append("<option value = '" + result[i].EmployeeAbrhs + "'>" + result[i].EmployeeName + "</option>");
                }
            }
        });
}

function bindWidgetUserPermissions(employeeAbrhs) {
    var jsonObject = {
        employeeAbrhs: employeeAbrhs
    };

    calltoAjax(misApiUrl.getWidgetsUserPermissions, "POST", jsonObject,
    function (result) {
        var resultdata = $.parseJSON(JSON.stringify(result.WidgetPermission));
        if (resultdata && resultdata.length > 0) {
            $('#btnUpdateUserPermission').show();
        }
        else {
            $('#btnUpdateUserPermission').hide();
        }

        table = $("#userWiseWidgetsGrid").dataTable({
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

function updateUserPermission() {
    if (!validateControls('permissionContainer')) {
        return false;
    }

    var permission = function (widgetPermissionId, widgetId, sequence, isViewRights) {
        this.WidgetPermissionId = widgetPermissionId || 0;
        this.WidgetId = widgetId || 0;
        this.Sequence = sequence || 0;
        this.IsViewRights = isViewRights || false;
    };

    var permissionsList = [];
    $('#userWiseWidgetsGrid tbody tr').each(function (index, item) {
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

    var employeeAbrhs = $('#ddlEmployee').val();
    var jsonObject = {
        IsUserPermission: true,
        EmployeeAbrhs: employeeAbrhs,
        RoleAbrhs: '',
        WidgetPermission: permissionsList
    }
    calltoAjax(misApiUrl.addUpdateWidgetPermissions, "POST", jsonObject,
        function (result) {
            if (result == 1) {
                misAlert("User permission has been saved successfully.", 'Success', 'success');
                bindWidgetUserPermissions($('#ddlEmployee').val());
            }
            else if (result == 2) {
                misError("Unable to save user permission.", 'Warning', 'warning');
            }
            else {
                misAlert();
            }
        });
}