$(document).ready(function () {
    getAllForms();
});

function getAllForms() {
    calltoAjax(misApiUrl.getAllForms, "POST", '',
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#tblAllForm").dataTable({
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
                        "mData": "FormTitle",
                        "sTitle": "Form Name",
                    },
                    {
                        "mData": "DepartmentName",
                        "sTitle": "Department",
                    },
                    {
                        "mData": "Status",
                        "sTitle": "Status",
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        "sClass": "text-center",
                        mRender: function (data, type, row) {
                            var html = '<div>';
                            if (row.IsActive == true)
                                html += '<button type="button" data-toggle="tooltip" class="btn btn-sm btn-success"' + 'onclick="changeFormStatus(' + row.FormId + ',2' + ')" title="DeActivate"><i class="fa fa-check" aria-hidden="true"></i></button>';
                            else
                                html += '<button type="button" data-toggle="tooltip" class="btn btn-sm btn-warning"' + 'onclick="changeFormStatus(' + row.FormId + ',1' + ')" title="Activate"><i class="fa fa-times" aria-hidden="true"></i></button>';

                            html += '&nbsp;<button type="button" data-toggle="tooltip" class="btn btn-sm btn-danger"' + 'onclick="changeFormStatus(' + row.FormId + ',3' + ')" title="Delete"><i class="fa fa-trash" aria-hidden="true"></i></button></div>'
                            return html;
                        }
                    },
                ]
            });
        });
}

function changeFormStatus(formId, status) { //status = 1:activate, 2:deactivate, 3:delete
    var jsonObject = {
        formId: formId,
        status: status,
        userAbrhs: misSession.userabrhs,
    }

    if (status != 1) {
        misConfirm("Are you sure you want to " + (status == 2 ? "deactive" : "delete") + " this form?", "Confirm", function (isConfirmed) {
            if (isConfirmed) {
                calltoAjax(misApiUrl.changeFormStatus, "POST", jsonObject,
                    function (result) {
                        var resultData = $.parseJSON(JSON.stringify(result));
                        if (resultData) {
                            misAlert("Form has been " + (status == 2 ? "deactivated" : "deleted") + " successfully.", "Success", "success");
                            getAllForms();
                        }
                        else
                            misAlert("Unable to process your request. Try again", "Error", "error");
                    });
            }
        });
    }
    else {
        calltoAjax(misApiUrl.changeFormStatus, "POST", jsonObject,
              function (result) {
                  var resultData = $.parseJSON(JSON.stringify(result));
                  if (resultData) {
                      misAlert("Form has been activated successfully", "Success", "success");
                      getAllForms();
                  }
                  else
                      misAlert("Unable to process your request. Try again", "Error", "error");
              });
    }
}

function addNewForm() {
    loadModal("modal-addForm", "modal-addFormContainer", misAppUrl.addForm, true);
}