var _eligibleForLink;
$(document).ready(function () {
    getPermissionToViewAttLog();
    if (misPermissions.isDelegatable) {
        var html = '<button id="btnUserDelegation" type="button" class="btn btn-success"><i class="fa fa-bolt"></i>&nbsp;Delegate</button>';
        $("#divDeligation").html(html);
    }

    var ToDate = new Date();
    var FromDate = new Date();
    FromDate.setDate(FromDate.getDate() - 15);
    $("#fromDate input").val(toddmmyyyDatePicker(FromDate));
    $("#tillDate input").val(toddmmyyyDatePicker(ToDate));

    $('#fromDate').datepicker({
        format: "mm/dd/yyyy",
        autoclose: true,
        todayHighlight: true
    }).datepicker('setEndDate', new Date()).on('changeDate', function (ev) {
        var fromStartDate = new Date(ev.date.valueOf());
        $('#tillDate input').val('');
        $('#tillDate').datepicker('setStartDate', fromStartDate).trigger('change');
    });

    $('#tillDate').datepicker({
        format: "mm/dd/yyyy",
        autoclose: true,
        todayHighlight: true
    }).datepicker('setEndDate', new Date()).on('changeDate', function (ev) {

    });
   
    getStaffNames();
    getAttendanceRegisterForSupportingStaffMembers();
});

function getPermissionToViewAttLog() {
    calltoAjax(misApiUrl.getPermissionToViewAttendance, "POST", "",
        function (result) {
            if (result) {
                _eligibleForLink = true;
            }
            else {
                _eligibleForLink = false;
            }
        });
}

function getStaffNames() {
    $('#StaffName').empty();
    var jsonObject = {
        userAbrhs: misSession.userabrhs
    }
    calltoAjax(misApiUrl.getSupportingStaffMembers, "POST", jsonObject,
        function (result) {
            if (result !== null && result.length > 0) {
                $("#StaffName").empty();
                $("#StaffName").append("<option value='0'>All</option>");
                for (var i = 0; i < result.length ; i++) {
                    $("#StaffName").append("<option value = '" + result[i].EmployeeAbrhs + "'>" + result[i].EmployeeName + "</option>");
                }
            }
        });
}

function getAttendanceRegisterForSupportingStaffMembers() {

    var jsonObject = {
        EmpAbrhs: $("#StaffName").val() === null ? 0 : $("#StaffName").val(),
        fromDate: $("#fromDate input").val(),
        tillDate: $("#tillDate input").val(),
        userAbrhs: misSession.userabrhs
    }
    calltoAjax(misApiUrl.getAttSupportingStaff, "POST", jsonObject,
        function (result) {
            processDataForSupportingStaffMembers(result);
        });
}

function processDataForSupportingStaffMembers(result) {
    var data = $.parseJSON(JSON.stringify(result));
    $("#tblStaffAttendanceList").dataTable({
        "dom": 'lBfrtip',
        "buttons": [
         {
             filename: 'Staff Attendance',
             extend: 'collection',
             text: 'Export',
             buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'Staff Attendance' },
                        { extend: 'pdf', filename: 'Staff Attendance' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                        { extend: 'print', filename: 'Staff Attendance' },
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
                    if (_eligibleForLink)
                        html = '<a  onclick="showAttendanceLogForStaff(\'' + row.EmployeeAbrhs + '\', \'' + row.Date + '\')" style="text-decoration: underline !important;" data-toggle="tooltip" title="Show Attendance Log">' + row.Date + '</a>';
                    else
                        html = row.Date;

                    return html;
                }
            },
           
            {
                "mData": "EmployeeName",
                "sTitle": "Staff Name",
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
                    if (row.IsNightSift)
                        html += '<span class="nightShift">N</span>';

                    return html;
                }
            },
        ]
    });
}

function showAttendanceLogForStaff(empAbrhs, attendanceDate) {
    var options = {
        empAbrhs: empAbrhs,
        attendanceDate: attendanceDate
    };
    $('#modalAttendanceLogForStaff').modal('show');
    $('#modalAttendanceLogTitleForStaff').text('Punch in/out summary on: ' + attendanceDate);

    calltoAjax(misApiUrl.getPunchInOutLogForStaff, "POST", options, function (result) {
        var resultdata = $.parseJSON(JSON.stringify(result));
        var cCounter = 0;
        var nCounter = 0;
        $('#gridAttendanceLogForStaff').DataTable({
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
                //In/Out
                if (aData.Event == 1) {
                    $('td', nRow).css('background-color', '#d3fcd4');
                }
                else if (aData.Event == 0) {
                    $('td', nRow).css('background-color', '#ffdcdc');
                }
            }
        });
    }, null, function () {
        scrollToId('currentAttendance');
    });
}
$("#btnCloseForStaff").click(function () {
    $('#modalAttendanceLogForStaff').modal('hide');
});