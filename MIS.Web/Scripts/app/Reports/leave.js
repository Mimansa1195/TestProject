//$(document).ready(function () {
//    processLeaveReport();
//});

function processReport() {
    processLeaveReport();
}

function processLeaveReport() {
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
    calltoAjax(misApiUrl.getLeaveReport, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblLeaveReportList").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'Leave Report',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'Leave Report' },
                        { extend: 'pdf', filename: 'Leave Report' },
                        { extend: 'print', filename: 'Leave Report' },
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
                        "mData": "PresentDays",
                        "sTitle": "PresentDays",
                    },
                    {
                        "mData": "WFH",
                        "sTitle": "WFH",
                    },
                    {
                        "mData": "CL",
                        "sTitle": "CL",
                    },

                    {
                        "mData": "PL",
                        "sTitle": "PL",
                    },
                    {
                        "mData": "LWP",
                        "sTitle": "LWP",
                    },
                    {
                        "mData": "COFF",
                        "sTitle": "COFF",
                    },
                ]
            });
        });
}

