$(document).ready(function () {
    loadAccessCardGrid();
});

function loadAccessCardGrid() {
    calltoAjax(misApiUrl.getAllAccessCards, "POST", '',
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#tblAllAccessCard").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                 {
                     filename: 'Access Cards',
                     extend: 'collection',
                     text: 'Export',
                     buttons: [{ extend: 'copy' },
                                { extend: 'excel', filename: 'Access Cards' },
                                { extend: 'pdf', filename: 'Access Cards' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                                { extend: 'print', filename: 'Access Cards' },
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
                        "mData": "AccessCardNo",
                        "sTitle": "Card Number",
                    },
                    {
                        "mData": null,
                        "sTitle": "Access For",
                        'bSortable': false,
                        "sClass": "text-center",
                        mRender: function (data, type, row) {
                            var html = '<div>';
                            if(row.IsPimcoCard)
                                html += 'Pimco';
                            else
                                html += 'Non-Pimco'
                            html += '</div>'
                            return html;
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Card Type",
                        'bSortable': false,
                        "sClass": "text-center",
                        mRender: function (data, type, row) {
                            var html = '<div>';
                            if (row.IsTemporaryCard)
                                html += 'Temporary';
                            else
                                html += 'Permanent'
                            html += '</div>'
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
                        'bSortable': false,
                        "sClass": "text-center",
                        mRender: function (data, type, row) {
                            var html = '<div>';
                            if (row.IsMapped)
                                html += 'Assigned to '+row.EmployeeName;
                            else {
                                if (row.IsActive)
                                    html += '<button type="button" data-toggle="tooltip" class="btn btn-sm btn-warning"' + 'onclick="changeAccessCardState(' + row.AccessCardId + ",2" + ')" title="Deactivate"><i class="fa fa-times" aria-hidden="true"></i></button>&nbsp';
                                else
                                    html += '<button type="button" data-toggle="tooltip" class="btn btn-sm btn-success"' + 'onclick="changeAccessCardState(' + row.AccessCardId + ",1" + ')" title="Activate"><i class="fa fa-check" aria-hidden="true"></i></button>&nbsp';
                                html += '<button type="button" data-toggle="tooltip" class="btn btn-sm btn-danger"' + 'onclick="changeAccessCardState(' + row.AccessCardId + ",3" + ')" title="Delete"><i class="fa fa-trash" aria-hidden="true"></i></button>';
                            }
                            html += '</div>'
                            return html;
                        }
                    },
                ]
            });
        });
}

function changeAccessCardState(accessCardId, state) { //state = 1: activate, 2: deactivate, 3: delete
    var jsonObject = {
        accessCardId: accessCardId,
        state: state,
        userAbrhs: misSession.userabrhs
    };

    switch (state) {
        case 1:
            var reply = misConfirm("Are you sure you want to activate access card", "Confirm", function (reply) {
                if (reply) {
                    calltoAjax(misApiUrl.changeAccessCardState, "POST", jsonObject,
                        function (result) {
                            var resultData = $.parseJSON(JSON.stringify(result));
                            switch (resultData) {
                                case 1:
                                    misAlert("Request processed successfully", "Success", "success");
                                    loadAccessCardGrid();
                                    break;
                                case 2:
                                    misAlert("Card has user mapped to it. Please check.", "Warning", "warning");
                                    break
                                case 0:
                                    misAlert("Unable to process request. Try again", "Error", "error");
                                    break;
                            }
                        });
                }
            });
            break;
        case 2:
             reply = misConfirm("Are you sure you want to deactivate access card", "Confirm", function (reply) {
                if (reply) {
                    calltoAjax(misApiUrl.changeAccessCardState, "POST", jsonObject,
                        function (result) {
                            var resultData = $.parseJSON(JSON.stringify(result));
                            switch (resultData) {
                                case 1:
                                    misAlert("Request processed successfully", "Success", "success");
                                    loadAccessCardGrid();
                                    break;
                                case 2:
                                    misAlert("Card has user mapped to it. Please check.", "Warning", "warning");
                                    break
                                case 0:
                                    misAlert("Unable to process request. Try again", "Error", "error");
                                    break;
                            }
                        });
                }
            });
            break;
        case 3:
            reply = misConfirm("Are you sure you want to delete access card", "Confirm", function (reply) {
                if (reply) {
                    calltoAjax(misApiUrl.changeAccessCardState, "POST", jsonObject,
                        function (result) {
                            var resultData = $.parseJSON(JSON.stringify(result));
                            switch (resultData) {
                                case 1:
                                    misAlert("Request processed successfully", "Success", "success");
                                    loadAccessCardGrid();
                                    break;
                                case 2:
                                    misAlert("Card has user mapped to it. Please check.", "Warning", "warning");
                                    break
                                case 0:
                                    misAlert("Unable to process request. Try again", "Error", "error");
                                    break;
                            }
                        });
                }
            });
            break;
    }
}

function changeCardPreference() {
    if ($('input:checkbox[id=isPimcoCard]').is(':checked') === false)
        $("#isPimcoCard").attr("checked", false);
    else
        $("#isPimcoCard").attr("checked", true);

    if ($('input:checkbox[id=isTempCard]').is(':checked') === false)
        $("#isTempCard").attr("checked", false);
    else
        $("#isTempCard").attr("checked", true);
}

function addNewAccessCard() {
    $("#modal-addAccessCard").modal('show');
    $("#cardNo").val("");
    $("#isTempCard").attr("checked", false);
    $("#isPimcoCard").attr("checked", false);    
}

function finalAddAccessCard() {
    if (!validateControls('modal-addAccessCard')) {
        return false;
    }
    if (/^0*$/.test($("#cardNo").val())) {
        misAlert("Invalid card number !", "Warning", "warning");
        return false;
    }

    var isTempCard = false;
    var isPimcoCard = false;

    if ($("#isPimcoCard").is(':checked'))
        isPimcoCard = true;
    if ($("#isTempCard").is(':checked'))
        isTempCard = true;

    var jsonObject = {
        cardNo: $("#cardNo").val(),
        isPimcoCard: isPimcoCard,
        isTemporaryCard: isTempCard,
        userAbrhs: misSession.userabrhs
    };

    calltoAjax(misApiUrl.addAccessCard, "POST", jsonObject,
    function (result) {
        var resultData = $.parseJSON(JSON.stringify(result));
        switch (resultData) {
            case 1:
                misAlert("Request processed successfully", "Success", "success");
                $("#modal-addAccessCard").modal('hide');
                loadAccessCardGrid();
                break;
            case 2:
                misAlert("Card with same number already exists. Please check.", "Warning", "warning");
                break
            case 0:
                misAlert("Unable to process request. Try again", "Error", "error");
                break;
        }
    });
}

$("#btnClose").click(function () {
    $("#modal-addAccessCard").modal('hide');
});

