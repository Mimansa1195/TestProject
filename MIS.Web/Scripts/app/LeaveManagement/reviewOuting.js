var _applicationId, _status, _type, _period, _remark, _applicantId = 0;
var tableOutingReviewRequestPending = "";
var rows_selected = [];
var Employee_selected = [];
$(document).ready(function () {
    $("#tabApplyOnDutyReq").click(function (e) {
        getOutingRequest();
    });
})
// For Outing
// Handle click on checkbox
$('body').on('click', '#tblOutingReviewRequestPending tbody input[type="checkbox"]', function (e) {
    var $row = $(this).closest('tr');
    // Get row data
    var data = tableOutingReviewRequestPending.row($row).data();
    // Get row ID
    var rowId = data[0];
    // Determine whether row ID is in the list of selected row IDs
    var index = $.inArray(rowId, rows_selected);
    // If checkbox is checked and row ID is not in list of selected row IDs
    if (this.checked && index === -1) {
        rows_selected.push(rowId);
        //$(this).parent().parent("tr").addClass("selected");
        // Otherwise, if checkbox is not checked and row ID is in list of selected row IDs
    } else if (!this.checked && index !== -1) {
        rows_selected.splice(index, 1);
    }
    // Update state of "Select all" control
    updateDataTableSelectAllCtrlUn(tableOutingReviewRequestPending);
    // Prevent click event from propagating to parent
    e.stopPropagation();
});

// Handle click on "Select all " control
$('body').on('click', '#OutingReviewRequestPending', function (e) {
    if (this.checked) {
        $('input[type="checkbox"]', '#tblOutingReviewRequestPending').prop('checked', true);
        var count = $('#tblOutingReviewRequestPending tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    } else {
        $('input[type="checkbox"]', '#tblOutingReviewRequestPending').prop('checked', false);
        var count = $('#tblOutingReviewRequestPending tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    }
    // Prevent click event from propagating to parent
    e.stopPropagation();
})

// Handle click on "Select all " control
$('#tblOutingReviewRequestPending tbody').on('click', 'input[Name="UnCheckbox"]', function (e) {
    if (this.checked) {
        $('input[type="checkbox"]', '#tblOutingReviewRequestPending').prop('checked', true);
        var count = $('#tblOutingReviewRequestPending tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    } else {
        $('input[type="checkbox"]', '#tblOutingReviewRequestPending').prop('checked', false);
        var count = $('#tblOutingReviewRequestPending tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    }
    // Prevent click event from propagating to parent
    e.stopPropagation();
})

// Handle click on tableLeaveReviewRequestPending cells with checkboxes
$('#tblOutingReviewRequestPending tbody').on('click', 'input[type="checkbox"]', function (e) {
    if (e.target.name != "UnCheckbox") {
        $(this).parent().find('input[type="checkbox"]').trigger('click');
        var count = $('#tblOutingReviewRequestPending tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    }
    else {
        var count = $('#tblOutingReviewRequestPending tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    }
});

// Handle table draw event
if (tableOutingReviewRequestPending) {
    tableOutingReviewRequestPending.on('draw', function () {
        // Update state of "Select all" control
        updateDataTableSelectAllCtrlUn(tableOutingReviewRequestPending);
    });
}
function getOutingRequest() {
    var jsonObject = {
        'year': $("#ddlFinancialYear").val()
    };
    calltoAjax(misApiUrl.getOutingReviewRequest, "POST", jsonObject, function (result) {
        if (result.length === 0) {
            bindPendingOutingRequest(result);
            bindNonPendingOutingRequest(result);
        }
        else {
            var pendingReqData = [], nonPendingReqData = [];
            if (result[0].UserType === "HR") {
                pendingReqData = getAllMatchedObject({ StatusCode: 'PV' }, result);
                var pa = getAllMatchedObject({ StatusCode: 'PA' }, result);
                $.merge(pendingReqData, pa);

                var upv = getAllUnmatchedObject({ 'StatusCode': 'PV' }, result);
                var nonPendingReqData = getAllUnmatchedObject({ 'StatusCode': 'PA' }, upv);
            }
            else {
                pendingReqData = getAllMatchedObject({ 'StatusCode': 'PA' }, result);
                nonPendingReqData = getAllUnmatchedObject({ 'StatusCode': 'PA' }, result);
            }
            bindPendingOutingRequest(pendingReqData);
            var html = "<button type='button' class='btn btn-primary' onclick=\"showPopupOnBulkApproveOuting('outing','AP','NULL')\"><i class='fa fa-check'></i>&nbsp;Bulk Approve </button>";
            $("#divBulkOutingApprove").html(html);
            bindNonPendingOutingRequest(nonPendingReqData);
        }
    }

    );
}
function bindPendingOutingRequest(newdata) {
    var data = $.parseJSON(JSON.stringify(newdata));
    $("#tblOutingReviewRequestPending").dataTable({
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
                "sTitle": '<input name="select_all" value="1" id="OutingReviewRequestPending" type="checkbox" />',
                'className': 'dt-body-center',
                'render': function (data, type, full, meta) {
                    if (full.Selected) {
                        return '<input type="checkbox" name="id[' + full.OutingRequestId + ']" value="' + full.OutingRequestId + '" checked="' + full.OutingRequestId + '">';
                    }
                    else {
                        return '<input type="checkbox" name="id[' + full.OutingRequestId + ']" value="' + full.OutingRequestId + '">';
                    }

                }
            },
            {
                "mData": "EmployeeName",
                "sTitle": "Employee Name",
                "sWidth": "100px",
                "className": "all"
            },
            {
                "mData": "Period",
                "sTitle": "Period",
                "sWidth": "80px",
                "className": "all"
            },
            {
                "mData": "DutyType",
                "sTitle": "Duty Type",
                "sWidth": "100px",
                "className": "all"

            },

            {
                "mData": "Reason",
                "sTitle": "Reason",
                "sWidth": "100px",
                "className": "all"
            },

            {
                "mData": null,
                "sWidth": "150px",
                "sTitle": "Remark/Status",
                mRender: function (data, type, row) {
                    var html = '<a  onclick="showOutingRemarksPopup(' + row.OutingRequestId + ',' + "'OR'" + ')" >' + (row.Remarks === null ? '' : row.Remarks) + '</a>';
                    return html;
                }
            },
            {
                "mData": "ApplyDate",
                "sTitle": "Applied On",
                "sWidth": "70px",
                "className": "all"
            },
            {
                "mData": null,
                "sTitle": "Action",
                "sWidth": "80px",
                "className": "all",
                mRender: function (data, type, row) {
                    var html = '&nbsp;<button type="button" class="btn btn-sm teal" ' + 'onclick="showOutingPopup(' + row.OutingRequestId + ',' + "'OUTING'" + ' ,' + "'AP'" + ',' + "'NULL'" + ')" data-toggle="tooltip" title="Verify"><i class="fa fa-check"> </i></button>';
                    html += '&nbsp;<button type="button" class="btn btn-sm btn-danger" ' + 'onclick="showOutingPopup(' + row.OutingRequestId + ',' + "'OUTING'" + ' ,' + "'RJ'" + ',' + "'NULL'" + ')" data-toggle="tooltip" title="Reject"><i class="fa fa-times"> </i></button>';
                    return html;
                }
            },
        ], 'rowCallback': function (row, data, dataIndex) {
            var rowId = data.RequestID;
            // If row ID is in the list of selected row IDs
            if ($.inArray(rowId, rows_selected) !== -1) {
                //$(row).find('input[type="checkbox"]').prop('checked', true);
                //$(row).addClass('selected');
            }
        }
    });

    tableOutingReviewRequestPending = $('#tblOutingReviewRequestPending').DataTable();
}

function bindNonPendingOutingRequest(newdata) {
    var data = $.parseJSON(JSON.stringify(newdata));
    $("#tblOutingReviewRequestComplete").dataTable({
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
                "sWidth": "80px",
                "className": "all"
            },
            {
                "mData": "Period",
                "sTitle": "Period",
                "sWidth": "70px",
                "className": "all",
            },
            {
                "mData": "DutyType",
                "sTitle": "Duty Type",
                "sWidth": "80px",
                "className": "all"

            },

            {
                "mData": "Reason",
                "sTitle": "Reason",
            },
            {
                "mData": "ApplyDate",
                "sTitle": "Applied On",
                "sWidth": "90px",
                "className": "all"
            },
            {
                "mData": null,
                "sTitle": "Remark",
                mRender: function (data, type, row) {
                    var html = '<a  onclick="showOutingRemarksPopup(' + row.OutingRequestId + ',' + "'OR'" + ')" >' + (row.Remarks === null ? '' : row.Remarks) + '</a>';
                    return html;
                }
            },
            {
                "mData": "Status",
                "sTitle": "Status",
                "className": "all"
            },

            {
                "mData": null,
                "sTitle": "Action",
                mRender: function (data, type, row) {
                    var html = '<div>';
                    if (data.StatusCode === "VD" && data.UserType === "HR") {
                        html = '<button type="button" class="btn btn-sm btn-danger"  onclick="cancelOutingRequestByHR(' + row.OutingRequestId + ')" data-toggle="tooltip" title="Cancel request"><i class="fa fa-times"> </i></button>';
                        return html;
                    }
                    else {
                        html = "  "
                        return html;
                    }
                }
            },

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
}

function showOutingPopup(applicationId, type, status, period) {
    _applicationId = applicationId;
    _type = type;
    _status = status;
    _period = period;
    $("#mypopupReviewOutingRemark").modal("show");
    $("#reviewOutingRemark").val('');
    $("#submitReviewOutingRemark").show();
    if (_status === "RJ") {
        $("#submitReviewOutingRemark").removeClass("btn-success")
        $("#submitReviewOutingRemark").addClass("btn-danger") /*css('background-color', '#f10e2b')*/
        $("#submitReviewOutingRemark").html('Reject')
    }
    else {
        $("#submitReviewOutingRemark").removeClass("btn-danger")
        $("#submitReviewOutingRemark").addClass("btn-success")/*css('background-color', '#599659')*/
        $("#submitReviewOutingRemark").html('Approve')
    }
    $("#reviewOutingRemark").attr('disabled', false);
}

function TakeActionOnOutingRequest() {
    var remarks = $('#reviewOutingRemark').val().trim();
    if (_status === "RJ" && remarks === "") {
        misAlert("Please fill remarks", "Warning", "warning");
        return;
    }
    var jsonObject = {
        'OutingRequestId': _applicationId,
        'Status': _status,
        'Remark': remarks,
        'UserAbrhs': misSession.userabrhs
    };
    calltoAjax(misApiUrl.takeActionOnOutingRequest, "POST", jsonObject,
        function (result) {
            if (result === 1 && _status === "RJ") {
                getOutingRequest();
                misAlert('Out Duty/Tour request has been rejected successfully.', "Success", "success");
            }
            else if (result === 1 && _status === "AP") {
                getOutingRequest();
                misAlert('Out Duty/Tour has been approved successfully.', "Success", "success");
            }
            else if (result === 2 && (_status === "RJ" || _status === "AP")) {
                misAlert('Your request can not be processed. Please contact MIS Team.', "Warning", "warning");
            }
            else {
                misAlert("Unable to process request. please try again", "Error", "error");
            }
        });
    $("#mypopupReviewOutingRemark").modal("hide");
}

function cancelOutingRequestByHR(outingRequestId) {
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
                        getOutingRequest()
                        misAlert("Out Duty/Tour request has been cancelled successfully.", "Success", "success");
                    }
                    else if (result === "Failed") {
                        misAlert("Unable to process request, please try again.", "Error", "error");
                    }
                    else if (result === "Unprocessed") {
                        misAlert('Your request can not be processed. Please contact MIS Team.', "Warning", "warning");
                    }
                });
        }
    });


}

function showOutingRemarksPopup(applicationId, type) {
    var jsonObject = {
        'requestId': applicationId,
        'type': type
    };
    calltoAjax(misApiUrl.getApproverRemarks, "POST", jsonObject,
        function (result) {
            if (result !== "ERROR") {
                if (result === "") {
                    result = "NA";
                }
                $('#modalTitlemypopupReviewOutingRemark').text('Approver\'s Remarks');
                $("#submitReviewOutingRemark").hide();
                $("#mypopupReviewOutingRemark").modal("show");
                $("#reviewOutingRemark").val(result);
                $("#reviewOutingRemark").attr('disabled', true);
            }
        });
}
$("#btnOutingClose").click(function () {
    $("#mypopupReviewOutingRemark").modal("hide");
});
// Bulk Approve Section 

function showPopupOnBulkApproveOuting(type, status, period) {
    _typeOnBulkApprove = type;
    _statusOnBulkApprove = status;
    _periodOnBulkApprove = period;
    var selectedLeavesApplicationIds = [];
    var selectedEmployees = [];
    $("#tblOutingReviewRequestPending").dataTable().$('input[type="checkbox"]').each(function () {
        if (this.checked) {
            selectedLeavesApplicationIds.push($(this).val());
            selectedEmployees.push(this.parentNode.nextElementSibling.firstChild.nodeValue.trim());
        }
    });
    selectedEmployees = jQuery.unique(selectedEmployees);
    var Names = selectedEmployees.join();
    _selectedLeavesApplicationIds = selectedLeavesApplicationIds.join();
    $("#employeesNames").html(Names);
    $("#popupfor").html("Leave");
    if (selectedEmployees.length > 0) {
        $("#mypopupBulkApproveRemark").modal("show");
    }
    else {
        misAlert("Please select an employee.", "Warning", "warning");
    }
}
function bulkApproveOuting(OutingId, Status, remark) {

    var jsonObject = {
        'RequestID': OutingId,
        'Userabrhs': misSession.userabrhs,
        'Status': Status,
        'Remark': remark
        
    };
    calltoAjax(misApiUrl.takeActionOnOutingBulkApprove, "POST", jsonObject,
        function (result) {
            if (result.ActionNotTaken.length == 0 && result.ErrorList.length == 0 && result.SuccessList.length > 0) {
                misAlert("Request processed successfully", "Success", "success")
            }
            else if (result.ActionNotTaken.length>0 ) {
                misAlert("Due to change of reporting manager of employee(s) " + result.ActionNotTaken + ", request can't be processed. Please contact MIS Team", "Warning", "warning");
            }
            else if (result.ErrorList.Count > 0 ){
                misAlert("Unable to process request for the employee(s) "+result.ErrorList+", please try again", "Error", "error");
            }
            getOutingRequest();

        });
}