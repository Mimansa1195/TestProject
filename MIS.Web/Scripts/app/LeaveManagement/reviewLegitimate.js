var _applicationId, _status, _type, _period, _remark, _applicantId = 0;
var tableLWPChangeReviewRequestPending = "";
var rows_selected = [];
var Employee_selected = [];
$("#tabLWPChangeReq").on("click",function() {
        getLegitimateRequest();
    });
    // For Leave
    // Handle click on checkbox
    $('body').on('click', '#tblLegitimateReviewRequestPending tbody input[type="checkbox"]', function (e) {
        var $row = $(this).closest('tr');
        // Get row data
        var data = tableLWPChangeReviewRequestPending.row($row).data();
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
        updateDataTableSelectAllCtrlUn(tableLWPChangeReviewRequestPending);
        // Prevent click event from propagating to parent
        e.stopPropagation();
    });

    // Handle click on "Select all " control
    $('body').on('click', '#LWPChangeReviewRequestPending', function (e) {
        if (this.checked) {
            $('input[type="checkbox"]', '#tblLegitimateReviewRequestPending').prop('checked', true);
            var count = $('#tblLegitimateReviewRequestPending tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        } else {
            $('input[type="checkbox"]', '#tblLegitimateReviewRequestPending').prop('checked', false);
            var count = $('#tblLegitimateReviewRequestPending tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        }
        // Prevent click event from propagating to parent
        e.stopPropagation();
    })

    // Handle click on "Select all " control
    $('#tblLegitimateReviewRequestPending tbody').on('click', 'input[Name="UnCheckbox"]', function (e) {
        if (this.checked) {
            $('input[type="checkbox"]', '#tblLegitimateReviewRequestPending').prop('checked', true);
            var count = $('#tblLegitimateReviewRequestPending tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        } else {
            $('input[type="checkbox"]', '#tblLegitimateReviewRequestPending').prop('checked', false);
            var count = $('#tblLegitimateReviewRequestPending tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        }
        // Prevent click event from propagating to parent
        e.stopPropagation();
    })

    // Handle click on tableLeaveReviewRequestPending cells with checkboxes
    $('#tblLegitimateReviewRequestPending tbody').on('click', 'input[type="checkbox"]', function (e) {
        if (e.target.name != "UnCheckbox") {
            $(this).parent().find('input[type="checkbox"]').trigger('click');
            var count = $('#tblLegitimateReviewRequestPending tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        }
        else {
            var count = $('#tblLegitimateReviewRequestPending tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        }
    });

    // Handle table draw event
    if (tableLWPChangeReviewRequestPending) {
        tableLWPChangeReviewRequestPending.on('draw', function () {
            // Update state of "Select all" control
            updateDataTableSelectAllCtrlUn(tableLWPChangeReviewRequestPending);
        });
    }


function getLegitimateRequest() {
    var jsonObject = {
        'year' : $("#ddlFinancialYear").val()
    }
    calltoAjax(misApiUrl.getLegitimateRequest, "POST", jsonObject, function (result) {
        if (result.length === 0) {
            bindPendingLegitimateRequest(result);
            bindNonPendingLegitimateRequest(result);
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
           
            bindPendingLegitimateRequest(pendingReqData);
            var html = "<button type='button' class='btn btn-primary' onclick=\"showPopupOnBulkApproveLWPChange('LWP','AP','NULL')\"><i class='fa fa-check'></i>&nbsp;Bulk Approve </button>";
            $("#divBulkLWPChangeRequestApprove").html(html);
            bindNonPendingLegitimateRequest(nonPendingReqData);
        }
    }

    );
}

function bindPendingLegitimateRequest(newData) {
    data = $.parseJSON(JSON.stringify(newData));
    $("#tblLegitimateReviewRequestPending").dataTable({
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
                "sTitle": '<input name="select_all" value="1" id="LWPChangeReviewRequestPending" type="checkbox" />',
                'className': 'dt-body-center',
                'render': function (data, type, full, meta) {
                    if (full.Selected) {
                        return '<input type="checkbox" name="id[' + full.RequestId + ']" value="' + full.RequestId + '" checked="' + full.RequestId + '">';
                    }
                    else {
                        return '<input type="checkbox" name="id[' + full.RequestId + ']" value="' + full.RequestId + '">';
                    }

                }
            },
            {
                "mData": "EmployeeName",
                "sTitle": "Employee Name",
                "sWidth": "80px",
                "className": "all"
            },
            {
                "mData": "Date",
                "sTitle": "Period",
                "sWidth": "80px",
                "className": "all"
            },
            {
                "mData": "LeaveInfo",
                "sTitle": "Leave Type",
                "sWidth": "80px",
                "className": "all"

            },

            {
                "mData": "Reason",
                "sTitle": "Reason",
                "sWidth": "80px",
                "className": "all"
            },

            {
                "mData": null,
                "sTitle": "Remark/Status",
                mRender: function (data, type, row) {
                    var html = '<a  onclick="showLegitimateRemarksPopup(' + row.RequestId + ',' + "'LGT'" + ')" >' + (row.Remarks === null ? '' : row.Remarks) + '</a>';
                    return html;
                }
            },
            {
                "mData": "ApplyDate",
                "sTitle": "Applied On",
                "sWidth": "90px",
                "className": "all"
            },
            {
                "mData": null,
                "sTitle": "Action",
                "sWidth": "80px",
                "className": "all",
                mRender: function (data, type, row) {
                    var html = '&nbsp;<button type="button" class="btn btn-sm teal" ' + 'onclick="showLegitimatePopup(' + row.RequestId + ',' + "'LEGITIMATE'" + ' ,' + "'AP'" + ',' + "'NULL'" + ')" data-toggle="tooltip" title="Verify"><i class="fa fa-check"> </i></button>';
                    html += '&nbsp;<button type="button" class="btn btn-sm btn-danger" ' + 'onclick="showLegitimatePopup(' + row.RequestId + ',' + "'LEGITIMATE'" + ' ,' + "'RJ'" + ',' + "'NULL'" + ')" data-toggle="tooltip" title="Reject"><i class="fa fa-times"> </i></button>';
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

    tableLWPChangeReviewRequestPending = $('#tblLegitimateReviewRequestPending').DataTable();
}
function bindNonPendingLegitimateRequest(newData) {

    var data = $.parseJSON(JSON.stringify(newData));
    $("#tblLegitimateReviewRequestComplete").dataTable({
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
                "mData": "Date",
                "sTitle": "Period",
                "sWidth": "80px",
                "className": "all",
            },
            {
                "mData": "LeaveInfo",
                "sTitle": "Leave Type",
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
                    var html = '<a  onclick="showLegitimateRemarksPopup(' + row.RequestId + ',' + "'LGT'" + ')" >' + (row.Remarks === null ? '' : row.Remarks) + '</a>';
                    return html;
                }
            },
            {
                "mData": "Status",
                "sTitle": "Status",
                "className": "all"
            },



        ],
        "fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
           if (aData.StatusCode === "RJM") {
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

function showLegitimatePopup(applicationId, type, status, period) {
    _applicationId = applicationId;
    _type = type;
    _status = status;
    _period = period;
    $("#mypopupReviewLegitimateRemark").modal("show");
    $("#reviewLegitimateRemark").val('');
    $("#submitReviewLeaveRemark").show();
    if (_status === "RJ") {
        $("#submitReviewLegitimateRemark").removeClass("btn-success");
        $("#submitReviewLegitimateRemark").addClass("btn-danger"); /*css('background-color', '#f10e2b')*/
        $("#submitReviewLegitimateRemark").html('Reject')

    }
    else {
        $("#submitReviewLegitimateRemark").removeClass("btn-danger");
        $("#submitReviewLegitimateRemark").addClass("btn-success");/*css('background-color', '#599659')*/
        $("#submitReviewLegitimateRemark").html('Approve')

    }
    $("#reviewLegitimateRemark").attr('disabled', false);
}

function takeActionOnLegitimateRequest() {
    var remarks = $('#reviewLegitimateRemark').val().trim();
    if (_status === "RJ" && remarks === "") {
        misAlert("Please fill remarks", "Warning", "warning");
        return;
    }
    var jsonObject = {
        'RequestId': _applicationId,
        'Status': _status,
        'Remark': remarks,
        'UserAbrhs': misSession.userabrhs
    };
    calltoAjax(misApiUrl.takeActionOnLegitimateRequest, "POST", jsonObject,
        function (result) {
            if (result === 1 && _status === "RJ") {
                getLegitimateRequest();
                misAlert('LWP change request has been rejected successfully.', "Success", "success");
            }
            else if (result === 1 && _status === "AP") {
                getLegitimateRequest();
                misAlert('LWP change request has been approved successfully.', "Success", "success");
            }
            else if (result === 2) {
                misAlert('Your request can not be processed. Please contact MIS Team.', "Warning", "warning");
            }
            else {
                misAlert("Unable to process request. please try again", "Error", "error");
            }
        });
    $("#mypopupReviewLegitimateRemark").modal("hide");
}

$("#btnLgClose").click(function () {
    $("#mypopupReviewLegitimateRemark").modal("hide");
});




function showLegitimateRemarksPopup(applicationId, type) {
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
                $('#modalTitleMyPopupReviewLeaveRemark').text('Approver\'s Remarks');
                $("#submitReviewLeaveRemark").hide();
                $("#mypopupReviewLeaveRemark").modal("show");
                $("#reviewLeaveRemark").val(result);
                $("#reviewLeaveRemark").attr('disabled', true);
            }
        });
}
$("#btnClose").click(function () {
    $("#mypopupReviewLeaveRemark").modal("hide");
});
function showPopupOnBulkApproveLWPChange(type, status, period) {
    _typeOnBulkApprove = type;
    _statusOnBulkApprove = status;
    _periodOnBulkApprove = period;
    var selectedLeavesApplicationIds = [];
    var selectedEmployees = [];
    $("#tblLegitimateReviewRequestPending").dataTable().$('input[type="checkbox"]').each(function () {
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
function bulkApproveLWPChangeRequest(RequestId, Status, remark) {

    var jsonObject = {
        'RequestID': RequestId,
        'Userabrhs': misSession.userabrhs,
        'Status': Status,
        'Remark': remark

    };
    calltoAjax(misApiUrl.takeActionOnLWPChangeBulkApprove, "POST", jsonObject,
        function (result) {
            if (result == 'SUCCEED') {
                misAlert("Request processed successfully", "Success", "success")
                getLegitimateRequest();
            } else {
                misAlert("Unable to process request. Please try again", "Error", "error");
            }
        });
}