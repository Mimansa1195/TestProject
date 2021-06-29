$(document).ready(function () {
    bindFinancialYearForGoalReport(misSession.goalcycleid);
    bindStatusForGoalReport();
});
$("#status").on('change', function () {
    loadGoalGrid();
});
$("#financialYear").on('change', function () {
    if ($('#status').val() > 0) {
        $('#status').val(0);
        loadGoalGrid();
    }
    bindStatusForGoalReport();
});
function bindFinancialYearForGoalReport(selectedId) {
    calltoAjax(misApiUrl.getFinancialYearForTeamGoal, "POST", '',
        function (result) {
            if (result.length > 0) {
                $("#financialYear").select2();
                $("#financialYear").empty();
                $("#financialYear").append("<option value='0'>Select</option>");
                $.each(result, function (index, result) {
                    var frmyear = result.AppraisalYear - 1;
                    var endYear = result.AppraisalYear;
                    var FY = frmyear + " - " + endYear;
                    $("#financialYear").append("<option value=" + result.AppraisalCycleId + ">" + FY + "</option>");
                });
                if (selectedId > 0) {
                    $('#financialYear').val(selectedId);
                }
            }
        });
}
function bindStatusForGoalReport() {
    calltoAjax(misApiUrl.getStatusForGoalsReport, "POST", '',
        function (result) {
            if (result.length > 0) {
                $("#status").select2();
                $("#status").empty();
                $("#status").append("<option value='0'>Select</option>");
                $.each(result, function (index, result) {
                    $("#status").append("<option value=" + result.Value + ">" + result.Text + "</option>");
                });
            }
        });
}
function loadGoalGrid() {
    var jsonObject = {
        goalCycleId: $("#financialYear").val(),
        statusId: $("#status").val()
    }
    calltoAjax(misApiUrl.getGoalsForReports, "POST", jsonObject, function (result) {

        $("#tblGoalReportList").dataTable({
            "dom": 'lBfrtip',
            "buttons": [
                {
                    filename: 'Goal status report',
                    extend: 'collection',
                    text: 'Export',
                    buttons: [{ extend: 'copy' },
                    { extend: 'excel', filename: 'Goal status report' },
                    { extend: 'pdf', filename: 'Goal status report' },
                    { extend: 'print', filename: 'Goal status report' },
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
            "aaData": result,
            "aoColumns": [
                {
                    "mData": "Name",
                    "sTitle": "Employee Name",
                },
                {
                    "mData": "Manager",
                    "sTitle": "Reporting Manager"
                },
                {
                    "mData": "Team",
                    "sTitle": "Team"
                },
                {
                    "mData": "Department",
                    "sTitle": "Department"
                },
                {
                    "mData": "Division",
                    "sTitle": "Division"
                },
            ]
        });
    });
}