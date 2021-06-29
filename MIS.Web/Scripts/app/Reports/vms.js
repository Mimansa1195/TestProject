var _issueId;  
$(document).ready(function () {
    bindAllAccessCard();
    $("#txtCardNo").removeClass('validation-required');
    $("#divDDL").show();
    $("#divText").hide();
    $('.select2').select2();
    if (misPermissions.isDelegatable) {
        var html = '';
        if (!misPermissions.isDelegated) {
            html = '<button id="btnUserDelegation" type="button" class="btn btn-success"><i class="fa fa-bolt"></i>&nbsp;Delegate</button>';
        }
        else {
            html = '<button id="btnUserDelegation" type="button" class="btn btn-success"><i class="fa fa-lightbulb-o" style="color: yellow;font-size: 20px;"></i>&nbsp;Delegate</button>';
        }
        $("#divDeligation").html(html);
    }
    var ToDate = new Date();
    var FromDate = new Date();
    FromDate.setDate(FromDate.getDate());
    $("#fromDateVisitor input").val(toddmmyyyDatePicker(FromDate));
    $("#tillDateVisitor input").val(toddmmyyyDatePicker(ToDate));
    $("#fromDateTempCard input").val(moment(FromDate).format("DD/MM/YYYY"));
    $("#tillDateTempCard input").val(moment(ToDate).format("DD/MM/YYYY"));
    $("#txtFromDateLog input").val(toddmmyyyDatePicker(FromDate));
    $("#txtTillDateLog input").val(toddmmyyyDatePicker(ToDate));

    $('#fromDateVisitor').datepicker({
        format: "mm/dd/yyyy",
        autoclose: true,
        todayHighlight: true
    }).datepicker('setEndDate', new Date()).on('changeDate', function (ev) {
        var fromStartDate = $('#fromDateVisitor input').val();
        $('#tillDateVisitor input').val('');
        $('#tillDateVisitor').datepicker('setStartDate', fromStartDate).trigger('change');
    });

    $('#tillDateVisitor').datepicker({
        format: "mm/dd/yyyy",
        autoclose: true,
        todayHighlight: true
    }).datepicker('setEndDate', new Date());

    $('#fromDateTempCard').datepicker({
        format: "dd/mm/yyyy",
        autoclose: true,
        todayHighlight: true
    }).datepicker('setEndDate', new Date()).on('changeDate', function (ev) {
        var fromStartDate = $('#fromDateTempCard input').val();
        $('#tillDateTempCard input').val('');
        $('#tillDateTempCard').datepicker('setStartDate', fromStartDate).trigger('change');
    });

    $('#tillDateTempCard').datepicker({
        format: "dd/mm/yyyy",
        autoclose: true,
        todayHighlight: true
    }).datepicker('setEndDate', new Date());

    $('#txtFromDateLog').datepicker({
        format: "mm/dd/yyyy",
        autoclose: true,
        todayHighlight: true
    }).datepicker('setEndDate', new Date()).on('changeDate', function (ev) {
        var fromStartDate = $('#txtFromDateLog input').val();
        $('#txtTillDateLog input').val('');
        $('#txtTillDateLog').datepicker('setStartDate', fromStartDate).trigger('change');
    });

    $('#txtTillDateLog').datepicker({
        format: "mm/dd/yyyy",
        autoclose: true,
        todayHighlight: true
    }).datepicker('setEndDate', new Date());

    $("#returnDate").datetimepicker({
        locale: 'en-gb',
        maxDate: moment(ToDate),
        stepping: 15,
        //minDate: ToDate,
        format: 'DD/MM/YYYY HH:mm',
    }).on('dp.change', function (e) {
        $(this).data('DateTimePicker').hide();
    });

    $("#issueDate").datetimepicker({
        locale: 'en-gb',
        maxDate: moment(ToDate),
        //minDate: ToDate,
        format: 'DD/MM/YYYY HH:mm',
    }).on('dp.change', function (e) {
        var fromStartDate = $('#issueDate input').val();
        $(this).data('DateTimePicker').hide();
        $('#returnDate').data("DateTimePicker").minDate(fromStartDate);
        $('#returnDate input').val('');
    });

    $("#addReturnDate").datetimepicker({
        locale: 'en-gb',
        defaultDate: moment(ToDate),
        maxDate: moment(ToDate),
       // minDate: ToDate,
        format: 'DD/MM/YYYY HH:mm',
    }).on('dp.change', function (e) {
        $(this).data('DateTimePicker').hide();
        });

    $("#addIssueDate").datetimepicker({
        locale: 'en-gb',
        defaultDate: moment(ToDate),
        maxDate: moment(ToDate),
        //minDate: ToDate,
        format: 'DD/MM/YYYY HH:mm',
    }).on('dp.change', function (e) {
        var fromStartDate = $('#addIssueDate input').val();
        $(this).data('DateTimePicker').hide();
        $('#addReturnDate').data("DateTimePicker").minDate(fromStartDate);
        $('#addReturnDate input').val('');
        });

    $("#btnEditClose").click(function () {
        $("#mypopupEditCardDetails").modal('hide');
    });

    $("#btnVisitor").click(function () {
        bindVisitorsData();
    });
    $("#btnTempCard").click(function () {
        bindTempCardDetails();
    });
    $("#editAccessCard").click(function () {
        editAccessCardDetails();
    });
    $("#btnAddCard").click(function () {

        if ($("#addIssueDate > .bootstrap-datetimepicker-widget.dropdown-menu.usetwentyfour.top").css("display") == "block"
            || $("#addIssueDate > .bootstrap-datetimepicker-widget.dropdown-menu.usetwentyfour.bottom").css("display") == "block") {
            $("#spnAddFrom").trigger("click");
        }

        if ($("#addReturnDate > .bootstrap-datetimepicker-widget.dropdown-menu.usetwentyfour.top").css("display") == "block"
            || $("#addReturnDate > .bootstrap-datetimepicker-widget.dropdown-menu.usetwentyfour.bottom").css("display") == "block") {
            $("#spnAddTill").trigger("click");
        }

        $("#reason").removeClass('error-validation');
        $("#addEmployee").select2("val", "0");
        $("#addAccessCardNo").select2("val", "0");
        $("#addIsReturned").attr('checked', false);
        $("#mypopupAddCardDetails").modal('show');
        bindAllEmployeesToAdd();
    });
    $("#btnAddClose").click(function () {
        $("#mypopupAddCardDetails").modal('hide');
    });
    $("#addAccessCard").click(function () {
        if (!validateControls('divAddCardDetails')) {
            return false;
        }
        else
            saveAddedCards();
    });
    bindAllEmployees();
    bindAllTempCards();
    //checkIfUserEligibleToAddCards();
    bindAllTempCardsToAdd();
    if (misPermissions.hasAddRights === true) {
        $("#btnAddCard").show();
    }
});

function bindAllEmployees() {
    $("#employee").html(""); //to clear the previously selected value
    $("#employee").select2();
    $("#employee").append("<option value='0'>Select</option>");
    calltoAjax(misApiUrl.listAllActiveUsers, "POST", '',
        function (result) {
            $.each(result, function (idx, item) {
                $("#employee").append($("<option></option>").val(item.EmployeeAbrhs).html(item.EmployeeName));
            });
        });
}

function bindAllTempCards() {
    $("#accessCardNo").html(""); //to clear the previously selected value
    $("#accessCardNo").select2();
    $("#accessCardNo").append("<option value='0'>Select</option>");
    calltoAjax(misApiUrl.getAllTempCards, "POST", '',
        function (result) {
            $.each(result, function (idx, item) {
                $("#accessCardNo").append($("<option></option>").val(item.Value).html(item.Text));
            });
        });
}

function bindAllEmployeesToAdd() {
    $("#addEmployee").html(""); //to clear the previously selected value
    $("#addEmployee").select2();
    $("#addEmployee").append("<option value='0'>Select</option>");
    calltoAjax(misApiUrl.listAllActiveUsers, "POST", '',
        function (result) {
            $.each(result, function (idx, item) {
                $("#addEmployee").append($("<option></option>").val(item.EmployeeAbrhs).html(item.EmployeeName));
            });
        });
}

function bindAllTempCardsToAdd() {
    $("#addAccessCardNo").html(""); //to clear the previously selected value
    $("#addAccessCardNo").select2();
    $("#addAccessCardNo").append("<option value='0'>Select</option>");
    calltoAjax(misApiUrl.getAllTempCards, "POST", '',
        function (result) {
            $.each(result, function (idx, item) {
                $("#addAccessCardNo").append($("<option></option>").val(item.Value).html(item.Text));
            });
        });
}
//function checkIfUserEligibleToAddCards() {
//    calltoAjax(misApiUrl.checkIfUserEligibleToAddCards, "POST", '',
//        function (result) {
//            var resultData = $.parseJSON(JSON.stringify(result));
//            switch (resultData) {
//                case 1:
//                    $("#btnAddCard").show();
//                    break;
//                case 2:
//                    $("#btnAddCard").hide();
//                    break;
//            }
//        });
//}

function bindVisitorsData() {
    var jsonObject = {
        fromDate: $("#fromDateVisitor input").val(),
        endDate: $("#tillDateVisitor input").val(),
        userAbrhs: misSession.userabrhs,
    }
    calltoAjax(misApiUrl.getVisitorDetails, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblVisitor").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'VMS List',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'VMS List' },
                        { extend: 'pdf', filename: 'VMS List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                        { extend: 'print', filename: 'VMS List' },
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
                "deferRender": false,
                "aaData": data,
                "aoColumns": [
                    {
                        "mData": "VisitorId",
                        "sTitle": "Visitor Id",
                    },
                    {
                        "mData": null,
                        "sTitle": "Visitor Name",
                        'bSortable': false,
                        mRender: function (data, type, row) {
                            return row.Visitor_FName + " " + row.Visitor_LName;
                        }
                    },
                    {
                        "mData": "Visitor_Address",
                        "sTitle": "Address",
                    },
                    {
                        "mData": "Visitor_ContactNo",
                        "sTitle": "Contact No",
                    },
                    {
                        "mData": "Visitor_Email",
                        "sTitle": "Visitor Email",
                    },
                    {
                        "mData": "EmployeeName",
                        "sTitle": "Employee Name",
                    },
                    {
                        "mData": "Visitor_Purpose",
                        "sTitle": "Purpose",
                    },
                    //{
                    //    "mData": "Visitor_IdentityProof",
                    //    "sTitle": "Identity Proof",
                    //},
                    {
                        "mData": "Visitor_TimeIn",
                        "sTitle": "TimeIn",
                    },
                    {
                        "mData": "Visitor_TimeOut",
                        "sTitle": "TimeOut",
                    },
                ]
            });
        });
}

function bindTempCardDetails() {
    if (!validateControls('tabTempCard')) {
        return false;
    }
    var jsonObject = {
        fromDate: $("#fromDateTempCard input").val(),
        endDate: $("#tillDateTempCard input").val(),
        userAbrhs: misSession.userabrhs,
    }
    calltoAjax(misApiUrl.getTempCardDetails, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblTempCard").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'Temp Card Issue History',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'Temp Card Issue History' },
                        { extend: 'pdf', filename: 'Temp Card Issue History' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                        { extend: 'print', filename: 'Temp Card Issue History' },
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
                "deferRender": false,
                "aaData": data,
                "aoColumns": [
                    //{
                    //    "mData": "IssueId",
                    //    "sTitle": "Issue Id",
                    //},
                    {
                        "mData": null,
                        "sTitle": "Employee Name",
                        "sWidth": "100px",
                        //'bSortable': false,
                        mRender: function (data, type, row) {
                              var  html = '<a  onclick="showAttendanceLog(\'' + row.EmployeeAbrhs + '\', \'' + row.AccessCardNo + '\', \'' + row.IssueDate + '\')" style="text-decoration: underline !important;" data-toggle="tooltip" title="Show Attendance Log">' + row.EmployeeName + '</a>';
                            return html;
                        }
                    },
                    //{
                    //    "mData": "EmployeeName",
                    //    "sTitle": "Employee Name",
                    //},
                    {
                        "mData": "AccessCardNo",
                        "sTitle": "Access Card No",
                    },
                    {
                        "mData": "IssueDate",
                        "sTitle": "Issue Date",
                    },
                    {
                        "mData": "ReturnDate",
                        "sTitle": "Return Date",
                    },
                    {
                        "mData": "Reason",
                        "sTitle": "Reason",
                    },
                    {
                        "mData": "IsReturn",
                        "sTitle": "Return",
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        mRender: function (data, type, row) {
                            var html = '<div>';
                            if (misPermissions.hasModifyRights === true) {
                                html += '<button type="button" class="btn btn-sm teal"' + 'onclick="getDetailsOfCard(' + row.IssueId + ')" data-toggle="tooltip" title="Edit"><i class="fa fa-edit"></i></button>';
                            }
                            if (misPermissions.hasDeleteRights === true) {
                                html += '&nbsp;<button type="button" class="btn btn-sm btn-danger"' + 'onclick="deactivateCard(' + row.IssueId + ')" data-toggle="tooltip" title="Deactivate"><i class="fa fa-ban"></i></button>';
                            }
                            html += '</div>'
                            return html;
                        }
                    },
                ]
            });
        });
}

$("#btnClose").click(function () {
    $("#note").hide();
    $("#note").html("");
    $('#modalTempCardAttendanceLog').modal('hide');
});

function showAttendanceLog(empAbrhs, accessCardNo, attendanceDate) {
    var options = {
        empAbrhs: empAbrhs,
        accessCardNo: accessCardNo,
        attendanceDate: attendanceDate
    };
    $('#modalTempCardAttendanceLog').modal('show');
    $('#modalAttendanceLogTitle').text('Punch in/out summary on: ' + attendanceDate);

    calltoAjax(misApiUrl.getPunchInOutLogForTempCard, "POST", options, function (result) {
        var resultdata = $.parseJSON(JSON.stringify(result));
        var cCounter = 0;
        var nCounter = 0;
        var oCounter = 0;
        $('#gridAttendanceLog').DataTable({
            "bDestroy": true,
            "bPaginate": false,
            "bFilter": false,
            "info": false,
            "aaData": resultdata,
            "order": [],
            "aoColumns": [
                { "sTitle": "Punch Time", "mData": "PunchTime", "sWidth": "150px", 'bSortable': false },
                { "sTitle": "Door Point", "mData": "DoorPoint", 'bSortable': false },
            ],
            "fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                if (aData.Day == 'P') {
                    $(nRow).find('td:eq(0)').css('border-left', '5px solid #00bcd4');
                }
                else if (aData.Day == 'C') {
                    cCounter += 1;
                    $(nRow).find('td:eq(0)').css('border-left', '5px solid #03a817');
                    $(nRow).find('td:eq(1)').css('border-right', '5px solid #03a817');
                    if (cCounter == 1) {
                        $(nRow).attr('id', 'currentAttendance');
                        $('td', nRow).css('border-top', '2px solid #03a817')
                    }
                }
                else if (aData.Day == 'N') {
                    nCounter += 1;
                    $(nRow).find('td:eq(0)').css('border-left', '5px solid #ff9800');
                    if (cCounter > 0 && nCounter == 1)
                        $('td', nRow).css('border-top', '2px solid #03a817');
                }
                else {
                    oCounter += 1;
                    $(nRow).find('td:eq(0)').css('border-left', '5px solid #353131');
                    $(nRow).find('td').css('border-top', '2px solid #353131');
                }
                //In/Out
                if (aData.Event == 1) {
                    $('td', nRow).css('background-color', '#d3fcd4');
                }
                else if (aData.Event == 0) {
                    $('td', nRow).css('background-color', '#ffdcdc');
                }
            }
        });

        if (resultdata.length > 0) {
            var currentDayDataCount = 0;
            for (var i = 0; i < resultdata.length; i++) {
                if (resultdata[i].Day == 'C')
                    currentDayDataCount++;
            }
            if (currentDayDataCount == 0) {
                $("#note").show();
                $("#note").html("Note : Current date data is not available.");
            }
            else if (currentDayDataCount > 0) {
                $("#note").hide();
                $("#note").html("");

            }
        }
    }, null, function () {
        scrollToId('currentAttendance');
    });

}

function getDetailsOfCard(issueId) {
    if ($("#issueDate > .bootstrap-datetimepicker-widget.dropdown-menu.usetwentyfour.top").css("display") == "block"
        || $("#issueDate > .bootstrap-datetimepicker-widget.dropdown-menu.usetwentyfour.bottom").css("display") == "block") {
        $("#spnFrom").trigger("click");
    }

    if ($("#returnDate > .bootstrap-datetimepicker-widget.dropdown-menu.usetwentyfour.top").css("display") == "block"
        || $("#returnDate > .bootstrap-datetimepicker-widget.dropdown-menu.usetwentyfour.bottom").css("display") == "block") {
        $("#spnTill").trigger("click");
    }
    $("#issueDate input").val('');

    _issueId = issueId;
    var jsonObject = {
        issueId: issueId,
    };
    calltoAjax(misApiUrl.getTempCardDetailsForEdit, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#issueDate").datetimepicker().on('dp.show', function (e) {
                $("#issueDate table tr td").removeClass("active");
                $("#issueDate table tr td[data-day='" + resultData.IssueDate + "']").addClass("active");
                $("#issueDate input").val(resultData.IssueDate)
            });
            $("#employee").select2("val", [resultData.EmployeeId]);
            $("#accessCardNo").select2("val", [resultData.AccessCardId]);
            $("#reason").val(resultData.Reason);

            $('#issueDate').data("DateTimePicker").defaultDate(resultData.IssueDate);
           // $("#issueDate input").val(resultData.IssueDate);
            $('#returnDate').data("DateTimePicker").minDate(resultData.IssueDate);
            $("#returnDate input").val(resultData.ReturnDate);

            if (resultData.IsReturn == "False")
                $("#isReturned").prop('checked', false);
            else if (resultData.IsReturn == "True")
                $("#isReturned").prop('checked', true);
            $("#mypopupEditCardDetails").modal('show');
        });
}

function editAccessCardDetails() {
    if (!validateControls('mypopupEditCardDetails')) {
        return false;
    }
    var issueDate = $("#issueDate input").val();
    var returnDate = $("#returnDate input").val() != "" && $("#returnDate input").val() != "NA" ? $("#returnDate input").val(): "";
    var jsonObject = {
        issueId: _issueId,
        employeeId: $("#employee").val(),
        accessCardId: $("#accessCardNo").val(),
        issueDate: issueDate,
        returnDate: returnDate,
        reason: $("#reason").val(),
        isReturn: $("#isReturned").is(':checked') ? true : false
    }
    calltoAjax(misApiUrl.editAccessCardDetails, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            switch (resultData) {
                case 1:
                    misAlert("Access card detail has been updated successfully", "Success", "success");
                    $("#mypopupEditCardDetails").modal('hide');
                    bindTempCardDetails();
                    break;
                case 2:
                    misAlert("Access card does not Exist.", "Warning", "warning");
                    break;
            }
        });
}

function saveAddedCards() {
    var jsonObject = {
        employeeId: $("#addEmployee").val(),
        accessCardId: $("#addAccessCardNo").val(),
        issueDate: $("#addIssueDate input").val(),
        returnDate: $("#addReturnDate input").val(),
        reason: $("#reason").val(),
        isReturn: $("#addIsReturned").is(':checked') ? true : false
    }
    calltoAjax(misApiUrl.addCardIssueDetail, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            switch (resultData) {
                case 1:
                    misAlert("Issue detail added successfully.", "Success", "success");
                    $("#mypopupAddCardDetails").modal('hide');
                    bindTempCardDetails();
                    break;
                case 0:
                    misAlert("Unable to process request. Try again.", "Error", "error");
                    $("#mypopupAddCardDetails").modal('hide');
                    break;
            }
        });
}

function deactivateCard(issueId) {
    misConfirm("Are you sure you want to deactivate this record?", "Confirm", function (isConfirmed) {
        if (isConfirmed) {
            var JsonObject = {
                issueId: issueId,
            };
            calltoAjax(misApiUrl.changeStatusOfIssuedCard, "POST", JsonObject,
                function (result) {
                    if (result === 1) {
                        misAlert("Record has been deactivated successfully.", "Success", "success");
                        bindTempCardDetails();
                    }
                    else {
                        misAlert("Request failed to process.", "Danger", "danger");
                        bindTempCardDetails();
                    }
                });
        }
    });
}

$("#ddlCardType").change(function () {
    var cardType = $("#ddlCardType").val();
    if (cardType === "A") {
        $("#txtCardNo").addClass('validation-required');
        $("#ddlAccessCard").removeClass('validation-required');
        $("#divText").show();
        $("#divDDL").hide();
        $("#txtCardNo").val('');
    }
    else {
        $("#txtCardNo").removeClass('validation-required');
        $("#ddlAccessCard").addClass('validation-required');
        $("#divDDL").show();
        $("#divText").hide();
        bindAllAccessCard();
    }
});

function bindAllAccessCard() {
    var cardType = $("#ddlCardType").val();
    if (cardType !== "A") {
        var jsonObject = {
            cardType: cardType
        };
        $("#ddlAccessCard").empty();
        $("#ddlAccessCard").append("<option value='0'>Select</option>");
        calltoAjax(misApiUrl.getAllAccessCard, "POST", jsonObject,
            function (result) {
                if (result) {
                    $.each(result, function (key, value) {
                        $("#ddlAccessCard").append('<option value=' + value.AccessCardNo + '>' + value.AccessCardNo + '</option>');
                    });
                }
            });
    }
}

$("#btnFetchCardLogs").click(function () {
    fetchCardLogs();
});

function fetchCardLogs() {
    if (!validateControls('tabCardLog')) {
        return false;
    }
    var cardType = $("#ddlCardType").val();
    var cardNo = "";
    if (cardType == "A") 
        cardNo = $("#txtCardNo").val();
    else
        cardNo = $("#ddlAccessCard").val();
   
    var jsonObject = {
        accessCardNo: cardNo,
        fromDate: $("#txtFromDateLog input").val(),
        tillDate: $("#txtTillDateLog input").val()
    };
    calltoAjax(misApiUrl.getPunchInOutLogForAllCard, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblCardLogs").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'Card Logs',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'Card Logs' },
                        { extend: 'pdf', filename: 'Card Logs' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                        { extend: 'print', filename: 'Card Logs' },
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
                "deferRender": false,
                "aaData": data,
                "aoColumns": [
                    { "sTitle": "Punch Time", "mData": "PunchTime", "sWidth": "150px", 'bSortable': false },
                    { "sTitle": "Door Point", "mData": "DoorPoint", "sWidth": "150px", 'bSortable': false },
                ],
                "fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                    //In/Out
                    if (aData.Event == 1) {
                        $('td', nRow).css('background-color', '#d3fcd4');
                    }
                    else if (aData.Event == 0) {
                        $('td', nRow).css('background-color', '#ffdcdc');
                    }
                }
            });
    });
}
