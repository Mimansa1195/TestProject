$(document).ready(function () {
    $("#formDepartment").select2();
    $("#formDepartment").empty();
    $("#formDepartment").append("<option value='0'>All</option>");
    calltoAjax(misApiUrl.getDepartments, "POST", '',
        function (result) {
            if (result != null)
                $.each(result, function (index, item) {
                    $("#formDepartment").append("<option value = '" + item.DepartmentAbrhs + "' >" + item.DepartmentName + "</option>");
                });
        });

    getActiveForms(null);
});

function getFormByDepartment() {
    getActiveForms($("#formDepartment").val());
}

function getActiveForms(departmentAbrhs) {
    $("#tblActiveForm").empty();
    var jsonObject = {
        departmentAbrhs: departmentAbrhs,
    };

    calltoAjax(misApiUrl.getAllActiveForms, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#tblActiveForm").dataTable({
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
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        "sWidth": "100px",
                        mRender: function (data, type, row) {
                            var html = '';
                            if (misPermissions.hasViewRights === true) {
                                //html += '<div><a href = "javascript:void(0)" onclick="fetchFormInformation(\'' + row.FormTitle + '\' ,' + row.FormId + ')" data-toggle="tooltip" title="Download">Download</a></div>'; //'<div><button type="button" data-toggle="tooltip" title="Download"  class="btn btn-sm btn-success"' + 'onclick="downloadForm(' + row.FormId + ')">Download</button></div>';
                                var extention = getFileExtension(row.FormName);
                                html += '<button type="button" class="btn btn-sm teal" onclick="fetchFormInformation(\'' + row.FormName + '\' ,' + row.FormId + ')" data-toggle="tooltip" title="Download"><i class="fa fa-download"> </i></button>';
                                if (extention == "pdf") {
                                    html += '&nbsp; <button type="button" class="btn btn-sm teal" data-toggle"model" data-target="#mypopupViewDocModal" onclick="viewDocumentInPopup(\'' + row.FormTitle + '\' , \'' + row.FormName + '\' ,' + row.FormId + ')" data-toggle="tooltip" title="View"><i class="fa fa-eye"> </i></button>';
                                }
                            }
                            return html;
                        }
                    },
                ]
            });
        });
}

function fetchFormInformation(formaName, formId) {
    var jsonObject = {
        formId: formId,
    }
    calltoAjax(misApiUrl.fetchFormInformation, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            if (resultData != null && resultData != '') {
                downloadFileFromBase64(formaName, resultData);
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
    calltoAjax(misApiUrl.fetchFormInformation, "POST", jsonObject,
        function (resultData) {
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