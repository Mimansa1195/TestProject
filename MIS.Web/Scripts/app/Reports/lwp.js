//$(document).ready(function () {
//    processLWPReport();
//});
function processReport() {
    processLWPReport();
}

function processLWPReport() {
    if (!validateControls('reportFilter')) {
        return false;
    }
    var departmentIds = (($('#department').val() != null && typeof $('#department').val() != 'undefined' && $('#department').val().length > 0) ? $('#department').val().join(',') : '0');
    var reportToAbrhs = (($('#reportingManager').val() != null && typeof $('#reportingManager').val() != 'undefined' && $('#reportingManager').val().length > 0) ? $('#reportingManager').val().join(',') : '0');
    var userIds = 0;
    //if ($("#employeeCode").val() === 0) {
        userIds = (($('#employeeName').val() != null && typeof $('#employeeName').val() != 'undefined' && $('#employeeName').val().length > 0) ? $('#employeeName').val().join(',') : '0');
    //} else {
    //    userIds = (($('#employeeCode').val() != null && typeof $('#employeeCode').val() != 'undefined' && $('#employeeCode').val().length > 0) ? $('#employeeCode').val().join(',') : '0');
    //}
    var locationIds = (($('#location').val() !== null && typeof $('#location').val() !== 'undefined' && $('#location').val().length > 0) ? $('#location').val().join(',') : '0');
    var jsonObject = {
        fromDate: $("#fromDateEmp input").val(),
        endDate: $("#tillDateEmp input").val(),
        departmentIds: departmentIds,
        reportToAbrhs: reportToAbrhs,
        empAbrhs: userIds,
        locationIds: locationIds
    }
    calltoAjax(misApiUrl.getLwpReport, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblLwpReportList").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                 {
                     filename: 'Lwp Report',
                     extend: 'collection',
                     text: 'Export',
                     buttons: [{ extend: 'copy' },
                                { extend: 'excel', filename: 'Lwp Report' },
                                { extend: 'pdf', filename: 'Lwp Report' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                                { extend: 'print', filename: 'Lwp Report' },
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
                        "mData": "EmpCode",
                        "sTitle": "Emp. Code",
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
                         "mData": "ManagerName",
                         "sTitle": "Manager Name",
                    },
                     {
                         "mData": "Location",
                         "sTitle": "Location",
                     },
                      {
                          "mData": null,
                          "sTitle": "Applied",
                          'bSortable': false,
                          "sClass": "text-center",
                          mRender: function (data, type, row) {
                              return '<a href = "javascript:void(0)" title = "Click to see detail" onclick="GetLwpReportDetailsByUserId(\'' + row.EmpAbrhs + '\', 1)">' + row.Applied + '</a>';
                          }
                      },
                     {
                         "mData": null,
                         "sTitle": "Cancelled",
                         'bSortable': false,
                         "sClass": "text-center",
                         mRender: function (data, type, row) {
                             var html = '';
                             if (row.Cancelled > 0)
                                 html += '<a href = "javascript:void(0)" title = "Click to see detail" onclick="GetLwpReportDetailsByUserId(\'' + row.EmpAbrhs + '\', 2)">' + row.Cancelled + '</a>';
                             else
                                 html += row.Cancelled;
                             return html;
                         }
                     },
                     {
                         "mData": null,
                         "sTitle": "Availed",
                         'bSortable': false,
                         "sClass": "text-center",
                         mRender: function (data, type, row) {
                             var html = '';
                             if (row.Availed > 0)
                                 html += '<a href = "javascript:void(0)" title = "Click to see detail" onclick="GetLwpReportDetailsByUserId(\'' + row.EmpAbrhs + '\', 3)">' + row.Availed + '</a>';
                             else
                                 html += row.Availed;
                             return html;
                         }
                     },
                ]
            });
        });
}

function GetLwpReportDetailsByUserId(userId, requestType) {
    var jsonObject = {
        fromDate: $("#fromDateEmp input").val(),
        endDate: $("#tillDateEmp input").val(),
        requestType: requestType,
        empAbrhs: userId,
    }
    calltoAjax(misApiUrl.getLwpReportDetailsByUserId, "POST", jsonObject,
        function (result) {
            $("#mypopupShowDetailsModal").modal("show");
            bindPopupData(result, requestType);
        });
}



function bindPopupData(result, requestType) {
    $("#popupDataShow").empty();
    var html = "";
    //alert(result.length);
    switch (requestType) {
        case 1: //applied
            html += "<table id='table-sm' class='table table-bordered table-hover table-sm'><tbody><tr><th>Request Date</th><th>Date</th><th>No Of Days</th><th>Reason</th><th>Status</th><tr>";
            break;
        case 2: //cancelled
            html += "<table id='table-sm' class='table table-bordered table-hover table-sm'><tbody><tr><th>Request Date</th><th>Date</th><th>No Of Days</th><th>Reason</th><th>Cancelled On</th><tr>";
            break;
        case 3: //availed
            html += "<table id='table-sm' class='table table-bordered table-hover table-sm'><tbody><tr><th>Request Date</th><th>Date</th><th>No Of Days</th><th>Reason</th><tr>";
            break;
    }
    for (var i = 0; i < result.length; i++) {
        switch (requestType) {
            case 1: //applied
                html += "<tr><td>" + result[i].CreatedDate + "</td><td>" + result[i].Period + "</td><td style='text-align: center;'>" + result[i].Count + "</td><td>" + result[i].ReasonOfApplication + "</td><td>" + result[i].Status + "</td><tr>";
                break;
            case 2: //cancelled
                html += "<tr><td>" + result[i].CreatedDate + "</td><td>" + result[i].Period + "</td><td style='text-align: center;'>" + result[i].Count + "</td><td>" + result[i].ReasonOfApplication + "</td><td>" + result[i].ModifiedDate + "</td><tr>";
                break;
            case 3: //availed
                html += "<tr><td>" + result[i].CreatedDate + "</td><td>" + result[i].Period + "</td><td style='text-align: center;'>" + result[i].Count + "</td><td>" + result[i].ReasonOfApplication + "</td><tr>";
                break;
        }
    }
    html += '</tbody></table>';
    $("#popupDataShow").append(html);
}

$("#btnClosePopUp").click(function () {
    $("#mypopupShowDetailsModal").modal("hide");
});
