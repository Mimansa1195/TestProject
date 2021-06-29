$(function () {
    $('#permissionType').prop('checked', true);
    loadManageRolePermission();
    $("#permissionType").change(function () {
        if ($("#permissionType").is(':checked')) {
            loadManageRolePermission();
        }
        else {
            loadManageUserPermission();
        }
    });
});

//Menu Role Permissions
function loadManageRolePermission() {
    loadUrlToId(misAppUrl.manageRolePermission, 'partialPermissionContainer');
}

//Menu User Permissions
function loadManageUserPermission() {
    loadUrlToId(misAppUrl.manageUserPermission, 'partialPermissionContainer');
}