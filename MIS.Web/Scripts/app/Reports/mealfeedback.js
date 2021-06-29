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
    $("#fromDate input").val(toddmmyyyDatePicker(FromDate));
    $("#tillDate input").val(toddmmyyyDatePicker(ToDate));


    $('#fromDate').datepicker({
        format: "mm/dd/yyyy",
        autoclose: true,
        todayHighlight: true
    }).datepicker('setEndDate', new Date()).on('changeDate', function (ev) {
        var fromStartDate = $('#fromDate input').val();
        $('#tillDate input').val('');
        $('#tillDate').datepicker('setStartDate', fromStartDate).trigger('change');
    });

    $('#tillDate').datepicker({
        format: "mm/dd/yyyy",
        autoclose: true,
        todayHighlight: true
    }).datepicker('setEndDate', new Date());


    //$("#fromDate").datepicker("setDate", new Date());
    //$("#tillDate").datepicker("setDate", new Date());
});

$("#btnMealMenu").click(function () {
    bindMealFeedbackData();
});

function bindMealFeedbackData() {
    var jsonObject = {
        fromDate: $("#fromDate input").val(),
        endDate: $("#tillDate input").val(),
        userAbrhs: misSession.userabrhs,
    }
    calltoAjax(misApiUrl.getMealFeedbackData, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblMealFeedback").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                 {
                     filename: 'Meal Feedback List',
                     extend: 'collection',
                     text: 'Export',
                     buttons: [{ extend: 'copy' },
                                { extend: 'excel', filename: 'Meal Feedback List' },
                                { extend: 'pdf', filename: 'Meal Feedback List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                                { extend: 'print', filename: 'Meal Feedback List' },
                     ]
                 }
                ],
                "responsive": true,
                "autoWidth": false,
                "paging": true,
                "bDestroy": true,
                "searching": true,
                "ordering": false,
                "info": false,
                "deferRender": true,
                "aaData": data,
                "aoColumns": [
                    {
                        "mData": "MealPackages",
                        "sTitle": "Meal Packages",
                    },
                    {
                         "mData": null,
                         "sTitle": "Like",
                         'bSortable': false,
                         mRender: function (data, type, row) {
                             if (row.IsLike) {
                                 return 'Good';
                             }
                             else {
                                 return 'Not Good';
                             }
                         }
                    },
                    {
                        "mData": "Comment",
                        "sTitle": "Comment",
                    },
                    {
                        "mData": "FeedbackBy",
                        "sTitle": "Feedback By",
                    },
                    {
                        "mData": "FeedbackDate",
                        "sTitle": "Feedback Date",
                    },
                ]
            });
        });
}
