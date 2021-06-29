$(document).ready(function () {
    getPendingAssetRequest();
    getAssetCount();
});

function getAssetCount() {
    var jsonObject = {
        userAbrhs: misSession.userabrhs
    }
    calltoAjax(misApiUrl.getAssetCountDataByManagerId, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#tblAssetCount").dataTable({
                "responsive": true,
                "autoWidth": false,
                "paging": false,
                "bDestroy": true,
                "searching": false,
                "ordering": false,
                "info": false,
                "deferRender": true,
                "aaData": resultData,
                "aoColumns": [
                    {
                        "mData": "AllotedToDepartment",
                        "sTitle": "Alloted to department",
                    },
                    {
                        "mData": "AllocatedToDepartment",
                        "sTitle": "Allocated to department",
                    },
                    {
                        "mData": "AllocatedToParentTeam",
                        "sTitle": "Allocated to team",
                    },
                    //{
                    //    "mData": "AllocatedToSubTeam",
                    //    "sTitle": "Allocated to sub team",
                    //},
                    {
                        "mData": "DeptWisePercentageAllocation",
                        "sTitle": "% Allocation<br />(Dept wise)",
                    }
                ]
            });
        });
}

function getPendingAssetRequest() {
    var jsonObject = {
        statusId: 1,
        userAbrhs: misSession.userabrhs,
    };
    calltoAjax(misApiUrl.getAssetDetailsForReportingManager, "POST", jsonObject,
        function (result) {
            var resultdata = $.parseJSON(JSON.stringify(result));
            $("#tblPendingAssetGrid").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                 {
                     filename: 'Asset Details For Manager',
                     extend: 'collection',
                     text: 'Export',
                     buttons: [{ extend: 'copy' },
                                { extend: 'excel', filename: 'Asset Details For Manager' },
                                { extend: 'pdf', filename: 'Asset Details For Manager' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                                { extend: 'print', filename: 'Asset Details For Manager' },
                     ]
                 }
                ],
                "responsive": true,
                "autoWidth": false,
                "paging": true,
                "bDestroy": true,
                "ordering": true,
                "order": [], // disable default sorting
                "info": true,
                "deferRender": true,
                "aaData": resultdata,
                "aoColumns": [
                    {
                        "mData": "EmployeeName",
                        "sTitle": "Employee Name",
                    },
                    {
                        "mData": "IssueFromDate",
                        "sTitle": "Issue From Date",
                    },
                    {
                        "mData": "ReturnDueDate",
                        "sTitle": "Return Due Date",
                    },
                    {
                        "mData": "Reason",
                        "sTitle": "Reason",
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        "sClass": "text-center",
                        "sWidth": "140px",
                        mRender: function (data, type, row) {
                            var html = '';
                            //if (misPermissions.hasApproveRights === true)
                            html += '<div><button type="button" data-toggle="tooltip" title="Approve"  class="btn btn-sm btn-success"' + 'onclick="takeActionOnAssetRequest(' + row.RequestId + ',2' + ')"><i class="fa fa-check" aria-hidden="true"></i></button>' +
                                    '&nbsp<button type="button" data-toggle="tooltip" title="Reject"  class="btn btn-sm btn-danger"' + 'onclick="rejectAssetRequest(' + row.RequestId + ',-1' + ')"><i class="fa fa-times" aria-hidden="true"></i></button></div>';
                            return html;
                        }
                    },
                ]
            });
        });
}

function rejectAssetRequest(requestId, statusId) {
    var reply = misConfirm("Are you sure you want to reject request", "Confirm", function (reply) {
        if (reply)
            takeActionOnAssetRequest(requestId, statusId);
    });
}

function takeActionOnAssetRequest(requestId, statusId) {
    var jsonObject = {
        requestId: requestId,
        statusId: statusId,
        userAbrhs: misSession.userabrhs,
    };
    calltoAjax(misApiUrl.takeActionOnAssetRequest, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            //console.log(resultData);
            if (resultData) {
                misAlert("Request processed successfully", "Success", "success");
                getPendingAssetRequest();
            }
            else
                misAlert("Unable to process request. Please try again !", "Error", "error");
        });
}

function getApprovedRequest() {
    var jsonObject = {
        statusId: 2,
        userAbrhs: misSession.userabrhs,
    };
    calltoAjax(misApiUrl.getAssetDetailsForReportingManager, "POST", jsonObject,
        function (result) {
            var resultdata = $.parseJSON(JSON.stringify(result));
            $("#tblApprovedAssetGrid").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                 {
                     filename: 'Asset Details For Manager',
                     extend: 'collection',
                     text: 'Export',
                     buttons: [{ extend: 'copy' },
                                { extend: 'excel', filename: 'Asset Details For Manager' },
                                { extend: 'pdf', filename: 'Asset Details For Manager' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                                { extend: 'print', filename: 'Asset Details For Manager' },
                     ]
                 }
                ],
                "responsive": true,
                "autoWidth": false,
                "paging": true,
                "bDestroy": true,
                "ordering": true,
                "order": [], // disable default sorting
                "info": true,
                "deferRender": true,
                "aaData": resultdata,
                "aoColumns": [
                    {
                        "mData": "EmployeeName",
                        "sTitle": "Employee Name",
                    },
                    {
                        "mData": "IssueFromDate",
                        "sTitle": "Issue From Date",
                    },
                    {
                        "mData": "ReturnDueDate",
                        "sTitle": "Return Due Date",
                    },
                    {
                        "mData": "Reason",
                        "sTitle": "Reason",
                    },
                    //{
                    //    "mData": null,
                    //    "sTitle": "Action",
                    //    'bSortable': false,
                    //    "sClass": "text-center",
                    //    "sWidth": "140px",
                    //    mRender: function (data, type, row) {
                    //        var html = '';
                    //        //if (misPermissions.hasApproveRights === true)
                    //        html += '<div><button type="button" data-toggle="tooltip" title="Revoke"  class="btn btn-sm btn-danger"' + 'onclick="takeActionOnAssetRequest(' + row.RequestId + ',-1' + ')">Revoke</button></div>';
                    //        return html;
                    //    }
                    //},
                ]
            });
        });
}