var _result, _isEligibleForLink;
$(document).ready(function () {
   
    getPermissionToViewAttendance();

    //var ToDate = new Date();
    //var FromDate = new Date();
    //FromDate.setDate(FromDate.getDate());
    //$("#fromDateEmp input").val(toddmmyyyDatePicker(FromDate));
    //$("#tillDateEmp input").val(toddmmyyyDatePicker(ToDate));

    //$('#fromDateEmp').datepicker({
    //    format: "mm/dd/yyyy",
    //    autoclose: true,
    //    todayHighlight: true
    //}).datepicker('setEndDate', new Date()).on('changeDate', function (ev) {
    //    var fromStartDate = new Date(ev.date.valueOf());
    //    $('#tillDateEmp input').val('');
    //    $('#tillDateEmp').datepicker('setStartDate', new Date()).trigger('change');
    //});

    //$('#tillDateEmp').datepicker({
    //    format: "mm/dd/yyyy",
    //    autoclose: true,
    //    todayHighlight: true
    //}).datepicker('setEndDate', new Date());

    $('#fromDateEmp').datepicker({
        autoclose: true,
        todayHighlight: true
    }).datepicker('setDate', new Date());

    $('#tillDateEmp').datepicker({
        autoclose: true,
        todayHighlight: true
    }).datepicker('setDate', new Date());

    $('#fromDateEmp').datepicker({
        autoclose: true,
        todayHighlight: true
    }).datepicker('setEndDate', new Date()).on('changeDate', function (ev) {
        onFromDateChange();
    });
      
    getDepartments(0);
    //processAttendanceSummaryReport();

    $('#employeeName').multiselect({
        includeSelectAllOption: true,
        enableFiltering: true,
        enableCaseInsensitiveFiltering: true,
        buttonWidth: false,
        onDropdownHidden: function (event) {
        }
    });

    $("#reportingManager").change(function () {
        getEmployeesAccordingToSelection(1);
    });

    $('#location').change(function () {
        getEmployeesAccordingToSelection(1);
    });

    $("#btnProcessReportEmp").click(function () {
        if (!validateControls('filterDiv')) {
            return false;
        }
        processAttendanceSummaryReport();
    });
});

function onFromDateChange() {
    var fromDate = $("#fromDateEmp input").val();
    $('#tillDateEmp input').val("");
    $('#tillDateEmp').datepicker({
        autoclose: true,
        todayHighlight: true
    }).datepicker('setStartDate', fromDate).datepicker('setEndDate', new Date());
}

function getPermissionToViewAttendance() {
    calltoAjax(misApiUrl.getPermissionToViewAttendance, "POST", "",
        function (result) {
            if (result) {
                _isEligibleForLink = true;
                $("#divDepartment").show();
                $("#divReportingManager").show();
            }
            else {
                 showLoader('tblEmployeeAttendanceList', true);
                _isEligibleForLink = false;
                $("#divDepartment").hide();
                $("#divReportingManager").hide();
            }
        });
}

function getDepartments(requestFor) {
    var jsonObject = {
        'userAbrhs': misSession.userabrhs,
        'menuAbrhs': misPermissions.menuAbrhs
    };
    calltoAjax(misApiUrl.getDepartmentOnReportToBasis, "POST", jsonObject,
        function (result) {
            $('#department').multiselect("destroy");
            $('#department').empty();
            $.each(result, function (index, value) {
                $('<option selected>').val(value.UserId).text(value.UserName).appendTo('#department');
            });
            $('#department').multiselect({
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                buttonWidth: false,
                onDropdownHidden: function (event) {
                }
            });
            getReportingManagersByDepartmentId(requestFor);
        });
}
function getLocation(requestFor) {
    calltoAjax(misApiUrl.getCompanyLocation, "POST", '',
        function (result) {
            $('#location').multiselect("destroy");
            $('#location').empty();
            $.each(result, function (index, value) {
                $('<option selected>').val(value.Value).text(value.Text).appendTo('#location');
            });
            $('#location').multiselect({
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                buttonWidth: false,
                onDropdownHidden: function (event) {
                }
            });
           // $('#location').multiselect('select', [misSession.companylocationid]);
            getEmployeesAccordingToSelection(requestFor);
        });
}
function getReportingManagersByDepartmentId(requestFor) {
    var departmentIds = (($('#department').val() != null && typeof $('#department').val() != 'undefined' && $('#department').val().length > 0) ? $('#department').val().join(',') : '0');
    var jsonObject = {
        departmentIds: departmentIds,
    };
    calltoAjax(misApiUrl.getReportingManagersInADepartment, "POST", jsonObject,
        function (result) {
            $('#reportingManager').multiselect("destroy");
            $('#reportingManager').empty();
            $.each(result, function (index, value) {
                $('<option selected>').val(value.EmployeeAbrhs).text(value.Name).appendTo('#reportingManager');
            });
            
            $('#reportingManager').multiselect({
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                buttonWidth: false,
                onDropdownHidden: function (event) {
                }
            });
            getLocation(requestFor);
           
        });
}

function getEmployeesAccordingToSelection(requestFor) {
    if (!validateControls('dateDiv')) {
        return false;
    }
    var departmentIds = (($('#department').val() != null && typeof $('#department').val() != 'undefined' && $('#department').val().length > 0) ? $('#department').val().join(',') : '0');
    var reportToIds = (($('#reportingManager').val() != null && typeof $('#reportingManager').val() != 'undefined' && $('#reportingManager').val().length > 0) ? $('#reportingManager').val().join(',') : '0');
    var locationIds = (($('#location').val() !== null && typeof $('#location').val() !== 'undefined' && $('#location').val().length > 0) ? $('#location').val().join(',') : '0');

    var jsonObject = {
        departmentId: departmentIds,
        date: $("#tillDateEmp  input").val(),
        reportToAbrhs: reportToIds,
        menuAbrhs: misPermissions.menuAbrhs,
        locationIds: locationIds
    };
    calltoAjax(misApiUrl.getUsersForReports, "POST", jsonObject,
        function (result) {
            var employeeName = result.OrderedByEmployeeName;
            $('#employeeName').multiselect("destroy");
            $('#employeeName').empty();
            if (employeeName.length != 0) {
                $.each(employeeName, function (index, value) {
                    $('<option selected>').val(value.EmployeeAbrhs).text(value.Name).appendTo('#employeeName');
                });
            }
            else {
                $('<option selected>').val("0").text("No data found").appendTo('#employeeName');
            }
            $('#employeeName').multiselect({
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                buttonWidth: false,
                onDropdownHidden: function (event) {
                }
            });
            if (requestFor == 0 && !_isEligibleForLink) {
                processAttendanceSummaryReport();
            }
        });
}

//$('#employeeName').on('change', function () {
//    processAttendanceSummaryReport();
//});

function processAttendanceSummaryReport() {
    if (!validateControls('filterDiv')) {
        return false;
    }
    var departmentIds = (($('#department').val() != null && typeof $('#department').val() != 'undefined' && $('#department').val().length > 0) ? $('#department').val().join(',') : '0');
    var reportToAbrhs = (($('#reportingManager').val() != null && typeof $('#reportingManager').val() != 'undefined' && $('#reportingManager').val().length > 0) ? $('#reportingManager').val().join(',') : '0');
    var userIds = 0;
    var userIds = (($('#employeeName').val() != null && typeof $('#employeeName').val() != 'undefined' && $('#employeeName').val().length > 0) ? $('#employeeName').val().join(',') : '0');
    var locationIds = (($('#location').val() !== null && typeof $('#location').val() !== 'undefined' && $('#location').val().length > 0) ? $('#location').val().join(',') : '0');
    var jsonObject = {
        fromDate: $("#fromDateEmp input").val(),
        endDate: $("#tillDateEmp input").val(),
        departmentIds: departmentIds,
        empAbrhs: userIds,
        locationIds: locationIds,
        userAbrhs: misSession.userabrhs
    }
    calltoAjax(misApiUrl.getAttendanceForEmployees, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblEmployeeAttendanceList").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'Employee Attendance',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'Employee Attendance' },
                        { extend: 'pdf', filename: 'Employee Attendance' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                        { extend: 'print', filename: 'Employee Attendance' },
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
                        "mData": null,
                        "sTitle": "Date",
                        "sWidth": "100px",
                        //'bSortable': false,
                        mRender: function (data, type, row) {
                            var html = '';
                            if (_isEligibleForLink)
                                html = '<a  onclick="showAttendanceLog(\'' + row.EmployeeAbrhs + '\', \'' + row.Date + '\')" style="text-decoration: underline !important;" data-toggle="tooltip" title="Show Attendance Log">' + row.Date + '</a>';
                            else
                                html = row.Date;

                            return html;
                        }
                    },
                    {
                        "mData": "EmployeeName",
                        "sTitle": "Employee Name",
                    },
                    {
                        "mData": "Department",
                        "sTitle": "Department",
                    },
                    {
                        "mData": "Location",
                        "sTitle": "Location",
                    },
                    {
                        "mData": "InTime",
                        "sTitle": "In Time",
                    },
                    {
                        "mData": "OutTime",
                        "sTitle": "Out Time",
                    },
                    //{
                    //    "mData": "LoggedInHours",
                    //    "sTitle": "LoggedIn Hours",
                    //},
                    {
                        "mData": null,
                        "sTitle": "LoggedIn Hours",
                        "sWidth": "100px",
                        mRender: function (data, type, row) {
                            var html = '<span>' + row.LoggedInHours + '</span> &nbsp;';
                            if (row.IsNightSift && row.IsApproved)
                                html += '<span class="nightShift">N</span>' + '<span class="approved">A</span>';
                            else if (row.IsNightSift && row.IsPending)
                                html += '<span class="nightShift">N</span>' + '<span class="pending">P</span>';
                            return html;
                        }
                    },
                ]
            });
        });
}

function showAttendanceLog(empAbrhs, attendanceDate) {
    var options = {
        empAbrhs: empAbrhs,
        attendanceDate: attendanceDate
    };
    $('#modalAttendanceLog').modal('show');
    $('#modalAttendanceLogTitle').text('Punch in/out summary on: ' + attendanceDate);

    calltoAjax(misApiUrl.getPunchInOutLog, "POST", options, function (result) {
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
                {
                    "mData": null,
                    "sTitle": "Card Types",
                    "sWidth": "100px",
                    mRender: function (data, type, row) {
                        var html = '<a onclick="showCardDetails(\'' + row.CardDetail + '\')" >' + row.CardType + '</a>';
                        return html;
                    }
                },
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

$("#btnClose").click(function () {
    $("#note").hide();
    $("#note").html("");
    $('#modalAttendanceLog').modal('hide');
});

function showCardDetails(data) {
    $("#cardDetailModal").modal('show');
    $("#cardDetailData").html(data);
}
