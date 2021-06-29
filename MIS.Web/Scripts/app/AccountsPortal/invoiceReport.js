﻿var tableInvoiceReport;
$(document).ready(function () {
    getInvoicesForReview();

    bindClientDropDown();
    bindFYDropDown();
    bindMonthDropDown();
    //processInvoiceReport();
    $("#FYear").on('change', function () {
        bindMonthDropDown();
    });
    $("#btnAddNew").click(function () {
        $("#popupAddClient").modal("show");
    });

    $("#btnReasonClose").click(function () {
        $("#mypopupReason").modal("hide");
        $("#reason").val("");
        $("#reason").removeClass('error-validation');
    });

    $("#btnClose").click(function () {
        $("#modalInvoiceDetail").modal("hide");
    });

    $("#btnCloseAnother").click(function () {
        $("#modalInvoiceDetail").modal("hide");
    });

    $("#close").click(function () {
        $("#popupAddClient").modal("hide");
        $("#clientName").removeClass('error-validation');
    });

    $("#closeAnother").click(function () {
        $("#popupAddClient").modal("hide");
        $("#clientName").removeClass('error-validation');
    });

    $("#submitReasonRemark").click(function () {
        if (!validateControls('reasonDiv')) {
            return false;
        }
        takeActionOnSubmitRemarks();
    });

    var popOverSettings = {
        selector: '[rel=popover]',
        trigger: 'hover',
        placement: 'left',
        container: 'body',
        html: true,
        content: function () {
            return $(this).attr("data-attr-JD");
        }
    }
    $('body').popover(popOverSettings);

    // Add event listener for opening and closing details
    $(document).on("click", "#tblInvoiceReportList tbody tr[role='row']", function () {
        var tr = $(this).closest('tr');
        var row = tableInvoiceReport.row(tr);
        if (row.child.isShown()) {
            row.child.hide();
            $("#tblInvoiceReportList tbody tr").removeClass('shown expand');
        }
        else {
            tableInvoiceReport.rows().eq(0).each(function (idx) {
                var row = tableInvoiceReport.row(idx);
                if (row.child.isShown()) {
                    row.child.hide();
                }
            });
            row.child(formatInvoiceDetail(row.data().InvoiceList)).show();
            $("#tblInvoiceReportList tbody tr").removeClass('shown expand');
            tr.addClass('shown expand');
        }
    });
});

function formatInvoiceDetail(InvoiceList) {
    if (InvoiceList.length > 0) {
        var html = '<table class="tbl-typical fixed-header text-left"><thead><tr><th> <div>Generated By</div></th><th><div>Invoice Number</div></th><th><div>Generated On</div></th><th><div>Status</div></th><th><div>Action</div></th></tr></thead><tbody>';
        for (var j = 0; j < InvoiceList.length; j++) {
            if (InvoiceList[j].IsCancellable == true)
                html += '<tr><td>' + InvoiceList[j].CreatedBy + '</td><td>' + InvoiceList[j].InvoiceNumber + '</td><td>' + moment(InvoiceList[j].CreatedOn).format('DD MMM YYYY hh:mm:ss') + '</td><td><span rel="popover"  data-toggle="popover" title="Reason" data-attr-JD="' + InvoiceList[j].Reason + '" class="label label-danger">Cancelled</span></td><td></td></tr>';
            else
                html += '<tr><td>' + InvoiceList[j].CreatedBy + '</td><td>' + InvoiceList[j].InvoiceNumber + '</td><td>' + moment(InvoiceList[j].CreatedOn).format('DD MMM YYYY hh:mm:ss') + '</td><td><span class="label label-info" >Booked</span ></td><td><button type="button" class="btn btn-sm btn-danger" onclick="openReasonPopup(\'' + InvoiceList[j].InvoiceId + '\',3)" data-toggle="tooltip" title="Cancel"><i class="fa fa-times"></i></button></td></tr>';
        }
        html += '</tbody></table>';
        return html;
    }
}

function onReviewInvoiceTabClick() {
    getInvoicesForReview();
}

function formatReviewInvoiceDetail(InvoiceList) {
    if (InvoiceList.length > 0) {
        var html = '<table class="tbl-typical  fixed-header text-left"><thead><tr><th> <div>Client</div></th><th><div>No Of Invoices</div></th></tr></thead><tbody>';
        for (var j = 0; j < InvoiceList.length; j++) {
            html += '<tr><td>' + InvoiceList[j].ClientName + '</td><td>' + InvoiceList[j].NoOfInvoices + '</td></tr>';
        }
        html += '</tbody></table>';
        return html;
    }
}

function getInvoicesForReview() {
    calltoAjax(misApiUrl.getInvoicesForReview, "POST", "", function (result) {
        var resultData = $.parseJSON(JSON.stringify(result));
        var table = $('#tblInvoiceReviewList').DataTable({
            "dom": 'lBfrtip',
            "responsive": true,
            "autoWidth": false,
            "paging": true,
            "bDestroy": true,
            "ordering": false,
            "info": true,
            "deferRender": true,
            "buttons": [
                {
                    filename: 'Invoice Review List',
                    extend: 'collection',
                    text: 'Export',
                    buttons: [{ extend: 'copy' },
                    { extend: 'excel', filename: 'Invoice Review List' },
                    { extend: 'pdf', filename: 'Invoice Review List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                    { extend: 'print', filename: 'Invoice Review List' },
                    ]
                }
            ],
            "aaData": resultData,
            "aoColumns": [
                {

                    "className": 'details-control',
                    "orderable": false,
                    "mData": null,
                    "defaultContent": ''
                },
                {
                    "mData": "CreatedBy",
                    "sTitle": "Requested By",
                },
                {
                    "mData": null,
                    "sTitle": "Requested On",
                    mRender: function (data, type, row) {
                        return moment(row.CreatedOn).format('DD MMM YYYY hh:mm:ss');
                    }
                },
                {
                    "mData": null,
                    "sTitle": "Action",
                    mRender: function (data, type, row) {
                        var html = '<div>';
                        //if (data.IsApproved == 0) {
                        html += '&nbsp;<button type="button" class="btn btn-sm btn-success" onclick="takeActionOnInvoiceRequest(\'' + row.InvoiceId + '\' , 1)" data-toggle="tooltip" title="Approve"><i class="fa fa-check"></i></button>';
                        html += '&nbsp;<button type="button" class="btn btn-sm btn-danger" onclick="openReasonPopup(\'' + row.InvoiceId + '\',2)" data-toggle="tooltip" title="Reject"><i class="fa fa-times"></i></button>';
                        return html;
                        //}
                        //else {
                        //    html += '<span class="label label-info" >Responded</span >';
                        //    return html;
                        //}
                    }
                },
            ], "rowCallback": function (row, data) {
                if (data.InvoiceList.length == 0) {
                    $('td:eq(0)', row).removeClass("details-control");
                } else {
                }
            }, "order": [[1, 'asc']]
        });
        $('#tblInvoiceReviewList tbody').on('click', 'td.details-control', function () {
            var tr = $(this).closest('tr');
            var row = table.row(tr);
            //console.log(resultData)
            if (row.child.isShown()) {
                row.child.hide();
                $("#tblInvoiceReviewList tbody tr").removeClass('shown expand');
            }
            else {
                table.rows().eq(0).each(function (idx) {
                    var row = table.row(idx);
                    if (row.child.isShown()) {
                        row.child.hide();
                    }
                });
                row.child(formatReviewInvoiceDetail(row.data().InvoiceList)).show();
                $("#tblInvoiceReviewList tbody tr").removeClass('shown expand');
                tr.addClass('shown expand');
            }
        });
    });
}

function bindClientDropDown() {
    calltoAjax(misApiUrl.getClients, "POST", '', function (result) {
        $('#clientForReport').multiselect("destroy");
        $('#clientForReport').empty();
        $.each(result, function (index, value) {
            $('<option selected>').val(value.Value).text(value.Text).appendTo('#clientForReport');
        });
        $('#clientForReport').multiselect({
            includeSelectAllOption: true,
            enableFiltering: true,
            enableCaseInsensitiveFiltering: true,
            buttonWidth: false,
            onDropdownHidden: function (event) {
            }
        });
    processInvoiceReport();

    });
}

function bindFYDropDown() {
    $("#FYear").empty();
    //$("#FYear").append($("<option></option>").val(0).html("Select"));
    calltoAjax(misApiUrl.getFinancialYearsForAccounts, "POST", '', function (result) {
        $.each(result, function (idx, item) {
            $("#FYear").append($("<option></option>").val(item.StartYear).html(item.Text));
        });
    });
}

function bindMonthDropDown() {
    var fYear = $("#FYear").val();
    if (fYear == null)
        fYear = new Date(misSession.fystartdate).getFullYear();
    var jsonObject = {
        year: fYear
    }
    calltoAjax(misApiUrl.getMonths, "POST", jsonObject, function (result) {
        $('#month').multiselect("destroy");
        $('#month').empty();
        $.each(result, function (index, value) {
            $('<option>').val(value.StartYear).text(value.Text).appendTo('#month');
        });
        $('#month').multiselect({
            includeSelectAllOption: true,
            enableFiltering: true,
            enableCaseInsensitiveFiltering: true,
            buttonWidth: false
        });
        var currentMonth = new Date().getMonth() + 1;
        $('#month').multiselect('select', [currentMonth]);
        processInvoiceReport();
    });
}

function addClient() {
    if (!validateControls('addClient')) {
        return false;
    }
    var jsonObject = {
        clientName: $("#clientName").val(),
        userAbrhs: misSession.userabrhs
    }
    calltoAjax(misApiUrl.addClient, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            switch (resultData) {
                case 2:
                    misAlert("This client already exists.", "Warning", "warning");
                    $("#popupAddClient").modal("hide");
                    $("#clientName").val("");
                    break;
                case 1:
                    misAlert("Client has been added successfully.", "Success", "success");
                    $("#popupAddClient").modal("hide");
                    $("#clientName").val("");
                    break;
                case 0:
                    misAlert("Unable to process request. Try again", "Error", "error");
                    $("#popupAddClient").modal("hide");
                    $("#clientName").val("");
                    break;
            }
        });
}

function processInvoiceReport() {
    if (!validateControls('invoiceReportFilter')) {
        return false;
    }
    loadInvoiceReportGrid();
}
//function onInvoiceReportTabClick() {
//    loadInvoiceReportGrid();
//}

function loadInvoiceReportGrid() {
    var clientIds = (($('#clientForReport').val() !== null && typeof $('#clientForReport').val() !== 'undefined' && $('#clientForReport').val().length > 0) ? $('#clientForReport').val().join(',') : '0');
    var months = (($('#month').val() !== null && typeof $('#month').val() !== 'undefined' && $('#month').val().length > 0) ? $('#month').val().join(',') : new Date().getMonth() + 1);
    var jsonObject = {
        clientIds: clientIds,
        year: $('#FYear').val() ? $('#FYear').val() : new Date(misSession.fystartdate).getFullYear(),
        months: months 
    }
    calltoAjax(misApiUrl.getInvoiceReport, "POST", jsonObject, function (result) {
        var resultData = $.parseJSON(JSON.stringify(result));
        tableInvoiceReport = $('#tblInvoiceReportList').DataTable({
            "dom": 'lBfrtip',
            "responsive": true,
            "autoWidth": false,
            "paging": true,
            "bDestroy": true,
            "ordering": true,
            "info": true,
            "deferRender": true,
            "buttons": [
                {
                    filename: 'Invoice Report',
                    extend: 'collection',
                    text: 'Export',
                    buttons: [{ extend: 'copy' },
                    { extend: 'excel', filename: 'Invoice Report' },
                    { extend: 'pdf', filename: 'Invoice Report' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                    { extend: 'print', filename: 'Invoice Report' },
                    ]
                }
            ],
            "aaData": resultData,
            "aoColumns": [
                {

                    "className": 'details-control',
                    "orderable": false,
                    "mData": null,
                    "defaultContent": ''
                },
                {
                    "mData": "ClientName",
                    "sTitle": "Client",
                },
                {
                    "mData": "InvoiceCount",
                    "sTitle": "Total Invoices",
                },
                {
                    "mData": "BookedCount",
                    "sTitle": "Booked",
                },
                {
                    "mData": "CancelledCount",
                    "sTitle": "Cancelled",
                },
            ], "rowCallback": function (row, data) {
                if (data.InvoiceList.length == 0) {
                    $('td:eq(0)', row).removeClass("details-control");
                } else {
                }
            }, "order": [[1, 'asc']]
        });
    });
}

function takeActionOnInvoiceRequest(invoiceRequestId, forApproval) {
    var jsonObject = {
        invoiceRequestId: invoiceRequestId,
        forApproval: forApproval
    }
    misConfirm("Are you sure you want to approve this request?", "Confirm", function (isConfirmed) {
        if (isConfirmed) {
            calltoAjax(misApiUrl.takeActionOnInvoiceRequest, "POST", jsonObject, function (result) {
                var resultData = $.parseJSON(JSON.stringify(result));
                if (resultData) {
                    switch (resultData) {
                        case 1:
                            misAlert("Invoice request has been approved successfully.", "Success", "success");
                            //$("#client").val(0);
                            //$("#mypopupGenerateInvoice").modal("hide");
                            getInvoicesForReview();
                            break;
                        case 0:
                            misAlert("Unable to process request. Try again", "Error", "error");
                            //$("#client").val(0);
                            //$("#mypopupGenerateInvoice").modal("hide");
                            getInvoicesForReview();
                            break;
                    }
                }
            });
        }
    });
}
var _invoiceRequestId = 0;
var _forApproval = 0;
function openReasonPopup(invoiceRequestId, forApproval) {
    _invoiceRequestId = invoiceRequestId;
    _forApproval = forApproval;
    $("#mypopupReason").modal("show");
    if (forApproval == 3) {
        $("#heading").text("Cancel Invoice");
        $("#reason").attr("placeholder", "Please enter reason for cancellation.")
    }
    $("#reason").removeClass('error-validation');
    $("#reason").val("");
}

function takeActionOnSubmitRemarks() {
    var jsonObject = {
        invoiceRequestId: _invoiceRequestId,
        forApproval: _forApproval,
        reason: $("#reason").val()
    }
    calltoAjax(misApiUrl.takeActionOnInvoiceRequest, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            if (resultData) {
                switch (resultData) {
                    case 3:
                        misAlert("Invoice has been cancelled successfully.", "Success", "success");
                        $("#reason").val("");
                        $("#mypopupReason").modal("hide");
                        loadInvoiceReportGrid();
                        break;

                    case 2:
                        misAlert("Invoice request has been rejected successfully.", "Success", "success");
                        $("#reason").val("");
                        $("#mypopupReason").modal("hide");
                        getInvoicesForReview();
                        break;
                    case 0:
                        misAlert("Unable to process request. Try again", "Error", "error");
                        $("#reason").val(0);
                        $("#mypopupReason").modal("hide");
                        getInvoicesForReview();
                        break;
                }
            }
        });
}

//function viewInvoiceDetail(invoiceId) {
//    $("#modalInvoiceDetail").modal("show");
//    var jsonObject = {
//        invoiceId: invoiceId
//    }
//    calltoAjax(misApiUrl.getInvoiceDetail, "POST", jsonObject,
//        function (result) {
//            //console.log(result)
//            var resultData = $.parseJSON(JSON.stringify(result));

//            if (resultData.length > 0) {
//                var html = '<table class="tbl-typical fixed-header text-left"><thead><tr><th> <div>Invoice Numbers</div></th></tr></thead> <tbody>';
//                for (var j = 0; j < resultData.length; j++) {
//                    html += '<tr><td>' + resultData[j].InvoiceNumber + '</td></tr>';
//                }
//                html += '</tbody></table>';
//                $("#tblInvoiceDetail").html(html);
//            }
//        });
//}