var _achievementList, _id, _rmComments, _discussHR, _selectedEmployee;
$(function () {
    bindAllReportingEmployeesForMonthly();
    
    $('a[href ="#tabMonthlyTeamPimcoAchievement"]').on('click', function () {
        if ($.fn.DataTable.isDataTable('#tblViewTeamPimcoMonthlyAchievementsList')) {
            $('#tblViewTeamPimcoMonthlyAchievementsList tbody').empty();
        }
        bindAllReportingEmployeesForMonthly();
    });

    $('a[href ="#tabQuarterlyTeamPimcoAchievement"]').on('click', function () {
        if ($.fn.DataTable.isDataTable('#tblViewTeamPimcoAchievementsList')) {
            $('#tblViewTeamPimcoAchievementsList tbody').empty();
        }
        bindAllReportingEmployees(); 
    });

    //getTeamPimcoAchievement();
    //Monthly
    $('#ddlEmployeeForMonthly').multiselect({
        includeSelectAllOption: true,
        enableFiltering: true,
        enableCaseInsensitiveFiltering: true,
        buttonWidth: false,
        onDropdownHidden: function (event) {
        }
    });

    $('#ddlMonth').multiselect({
        includeSelectAllOption: true,
        enableFiltering: true,
        enableCaseInsensitiveFiltering: true,
        buttonWidth: false,
        onDropdownHidden: function (event) {
        }
    });

    $("#ddlEmployeeForMonthly").change(function () {
        getTeamPimcoMonthlyAchievement();
    });

    $("#financialYearForMonthly").change(function () {
        bindMonths();
    });

    $("#ddlMonth").change(function () {
        getTeamPimcoMonthlyAchievement();
    });

    //Quarterly
    $('#ddlEmployee').multiselect({
        includeSelectAllOption: true,
        enableFiltering: true,
        enableCaseInsensitiveFiltering: true,
        buttonWidth: false,
        onDropdownHidden: function (event) {
        }
    });

    $('#quarter').multiselect({
        includeSelectAllOption: true,
        enableFiltering: true,
        enableCaseInsensitiveFiltering: true,
        buttonWidth: false,
        onDropdownHidden: function (event) {
        }
    });

    $("#ddlEmployee").change(function () {
        getTeamPimcoAchievement();
    });

    $("#financialYear").change(function () {
        bindQuarters();
    });

    $("#quarter").change(function () {
        getTeamPimcoAchievement();
    });

    $("#saveRMComment").on('click', function () {
        if (!validateControls('modalViewTeamPimcoAchievementPopUp')) {
            return false;
        }
        sumbitRMComment();
    });

    //Add Team Achievement Monthly
    
    $("#btnAddTeamPimcoMonthlyAchievement").on('click', function () {
        $("#btnSubmitTeamPimcoMonthlyAchievement").hide();
        $("#modalAddTeamPimcoMonthlyAchievement").modal({
            backdrop: 'static',
            keyboard: false
        });
        $("#ddlEmployeeToAddMonthlyAchievements").removeClass("error-validation");
        $("#monthToAddAchievements").removeClass("error-validation");
        $("#divAddTeamMonthlyAchievement").hide();
        $("#dynamicAddTeamPimcoMonthlyAchievement").empty();
        $("#empCommentsToAddMonthlyAchievement").val("");
        bindAllEmployeesToAddMonthlyAchievement();
        $("#modalAddTeamPimcoMonthlyAchievement").modal('show');
    });

    $("#financialYearToAddMonthlyAchievements").change(function () {
        bindMonthsToAddMonthlyAchievement();
    });

    $("#ddlEmployeeToAddMonthlyAchievements").change(function () {
        $("#dynamicAddTeamPimcoMonthlyAchievement").empty();
        $("#empCommentsToAddMonthlyAchievement").val("");
        checkIfAllowedToFillTeamMonthlyAchievement();
    });

    $("#monthToAddAchievements").change(function () {
        $("#dynamicAddTeamPimcoMonthlyAchievement").empty();
        $("#empCommentsToAddMonthlyAchievement").val("");
        checkIfAllowedToFillTeamMonthlyAchievement();
    });

    $("#btnSubmitTeamPimcoMonthlyAchievement").click(function () {
        if (!validateControls("modalAddTeamPimcoMonthlyAchievement"))
            return false;

        if (getMonthlyAchievementData().length === 0) {
            misAlert("No pimco achievements have been added.", "Warning", "warning");
            return false;
        }
        else {
            misConfirm("<span style='color:red;'>This is one time activity. Once submitted, you won't be able to modify it or add achievements for this month of financial year.</span>", "Confirm", function (isConfirmed) {
                if (isConfirmed) {
                    submitTeamMonthlyAchievement();
                }
            }, false, true, true);
        }
    });

    $("#btnAddNewTeamPimcoMonthlyAchievement").click(function () {
        if (!validateControls('dynamicAddTeamPimcoMonthlyAchievement')) {
            return false;
        } 
        generateMonthlyAchievementControls('dynamicAddTeamPimcoMonthlyAchievement');
        $('.select2').select2();
    });


    //Add Team Achievement Quarterly
    $("#btnAddTeamPimcoAchievement").on('click', function () {
        $("#btnSubmitTeamPimcoAchievement").hide();
        $("#modalAddTeamPimcoAchievement").modal({
            backdrop: 'static',
            keyboard: false
        });
        $("#ddlEmployeeToAddAchievements").removeClass("error-validation");
        $("#quarterToAddAchievements").removeClass("error-validation");
        $("#divAddTeamAchievement").hide();
        $("#dynamicAddTeamPimcoAchievement").empty();
        $("#empCommentsToAddAchievement").val("");
        bindAllEmployeesToAddAchievement();
        $("#modalAddTeamPimcoAchievement").modal('show');
       
    });

    $("#financialYearToAddAchievements").change(function () {
        bindQuartersToAddAchievement();
    });

    $("#ddlEmployeeToAddAchievements").change(function () {
        $("#dynamicAddTeamPimcoAchievement").empty();
        $("#empCommentsToAddAchievement").val("");
        checkIfAllowedToFillTeamAchievement();
    });

    $("#quarterToAddAchievements").change(function () {
        $("#dynamicAddTeamPimcoAchievement").empty();
        $("#empCommentsToAddAchievement").val("");
        checkIfAllowedToFillTeamAchievement();
    });

    $("#btnSubmitTeamPimcoAchievement").click(function () {
        if (!validateControls("modalAddTeamPimcoAchievement"))
            return false;

        if (getAchievementData().length === 0) {
            misAlert("No pimco achievements have been added.", "Warning", "warning");
            return false;
        }
        else {
            misConfirm("<span style='color:red;'>This is one time activity. Once submitted, you won't be able to modify it or add achievements for this quarter of financial year.</span>", "Confirm", function (isConfirmed) {
                if (isConfirmed) {
                    submitTeamQuarterlyAchievement();
                }
            }, false, true, true);
        }
    });

    $("#btnAddNewTeamPimcoAchievement").click(function () {
        if (!validateControls('dynamicAddTeamPimcoAchievement')) {
            return false;
        }
        generateAchievementControls('dynamicAddTeamPimcoAchievement');
        $('.select2').select2();
    });
});

//Monthly

function bindAllReportingEmployeesForMonthly() {
    $("#ddlEmployeeForMonthly").multiselect('destroy');
    $("#ddlEmployeeForMonthly").empty();
    $('#ddlEmployeeForMonthly').multiselect();
    calltoAjax(misApiUrl.getAllEmployeesReportingToUser, "POST", '',
        function (result) {
            if (result != null && result.length > 0) {

                for (var x = 0; x < result.length; x++) {
                    $("#ddlEmployeeForMonthly").append("<option value = '" + result[x].EmployeeAbrhs + "'>" + result[x].EmployeeName + "</option>");
                }
                $('#ddlEmployeeForMonthly').multiselect("destroy");
                $('#ddlEmployeeForMonthly').multiselect({
                    includeSelectAllOption: true,
                    enableFiltering: true,
                    enableCaseInsensitiveFiltering: true,
                    buttonWidth: false,
                    onDropdownHidden: function (event) {
                    }
                });
                $("#ddlEmployeeForMonthly").multiselect('selectAll', false);
                $("#ddlEmployeeForMonthly").multiselect('updateButtonText');
                bindFinancialYearForMonthly();
            }
        });
}

function bindFinancialYearForMonthly() {
    calltoAjax(misApiUrl.getFinancialYears, "POST", '',
        function (result) {
            if (result !== null)
                $.each(result, function (index, item) {
                    $("#financialYearForMonthly").append($("<option></option>").val(item.StartYear).html(item.Text));
                });
            bindMonths();
        });
}

function bindMonths() {
    $("#ddlMonth").multiselect('destroy');
    $("#ddlMonth").empty();
    $('#ddlMonth').multiselect();
    var year = $("#financialYearForMonthly").val();
    if (year == null)
        year = misSession.fystartyear; /*new Date().getMonth() + 1 < 4 ? new Date().getFullYear() - 1 : new Date().getFullYear();*/
    var jsonObject = {
        year: year
    }
    calltoAjax(misApiUrl.getMonths, "POST", jsonObject,
        function (result) {
            if (result !== null)
                $.each(result, function (index, item) {
                    $("#ddlMonth").append($("<option></option>").val(item.StartYear).html(item.Text));
                });
            $('#ddlMonth').multiselect("destroy");
            $('#ddlMonth').multiselect({
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                buttonWidth: false,
                onDropdownHidden: function (event) {
                }
            });
            $("#ddlMonth").multiselect('selectAll', false);
            $("#ddlMonth").multiselect('updateButtonText');
            getTeamPimcoMonthlyAchievement();
        });
}

function getTeamPimcoMonthlyAchievement() {
    var userAbrhs = "";
    var months = "";
    if ($('#ddlEmployeeForMonthly').val() !== null) {
        userAbrhs = $('#ddlEmployeeForMonthly').val().join(",");
    }
    if ($('#ddlMonth').val() !== null) {
        months = $('#ddlMonth').val().join(",");
    }
    var jsonObject = {
        fyYear: $("#financialYearForMonthly").val(),
        months: months,
        userAbrhs: userAbrhs
    };
    calltoAjax(misApiUrl.getTeamPimcoMonthlyAchievements, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblViewTeamPimcoMonthlyAchievementsList").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'Achievement List',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        {
                            extend: 'excelHtml5', filename: 'Achievement List',
                            exportOptions: {
                                columns: [0, 1, 2, 3, 6, 7, 8],
                                format: {
                                    body: function (data, column, row) {
                                        return row == 7 ? data.replace(/<br>/g, '' + "\r\n" + '') : data;
                                    }
                                }
                            }
                        },
                            //{ extend: 'pdf', filename: 'Achievement List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                            //{ extend: 'print', filename: 'Achievement List' },
                        ]
                    }],
                "responsive": true,
                "autoWidth": false,
                "paging": true,
                "bDestroy": true,
                "ordering": true,
                "footer": true,
                "order": [],
                "info": true,
                "deferRender": true,
                "aaData": data,
                "aoColumns": [
                    {
                        "mData": "EmployeeName",
                        "sTitle": "Employee Name",
                        "sWidth": "100px",
                    },
                    {
                        "mData": "DesignationName",
                        "sTitle": "Designation",
                        "sWidth": "100px",
                    },
                    {
                        "mData": "Department",
                        "sTitle": "Department",
                        "sWidth": "100px",
                    },
                    {
                        "mData": "Team",
                        "sTitle": "Team",
                        "sWidth": "100px",
                    },
                    {
                        "mData": null,
                        "sTitle": "Employee",
                        "sClass": "text-center",
                        "sWidth": "200px",
                        mRender: function (data, type, row) {
                            return "<td class='halign-center'><img  onerror=\"this.src='../img/avatar-sign.png'\" src='" + data.EmployeePhotoName + "' class='img-circle' alt='User Image'><br/>" + data.EmployeeName + "<br/>" + data.DesignationName + "</td>";
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Department/Team",
                        "sClass": "text-left",
                        "sWidth": "200px",
                        mRender: function (data, type, row) {
                            var html = '<b> Dept: </b>' + row.Department;
                            html = html + '<br /><br />' + '<b> Team: </b>' + row.Team
                            return html;
                        }
                    },
                    {
                        "mData": "ReportingManager",
                        "sTitle": "Reporting Manager",
                        "swidth": "100px"
                    },
                    //{
                    //    "mData": null,
                    //    "sTitle": "Emp Comments",
                    //    "swidth": "100px",
                    //    mRender: function (data, type, row) {
                    //        if (data.EmpComments == "")
                    //            return "N.A";
                    //        else
                    //            return data.EmpComments;
                    //    },
                    //},
                    {
                        "mData": "SubmittedDate",
                        "sTitle": "Submitted On",
                        "swidth": "80px"
                    },
                    {
                        "mData": null,
                        'bSortable': false,
                        "sClass": "text-center",
                        "sTitle": "Action",
                        mRender: function (data, type, row) {
                            var id = row.PimcoAchievementId;
                            var html = '';
                            html += '<button type="button" class="btn btn-sm btn-success"' + 'onclick="viewMonthlyAchievements(' + id + ')" title="view"><i class="fa fa-eye" ></i></button>';
                            return html;
                        },
                    }
                ],
                //'rowCallback': function (row, data, dataIndex) {
                //    var table = $("#tblViewTeamAchievementsList").DataTable();
                //    table.columns([0, 1, 2, 3]).visible(false);
                //},
                "fnInitComplete": function (row) {
                    //if (typeof (data) == 'undefined' || data === null || !(data.length > 0)) {
                    var table = $("#tblViewTeamPimcoMonthlyAchievementsList").DataTable();
                    table.columns([0, 1, 2, 3]).visible(false);
                    //}
                }
            });
        }

    );
}

function viewMonthlyAchievements(id) {
    _id = id;
    var jsonObject = {
        pimcoAchievementId: id
    }
    calltoAjax(misApiUrl.getPimcoMonthlyAchievementsOfTeamById, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblViewTeamPimcoMonthlyAchievements").dataTable({
                "responsive": true,
                "autoWidth": false,
                "paging": false,
                "bDestroy": true,
                "searching": false,
                "ordering": false,
                "info": false,
                "deferRender": true,
                "aaData": data,
                "aoColumns": [
                    {
                        "mData": "SNo",
                        "sTitle": "SNo",
                        "swidth": "50px"
                    },
                    {
                        "mData": "ProjectName",
                        "sTitle": "Pimco Project",
                        "swidth": "50px"
                    },
                    {
                        "mData": "Achievement",
                        "sTitle": "Achievement",
                        "swidth": "50px"
                    }
                ]
            });
        });
    $("#modalViewTeamPimcoMonthlyAchievementPopUp").modal('show');
}


//Add Team Achievement

function bindAllEmployeesToAddMonthlyAchievement() {
    $("#ddlEmployeeToAddMonthlyAchievements").empty();
    $('#ddlEmployeeToAddMonthlyAchievements').append("<option value ='0'>Select</option>");
    calltoAjax(misApiUrl.getAllEmployeesReportingToUser, "POST", '',
        function (result) {
            if (result != null && result.length > 0) {
                for (var x = 0; x < result.length; x++) {
                    $("#ddlEmployeeToAddMonthlyAchievements").append("<option value = '" + result[x].EmployeeAbrhs + "'>" + result[x].EmployeeName + "</option>");
                }
                bindFinancialYearToAddMonthlyAchievement();
            }
        });
}

function bindFinancialYearToAddMonthlyAchievement() {
    $("#financialYearToAddMonthlyAchievements").empty();
    $('#financialYearToAddMonthlyAchievements').append("<option value ='0'>Select</option>");
    calltoAjax(misApiUrl.getFinancialYears, "POST", '',
        function (result) {
            if (result !== null)
                $.each(result, function (index, item) {
                    $("#financialYearToAddMonthlyAchievements").append($("<option></option>").val(item.StartYear).html(item.Text));
                });
            bindMonthsToAddMonthlyAchievement();
        });
}

function bindMonthsToAddMonthlyAchievement() {
    $("#monthToAddAchievements").empty();
    $('#monthToAddAchievements').append("<option value ='0'>Select</option>");
    var year = $("#financialYearToAddMonthlyAchievements").val();
    if (year !== "0") {
        if (year == null)
            year = misSession.fystartyear; /*new Date().getMonth() + 1 < 4 ? new Date().getFullYear() - 1 : new Date().getFullYear();*/
        var jsonObject = {
            year: year
        }
        calltoAjax(misApiUrl.getMonths, "POST", jsonObject,
            function (result) {
                if (result !== null) {
                    $.each(result, function (index, item) {
                        $("#monthToAddAchievements").append($("<option></option>").val(item.StartYear).html(item.Text));
                    });
                   
                }
            });
    }
}

function bindPimcoProjects(controlId) {
    $(controlId).empty();
    $(controlId).append($("<option></option>").val(0).html("Select"));
    
    var jsonObject = {
        userAbrhs: _selectedEmployee
    };
    calltoAjax(misApiUrl.getPimcoProjects, "POST", jsonObject,
        function (result) {
            if (result !== null) {
                $.each(result, function (index, item) {
                    $(controlId).append($("<option></option>").val(item.ProjectId).html(item.ProjectName));
                });
                $(controlId).val(0);
            }
        });
}

function checkIfAllowedToFillTeamMonthlyAchievement() {
    var year = $("#financialYearToAddMonthlyAchievements").val();
    var month = $("#monthToAddAchievements").val();
    var selectedEmpAbrhs = $("#ddlEmployeeToAddMonthlyAchievements").val();
    _selectedEmployee = selectedEmpAbrhs;

    if (year !== "0" && quarter !== "0" && selectedEmpAbrhs!= "0") {
        if (year == null)
            year = misSession.fystartyear; /*new Date().getMonth() + 1 < 4 ? new Date().getFullYear() - 1 : new Date().getFullYear();*/
        var jsonObject = {
            year: year,
            mNumber: month,
            userAbrhs: selectedEmpAbrhs
        }
        calltoAjax(misApiUrl.checkIfAllowedToFillPimcoMonthlyAchievements, "POST", jsonObject,
            function (result) {
                var resultData = $.parseJSON(JSON.stringify(result));
                switch (resultData) {
                    case 3:
                        $("#divAddTeamMonthlyAchievement").show();
                        $("#btnSubmitTeamPimcoMonthlyAchievement").show();
                        break;
                    case 2:
                        $("#divAddTeamMonthlyAchievement").hide();
                        $("#btnSubmitTeamPimcoMonthlyAchievement").hide();
                        break;
                    case 1:
                        $("#divAddTeamMonthlyAchievement").hide();
                        $("#btnSubmitTeamPimcoMonthlyAchievement").hide();
                }
            });
    }
    else {
        $("#divAddTeamMonthlyAchievement").hide();
        $("#btnSubmitTeamPimcoMonthlyAchievement").hide();
    }

}

function generateMonthlyAchievementControls(containerId, maxNoOfTextBoxes, minNoOfMandatoryTxtBoxes) {
    maxNoOfTextBoxes = maxNoOfTextBoxes || 40;
    if (containerId) {
        var txtCount = $("#" + containerId).find('.itemRowMonthly').length;
        if (txtCount < maxNoOfTextBoxes) {
            $("#" + containerId).append(getMonthlyDynamicControls(txtCount, minNoOfMandatoryTxtBoxes || 1, ''));
        }
        else {
            misAlert("You can't add more than " + maxNoOfTextBoxes + " achievements!", 'Sorry', 'warning');
        }
    }
}

function getMonthlyDynamicControls(idx, minNoOfMandatoryTxtBoxes, value) {
    var html = '<div class="itemRowMonthly" id = "dynamicAddMonthlyAchievementDiv-' + idx + '">' +
        '<div class="row">' +
        '<div class="col-md-5"><div class="form-group"><label class="control-label">Pimco Projects <span class="spnError">*</span></label><select class="form-control select2 validation-required"  id="ddlPimcoProjectId' + idx + '" ><option value="0" selected>Select</option></select></div></div>' +
        '<div class="col-md-5"><div class="form-group"><label>Achievement Detail<span class="spnError">*</span></label><textarea rows="4" cols="6" class="form-control validation-required" placeholder="Enter your achievement " id="achievementMonthly' + idx + '" maxlength="500" data-mask="" data-attr-name="r2"></textarea></div></div>' +
        '<div class="col-md-2" style="padding-top: 22px;"><span class="input-group-btn"><button class="btn btn-danger" style="background-color: #d2322d;" value="X" onclick="removeMonthlyControls(this)">X</button></span></div>' +
        '</div></div>';
    var controlId = "#ddlPimcoProjectId" + idx;
    bindPimcoProjects(controlId);
    return html;
}

function removeMonthlyControls(item) {
    $(item).closest('.itemRowMonthly').remove();
}

function getMonthlyAchievementData() {
    var collection = new Array();
    var items;
    $('.itemRowMonthly').each(function () {
        var id = $(this).closest(".itemRowMonthly").attr("id").split('-')[1];
        items = new Object();
        items.Achievement = $("#achievementMonthly" + id).val();
        items.ProjectId = parseInt($("#ddlPimcoProjectId" + id).val());
        collection.push(items);
    });
    return collection;
}

function submitTeamMonthlyAchievement() {
    var selectedEmpAbrhs = $("#ddlEmployeeToAddMonthlyAchievements").val();
    _selectedEmployee = selectedEmpAbrhs;
    var jsonObject = {
        AchievementData: getMonthlyAchievementData(),
        Year: $("#financialYearToAddMonthlyAchievements").val(),
        MNumber: $("#monthToAddAchievements").val(),
        Comments: "",
        UserAbrhs: selectedEmpAbrhs 
    };
    calltoAjax(misApiUrl.submitUserMonthlyAchievement, "POST", jsonObject,
        function (result) {
            if (result === 1) {
                misAlert("Your achievemets have been submitted successfully", "Success", "success");
                getTeamPimcoMonthlyAchievement();
                $("#dynamicAddTeamPimcoMonthlyAchievement").empty();
                $("#empCommentsToAddMonthlyAchievement").val("");
            }
            else if (result === 2) {
                misAlert("Already submitted achievement for the selected month.", "Warning", "warning");
            }
            else
                misAlert("Unable to process request. Please try again.", "Error", "error");
        });
}

//Quarterly
function bindAllReportingEmployees() {
    $("#ddlEmployee").multiselect('destroy');
    $("#ddlEmployee").empty();
    $('#ddlEmployee').multiselect();
    calltoAjax(misApiUrl.getAllEmployeesReportingToUser, "POST", '',
        function (result) {
            if (result != null && result.length > 0) {

                for (var x = 0; x < result.length; x++) {
                    $("#ddlEmployee").append("<option value = '" + result[x].EmployeeAbrhs + "'>" + result[x].EmployeeName + "</option>");
                }
                $('#ddlEmployee').multiselect("destroy");
                $('#ddlEmployee').multiselect({
                    includeSelectAllOption: true,
                    enableFiltering: true,
                    enableCaseInsensitiveFiltering: true,
                    buttonWidth: false,
                    onDropdownHidden: function (event) {
                    }
                });
                $("#ddlEmployee").multiselect('selectAll', false);
                $("#ddlEmployee").multiselect('updateButtonText');
                bindFinancialYear();
            }
        });
}

function bindFinancialYear() {
    calltoAjax(misApiUrl.getFinancialYears, "POST", '',
        function (result) {
            if (result !== null)
                $.each(result, function (index, item) {
                    $("#financialYear").append($("<option></option>").val(item.StartYear).html(item.Text));
                });
            bindQuarters();
        });
}

function bindQuarters() {
    $("#quarter").multiselect('destroy');
    $("#quarter").empty();
    $('#quarter').multiselect();
    var year = $("#financialYear").val();
    if (year == null)
        year = misSession.fystartyear; /*new Date().getMonth() + 1 < 4 ? new Date().getFullYear() - 1 : new Date().getFullYear();*/
    var jsonObject = {
        year: year
    }
    calltoAjax(misApiUrl.getQuartersForFY, "POST", jsonObject,
        function (result) {
            if (result !== null)
                $.each(result, function (index, item) {
                    $("#quarter").append($("<option></option>").val(item.StartYear).html(item.Text));
                });
            $('#quarter').multiselect("destroy");
            $('#quarter').multiselect({
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                buttonWidth: false,
                onDropdownHidden: function (event) {
                }
            });
            $("#quarter").multiselect('selectAll', false);
            $("#quarter").multiselect('updateButtonText');
            getTeamPimcoAchievement();
        });
}

function getTeamPimcoAchievement() {
    var userAbrhs = "";
    var quarters = "";
    if ($('#ddlEmployee').val() !== null) {
        userAbrhs = $('#ddlEmployee').val().join(",");
    }
    if ($('#quarter').val() !== null) {
        quarters = $('#quarter').val().join(",");
    }
    var jsonObject = {
        fyYear: $("#financialYear").val(),
        quarters: quarters,
        userAbrhs: userAbrhs
    };
    calltoAjax(misApiUrl.getTeamPimcoAchievements, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblViewTeamPimcoAchievementsList").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'Achievement List',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        {
                            extend: 'excelHtml5', filename: 'Achievement List',
                            exportOptions: {
                                columns: [0, 1, 2, 3, 6, 7, 8],
                                format: {
                                    body: function (data, column, row) {
                                        return row == 7 ? data.replace(/<br>/g, '' + "\r\n" + '') : data;
                                    }
                                }
                            }
                        },
                            //{ extend: 'pdf', filename: 'Achievement List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                            //{ extend: 'print', filename: 'Achievement List' },
                        ]
                    }],
                "responsive": true,
                "autoWidth": false,
                "paging": true,
                "bDestroy": true,
                "ordering": true,
                "footer": true,
                "order": [],
                "info": true,
                "deferRender": true,
                "aaData": data,
                "aoColumns": [
                    {
                        "mData": "EmployeeName",
                        "sTitle": "Employee Name",
                        "sWidth": "100px",
                    },
                    {
                        "mData": "DesignationName",
                        "sTitle": "Designation",
                        "sWidth": "100px",
                    },
                    {
                        "mData": "Department",
                        "sTitle": "Department",
                        "sWidth": "100px",
                    },
                    {
                        "mData": "Team",
                        "sTitle": "Team",
                        "sWidth": "100px",
                    },
                    {
                        "mData": null,
                        "sTitle": "Employee",
                        "sClass": "text-center",
                        "sWidth": "200px",
                        mRender: function (data, type, row) {
                            return "<td class='halign-center'><img  onerror=\"this.src='../img/avatar-sign.png'\" src='" + data.EmployeePhotoName + "' class='img-circle' alt='User Image'><br/>" + data.EmployeeName + "<br/>" + data.DesignationName + "</td>";
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Department/Team",
                        "sClass": "text-left",
                        "sWidth": "200px",
                        mRender: function (data, type, row) {
                            var html = '<b> Dept: </b>' + row.Department;
                            html = html + '<br /><br />' + '<b> Team: </b>' + row.Team
                            return html;
                        }
                    },
                    {
                        "mData": "ReportingManager",
                        "sTitle": "Reporting Manager",
                        "swidth": "100px"
                    },
                    {
                        "mData": null,
                        "sTitle": "Emp Comments",
                        "swidth": "100px",
                        mRender: function (data, type, row) {
                            if (data.EmpComments == "")
                                return "N.A";
                            else
                                return data.EmpComments;
                        },
                    },
                    {
                        "mData": "SubmittedDate",
                        "sTitle": "Submitted On",
                        "swidth": "80px"
                    },
                    {
                        "mData": null,
                        'bSortable': false,
                        "sClass": "text-center",
                        "sTitle": "Action",
                        mRender: function (data, type, row) {
                            var id = row.PimcoAchievementId;
                            var html = '';
                            html += '<button type="button" class="btn btn-sm btn-success"' + 'onclick="viewAchievements(' + id + ')" title="view"><i class="fa fa-eye" ></i></button>';
                            return html;
                        },
                    }
                ],
                //'rowCallback': function (row, data, dataIndex) {
                //    var table = $("#tblViewTeamAchievementsList").DataTable();
                //    table.columns([0, 1, 2, 3]).visible(false);
                //},
                "fnInitComplete": function (row) {
                    //if (typeof (data) == 'undefined' || data === null || !(data.length > 0)) {
                    var table = $("#tblViewTeamPimcoAchievementsList").DataTable();
                    table.columns([0, 1, 2, 3]).visible(false);
                    //}
                }
            });
        }

    );
}

function viewAchievements(id) {
    _id = id;
    $('#RMComments').val("");
    $('#discussWithHr').prop('checked', false);
    var jsonObject = {
        pimcoAchievementId: id
    }
    calltoAjax(misApiUrl.getPimcoAchievementsOfTeamById, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblViewTeamPimcoAchievements").dataTable({
                "responsive": true,
                "autoWidth": false,
                "paging": false,
                "bDestroy": true,
                "searching": false,
                "ordering": false,
                "info": false,
                "deferRender": true,
                "aaData": data,
                "aoColumns": [
                    {
                        "mData": "ProjectName",
                        "sTitle": "Pimco Project",
                        "swidth": "50px"
                    },
                    {
                        "mData": "Achievement",
                        "sTitle": "Achievement",
                        "swidth": "50px"
                    },
                    {
                        "mData": "Purpose",
                        "sTitle": "Benefits",
                        "swidth": "50px"
                    }
                ]
            });
            if (data[0].RMComments == null) {
                $('#RMComments').prop('disabled', false);
                $("#discussWithHr").attr("disabled", false);
                $("#saveRMComment").show();
            }
            else if (data[0].RMComments != null) {
                $('#RMComments').val(data[0].RMComments);
                $('#RMComments').prop('disabled', true);
                $("#saveRMComment").hide();
                if (data[0].DiscussWithHR == true) {
                    $('#discussWithHr').prop('checked', true);
                    $("#discussWithHr").attr("disabled", true);
                }
                else {
                    $('#discussWithHr').prop('checked', false);
                    $("#discussWithHr").attr("disabled", true);
                }
            }
        });
    $("#modalViewTeamPimcoAchievementPopUp").modal('show');
}

function sumbitRMComment() {
    var jsonObject = {
        comments: $("#RMComments").val(),
        toBeDiscussedWithHR: $('#discussWithHr').is(':checked') ? true : false,
        pimcoAchievementId: _id
    }
    calltoAjax(misApiUrl.submitRMComments, "POST", jsonObject,
        function (result) {
            if (result === 1) {
                misAlert("Your comments have been saved successfully.", "Success", "success");
                $("#modalViewTeamPimcoAchievementPopUp").modal('hide');
                getTeamPimcoAchievement();
                $('#RMComments').val("");
                $('#discussWithHr').prop('checked', false);
            }
            else
                misAlert("Unable to process request. Please try again.", "Error", "error");
        });
}

//Add Team Achievement

function bindAllEmployeesToAddAchievement() {
    $("#ddlEmployeeToAddAchievements").empty();
    $('#ddlEmployeeToAddAchievements').append("<option value ='0'>Select</option>");
    calltoAjax(misApiUrl.getAllEmployeesReportingToUser, "POST", '',
        function (result) {
            if (result != null && result.length > 0) {
                for (var x = 0; x < result.length; x++) {
                    $("#ddlEmployeeToAddAchievements").append("<option value = '" + result[x].EmployeeAbrhs + "'>" + result[x].EmployeeName + "</option>");
                }
                bindFinancialYearToAddAchievement();
            }
        });
}

function bindFinancialYearToAddAchievement() {
    $("#financialYearToAddAchievements").empty();
    $('#financialYearToAddAchievements').append("<option value ='0'>Select</option>");
    calltoAjax(misApiUrl.getFinancialYears, "POST", '',
        function (result) {
            if (result !== null)
                $.each(result, function (index, item) {
                    $("#financialYearToAddAchievements").append($("<option></option>").val(item.StartYear).html(item.Text));
                });
            bindQuartersToAddAchievement();
        });
}

function bindQuartersToAddAchievement() {
    $("#quarterToAddAchievements").empty();
    $('#quarterToAddAchievements').append("<option value ='0'>Select</option>");
    var year = $("#financialYearToAddAchievements").val();
    if (year !== "0") {
        if (year == null)
            year = misSession.fystartyear; /*new Date().getMonth() + 1 < 4 ? new Date().getFullYear() - 1 : new Date().getFullYear();*/
        var jsonObject = {
            year: year
        }
        calltoAjax(misApiUrl.getQuartersForFY, "POST", jsonObject,
            function (result) {
                if (result !== null)
                    $.each(result, function (index, item) {
                        $("#quarterToAddAchievements").append($("<option></option>").val(item.StartYear).html(item.Text));
                    });
            });
    }
}

function checkIfAllowedToFillTeamAchievement() {
    var year = $("#financialYearToAddAchievements").val();
    var quarter = $("#quarterToAddAchievements").val();
    var selectedEmpAbrhs = $("#ddlEmployeeToAddAchievements").val();
    _selectedEmployee = selectedEmpAbrhs

    if (year !== "0" && quarter !== "0" && selectedEmpAbrhs != "0") {
        if (year == null)
            year = misSession.fystartyear; /*new Date().getMonth() + 1 < 4 ? new Date().getFullYear() - 1 : new Date().getFullYear();*/
        var jsonObject = {
            year: year,
            qNumber: $("#quarterToAddAchievements").val(),
            userAbrhs: selectedEmpAbrhs
        }
        calltoAjax(misApiUrl.checkIfAllowedToFillPimcoAchievements, "POST", jsonObject,
            function (result) {
                var resultData = $.parseJSON(JSON.stringify(result));
                switch (resultData) {
                    case 3:
                        $("#divAddTeamAchievement").show();
                        $("#btnSubmitTeamPimcoAchievement").show();
                        break;
                    case 2:
                        $("#divAddTeamAchievement").hide();
                        $("#btnSubmitTeamPimcoAchievement").hide();
                        break;
                    case 1:
                        $("#divAddTeamAchievement").hide();
                        $("#btnSubmitTeamPimcoAchievement").hide();
                }
            });
    }
    else {
        $("#divAddTeamAchievement").hide();
        $("#btnSubmitTeamPimcoAchievement").hide();
    }

}

function generateAchievementControls(containerId, maxNoOfTextBoxes, minNoOfMandatoryTxtBoxes) {
    maxNoOfTextBoxes = maxNoOfTextBoxes || 40;
    if (containerId) {
        var txtCount = $("#" + containerId).find('.itemRow').length;
        if (txtCount < maxNoOfTextBoxes) {
            $("#" + containerId).append(getDynamicControls(txtCount, minNoOfMandatoryTxtBoxes || 1, ''));
        }
        else {
            misAlert("You can't add more than " + maxNoOfTextBoxes + " achievements!", 'Sorry', 'warning');
        }
    }
}

function getDynamicControls(idx, minNoOfMandatoryTxtBoxes, value) {
    var html = '<div class="itemRow" id = "dynamicAddAchievementDiv-' + idx + '">' +
        '<div class="row">' +
        '<div class="col-md-3"><div class="form-group"><label class="control-label">Pimco Projects <span class="spnError">*</span></label><select class="form-control select2 validation-required"  id="ddlQtrPimcoProjectId' + idx + '" ><option value="0" selected>Select</option></select></div></div>' +
        '<div class="col-md-4"><div class="form-group"><label>Achievement Detail<span class="spnError">*</span></label><textarea rows="4" cols="6" class="form-control validation-required" placeholder="Enter your achievement " id="achievement' + idx + '" maxlength="500" data-mask="" data-attr-name="r2"></textarea></div></div>' +
        '<div class="col-md-4"><div class="form-group"><label>Benefits<span class="spnError">*</span></label><textarea rows="4" cols="6" class="form-control validation-required" placeholder="Enter benefits " id="purpose' + idx + '" maxlength="500" data-mask="" data-attr-name="rp2"></textarea></div></div>' +
        '<div class="col-md-1" style="padding-top: 22px;"><span class="input-group-btn"><button class="btn btn-danger" style="background-color: #d2322d;" value="X" onclick="removeControls(this)">X</button></span></div>' +
        '</div></div>';
    var controlId = "#ddlQtrPimcoProjectId" + idx;
    bindPimcoProjects(controlId);
    return html;
}

function removeControls(item) {
    $(item).closest('.itemRow').remove();
}
function getAchievementData() {
    var collection = new Array();
    var items;
    $('.itemRow').each(function () {
        var id = $(this).closest(".itemRow").attr("id").split('-')[1];
        items = new Object();
        items.Achievement = $("#achievement" + id).val();
        items.Purpose = $("#purpose" + id).val();
        items.ProjectId = parseInt($("#ddlQtrPimcoProjectId" + id).val());
        collection.push(items);
    });
    return collection;
}

function submitTeamQuarterlyAchievement() {
    var selectedEmpAbrhs = $("#ddlEmployeeToAddAchievements").val();
   
    var jsonObject = {
        AchievementData: getAchievementData(),
        year: $("#financialYearToAddAchievements").val(),
        qNumber: $("#quarterToAddAchievements").val(),
        comments: $("#empCommentsToAddAchievement").val(),
        UserAbrhs: selectedEmpAbrhs
    };
    calltoAjax(misApiUrl.submitUserQuarterlyAchievement, "POST", jsonObject,
        function (result) {
            if (result === 1) {
                misAlert("Your achievemets have been submitted successfully", "Success", "success");
                getTeamPimcoAchievement();
                $("#dynamicAddTeamPimcoAchievement").empty();
                $("#empCommentsToAddAchievement").val("");
            }
            else if (result === 2) {
                misAlert("Already submitted achievement for the selected quarter.", "Warning", "warning");
            }
            else
                misAlert("Unable to process request. Please try again.", "Error", "error");
        });
}


