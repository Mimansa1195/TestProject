$(function () {
    $("#lblReimbursementRequest").html("Reimbursement Request");
    $("#btnBackToReimbursementList").hide();
    loadReimbursementList(0, 0);
    bindReimbursementTypeToView();
    var currentDate = new Date();
    var year = currentDate.getFullYear();
    bindMonthYearToView(year);
    $("#btnRequestReimbursement").show();
    $("#viewReimbType").on('change', function () {
        loadReimbursementList($("#viewReimbType").val(), $("#viewMonthYear").val());
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
        loadReimbursementList($("#viewReimbType").val(), $("#viewMonthYear").val());
    });
});

function bindReimbursementTypeToView() {
    $("#viewReimbType").empty();
    $("#viewReimbType").append("<option value='0'>All</option>")
    calltoAjax(misApiUrl.getReimbursementType, "POST", "",
        function (result) {
            if (result !== null) {
                $.each(result, function (index, result) {
                    $("#viewReimbType").append("<option value=" + result.TypeId + ">" + result.TypeName + "</option>")
                });
                $("#viewReimbType").val(0);
            }
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
    });
}

function showReimbursementRemarksPopup(reimbursementRequestId) {
    var jsonObject = {
        reimbursementRequestId: reimbursementRequestId,
    };
    calltoAjax(misApiUrl.getReimbusrementStatusHistory, "POST", jsonObject,
        function (result) {
            var resultdata = $.parseJSON(JSON.stringify(result));
            $('#reimbursementHistoryBody').DataTable({
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
                    { "sTitle": "Date", "mData": "Date", "sWidth": "100px" },
                    { "sTitle": "Status", "mData": "Status", "sWidth": "100px" },
                    { "sTitle": "Action Taken By", "mData": "ApproverName", "sWidth": "100px" },
                    { "sTitle": "Comment", "mData": "Remarks", "sWidth": "150px" },
                ],
            });
        });
    $("#reimbursementRemark").modal('show');
}

function loadReimbursementList(reimursementTypeId, selectedYear) {
    var jsonObject = {
        reimursementTypeId: reimursementTypeId,
        year: selectedYear
    };
    calltoAjax(misApiUrl.getReimbursementListToView, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblReimbursementList").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel' },
                        { extend: 'pdf' },
                        { extend: 'print' },
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
                "footer": true,
                "deferRender": true,
                "aaData": data,
                "aoColumns": [
                    {
                        "mData": "ReimursementType",
                        "sTitle": "Request Type",
                        "sWidth": "80px",
                    },
                    {
                        "mData": "MonthYear",
                        "sTitle": "Month & Year",
                        "sWidth": "90px",
                    },
                    {
                        "mData": null,
                        "sWidth": "90px",
                        "sTitle": "Remark/Status",
                        mRender: function (data, type, row) {
                            var html = '<a  onclick="showReimbursementRemarksPopup(' + row.ReimbursementRequestId + ')" >' + row.Status + '</a>';
                            return html;
                        }
                    },
                    {
                        "mData": "CreatedDate",
                        "sTitle": "Requested On",
                        "className": "none",
                        "sWidth": "120px"
                    },
                    {
                        "mData": "TotalAmount",
                        "sTitle": '<i class="fa fa-inr"></i> Total',
                        "className": "text-right",
                        "sWidth": "90px",
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
                        "sWidth": "90px",
                        "className": "text-left",
                        "sTitle": "Action",
                        mRender: function (data, type, row) {
                            var html = '<div>';
                            if (data.StatusCode === "RB" || data.StatusCode === "DF") {
                                html += '<button type="button" class="btn btn-sm btn-success"  onclick="getFormToEdit(\'' + row.ReimbursementRequestAbrhs + '\',\'' + row.MonthYear + '\')"  title="Edit"><i class="fa fa-pencil-square-o"> </i></button>';
                                html += '&nbsp;<button type="button" class="btn btn-sm btn-danger"  onclick="cancelReimbursementRequest(\'' + row.ReimbursementRequestAbrhs + '\',\'' + reimursementTypeId + '\',\'' + selectedYear + '\')"  title="Cancel"><i class="fa fa-times"> </i></button>';
                            }
                            else if (data.StatusCode === "PA" || data.StatusCode === "PV" || data.StatusCode === "AP") {
                                html = '<button type="button" class="btn btn-sm btn-info" onclick="getFormToView(\'' + row.ReimbursementRequestAbrhs + '\',\'' + row.MonthYear + '\')"  title="View"><i class="fa  fa-eye"></i></button>';
                                html += '&nbsp;<button type="button" class="btn btn-sm btn-danger"  onclick="cancelReimbursementRequest(\'' + row.ReimbursementRequestAbrhs + '\',\'' + reimursementTypeId + '\',\'' + selectedYear + '\')"  title="Cancel"><i class="fa fa-times"> </i></button>';
                            }
                            else {//VD, RJ, CA,
                                html = '<button type="button" class="btn btn-sm btn-info" onclick="getFormToView(\'' + row.ReimbursementRequestAbrhs + '\',\'' + row.MonthYear + '\')"  title="View"><i class="fa  fa-eye"></i></button>';
                            }
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
                        .column(4)
                        .data()
                        .reduce(function (a, b) {
                            return intVal(a) + intVal(b);
                        }, 0);

                    // Total over this page
                    pageTotal = api
                        .column(4, { page: 'current' })
                        .data()
                        .reduce(function (a, b) {
                            return intVal(a) + intVal(b);
                        }, 0);
                    // Update footer
                    $(api.column(4).footer()).html(
                        '<label><i class="fa fa-inr"></i><span> ' + pageTotal.toFixed(2) + '</span></label><label><i class="fa fa-inr"></i><span > ' + total.toFixed(2) + '</span></label>'
                    );

                    // Total over all pages
                    total = api
                        .column(5)
                        .data()
                        .reduce(function (a, b) {
                            return intVal(a) + intVal(b);
                        }, 0);

                    // Total over this page
                    pageTotal = api
                        .column(5, { page: 'current' })
                        .data()
                        .reduce(function (a, b) {
                            return intVal(a) + intVal(b);
                        }, 0);
                    // Update footer
                    $(api.column(5).footer()).html(
                        '<label><i class="fa fa-inr"></i><span> ' + pageTotal.toFixed(2) + '</span></label><label><i class="fa fa-inr"></i><span > ' + total.toFixed(2) + '</span></label>'
                    );

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

        });
}

function getFormToEdit(reimbursementRequestAbrhs, monthYear) {
    $('#reimbursementDiv').addHiddenInputData({
        "hiddenReimursementRequestAbrhs": reimbursementRequestAbrhs,
        "hiddenAction": "Edit"
    });
    loadUrlToId(misAppUrl.manageReimbursementRequest, 'partialReimbursementContainer');
}

function getFormToView(reimbursementRequestAbrhs, monthYear) {
    $('#reimbursementDiv').addHiddenInputData({
        "hiddenReimursementRequestAbrhs": reimbursementRequestAbrhs,
        "hiddenAction": "Edit"
    });
    loadUrlToId(misAppUrl.viewReimbursementFormDetail, 'partialReimbursementContainer');
}

function cancelReimbursementRequest(reimbursementRequestAbrhs, reimbursementTypeId, selectedYear) {
    var reply = misConfirm("Are you sure you want to cancel this request ?", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                reimbursementRequestAbrhs: reimbursementRequestAbrhs
            };
            calltoAjax(misApiUrl.cancelReimbursementRequest, "POST", jsonObject,
                function (result) {
                    if (result == 1) {
                        loadReimbursementList(reimbursementTypeId, selectedYear);
                        misAlert("Reimbursement request have been cancelled successfully.", "Success", "success");
                    }
                    else {
                        misAlert("Unable to process request. Please try again.", "Error", "error");
                    }
                });
        }
    });
}
