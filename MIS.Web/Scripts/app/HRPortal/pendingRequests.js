var profileRequestPending = "";
var _selectedId;
$(function () {
    bindPendingProfileRequests();
    bindVerifiedProfileRequests();
    // Handle click on checkbox
    $('body').on('click', '#tblProfileVerification tbody input[type="checkbox"]', function (e) {
        var $row = $(this).closest('tr');
        // Get row data
        var data = profileRequestPending.row($row).data();
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
        updateDataTableSelectAllCtrlUn(profileRequestPending);
        // Prevent click event from propagating to parent
        e.stopPropagation();
    });

    // Handle click on "Select all " control
    $('body').on('click', '#ProfileVerification', function (e) {
        if (this.checked) {
            $('input[type="checkbox"]', '#tblProfileVerification').prop('checked', true);
            var count = $('#tblProfileVerification tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        } else {
            $('input[type="checkbox"]', '#tblProfileVerification').prop('checked', false);
            var count = $('#tblProfileVerification tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        }
        // Prevent click event from propagating to parent
        e.stopPropagation();
    })

    // Handle click on "Select all " control
    $('#tblProfileVerification tbody').on('click', 'input[Name="UnCheckbox"]', function (e) {
        if (this.checked) {
            $('input[type="checkbox"]', '#tblProfileVerification').prop('checked', true);
            var count = $('#tblProfileVerification tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        } else {
            $('input[type="checkbox"]', '#tblProfileVerification').prop('checked', false);
            var count = $('#tblProfileVerification tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        }
        // Prevent click event from propagating to parent
        e.stopPropagation();
    })

    // Handle click on tableLeaveReviewRequestPending cells with checkboxes
    $('#tblProfileVerification tbody').on('click', 'input[type="checkbox"]', function (e) {
        if (e.target.name != "UnCheckbox") {
            $(this).parent().find('input[type="checkbox"]').trigger('click');
            var count = $('#tblProfileVerification tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        }
        else {
            var count = $('#tblProfileVerification tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        }
    });

    // Handle table draw event
    if (profileRequestPending) {
        profileRequestPending.on('draw', function () {
            // Update state of "Select all" control
            updateDataTableSelectAllCtrlUn(profileRequestPending);
        });
    }

    $("#rejectRequest").click(function () {
        if (!validateControls('mypopupReviewProfile')) {
            return false;
        }
        verifyProfileRequest(_selectedId, "1");

    });
    $("#btnClose").click(function () {

        $("#mypopupReviewProfile").modal("hide");

    });


});
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

function bindPendingProfileRequests() {
    //var html = "<button type='button' class='btn btn-primary' onclick=\"showPopupOnBulkApprove('leave','AP','NULL')\"><i class='fa fa-check'></i>&nbsp;Bulk Approve </button>";
    //$("#divBulkProfileApprove").html(html);
    var jsonObject = {
        status: "Pending"
    }
    calltoAjax(misApiUrl.getAllProfilePendingRequests, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#tblProfileVerification").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'Pending Profile Verification List',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'Pending Profile Verification List' },
                        { extend: 'pdf', filename: 'Pending Profile Verification List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                        { extend: 'print', filename: 'Pending Profile Verification List' },
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
                "aaData": resultData,
                "aoColumns": [
                    {
                        'targets': 0,
                        'searchable': false,
                        'width': '1%',
                        'orderable': false,
                        'bSortable': false,
                        "sTitle": '<input name="select_all" value="1" id="ProfileVerification" type="checkbox" />',
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
                        "mData": "UserName",
                        "sTitle": "Employee Name",

                    },
                    {
                        "mData": null,
                        "sTitle": "Old Image",
                        "sClass": "text-center",
                        mRender: function (data, type, row) {
                            if (row.OldImage != null || row.OldImage != "")
                                return "<td class='halign-center'><img  onerror=\"this.src='../img/avatar-sign.png'\"  src='" + data.OldImage + "' class='img-circle' alt='User Image'></td>";
                            else
                                return "";
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "New Image",
                        "sClass": "text-center",
                        mRender: function (data, type, row) {
                            if (row.NewImage != null || row.NewImage != "")
                                return "<td class='halign-center'><img  onerror=\"this.src='../img/avatar-sign.png'\"  src='" + data.NewImage + "' class='img-circle' alt='User Image'></td>";
                            else
                                return "";
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Old Mobile No",
                        mRender: function (data, type, row) {
                            if (row.OldMobNo != null || row.OldMobNo != "")
                                return row.OldMobNo;
                            else
                                return "";
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "New Mobile No",
                        mRender: function (data, type, row) {
                            if (row.NewMobNo != null || row.NewMobNo != "")
                                return row.NewMobNo;
                            else
                                return "";
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        "sWidth": "80px",
                        "className": "all",
                        mRender: function (data, type, row) {
                            var html = '&nbsp;<button type="button" class="btn btn-sm btn-success" onclick="verifyProfileRequest(\'' + row.RequestId + '\',2' + ')" data-toggle="tooltip" title="Approve"><i class="fa fa-check"> </i></button>';
                            html += '&nbsp;<button type="button" class="btn btn-sm btn-danger" data-toggle"model" data-target="#myModal"' + 'onclick="showPopup(\'' + row.RequestId + '\',1' + ')" data-toggle="tooltip" title="Reject"><i class="fa fa-times"> </i></button>';
                            return html;
                        }
                    },
                ]
            });
        });
    profileRequestPending = $('#tblLeaveReviewRequestPending').DataTable();
}
function bindVerifiedProfileRequests() {
    //var html = "<button type='button' class='btn btn-primary' onclick=\"showPopupOnBulkApprove('leave','AP','NULL')\"><i class='fa fa-check'></i>&nbsp;Bulk Approve </button>";
    //$("#divBulkProfileApprove").html(html);
    var jsonObject = {
        status: "Verified"
    }
    calltoAjax(misApiUrl.getAllProfilePendingRequests, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#tblVerifiedProfileVerification").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'Pending Profile Verification List',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'Pending Profile Verification List' },
                        { extend: 'pdf', filename: 'Pending Profile Verification List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                        { extend: 'print', filename: 'Pending Profile Verification List' },
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
                "aaData": resultData,
                "aoColumns": [

                    {
                        "mData": "UserName",
                        "sTitle": "Employee Name",

                    },
                    {
                        "mData": null,
                        "sTitle": "Old Image",
                        "sClass": "text-center",
                        mRender: function (data, type, row) {
                            if (row.OldImage != null || row.OldImage != "")
                                return "<td class='halign-center'><img  onerror=\"this.src='../img/avatar-sign.png'\"  src='" + data.OldImage + "' class='img-circle' alt='User Image'></td>";
                            else
                                return "";
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "New Image",
                        "sClass": "text-center",
                        mRender: function (data, type, row) {
                            if (row.NewImage != null || row.NewImage != "")
                                return "<td class='halign-center'><img  onerror=\"this.src='../img/avatar-sign.png'\"  src='" + data.NewImage + "' class='img-circle' alt='User Image'></td>";
                            else
                                return "";
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Old Mobile No",
                        mRender: function (data, type, row) {
                            if (row.OldMobNo != null || row.OldMobNo != "")
                                return row.OldMobNo;
                            else
                                return "";
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "New Mobile No",
                        mRender: function (data, type, row) {
                            if (row.NewMobNo != null || row.NewMobNo != "")
                                return row.NewMobNo;
                            else
                                return "";
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Status",
                        mRender: function (data, type, row) {
                            if (row.IsVerified == true)
                                return '<span class="label label-success">Approved</span>';
                            else
                                return '<span class="label label-danger">Rejected</span><br><span>' + row.Reason + '</span>';
                        }
                    },

                ]
            });
        });

}
function showPopup(requestId, status) {
    _selectedId = requestId;
    $("#mypopupReviewProfile").modal("show");
}
function showPopupOnBulkApprove() {

    var selectedIds = [];
    var selectedEmployees = [];
    $("#tblProfileVerification").dataTable().$('input[type="checkbox"]').each(function () {
        if (this.checked) {
            selectedIds.push($(this).val());
            selectedEmployees.push(this.parentNode.nextElementSibling.firstChild.nodeValue.trim());
        }
    });
    var selectedEmployees = jQuery.unique(selectedEmployees);

    //var Names = selectedEmployees.join();
    var selectedRequestIds = selectedIds.join();
    //$("#employeesNames").html(Names);
    // $("#popupfor").html("Leave");
    if (selectedEmployees.length > 0) {
        bulkApproveProfileRequests(selectedRequestIds);
    }
    else {
        misAlert("Please select an employee.", "Warning", "warning");
    }
}
function bulkApproveProfileRequests(selectedRequestIds) {
    var jsonObject = {
        requestIds: selectedRequestIds,
    }
    misConfirm("Are you sure you want to approve these request?", "Confirm", function (isConfirmed) {
        if (isConfirmed) {
            calltoAjax(misApiUrl.verifyBulkUserProfile, "POST", jsonObject,
                function (result) {
                    var resultData = $.parseJSON(JSON.stringify(result));
                    if (resultData) {
                        misAlert("Request has been approved successfully.", "Success", "success");
                        bindPendingProfileRequests();
                        bindVerifiedProfileRequests();

                    }
                    else
                        misAlert('Your request cannot be processed, please try after some time or contact to MIS team for further assistance.', 'Error', 'error');
                });
        }
    });
}
function verifyProfileRequest(requestId, status) {
    var jsonObject = {
        requestId: requestId,
        status: status,
        reason: status == 2 ? "" : $("#reviewProfile").val()
    }
    misConfirm("Are you sure you want to " + (status == 2 ? "approve" : "reject") + " this request?", "Confirm", function (isConfirmed) {
        if (isConfirmed) {
            calltoAjax(misApiUrl.verifyUserProfile, "POST", jsonObject,
                function (result) {
                    var resultData = $.parseJSON(JSON.stringify(result));
                    if (resultData) {
                        misAlert("Request has been " + (status == 2 ? "approved" : "rejected") + " successfully.", "Success", "success");
                        bindPendingProfileRequests();
                        bindVerifiedProfileRequests();
                        $("#mypopupReviewProfile").modal("hide");
                    }
                    else
                        misAlert('Your request cannot be processed, please try after some time or contact to MIS team for further assistance.', 'Error', 'error');
                });
        }
    });
}