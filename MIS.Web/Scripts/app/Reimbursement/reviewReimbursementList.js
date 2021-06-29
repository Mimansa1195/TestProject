var _reimbursementRequestAbrhs, _action;
$(document).ready(function () {
    $("#reimbursementDiv .gridViewHeader .tbl-cell").on("click", function () {
        $(this).find("i").toggleClass("fa-chevron-circle-up , fa-chevron-circle-down");
    });
    $("#pendingDiv").trigger('click');
    $("#btnBackToReviewReimbursementList").hide();
    $("#lblReimbursementReview").html("Review Reimbursement");
    bindAllEmployees();
    $('#ddlEmployeeForReimbursement').multiselect({
        includeSelectAllOption: true,
        enableFiltering: true,
        enableCaseInsensitiveFiltering: true,
        buttonWidth: false,
        onDropdownHidden: function (event) {
        }
    });
    $("#ddlEmployeeForReimbursement").change(function () {
        loadReimbursementListToReview($("#viewReimbType").val(), $("#viewMonthYear").val());
    });

    $("#viewReimbType").on('change', function () {
        loadReimbursementListToReview($("#viewReimbType").val(), $("#viewMonthYear").val());
    });

    $("#viewMonthYear").on('change', function () {
        if ($("#viewMonthYear").val() == 0) {
            $("#lblFinancialYear").hide();
        }
        else {
            $("#lblFinancialYear").show();
            var selectFinancialYear = $("#viewMonthYear option:selected").text();
            var year = selectFinancialYear.split('-');
            $("#cntYear").html(year[0]);
            $("#nxtYear").html(year[1]);
        }
        loadReimbursementListToReview($("#viewReimbType").val(), $("#viewMonthYear").val());
    });

    $("#btnSubmitReimbursementRemark").click(function () {
        TakeActionOnReimbursementRequest();
    });

});

function bindAllEmployees() {
    $("#ddlEmployeeForReimbursement").multiselect('destroy');
    $("#ddlEmployeeForReimbursement").empty();
    $('#ddlEmployeeForReimbursement').multiselect();
    calltoAjax(misApiUrl.getAllEmployeesForReimbursement, "POST", '',
        function (result) {
            if (result != null && result.length > 0) {

                for (var x = 0; x < result.length; x++) {
                    $("#ddlEmployeeForReimbursement").append("<option value = '" + result[x].EmployeeAbrhs + "'>" + result[x].EmployeeName + "</option>");
                }
                $('#ddlEmployeeForReimbursement').multiselect("destroy");
                $('#ddlEmployeeForReimbursement').multiselect({
                    includeSelectAllOption: true,
                    enableFiltering: true,
                    enableCaseInsensitiveFiltering: true,
                    buttonWidth: false,
                    onDropdownHidden: function (event) {
                    }
                });
                $("#ddlEmployeeForReimbursement").multiselect('selectAll', false);
                $("#ddlEmployeeForReimbursement").multiselect('updateButtonText');
            }
            bindReimbursementTypeToView();
        });
}

function bindReimbursementTypeToView() {
    var currentDate = new Date();
    var year = currentDate.getFullYear();
    calltoAjax(misApiUrl.getReimbursementType, "POST", "",
        function (result) {
            $("#viewReimbType").empty();
            $("#viewReimbType").append("<option value='0'>All</option>");
            if (result !== null) {
                $.each(result, function (index, result) {
                    $("#viewReimbType").append("<option value=" + result.TypeId + ">" + result.TypeName + "</option>")
                });
                $("#viewReimbType").val(0);
            }
            bindMonthYearToView(year);
        });
}

function bindMonthYearToView(selectedYear) {
    $("#viewMonthYear").empty();
    $("#viewMonthYear").append("<option value='0'>All</option>");
    calltoAjax(misApiUrl.getReimbursementMonthYearToViewAndApprove, "POST", "", function (result) {
        if (result !== null) {
            $.each(result.YearText, function (idx, item) {
                var frmyear = item.Year;
                var endYear = item.Year + 1;
                var FY = frmyear + " - " + endYear;
                $("#viewMonthYear").append($("<option></option>").val(item.Year).html(FY));
            });
            $("#viewMonthYear").val(selectedYear);
            if ($("#viewMonthYear").val() == 0) {
                $("#lblFinancialYear").hide();
            }
            else {
                $("#lblFinancialYear").show();
                var selectFinancialYear = $("#viewMonthYear option:selected").text();
                var year = selectFinancialYear.split('-');
                $("#cntYear").html(year[0]);
                $("#nxtYear").html(year[1]);
            }
        }
        loadReimbursementListToReview(0, selectedYear);
    });
}

function loadReimbursementListToReview(reimursementTypeId, year) {
    var userAbrhs = "";
    if ($('#ddlEmployeeForReimbursement').val() !== null) {
        userAbrhs = $('#ddlEmployeeForReimbursement').val().join(",");
    }
    var jsonObject = {
        reimursementTypeId: reimursementTypeId,
        year: year,
        userAbrhs: userAbrhs
    };
    calltoAjax(misApiUrl.getReimbursementListToReview, "POST", jsonObject,
        function (result) {
            if (result.length === 0) {
                bindPendingReimbursementRequest(null);
                bindNonPendingReimbursementRequest(null);
            }
            else {
                var pendingReqData = [], nonPendingReqData = [];
                if (result[0].UserType === "Verifier") {
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
                bindPendingReimbursementRequest(pendingReqData);
                bindNonPendingReimbursementRequest(nonPendingReqData);
            }
        });
}

function bindPendingReimbursementRequest(result) {
    var data = $.parseJSON(JSON.stringify(result));
    if ($.fn.DataTable.isDataTable('#tblReimbursementPendingList')) {
        $('#tblReimbursementPendingList').DataTable().destroy();
    }
    $('#tblReimbursementPendingList tbody').empty();
    $("#tblReimbursementPendingList").dataTable({
        "dom": 'lBfrtip',
        "buttons": [{
            extend: 'collection',
            text: 'Export',
            buttons: [{ extend: 'copy' },
            { extend: 'excel' },
            { extend: 'pdf' },
            { extend: 'print' }]
        }],
        "responsive": true,
        "autoWidth": false,
        "paging": true,
        "bDestroy": true,
        "ordering": true,
        "order": [],
        "info": true,
        "footer": true,
        "deferRender": true,
        "aaData": data,
        "aoColumns": [
            {
                "mData": "EmployeeName",
                "sTitle": "Employee Name",
                "sWidth": "150px",
            },
            {
                "mData": "ReimursementType",
                "sTitle": "Request Type",
                "sWidth": "90px",
            },
            {
                "mData": "Department",
                "sTitle": "Department",
                "sWidth": "100px",
                "className": "none",
            },
            {
                "mData": "MonthYear",
                "sTitle": "Month & Year",
                "sWidth": "100px",
            },
            {
                "mData": null,
                "sWidth": "100px",
                "sTitle": "Remark/Status",
                mRender: function (data, type, row) {
                    var html = '<a  onclick="showReimbursementRemarksPopup(' + row.ReimbursementRequestId + ')" >' + row.Status+ '</a>';
                    return html;
                }
            },
            {
                "mData": "CreatedDate",
                "sTitle": "Requested On",
                "sWidth": "110px",
                "className": "none"
            },
            {
                "mData": "TotalAmount",
                "sTitle": '<i class="fa fa-inr"></i> Total',
                "sWidth": "100px",
                "className": "text-right",
            },
            {
                "mData": "RequestedAmount",
                "sTitle": '<i class="fa fa-inr"></i> Requested',
                "className": "text-right",
                "sWidth": "90px",
            },
            {
                "mData": "ApprovedAmount",
                "sTitle": '<i class="fa fa-inr"></i> Approved',
                "className": "text-right",
                "sWidth": "90px",
            },
            {
                "mData": null,
                "sWidth": "80px",
                "sTitle": "Action",
                "className": "text-center",
                "sClass": "All",
                mRender: function (data, type, row) {
                    var html = '<div>';
                    html += '&nbsp;<button type="button" class="btn btn-sm btn-success"  onclick="getFormToTakeAction(\'' + row.ReimbursementRequestAbrhs + '\',\'' + row.StatusCode + '\')"  title="Take action"><i class="fa fa-eye"> </i></button>';
                    html += '&nbsp;<button type="button" class="btn btn-sm btn-danger"  onclick="openRemarksPopUp(\'' + row.ReimbursementRequestAbrhs + '\',\'' + "RJ" + '\')"  title="Reject"><i class="fa fa-times"> </i></button>';
                    return html;
                }
            }

        ],
        "footerCallback": function (row, data, start, end, display) {
            var api = this.api(), data;

            // Remove the formatting to get integer data for summation
            var intVal = function (i) {
                return typeof i === 'string' ?
                    i.replace(/[\$,]/g, '') * 1 :
                    typeof i === 'number' ?
                        i : 0;
            };

            // Total over all pages
            total = api
                .column(6)
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);

            // Total over this page
            pageTotal = api
                .column(6, { page: 'current' })
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);

            // Update footer
            $(api.column(6).footer()).html(
                '<label><i class="fa fa-inr"></i><span> ' + pageTotal.toFixed(2) + '</span></label><label><i class="fa fa-inr"></i><span > ' + total.toFixed(2) + '</span></label>'
            );
            // Total over all pages
            total = api
                .column(7)
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);

            // Total over this page
            pageTotal = api
                .column(7, { page: 'current' })
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);

            // Update footer
            $(api.column(7).footer()).html(
                '<label><i class="fa fa-inr"></i><span> ' + pageTotal.toFixed(2) + '</span></label><label><i class="fa fa-inr"></i><span > ' + total.toFixed(2) + '</span></label>'
            );
            // Total over all pages
            total = api
                .column(8)
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);

            // Total over this page
            pageTotal = api
                .column(8, { page: 'current' })
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);

            // Update footer
            $(api.column(8).footer()).html(
                '<label><i class="fa fa-inr"></i><span> ' + pageTotal.toFixed(2) + '</span></label><label><i class="fa fa-inr"></i><span > ' + total.toFixed(2) + '</span></label>'
            );
        }
    });
}

function bindNonPendingReimbursementRequest(result) {
    var data = $.parseJSON(JSON.stringify(result));
    if ($.fn.DataTable.isDataTable('#tblReimbursementApprovedList')) {
        $('#tblReimbursementApprovedList').DataTable().destroy();
    }
    $('#tblReimbursementApprovedList tbody').empty();
    $("#tblReimbursementApprovedList").dataTable({
        "dom": 'lBfrtip',
        "buttons": [{
            extend: 'collection',
            text: 'Export',
            buttons: [{ extend: 'copy' },
            { extend: 'excel' },
            { extend: 'pdf' },
            { extend: 'print' }]
        }],
        "responsive": true,
        "autoWidth": false,
        "paging": true,
        "bDestroy": true,
        "ordering": true,
        "footer": true,
        "order": [],
        "info": true,
        "deferRender": true,
        "aaData": data,
        "aoColumns": [
            {
                "mData": "EmployeeName",
                "sTitle": "Employee Name",
                "sWidth": "150px",

            },
            {
                "mData": "ReimursementType",
                "sTitle": "Request Type",
                "sWidth": "80px",
            },

            {
                "mData": "Department",
                "sTitle": "Department",
                "sWidth": "90px",
                "className": "none",
            },

            {
                "mData": "MonthYear",
                "sTitle": "Month & Year",
                "sWidth": "90px",
            },
            {
                "mData": null,
                "sWidth": "150px",
                "sTitle": "Remark/Status",
                mRender: function (data, type, row) {
                    var html = '<a  onclick="showReimbursementRemarksPopup(' + row.ReimbursementRequestId + ')" >' +  row.Status + '</a>';
                    return html;
                }
            },
            {
                "mData": "CreatedDate",
                "sTitle": "Requested On",
                "sWidth": "90px",
                "className": "none",
            },
            {
                "mData": "TotalAmount",
                "sTitle": '<i class="fa fa-inr"></i> Total',
                "sWidth": "150px",
                "sClass": "all text-right",
            },
            {
                "mData": "RequestedAmount",
                "sTitle": '<i class="fa fa-inr"></i> Requested',
                "className": "text-right",
                "sWidth": "90px",
            },
            {
                "mData": "ApprovedAmount",
                "sTitle": '<i class="fa fa-inr"></i> Approved',
                "className": "text-right",
                "sWidth": "90px",
            },
            {
                "mData": null,
                "sWidth": "80px",
                "sTitle": "Action",
                "sClass": "all text-center",
                mRender: function (data, type, row) {
                    var html = '<div>';
                    html = '<button type="button" class="btn btn-sm btn-info" onclick="getFormToView(\'' + row.ReimbursementRequestAbrhs + '\',\'' + row.StatusCode + '\')"  title="View"><i class="fa  fa-eye"></i></button>';
                    return html;
                }
            }

        ],
        "footerCallback": function (row, data, start, end, display) {
            var api = this.api(), data;

            // Remove the formatting to get integer data for summation
            var intVal = function (i) {
                return typeof i === 'string' ?
                    i.replace(/[\$,]/g, '') * 1 :
                    typeof i === 'number' ?
                        i : 0;
            };

            // Total over all pages
            total = api
                .column(6)
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);

            // Total over this page
            pageTotal = api
                .column(6, { page: 'current' })
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);

            // Update footer
            $(api.column(6).footer()).html(
                '<label><i class="fa fa-inr"></i><span > ' + pageTotal.toFixed(2) + '</span></label><label><i class="fa fa-inr"></i><span > ' + total.toFixed(2) + '</span></label>'
            );
            // Total over all pages
            total = api
                .column(7)
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);

            // Total over this page
            pageTotal = api
                .column(7, { page: 'current' })
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);

            // Update footer
            $(api.column(7).footer()).html(
                '<label><i class="fa fa-inr"></i><span > ' + pageTotal.toFixed(2) + '</span></label><label><i class="fa fa-inr"></i><span > ' + total.toFixed(2) + '</span></label>'
            );
            // Total over all pages
            total = api
                .column(8)
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);

            // Total over this page
            pageTotal = api
                .column(8, { page: 'current' })
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);

            // Update footer
            $(api.column(8).footer()).html(
                '<label><i class="fa fa-inr"></i><span > ' + pageTotal.toFixed(2) + '</span></label><label><i class="fa fa-inr"></i><span > ' + total.toFixed(2) + '</span></label>'
            );
        },
        "fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
            if (aData.StatusCode === "CA") {
                $('td', nRow).css('background-color', '#c2cbd2');
            }
            else if (aData.StatusCode === "RJ") {
                $('td', nRow).css('background-color', '#f3a0a0');
            }
            else if (aData.StatusCode === "VD") {
                $('td', nRow).css('background-color', '#99ff99');
            }
            else if (aData.StatusCode === "RB") {
                $('td', nRow).css('background-color', 'rgb(243, 243, 160)');
            }
        }
    });

}

function getFormToView(reimbursementRequestAbrhs, statusCode) {
    $('#reimbursementDiv').addHiddenInputData({
        "hiddenReimursementRequestAbrhs": reimbursementRequestAbrhs,
        "hiddenActionCode": "View"
    });
    loadUrlToId(misAppUrl.getReimbursementFormDataToReview, 'partialReimbursementReviewContainer');
}

function openRemarksPopUp(reimbursementRequestAbrhs, action) {
    _reimbursementRequestAbrhs = reimbursementRequestAbrhs;
    _action = action;
    $("#reimbursementRemarkPopUp").modal('show');
}

function getFormToTakeAction(reimbursementRequestAbrhs, statusCode) {
    $('#reimbursementDiv').addHiddenInputData({
        "hiddenReimursementRequestAbrhs": reimbursementRequestAbrhs,
        "hiddenActionCode": "TakeAction"
    });
    loadUrlToId(misAppUrl.getReimbursementFormDataToReview, 'partialReimbursementReviewContainer');
}

function showReimbursementRemarksPopup(reimbursementRequestId) {
    var jsonObject = {
        reimbursementRequestId: reimbursementRequestId,
    };
    calltoAjax(misApiUrl.getReimbusrementStatusHistory, "POST", jsonObject,
        function (result) {
            var resultdata = $.parseJSON(JSON.stringify(result));
            $('#reimbursementHistoryBodyForReview').DataTable({
                "bDestroy": true,
                "bPaginate": false,
                "bFilter": false,
                "info": false,
                "aaData": resultdata,
                "aoColumns": [
                    { "sTitle": "Date", "mData": "Date", "sWidth": "80px" },
                    { "sTitle": "Status", "mData": "Status", "sWidth": "90px" },
                    { "sTitle": "Action Taken By", "mData": "ApproverName", "sWidth": "100px" },
                    { "sTitle": "Comment", "mData": "Remarks", "sWidth": "200px" },
                ],
            });
        });
    $("#reimbursementRemarkHistory").modal('show');
}

function TakeActionOnReimbursementRequest() {
    var remarks = $('#approverRemark').val().trim();
    if (remarks === "") {
        misAlert("Please fill remarks", "Warning", "warning");
        return false;
    }
    var jsonObject = {
        ReimbursementRequestAbrhs: _reimbursementRequestAbrhs,
        ReimbursementDetailAbrhs: "",
        ActionType: _action,
        Remarks: remarks,
        ReimbursementTypeId: $("#viewReimbType").val()
    };
    calltoAjax(misApiUrl.takeActionOnReimbursementRequest, "POST", jsonObject,
        function (result) {
            if (result === 1 && _action == "RJ") {
                $("#reimbursementRemarkHistory").modal('hide');
                loadReimbursementListToReview($("#viewReimbType").val(), $("#viewMonthYear").val());
                misAlert("Reimbursement request has been rejected successfully..", "Success", "success");
            }
            else {
                misAlert("Unable to process request. Please try again.", "Error", "error");
            }
        });
}
