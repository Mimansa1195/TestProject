$(document).ready(function () {
    getActiveForms();
});

function getActiveForms() {
    $("#tblActivePolicy").empty();
    calltoAjax(misApiUrl.getAllActivePolicies, "POST", {},
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#tblActivePolicy").dataTable({
                "responsive": true,
                "autoWidth": false,
                "paging": true,
                "bDestroy": true,
                "searching": true,
                "ordering": false,
                "info": false,
                "deferRender": true,
                "aaData": resultData,
                "aoColumns": [
                    {
                        "mData": "PolicyTitle",
                        "sTitle": "Policy Name"
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        "sWidth": "100px",
                        mRender: function (data, type, row) {
                            var html = '';
                            if (misPermissions.hasViewRights === true) {
                                var extention = (row.PolicyName).split('.')[1];
                                if (extention == "pdf") {
                                    html += '<button type="button" class="btn btn-sm teal" data-toggle"model" data-target="#mypopupViewDocModal" onclick="viewDocumentInPopup(\'' + row.PolicyTitle + '\' , \'' + row.PolicyName + '\' ,' + row.PolicyId + ')" data-toggle="tooltip" title="View"><i class="fa fa-eye"> </i></button>';
                                }
                            }
                            return html;
                        }
                    },
                ]
            });
        });
}

function viewDocumentInPopup(policyTitle, policyName, policyId) {
    var extention = (policyName).split('.')[1];
    var jsonObject = {
        policyId: policyId,
    }
    calltoAjax(misApiUrl.fetchPolicyInformation, "POST", jsonObject, function (resultData) {

        if (resultData != null && resultData != '') {
            var elapsedT = Date.now();
            if (extention == "pdf") {
                $("#objViewPdf").attr("src", (misApiPoliciesUrl + resultData + "?t=" + elapsedT + '#toolbar=0&navpanes=0&scrollbar=0'));
                $("#modalTitle").html("Policy: " + policyTitle);
                $("#popupWindowViewDocument").html($("#popupWindowViewDocument").html());
                $("#viewDocumentModal").modal("show");
            }
            else {
                downloadFileFromBase64(policyTitle, resultData);
            }
        }
        else {
            misAlert('The file you have requested does not exist. Please try after some time or contact to MIS team for further assistance.', 'Oops...', 'info');
        }
    });
}