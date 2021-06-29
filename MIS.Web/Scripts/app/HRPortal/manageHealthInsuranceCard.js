$(document).ready(function () {
    GetEmployeeHEalthInsuranceCardDetails();
});


function GetEmployeeHEalthInsuranceCardDetails() {

    calltoAjax(misApiUrl.getHealthInsuranceDetails, "GET", null,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblAllHealthInsuranceForm").dataTable({
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
                        "mData": "EmployeeName",
                        "sTitle": "Employee Name",
                    },
                    {
                        "mData": "EmployeeCode",
                        "sTitle": "Employee Code",
                    },
                    {
                        "mData": "FileName",
                        "sTitle": "File Name",
                    },
                    {
                        "mData": "CreatedDate",
                        "sTitle": "CreatedDate",
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        "sWidth": "100px",
                        mRender: function (data, type, row) {
                            var html = '';
                            if (misPermissions.hasViewRights === true) {
                                html += '<button type="button" class="btn btn-sm teal" data-toggle"model" data-target="#mypopupViewDocModal" onclick="viewDocumentInPopup(\'' + row.FileName + '\')"  data-toggle="tooltip" title="View"><i class="fa fa-eye"> </i></button>';
                            }
                            return html;
                        }
                    },
                ]
            });
        });
}


function UploadHealthInsuranceCard() {
    loadModal("modal-uploadHealthInsuranceCard", "modal-addFormContainer", misAppUrl.uploadHealthsuranceCard, true);
}

function viewDocumentInPopup(fileName) {

    if (fileName != null && fileName != '') {
        $("#objViewPdf").attr("src", (misApiHealthInsuranceCardUrl + fileName + '#toolbar=0&navpanes=0&scrollbar=0'));
        $("#modalTitle").html("HealthInsurnace: " + fileName);
        $("#popupWindowViewDocument").html($("#popupWindowViewDocument").html());
        $("#viewDocumentModal").modal("show");
    }
    else {
        misAlert('The file you have requested does not exist. Please try after some time or contact to MIS team for further assistance.', 'Oops...', 'info');
    }
};
