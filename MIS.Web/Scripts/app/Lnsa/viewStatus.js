$(document).ready(function () {
    formLnsaStatusGrid();
});

function formLnsaStatusGrid() {
    var jsonObject = {
        userAbrhs: misSession.userabrhs,
    };
    calltoAjax(misApiUrl.getAllLnsaRequest, "POST", jsonObject,
        function (result) {
            var resultdata = $.parseJSON(JSON.stringify(result));
            $("#tblLnsaStatusGrid").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'All Lnsa Request List',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'All Lnsa Request List' },
                        { extend: 'pdf', filename: 'All Lnsa Request List' },
                        { extend: 'print', filename: 'All Lnsa Request List' },
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
                        "mData": "FromDate",
                        "sTitle": "From Date",
                        "sWidth": "80px",
                    },
                    {
                        "mData": "TillDate",
                        "sTitle": "Till Date",
                        "sWidth": "80px",
                    },
                    {
                        "mData": "NoOfDays",
                        "sTitle": "No Of Days",
                        "sWidth": "50px",
                    },
                    {
                        "mData": "Reason",
                        "sTitle": "Reason",
                        "sWidth": "150px",
                    },
                    {
                        "mData": null,
                        "sWidth": "150px",
                        "sTitle": "Status/Remark",
                        mRender: function (data, type, row) {
                            var html = '<a  onclick="showRemarksPopupForLNSARequest(' + row.RequestId + ', ' + "'LNSAREQUEST'" + ')" >' + (row.Status === null ? "N.A" : row.Status) + '</a>';
                            return html;
                        }
                    },
                    {
                        "mData": "ApplyDate",
                        "sTitle": "Requested On",
                        "sWidth": "150px",
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        "sWidth": "80px",
                        mRender: function (data, type, row) {
                            var can = 1;
                            var html = '<div>';
                            if (data.StatusCode !== "AP" && data.IsCancellable === true) {
                                html = '<button type="button" class="btn btn-sm btn-info" onclick="getDateToCancelLnsaRequest(' + row.RequestId + ',' + can + ')" data-toggle="tooltip" title="View & Cancel"><i class="fa  fa-eye"></i></button>';
                                html += '&nbsp;<button type="button" class="btn btn-sm btn-danger"  onclick="cancelAllLnsaRequest(' + row.RequestId + ')" data-toggle="tooltip" title="Cancel request"><i class="fa fa-times"> </i></button>';
                            }
                            else {
                                html = '<button type="button" class="btn btn-sm btn-info" onclick="getDateToCancelLnsaRequest(' + row.RequestId + ',' + can + ')" data-toggle="tooltip" title="View "><i class="fa  fa-eye"></i></button>';
                            }
                            return html;
                        }
                    },

                ],
                "fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                    if (aData.StatusCode === "CA") {
                        $('td', nRow).css('background-color', '#c2cbd2');
                    }
                    else if (aData.StatusCode === "RJ") {
                        $('td', nRow).css('background-color', '#f3a0a0');
                    }
                    else if (aData.StatusCode === "AP") {
                        $('td', nRow).css('background-color', '#99ff99');
                    }
                }
            });
        });
}

var dtTable;

function showRemarksPopupForLNSARequest(lnsaRequestId, type) {
    var jsonObject = {
        requestId: lnsaRequestId,
        type: type,
    };
    calltoAjax(misApiUrl.getApproverRemarks, "POST", jsonObject,
        function (result) {
            if (result !== "ERROR") {
                if (result === "") {
                    result = "NA";
                }
                $("#viewLnsaStatusRemark").val(result);
                $("#viewLnsaStatusRemark").attr('disabled', true);
                $("#mypopupviewLnsaStatusRemark").modal("show");
            }
        });
}

function getDateToCancelLnsaRequest(lnsaRequestId, can) {
    var jsonObject = {
        lnsaRequestId: lnsaRequestId
    }
    calltoAjax(misApiUrl.getDateToCancelLnsaRequest, "POST", jsonObject,
        function (result) {
            var ReqData = [];
            var count = 0;
            ReqData = getAllMatchedObject({ 'IsCancellable': true }, result);
            count = ReqData.length;

            if (count === 0 && can === 0) {
                $("#dateLnsaModal").modal('hide');
                formLnsaStatusGrid();
            }
            if (count === 0 && can === 1) {
                $("#dateLnsaModal").modal('show');
            }

            var data = $.parseJSON(JSON.stringify(result));
            dtTable = $("#tblLnsaData").DataTable({
                "responsive": true,
                //"autoWidth": true,
                "paging": false,
                // "lengthMenu": [[5, 10, 20, -1], [5, 10, 20, "All"]],
                //"pageLength": 5,
                "scrollY": "200px",
                "scrollCollapse": true,
                "bDestroy": true,
                "ordering": true,
                "order": [],
                "info": false,
                "deferRender": true,
                "aaData": data,
                "searching": false,
                "aoColumns": [
                    {
                        "mData": "Date",
                        "sTitle": "Date",
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
                                html += '<button type="button" class="btn btn-sm btn-danger" /*data-toggle"model" data-target="#myModal"*/' + 'onclick="cancelLnsaRequest(' + lnsaRequestId + ',' + "'CA'" + ',' + row.LnsaRequestDetailId + ')" data-toggle="tooltip" title="Cancel"><i class="fa fa-times"></i></button>';
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
            setTimeout(resizeDataTable, 200);
        });
}

function resizeDataTable() {
    $("#tblLnsaData").DataTable().order([[1, 'asc']]).draw(false);
}

function cancelLnsaRequest(lnsaRequestId, status, lnsaRequestDetailId) {
    var reply = misConfirm("Are you sure you want to cancel this request ?", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                lnsaRequestId: lnsaRequestId,
                status: status,
                action: "Single",
                userAbrhs: misSession.userabrhs,
                lnsaRequestDetailId: lnsaRequestDetailId
            };
            calltoAjax(misApiUrl.cancelLnsaRequest, "POST", jsonObject,
                function (result) {
                    if (result === 1) {
                        var can = 0;
                        getDateToCancelLnsaRequest(lnsaRequestId, can);
                        misAlert("LNSA request has been cancelled successfully.", "Success", "success");
                    }
                    else if (result === 2) {
                        misAlert('Your request can not be processed. Please contact MIS Team.', "Warning", "warning");
                    }
                    else {
                        misAlert("Unable to process request, please try again.", "Error", "error");
                    }
                });
        }
    });
}

function cancelAllLnsaRequest(lnsaRequestId) {
    var reply = misConfirm("Are you sure you want to cancel this request ?", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                lnsaRequestId: lnsaRequestId,
                status: "CA",
                action: 'All',
                userAbrhs: misSession.userabrhs,
            };
            calltoAjax(misApiUrl.cancelAllLnsaRequest, "POST", jsonObject,
                function (result) {
                    if (result === 1) {
                        formLnsaStatusGrid();
                        misAlert("LNSA request has been cancelled successfully.", "Success", "success");
                    }
                    else if (result === 2) {
                        misAlert('Your request can not be processed. Please contact MIS Team.', "Warning", "warning");
                    }
                    else
                        misAlert("Unable to process request, please try again.", "Error", "error");
                });
        }
    });
}

$("#btnViewLnsaClose").click(function () {
    $("#mypopupviewLnsaStatusRemark").modal("hide");
});