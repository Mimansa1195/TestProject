function processReport() {
    processLnsaCompoOffReport();
}

function processLnsaCompoOffReport() {
    if (!validateControls('reportFilter')) {
        return false;
    }

    var reportType = (($('#report').val() != null && typeof $('#report').val() != 'undefined' && $('#report').val().length > 0) ? $('#report').val() : '0');

    var jsonObject = {
        fromDate: $("#fromDateEmp input").val(),
        endDate: $("#tillDateEmp input").val(),
        report: reportType
    }

    $("#tblLwpReportList").empty();
    var columns = [
        {
            "mData": "EmpCode",
            "sTitle": "EmpCode",
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
            "mData": "Team",
            "sTitle": "Team",
        },
        {
            "mData": "ManagerName",
            "sTitle": "Manager Name",
        },       
        {
            "mData": "PendingForApproval",
            "sTitle": "Pending For Approval",
        },
    ]        

    if (reportType == "LNSA") {
        columns.push(
            {
                "mData": "Applied",
                "sTitle": "Applied LNSA",
            },
            {
                "mData": "Approved",
                "sTitle": "Approved LNSA",
            },            
            {
                "mData": "Rejected",
                "sTitle": "Rejected LNSA",
            });
    }
    else {
        columns.push(
            {
                "mData": "Applied",
                "sTitle": "Applied COff",
            },
            {
                "mData": "Approved",
                "sTitle": "Approved COff",
            },
            {
                "mData": "Rejected",
                "sTitle": "Rejected COff",
            },
            {
                "mData": "Lapsed",
                "sTitle": "Lapsed COff",
            }
        )
        }

    calltoAjax(misApiUrl.getLnsaCompOffReport, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblLwpReportList").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'Lnsa CompOff Report',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'Lnsa CompOff Report' },
                        { extend: 'pdf', filename: 'Lnsa CompOff Report' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                        { extend: 'print', filename: 'Lnsa CompOff Report' },                          
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
                "aoColumns": columns
            });
        });
}
