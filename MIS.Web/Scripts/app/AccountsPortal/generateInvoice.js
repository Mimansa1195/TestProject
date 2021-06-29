var _invoiceCount = 0;
$(document).ready(function () {
    bindClientDropDown();
    bindAllClientDropDown();
    checkForRequestEligibility();
    loadInvoiceReportGrid();
    $("#client").select2();
    $("[data-toggle=popover]").each(function (i, obj) {
        $(this).popover({
            html: true,
            trigger: 'hover',
            //title: 'Invoice Permissions',
            placement: 'left',
            container: 'body',
            content: function () {
                return $('#popover-content-login').html();
            }
        });
    });
    $("#buttonClose").click(function () {
        $("#mypopupRequestInvoice").modal("hide");
        $("#noOfInvoices").removeClass('error-validation');
        $("#dynamicAddRequests").html("");
        $("#invoiceTotalCount").html("");
        $("#noOfInvoices").val("");
    });

    $("#btnClose").click(function () {
        $("#mypopupRequestInvoice").modal("hide");
        $("#noOfInvoices").removeClass('error-validation');
        $("#dynamicAddRequests").html("");
        $("#invoiceTotalCount").html("");
        $("#noOfInvoices").val("");
    });
    $("#btnCloseReason").click(function () {
        $("#mypopupReason").modal("hide");
        $("#reason").removeClass('error-validation');
        $("#reason").val("");
    });

    $("#btnCloseInv").click(function () {
        $("#mypopupGenerateInvoice").modal("hide");
        $($('#client').data('select2').$container).removeClass('error-validation');
        $("#client").select2("val", "");
    });

    $("#btnAddNewRequests").click(function () {
        if (!validateControls('dynamicAddRequests')) {
            return false;
        }
        generateControls('dynamicAddRequests');
    });

    $("#requestInvoice").click(function () {
        if (!validateControls('requestInvoiceDiv')) {
            return false;
        }
        if (getFormData().length == 0) {
            misAlert("Please add atleast one client and invoice.", "Warning", "warning");
            return false;
        }
        var jsonObject = {
            requestList: getFormData(),
            appLinkUrl: misAppUrl.actionOnRequestedInvoice,
            userAbrhs: misSession.userabrhs
        };
        calltoAjax(misApiUrl.requestInvoice, "POST", jsonObject,
            function (result) {
                var resultData = $.parseJSON(JSON.stringify(result));
                switch (resultData) {
                    case 2:
                        misAlert("Max 10 invoices are allowed.", 'Warning', 'warning');
                        //$("#dynamicAddRequests").empty();
                        //$("#mypopupRequestInvoice").modal("hide");
                        //checkForRequestEligibility();
                        break;
                    case 1:
                        misAlert("Request for invoice booking has been sent successfully. Please wait for approval.", "Success", "success");
                        $("#dynamicAddRequests").empty();
                        $("#mypopupRequestInvoice").modal("hide");
                        checkForRequestEligibility();
                        break;
                    case 0:
                        misAlert("Unable to process request. Try again", "Error", "error");
                        $("#dynamicAddRequests").empty();
                        $("#mypopupRequestInvoice").modal("hide");
                        checkForRequestEligibility();
                        break;
                }
            });
    });

    $("#saveInvoice").click(function () {
        if (!validateControls('generateInvoice')) {
            return false;
        }
        var jsonObject = {
            clientId: $("#client").val(),
        }
        calltoAjax(misApiUrl.generateInvoice, "POST", jsonObject,
            function (result) {
                var resultData = $.parseJSON(JSON.stringify(result));
                if (resultData) {
                    if (resultData != null) {
                        if (resultData.InvoiceNumber != null) {
                            var summary = '<ul class="list-group" id="listDetails">' +
                                '<li class="list-group-item text-left">Invoice Number:<span class="pull-right label label-info">' + resultData.InvoiceNumber + '</span></li>' +
                                '<li class="list-group-item text-left">Client: <span class="pull-right">' + resultData.ClientName + '</span></li>' +
                                '<li class="list-group-item text-left">Invoice Date: <span class="pull-right">' + resultData.CreatedOn + '</span></li>' +
                                '</ul>';
                            misAlert("Invoice has been booked succesfully." + "</br>" + summary, "Success", "success");
                            //$("#client").select2("val", "0");
                            //$("#client").removeClass('error-validation');
                            $("#mypopupGenerateInvoice").modal("hide");
                            loadInvoiceReportGrid();
                            checkForRequestEligibility();
                            getUserwiseRequestDetail();
                        }
                        else {
                            misAlert("You don't have permission to book invoice for this client.", "Warning", "warning");
                            //$("#client").select2("val", "0");
                            //$("#client").removeClass('error-validation');
                            $("#mypopupGenerateInvoice").modal("hide");
                            loadInvoiceReportGrid();
                            checkForRequestEligibility();
                            getUserwiseRequestDetail();
                        }
                    }
                    else
                        misAlert("Unable to process request. Try again", "Error", "error");
                    //$("#client").select2("val", "0");
                    //$("#client").removeClass('error-validation');
                    $("#mypopupGenerateInvoice").modal("hide");
                    loadInvoiceReportGrid();
                    checkForRequestEligibility();
                    getUserwiseRequestDetail();
                }
            });
    });
    $("#submitReasonRemark").click(function () {
        if (!validateControls('reasonDiv')) {
            return false;
        }
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
                        case 0:
                            misAlert("Unable to process request. Try again", "Error", "error");
                            $("#reason").val("");
                            $("#mypopupReason").modal("hide");
                            loadInvoiceReportGrid();
                            break;
                    }
                }
            });
    });
});

function checkForRequestEligibility() {
    calltoAjax(misApiUrl.checkForRequestEligibility, "POST", "",
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            switch (resultData) {
                case 3:
                    $("#btnRequestInvoice").hide();
                    $("#btnGenerateInvoice").show();
                    $("#icon").show();
                    $("#info").hide();
                    getUserwiseRequestDetail();
                    break;
                case 2:
                    $("#btnRequestInvoice").hide();
                    $("#btnGenerateInvoice").hide();
                    $("#icon").hide();
                    $("#info").show();
                    $("#info").text("Invoice booking request is pending for approval.");
                    break;
                case 1:
                    $("#btnRequestInvoice").show();
                    $("#btnGenerateInvoice").hide();
                    $("#icon").hide();
                    $("#info").hide();
                    break;
            }
        });
}

function getUserwiseRequestDetail() {
    calltoAjax(misApiUrl.getRequestedInvoiceInfo, "POST", '', function (result) {
        var html = '<table class="tbl-typical info-popover-table text-left">';
        html += '<thead><tr><th><div>Client</div></th><th><div>Requested</div></th><th><div>Available</div></th></tr></thead>';
        if (result) {
            var resultdata = $.parseJSON(JSON.stringify(result));
            if (resultdata && resultdata.length > 0) {
                for (var i = 0; i < resultdata.length; i++) {
                    html += '<tr><td>' + resultdata[i].ClientName + '</td><td>' + resultdata[i].InvoiceCount + '</td><td>' + resultdata[i].NoOfInvoices + '</td></tr>';
                }
                html += '</table>';
                $("#infoIcon").attr("data-content", html)
                $("#anotherInfoIcon").attr("data-content", html)
                //$("#popover-content-login").html(html);
                //$("#infoIcon").data('bs.popover').options.content= html;
            }
        }
    });
}

function showRequestInvoicePopup() {
    $("#mypopupRequestInvoice").modal("show");
    $("#noOfInvoices").removeClass('error-validation');
    $("#noOfInvoices").val("");
    $("#invoiceTotalCount").html(0);
}

function showGenerateInvoicePopup() {
    $("#client").select2("val", [0]);
    $("#mypopupGenerateInvoice").modal("show"); 
    $('#mypopupGenerateInvoice').on('show.bs.modal', function () {
        $(".select2-selection[role='combobox']").removeClass("error-validation");
    }) 
}

function bindClientDropDown() {
    $("#client").select2();
    $("#client").empty();
    $("#client").append($("<option></option>").val(0).html("Select"));
    calltoAjax(misApiUrl.getClients, "POST", '',
        function (result) {
            $.each(result, function (idx, item) {
                $("#client").append($("<option></option>").val(item.Value).html(item.Text));
            });
        });
}

var txtCount = 0;
function generateControls(containerId, maxNoOfTextBoxes, minNoOfMandatoryTxtBoxes) {
    maxNoOfTextBoxes = 10;
    if (containerId) {
        txtCount = $("#" + containerId).find('.itemRow').length;
        var noOfInvoices = $("#invoiceTotalCount").html();
        if (txtCount < maxNoOfTextBoxes && noOfInvoices < 10) {
            $("#" + containerId).append(getDynamicControls(txtCount, minNoOfMandatoryTxtBoxes || 1, ''));
            $("#client" + txtCount).select2();
            $("#client" + txtCount).empty();
            $("#client" + txtCount).append($("<option></option>").val(0).html("Select"));
            calltoAjax(misApiUrl.getClients, "POST", '',
                function (result) {
                    $.each(result, function (idx, item) {
                        $("#client" + txtCount).append($("<option></option>").val(item.Value).html(item.Text));
                    });
                });
            //sum();
        }
        else {
            misAlert("Max " + maxNoOfTextBoxes + " invoices are allowed.!", 'Warning', 'warning');
        }
    }
}

function getDynamicControls(idx, minNoOfMandatoryTxtBoxes, value) {
    return '<div class="col-md-12 itemRow" id = "dynamicAddGoalDiv-' + idx + '">' +
        '<div class="row">' +
        '<div class="col-md-5"><div class="form-group"><label>Client<span class="spnError">*</span></label><div class="input-group"><select class="form-control select2 validation-required" id="client' + idx + '" onchange= "checkIfAlreadyRequestedForClient(' + idx + ')">< option value= "0" selected> Select</option ></select></div></div></div>' +
        '<div class="col-md-5"><div class="form-group"><label>No Of Invoices<span class="spnError">*</span></label><div class="input-group"><input class="form-control validation-required invoiceCount" id="noOfInvoices' + idx + '" type="number" min="1" max="10" onchange="sum(' + idx + ');" onkeyup="sum(' + idx + ');"></div></div></div>' +
        '<div class="col-md-2" style="padding-top: 22px;"><span class="input-group-btn"><button class="btn btn-danger" style="background-color: #d2322d;" value="X" onclick="removeControls(this)">X</button></span></div>' +
        '</div></div>';
}
function checkIfAlreadyRequestedForClient(j) {
    var collection = new Array();
    // var items;
    $('.itemRow').each(function () {
        var id = $(this).closest(".itemRow").attr("id").split('-')[1];
        var clientId = $("#client" + id).val();
        if ($.inArray(clientId, collection) !== -1) {
            misAlert("You have already requested for this client.", 'Sorry', 'warning');
            $("#client" + j).select2("val", "0");
            // //$("#client" + j).select2({
            // //    html: "Select"
            // //});
            //// var newId = "client" + id;
            // var x = document.getElementById('"client" + id');
            // x.remove(x.selectedIndex);
            // //
            // //console.log(newId);
            // //$("#newId > option").removeAttr("selected");
            // //$("#id
        }
        else
            collection.push(clientId);
    });
}
function removeControls(item) {
    $(item).closest('.itemRow').remove();
    sum(1);
}

function sum(i) {
    _invoiceCount = 0;
    var itemrow = $("#dynamicAddRequests .invoiceCount");
    if (itemrow && itemrow.length > 0) {
        for (var k = 0; k < itemrow.length; k++) {
            _invoiceCount += parseInt($("#" + itemrow[k].id).val()) || 0;
        }
    }
    if (_invoiceCount > 10) {
        misAlert("Max 10 invoices are allowed.", 'Warning', 'warning');
        if (itemrow.length > 1)
            parseInt($("#" + itemrow[(itemrow.length - 1)].id).val("1"))
        else
            parseInt($("#" + itemrow[0].id).val("1"))
    }
    else
        $("#invoiceTotalCount").html(_invoiceCount);
}

function getFormData() {
    var collection = new Array();
    var items;
    $('.itemRow').each(function () {
        var id = $(this).closest(".itemRow").attr("id").split('-')[1];
        items = new Object();
        items.ClientId = $("#client" + id).val();
        items.NoOfInvoices = $("#noOfInvoices" + id).val();
        collection.push(items);
    });
    return collection;
}

function bindAllClientDropDown() {
    calltoAjax(misApiUrl.getClients, "POST", '',
        function (result) {
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
        });
}

function loadInvoiceReportGrid() {
    //var clientIds = (($('#clientForReport').val() !== null && typeof $('#clientForReport').val() !== 'undefined' && $('#clientForReport').val().length > 0) ? $('#clientForReport').val().join(',') : '0');
    //var jsonObject = {
    //    clientIds: clientIds
    //}
    calltoAjax(misApiUrl.getInvoice, "POST", "",
        function (result) {
            //console.log(result)
            var resultData = $.parseJSON(JSON.stringify(result));
            var table = $('#tblInvoiceList').DataTable({

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
                        filename: 'Invoice List',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'Invoice List' },
                        { extend: 'pdf', filename: 'Invoice List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                        { extend: 'print', filename: 'Invoice List' },
                        ]
                    }
                ],
                "aaData": resultData,

                "aoColumns": [
                    {
                        "mData": "CreatedBy",
                        "sTitle": "Generated By",
                    },
                    {
                        "mData": "ClientName",
                        "sTitle": "Client",
                    },
                    {
                        "mData": "InvoiceNumber",
                        "sTitle": "Invoice Number",
                    },
                    {
                        "mData": null,
                        "sTitle": "Invoice Date",
                        mRender: function (data, type, row) {
                            return moment(row.CreatedOn).format('DD MMM YYYY');
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Generated On",
                        mRender: function (data, type, row) {
                            return moment(row.CreatedOn).format('DD MMM YYYY hh:mm:ss');
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        mRender: function (data, type, row) {
                            var html = '<div>';
                            if (data.IsCancellable == true) {
                                html += '&nbsp;<button type="button" class="btn btn-sm btn-danger" onclick="openReasonPopup(\'' + row.InvoiceId + '\' , 3)" data-toggle="tooltip" title="Cancel"><i class="fa fa-times"></i></button>';
                                return html;
                            }
                            else
                                return html;
                        }
                    },
                ],
                "fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                    if (aData.IsCancelled == true) {
                        $('td', nRow).css('background-color', '#f3a0a0');
                    }
                }
            });
        });
}

function openReasonPopup(invoiceRequestId, forApproval) {
    _invoiceRequestId = invoiceRequestId;
    _forApproval = forApproval;
    $("#mypopupReason").modal("show");
    $("#reason").removeClass('error-validation');
    $("#reason").val("");
}


