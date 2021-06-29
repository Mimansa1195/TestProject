$(function () {
    loadUnlockUserAccountGrid();
});

function loadUnlockUserAccountGrid() {
    calltoAjax(misApiUrl.getLockedUsersList, "GET", '',
    function (result) {
        var resultdata = $.parseJSON(JSON.stringify(result));
        $("#lockedUsersGrid").dataTable({
            "dom": 'lBfrtip',
            "buttons": [
             {
                 filename: 'Locked Users List',
                 extend: 'collection',
                 text: 'Export',
                 buttons: [{ extend: 'copy' },
                            { extend: 'excel', filename: 'Locked Users List' },
                            { extend: 'pdf', filename: 'Locked Users List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                            { extend: 'print', filename: 'Locked Users List' },
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
            "aaData": resultdata,
            "aoColumns": [
                {
                    "mData": "UserName",
                    "sTitle": "User Name",
                },
                {
                    "mData": null,
                    "sTitle": "Action",
                    "sWidth": "100px",
                    'bSortable': false,
                    mRender: function (data, type, row) {
                        var html = '';
                        if (misPermissions.hasModifyRights === true) {
                            html += '<button type="button" class="btn btn-sm teal" onclick=\'unlockUserAccount("' + row.EmployeeAbrhs + '", "' + row.UserName + '")\' data-toggle="tooltip" title="Unlock User"><i class="font-icon glyphicon glyphicon-send"></i></button>';
                        }
                        return html;
                    }
                }
            ]
        });
    });
}

function unlockUserAccount(empAbrhs, empName) {
    var jsonObject = {
        employeeAbrhs: empAbrhs
    };
    misConfirm("Are you sure you want to unlock the account !", "Confirm", function (isConfirmed) {
        if (isConfirmed) {
            calltoAjax(misApiUrl.unlockUser, "POST", jsonObject,
            function (result) {
                if (result === true) {
                    misAlert(("Account has been unlocked successfully for " + empName), "Success", "success");
                    loadUnlockUserAccountGrid();
                }
                else {
                    misAlert(("Failed to unlock account for " + empName), "Error", "error");
                }
            });
        }
    });
}