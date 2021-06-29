$(document).ready(function () {
    $('#assetTag').select2();
    getPendingAllocationRequest();
    getAssetCount();
});

function getPendingRetunRequest() {
    var jsonObject = {
        statusId: 4,//3,
        userAbrhs: misSession.userabrhs,
    };
    calltoAjax(misApiUrl.getAssetDetailsForITDepartment, "POST", jsonObject,
        function (result) {
            var resultdata = $.parseJSON(JSON.stringify(result));
            $("#tblPendingReturnGrid").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'Asset Details For IT Department',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'Asset Details For IT Department' },
                        { extend: 'pdf', filename: 'Asset Details For IT Department' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                        { extend: 'print', filename: 'Asset Details For IT Department' },
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
                        "mData": "UserReturnDate",
                        "sTitle": "Return By User Date ",
                    },
                    {
                        "mData": "Department",
                        "sTitle": "Department",
                    },
                    {
                        "mData": "Reason",
                        "sTitle": "Reason",
                    },
                    {
                        "mData": "AssetTag",
                        "sTitle": "Tag",
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
                            html += '<div><button type="button" data-toggle="tooltip" title="Acknowledge"  class="btn btn-sm btn-success"' + 'onclick="returnDongle(' + row.RequestId + ')"><i class="fa fa-check" aria-hidden="true"></i></button>' +
                                '&nbsp<button type="button" data-toggle="tooltip" title="Decline"  class="btn btn-sm btn-danger"' + 'onclick="rejectAssetRequest(' + row.RequestId + ',6' + ')"><i class="fa fa-times" aria-hidden="true"></i></button></div>';
                            return html;
                        }
                    },
                ]
            });
        });
}

function getDeclinedRequest() {
    var jsonObject = {
        statusId: 6,//3,
        userAbrhs: misSession.userabrhs,
    };
    calltoAjax(misApiUrl.getAssetDetailsForITDepartment, "POST", jsonObject,
        function (result) {
            var resultdata = $.parseJSON(JSON.stringify(result));
            $("#tblDeclinedAssets").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'Asset Details For IT Department',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'Asset Details For IT Department' },
                        { extend: 'pdf', filename: 'Asset Details For IT Department' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                        { extend: 'print', filename: 'Asset Details For IT Department' },
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
                        "mData": "Department",
                        "sTitle": "Department",
                    },
                    {
                        "mData": "Reason",
                        "sTitle": "Reason",
                    },
                    {
                        "mData": "AssetTag",
                        "sTitle": "Tag",
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        "sClass": "text-center",
                        "sWidth": "140px",
                        mRender: function (data, type, row) {
                            var html = '';
                            html += '<div><button type="button" data-toggle="tooltip" title="Acknowledge"  class="btn btn-sm btn-success"' + 'onclick="returnDongle(' + row.RequestId + ')">Acknowledge</button></div>'
                            return html;
                        }
                    },
                ]
            });
        });
}

function returnDongle(requestId) {
    loadModal("modal-returnAsset", "modal-returnAssetContainer", misAppUrl.returnAsset, true);
    $("#hdnAssetRequestId").val(requestId);
}

function returnAsset() {
    if (!validateControls('modal-returnAsset')) {
        return false;
    }
    var jsonObject = {
        transactionId: $("#hdnTransactionId").val(),
        returnDate: $("#dongleReturnDate").val(),
        userAbrhs: misSession.userabrhs,
    };

    calltoAjax(misApiUrl.returnAsset, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            if (resultData) {
                misAlert("Request processed successfully", "Success", "success");
                getPendingRetunRequest();
                getDeclinedRequest();
                getAssetCount();
                $("#modal-returnAsset").modal('hide');
            }
            else
                misAlert("Unable to process request. Try again", "Error", "error");
        });
}

function getPendingAllocationRequest() {
    var jsonObject = {
        statusId: 2,
        userAbrhs: misSession.userabrhs,
    };
    calltoAjax(misApiUrl.getAssetDetailsForITDepartment, "POST", jsonObject,
        function (result) {
            var resultdata = $.parseJSON(JSON.stringify(result));
            $("#tblPendingAllocationGrid").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'Asset Details For IT Department',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'Asset Details For IT Department' },
                        { extend: 'pdf', filename: 'Asset Details For IT Department' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                        { extend: 'print', filename: 'Asset Details For IT Department' },
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
                        "mData": "Department",
                        "sTitle": "Department",
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
                            html += '<button type="button" data-toggle="tooltip" title="Allocate"  class="btn btn-sm btn-success"' + 'onclick="takeActionOnAssetRequest(' + row.RequestId + ',3' + ')"><i class="fa fa-check" aria-hidden="true"></i></button>' +
                                '&nbsp<button type="button" data-toggle="tooltip" title="Reject"  class="btn btn-sm btn-danger"' + 'onclick="rejectAssetRequest(' + row.RequestId + ',0' + ')"><i class="fa fa-times" aria-hidden="true"></i></button></div>';
                            return html;
                        }
                    },
                ]
            });
        });
}

function rejectAssetRequest(requestId, statusId) {
    if (statusId == 0)
        var reply = misConfirm("Are you sure you want to reject request", "Confirm", function (reply) {
            if (reply)
                takeActionOnAssetRequest(requestId, statusId);
        });
    else
        var reply = misConfirm("Are you sure you want to decline request", "Confirm", function (reply) {
            if (reply)
                takeActionOnAssetRequest(requestId, statusId);
        });
}

function takeActionOnAssetRequest(requestId, statusId) {
    if (statusId == 3) {
        loadModal("modal-allocateAsset", "modal-allocateAssetContainer", misAppUrl.allocateAsset, true);
        $("#hdnAllocateAssetRequestId").val(requestId);

        $('#assetTag').empty();
        $("#assetTag").append("<option value='0'>Select</option>");

        calltoAjax(misApiUrl.getAvailableAssetTag, "POST", jsonObject,
            function (result) {
                console.log(result);
                $.each(result, function (index, result) {
                    $("#assetTag").append("<option value=" + result + ">" + result + "</option>");
                });
            });

    }
    else {
        var jsonObject = {
            requestId: requestId,//$("#hdnAllocateAssetRequestId").val(),
            statusId: statusId,
            userAbrhs: misSession.userabrhs,
        }
        calltoAjax(misApiUrl.takeActionOnAssetRequest, "POST", jsonObject,
            function (result) {
                var resultData = $.parseJSON(JSON.stringify(result));
                if (resultData) {
                    misAlert("Request processed successfully", "Success", "success");
                    getPendingAllocationRequest();
                    getPendingRetunRequest();
                    getAssetCount();
                }
                else {
                    misAlert("Unable to process request. Try again", "Error", "error");
                }
            });
    }
}

function allocateAsset() {
    if (!validateControls('modal-allocateAsset')) {
        return false;
    }

    var jsonObject = {
        requestId: $("#hdnAllocateAssetRequestId").val(),
        assetDetailId: _assetDetailId,
        userAbrhs: misSession.userabrhs,
    }
    calltoAjax(misApiUrl.allocateAsset, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            if (resultData) {
                misAlert("Request processed successfully", "Success", "success");
            }
            else {
                misAlert("Unable to process request. Try again", "Error", "error");
            }
            $("#modal-allocateAsset").modal('hide');

            getPendingAllocationRequest();
            getAssetCount();
        });
}

function onAssetTagChange() {
    if ($("#assetTag").val() == 0) {
        $("#hiddenAssetDetail").hide();
        return false;
    }

    var jsonObject = {
        assetTag: $("#assetTag").val()
    }
    calltoAjax(misApiUrl.getAssetDetailOnBasisOfAssetTag, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            if (resultData == null) {
                $("#hiddenAssetDetail").hide();
                misAlert("Invalid tag. Try again", "Error", "error");
            }
            else {
                if (resultData.IsIssued == true) {
                    $("#hiddenAssetDetail").hide();
                    misAlert("This dongle is already issues. Try another asset tag", "Warning", "warning");
                }
                else {
                    _assetDetailId = resultData.AssetDetailId;
                    $("#assetSerialNo").val(resultData.SerialNumber);
                    $("#assetSimNo").val(resultData.SimNumber);
                    $("#assetMake").val(resultData.Make);
                    $("#assetModel").val(resultData.Model);
                    $("#hiddenAssetDetail").show();
                }
            }
        });
}

//$('#assetTag').keypress(function (e) {
//    var key = e.which;
//    if (key == 13)  // the enter key code
//    {
//        var jsonObject = {
//            assetTag: $("#assetTag").val()
//        }
//        calltoAjax(misApiUrl.getAssetDetailOnBasisOfAssetTag, "POST", jsonObject,
//            function (result) {
//                var resultData = $.parseJSON(JSON.stringify(result));
//                if (resultData == null) {
//                    $("#hiddenAssetDetail").hide();
//                    misAlert("Invalid tag. Try again", "Error", "error");
//                }
//                else {
//                    if (resultData.IsIssued == true) {
//                        $("#hiddenAssetDetail").hide();
//                        misAlert("This dongle is already issues. Try another asset tag", "Warning", "warning");
//                    }
//                    else {
//                        _assetDetailId = resultData.AssetDetailId;
//                        $("#assetSerialNo").val(resultData.SerialNumber);
//                        $("#assetSimNo").val(resultData.SimNumber);
//                        $("#assetMake").val(resultData.Make);
//                        $("#assetModel").val(resultData.Model);
//                        $("#hiddenAssetDetail").show();
//                    }
//                }
//            });
//    }
//});

$("#btnClose").click(function () {
    $("#modal-allocateAsset").modal('hide');
});

function getAssetCount() {
    calltoAjax(misApiUrl.getAllAssetCountData, "POST", '',
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#tblAssetCount").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'All Asset Count Data',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'All Asset Count Data' },
                        { extend: 'pdf', filename: 'All Asset Count Data' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                        { extend: 'print', filename: 'All Asset Count Data' },
                        ]
                    }
                ],
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