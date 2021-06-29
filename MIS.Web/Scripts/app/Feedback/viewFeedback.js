$(document).ready(function () {
    getAllFeedback();
});

function getAllFeedback() {
    calltoAjax(misApiUrl.fetchAllFeedbacks, "POST", '',
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#tblFeedback").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                 {
                     filename: 'All Feedback List',
                     extend: 'collection',
                     text: 'Export',
                     buttons: [{ extend: 'copy' },
                                {
                                    extend: 'excel', filename: 'All Feedback List', exportOptions: {
                                        columns: [0, 1, 2,3]
                                    }
                                },
                                {
                                    extend: 'pdf', filename: 'All Feedback List', exportOptions: {
                                        columns: [0, 1, 2,3]
                                    }
                                }, //, orientation: 'landscape', pageSize: 'LEGAL',
                                {
                                    extend: 'print', filename: 'All Feedback List', exportOptions: {
                                        columns: [0, 1, 2,3]
                                    }
                                },
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
                "aaData": resultData,
                "aoColumns": [
                    {
                        "mData": "Remarks",
                        "sTitle": "Feedback",
                    },
                    {
                        "mData": "EmployeeName",
                        "sTitle": "Employee Name",
                    },
                    {
                        "mData": null,
                        "sTitle": "Status",
                        'bSortable': false,
                        "sClass": "text-center",
                        mRender: function (data, type, row) {
                            var html = '<div>';
                            if (row.IsAcknowledged)
                                html += 'Acknowledged</div>';
                            else
                                html += 'Unacknowledged</div>'
                            return html;
                        }
                    },
                    {
                        "mData": "DisplayCreatedDate",
                        "sTitle": "Submitted On",
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        "sClass": "text-center",
                        mRender: function (data, type, row) {
                            var html = '<div>';
                            html += '<button type="button" data-toggle="tooltip" title="View"  class="btn btn-sm btn-success"' + 'onclick="openPopupViewFeedback(' + row.FeedbackId + ')"><i class="fa fa-eye" aria-hidden="true"></i></button>&nbsp;';
                            if (!row.IsAcknowledged)
                                html += '<button type="button" data-toggle="tooltip" class="btn btn-sm btn-success"' + 'onclick="openPopupAcknowledgeFeedback(' + row.FeedbackId + ')" title="Acknowledge"><i class="fa fa-check" aria-hidden="true"></i></button>';
                            return html;
                        }
                    },
                ]
            });
        });
}

function openPopupViewFeedback(feedbackId) {
    $("#modal-feedback").modal('show');
    $("#btnAcknowledgeFeedback").hide();    

    var jsonObject = {
        feedbackId: feedbackId,
    }
    calltoAjax(misApiUrl.fetchFeedbackById, "POST", jsonObject,
        function (result) {            
            $("#employeeName").val(result.EmployeeName);
            $("#createdDate").val(result.DisplayCreatedDate);
            $("#acknowledgedBy").val(result.AcknowledgedBy);
            $("#feedbackMessage").val(result.Remarks);
        });
}

function openPopupAcknowledgeFeedback(feedbackId) {
    $("#modal-feedback").modal('show');
    $("#btnAcknowledgeFeedback").show();
    $("#hdnFeedbackId").val(feedbackId);

    var jsonObject = {
        feedbackId: feedbackId,
    }
    calltoAjax(misApiUrl.fetchFeedbackById, "POST", jsonObject,
        function (result) {
            $("#employeeName").val(result.EmployeeName);
            $("#createdDate").val(result.DisplayCreatedDate);
            $("#acknowledgedBy").val(result.AcknowledgedBy);
            $("#feedbackMessage").val(result.Remarks);
        });
}


function acknowledgeFeedback() {
    var reply = misConfirm("Please make sure you read the feedback before you acknowledge it", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                feedbackId: $("#hdnFeedbackId").val(),
                userAbrhs: misSession.userabrhs,
            }
            calltoAjax(misApiUrl.acknowledgeFeedback, "POST", jsonObject,
                function (result) {
                    if (result) {
                        $("#modal-feedback").modal('hide');
                        misAlert("Request processed successfully", "Success", "success");
                        getAllFeedback();
                    }
                    else
                        misAlert("Unable to process request. Try again", "Error", "error");
                });
        }
    });
}

$("#btnClose").click(function () {
    $("#modal-feedback").modal('hide');
});