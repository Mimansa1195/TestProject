var rowsData, _leftImageCount = 0, _reimbursementTypeId, _hiddenStatusCode;
var _hiddenReimbursementRequestAbrhs, _action, _reimbursementDetailAbrhs;

$(function () {
    $("#btnBackToReviewReimbursementList").show();
    $("#lblReimbursementReview").html("Reimbursement Form");
    bindReimbursementType();
    _hiddenReimbursementRequestAbrhs = $("#reimbursementDiv > #hiddenReimursementRequestAbrhs").val();
    _hiddenActionCode = $("#reimbursementDiv > #hiddenActionCode").val();

    $("#btnSubmitReimbursementRemark").on("click", function () {
        TakeActionOnReimbursementRequest();
    })

    $("#referBackBtn").on('click', function () {
        if (!validateControls('divReimbursmentAmount')) {
            return false;
        }
        var result = isValidReimbusreAmount();
        if (!result) {
            misAlert("Reimbursement amount can't be greater than total amount or requested amount", "Warning", "warning");
        }
        else {
            _action = "RB";
            $('#approverRemark').val("");
            $("#btnSubmitReimbursementRemark").removeClass("btn-danger");
            $("#btnSubmitReimbursementRemark").removeClass("btn-success");
            $("#btnSubmitReimbursementRemark").addClass("btn-outline-info");
            $("#btnSubmitReimbursementRemark").text("Refer Back");
            $("#reimbursementRemark").modal('show');
        }
    });

    $("#approveBtn").on('click', function () {
        if (!validateControls('divReimbursmentAmount')) {
            return false;
        }
        var result = isValidReimbusreAmount();
        if (!result) {
            misAlert("Reimbursement amount can't be greater than total amount or requested amount", "Warning", "warning");
        }
        else {
            $('#approverRemark').val("");
            _action = "AP";
            $("#btnSubmitReimbursementRemark").removeClass("btn-danger");
            $("#btnSubmitReimbursementRemark").removeClass("btn-outline-info");
            $("#btnSubmitReimbursementRemark").addClass("btn-success");
            $("#btnSubmitReimbursementRemark").text("Approve");
            $("#reimbursementRemark").modal('show');
        }
    });
    $("#txtReimburseAmount").on('keydown', function () {
        isNumberKey(event, this);
    });
    $("#txtReimburseAmount").on('keyup', function () {
        isNumberKey(event, this);
    });

});

function getReimbursementFormData() {
    $("#tblBody").empty();
    var jsonObject = {
        reimbursementRequestAbrhs: _hiddenReimbursementRequestAbrhs
    };
    calltoAjax(misApiUrl.getReimbursementFormData, "POST", jsonObject,
        function (result) {
            _reimbursementTypeId = result.TypeId;
            $("#txtReimbType").val(result.TypeId);
            $("#txtMonthYear").val(result.MonthYear);
            $("#txtRequestedAmount").val(result.RequestedAmount);
            $("#txtReimburseAmount").val(result.ApprovedAmount);
            var validSum = 0.00;
            var invalidSum = 0.00;
            data = result.DocumentList;
            var count = 0;
            var validCount = 0;
            for (var i = 0; i < data.length; i++) {
                var amount = Math.round(data[i].Amount);
                rowsData = "";
                if (_hiddenActionCode == "TakeAction") {
                    $("#txtReimburseAmount").attr("disabled", false);
                    if (data[i].IsActive && data[i].IsDocumentValid) {
                        validCount++;
                        validSum = validSum + parseFloat(data[i].Amount);
                        rowsData += '<div class="tile"><div class="tile-section"><div class="tile-header"><span class="bill-no">Bill No. <span>' + data[i].BillNo + '</span></span><span class="bill-amount"><i class="fa fa-inr"></i> ' + amount + '</span></div><input type="hidden" id="isActive' + i + '" value="1"/><input type="hidden" value=' + data[i].ReimbursementDetailAbrhs + ' id="reimbursementDetailAbrhs' + i + '"><input type="file" class="form-control fileinput"   name="file"> <p class="bill-date"><span>' + data[i].DateName + '</span></p> <p><span class="bill-details" title="' + data[i].CategoryName + '">' + data[i].CategoryName + '</span></p><input type="button" value="Mark Invalid" class="btn btn-danger" onclick="openRemarksPopUp(\'' + data[i].ReimbursementDetailAbrhs + '\',\'' + "INVALID" + '\');" id="markInvalidRow' + i + '"/></div></div>';
                    }
                    else if (data[i].IsActive && !data[i].IsDocumentValid) {
                        invalidSum = invalidSum + parseFloat(data[i].Amount);
                        rowsData += '<div class="tile invalid-tile"><div class="tile-section"><div class="invalid-strip"></div><div class="tile-header"><span class="bill-no">Bill No. <span>' + data[i].BillNo + '</span></span><span class="bill-amount"><i class="fa fa-inr"></i> ' + amount + '</span></div><input type="hidden" id="isActive' + i + '" value="1"/><input type="hidden" value=' + data[i].ReimbursementDetailAbrhs + ' id="reimbursementDetailAbrhs' + i + '"><input type="file" class="form-control fileinput"   name="file"> <p class="bill-date"><span>' + data[i].DateName + '</span></p> <p><span class="bill-details" title="' + data[i].CategoryName + '">' + data[i].CategoryName + '</span></p><input type="button" disabled value="Invalid" class="btn btn-danger " /></div></div>';
                    }
                }
                else if (_hiddenActionCode == "View") {
                    $("#txtReimburseAmount").attr("disabled", true);
                    if (data[i].IsActive && !data[i].IsDocumentValid) {
                        invalidSum = validSum + parseFloat(data[i].Amount);
                        rowsData += '<div class="tile invalid-tile"><div class="tile-section"><div class="invalid-strip"></div><div class="tile-header"><span class="bill-no">Bill No. <span>' + data[i].BillNo + '</span></span><span class="bill-amount"><i class="fa fa-inr"></i> ' + amount + '</span></div><input type="hidden" id="isActive' + i + '" value="1"/><input type="hidden" value=' + data[i].ReimbursementDetailAbrhs + ' id="reimbursementDetailAbrhs' + i + '"><input type="file" class="form-control fileinput"   name="file"> <p class="bill-date"><span>' + data[i].DateName + '</span></p> <p><span class="bill-details" title="' + data[i].CategoryName + '">' + data[i].CategoryName + '</span></p><span><a href="javascript: void(0)" data-toggle="popover" title="Remark" style="text-decoration: underline;color:red" data-placement="top" data-trigger="hover" data-content="' + data[i].Remarks + '">Invalid</a></span></div></div>';
                    }
                    else if (data[i].IsActive && data[i].IsDocumentValid) {
                        validSum = validSum + parseFloat(data[i].Amount);
                        rowsData += '<div class="tile"><div class="tile-section"><div class="tile-header"><span class="bill-no">Bill No. <span>' + data[i].BillNo + '</span></span><span class="bill-amount"><i class="fa fa-inr"></i> ' + amount + '</span></div><input type="hidden" id="isActive' + i + '" value="1"/><input type="hidden" value=' + data[i].ReimbursementDetailAbrhs + ' id="reimbursementDetailAbrhs' + i + '"><input type="file" class="form-control fileinput"   name="file"> <p class="bill-date"><span>' + data[i].DateName + '</span></p> <p><span class="bill-details" title="' + data[i].CategoryName + '">' + data[i].CategoryName + '</span></p><span><a href="javascript: void(0)" data-toggle="popover" title="Remark" style="text-decoration: underline;color:green" data-placement="top" data-trigger="hover" data-content="' + data[i].Remarks + '">Active</a></span></div></div>';
                    }

                }
                $(".rows").append(rowsData);
                $(".select2").select2();
                $('[data-toggle="popover"]').popover();
                $(".fileinput").fileinput({
                    dropZoneEnabled: false,
                    initialPreviewAsData: true,
                    initialPreviewFileType: 'image',
                    initialCaption: data[i].ImageName,
                    initialPreviewConfig: [
                        { caption: data[i].ImageName },
                    ],
                    showRemove: false,
                    showDownload: true,
                    initialPreviewDownloadUrl: true,
                    showDrag: false,
                    initialPreview: [data[i].ImagePath]
                });
            }
            if (validCount > 0) {
                $("#divBtn").show();
            }
            else {
                $("#divBtn").hide();
            }
            var validHtml = '<i class="fa fa-inr"></i> ' + validSum.toFixed(2) ;
            var invalidHtml = '<i class="fa fa-inr"></i> ' + invalidSum.toFixed(2);
            $("#validAmount").html(validHtml);
            $("#invalidAmount").html(invalidHtml);
            _leftImageCount = validCount;
            $(".form-control.datepicker").datepicker({
                autoclose: true,
                singleDatePicker: true,
                showDropdowns: true,
                todayHighlight: true
            }).datepicker('setEndDate', new Date());
        });
}

function remarksBox() {
    $('#approverRemark').val("");
    $("#btnSubmitReimbursementRemark").removeClass("btn-outline-info");
    $("#btnSubmitReimbursementRemark").removeClass("btn-success");
    $("#btnSubmitReimbursementRemark").addClass("btn-danger");
    $("#btnSubmitReimbursementRemark").text("Mark Invalid");
    $("#reimbursementRemark").modal('show');
}

function isNumberKey(evt, e) {
    var term = e.value;
    var re = new RegExp("^[0-9]*$");
    if (re.test(term)) {
        return true;
    } else {
        e.value = term.substring(0, term.length - 1);
    }
}

function isValidReimbusreAmount() {
    var totalAmt = parseFloat($("#validAmount").html().replace('<i class="fa fa-inr"></i>', '').trim());
    var requestedAmt = parseFloat($("#txtRequestedAmount").val());
    var reimbusrementAmt = parseFloat($("#txtReimburseAmount").val());
        if (reimbusrementAmt > totalAmt || reimbusrementAmt > requestedAmt) {
        return false;
    }
    else
        return true;
}

function openRemarksPopUp(reimbursementDetailAbrhs, action) {
    if (!validateControls('divReimbursmentAmount')) {
        return false;
    }
    var result = isValidReimbusreAmount();
    if (!result) {
        misAlert("Reimbursement amount can't be greater than total amount and requested amount", "Warning", "warning");
    }

    $('#approverRemark').val("");
    if (action === "INVALID") {
        if (_leftImageCount == 1) {
            misConfirm("Are you sure you want to mark this document invalid? After this request will be rejected.", "Confirm", function (isConfirmed) {
                if (isConfirmed) {
                    remarksBox();
                }
            }, false, false, true);
        }
        else
            remarksBox();
    }
    else {
        remarksBox();
    }
    _reimbursementDetailAbrhs = reimbursementDetailAbrhs;
    _action = action;
}

function TakeActionOnReimbursementRequest() {

    var remarks = $('#approverRemark').val().trim();
    if (remarks === "") {
        misAlert("Please fill remarks", "Warning", "warning");
        return false;
    }
    var jsonObject = {
        ReimbursementRequestAbrhs: _hiddenReimbursementRequestAbrhs,
        ReimbursementDetailAbrhs: _reimbursementDetailAbrhs,
        ApprovedAmount: parseFloat($("#txtReimburseAmount").val()).toFixed(2),
        ActionType: _action,
        Remarks: remarks,
        ReimbursementTypeId: _reimbursementTypeId
    };
    calltoAjax(misApiUrl.takeActionOnReimbursementRequest, "POST", jsonObject,
        function (result) {
            $("#reimbursementRemark").modal('hide');
            if (result === 1) {
                if (_action !== "INVALID") {
                    loadUrlToId(misAppUrl.reviewReimbursementList, 'partialReimbursementReviewContainer');
                }
                if (_action == "AP") {
                    misAlert("Reimbursement request has been approved successfully.", "Success", "success");
                }
                else if (_action == "VD") {
                    misAlert("Reimbursement request has been verified successfully.", "Success", "success");
                }
                else if (_action == "RB") {
                    misAlert("Reimbursement request has been referred back.", "Success", "success");
                }
                else if (_action == "INVALID") {
                    misAlert("Reimbursement receipt has been marked as invalid.", "Success", "success");
                    getReimbursementFormData()
                }
                else {
                    misAlert("Unable to process request. Invalid action.", "Error", "error");
                }
            }
            else {
                misAlert("Unable to process request. Please try again.", "Error", "error");
            }
            $('body').removeClass('modal-open');
            $('.modal-backdrop').remove();
        });
}

function bindReimbursementType() {
    calltoAjax(misApiUrl.getReimbursementType, "POST", "",
        function (result) {
            $("#txtReimbType").empty();
            $("#txtReimbType").append("<option value='0'>Select</option>")
            if (result !== null) {
                $.each(result, function (index, result) {
                    $("#txtReimbType").append("<option value=" + result.TypeId + ">" + result.TypeName + "</option>")
                });
            }
            bindMonthYear();
        });
}

function bindMonthYear() {
    calltoAjax(misApiUrl.getReimbursementMonthYearToViewAndApprove, "POST", "", function (result) {
        $("#txtMonthYear").empty();
        $("#txtMonthYear").append("<option value='0'>Select</option>")
        if (result !== null) {
            $.each(result.MonthYearText, function (idx, item) {
                $("#txtMonthYear").append($("<option></option>").val(item.MonthYear).html(item.MonthYear));
            });
        }
        getReimbursementFormData();
    });
}

