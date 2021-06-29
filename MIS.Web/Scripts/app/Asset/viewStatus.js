var _requestId;

$(document).ready(function () {
    formAssetStatusGrid();
});

function formAssetStatusGrid() {
    var jsonObject = {
        userAbrhs: misSession.userabrhs,
    };
    calltoAjax(misApiUrl.getAllAssetRequest, "POST", jsonObject,
        function (result) {
            var resultdata = $.parseJSON(JSON.stringify(result));
            $("#tblAssetStatusGrid").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                 {
                     filename: 'All Asset Request',
                     extend: 'collection',
                     text: 'Export',
                     buttons: [{ extend: 'copy' },
                                { extend: 'excel', filename: 'All Asset Request' },
                                { extend: 'pdf', filename: 'All Asset Request' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                                { extend: 'print', filename: 'All Asset Request' },
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
                        "mData": "Asset",
                        "sTitle": "Asset",
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
                        "mData": "Status",
                        "sTitle": "Status",
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        "sClass": "text-center",                        
                        mRender: function (data, type, row) {
                            var html = '<div>';
                            if (row.StatusId == 3)
                                html += '<button type="button" data-toggle="tooltip" title="Return"  class="btn btn-sm btn-success"' + 'onclick="returnDongleByUser(' + row.RequestId + ',\'' + row.AllocatedDate + '\')"><i class="fa fa-check" aria-hidden="true"></i></button>';
                                //html += '<button type="button" data-toggle="tooltip" class="btn btn-sm btn-success"' + 'onclick="returnDongleByUser(' + row.RequestId + ')">Return</button>';
                            else
                                html += 'NA';//row.Status;
                            html += '</div>';
                            return html;
                        }
                    },
                ]
            });
        });
}

function returnDongleByUser(requestId, allocatedDate) {
    $("#modal-returnAssetByUser").modal('show');
    //$("#dongleReturnDate").datepicker();
    $('#dongleReturnDate').datepicker({ autoclose: true, todayHighlight: true }).datepicker('setEndDate', new Date());//datepicker('setStartDate', allocatedDate)

    $("#dongleAllocatedDate").val(allocatedDate);
    $("#hdnAssetRequestId").val(requestId);
}

function returnAssetByUser() {
    if (!validateControls('returnAssetContainer')) {
        return false;
    }
    var jsonObject = {
        requestId: $("#hdnAssetRequestId").val(),
        returnDate: $("#dongleReturnDate").val(),
        userAbrhs: misSession.userabrhs,
    };

    calltoAjax(misApiUrl.returnAssetByUser, "POST", jsonObject,
            function (result) {
                var resultData = $.parseJSON(JSON.stringify(result));
                if (resultData == 1) {
                    misAlert("Request processed successfully", "Success", "success");
                    formAssetStatusGrid();
                    $("#modal-returnAssetByUser").modal('hide');
                }
                else if(resultData == 2)
                    misAlert("Return date cannot be prior to allocated date", "Warning", "warning");
                else
                    misAlert("Unable to process request. Try again", "Error", "error");
            });
}

$("#btnClose").click(function () {
    $("#modal-returnAssetByUser").modal('hide');
});