$(document).ready(function () {
    loadNavigationMenuGrid();
    $('#menuType').prop('checked', true);
    $("#divIsNewMenu").show();
    $("#divIsParentMenu").hide();
    $("#menuType").change(function () {
        if ($("#menuType").is(':checked')) {
            $("#divIsNewMenu").show();
            $("#divIsParentMenu").hide();
            $("#txtControllerName").addClass("validation-required");
            $("#parentControllerScroll").removeClass("validation-required");
            $("#parentControllerScroll").removeClass("error-validation");
        }
        else {
            $("#divIsNewMenu").hide();
            $("#divIsParentMenu").show();
            $("#txtControllerName").removeClass("validation-required");
            $("#txtControllerName").removeClass("error-validation");
            $("#parentControllerScroll").addClass("validation-required");
            bindControllerDropdown("parentControllerScroll", 0);
        }
    });
});

function bindControllerDropdown(controlId, selectedValue = 0) {
    $("#" + controlId).html(""); //to clear the previously selected value
    $("#" + controlId).select2();
    $("#" + controlId).append("<option value='0'>Select</option>");
    calltoAjax(misApiUrl.getControllers, "POST", '',
        function (result) {
            if (result !== null) {
                $.each(result, function (index, item) {
                    $("#" + controlId).append("<option value = '" + item.ControllerName + "' >" + item.ControllerName + "</option>");
                });
                if (selectedValue !== 0) {
                    $("#" + controlId).val(selectedValue);
                }
            }
        });
}

function showPopupAddNavigationMenu() {
    $("#mypopupAddNavigationMenu").modal("show");
    $("#txtMenuName").val("");
    $("#txtActionName").val("");
    $("#txtControllerName").val("");
    $("#parentControllerScroll").val("");
    $("#txtSequenceScroll").val("");
    $("#IsLinkEnabled").attr("checked", false);
    $("#IsMenuVisible").attr("checked", false);
    $("#CSSClass").val("");
    $("#IsDelegatable").attr("checked", false);
    $("#IsTabMenu").attr("checked", false);

}


$("#btnSaveMenus").click(function () {

    if (!validateControls('mypopupAddNavigationMenu')) {
        return false;
    }
    var IsLinkEnabled = false;
    var IsMenuVisible = false;
    var IsDelegatable = false;
    var IsTabMenu = false;
    if ($("#menuType").is(':checked'))
        var currentName = $("#txtControllerName").val();
    else
        currentName = $("#parentControllerScroll").val();
    if ($("#IsLinkEnabled").is(':checked'))
        IsLinkEnabled = true;
    if ($("#IsMenuVisible").is(':checked'))
        IsMenuVisible = true;
    if ($("#IsDelegatable").is(':checked'))
        IsDelegatable = true;
    if ($("#IsTabMenu").is(':checked'))
        IsTabMenu = true;

    var jsonObject = {
        MenuName: $("#txtMenuName").val(),
        ActionName: $("#txtActionName").val(),
        ControllerName: currentName,

        Sequence: $("#txtSequenceScroll").val(),
        IsLinkEnabled: IsLinkEnabled,
        IsMenuVisible: IsMenuVisible,
        CssClass: $("#CSSClass").val(),
        IsDelegatable: IsDelegatable,
        IsTabMenu: IsTabMenu,
        userAbrhs: misSession.userabrhs
    };

    calltoAjax(misApiUrl.addNavigationMenu, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            switch (resultData) {
                case 1:
                    misAlert("Navigation menu added successfully", "Success", "success");
                    $("#mypopupAddNavigationMenu").modal('hide');
                    loadNavigationMenuGrid();
                    break;
                case 2:
                    misAlert("Controller with this name already exists. Please check.", "Warning", "warning");
                    $("#mypopupAddNavigationMenu").modal('hide');

                    break;

                case 0:
                    misAlert("Unable to process request. Try again", "Error", "error");
                    $("#mypopupAddNavigationMenu").modal('toggle');
                    break;
            }
        });
});


function loadNavigationMenuGrid() {
    calltoAjax(misApiUrl.getNavigationMenus, "GET", '',
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            var table = $("#tblNavigationMenuList").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'Navigation Menus',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'Navigation Menus' },
                        { extend: 'pdf', filename: 'Navigation Menus' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                        { extend: 'print', filename: 'Navigation Menus' },
                        ]
                    }
                ],
                //"responsive": true,
                "autoWidth": true,
                //"scrollY": "500px",
                "scrollX": true,
                "scrollCollapse": true,
                "paging": false,
                "bDestroy": true,
                "searching": false,
                "ordering": true,
                "order": [],
                "info": true,
                "deferRender": true,
                "aaData": resultData,
                "aoColumns": [
                    { "mData": "MenuId", "sTitle": "MenuId", "bVisible": false, "orderable": false },
                    {
                        "mData": "MenuName", "sTitle": 'Menu', "orderable": false,
                        mRender: function (data, type, row) {
                            var hidd = '';
                            hidd += '<input data-attr-MenuId="' + row.MenuId + '" id="hdnMenuId' + row.MenuId + '" "hdnMenuId' + row.MenuId + '" type="hidden" value="' + row.MenuId + '" />';
                            if (row.CssClass)
                                hidd += '<i class="' + row.CssClass + '"></i> ';
                            hidd += row.MenuName;
                            return hidd;
                        }
                    },
                    { "mData": "ControllerName", "sTitle": "Controller", "orderable": false, "bVisible": false },
                    { "mData": "ActionName", "sTitle": "Action Name", "orderable": false },
                    { "mData": "Sequence", "sTitle": "#", "orderable": false },
                    {
                        "mData": "IsLinkEnabled", "sTitle": 'Link', "orderable": false,
                        mRender: function (data, type, row) {
                            if (row.IsLinkEnabled === true)
                                return '<span class="label label-info">Enabled</span>';
                            else
                                return '<span class="label label-default">Disabled</span>';
                        }
                    },
                    {
                        "mData": "IsMenuVisible", "sTitle": 'Visible', "orderable": false,
                        mRender: function (data, type, row) {
                            if (row.IsMenuVisible === true)
                                return '<span class="label label-success"> <i class="fa fa-eye"></i> </span>';
                            else
                                return '<span class="label label-danger"> <i class="fa fa-eye-slash"></i> </span>';
                        }
                    },
                    {
                        "mData": "IsDelegatable", "sTitle": 'Delegatable', "orderable": false,
                        mRender: function (data, type, row) {
                            if (row.IsDelegatable === true)
                                return '<span class="label label-success"><i class="fa fa-bolt"></i> Yes</span>';
                            else
                                return '<span class="label label-danger">No</span>';
                        }
                    },
                    {
                        "mData": "IsTabMenu", "sTitle": 'Tab Menu', "orderable": false,
                        mRender: function (data, type, row) {
                            if (row.IsTabMenu === true)
                                return '<span class="label label-success"><i class="fa fa-bolt"></i> Yes</span>';
                            else
                                return '<span class="label label-danger">No</span>';
                        }
                    },
                    { "mData": "CreatedDate", "sTitle": "Created On", "orderable": false },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        "sWidth": "75px",
                        mRender: function (data, type, row) {
                            var html = '<div>';
                            html += '&nbsp;<button type="button" class="btn btn-sm teal"' + 'onclick="editMenu(' + row.MenuId + ')" data-toggle="tooltip" title="Edit"><i class="fa fa-edit"></i></button>';
                            if (row.IsActive) {
                                html += '&nbsp;<button type="button" data-toggle="tooltip" class="btn btn-sm btn-success"' + 'onclick="changeMenuStatus(' + row.MenuId + ')"  title="DeActivate"><i class="fa fa-check"></i></button>';
                            }
                            else {
                                html += '&nbsp;<button type="button" data-toggle="tooltip" class="btn btn-sm btn-danger"' + 'onclick="changeMenuStatusActive(' + row.MenuId + ')"  title="Activate"><i class="fa fa-ban"></i></button>';
                            }

                            html += '</div>'
                            return html;
                        }
                    },
                ],
                "drawCallback": function (settings) {
                    var api = this.api();
                    var rows = api.rows({ page: 'current' }).nodes();
                    var last = null;
                    api.column(2, { page: 'current' }).data().each(function (group, i) {
                        if (last !== group) {
                            $(rows).eq(i).before(
                                '<tr class="group"><td colspan="10">' + group.formatWithSpace() + '</td></tr>'
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
$("#btnCloseEditMenu").click(function () {
    $("#updateNavigationMenu").modal('hide');
    $("#txtMenuNameEdit").removeClass('error-validation');
    $("#txtActionNameEdit").removeClass('error-validation');
    $("#txtSequenceScrollEdit").removeClass('error-validation');
    $("#txtControllerNameEdit").removeClass('error-validation');
    $(".select2-selection").removeClass('error-validation');
});


function editMenu(menuId) {
    _MenuId = menuId;

    $("#divIsParentMenuEdit").show();
    $("#divIsNewMenuEdit").hide();
    $('#menuTypeEdit').prop('checked', false);
    $(".toggle").addClass("off");
    $(".toggle").removeClass("on");

    $("#menuTypeEdit").change(function () {
        if ($("#menuTypeEdit").is(':checked')) {

            $("#divIsNewMenuEdit").show();
            $("#divIsParentMenuEdit").hide();

        }
        else {
            $("#divIsNewMenuEdit").hide();
            $("#divIsParentMenuEdit").show();
            bindControllerDropdown("parentControllerScrollEdit", 0);

        }
    });
    var jsonObject = {
        menuId: menuId,
        userAbrhs: misSession.userabrhs
    };

    calltoAjax(misApiUrl.getMenus, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#txtMenuNameEdit").val(resultData.MenuName);
            $("#txtActionNameEdit").val(resultData.ActionName);
            bindControllerDropdown("parentControllerScrollEdit", resultData.ControllerName);
            $("#CSSClassEdit").val(resultData.CSSClass);
            $("#txtSequenceScrollEdit").val(resultData.Sequence);
            $("#IsLinkEnabledEdit").prop('checked', resultData.IsLinkEnabled);
            $("#IsMenuVisibleEdit").prop('checked', resultData.IsMenuVisible);
            $("#IsDelegatableEdit").prop('checked', resultData.IsDelegatable);
            $("#IsTabMenuEdit").prop('checked', resultData.IsTabMenu);
            $("#updateNavigationMenu").modal('show');
        });

}
function changeMenuStatus(menuId) {
    misConfirm("Are you sure you want to deactivate the navigation menu ?", "Confirm", function (isConfirmed) {
        if (isConfirmed) {
            var JsonObject = {
                menuId: menuId
            };
            calltoAjax(misApiUrl.changeMenuStatus, "POST", JsonObject,
                function (result) {
                    if (result === 2) {
                        misAlert("Navigation Menu has been deactivated successfully.", "Success", "success");
                        loadNavigationMenuGrid();
                    }
                    else {
                        misAlert("Request failed to process", "Danger", "danger");
                        loadNavigationMenuGrid();

                    }
                });
        }
    });
}
function changeMenuStatusActive(menuId) {
    misConfirm("Are you sure you want to activate the navigation menu ?", "Confirm", function (isConfirmed) {
        if (isConfirmed) {
            var JsonObject = {
                menuId: menuId
            };
            calltoAjax(misApiUrl.changeMenuStatus, "POST", JsonObject,
                function (result) {
                    if (result === 1) {
                        misAlert("Navigation Menu has been activated successfully.", "Success", "success");
                        loadNavigationMenuGrid();
                    }
                    else {
                        misAlert("Request failed to process", "Danger", "danger");
                        loadNavigationMenuGrid();

                    }
                });
        }
    });
}
$("#btnUpdate").click(function () {

    var IsLinkEnabled = false;
    var IsMenuVisible = false;
    var IsDelegatable = false;
    var IsTabMenu = false;
    if ($("#menuTypeEdit").is(':checked'))
        var currentName = $("#txtControllerNameEdit").val();
    else
        currentName = $("#parentControllerScrollEdit").val();
    if ($("#IsLinkEnabledEdit").is(':checked'))
        IsLinkEnabled = true;
    if ($("#IsMenuVisibleEdit").is(':checked'))
        IsMenuVisible = true;
    if ($("#IsDelegatableEdit").is(':checked'))
        IsDelegatable = true;
    if ($("#IsTabMenuEdit").is(':checked'))
        IsTabMenu = true;

    var jsonObject = {
        MenuId: _MenuId,
        MenuName: $("#txtMenuNameEdit").val(),
        ActionName: $("#txtActionNameEdit").val(),
        ControllerName: currentName,

        Sequence: $("#txtSequenceScrollEdit").val(),
        IsLinkEnabled: IsLinkEnabled,
        IsMenuVisible: IsMenuVisible,
        CssClass: $("#CSSClassEdit").val(),
        IsDelegatable: IsDelegatable,
        IsTabMenu: IsTabMenu,
        userAbrhs: misSession.userabrhs
    };
    calltoAjax(misApiUrl.updateMenus, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            switch (resultData) {
                case 1:
                    misAlert("Menu has been updated successfully", "Success", "success");
                    $("#updateNavigationMenu").modal('hide');
                    loadNavigationMenuGrid();
                    break;
                case 2:
                    misAlert("Menu does not Exist.", "Warning", "warning");
                    break;
            }
        });
});


$("#btnCloseAddMenu").click(function () {
    $("#mypopupAddNavigationMenu").modal("hide");
    $("#txtMenuName").removeClass('error-validation');
    $("#txtActionName").removeClass('error-validation');
    $("#txtSequenceScroll").removeClass('error-validation');
    $("#txtControllerName").removeClass('error-validation');
    $(".select2-selection").removeClass('error-validation');

});
$("#btnClose").click(function () {
    $("#mypopupAddNavigationMenu").modal("hide");
    $("#txtMenuName").removeClass('error-validation');
    $("#txtActionName").removeClass('error-validation');
    $("#txtSequenceScroll").removeClass('error-validation');
    $("#txtControllerName").removeClass('error-validation');
    $(".select2-selection").removeClass('error-validation');

});

