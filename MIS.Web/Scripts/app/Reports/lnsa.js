//$(document).ready(function () {
//    processLnsaReport();
//});

function processReport(){
    processLnsaReport();
}

function processLnsaReport() {
    if (!validateControls('reportFilter')) {
        return false;
    }

    var departmentIds = (($('#department').val() != null && typeof $('#department').val() != 'undefined' && $('#department').val().length > 0) ? $('#department').val().join(',') : '0');
    var reportToAbrhs = (($('#reportingManager').val() != null && typeof $('#reportingManager').val() != 'undefined' && $('#reportingManager').val().length > 0) ? $('#reportingManager').val().join(',') : '0');
    var userIds = 0;
    //if ($("#employeeCode").val() === null) {
    userIds = (($('#employeeName').val() != null && typeof $('#employeeName').val() != 'undefined' && $('#employeeName').val().length > 0) ? $('#employeeName').val().join(',') : '0');
    var locationIds = (($('#location').val() !== null && typeof $('#location').val() !== 'undefined' && $('#location').val().length > 0) ? $('#location').val().join(',') : '0');
    var jsonObject = {
        fromDate: $("#fromDateEmp input").val(),
        endDate: $("#tillDateEmp input").val(),
        departmentIds: departmentIds,
        reportToAbrhs: reportToAbrhs,
        empAbrhs: userIds,
        locationIds : locationIds
    }
    calltoAjax(misApiUrl.getLnsaReport, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblLwpReportList").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'Lnsa Report',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'Lnsa Report' },
                        { extend: 'pdf', filename: 'Lnsa Report' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                        { extend: 'print', filename: 'Lnsa Report' },
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
                            return '<a href = "javascript:void(0)" title = "Click to see detail" onclick="GetLnsaReportDetailsByUserId(\'' + row.EmpAbrhs + '\', 1)">' + row.Applied + '</a>';
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Approved",
                        'bSortable': false,
                        "sClass": "text-center",
                        mRender: function (data, type, row) {
                            var html = '';
                            if (row.Approved > 0)
                                html += '<a href = "javascript:void(0)" title = "Click to see detail" onclick="GetLnsaReportDetailsByUserId(\'' + row.EmpAbrhs + '\', 2)">' + row.Approved + '</a>';
                            else
                                html += row.Approved;
                            return html;
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Pending For Approval",
                        'bSortable': false,
                        "sClass": "text-center",
                        mRender: function (data, type, row) {
                            var html = '';
                            if (row.PendingForApproval > 0)
                                html += '<a href = "javascript:void(0)" title = "Click to see detail" onclick="GetLnsaReportDetailsByUserId(\'' + row.EmpAbrhs + '\', 4)">' + row.PendingForApproval + '</a>';
                            else
                                html += row.PendingForApproval;
                            return html;
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Rejected",
                        'bSortable': false,
                        "sClass": "text-center",
                        mRender: function (data, type, row) {
                            var html = '';
                            if (row.Rejected > 0)
                                html += '<a href = "javascript:void(0)" title = "Click to see detail" onclick="GetLnsaReportDetailsByUserId(\'' + row.EmpAbrhs + '\', 3)">' + row.Rejected + '</a>';
                            else
                                html += row.Rejected;
                            return html;
                        }
                    },
                ]
            });
        });
}

function GetLnsaReportDetailsByUserId(userId, requestType) {
    var jsonObject = {
        fromDate: $("#fromDateEmp input").val(),
        endDate: $("#tillDateEmp input").val(),
        requestType: requestType,
        empAbrhs: userId,
    }
    calltoAjax(misApiUrl.getLnsaReportDetailsByUserId, "POST", jsonObject,
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
            html += "<table id='table-sm' class='table table-bordered table-hover table-sm'><tbody><tr><th>Request Date</th><th>Period</th><th>No Of Days</th><th>Reason</th><th>Status</th><tr>";
            break;
        case 2: //approved
            html += "<table id='table-sm' class='table table-bordered table-hover table-sm'><tbody><tr><th>Request Date</th><th>Period</th><th>No Of Days</th><th>Reason</th><th>Approved On</th><tr>";
            break;
        case 3: //rejected
            html += "<table id='table-sm' class='table table-bordered table-hover table-sm'><tbody><tr><th>Request Date</th><th>Period</th><th>No Of Days</th><th>Reason</th><th>Rejected By</th><th>Reason Of Rejection</th><th>Rejected On</th><tr>";
            break;
        case 4: //pending
            html += "<table id='table-sm' class='table table-bordered table-hover table-sm'><tbody><tr><th>Request Date</th><th>Period</th><th>No Of Days</th><th>Reason</th><th>Pending With</th><tr>";
            break;
    }
    for (var i = 0; i < result.length; i++) {
        switch (requestType) {
            case 1: //applied
                html += "<tr><td>" + result[i].CreatedDate + "</td><td>" + result[i].Period + "</td><td style='text-align: center;'>" + result[i].Count + "</td><td>" + result[i].ReasonOfApplication + "</td><td>" + result[i].Status + "</td><tr>";
                break;
            case 2: //approved
                html += "<tr><td>" + result[i].CreatedDate + "</td><td>" + result[i].Period + "</td><td style='text-align: center;'>" + result[i].Count + "</td><td>" + result[i].ReasonOfApplication + "</td><td>" + result[i].ModifiedDate + "</td><tr>";
                break;
            case 3: //rejected
                html += "<tr><td>" + result[i].CreatedDate + "</td><td>" + result[i].Period + "</td><td style='text-align: center;'>" + result[i].Count + "</td><td>" + result[i].ReasonOfApplication + "</td><td>" + result[i].RejectedBy + "</td><td>" + result[i].ReasonOfRejection + "</td><td>" + result[i].ModifiedDate + "</td><tr>";
                break;
            case 4: //pending
                html += "<tr><td>" + result[i].CreatedDate + "</td><td>" + result[i].Period + "</td><td style='text-align: center;'>" + result[i].Count + "</td><td>" + result[i].ReasonOfApplication + "</td><td>" + result[i].PendingWith + "</td><tr>";
                break;
            case 5: //availed

                break;
        }
    }
    html += '</tbody></table>';
    $("#popupDataShow").append(html);
}

$("#btnClosePopUp").click(function () {
    $("#mypopupShowDetailsModal").modal("hide");
});
