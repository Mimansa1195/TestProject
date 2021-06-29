$(function () {
    fetchAppraisalCycleFilter(0);
    $('#ddlAppraisalStatus').multiselect({
        includeSelectAllOption: true,
        enableFiltering: true,
        enableCaseInsensitiveFiltering: true,
        buttonWidth: false,
        onDropdownHidden: function (event) {
        }
    });


    $("#btnFilterSearch").click(function () {
        if (!validateControls('divAppraisalStatusReport')) {
            return false;
        }
        GetAppraisalReport();
    });
});

function bindAppraisalStatus() {
    fetchAppraisalStatusFilter();
}

function fetchAppraisalCycleFilter(selectedId) {
    $('#ddlAppraisalCycleMaster').empty();
    calltoAjax(misApiUrl.getAppraisalCycleList, "POST", '',
            function (result) {
                if (result != null && result.length > 0) {
                    $('#ddlAppraisalCycleMaster').append("<option value = 0>Select</option>");
                    for (var x = 0; x < result.length; x++) {
                        $('#ddlAppraisalCycleMaster').append("<option value = '" + result[x].Value + "'>" + result[x].Text + "</option>");
                    }
                    if (selectedId > 0) {
                        $('#ddlAppraisalCycleMaster').val(selectedId);
                    }
                }
            });
}

function fetchAppraisalStatusFilter() {
    $('#ddlAppraisalStatus').multiselect('destroy');
    $('#ddlAppraisalStatus').empty();
    $('#ddlAppraisalStatus').multiselect();
    var selectValue = 0;
    calltoAjax(misApiUrl.getAppraisalStatus, "POST", '',
        function (result) {
            $.each(result, function (index, value) {
                $('<option selected>').val(value.Value).text(value.Text).appendTo('#ddlAppraisalStatus');
            });
            $('#ddlAppraisalStatus').multiselect("destroy");
            $('#ddlAppraisalStatus').multiselect({
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                buttonWidth: false,
                onDropdownHidden: function (event) {
                }
            });
        });
}

function GetAppraisalReport() {
    var statusIds = (($('#ddlAppraisalStatus').val() != null && typeof $('#ddlAppraisalStatus').val() != 'undefined' && $('#ddlAppraisalStatus').val().length > 0) ? $('#ddlAppraisalStatus').val().join(',') : '0');

    var jsonObject = {
        appraisalCycleId: $("#ddlAppraisalCycleMaster").val(),
        appraisalStatusIds: statusIds,
        UserAbrhs: misSession.userabrhs
    };
    calltoAjax(misApiUrl.getAppraisalReport, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#tblEmployeeAppraisalStatusList").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                 {
                     filename: 'Consolidated Appraisal Report',
                     extend: 'collection',
                     text: 'Export',
                     buttons: [ { extend: 'copy'},
                                { extend: 'excel', filename: 'Consolidated Appraisal Report' },
                                { extend: 'pdf', orientation: 'landscape', pageSize: 'LEGAL', filename: 'Consolidated Appraisal Report' },
                                { extend: 'print', filename: 'Consolidated Appraisal Report' },
                            ]
                 }
                ],
                "responsive": true,
                "autoWidth": false,
                "paging": true,
                "bDestroy": true,
                "searching": true,
                "ordering": true,
                "info": true,
                "deferRender": true,
                "aaData": resultData,
                "aoColumns": [
                           {
                               "mData": null,
                               "sTitle": "",
                               mRender: function (data, type, row) {
                                   return "<td class='halign-center'><img  onerror=\"this.src='../img/avatar-sign.png'\"  src='" + misApiProfileImageUrl + data.EmployeePhotoName + "' class='img-circle' alt='User Image'></td>";
                               }
                           },
                           {
                               'bSortable': false,
                               "sTitle": "Employee Details",
                               mRender: function (data, type, row) {
                                   var html = row.EmployeeName;
                                   return html;
                               }
                           },
                           {
                               'bSortable': false,
                               "sTitle": "Designation",
                               mRender: function (data, type, row) {
                                   var html = row.CurrentDesignation;
                                   return html;
                               }
                           },                           
                           {
                               'bSortable': false,
                               "sTitle": "RM Name",
                               mRender: function (data, type, row) {
                                   var html = row.ReportingManager;
                                   return html;
                               }
                           },
                           {
                               'bSortable': false,
                               "sTitle": "Appraiser",
                               mRender: function (data, type, row) {
                                   var html = row.Appraiser;
                                   return html;
                               }
                           },
                           {
                               'bSortable': false,
                               "sTitle": "Approver",
                               mRender: function (data, type, row) {
                                   var html = row.Approver;
                                   return html;
                               }
                           },
                           {
                               'bSortable': false,
                               "sTitle": "Appraiser <br />Recommended <br />Designation",
                               mRender: function (data, type, row) {
                                   var html = row.AppraiserRecommendedDesignation;
                                   return html;
                               }
                           },
                           {
                               'bSortable': false,
                               "sTitle": "Appraiser <br />Recommended %",
                               mRender: function (data, type, row) {
                                   var html = row.AppraiserRecommendedPercentage;
                                   return html;
                               }
                           },
                           {
                               'bSortable': false,
                               "sTitle": "Approver <br />Recommended <br />Designation",
                               mRender: function (data, type, row) {
                                   var html = row.ApproverRecommendedDesignation;
                                   return html;
                               }
                           },
                           {
                               'bSortable': false,
                               "sTitle": "Approver <br />Recommended %",
                               mRender: function (data, type, row) {
                                   var html = row.ApproverRecommendedPercentage;
                                   return html;
                               }
                           },
                           {
                               'bSortable': false,
                               "sTitle": "Appraiser <br />Marked <br />High Potential",
                               mRender: function (data, type, row) {
                                   var html = "NA";
                                   if (row.AppraiserMarkedHighPotential)
                                       html = "Yes";
                                   return html;
                               }
                           },
                           {
                               'bSortable': false,
                               "sTitle": "Approver <br />Marked <br />High Potential",
                               mRender: function (data, type, row) {
                                   var html = "NA";
                                   if (row.ApproverMarkedHighPotential)
                                       html = "Yes";
                                   return html;
                               }
                           },
                           {
                               'bSortable': false,
                               "sTitle": "Self Rating",
                               mRender: function (data, type, row) {
                                   var html = row.SelfRating;
                                   return html;
                               }
                           },
                           {
                               'bSortable': false,
                               "sTitle": "Appraiser Rating",
                               mRender: function (data, type, row) {
                                   var html = row.AppraiserRating;
                                   return html;
                               }
                           },
                           {
                               'bSortable': false,
                               "sTitle": "Approver Rating",
                               mRender: function (data, type, row) {
                                   var html = row.ApproverRating;
                                   return html;
                               }
                           },
                           {
                               'bSortable': false,
                               "sTitle": "Appraisal Status",
                               mRender: function (data, type, row) {
                                   var html = row.AppraisalStatus;
                                   return html;
                               }
                           },
                ],
            });
        });
}