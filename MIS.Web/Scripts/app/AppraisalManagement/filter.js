$(function () {
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

function fetchCompanyLocationFilter(selectedId) {
    $('#ddlCountryMaster').empty();
    calltoAjax(misApiUrl.getCompanyLocation, "POST", '',
        function (result) {
            if (result != null && result.length > 0) {
                $('#ddlCountryMaster').append("<option value = 0>Select</option>");
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
