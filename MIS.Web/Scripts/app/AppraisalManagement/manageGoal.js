var currentDate = new Date();
var _StartDate, _EndDate, _StartDateT, _EndDateT;

var tableGoalList = "";
var _selectedTeamGoalIds = "";
var rows_selected = [];
var Team_selected = [];

//reportees goal
var _selectedReporteesGoalIds = "";
var tableReporteesGoalPending = "";
var rows_selected_reportees = [];

$(document).ready(function () {
    bindAllReportingEmployees("#ddlEmployee", 0);
    $('#ddlEmployee').multiselect({
        includeSelectAllOption: true,
        enableFiltering: true,
        enableCaseInsensitiveFiltering: true,
        buttonWidth: false,
        onDropdownHidden: function (event) {
        }
    });

    //reportees goal
    $("#ddlEmployee").change(function () {
        loadGoalGrid();
    });
    $("#financialYearForTeam").on('change', function () {
        loadGoalGrid();
    });
    $("a[href='#tabReporteesGoal']").click(function () {
        bindAllReportingEmployees("#ddlEmployee", 0);
        $('#ddlEmployee').multiselect({
            includeSelectAllOption: true,
            enableFiltering: true,
            enableCaseInsensitiveFiltering: true,
            buttonWidth: false,
            onDropdownHidden: function (event) {
            }
        });
    });

    //team goal
    $("#ddlTeam").change(function () {
        loadTeamGoalGrid();
    });
    $("#financialYearForTeamGoal").on('change', function () {
        loadTeamGoalGrid();
    });
    $("a[href='#tabTeamGoal']").click(function () {
        bindAllTeams("#ddlTeam", 0);
        $('#ddlTeam').multiselect({
            includeSelectAllOption: true,
            enableFiltering: true,
            enableCaseInsensitiveFiltering: true,
            buttonWidth: false,
            onDropdownHidden: function (event) {
            }
        });
    });
});

//reportees goal
// Handle click on checkbox
$('body').on('click', '#tblPendingReporteesGoalList tbody input[type="checkbox"]', function (e) {
    var $row = $(this).closest('tr');
    // Get row data
    var data = tableReporteesGoalPending.row($row).data();
    // Get row ID
    var rowId = data[0];
    // Determine whether row ID is in the list of selected row IDs
    var index = $.inArray(rowId, rows_selected_reportees);
    // If checkbox is checked and row ID is not in list of selected row IDs
    if (this.checked && index === -1) {
        rows_selected_reportees.push(rowId);
        //$(this).parent().parent("tr").addClass("selected");
        // Otherwise, if checkbox is not checked and row ID is in list of selected row IDs
    } else if (!this.checked && index !== -1) {
        rows_selected_reportees.splice(index, 1);
    }
    // Update state of "Select all" control
    updateDataTableSelectAllCtrlUn(tableReporteesGoalPending);
    // Prevent click event from propagating to parent
    e.stopPropagation();
});

// Handle click on "Select all " control
$('body').on('click', '#selectAllReporteesGoalPending', function (e) {
    if (this.checked) {
        $('input[type="checkbox"]', '#tblPendingReporteesGoalList').prop('checked', true);
        var count = $('#tblPendingReporteesGoalList tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    } else {
        $('input[type="checkbox"]', '#tblPendingReporteesGoalList').prop('checked', false);
        var count = $('#tblPendingReporteesGoalList tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    }
    // Prevent click event from propagating to parent
    e.stopPropagation();
})

// Handle click on "Select all " control
$('#tblPendingReporteesGoalList tbody').on('click', 'input[Name="UnCheckbox"]', function (e) {
    if (this.checked) {
        $('input[type="checkbox"]', '#tblPendingReporteesGoalList').prop('checked', true);
        var count = $('#tblPendingReporteesGoalList tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    } else {
        $('input[type="checkbox"]', '#tblPendingReporteesGoalList').prop('checked', false);
        var count = $('#tblPendingReporteesGoalList tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    }
    // Prevent click event from propagating to parent
    e.stopPropagation();
})

// Handle click on tableLeaveReviewRequestPending cells with checkboxes
$('#tblPendingReporteesGoalList tbody').on('click', 'input[type="checkbox"]', function (e) {
    if (e.target.name != "UnCheckbox") {
        $(this).parent().find('input[type="checkbox"]').trigger('click');
        var count = $('#tblPendingReporteesGoalList tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    }
    else {
        var count = $('#tblPendingReporteesGoalList tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    }
});

// Handle table draw event
if (tableReporteesGoalPending) {
    tableReporteesGoalPending.on('draw', function () {
        // Update state of "Select all" control
        updateDataTableSelectAllCtrlUn(tableReporteesGoalPending);
    });
}

function bindFinancialYearForReporteesGoal() {
    var jsonObject = {
        forTeam: true
    }
    calltoAjax(misApiUrl.getAllGoalCycleIdToViewAchievement, "POST", jsonObject,
        function (result) {
            if (result.length > 0) {
                $("#financialYearForTeam").empty();
                $("#financialYearForTeam").append("<option value='0'>All</option>");
                $.each(result, function (index, result) {
                    $("#financialYearForTeam").append("<option value=" + result.GoalCycleId + ">" + result.FinancialYearName + "</option>");
                });
                var FY = new Date(result[0].FyStartDate);
                var goalCycleId = result[0].GoalCycleId;
                var fromyear = FY.getFullYear();
                var endyear = fromyear + 1;
                $("#cntYear").html(fromyear);
                $("#nxtYear").html(endyear);
                $("#showAppraisalYear").val(fromyear + ' - ' + endyear);
                $("#txtHiddenGoalCycleId").val(goalCycleId);
                _FYStartDate = '0' + 4 + '/' + '0' + 1 + '/' + fromyear;
                _FYEndDate = '0' + 3 + '/' + 31 + '/' + endyear;
                $("#showAppraisalYear").val(fromyear + ' - ' + endyear);
                $("#txtHiddenGoalCycleIdForTeam").val(goalCycleId);
                $("#financialYearForTeam").val(goalCycleId);
                loadGoalGrid();
            }
        });
}

function bindAllReportingEmployees(controlId, selectedId) {
    $(controlId).multiselect('destroy');
    $(controlId).empty();
    $(controlId).multiselect();
    calltoAjax(misApiUrl.getAllEmployeesReportingToUser, "POST", '',
        function (result) {
            if (result != null && result.length > 0) {
                for (var x = 0; x < result.length; x++) {
                    $(controlId).append("<option value = '" + result[x].EmployeeAbrhs + "'>" + result[x].EmployeeName + "</option>");
                }
                $(controlId).multiselect("destroy");
                $(controlId).multiselect({
                    includeSelectAllOption: true,
                    enableFiltering: true,
                    enableCaseInsensitiveFiltering: true,
                    buttonWidth: false,
                    onDropdownHidden: function (event) {
                    }
                });
                $(controlId).multiselect('selectAll', false);
                $(controlId).multiselect('updateButtonText');
                //showAddGoalArea();
                bindFinancialYearForReporteesGoal();
            }
            else
                $(controlId).append("<option value = 0>No records available</option>");
        });
}

function bindAllReportingEmployeesToAddGoal(controlId, selectedId) {
    $(controlId).empty();
    calltoAjax(misApiUrl.getAllEmployeesReportingToUser, "POST", '',
        function (result) {
            if (result != null && result.length > 0) {
                $(controlId).append("<option value = 0>Select</option>");
                for (var x = 0; x < result.length; x++) {
                    $(controlId).append("<option value = '" + result[x].EmployeeAbrhs + "'>" + result[x].EmployeeName + "</option>");
                }
                if (selectedId != 0) {
                    $(controlId).val(selectedId);
                    showAddGoalArea();
                }
            }
            else
                $(controlId).append("<option value = 0>No records available</option>");
        });
}

function bindPendingReporteesGoal(data) {
    if (data.length > 0) {
        var html = "<button type='button' class='btn btn-primary' onclick=\"approveReporteesGoal()\"><i class='fa fa-check'></i>&nbsp;Bulk Approve </button>";
        $("#divBulkApproveReporteesGoal").html(html);
    }
    $("#tblPendingReporteesGoalList").dataTable({
        "dom": 'lBfrtip',
        "buttons": [
            {
                filename: 'All Reportees Goals',
                extend: 'collection',
                text: 'Export',
                buttons: [{ extend: 'copy' },
                { extend: 'excel', filename: 'All Reportees Goals' },
                { extend: 'pdf', filename: 'All Reportees Goals' },
                { extend: 'print', filename: 'All Reportees Goals' },
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
                "sTitle": '<input name="select_all" value="1" id="selectAllReporteesGoalPending" type="checkbox" />',
                'className': 'dt-body-center',
                'render': function (data, type, full, meta) {
                    if (full.Selected) {
                        return '<input type="checkbox" name="id[' + full.GoalId + ']" value="' + full.GoalId + '" checked="' + full.GoalId + '">';
                    }
                    else {
                        return '<input type="checkbox" name="id[' + full.GoalId + ']" value="' + full.GoalId + '">';
                    }

                }
            },
            { "mData": "Employee", "sTitle": "Employee Name", "sWidth": "150px" },
            {
                "mData": null,
                "sTitle": "Financial Year",
                'bSortable': true,
                "sWidth": "100px",
                mRender: function (data, type, row) {
                    var html = '<div>';
                    html += row.AppraisalYear - 1 + " - " + row.AppraisalYear;
                    html += '</div>'
                    return html;
                }
            },
            { "mData": "AppraisalCycleName", "sTitle": "Appraisal Cycle", "sWidth": "100px" },
            { "mData": "GoalCategory", "sTitle": "Goal Type" },
            { "mData": "Goal", "sTitle": "Goal" },
            //{ "mData": "AppraisalCycleName", "sTitle": "Appraisal Cycle" },
            //{ "mData": "StartDate", "sTitle": "Start Date" },
            //{ "mData": "EndDate", "sTitle": "End Date" },
            //{ "mData": "UserRemark", "sTitle": "User Remark" },
            //{ "mData": "OtherRemark", "sTitle": "Other Remark" },
            //{ "mData": "CreatedBy", "sTitle": "Created By" },
            { "mData": "Status", "sTitle": "Status", "sWidth": "100px", },
            {
                "mData": null,
                "sTitle": "Action",
                'bSortable': false,
                "sClass": "text-center",
                "sWidth": "100px",
                mRender: function (data, type, row) {
                    var html = '<div>';
                    switch (row.Status) {
                        case 'Submitted':
                            html += '<button type="button" data-toggle="tooltip" title="Approve"  class="btn btn-sm btn-success"' + 'onclick="openPopupFreezeGoal(' + row.GoalId + ')"><i class="fa fa-check" aria-hidden="true"></i></button>';
                            html += '&nbsp;<button type="button" data-toggle="tooltip" title="Edit"  class="btn btn-sm btn-success"' + 'onclick="openPopupEditGoal(' + row.GoalId + ')"><i class="fa fa-edit" aria-hidden="true"></i></button>';
                            html += '&nbsp;<button type="button" data-toggle="tooltip" title="Mark goal as irrelevant"  class="btn btn-sm btn-danger"' + 'onclick="openPopupDeleteGoal(' + row.GoalId + ')"><i class="fa fa-trash" aria-hidden="true"></i></button>';
                            break;
                        case 'Approved':
                            //html += '<button type="button" data-toggle="tooltip" title="Edit"  class="btn btn-sm btn-success"' + 'onclick="openPopupEditGoal(' + row.GoalId + ')"><i class="fa fa-edit" aria-hidden="true"></i></button>';
                            html += '&nbsp;<button type="button" data-toggle="tooltip" title="Mark goal as irrelevant"  class="btn btn-sm btn-danger"' + 'onclick="openPopupDeleteGoal(' + row.GoalId + ')"><i class="fa fa-trash" aria-hidden="true"></i></button>';
                            break;
                        case 'Achieved':
                            html += 'Achieved on ' + row.GoalAchievingDate;
                            break;
                        case 'Rejected':
                            html += 'Marked as irrelevant';
                            break;
                    }

                    html += '</div>';
                    return html;
                }
            },
            {
                "mData": null,
                "sTitle": "Log",
                'bSortable': false,
                "sClass": "text-center",
                "sWidth": "100px",
                mRender: function (data, type, row) {
                    var html = '<div>';
                    if (row.Status == 'Drafted' || row.Status == 'Deleted')
                        html += 'NA';
                    else
                        html += '<button type="button" data-toggle="tooltip" title="View"  class="btn btn-sm teal"' + 'onclick="openPopupGoalHist(' + row.GoalId + ',\'' + row.Goal + '\')"><i class="fa fa-eye" aria-hidden="true"></i></button>';
                    html += '</div>'
                    return html;
                }
            }
        ]
    });

    tableReporteesGoalPending = $('#tblPendingReporteesGoalList').DataTable();
}

function bindNonPendingReporteesGoal(data) {
    $("#tblApprovedNRejectedReporteesGoalList").dataTable({
        "dom": 'lBfrtip',
        "buttons": [
            {
                filename: 'All Reportees Goals',
                extend: 'collection',
                text: 'Export',
                buttons: [{ extend: 'copy' },
                { extend: 'excel', filename: 'All Reportees Goals' },
                { extend: 'pdf', filename: 'All Reportees Goals' },
                { extend: 'print', filename: 'All Reportees Goals' },
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
            { "mData": "Employee", "sTitle": "Employee Name", "sWidth": "150px" },
            {
                "mData": null,
                "sTitle": "Financial Year",
                'bSortable': true,
                "sWidth": "100px",
                mRender: function (data, type, row) {
                    var html = '<div>';
                    html += row.AppraisalYear - 1 + " - " + row.AppraisalYear;
                    html += '</div>'
                    return html;
                }
            },
            { "mData": "AppraisalCycleName", "sTitle": "Appraisal Cycle", "sWidth": "100px" },
            { "mData": "GoalCategory", "sTitle": "Goal Type" },
            { "mData": "Goal", "sTitle": "Goal" },
            //{ "mData": "AppraisalCycleName", "sTitle": "Appraisal Cycle" },
            //{ "mData": "StartDate", "sTitle": "Start Date" },
            //{ "mData": "EndDate", "sTitle": "End Date" },
            //{ "mData": "UserRemark", "sTitle": "User Remark" },
            //{ "mData": "OtherRemark", "sTitle": "Other Remark" },
            //{ "mData": "CreatedBy", "sTitle": "Created By" },
            { "mData": "Status", "sTitle": "Status", "sWidth": "100px", },
            {
                "mData": null,
                "sTitle": "Action",
                'bSortable': false,
                "sClass": "text-center",
                "sWidth": "100px",
                mRender: function (data, type, row) {
                    var html = '<div>';
                    switch (row.Status) {
                        case 'Approved':
                            //html += '<button type="button" data-toggle="tooltip" title="Edit"  class="btn btn-sm btn-success"' + 'onclick="openPopupEditGoal(' + row.GoalId + ')"><i class="fa fa-edit" aria-hidden="true"></i></button>';
                            html += '&nbsp;<button type="button" data-toggle="tooltip" title="Mark goal as irrelevant"  class="btn btn-sm btn-danger"' + 'onclick="openPopupDeleteGoal(' + row.GoalId + ')"><i class="fa fa-trash" aria-hidden="true"></i></button>';
                            break;
                        case 'Achieved':
                            html += 'Achieved on ' + row.GoalAchievingDate;
                            break;
                        case 'Rejected':
                            html += 'Marked as irrelevant';
                            break;
                    }

                    html += '</div>';
                    return html;
                }
            },
            {
                "mData": null,
                "sTitle": "Log",
                'bSortable': false,
                "sClass": "text-center",
                "sWidth": "100px",
                mRender: function (data, type, row) {
                    var html = '<div>';
                    if (row.Status == 'Drafted' || row.Status == 'Deleted')
                        html += 'NA';
                    else
                        html += '<button type="button" data-toggle="tooltip" title="View"  class="btn btn-sm teal"' + 'onclick="openPopupGoalHist(' + row.GoalId + ',\'' + row.Goal + '\')"><i class="fa fa-eye" aria-hidden="true"></i></button>';
                    html += '</div>'
                    return html;
                }
            }
        ]
    });
}

function loadGoalGrid() {
    var userAbrhs = "";
    if ($('#ddlEmployee').val() === null) {
        bindPendingReporteesGoal([]);
        bindNonPendingReporteesGoal([]);

    }
    else {
        if ($('#ddlEmployee').val() !== null) {
            userAbrhs = $('#ddlEmployee').val().join(",");
        }
        var jsonObject = {
            userAbrhs: userAbrhs,
            appraisalCycleId: $("#financialYearForTeam").val()
        };
        calltoAjax(misApiUrl.getAllSelfGoals, "POST", jsonObject,
            function (result) {
                if (result.length === 0) {
                    bindPendingReporteesGoal(result);
                    bindNonPendingReporteesGoal(result);
                }
                else {
                    var pendingReqData = [], nonPendingReqData = [];
                    pendingReqData = getAllMatchedObject({ Status: 'Submitted' }, result);

                    nonPendingReqData = getAllMatchedObject({ Status: 'Approved' }, result);
                    var gA = getAllMatchedObject({ Status: 'Achieved' }, result);
                    $.merge(nonPendingReqData, gA);
                    var gR = getAllMatchedObject({ Status: 'Rejected' }, result);
                    $.merge(nonPendingReqData, gR);

                    bindPendingReporteesGoal(pendingReqData);
                    bindNonPendingReporteesGoal(nonPendingReqData);
                }
            });
    }
}

function approveReporteesGoal() {
    var selectedGoalIds = [];
    var selectedReportees = [];
    _selectedReporteesGoalIds = "";
    $("#tblPendingReporteesGoalList").dataTable().$('input[type="checkbox"]').each(function () {
        if (this.checked) {
            selectedGoalIds.push($(this).val());
            selectedReportees.push(this.parentNode.nextElementSibling.firstChild.nodeValue.trim());
        }
    });

    selectedReportees = jQuery.unique(selectedReportees);
    var reporteesNames = selectedReportees.join(", ");
    _selectedReporteesGoalIds = selectedGoalIds.join();

    if (_selectedReporteesGoalIds.length > 0) {
        openPopupFreezeBulkReportessGoal(_selectedReporteesGoalIds, reporteesNames)
    }
    else {
        misAlert("No rows selected.", "Warning", "warning");
    }
}

function openPopupFreezeBulkReportessGoal(goalIds, reporteesNames) {
    var reply = misConfirm("Are you sure you want to approve below reportess's goal?<br /><b>" + reporteesNames + "</b>", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                userAbrhs: misSession.userabrhs,
                goalIds: goalIds
            };
            calltoAjax(misApiUrl.approveGoal, "POST", jsonObject,
                function (result) {
                    if (result === 1) {
                        _selectedReporteesGoalIds = "";
                        misAlert("Request processed successfully", "Success", "success");
                        loadGoalGrid();
                    }
                    else
                        misAlert("No such record present", "Error", "error");
                });
        }
    }, false, true)
}

function openPopupFreezeGoal(goalId) {
    var reply = misConfirm("Are you sure you want to approve goal", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                userAbrhs: misSession.userabrhs,
                goalIds: goalId
            };
            calltoAjax(misApiUrl.approveGoal, "POST", jsonObject,
                function (result) {
                    if (result) {
                        misAlert("Request processed successfully", "Success", "success");
                        loadGoalGrid();
                    }
                    else
                        misAlert("No such record present", "Error", "error");
                });
        }
    })
}

function openPopupGoalHist(goalId, goal) {
    document.getElementById("lblGoal").innerHTML = " Goal summary: " + goal + "";
    $("#modalGoalHistory").modal('show');
    var jsonObject = {
        goalId: goalId,
    };
    calltoAjax(misApiUrl.fetchGoalHistoryById, "POST", jsonObject,
        function (result) {
            if (result != null) {
                $("#goalHistTable").empty();
                var html = ""
                html = "<tr><th>Start Date</th><th>End Date</th><th>Remarks</th><th>Action</th><th>Action Date</th><th>Action By</th></tr>"
                for (var i = 0; i < result.length; i++) {
                    html += "<tr><td>" + result[i].StartDate + "</td><td>" + result[i].EndDate + "</td><td>" + result[i].Remark + "</td><td>" + result[i].Status + "</td><td>" + result[i].CreatedDate + "</td><td>" + result[i].CreatedBy + "</td></tr>";
                }
                $("#goalHistTable").append(html);
            }
            else
                misAlert("Unable to fetch goal details", "Error", "error");
        });
}

function openPopupDeleteGoal(goalId) {
    $("#modalDeleteGoal").modal('show');
    $("#hdnGoalId").val(goalId);
    $("#remarks").val("");
}

function openPopupEditGoal(goalId) {
    $("#modalEditGoal").modal('show');
    $("#hdnEditGoalId").val(goalId);
    $("#goalStartDate").datepicker({ autoclose: true, todayHighlight: true }).datepicker('setStartDate', _StartDate);
    $("#goalStartDate").datepicker({ autoclose: true, todayHighlight: true }).on('changeDate', function () {
        $("#goalEndDate").val("");
        $("#goalEndDate").datepicker('setStartDate', $("#goalStartDate").val());
    });
    $("#goalEndDate").datepicker({ autoclose: true, todayHighlight: true }).datepicker('setEndDate', _EndDate);
    var jsonObject = {
        goalId: $("#hdnEditGoalId").val(),
    };
    calltoAjax(misApiUrl.fetchGoalDetailById, "POST", jsonObject,
        function (result) {
            if (result != null) {
                $("#goalStartDate").val(result.StartDate);
                $("#goalEndDate").val(result.EndDate);
                $("#goalStartDate").removeClass('error-validation');
                $("#goalEndDate").removeClass('error-validation');
                $("#goalEndDate").datepicker('setStartDate', result.StartDate);
                bindGoalCategory("#ddlGoalCategory", result.GoalCategoryId);
                $("#goalDesc").val(result.Goal);
            }
            else
                misAlert("Unable to fetch goal details", "Error", "error");
        });
}

function bindGoalCategory(controlId, selectedValue) {
    $(controlId).empty();
    $(controlId).append($("<option></option>").val(0).html("Select"));
    $(controlId).select2();
    calltoAjax(misApiUrl.fetchGoalCategory, "POST", "",
        function (result) {
            if (result !== null) {
                $.each(result, function (index, item) {
                    $(controlId).append($("<option></option>").val(item.Value).html(item.Text));
                });
            }
            if (selectedValue > 0)
                $(controlId).val(selectedValue);
        });
}

function editGoal() {
    if (!validateControls('editGoalDiv'))
        return false;
    var jsonObject = {
        GoalId: $("#hdnEditGoalId").val(),
        StartDate: $("#goalStartDate").val(),
        EndDate: $("#goalEndDate").val(),
        GoalCategoryId: parseInt($("#ddlGoalCategory").val() || 0),
        Goal: $("#goalDesc").val(),
        UserAbrhs: misSession.userabrhs,
    };
    calltoAjax(misApiUrl.editGoal, "POST", jsonObject,
        function (result) {
            if (result) {
                misAlert("Request processed successfully", "Success", "success");
                $("#modalEditGoal").modal('hide');
                loadGoalGrid();
            }
            else
                misAlert("Unable to process request", "Error", "error");
        });
}

function deleteGoal() {
    if (!validateControls('modalDeleteGoal')) {
        return false;
    }
    var reply = misConfirm("Are you sure you want to mark goal as irrelevant", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                userAbrhs: misSession.userabrhs,
                goalId: $("#hdnGoalId").val(),
                remarks: $("#remarks").val(),
            };
            calltoAjax(misApiUrl.deleteGoal, "POST", jsonObject,
                function (result) {
                    if (result) {
                        misAlert("Request processed successfully", "Success", "success");
                        $("#modalDeleteGoal").modal('hide');
                        loadGoalGrid();
                    }
                    else
                        misAlert("No such record present", "Error", "error");
                });
        }
    });
}

function openPopupManageGoal() {
    $("#modalManageGoal").modal('show');
    bindAllReportingEmployeesToAddGoal("#ddlEmployeeAddGoal", 0);
    $("#showOnEmployeeChangeDiv").hide();
    $("#dynamicAddGoal").empty();
}

$("#btnAddNew").click(function () {
    if (!validateControls('dynamicAddGoal')) {
        return false;
    }
    generateControls('dynamicAddGoal');
});

function showAddGoalArea() {
    $("#showOnEmployeeChangeDiv").show();
    $("#dynamicAddGoal").empty();
}

//function generateControls(containerId, maxNoOfTextBoxes, minNoOfMandatoryTxtBoxes) {
//    maxNoOfTextBoxes = maxNoOfTextBoxes || 5;
//    if (containerId) {
//        var txtCount = $("#" + containerId).find('.itemRow').length;
//        //if (txtCount < maxNoOfTextBoxes) {
//        $("#" + containerId).append(getDynamicControls(dynamicId, minNoOfMandatoryTxtBoxes || 1, ''));
//        $("#goalStartDate" + dynamicId).datepicker({ autoclose: true, todayHighlight: true }).on('changeDate', function () {
//            $("#goalEndDate" + (dynamicId - 1)).val("");
//            $("#goalEndDate" + (dynamicId - 1)).datepicker('setStartDate', $("#goalStartDate" + (dynamicId - 1)).val());
//        });
//        $("#goalStartDate" + dynamicId).datepicker('update', new Date());
//        $("#goalEndDate" + dynamicId).datepicker({ autoclose: true, todayHighlight: true }).datepicker('setStartDate', $("#goalStartDate" + dynamicId).val());
//        dynamicId += 1;
//        //}
//        //else
//        //    misAlert("You can't add more than " + maxNoOfTextBoxes + " goals!", 'Sorry', 'warning');        
//    }
//}

function generateControls(containerId, maxNoOfTextBoxes, minNoOfMandatoryTxtBoxes) {
    maxNoOfTextBoxes = maxNoOfTextBoxes || 20;
    if (containerId) {
        var txtCount = $("#" + containerId).find('.itemRow').length;
        if (txtCount < maxNoOfTextBoxes) {
            $("#" + containerId).append(getDynamicControls(txtCount, minNoOfMandatoryTxtBoxes || 1, ''));
            $("#goalStartDate" + txtCount).datepicker({ autoclose: true, todayHighlight: true }).datepicker('setStartDate', new Date(_FYStartDate));
            $("#goalEndDate" + txtCount).datepicker({ autoclose: true, todayHighlight: true }).datepicker('setEndDate', new Date(_FYEndDate));
            $("#goalStartDate" + txtCount).datepicker({ autoclose: true, todayHighlight: true }).on('changeDate', function () {
                $("#goalEndDate" + txtCount).val('');
                $("#goalEndDate" + txtCount).datepicker('setStartDate', new Date($("#goalStartDate" + txtCount).val()));
            });
            $("#goalStartDate" + txtCount).datepicker('update', new Date());
            $("#goalEndDate" + txtCount).datepicker({ autoclose: true, todayHighlight: true }).datepicker('setStartDate', $("#goalStartDate" + txtCount).val());
        }
        else {
            misAlert("You can't add more than " + maxNoOfTextBoxes + " goals!", 'Sorry', 'warning');
        }
        $(".select2").select2();
    }
}

function getDynamicControls(idx, minNoOfMandatoryTxtBoxes, value) {
    var html = '<div class="row col-md-12 itemRow" id = "dynamicAddGoalDiv-' + idx + '">' +
        '<div class="row">' +
        '<div class="col-md-2"><div class="form-group"><label>Goal start date<span class="spnError">*</span></label><div class="input-group"><div class="input-group-addon"><i class="fa fa-calendar"></i></div><input disable="" type="text" class="form-control validation-required" placeholder="Start date" tabindex="6" id="goalStartDate' + idx + '" data-mask="" data-attr-name="r2"></div></div></div>' +
        '<div class="col-md-2"><div class="form-group"><label>Goal end date<span class="spnError">*</span></label><div class="input-group"><div class="input-group-addon"><i class="fa fa-calendar"></i></div><input disable="" type="text" class="form-control validation-required" placeholder="End date" tabindex="6" id="goalEndDate' + idx + '" data-mask="" data-attr-name="r2"></div></div></div>' +
        ' <div class="col-md-2"><div class="form-group"> <label>Goal type<span class="spnError">*</span></label><div class="input-group"><select class="form-control select2 validation-required" id="ddlGoalCategory' + idx + '"><option value="0">Select</option></select></div></div></div>' +
        '<div class="col-md-5"><div class="form-group"><label>Goal description<span class="spnError">*</span></label><textarea rows="2" cols="6" class="form-control validation-required" placeholder="Goal description" id="goal' + idx + '" maxlength="4000" data-mask="" data-attr-name="r2"></textarea></div></div>' +
        '<div class="col-md-1" style="padding-top: 22px;"><span class="input-group-btn"><button class="btn btn-danger" style="background-color: #d2322d;" value="X" onclick="removeControls(this)">X</button></span></div>' +
        '</div></div>';

    var controlId = "#ddlGoalCategory" + idx;
    bindGoalCategory(controlId, 0);
    return html;
}

function addGoal() {
    if (!validateControls('modalManageGoal')) {
        return false;
    }
    if (getFormData().length == 0) {
        misAlert("No goals have been added.", "Warning", "warning");
        return false;
    }
    var reply = misConfirm("Once you add goal, it can not be edited", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                goalList: getFormData(),
                employeeAbrhs: $("#ddlEmployeeAddGoal").val(),
                userAbrhs: misSession.userabrhs,
                goalCycleId: $("#txtHiddenGoalCycleIdForTeam").val()
            };
            calltoAjax(misApiUrl.addGoals, "POST", jsonObject,
                function (result) {
                    if (result) {
                        misAlert("Request processed successfully", "Success", "success");

                        bindAllReportingEmployees("#ddlEmployee", $("#ddlEmployeeAddGoal").val());
                        loadGoalGrid($("#ddlEmployeeAddGoal").val());

                        $("#showOnEmployeeChangeDiv").hide();
                        $("#dynamicAddGoal").empty();
                        $("#ddlEmployeeAddGoal").val("");

                    }
                    else
                        misAlert("Unable to process request. Please try again.", "Error", "error");
                });
        }
    });
}

function getFormData() {
    var collection = new Array();
    var items;
    $('.itemRow').each(function () {
        var id = $(this).closest(".itemRow").attr("id").split('-')[1];
        items = new Object();
        items.StartDate = $("#goalStartDate" + id).val();
        items.EndDate = $("#goalEndDate" + id).val();
        items.GoalCategoryId = parseInt($("#ddlGoalCategory" + id).val() || 0);
        items.Goal = $("#goal" + id).val();
        collection.push(items);
    });
    return collection;
}

function removeControls(item) {
    $(item).closest('.itemRow').remove();
}

$(".btnClose").click(function () {
    $("#modalManageGoal").modal('hide');
    $("#modalDeleteGoal").modal('hide');
    $("#modalEditGoal").modal('hide');
    $("#modalGoalHistory").modal('hide');
});


//team goal

// Handle click on checkbox
$('body').on('click', '#tblTeamGoalList tbody input[type="checkbox"]', function (e) {
    var $row = $(this).closest('tr');
    // Get row data
    var data = tableGoalList.row($row).data();
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
    updateDataTableSelectAllCtrlUn(tableGoalList);
    // Prevent click event from propagating to parent
    e.stopPropagation();
});

// Handle table draw event
if (tableGoalList) {
    tableGoalList.on('draw', function () {
        // Update state of "Select all" control
        updateDataTableSelectAllCtrlUn(tableGoalList);
    });
}

function updateDataTableSelectAllCtrlUn(tableData) {
    var tableData = tableData.table().node();
    var $chkbox_all = $('tbody input[type="checkbox"]', tableData);
    var $chkbox_checked = $('tbody input[type="checkbox"]:checked', tableData);
    var chkbox_select_all = $('thead input[name="select_all"]', tableData).get(0);

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
$('body').on('click', '#selectAllTeamGoal', function (e) {
    if (this.checked) {
        $('input[type="checkbox"]', '#tblTeamGoalList').prop('checked', true);
        var count = $('#tblTeamGoalList tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    } else {
        $('input[type="checkbox"]', '#tblTeamGoalList').prop('checked', false);
        var count = $('#tblTeamGoalList tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    }
    // Prevent click event from propagating to parent
    e.stopPropagation();
})

function approveBulkTeamGoal() {
    var selectedTeamGoalIds = [];
    var selectedTeams = [];
    _selectedTeamGoalIds = "";
    $("#tblTeamGoalList").dataTable().$('input[type="checkbox"]').each(function () {
        if (this.checked) {
            selectedTeamGoalIds.push($(this).val());
            selectedTeams.push(this.parentNode.nextElementSibling.firstChild.nodeValue.trim());
        }
    });

    selectedTeams = jQuery.unique(selectedTeams);
    var teamNames = selectedTeams.join(", ");
    _selectedTeamGoalIds = selectedTeamGoalIds.join();

    if (_selectedTeamGoalIds.length > 0) {
        openPopupFreezeBulkTeamGoal(_selectedTeamGoalIds, teamNames)
    }
    else {
        misAlert("No rows selected.", "Warning", "warning");
    }
}

function openPopupFreezeBulkTeamGoal(goalIds, teamNames) {
    var reply = misConfirm("Are you sure you want to approve below team's goal?<br /><b>" + teamNames + "</b>", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                userAbrhs: misSession.userabrhs,
                goalIds: goalIds
            };
            calltoAjax(misApiUrl.approveTeamGoal, "POST", jsonObject,
                function (result) {
                    if (result === 1) {
                        misAlert("Request processed successfully", "Success", "success");
                        loadTeamGoalGrid();
                    }
                    else
                        misAlert("No such record present", "Error", "error");
                });
        }
    }, false, true)
}

function bindFinancialYearForTeamGoal() {
    $("#financialYearForTeamGoal").empty();
    $("#financialYearForTeamGoal").append("<option value='0'>All</option>");
    var jsonObject = {
        forTeam: true
    }
    calltoAjax(misApiUrl.getAllGoalCycleIdToViewAchievement, "POST", jsonObject,
        function (result) {
            if (result.length > 0) {
                $.each(result, function (index, result) {
                    $("#financialYearForTeamGoal").append("<option value=" + result.GoalCycleId + ">" + result.FinancialYearName + "</option>");
                });
                var FY = new Date(result[0].FyStartDate);
                var fromyear = FY.getFullYear();
                var endyear = fromyear + 1;
                _StartDateT = '0' + 4 + '/' + '0' + 1 + '/' + fromyear;
                _EndDateT = '0' + 3 + '/' + 31 + '/' + endyear;
                var goalCycleId = result[0].GoalCycleId;
                $("#financialYearForTeamGoal").val(goalCycleId);
                loadTeamGoalGrid();
            }
        });
}

function bindAllTeams(controlId) {
    $(controlId).multiselect('destroy');
    $(controlId).empty();
    $(controlId).multiselect();

    calltoAjax(misApiUrl.fetchTeamsToReviewGoals, "POST", '',
        function (result) {
            if (result != null && result.length > 0) {
                for (var x = 0; x < result.length; x++) {
                    $(controlId).append("<option value = '" + result[x].KeyValue + "'>" + result[x].Text + "</option>");
                }
                $(controlId).multiselect("destroy");
                $(controlId).multiselect({
                    includeSelectAllOption: true,
                    enableFiltering: true,
                    enableCaseInsensitiveFiltering: true,
                    buttonWidth: false,
                    onDropdownHidden: function (event) {
                    }
                });
                $(controlId).multiselect('selectAll', false);
                $(controlId).multiselect('updateButtonText');
                //showAddGoalArea();

            }
            else
                $(controlId).append("<option value = 0>No records available</option>");

            bindFinancialYearForTeamGoal();
        });
}

function loadTeamGoalGrid() {
    var teamAbrhs = "";
    if ($('#ddlTeam').val() === null) {
        bindPendingTeamGoal([]);
        bindNonPendingTeamGoal([]);

    }
    else {
        if ($('#ddlTeam').val() !== null) {
            teamAbrhs = $('#ddlTeam').val().join(",");
        }
        var jsonObject = {
            teamAbrhs: teamAbrhs,
            appraisalCycleId: $("#financialYearForTeamGoal").val()
        };

        calltoAjax(misApiUrl.getAllTeamGoals, "POST", jsonObject,
            function (result) {
                if (result.length === 0) {
                    bindPendingTeamGoal(result);
                    bindNonPendingTeamGoal(result);
                }
                else {
                    var pendingReqData = [], nonPendingReqData = [];
                    pendingReqData = getAllMatchedObject({ Status: 'Submitted' }, result);

                    nonPendingReqData = getAllMatchedObject({ Status: 'Approved' }, result);
                    var gA = getAllMatchedObject({ Status: 'Achieved' }, result);
                    $.merge(nonPendingReqData, gA);
                    var gR = getAllMatchedObject({ Status: 'Rejected' }, result);
                    $.merge(nonPendingReqData, gR);

                    bindPendingTeamGoal(pendingReqData);
                    bindNonPendingTeamGoal(nonPendingReqData);
                }
            });
    }
}

function bindPendingTeamGoal(result) {
    if (result.length > 0) {
        var html = "<button type='button' class='btn btn-primary' onclick=\"approveBulkTeamGoal()\" > <i class='fa fa-check'></i>&nbsp;Bulk Approve </button>";
        $("#divBulkApproveTeamGoal").html(html);
    }

    $("#tblTeamGoalList").dataTable({
        "dom": 'lBfrtip',
        "buttons": [
            {
                filename: 'All Team Goals',
                extend: 'collection',
                text: 'Export',
                buttons: [{ extend: 'copy' },
                { extend: 'excel', filename: 'All Team Goals' },
                { extend: 'pdf', filename: 'All Team Goals' },
                { extend: 'print', filename: 'All Team Goals' },
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
        "aaData": result,
        "aoColumns": [
            {
                'targets': 0,
                'searchable': false,
                'width': '1%',
                'orderable': false,
                'bSortable': false,
                "sTitle": '<input name="select_all" value="1" id="selectAllTeamGoal" type="checkbox" />',
                'className': 'dt-body-center',
                'render': function (data, type, full, meta) {
                    if (full.Selected) {
                        return '<input type="checkbox" name="id[' + full.GoalId + ']" value="' + full.GoalId + '" checked="' + full.GoalId + '">';
                    }
                    else {
                        return '<input type="checkbox" name="id[' + full.GoalId + ']" value="' + full.GoalId + '">';
                    }

                }
            },
            { "mData": "TeamName", "sTitle": "Team", "sWidth": "150px" },
            { "mData": "DepartmentName", "sTitle": "Department", "sWidth": "100px" },
            {
                "mData": null,
                "sTitle": "Financial Year",
                'bSortable': true,
                "sWidth": "100px",
                mRender: function (data, type, row) {
                    var html = '<div>';
                    html += row.AppraisalYear - 1 + " - " + row.AppraisalYear;
                    html += '</div>'
                    return html;
                }
            },
            { "mData": "AppraisalCycleName", "sTitle": "Appraisal Cycle", "sWidth": "100px" },
            { "mData": "GoalCategory", "sTitle": "Goal Type" },
            { "mData": "Goal", "sTitle": "Goal" },
            { "mData": "Status", "sTitle": "Status", "sWidth": "100px", },
            {
                "mData": null,
                "sTitle": "Action",
                'bSortable': false,
                "sClass": "text-center",
                "sWidth": "100px",
                mRender: function (data, type, row) {
                    var html = '<div>';
                    if (row.HasApproverRights) {
                        html += '<button type="button" data-toggle="tooltip" title="Approve"  class="btn btn-sm btn-success"' + 'onclick="openPopupFreezeTeamGoal(' + row.GoalId + ')"><i class="fa fa-check" aria-hidden="true"></i></button>';
                        html += '&nbsp;<button type="button" data-toggle="tooltip" title="Edit"  class="btn btn-sm btn-success"' + 'onclick="openPopupEditTeamGoal(' + row.GoalId + ')"><i class="fa fa-edit" aria-hidden="true"></i></button>';
                        html += '&nbsp;<button type="button" data-toggle="tooltip" title="Mark goal as irrelevant"  class="btn btn-sm btn-danger"' + 'onclick="openPopupDeleteTeamGoal(' + row.GoalId + ')"><i class="fa fa-trash" aria-hidden="true"></i></button>';
                    }
                    html += '</div>';
                    return html;
                }
            },
            {
                "mData": null,
                "sTitle": "Log",
                'bSortable': false,
                "sClass": "text-center",
                "sWidth": "100px",
                mRender: function (data, type, row) {
                    var html = '<div>';
                    if (row.Status == 'Drafted' || row.Status == 'Deleted')
                        html += 'NA';
                    else
                        html += '<button type="button" data-toggle="tooltip" title="View"  class="btn btn-sm teal"' + 'onclick="openPopupTeamGoalHist(' + row.GoalId + ',\'' + row.Goal + '\')"><i class="fa fa-eye" aria-hidden="true"></i></button>';
                    html += '</div>'
                    return html;
                }
            }
        ]
    });

    tableGoalList = $('#tblTeamGoalList').DataTable();
}

function bindNonPendingTeamGoal(result) {
    $("#tblApprovedNRejectedTeamGoalList").dataTable({
        "dom": 'lBfrtip',
        "buttons": [
            {
                filename: 'All Team Goals',
                extend: 'collection',
                text: 'Export',
                buttons: [{ extend: 'copy' },
                { extend: 'excel', filename: 'All Team Goals' },
                { extend: 'pdf', filename: 'All Team Goals' },
                { extend: 'print', filename: 'All Team Goals' },
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
        "aaData": result,
        "aoColumns": [
            { "mData": "TeamName", "sTitle": "Team", "sWidth": "150px" },
            { "mData": "DepartmentName", "sTitle": "Department", "sWidth": "100px" },
            {
                "mData": null,
                "sTitle": "Financial Year",
                'bSortable': true,
                "sWidth": "100px",
                mRender: function (data, type, row) {
                    var html = '<div>';
                    html += row.AppraisalYear - 1 + " - " + row.AppraisalYear;
                    html += '</div>'
                    return html;
                }
            },
            { "mData": "AppraisalCycleName", "sTitle": "Appraisal Cycle", "sWidth": "100px" },
            { "mData": "GoalCategory", "sTitle": "Goal Type" },
            { "mData": "Goal", "sTitle": "Goal" },
            { "mData": "Status", "sTitle": "Status", "sWidth": "100px", },
            {
                "mData": null,
                "sTitle": "Action",
                'bSortable': false,
                "sClass": "text-center",
                "sWidth": "100px",
                mRender: function (data, type, row) {
                    var html = '<div>';
                    switch (row.Status) {
                        case 'Approved':
                            if (row.HasApproverRights)
                                html += '&nbsp;<button type="button" data-toggle="tooltip" title="Mark goal as irrelevant"  class="btn btn-sm btn-danger"' + 'onclick="openPopupDeleteTeamGoal(' + row.GoalId + ')"><i class="fa fa-trash" aria-hidden="true"></i></button>';
                            break;
                        case 'Achieved':
                            html += 'Achieved on ' + row.GoalAchievingDate;
                            break;
                        case 'Rejected':
                            html += 'Marked as irrelevant';
                            break;
                    }

                    html += '</div>';
                    return html;
                }
            },
            {
                "mData": null,
                "sTitle": "Log",
                'bSortable': false,
                "sClass": "text-center",
                "sWidth": "100px",
                mRender: function (data, type, row) {
                    var html = '<div>';
                    if (row.Status == 'Drafted' || row.Status == 'Deleted')
                        html += 'NA';
                    else
                        html += '<button type="button" data-toggle="tooltip" title="View"  class="btn btn-sm teal"' + 'onclick="openPopupTeamGoalHist(' + row.GoalId + ',\'' + row.Goal + '\')"><i class="fa fa-eye" aria-hidden="true"></i></button>';
                    html += '</div>'
                    return html;
                }
            }
        ]
    });
}

function openPopupTeamGoalHist(goalId, goal) {
    document.getElementById("lblGoal").innerHTML = " Goal summary: " + goal + "";
    $("#modalGoalHistory").modal('show');
    var jsonObject = {
        goalId: goalId,
    };
    calltoAjax(misApiUrl.fetchTeamGoalHistoryById, "POST", jsonObject,
        function (result) {
            if (result != null) {
                $("#goalHistTable").empty();
                var html = ""
                html = "<tr><th>Start Date</th><th>End Date</th><th>Remarks</th><th>Action</th><th>Action Date</th><th>Action By</th></tr>"
                for (var i = 0; i < result.length; i++) {
                    html += "<tr><td>" + result[i].StartDate + "</td><td>" + result[i].EndDate + "</td><td>" + result[i].Remark + "</td><td>" + result[i].Status + "</td><td>" + result[i].CreatedDate + "</td><td>" + result[i].CreatedBy + "</td></tr>";
                }
                $("#goalHistTable").append(html);
            }
            else
                misAlert("Unable to fetch goal details", "Error", "error");
        });
}

function openPopupFreezeTeamGoal(goalId) {
    var reply = misConfirm("Are you sure you want to approve goal", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                userAbrhs: misSession.userabrhs,
                goalIds: goalId
            };
            calltoAjax(misApiUrl.approveTeamGoal, "POST", jsonObject,
                function (result) {
                    if (result === 1) {
                        misAlert("Request processed successfully", "Success", "success");
                        loadTeamGoalGrid();
                    }
                    else
                        misAlert("No such record present", "Error", "error");
                });
        }
    })
}

function openPopupDeleteTeamGoal(goalId) {
    $("#modalDeleteTeamGoal").modal('show');
    $("#hdnTeamGoalId").val(goalId);
    $("#remarksForTeamGoal").val("");
}

function deleteTeamGoal() {
    if (!validateControls('modalDeleteTeamGoal')) {
        return false;
    }
    var reply = misConfirm("Are you sure you want to mark goal as irrelevant", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                userAbrhs: misSession.userabrhs,
                goalId: $("#hdnTeamGoalId").val(),
                remarks: $("#remarksForTeamGoal").val(),
            };
            calltoAjax(misApiUrl.deleteTeamGoal, "POST", jsonObject,
                function (result) {
                    if (result) {
                        misAlert("Request processed successfully", "Success", "success");
                        $("#modalDeleteTeamGoal").modal('hide');
                        loadTeamGoalGrid();
                    }
                    else
                        misAlert("No such record present", "Error", "error");
                });
        }
    });
}

function openPopupEditTeamGoal(goalId) {
    $("#modalEditTeamGoal").modal('show');
    $("#hdnEditTeamGoalId").val(goalId);
    $("#teamGoalStartDate").datepicker({ autoclose: true, todayHighlight: true }).datepicker('setStartDate', _StartDateT);
    $("#teamGoalStartDate").datepicker({ autoclose: true, todayHighlight: true }).on('changeDate', function () {
        $("#teamGoalEndDate").val("");
        $("#teamGoalEndDate").datepicker('setStartDate', $("#goalStartDate").val());
    });
    $("#teamGoalEndDate").datepicker({ autoclose: true, todayHighlight: true }).datepicker('setEndDate', _EndDateT);
    var jsonObject = {
        goalId: $("#hdnEditTeamGoalId").val(),
    };
    calltoAjax(misApiUrl.fetchTeamGoalDetailById, "POST", jsonObject,
        function (result) {
            if (result != null) {
                $("#teamGoalStartDate").val(result.StartDate);
                $("#teamGoalEndDate").val(result.EndDate);
                $("#teamGoalStartDate").removeClass('error-validation');
                $("#teamGoalEndDate").removeClass('error-validation');
                $("#teamGoalEndDate").datepicker('setStartDate', result.StartDate);
                bindGoalCategory("#ddlTeamGoalCategory", result.GoalCategoryId);
                $("#teamGoalDesc").val(result.Goal);
            }
            else
                misAlert("Unable to fetch goal details", "Error", "error");
        });
}

function editTeamGoal() {
    if (!validateControls('editTeamGoalDiv'))
        return false;
    var jsonObject = {
        GoalId: $("#hdnEditTeamGoalId").val(),
        StartDate: $("#teamGoalStartDate").val(),
        EndDate: $("#teamGoalEndDate").val(),
        GoalCategoryId: parseInt($("#ddlTeamGoalCategory").val() || 0),
        Goal: $("#teamGoalDesc").val(),
        UserAbrhs: misSession.userabrhs,
    };
    calltoAjax(misApiUrl.editTeamGoal, "POST", jsonObject,
        function (result) {
            if (result === 1) {
                misAlert("Request processed successfully", "Success", "success");
                $("#modalEditTeamGoal").modal('hide');
                loadTeamGoalGrid();
            }
            else
                misAlert("Unable to process request", "Error", "error");
        });
}
