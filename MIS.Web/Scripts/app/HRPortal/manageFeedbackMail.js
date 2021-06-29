var tableEmployeeListForFeedback = "";
var _selectedEmployeeEmailIds = "";
var rows_selected = [];
var Employee_selected = [];
var today = new Date();
var fillByDate = new Date(today.getFullYear(), (today.getMonth()), (today.getDate() + 7));

$(document).ready(function () {
    $('#txtFromDate').datepicker({
        autoclose: true,
        todayHighlight: true,
        format: "mm/dd/yyyy",
    }).datepicker('setDate', new Date()).on('changeDate', function (ev) {
        onFromDateChange();
    });

    $('#txtTillDate').datepicker({
        autoclose: true,
        todayHighlight: true,
        format: "mm/dd/yyyy",
    }).datepicker('setStartDate', new Date()).datepicker('setDate', new Date());

    getEmployeeListForFeedBackMail();

    $("#btnSearch").click(function () {
        if (!validateControls('divFilter'))
            return false;
        getEmployeeListForFeedBackMail();
    });
});

// Handle click on checkbox
$('body').on('click', '#tblEmployeeListForFeedbackMail tbody input[type="checkbox"]', function (e) {
    var $row = $(this).closest('tr');
    // Get row data
    var data = tableEmployeeListForFeedback.row($row).data();
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
    updateDataTableSelectAllCtrlUn(tableEmployeeListForFeedback);
    // Prevent click event from propagating to parent
    e.stopPropagation();
});

// Handle table draw event
if (tableEmployeeListForFeedback) {
    tableEmployeeListForFeedback.on('draw', function () {
        // Update state of "Select all" control
        updateDataTableSelectAllCtrlUn(tableEmployeeListForFeedback);
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
$('body').on('click', '#selectAllEmp', function (e) {
    if (this.checked) {
        $('input[type="checkbox"]', '#tblEmployeeListForFeedbackMail').prop('checked', true);
        var count = $('#tblEmployeeListForFeedbackMail tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    } else {
        $('input[type="checkbox"]', '#tblEmployeeListForFeedbackMail').prop('checked', false);
        var count = $('#tblEmployeeListForFeedbackMail tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    }
    // Prevent click event from propagating to parent
    e.stopPropagation();
})

function showPopupOnBulkSendMail() {

    $('#txtFillByDate').datepicker({
        autoclose: true,
        todayHighlight: true,
        format: "mm/dd/yyyy",
    }).datepicker('setStartDate', new Date()).datepicker('setDate', fillByDate);

    var selectedEmployeeEmailIds = [];
    var selectedEmployees = [];
    _selectedEmployeeEmailIds = "";
    $("#tblEmployeeListForFeedbackMail").dataTable().$('input[type="checkbox"]').each(function () {
        if (this.checked) {
            selectedEmployeeEmailIds.push($(this).val());
            selectedEmployees.push(this.parentNode.nextElementSibling.firstChild.nodeValue.trim());
        }
    });
    selectedEmployees = jQuery.unique(selectedEmployees);
    var Names = selectedEmployees.join(", ");
    _selectedEmployeeEmailIds = selectedEmployeeEmailIds.join();
    $("#employeesNames").html(Names);

    if (selectedEmployees.length > 0) {
        $("#mypopupSendBulkMail").modal("show");
    }
    else {
        misAlert("Please select an employee.", "Warning", "warning");
    }
}

function showPopupOnIndividualSendMail(empEmailId, empName) {
    _selectedEmployeeEmailIds = empEmailId;
    $("#employeesNames").html(empName);
    $('#txtFillByDate').datepicker({
        autoclose: true,
        todayHighlight: true,
        format: "mm/dd/yyyy",
    }).datepicker('setStartDate', new Date()).datepicker('setDate', fillByDate);
    $("#mypopupSendBulkMail").modal("show");
}

$("#btnSendBulkMail").click(function () {
    if (!validateControls('mypopupSendBulkMail'))
        return false;

    sendProbationAndTrainingCompletionEmail(_selectedEmployeeEmailIds);
});

function onFromDateChange() {
    var fromDate = $("#txtFromDate input").val();
    $('#txtTillDate input').val("");
    $('#txtTillDate').datepicker({ autoclose: true, todayHighlight: true }).datepicker('setStartDate', fromDate);
}

function getEmployeeListForFeedBackMail() {

    var jsonObject = {
        emailFromDate: $("#txtFromDate input").val(),
        emailTillDate: $('#txtTillDate input').val()
    };
    calltoAjax(misApiUrl.getEmployeeListForFeedBackMail, "POST", jsonObject,
        function (result) {

            if (result.length > 0) {
                var html = "<button type='button' class='btn btn-primary' onclick=\"showPopupOnBulkSendMail()\" > <i class='fa fa-check'></i>&nbsp;Send Mail </button>";
                $("#divBulkSendMail").html(html);
            }

            var resultData = $.parseJSON(JSON.stringify(result));

            $("#tblEmployeeListForFeedbackMail").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'Job Openings List',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'Job Openings List' },
                        { extend: 'pdf', filename: 'Job Openings List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                        { extend: 'print', filename: 'Job Openings List' },
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
                        "sTitle": '<input name="select_all" value="1" id="selectAllEmp" type="checkbox" />',
                        'className': 'dt-body-center',
                        'render': function (data, type, full, meta) {
                            if (full.Selected) {
                                return '<input type="checkbox" name="id[' + full.EmployeeEmailId + ']" value="' + full.EmployeeEmailId + '" checked="' + full.EmployeeEmailId + '">';
                            }
                            else {
                                return '<input type="checkbox" name="id[' + full.EmployeeEmailId + ']" value="' + full.EmployeeEmailId + '">';
                            }

                        }
                    },
                    {
                        "mData": "EmployeeName",
                        "sTitle": "Employee Name",
                    },
                    {
                        "mData": "EmployeeCode",
                        "sTitle": "Employee Code",
                    },
                    {
                        "mData": "RMFullName",
                        "sTitle": "Reporting Manager",
                    },
                    {
                        "mData": "CompletionType",
                        "sTitle": "Completion Type",
                    },
                    {
                        "mData": "CompletionDate",
                        "sTitle": "Completion Date",
                    },
                    {
                        "mData": "EmailDate",
                        "sTitle": "Email Date",
                    },

                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        "sClass": "text-center",
                        mRender: function (data, type, row) {
                            var html = '';
                            html += '<button type="button" class="btn btn-sm btn-success" onclick="showPopupOnIndividualSendMail(\'' + row.EmployeeEmailId + '\', \'' + row.EmployeeName + '\')" data-toggle="tooltip" title="Send Email"><i class="fa fa-send"> </i></button>';
                            return html;
                        }
                    },
                ]
            });
            tableEmployeeListForFeedback = $('#tblEmployeeListForFeedbackMail').DataTable();
        });
}

function sendProbationAndTrainingCompletionEmail(empEmailIds) {
    var jsonObject = {
        emailFromDate: $("#txtFromDate input").val(),
        emailTillDate: $('#txtTillDate input').val(),
        fillByDate: $('#txtFillByDate input').val(),
        emailIds: empEmailIds,
    }
    calltoAjax(misApiUrl.sendProbationAndTrainingCompletionEmail, "POST", jsonObject,
        function (result) {
            if (result === 1) {
                $("#mypopupSendBulkMail").modal('hide');
                getEmployeeListForFeedBackMail();
                misAlert("Email has been sent successfully", "Success", "success");
            }
            else {
                misAlert("Unable to process request.", "Error", "error");
            }
        });
}
