$(document).ready(function () {
    getAllUserFeedback();
});

function getAllUserFeedback() {
    var jsonObject = {
        userAbrhs: misSession.userabrhs,
    }
    calltoAjax(misApiUrl.fetchAllFeedbackByUserId, "POST", jsonObject,
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
                                { extend: 'excel', filename: 'All Feedback List' },
                                { extend: 'pdf', filename: 'All Feedback List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                                { extend: 'print', filename: 'All Feedback List' },
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
                        "mData": null,
                        "sTitle": "View",
                        'bSortable': false,
                        "sClass": "text-center",
                        mRender: function (data, type, row) {
                            var html = '<div>';
                            html += '<button type="button" data-toggle="tooltip" title="View"  class="btn btn-sm btn-success"' + 'onclick="openPopupViewFeedback(' + row.FeedbackId + ')"><i class="fa fa-eye" aria-hidden="true"></i></button>&nbsp;';
                            return html;
                        }
                    },
                ]
            });
        });
}

function openPopupViewFeedback(feedbackId) {
    $("#modal-feedback").modal('show');

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

function openPopupSubmitFeedback() {
    $("#modal-submitFeedback").modal('show');
    $("#feedback").val('');
}

function submitFeedback()
{
    if (!validateControls('submitFeedback'))
        return false;

    var jsonObject = {
        remarks: $("#feedback").val(),
        userAbrhs: misSession.userabrhs,
    }
    calltoAjax(misApiUrl.submitFeedback, "POST", jsonObject,
        function (result) {
            if (result) {                
                misAlert("Request processed successfully", "Success", "success");
                $("#modal-submitFeedback").modal('hide');
                getAllUserFeedback();
            }
            else
                misAlert("Unable to process request. Try again", "Error", "error");
        });
}

$("#btnClose").click(function () {
    $("#modal-feedback").modal('hide');
});

$(".btnClose").click(function () {
    $("#modal-feedback").modal('hide');
    $("#modal-submitFeedback").modal('hide');
});