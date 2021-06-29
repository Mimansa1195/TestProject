$(document).ready(function () {
    bindAllMyForms();

    $("#uploadForm").click(function () {
        loadModal("modal-uploadMyForm", "modal-uploadMyFormContainer", misAppUrl.uploadMyForm, true);
    });
});

function bindAllMyForms() {
    calltoAjax(misApiUrl.getAllMyForms, "GET", '',
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#tblMyForms").dataTable({
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
                        "mData": "ActualFormName",
                        "sTitle": "Form",
                    },
                    {
                        "mData": "UsersFormName",
                        "sTitle": "My Form",
                    },
                    {
                        "mData": "Status",
                        "sTitle": "Status",
                    },
                    {
                        "mData": null,
                        "sTitle": "Uploaded On",
                        "sWidth": "100px",
                        mRender: function (data, type, row) {
                            return toddMMMYYYYHHMMSSAP(row.CreatedDate);
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        "sClass": "text-center",
                        "sWidth": "90px",
                        mRender: function (data, type, row) {
                            var html = '<div>';
                            if (row.IsActive == true)
                                html += '<button type="button" data-toggle="tooltip" class="btn btn-sm btn-success"' + 'onclick="changeMyFormStatus(\'' + row.UserFormAbrhs + '\',2' + ')" title="DeActivate"><i class="fa fa-check" aria-hidden="true"></i></button>';
                            //else
                            //    html += '<button type="button" data-toggle="tooltip" class="btn btn-sm btn-warning"' + 'onclick="changeMyFormStatus(\'' + row.UserFormAbrhs + '\',1' + ')" title="Activate"><i class="fa fa-times" aria-hidden="true"></i></button>';

                            //html += '&nbsp;<button type="button" data-toggle="tooltip" class="btn btn-sm btn-danger"' + 'onclick="changeMyFormStatus(\'' + row.UserFormAbrhs + '\',3' + ')" title="Delete"><i class="fa fa-trash" aria-hidden="true"></i></button></div>'

                            if (misPermissions.hasViewRights === true) {
                                var extention = getFileExtension(row.UsersFormName);
                                html += '&nbsp;<button type="button" class="btn btn-sm teal" onclick="fetchFormInformation(\'' + row.UsersFormName + '\' ,\'' + row.UserFormAbrhs + '\')" data-toggle="tooltip" title="Download"><i class="fa fa-download"> </i></button>';
                                if (extention == "pdf") {
                                    html += '&nbsp;<button type="button" class="btn btn-sm teal" onclick="viewDocumentInPopup(\'' + row.ActualFormName + '\' , \'' + row.UsersFormName + '\' ,' + row.FormId + ')" data-toggle="tooltip" title="View"><i class="fa fa-eye"> </i></button>';
                                    //html += '&nbsp;<button type="button" class="btn btn-sm teal" data-toggle"model" data-target="#mypopupViewDocModal" onclick="viewDocumentInPopup(\'' + row.UsersFormName + '\' ,\'' + row.UserFormAbrhs + '\')" data-toggle="tooltip" title="View"><i class="fa fa-eye"> </i></button>';
                                }
                            }
                            return html;
                        }
                    },
                ]
            });
        });
}

//status = 1:activate, 2:deactivate, 3:delete
function changeMyFormStatus(formAbrhs, status) {
    var jsonObject = {
        userFormAbrhs: formAbrhs,
        status: status
    }

    if (status != 1) {
        misConfirm("Are you sure you want to " + (status == 2 ? "deactive" : "delete") + " this form?", "Confirm", function (isConfirmed) {
            if (isConfirmed) {
                calltoAjax(misApiUrl.changeMyFormStatus, "POST", jsonObject,
                    function (result) {
                        var resultData = $.parseJSON(JSON.stringify(result));
                        if (resultData) {
                            misAlert("Your form has been " + (status == 2 ? "deactivated" : "deleted") + " successfully.", "Success", "success");
                            bindAllMyForms();
                        }
                        else
                        misAlert('Your request cannot be processed, please try after some time or contact to MIS team for further assistance.', 'Error', 'error');
                    });
            }
        });
    }
    else {
        calltoAjax(misApiUrl.changeMyFormStatus, "POST", jsonObject,
              function (result) {
                  var resultData = $.parseJSON(JSON.stringify(result));
                  if (resultData) {
                      misAlert("Your form has been activated successfully", "Success", "success");
                      bindAllMyForms();
                  }
                  else
                      misAlert('Your request cannot be processed, please try after some time or contact to MIS team for further assistance.', 'Error', 'error');
              });
    }
}

function fetchFormInformation(userFormName, formAbrhs) {
    var jsonObject = {
        userFormAbrhs: formAbrhs,
    }
    calltoAjax(misApiUrl.fetchUserForm, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            if (resultData != null && resultData != '') {
                downloadFileFromBase64(userFormName, resultData);
            }
            else {
                misAlert('The file you have requested does not exist. Please try after some time or contact to MIS team for further assistance.', 'Oops...', 'info');

            }
        });
}

function viewDocumentInPopup(formTitle, formName, formId) {
    var extention = getFileExtension(formName);
    var jsonObject = {
        formId: formId,
    }
    calltoAjax(misApiUrl.fetchFormInformation, "POST", jsonObject, function (resultData) {
        if (resultData != null && resultData != '') {
            if (extention == "pdf") {
                $("#objViewPdf").attr("data", resultData);
                $("#modalTitle").html(formTitle);
                $("#viewDocumentModal").modal("show");
            }
            else {
                downloadFileFromBase64(formTitle, resultData);
            }
        }
        else {
            misAlert('The file you have requested does not exist. Please try after some time or contact to MIS team for further assistance.', 'Oops...', 'info');
        }
    });
}