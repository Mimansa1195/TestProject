$(document).ready(function () {
    bindDashboardSettings();
})

function bindDashboardSettings() {

    calltoAjaxSync(misApiUrl.getUserRoleDashboardSettings, "POST", '',
    function (result) {
        var resultdata = $.parseJSON(JSON.stringify(result.DashBoardSetting));
        var html = '';
        for (var i = 0; i < resultdata.length; i++) {
            var chk = (resultdata[i].IsActive === true) ? 'checked' : '';
            html += '<tr>'+
                '<td class="sequence">' + (i+1) + '</td>' +
                '<td><input data-attr-DashboardWidgetPermissionId="' + resultdata[i].DashboardWidgetPermissionId + '" data-attr-DashboardWidgetId="' + resultdata[i].DashboardWidgetId + '" id="hdnDashboardWidgetPermissionId' + resultdata[i].DashboardWidgetPermissionId + '" "hdnDashboardWidgetPermissionId' + resultdata[i].DashboardWidgetPermissionId + '" type="hidden" value="' + resultdata[i].DashboardWidgetPermissionId + '" />' + resultdata[i].DashboardWidgetName + '</td>' +
                '<td><input type="checkbox" ' + chk + ' class="chkView" name="chkView' + resultdata[i].DashboardWidgetPermissionId + '" id="chkView' + resultdata[i].DashboardWidgetPermissionId + '"></td>' +
                '</tr>';
        }
        $("#divdashboardvisit").html(html);
    });

    $('#dashBoardSettingGrid').DataTable({
        rowReorder: {
        },
        "responsive": true,
        "paging": false,
        "bDestroy": false,
        "searching": false,
        "info": false,
        "aoColumnDefs": [
            { "bSortable": false, "aTargets": [1,2] }
        ]
    });
}

$("#btnSaveSetting").click(function () {
    updateDashBoardSettings();
})

function updateDashBoardSettings() {
    var permission = function (DashboardWidgetPermissionId, DashboardWidgetId, IsActive, Sequence) {
        this.DashboardWidgetPermissionId = DashboardWidgetPermissionId || 0;
        this.DashboardWidgetId = DashboardWidgetId || 0;
        this.IsActive = IsActive || false;
        this.Sequence = Sequence || 0;
    };

    var dashBoardSettingList = [];
    $('#divdashboardvisit tr').each(function (index, item) {
        var $inputs = $(this).find(':input');
        var rowiDx = '';
        if ($inputs.length > 0) {
            var perObj = new permission();
            $inputs.each(function (idx, itm) {
                var id = $(this)[0].id;
                if ($(this)[0].type == 'hidden') {
                    rowiDx = $(this).val();
                    perObj.DashboardWidgetPermissionId = $(this).attr("data-attr-DashboardWidgetPermissionId");
                    perObj.DashboardWidgetId = $(this).attr("data-attr-DashboardWidgetId");
                }

                if ($(this)[0].type === 'checkbox' && id == 'chkView' + rowiDx) {
                    perObj.IsActive = $(this).is(':checked');
                }
                    perObj.Sequence = item.firstChild.innerHTML;
            });
            dashBoardSettingList.push(perObj);
        }
        else {
            // no chk selected
        }

    });
    var jsonObject = {
        IsUserPermission: true,
        UserAbrhs: misSession.userabrhs,
        DashBoardSetting: dashBoardSettingList
    }
    calltoAjax(misApiUrl.addUpdateDashboardSettings, "POST", jsonObject,
        function (result) {
            if (result == 1) {
                $("#myModalDashBoardSettings").modal("hide");
                misCountdownAlert('Dashboard settings has been saved successfully.', 'Widget Reloading', 'success', function () {
                    redirectToURL(misAppUrl.home);
                }, false, 2);
            }
            else if (result == 2) {
                misError("Unable to save dashboard settings.", 'Warning', 'warning');
            }
            else {
                misAlert();
            }
        });
}

$("#btnCloseDashBoardSettings").click(function () {
    $("#myModalDashBoardSettings").modal("hide");
});