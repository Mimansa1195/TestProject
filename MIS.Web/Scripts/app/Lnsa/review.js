var _type = "";
var _lnsaRequestId, _lnsaRequestDetailId;
var resizetableId;
var _selectedLnsaRequestIds = "";
var tableLnsaReviewRequestPending = "";
var rows_selected = [];
var Employee_selected = [];

$(document).ready(function () {
    getPendingLnsaRequest();
    $('#fromDate').datepicker({
        autoclose: true,
        todayHighlight: true
    });
    $('#tillDate').datepicker({
        autoclose: true,
        todayHighlight: true
    });
    getApprovedRequestLastTwentyFive();
});

// For Outing
// Handle click on checkbox
$('body').on('click', '#tblPendingLnsaGrid tbody input[type="checkbox"]', function (e) {
    var $row = $(this).closest('tr');
    // Get row data
    var data = tableLnsaReviewRequestPending.row($row).data();
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
    updateDataTableSelectAllCtrlUn(tableLnsaReviewRequestPending);
    // Prevent click event from propagating to parent
    e.stopPropagation();
});

// Handle click on "Select all " control
$('body').on('click', '#LnsaReviewRequestPending', function (e) {
    if (this.checked) {
        $('input[type="checkbox"]', '#tblPendingLnsaGrid').prop('checked', true);
        var count = $('#tblPendingLnsaGrid tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    } else {
        $('input[type="checkbox"]', '#tblPendingLnsaGrid').prop('checked', false);
        var count = $('#tblPendingLnsaGrid tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    }
    // Prevent click event from propagating to parent
    e.stopPropagation();
})

// Handle click on "Select all " control
$('#tblPendingLnsaGrid tbody').on('click', 'input[Name="UnCheckbox"]', function (e) {
    if (this.checked) {
        $('input[type="checkbox"]', '#tblPendingLnsaGrid').prop('checked', true);
        var count = $('#tblPendingLnsaGrid tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    } else {
        $('input[type="checkbox"]', '#tblPendingLnsaGrid').prop('checked', false);
        var count = $('#tblPendingLnsaGrid tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    }
    // Prevent click event from propagating to parent
    e.stopPropagation();
})

// Handle click on tableLeaveReviewRequestPending cells with checkboxes
$('#tblPendingLnsaGrid tbody').on('click', 'input[type="checkbox"]', function (e) {
    if (e.target.name != "UnCheckbox") {
        $(this).parent().find('input[type="checkbox"]').trigger('click');
        var count = $('#tblPendingLnsaGrid tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    }
    else {
        var count = $('#tblPendingLnsaGrid tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    }
});

// Handle table draw event
if (tableLnsaReviewRequestPending) {
    tableLnsaReviewRequestPending.on('draw', function () {
        // Update state of "Select all" control
        updateDataTableSelectAllCtrlUn(tableLnsaReviewRequestPending);
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


function onFromDateChange() {
    $('#tillDate input').val("");
    var fromStartDate = $('#fromDate input').val();
    $('#tillDate').datepicker({
        autoclose: true,
        todayHighlight: true
    }).datepicker('setStartDate', fromStartDate);
}
function onTillDateChange() {
    getApprovedRequest();
}

function getDateToRejectLnsaRequest(lnsaRequestId, type) {
    _type = type;
    $("#hiddenTempShiftId").val(lnsaRequestId);
    var jsonObject = {
        lnsaRequestId: lnsaRequestId
    }
    if ($.fn.DataTable.isDataTable('#tblLnsaDataToReject')) {
        $('#tblLnsaDataToReject').DataTable().destroy();
    }
    $('#tblLnsaDataToReject tbody').empty();
    $("#mypopupReviewLnsaRemarkReject").modal("show");
    calltoAjax(misApiUrl.getDateLnsaRequest, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            resizetableId = "#tblLnsaDataToReject";
            $("#tblLnsaDataToReject").dataTable({
                "responsive": true,
                "autoWidth": true,
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
                ],
            });
            setTimeout(resizeDataTable, 200);
        });
    $("#divReviewToReject").show();
    $("#txtRemarksToReject").show();
   
    $("#reviewLnsaRemarkToReject").show();
    $("#reviewLnsaRemarkToReject").val('');
    $("#submitLnsaRemarkToReject").show();
}

$("#btnLnsaRejectClose").click(function () {
    $("#mypopupReviewLnsaRemarkReject").modal("hide");
});

function getDateToApproveLnsaRequest(lnsaRequestId, can) {
    $("#hiddenShiftId").val(lnsaRequestId);
    var jsonObject = {
        lnsaRequestId: lnsaRequestId
    }
    if ($.fn.DataTable.isDataTable('#tblLnsaDataToApprove')) {
        $('#tblLnsaDataToApprove').DataTable().destroy();
    }
    $('#tblLnsaDataToApprove tbody').empty();
    $("#mypopupReviewLnsaRemarkApprove").modal("show");

    calltoAjax(misApiUrl.getDateLnsaRequest, "POST", jsonObject,
        function (result) {
            resizetableId = "#tblLnsaDataToApprove";
            var ReqData = [];
            var count = 0;
            ReqData = getAllMatchedObject({ 'IsCancellable': true }, result);
            count = ReqData.length;
            if (count == 0 && can == 0) {
                $("#mypopupReviewLnsaRemarkApprove").modal("hide");
                getPendingLnsaRequest();
                getApprovedRequestLastTwentyFive();
            }
            else {
                var data = $.parseJSON(JSON.stringify(result));
                $("#tblLnsaDataToApprove").dataTable({
                    "responsive": true,
                    "autoWidth": true,
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
                                    html += '<button type="button" class="btn btn-sm btn-danger" /*data-toggle"model" data-target="#myModal"*/' + 'onclick="rejectLnsaRequestRemarks(' + lnsaRequestId + ',' + row.LnsaRequestDetailId + ')" data-toggle="tooltip" title="Reject"><i class="fa fa-times"></i></button>';
                                    html += '</div>'
                                    return html;
                                }
                                else
                                    return "";
                            }
                        }
                    ],
                });
                setTimeout(resizeDataTable, 200);
                if (count === 0) {
                    $("#txtRemarksToApprove").hide();
                    $("#divReviewToApprove").hide();
                    $("#reviewLnsaRemarkToApprove").hide();
                    $("#submitLnsaRemarkToApprove").hide();
                } else {
                    $("#txtRemarksToApprove").show();
                    $("#divReviewToApprove").show();
                    $("#reviewLnsaRemarkToApprove").val('');
                    $("#submitLnsaRemarkToApprove").show();
                }
            }
        });
}

$("#btnLnsaApproveClose").click(function () {
    $("#mypopupReviewLnsaRemarkApprove").modal("hide");
});

function approveLnsaShiftRequest() {
    var lnsaRequestId = $("#hiddenShiftId").val();
    var remarks = $('#reviewLnsaRemarkToApprove').val().trim();
    var jsonObject = {
        lnsaRequestId: lnsaRequestId,
        status: "AP",
        action: "",
        remarks: remarks,
        userAbrhs: misSession.userabrhs
    };
    calltoAjax(misApiUrl.approveLnsaShiftRequest, "POST", jsonObject,
        function (result) {
            if (result === 1) {
                $("#mypopupReviewLnsaRemarkApprove").modal("hide");
                getPendingLnsaRequest();
                getApprovedRequestLastTwentyFive();
                misAlert("LNSA request has been approved successfully.", "Success", "success");
            }
            else if (result === 2) {
                misAlert('Your request can not be processed. Please contact MIS Team.', "Warning", "warning");
            }
            else {
                misAlert("Unable to process request, please try again.", "Error", "error");
            }
        });
}

function rejectLnsaRequestRemarks(lnsaRequestId, lnsaRequestDetailId) {
    _lnsaRequestId = lnsaRequestId;
    _lnsaRequestDetailId = lnsaRequestDetailId;
    $("#mypopupReviewLnsaRemark").modal("show");
    $("#btnLnsa").show();
    $("#btnApprovedLnsa").hide();
    $("#reviewLnsaRemark").val('');
    $("#reviewLnsaRemark").attr("disabled", false);
}

function rejectApprovedLnsaRequestRemarks(lnsaRequestId, lnsaRequestDetailId) {

    _lnsaRequestId = lnsaRequestId;
    _lnsaRequestDetailId = lnsaRequestDetailId;
    $("#mypopupReviewLnsaRemark").modal("show");
    $("#btnLnsa").hide();
    $("#btnApprovedLnsa").show();
    $("#reviewLnsaRemark").val('');
    $("#reviewLnsaRemark").attr("disabled", false);
}

function rejectApprovedLnsaRequest() {
    var remarks = $("#reviewLnsaRemark").val().trim();
    if (remarks === "") {
        misAlert("Please fill remarks", "Warning", "warning");
        return false;
    }
    var jsonObject = {
        lnsaRequestId: _lnsaRequestId,
        status: "RJ",
        action: "Single",
        remarks: remarks,
        userAbrhs: misSession.userabrhs,
        lnsaRequestDetailId: _lnsaRequestDetailId
    };
    calltoAjax(misApiUrl.rejectLnsaRequest, "POST", jsonObject,
        function (result) {
            if (result === 1) {
                $("#mypopupReviewLnsaRemark").modal("hide");
                getDateForLnsaRequest(_lnsaRequestId, 0)
                misAlert("LNSA request has been rejected successfully.", "Success", "success");
            }
            else if (result === 2) {
                misAlert('Your request can not be processed. Please contact MIS Team.', "Warning", "warning");
            }
            else {
                $("#mypopupReviewLnsaRemark").modal("hide");
                misAlert("Unable to process request, please try again.", "Error", "error");
            }
        });
}

function rejectLnsaRequest() {
    var remarks = $("#reviewLnsaRemark").val().trim();
    if (remarks === "") {
        misAlert("Please fill remarks", "Warning", "warning");
        return false;
    }
    var jsonObject = {
        lnsaRequestId: _lnsaRequestId,
        status: "RJ",
        action: "Single",
        remarks: remarks,
        userAbrhs: misSession.userabrhs,
        lnsaRequestDetailId: _lnsaRequestDetailId
    };
    calltoAjax(misApiUrl.rejectLnsaRequest, "POST", jsonObject,
        function (result) {
            if (result === 1) {
                $("#mypopupReviewLnsaRemark").modal("hide");
                getDateToApproveLnsaRequest(_lnsaRequestId, 0)
                misAlert("LNSA request has been rejected successfully.", "Success", "success");
            }
            else if (result === 2) {
                misAlert('Your request can not be processed. Please contact MIS Team.', "Warning", "warning");
            }
            else {
                $("#mypopupReviewLnsaRemark").modal("hide");
                misAlert("Unable to process request, please try again.", "Error", "error");
            }
        });
}

function showLnsaRemarksPopup(lnsaRequestId, type) {
    var jsonObject = {
        'requestId': lnsaRequestId,
        'type': type
    };
    calltoAjax(misApiUrl.getApproverRemarks, "POST", jsonObject,
        function (result) {
            if (result !== "ERROR") {
                if (result === "") {
                    result = "NA";
                }
                $("#btnLnsa").hide();
                $("#btnApprovedLnsa").hide();
                $("#modalTitlemypopupReviewLnsaRemark").html("Remarks");
                $("#reviewLnsaRemark").attr("disabled", true);
                $("#mypopupReviewLnsaRemark").modal("show");
                $("#reviewLnsaRemark").val(result);
            }
        });
}

$("#btnLnsaClose").click(function () {
    $("#mypopupReviewLnsaRemark").modal("hide");
});

function rejectAllLnsaRequest() {
    var lnsaRequestId = $("#hiddenTempShiftId").val();
    var remarks = $('#reviewLnsaRemarkToReject').val().trim();
    if (remarks === "") {
        misAlert("Please fill remarks", "Warning", "warning");
        return false;
    }
    var reply = misConfirm("Are you sure you want to reject this request ?", "Confirm", function (reply) {
        if (reply) {
                var jsonObject = {
                    lnsaRequestId: lnsaRequestId,
                    status: "RJ",
                    action: "All",
                    remarks: remarks,
                    userAbrhs: misSession.userabrhs
                };

            calltoAjax(misApiUrl.rejectAllLnsaRequest, "POST", jsonObject,
                function (result) {
                    if (result === 1) {
                        $("#mypopupReviewLnsaRemarkReject").modal("hide");
                        getPendingLnsaRequest();
                        getApprovedRequestLastTwentyFive();
                        misAlert("LNSA request has been rejected successfully.", "Success", "success");
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

function getDateForLnsaRequest(lnsaRequestId, can) {
    var jsonObject = {
        lnsaRequestId: lnsaRequestId
    }
    if ($.fn.DataTable.isDataTable('#tblApprovedLnsa')) {
        $('#tblApprovedLnsa').DataTable().destroy();
    }
    $('#tblApprovedLnsa tbody').empty();
    calltoAjax(misApiUrl.getDateLnsaRequest, "POST", jsonObject,
        function (result) {
            resizetableId = "#tblApprovedLnsa";
            var ReqData = [];
            var count = 0;
            ReqData = getAllMatchedObject({ 'IsCancellable': true }, result);
            count = ReqData.length;
            if (count == 0 && can == 0) {
                $("#mypopupReviewApprovedLnsaRemark").modal("hide");
                getPendingLnsaRequest();
                getApprovedRequestLastTwentyFive();
            }
            else {
               
                var data = $.parseJSON(JSON.stringify(result));
                $("#tblApprovedLnsa").dataTable({
                    "responsive": true,
                    "autoWidth": true,
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
                                if (data.IsCancellableAfterApproval === true) {
                                    var html = '<div>';
                                    html += '<button type="button" class="btn btn-sm btn-danger" /*data-toggle"model" data-target="#myModal"*/' + 'onclick="rejectApprovedLnsaRequestRemarks(' + lnsaRequestId + ',' + row.LnsaRequestDetailId + ')" data-toggle="tooltip" title="Reject"><i class="fa fa-times"></i></button>';
                                    html += '</div>'
                                    return html;
                                }
                                else
                                    return "";
                            }
                        }
                    ],
                });
                setTimeout(resizeDataTable, 200);
                $("#divReviewApprovedLnsa").show();
            }
        });
   
}

$("#btnLnsaApprovedClose").click(function () {
    $("#mypopupReviewApprovedLnsaRemark").modal("hide");
});

function getApprovedRequest() {
    if (!validateControls('filterDiv')) {
        return false;
    }
    var jsonObject = {
        fromDate: $("#fromDate input").val(),
        tillDate: $("#tillDate input").val(),
        userAbrhs: misSession.userabrhs,
    };
    calltoAjax(misApiUrl.getAllApprovedLnsaRequest, "POST", jsonObject,
        function (result) {
             var nonPendingReqData = getAllUnmatchedObject({ 'StatusCode': 'PA' }, result);
            var resultdata = $.parseJSON(JSON.stringify(nonPendingReqData));
            $("#tblApprovedLnsaGrid").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'Approved Lnsa Request List',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'Approved Lnsa Request List' },
                        { extend: 'pdf', filename: 'Approved Lnsa Request List' },
                        { extend: 'print', filename: 'Approved Lnsa Request List' },
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
                        "sWidth": "100px",
                    },
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
                        "sWidth": "100px",
                    },
                    {
                        "mData": null,
                        "sWidth": "150px",
                        "sTitle": "Status/Remark",
                        mRender: function (data, type, row) {
                            var html = '<a  onclick="showRemarksPopupForLNSARequest(' + row.RequestId + ', ' + "'LNSAREQUEST'" + ')" >' + row.Status + '</a>';
                            return html;
                        }
                    },
                    {
                        "mData": "ApplyDate",
                        "sTitle": "Requested On",
                        "sWidth": "150px",
                        "className": "all"
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        "sWidth": "100px",
                        "className": "all",
                        mRender: function (data, type, row) {
                            var html = ""
                            var can = 1;
                            if (data.IsCancellable == true) {
                                html = '&nbsp;<button type="button" class="btn btn-sm teal" ' + 'onclick="getDateForLnsaRequestReject(' + row.RequestId + ',' + can + ')" data-toggle="tooltip" title="View"><i class="fa fa-eye"> </i></button>';
                                html += '&nbsp;<button type="button" class="btn btn-sm btn-danger" ' + 'onclick="getDateToRejectLnsaRequest(' + row.RequestId + ',' + "'AP'" + ')" data-toggle="tooltip" title="Reject"><i class="fa fa-times"> </i></button>';
                            }
                            else {
                                html = '&nbsp;<button type="button" class="btn btn-sm teal" ' + 'onclick="getDateForLnsaRequestView(' + row.RequestId + ',' + can + ')" data-toggle="tooltip" title="View"><i class="fa fa-eye"> </i></button>';
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

function getDateForLnsaRequestView(requestId, can) {
    $("#txtHeading").html("View LNSA Request");
    $("#mypopupReviewApprovedLnsaRemark").modal("show");
    getDateForLnsaRequest(requestId, can);
}

function getDateForLnsaRequestReject(requestId, can) {
    $("#txtHeading").html("Reject LNSA Request");
    $("#mypopupReviewApprovedLnsaRemark").modal("show");
    getDateForLnsaRequest(requestId, can);
}

function getApprovedRequestLastTwentyFive() {
    var jsonObject = {
        userAbrhs: misSession.userabrhs,
        noOfRecords: 25
    };
    calltoAjax(misApiUrl.getLastNApprovedLnsaRequest, "POST", jsonObject,
        function (result) {
            var nonPendingReqData = getAllUnmatchedObject({ 'StatusCode': 'PA' }, result);
            var resultdata = $.parseJSON(JSON.stringify(nonPendingReqData));
            $("#tblApprovedLnsaGrid").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'Approved Lnsa Request List',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'Approved Lnsa Request List' },
                        { extend: 'pdf', filename: 'Approved Lnsa Request List' },
                        { extend: 'print', filename: 'Approved Lnsa Request List' },
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
                        "mData": "EmployeeName",
                        "sTitle": "Employee Name",
                        "sWidth": "100px",
                    },
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
                        "sWidth": "100px",
                    },
                    {
                        "mData": null,
                        "sWidth": "150px",
                        "sTitle": "Status/Remark",
                        mRender: function (data, type, row) {
                            var html = '<a  onclick="showRemarksPopupForLNSARequest(' + row.RequestId + ', ' + "'LNSAREQUEST'" + ')" >' + row.Status + '</a>';
                            return html;
                        }
                    },
                    {
                        "mData": "ApplyDate",
                        "sTitle": "Requested On",
                        "sWidth": "150px",
                        "className": "all"
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        "sWidth": "100px",
                        "className": "all",
                        mRender: function (data, type, row) {
                            var html = ""
                            var can = 1;
                            if (data.IsCancellable == true) {
                                html = '&nbsp;<button type="button" class="btn btn-sm teal" ' + 'onclick="getDateForLnsaRequestReject(' + row.RequestId + ',' + can + ')" data-toggle="tooltip" title="View & Reject"><i class="fa fa-eye"> </i></button>';
                                html += '&nbsp;<button type="button" class="btn btn-sm btn-danger" ' + 'onclick="getDateToRejectLnsaRequest(' + row.RequestId + ',' + "'AP'" + ')" data-toggle="tooltip" title="Reject"><i class="fa fa-times"> </i></button>';
                            }
                            else {
                                html = '&nbsp;<button type="button" class="btn btn-sm teal" ' + 'onclick="getDateForLnsaRequestView(' + row.RequestId + ',' + can + ')" data-toggle="tooltip" title="View"><i class="fa fa-eye"> </i></button>';
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

function getPendingLnsaRequest() {
    var html = "<button type='button' class='btn btn-primary' onclick=\"showPopupOnBulkApprove('Lnsa','PA','NULL')\"><i class='fa fa-check'></i>&nbsp;Bulk Approve </button>";
    $("#divBulkLeaveApprove").html(html);

    var jsonObject = {
        userAbrhs: misSession.userabrhs,
    };
    calltoAjax(misApiUrl.getAllPendingLnsaRequest, "POST", jsonObject,
        function (result) {
            var resultdata = $.parseJSON(JSON.stringify(result));
            $("#tblPendingLnsaGrid").DataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'Pending Lnsa Request List',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'Pending Lnsa Request List' },
                        { extend: 'pdf', filename: 'Pending Lnsa Request List' },
                        { extend: 'print', filename: 'Pending Lnsa Request List' },
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
                        'targets': 0,
                        'searchable': false,
                        'width': '1%',
                        'orderable': false,
                        'bSortable': false,
                        "sTitle": '<input name="select_all" value="1" id="LnsaReviewRequestPending" type="checkbox" />',
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
                        "sWidth": "100px",
                    },
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
                        "sWidth": "100px",
                    },
                    {
                        "mData": null,
                        "sWidth": "150px",
                        "sTitle": "Status/Remark",
                        mRender: function (data, type, row) {
                            var html = '<a  onclick="showRemarksPopupForLNSARequest(' + row.RequestId + ', ' + "'LNSAREQUEST'" + ')" >' + row.Status + '</a>';
                            return html;
                        }
                    },
                    {
                        "mData": "ApplyDate",
                        "sTitle": "Requested On",
                        "sWidth": "150px",
                        "className": "all"
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        "sWidth": "100px",
                        "className": "all",
                        mRender: function (data, type, row) {
                            var can = 1;
                            var html = '&nbsp;<button type="button" class="btn btn-sm teal" ' + 'onclick="getDateToApproveLnsaRequest(' + row.RequestId + ',' + can + ')" data-toggle="tooltip" title="Verify"><i class="fa fa-eye"> </i></button>';
                            html += '&nbsp;<button type="button" class="btn btn-sm btn-danger" ' + 'onclick="getDateToRejectLnsaRequest(' + row.RequestId + ',\'' + "AP" + '\')" data-toggle="tooltip" title="Reject"><i class="fa fa-times"> </i></button>';
                            return html;
                        }
                    },
                ], 'rowCallback': function (row, data, dataIndex) {
                    var rowId = data.RequestId;
                    // If row ID is in the list of selected row IDs
                    if ($.inArray(rowId, rows_selected) !== -1) {
                        //$(row).find('input[type="checkbox"]').prop('checked', true);
                        //$(row).addClass('selected');
                    }
                }
            });
            tableLnsaReviewRequestPending = $('#tblPendingLnsaGrid').DataTable();
        });
}

function showPopupOnBulkApprove(type, status, period) {
    $("#reviewBulkRemark").val("");
    var selectedLnsaRequestIds = [];
    var selectedEmployees = [];
    $("#tblPendingLnsaGrid").dataTable().$('input[type="checkbox"]').each(function () {
        if (this.checked) {
            var emp = this.parentNode.nextElementSibling.firstChild.nodeValue.trim();
            if (selectedLnsaRequestIds.indexOf($(this).val()) == -1) {
                selectedLnsaRequestIds.push($(this).val());
            }

            if (selectedEmployees.indexOf(emp) == -1) {
                selectedEmployees.push(emp);
            }
        }
    });
   
    var Names = selectedEmployees.join(", ");
    _selectedLnsaRequestIds = selectedLnsaRequestIds.join();
    $("#employeesNames").html(Names);
    $("#popupfor").html("Lnsa");
    if (selectedEmployees.length > 0) {
        $("#mypopupBulkApproveRemark").modal("show");
    }
    else {
        misAlert("Please select an employee.", "Warning", "warning");
    }
}

$("#submitReviewLnsaRemarkBulk").click(function () {
    if (!validateControls('remarkdiv')) {
        return false;
    }
    var remark = $("#reviewBulkRemark").val();
    bulkApproveLnsaRequest(_selectedLnsaRequestIds, remark);
    
});

function bulkApproveLnsaRequest(lnsaRequestIds, remark) {
    var jsonObject = {
        lnsaRequestIds: lnsaRequestIds,
        remarks: remark
    };
    calltoAjax(misApiUrl.bulkApproveLnsaRequest, "POST", jsonObject,
        function (result) {
            if (result.length === 0) {
                $("#mypopupBulkApproveRemark").modal("hide");
                getPendingLnsaRequest();
                getApprovedRequestLastTwentyFive();
                misAlert("LNSA request has been approved successfully.", "Success", "success");
            }
            else {
                misAlert("<span style='color: red;'>Unable to process request<span>"+result+"</span>, please try again.</span>", "Error", "error");
            }
        });
}

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

function resizeDataTable() {
    $(resizetableId).DataTable().order([[1, 'asc']]).draw(false);
}