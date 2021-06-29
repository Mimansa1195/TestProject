//var _applicationId, _status, _type, _period, _remark, _applicantId = 0;

var tableCabRequestPending = "";
var rows_selected = [];
var Employee_selected = [];
$(document).ready(function () {
    getCabRequest();
})
function getCabRequest() {
    var jsonObject = {
        UserAbrhs: misSession.userabrhs
    }
    calltoAjax(misApiUrl.getCabReviewRequest, "POST", jsonObject, function (result) {
        if (result.length === 0) {
            bindPendingCabRequest(null);
            bindNonPendingCabRequest(null);
        }
        else {
            var pendingReqData = [], nonPendingReqData = [];
            pendingReqData = getAllMatchedObject({ 'StatusCode': 'PA' }, result);
            nonPendingReqData = getAllUnmatchedObject({ 'StatusCode': 'PA' }, result);
            bindPendingCabRequest(pendingReqData);
            bindNonPendingCabRequest(nonPendingReqData);
        }
    }

    );
}

// Handle click on checkbox
$('body').on('click', '#tblCabReviewRequestPending tbody input[type="checkbox"]', function (e) {
    var $row = $(this).closest('tr');
    // Get row data
    var data = tableCabRequestPending.row($row).data();
    // Get row ID
    var rowId = data[0];
    // Determine whether row ID is in the list of selected row IDs
    var index = $.inArray(rowId, rows_selected);
    // If checkbox is checked and row ID is not in list of selected row IDs
    if (this.checked && index === -1) {
        rows_selected.push(rowId);
        // Otherwise, if checkbox is not checked and row ID is in list of selected row IDs
    } else if (!this.checked && index !== -1) {
        rows_selected.splice(index, 1);
    }
    // Update state of "Select all" control
    updateDataTableSelectAllCtrlUn(tableCabRequestPending);
    // Prevent click event from propagating to parent
    e.stopPropagation();
});

// Handle table draw event
if (tableCabRequestPending) {
    tableCabRequestPending.on('draw', function () {
        // Update state of "Select all" control
        updateDataTableSelectAllCtrlUn(tableCabRequestPending);
    });
}

function updateDataTableSelectAllCtrlUn(tableAssigned) {
    var tableAssigned = tableAssigned.table().node();
    var $chkbox_all = $('tbody input[type="checkbox"]', tableAssigned);
    var $chkbox_checked = $('tbody input[type="checkbox"]:checked', tableAssigned);
    var chkbox_select_all = $('thead input[name="select_all"]', tableAssigned).get(0);

    // If none of the checkboxes are checked
    if ($chkbox_checked.length === 0) {
        chkbox_select_all.checked = false;
        if ('indeterminate' in chkbox_select_all) {
            chkbox_select_all.indeterminate = false;
        }

        // If all of the checkboxes are checked
    } else if ($chkbox_checked.length === $chkbox_all.length) {
        chkbox_select_all.checked = true;
        if ('indeterminate' in chkbox_select_all) {
            chkbox_select_all.indeterminate = false;
        }

        // If some of the checkboxes are checked
    } else {

        chkbox_select_all.checked = true;
        if ('indeterminate' in chkbox_select_all) {
            chkbox_select_all.indeterminate = true;
        }
    }
}


// Handle click on "Select all " control
$('body').on('click', '#cabRequestPending', function (e) {
    if (this.checked) {
        $('input[type="checkbox"]', '#tblCabReviewRequestPending').prop('checked', true);
        var count = $('#tblCabReviewRequestPending tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    } else {
        $('input[type="checkbox"]', '#tblCabReviewRequestPending').prop('checked', false);
        var count = $('#tblCabReviewRequestPending tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    }
    // Prevent click event from propagating to parent
    e.stopPropagation();
})

function showPopupOnBulkCabApprove(status) {

    _statusOnBulkApprove = status;
    var selectedCabRequestIds = [];
    var selectedEmployees = [];
    $("#tblCabReviewRequestPending").dataTable().$('input[type="checkbox"]').each(function () {
        if (this.checked) {
            selectedCabRequestIds.push($(this).val());
            selectedEmployees.push(this.parentNode.nextElementSibling.firstChild.nodeValue.trim());
        }
    });
    selectedEmployees = jQuery.unique(selectedEmployees);
    var Names = selectedEmployees.join();
    _selectedCabRequestIds = selectedCabRequestIds.join();
    $("#employeesNames").html(Names);
    $("#txtRemarkForBulkCabRequest").removeClass("error-validation");
    $("#txtRemarkForBulkCabRequest").val("");
    if (selectedEmployees.length > 0) {
        $("#mypopupBulkApprove").modal("show");
    }
    else {
        misAlert("Please select an employee.", "Warning", "warning");
    }

}

$("#submitCabRequestBulk").click(function () {
    if (!validateControls('mypopupBulkApprove'))
        return false;

    bulkApproveCabRequests(_selectedCabRequestIds, _statusOnBulkApprove);

});


$("#btnCloseBulk").click(function () {
    $("#mypopupBulkApprove").modal("hide");

});

function bindPendingCabRequest(newdata) {

    var html = "<button type='button' class='btn btn-primary' onclick=\"showPopupOnBulkCabApprove('AP')\" > <i class='fa fa-check'></i>&nbsp;Bulk Approve </button>";
    $("#divBulkCabApprove").html(html);

    var data = $.parseJSON(JSON.stringify(newdata));
    $("#tblCabReviewRequestPending").dataTable({
        "dom": 'lBfrtip',
        "buttons": [
            {
                filename: 'OR List',
                extend: 'collection',
                text: 'Export',
                buttons: [{ extend: 'copy' },
                { extend: 'excel', filename: 'OR List' },
                { extend: 'pdf', filename: 'OR List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                { extend: 'print', filename: 'OR List' },
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
                'targets': 0,
                'searchable': false,
                'width': '1%',
                'orderable': false,
                'bSortable': false,
                "sTitle": '<input name="select_all" value="1" id="cabRequestPending" type="checkbox" />',
                'className': 'dt-body-center',
                'render': function (data, type, full, meta) {
                    if (full.Selected) {
                        return '<input type="checkbox" name="id[' + full.CabRequestId + ']" value="' + full.CabRequestId + '" checked="' + full.CabRequestId + '">';
                    }
                    else {
                        return '<input type="checkbox" name="id[' + full.CabRequestId + ']" value="' + full.CabRequestId + '">';
                    }

                }
            },
            {
                "mData": "EmployeeName",
                "sTitle": "Employee Name",
                "sWidth": "100px"
            },
            {
                "mData": "EmpContactNo",
                "sTitle": "Mobile No.",
                "sWidth": "100px"
            },
            
            {
                "mData": "DateText",
                "sTitle": "Date",
                "sWidth": "100px"
            },
            {
                "mData": "ServiceType",
                "sTitle": "Service",
                "sWidth": "100px"
            },
            {
                "mData": "ShiftName",
                "sTitle": "Time",
                "sWidth": "100px"
            },
            {
                "mData": "LocationName",
                "sTitle": "Location",
                "sWidth": "100px"
            },
            //{
            //    "mData": "LocationDetail",
            //    "sTitle": "Location Detail",
            //    "sWidth": "100px"
            //},
            {
                "mData": "CreatedDate",
                "sTitle": "Requested On",
                "sWidth": "90px"
            },
            {
                "mData": null,
                "sTitle": "Action",
                "sWidth": "80px",
                "className": "all",
                mRender: function (data, type, row) {
                    var html = '&nbsp;<button type="button" class="btn btn-sm teal" ' + 'onclick="approveCabRequest(' + row.CabRequestId + ')" data-toggle="tooltip" title="Approve"><i class="fa fa-check"> </i></button>';
                    html += '&nbsp;<button type="button" class="btn btn-sm btn-danger" ' + 'onclick="rejectCabRequest(' + row.CabRequestId + ' )" data-toggle="tooltip" title="Reject"><i class="fa fa-times"> </i></button>';
                    return html;
                }
            },
        ]
    });

    tableCabRequestPending = $('#tblCabReviewRequestPending').DataTable();
}

function bindNonPendingCabRequest(newdata) {
    var data = $.parseJSON(JSON.stringify(newdata));
    $("#tblCabReviewRequestComplete").dataTable({
        "dom": 'lBfrtip',
        "buttons": [
            {
                filename: 'OR List',
                extend: 'collection',
                text: 'Export',
                buttons: [{ extend: 'copy' },
                { extend: 'excel', filename: 'OR List' },
                { extend: 'pdf', filename: 'OR List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                { extend: 'print', filename: 'OR List' },
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
                "mData": "EmployeeName",
                "sTitle": "Employee Name",
                "sWidth": "100px"
            },
            {
                "mData": "EmpContactNo",
                "sTitle": "Mobile No.",
                "sWidth": "100px"
            },
            {
                "mData": "DateText",
                "sTitle": "Date",
                "sWidth": "100px"
            },
            {
                "mData": "ServiceType",
                "sTitle": "Service",
                "sWidth": "100px"
            },
            {
                "mData": "ShiftName",
                "sTitle": "Time",
                "sWidth": "100px"
            },
            {
                "mData": "LocationName",
                "sTitle": "Location",
                "sWidth": "100px"
            },
            //{
            //    "mData": "LocationDetail",
            //    "sTitle": "Location Detail",
            //    "sWidth": "100px"
            //},
            {
                "mData": "CreatedDate",
                "sTitle": "Requested On",
                "sWidth": "90px"
            },
            
            {   "mData":null,
                "sTitle": "Status",
                "sWidth": "100px",
                "className": "all",
                mRender: function (data, type, row) {
                    var html = '<a onclick="showCabRemarksPopup('+data.CabRequestId+')">' + data.Status + '</a>';
                    return html;
                }
            },
            //{
            //    "mData": "Status",
            //    "sTitle": "Status",
            //    "sWidth": "100px",
            //    "className": "all"
            //},
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
}

function showCabRemarksPopup(requestId) {
    var jsonObject = {
        'requestId': requestId,
        'type': "CAB",
    };
    calltoAjax(misApiUrl.getApproverRemarks, "POST", jsonObject,
        function (result) {
            if (result !== "ERROR") {
                if (result === "") {
                    result = "NA";
                }
                $("#cabRequestRemark").val(result);
                $("#cabRequestRemark").attr('disabled', true);
                $("#mypopupCabRequestRemark").modal("show");
            }
        });
}

function rejectCabRequest(cabRequestId) {
    $("#txtCabRequestRemark").removeClass("error-validation");
    $("#txtCabRequestRemark").val("");
    $("#mypopupReviewCabrequestRemark").modal('show');
    $("#btnRejectCabRequest").show();
    $("#btnApproveCabRequest").hide();
    $("#hdnCabRequestId").val(cabRequestId);
}

function approveCabRequest(cabRequestId) {
    $("#txtCabRequestRemark").removeClass("error-validation");
    $("#txtCabRequestRemark").val("");
    $("#mypopupReviewCabrequestRemark").modal('show');
    $("#btnApproveCabRequest").show();
    $("#btnRejectCabRequest").hide();
    $("#hdnCabRequestId").val(cabRequestId);
}

$("#btnRejectCabRequest").click(function () {
    if (!validateControls("mypopupReviewCabrequestRemark")) {
        return false;
    }
    takeActionOnCabRequest($("#hdnCabRequestId").val(), "RJ");
});

$("#btnApproveCabRequest").click(function () {
    if (!validateControls("mypopupReviewCabrequestRemark")) {
        return false;
    }
    takeActionOnCabRequest($("#hdnCabRequestId").val(), "AP");
});

function takeActionOnCabRequest(cabRequestId, actionCode) {
    if (actionCode == "RJ") {
                var jsonObject = {
                    CabRequestId: cabRequestId,
                    StatusCode: actionCode,
                    Remarks: $("#txtCabRequestRemark").val(),
                    ForScreen: "MGR"
                };
                calltoAjax(misApiUrl.takeActionOnCabRequest, "POST", jsonObject,
                    function (result) {
                        if (result === 1) {
                            $("#mypopupReviewCabrequestRemark").modal('hide');
                            getCabRequest();
                            misAlert('Cab request has been rejected successfully.', "Success", "success");
                        }
                        else if (result = 3) {
                            misAlert("Deadline crossed. Unable to fulfill your request.", "Oops", "warning");
                        }
                        else {
                            misAlert("Unable to process request. please try again", "Error", "error");
                        }
                    });
    }
    else {
                var jsonObject = {
                    CabRequestId: cabRequestId,
                    StatusCode: actionCode,
                    Remarks: $("#txtCabRequestRemark").val(),
                    ForScreen: "MGR"
                };
                calltoAjax(misApiUrl.takeActionOnCabRequest, "POST", jsonObject,
                    function (result) {
                        if (result == 1) {
                            $("#mypopupReviewCabrequestRemark").modal('hide');
                            getCabRequest();
                            misAlert('Cab Request has been approved successfully.', "Success", "success");
                        }
                        else if (result = 3) {
                            misAlert("Deadline crossed. Unable to fulfill your request.", "Oops", "warning");
                        }
                        else {
                            misAlert("Unable to process request. please try again", "Error", "error");
                        }
                    });
    }
}

function bulkApproveCabRequests(cabRequestId, status) {
    var jsonObject = {
        requestIds: cabRequestId,
        statusCode: status,
        remarks: $("#txtRemarkForBulkCabRequest").val()
    };
    calltoAjax(misApiUrl.takeActionOnCabBulkApprove, "POST", jsonObject,
        function (result) {
            if (result.Result == 1) {
                misAlert("<span>Request approved successfully.<\span><br /><span style='color:red'>" + result.Message + "</span>", "Success", "success")
                $("#mypopupBulkApprove").modal("hide");
                getCabRequest();
            } else {
                misAlert("<span>Unable to process request.<\span><br /><span style='color:red'>" + result.Message+"</span>", "Warning", "warning")
                getCabRequest();
            }
        });
}
