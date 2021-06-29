var todayDate = new Date();
var draftedGoalId = [];
var draftedTeamGoalId = [];

var _FYStartDate, _FYEndDate, _FYStartDateT, _FYEndDateT;

$(document).ready(function () {
    $(".select2").select2();
    bindFinancialYearForGoal();

    $("a[href='#tabMyGoal']").click(function () {
        bindFinancialYearForGoal();
    });

    $("a[href='#tabTeamGoal']").click(function () {
        bindAllTeams(("#ddlTeam"));
    });
});

//My Goal
$("#financialYear").on('change', function () {
    var appraisalCycleId = $("#financialYear").val();
    loadSelfGoalGrid(appraisalCycleId);
});

function bindFinancialYearForGoal() {
    var jsonObject = {
        forTeam: false
    }
    calltoAjax(misApiUrl.getAllGoalCycleIdToViewAchievement, "POST", jsonObject,
        function (result) {
            if (result.length > 0) {
                $("#financialYear").empty();
                $("#financialYear").append("<option value='0'>All</option>");
                $.each(result, function (index, result) {
                    $("#financialYear").append("<option value=" + result.GoalCycleId + ">" + result.FinancialYearName + "</option>");
                });
                var FY = new Date(result[0].FyStartDate);
                var goalCycleId = result[0].GoalCycleId;
                var fromyear = FY.getFullYear();
                var endyear = fromyear + 1;
                $("#cntYear").html(fromyear);
                $("#nxtYear").html(endyear);
                $("#showAppraisalYear").val(fromyear + ' - ' + endyear);
                $("#txtHiddenGoalCycleId").val(goalCycleId);
                _FYStartDate = '0' + 4 + '/' + '0' + 1 + '/' + fromyear;
                _FYEndDate = '0' + 3 + '/' + 31 + '/' + endyear;
                $("#showAppraisalYear").val(fromyear + ' - ' + endyear);
                $("#txtHiddenGoalCycleId").val(goalCycleId);
                $("#financialYear").val(goalCycleId);
                loadSelfGoalGrid(goalCycleId);
            }
        });
}

function loadSelfGoalGrid(appraisalCycleId) {
    var jsonObject = {
        appraisalCycleId: appraisalCycleId,
        userAbrhs: misSession.userabrhs
    };
    calltoAjax(misApiUrl.getAllSelfGoals, "POST", jsonObject, function (result) {
        var resultData = $.parseJSON(JSON.stringify(result));

        draftedGoalId = [];
        for (var i = 0; i < resultData.length; i++) {
            if (resultData[i].Status == 'Drafted')
                draftedGoalId.push(resultData[i].GoalId);
        }
        if (draftedGoalId.length > 0)
            $("#btnSaveGoal").show();
        else
            $("#btnSaveGoal").hide();

        $("#tblSelfGoalList").dataTable({
            "dom": 'lBfrtip',
            "buttons": [
                {
                    filename: 'All Self Goals',
                    extend: 'collection',
                    text: 'Export',
                    buttons: [{ extend: 'copy' },
                    { extend: 'excel', filename: 'All Self Goals' },
                    { extend: 'pdf', filename: 'All Self Goals' },
                    { extend: 'print', filename: 'All Self Goals' }
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
                {
                    "mData": null,
                    "sTitle": "Financial Year",
                    'bSortable': true,
                    "sWidth": "100px",
                    mRender: function (data, type, row) {
                        var html = '<div>';
                        html += row.AppraisalYear - 1 + " - " + row.AppraisalYear;
                        html += '</div>'
                        return html;
                    }
                },
                { "mData": "AppraisalCycleName", "sTitle": "Appraisal Cycle", "sWidth": "100px" },
                { "mData": "GoalCategory", "sTitle": "Goal Type" },
                { "mData": "Goal", "sTitle": "Goal" },
                //{ "mData": "AppraisalCycleName", "sTitle": "Appraisal Cycle" },
                //{ "mData": "StartDate", "sTitle": "Start Date" },
                //{ "mData": "EndDate", "sTitle": "End Date" },
                //{ "mData": "UserRemark", "sTitle": "My Remark" },
                //{ "mData": "OtherRemark", "sTitle": "Comments" },
                //{ "mData": "CreatedBy", "sTitle": "Created By" },
                { "mData": "Status", "sTitle": "Status", "sWidth": "100px" },
                {
                    "mData": null,
                    "sTitle": "Action",
                    'bSortable': false,
                    "sClass": "text-center",
                    "sWidth": "200px",
                    mRender: function (data, type, row) {
                        var html = '<div>';
                        switch (row.Status) {
                            case 'Drafted':
                                html += '<button type="button" data-toggle="tooltip" title="Edit"  class="btn btn-sm btn-success"' + 'onclick="openPopupEditGoal(' + row.GoalId + ')"><i class="fa fa-edit" aria-hidden="true"></i></button>';
                                html += '&nbsp;<button type="button" data-toggle="tooltip" title="Delete"  class="btn btn-sm btn-danger"' + 'onclick="openPopupDeleteGoal(' + row.GoalId + ')"><i class="fa fa-trash" aria-hidden="true"></i></button>';
                                break;
                            case 'Submitted':
                                html += 'Pending for approval with manager';
                                break;
                            case 'Approved':
                                html += html += '<button type="button" data-toggle="tooltip" class="btn btn-sm btn-gemini"' + 'onclick="openPopup(' + row.GoalId + ',\'' + row.StartDate + '\')" title="Mark as achieved"><i class="fa fa-thumbs-up" aria-hidden="true"></i></button>';
                                break;
                            case 'Achieved':
                                html += 'Achieved on ' + row.GoalAchievingDate;
                                break;
                            case 'Rejected':
                                html += 'Marked as irrelevant';
                                break;
                            case 'Deleted':
                                html += 'Deleted';
                                break;
                        }
                        html += '</div>';
                        return html;
                    }
                },
                {
                    "mData": null,
                    "sTitle": "Log",
                    'bSortable': false,
                    "sClass": "text-center",
                    "sWidth": "100px",
                    mRender: function (data, type, row) {
                        var html = '<div>';
                        if (row.Status == 'Drafted' || row.Status == 'Deleted')
                            html += 'NA';
                        else
                            html += '<button type="button" data-toggle="tooltip" title="View"  class="btn btn-sm teal"' + 'onclick="openPopupGoalHist(' + row.GoalId + ',\'' + row.Goal + '\')"><i class="fa fa-eye" aria-hidden="true"></i></button>';
                        html += '</div>';
                        return html;
                    }
                }
            ]
        });
    });
}

function openPopupGoalHist(goalId, goal) {
    document.getElementById("lblGoal").innerHTML = " Goal summary: " + goal + "";
    $("#modalGoalHistory").modal('show');
    var jsonObject = {
        goalId: goalId
    };
    calltoAjax(misApiUrl.fetchGoalHistoryById, "POST", jsonObject,
        function (result) {
            if (result != null) {
                $("#goalHistTable").empty();
                var html = "";
                html = "<tr><th>Start Date</th><th>End Date</th><th>Remarks</th><th>Action</th><th>Action Date</th><th>Action By</th></tr>";
                for (var i = 0; i < result.length; i++) {
                    html += "<tr><td>" + result[i].StartDate + "</td><td>" + result[i].EndDate + "</td><td>" + result[i].Remark + "</td><td>" + result[i].Status + "</td><td>" + result[i].CreatedDate + "</td><td>" + result[i].CreatedBy + "</td></tr>";
                }
                $("#goalHistTable").append(html);
            }
            else
                misAlert("Unable to fetch goal details", "Error", "error");
        });
}

function openPopupEditGoal(goalId) {
    $("#modalEditGoal").modal('show');
    $("#hdnEditGoalId").val(goalId);
    $("#goalStartDate").datepicker({ autoclose: true, todayHighlight: true }).datepicker('setStartDate', _FYStartDate);
    $("#goalStartDate").datepicker({ autoclose: true, todayHighlight: true }).on('changeDate', function () {
        $("#goalEndDate").val("");
        $("#goalEndDate").datepicker('setStartDate', $("#goalStartDate").val());
    });
    $("#goalEndDate").datepicker({ autoclose: true, todayHighlight: true }).datepicker('setEndDate', _FYEndDate);
    var jsonObject = {
        goalId: $("#hdnEditGoalId").val()
    };
    calltoAjax(misApiUrl.fetchGoalDetailById, "POST", jsonObject,
        function (result) {
            if (result != null) {
                $("#goalStartDate").val(result.StartDate);
                $("#goalEndDate").val(result.EndDate);
                $("#goalStartDate").removeClass('error-validation');
                $("#goalEndDate").removeClass('error-validation');
                bindGoalCategory("#ddlGoalCategory", result.GoalCategoryId);
                $("#goalDesc").val(result.Goal);
            }
            else
                misAlert("Unable to fetch goal details", "Error", "error");
        });
}

function editGoal() {
    if (!validateControls('editGoalDiv'))
        return false;
    var jsonObject = {
        GoalId: $("#hdnEditGoalId").val(),
        StartDate: $("#goalStartDate").val(),
        EndDate: $("#goalEndDate").val(),
        GoalCategoryId: parseInt($("#ddlGoalCategory").val() || 0),
        Goal: $("#goalDesc").val(),
        UserAbrhs: misSession.userabrhs
    };
    calltoAjax(misApiUrl.editGoal, "POST", jsonObject,
        function (result) {
            if (result) {
                misAlert("Request processed successfully", "Success", "success");
                $("#modalEditGoal").modal('hide');
                var appraisalCycleId = $("#financialYear").val();
                loadSelfGoalGrid(appraisalCycleId);
            }
            else
                misAlert("Unable to process request", "Error", "error");
        });
}

function openPopupDeleteGoal(goalId) {
    $("#modalDeleteGoal").modal('show');
    $("#hdnDeleteGoalId").val(goalId);
    $("#remarks").val("");
}

function deleteGoal() {
    if (!validateControls('modalDeleteGoal')) {
        return false;
    }
    var reply = misConfirm("Are you sure you want to delete goal", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                userAbrhs: misSession.userabrhs,
                goalId: $("#hdnDeleteGoalId").val(),
                remarks: $("#remarks").val()
            };
            calltoAjax(misApiUrl.deleteGoal, "POST", jsonObject,
                function (result) {
                    if (result) {
                        misAlert("Request processed successfully", "Success", "success");
                        $("#modalDeleteGoal").modal('hide');
                        var appraisalCycleId = $("#financialYear").val();
                        loadSelfGoalGrid(appraisalCycleId);
                    }
                    else
                        misAlert("No such record present", "Error", "error");
                });
        }
    });
}

function openPopupAddSelfGoal() {
    $("#modalSelfGoal").modal({
        backdrop: 'static',
        keyboard: false
    });
    $("#modalSelfGoal").modal('show');
    $("#dynamicAddGoal").empty();
}

$("#btnAddNew").click(function () {
    if (!validateControls('dynamicAddGoal')) {
        return false;
    }
    generateControls('dynamicAddGoal');
});

function generateControls(containerId, maxNoOfTextBoxes, minNoOfMandatoryTxtBoxes) {
    maxNoOfTextBoxes = maxNoOfTextBoxes || 20;
    if (containerId) {
        var txtCount = $("#" + containerId).find('.itemRow').length;
        if (txtCount < maxNoOfTextBoxes) {
            $("#" + containerId).append(getDynamicControls(txtCount, minNoOfMandatoryTxtBoxes || 1, ''));
            $("#goalStartDate" + txtCount).datepicker({ autoclose: true, todayHighlight: true }).datepicker('setStartDate', new Date(_FYStartDate));
            $("#goalEndDate" + txtCount).datepicker({ autoclose: true, todayHighlight: true }).datepicker('setEndDate', new Date(_FYEndDate));
            $("#goalStartDate" + txtCount).datepicker({ autoclose: true, todayHighlight: true }).on('changeDate', function () {
                $("#goalEndDate" + txtCount).val('');
                $("#goalEndDate" + txtCount).datepicker('setStartDate', new Date($("#goalStartDate" + txtCount).val()));
            });
            $("#goalStartDate" + txtCount).datepicker('update', new Date());
            $("#goalEndDate" + txtCount).datepicker({ autoclose: true, todayHighlight: true }).datepicker('setStartDate', $("#goalStartDate" + txtCount).val());
        }
        else {
            misAlert("You can't add more than " + maxNoOfTextBoxes + " goals!", 'Sorry', 'warning');
        }
        $(".select2").select2();
    }
}

function getDynamicControls(idx, minNoOfMandatoryTxtBoxes, value) {
    var html = '<div class="row col-md-12 itemRow" id = "dynamicAddGoalDiv-' + idx + '">' +
        '<div class="row">' +
        '<div class="col-md-2"><div class="form-group"><label>Goal start date<span class="spnError">*</span></label><div class="input-group"><div class="input-group-addon"><i class="fa fa-calendar"></i></div><input disable="" type="text" class="form-control validation-required" placeholder="Start date" tabindex="6" id="goalStartDate' + idx + '" data-mask="" data-attr-name="r2"></div></div></div>' +
        '<div class="col-md-2"><div class="form-group"><label>Goal end date<span class="spnError">*</span></label><div class="input-group"><div class="input-group-addon"><i class="fa fa-calendar"></i></div><input disable="" type="text" class="form-control validation-required" placeholder="End date" tabindex="6" id="goalEndDate' + idx + '" data-mask="" data-attr-name="r2"></div></div></div>' +
        ' <div class="col-md-2"><div class="form-group"> <label>Goal type<span class="spnError">*</span></label><div class="input-group ddl-ellipsis"><select class="form-control select2 validation-required" id="ddlGoalCategory' + idx + '"><option value="0">Select</option></select></div></div></div>' +
        '<div class="col-md-5"><div class="form-group"><label>Goal description<span class="spnError">*</span></label><textarea rows="2" cols="6" class="form-control validation-required" placeholder="Goal description" id="goal' + idx + '" maxlength="4000" data-mask="" data-attr-name="r2"></textarea></div></div>' +
        '<div class="col-md-1" style="padding-top: 22px;"><span class="input-group-btn"><button class="btn btn-danger" style="background-color: #d2322d;" value="X" onclick="removeControls(this)">X</button></span></div>' +
        '</div></div>';

    var controlId = "#ddlGoalCategory" + idx;
    bindGoalCategory(controlId, 0);
    return html;
}

function bindGoalCategory(controlId, selectedValue) {
    $(controlId).empty();
    $(controlId).append($("<option></option>").val(0).html("Select"));
    $(controlId).select2();
    calltoAjax(misApiUrl.fetchGoalCategory, "POST", "",
        function (result) {
            if (result !== null) {
                $.each(result, function (index, item) {
                    $(controlId).append($("<option></option>").val(item.Value).html(item.Text));
                });
            }
            if (selectedValue > 0)
                $(controlId).val(selectedValue);
        });
}

function removeControls(item) {
    $(item).closest('.itemRow').remove();
}

function getFormData() {
    var collection = new Array();
    var items;
    $('.itemRow').each(function () {
        var id = $(this).closest(".itemRow").attr("id").split('-')[1];
        items = new Object();
        items.StartDate = $("#goalStartDate" + id).val();
        items.EndDate = $("#goalEndDate" + id).val();
        items.Goal = $("#goal" + id).val();
        items.GoalCategoryId = parseInt($("#ddlGoalCategory" + id).val() || 0);
        collection.push(items);
    });
    return collection;
}

function submitGoal() {
    if (draftedGoalId.length == 0) {
        misAlert("No goals are there in draft state", "Warning", "warning");
        return false;
    }
    var reply = misConfirm("This will submit all the draft goals. They cannot be modified further", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                goalIds: draftedGoalId.toString(),
                userAbrhs: misSession.userabrhs
            };
            calltoAjax(misApiUrl.submitGoals, "POST", jsonObject,
                function (result) {
                    if (result) {
                        draftedGoalId = [];
                        misAlert("Request processed successfully", "Success", "success");
                        var appraisalCycleId = $("#financialYear").val();
                        loadSelfGoalGrid(appraisalCycleId);
                        $("#ddlEmployeeAddGoal").val("");
                    }
                    else
                        misAlert("Unable to process request. Please try again.", "Error", "error");
                });
        }
    });
}

function draftGoal() {
    if (!validateControls('modalSelfGoal')) {
        return false;
    }
    if (getFormData().length == 0) {
        misAlert("No goals have been added.", "Warning", "warning");
        return false;
    }
    var jsonObject = {
        goalList: getFormData(),
        employeeAbrhs: misSession.userabrhs,
        userAbrhs: misSession.userabrhs,
        goalCycleId: $("#txtHiddenGoalCycleId").val()
    };
    calltoAjax(misApiUrl.draftGoals, "POST", jsonObject,
        function (result) {
            if (result) {
                misAlert("Request processed successfully", "Success", "success");
                var appraisalCycleId = $("#financialYear").val();
                loadSelfGoalGrid(appraisalCycleId);

                $("#dynamicAddGoal").empty();
                $("#ddlEmployeeAddGoal").val("");
            }
            else
                misAlert("Unable to process request. Please try again.", "Error", "error");
        });
}

function openPopup(goalId, startDate) {
    $("#modalChangeGoalStatus").modal('show');
    $("#hdnGoalId").val(goalId);
    //alert(startDate);
    //alert(moment(startDate).format("MM/DD/YYYY"));
    $('#goalAchievingDate').datepicker({ autoclose: true, todayHighlight: true })
        .datepicker('setEndDate', todayDate).datepicker('setStartDate', startDate);
}

function markGoalAsAchieved() {
    if (!validateControls('modalChangeGoalStatus')) {
        return false;
    }
    var jsonObject = {
        userAbrhs: misSession.userabrhs,
        goalId: $("#hdnGoalId").val(),
        remarks: $("#goalUserRemarks").val(),
        date: $("#goalAchievingDate").val()
    };
    calltoAjax(misApiUrl.markGoalAsAchieved, "POST", jsonObject,
        function (result) {
            switch (result) {
                case 1:
                    misAlert("Request processed successfully", "Success", "success");
                    $("#modalChangeGoalStatus").modal('hide');
                    var appraisalCycleId = $("#financialYear").val();
                    loadSelfGoalGrid(appraisalCycleId);
                    break;
                case 2:
                    misAlert("You are not authorised to perform this action", "Error", "error");
                    break;
                case 3:
                    misAlert("Goal has already been marked as achieved", "Warning", "warning");
                    break;
                case 4:
                    misAlert("No such record present", "Error", "error");
                    break;
            }
        });
}

$(".btnClose").click(function () {
    $("#modalChangeGoalStatus").modal('hide');
    $("#modalSelfGoal").modal('hide');
    $("#modalEditGoal").modal('hide');
    $("#modalDeleteGoal").modal('hide');
    $("#modalGoalHistory").modal('hide');
});


//Team Goal
$("#financialYearForTeamGoal").on('change', function () {
    var appraisalCycleId = $("#financialYearForTeamGoal").val();
    loadTeamGoalGrid(appraisalCycleId);
});

function bindAllTeams(controlId) {
    $(controlId).empty();
    $(controlId).append("<option value='0'>View All</option>");
    var jsonObject = {
        type: "V"
    };
    calltoAjax(misApiUrl.fetchTeamsToAddGoals, "POST", jsonObject,
        function (result) {
            if (result != null && result.length > 0) {
                for (var x = 0; x < result.length; x++) {
                    if (result[x].Selected)
                        $(controlId).append("<option Selected value = '" + result[x].KeyValue + "'>" + result[x].Text + "</option>");
                    else
                        $(controlId).append("<option value = '" + result[x].KeyValue + "'>" + result[x].Text + "</option>");
                }
            }
            getUserPrivilegesToAddTeamGoal();
            bindFinancialYearForTeamGoal();
        });
}

function bindAllTeamsToAddGoals(controlId) {
    $(controlId).multiselect('destroy');
    $(controlId).empty();
    $(controlId).append("<option value='0'>Select</option>");
    var jsonObject = {
        type: "A"
    };
    calltoAjax(misApiUrl.fetchTeamsToAddGoals, "POST", jsonObject,
        function (result) {
            $.each(result, function (idx, item) {
                if (item.Selected) {
                    $(controlId).append("<option Selected value = '" + item.KeyValue + "'>" + item.Text + "</option>");
                    showAddGoalArea();
                }
                else
                    $(controlId).append("<option  value = '" + item.KeyValue + "'>" + item.Text + "</option>");
            });
        });
}

function bindFinancialYearForTeamGoal() {
    $("#financialYearForTeamGoal").empty();
    $("#financialYearForTeamGoal").append("<option value='0'>All</option>");
    var jsonObject = {
        forTeam: false
    }
    calltoAjax(misApiUrl.getAllGoalCycleIdToViewAchievement, "POST", jsonObject,
        function (result) {
            if (result.length > 0) {
                $.each(result, function (index, result) {
                    $("#financialYearForTeamGoal").append("<option value=" + result.GoalCycleId + ">" + result.FinancialYearName + "</option>");
                });
                var FY = new Date(result[0].FyStartDate);
                var goalCycleId = result[0].GoalCycleId;
                var fromyear = FY.getFullYear();
                var endyear = fromyear + 1;
                $("#cntYearForTeamGoal").html(fromyear);
                $("#nxtYearForTeamGoal").html(endyear);
                $("#showAppraisalYearForTeamGoal").val(fromyear + ' - ' + endyear);
                $("#txtHiddenTeamGoalCycleId").val(goalCycleId);
                _FYStartDateT = '0' + 4 + '/' + '0' + 1 + '/' + fromyear;
                _FYEndDateT = '0' + 3 + '/' + 31 + '/' + endyear;
                $("#showAppraisalYearForTeamGoal").val(fromyear + ' - ' + endyear);
                $("#txtHiddenTeamGoalCycleId").val(goalCycleId);
                $("#financialYearForTeamGoal").val(goalCycleId);
                loadTeamGoalGrid(goalCycleId);
            }
        });
}

function showAddGoalArea() {
    if ($('#ddlTeamAddGoal').val() !== "0") {
        $("#showOnTeamChangeDiv").show();
        $("#btnDraftTeamGoal").show();
    }
    else {
        $("#showOnTeamChangeDiv").hide();
        $("#btnDraftTeamGoal").hide();
    }
    $("#dynamicAddTeamGoal").empty();
}

function loadTeamGoalGrid(appraisalCycleId) {
    var jsonObject = {
        appraisalCycleId: appraisalCycleId,
        teamAbrhs: $('#ddlTeam').val()
    };
    calltoAjax(misApiUrl.getAllTeamGoals, "POST", jsonObject, function (result) {
        var resultData = $.parseJSON(JSON.stringify(result));

        draftedTeamGoalId = [];
        for (var i = 0; i < resultData.length; i++) {
            if (resultData[i].Status == 'Drafted' && resultData[i].HasAddRights)
                draftedTeamGoalId.push(resultData[i].GoalId);
        }
        if (draftedTeamGoalId.length > 0)
            $("#btnSaveTeamGoal").show();
        else
            $("#btnSaveTeamGoal").hide();

        $("#tblTeamGoalList").dataTable({
            "dom": 'lBfrtip',
            "buttons": [
                {
                    filename: 'All Team Goals',
                    extend: 'collection',
                    text: 'Export',
                    buttons: [{ extend: 'copy' },
                    { extend: 'excel', filename: 'All Team Goals' },
                    { extend: 'pdf', filename: 'All Team Goals' },
                    { extend: 'print', filename: 'All Team Goals' }
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
                {
                    "mData": null,
                    "sTitle": "Financial Year",
                    'bSortable': true,
                    "sWidth": "100px",
                    mRender: function (data, type, row) {
                        var html = '<div>';
                        html += row.AppraisalYear - 1 + " - " + row.AppraisalYear;
                        html += '</div>'
                        return html;
                    }
                },
                { "mData": "AppraisalCycleName", "sTitle": "Appraisal Cycle", "sWidth": "100px" },
                { "mData": "TeamName", "sTitle": "Team", "sWidth": "100px" },
                { "mData": "DepartmentName", "sTitle": "Department", "sWidth": "100px" },
                { "mData": "GoalCategory", "sTitle": "Goal Type" },
                { "mData": "Goal", "sTitle": "Goal", "sWidth": "150px" },
                { "mData": "Status", "sTitle": "Status", "sWidth": "100px" },
                {
                    "mData": null,
                    "sTitle": "Action",
                    'bSortable': false,
                    "sClass": "text-center",
                    "sWidth": "100px",
                    mRender: function (data, type, row) {
                        var html = '<div>';
                        switch (row.Status) {
                            case 'Drafted':
                                if (row.HasAddRights) {
                                    html += '<button type="button"  title="Edit"  class="btn btn-sm btn-success"' + 'onclick="openPopupEditTeamGoal(' + row.GoalId + ')"><i class="fa fa-edit" aria-hidden="true"></i></button>';
                                    html += '&nbsp;<button type="button"  title="Delete"  class="btn btn-sm btn-danger"' + 'onclick="openPopupDeleteTeamGoal(' + row.GoalId + ')"><i class="fa fa-trash" aria-hidden="true"></i></button>';
                                }
                                break;
                            case 'Submitted':
                                html += 'Pending for approval with ' + row.DepartmentHead;
                                break;
                            case 'Approved':
                                if (row.HasAddRights)
                                    html += html += '<button type="button" class="btn btn-sm btn-gemini"' + 'onclick="openPopupForTeamGoal(' + row.GoalId + ',\'' + row.StartDate + '\')" title="Mark as achieved"><i class="fa fa-thumbs-up" aria-hidden="true"></i></button>';
                                break;
                            case 'Achieved':
                                html += 'Achieved on ' + row.GoalAchievingDate;
                                break;
                            case 'Rejected':
                                html += 'Marked as irrelevant';
                                break;
                            case 'Deleted':
                                html += 'Deleted';
                                break;
                        }
                        html += '</div>';
                        return html;
                    }
                },
                {
                    "mData": null,
                    "sTitle": "Log",
                    'bSortable': false,
                    "sClass": "text-center",
                    "sWidth": "100px",
                    mRender: function (data, type, row) {
                        var html = '<div>';
                        if (row.Status == 'Drafted' || row.Status == 'Deleted')
                            html += 'NA';
                        else
                            html += '<button type="button"  title="View"  class="btn btn-sm teal"' + 'onclick="openPopupTeamGoalHist(' + row.GoalId + ',\'' + row.Goal + '\')"><i class="fa fa-eye" aria-hidden="true"></i></button>';
                        html += '</div>';
                        return html;
                    }
                }
            ]
        });
    });
}

$("#ddlTeam").change(function () {
    getUserPrivilegesToAddTeamGoal();
    var appraisalCycleId = $("#financialYearForTeamGoal").val();
    loadTeamGoalGrid(appraisalCycleId);
});

function getUserPrivilegesToAddTeamGoal() {
    var jsonObject = {
        teamAbrhs: $("#ddlTeam").val()
    };
    calltoAjax(misApiUrl.getUserPrivilegesToAddTeamGoal, "POST", jsonObject,
        function (result) {
            if (result === true) {
                $("#btnAddTeamGoals").show();
            }
            else {
                $("#btnAddTeamGoals").hide();
            }
        });
}

function openPopupTeamGoalHist(goalId, goal) {
    document.getElementById("lblGoal").innerHTML = " Goal summary: " + goal + "";
    $("#modalGoalHistory").modal('show');
    var jsonObject = {
        goalId: goalId
    };
    calltoAjax(misApiUrl.fetchTeamGoalHistoryById, "POST", jsonObject,
        function (result) {
            if (result != null) {
                $("#goalHistTable").empty();
                var html = "";
                html = "<tr><th>Start Date</th><th>End Date</th><th>Remarks</th><th>Action</th><th>Action Date</th><th>Action By</th></tr>";
                for (var i = 0; i < result.length; i++) {
                    html += "<tr><td>" + result[i].StartDate + "</td><td>" + result[i].EndDate + "</td><td>" + result[i].Remark + "</td><td>" + result[i].Status + "</td><td>" + result[i].CreatedDate + "</td><td>" + result[i].CreatedBy + "</td></tr>";
                }
                $("#goalHistTable").append(html);
            }
            else
                misAlert("Unable to fetch goal details", "Error", "error");
        });
}

function openPopupEditTeamGoal(goalId) {
    $("#modalEditTeamGoal").modal('show');
    $("#hdnEditTeamGoalId").val(goalId);
    $("#teamGoalStartDate").datepicker({ autoclose: true, todayHighlight: true }).datepicker('setStartDate', _FYStartDateT);
    $("#teamGoalStartDate").datepicker({ autoclose: true, todayHighlight: true }).on('changeDate', function () {
        $("#teamGoalEndDate").val("");
        $("#teamGoalEndDate").datepicker('setStartDate', $("#teamGoalStartDate").val());
    });
    $("#teamGoalEndDate").datepicker({ autoclose: true, todayHighlight: true }).datepicker('setEndDate', _FYEndDateT);
    var jsonObject = {
        goalId: $("#hdnEditTeamGoalId").val()
    };
    calltoAjax(misApiUrl.fetchTeamGoalDetailById, "POST", jsonObject,
        function (result) {
            if (result != null) {
                $("#teamGoalStartDate").val(result.StartDate);
                $("#teamGoalEndDate").val(result.EndDate);
                $("#teamGoalStartDate").removeClass('error-validation');
                $("#teamGoalEndDate").removeClass('error-validation');
                bindGoalCategory("#ddlTeamGoalCategory", result.GoalCategoryId);
                $("#teamGoalDesc").val(result.Goal);
            }
            else
                misAlert("Unable to fetch goal details", "Error", "error");
        });
}

function editTeamGoal() {
    if (!validateControls('editTeamGoalDiv'))
        return false;
    var jsonObject = {
        GoalId: $("#hdnEditTeamGoalId").val(),
        StartDate: $("#teamGoalStartDate").val(),
        EndDate: $("#teamGoalEndDate").val(),
        GoalCategoryId: parseInt($("#ddlTeamGoalCategory").val() || 0),
        Goal: $("#teamGoalDesc").val(),
        UserAbrhs: misSession.userabrhs
    };
    calltoAjax(misApiUrl.editTeamGoal, "POST", jsonObject,
        function (result) {
            if (result === 1) {
                misAlert("Request processed successfully", "Success", "success");
                $("#modalEditTeamGoal").modal('hide');
                var appraisalCycleId = $("#financialYearForTeamGoal").val();
                loadTeamGoalGrid(appraisalCycleId);
            }
            else
                misAlert("Unable to process request", "Error", "error");
        });
}

function openPopupDeleteTeamGoal(goalId) {
    $("#modalDeleteTeamGoal").modal('show');
    $("#hdnDeleteTeamGoalId").val(goalId);
    $("#remarksForTeamGoal").val("");
}

function deleteTeamGoal() {
    if (!validateControls('modalDeleteTeamGoal')) {
        return false;
    }
    var reply = misConfirm("Are you sure you want to delete goal", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                userAbrhs: misSession.userabrhs,
                goalId: $("#hdnDeleteTeamGoalId").val(),
                remarks: $("#remarksForTeamGoal").val()
            };
            calltoAjax(misApiUrl.deleteTeamGoal, "POST", jsonObject,
                function (result) {
                    if (result) {
                        misAlert("Request processed successfully", "Success", "success");
                        $("#modalDeleteTeamGoal").modal('hide');
                        var appraisalCycleId = $("#financialYearForTeamGoal").val();
                        loadTeamGoalGrid(appraisalCycleId);
                    }
                    else
                        misAlert("No such record present", "Error", "error");
                });
        }
    });
}

function openPopupAddTeamGoal() {
    bindAllTeamsToAddGoals("#ddlTeamAddGoal");
    $("#modalTeamGoal").modal({
        backdrop: 'static',
        keyboard: false
    });
    $("#modalTeamGoal").modal('show');
    $("#dynamicAddTeamGoal").empty();
}

$("#btnAddNewTeamGoal").click(function () {
    if (!validateControls('dynamicAddTeamGoal')) {
        return false;
    }
    generateControlsForTeamGoal('dynamicAddTeamGoal');
});

function generateControlsForTeamGoal(containerId, maxNoOfTextBoxes, minNoOfMandatoryTxtBoxes) {
    maxNoOfTextBoxes = maxNoOfTextBoxes || 100;
    if (containerId) {
        var txtCount = $("#" + containerId).find('.itemRowT').length;
        if (txtCount < maxNoOfTextBoxes) {
            $("#" + containerId).append(getDynamicControlsForTeamGoal(txtCount, minNoOfMandatoryTxtBoxes || 1, ''));
            $("#goalStartDateT" + txtCount).datepicker({ autoclose: true, todayHighlight: true }).datepicker('setStartDate', new Date(_FYStartDateT));
            $("#goalEndDateT" + txtCount).datepicker({ autoclose: true, todayHighlight: true }).datepicker('setEndDate', new Date(_FYEndDateT));
            $("#goalStartDateT" + txtCount).datepicker({ autoclose: true, todayHighlight: true }).on('changeDate', function () {
                $("#goalEndDateT" + txtCount).val('');
                $("#goalEndDateT" + txtCount).datepicker('setStartDate', new Date($("#goalStartDateT" + txtCount).val()));
            });
            $("#goalStartDateT" + txtCount).datepicker('update', new Date());
            $("#goalEndDateT" + txtCount).datepicker({ autoclose: true, todayHighlight: true }).datepicker('setStartDate', $("#goalStartDateT" + txtCount).val());
        }
        else {
            misAlert("You can't add more than " + maxNoOfTextBoxes + " goals!", 'Sorry', 'warning');
        }
        $(".select2").select2();
    }
}

function getDynamicControlsForTeamGoal(idx, minNoOfMandatoryTxtBoxes, value) {
    var html = '<div class="row col-md-12 itemRowT" id = "dynamicAddTeamGoalDiv-' + idx + '">' +
        '<div class="row">' +
        '<div class="col-md-2"><div class="form-group"><label>Goal start date<span class="spnError">*</span></label><div class="input-group"><div class="input-group-addon"><i class="fa fa-calendar"></i></div><input disable="" type="text" class="form-control validation-required" placeholder="Start date" tabindex="6" id="goalStartDateT' + idx + '" data-mask="" data-attr-name="r2"></div></div></div>' +
        '<div class="col-md-2"><div class="form-group"><label>Goal end date<span class="spnError">*</span></label><div class="input-group"><div class="input-group-addon"><i class="fa fa-calendar"></i></div><input disable="" type="text" class="form-control validation-required" placeholder="End date" tabindex="6" id="goalEndDateT' + idx + '" data-mask="" data-attr-name="r2"></div></div></div>' +
        '<div class="col-md-2"><div class="form-group"> <label>Goal type<span class="spnError">*</span></label><div class="input-group ddl-ellipsis"><select class="form-control select2 validation-required" id="ddlGoalCategoryT' + idx + '"><option value="0">Select</option></select></div></div></div>' +
        '<div class="col-md-5"><div class="form-group"><label>Goal description<span class="spnError">*</span></label><textarea rows="2" cols="6" class="form-control validation-required" placeholder="Goal description" id="goalT' + idx + '" maxlength="4000" data-mask="" data-attr-name="r2"></textarea></div></div>' +
        '<div class="col-md-1" style="padding-top: 22px;"><span class="input-group-btn"><button class="btn btn-danger" style="background-color: #d2322d;" value="X" onclick="removeControlsForTeamGoal(this)">X</button></span></div>' +
        '</div></div>';

    var controlId = "#ddlGoalCategoryT" + idx;
    bindGoalCategory(controlId, 0);
    return html;
}

function removeControlsForTeamGoal(item) {
    $(item).closest('.itemRowT').remove();
}

function getTeamFormData() {
    var collection = new Array();
    var items;
    $('.itemRowT').each(function () {
        var id = $(this).closest(".itemRowT").attr("id").split('-')[1];
        items = new Object();
        items.StartDate = $("#goalStartDateT" + id).val();
        items.EndDate = $("#goalEndDateT" + id).val();
        items.Goal = $("#goalT" + id).val();
        items.GoalCategoryId = parseInt($("#ddlGoalCategoryT" + id).val() || 0);
        collection.push(items);
    });
    return collection;
}

function submitTeamGoal() {
    if (draftedTeamGoalId.length == 0) {
        misAlert("No goals are there in draft state", "Warning", "warning");
        return false;
    }
    var reply = misConfirm("This will submit all the draft goals. They cannot be modified further", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                goalIds: draftedTeamGoalId.toString(),
                userAbrhs: misSession.userabrhs
            };
            calltoAjax(misApiUrl.submitTeamGoals, "POST", jsonObject,
                function (result) {
                    if (result) {
                        draftedTeamGoalId = [];
                        misAlert("Request processed successfully", "Success", "success");
                        var appraisalCycleId = $("#financialYearForTeamGoal").val();
                        loadTeamGoalGrid(appraisalCycleId);
                    }
                    else
                        misAlert("Unable to process request. Please try again.", "Error", "error");
                });
        }
    });
}

function draftTeamGoal() {
    if (!validateControls('modalTeamGoal')) {
        return false;
    }
    if (getTeamFormData().length == 0) {
        misAlert("No goals have been added.", "Warning", "warning");
        return false;
    }
    var jsonObject = {
        goalList: getTeamFormData(),
        teamAbrhs: $("#ddlTeamAddGoal").val(),
        userAbrhs: misSession.userabrhs,
        goalCycleId: $("#txtHiddenTeamGoalCycleId").val()
    };
    calltoAjax(misApiUrl.draftTeamGoals, "POST", jsonObject,
        function (result) {
            if (result === 1) {
                $("#ddlTeam").val("0");
                misAlert("Request processed successfully", "Success", "success");
                var appraisalCycleId = $("#financialYearForTeamGoal").val();
                loadTeamGoalGrid(appraisalCycleId);
                $("#dynamicAddTeamGoal").empty();
            }
            else if (result === 2) {
                misAlert("Appraisal cycle is not mapped for the current financial year.", "Warning", "warning");
            }
            else
                misAlert("Unable to process request. Please try again.", "Error", "error");
        });
}

function openPopupForTeamGoal(goalId, startDate) {
    $("#modalChangeTeamGoalStatus").modal('show');
    $("#hdnTeamGoalId").val(goalId);
    $('#teamGoalAchievingDate').datepicker({ autoclose: true, todayHighlight: true })
        .datepicker('setEndDate', todayDate).datepicker('setStartDate', startDate);
}

function markTeamGoalAsAchieved() {
    if (!validateControls('modalChangeTeamGoalStatus')) {
        return false;
    }
    var jsonObject = {
        userAbrhs: misSession.userabrhs,
        goalId: $("#hdnTeamGoalId").val(),
        remarks: $("#teamGoalUserRemarks").val(),
        date: $("#teamGoalAchievingDate").val()
    };
    calltoAjax(misApiUrl.markTeamGoalAsAchieved, "POST", jsonObject,
        function (result) {
            switch (result) {
                case 1:
                    misAlert("Request processed successfully", "Success", "success");
                    $("#modalChangeTeamGoalStatus").modal('hide');
                    var appraisalCycleId = $("#financialYearForTeamGoal").val();
                    loadTeamGoalGrid(appraisalCycleId);
                    break;
                case 2:
                    misAlert("You are not authorised to perform this action", "Error", "error");
                    break;
                case 3:
                    misAlert("Goal has already been marked as achieved", "Warning", "warning");
                    break;
                case 4:
                    misAlert("No such record present", "Error", "error");
                    break;
            }
        });
}