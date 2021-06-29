$(document).ready(function () {
    formEmployeeDirectoryGrid();
})

function formEmployeeDirectoryGrid() {
    calltoAjax(misApiUrl.employeeDirectory, "GET", "",
        function (result) {
            var resultdata = $.parseJSON(JSON.stringify(result));
            $("#tblEmployeeDirectory").DataTable({
                "responsive": true,
                "autoWidth": false,
                "paging": true,
                "bDestroy": true,
                "ordering": true,
                "order": [],
                "info": true,
                "deferRender": true,
                "aaData": resultdata,
                "aoColumns": [
                    {
                        "mData": null,
                        "sTitle": "Employee Name",
                        'bSortable': false,
                          "sWidth": "150px",
                        mRender: function (data, type, row) {
                            var html = '<a  onclick="showProfilePopup(\'' + row.EmailId + '\')" style="text-decoration: underline !important;" data-toggle="tooltip" title="View Profile">' + row.EmployeeName + '</a>';
                            return html;
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Email",
                        'bSortable': false,
                        "sWidth": "100px",
                        "className": "none",
                        mRender: function (data, type, row) {
                            var html = '<a href="mailto:' + row.EmailId + '" style="text-decoration:none"><i class="fa fa-envelope" aria-hidden="true" style="color:#b348ae"></i> &nbsp; ' + row.EmailId + '</a> ';
                            return html;
                        }
                    },
                    {
                        "mData": "Designation",
                        "sTitle": "Designation",
                    },
                    {
                        "mData": "Department",
                        "sTitle": "Department",
                    },
                    {
                        "mData": "MobileNumber",
                        "sTitle": "Mobile No.",
                    },
                    {
                        "mData": "Extension",
                        "sTitle": "Extension",
                    },
                    {
                        "mData": "Location",
                        "sTitle": "Location",
                        "sWidth": "80px",
                    },
                ]
            });
        });
}

function showProfilePopup(emailId) {
    $("#hdnEmpAbrhs").val(emailId);
    loadModal("mypopupUserProfile", "userProfile", misAppUrl.userProfile, true, {}, true);
}
