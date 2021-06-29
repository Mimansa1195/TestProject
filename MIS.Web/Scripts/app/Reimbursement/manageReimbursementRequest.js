var rowsData, rowCounter = 0;

$(function () {
    $("#lblReimbursementRequest").html("Reimbursement Form");
    $("#btnRequestReimbursement").hide();
    $("#btnBackToReimbursementList").show();
    var sumVal = (0).toFixed(2);
    var htmlSum = '<i class="fa fa-inr"></i> ' + sumVal;
    $("#txtTotalAmount").html(htmlSum);
    var hiddenReimursementRequestAbrhs = $("#reimbursementDiv > #hiddenReimursementRequestAbrhs").val();
    var hiddenAction = $("#reimbursementDiv >#hiddenAction").val();
    bindReimbursementType();
    if (hiddenAction === "Add") {
        $("#tblDiv").hide();
        $("#tblFootr").hide();
        $("#txtReimbType").removeAttr("disabled");
        $("#txtMonthYear").removeAttr("disabled");
        bindMonthYearToAdd(0);
        $("#txtMonthYear").val(0);
    }
    else if (hiddenAction === "Edit") {
        $("#tblDiv").show();
        $("#txtReimbType").attr('disabled', 'disabled');
        $("#txtMonthYear").attr('disabled', 'disabled');
        loadReimburesementForm();
    }
    $("#browseBtn").click(function () {
        if (!validateControls("reimbusrementTypeAndMonthYear")) {
            return false;
        }
    });
    $("#file").on("change", function () {
        $("#tblDiv").show();
        $("#tblFootr").show();
        $("#txtReimbursementAmount").val("");
        //$(".file-details").show();
        $("#divBtn").show();

        var fi = document.getElementById('file');
        if (fi.files.length > 0) {
            // RUN A LOOP TO CHECK EACH SELECTED FILE.
            for (var i = 0; i <= fi.files.length - 1; i++) {
                var files = document.getElementById('file').files;
                var fname = fi.files.item(i).name;      // THE NAME OF THE FILE.
                var fsize = fi.files.item(i).size;      // THE SIZE OF THE FILE.
                // Call the function for conversion of image to base64
                rowCounter++;
                convertToBase64(files[i], fname, rowCounter);
            }
        }
        $(this).val("");
    });

    $("#txtReimbType").on('change', function () {
        $("#tblBody").empty();

        $("#tblDiv").hide();
        $("#divBtn").hide();
        bindMonthYearToAdd($("#txtReimbType").val());
        //  bindReimbursementCategory();
    });

    $(".select2").select2();

    $("#submitBtn").click(function () {
        var len = 0;
        $(".edit-file-details tbody .tblRows").each(function () {
            var isActive = $(this).find("td:nth-child(1)").find("input[id*='isActive']").val();
            if (isActive == 1) {
                len++;
            }
        });
        if (len == 0) {
            misAlert("No documents selected. Please select at least one document", "Warning", "warning");
            return false;
        }
        if (!validateControls("reimbursementDiv")) {
            return false;
        }
        var totalAmt = parseFloat($("#txtTotalAmount").html().replace('<i class="fa fa-inr"></i>', '').trim());
        var reimbusrementAmt = parseFloat($("#txtReimbursementAmount").val());
        if (reimbusrementAmt > totalAmt) {
            misAlert("Reimbursement amount can't be greater than total amount", "Warning", "warning");
            return false;
        }
        submitReimbursementRequest();
    });

    $("#draftBtn").click(function () {
        var len = 0;
        $(".edit-file-details tbody .tblRows").each(function () {
            //$(this).find('td').each(function (key, val) {
            var isActive = $(this).find("td:nth-child(1)").find("input[id*='isActive']").val();
            if (isActive == 1) {
                len++;
            }
        });

        if (len == 0) {
            misAlert("No documents selected. Please select at least one document", "Warning", "warning");
            return false;
        }
        if (!validateControls("reimbursementDiv")) {
            return false;
        }
        var totalAmt = parseFloat($("#txtTotalAmount").html().replace('<i class="fa fa-inr"></i>', '').trim());
        var reimbusrementAmt = parseFloat($("#txtReimbursementAmount").val());
        if (reimbusrementAmt > totalAmt) {
            misAlert("Reimbursement amount can't be greater than total amount", "Warning", "warning");
            return false;
        }

        draftReimbursementFormDetail();
    });

    $("#txtReimbursementAmount").on('keyup', function () {
        isNumberKey(event, this);
    });

    $("#txtReimbursementAmount").on('keydown', function () {
        isNumberKey(event, this);
    });
});

function loadReimburesementForm() {
    $("#tblBody").empty();
    var reimburesementReqAbrhs = $("#reimbursementDiv > #hiddenReimursementRequestAbrhs").val() || '';
    var jsonObject = {
        reimbursementRequestAbrhs: reimburesementReqAbrhs
    }
    calltoAjax(misApiUrl.getReimbursementFormData, "POST", jsonObject,
        function (result) {
            $("#txtReimbType").val(result.TypeId);
            bindMonthYearToEdit(result.MonthYear);
            var sum = 0.00;
            $("#txtReimbType").attr('disabled', 'disabled');
            $("#txtMonthYear").attr('disabled', 'disabled');
            $("#txtReimbursementAmount").val(parseFloat(result.RequestedAmount).toFixed(2));
            data = result.DocumentList;
            var count = 0;
            for (var i = 0; i < data.length; i++) {
                bindReimbursementCategory(result.TypeId, i, data[i].CategoryId);

                //bindReimbursementCategoryEdit(result.TypeId, i, data[i].CategoryId);
                var amount = Math.round(data[i].Amount);
                rowsData = "";
                if (data[i].IsActive && data[i].IsDocumentValid) {
                    count++;
                    rowsData += '<tr data-attr-row-counter ="' + i + '" class="tblRows"> <td data-attr-title="Image" class="image text-center"><input type="hidden" id="isActive' + i + '" value="1"/><input type="hidden" value=' + data[i].ReimbursementDetailId + ' id="reimbursementDetailId' + i + '"><input type="hidden" value="' + data[i].ImageName + '" id="txtUploadedImageName' + i + '"><img width="40" height="40" id="image' + i + '" src=" ' + data[i].ImagePath + '"/><br/>' + data[i].ImageName + '</td> <td data-attr-title="Category"><select id="txtReimbCategory' + i + '"  class="form-control  select-validate validation-required"></select></td> <td  data-attr-title="Bill No"> <input value=' + data[i].BillNo + ' id="txtBillNo' + i + '" type="text"  class="form-control validation-required" placeholder="Bill No."/></td> <td data-attr-title="Date"><input  value=' + data[i].Date + ' type="text" id="txtDate' + i + '" class="form-control datepicker validation-required" readonly placeholder="Date"/></td><td data-attr-title="Amount"><input value=' + amount + ' type="text" id="txtAmount' + i + '" onkeydown="isNumberKey(event,this)" onkeyup="isNumberKey(event,this)" oncopy="return false" onpaste="return false" oncut="return false" class="txtAmount form-control validation-required text-right" placeholder="Amount"/></td><td><input type="button" value="Delete" class="btn btn-danger" onclick="deleteRow(this)" id="deleteRow' + i + '"/></td> </tr>';
                    sum = sum + parseFloat(data[i].Amount);
                }
                else if (data[i].IsActive && !data[i].IsDocumentValid) {
                    rowsData += '<tr data-attr-row-counter ="' + i + '" class="tblRows"> <td data-attr-title="Image" class="image text-center"><input type="hidden" id="isActive' + i + '" value="0"/><input type="hidden" value=' + data[i].ReimbursementDetailId + ' id="reimbursementDetailId' + i + '"><input type="hidden" value="' + data[i].ImageName + '" id="txtUploadedImageName' + i + '"><img width="40" height="40" id="image' + i + '" src=" ' + data[i].ImagePath + '"/><br/>' + data[i].ImageName + '</td> <td data-attr-title="Category"><select disabled  id="txtReimbCategory' + i + '"  class="form-control  select-validate validation-required"></select></td> <td data-attr-title="Bill No"> <input disabled value=' + data[i].BillNo + ' id="txtBillNo' + i + '" type="text"  class="form-control validation-required" placeholder="Bill No."/></td> <td data-attr-title="Date"><input disabled value=' + data[i].Date + ' type="text" id="txtDate' + i + '" class="form-control datepicker validation-required" readonly placeholder="Date"/></td><td data-attr-title="Amount"><input disabled value=' + amount + ' type="text" id="txtAmount' + i + '" onkeydown="isNumberKey(event,this)" onkeyup="isNumberKey(event,this)" oncopy="return false" onpaste="return false" oncut="return false" class="txtAmount form-control validation-required text-right" placeholder="Amount"/></td><td class="status" data-attr-title="Status"><a href="javascript: void(0)" data-toggle="popover" title="Remarks" style="text-decoration: underline;color:red"  data-trigger="hover" data-content="' + data[i].Remarks + '">Invalid</a></td></tr>';
                }
                else if (!data[i].IsActive) {
                    rowsData += '<tr data-attr-row-counter ="' + i + '" class="tblRows"> <td data-attr-title="Image" class="image text-center"><input type="hidden" id="isActive' + i + '" value="0"/><input type="hidden" value=' + data[i].ReimbursementDetailId + ' id="reimbursementDetailId' + i + '"><input type="hidden" value="' + data[i].ImageName + '" id="txtUploadedImageName' + i + '"><img width="40" height="40" id="image' + i + '" src=" ' + data[i].ImagePath + '"/><br/>' + data[i].ImageName + '</td> <td data-attr-title="Category"><select disabled  id="txtReimbCategory' + i + '"  class="form-control select-validate validation-required"></select></td> <td data-attr-title="Bill No"> <input disabled value=' + data[i].BillNo + ' id="txtBillNo' + i + '" type="text"  class="form-control validation-required" placeholder="Bill No."/></td> <td data-attr-title="Date"><input disabled value=' + data[i].Date + ' type="text" id="txtDate' + i + '" class="form-control datepicker validation-required" readonly placeholder="Date"/></td><td data-attr-title="Amount"><input disabled value=' + amount + ' type="text" id="txtAmount' + i + '" onkeydown="isNumberKey(event,this)" onkeyup="isNumberKey(event,this)" oncopy="return false" onpaste="return false" oncut="return false" class="txtAmount form-control validation-required text-right" placeholder="Amount"/></td><td class="status" data-attr-title="Status"><a href="javascript: void(0)" data-toggle="popover" title="Remarks" style = "text-decoration: underline; color:red"  data-trigger="hover" data-content="' + data[i].Remarks + '">Deleted</a></td></tr>';
                }
                $(".rows").append(rowsData);
                $(".select2").select2();
                rowCounter = $(" tbody tr:last-child").attr("data-attr-row-counter");

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

function convertToBase64(file, fname, cntr) {
    var ext = getFileExtension(fname);
    if (ext.toLowerCase() == "jpg" || ext.toLowerCase() == "png" || ext.toLowerCase() == "jpeg") {
        var reader = new FileReader();
        reader.readAsDataURL(file);
        reader.onload = function () {
            rowsData = "";
            rowsData += '<tr class="tblRows"> <td data-attr-title="Image" class="image text-center"><input type="hidden" id="isActive' + cntr + '" value="1"/><input type="hidden" value="0" id="reimbursementDetailId' + cntr + '"><input type="hidden" value="' + fname + '" id="txtUploadedImageName' + cntr + '"><img width="40" height="40" id="image' + cntr + '" src=" ' + reader.result + '"/><br/>' + fname + '</td> <td data-attr-title="Category Type"><select id="txtReimbCategory' + cntr + '"  class="form-control select-validate validation-required"><option value="0">Select</option></select></td> <td data-attr-title="Bill No"> <input id="txtBillNo' + cntr + '" type="text"  class="form-control validation-required" placeholder="Bill No."/></td> <td data-attr-title="Date"><input  type="text" id="txtDate' + cntr + '" class="form-control datepicker validation-required" readonly placeholder="Date"/></td><td data-attr-title="Amount"><input value="" oncopy="return false" onpaste="return false" oncut="return false" type="text" id="txtAmount' + cntr + '" onkeydown="isNumberKey(event,this)" onkeyup="isNumberKey(event,this)" class="txtAmount form-control validation-required text-right" placeholder="Amount"/></td><td><input type="button" value="Delete" class="btn btn-danger" onclick="deleteRow(this)" id="deleteRow' + cntr + '"/></td> </tr>';
            $(".rows").append(rowsData);

            $(".form-control.datepicker").datepicker({
                autoclose: true,
                singleDatePicker: true,
                showDropdowns: true,
                todayHighlight: true
            }).datepicker('setEndDate', new Date());
        };
        reader.onerror = function (error) {
            console.log('Error: ', error);
        };
        bindReimbursementCategory($("#txtReimbType").val(), cntr, 0);
    }
    else {
        misAlert("Invalid image extension. Please select only- .jpg/.png ", "Warning", "warning");
        return false;
    }
}

function deleteRow(e) {
    var len = 0;
    var count = 0;
    var hiddenAction = $("#reimbursementDiv >#hiddenAction").val();
    $(".edit-file-details tbody .tblRows").each(function () {
        var isActive = $(this).find("td:nth-child(1)").find("input[id*='isActive']").val();
        if (isActive == 1) {
            len++;
        }
        count++;
    });
    if (count == 1) {
        $("#tblFootr").hide();
    }
    if (len == 1 && hiddenAction !== "Add") {
        misAlert("You can't delete all documents. Since it will lead to cancellation of the reimbursement request. If you want to do so please cancell the entire request", "Warning", "warning");
        $("#tblFootr").show();
    }
    else if (len == 1 && hiddenAction == "Add") {
        $("#divBtn").hide();
        $("#tblDiv").hide();
        $(e).parents("tr").remove();
    }
    else {
        $("#tblDiv").show();
        $("#divBtn").show();
        $(e).parents("tr").remove();
    }
    var sum = 0;
    $(".edit-file-details tbody .tblRows").each(function () {
        var isActive = $(this).find("td:nth-child(1)").find("input[id*='isActive']").val();
        if (isActive == 1) {
            sum = sum + parseFloat($(this).find("td:eq(4)").find("input[id*='txtAmount']").val() || 0);
        }
    });
    sum = sum.toFixed(2);
    var htmlSum = '<i class="fa fa-inr"></i> ' + sum;
    $("#txtTotalAmount").html(htmlSum);
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

$(document).on("keyup", ".txtAmount.form-control", function () {
    var sum = 0;
    $(".edit-file-details tbody .tblRows").each(function () {
        var isActive = $(this).find("td:nth-child(1)").find("input[id*='isActive']").val();
        if (isActive == 1) {
            sum = sum + parseFloat($(this).find("td:eq(4)").find("input[id*='txtAmount']").val() || 0);
        }
    });
    sum = sum.toFixed(2);
    var htmlSum = '<i class="fa fa-inr"></i> ' + sum;
    $("#txtTotalAmount").html(htmlSum);
});

$(document).on("change", ".txtAmount.form-control", function () {
    var sum = 0;
    $(".edit-file-details tbody .tblRows").each(function () {
        var isActive = $(this).find("td:nth-child(1)").find("input[id*='isActive']").val();
        if (isActive == 1) {
            sum = sum + parseFloat($(this).find("td:eq(4)").find("input[id*='txtAmount']").val() || 0);
        }
    });
    sum = sum.toFixed(2);
    var htmlSum = '<i class="fa fa-inr"></i> ' + sum;
    $("#txtTotalAmount").html(htmlSum);
});

function bindReimbursementType() {
    calltoAjax(misApiUrl.getReimbursementType, "POST", "",
        function (result) {
            $("#txtReimbType").empty();
            $("#txtReimbType").append("<option value='0'>Select</option>");
            if (result !== null) {
                $.each(result, function (index, result) {
                    $("#txtReimbType").append("<option value=" + result.TypeId + ">" + result.TypeName + "</option>")
                });
            }
        });
}

function bindMonthYearToAdd(reimbusrementTypeId) {
    var jsonObject = {
        typeId: reimbusrementTypeId
    };
    calltoAjax(misApiUrl.getReimbursementMonthYearToAddNewRequest, "POST", jsonObject, function (result) {
        $("#txtMonthYear").empty();
        $("#txtMonthYear").append("<option value='0'>Select</option>")
        if (result !== null) {
            $.each(result, function (idx, item) {
                $("#txtMonthYear").append($("<option></option>").val(item.Text).html(item.Text));
            });
        }
    });
}

function bindMonthYearToEdit(selectedMonthYear) {
    calltoAjax(misApiUrl.getReimbursementMonthYearToViewAndApprove, "POST", "", function (result) {
        $("#txtMonthYear").empty();
        $("#txtMonthYear").append("<option value='0'>Select</option>");
        if (result !== null) {
            $.each(result.MonthYearText, function (idx, item) {
                $("#txtMonthYear").append($("<option></option>").val(item.MonthYear).html(item.MonthYear));
            });
            $("#txtMonthYear").val(selectedMonthYear)
        }
    });
}

function bindReimbursementCategory(typeId, i, selectedId) {
    jsonObject = {
        typeId: typeId
    }
    calltoAjax(misApiUrl.getReimbursementCategory, "POST", jsonObject,
        function (result) {
            $("#txtReimbCategory" + i).empty();
            $("#txtReimbCategory" + i).append("<option value='0'>Select</option>")
            if (result !== null) {
                $.each(result, function (index, result) {
                    $("#txtReimbCategory" + i).append("<option value=" + result.TypeId + ">" + result.TypeName + "</option>");
                });
                $("#txtReimbCategory" + i).val(selectedId);
            }
        });
}

function submitReimbursementRequest() {
    var list = new Array();
    $(".edit-file-details tbody .tblRows").each(function () {
        //$(this).find('td').each(function (key, val) {
        var isActive = $(this).find("td:nth-child(1)").find("input[id*='isActive']").val();
        if (isActive == 1) {
            var obj = {
                "ReimbursementDetailId": $(this).find("td:eq(0)").find("input[id*='reimbursementDetailId']").val(),
                "Base64ImageData": $(this).find("td:eq(0)").find("img").attr("src"),
                "CategoryId": $(this).find("td:eq(1)").find("select[id*='txtReimbCategory']").val(),
                "BillNo": $(this).find("td:eq(2)").find("input[id*='txtBillNo']").val(),
                "Date": $(this).find("td:eq(3)").find("input[id*='txtDate']").val(),
                "Amount": parseFloat($(this).find("td:eq(4)").find("input[id*='txtAmount']").val()).toFixed(2),
                "UploadedImageName": $(this).find("td:eq(0)").find("input[id*='txtUploadedImageName']").val()
            };
            list.push(obj);
        }
    });
    var flag = 0;
    for (var j = 0; j < list.length; j++) {
        for (var k = j + 1; k < list.length; k++) {
            if (list[j].CategoryId == list[k].CategoryId && list[j].BillNo == list[k].BillNo
                && list[j].Amount == list[k].Amount && list[j].Date == list[k].Date) {
                flag = 1;
                break;
            }
        }
    }
    if (flag == 1) {
        misAlert("You have added duplicate documents.", "Warning", "warning");
        return false;
    }
    var jsonObject = {
        ReimbursementRequestAbrhs: $("#reimbursementDiv > #hiddenReimursementRequestAbrhs").val(),
        MonthYear: $("#txtMonthYear").val(),
        RequestedAmount: parseFloat($("#txtReimbursementAmount").val()).toFixed(2),
        TypeId: $("#txtReimbType").val(),
        DocumentList: list
    };
    calltoAjax(misApiUrl.submitReimbursementForm, "POST", jsonObject,
        function (result) {
            if (result.Result == 1) {
                $('#reimbursementDiv').addHiddenInputData({
                    "hiddenReimursementTypeId": $("#txtReimbType").val()
                });
                loadUrlToId(misAppUrl.viewReimbursementList, 'partialReimbursementContainer');
                misAlert("Reimbursement request has been submitted successfully.", "Success", "success");

            }
            else if (result.Result == 2) {
                misAlert("You can not raise more than one request in a month for reimbursement type monthly.", "Warning", "warning");
            }
            else if (result.Result == 3) {
                misAlert("Documets already exists. Please add valid documents", "Warning", "warning");
            }
            else {
                misAlert("Unable to process request. Please try again.", "Error", "error");
            }
        });
}

function draftReimbursementFormDetail() {
    var list = new Array();
    $(".edit-file-details tbody .tblRows").each(function () {
        var isActive = $(this).find("td:nth-child(1)").find("input[id*='isActive']").val();
        if (isActive == 1) {
            var obj = {
                "ReimbursementDetailId": $(this).find("td:eq(0)").find("input[id*='reimbursementDetailId']").val(),
                "Base64ImageData": $(this).find("td:eq(0)").find("img").attr("src"),
                "CategoryId": $(this).find("td:eq(1)").find("select[id*='txtReimbCategory']").val(),
                "BillNo": $(this).find("td:eq(2)").find("input[id*='txtBillNo']").val(),
                "Date": $(this).find("td:eq(3)").find("input[id*='txtDate']").val(),
                "Amount": parseFloat($(this).find("td:eq(4)").find("input[id*='txtAmount']").val()).toFixed(2),
                "UploadedImageName": $(this).find("td:eq(0)").find("input[id*='txtUploadedImageName']").val()
            };
            list.push(obj);
        }
    });
    var flag = 0;
    for (var j = 0; j < list.length; j++) {
        for (var k = j + 1; k < list.length; k++) {
            if (list[j].CategoryId == list[k].CategoryId && list[j].BillNo == list[k].BillNo
                && list[j].Amount == list[k].Amount && list[j].Date == list[k].Date) {
                flag = 1;
                break;
            }

        }
    }
    if (flag == 1) {
        misAlert("You have added duplicate documents.", "Warning", "warning");
        return false;
    }

    var jsonObject = {
        ReimbursementRequestAbrhs: $("#reimbursementDiv > #hiddenReimursementRequestAbrhs").val() || '',
        MonthYear: $("#txtMonthYear").val(),
        RequestedAmount: parseFloat($("#txtReimbursementAmount").val()).toFixed(2),
        TypeId: $("#txtReimbType").val(),
        DocumentList: list
    };
    calltoAjax(misApiUrl.draftReimbursementDetails, "POST", jsonObject,
        function (result) {
            if (result.Result == 1) {
                misAlert("Reimbursement request has been drafted successfully.", "Success", "success");
                $('#reimbursementDiv').addHiddenInputData({
                    "hiddenReimursementRequestAbrhs": result.ReimbursementRequestAbrhs,
                    "hiddenAction": "Edit"
                });
                loadReimburesementForm();
            }
            else if (result.Result == 2) {
                misAlert("You can not raise more than one request in a month for reimbursement type monthly.", "Warning", "warning");
            }
            else if (result.Result == 3) {
                misAlert("Documets already exists. Please add valid documents", "Warning", "warning");
            }
            else {
                misAlert("Unable to process request. Please try again.", "Error", "error");
            }
        });
}