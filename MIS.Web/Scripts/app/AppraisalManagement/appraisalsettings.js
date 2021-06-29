$("#btnAddAppraisalSettings").click(function () {
    loadModal("addAppraisalSettings", "addAppraisalSettingsContainer", misAppUrl.addAppraisalSettings, true);
});

$("#btnFilterSearch").click(function () {
    if (!validateControls('appraisalsettingsDiv')) {
        return false;
    }
    GetAppraisalSettingsList();
});

function GetAppraisalSettingsList() {
    var divisionIds = (($('#ddlDivisionMaster').val() != null && typeof $('#ddlDivisionMaster').val() != 'undefined' && $('#ddlDivisionMaster').val().length > 0) ? $('#ddlDivisionMaster').val().join(',') : '0');
    var departmentIds = (($('#ddlDepartmentMaster').val() != null && typeof $('#ddlDepartmentMaster').val() != 'undefined' && $('#ddlDepartmentMaster').val().length > 0) ? $('#ddlDepartmentMaster').val().join(',') : '0');
    var teamIds = (($('#ddlPopTeamMaster').val() != null && typeof $('#ddlPopTeamMaster').val() != 'undefined' && $('#ddlPopTeamMaster').val().length > 0) ? $('#ddlPopTeamMaster').val().join(',') : '0');

    var JsonObject = {
        AppraisalCycleId: $("#ddlAppraisalCycleMaster").val(),
        AppraisalSettingId: 0,
        LocationId: $("#ddlCountryMaster").val(),
        VerticalIds: $("#ddlVerticalMaster").val(),
        DivisionIds: divisionIds,
        DepartmentIds: departmentIds,
        TeamIds: teamIds
    };
    calltoAjax(misApiUrl.getAppraisalSettingList, "POST", JsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#tblAppraisalSetting").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                 {
                     filename: 'Appraisal Setting List',
                     extend: 'collection',
                     text: 'Export',
                     buttons: [{ extend: 'copy' },
                                { extend: 'excel', filename: 'Appraisal Setting List' },
                                { extend: 'pdf', filename: 'Appraisal Setting List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                                { extend: 'print', filename: 'Appraisal Setting List' },
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
                               'bSortable': false,
                               mRender: function (data, type, row) {
                                   var year = row.AppraisalMonth.split(',');
                                   var html = '<span class="halign-center circle-bg">' + year[1] + '</span>';
                                   return html;
                               }
                           },
                           {
                               'bSortable': false,
                               mRender: function (data, type, row) {
                                   var month = row.AppraisalMonth.split(',');
                                   var html = '<td>' +
                                       '<h4><span>Appraisal Cycle <strong>' + month[0] + '</strong></span></h4>' +
                                       '<strong>' + row.LocationName + ',' + row.VerticalName + ',' + row.DivisionName + '</strong><br>' +
                                        '<strong>' + row.DepartmentName + ',' + row.TeamName + '</strong><br>' +
                                       '<a data-toggle="tooltip" title="' + row.DesignationName + '" class="designation small-text-value">' + row.DesignationName + '</a>' +
                                       '<br /><strong>Start date</strong><span class="dates"> ' + row.StartDate + '</span><br/> <strong>End date</strong> <span class="dates"> ' + row.EndDate + '</span>' +
                                       '</td>';
                                   return html;
                               }
                           },
                            {
                                'bSortable': false,
                                mRender: function (data, type, row) {
                                    var html = getStartStages(row);
                                    return html;
                                }
                            },
                            {
                                'bSortable': false,
                                mRender: function (data, type, row) {
                                    var html = getEndStages(row);
                                    return html;
                                }
                            },

                             {
                                 "mData": null,
                                 'bSortable': false,
                                 mRender: function (data, type, row) {
                                     var html = "<td class='halign-center'>";
                                     html += "<button title='Edit' data-toggle='tooltip' onclick='editAppraisalSettings(" + ((row.EmpSettingCount > 0) ? true : false) + ',' + row.AppraisalSettingId + ',' + row.AppraisalCycleId + ',' + row.LocationId + ',"' + row.VerticalId + '","' + row.DivisionId + '","' + row.DepartmentId + '","' + row.TeamId + '","' + row.DesignationIds + "\");' class='btn btn-primary' style='padding-bottom:5px;'><i class='fa fa-edit'></i></button>";
                                     html += "&nbsp;<button data-toggle='tooltip'" + (row.EmpSettingCount > 0 ? " disabled" : " title='Generate'") + " onclick='generateAppraisalSettings(" + row.AppraisalSettingId + ',' + row.AppraisalCycleId + ',' + row.LocationId + ',"' + row.VerticalId + '","' + row.DivisionId + '","' + row.DepartmentId + '","' + row.TeamId + '","' + row.DesignationIds + "\");' class='btn btn-success' type='button' style='padding-bottom:5px;'><i class='fa fa-external-link'></i></button>";
                                     html += "&nbsp;<button data-toggle='tooltip' title='Delete' onclick='deleteAppraisalSetting(" + row.AppraisalSettingId + ");' class='btn btn-danger'><i class='fa fa-trash'></i></button>";
                                     html += "</td>";
                                     return html;
                                 }
                             },
                ],
                "fnDrawCallback": function (oSettings) {
                    $(oSettings.nTHead).hide();
                }
            });
        });
}

function getEndStages(d) {
    var statges = JSON.parse(d.AppraisalStatges);
    var empSettingCount = d.EmpSettingCount;
    var tbl = '<td class="labels">';
    if (statges.length > 0) {
        var row = '';
        $.each(statges, function (key, value) {
            row += '<strong>' + value.AppraisalStageName + ' End Date</strong><span class="dates">' + value.EndDate + '</span>';
            row += "<br>";
        });
        row += '<strong>&nbsp;</strong><span class="">&nbsp;</span>';
        tbl += row;
    }
    else {
        tbl += '<td valign="top" colspan="2" class="dataTables_empty">No data available in table</td>';
    }

    return tbl;
}

function getStartStages(d) {
    var statges = JSON.parse(d.AppraisalStatges);
    var empSettingCount = d.EmpSettingCount;
    var tbl = '<td class="labels">';
    if (statges.length > 0) {
        var row = '';
        $.each(statges, function (key, value) {
            row += '<strong>' + value.AppraisalStageName + ' Start Date</strong><span class="dates">' + value.StartDate + '</span>';
            row += "<br>";
        });
        row += (empSettingCount > 0 ? '<strong>Status</strong><span class="text-green status">Generated</span>' : '<strong>Status</strong><span class="text-red status">Not Generated</span>');
        tbl += row;
    }
    else {
        tbl += '<td valign="top" colspan="2" class="dataTables_empty">No data available in table</td>';
    }

    return tbl;
}

function deleteAppraisalSetting(appraisalSettingId) {
    var reply = misConfirm("Are you sure you want to delete this appraisal setting?", "Confirm", function (reply) {
        if (reply) {
            var JsonObject = {
                AppraisalSettingId: appraisalSettingId
            };
            calltoAjax(misApiUrl.deleteAppraisalSetting, "POST", JsonObject,
                function (result) {
                    if (result == 1) {
                        GetAppraisalSettingsList();
                        misAlert("Appraisal Settings has been deleted successfully.", "Success", "success");
                    }
                });
        }
    });
}

function generateAppraisalSettings(appraisalSettingId, appraisalCycleId, locationId, verticalId, divisionId, departmentId, teamId, designationIds) {
    var reply = misConfirm("Are you sure you want to generate this appraisal setting? ", "Confirm", function (reply) {
        if (reply) {
            var JsonObject = {
                AppraisalSettingId: appraisalSettingId
            };
            calltoAjax(misApiUrl.generateAppraisalSettings, "POST", JsonObject,
                function (result) {
                    if (result.Status == '1') {
                        GetAppraisalSettingsList();
                        $("#editAppraisalSettings").modal('hide');
                        misAlert("Appraisal settings has been generated successfully", "Success", "success");
                    }
                    if (result.Status == '2') {
                        misAlert("There is no employee to generate appraisal for this setting.", "Warning", "warning");
                    }
                    if (result.Status == '3') {
                        misAlert("<div style='font-size: 18px;color: #e52121;text-align: justify;'> Appraisal setting is not generated as employee(s), <br /> designation/appraiser/RM/appraisal cycle/appraisal form is missing. For detail, go to 'Appraisal Management > Appraisal Not Generated' menu <div>", "Warning", "warning");
                    }
                });
        }
    });
}

function editAppraisalSettings(empSettingCount, appraisalSettingId, appraisalCycleId, locationId, verticalId, divisionId, departmentId, teamId, designationIds) {
    if (!(appraisalCycleId > 0) && !(locationId > 0) && !(appraisalSettingId > 0)) {
        return false;
    }
    $("#hdnEditAppraisalCycleId").val(appraisalCycleId);
    $("#hdnEditAppraisalSettingId").val(appraisalSettingId);
    $("#hdnEditLocationId").val(locationId);
    $("#hdnEditVerticalId").val(verticalId);
    $("#hdnEditDivisionId").val(divisionId);
    $("#hdnEditDepartmentId").val(departmentId);
    $("#hdnEditTeamId").val(teamId);

    loadModal("editAppraisalSettings", "UpdateAppraisalSettingsContainer", misAppUrl.editAppraisalSettings, true);
   
}