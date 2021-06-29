$(document).ready(function () {
   
    $("#errorDate").datepicker({
        autoclose: true,
        todayHighlight: false,
        minDate: new Date(2016, 3, 1)
    }).datepicker("setDate", new Date());

    FetchErrorLogs();
})

function FetchErrorLogs() {
    if ($("#errorDate input").val() == "") {
        return false;
    }

    var jsonObject = {
        'date': toDate($("#errorDate input").val())
    };

    calltoAjax(misApiUrl.getErrorLogs, "POST", jsonObject,
        function (result) {
            var resultdata = $.parseJSON(JSON.stringify(result));
            $("#tblErrorLogs").DataTable({
                "dom": 'lBfrtip',
                "buttons": [
                 {
                     filename: 'Error Logs',
                     extend: 'collection',
                     text: 'Export',
                     buttons: [{ extend: 'copy' },
                                { extend: 'excel', filename: 'Error Logs' },
                                { extend: 'pdf', filename: 'Error Logs' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                                { extend: 'print', filename: 'Error Logs' },
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
                     {
                         "mData": null,
                         "sTitle": "Error Id",
                         'bSortable': false,
                         mRender: function (data, type, row) {
                             var html = '<a  onclick="showStackTracePopup(\'' + row.ErrorId + '\')" style="text-decoration: underline !important;" data-toggle="tooltip" title="Show Stack Trace">' + row.ErrorId + '</a>';
                             return html;
                         }
                     },
                    {
                        "mData": "ModuleName",
                        "sTitle": "Module",
                    },
                    {
                        "mData": "Source",
                        "sTitle": "Source",
                    },
                    {
                        "mData": "ControllerName",
                        "sTitle": "Controller",
                    },
                    {
                        "mData": "ActionName",
                        "sTitle": "Action",
                    },
                     {
                         "mData": "ErrorType",
                         "sTitle": "Error Type",
                     },
                    {
                        "mData": "ReportedBy",
                        "sTitle": "Reported By",
                    },
                    {
                        "mData": null,
                        "sTitle": "Log Date",
                        'bSortable': false,
                        mRender: function (data, type, row) {
                            return toddMMMYYYYHHMMSSAP(row.CreatedDate);
                        }
                    },
                ]
            });
        });
}

function showStackTracePopup(errorId) {
    $("#spnMessage").html("");
    $("#spnStackTrace").html("");
    $("#spnTargetSite").html("");
    var jsonObject = {
        errorId: errorId,
    };
    calltoAjax(misApiUrl.getStackTraceById, "POST", jsonObject,
        function (result) {
            if (result.ErrorMessage) {
                $("#spnMessage").html(result.ErrorMessage);
                $("#spnStackTrace").html(result.StackTrace);
                $("#spnTargetSite").html(result.TargetSite);
                $("#mypopupErrorLogs").modal("show");
            }
           
        });
}

$("#btnClose").click(function () {
    $("#mypopupErrorLogs").modal("hide");
});

