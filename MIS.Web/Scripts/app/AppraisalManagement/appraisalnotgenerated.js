$("#btnFilterSearch").click(function () {
    if (!validateControls('divAppraisalFilter')) {
        return false;
    }
    GetAppraisalNotGeneratedList();
});

function GetAppraisalNotGeneratedList() {
    var divisionIds = (($('#ddlDivisionMaster').val() != null && typeof $('#ddlDivisionMaster').val() != 'undefined' && $('#ddlDivisionMaster').val().length > 0) ? $('#ddlDivisionMaster').val().join(',') : '0');
    var departmentIds = (($('#ddlDepartmentMaster').val() != null && typeof $('#ddlDepartmentMaster').val() != 'undefined' && $('#ddlDepartmentMaster').val().length > 0) ? $('#ddlDepartmentMaster').val().join(',') : '0');
    var teamIds = (($('#ddlPopTeamMaster').val() != null && typeof $('#ddlPopTeamMaster').val() != 'undefined' && $('#ddlPopTeamMaster').val().length > 0) ? $('#ddlPopTeamMaster').val().join(',') : '0');
    var designationIds = (($('#ddlPopDesignationMaster').val() != null && typeof $('#ddlPopDesignationMaster').val() != 'undefined' && $('#ddlPopDesignationMaster').val().length > 0) ? $('#ddlPopDesignationMaster').val().join(',') : '0');

    var JsonObject = {
        AppraisalCycleId: $("#ddlAppraisalCycleMaster").val(),
        AppraisalSettingId: 0,
        LocationId: $("#ddlCountryMaster").val(),
        VerticalIds: $("#ddlVerticalMaster").val(),
        DivisionIds: divisionIds,
        DepartmentIds: departmentIds,
        TeamIds: teamIds,
        DesignationIds: designationIds,
        userAbrhs: misSession.userabrhs
    };
    calltoAjax(misApiUrl.getAppraisalNotGeneratedList, "POST", JsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#tblAppraisalNotGeneratedList").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                 {
                     filename: 'Appraisal Not Generated List',
                     extend: 'collection',
                     text: 'Export',
                     buttons: [{ extend: 'copy' },
                                { extend: 'excel', filename: 'Appraisal Not Generated List' },
                                { extend: 'pdf', filename: 'Appraisal Not Generated List' }, 
                                { extend: 'print', filename: 'Appraisal Not Generated List' },
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
                               "sTitle": "Employee",
                               mRender: function (data, type, row) {
                                   var html = row.EmployeeName;
                                   return html;
                               }
                           },
                           {
                               'bSortable': false,
                               "sTitle": "Employee Details",
                               mRender: function (data, type, row) {
                                   var html = '<td>' +
                                          '<strong>' + row.LocationName + ',' + row.VerticalName + ',' + row.DivisionName + '</strong><br>' +
                                           '<strong>' + row.DepartmentName + ',' + row.TeamName + '</strong><br>' +
                                          '<a data-toggle="tooltip" title="' + row.DesignationName + '" class="designation small-text-value">' + row.DesignationName + '</a>' +
                                          '</td>';
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
                               "sTitle": "RM Name",
                               mRender: function (data, type, row) {
                                   var html = row.RMName;
                                   return html;
                               }
                           },
                           {
                               'bSortable': false,
                               "sTitle": "Reason",
                               mRender: function (data, type, row) {
                                   var html = row.Reason;
                                   return html;
                               }
                           },

                             {
                                 "mData": null,
                                 'bSortable': false,
                                 "sTitle": "Action",
                                 mRender: function (data, type, row) {
                                     var html = '';
                                     if (row.IsGenerate && row.AppraisalCycleId > 0 && row.AppraisalCycleId != null)
                                         html += "<button data-toggle='tooltip' title='Generate' onclick='GenerateEmployeeAppraisal(" + row.EmployeeId + "," + row.AppraisalCycleId + ");' class='btn btn-success'><i class='fa fa-external-link'></i></button>";
                                     return html;
                                 }
                             },
                ],
            });
        });
}

function GenerateEmployeeAppraisal(employeeId, appraisalCycleId) {
    var reply = misConfirm("Are you sure you want to generate this appraisal setting? ", "Confirm", function (reply) {
        if (reply) {
            var JsonObject = {
                EmployeeId:employeeId,
                AppraisalCycleId: appraisalCycleId,
                UserAbrhs: misSession.userabrhs
            };
            calltoAjax(misApiUrl.createPendingEmpAppraisalSetting, "POST", JsonObject,
                function (result) {
                    if (result == '0') {
                        GetAppraisalSettingsList();
                        $("#editAppraisalSettings").modal('hide');
                        misAlert("Appraisal settings has been generated successfully", "Success", "success");
                    }
                    if (result == '1') {
                        GetAppraisalSettingsList();
                        $("#editAppraisalSettings").modal('hide');
                        misAlert("Appraisal settings has been generated successfully", "Success", "success");
                    }
                    if (result == '2') {
                        misAlert("Employee's appraisal setting already generated. Dismiss already generated appraisal first.", "Warning", "warning");
                    }
                    if (result == '3') {
                        misAlert("There is no employee to generate appraisal for this setting.", "Warning", "warning");
                    }
                    if (result == '4') {
                        misAlert("Appraisal setting is not generated as employee's appraisal cycle is missing. For detail, go to Appraisal Management > Appraisal Not Generated menu", "Warning", "warning");
                    }
                    if (result == '5') {
                        misAlert("Appraisal setting is not generated as employee's Appraiser is missing. For detail, go to Appraisal Management > Appraisal Not Generated menu", "Warning", "warning");
                    }
                    if (result == '6') {
                        misAlert("Appraisal setting is not generated as employee's RM is missing. For detail, go to 'Appraisal Management > Appraisal Not Generated menu", "Warning", "warning");
                    }
                    if (result == '7') {
                        misAlert("Appraisal setting is not generated as employee's appraisal form is missing. For detail, go to 'Appraisal Management > Appraisal Not Generated menu", "Warning", "warning");
                    }
                });
        }
    });
}