var rowsData;
$(function () {
    $("#btnBackToReimbursementList").show();
    $("#btnRequestReimbursement").hide();
    $("#lblReimbursementRequest").html("Reimbursement Form");
    bindReimbursementType();
})

function getReimbursementFormData() {
    var jsonObject = {
        reimbursementRequestAbrhs: $("#reimbursementDiv > #hiddenReimursementRequestAbrhs").val()
    }
    calltoAjax(misApiUrl.getReimbursementFormData, "POST", jsonObject,
        function (result) {
            $("#txtReimbType").val(result.TypeId);
            $("#txtMonthYear").val(result.MonthYear);
            $("#txtReimbursementAmount").val(parseFloat(result.RequestedAmount).toFixed(2));
            var sum = 0.00;
            data = result.DocumentList;
            var count = 0;
            for (var i = 0; i < data.length; i++) {
                bindReimbursementCategory(result.TypeId, i, data[i].CategoryId);
                var amount = Math.round(data[i].Amount);
                rowsData = "";
                if (data[i].IsActive && !data[i].IsDocumentValid) {
                    rowsData += '<tr > <td data-attr-title="Image" class="image text-center"><input type="hidden"  value="1"/><input type="hidden" value=' + data[i].ReimbursementDetailId + ' ><img width="40" height="40"  src=" ' + data[i].ImagePath + '"/><br/>' + data[i].ImageName + '</td> <td data-attr-title="Category Type"><select class="form-control select-validate" disabled id="txtReimbCategory' + i + '"></select></td> <td  data-attr-title="Bill No"> <input disabled value=' + data[i].BillNo + '  type="text"  class="form-control " placeholder="Bill No."/></td> <td data-attr-title="Date"><input disabled value=' + data[i].Date + ' type="text"  class="form-control datepicker " readonly /></td><td data-attr-title="Amount"><input disabled value=' + amount + ' type="text" id="txtAmountEdit' + i + '" class="txtAmount text-right form-control " /></td><td class="status" data-attr-title="Status"><a href="javascript: void(0)" data-toggle="popover" title="Remarks" style="text-decoration: underline;color:red" data-trigger="hover" data-content="' + data[i].Remarks + '">Invalid</a></td> </tr>';
                }
                else if (data[i].IsActive && data[i].IsDocumentValid) {
                    sum = sum + parseFloat(data[i].Amount);
                    rowsData += '<tr > <td data-attr-title="Image" class="image text-center"><input type="hidden"  value="1"/><input type="hidden" value=' + data[i].ReimbursementDetailId + '><img width="40" height="40"  src=" ' + data[i].ImagePath + '"/><br/>' + data[i].ImageName + '</td> <td data-attr-title="Category Type"><select class="form-control select-validate" disabled id="txtReimbCategory' + i + '"></select></td> <td  data-attr-title="Bill No"> <input disabled value=' + data[i].BillNo + ' type="text"  class="form-control " placeholder="Bill No."/></td> <td data-attr-title="Date"><input disabled value=' + data[i].Date + ' type="text"  class="form-control datepicker " readonly /></td><td data-attr-title="Amount"><input disabled value=' + amount + ' type="text" id="txtAmountEdit' + i + '" class="txtAmount form-control text-right " /></td><td class="status" data-attr-title="Status"><a href="javascript: void(0)" data-toggle="popover" title="Remarks" style = "text-decoration: underline; color:green" data-trigger="hover" data-content="' + data[i].Remarks + '">Active</a></td> </tr>';
                }
                else {
                    rowsData += '<tr > <td data-attr-title="Image" class="image text-center"><input type="hidden"  value="0"/><input type="hidden" value=' + data[i].ReimbursementDetailId + ' ><img width="40" height="40" src=" ' + data[i].ImagePath + '"/><br/>' + data[i].ImageName + '</td> <td data-attr-title="Category Type"><select class="form-control select-validate" disabled id="txtReimbCategory' + i + '"></select></td> <td  data-attr-title="Bill No"> <input disabled  value=' + data[i].BillNo + '  type="text"  class="form-control " placeholder="Bill No."/></td> <td data-attr-title="Date"><input disabled  value=' + data[i].Date + ' type="text" i class="form-control datepicker " readonly /></td><td data-attr-title="Amount"><input disabled  value=' + amount + ' type="text" id="txtAmountEdit' + i + '"  class="txtAmount text-right form-control " /></td><td class="status" data-attr-title="Status"><a href="javascript: void(0)" data-toggle="popover" title="Remarks" style = "text-decoration: underline; color:red" data-trigger="hover" data-content="' + data[i].Remarks + '">Deleted</a></td> </tr>';
                }
                $(".rows").append(rowsData);
                $(".select2").select2();
                if ($(document).width() < 768) {
                    var options = {
                        placement: function (context, source) {
                            var position = $(source).position();

                            if (position.left > 500) {
                                return "left";
                            }

                            if (position.left < 500) {
                                return "top";
                            }
                        }
                        , trigger: "click"
                    };
                    $('[data-toggle="popover"]').popover(options);
                }
                else {
                    var options = {
                        placement: function (context, source) {
                            var position = $(source).position();

                            if (position.left > 500) {
                                return "left";
                            }

                            if (position.left < 500) {
                                return "top";
                            }
                        }
                        , trigger: "hover"
                    };
                    $('[data-toggle="popover"]').popover(options);
                }

            }
            if (count > 0) {
                $("#divBtn").show();
            }
            sum = sum.toFixed(2);
            var htmlSum = '<i class="fa fa-inr"></i> ' + sum;
            $("#txtTotalAmount").html(htmlSum);
            $(".form-control.datepicker").datepicker({
                autoclose: true,
                singleDatePicker: true,
                showDropdowns: true,
                todayHighlight: true
            }).datepicker('setEndDate', new Date());

        });
}

function bindReimbursementType() {
    $("#txtReimbType").empty();
    $("#txtReimbType").append("<option value='0'>Select</option>")
    calltoAjax(misApiUrl.getReimbursementType, "POST", "",
        function (result) {
            if (result !== null) {
                $.each(result, function (index, result) {
                    $("#txtReimbType").append("<option value=" + result.TypeId + ">" + result.TypeName + "</option>")
                });
            }
            bindMonthYear();
        });
}

function bindMonthYear() {
    $("#txtMonthYear").empty();
    $("#txtMonthYear").append("<option value='0'>Select</option>")
    calltoAjax(misApiUrl.getReimbursementMonthYearToViewAndApprove, "POST", "", function (result) {
        if (result !== null) {
            $.each(result.MonthYearText, function (idx, item) {
                $("#txtMonthYear").append($("<option></option>").val(item.MonthYear).html(item.MonthYear));
            });
        }
        getReimbursementFormData();
    });
}

function bindReimbursementCategory(typeId, i, selectedId) {
    $("#txtReimbCategory" + i).empty();
    $("#txtReimbCategory" + i).append("<option value='0'>Select</option>")
    jsonObject = {
        typeId: typeId
    }
    calltoAjax(misApiUrl.getReimbursementCategory, "POST", jsonObject,
        function (result) {
            if (result !== null) {
                $.each(result, function (index, result) {
                    $("#txtReimbCategory" + i).append("<option value=" + result.TypeId + ">" + result.TypeName + "</option>")
                });
                $("#txtReimbCategory" + i).val(selectedId);
            }
        });
}

