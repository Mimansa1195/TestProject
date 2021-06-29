
function loadApplyOutingRequestGrid(year) {
    var jsonObject = {
        'employeeAbrhs': misSession.userabrhs,
        year: year
    };
    calltoAjax(misApiUrl.listApplyOutingRequest, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblOnDutyReqHistory").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel' },
                        { extend: 'pdf' },
                        { extend: 'print' },
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
                "aaData": data,
                "aoColumns": [
                    {
                        "mData": "Period",
                        "sTitle": "Period",
                        "sWidth": "150px",
                        "className": "all"
                    },
                    {
                        "mData": "OutingType",
                        "sTitle": "Duty Type",
                        "sWidth": "90px",
                    },
                    {
                        "mData": "Reason",
                        "sTitle": "Reason",
                        "sWidth": "90px",
                    },
                    {
                        "mData": null,
                        "sTitle": "Remarks",
                        "sWidth": "100px",
                        mRender: function (data, type, row) {
                            var html = '<a  onclick="showOutingRemarksPopup(' + row.OutingRequestId + ',' + "'OR'" + ')" >' + row.Remarks + '</a>';
                            return html;
                        }
                    },
                    {
                        "mData": "Status",
                        "sTitle": "Status",
                        "sWidth": "150px",
                    },
                    {
                        "mData": "ApplyDate",
                        "sTitle": "Applied On",
                        "sWidth": "80px",
                    },
                    {
                        "mData": null,
                        "sWidth": "80px",
                        "sTitle": "Action",
                        mRender: function (data, type, row) {
                                var can = 1;
                                var html = '<div>';
                                if (data.StatusCode !== "VD" && data.IsCancellable == true) {
                                    html += '<button type="button" class="btn btn-sm btn-info" onclick="getDateToCancelOutingRequest(' + row.OutingRequestId + ',' + can + ')" data-toggle="tooltip" title="View & Cancel"><i class="fa  fa-eye"></i></button>';
                                    html += '&nbsp;<button type="button" class="btn btn-sm btn-danger"  onclick="cancelAllOutingRequest(' + row.OutingRequestId + ')" data-toggle="tooltip" title="Cancel request"><i class="fa fa-times"> </i></button>';
                                }
                                else {
                                    html += '<button type="button" class="btn btn-sm btn-info" onclick="getDateToCancelOutingRequest(' + row.OutingRequestId + ',' + can + ')" data-toggle="tooltip" title="View"><i class="fa  fa-eye"></i></button>';
                                }
                                html += '</div>';
                                    return html;
                            
                           
                        }
                    }
                ],
                "fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                    if (aData.StatusCode === "CA") {
                        $('td', nRow).css('background-color', '#c2cbd2');
                    }
                    else if (aData.StatusCode === "RJM") {
                        $('td', nRow).css('background-color', '#f3a0a0');
                    }
                    else if (aData.StatusCode === "RJH") {
                        $('td', nRow).css('background-color', '#f3a0a0');
                    }
                    else if (aData.StatusCode === "VD") {
                        $('td', nRow).css('background-color', '#99ff99');
                    }
                }
            });
        });
}
function getDateToCancelOutingRequest(outingRequestId, can) {

    var jsonObject = {
        'OutingRequestId': outingRequestId
    }
    calltoAjax(misApiUrl.getDateToCancelOutingRequest, "POST", jsonObject,
        function (result) {
            $("#dateModal").modal('show');
            var ReqData = [];
            var count = 0;
            ReqData = getAllMatchedObject({ 'IsCancellable': true }, result);
            count = ReqData.length;
            if (count === 0 && can === 0) {
                $("#dateModal").modal('hide');
                var yr = $("#financialYearScroll").val();
                loadApplyOutingRequestGrid(yr);
            }
            if (count === 0 && can === 1) {
                $("#dateModal").modal('show');
            }

            var data = $.parseJSON(JSON.stringify(result));
            $("#tblOutingData").dataTable({
                "responsive": true,
                "autoWidth": false,
                "paging": true,
                "lengthMenu": [[5, 10, 20, -1], [5, 10, 20, "All"]],
                "pageLength": 5,
                "bDestroy": true,
                "ordering": true,
                "order": [],
                "info": true,
                "deferRender": true,
                "aaData": data,
                "aoColumns": [
                    {
                        "mData": "DisplayOutingDate",
                        "sTitle": "Outing Date",
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
                            if (data.IsCancellable === true) {
                                var html = '<div>';
                                html += '<button type="button" class="btn btn-sm btn-danger" /*data-toggle"model" data-target="#myModal"*/' + 'onclick="cancelOutingRequest(' + outingRequestId + ',' + "'CA'" + ',' + row.OutingRequestDetailId + ')" data-toggle="tooltip" title="Cancel"><i class="fa fa-times"></i></button>';
                                html += '</div>'
                                return html;
                            }
                            else {
                                html = " ";
                                return html;
                            }
                        }
                    }
                ],
            });
        });
}
function cancelOutingRequest(requestId, status, outingRequestDetailId) {
  
    var reply = misConfirm("Are you sure you want to cancel this request ?", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                'OutingRequestId': requestId,
                'Status': status,
                'Remark': 'Cancelled',
                'UserAbrhs': misSession.userabrhs,
                'OutingRequestDetailId': outingRequestDetailId
            };
            calltoAjax(misApiUrl.cancelOutingRequest, "POST", jsonObject,
                function (result) {
                    if (result === "Cancelled") {
                        var can = 0;
                        getDateToCancelOutingRequest(requestId, can);
                        misAlert("Out Duty/Tour request has been cancelled successfully.", "Success", "success");
                    }
                    else if (result === "Failed") {
                        misAlert("Unable to process request, please try again.", "Error", "error");
                    }
                    else if (result === "Unprocessed") {
                        misAlert("Your request can not be processed. Please contact MIS Team.", "Warning", "warning");
                    }
                });
        }
    });
}
function cancelAllOutingRequest(outingRequestId) {
    var reply = misConfirm("Are you sure you want to cancel this request ?", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                'OutingRequestId': outingRequestId,
                'Status': "CA",
                'Remark': 'Cancelled',
                'UserAbrhs': misSession.userabrhs,
            };
            calltoAjax(misApiUrl.cancelAllOutingRequest, "POST", jsonObject,
                function (result) {
                    if (result === "Cancelled") {
                        var yr = $("#financialYearScroll").val();
                        loadApplyOutingRequestGrid(yr);
                        misAlert("Out Duty/Tour request has been cancelled successfully.", "Success", "success");
                    }
                    else if (result === "Failed") {
                        misAlert("Unable to process request, please try again.", "Error", "error");
                    }
                    else if (result === "Unprocessed") {
                        misAlert("Your request can not be processed. Please contact MIS Team.", "Warning", "warning");
                    }
                });
        }
    });
}
function showOutingRemarksPopup(applicationId, type) {
    var jsonObject = {
        'requestId': applicationId,
        'type': type,
    };
    calltoAjax(misApiUrl.getApproverRemarks, "POST", jsonObject,
        function (result) {
            if (result !== "ERROR") {
                if (result === "") {
                    result = "NA";
                }
                $("#viewOutingStatusRemark").val(result);
                $("#viewOutingStatusRemark").attr('disabled', true);
                $("#mypopupviewOutingStatusRemark").modal("show");
            }
        });
}
$("#btnViewOutingClose").click(function () {
    $("#mypopupviewOutingStatusRemark").modal("hide");
});