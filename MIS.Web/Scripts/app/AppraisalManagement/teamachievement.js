$(document).ready(function () {
    bindDepartmentalForms();
    bindAllUserForms(0);

    $("#departmentalForm").change(function () {
        bindAllUserForms($("#departmentalForm").val());
    });

    $("#downloadAllForm").click(function () {
        downloadAllUserForms($("#departmentalForm").val());
    });
});

function bindDepartmentalForms() {
    var jsonObject = {
        departmentAbrhs: "0" //bind all departments forms
    };
    $("#departmentalForm").select2();
    $("#departmentalForm").empty();
    $("#departmentalForm").append("<option value='0'>All</option>");
    calltoAjax(misApiUrl.getAllActiveForms, "POST", jsonObject,
        function (result) {
            if (result != null)
                $.each(result, function (index, item) {
                    $("#departmentalForm").append("<option value = '" + item.FormId + "' >" + item.FormTitle + "</option>");
                });
        });
}

function bindAllUserForms(formId) {
    var jsonObject = {
        formId: formId
    };
    calltoAjax(misApiUrl.getAllUserForms, "POST", jsonObject, function (result) {
        var resultData = $.parseJSON(JSON.stringify(result));
        $("#tblTeamForms").dataTable({
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
                    "mData": "EmployeeName",
                    "sTitle": "Employee Name",
                    "sWidth": "150px",
                },
                {
                    "mData": "ActualFormName",
                    "sTitle": "Form Type",
                },
                {
                    "mData": "UsersFormName",
                    "sTitle": "Employee Form",
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
                    "sWidth": "100px",
                    mRender: function (data, type, row) {
                        var html = '';
                        if (misPermissions.hasViewRights === true) {
                            var extention = getFileExtension(row.UsersFormName);
                            html += '<button type="button" class="btn btn-sm teal" onclick="fetchUserForm(\'' + row.UsersFormName + '\' ,\'' + row.UserFormAbrhs + '\')" data-toggle="tooltip" title="Download"><i class="fa fa-download"> </i></button>';
                            if (extention == "pdf") {
                                html += '&nbsp; <button type="button" class="btn btn-sm teal" data-toggle"model" data-target="#mypopupViewDocModal" onclick="viewDocumentInPopup(\'' + row.UsersFormName + '\' ,\'' + row.UserFormAbrhs + '\')" data-toggle="tooltip" title="View"><i class="fa fa-eye"> </i></button>';
                            }
                        }
                        return html;
                    }
                },
            ]
        });
    });
}

function fetchUserForm(userFormName, formAbrhs) {
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

function viewDocumentInPopup(userFormName, formAbrhs) {
    var extention = getFileExtension(userFormName);
    var jsonObject = {
        userFormAbrhs: formAbrhs,
    }
    calltoAjax(misApiUrl.fetchUserForm, "POST", jsonObject,
        function (resultData) {
            if (resultData != null && resultData != '') {
                if (extention == "pdf") {
                    $("#objViewPdf").attr("data", resultData);

                    $("#modalTitle").html(trimExtension(userFormName));
                    $("#viewDocumentModal").modal("show");
                }
                else {
                    downloadFileFromBase64(userFormName, resultData);
                }
            }
            else {
                misAlert('The file you have requested does not exist. Please try after some time or contact to MIS team for further assistance.', 'Oops...', 'info');
            }
        });
}

function downloadAllUserForms(formId) {
    var jsonObject = {
        formId: formId
    };
    calltoAjax(misApiUrl.fetchAllUserForms, "POST", jsonObject, function (result) {
        var resultData = $.parseJSON(JSON.stringify(result));
        if (resultData != null && resultData != '') {
            downloadFileFromBase64(userFormName, resultData);
        }
        else {
            misAlert('The file you have requested does not exist. Please try after some time or contact to MIS team for further assistance.', 'Oops...', 'info');

        }
    }); //, function () { }, function () { }, 'application/octet-stream');
}