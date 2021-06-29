$(document).ready(function () {
    loadAppraisalCycleGrid();
});

function loadAppraisalCycleGrid() {
    calltoAjax(misApiUrl.getAllAppraisalCycles, "POST", '',
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#tblAppraisalCycleList").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                 {
                     filename: 'Appraisal Cycles',
                     extend: 'collection',
                     text: 'Export',
                     buttons: [{ extend: 'copy' },
                                { extend: 'excel', filename: 'Appraisal Cycles' },
                                { extend: 'pdf', filename: 'Appraisal Cycles' }, 
                                { extend: 'print', filename: 'Appraisal Cycles' },
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
                "deferRender": true,
                "aaData": resultData,
                "aoColumns": [
                    { "mData": "AppraisalCycleName", "sTitle": "Appraisal Cycle" },
                    { "mData": "Country", "sTitle": "Country" },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        "sClass": "text-center",
                        mRender: function (data, type, row) {
                            var html = '<div>';
                            html += '<button type="button" class="btn btn-sm teal"' + 'onclick="editAppraisalCycle(\'' + row.AppraisalCycleAbrhs + '\')" data-toggle="tooltip" title="Edit"><i class="fa fa-edit"></i></button>';
                            html += '&nbsp;<button type="button" data-toggle="tooltip" class="btn btn-sm btn-danger"' + 'onclick="deletedAppraisalCycle(\'' + row.AppraisalCycleAbrhs + '\')"  title="Delete"><i class="fa fa-trash"></i></button>';
                            html += '</div>'
                            return html;
                        }
                    }
                ]
            });
        });
}

function addAppraisalCycle() {
    $("#modaladdAppraisalCycle").modal('show');
    bindCountry(0, 'ddlCountryAdd');
    bindYearDDL(0, 'ddlAppraisalYearAdd');
    bindMonth(0, 'ddlAppraisalMonthAdd');
}

$("#btnSaveAppraisalCycle").click(function () {
    if (!validateControls('modaladdAppraisalCycle')) {
        return false;
    }
    var jsonObject = {
        AppraisalCycleAbrhs: "",
        CountryId: $("#ddlCountryAdd").val(),
        AppraisalMonth: $("#ddlAppraisalMonthAdd").val(),
        AppraisalYear: $("#ddlAppraisalYearAdd").val(),
        UserAbrhs: misSession.userabrhs
    };

    calltoAjax(misApiUrl.addAppraisalCycle, "POST", jsonObject,
    function (result) {
        var resultData = $.parseJSON(JSON.stringify(result));
        switch (resultData) {
            case 1:
                misAlert("Appraisal Cycle has been saved successfully", "Success", "success");
                $("#modaladdAppraisalCycle").modal('hide');
                loadAppraisalCycleGrid();
                break;
            case 2:
                misAlert("Appraisal Cycle Already Exist.", "Warning", "warning");
                break;
        }
    });
});

$("#btnClose").click(function () {
    $("#modaladdAppraisalCycle").modal('hide');
});

$("#btnEditClose").click(function () {
    $("#modalEditAppraisalCycle").modal('hide');
});

function bindCountry(preSelectedId, ddlId) {
    $('#' + ddlId + '').empty();
    $('#' + ddlId + '').append($("<option></option>").val(0).html("Select"));
    calltoAjax(misApiUrl.getCountries, "POST", '',
        function (data) {
            $.each(data, function (idx, item) {
                $('#' + ddlId + '').append($("<option></option>").val(item.Value).html(item.Text));
            });
            if (preSelectedId > 0) {
                $('#' + ddlId + '').val(preSelectedId)
            }
        });
}

function bindYearDDL(preSelectedYear, ddlId) {
    var startYr;
    var endYear;
    if (preSelectedYear > 0) { //edit
        startYr = preSelectedYear - 5;
        endYear = preSelectedYear + 5;
    }
    else { //add
        var currentYear = (new Date()).getFullYear();
        startYr = 2012;
        endYear = currentYear + 5;
    }

    $('#' + ddlId + '').empty();
    $('#' + ddlId + '').append($("<option></option>").val(0).html("Select"));
    if (startYr > 0 && endYear > 0) {
        for (t = startYr; t <= endYear; t++) {
            $('#' + ddlId + '').append("<option value = '" + t + "'>" + t + "</option>");
        }
        if (preSelectedYear != null) {
            $('#' + ddlId + '').val(preSelectedYear);
        }
    }
}

function bindMonth(preSelectedId, ddlId) {
    $('#' + ddlId + '').empty();
    $('#' + ddlId + '').append($("<option></option>").val(0).html("Select"));
    var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    $.each(months, function (idx, item) {
        $('#' + ddlId + '').append($("<option></option>").val(idx + 1).html(item));
    });
    if (preSelectedId > 0) {
        $('#' + ddlId + '').val(preSelectedId)
    }
}

function editAppraisalCycle(AppraisalCycleAbrhs) {
    _AppraisalCycleAbrhs = AppraisalCycleAbrhs;
    var jsonObject = {
        AppraisalCycleAbrhs: AppraisalCycleAbrhs
    };

    calltoAjax(misApiUrl.getAppraisalCycle, "POST", jsonObject,
    function (result) {
        var resultData = $.parseJSON(JSON.stringify(result));
        $("#modalEditAppraisalCycle").modal('show');

        bindCountry(resultData.CountryId, 'ddlCountryEdit');
        bindYearDDL(resultData.AppraisalYear, 'ddlAppraisalYearEdit');
        bindMonth(resultData.AppraisalMonth, 'ddlAppraisalMonthEdit');
    });
}

function deletedAppraisalCycle(AppraisalCycleAbrhs) {
    misConfirm("Are you sure you want to delete ?", "Confirm", function (isConfirmed) {
        if (isConfirmed) {
            var jsonObject = {
                AppraisalCycleAbrhs: AppraisalCycleAbrhs
            };

            calltoAjax(misApiUrl.deleteAppraisalCycle, "POST", jsonObject,
            function (result) {
                if (result == 1) {
                    misAlert("Appraisal Cycle has been deleted successfully", "Success", "success");
                    loadAppraisalCycleGrid();
                }
            });
        }
    });
}

$("#btnUpdateAppraisalCycle").click(function () {
    if (!validateControls('modalEditAppraisalCycle')) {
        return false;
    }

    var jsonObject = {
        AppraisalCycleAbrhs: _AppraisalCycleAbrhs,
        CountryId: $("#ddlCountryEdit").val(),
        AppraisalMonth: $("#ddlAppraisalMonthEdit").val(),
        AppraisalYear: $("#ddlAppraisalYearEdit").val(),
        UserAbrhs: misSession.userabrhs
    };

    calltoAjax(misApiUrl.updateAppraisalCycle, "POST", jsonObject,
    function (result) {
        var resultData = $.parseJSON(JSON.stringify(result));
        switch (resultData) {
            case 1:
                misAlert("Appraisal Cycle has been updated successfully", "Success", "success");
                $("#modalEditAppraisalCycle").modal('hide');
                loadAppraisalCycleGrid();
                break;
            case 2:
                misAlert("Appraisal Cycle already exist.", "Warning", "warning");
                break;
        }
    });
});
