$(function () {
    $('#ddlAppraiserMaster').multiselect({
        includeSelectAllOption: true,
        enableFiltering: true,
        enableCaseInsensitiveFiltering: true,
        buttonWidth: false,
        onDropdownHidden: function (event) {
        }
    });

    $('#ddlApproverMaster').multiselect({
        includeSelectAllOption: true,
        enableFiltering: true,
        enableCaseInsensitiveFiltering: true,
        buttonWidth: false,
        onDropdownHidden: function (event) {
        }
    });

    $("#ddlPopTeamMaster").change(function () {
        var appraisalCycleId = $('#ddlAppraisalCycleMaster').val();
        var locationId = $('#ddlCountryMaster').val();
        var verticalId = $('#ddlVerticalMaster').val();
        var divisionIds = (($('#ddlDivisionMaster').val() != null && typeof $('#ddlDivisionMaster').val() != 'undefined' && $('#ddlDivisionMaster').val().length > 0) ? $('#ddlDivisionMaster').val().join(',') : '0');
        var departmentIds = (($('#ddlDepartmentMaster').val() != null && typeof $('#ddlDepartmentMaster').val() != 'undefined' && $('#ddlDepartmentMaster').val().length > 0) ? $('#ddlDepartmentMaster').val().join(',') : '0');
        var teamIds = (($('#ddlPopTeamMaster').val() != null && typeof $('#ddlPopTeamMaster').val() != 'undefined' && $('#ddlPopTeamMaster').val().length > 0) ? $('#ddlPopTeamMaster').val().join(',') : '0');
        fetchAppraiserFilter(appraisalCycleId, locationId, verticalId, divisionIds, departmentIds, teamIds);
        fetchApproverFilter(appraisalCycleId, locationId, verticalId, divisionIds, departmentIds, teamIds);
    });

    // Filter.js
    $("#ddlappraisalcycleMaster").select2();
    $("#ddlCountryMaster").select2();
    $("#ddlVerticalMaster").select2();
    $("#ddlAppraisalCycleMaster").select2();

    $('#ddlDivisionMaster').multiselect({
        includeSelectAllOption: true,
        enableFiltering: true,
        enableCaseInsensitiveFiltering: true,
        buttonWidth: false,
        onDropdownHidden: function (event) {
        }
    });
    $('#ddlDepartmentMaster').multiselect({
        includeSelectAllOption: true,
        enableFiltering: true,
        enableCaseInsensitiveFiltering: true,
        buttonWidth: false,
        onDropdownHidden: function (event) {
        }
    });
    $('#ddlPopTeamMaster').multiselect({
        includeSelectAllOption: true,
        enableFiltering: true,
        enableCaseInsensitiveFiltering: true,
        buttonWidth: false,
        onDropdownHidden: function (event) {
        }
    });

    $('#ddlPopDesignationMaster').multiselect({
        includeSelectAllOption: true,
        enableFiltering: true,
        enableCaseInsensitiveFiltering: true,
        buttonWidth: false,
        onDropdownHidden: function (event) {
        }
    });


    fetchAppraisalCycleFilter(0);
    fetchCompanyLocationFilter(0);
    fetchVerticalFilter(0);

    $("#ddlVerticalMaster").change(function () {
        fetchDivisionFilter($("#ddlVerticalMaster").val(), 0);// populateGroupMaster($("#ddlPopLocationMaster").val());
    });

    $("#ddlDivisionMaster").change(function () {
        var divisions = (($('#ddlDivisionMaster').val() != null && typeof $('#ddlDivisionMaster').val() != 'undefined' && $('#ddlDivisionMaster').val().length > 0) ? $('#ddlDivisionMaster').val().join(',') : '0');
        fetchDepartmentFilter(divisions, 0);
    });

    $("#ddlDepartmentMaster").change(function () {
        var departmentIds = (($('#ddlDepartmentMaster').val() != null && typeof $('#ddlDepartmentMaster').val() != 'undefined' && $('#ddlDepartmentMaster').val().length > 0) ? $('#ddlDepartmentMaster').val().join(',') : '0');
        populatePopTeamMasterFilter(departmentIds, 0);
    });


});

function fetchAppraiserFilter(appraisalCycleId, locationId, verticalId, divisionIds, departmentIds, teamIds) {
    $('#ddlAppraiserMaster').multiselect('destroy');
    $('#ddlAppraiserMaster').empty();
    $('#ddlAppraiserMaster').multiselect();
    var jsonObject = {
        'AppraisalCycleId': appraisalCycleId || 0,
        'LocationId': locationId || 0,
        'VerticalId': verticalId || 0,
        'DivisionIds': divisionIds,
        'DepartmentIds': departmentIds,
        'TeamIds': teamIds
    };
    calltoAjax(misApiUrl.getAppraiserListByIDs, "POST", jsonObject,
        function (result) {
            $.each(result, function (index, value) {
                $('<option selected>').val(value.Value).text(value.Text).appendTo('#ddlAppraiserMaster');
            });
            $('#ddlAppraiserMaster').multiselect("destroy");
            $('#ddlAppraiserMaster').multiselect({
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                buttonWidth: false,
                onDropdownHidden: function (event) {
                }
            });
        });
}

function fetchApproverFilter(appraisalCycleId, locationId, verticalId, divisionIds, departmentIds, teamIds) {
    $('#ddlApproverMaster').multiselect('destroy');
    $('#ddlApproverMaster').empty();
    $('#ddlApproverMaster').multiselect();
    var jsonObject = {
        'AppraisalCycleId': appraisalCycleId || 0,
        'LocationId': locationId || 0,
        'VerticalId': verticalId || 0,
        'DivisionIds': divisionIds,
        'DepartmentIds': departmentIds,
        'TeamIds': teamIds
    };
    calltoAjax(misApiUrl.getApproverListByIDs, "POST", jsonObject,
        function (result) {
            $.each(result, function (index, value) {
                $('<option selected>').val(value.Value).text(value.Text).appendTo('#ddlApproverMaster');
            });
            $('#ddlApproverMaster').multiselect("destroy");
            $('#ddlApproverMaster').multiselect({
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                buttonWidth: false,
                onDropdownHidden: function (event) {
                }
            });
        });
}

$("#btnFilterSearchTeamWise").click(function () {
    if (!validateControls('teamAppraisalDiv')) {
        return false;
    }
    GetTeamAppraisalSettingsList();
});

function GetTeamAppraisalSettingsList() {
    var divisionIds = (($('#ddlDivisionMaster').val() != null && typeof $('#ddlDivisionMaster').val() != 'undefined' && $('#ddlDivisionMaster').val().length > 0) ? $('#ddlDivisionMaster').val().join(',') : '0');
    var departmentIds = (($('#ddlDepartmentMaster').val() != null && typeof $('#ddlDepartmentMaster').val() != 'undefined' && $('#ddlDepartmentMaster').val().length > 0) ? $('#ddlDepartmentMaster').val().join(',') : '0');
    var teamIds = (($('#ddlPopTeamMaster').val() != null && typeof $('#ddlPopTeamMaster').val() != 'undefined' && $('#ddlPopTeamMaster').val().length > 0) ? $('#ddlPopTeamMaster').val().join(',') : '0');
    var appraiserIds = (($('#ddlAppraiserMaster').val() != null && typeof $('#ddlAppraiserMaster').val() != 'undefined' && $('#ddlAppraiserMaster').val().length > 0) ? $('#ddlAppraiserMaster').val().join(',') : '');
    var approverIds = (($('#ddlApproverMaster').val() != null && typeof $('#ddlApproverMaster').val() != 'undefined' && $('#ddlApproverMaster').val().length > 0) ? $('#ddlApproverMaster').val().join(',') : '');

    var JsonObject = {
        IsTeamData: false,
        AppraisalCycleId: $("#ddlAppraisalCycleMaster").val(),
        LocationId: $("#ddlCountryMaster").val(),
        VerticalIds: $("#ddlVerticalMaster").val(),
        DivisionIds: divisionIds,
        DepartmentIds: departmentIds,
        TeamIds: teamIds,
        AppraiserIds: appraiserIds,
        ApproverIds: approverIds,
        AppraisalSettingId: 0,
        userAbrhs: misSession.userabrhs
    };
    calltoAjax(misApiUrl.getEmpAppraisalSetting, "POST", JsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#tblTeamAppraisal").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                 {
                     filename: 'Team Appraisal Setting',
                     extend: 'collection',
                     text: 'Export',
                     buttons: [{ extend: 'copy' },
                                { extend: 'excel', filename: 'Team Appraisal Setting' },
                                { extend: 'pdf', filename: 'Team Appraisal Setting' },
                                { extend: 'print', filename: 'Team Appraisal Setting' },
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
                        return "<td class='halign-center'><img  onerror=\"this.src='../img/avatar-sign.png'\"  src='" + misApiProfileImageUrl + data.EmployeePhotoName + "' class='img-circle' alt='User Image'><br/>" + data.EmployeeName + "<br/>" + data.DesignationName + "</td>";
                    }
                },
                   {
                       "mData": null,
                       "sTitle": "Details",
                       mRender: function (data, type, row) {
                           var htmldetails = "<td class='labels'>";
                           htmldetails += "<strong>Appraiser</strong> <span class='text-color'>" + data.AppraiserName + "</span><br/> ";
                           if (data.Approver1Name != null && data.Approver1Name != '') {
                               htmldetails += "<strong>Approver</strong> <span class='text-color'>" + data.Approver1Name + "</span><br/> ";
                           }
                           if (data.Approver2Name != null && data.Approver2Name != '') {
                               htmldetails += "<strong>Approver 2</strong> <span class='text-color'>" + data.Approver2Name + "</span><br/>";
                           }
                           if (data.Approver3Name != null && data.Approver3Name != '') {
                               htmldetails += "<strong>Approver 3</strong> <span class='text-color'>" + data.Approver3Name + "</span><br/> ";
                           }
                           htmldetails += "<strong>Reporting Manager</strong> <span class='text-color'>" + data.RMName + "</span><br/> ";
                           htmldetails += "<strong>Self Appraisal</strong> <span class='text-color'>" + ((data.IsSelfAppraisal == true) ? 'Yes' : 'No') + "</span><br/>";
                           htmldetails += "<strong>Appraisal Form</strong> <span  data-toggle='tooltip' title='" + data.CompetencyFormName + "' class='text-color small-text-value'>" + data.CompetencyFormName + "</span><br/>  ";
                           htmldetails += "</td>";
                           return htmldetails;
                       }
                   },
                  {
                      "mData": null,
                      "sTitle": "Dates",
                      mRender: function (data, type, row) {
                          var dates = "<td class='labels'>";
                          dates += "<strong>Appraisal Starts From</strong> <span class='text-color'>" + data.StartDate + "</span><br/>";
                          if (data.AppraisalStatges && data.AppraisalStatges != '') {
                              $.each(data.AppraisalStatges.split(","), function (key, splitvalue) {
                                  var b = splitvalue.split("#");
                                  if (b[0] == 1) {
                                      dates += "<strong>Self Appraisal End Date</strong> <span class='text-color'>" + b[1] + "</span><br/>";
                                  }
                                  if (b[0] == 2) {
                                      dates += "<strong>Appraiser Review End Date</strong> <span class='text-color'>" + b[1] + "</span><br/>";
                                  }
                                  if (b[0] == 3) {
                                      dates += "<strong>Approval End Date</strong> <span class='text-color'>" + b[1] + "</span><br/>";
                                  }
                                  if (b[0] == 4) {
                                      dates += "<strong>Accept/Closure End Date</strong> <span class='text-color'>" + b[1] + "</span><br/>";
                                  }
                              });
                          }

                          dates += "<strong>Appraisal Ends By</strong> <span class='text-color'>" + data.EndDate + "</span><br/>";
                          dates += "<strong>Status</strong> <span  data-toggle='tooltip' title='" + data.AppraisalStatusName + "' class='text-green small-text-value status'>" + data.AppraisalStatusName + "</span><br/>";
                          dates += "</td>";
                          return dates;
                      }
                  },
                  {
                      "mData": null,
                      "sTitle": "Action",
                      mRender: function (data, type, row) {
                          var html = '';
                          //if (data.IsSettingModified == false) {
                          html = "<td><div class='btn-group' style='width: 70px;'><button type='button' class='btn btn-sm  btn-primary' data-toggle='tooltip' title='Edit' " + "onclick='btnedit(" + data.EmpAppraisalSettingId + "," + data.LocationId + "," + data.VerticalId + "," + data.DivisionId + "," + data.DepartmentId + "," + data.DesignationId + "," + data.AppraisalCycleId + "," + data.EmployeeId + ")'><i class='fa fa-edit'></i></button></div></td>";
                          //}
                          return html;
                      }
                  }
                ],
                "fnRowCallback": function (nRow, data, oSettings) {
                    var $nRow = $(nRow);
                    if (data.IsSettingModified == true) {
                        $nRow.css({ "background-color": "#F0E68C" })
                    }
                    $(oSettings.nTHead).hide();
                    return nRow
                },
            });
        });
}

function btnedit(empAppraisalSettingId, locationId, verticalId, divisionId, departmentId, designationId, appraisalCycleId, employeeId) {
    var jsonObject = {
        'AppraisalCycleId': 0,
        'EmpAppraisalSettingId': empAppraisalSettingId || 0,
        'EmployeeId': 0
    };
    calltoAjax(misApiUrl.getTeamAppraiselEditData, "POST", jsonObject,
        function (result) {
            bindPopupData(result[0]);
            fetchCompetencyList(locationId, verticalId, divisionId, departmentId, designationId, result[0].CompetencyFormId);
        });

}

function nextDate(date, day) {
    var sDate = new Date(date);
    var nextDate = new Date(sDate);
    nextDate.setDate(sDate.getDate() + day);
    return nextDate;
}

function fetchCompetencyList(locationId, verticalId, divisionId, departmentId, designationId, selectedId) {
    $('#ddlCompetency').empty();
    var jsonObject = {
        'feedbackTypeId': 1,
        'locationId': locationId || 0,
        'verticalId': verticalId || 0,
        'divisionId': divisionId || 0,
        'departmentId': departmentId || 0,
        'designationId': designationId || 0,
        'competencyFormId': 0,
        'UserAbrhs': misSession.userabrhs
    };
    calltoAjax(misApiUrl.getCompetencyList, "POST", jsonObject,
        function (result) {
            if (result != null && result.length > 0) {
                $('#ddlCompetency').append("<option value = 0>Select</option>");
                for (var x = 0; x < result.length; x++) {
                    $('#ddlCompetency').append("<option value = '" + result[x].Value + "'>" + result[x].Text + "</option>");
                }
                if (selectedId > 0) {
                    $('#ddlCompetency').val(selectedId);
                }
            }
        });
}

function bindPopupData(jsondata) {
    $('.requiredddl').closest('div').find('.select2-selection').removeClass("error-validation");
    $('.requiredtxt').removeClass("error-validation");
    $('#hdnempAppraisalSettingId').val(jsondata.EmpAppraisalSettingId);
    if (jsondata != null && jsondata.responseText != "") {
        $('#divstages').empty();
        if (jsondata.AppraisalJsonStatges != null) {
            $.each(JSON.parse(jsondata.AppraisalJsonStatges), function (key, splitvalue) {
                $('#divstages').append("<div class='form-group col-md-12'><label>" + splitvalue.AppraisalStageName + " End Date <span class='spnError'>*</span></label><div class='input-group'><div class='input-group-addon'> <i class='fa fa-calendar'></i></div><input id = 'txt" + splitvalue.AppraisalStageName.replace(" ", "").replace("/", "") + "' type='text' value= '" + splitvalue.EndDate + "' data-attr-value='" + splitvalue.AppraisalStageId + "' class='form-control required setrangedate'  data-mask=''></div></div>");
            });
            if (jsondata.IsHRBP == false) {
                $('#txt' + splitvalue.AppraisalStageName.replace(" ", "").replace("/", "")).attr("disabled", "disabled");
            }
        }
        if (jsondata.IsHRBP == true) {
            $('#divstages div.col-md-12').each(function () {
                var startDate = (typeof ($(this).prev().find('input').val()) === 'undefined') ? nextDate(jsondata.StartDate, 1) : nextDate($(this).prev().find('input').val(), 1);
                var endDate = (typeof ($(this).next().find('input').val()) === 'undefined') ? nextDate(jsondata.EndDate, 0) : nextDate($(this).next().find('input').val(), -1);
                $(this).find('input').datepicker({
                    autoclose: true,
                    todayHighlight: false,
                    format: "dd M yyyy",
                    startDate: startDate,
                    endDate: endDate,
                }).on('changeDate', function (ev) {
                    var fromStartDate = new Date(ev.date.valueOf() + 1000 * 3600 * 24);
                    var fromEndDate = new Date(ev.date.valueOf() - 1000 * 3600 * 24);
                    $(this).closest('div.col-md-12:not(:last)').nextAll().find('.setrangedate').val('');
                    $(this).closest('div.col-md-12').next().find('.setrangedate').datepicker('setStartDate', fromStartDate);
                    $(this).closest('div.col-md-12').prev().find('.setrangedate').datepicker('setEndDate', fromEndDate);
                });


            });

            $('#txtappraisalenddate').datepicker({
                autoclose: true,
                todayHighlight: false,
                format: "dd M yyyy",
                startDate: nextDate(jsondata.EndDate, 1)
            }).on('changeDate', function (ev) {
                var fromEndDate = new Date(ev.date.valueOf());
                $('input.setrangedate:last').val(this.value);
                $('input.setrangedate:last').datepicker('setEndDate', fromEndDate);
            });
        }

        BindAppraiserAprovers(jsondata.AppraiserIdAbrhs, jsondata.Approver1Abrhs);
        $('#hdnEmployeeId').val(jsondata.EmployeeId);
        $('#hdnAppraisalCycleId').val(jsondata.AppraisalCycleId);
        $('#hdnRMAccessId').val(jsondata.RMId);
        $('#myModalLabel').text(jsondata.EmployeeName);
        $('#ddlApprover1').select2('val', jsondata.Approver1);
        $('#ddlApprover2').select2('val', jsondata.Approver2);
        $('#ddlApprover3').select2('val', jsondata.Approver3);
        $('#ddlRmAcessId').select2('val', jsondata.RMAccessId);
        $('#spnDesignation').text("(" + jsondata.DesignationName + ")");
        $('#spnCycledate').text(jsondata.AppraisalCycleName);
        $('#txtCurrentDesignation').val(jsondata.DesignationName);

        $('#txtAppraiser').val(jsondata.AppraiserName);
        $('#txtReportingManager').val(jsondata.RMName);

        $('#txtappraisalstatdate').val(jsondata.StartDate);
        $('#txtappraisalenddate').val(jsondata.EndDate);

        $('#txtLastDone').val(jsondata.LastAppraisalCycleName);
        $('#txtNextDue').val(jsondata.NextAppraisalCycleName);

        $('#ddlCompetency').select2('val', jsondata.CompetencyFormId);

        $('#txtpromotionSecond').text((jsondata.SecondLastPromotionDate != '') ? "Last-1 Done (" + jsondata.SecondLastPromotionDate + ")" : "Last-1 Done");
        $('#txtpromotionFirst').text((jsondata.LastPromotionDate != '') ? "Last Done (" + jsondata.LastPromotionDate + ")" : "Last Done");
        $('#txtpromotionNext').text((jsondata.NextPromotionDate != '') ? "Next Designation (" + jsondata.NextPromotionDate + ")" : "Next Designation");

        $('#txtFirstDesignationName').val(jsondata.LastPromotionDesignationName);
        $('#txtSecondDesignationName').val(jsondata.SecondLastPromotionDesignationName);

        if (jsondata.RMId == $('#hdnLoginUserId').val() && jsondata.Approver1 != $('#hdnLoginUserId').val() && jsondata.Approver2 != $('#hdnLoginUserId').val() && jsondata.Approver3 != $('#hdnLoginUserId').val()) {
            $('#ddlRmAcessId').attr("disabled", "disabled");
        }
        else {
            $('#ddlRmAcessId').removeAttr("disabled");
        }

        if (jsondata.IsHRBP == true) {
            $('#chkselfAppraisal,#txtappraisalenddate').removeAttr("disabled");
            $('#txtappraisalstatdate').attr("disabled", "disabled");
        }
        else {
            $('#chkselfAppraisal,#txtappraisalstatdate,#txtappraisalenddate').attr("disabled", "disabled");
        }

        //if (parseInt(jsondata.AppraisalStatusId) > 4) {
        //    $('#ddlAppraiser').attr("disabled", "disabled");
        //}
        //if (parseInt(jsondata.AppraisalStatusId) > 5) {
        //    $('#ddlApprover1,#ddlApprover2,#ddlApprover3').attr("disabled", "disabled");
        //}

        if (parseInt(jsondata.AppraisalStatusId) == 6) {
            $('#ddlAppraiser,#ddlApprover1,#ddlApprover2,#ddlApprover3').attr("disabled", "disabled");
        }
        else if (parseInt(jsondata.AppraisalStatusId) == 5) {
            $('#ddlAppraiser').attr("disabled", "disabled");
        }
        else {
            $('#ddlAppraiser,#ddlApprover1,#ddlApprover2,#ddlApprover3').removeAttr("disabled");
        }

        if (jsondata.IsFormEditable == false) {
            $('#ddlCompetency').attr("disabled", "disabled");
        }
        $('#myModal').modal('show');
    }
}

$('#btnMTASave').click(function () {
    var success = 1;
    if (!validateControls('myModal')) {
        success = 0;
    }
    if ($('#ddlCompetency').closest('div').find('select').val() == null || $('#ddlCompetency').closest('div').find('select').val() == '0') {
        $('#ddlCompetency').closest('div').find('.select2-selection').addClass("error-validation");
        success = 0;
    }
    else {
        $('#ddlCompetency').closest('div').find('.select2-selection').removeClass("error-validation");
    }
    if (success == 0) {
        return;
    }

    var $inputs = $('#divstages :input');
    var collection = new Array();
    var items;
    $inputs.each(function (index) {
        items = new Object();
        items.AppraisalStageId = $(this).attr("data-attr-value");
        items.EndDate = $(this).val();
        collection.push(items);
    });

    var selfAppraisal = false;
    var isChecked = true; //$('#chkselfAppraisal').prop('checked');
    if (isChecked == true) {
        selfAppraisal = true;
    }

    var jsonObject = {
        EmpAppraisalSettingId: parseInt($('#hdnempAppraisalSettingId').val()),
        EmployeeId: parseInt($('#hdnEmployeeId').val()),
        AppraisalCycleId: parseInt($('#hdnAppraisalCycleId').val()),
        CompetencyFormId: parseInt($('#ddlCompetency').val()),
        AppraiserAbrhs: $('#ddlAppraiser').val(),
        Approver1Abrhs: $('#ddlApprover1').val(),
        Approver2: parseInt($('#ddlApprover2').val()),
        Approver3: parseInt($('#ddlApprover3').val()),
        StartDate: $('#txtappraisalstatdate').val(),
        EndDate: $('#txtappraisalenddate').val(),
        RMId: parseInt($('#ddlRmAcessId').val()),
        IsSelfAppraisal: selfAppraisal,
        AppraisalStagesList: collection,
        UserAbrhs: misSession.userabrhs,
    };
    calltoAjax(misApiUrl.updateAppraisalTeamSettings, "POST", jsonObject,
      function (result) {
          if (result.Status == 1) {
              GetTeamAppraisalSettingsList();
              $('#myModal').modal('hide');
              misAlert("Appraisal Settings has been updated successfully", "Success", "success");
          }
      });

});


//Filter.js Code 

function fetchCompanyLocationFilter(selectedId) {
    $('#ddlCountryMaster').empty();
    calltoAjax(misApiUrl.getCompanyLocation, "POST", '',
        function (result) {
            if (result != null && result.length > 0) {
                $('#ddlCountryMaster').append("<option value = 0>All</option>");
                for (var x = 0; x < result.length; x++) {
                    $('#ddlCountryMaster').append("<option value = '" + result[x].Value + "'>" + result[x].Text + "</option>");
                }
                if (selectedId > 0) {
                    $('#ddlCountryMaster').val(selectedId);
                }
            }
        });
}

function fetchVerticalFilter(selectedId) {
    $('#ddlVerticalMaster').empty();
    calltoAjax(misApiUrl.getVertical, "POST", '',
        function (result) {
            if (result != null && result.length > 0) {
                $('#ddlVerticalMaster').append("<option value = 0>Select</option>");
                for (var x = 0; x < result.length; x++) {
                    $('#ddlVerticalMaster').append("<option value = '" + result[x].Value + "'>" + result[x].Text + "</option>");
                }
                if (selectedId > 0) {
                    $('#ddlVerticalMaster').val(selectedId);
                }
            }
        });
}

function fetchDivisionFilter(verticalId, selectedId) {
    $('#ddlDivisionMaster').multiselect('destroy');
    $('#ddlDivisionMaster').empty();
    $('#ddlDivisionMaster').multiselect();
    var jsonObject = { 'verticalId': verticalId || 0 }
    var selectValue = 0;
    if (jsonObject.verticalId > 0) {
        calltoAjax(misApiUrl.getDivisionByVertical, "POST", jsonObject,
            function (result) {
                $.each(result, function (index, value) {
                    $('<option selected>').val(value.Value).text(value.Text).appendTo('#ddlDivisionMaster');
                });

                var divisions = (($('#ddlDivisionMaster').val() != null && typeof $('#ddlDivisionMaster').val() != 'undefined' && $('#ddlDivisionMaster').val().length > 0) ? $('#ddlDivisionMaster').val().join(',') : '0');
                fetchDepartmentFilter(divisions, 0);

                $('#ddlDivisionMaster').multiselect("destroy");
                $('#ddlDivisionMaster').multiselect({
                    includeSelectAllOption: true,
                    enableFiltering: true,
                    enableCaseInsensitiveFiltering: true,
                    buttonWidth: false,
                    onDropdownHidden: function (event) {
                    }
                });
            });
    }
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

function fetchDepartmentFilter(divisionIds, selectedId) {
    $('#ddlDepartmentMaster').multiselect('destroy');
    $('#ddlDepartmentMaster').empty();
    $('#ddlDepartmentMaster').multiselect();
    var jsonObject = { 'divisionIds': divisionIds }
    var selectValue = 0;
    calltoAjax(misApiUrl.getDepartmentByDivision, "POST", jsonObject,
        function (result) {
            $.each(result, function (index, value) {
                $('<option selected>').val(value.Value).text(value.Text).appendTo('#ddlDepartmentMaster');
            });
            var departmentIds = (($('#ddlDepartmentMaster').val() != null && typeof $('#ddlDepartmentMaster').val() != 'undefined' && $('#ddlDepartmentMaster').val().length > 0) ? $('#ddlDepartmentMaster').val().join(',') : '0');
            populatePopTeamMasterFilter(departmentIds, 0);

            $('#ddlDepartmentMaster').multiselect("destroy");
            $('#ddlDepartmentMaster').multiselect({
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                buttonWidth: false,
                onDropdownHidden: function (event) {
                }
            });
        });
}

function populatePopTeamMasterFilter(departmentIds, selectValue) {
    $('#ddlPopTeamMaster').multiselect('destroy');
    $('#ddlPopTeamMaster').empty();
    $('#ddlPopTeamMaster').multiselect();
    $('#ddlPopDesignationMatser').multiselect('destroy');
    $('#ddlPopDesignationMatser').empty();
    $('#ddlPopDesignationMatser').multiselect();
    var jsonObject = { departmentIds: departmentIds || 0 };
    if (jsonObject.departmentIds != '') {
        calltoAjax(misApiUrl.getTeamsByDepartment, "POST", jsonObject,
          function (result) {
              $('#ddlPopTeamMaster').multiselect("destroy");
              $('#ddlPopTeamMaster').empty();
              $.each(result, function (index, value) {
                  $('<option selected>').val(value.Value).text(value.Text).appendTo('#ddlPopTeamMaster');
              });
              var teamIds = (($('#ddlPopTeamMaster').val() != null && typeof $('#ddlPopTeamMaster').val() != 'undefined' && $('#ddlPopTeamMaster').val().length > 0) ? $('#ddlPopTeamMaster').val().join(',') : '');
              populateDesignationFilter(teamIds, '');

              var appraisalCycleId = $('#ddlAppraisalCycleMaster').val();
              var locationId = $('#ddlCountryMaster').val();
              var verticalId = $('#ddlVerticalMaster').val();
              var divisionIds = (($('#ddlDivisionMaster').val() != null && typeof $('#ddlDivisionMaster').val() != 'undefined' && $('#ddlDivisionMaster').val().length > 0) ? $('#ddlDivisionMaster').val().join(',') : '0');
              var departmentIds = (($('#ddlDepartmentMaster').val() != null && typeof $('#ddlDepartmentMaster').val() != 'undefined' && $('#ddlDepartmentMaster').val().length > 0) ? $('#ddlDepartmentMaster').val().join(',') : '0');
              var teamIds = (($('#ddlPopTeamMaster').val() != null && typeof $('#ddlPopTeamMaster').val() != 'undefined' && $('#ddlPopTeamMaster').val().length > 0) ? $('#ddlPopTeamMaster').val().join(',') : '0');
              fetchAppraiserFilter(appraisalCycleId, locationId, verticalId, divisionIds, departmentIds, teamIds);
              fetchApproverFilter(appraisalCycleId, locationId, verticalId, divisionIds, departmentIds, teamIds);

              $('#ddlPopTeamMaster').multiselect({
                  includeSelectAllOption: true,
                  enableFiltering: true,
                  enableCaseInsensitiveFiltering: true,
                  buttonWidth: false,
                  onDropdownHidden: function (event) {
                  }
              });
          });
    }
    else {
        destroyMultiselect("ddlPopTeamMaster");
        $("#ddlPopTeamMaster").empty();
        loadEmptyMultiSelect("ddlPopTeamMaster");
        populateDesignationFilter(0, 0, '', '');
    }
}

function populateDesignationFilter(teamIds, selectValue) {

    $('#ddlPopDesignationMaster').multiselect('destroy');
    $('#ddlPopDesignationMaster').empty();
    $('#ddlPopDesignationMaster').multiselect();
    var jsonObject = { teamIds: teamIds }
    var selectValue = 0;
    if (jsonObject.teamIds != '') {
        calltoAjax(misApiUrl.getDesignationsByTeams, "POST", jsonObject,
            function (result) {
                $.each(result, function (index, value) {
                    $('<option selected>').val(value.Value).text(value.Text).appendTo('#ddlPopDesignationMaster');
                });
                $('#ddlPopDesignationMaster').multiselect("destroy");
                $('#ddlPopDesignationMaster').multiselect({
                    includeSelectAllOption: true,
                    enableFiltering: true,
                    enableCaseInsensitiveFiltering: true,
                    buttonWidth: false,
                    onDropdownHidden: function (event) {
                    }
                });
            });
    }
}


function BindAppraiserAprovers(appraiserAbrhs, approverAbrhs) {

    var jsonObject = {
        userAbrhs: misSession.userabrhs
    }
    calltoAjax(misApiUrl.getAllReportingManager, "POST", jsonObject,
        function (result) {
            if (result != null && result.length > 0) {
                $("#ddlAppraiser").empty();
                $("#ddlAppraiser").append("<option value='0'>Select</option>");
                $("#ddlApprover1").empty();
                $("#ddlApprover1").append("<option value='0'>Select</option>");
                for (var i = 0; i < result.length ; i++) {
                    $("#ddlAppraiser").append("<option value = '" + result[i].EmployeeAbrhs + "'>" + result[i].EmployeeName + "</option>");
                    $("#ddlApprover1").append("<option value = '" + result[i].EmployeeAbrhs + "'>" + result[i].EmployeeName + "</option>");
                }
                if (appraiserAbrhs != null && appraiserAbrhs != '') {
                    $("#ddlAppraiser").val(appraiserAbrhs);
                }
                if (approverAbrhs != null && approverAbrhs != '') {
                    $("#ddlApprover1").val(approverAbrhs);
                }
            }
        });
}