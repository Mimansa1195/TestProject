var _achievementList, _isValid, _rmComments, _monthlyAchievementList;
$(document).ready(function () {
    setFinancialYearForMonthlyAchiev();
    bindMonths();

    $("a[href='#tabMonthlyPimcoAchievement'] ").on('click', function () {
        setFinancialYearForMonthlyAchiev();
        bindMonths();
    });

    $("a[href='#tabQuarterlyPimcoAchievement'] ").on('click', function () {
        setFinancialYear();
        bindQuarters();
    });

//Monthly
    $("#ddlYear").on('change', function () {
        bindMonths();
    });

    $("#ddlMonth").on('change', function () {
        checkIfAllowedToFillMonthlyAchievement();
    });

    $("#btnAddPimcoMonthlyAchievement").click(function () {
        $("#viewPimcoMonthlyAchievementModal").modal({
            backdrop: 'static',
            keyboard: false
        });

        var fYStart = $("#ddlYear").val();
        var fYEnd = Number(fYStart) + 1;
        $("#txtFYYear").val(fYStart + '-' + fYEnd);
        var currentMonth = $("#ddlMonth option:selected").text();
        $("#cntMonth").text(currentMonth);
        $("#viewPimcoMonthlyAchievementModal").modal('show');
        $("#dynamicAddPimcoMonthlyAchievement").empty();
    });

    $("#showMonthlyAchievementYear").on('change', function () {
        getUserMonthlyAchievement();
    });

    $("#btnAddNewPimcoMonthlyAchievement").click(function () {
        if (!validateControls('dynamicAddPimcoMonthlyAchievement')) {
            return false;
        }
        generateMonthlyAchievementControls('dynamicAddPimcoMonthlyAchievement');
        $('.select2').select2();
    });

    $("#btnSubmitPimcoMonthlyAchievement").click(function () {
        if (!validateControls('viewPimcoMonthlyAchievementModal')) {
            return false;
        }
        if (getMonthlyAchievementData().length === 0) {
            misAlert("No pimco achievements have been added.", "Warning", "warning");
            return false;
        }
        else {
            misConfirm("<span style='color:red;'>This is one time activity. Once submitted, you won't be able to modify it or add achievements for this month of financial year.</span>", "Confirm", function (isConfirmed) {
                if (isConfirmed) {
                    submitUserMonthlyAchievement();
                }
            }, false, true, true);
        }
    })

//Quarterly
    $("#showYear").on('change', function () {
        bindQuarters();
    });

    $("#showQuarter").on('change', function () {
        checkIfAllowedToFill();
    });

    $("#btnAddPimcoAchievement").click(function () {
        $("#viewPimcoAchievementModal").modal({
            backdrop: 'static',
            keyboard: false
        });

        var fYStart = $("#showYear").val();
        var fYEnd = Number(fYStart) + 1;
        $("#showFYYear").val(fYStart + '-' + fYEnd);
        var currentQuarter = $("#showQuarter option:selected").text();
        $("#cntQuarter").text(currentQuarter);
        $("#viewPimcoAchievementModal").modal('show');
        $("#dynamicAddPimcoAchievement").empty();
    });

    $("#showAchievementYear").on('change', function () {
        getUserMidYearAchievement();
    });

    $("#btnAddNewPimcoAchievement").click(function () {
        if (!validateControls('dynamicAddPimcoAchievement')) {
            return false;
        }
        generateAchievementControls('dynamicAddPimcoAchievement');
        $('.select2').select2();
    });

    $("#btnSubmitPimcoAchievement").click(function () {
        if (!validateControls('viewPimcoAchievementModal')) {
            return false;
        }
        if (getAchievementData().length === 0) {
            misAlert("No pimco achievements have been added.", "Warning", "warning");
            return false;
        }
        else {
            misConfirm("<span style='color:red;'>This is one time activity. Once submitted, you won't be able to modify it or add achievements for this quarter of financial year.</span>", "Confirm", function (isConfirmed) {
                if (isConfirmed) {
                    submitUserQuarterlyAchievement();
                }
            }, false, true, true);
        }
    })

});

//Monthly
function setFinancialYearForMonthlyAchiev() {
    $("#ddlYear").empty();
    calltoAjax(misApiUrl.getFinancialYears, "POST", '',
        function (result) {
            if (result !== null)
                $.each(result, function (index, item) {
                    $("#ddlYear").append($("<option></option>").val(item.StartYear).html(item.Text));
                });
        });
}

function bindMonths() {
    $("#ddlMonth").empty();
    $("#ddlMonth").append($("<option></option>").val(0).html("Select"));
    var year = $("#ddlYear").val();
    if (year == null)
        year = misSession.fystartyear; /*new Date().getMonth() + 1 < 4 ? new Date().getFullYear() - 1 : new Date().getFullYear();*/
    var jsonObject = {
        year: year
    }
    calltoAjax(misApiUrl.getMonths, "POST", jsonObject,
        function (result) {
            if (result !== null) {
                $.each(result, function (index, item) {
                    $("#ddlMonth").append($("<option></option>").val(item.StartYear).html(item.Text));
                });
                var d = new Date();
                var n = d.getMonth()+1;
                $('#ddlMonth').val(n);
                checkIfAllowedToFillMonthlyAchievement();
            }
        });

}

function bindPimcoProjects(controlId) {
    $(controlId).empty();
    $(controlId).append($("<option></option>").val(0).html("Select"));
    var jsonObject = {
        userAbrhs: misSession.userabrhs
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

function checkIfAllowedToFillMonthlyAchievement() {
    var year = $("#ddlYear").val();
    if (year == null)
        year = misSession.fystartyear; /*new Date().getMonth() + 1 < 4 ? new Date().getFullYear() - 1 : new Date().getFullYear();*/
    var jsonObject = {
        year: year,
        mNumber: $("#ddlMonth").val() || 0,
        userAbrhs: misSession.userabrhs
    }
    calltoAjax(misApiUrl.checkIfAllowedToFillPimcoMonthlyAchievements, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            switch (resultData) {
                case 3:
                    $("#btnAddPimcoMonthlyAchievement").show();
                    break;
                case 2:
                    $("#btnAddPimcoMonthlyAchievement").hide();
                    getUserMonthlyAchievement();
                    break;
                case 1:
                    $("#btnAddPimcoMonthlyAchievement").hide();
                    getUserMonthlyAchievement();
                    
            }
        });
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
    var collection = [];
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

function submitUserMonthlyAchievement() {
    var jsonObject = {
        AchievementData: getMonthlyAchievementData(),
        Year: $("#ddlYear").val(),
        MNumber: $("#ddlMonth").val(),
        Comments: "",
        UserAbrhs: misSession.userabrhs
    };
    calltoAjax(misApiUrl.submitUserMonthlyAchievement, "POST", jsonObject,
        function (result) {
            if (result === 1) {
                misAlert("Your monthly achievemets have been submitted successfully", "Success", "success");
                checkIfAllowedToFillMonthlyAchievement();
                getUserMonthlyAchievement();
                $("#viewPimcoMonthlyAchievementModal").modal('hide');
            }
            else if (result === 2) {
                misAlert("Already submitted achievement for the selected month.", "Warning", "warning");
            }
            else
                misAlert("Unable to process request. Please try again.", "Error", "error");
        });
}

function getUserMonthlyAchievement() {
    var jsonObject = {
        year: $("#ddlYear").val(),
        mNumber: $("#ddlMonth").val() || 0,
    };
    calltoAjax(misApiUrl.getUserMonthlyAchievement, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblPimcoMonthlyAchievements").dataTable({
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
                    //{
                    //    "sTitle": "Appraisal Year",
                    //    'bSortable': false,
                    //    "swidth": "100px",
                    //    mRender: function (data, type, row) {
                    //        var year = row.AppraisalYear;
                    //        var html = '<span class="halign-center circle-bg" style="font-size: 20px;">' + year + '</span>';
                    //        return html;
                    //    }
                    //},
                    {
                        "mData": "SubmittedDate",
                        "sTitle": "Submitted On",
                        //"swidth": "80px"
                    },
                    //{
                    //    "mData": null,
                    //    "sTitle": "Comments",
                    //    mRender: function (data, type, row) {
                    //        var a = 'N.A';
                    //        if (row.EmpComments == null || row.EmpComments == "")
                    //            return a;
                    //        else
                    //            return row.EmpComments;
                    //    }
                    //},
                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        "sClass": "text-center",
                        // "sWidth": "90px",
                        mRender: function (data, type, row) {
                            _monthlyAchievementList = row.AchievementData;
                            _rmComments = row.RMComments;
                            var html = '';
                            html += '<button type="button" class="btn btn-sm btn-success"' + 'onclick="viewMonthlyAchievements()" title="view"><i class="fa fa-eye" ></i></button>';
                            return html;
                        }
                    },
                ]
            });
        }

    );
}

function viewMonthlyAchievements() {
    var data = $.parseJSON(JSON.stringify(_monthlyAchievementList));
    $("#tblViewMyPimcoMonthlyAchievements").dataTable({
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
                "sTitle": "S.No.",
                "swidth": "20px"
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
    if (_rmComments != null) {
        $("#lblComment").show();
        $("#RMComments").show();
        $("#RMComments").val(_rmComments);
    }
    $("#modalViewPimcoMonthlyAchievementPopUp").modal('show');
}

//Quarterly

function setFinancialYear() {
    $("#showYear").empty();
    calltoAjax(misApiUrl.getFinancialYears, "POST", '',
        function (result) {
            if (result !== null)
                $.each(result, function (index, item) {
                    $("#showYear").append($("<option></option>").val(item.StartYear).html(item.Text));
                });
        });
}

function bindQuarters() {
    $("#showQuarter").empty();
    $("#showQuarter").append($("<option></option>").val(0).html("Select"));
    var year = $("#showYear").val();
    if (year == null)
        year = misSession.fystartyear; /*new Date().getMonth() + 1 < 4 ? new Date().getFullYear() - 1 : new Date().getFullYear();*/
    var jsonObject = {
        year: year
    }
    calltoAjax(misApiUrl.getQuartersForFY, "POST", jsonObject,
        function (result) {
            if (result !== null)
                $.each(result, function (index, item) {
                    $("#showQuarter").append($("<option></option>").val(item.StartYear).html(item.Text));
                });
            var currentQuarter = misSession.currentquarter;
            $('#showQuarter').select2("val", currentQuarter);
            checkIfAllowedToFill();
        });

}

function checkIfAllowedToFill() {
    var year = $("#showYear").val();
    if (year == null)
        year = misSession.fystartyear; /*new Date().getMonth() + 1 < 4 ? new Date().getFullYear() - 1 : new Date().getFullYear();*/
    var jsonObject = {
        year: year,
        qNumber: $("#showQuarter").val(),
        userAbrhs: misSession.userabrhs
    }
    calltoAjax(misApiUrl.checkIfAllowedToFillPimcoAchievements, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            switch (resultData) {
                case 3:
                    $("#btnAddPimcoAchievement").show();
                    break;
                case 2:
                    $("#btnAddPimcoAchievement").hide();
                    getUserQuarterlyAchievement();
                    break;
                case 1:
                    $("#btnAddPimcoAchievement").hide();
                    getUserQuarterlyAchievement();
            }
        });
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
        '<div class="col-md-4"><div class="form-group"><label class="control-label">Pimco Projects <span class="spnError">*</span></label><select class="form-control select2 validation-required"  id="ddlQtrPimcoProjectId' + idx + '" ><option value="0" selected>Select</option></select></div></div>' +
        '<div class="col-md-3"><div class="form-group"><label>Achievement Detail<span class="spnError">*</span></label><textarea rows="4" cols="6" class="form-control validation-required" placeholder="Enter your achievement " id="achievement' + idx + '" maxlength="500" data-mask="" data-attr-name="r2"></textarea></div></div>' +
        '<div class="col-md-3"><div class="form-group"><label>Benefits<span class="spnError">*</span></label><textarea rows="4" cols="6" class="form-control validation-required" placeholder="Enter benefits " id="purpose' + idx + '" maxlength="500" data-mask="" data-attr-name="rp2"></textarea></div></div>' +
        '<div class="col-md-2" style="padding-top: 22px;"><span class="input-group-btn"><button class="btn btn-danger" style="background-color: #d2322d;" value="X" onclick="removeControls(this)">X</button></span></div>' +
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

function submitUserQuarterlyAchievement() {
    var jsonObject = {
        AchievementData: getAchievementData(),
        year: $("#showYear").val(),
        qNumber: $("#showQuarter").val(),
        comments: $("#empComments").val(),
        UserAbrhs: misSession.userabrhs
    };
    calltoAjax(misApiUrl.submitUserQuarterlyAchievement, "POST", jsonObject,
        function (result) {
            if (result === 1) {
                misAlert("Your achievemets have been submitted successfully", "Success", "success");
                checkIfAllowedToFill();
                getUserQuarterlyAchievement();
                $("#viewPimcoAchievementModal").modal('hide');
            }
            else if (result === 2) {
                misAlert("Already submitted achievement for the selected quarter.", "Warning", "warning");
            }
            else
                misAlert("Unable to process request. Please try again.", "Error", "error");
        });
}

function getUserQuarterlyAchievement() {
    var jsonObject = {
        year: $("#showYear").val(),
        qNumber: $("#showQuarter").val(),
    };
    calltoAjax(misApiUrl.getUserQuarterlyAchievement, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblPimcoAchievements").dataTable({
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
                    //{
                    //    "sTitle": "Appraisal Year",
                    //    'bSortable': false,
                    //    "swidth": "100px",
                    //    mRender: function (data, type, row) {
                    //        var year = row.AppraisalYear;
                    //        var html = '<span class="halign-center circle-bg" style="font-size: 20px;">' + year + '</span>';
                    //        return html;
                    //    }
                    //},
                    {
                        "mData": "SubmittedDate",
                        "sTitle": "Submitted On",
                        //"swidth": "80px"
                    },
                    {
                        "mData": null,
                        "sTitle": "Comments",
                        mRender: function (data, type, row) {
                            var a = 'N.A';
                            if (row.EmpComments == null || row.EmpComments == "")
                                return a;
                            else
                                return row.EmpComments;
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        "sClass": "text-center",
                       // "sWidth": "90px",
                        mRender: function (data, type, row) {
                            _achievementList = row.AchievementData;
                            _rmComments = row.RMComments;
                            var html = '';
                            html += '<button type="button" class="btn btn-sm btn-success"' + 'onclick="viewAchievements()" title="view"><i class="fa fa-eye" ></i></button>';
                            return html;
                        }
                    },
                ]
            });
        }

    );
}

function viewAchievements() {
    $("#lblComment").hide();
    $("#RMComments").hide();
    $("#RMComments").val("");
    var data = $.parseJSON(JSON.stringify(_achievementList));
    $("#tblViewMyPimcoAchievements").dataTable({
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
                "sTitle": "S.No.",
                "swidth" : "20px"
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
            },
            {
                "mData": "Purpose",
                "sTitle": "Benefits",
                "swidth": "50px"
            }
        ]
    });
    if (_rmComments != null) {
        $("#lblComment").show();
        $("#RMComments").show();
        $("#RMComments").val(_rmComments);
    }
    $("#modalViewPimcoAchievementPopUp").modal('show');
}


