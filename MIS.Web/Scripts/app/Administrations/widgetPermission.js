$(function () {
    $('#permissionType').prop('checked', true);
    loadManageWidgetRolePermission();
    $("#permissionType").change(function () {
        if ($("#permissionType").is(':checked')) {
            loadManageWidgetRolePermission();
        }
        else {
            loadManageWidgetUserPermission();
        }
    });
});

//Widget Role Permissions
function loadManageWidgetRolePermission() {
    loadUrlToId(misAppUrl.manageWidgetRolePermission, 'partialPermissionContainer');
}

//Widget User Permissions
function loadManageWidgetUserPermission() {
    loadUrlToId(misAppUrl.manageWidgetUserPermission, 'partialPermissionContainer');
}