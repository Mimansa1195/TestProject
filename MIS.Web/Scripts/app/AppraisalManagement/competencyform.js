$(document).ready(function () {
    //GetYears("#ddlYearMaster", 0);
    GetCompetencyFormsList();

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
        populateDesignationFilter(departmentIds, 0)
    });

});

$("#btnFilterReset").click(function () {
    fetchAppraisalCycleFilter(0);
    fetchCompanyLocationFilter(0);
    fetchVerticalFilter(0);
    fetchDivisionFilter(0, 0);
    fetchDepartmentFilter(0, 0);
    populateDesignationFilter(0, 0);
    GetYears("#ddlYearMaster", 0);
});

$("#btnAddCompetencyForm").click(function () {
    loadModal("addCompetencyForm", "addCompetencyFormContainer", misAppUrl.createCompetencyForm, true);
});

function GetYears(controlId, selectedId) {
    $(controlId).empty();
    calltoAjax(misApiUrl.getAppraisalParametersYears, "POST", '',
            function (result) {
                if (result != null && result.length > 0) {
                    $(controlId).append("<option value = 0>Select</option>");
                    for (var x = 0; x < result.length; x++) {
                        $(controlId).append("<option value = '" + result[x].Value + "'>" + result[x].Text + "</option>");
                    }
                    if (selectedId > 0) {
                        $(controlId).val(selectedId);
                    }
                }
            });
}

function GetCompetency(controlId, selectedId) {
    $(controlId).empty();
    calltoAjax(misApiUrl.getCompetency, "POST", '',
            function (result) {
                if (result != null && result.length > 0) {
                    $(controlId).append("<option value = 0>Select</option>");
                    for (var x = 0; x < result.length; x++) {
                        $(controlId).append("<option value = '" + result[x].Value + "'>" + result[x].Text + "</option>");
                    }
                    if (selectedId > 0) {
                        $(controlId).val(selectedId);
                    }
                }
            });
}

$("#btnFilterSearch").click(function () {
    if (!validateControls('divAppraisalSettingFilter')) {
        return false;
    }
    GetCompetencyFormsList();
});

function GetCompetencyFormsList() {

    var divisionIds = (($('#ddlDivisionMaster').val() != null && typeof $('#ddlDivisionMaster').val() != 'undefined' && $('#ddlDivisionMaster').val().length > 0) ? $('#ddlDivisionMaster').val().join(',') : '0');
    var departmentIds = (($('#ddlDepartmentMaster').val() != null && typeof $('#ddlDepartmentMaster').val() != 'undefined' && $('#ddlDepartmentMaster').val().length > 0) ? $('#ddlDepartmentMaster').val().join(',') : '0');
    var designationIds = (($('#ddlPopDesignationMaster').val() != null && typeof $('#ddlPopDesignationMaster').val() != 'undefined' && $('#ddlPopDesignationMaster').val().length > 0) ? $('#ddlPopDesignationMaster').val().join(',') : '0');

    var JsonObject = {
        LocationIds: $("#ddlCountryMaster").val() || 0,
        VerticalIds: $("#ddlVerticalMaster").val() || 0,
        DivisionIds: divisionIds,
        DepartmentIds: departmentIds,
        DesignationIds: designationIds,
        YearVal: $("#ddlAppraisalCycleMaster option:selected").text().split(' ').pop(),
        CompetencyFormId: 0
    };
    calltoAjax(misApiUrl.getCompetencyFormList, "POST", JsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#tblCompetencyForm").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                 {
                     filename: 'Competency Form List',
                     extend: 'collection',
                     text: 'Export',
                     buttons: [{ extend: 'copy' },
                                { extend: 'excel', filename: 'Competency Form List' },
                                { extend: 'pdf', filename: 'Competency Form List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                                { extend: 'print', filename: 'Competency Form List' },
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
                        "mData": "LocationName",
                        "sTitle": "Location",
                    },
                    {
                        "mData": "VerticalName",
                        "sTitle": "Vertical",
                    },
                    {
                        "mData": "DivisionName",
                        "sTitle": "Division",
                    },
                    {
                        "mData": "DepartmentName",
                        "sTitle": "Department",
                    },
                    {
                        "mData": "DesignationName",
                        "sTitle": "Designation",
                    },
                    {
                        "mData": null,
                        "sTitle": "Form Name",
                        "sWidth": '120px',
                        mRender: function (data, type, row) {
                            var html = "<span  data-toggle='tooltip' title='" + data.CompetencyFormName + "' class='text-color small-text-value'>" + data.CompetencyFormName + "</span>";//'<div style="word-wrap:word-wrap">' + row.CompetencyFormName + '</div>';
                            return html;
                        }
                    },
                    {
                        "mData": "CreatedDate",
                        "sTitle": "Created On",
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        "sWidth": '120px',
                        mRender: function (data, type, row) {
                            var html = '<div>';
                            if (row.IsFinalized) {
                                if (!row.IsRetired) {
                                    html += '<button type="button" data-toggle="tooltip" class="btn btn-sm btn-gemini"' + 'onclick="retireCompetencyForm(' + row.CompetencyFormId + ')" title="Retire"><i class="fa fa-user-times"></i></button>&nbsp;';
                                    html += '<button type="button" data-toggle="tooltip" class="btn btn-sm btn-gemini"' + 'onclick="loadCompetencyForm(' + row.CompetencyFormId + ')" title="Finalized"><i class="fa fa-eye"></i></button>&nbsp;';
                                }
                                else {
                                    html += '<button type="button" data-toggle="tooltip" class="btn btn-sm btn-gemini"' + 'onclick="loadCompetencyForm(' + row.CompetencyFormId + ')" title="Retired (' + row.RetiredDate + ')"><i class="fa fa-street-view"></i></button>&nbsp;';
                                }
                                html += '<button type="button" data-toggle="tooltip" class="btn btn-sm"' + 'onclick="openPopUpForCloneForm(' + row.CompetencyFormId + ')" title="Create Clone"><i class="fa fa-clone"></i></button>&nbsp;';
                            }
                            else {
                                html += '<button type="button" data-toggle="tooltip" class="btn btn-sm btn-danger"' + 'onclick="deleteCompetencyForm(' + row.CompetencyFormId + ')" title="Delete"><i class="fa fa-trash" aria-hidden="true"></i></button>&nbsp;';
                                html += '<button type="button" data-toggle="tooltip" class="btn btn-sm btn-success"' + 'onclick="openPopUpForCompetency(' + row.CompetencyFormId + ')" title="Edit"><i class="fa fa-edit"></i></button>&nbsp;';
                            }
                            html += '</div>'
                            return html;
                        }
                    },
                ]
            });
        });
}

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
            populateDesignationFilter(departmentIds, 0)

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

function populateDesignationFilter(departmentIds, selectValue) {

    $('#ddlPopDesignationMaster').multiselect('destroy');
    $('#ddlPopDesignationMaster').empty();
    $('#ddlPopDesignationMaster').multiselect();
    var jsonObject = { departments: departmentIds }
    var selectValue = 0;
    if (jsonObject.departments != '') {
        calltoAjax(misApiUrl.getDesignationsByDepartments, "POST", jsonObject,
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

function retireCompetencyForm(competencyFormId) {
    var reply = misConfirm("Are you sure you want to retire this form?", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                'competencyFormId': competencyFormId
            };
            calltoAjax(misApiUrl.retireCompetencyForm, "POST", jsonObject,
                function (result) {
                    if (result != 0) {
                        GetCompetencyFormsList();
                        misAlert('Competency form has been retire successfully.', "Success", "success");
                    }
                });
        }
    });
}

function loadCompetencyForm(competencyFormId) {
    var jsonObject = {
        'competencyFormId': competencyFormId
    };
    calltoAjax(misApiUrl.getCompetencyFormDataForEdit, "POST", jsonObject,
        function (result) {
            $('#popupViewForm').modal('show');
            if (result.CompetencyFormData != null) {
                $("#lblLocation").html(result.CompetencyFormData.LocationName);
                $("#lblVertical").html(result.CompetencyFormData.VerticalName);
                $("#lblDivision").html(result.CompetencyFormData.DivisionName);
                $("#lblDepartment").html(result.CompetencyFormData.DepartmentName);
                $("#lblDesignation").html(result.CompetencyFormData.DesignationName);
                $("#lblFormName").html(result.CompetencyFormData.CompetencyFormName);
            }
            if (result.CompetencyAndParameterListBO.length > 0) {
                var resultData = $.parseJSON(JSON.stringify(result.CompetencyAndParameterListBO));
                $("#tblCompetencyAndParameterList").dataTable({
                    "responsive": true,
                    "autoWidth": false,
                    "paging": false,
                    "bDestroy": true,
                    "searching": false,
                    "ordering": false,
                    "info": false,
                    "deferRender": true,
                    "aaData": resultData,
                    "aoColumns": [
                        {
                            "mData": "CompetencyType",
                            "sTitle": "CompetencyType",
                        },
                        {
                            "mData": "Parameter",
                            "sTitle": "Parameter",
                        },
                        {
                            "mData": "EvaluationCriteria",
                            "sTitle": "EvaluationCriteria",
                        },
                    ]
                });
            }
        });
}

function openPopUpForCloneForm(competencyFormId) {
    $("#hdnCompetencyFormIdClone").val(competencyFormId);
    loadModal("CloneCompetencyForm", "CloneCompetencyFormContainer", misAppUrl.cloneCompetencyForm, true);
}

function deleteCompetencyForm(competencyFormId) {
    var reply = misConfirm("Are you sure you want to delete this competency form?", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                'competencyFormId': competencyFormId
            };
            calltoAjax(misApiUrl.deleteCompetencyForm, "POST", jsonObject,
                function (result) {
                    if (result != 0) {
                        GetCompetencyFormsList();
                        misAlert('Competency form has been deleted successfully.', "Success", "success");
                    }
                });
        }
    });
}

function openPopUpForCompetency(competencyFormId) {
    $("#hdnCompetencyFormId").val(competencyFormId);
    loadModal("EditCompetencyForm", "EditCompetencyFormContainer", misAppUrl.editCompetencyForm, true);
}