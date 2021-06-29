$(document).ready(function () {
    getAllPolicies();

    $("#btnAddNewPolicy").click(function () {
        loadModal("modal-addPolicy", "modal-addPolicyContainer", misAppUrl.addPolicy, true);
    });
});

function getAllPolicies() {
    calltoAjax(misApiUrl.getAllPolicies, "POST", '',
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#tblAllPolicy").dataTable({
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
                        "mData": "Status",
                        "sTitle": "Status"
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        "sClass": "text-center",
                        mRender: function (data, type, row) {
                            var html = '<div>';
                            if (row.IsActive == true)
                                html += '<button type="button" data-toggle="tooltip" class="btn btn-sm btn-success"' + 'onclick="changePolicyStatus(' + row.PolicyId + ',2' + ')" title="DeActivate"><i class="fa fa-check" aria-hidden="true"></i></button>';
                            else
                                html += '<button type="button" data-toggle="tooltip" class="btn btn-sm btn-warning"' + 'onclick="changePolicyStatus(' + row.PolicyId + ',1' + ')" title="Activate"><i class="fa fa-times" aria-hidden="true"></i></button>';

                            html += '&nbsp;<button type="button" data-toggle="tooltip" class="btn btn-sm btn-danger"' + 'onclick="changePolicyStatus(' + row.PolicyId + ',3' + ')" title="Delete"><i class="fa fa-trash" aria-hidden="true"></i></button></div>'
                            return html;
                        }
                    },
                ]
            });
        });
}

function changePolicyStatus(policyId, status) { //status = 1:activate, 2:deactivate, 3:delete
    var jsonObject = {
        policyId: policyId,
        status: status,
        userAbrhs: misSession.userabrhs,
    }

    if (status != 1) {
        misConfirm("Are you sure you want to " + (status == 2 ? "deactive" : "delete") + " this policy?", "Confirm", function (isConfirmed) {
            if (isConfirmed) {
                calltoAjax(misApiUrl.changePolicyStatus, "POST", jsonObject,
                    function (result) {
                        var resultData = $.parseJSON(JSON.stringify(result));
                        if (resultData === true) {
                            misAlert("Policy has been " + (status == 2 ? "deactivated" : "deleted") + " successfully.", "Success", "success");
                            getAllPolicies();
                        }
                        else
                            misAlert("Unable to process your request. Try again", "Error", "error");
                    });
            }
        });
    }
    else {
        calltoAjax(misApiUrl.changePolicyStatus, "POST", jsonObject,
              function (result) {
                  var resultData = $.parseJSON(JSON.stringify(result));
                  if (resultData === true) {
                      misAlert("Policy has been added successfully", "Success", "success");
                      getAllPolicies();
                  }
                  else
                      misAlert("Unable to process your request. Try again", "Error", "error");
              });
    }
}