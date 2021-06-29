﻿$(function () {
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
        GetEmployeeAppraisalStatusList();
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

function GetEmployeeAppraisalStatusList() {
    var statusIds = (($('#ddlAppraisalStatus').val() != null && typeof $('#ddlAppraisalStatus').val() != 'undefined' && $('#ddlAppraisalStatus').val().length > 0) ? $('#ddlAppraisalStatus').val().join(',') : '0');

    var JsonObject = {
        appraisalCycleId: $("#ddlAppraisalCycleMaster").val(),
        appraisalStatusIds: statusIds
    };
    calltoAjax(misApiUrl.getEmployeeAppraisalStatusList, "POST", JsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#tblEmployeeAppraisalStatusList").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                 {
                     filename: 'Employee Appraisal Form List',
                     extend: 'collection',
                     text: 'Export',
                     buttons: [{ extend: 'copy' },
                                { extend: 'excel', filename: 'Employee Appraisal Form List' },
                                { extend: 'pdf', filename: 'Employee Appraisal Form List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                                { extend: 'print', filename: 'Employee Appraisal Form List' },
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
                                   var html = '<td>' +
                                          '<strong>' + row.EmployeeName + ',' + row.DesignationName + '</strong><br>' +
                                          '' + row.VerticalName + ',' + row.DivisionName + '<br>' +
                                          '' + row.DepartmentName + ',' + row.TeamName + '<br>' +
                                          '</td>';
                                   return html;
                               }
                           },
                           {
                               'bSortable': false,
                               "sTitle": "RM Name",
                               mRender: function (data, type, row) {
                                   var html = row.RMName;
                                   return html;
                               }
                           },
                           {
                               'bSortable': false,
                               "sTitle": "Appraiser",
                               mRender: function (data, type, row) {
                                   var html = row.AppraiserName;
                                   return html;
                               }
                           },
                           {
                               'bSortable': false,
                               "sTitle": "Approver",
                               mRender: function (data, type, row) {
                                   var html = row.Approver1Name;
                                   return html;
                               }
                           },
                           //{
                           //    'bSortable': false,
                           //    "sTitle": "Status",
                           //    mRender: function (data, type, row) {
                           //        var html = row.AppraisalStatusName;
                           //        return html;
                           //    }
                           //},
                           {
                               'bSortable': false,
                               "sTitle": "Action",
                               "sWidth": "100px",
                               mRender: function (data, type, row) {
                                   var html = '<div>';
                                   html += '<button type="button" data-toggle="tooltip" class="btn btn-sm btn-success"' + 'onclick="DownloadForm(' + row.EmpAppraisalSettingId + ')" title="Download"><i class="fa fa-download" aria-hidden="true"></i></button>';
                                   html += '&nbsp; <button type="button" data-toggle="tooltip" class="btn btn-sm btn-success"' + 'onclick="SendFormOnMail(' + row.EmpAppraisalSettingId + ')" title="Send Mail"><i class="fa fa-envelope" aria-hidden="true"></i></button>';
                                   return html;
                               }
                           },
                ],
            });
        });
}

function DownloadForm(empAppraisalSettingId) {
    var JsonObject = {
        "empAppraisalSettingId": empAppraisalSettingId
    };
    calltoAjax(misApiUrl.downloadAppraisalForm, "POST", JsonObject,
        function (result) {
        });
}

function SendFormOnMail(empAppraisalSettingId) {
    var JsonObject = {
        EmpAppraisalSettingId: empAppraisalSettingId
    };
    calltoAjax(misApiUrl.sendAppraisalFormOnMail, "POST", JsonObject,
        function (result) {
        });
}