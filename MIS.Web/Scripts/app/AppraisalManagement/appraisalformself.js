var AppraiserAbrhs = '';
var AppraiseeAbrhs = '';
var IsAppraisee = 0;
var hasModifyRight = false;
var AppraisalStatusId = 0;
var _currentTab = 'Tab1';
var _oldTabId = 'Tab1';

$(function () {
    BtnGroup('DELIVERY_INTERVAL');
    BtnGroup('PICKUP_INTERVAL');

    $('div.idealforms').idealforms({
        silentLoad: false,
    });

    //Bind Tab Clicks.
    //$('#btnSaveAsDraft').click(function (e) {
    $("#btnSaveAsDraft").unbind().click(function () {
        var tabid = $(".idealsteps-step-active").attr('id');
        if (AppraisalStatusId <= 3) {
            if (tabid == 'Tab1') {
                navigateToTab(2);
            }

            if (tabid == 'Tab2') {
                if (AppraiseeAbrhs == misSession.userabrhs && (AppraisalStatusId == 3 || AppraisalStatusId == 2)) {
                    SaveAppraisalForm();
                }
                navigateToTab(3);
            }
            if (tabid == 'Tab3') {
                if (AppraiseeAbrhs == misSession.userabrhs && (AppraisalStatusId == 3 || AppraisalStatusId == 2)) {
                    SaveEmployeeGoals();
                }
                navigateToTab(4);
            }
            if (tabid == 'Tab4') {
                if (AppraiseeAbrhs == misSession.userabrhs && (AppraisalStatusId == 3 || AppraisalStatusId == 2)) {
                    $("#btnSaveAsDraft").html("<i class='fa fa-save'></i>&nbsp;Final Submit");
                    SaveEmployeeAchievementsByAppraisee();
                }
                navigateToTab(5);
            }
            if (tabid == 'Tab5') {
                if (AppraiseeAbrhs == misSession.userabrhs && (AppraisalStatusId == 3 || AppraisalStatusId == 2)) {
                    FinalSubmitAppraisalForm();
                }
                else {
                    navigateToTab(1);
                }
            }
        }
        else {
            if (tabid == 'Tab1') {
                navigateToTab(2);
            }

            if (tabid == 'Tab2') {
                navigateToTab(3);
            }
            if (tabid == 'Tab3') {
                navigateToTab(4);
            }
            if (tabid == 'Tab4') {
                navigateToTab(5);
            }
            if (tabid == 'Tab5') {
                navigateToTab(1);
            }
        }
    });

    $("#Tab1").click(function () {
        if (AppraiseeAbrhs == misSession.userabrhs && (AppraisalStatusId == 2 || AppraisalStatusId == 3)) {
            $("#btnSaveAsDraft").html("<i class='fa fa-save'></i>&nbsp;Save &amp; Continue");
            saveOnTabChange(_oldTabId);
        }
    });

    $("#Tab2").click(function () {
        if (AppraiseeAbrhs == misSession.userabrhs && (AppraisalStatusId == 2 || AppraisalStatusId == 3)) {
            $("#btnSaveAsDraft").html("<i class='fa fa-save'></i>&nbsp;Save &amp; Continue");
            saveOnTabChange(_oldTabId);
        }
    });

    $("#Tab3").click(function () {
        if (AppraiseeAbrhs == misSession.userabrhs && (AppraisalStatusId == 2 || AppraisalStatusId == 3)) {
            $("#btnSaveAsDraft").html("<i class='fa fa-save'></i>&nbsp;Save &amp; Continue");
            saveOnTabChange(_oldTabId);
        }
    });

    $("#Tab4").click(function () {
        if (AppraiseeAbrhs == misSession.userabrhs && (AppraisalStatusId == 2 || AppraisalStatusId == 3)) {
            $("#btnSaveAsDraft").html("<i class='fa fa-save'></i>&nbsp;Save &amp; Continue");
            saveOnTabChange(_oldTabId);
        }
    });

    $("#Tab5").click(function () {
        if (AppraiseeAbrhs == misSession.userabrhs && (AppraisalStatusId == 2 || AppraisalStatusId == 3)) {
            $("#btnSaveAsDraft").html("<i class='fa fa-save'></i>&nbsp;Final Submit");
            saveOnTabChange(_oldTabId);
        }
    });

    bindApraisalForm();

    //start auto save/update for every 60 sec (60000 milli second)
    window.setInterval(function () {
        startAutoSave();
    }, 60000);

    var popOverSettings = {
        selector: '[rel=popover]',
        trigger: 'hover',
        placement: 'right',
        container: 'body',
        html: true,
        content: function () {
            return $(this).attr("data-attr-evalCriteria");
        }
    }
    $('body').popover(popOverSettings);

    $("#btnCloseAppraisalForm").click(function () {
        hasModifyRight = false;
        $("#selfAppraisalFormPopup").modal("hide");
    });
});

function startAutoSave() {
    //start auto save/update on the specific time interval
    _currentTab = $(".idealsteps-step-active").attr('id');
    if (_currentTab && hasModifyRight === true) {
        switch (_currentTab) {
            case "Tab2":
                addUpdateEmployeeAppraisalFormAsync();
                break;
            case "Tab3":
                addUpdateEmployeeAppraisalGoalAsync();
                break;
            default:
                break;
        }
    }
}

function saveOnTabChange(tabId) {
    if (tabId && hasModifyRight === true) {
        switch (tabId) {
            case "Tab2":
                addUpdateEmployeeAppraisalFormAsync();
                break;
            case "Tab3":
                addUpdateEmployeeAppraisalGoalAsync();
                break;
            case "Tab4":
                SaveEmployeeAchievementsByAppraisee();
                break;
            default:
                break;
        }
    }
    _oldTabId = $(".idealsteps-step-active").attr('id');
}

function BtnGroup(divid) {
    $('.' + divid + ' button').first().attr("aria-pressed", "true");
    $('.' + divid + ' button').first().addClass("active");
    $('#' + divid).attr('value', $('.' + divid + ' button.active').val());
    $('.' + divid + ' button').click(function () {
        $('.' + divid + ' button').attr("aria-pressed", "false");
        $('.' + divid + ' button').removeClass("active");
        $(this).attr("aria-pressed", "true");
        $(this).addClass("active");
        $('#' + divid).attr('value', $('.' + divid + ' button.active').val());
    });
}

function bindApraisalForm() {
    var JsonObject = {
        empAppraisalSettingId: $("#hdnEmpAppraisalSettingId").val(),
        digestKey: $("#hdnDigestKey").val()
    };
    calltoAjax(misApiUrl.getAppraisalFormData, "POST", JsonObject,
        function (result) {
            result = $.parseJSON(JSON.stringify(result));
            bindAppraisalFormDetails(result);
            bindAppraisalTechnicalCompetency(result);
            bindAppraisalBehaviouralCompetency(result);
            bindAppraisalGoals(result);
            AppraisalStatusId = result.AppraisalStatusId;
            AppraiserAbrhs = result.AppraiserAbrhs;
            AppraiseeAbrhs = result.AppraiseeAbrhs;
            hasModifyRight = result.IsModifyRight;

            //Rating Div
            if (AppraiseeAbrhs == misSession.userabrhs) {
                $("#divRating").append('<div style="display: inline-block;padding-left: 25px;"><div class="sign-avatar rattingcircle" style="background:#3ade03;" id="lblAppraiseeRatingWeighted"></div>Appraisee Rating</div>');
                $("#divNormalRating").append('<div style="display: inline-block;padding-left: 25px;"><div class="sign-avatar rattingcircle" style="background:#3ade03;" id="lblAppraiseeNormalRating"></div>Appraisee Rating</div>');
                if (AppraisalStatusId > 4) {
                    $("#divRating").append('<div style="display: inline-block;padding-left: 25px;"><div class="sign-avatar rattingcircle" style="background: #34af0b;" id="lblAppraiserRatingWeighted"></div>Appraiser Rating</div>');
                    $("#divNormalRating").append('<div style="display: inline-block;padding-left: 25px;"><div class="sign-avatar rattingcircle" style="background: #34af0b;" id="lblAppraiserNormalRating"></div>Appraiser Rating</div>');
                }
            }

            $("#lblAppraiseeRatingWeighted").html(result.SelfOverallRatingWeighted);
            $("#lblAppraiserRatingWeighted").html(result.AppraiserOverallRatingWeighted);
            $("#lblAppraiseeNormalRating").html(result.SelfOverallRatingNormal);
            $("#lblAppraiserNormalRating").html(result.AppraiserOverallRatingNormal);
            //Change Save and Next Button Text.
            if (AppraiseeAbrhs == misSession.userabrhs && (AppraisalStatusId === 3 || AppraisalStatusId === 2)) {
                $("#btnSaveAsDraft").html("<i class='fa fa-save'></i>&nbsp;Save &amp; Continue");
            }
            else {
                $("#btnSaveAsDraft").html("Next&nbsp;<i class='fa fa-arrow-circle-o-right'></i>");
            }

            $("#btnSaveAsDraft").removeClass("hidden");
            // Change Status Self Appraisal Initiated to Self Appraisal Pending
            if (misSession.userabrhs == result.AppraiseeAbrhs && result.AppraisalStatusId == 2) {
                UpdateFormStatusFormOpen();
            }

            $("#txtReviewFrom").val(result.ReviewFrom);
            $("#txtReviewTo").val(result.ReviewTo);

            if (result.AppraisalStatusId < 4) {
                var html = '<a id="btnAddNew" onClick="AddNewControl();" data-toggle="modal" class="btn btn-primary pull-left"><i class="fa fa-plus"></i></a>&nbsp;<span class="spnError">Click to add your achievements.</span><div id="dynamicAddAchievements"></div>';
                $("#divEmployeeAchievements").append(html);
                bindAchievementsAfterAdd(result);
            }
            else {
                bindAppraisalAchievements(result);
            }
        });
}

function navigateToTab(sequence) {
    $(".tabClass").removeClass("idealsteps-step-active");
    $("#Tab" + sequence).addClass("idealsteps-step-active");
    $(".idealsteps-step").hide();
    $("#step" + sequence).show();
}

function bindAppraisalFormDetails(formData) {
    var appraisalData = formData;
    //hidden form values
    $("#hdnEmpAppraisalId").val(appraisalData.EmpAppraisalId);
    $("#hdnEmpAppraisalSettingId").val(appraisalData.EmpAppraisalSettingId);

    //Appraisee Details
    $("#txtAppraiseName").val(appraisalData.EmployeeName);
    $("#txtAppraiseDesignation").val(appraisalData.DesignationName);
    $("#txtAppraiseDOJ").val(appraisalData.DateOfJoin);
    $("#appraiserName").html(appraisalData.AppraiserName);
    $("#appraiseeName").html(appraisalData.EmployeeName);
    if (appraisalData.SelfSubmitDate == null || appraisalData.SelfSubmitDate == '') {
        $("#spndate").html(toddMMMyyy(new Date()));
    }
    else {
        $("#spndate").html(appraisalData.SelfSubmitDate);
    }


    //Appraiser Details
    $("#txtAppraiserName").val(appraisalData.AppraiserName);
    $("#txtAppraiserDesignation").val(appraisalData.AppraiserDesignation);

    //Approver Details
    $("#txtReviewerName").val(appraisalData.Approver1Name);
    $("#txtReviewerDesignation").val(appraisalData.Approver1Designation);

    //Appraisee Additional Comments
    $("#txtAppraiseComments").val(appraisalData.AppraiseeComment);

    //Appraiser Additional Comments
    $("#txtAppraiserComments").val(appraisalData.AppraiserComment);

    //Approver Additional Comments
    $("#txtApproverComments").val(appraisalData.ApproverComment);
}

function bindAppraisalTechnicalCompetency(formData) {
    var resultData = $.parseJSON(formData.AppraisalParameterDetail);
    resultData = $.grep(resultData, function (n, i) {
        return n.CompetencyTypeId == 2;
    });
    $('#gridAppraisalTechnicalCompetency').DataTable({
        data: resultData,
        "responsive": true,
        "paging": false,
        "bDestroy": false,
        "searching": false,
        "ordering": false,
        "info": false,
        "columns": [
            {
                "data": "ParameterName",
                "sTitle": "Parameter Name",
                "sClass": "width-per-20",
                mRender: function (data, type, row) {
                    var hidd = '';
                    hidd += '<input type="hidden" value="' + row.CompetencyFormDetailId + '" data-attr-CompetencyFormDetailId="' + row.CompetencyFormDetailId + '" data-attr-EAParameterDetailId="' + row.EAParameterDetailId + '" id="hdnCompetencyFormDetailId' + row.CompetencyFormDetailId + '" name="hdnCompetencyFormDetailId' + row.CompetencyFormDetailId + '" />';
                    hidd += "<a class='evalCreteria' rel='popover' href='javascript:void(0)' data-attr-kra='" + row.ParameterName + "' data-attr-evalCriteria='" + row.EvaluationCriteria + "'>" + '<span style="">' + row.ParameterName + "</span></a> ";
                    return hidd;
                }
            },
           {
               "data": "SelfAppraisal",
               "sTitle": "Self Comments <span class='spnError'><b>*</b></span>",
               "sClass": "col-max-width-200 relative-pos",
               mRender: function (data, type, row) {
                   var colElement = '';
                   if (formData.IsSelfAppraisal) {
                       var isEmpAccess = (formData.IsModifyRight == true && formData.AppraiseeAbrhs == misSession.userabrhs && (formData.AppraisalStatusId == 2 || formData.AppraisalStatusId == 3));
                       var enabled = (isEmpAccess == false) ? "disabled='disabled'" : "";
                       var validationClass = "form-control scroll-max-height-200 self-feedback openPopup" + ((isEmpAccess == false) ? "" : " validation-required openPopup");
                       colElement = "<textarea " + enabled + " id ='txtSelf" + row.CompetencyFormDetailId + "' style='width:100%;' placeholder='Enter your comments here...' rows='3' maxlength='4000' class='" + validationClass + "' onkeypress='return blockSpecialChar(event)'>" + row.SelfComment + "</textarea>" +
                                    '<div class="btn-group ' + ((isEmpAccess == true) ? "" : "radioButtonDisabled") + '" data-toggle="buttons" style="width:100%;" id ="selfTeRating' + row.CompetencyFormDetailId + '">' +
                                    '<label class="rating-button btn btn-default ' + (row.SelfRatingId == 1 ? 'active' : '') + '"><input name="rdbselfTeRating' + row.CompetencyFormDetailId + '" value="1" type="radio" ' + (row.SelfRatingId == 1 ? 'checked' : '') + '>1</label>' +
                                    '<label class="rating-button btn btn-default ' + (row.SelfRatingId == 2 ? 'active' : '') + '"><input name="rdbselfTeRating' + row.CompetencyFormDetailId + '" value="2" type="radio" ' + (row.SelfRatingId == 2 ? 'checked' : '') + '>2</label>' +
                                    '<label class="rating-button btn btn-default ' + (row.SelfRatingId == 3 ? 'active' : '') + '"><input name="rdbselfTeRating' + row.CompetencyFormDetailId + '" value="3" type="radio" ' + (row.SelfRatingId == 3 ? 'checked' : '') + '>3</label>' +
                                    '<label class="rating-button btn btn-default ' + (row.SelfRatingId == 4 ? 'active' : '') + '"><input name="rdbselfTeRating' + row.CompetencyFormDetailId + '" value="4" type="radio" ' + (row.SelfRatingId == 4 ? 'checked' : '') + '>4</label>' +
                                    '<label class="rating-button btn btn-default ' + (row.SelfRatingId == 5 ? 'active' : '') + '"><input name="rdbselfTeRating' + row.CompetencyFormDetailId + '" value="5" type="radio" ' + (row.SelfRatingId == 5 ? 'checked' : '') + '>5</label></div>';
                   }
                   return colElement;
               }
           },
           {
               "data": "AppraiserFeedback",
               "sTitle": "Appraiser Comments <span class='spnError'><b>*</b></span>",
               "sClass": "col-max-width-200 relative-pos",
               mRender: function (data, type, row) {
                   var isEmpAccess = (formData.IsModifyRight == true && formData.AppraisalStatusId == 4 && formData.AppraiserAbrhs == misSession.userabrhs);
                   var enabled = (isEmpAccess == false) ? "disabled='disabled'" : "";
                   var validationClass = "form-control max-height-txt scroll-max-height-200 appraiser-feedback" + ((isEmpAccess == false) ? "" : " validation-required openPopup");
                   var html = "<textarea " + enabled + " id ='txtAppraiserFeed" + row.CompetencyFormDetailId + "' style='width:100%;' placeholder='Enter your comments here...' rows='3' maxlength='4000' class='" + validationClass + "' onkeypress='return blockSpecialChar(event)'>" + row.AppraiserComment + "</textarea>" +
                                   '<div class="btn-group ' + ((isEmpAccess == true) ? "" : "radioButtonDisabled") + '" data-toggle="buttons" style="width:100%;margin-left: 0px !important;" id ="appraiserTeRating' + row.CompetencyFormDetailId + '">' +
                                    '<label class="rating-button btn btn-default ' + (row.AppraiserRatingId == 1 ? 'active' : '') + '"><input name="rdbappraiserTeRating' + row.CompetencyFormDetailId + '" value="1" type="radio" ' + (row.AppraiserRatingId == 1 ? 'checked' : '') + '>1</label>' +
                                    '<label class="rating-button btn btn-default ' + (row.AppraiserRatingId == 2 ? 'active' : '') + '"><input name="rdbappraiserTeRating' + row.CompetencyFormDetailId + '" value="2" type="radio" ' + (row.AppraiserRatingId == 2 ? 'checked' : '') + '>2</label>' +
                                    '<label class="rating-button btn btn-default ' + (row.AppraiserRatingId == 3 ? 'active' : '') + '"><input name="rdbappraiserTeRating' + row.CompetencyFormDetailId + '" value="3" type="radio" ' + (row.AppraiserRatingId == 3 ? 'checked' : '') + '>3</label>' +
                                    '<label class="rating-button btn btn-default ' + (row.AppraiserRatingId == 4 ? 'active' : '') + '"><input name="rdbappraiserTeRating' + row.CompetencyFormDetailId + '" value="4" type="radio" ' + (row.AppraiserRatingId == 4 ? 'checked' : '') + '>4</label>' +
                                    '<label class="rating-button btn btn-default ' + (row.AppraiserRatingId == 5 ? 'active' : '') + '"><input name="rdbappraiserTeRating' + row.CompetencyFormDetailId + '" value="5" type="radio" ' + (row.AppraiserRatingId == 5 ? 'checked' : '') + '>5</label></div>';
                   return html;
               }
           }
        ]
    });

}

function bindAppraisalBehaviouralCompetency(formData) {

    var resultData = $.parseJSON(formData.AppraisalParameterDetail);
    resultData = $.grep(resultData, function (n, i) {
        return n.CompetencyTypeId == 1;
    });

    $('#gridAppraisalBehaviouralCompetency').DataTable({
        data: resultData,
        "responsive": true,
        "paging": false,
        "bDestroy": false,
        "searching": false,
        "ordering": false,
        "info": false,
        "columns": [
           {
               "data": "ParameterName",
               "sTitle": "Parameter Name",
               "sClass": "width-per-20",
               mRender: function (data, type, row) {
                   var hidd = '';
                   hidd += '<input type="hidden" value="' + row.CompetencyFormDetailId + '" data-attr-CompetencyFormDetailId="' + row.CompetencyFormDetailId + '" data-attr-EAParameterDetailId="' + row.EAParameterDetailId + '" id="hdnCompetencyFormDetailId' + row.CompetencyFormDetailId + '" name="hdnCompetencyFormDetailId' + row.CompetencyFormDetailId + '" />';
                   hidd += "<a class='evalCreteria' rel='popover' href='javascript:void(0)' data-attr-kra='" + row.ParameterName + "' data-attr-evalCriteria='" + row.EvaluationCriteria + "'>" + '<span style="">' + row.ParameterName + "</span></a> ";
                   return hidd;
               }
           },
           {
               "data": "SelfAppraisal",
               "sTitle": "Self Comments <span class='spnError'><b>*</b></span>",
               "sClass": "col-max-width-200 relative-pos",
               mRender: function (data, type, row) {
                   var colElement = '';
                   if (formData.IsSelfAppraisal) {
                       var isEmpAccess = (formData.IsModifyRight == true && formData.AppraiseeAbrhs == misSession.userabrhs && (formData.AppraisalStatusId == 2 || formData.AppraisalStatusId == 3));
                       var enabled = (isEmpAccess == false) ? "disabled='disabled'" : "";
                       var validationClass = "form-control scroll-max-height-200 self-feedback openPopup" + ((isEmpAccess == false) ? "" : " validation-required openPopup");
                       colElement = "<textarea " + enabled + " id ='txtSelf" + row.CompetencyFormDetailId + "' style='width:100%;' placeholder='Enter your comments here...' rows='3' maxlength='4000' class='" + validationClass + "' onkeypress='return blockSpecialChar(event)'>" + row.SelfComment + "</textarea>" +
                                    '<div class="btn-group ' + ((isEmpAccess == true) ? "" : "radioButtonDisabled") + '" data-toggle="buttons" style="width:100%;" id ="selfTeRating' + row.CompetencyFormDetailId + '">' +
                                    '<label class="rating-button btn btn-default ' + (row.SelfRatingId == 1 ? 'active' : '') + '"><input name="rdbselfTeRating' + row.CompetencyFormDetailId + '" value="1" type="radio" ' + (row.SelfRatingId == 1 ? 'checked' : '') + '>1</label>' +
                                    '<label class="rating-button btn btn-default ' + (row.SelfRatingId == 2 ? 'active' : '') + '"><input name="rdbselfTeRating' + row.CompetencyFormDetailId + '" value="2" type="radio" ' + (row.SelfRatingId == 2 ? 'checked' : '') + '>2</label>' +
                                    '<label class="rating-button btn btn-default ' + (row.SelfRatingId == 3 ? 'active' : '') + '"><input name="rdbselfTeRating' + row.CompetencyFormDetailId + '" value="3" type="radio" ' + (row.SelfRatingId == 3 ? 'checked' : '') + '>3</label>' +
                                    '<label class="rating-button btn btn-default ' + (row.SelfRatingId == 4 ? 'active' : '') + '"><input name="rdbselfTeRating' + row.CompetencyFormDetailId + '" value="4" type="radio" ' + (row.SelfRatingId == 4 ? 'checked' : '') + '>4</label>' +
                                    '<label class="rating-button btn btn-default ' + (row.SelfRatingId == 5 ? 'active' : '') + '"><input name="rdbselfTeRating' + row.CompetencyFormDetailId + '" value="5" type="radio" ' + (row.SelfRatingId == 5 ? 'checked' : '') + '>5</label></div>';
                   }
                   return colElement;
               }
           },
           {
               "data": "AppraiserFeedback",
               "sTitle": "Appraiser Comments <span class='spnError'><b>*</b></span>",
               "sClass": "col-max-width-200 relative-pos",
               mRender: function (data, type, row) {
                   var isEmpAccess = (formData.IsModifyRight == true && formData.AppraisalStatusId == 4 && formData.AppraiserAbrhs == misSession.userabrhs);
                   var enabled = (isEmpAccess == false) ? "disabled='disabled'" : "";
                   var validationClass = "form-control max-height-txt scroll-max-height-200 appraiser-feedback" + ((isEmpAccess == false) ? "" : " validation-required openPopup");
                   var html = "<textarea " + enabled + " id ='txtAppraiserFeed" + row.CompetencyFormDetailId + "' style='width:100%;' placeholder='Enter your comments here...' rows='3' maxlength='4000' class='" + validationClass + "' onkeypress='return blockSpecialChar(event)'>" + row.AppraiserComment + "</textarea>" +
                                   '<div class="btn-group ' + ((isEmpAccess == true) ? "" : "radioButtonDisabled") + '" data-toggle="buttons" style="width:100%;margin-left: 0px !important;" id ="appraiserTeRating' + row.CompetencyFormDetailId + '">' +
                                    '<label class="rating-button btn btn-default ' + (row.AppraiserRatingId == 1 ? 'active' : '') + '"><input name="rdbappraiserTeRating' + row.CompetencyFormDetailId + '" value="1" type="radio" ' + (row.AppraiserRatingId == 1 ? 'checked' : '') + '>1</label>' +
                                    '<label class="rating-button btn btn-default ' + (row.AppraiserRatingId == 2 ? 'active' : '') + '"><input name="rdbappraiserTeRating' + row.CompetencyFormDetailId + '" value="2" type="radio" ' + (row.AppraiserRatingId == 2 ? 'checked' : '') + '>2</label>' +
                                    '<label class="rating-button btn btn-default ' + (row.AppraiserRatingId == 3 ? 'active' : '') + '"><input name="rdbappraiserTeRating' + row.CompetencyFormDetailId + '" value="3" type="radio" ' + (row.AppraiserRatingId == 3 ? 'checked' : '') + '>3</label>' +
                                    '<label class="rating-button btn btn-default ' + (row.AppraiserRatingId == 4 ? 'active' : '') + '"><input name="rdbappraiserTeRating' + row.CompetencyFormDetailId + '" value="4" type="radio" ' + (row.AppraiserRatingId == 4 ? 'checked' : '') + '>4</label>' +
                                    '<label class="rating-button btn btn-default ' + (row.AppraiserRatingId == 5 ? 'active' : '') + '"><input name="rdbappraiserTeRating' + row.CompetencyFormDetailId + '" value="5" type="radio" ' + (row.AppraiserRatingId == 5 ? 'checked' : '') + '>5</label></div>';
                   return html;
               }
           }
        ]
    });
}

function bindAppraisalGoals(formData) {
    var resultData = $.parseJSON(formData.EmployeeGoals);
    $('#gridAppraisalGoals').DataTable({
        data: resultData,
        "responsive": true,
        "autoWidth": false,
        "paging": false,
        "bDestroy": false,
        "searching": false,
        "ordering": false,
        "info": false,
        "columns": [
            {
                "sTitle": "Previous Goals",
                "sClass": "col-max-width-100",
                "sWidth": "140px",
                mRender: function (data, type, row) {
                    var hidd = '';
                    hidd += '<input type="hidden" value="' + row.UserGoalId + '"  id="hdnUserGoalId' + row.UserGoalId + '" name="hdnUserGoalId' + row.UserGoalId + '" data-attr-UserGoalId="' + row.UserGoalId + '"/>';
                    hidd += '<span style="">' + row.Goal + '</span>';
                    return hidd;
                }
            },
             {
                 "sTitle": "Self Comments <span class='spnError'><b>*</b></span>",
                 "sClass": "col-max-width-200 relative-pos",
                 "sWidth": "350px",
                 mRender: function (data, type, row) {
                     var colElement = '';
                     if (formData.IsSelfAppraisal) {
                         var isEmpAccess = (formData.IsModifyRight == true && formData.AppraiseeAbrhs == misSession.userabrhs && (formData.AppraisalStatusId == 2 || formData.AppraisalStatusId == 3));
                         var enabled = (isEmpAccess == false) ? "disabled='disabled'" : "";
                         var validationClass = "form-control scroll-max-height-200 self-feedback openPopup" + ((isEmpAccess == false) ? "" : " validation-required openPopup");
                         colElement = "<textarea " + enabled + " id ='txtSelf" + row.UserGoalId + "' style='width:100%;' placeholder='Enter your comments here...' rows='3' maxlength='4000' class='" + validationClass + "' onkeypress='return blockSpecialChar(event)'>" + row.SelfComment + "</textarea>";
                     }
                     return colElement;
                 }
             },
            {
                "sTitle": "Appraiser Comments <span class='spnError'><b>*</b></span>",
                "sClass": "col-max-width-200 relative-pos",
                "sWidth": "350px",
                mRender: function (data, type, row) {
                    var isEmpAccess = (formData.IsModifyRight == true && formData.AppraisalStatusId == 4 && formData.AppraiserAbrhs == misSession.userabrhs);
                    var enabled = (isEmpAccess == false) ? "disabled='disabled'" : "";
                    var validationClass = "form-control max-height-txt scroll-max-height-200 appraiser-feedback" + ((isEmpAccess == false) ? "" : " validation-required openPopup");
                    return "<textarea " + enabled + " id ='txtAppraiserFeed" + row.UserGoalId + "' style='width:100%;' placeholder='Enter your comments here...' rows='3' maxlength='4000' class='" + validationClass + "' onkeypress='return blockSpecialChar(event)'>" + row.AppraiserComment + "</textarea>";
                }
            }
        ]
    });
}

// Generate Dynamic Controls for add Achivements.
function AddNewControl() {
    generateControls('dynamicAddAchievements');
}

function generateControls(containerId, maxNoOfTextBoxes, minNoOfMandatoryTxtBoxes) {
    maxNoOfTextBoxes = maxNoOfTextBoxes || 10;
    if (containerId) {
        var txtCount = 0;
        var itemrow = $("#dynamicAddAchievements .itemRow");
        if (itemrow && itemrow.length > 0) {
            var controlName = itemrow.last();
            txtCount = parseInt(controlName[0].id.replace("dynamicAddAchievementsDiv-", "")) + 1;;
        }
        //var txtCount = $("#" + containerId).find('.itemRow').length;
        if (txtCount < maxNoOfTextBoxes) {
            $("#" + containerId).append(getDynamicControls(txtCount, minNoOfMandatoryTxtBoxes || 1, '', 0));
            //dynamicId += 1;
        }
        else {
            misAlert("You can't add more than " + maxNoOfTextBoxes + " Achievements !", 'Sorry', 'warning');
        }
    }
}

function getDynamicControls(idx, minNoOfMandatoryTxtBoxes, value, userAchievementId) {
    return '<div class="col-md-12 itemRow" id = "dynamicAddAchievementsDiv-' + idx + '" data-attr-UserAchievementId=' + userAchievementId + '>' +
           '<div class="row">' +
           '<div class="col-md-5"><div class="form-group"><label>Achievement Description<span class="spnError">*</span></label><textarea rows="2" cols="6" class="form-control validation-required" placeholder="Achievements Description" id="achievements' + idx + '" maxlength="4000" data-mask="" data-attr-name="r2" onkeypress="return blockSpecialChar(event)"></textarea></div></div>' +
           '<div class="col-md-1" style="padding-top: 22px;"><span class="input-group-btn"><button class="btn btn-danger" style="background-color: #d2322d;" value="X" onclick="removeControls(this)">X</button></span></div>' +
           '</div></div>';
}

// For Edit Call.
function bindAchievementsAfterAdd(formData) {

    var resultData = $.parseJSON(formData.EmployeeAchievements);
    if (resultData.length > 0) {
        $("#dynamicAddAchievements").html('');
        dynamicReloadId = 0;
        $.each(resultData, function (key, item) {
            generateControlsForReload('dynamicAddAchievements', 20, 1, item.UserAchievementId, item.Achievement)
        });
    }
}

function generateControlsForReload(containerId, maxNoOfTextBoxes, minNoOfMandatoryTxtBoxes, achievementId, achievement) {

    maxNoOfTextBoxes = maxNoOfTextBoxes || 10;
    if (containerId) {
        var txtCount = 0;
        var itemrow = $("#dynamicAddAchievements .itemRow");
        if (itemrow && itemrow.length > 0) {
            var controlName = itemrow.last();
            txtCount = parseInt(controlName[0].id.replace("dynamicAddAchievementsDiv-", "")) + 1;;
        }
        //var txtCount = $("#" + containerId).find('.itemRow').length;
        if (txtCount < maxNoOfTextBoxes) {
            $("#" + containerId).append(getDynamicControls(txtCount, minNoOfMandatoryTxtBoxes || 1, '', achievementId));
            //dynamicReloadId += 1;
        }
        else {
            misAlert("You can't add more than " + maxNoOfTextBoxes + " Achievements !", 'Sorry', 'warning');
        }
        $('#achievements' + txtCount + '').val(achievement);
    }
}

function bindAppraisalAchievements(formData) {
    var resultData = $.parseJSON(formData.EmployeeAchievements);
    $('#gridAppraisalAchievements').DataTable({
        data: resultData,
        "responsive": true,
        "paging": false,
        "bDestroy": false,
        "searching": false,
        "ordering": false,
        "info": false,
        "columns": [
            {
                "sTitle": "Self Achievements",
                "sClass": "width-per-50",
                //"sWidth": "140px",
                mRender: function (data, type, row) {
                    var hidd = '';
                    hidd += '<input type="hidden" value="' + row.UserAchievementId + '"  id="hdnUserAchievementId' + row.UserAchievementId + '" name="hdnUserAchievementId' + row.UserAchievementId + '" data-attr-UserAchievementId="' + row.UserAchievementId + '"/>';
                    hidd += '<span style="">' + row.Achievement + '</span>';
                    return hidd;
                }
            },
            {
                "sTitle": "Appraiser Comments <span class='spnError'><b>*</b></span>",
                "sClass": "col-max-width-200 relative-pos",
                mRender: function (data, type, row) {
                    var isEmpAccess = (formData.IsModifyRight == true && formData.AppraisalStatusId == 4 && formData.AppraiserAbrhs == misSession.userabrhs);
                    var enabled = (isEmpAccess == false) ? "disabled='disabled'" : "";
                    var validationClass = "form-control max-height-txt scroll-max-height-200 appraiser-feedback" + ((isEmpAccess == false) ? "" : " validation-required openPopup");
                    return "<textarea " + enabled + " id ='txtAppraiserAchievementsFeed" + row.UserAchievementId + "' style='width:100%;' placeholder='Enter your comments here...' rows='3' maxlength='4000' class='" + validationClass + "' onkeypress='return blockSpecialChar(event)'>" + row.AppraiserComment + "</textarea>";
                }
            }
        ],

    });
}

function removeControls(item) {
    $(item).closest('.itemRow').remove()
}

// Save Calls
//Tab 1. Appraisal Form Call.
// Update Form Status When Appraise open form First Time
function UpdateFormStatusFormOpen() {
    var JsonObject = {
        empAppraisalSettingId: $("#hdnEmpAppraisalSettingId").val()
    };
    calltoAjax(misApiUrl.changeAppraisalFormStatusToNextLevel, "POST", JsonObject,
        function (result) {
            BindMyAppraisal();
        });
}

//Tab 2. Appraisal Form Call.
function SaveAppraisalForm() {
    var JsonObject = {
        empAppraisalSettingId: $("#hdnEmpAppraisalSettingId").val(),
        ReviewPeriod: $("#hdnEmpAppraisalSettingId").val(),
        ExposerFromDate: $("#txtReviewFrom").val(),
        ExposerToDate: $("#txtReviewTo").val(),
        AppraisalParameter: getAppraisalFormData()
    };
    calltoAjax(misApiUrl.saveEmployeeAppraisalForm, "POST", JsonObject,
        function (result) {
            var data = $.parseJSON(result.Ratings);
            $("#lblAppraiseeRatingWeighted").html(data.SelfOverallRatingWeighted);
            $("#lblAppraiserRatingWeighted").html(data.AppraiserOverallRatingWeighted);
        });
}

function getAppraisalFormData() {
    var i = 0;
    var collection = [];
    var items;

    $('#gridAppraisalTechnicalCompetency tbody tr').each(function (index, item) {
        var $inputs = $(this).find(':input');
        var $tr = $(this);
        var rowiDx = '';
        items = new Object();
        var eACompetencyFormDetailId = 0;
        $inputs.each(function (idx, itm) {
            var id = $(this)[0].id;
            if ($(this)[0].type == 'hidden' && !(id.indexOf('ddlRating') > -1)) {
                rowiDx = $(this).val();
                eACompetencyFormDetailId = $(this).attr("data-attr-CompetencyFormDetailId");
                items.EAParameterDetailId = $(this).attr("data-attr-EAParameterDetailId");
                items.CompetencyFormDetailId = $(this).attr("data-attr-CompetencyFormDetailId");
            }
            if (AppraiseeAbrhs == misSession.userabrhs) {
                if (id == 'txtSelf' + rowiDx) {
                    items.Comment = $("#" + id).val();
                    var rtng = $tr.find('input[name=rdbselfTeRating' + eACompetencyFormDetailId + ']:checked')[0];
                    items.RatingId = (typeof (rtng) !== 'undefined' && rtng.value !== "0") ? rtng.value : null;
                }
            }
            if (AppraiserAbrhs == misSession.userabrhs) {
                if (id == 'txtAppraiserFeed' + rowiDx) {
                    items.Comment = $("#" + id).val();
                    var rtng = $tr.find('input[name=rdbappraiserTeRating' + eACompetencyFormDetailId + ']:checked')[0];
                    items.RatingId = (typeof (rtng) !== 'undefined' && rtng.value !== "0") ? rtng.value : null;
                }
            }
        });
        collection.push(items);
    });

    $('#gridAppraisalBehaviouralCompetency tbody tr').each(function (index, item) {
        var $inputs = $(this).find(':input');
        var $tr = $(this);
        var rowiDx = '';
        items = new Object();
        var eACompetencyFormDetailId = 0;
        $inputs.each(function (idx, itm) {
            var id = $(this)[0].id;
            if ($(this)[0].type == 'hidden' && !(id.indexOf('ddlRating') > -1)) {
                rowiDx = $(this).val();
                eACompetencyFormDetailId = $(this).attr("data-attr-CompetencyFormDetailId");
                items.EAParameterDetailId = $(this).attr("data-attr-EAParameterDetailId");
                items.CompetencyFormDetailId = $(this).attr("data-attr-CompetencyFormDetailId");
            }
            if (AppraiseeAbrhs == misSession.userabrhs) {
                if (id == 'txtSelf' + rowiDx) {
                    items.Comment = $("#" + id).val();
                    var rtng = $tr.find('input[name=rdbselfTeRating' + eACompetencyFormDetailId + ']:checked')[0];
                    items.RatingId = (typeof (rtng) !== 'undefined' && rtng.value !== "0") ? rtng.value : null;
                }
            }
            if (AppraiserAbrhs == misSession.userabrhs) {
                if (id == 'txtAppraiserFeed' + rowiDx) {
                    items.Comment = $("#" + id).val();
                    var rtng = $tr.find('input[name=rdbappraiserTeRating' + eACompetencyFormDetailId + ']:checked')[0];
                    items.RatingId = (typeof (rtng) !== 'undefined' && rtng.value !== "0") ? rtng.value : null;
                }
            }
        });
        collection.push(items);
    });
    return collection;
}

//Tab 3. Save Goals.
function SaveEmployeeGoals() {
    var JsonObject = {
        EmpAppraisalSettingId: $("#hdnEmpAppraisalSettingId").val(),
        DetailList: getGoalsFormData()
    };

    if (goalCheck > 0) {
        calltoAjax(misApiUrl.saveEmployeeAppraisalGoal, "POST", JsonObject,
            function (result) {

            });
    }

}
var goalCheck = 0;
function getGoalsFormData() {
    var i = 0;
    var goalCollection = new Array();
    var goalItems;
    $('#gridAppraisalGoals tbody tr').each(function (index, item) {
        var $inputs = $(this).find(':input');
        var rowiDx = '';
        goalItems = new Object();
        $inputs.each(function (idx, itm) {
            goalCheck = goalCheck + 1;
            var id = $(this)[0].id;
            if ($(this)[0].type == 'hidden') {
                rowiDx = $(this).val();
                goalItems.UserGoalId = $(this).attr("data-attr-UserGoalId");
            }
            if (AppraiseeAbrhs == misSession.userabrhs) {
                if (id == 'txtSelf' + rowiDx) {
                    goalItems.Comment = $("#" + id).val();
                }
            }
            if (AppraiserAbrhs == misSession.userabrhs) {
                if (id == 'txtAppraiserFeed' + rowiDx) {
                    goalItems.Comment = $("#" + id).val();
                }
            }
        });
        goalCollection.push(goalItems);
    });

    return goalCollection;
}

//Tab 4. Save Achievements.
//(i) For Appraisee
function SaveEmployeeAchievementsByAppraisee() {
    var JsonObject = {
        EmpAppraisalSettingId: $("#hdnEmpAppraisalSettingId").val(),
        DetailList: getAchievementsFormData()
    };

    calltoAjax(misApiUrl.saveEmployeeAppraisalAchievementBySelf, "POST", JsonObject,
        function (result) {
            $("#dynamicAddAchievements").html('');
            dynamicReloadId = 0;
            $.each(result, function (key, item) {
                generateControlsForReload('dynamicAddAchievements', 20, 1, item.UserAchievementId, item.Comment)
            });
        });
}

function getAchievementsFormData() {
    var achievementscollection = new Array();
    var items;
    $('.itemRow').each(function () {
        var combinedId = $(this).closest(".itemRow").attr("id");
        if (combinedId) {
            var id = combinedId.split('-')[1];
            items = new Object();
            items.UserAchievementId = $(this).closest(".itemRow").attr("data-attr-UserAchievementId");
            items.Comment = $("#achievements" + id).val();
            achievementscollection.push(items);
        }
    });
    return achievementscollection;
}

//(ii) For Appraiser.
function SaveEmployeeAchievementComments() {
    var JsonObject = {
        EmpAppraisalSettingId: $("#hdnEmpAppraisalSettingId").val(),
        DetailList: getAchievementsCommentsFormData()
    };

    calltoAjax(misApiUrl.saveEmployeeAppraisalAchievement, "POST", JsonObject,
        function (result) {

        });
}

function getAchievementsCommentsFormData() {
    var i = 0;
    var achievementsCollection = new Array();
    var achievementsItems;
    $('#gridAppraisalAchievements tbody tr').each(function (index, item) {
        var $inputs = $(this).find(':input');
        var rowiDx = '';
        achievementsItems = new Object();
        $inputs.each(function (idx, itm) {
            var id = $(this)[0].id;
            if ($(this)[0].type == 'hidden') {
                rowiDx = $(this).val();
                achievementsItems.UserAchievementId = $(this).attr("data-attr-UserAchievementId");
            }
            if (AppraiserAbrhs == misSession.userabrhs) {
                if (id == 'txtAppraiserAchievementsFeed' + rowiDx) {
                    achievementsItems.Comment = $("#" + id).val();
                }
            }
        });
        achievementsCollection.push(achievementsItems);
    });

    return achievementsCollection;
}

//6. Final Submit Call.
function FinalSubmitAppraisalForm() {
    var reply = misConfirm("Are you sure, you want to submit appraisal form?", "Confirm", function (reply) {
        if (reply === true) {
            var JsonObject = {
                EmpAppraisalSettingId: $("#hdnEmpAppraisalSettingId").val()
            };

            calltoAjax(misApiUrl.validateAndSubmitAppraisalForm, "POST", JsonObject,
                function (result) {
                    if (!result.IsValid) {
                        var data = result.MandatoryFieldsList;
                        var html = "<div class='confirm-max200'><table class='table table-bordered' style='font-size: 15px'>";
                        var x = {};
                        for (var i = 0; i < data.length; ++i) {
                            var obj = data[i];
                            if (x[obj.Category] === undefined)
                                x[obj.Category] = [obj.Category];
                            x[obj.Category].push(obj.Field);
                        }
                        $.each(x, function (k, v) {
                            html += "<tr><td style='text-align: left; padding-left: 3px' rowspan = '" + v.length + "'>" + k + "</td></tr>";
                            for (var i = 1; i < v.length; i++) {
                                html += "<tr><td style='text-align: left; padding-left: 3px'>" + v[i] + "</td></tr> "
                            }
                        });
                        html += "</table></div>";
                        misAlert(html, "Following fields are missing", "warning");

                    }
                    else {
                        if (result.IsSubmitted) {
                            hasModifyRight = false;
                            BindMyAppraisal();
                            $("#selfAppraisalFormPopup").modal("hide");
                            $("#btnSaveAsDraft").addClass("hidden");
                            misAlert("You have successfully submited your appraisal.", "Success", "success");
                        }
                        else {
                            misAlert('Your request cannot be processed, please try after some time or contact to MIS team for further assistance.', 'Error', 'error');
                        }

                    }
                });
        }
    });
}

/***************************Auto save***************************/
//auto save employee appraisal form
function addUpdateEmployeeAppraisalFormAsync() {
    //console.log('Appraisal form auto saved');
    var JsonObject = {
        empAppraisalSettingId: $("#hdnEmpAppraisalSettingId").val(),
        ReviewPeriod: $("#hdnEmpAppraisalSettingId").val(),
        ExposerFromDate: $("#txtReviewFrom").val(),
        ExposerToDate: $("#txtReviewTo").val(),
        AppraisalParameter: getAppraisalFormData()
    };
    calltoAjaxWithoutLoader(misApiUrl.saveEmployeeAppraisalFormAsync, "POST", JsonObject,
        function (result) {
            var data = $.parseJSON(result.Ratings);
            $("#lblAppraiseeRatingWeighted").html(data.SelfOverallRatingWeighted);
            $("#lblAppraiserRatingWeighted").html(data.AppraiserOverallRatingWeighted);

            $("#lblAppraiseeNormalRating").html(data.SelfOverallRatingNormal);
            $("#lblAppraiserNormalRating").html(data.AppraiserOverallRatingNormal);
        });
}

//auto save employee appraisal goal
function addUpdateEmployeeAppraisalGoalAsync() {
    console.log('Appraisal goals auto saved');
    var JsonObject = {
        EmpAppraisalSettingId: $("#hdnEmpAppraisalSettingId").val(),
        DetailList: getGoalsFormData()
    };

    if (goalCheck > 0) {
        calltoAjaxWithoutLoader(misApiUrl.saveEmployeeAppraisalGoalAsync, "POST", JsonObject,
            function (result) { });
    }
}

//auto save employee appraisal achievement self
function saveEmployeeAppraisalAchievementBySelfAsync() {
    //console.log('Achievements auto saved for user');
    //var JsonObject = {
    //    EmpAppraisalSettingId: $("#hdnEmpAppraisalSettingId").val(),
    //    DetailList: getAchievementsFormData()
    //};

    //calltoAjaxWithoutLoader(misApiUrl.saveEmployeeAppraisalAchievementBySelfAsync, "POST", JsonObject,
    //    function (result) { });
}
/***************************************************************/