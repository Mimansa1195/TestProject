var currentDate = toddmmyyyDatePicker(new Date());
$(function () {
    var ToDate = new Date();
    var FromDate = new Date();
    $("#logFromDate input").val(toddmmyyyDatePicker(FromDate));
    $("#logTillDate input").val(toddmmyyyDatePicker(ToDate));


    $('#logFromDate').datepicker({
        format: "mm/dd/yyyy",
        autoclose: true,
    }).datepicker('setEndDate', new Date()).on('changeDate', function (ev) {
        var fromStartDate = new Date(ev.date.valueOf());
        $('#logTillDate input').val('');
        $('#logTillDate').datepicker('setStartDate', fromStartDate).trigger('change');
    });

    $('#logTillDate').datepicker({
        format: "mm/dd/yyyy",
        autoclose: true,
    }).datepicker('setStartDate', new Date()).datepicker('setEndDate', new Date()).on('changeDate', function (ev) {});

    bindEmployees();
    bindUserActivityLogs('', currentDate, currentDate);

    $('#btnSearch').click(function () {
        bindUserActivityLogs($('#employees').val(), $('#logFromDate input').val(), $('#logTillDate input').val());
    });

    $("#employees").select2();
});

function bindEmployees() {
    $("#employees").empty();
    var jsonObject = {
        userAbrhs: misSession.userabrhs
    }
    calltoAjax(misApiUrl.listAllActiveUsers, "POST", jsonObject,
        function (result) {
            var employees = result;
            $("#employees").empty();
            $("#employees").append("<option value=''>All</option>");

            if (employees != null) {
                for (var i = 0; i < employees.length ; i++) {
                    $("#employees").append("<option value = '" + employees[i].EmployeeAbrhs + "'>" + employees[i].EmployeeName + "</option>");
                }
            }
        });
}

function bindUserActivityLogs(empAbrhs, fDate, tDate) {
    if (!validateControls('logContainer')) {
        return false;
    }

    var jsonObject = {
        employeeAbrhs: empAbrhs,
        fromDate: fDate || currentDate,
        toDate: tDate || currentDate
    };

    calltoAjax(misApiUrl.getUserActivityLogs, "POST", jsonObject,
    function (result) {
        var resultdata = $.parseJSON(JSON.stringify(result));
        $("#userActivityLogsGrid").dataTable({
            "dom": 'lBfrtip',
            "buttons": [
             {
                 filename: 'User Activity Logs List',
                 extend: 'collection',
                 text: 'Export',
                 buttons: [{ extend: 'copy' },
                            { extend: 'excel', filename: 'User Activity Logs List' },
                            { extend: 'pdf', filename: 'User Activity Logs List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                            { extend: 'print', filename: 'User Activity Logs List' },
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
            "aaData": resultdata,
            "aoColumns": [
                //{ "mData": "UserActivityLogId", "sTitle": "User Name" },
                //{ "mData": "EmployeeAbrhs", "sTitle": "User Name" },
                { "mData": "UserName", "sTitle": "User Name" },
                {
                    "mData": null,
                    "sTitle": "Login Time",
                    "sClass": "text-center",
                    mRender: function (data, type, row) {
                        return toddMMMYYYYHHMMSSAP(row.LoginTime);
                    }
                },
                { "mData": "IPAddress", "sTitle": "IP Address" },
                { "mData": "ISP", "sTitle": "ISP" },
                { "mData": "City", "sTitle": "City" },
                { "mData": "Device", "sTitle": "Device" },
                //{ "mData": "BrowserInfo", "sTitle": "Browser" },
                //{ "mData": "ActivityStatus", "sTitle": "Status" },
                {
                    "mData": null,
                    "sTitle": "Status",
                    mRender: function (data, type, row) {
                        if (row.ActivityStatus.toLowerCase() === 'success') {
                            return '<span class="label label-success">' + row.ActivityStatus + '</span>';
                        }
                        else {
                            return '<span class="label label-danger">' + row.ActivityStatus + '</span>';
                        }
                    }
                },
                //{ "mData": "ActivityDetail", "sTitle": "Activity Detail" },
                //{ "mData": "ClientInfo", "sTitle": "ClientInfo" },
                //{ "mData": "Country", "sTitle": "Country" },
                //{ "mData": "Latitude", "sTitle": "Latitude" },
                //{ "mData": "Longitude", "sTitle": "Longitude" },
                //{ "mData": "TimeZone", "sTitle": "Time Zone" },
                {
                    "mData": null,
                    "sTitle": "Action",
                    "sWidth": "60px",
                    'bSortable': false,
                    mRender: function (data, type, row) {
                        var html = '';
                        if (misPermissions.hasViewRights === true) {
                            if (row.ClientInfo && row.ClientInfo != 'null') {
                            var cInfo = $.parseJSON(row.ClientInfo);
                                html += '<button type="button" class="btn btn-sm teal" onclick=\'viewUserLocation("' +
                                row.UserName + '", "'
                                + row.BrowserInfo + '", "'
                                + row.ActivityStatus + '", "'
                                + row.ActivityDetail + '", "'
                                + row.LoginTime + '", "'
                                + cInfo.device + '", "'
                                + cInfo.isp + '", "'
                                + cInfo.as + '", "'
                                + cInfo.city + '", "'
                                + cInfo.country + '", "'
                                + cInfo.lat + '", "'
                                + cInfo.lon + '", "'
                                + cInfo.query + '", "'
                                + cInfo.regionName + '", "'
                                + cInfo.timezone + '", "'
                                + cInfo.zip + '")\' data-toggle="tooltip" title="View user location"><i class="fa fa-map-marker"></i></button>';
                            }
                            else {
                                var html = 'NA';
                            }
                        }
                        return html;
                    }
                }
            ]
        });
    });
}

function viewUserLocation(name, browser, status, activityDetail, loginTime, device, isp, ispAs, city, country, lat, long, ip, region, timeZone, zip) {
    $('#userLocationModal').addHiddenInputData({
        "hdnName": name,
        "hdnBrowser": browser,
        "hdnStatus": status,
        "hdnActivityDetail": activityDetail,
        "hdnLoginTime": loginTime,
        "hdnDevice": device,
        "hdnISP": isp,
        "hdnISPAs": ispAs,
        "hdnCity": city,
        "hdnCountry": country,
        "hdnIP": ip,
        "hdnRegion": region,
        "hdnTimeZone": timeZone,
        "hdnZip": zip,
        "hdnLat": lat,
        "hdnLong": long
    });
    loadModal("userLocationModal", "userLocationModalContainer", misAppUrl.viewUserLocation, true);
}