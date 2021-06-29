var leaveSections="";
var financialYearsTab="";
var leavetype="";
var leaveBoxes=""; 
var className="";
var currentYear="";
var currentQtr="";
var leave;
var _employeeAbrhs = "";
var _doj = "";

$(document).ready(function () {
    _employeeAbrhs = $("#hdnEmployeeAbrhs").val();
    _doj = $("#hdnDOJ").val();

    $('#fromDate').datepicker({
        autoclose: true,
        todayHighlight: true,
        format: 'dd/mm/yyyy',
    }).datepicker("setDate",_doj).on('changeDate', function (ev) {
        onFromDateChange();
        });

    $('#tillDate').datepicker({
        autoclose: true,
        todayHighlight: true,
        format: 'dd/mm/yyyy',
    }).datepicker('setStartDate', _doj).datepicker('setDate', new Date());

    $('#datetimepicker1').datepicker({
        format: "dd/mm/yyyy",
        autoclose: true,
        todayHighlight: true
    }).datepicker('setDate', new Date()).datepicker('setEndDate', new Date());

    $("#btnGetUserDetailData").click(function () {
        if (!validateControls('divSearch'))
            return false;

        $("#divProfile").show();
        $("#divFilterFY").show();
        loadFullNFinalData(_employeeAbrhs);

        $(".fixed-header").attr("data-offset-top", $(".filter-heading").offset().top - 170)
        if ($(window).width() > 768) {
            $("#leaveCard .col-sm-2").css("width", "calc(100%/" + $("#leaveCard .col-sm-2").length + ")")
        }
        $(".fixed-header").css("width", $(".filter-heading").width() - 20);
    });

    $("#btnDeactiveUser").click(function () {
        inActivateEmployee(_employeeAbrhs);
    });

    $("#datetimepicker1 input").change(function () {
        loadUserLeaveBalanceDetail();
    });

    $("#btnBackToActiveUserList").click(function () {
    loadUrlToId(misAppUrl.listActiveUsers,'divActiveUserPartialContainer')
    });
});

function onFromDateChange() {
    var fromDate = $("#fromDate input").val();
    $('#tillDate input').val("");
    $('#tillDate').datepicker({
        autoclose: true,
        todayHighlight: true,
        format: 'dd/mm/yyyy',
    }).datepicker('setStartDate', fromDate);
}

function inActivateEmployee(employeeAbrhs) {
    getReporteesUnderManager(employeeAbrhs);
    getUserAssets(employeeAbrhs);
    $("#hdnEmployeeId").val(employeeAbrhs);
    loadUserLeaveBalanceDetail();
    $('#InActivateEmployeeModal').modal({
        backdrop: 'static',
        keyboard: false
    });
    $("#InActivateEmployeeModal").modal('show');
   
}

function getUserAssets(employeeAbrhs) {
    jsonObject = {
        userAbrhs: employeeAbrhs,
    }
    calltoAjax(misApiUrl.getUsersActiveAssets, "POST", jsonObject,
        function (result) {
            var assets = $.parseJSON(JSON.stringify(result));
            var html = '<div class="col-md-12 clearfix"><div class="input-group">'+
                '<table id="tblUserAssets" data-filter-control="true" data-toolbar="#toolbar" class="table table-hover"></table>'+
                '</div></div>';

           var tablHtml = '<table class="tbl-typical text-left">';
                tablHtml += '<tr class="bg-danger"><td colspan="2">Please collect following assets before deactivating this employee.</td></tr>';
                $.each(assets, function (idx, item) {
                    tablHtml += '<tr><td>' + item.AssetType + "(" + item.Brand + "_" + item.Model + ")" + '</td> <td>' + item.SerialNo + '</td></tr>'
                });
            tablHtml += '</table>';

            //if (assets.length == 0) {
            //    $("#btnInActivate").show();
            //    $("#divUserAssets").html("");
            //}
            //else {
            //    $("#btnInActivate").hide();
            //    $("#divUserAssets").html(html);
            //}

            //$("#tblUserAssets").html(tablHtml);

            $("#btnInActivate").show();
        });
}

function getReporteesUnderManager(employeeAbrhs) {
    var html = "";
    var jsonObject = {
        userAbrhs: employeeAbrhs
    }
    calltoAjax(misApiUrl.getEmployeesReportingToUserByManagerId, "POST", jsonObject, function (result) {
        if (result != null) {
            var resultdata = $.parseJSON(JSON.stringify(result));
            var count = resultdata.length;
            if (count == 0) {
                $("#btnInActivate").show();
            }
            else {
                $("#btnInActivate").hide();
            }
            html = '<table class="tbl-typical text-left">';
            //html += '<span class="spnError"></span>'
            if (resultdata.length > 0) {
                //html = '<tr class="bg-primary"><td>Reportees Under This Employee</td></tr>';
                html = '<tr class="bg-danger"><td>Update reporting manager of following employees before deactivating this employee.</td></tr>';
                for (var i = 0; i < resultdata.length; i++) {
                    html += '<tr><td>' + (resultdata[i].EmployeeName === null ? "NA" : resultdata[i].EmployeeName) + '</td> </tr>'
                }
            }
            html += '</table>';
        }
        $("#tblReportees").html(html);
    });
}

function loadUserLeaveBalanceDetail() {
    var dateOfLeaveing = $("#datetimepicker1 input").val();
    var jsonObject = {
        dol: dateOfLeaveing,
        userAbrhs: _employeeAbrhs
    };
    calltoAjax(misApiUrl.fetchUserLeaveBalanceDetail, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#tblUserLeaveSummary").dataTable({
                "responsive": true,
                "autoWidth": true,
                "paging": false,
                "bDestroy": true,
                "searching": false,
                "ordering": false,
                "info": false,
                "deferRender": true,
                "aaData": resultData,
                "aoColumns": [
                    {
                        "mData": "LeaveTypes",
                        "sTitle": "Leave Type",
                    },
                    {
                        "mData": "Summary",
                        "sTitle": "Summary",
                    },
                ]
            });
        });
}

function changeUserStatus() {
    if (!validateControls('InActivateEmployeeModal')) {
        return false;
    }
    var reply = misConfirm("Are you sure you want to de-activate the user", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                employeeAbrhs: $("#hdnEmployeeId").val(),
                status: 2,
                terminationDate: $("#txtDate").val()
            };
            calltoAjax(misApiUrl.changeUserStatus, "POST", jsonObject,
                function (result) {
                    var resultData = $.parseJSON(JSON.stringify(result));
                    if (resultData) {
                        swal("Success!", "Employee has been inactivated successfully!", "success")
                        $("#InActivateEmployeeModal").modal('hide');
                        $('body').removeClass('modal-open');
                        $('.modal-backdrop').remove();
                        loadUrlToId(misAppUrl.listActiveUsers, 'divActiveUserPartialContainer')
                    }
                }
            );
        }
    });
}

function loadFullNFinalData(employeeAbrhs) {

    var fromDate = $("#fromDate input").val();
    var tillDate = $("#tillDate input").val();
    var jsonObject = {
        userAbrhs: employeeAbrhs,
        fromDate: fromDate,
        tillDate: tillDate
    };
    calltoAjax(misApiUrl.loadFullNFinalData, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(result.Summary.replace(/"{/gi, '{').replace(/}"/gi, '}').replace(/"\[/gi, '[').replace(/]\"/gi, ']')); //$.parseJSON(JSON.stringify(result.Summary));
            processData(data);
        });
}

function processData(data) {
    leaveSections = "";
    financialYearsTab = "";
    leavetype = "";
    leaveBoxes = "";
    className = "";
    currentYear = "";
    currentQtr = "";

    /*Employee Details */
    for (j in data) {
        if (data.hasOwnProperty(j)) {
            $("#empImg").attr("src", data.UserSummary.ImagePath);
            $("#empName").text(data.UserSummary.EmployeeName);
            $("#empCode").text(data.UserSummary.EmployeeCode);
            $("#empDesignation").text(data.UserSummary.Designation);
            $("#empDepartment").text(data.UserSummary.Department);
            $("#empJoiningDate").text(data.UserSummary.JoiningDate);
            $("#empReportingManagerName").text(data.UserSummary.ReportingManagerName);
            $("#intern").text(data.UserSummary.IsIntern);
        }
    }
    /*Employee Details */

    /*Leave Couont Boxes */
    for (j in data.LeaveBalanceSummary) {
        if (data.LeaveBalanceSummary.hasOwnProperty(j)) {
            leaveSections += '<div class="col-sm-2">\
    <article class="statistic-box">\
        <div>\
            <div class="number">'+ data.LeaveBalanceSummary[j].LeaveCount + '</div>\
            <div class="caption"><div>'+ data.LeaveBalanceSummary[j].LeaveType + '</div></div>\
            <div class="fy">'+ data.LeaveBalanceSummary[j].Label + '</div>\
        </div>\
    </article>\
  </div>'
        }
    }
    /*Leave Count Boxes */

    /*Leave checkbox filter */
    for (j in data.LeaveSummary) {
        if (data.LeaveSummary.hasOwnProperty(j)) {
            if (data.LeaveSummary[j].LeaveType === "PL(M)") {
                leavetype += '<li class="list-group-item active leaveSelector"><input type="checkbox" checked name="checkbox" id="PLM"><label for="PLM">' + data.LeaveSummary[j].LeaveType + '</label></li>'
            }
            else {
                leavetype += '<li class="list-group-item active leaveSelector"><input type="checkbox" checked name="checkbox" id="' + data.LeaveSummary[j].LeaveType + '"><label for="' + data.LeaveSummary[j].LeaveType + '">' + data.LeaveSummary[j].LeaveType + '</label></li>'
            }
        }
    }
    leavetype += '<li class="list-group-item active"><input type="checkbox" checked name="checkbox" id="chkAll"><label for="chkAll">Select All</label></li>'

    $("#leavetype ul").html(leavetype)
    /*Leave checkbox filter */

    /*Leave year filter */
    $("#leaveCard ").html(leaveSections)
    for (j in data.FYSummary) {
        if (data.FYSummary.hasOwnProperty(j)) {
            if (data.FYSummary[j].IsCurrentFY == "Yes") {
                className = "active"
            }
            else {
                className = ""
            }
            financialYearsTab += '<li class="nav-item"><a class="nav-link ' + className + '" id="financial-year-' + data.FYSummary[j].FYName + '" href="">' + data.FYSummary[j].FYName + '</a></li> '
        }
    }
    $("#financialYears").html(financialYearsTab)
    /*Leave year filter */

    /*Leave details*/
    leaveBoxes += '';
    for (j in data.LeaveSummary) {
       
        if (data.LeaveSummary.hasOwnProperty(j)) {
            if (data.LeaveSummary[j].LeaveType == "PL(M)") {
                leaveBoxes += '<div class="col-md-12 section-PLM"><div class="card">\
                <div class="card-header PLM"><span>' + data.LeaveSummary[j].LeaveType + '</span></div><div class="card-body p-5">'
            }
            else {
                leaveBoxes += '<div class="col-md-12 section-' + data.LeaveSummary[j].LeaveType + '"><div class="card">\
                <div class="card-header '+ data.LeaveSummary[j].LeaveType + '"><span>' + data.LeaveSummary[j].LeaveType + '</span></div><div class="card-body p-5">'
            }
            if (data.LeaveSummary[j].Summary.length == 0) {
                leaveBoxes += '<h5 style="text-align:center;">No data found!!</h5>'
            }
            else {
                for (k in data.LeaveSummary[j].Summary) {
                    if (data.LeaveSummary[j].Summary.hasOwnProperty(k)) {
                      
                        /*Leave details section for comp off and LNSA*/
                        if (data.LeaveSummary[j].LeaveType == "COFF" || data.LeaveSummary[j].LeaveType == "LNSA") {

                            if (data.LeaveSummary[j].Summary[k].IsCurrentFY == "Yes") {
                                currentQtr = "active";
                            }
                            else {
                                currentQtr = "";
                            }
                            var array = [""];

                            if (data.LeaveSummary[j].Summary[k].Summary.Dates !== undefined && data.LeaveSummary[j].Summary[k].Summary.Dates !== "") {
                               
                                array = data.LeaveSummary[j].Summary[k].Summary.Dates.split(',');
                            }
                            leaveBoxes += '<div  class="col-md-3 p-5 ' + currentQtr + '" data-attr-id="financial-year-' + data.LeaveSummary[j].Summary[k].FYName + '"><div class="financial-year"><i class="fa fa-calendar" aria-hidden="true"></i><span>' + data.LeaveSummary[j].Summary[k].QuarterName + ' Qtr(' + data.LeaveSummary[j].Summary[k].Quarter + ')</span><a class="toggle-dates-section">Dates</a>\</div>\
                              <div data-attr-id="'+ data.LeaveSummary[j].Summary[k].QuarterName + '" class="leaveDates">\
                              <p>Applied Leaves:'+ data.LeaveSummary[j].Summary[k].Summary.Applied + '</p>\
                              <p>Rejected Leaves:'+ data.LeaveSummary[j].Summary[k].Summary.Rejected + '</p>\
                              <p>Cancelled Leaves:'+ data.LeaveSummary[j].Summary[k].Summary.Cancelled + '</p>\
                              <p>Pending Leaves:'+ data.LeaveSummary[j].Summary[k].Summary.Pending + '</p>\
                              <p>Approved Leaves:'+ data.LeaveSummary[j].Summary[k].Summary.Approved + '</p>\
                              <div class="dates-section">'
                            for (t in array) {
                                if (array[t] == "") {
                                    leaveBoxes += '<span class="badge">No data Available</span>'
                                }
                                else {
                                    leaveBoxes += '<span class="badge">' + array[t] + '</span>'
                                }
                            }
                            leaveBoxes += '</div></div></div>';

                        }
                        /*Leave details section for comp off and LNSA*/
                        else {
                            if (data.LeaveSummary[j].Summary[k].IsCurrentFY == "Yes") {
                                currentYear = "active";
                            }
                            else {
                                currentYear = "";
                            }
                            var array = data.LeaveSummary[j].Summary[k].Dates.split(',');
                            leaveBoxes += '<div  class="col-md-3 p-5 ' + currentYear + '" data-attr-id="financial-year-' + data.LeaveSummary[j].Summary[k].FYName + '"><div class="financial-year"><i class="fa fa-calendar" aria-hidden="true"></i><span>' + data.LeaveSummary[j].Summary[k].FYName + '</span><a class="toggle-dates-section">Dates</a>\</div>\
                              <div data-attr-id='+ data.LeaveSummary[j].Summary[k].FYName + ' class="leaveDates">\
                              <p>Applied Leaves:'+ data.LeaveSummary[j].Summary[k].Applied + '</p>\
                              <p>Rejected Leaves:'+ data.LeaveSummary[j].Summary[k].Rejected + '</p>\
                              <p>Cancelled Leaves:'+ data.LeaveSummary[j].Summary[k].Cancelled + '</p>\
                              <p>Pending Leaves:'+ data.LeaveSummary[j].Summary[k].Pending + '</p>\
                              <p>Approved Leaves:'+ data.LeaveSummary[j].Summary[k].Approved + '</p>\
                              <div class="dates-section">'
                            for (t in array) {
                                if (array[t] == "") {
                                    leaveBoxes += '<span class="badge">No data Available</span>'
                                }
                                else {
                                    leaveBoxes += '<span class="badge">' + array[t] + '</span>'
                                }
                            }
                            leaveBoxes += '</div></div></div>';
                        }

                    }
                }
            }
        }
        leaveBoxes += '</div></div></div>';
    }
    $("#boxes").html(leaveBoxes)
}

//    /*Filter leave as per financial year*/
//$(document).on("change", "#leavetype input[type='checkbox']", function (e) {
//    $(this).parent().toggleClass("active");
//    leave = $(this).attr("id");
//    $("#boxes .section-" + leave + "").toggle();
//    var leave = $(this).attr("id");
//    $("#boxes div[class='section-" + leave + "']").toggle();
//});


///*Filter leave as per financial year*/
//$(document).on("change", "#leavetype input[type='checkbox']", function (e) {
//    
//    leave = $(this).attr("id");
//    if (leave === "chkAll") {
//        if ($("#chkAll").is(':checked')) {
//            $("#leavetype input[type='checkbox']").prop('checked', true);
//        }
//        else {
//            $("#leavetype input[type='checkbox']").prop('checked', false);
//        }
//        $("#leavetype input[type='checkbox']").parent().toggleClass("active");
//        //$("#boxes").toggle();
//        $("#boxes div[class*='section-']").toggle();
//    }
//    else {
//        $(this).parent().toggleClass("active");
//        $("#boxes .section-" + leave + "").toggle();
//        //var leave = $(this).attr("id");
//        //$("#boxes div[class='section-" + leave + "']").toggle();

//        var totalLeave = $(".leaveSelector").length;
//        var activeLeave = $(".active.leaveSelector").length;
//        var notActiveLeave = totalLeave - activeLeave;

//        if (totalLeave == activeLeave) {
//            $("#chkAll").prop('checked', true);
//            $("#leavetype input[id='chkAll']").parent().toggleClass("active");
//        }
//        else {
//            if (notActiveLeave == 1) {
//                $("#chkAll").prop('checked', false);
//                $("#leavetype input[id='chkAll']").parent().toggleClass("active");
//            }
//        }
        
        
//    }
//});



