$(document).ready(function () {
    if (misPermissions.isDelegatable) {
        var html = '';
        if (!misPermissions.isDelegated) {
            html = '<button id="btnUserDelegation" type="button" class="btn btn-success"><i class="fa fa-bolt"></i>&nbsp;Delegate</button>';
        }
        else {
            html = '<button id="btnUserDelegation" type="button" class="btn btn-success"><i class="fa fa-lightbulb-o" style="color: yellow;font-size: 20px;"></i>&nbsp;Delegate</button>';
        }
        $("#divDeligation").html(html);
    }

    $("#expinMonthsReport").val(0);
    bindSkillLevelDropDownReport("#ddlSkillLevelReport", 0);
    bindSkillDropDownReport("#ddlSkillsReport", 0);
    bindSkillTypeDropDown("#ddlSkillTypeReport", 0);
   
});


function bindSkillLevelDropDownReport(ControlId, SelectedId) {
    $(ControlId).multiselect('destroy');
    $(ControlId).empty();
    $(ControlId).multiselect();
    var jsonObject = {
        'userAbrhs': misSession.userabrhs,
    };
    calltoAjax(misApiUrl.listSkillLevel, "POST", jsonObject,
               function (result) {
                   $(ControlId).multiselect("destroy");
                   $(ControlId).empty();
                   $.each(result, function (index, value) {
                       $('<option>').val(value.Value).text(value.Text).appendTo(ControlId);
                   });
                   $(ControlId).multiselect({
                       includeSelectAllOption: true,
                       enableFiltering: true,
                       enableCaseInsensitiveFiltering: true,
                       buttonWidth: false,
                       onDropdownHidden: function (event) {
                       }
                   });
               });
}

function bindSkillDropDownReport(ControlId, SelectedId) {
    $(ControlId).multiselect('destroy');
    $(ControlId).empty();
    $(ControlId).multiselect();
    calltoAjax(misApiUrl.listSkill, "POST", '',
               function (result) {
                   $(ControlId).multiselect("destroy");
                   $(ControlId).empty();
                   $.each(result, function (index, value) {
                       $('<option>').val(value.Value).text(value.Text).appendTo(ControlId);
                   });
                   $(ControlId).multiselect({
                       includeSelectAllOption: true,
                       enableFiltering: true,
                       enableCaseInsensitiveFiltering: true,
                       buttonWidth: false,
                       onDropdownHidden: function (event) {
                       }
                   });
               });
}

function bindSkillTypeDropDown(ControlId, SelectedId) {
    $(ControlId).multiselect('destroy');
    $(ControlId).empty();
    $(ControlId).multiselect();
    calltoAjax(misApiUrl.listSkillTypesForHR, "POST", '',
               function (result) {
                   $(ControlId).multiselect("destroy");
                   $(ControlId).empty();
                   $.each(result, function (index, value) {
                       $('<option>').val(value.Value).text(value.Text).appendTo(ControlId);
                   });
                   $(ControlId).multiselect({
                       includeSelectAllOption: true,
                       enableFiltering: true,
                       enableCaseInsensitiveFiltering: true,
                       buttonWidth: false,
                       onDropdownHidden: function (event) {
                       }
                   });
               });
}

$("#btnReportEmployeeSkills").click(function () {
    
    var skillIds = (($('#ddlSkillsReport').val() != null && typeof $('#ddlSkillsReport').val() != 'undefined' && $('#ddlSkillsReport').val().length > 0) ? $('#ddlSkillsReport').val().join(',') : '0');
    var skillLevelIds = (($('#ddlSkillLevelReport').val() != null && typeof $('#ddlSkillLevelReport').val() != 'undefined' && $('#ddlSkillLevelReport').val().length > 0) ? $('#ddlSkillLevelReport').val().join(',') : '0');
    var skillTypeIds = (($('#ddlSkillTypeReport').val() != null && typeof $('#ddlSkillTypeReport').val() != 'undefined' && $('#ddlSkillTypeReport').val().length > 0) ? $('#ddlSkillTypeReport').val().join(',') : '0');
    var jsonObject = {
        'SkillIds': skillIds,
        'SkillLevelIds': skillLevelIds,
        'SkillTypeIds': skillTypeIds,
        'ExperienceMonths': parseInt($("#expinMonthsReport").val() || 0),
        'UserAbrhs': misSession.userabrhs
    }
    calltoAjax(misApiUrl.getReportEmployeeSkills, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblReportEmployeeSkillsList").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                 {
                     filename: 'Employee Skills Report',
                     extend: 'collection',
                     text: 'Export',
                     buttons: [{ extend: 'copy' },
                                { extend: 'excel', filename: 'Employee Skills Report' },
                                { extend: 'pdf', filename: 'Employee Skills Report' },
                                { extend: 'print', filename: 'Employee Skills Report' },
                     ]
                 }
                ],
                "responsive": true,
                "autoWidth": false,
                "paging": true,
                "bDestroy": true,
                "ordering": true,
                "order": [],
                "info": true,
                "deferRender": false,
                "aaData": data,
                "aoColumns": [
                    {
                        "mData": "EmployeeName",
                        "sTitle": "Employee",
                    },
                    {
                        "mData": "SkillName",
                        "sTitle": "Technology",
                    },
                    {
                        "mData": "SkillLevelName",
                        "sTitle": "Proficiency Level",
                    },
                    {
                        "mData": null,
                        "sTitle": "Skill Type",
                        mRender: function (data, type, row) {
                            var SkillType = "Primary";
                            if (row.SkillTypeId == 2) {
                                SkillType = "Secondary";
                            }
                            return SkillType;
                        }
                    },
                     {
                         "mData": "ExperienceMonths",
                         "sTitle": "Experience (In Months)",
                     },
                      {
                          "mData": null,
                          "sTitle": "Last Updated On",
                          mRender: function (data, type, row) {
                              return toddMMMYYYYHHMMSSAP(row.CreatedDate);
                          }
                      },
                    
                ]
            });
        });
});