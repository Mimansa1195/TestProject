var _ajaxCallBasePath = window.location.pathname, UserRole, UserDesignation, IsHRVerifier, _IsForwarded = true;
var _applicationId, _status, _type, _period, _remark, _applicantId = 0;

var rows_selected = [];
var Employee_selected = [];
var tableWFHReviewRequestPending = "";
var tableCompOffReviewRequestPending = "";
var tableLeaveReviewRequestPending = "";
var tableDataChangeReviewRequestPending = "";

$(document).ready(function () {
    bindFinancialYearDDL();
    if (misPermissions.isDelegatable) {
        var html = '';
        if (!misPermissions.isDelegated) {
            html = '<button id="btnUserDelegation" type="button" class="btn btn-success"><i class="fa fa-bolt"></i>&nbsp;Delegate</button>';
        }
        else {
            html = '<button id="btnUserDelegation" type="button" class="btn btn-success"><i class="fa fa-lightbulb-o" style="color: yellow;font-size: 20px;"></i>&nbsp;Delegate</button>';
        }
        $("#divDeligation").html(html);
    }

    $("#submitReviewLeaveRemark").click(function () {
        var remarks = $('#reviewLeaveRemark').val().trim();
        if (_status === "RJ" && remarks === "") {
            misAlert("Please fill remarks", "Warning", "warning");
            return;
        }
        onPopupButtonClick(remarks);
    });

    $("#tabApplyLeave").click(function (e) {
        GetPendingLeaves();
        GetApprovedRejectedLeaves();
    });

    $("#tabApplyWFH").click(function (e) {
        loadApprovedWFHGrid();
        loadWFHGrid();
    });

    $("#tabApplyCompOff").click(function (e) {
        GetpendingCompOffRequest();
        GetApprovedRejectedCompOffRequest();
    });

    $("#tabDataChangeReq").click(function (e) {
        GetPendingRejectDataChangeRequest();
        GetApprovedDataChangeRequest();
    });

    $('#ddlFinancialYear').on('change', function () {
        var tabId = $("#tab a.active").attr('href');
        getData(tabId);
    });

    $('#tabs a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
        var targetTabId = $(e.target).attr("href"); // activated tab
        getData(targetTabId);
    });

    // For Leave
    // Handle click on checkbox
    $('body').on('click', '#tblLeaveReviewRequestPending tbody input[type="checkbox"]', function (e) {
        var $row = $(this).closest('tr');
        // Get row data
        var data = tableLeaveReviewRequestPending.row($row).data();
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
        updateDataTableSelectAllCtrlUn(tableLeaveReviewRequestPending);
        // Prevent click event from propagating to parent
        e.stopPropagation();
    });

    // Handle click on "Select all " control
    $('body').on('click', '#LeaveReviewRequestPending', function (e) {
        if (this.checked) {
            $('input[type="checkbox"]', '#tblLeaveReviewRequestPending').prop('checked', true);
            var count = $('#tblLeaveReviewRequestPending tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        } else {
            $('input[type="checkbox"]', '#tblLeaveReviewRequestPending').prop('checked', false);
            var count = $('#tblLeaveReviewRequestPending tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        }
        // Prevent click event from propagating to parent
        e.stopPropagation();
    })

    // Handle click on "Select all " control
    $('#tblLeaveReviewRequestPending tbody').on('click', 'input[Name="UnCheckbox"]', function (e) {
        if (this.checked) {
            $('input[type="checkbox"]', '#tblLeaveReviewRequestPending').prop('checked', true);
            var count = $('#tblLeaveReviewRequestPending tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        } else {
            $('input[type="checkbox"]', '#tblLeaveReviewRequestPending').prop('checked', false);
            var count = $('#tblLeaveReviewRequestPending tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        }
        // Prevent click event from propagating to parent
        e.stopPropagation();
    })

    // Handle click on tableLeaveReviewRequestPending cells with checkboxes
    $('#tblLeaveReviewRequestPending tbody').on('click', 'input[type="checkbox"]', function (e) {
        if (e.target.name != "UnCheckbox") {
            $(this).parent().find('input[type="checkbox"]').trigger('click');
            var count = $('#tblLeaveReviewRequestPending tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        }
        else {
            var count = $('#tblLeaveReviewRequestPending tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        }
    });

    // Handle table draw event
    if (tableLeaveReviewRequestPending) {
        tableLeaveReviewRequestPending.on('draw', function () {
            // Update state of "Select all" control
            updateDataTableSelectAllCtrlUn(tableLeaveReviewRequestPending);
        });
    }


    // For WFH
    // Handle click on checkbox
    $('body').on('click', '#tblWFHReviewRequestPending tbody input[type="checkbox"]', function (e) {
        var $row = $(this).closest('tr');
        // Get row data
        var data = tableWFHReviewRequestPending.row($row).data();
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
        updateDataTableSelectAllCtrlUn(tableWFHReviewRequestPending);
        // Prevent click event from propagating to parent
        e.stopPropagation();
    });

    // Handle click on "Select all " control
    $('body').on('click', '#WFHReviewRequestPending', function (e) {
        if (this.checked) {
            $('input[type="checkbox"]', '#tblWFHReviewRequestPending').prop('checked', true);
            var count = $('#tblWFHReviewRequestPending tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        } else {
            $('input[type="checkbox"]', '#tblWFHReviewRequestPending').prop('checked', false);
            var count = $('#tblWFHReviewRequestPending tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        }
        // Prevent click event from propagating to parent
        e.stopPropagation();
    })

    // Handle click on "Select all " control
    $('#tblWFHReviewRequestPending tbody').on('click', 'input[Name="UnCheckbox"]', function (e) {
        if (this.checked) {
            $('input[type="checkbox"]', '#tblWFHReviewRequestPending').prop('checked', true);
            var count = $('#tblWFHReviewRequestPending tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        } else {
            $('input[type="checkbox"]', '#tblWFHReviewRequestPending').prop('checked', false);
            var count = $('#tblWFHReviewRequestPending tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        }
        // Prevent click event from propagating to parent
        e.stopPropagation();
    })

    // Handle click on tableWFHReviewRequestPending cells with checkboxes
    $('#tblWFHReviewRequestPending tbody').on('click', 'input[type="checkbox"]', function (e) {
        if (e.target.name != "UnCheckbox") {
            $(this).parent().find('input[type="checkbox"]').trigger('click');
            var count = $('#tblWFHReviewRequestPending tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        }
        else {
            var count = $('#tblWFHReviewRequestPending tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        }
    });

    // Handle table draw event
    if (tableWFHReviewRequestPending) {
        tableWFHReviewRequestPending.on('draw', function () {
            // Update state of "Select all" control
            updateDataTableSelectAllCtrlUn(tableWFHReviewRequestPending);
        });
    }

    // For Comp Off.
    // Handle click on checkbox
    $('body').on('click', '#tblCompOffReviewRequestPending tbody input[type="checkbox"]', function (e) {
        var $row = $(this).closest('tr');
        // Get row data
        var data = tableCompOffReviewRequestPending.row($row).data();
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
        updateDataTableSelectAllCtrlUn(tableCompOffReviewRequestPending);
        // Prevent click event from propagating to parent
        e.stopPropagation();
    });

    // Handle click on "Select all " control
    $('body').on('click', '#CompOffReviewRequestPending', function (e) {
        if (this.checked) {
            $('input[type="checkbox"]', '#tblCompOffReviewRequestPending').prop('checked', true);
            var count = $('#tblCompOffReviewRequestPending tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        } else {
            $('input[type="checkbox"]', '#tblCompOffReviewRequestPending').prop('checked', false);
            var count = $('#tblCompOffReviewRequestPending tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        }
        // Prevent click event from propagating to parent
        e.stopPropagation();
    })

    // Handle click on "Select all " control
    $('#tblCompOffReviewRequestPending tbody').on('click', 'input[Name="UnCheckbox"]', function (e) {
        if (this.checked) {
            $('input[type="checkbox"]', '#tblCompOffReviewRequestPending').prop('checked', true);
            var count = $('#tblCompOffReviewRequestPending tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        } else {
            $('input[type="checkbox"]', '#tblCompOffReviewRequestPending').prop('checked', false);
            var count = $('#tblCompOffReviewRequestPending tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        }
        // Prevent click event from propagating to parent
        e.stopPropagation();
    })

    // Handle click on tableCompOffReviewRequestPending cells with checkboxes
    $('#tblCompOffReviewRequestPending tbody').on('click', 'input[type="checkbox"]', function (e) {
        if (e.target.name != "UnCheckbox") {
            $(this).parent().find('input[type="checkbox"]').trigger('click');
            var count = $('#tblCompOffReviewRequestPending tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        }
        else {
            var count = $('#tblCompOffReviewRequestPending tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        }
    });

    // Handle table draw event
    if (tableCompOffReviewRequestPending) {
        tableCompOffReviewRequestPending.on('draw', function () {
            // Update state of "Select all" control
            updateDataTableSelectAllCtrlUn(tableCompOffReviewRequestPending);
        });
    }

});
/// for data change request
// Handle click on checkbox
$('body').on('click', '#tblDataChangeReviewRequestPending tbody input[type="checkbox"]', function (e) {
    var $row = $(this).closest('tr');
    // Get row data
    var data = tableDataChangeReviewRequestPending.row($row).data();
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
    updateDataTableSelectAllCtrlUn(tableDataChangeReviewRequestPending);
    // Prevent click event from propagating to parent
    e.stopPropagation();
});

// Handle click on "Select all " control
$('body').on('click', '#DataChangeReviewRequestPending', function (e) {
    if (this.checked) {
        $('input[type="checkbox"]', '#tblDataChangeReviewRequestPending').prop('checked', true);
        var count = $('#tblDataChangeReviewRequestPending tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    } else {
        $('input[type="checkbox"]', '#tblDataChangeReviewRequestPending').prop('checked', false);
        var count = $('#tblDataChangeReviewRequestPending tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    }
    // Prevent click event from propagating to parent
    e.stopPropagation();
})

// Handle click on "Select all " control
$('#tblDataChangeReviewRequestPending tbody').on('click', 'input[Name="UnCheckbox"]', function (e) {
    if (this.checked) {
        $('input[type="checkbox"]', '#tblDataChangeReviewRequestPending').prop('checked', true);
        var count = $('#tblDataChangeReviewRequestPending tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    } else {
        $('input[type="checkbox"]', '#tblDataChangeReviewRequestPending').prop('checked', false);
        var count = $('#tblDataChangeReviewRequestPending tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    }
    // Prevent click event from propagating to parent
    e.stopPropagation();
})

// Handle click on tableLeaveReviewRequestPending cells with checkboxes
$('#tblDataChangeReviewRequestPending tbody').on('click', 'input[type="checkbox"]', function (e) {
    if (e.target.name != "UnCheckbox") {
        $(this).parent().find('input[type="checkbox"]').trigger('click');
        var count = $('#tblDataChangeReviewRequestPending tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    }
    else {
        var count = $('#tblDataChangeReviewRequestPending tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    }
});

// Handle table draw event
if (tableDataChangeReviewRequestPending) {
    tableDataChangeReviewRequestPending.on('draw', function () {
        // Update state of "Select all" control
        updateDataTableSelectAllCtrlUn(tableDataChangeReviewRequestPending);
    });
}

function bindFinancialYearDDL() {
    calltoAjax(misApiUrl.getFinancialYears, "POST", '',
        function (result) {
            if (result !== null)
                $.each(result, function (index, item) {
                    $("#ddlFinancialYear").append($("<option></option>").val(item.StartYear).html(item.Text));
                });
            getcurrentUser(1);
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

function getData(activeTabId) {
    if (activeTabId === "#tabs-2-tab-1") {
        GetPendingLeaves();
        GetApprovedRejectedLeaves();
    }
    else if (activeTabId === "#tabs-2-tab-3") {
        loadApprovedWFHGrid();
        loadWFHGrid();
    }
    else if (activeTabId === "#tabs-2-tab-4") {
        GetpendingCompOffRequest();
        GetApprovedRejectedCompOffRequest();
    }
    else if (activeTabId === "#tabs-2-tab-5") {
        GetPendingRejectDataChangeRequest();
        GetApprovedDataChangeRequest();
        getLegitimateRequest();
    }
    else if (activeTabId === "#tabs-2-tab-6")
        getOutingRequest();
}
//Leave Review

function GetPendingLeaves() {
    showLoader('tblLeaveReviewRequestPending', true);
  

    var jsonObject = {
        'Status': "Pending",
        'userAbrhs': misSession.userabrhs,
        'year': $("#ddlFinancialYear").val()
    };
    calltoAjax(misApiUrl.getLeaves, "POST", jsonObject,
        function (result) {
            if (IsHRVerifier == true) {
                ShowPendingLeavesHR(result);
                var html = "<button type='button' class='btn btn-primary' onclick=\"showPopupOnBulkApprove('leave','AP','NULL')\"><i class='fa fa-check'></i>&nbsp;Bulk Approve </button>";
                $("#divBulkLeaveApprove").html(html);
            }
            else {
                ShowPendingLeavesMNG(result);
                var html = "<button type='button' class='btn btn-primary' onclick=\"showPopupOnBulkApprove('leave','PV','NULL')\"><i class='fa fa-check'></i>&nbsp;Bulk Approve </button>";
                $("#divBulkLeaveApprove").html(html);
            }
        });
}

function ShowPendingLeavesHR(data) {
    var data = $.parseJSON(JSON.stringify(data));
    $("#tblLeaveReviewRequestPending").dataTable({
        "dom": 'lBfrtip',
        "buttons": [
            {
                filename: 'Pending Leaves List',
                extend: 'collection',
                text: 'Export',
                buttons: [{ extend: 'copy' },
                { extend: 'excel', filename: 'Pending Leaves List' },
                { extend: 'pdf', filename: 'Pending Leaves List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                { extend: 'print', filename: 'Pending Leaves List' },
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
                "sTitle": '<input name="select_all" value="1" id="LeaveReviewRequestPending" type="checkbox" />',
                'className': 'dt-body-center',
                'render': function (data, type, full, meta) {
                    if (full.Selected) {
                        return '<input type="checkbox" name="id[' + full.LeaveApplicationId + ']" value="' + full.LeaveApplicationId + '" checked="' + full.LeaveApplicationId + '">';
                    }
                    else {
                        return '<input type="checkbox" name="id[' + full.LeaveApplicationId + ']" value="' + full.LeaveApplicationId + '">';
                    }

                }
            },
            {
                "mData": null,
                "sTitle": "Employee Name",
                "className": "all",
                mRender: function (data, type, row) {
                    var html = data.EmployeeName;
                    return html;
                }
            },
            {
                "mData": null,
                "sTitle": "Period",
                "sWidth": "90px",
                "className": "all",
                mRender: function (data, type, row) {
                    var html = data.FromDate + " to " + data.ToDate;
                    return html;
                }
            },
            {
                "mData": "LeaveType",
                "sTitle": "Leave Info",
            },
            {
                "mData": "Reason",
                "sTitle": "Reason",
            },
            {
                "mData": null,
                "sTitle": "Remark/Status",
                mRender: function (data, type, row) {

                    var html = '<a  onclick="showRemarksPopup(' + row.LeaveApplicationId + ',' + "'LEAVE'" + ')" >' + (row.ApproverRemarks == null ? '' : row.ApproverRemarks) + '</a>';
                    return html;
                }
            },
            {
                "mData": null,
                "sTitle": "Applied On",
                "sWidth": "90px",
                mRender: function (data, type, row) {
                    return toddMMMYYYYHHMMSSAP(row.CreatedDate);
                }
            },
            {
                "mData": null,
                "sTitle": "Action",
                "sWidth": "80px",
                "className": "all",
                mRender: function (data, type, row) {
                    var html = '&nbsp;<button type="button" class="btn btn-sm teal" data-toggle"model" data-target="#myModal"' + 'onclick="showPopup(' + row.LeaveApplicationId + ',' + "'leave'" + ',' + "'AP'" + ',' + "'NULL'" + ')" data-toggle="tooltip" title="Verify"><i class="fa fa-check"> </i></button>';
                    html += '&nbsp;<button type="button" class="btn btn-sm btn-danger" data-toggle"model" data-target="#myModal"' + 'onclick="showPopup(' + row.LeaveApplicationId + ',' + "'leave'" + ' ,' + "'RJ'" + ',' + "'NULL'" + ')" data-toggle="tooltip" title="Reject"><i class="fa fa-times"> </i></button>';
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

    tableLeaveReviewRequestPending = $('#tblLeaveReviewRequestPending').DataTable();
}
function ShowPendingLeavesMNG(data) {
    var data = $.parseJSON(JSON.stringify(data));
    $("#tblLeaveReviewRequestPending").dataTable({
        "dom": 'lBfrtip',
        "buttons": [
            {
                filename: 'Pending Leaves List',
                extend: 'collection',
                text: 'Export',
                buttons: [{ extend: 'copy' },
                { extend: 'excel', filename: 'Pending Leaves List' },
                { extend: 'pdf', filename: 'Pending Leaves List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                { extend: 'print', filename: 'Pending Leaves List' },
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
                "sTitle": '<input name="select_all" value="1" id="LeaveReviewRequestPending" type="checkbox" />',
                'className': 'dt-body-center',
                'render': function (data, type, full, meta) {
                    if (full.Selected) {
                        return '<input type="checkbox" name="id[' + full.LeaveApplicationId + ']" value="' + full.LeaveApplicationId + '" checked="' + full.LeaveApplicationId + '">';
                    }
                    else {
                        return '<input type="checkbox" name="id[' + full.LeaveApplicationId + ']" value="' + full.LeaveApplicationId + '">';
                    }

                }
            },
            {
                "mData": null,
                "sTitle": "Employee Name",
                "className": "all",
                mRender: function (data, type, row) {
                    var html = data.EmployeeName;
                    return html;
                }
            },
            {
                "mData": null,
                "sTitle": "Period",
                "sWidth": "90px",
                "className": "all",
                mRender: function (data, type, row) {
                    var html = data.FromDate + " to " + data.ToDate;
                    return html;
                }
            },
            {
                "mData": "LeaveType",
                "sTitle": "Leave Info",
            },
            {
                "mData": "Reason",
                "sTitle": "Reason",
            },
            {
                "mData": null,
                "sTitle": "Remark/Status",
                mRender: function (data, type, row) {
                    var html = '<a  onclick="showRemarksPopup(' + row.LeaveApplicationId + ',' + "'LEAVE'" + ')" >' + (row.ApproverRemarks == null ? '' : row.ApproverRemarks) + '</a>';
                    return html;
                }
            },
            {
                "mData": null,
                "sTitle": "Applied On",
                "sWidth": "90px",
                mRender: function (data, type, row) {
                    return toddMMMYYYYHHMMSSAP(row.CreatedDate);
                }
            },
            {
                "mData": null,
                "sTitle": "Action",
                "sWidth": "100px",
                "className": "all",
                mRender: function (data, type, row) {
                    var html = '&nbsp;<button type="button" class="btn btn-sm teal" data-toggle"model" data-target="#myModal"' + 'onclick="showPopup(' + row.LeaveApplicationId + ',' + "'leave'" + ' ,' + "'PV'" + ',' + "'NULL'" + ')" data-toggle="tooltip" title="Approve"><i class="fa fa-check"></i></button>';
                    html += '&nbsp;<button type="button" class="btn btn-sm teal" data-toggle"model" data-target="#myModal"' + 'onclick="ViewLeaveApplication(' + row.LeaveApplicationId + ',' + row.ApplicantID + ')" data-toggle="tooltip" title="Approve and Forward"><i class="fa fa-arrow-right"> </i></button>';
                    html += '&nbsp;<button type="button" class="btn btn-sm btn-danger" data-toggle"model" data-target="#myModal"' + 'onclick="showPopup(' + row.LeaveApplicationId + ',' + "'leave'" + ' ,' + "'RJ'" + ',' + "'NULL'" + ')" data-toggle="tooltip" title="Reject"><i class="fa fa-times"> </i></button>';
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
    tableLeaveReviewRequestPending = $('#tblLeaveReviewRequestPending').DataTable();
}

function GetApprovedRejectedLeaves() {
    showLoader('tblLeaveReviewRequestComplete', true);
    var jsonObject = {
        'Status': "Approved",
        'userAbrhs': misSession.userabrhs,
        'year': $("#ddlFinancialYear").val()
    };
    calltoAjax(misApiUrl.getLeaves, "POST", jsonObject,
        function (result) {
            if (IsHRVerifier == true) {
                ShowApprovedRejectedLeavesHR(result);
            }
            else
                ShowApprovedRejectedLeavesMNG(result);
        });
}

function ShowApprovedRejectedLeavesHR(data) {
    var data = $.parseJSON(JSON.stringify(data));
    $("#tblLeaveReviewRequestComplete").dataTable({
        "dom": 'lBfrtip',
        "buttons": [
            {
                filename: 'Leaves List',
                extend: 'collection',
                text: 'Export',
                buttons: [{ extend: 'copy' },
                { extend: 'excel', filename: 'Leaves List' },
                { extend: 'pdf', filename: 'Leaves List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                { extend: 'print', filename: 'Leaves List' },
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
                "mData": null,
                "sTitle": "Employee Name",
                "className": "all",
                mRender: function (data, type, row) {
                    var html = data.EmployeeName;
                    return html;
                }
            },
            {
                "mData": null,
                "sTitle": "Period",
                "sWidth": "90px",
                "className": "all",
                mRender: function (data, type, row) {
                    var html = data.FromDate + " to " + data.ToDate;
                    return html;
                }
            },
            {
                "mData": "LeaveType",
                "sTitle": "Leave Info",
            },
            {
                "mData": "Reason",
                "sTitle": "Reason",
            },
            {
                "mData": null,
                "sTitle": "Applied On",
                mRender: function (data, type, row) {
                    return toddMMMYYYYHHMMSSAP(row.CreatedDate);
                }
            },
            {
                "mData": null,
                "sTitle": "Remarks",
                mRender: function (data, type, row) {
                    var html = '<a  onclick="showRemarksPopup(' + row.LeaveApplicationId + ',' + "'LEAVE'" + ')" >' + (row.ApproverRemarks == null ? '' : row.ApproverRemarks) + '</a>';
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
            if (aData.ApproverRemarks == 'Marked by system' && aData.StatusCode == "AV") {
                $('td', nRow).css('background-color', '#f3f3a0');
            }
            else if (aData.StatusCode == "CA") {
                $('td', nRow).css('background-color', '#c2cbd2');
            }
            else if (aData.StatusCode == "RJ") {
                $('td', nRow).css('background-color', '#f3a0a0');
            }
        }
    });
}

function ShowApprovedRejectedLeavesMNG(data) {
    var data = $.parseJSON(JSON.stringify(data));
    $("#tblLeaveReviewRequestComplete").dataTable({
        "dom": 'lBfrtip',
        "buttons": [
            {
                filename: 'Leaves List',
                extend: 'collection',
                text: 'Export',
                buttons: [{ extend: 'copy' },
                { extend: 'excel', filename: 'Leaves List' },
                { extend: 'pdf', filename: 'Leaves List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                { extend: 'print', filename: 'Leaves List' },
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
                "mData": null,
                "sTitle": "Employee Name",
                "className": "all",
                mRender: function (data, type, row) {
                    var html = data.EmployeeName;
                    return html;
                }
            },
            {
                "mData": null,
                "sTitle": "Period",
                "sWidth": "90px",
                "className": "all",
                mRender: function (data, type, row) {
                    var html = data.FromDate + " to " + data.ToDate;
                    return html;
                }
            },
            {
                "mData": "LeaveType",
                "sTitle": "Leave Info",
            },
            {
                "mData": "Reason",
                "sTitle": "Reason",
            },
            {
                "mData": null,
                "sTitle": "Applied On",
                mRender: function (data, type, row) {
                    return toddMMMYYYYHHMMSSAP(row.CreatedDate);
                }
            },
            {
                "mData": null,
                "sTitle": "Remarks",
                mRender: function (data, type, row) {
                    var html = '<a  onclick="showRemarksPopup(' + row.LeaveApplicationId + ',' + "'LEAVE'" + ')" >' + (row.ApproverRemarks == null ? '' : row.ApproverRemarks) + '</a>';
                    return html;
                }
            },
            {
                "mData": "Status",
                "sTitle": "Status",
                "className": "all",
            },
        ],
        "fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
            if (aData.ApproverRemarks == 'Marked by system' && aData.StatusCode == "AV") {
                $('td', nRow).css('background-color', '#f3f3a0');
            }
            else if (aData.StatusCode == "CA") {
                $('td', nRow).css('background-color', '#c2cbd2');
            }
            else if (aData.StatusCode == "RJ") {
                $('td', nRow).css('background-color', '#f3a0a0');
            }
        }
    });
}

function forwardLeave(status) {
    if (!validateControls('myleaveapplicationPopup')) {
        return false;
    }
    var reply = misConfirm("Are you sure you want to approve and forward this leave", "Approve and forward to " + $("#empselect option:selected").text(), function (reply) {
        if (reply) {
            var forwardedid = $("#forwardedid").val()
                , leaveApplicationId = $("#appid").val()
                , remark = $('#remark').val();
            var jsonObject = {
                'RequestID': parseInt(leaveApplicationId),
                'Userabrhs': misSession.userabrhs,
                'Status': status,
                'Remark': remark,
                'ForwardedAbrhs': forwardedid,
            };
            //console.log(jsonObject);
            calltoAjax(misApiUrl.takeActionOnLeave, "POST", jsonObject,
                function (result) {
                    if (result == 'SUCCEED') {
                        //var st = Status == "PV" ? "Approved" : "Verified";
                        misAlert("Request processed successfully", "Success", "success")
                        GetPendingLeaves();
                        GetApprovedRejectedLeaves();
                        if (remark === "ApprovedHack") {
                            $("#myleaveapplicationPopup").modal("hide");
                        }
                    } else if (result == "DUPLICATE") {
                        misAlert("Unable to process request. Please try again", "Error", "error");
                    } else {
                        misAlert("Unable to process request. Please try again", "Error", "error");
                    }
                });
        }
    });
}

function approveLeave(LeaveApplicationId, Status, remark) {
    if (remark === "ApprovedHack") {
        remark = $('#remark').val();
    }
    if (LeaveApplicationId == 0) {
        LeaveApplicationId = $("#appid").val();
    }
    var forwardedid = $("#forwardedid").val();
    $("#forwardedid").val(0);
    var jsonObject = {
        'RequestID': parseInt(LeaveApplicationId),
        'Userabrhs': misSession.userabrhs,
        'Status': Status,
        'Remark': remark,
        'ForwardedAbrhs': forwardedid,
    };
    calltoAjax(misApiUrl.takeActionOnLeave, "POST", jsonObject,
        function (result) {
            if (result == 'SUCCEED') {
                var st = Status == "PV" ? "Approved" : "Verified";
                misAlert("Request processed successfully", "Success", "success")
                GetPendingLeaves();
                GetApprovedRejectedLeaves();
                if (remark === "ApprovedHack") {
                    $("#myleaveapplicationPopup").modal("hide");
                }

            } else if (result == "DUPLICATE") {

            } else {
                misAlert("Unable to process request. Please try again", "Error", "error");
            }
        });
}

function RejectLeave(LeaveApplicationId, remark) {
    var jsonObject = {};
    if (LeaveApplicationId == 0)
        jsonObject = {
            'RequestID': $("#appid").val(),
            'Userabrhs': misSession.userabrhs,
            'ForwardedAbrhs': 0,
            'Status': "RJ",
            'Remark': remark
        };
    else
        jsonObject = {
            'RequestID': LeaveApplicationId,
            'Userabrhs': misSession.userabrhs,
            'ForwardedAbrhs': 0,
            'Status': "RJ",
            'Remark': remark
        };
    calltoAjax(misApiUrl.takeActionOnLeave, "POST", jsonObject,
        function (result) {
            if (result == 'SUCCEED') {
                misAlert("Request processed successfully", "Success", "success");
                GetPendingLeaves();
                GetApprovedRejectedLeaves();
            } else if (result == "DUPLICATE") {

            } else {
                misAlert("Unable to process request. Please try again", "Error", "error");
            }
        });
}

function ViewLeaveApplication(ApplicationID, ApplicantID) {
    var jsonObject = {
        'ApplicationID': ApplicationID
    };
    calltoAjax(misApiUrl.getLeaveApplicationByApplicationID, "POST", jsonObject,
        function (result) {
            showLeaveApplication(result);
            LoadAllUsers(ApplicantID);
        });

}

$("#empselect").change(function () {
    $("#forwardedid").val($("#empselect option:selected").val());
});

function showLeaveApplication(data) {
    $("#myleaveapplicationPopup").modal("show");
    $('#empselect').select2();

    $("#empselect").attr('disabled', false);
    if (data.IsAvailableOnEmail)
        $("#ApplicationavilableOnEmail").attr("checked", "checked");

    if (data.IsAvailableOnMobile)
        $("#ApplicationavilableOnMobile").attr("checked", "checked");

    $("#remark").val('');
    $("#appid").val(data.LeaveApplicationId);
    $("#ApplicationFromDate").val(data.FromDate);
    $("#ApplicationTillDate").val(data.ToDate);
    $("#leaveType").val(data.LeaveType);
    $("#team").html(data.Department);
    $("#ApplicationReason").val(data.Reason);
    $("#ApplicationContactNumber").val(data.PrimaryContactNo);
    $("#ApplicationAltContactNumber").val(data.AlternativeContactNo);
    $("ApplicationLeaveType").val(data.LeaveType);
    $("#status").val(data.Status);
    $("#empName").html(data.EmployeeName);
    $("#totaldays").val(data.NoOfTotalDays);
    $("#leaveworkingdays").val(data.NoOfWorkingDays);

    if (data.Status != "Pending") {
        if (data.Status == "Approved" || data.Status == 'Verified') {
            $("#empselect").attr('disabled', 'disabled');
            $("#btnSubmitReject").show();
        }
        else
            if (IsHRVerifier == true)
                $("#btnSubmitVerify").show();
            else
                $("#btnSubmitApprove").show();
    }
    else {
        $("#btnSubmitReject").show();
        $("#btnSubmitApprove").show();
    }

}

function LoadAllUsers(ApplicantID) {
    var empselect = $('#empselect');
    $("#empselect").empty();
    $("#empselect").append($("<option></option>").val(0).html("Select"));
    calltoAjax(misApiUrl.listAllActiveUsers, "POST", '',
        function (result) {
            $.each(result, function (key, value) {
                if (value.UserId != ApplicantID)
                    $("#empselect").append("<option value =" + value.EmployeeAbrhs + " >" + value.EmployeeName + "</option>");
            });
        });
}

//WFH Review

function loadWFHGrid() {
    var jsonObject = {
        'Status': 'Pending',
        'userAbrhs': misSession.userabrhs,
        'year': $("#ddlFinancialYear").val()
    };
    calltoAjax(misApiUrl.getWFHRequest, "POST", jsonObject,
        function (result) {
            if (IsHRVerifier == true) {
                successListPendingWFHForHR(result);
                var html = "<button type='button' class='btn btn-primary' onclick=\"showPopupOnBulkApproveWFH('WFH', 'AP', 'NULL')\"><i class='fa fa-check'></i>&nbsp;Bulk Approve </button>";
                $("#divBulkWFHApprove").html(html);
            }
            else {
                successListPendingWFH(result);
                var html = "<button type='button' class='btn btn-primary' onclick=\"showPopupOnBulkApproveWFH('WFH', 'PV', 'NULL')\"><i class='fa fa-check'></i>&nbsp;Bulk Approve </button>";
                $("#divBulkWFHApprove").html(html);
            }
        });
}

function successListPendingWFHForHR(data) {
    var data = $.parseJSON(JSON.stringify(data));
    $("#tblWFHReviewRequestPending").dataTable({
        "dom": 'lBfrtip',
        "buttons": [
            {
                filename: 'WFH List',
                extend: 'collection',
                text: 'Export',
                buttons: [{ extend: 'copy' },
                { extend: 'excel', filename: 'WFH List' },
                { extend: 'pdf', filename: 'WFH List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                { extend: 'print', filename: 'WFH List' },
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
                "sTitle": '<input name="select_all" value="1" id="WFHReviewRequestPending" type="checkbox" />',
                'className': 'dt-body-center',
                'render': function (data, type, full, meta) {
                    if (full.Selected) {
                        return '<input type="checkbox" name="id[' + full.RequestID + ']" value="' + full.RequestID + '" checked="' + full.RequestID + '">';
                    }
                    else {
                        return '<input type="checkbox" name="id[' + full.RequestID + ']" value="' + full.RequestID + '">';
                    }

                }
            },
            {
                "mData": null,
                "sTitle": "Employee Name",
                "className": "all",
                mRender: function (data, type, row) {
                    var html = data.EmployeeName;
                    return html;
                }
            },
            {
                "mData": "WFHDate",
                "sTitle": "Date",
                "sWidth": "80px",
                "className": "all",
            },
            {
                "mData": "IsHalfDay",
                "sTitle": "Half Day",
                mRender: function (data, type, row) {
                    var html = "NO";
                    if (row.IsHalfDay) {
                        html = "YES";
                    }
                    return html;
                }
            },
            {
                "mData": "Reason",
                "sTitle": "Reason",
            },
            {
                "mData": null,
                "sTitle": "Applied On",
                "sWidth": "90px",
                mRender: function (data, type, row) {
                    return toddMMMYYYYHHMMSSAP(row.CreatedDate);
                }
            },
            {
                "mData": null,
                "sTitle": "Remark/Status",
                mRender: function (data, type, row) {
                    var html = '<a  onclick="showRemarksPopup(' + row.RequestID + ',' + "'WFH'" + ')" >' + (row.Remark == null ? '' : row.Remark) + '</a>';
                    return html;
                }
            },

            {
                "mData": null,
                "sTitle": "Action",
                "sWidth": "80px",
                "className": "all",
                mRender: function (data, type, row) {
                    var html = '&nbsp;<button type="button" class="btn btn-sm teal" data-toggle"model" data-target="#myModal"' + 'onclick="showPopup(' + row.RequestID + ',' + "'WFH'" + ' ,' + "'AP'" + ',' + "'NULL'" + ')" data-toggle="tooltip" title="Verify"><i class="fa fa-check"> </i></button>';
                    html += '&nbsp;<button type="button" class="btn btn-sm btn-danger" data-toggle"model" data-target="#myModal"' + 'onclick="showPopup(' + row.RequestID + ',' + "'WFH'" + ' ,' + "'RJ'" + ',' + "'NULL'" + ')" data-toggle="tooltip" title="Reject"><i class="fa fa-times"> </i></button>';
                    return html;
                }
            },
        ],
        'rowCallback': function (row, data, dataIndex) {
            var rowId = data.RequestID;
            // If row ID is in the list of selected row IDs
            if ($.inArray(rowId, rows_selected) !== -1) {
                $(row).find('input[type="checkbox"]').prop('checked', true);
                $(row).addClass('selected');
            }
        }
    });
    tableWFHReviewRequestPending = $('#tblWFHReviewRequestPending').DataTable();
}

function successListPendingWFH(data) {
    var data = $.parseJSON(JSON.stringify(data));
    $("#tblWFHReviewRequestPending").dataTable({
        "dom": 'lBfrtip',
        "buttons": [
            {
                filename: 'WFH List',
                extend: 'collection',
                text: 'Export',
                buttons: [{ extend: 'copy' },
                { extend: 'excel', filename: 'WFH List' },
                { extend: 'pdf', filename: 'WFH List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                { extend: 'print', filename: 'WFH List' },
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
                "sTitle": '<input name="select_all" value="1" id="WFHReviewRequestPending" type="checkbox" />',
                'className': 'dt-body-center',
                'render': function (data, type, full, meta) {
                    if (full.Selected) {
                        return '<input type="checkbox" name="id[' + full.RequestID + ']" value="' + full.RequestID + '" checked="' + full.RequestID + '">';
                    }
                    else {
                        return '<input type="checkbox" name="id[' + full.RequestID + ']" value="' + full.RequestID + '">';
                    }

                }
            },
            {
                "mData": null,
                "sTitle": "Employee Name",
                "className": "all",
                mRender: function (data, type, row) {
                    var html = data.EmployeeName;
                    return html;
                }
            },
            {
                "mData": "WFHDate",
                "sTitle": "Date",
                "sWidth": "80px",
                "className": "all",
            },
            {
                "mData": "IsHalfDay",
                "sTitle": "Half Day",
                mRender: function (data, type, row) {
                    var html = "NO";
                    if (row.IsHalfDay) {
                        html = "YES";
                    }
                    return html;
                }
            },
            {
                "mData": "Reason",
                "sTitle": "Reason",
            },
            {
                "mData": null,
                "sTitle": "Applied On",
                "sWidth": "90px",
                mRender: function (data, type, row) {
                    return toddMMMYYYYHHMMSSAP(row.CreatedDate);
                }
            },
            {
                "mData": null,
                "sTitle": "Remark/Status",
                mRender: function (data, type, row) {
                    var html = '<a  onclick="showRemarksPopup(' + row.RequestID + ',' + "'WFH'" + ')" >' + (row.Remark == null ? '' : row.Remark) + '</a>';
                    return html;
                }
            },

            {
                "mData": null,
                "sTitle": "Action",
                "sWidth": "80px",
                "className": "all",
                mRender: function (data, type, row) {
                    var html = '&nbsp;<button type="button" class="btn btn-sm teal" data-toggle"model" data-target="#myModal"' + 'onclick="showPopup(' + row.RequestID + ',' + "'WFH'" + ' ,' + "'PV'" + ',' + "'NULL'" + ')" data-toggle="tooltip" title="Approve"><i class="fa fa-check"> </i></button>';
                    html += '&nbsp;<button type="button" class="btn btn-sm btn-danger" data-toggle"model" data-target="#myModal"' + 'onclick="showPopup(' + row.RequestID + ',' + "'WFH'" + ' ,' + "'RJ'" + ',' + "'NULL'" + ')" data-toggle="tooltip" title="Reject"><i class="fa fa-times"> </i></button>';
                    return html;
                }
            },
        ],
        'rowCallback': function (row, data, dataIndex) {
            var rowId = data.RequestID;
            // If row ID is in the list of selected row IDs
            if ($.inArray(rowId, rows_selected) !== -1) {
                $(row).find('input[type="checkbox"]').prop('checked', true);
                $(row).addClass('selected');
            }
        }
    });
    tableWFHReviewRequestPending = $('#tblWFHReviewRequestPending').DataTable();
}

function TakeActionOnWFH(RequestID, status, remark) {
    var jsonObject = {
        'RequestID': RequestID,
        'Status': status,
        'Remark': remark,
        'IsForwarded': false,
        'UserAbrhs': misSession.userabrhs
    };
    calltoAjax(misApiUrl.takeActionOnWFH, "POST", jsonObject,
        function (result) {
            if (result == 'SUCCEED') {
                loadApprovedWFHGrid();
                loadWFHGrid();
                misAlert('Request processed successfully', "Success", "success");
            } else if (result == "DUPLICATE") {

            } else {
                misAlert("Unable to process request. please try again", "Error", "error");
            }
        });
}

function loadApprovedWFHGrid() {
    var jsonObject = {
        'Status': 'Approved',
        'userAbrhs': misSession.userabrhs,
        'year': $("#ddlFinancialYear").val()
    };
    calltoAjax(misApiUrl.getWFHRequest, "POST", jsonObject,
        function (result) {
            if (IsHRVerifier == true) {
                successListApprovedWFHForHR(result);
            }
            else
                successListApprovedWFH(result);
        });
}

function successListApprovedWFHForHR(data) {
    var data = $.parseJSON(JSON.stringify(data));
    $("#tblWFHReviewRequestComplete").dataTable({
        "dom": 'lBfrtip',
        "buttons": [
            {
                filename: 'WFH List',
                extend: 'collection',
                text: 'Export',
                buttons: [{ extend: 'copy' },
                { extend: 'excel', filename: 'WFH List' },
                { extend: 'pdf', filename: 'WFH List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                { extend: 'print', filename: 'WFH List' },
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
                "mData": null,
                "sTitle": "Employee Name",
                "className": "all",
                mRender: function (data, type, row) {
                    var html = data.EmployeeName;
                    return html;
                }
            },
            {
                "mData": "WFHDate",
                "sTitle": "Date",
                "sWidth": "80px",
                "className": "all"
            },
            {
                "mData": "IsHalfDay",
                "sTitle": "Half Day",
                mRender: function (data, type, row) {
                    var html = "NO";
                    if (row.IsHalfDay) {
                        html = "YES";
                    }
                    return html;
                }
            },
            {
                "mData": "Reason",
                "sTitle": "Reason",
            },
            {
                "mData": null,
                "sTitle": "Applied On",
                "sWidth": "90px",
                mRender: function (data, type, row) {
                    return toddMMMYYYYHHMMSSAP(row.CreatedDate);
                }
            },
            {
                "mData": null,
                "sTitle": "Remark/Status",
                mRender: function (data, type, row) {
                    var html = '<a  onclick="showRemarksPopup(' + row.RequestID + ',' + "'WFH'" + ')" >' + (row.Remark == null ? '' : row.Remark) + '</a>';
                    return html;
                }
            },
            {
                "mData": "Status",
                "sTitle": "Status",
                "className": "all"
            },
        ]
    });
}

function successListApprovedWFH(data) {
    var data = $.parseJSON(JSON.stringify(data));
    $("#tblWFHReviewRequestComplete").dataTable({
        "dom": 'lBfrtip',
        "buttons": [
            {
                filename: 'WFH List',
                extend: 'collection',
                text: 'Export',
                buttons: [{ extend: 'copy' },
                { extend: 'excel', filename: 'WFH List' },
                { extend: 'pdf', filename: 'WFH List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                { extend: 'print', filename: 'WFH List' },
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
                "mData": null,
                "sTitle": "Employee Name",
                "className": "all",
                mRender: function (data, type, row) {
                    var html = data.EmployeeName;
                    return html;
                }
            },
            {
                "mData": "WFHDate",
                "sTitle": "Date",
                "sWidth": "80px",
                "className": "all"
            },
            {
                "mData": "IsHalfDay",
                "sTitle": "Half Day",
                mRender: function (data, type, row) {
                    var html = "NO";
                    if (row.IsHalfDay) {
                        html = "YES";
                    }
                    return html;
                }
            },
            {
                "mData": "Reason",
                "sTitle": "Reason",
            },
            {
                "mData": null,
                "sTitle": "Applied On",
                "sWidth": "90px",
                mRender: function (data, type, row) {
                    return toddMMMYYYYHHMMSSAP(row.CreatedDate);
                }
            },
            {
                "mData": null,
                "sTitle": "Remark/Status",
                mRender: function (data, type, row) {
                    var html = '<a  onclick="showRemarksPopup(' + row.RequestID + ',' + "'WFH'" + ')" >' + (row.Remark == null ? '' : row.Remark) + '</a>';
                    return html;
                }
            },
            {
                "mData": "Status",
                "sTitle": "Status",
                "className": "all"
            },
        ]
    });
}

// Data change Request
function approveDataChangeRequest(ApplicationId, remark, status, period) {
    var isForwarded = false;
    var jsonObject = {
        'Id': parseInt(ApplicationId),
        'Status': status,
        'Remarks': remark,
        'Period': period,
        'UserAbrhs': misSession.userabrhs,
    };
    calltoAjax(misApiUrl.takeActionOnDataChangeRequest, "POST", jsonObject,
        function (result) {
            if (result == "SUCCEED") {
                GetPendingRejectDataChangeRequest();
                GetApprovedDataChangeRequest();
                misAlert("Request processed successfully", "Success", "success");
            } else if (result == "DUPLICATE") {

            } else {
                misAlert("Unable to process request", "Error", "error");
            }
        });
}

function RejectDataChangeRequest(ApplicationId, remark, status, period) {
    var jsonObject = {
        'Id': ApplicationId,
        'Status': 'RJ',
        'Remarks': remark,
        'Period': period,
        'UserAbrhs': misSession.userabrhs,
    };
    calltoAjax(misApiUrl.takeActionOnDataChangeRequest, "POST", jsonObject,
        function (result) {
            if (result == "SUCCEED") {
                GetPendingRejectDataChangeRequest();
                GetApprovedDataChangeRequest();
                misAlert("Request processed successfully", "Success", "success")
            } else if (result == "DUPLICATE") {

            } else {
                misAlert("Unable to process request", "Error", "error");
            }
        });
}

function GetPendingRejectDataChangeRequest() {
    var jsonObject = {
        'status': 'PA',
        'userAbrhs': misSession.userabrhs,
        'year': $("#ddlFinancialYear").val()
    };
    calltoAjax(misApiUrl.getDataChangeRequest, "POST", jsonObject,
        function (result) {
            if (IsHRVerifier == true) {
                showPendingDataChangeRequestForHR(result);
                var html = "<button type='button' class='btn btn-primary' onclick=\"showPopupOnBulkApproveDataChange('dataChange','AP','NULL')\"><i class='fa fa-check'></i>&nbsp;Bulk Approve </button>";
                $("#divBulkDataChangeRequestApprove").html(html);

            } else {
                showPendingDataChangeRequest(result);
                var html = "<button type='button' class='btn btn-primary' onclick=\"showPopupOnBulkApproveDataChange('dataChange','PV','NULL')\"><i class='fa fa-check'></i>&nbsp;Bulk Approve </button>";
                $("#divBulkDataChangeRequestApprove").html(html);
            }
        });
}

function GetApprovedDataChangeRequest() {
    var jsonObject = {
        'status': 'AP',
        'userAbrhs': misSession.userabrhs,
        'year': $("#ddlFinancialYear").val()
    };
    calltoAjax(misApiUrl.getDataChangeRequest, "POST", jsonObject,
        function (result) {
            if (IsHRVerifier == true) {
                showApprovedRejectedDataChangeRequestForHR(result);
            } else {
                showApprovedRejectedDataChangeRequest(result);
            }
        });
}

function showPendingDataChangeRequest(data) {
    var data = $.parseJSON(JSON.stringify(data));
    $("#tblDataChangeReviewRequestPending").dataTable({
        "dom": 'lBfrtip',
        "buttons": [
            {
                filename: 'Data Change Request List',
                extend: 'collection',
                text: 'Export',
                buttons: [{ extend: 'copy' },
                { extend: 'excel', filename: 'Data Change Request List' },
                { extend: 'pdf', filename: 'Data Change Request List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                { extend: 'print', filename: 'Data Change Request List' },
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
                "sTitle": '<input name="select_all" value="1" id="DataChangeReviewRequestPending" type="checkbox" />',
                'className': 'dt-body-center',
                'render': function (data, type, full, meta) {
                    if (full.Selected) {
                        return '<input type="checkbox" name="id[' + full.DataChangeRequestApplicationId + ']" value="' + full.DataChangeRequestApplicationId + '" checked="' + full.DataChangeRequestApplicationId + '">';
                    }
                    else {
                        return '<input type="checkbox" name="id[' + full.DataChangeRequestApplicationId + ']" value="' + full.DataChangeRequestApplicationId + '">';
                    }

                }
            },
            {
                "mData": null,
                "sTitle": "Employee Name",
                "className": "all",
                mRender: function (data, type, row) {
                    var html = data.EmployeeName;
                    return html;
                }
            },
            {
                "mData": "Category",
                "sTitle": "Category",
            },
            {
                "mData": "ChangePeriod",
                "sTitle": "Period",
                "sWidth": "85px",
                "className": "all",
            },
            {
                "mData": "Reason",
                "sTitle": "Reason",
            },
            {
                "mData": null,
                "sTitle": "Applied On",
                "sWidth": "90px",
                mRender: function (data, type, row) {
                    return toddMMMYYYYHHMMSSAP(row.CreatedDate);
                }
            },
            {
                "mData": null,
                "sTitle": "Remark/Status",
                mRender: function (data, type, row) {
                    var html = '<a  onclick="showRemarksPopup(' + row.DataChangeRequestApplicationId + ',' + "'DATACHANGE'" + ')" >' + (row.Remarks == null ? '' : row.Remarks) + '</a>';
                    return html;
                }
            },
            {
                "mData": null,
                "sTitle": "Action",
                "sWidth": "80px",
                "className": "all",
                mRender: function (data, type, row) {
                    var html = '&nbsp;<button type="button" class="btn btn-sm teal" data-toggle"model" data-target="#myModal"' + 'onclick="showPopup(' + row.DataChangeRequestApplicationId + ",'datachange', 'PV', '" + row.ChangePeriod + '\')" data-toggle="tooltip" title="Approve"><i class="fa fa-check"> </i></button>';
                    html += '&nbsp;<button type="button" class="btn btn-sm btn-danger" data-toggle"model" data-target="#myModal"' + 'onclick="showPopup(' + row.DataChangeRequestApplicationId + ",'datachange', 'RJ', '" + row.ChangePeriod + '\')" data-toggle="tooltip" title="Reject"><i class="fa fa-times"> </i></button>';
                    return html;
                }
            },
        ],
        'rowCallback': function (row, data, dataIndex) {
            var rowId = data.RequestID;
            // If row ID is in the list of selected row IDs
            if ($.inArray(rowId, rows_selected) !== -1) {
                $(row).find('input[type="checkbox"]').prop('checked', true);
                $(row).addClass('selected');
            }
        }
    });
    tableDataChangeReviewRequestPending = $('#tblDataChangeReviewRequestPending').DataTable();
}


function showPendingDataChangeRequestForHR(data) {
    var data = $.parseJSON(JSON.stringify(data));
    $("#tblDataChangeReviewRequestPending").dataTable({
        "dom": 'lBfrtip',
        "buttons": [
            {
                filename: 'Data Change Request List',
                extend: 'collection',
                text: 'Export',
                buttons: [{ extend: 'copy' },
                { extend: 'excel', filename: 'Data Change Request List' },
                { extend: 'pdf', filename: 'Data Change Request List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                { extend: 'print', filename: 'Data Change Request List' },
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
                "sTitle": '<input name="select_all" value="1" id="DataChangeReviewRequestPending" type="checkbox" />',
                'className': 'dt-body-center',
                'render': function (data, type, full, meta) {
                    if (full.Selected) {
                        return '<input type="checkbox" name="id[' + full.DataChangeRequestApplicationId + ']" value="' + full.DataChangeRequestApplicationId + '" checked="' + full.DataChangeRequestApplicationId + '">';
                    }
                    else {
                        return '<input type="checkbox" name="id[' + full.DataChangeRequestApplicationId + ']" value="' + full.DataChangeRequestApplicationId + '">';
                    }

                }
            },
            {
                "mData": null,
                "sTitle": "Employee Name",
                "className": "all",
                mRender: function (data, type, row) {
                    var html = data.EmployeeName;
                    return html;
                }
            },
            {
                "mData": "Category",
                "sTitle": "Category",
            },
            {
                "mData": "ChangePeriod",
                "sTitle": "Period",
                "sWidth": "85px",
                "className": "all",
            },
            {
                "mData": "Reason",
                "sTitle": "Reason",
            },
            {
                "mData": null,
                "sTitle": "Applied On",
                "sWidth": "90px",
                mRender: function (data, type, row) {
                    return toddMMMYYYYHHMMSSAP(row.CreatedDate);
                }
            },
            {
                "mData": null,
                "sTitle": "Remark/Status",
                mRender: function (data, type, row) {
                    var html = '<a  onclick="showRemarksPopup(' + row.DataChangeRequestApplicationId + ',' + "'DATACHANGE'" + ')" >' + (row.Remarks == null ? '' : row.Remarks) + '</a>';
                    return html;
                }
            },
            {
                "mData": null,
                "sTitle": "Action",
                "sWidth": "80px",
                "className": "all",
                mRender: function (data, type, row) {
                    var html = '&nbsp;<button type="button" class="btn btn-sm teal" data-toggle"model" data-target="#myModal"' + 'onclick="showPopup(' + row.DataChangeRequestApplicationId + ",'datachange', 'AP', '" + row.ChangePeriod + '\')" data-toggle="tooltip" title="Verify"><i class="fa fa-check"> </i></button>';
                    html += '&nbsp;<button type="button" class="btn btn-sm btn-danger" data-toggle"model" data-target="#myModal"' + 'onclick="showPopup(' + row.DataChangeRequestApplicationId + ",'datachange', 'RJ', '" + row.ChangePeriod + '\')" data-toggle="tooltip" title="Reject"><i class="fa fa-times"> </i></button>';
                    return html;
                }
            },
        ],
        'rowCallback': function (row, data, dataIndex) {
            var rowId = data.RequestID;
            // If row ID is in the list of selected row IDs
            if ($.inArray(rowId, rows_selected) !== -1) {
                $(row).find('input[type="checkbox"]').prop('checked', true);
                $(row).addClass('selected');
            }
        }
    });
    tableDataChangeReviewRequestPending = $('#tblDataChangeReviewRequestPending').DataTable();
}

function showApprovedRejectedDataChangeRequest(data) {
    var data = $.parseJSON(JSON.stringify(data));
    $("#tblDataChangeReviewRequestComplete").dataTable({
        "dom": 'lBfrtip',
        "buttons": [
            {
                filename: 'Data Change Request List',
                extend: 'collection',
                text: 'Export',
                buttons: [{ extend: 'copy' },
                { extend: 'excel', filename: 'Data Change Request List' },
                { extend: 'pdf', filename: 'Data Change Request List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                { extend: 'print', filename: 'Data Change Request List' },
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
                "mData": null,
                "sTitle": "Employee Name",
                "className": "all",
                mRender: function (data, type, row) {
                    var html = data.EmployeeName;
                    return html;
                }
            },
            {
                "mData": "Category",
                "sTitle": "Category",
            },
            {
                "mData": "ChangePeriod",
                "sTitle": "Period",
                "sWidth": "85px",
                "className": "all",
            },
            {
                "mData": "Reason",
                "sTitle": "Reason",
            },
            {
                "mData": null,
                "sTitle": "Applied On",
                "sWidth": "90px",
                mRender: function (data, type, row) {
                    return toddMMMYYYYHHMMSSAP(row.CreatedDate);
                }
            },
            {
                "mData": null,
                "sTitle": "Remark/Status",
                mRender: function (data, type, row) {
                    var html = '<a  onclick="showRemarksPopup(' + row.DataChangeRequestApplicationId + ',' + "'DATACHANGE'" + ')" >' + (row.Remarks == null ? '' : row.Remarks) + '</a>';
                    return html;
                }
            },
            {
                "mData": "Status",
                "sTitle": "Status",
                "className": "all"
            },
        ]
    });
}

function showApprovedRejectedDataChangeRequestForHR(data) {
    var data = $.parseJSON(JSON.stringify(data));
    $("#tblDataChangeReviewRequestComplete").dataTable({
        "dom": 'lBfrtip',
        "buttons": [
            {
                filename: 'Data Change Request List',
                extend: 'collection',
                text: 'Export',
                buttons: [{ extend: 'copy' },
                { extend: 'excel', filename: 'Data Change Request List' },
                { extend: 'pdf', filename: 'Data Change Request List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                { extend: 'print', filename: 'Data Change Request List' },
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
                "mData": null,
                "sTitle": "Employee Name",
                "className": "all",
                mRender: function (data, type, row) {
                    var html = data.EmployeeName;
                    return html;
                }
            },
            {
                "mData": "Category",
                "sTitle": "Category",
            },
            {
                "mData": "ChangePeriod",
                "sTitle": "Period",
                "sWidth": "85px",
                "className": "all",
            },
            {
                "mData": "Reason",
                "sTitle": "Reason",
            },
            {
                "mData": null,
                "sTitle": "Applied On",
                "sWidth": "90px",
                mRender: function (data, type, row) {
                    return toddMMMYYYYHHMMSSAP(row.CreatedDate);
                }
            },
            {
                "mData": null,
                "sTitle": "Remark/Status",
                mRender: function (data, type, row) {
                    var html = '<a  onclick="showRemarksPopup(' + row.DataChangeRequestApplicationId + ',' + "'DATACHANGE'" + ')" >' + (row.Remarks == null ? '' : row.Remarks) + '</a>';
                    return html;
                }
            },
            {
                "mData": "Status",
                "sTitle": "Status",
                "className": "all"
            },
        ]
    });
}

// comp off review 

function approveCompOffRequest(RequestID, Status, remark) {
    var jsonObject = {
        'RequestID': RequestID,
        'Status': Status,
        'remark': remark,
        'UserAbrhs': misSession.userabrhs
    };
    calltoAjax(misApiUrl.takeActionOnCompOff, "POST", jsonObject,
        function (result) {
            if (result == 'SUCCEED') {
                misAlert("Request processed successfully", "Success", "success");
                GetpendingCompOffRequest();
                GetApprovedRejectedCompOffRequest();
            } else if (result == "DUPLICATE") {

            } else {
                misAlert("Unable to process request. Please try again", "Error", "error");
            }
        });
}

function RejectCompOffRequest(ApplicationId, Status, remark) {
    var jsonObject = {
        'RequestID': parseInt(ApplicationId),
        'Status': Status,
        'remark': remark,
        'UserAbrhs': misSession.userabrhs
    };
    calltoAjax(misApiUrl.takeActionOnCompOff, "POST", jsonObject,
        function (result) {
            if (result == 'SUCCEED') {
                misAlert("Request processed successfully", "Success", "success");
                GetpendingCompOffRequest();
                GetApprovedRejectedCompOffRequest();
            } else if (result == "DUPLICATE") {
            } else {
                misAlert("Unable to process request. Please try again", "Error", "error");
            }
        });
}

function GetpendingCompOffRequest() {
    var jsonObject = {
        'Status': "Pending",
        'userAbrhs': misSession.userabrhs,
        'year': $("#ddlFinancialYear").val()
    };
    calltoAjax(misApiUrl.getCompOffRequest, "POST", jsonObject,
        function (result) {
            if (IsHRVerifier == true) {

                ShowPendingCompOffRequestForHR(result);
                var html = "<button type='button' class='btn btn-primary' onclick=\"showPopupOnBulkApproveCOMPOff('compoff', 'AP', 'NULL')\"><i class='fa fa-check'></i>&nbsp;Bulk Approve </button>";
                $("#divBulkCompOffApprove").html(html);
            } else {
                ShowPendingCompOffRequest(result);
                var html = "<button type='button' class='btn btn-primary' onclick=\"showPopupOnBulkApproveCOMPOff('compoff', 'PV', 'NULL')\"><i class='fa fa-check'></i>&nbsp;Bulk Approve </button>";
                $("#divBulkCompOffApprove").html(html);
            }
        });
}

function GetApprovedRejectedCompOffRequest() {
    var jsonObject = {
        'Status': "Approved",
        'userAbrhs': misSession.userabrhs,
        'year': $("#ddlFinancialYear").val()
    };
    calltoAjax(misApiUrl.getCompOffRequest, "POST", jsonObject,
        function (result) {
            if (IsHRVerifier == true) {
                ShowApprovedRejectedCompOffRequestForHR(result);
            } else
                ShowApprovedRejectedCompOffRequest(result);
        });
}

function ShowPendingCompOffRequest(data) {
    var data = $.parseJSON(JSON.stringify(data));
    $("#tblCompOffReviewRequestPending").dataTable({
        "dom": 'lBfrtip',
        "buttons": [
            {
                filename: 'CompOff List',
                extend: 'collection',
                text: 'Export',
                buttons: [{ extend: 'copy' },
                { extend: 'excel', filename: 'CompOff List' },
                { extend: 'pdf', filename: 'CompOff List' },
                { extend: 'print', filename: 'CompOff List' },
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
                "sTitle": '<input name="select_all" value="1" id="CompOffReviewRequestPending" type="checkbox" />',
                'className': 'dt-body-center',
                'render': function (data, type, full, meta) {
                    if (full.Selected) {
                        return '<input type="checkbox" name="id[' + full.RequestID + ']" value="' + full.RequestID + '" checked="' + full.RequestID + '">';
                    }
                    else {
                        return '<input type="checkbox" name="id[' + full.RequestID + ']" value="' + full.RequestID + '">';
                    }

                }
            },
            {
                "mData": null,
                "sTitle": "Employee Name",
                "className": "all",
                mRender: function (data, type, row) {
                    var html = data.EmployeeName;
                    return html;
                }
            },
            {
                "mData": "CompOffDate",
                "sTitle": "Date",
                "sWidth": "80px",
                "className": "all",
            },
            {
                "mData": "NoOfDays",
                "sTitle": "Day(s)",
            },
            {
                "mData": "Reason",
                "sTitle": "Reason",
            },
            {
                "mData": null,
                "sTitle": "Applied On",
                "sWidth": "90px",
                mRender: function (data, type, row) {
                    return toddMMMYYYYHHMMSSAP(row.CreatedDate);
                }
            },
            {
                "mData": null,
                "sTitle": "Remark/Status",
                mRender: function (data, type, row) {
                    var html = '<a  onclick="showRemarksPopup(' + row.RequestID + ',' + "'COFF'" + ')" >' + (row.Remark == null ? '' : row.Remark) + '</a>';
                    return html;
                }
            },
            {
                "mData": "Status",
                "sTitle": "Status"
            },
            {
                "mData": null,
                "sTitle": "Action",
                "sWidth": "80px",
                "className": "all",
                mRender: function (data, type, row) {
                    var html = '&nbsp;<button type="button" class="btn btn-sm teal" data-toggle"model" data-target="#myModal"' + 'onclick="showPopup(' + row.RequestID + ',' + "'compoff'" + ' ,' + "'PV'" + ',' + "'NULL'" + ')" data-toggle="tooltip" title="Approve"><i class="fa fa-check"> </i></button>';
                    html += '&nbsp;<button type="button" class="btn btn-sm btn-danger" data-toggle"model" data-target="#myModal"' + 'onclick="showPopup(' + row.RequestID + ',' + "'compoff'" + ' ,' + "'RJ'" + ',' + "'NULL'" + ')" data-toggle="tooltip" title="Reject"><i class="fa fa-times"> </i></button>';
                    return html;
                }
            },
        ],
        'rowCallback': function (row, data, dataIndex) {
            var rowId = data.RequestID;
            // If row ID is in the list of selected row IDs
            if ($.inArray(rowId, rows_selected) !== -1) {
                $(row).find('input[type="checkbox"]').prop('checked', true);
                $(row).addClass('selected');
            }
        }
    });

    tableCompOffReviewRequestPending = $('#tblCompOffReviewRequestPending').DataTable();


}

function ShowPendingCompOffRequestForHR(data) {
    var data = $.parseJSON(JSON.stringify(data));
    $("#tblCompOffReviewRequestPending").dataTable({
        "dom": 'lBfrtip',
        "buttons": [
            {
                filename: 'CompOff List',
                extend: 'collection',
                text: 'Export',
                buttons: [{ extend: 'copy' },
                { extend: 'excel', filename: 'CompOff List' },
                { extend: 'pdf', filename: 'CompOff List' },
                { extend: 'print', filename: 'CompOff List' },
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
                "sTitle": '<input name="select_all" value="1" id="CompOffReviewRequestPending" type="checkbox" />',
                'className': 'dt-body-center',
                'render': function (data, type, full, meta) {
                    if (full.Selected) {
                        return '<input type="checkbox" name="id[' + full.RequestID + ']" value="' + full.RequestID + '" checked="' + full.RequestID + '">';
                    }
                    else {
                        return '<input type="checkbox" name="id[' + full.RequestID + ']" value="' + full.RequestID + '">';
                    }

                }
            },
            {
                "mData": null,
                "sTitle": "Employee Name",
                "className": "all",
                mRender: function (data, type, row) {
                    var html = data.EmployeeName;
                    return html;
                }
            },
            {
                "mData": "CompOffDate",
                "sTitle": "Date",
                "sWidth": "80px",
                "className": "all",
            },
            {
                "mData": "NoOfDays",
                "sTitle": "Day(s)",
            },
            {
                "mData": "Reason",
                "sTitle": "Reason",
            },
            {
                "mData": null,
                "sTitle": "Applied On",
                "sWidth": "90px",
                mRender: function (data, type, row) {
                    return toddMMMYYYYHHMMSSAP(row.CreatedDate);
                }
            },
            {
                "mData": null,
                "sTitle": "Remark/Status",
                mRender: function (data, type, row) {
                    var html = '<a  onclick="showRemarksPopup(' + row.RequestID + ',' + "'COFF'" + ')" >' + (row.Remark == null ? '' : row.Remark) + '</a>';
                    return html;
                }
            },
            {
                "mData": "Status",
                "sTitle": "Status",
            },
            {
                "mData": null,
                "sTitle": "Action",
                "sWidth": "80px",
                "className": "all",
                mRender: function (data, type, row) {
                    var html = '&nbsp;<button type="button" class="btn btn-sm teal" data-toggle"model" data-target="#myModal"' + 'onclick="showPopup(' + row.RequestID + ',' + "'compoff'" + ' ,' + "'AP'" + ',' + "'NULL'" + ')" data-toggle="tooltip" title="Verify"><i class="fa fa-check"> </i></button>';
                    html += '&nbsp;<button type="button" class="btn btn-sm btn-danger" data-toggle"model" data-target="#myModal"' + 'onclick="showPopup(' + row.RequestID + ',' + "'compoff'" + ' ,' + "'RJ'" + ',' + "'NULL'" + ')" data-toggle="tooltip" title="Reject"><i class="fa fa-times"> </i></button>';
                    return html;
                }
            },
        ]
    });


}

function ShowApprovedRejectedCompOffRequest(data) {
    var data = $.parseJSON(JSON.stringify(data));
    $("#tblCompOffReviewRequestComplete").dataTable({
        "dom": 'lBfrtip',
        "buttons": [
            {
                filename: 'CompOff List',
                extend: 'collection',
                text: 'Export',
                buttons: [{ extend: 'copy' },
                { extend: 'excel', filename: 'CompOff List' },
                { extend: 'pdf', filename: 'CompOff List' },
                { extend: 'print', filename: 'CompOff List' },
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
                "mData": null,
                "sTitle": "Employee Name",
                "className": "all",
                mRender: function (data, type, row) {
                    var html = data.EmployeeName;
                    return html;
                }
            },
            {
                "mData": "CompOffDate",
                "sTitle": "Date",
                "sWidth": "80px",
                "className": "all"
            },
            {
                "mData": "NoOfDays",
                "sTitle": "Day(s)",
            },
            {
                "mData": "Reason",
                "sTitle": "Reason",
            },
            {
                "mData": null,
                "sTitle": "Applied On",
                "sWidth": "90px",
                mRender: function (data, type, row) {
                    return toddMMMYYYYHHMMSSAP(row.CreatedDate);
                }
            },
            {
                "mData": null,
                "sTitle": "Remark/Status",
                mRender: function (data, type, row) {
                    var html = '<a  onclick="showRemarksPopup(' + row.RequestID + ',' + "'COFF'" + ')" >' + (row.Remark == null ? '' : row.Remark) + '</a>';
                    return html;
                }
            },
            {
                "mData": "Status",
                "sTitle": "Status",
                "className": "all"
            },
        ]
    });



}

function ShowApprovedRejectedCompOffRequestForHR(data) {
    var data = $.parseJSON(JSON.stringify(data));
    $("#tblCompOffReviewRequestComplete").dataTable({
        "dom": 'lBfrtip',
        "buttons": [
            {
                filename: 'CompOff List',
                extend: 'collection',
                text: 'Export',
                buttons: [{ extend: 'copy' },
                { extend: 'excel', filename: 'CompOff List' },
                { extend: 'pdf', filename: 'CompOff List' },
                { extend: 'print', filename: 'CompOff List' },
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
                "mData": null,
                "sTitle": "Employee Name",
                "className": "all",
                mRender: function (data, type, row) {
                    var html = data.EmployeeName;
                    return html;
                }
            },
            {
                "mData": "CompOffDate",
                "sTitle": "Date",
                "sWidth": "80px",
                "className": "all",
            },
            {
                "mData": "NoOfDays",
                "sTitle": "Day(s)",
            },
            {
                "mData": "Reason",
                "sTitle": "Reason",
            },
            {
                "mData": null,
                "sTitle": "Applied On",
                "sWidth": "90px",
                mRender: function (data, type, row) {
                    return toddMMMYYYYHHMMSSAP(row.CreatedDate);
                }
            },
            {
                "mData": null,
                "sTitle": "Remark/Status",
                mRender: function (data, type, row) {
                    var html = '<a  onclick="showRemarksPopup(' + row.RequestID + ',' + "'COFF'" + ')" >' + (row.Remark == null ? '' : row.Remark) + '</a>';
                    return html;
                }
            },
            {
                "mData": "Status",
                "sTitle": "Status",
                "className": "all"
            },
        ]
    });

}

function showPopup(applicationId, type, status, period) {
    _applicationId = applicationId;
    _type = type;
    _status = status;
    _period = period;
    $("#mypopupReviewLeaveRemark").modal("show");
    $("#reviewLeaveRemark").val('');
    $("#submitReviewLeaveRemark").show();
    $("#reviewLeaveRemark").attr('disabled', false);
}

function onPopupButtonClick(remark) {
    if (_type === "leave") {
        if (_status === "RJ") {
            RejectLeave(_applicationId, remark);
        }
        else {
            approveLeave(_applicationId, _status, remark);
        }
    }
    else if (_type === "compoff") {
        if (_status === "RJ") {
            RejectCompOffRequest(_applicationId, _status, remark);
        }
        else {
            approveCompOffRequest(_applicationId, _status, remark);
        }
    }
    else if (_type === "WFH") {
        TakeActionOnWFH(_applicationId, _status, remark);
    }
    else if (_type === "datachange") {
        if (_status === "RJ") {
            RejectDataChangeRequest(_applicationId, remark, _status, _period);
        } else {
            approveDataChangeRequest(_applicationId, remark, _status, _period);
        }
    }
    $("#mypopupReviewLeaveRemark").modal("hide");
}

function showRemarksPopup(applicationId, type) {
    var jsonObject = {
        'requestId': applicationId,
        'type': type
    };
    calltoAjax(misApiUrl.getApproverRemarks, "POST", jsonObject,
        function (result) {
            if (result != "ERROR") {
                if (result == "") {
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

function getcurrentUser(tab) {
    var jsonObject = {
        'userAbrhs': misSession.userabrhs
    };
    calltoAjax(misApiUrl.getUserDetailsByUserId, "POST", jsonObject,
        function (data) {
            UserRole = (data.RoleName);
            UserDesignation = (data.Designation);
            IsHRVerifier = data.IsHRVerifier;
            if (tab == 1) {
                GetPendingLeaves();
                GetApprovedRejectedLeaves();
            }
            if (tab == 2) {
                loadApprovedWFHGrid();
                loadWFHGrid();
            }
            if (tab == 3) {
                GetpendingCompOffRequest();
                GetApprovedRejectedCompOffRequest();
            }
            if (tab == 4) {
                GetPendingRejectDataChangeRequest();
                GetApprovedDataChangeRequest();
            }
        });
}

$("#btnCloseForwardPopup").click(function myfunction() {
    $("#myleaveapplicationPopup").modal("hide");
});

// Bulk Approve Section 

function showPopupOnBulkApprove(type, status, period) {
    _typeOnBulkApprove = type;
    _statusOnBulkApprove = status;
    _periodOnBulkApprove = period;
    var selectedLeavesApplicationIds = [];
    var selectedEmployees = [];
    $("#tblLeaveReviewRequestPending").dataTable().$('input[type="checkbox"]').each(function () {
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


function showPopupOnBulkApproveWFH(type, status, period) {
    _typeOnBulkApprove = type;
    _statusOnBulkApprove = status;
    _periodOnBulkApprove = period;
    var selectedLeavesApplicationIds = [];
    var selectedEmployees = [];
    $("#tblWFHReviewRequestPending").dataTable().$('input[type="checkbox"]').each(function () {
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

function showPopupOnBulkApproveCOMPOff(type, status, period) {
    _typeOnBulkApprove = type;
    _statusOnBulkApprove = status;
    _periodOnBulkApprove = period;
    var selectedLeavesApplicationIds = [];
    var selectedEmployees = [];
    $("#tblCompOffReviewRequestPending").dataTable().$('input[type="checkbox"]').each(function () {
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
function showPopupOnBulkApproveDataChange(type, status, period) {
    _typeOnBulkApprove = type;
    _statusOnBulkApprove = status;
    _periodOnBulkApprove = period;
    var selectedLeavesApplicationIds = [];
    var selectedEmployees = [];
    $("#tblDataChangeReviewRequestPending").dataTable().$('input[type="checkbox"]').each(function () {
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

$("#submitReviewLeaveRemarkBulk").click(function () {
    if (!validateControls('remarkdiv')) {
        return false;
    }

    var remark = $("#reviewBulkRemark").val();
    if (_typeOnBulkApprove === "leave") {
        if (_statusOnBulkApprove === "PV") {
            bulkApproveLeave(_selectedLeavesApplicationIds, _statusOnBulkApprove, remark);
        }
        else if (_statusOnBulkApprove === "AP") {
            bulkApproveLeaveByHR(_selectedLeavesApplicationIds, _statusOnBulkApprove, remark);
        }

    }
    else if (_typeOnBulkApprove === "compoff") {
        if (_statusOnBulkApprove === "PV") {
            bulkApproveCompOffRequest(_selectedLeavesApplicationIds, _statusOnBulkApprove, remark);
        }
        else if (_statusOnBulkApprove === "AP") {
            bulkApproveCompOffRequestByHR(_selectedLeavesApplicationIds, _statusOnBulkApprove, remark);
        }

    }
    else if (_typeOnBulkApprove === "WFH") {
        if (_statusOnBulkApprove === "PV") {
            bulkApproveWFH(_selectedLeavesApplicationIds, _statusOnBulkApprove, remark);
        }
        else if (_statusOnBulkApprove === "AP") {
            bulkApproveWFHByHR(_selectedLeavesApplicationIds, _statusOnBulkApprove, remark);
        }
    }
    else if (_typeOnBulkApprove === "outing") {
        if (_statusOnBulkApprove === "AP") {
            bulkApproveOuting(_selectedLeavesApplicationIds, _statusOnBulkApprove, remark);
        }
    }
    else if (_typeOnBulkApprove === "LWP") {
        if (_statusOnBulkApprove === "AP") {
            bulkApproveLWPChangeRequest(_selectedLeavesApplicationIds, _statusOnBulkApprove, remark);
        }

    }
    else if (_typeOnBulkApprove === "dataChange") {
        if (_statusOnBulkApprove === "PV") {
            bulkApproveDataChange(_selectedLeavesApplicationIds, _statusOnBulkApprove, remark);
        }
        else if (_statusOnBulkApprove === "AP") {
            bulkApproveDataChangeByHR(_selectedLeavesApplicationIds, _statusOnBulkApprove, remark);
        }
    }
    $("#reviewBulkRemark").val("");
    $("#mypopupBulkApproveRemark").modal("hide");
});
$("#btnCloseBulkApprove").click(function () {

    $("#mypopupBulkApproveRemark").modal("hide");

});

function bulkApproveLeave(LeaveApplicationId, Status, remark) {

    var jsonObject = {
        'RequestID': LeaveApplicationId,
        'Userabrhs': misSession.userabrhs,
        'Status': Status,
        'Remark': remark,
        'ForwardedAbrhs': "",
    };
    calltoAjax(misApiUrl.takeActionOnLeaveBulkApprove, "POST", jsonObject,
        function (result) {
            if (result == 'SUCCEED') {
                misAlert("Request processed successfully", "Success", "success")

                GetPendingLeaves();
                GetApprovedRejectedLeaves();
            } else {
                misAlert("Unable to process request. Please try again", "Error", "error");
            }
        });
}
function bulkApproveLeaveByHR(LeaveApplicationId, Status, remark) {

    var jsonObject = {
        'RequestID': LeaveApplicationId,
        'Userabrhs': misSession.userabrhs,
        'Status': Status,
        'Remark': remark,
        'ForwardedAbrhs': "",
    };
    calltoAjax(misApiUrl.takeActionOnLeaveBulkApprove, "POST", jsonObject,
        function (result) {
            if (result == 'SUCCEED') {
                misAlert("Request processed successfully", "Success", "success")

                GetPendingLeaves();
                GetApprovedRejectedLeaves();
            } else {
                misAlert("Unable to process request. Please try again", "Error", "error");
            }
        });
}

function bulkApproveCompOffRequest(RequestID, Status, remark) {
    var jsonObject = {
        'RequestID': RequestID,
        'Status': Status,
        'remark': remark,
        'UserAbrhs': misSession.userabrhs
    };
    calltoAjax(misApiUrl.takeActionOnCompOffBulkApprove, "POST", jsonObject,
        function (result) {
            if (result == 'SUCCEED') {
                misAlert("Request processed successfully", "Success", "success");
                GetpendingCompOffRequest();
                GetApprovedRejectedCompOffRequest();
            }
            else {
                misAlert("Unable to process request. Please try again", "Error", "error");
            }
        });
}
function bulkApproveCompOffRequestByHR(RequestID, Status, remark) {
    var jsonObject = {
        'RequestID': RequestID,
        'Status': Status,
        'remark': remark,
        'UserAbrhs': misSession.userabrhs
    };
    calltoAjax(misApiUrl.takeActionOnCompOffBulkApprove, "POST", jsonObject,
        function (result) {
            if (result == 'SUCCEED') {
                misAlert("Request processed successfully", "Success", "success");
                GetpendingCompOffRequest();
                GetApprovedRejectedCompOffRequest();
            }
            else {
                misAlert("Unable to process request. Please try again", "Error", "error");
            }
        });
}

function bulkApproveWFH(RequestID, status, remark) {

    var jsonObject = {
        'RequestID': RequestID,
        'Status': status,
        'Remark': remark,
        'IsForwarded': false,
        'UserAbrhs': misSession.userabrhs
    };
    calltoAjax(misApiUrl.takeActionOnWFHBulkApprove, "POST", jsonObject,
        function (result) {
            if (result == 'SUCCEED') {
                loadApprovedWFHGrid();
                loadWFHGrid();
                misAlert('Request processed successfully', "Success", "success");
            } else {
                misAlert("Unable to process request. please try again", "Error", "error");
            }
        });
}
function bulkApproveWFHByHR(RequestID, status, remark) {

    var jsonObject = {
        'RequestID': RequestID,
        'Status': status,
        'Remark': remark,
        'IsForwarded': false,
        'UserAbrhs': misSession.userabrhs
    };
    calltoAjax(misApiUrl.takeActionOnWFHBulkApprove, "POST", jsonObject,
        function (result) {
            if (result == 'SUCCEED') {
                loadApprovedWFHGrid();
                loadWFHGrid();
                misAlert('Request processed successfully', "Success", "success");
            } else {
                misAlert("Unable to process request. please try again", "Error", "error");
            }
        });
}
function bulkApproveDataChange(RequestID, status, remark) {

    var jsonObject = {
        'RequestID': RequestID,
        'Status': status,
        'Remark': remark,
        //'IsForwarded': false,
        'UserAbrhs': misSession.userabrhs
    };
    calltoAjax(misApiUrl.takeActionOnDataChangeBulkApprove, "POST", jsonObject,
        function (result) {
            if (result == 'SUCCEED') {
                GetPendingRejectDataChangeRequest();
                GetApprovedDataChangeRequest();
                misAlert('Request processed successfully', "Success", "success");
            } else {
                misAlert("Unable to process request. please try again", "Error", "error");
            }
        });
}
function bulkApproveDataChangeByHR(RequestID, status, remark) {

    var jsonObject = {
        'RequestID': RequestID,
        'Status': status,
        'Remark': remark,
        // 'IsForwarded': false,
        'UserAbrhs': misSession.userabrhs
    };
    calltoAjax(misApiUrl.takeActionOnDataChangeBulkApprove, "POST", jsonObject,
        function (result) {
            if (result == 'SUCCEED') {
                GetPendingRejectDataChangeRequest();
                GetApprovedDataChangeRequest();
                misAlert('Request processed successfully', "Success", "success");
            } else {
                misAlert("Unable to process request. please try again", "Error", "error");
            }
        });
}