$(document).ready(function () {
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
    $("#fromDateEmp input").val(toddmmyyyDatePicker(FromDate));
    $("#tillDateEmp input").val(toddmmyyyDatePicker(ToDate));


    $('#fromDateEmp').datepicker({
        format: "mm/dd/yyyy",
        autoclose: true,
        todayHighlight: true
    }).datepicker('setEndDate', new Date()).on('changeDate', function (ev) {
        var fromStartDate = $('#fromDateEmp input').val();
        $('#tillDateEmp input').val('');
        $('#tillDateEmp').datepicker('setStartDate', fromStartDate).trigger('change');
    });

    $('#tillDateEmp').datepicker({
        format: "mm/dd/yyyy",
        autoclose: true,
        todayHighlight: true
    }).datepicker('setEndDate', new Date());



    //$("#fromDateEmp").datepicker({ minDate: new Date(2016, 3, 1), maxDate: new Date() }).datepicker("setDate", new Date());
    //$("#tillDateEmp").datepicker({ minDate: new Date(2016, 3, 1), maxDate: new Date() }).datepicker("setDate", new Date());
    $("#employeeName").select2();
    GetUserActivity();
    getEmployees();
});


function GetUserActivity() {
    empAbrhs = $("#employeeName").val();
    var jsonObject = {
        fromDate: $("#fromDateEmp input").val(),
        endDate: $("#tillDateEmp input").val(),
        empAbrhs: empAbrhs || 0,
        userAbrhs: misSession.userabrhs
    }
    calltoAjax(misApiUrl.getUserActivity, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblUserActivityList").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                 {
                     filename: 'User Activity List',
                     extend: 'collection',
                     text: 'Export',
                     buttons: [{ extend: 'copy' },
                                { extend: 'excel', filename: 'User Activity List' },
                                { extend: 'pdf', filename: 'User Activity List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                                { extend: 'print', filename: 'User Activity List' },
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
                        "mData": "Activity",
                        "sTitle": "Visit Activity",
                    },
                    {
                        "mData": "ByUser",
                        "sTitle": "Visited By",
                    },
                    {
                        "mData": "ForUser",
                        "sTitle": "Visited For",
                    },
                    {
                        "mData": null,
                        "sTitle": "Activity On Date",
                        mRender: function (data, type, row) {
                            return toddMMMYYYYHHMMSSAP(row.ActivityDate);
                        }
                    },
                ]
            });
        });
}

function getEmployees() {
    $("#employeeName").empty();
    calltoAjax(misApiUrl.listAllActiveUsers, "POST", '',
        function (result) {
            $("#employeeName").empty();
            $("#employeeName").append("<option value='0'>All</option>");
            if (result != null) {
                for (var i = 0; i < result.length ; i++) {
                    $("#employeeName").append("<option value = '" + result[i].EmployeeAbrhs + "'>" + result[i].EmployeeName + "</option>");
                }
            }
        });
}