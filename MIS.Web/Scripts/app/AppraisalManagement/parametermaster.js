$(document).ready(function () {
    GetCompetency("#ddlCompetency", 0);
    GetAppraisalParametersYears("#ddlYear", 0);
    GetParameterList();
});

function GetCompetency(controlId, selectedId) {
    $(controlId).empty();
    calltoAjax(misApiUrl.getCompetency, "POST", '',
            function (result) {
                if (result !== null && result.length > 0) {
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

function GetAppraisalParametersYears(controlId, selectedId) {
    $(controlId).empty();
    calltoAjax(misApiUrl.getAppraisalParametersYears, "POST", '',
            function (result) {
                if (result !== null && result.length > 0) {
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

$("#btnSearchParameter").click(function () {
    if (!validateControls('filterDiv')) {
        return false;
    }

    GetParameterList();
});

$("#btnAddParameter").click(function () {
    loadModal("popupAddParameter", "modalAddParameter", misAppUrl.addAppraisalParameter, true);
});

$("#btnUpdateParameter").click(function () {
    if (!validateControls('modalEditParameter')) {
        return false;
    }
    var JsonObject = {
        parameterId: _parameterId,
        competencyTypeId: $("#ddlCompetencyEdit").val(),
        parameterName: $("#parameterNameEdit").val(),
        weightage: $("#ddlWeightageEdit").val()
    };
    calltoAjax(misApiUrl.updateParameter, "POST", JsonObject,
        function (result) {
            if (result === 1) {
                misAlert("Parameter has been updated successfully.", "Success", "success");
                GetParameterList();
                $("#popupEditParameter").modal('hide');
            }
        });
});

function GetParameterList() {
    var JsonObject = {
        competencyTypeId: $("#ddlCompetency").val() || 0,
        year: $("#ddlYear").val() || 0,
        status: $("#ddlStatus").val() || 0
    };
    calltoAjax(misApiUrl.getParameterList, "POST", JsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#tblParameterList").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                 {
                     filename: 'Parameter List',
                     extend: 'collection',
                     text: 'Export',
                     buttons: [{ extend: 'copy' },
                                { extend: 'excel', filename: 'Parameter List' },
                                { extend: 'pdf', filename: 'Parameter List' },
                                { extend: 'print', filename: 'Parameter List' },
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
                        "mData": "ParameterName",
                        "sTitle": "Parameter",
                        'bSortable': true
                    },
                    {
                        "mData": "CompetencyTypeName",
                        "sTitle": "Competency",
                        'bSortable': true
                    },
                    {
                        "mData": "Weightage",
                        "sTitle": "Weightage",
                        'bSortable': true
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        mRender: function (data, type, row) {
                            var html = '<div>';
                            if (!row.IsFinalized) {
                                if (row.IsActive) {
                                    html += '<button type="button" data-toggle="tooltip" class="btn btn-sm btn-gemini"' + 'onclick="finalizeParameter(' + row.ParameterId + ')" title="Finalize"><i class="fa fa-thumbs-up" aria-hidden="true"></i></button>';
                                    html += '&nbsp;<button type="button" data-toggle="tooltip" class="btn btn-sm"' + 'onclick="editParameter(' + row.ParameterId + ',' + row.CompetencyTypeId + ',\'' + row.ParameterName + '\',' + row.Weightage + ')" title="Edit"><i class="fa fa-pencil-square-o" aria-hidden="true"></i></button>';
                                    html += '&nbsp;<button type="button" data-toggle="tooltip" class="btn btn-sm btn-success"' + 'onclick="changeStatus(' + row.ParameterId + ')" title="DeActivate"><i class="fa fa-check" aria-hidden="true"></i></button>';
                                    html += '&nbsp;<button type="button" data-toggle="tooltip" class="btn btn-sm btn-danger"' + 'onclick="deleteParameter(' + row.ParameterId + ')" title="Delete"><i class="fa fa-trash" aria-hidden="true"></i></button>';
                                }
                                else {
                                    html += '&nbsp;<button type="button" data-toggle="tooltip" class="btn btn-sm"' + 'onclick="editParameter(' + row.ParameterId + ',' + row.CompetencyTypeId + ',\'' + row.ParameterName + '\',' + row.Weightage + ')" title="Edit"><i class="fa fa-pencil-square-o" aria-hidden="true"></i></button>';
                                    html += '&nbsp;<button type="button" data-toggle="tooltip" class="btn btn-sm btn-danger"' + 'onclick="changeStatus(' + row.ParameterId + ')" title="Activate"><i class="fa fa-ban" aria-hidden="true"></i></button>';
                                    html += '&nbsp;<button type="button" data-toggle="tooltip" class="btn btn-sm btn-danger"' + 'onclick="deleteParameter(' + row.ParameterId + ')" title="Delete"><i class="fa fa-trash" aria-hidden="true"></i></button>';
                                }
                            }
                            else {
                                html += 'Finalized';
                            }
                            html += '</div>'
                            return html;
                        }
                    },
                ]
            });
        });
}

function editParameter(parameterId, competencyTypeId, parameterName, weightage) {
    _parameterId = parameterId;
    $("#popupEditParameter").modal('show');
    GetCompetency("#ddlCompetencyEdit", competencyTypeId);
    $("#parameterNameEdit").val(parameterName);
    $("#ddlWeightageEdit").val(weightage);
}

function finalizeParameter(parameterId) {
    misConfirm("Are you sure you want to finalize ?", "Confirm", function (isConfirmed) {
        if (isConfirmed) {
            var JsonObject = {
                parameterId: parameterId
            };
            calltoAjax(misApiUrl.finalizeParameter, "POST", JsonObject,
                function (result) {
                    if (result === 1) {
                        misAlert("Parameter has been finalized.", "Success", "success");
                        GetParameterList();
                    }
                });
        }
    });
}

function changeStatus(parameterId) {
    misConfirm("Are you sure you want to change the status ?", "Confirm", function (isConfirmed) {
        if (isConfirmed) {
            var JsonObject = {
                parameterId: parameterId
            };
            calltoAjax(misApiUrl.changeStatus, "POST", JsonObject,
                function (result) {
                    if (result === 1) {
                        misAlert("Parameter status has been changed.", "Success", "success");
                        GetParameterList();
                    }
                });
        }
    });
}

function deleteParameter(parameterId) {
    misConfirm("Are you sure you want to delete ?", "Confirm", function (isConfirmed) {
        if (isConfirmed) {
            var JsonObject = {
                parameterId: parameterId
            };
            calltoAjax(misApiUrl.deleteParameter, "POST", JsonObject,
                function (result) {
                    if (result === 1) {
                        misAlert("Parameter has been deleted.", "Success", "success");
                        GetParameterList();
                    }
                });
        }
    });
}

