var AppraiserAbrhs = '';
var ApproverAbrhs = '';
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

    $("#divAppraiserPromotionsControls").hide();
    $("#divApproverPromotionsControls").hide();
    $("#divAppraiserHPControls").hide();
    $("#divApproverHPControls").hide();

    $("#btnSaveAsDraft").unbind().click(function () {
        var tabid = $(".idealsteps-step-active").attr('id');
        if (AppraisalStatusId >= 4 || AppraisalStatusId <= 5) {
            if (tabid == 'Tab1') {
                navigateToTab(2);
            }

            if (tabid == 'Tab2') {
                if ((AppraiserAbrhs == misSession.userabrhs && AppraisalStatusId == 4) || (ApproverAbrhs == misSession.userabrhs && AppraisalStatusId == 5)) {
                    SaveAppraisalForm();
                }
                navigateToTab(3);
            }
            if (tabid == 'Tab3') {
                if ((AppraiserAbrhs == misSession.userabrhs && AppraisalStatusId == 4) || (ApproverAbrhs == misSession.userabrhs && AppraisalStatusId == 5)) {
                    SaveEmployeeGoals();
                }
                navigateToTab(4);
            }
            if (tabid == 'Tab4') {
                if ((AppraiserAbrhs == misSession.userabrhs && AppraisalStatusId == 4) || (ApproverAbrhs == misSession.userabrhs && AppraisalStatusId == 5)) {
                    SaveEmployeeAchievementComments();
                }
                navigateToTab(5);
            }
            if (tabid == 'Tab5') {
                if ((AppraiserAbrhs == misSession.userabrhs && AppraisalStatusId == 4) || (ApproverAbrhs == misSession.userabrhs && AppraisalStatusId == 5)) {
                    $("#btnSaveAsDraft").html("<i class='fa fa-save'></i>&nbsp;Final Submit");
                    SaveEmployeePromotions();
                }
                navigateToTab(6);
            }
            if (tabid == 'Tab6') {
                if ((AppraiserAbrhs == misSession.userabrhs && AppraisalStatusId == 4) || (ApproverAbrhs == misSession.userabrhs && AppraisalStatusId == 5)) {
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
                navigateToTab(6);
            }
            if (tabid == 'Tab6') {
                navigateToTab(1);
            }
        }
    });

    $("#Tab1").click(function () {
        if ((AppraiserAbrhs == misSession.userabrhs && AppraisalStatusId == 4) || (ApproverAbrhs == misSession.userabrhs && AppraisalStatusId == 5)) {
            $("#btnSaveAsDraft").html("<i class='fa fa-save'></i>&nbsp;Save &amp; Continue");
            saveOnTabChange(_oldTabId);
        }
    });

    $("#Tab2").click(function () {
        if ((AppraiserAbrhs == misSession.userabrhs && AppraisalStatusId == 4) || (ApproverAbrhs == misSession.userabrhs && AppraisalStatusId == 5)) {
            $("#btnSaveAsDraft").html("<i class='fa fa-save'></i>&nbsp;Save &amp; Continue");
            saveOnTabChange(_oldTabId);
        }
    });

    $("#Tab3").click(function () {
        if ((AppraiserAbrhs == misSession.userabrhs && AppraisalStatusId == 4) || (ApproverAbrhs == misSession.userabrhs && AppraisalStatusId == 5)) {
            $("#btnSaveAsDraft").html("<i class='fa fa-save'></i>&nbsp;Save &amp; Continue");
            saveOnTabChange(_oldTabId);
        }
    });

    $("#Tab4").click(function () {
        if ((AppraiserAbrhs == misSession.userabrhs && AppraisalStatusId == 4) || (ApproverAbrhs == misSession.userabrhs && AppraisalStatusId == 5)) {
            $("#btnSaveAsDraft").html("<i class='fa fa-save'></i>&nbsp;Save &amp; Continue");
            saveOnTabChange(_oldTabId);
        }
    });

    $("#Tab5").click(function () {
        if ((AppraiserAbrhs == misSession.userabrhs && AppraisalStatusId == 4) || (ApproverAbrhs == misSession.userabrhs && AppraisalStatusId == 5)) {
            $("#btnSaveAsDraft").html("<i class='fa fa-save'></i>&nbsp;Save &amp; Continue");
            saveOnTabChange(_oldTabId);
        }
    });

    $("#Tab6").click(function () {
        if ((AppraiserAbrhs == misSession.userabrhs && AppraisalStatusId == 4) || (ApproverAbrhs == misSession.userabrhs && AppraisalStatusId == 5)) {
            $("#btnSaveAsDraft").html("<i class='fa fa-save'></i>&nbsp;Final Submit");
            saveOnTabChange(_oldTabId);
        }
    });

    //start auto save/update for every 60 sec (60000 milli second)
    window.setInterval(function () {
        startAutoSave();
    }, 60000);

    bindApraisalForm();

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

    // Refer Back.
    $("#btnReferBack").click(function () {
        $("#AppraisalFormReferBackPopup").modal("show");
    });

    $("#btnSaveReferBack").click(function () {
        if (!validateControls('referBackBody')) {
            return false;
        }
        var reply = misConfirm("Are you sure you want to refer back the appraisal form?", "Confirm", function (reply) {
            if (reply === true) {
                var JsonObject = {
                    empAppraisalSettingId: $("#hdnEmpAppraisalSettingId").val(),
                    comments: $("#txtReferBackRemark").val()
                };

                calltoAjax(misApiUrl.referBackAppraisalForm, "POST", JsonObject,
                    function (result) {
                        if (result == 1) {
                            hasModifyRight = false;
                            BindTeamAppraisal();
                            $("#AppraisalFormReferBackPopup").modal("hide");
                            $("#teamAppraisalFormPopup").modal("hide");
                            misAlert("You have successfully refered back appraisal form.", "Success", "success");
                        }
                    });
            }
        });
    });

    // Technical Competency Self Comments Copy by Appraiser
    $(document).on('change', '#ckbTechnicalSelfCommentsCopy', function (e) {
        var isChecked = $("#ckbTechnicalSelfCommentsCopy").is(':checked');
        if (isChecked == true) {
            misConfirm("Are you sure you want to copy the data?", "Confirm", function (isConfirmed) {
                if (isConfirmed) {
                    $('#gridAppraisalTechnicalCompetency tbody tr').each(function (index, item) {
                        var $inputs = $(this).find(':input');
                        var $tr = $(this);
                        var rowiDx = '';
                        var items = {};
                        var eACompetencyFormDetailId = 0;
                        $inputs.each(function (idx, itm) {
                            var id = $(this)[0].id;
                            if ($(this)[0].type == 'hidden' && !(id.indexOf('ddlRating') > -1)) {
                                rowiDx = $(this).val();
                                eACompetencyFormDetailId = $(this).attr("data-attr-CompetencyFormDetailId");
                                items.EAParameterDetailId = $(this).attr("data-attr-EAParameterDetailId");
                                items.CompetencyFormDetailId = $(this).attr("data-attr-CompetencyFormDetailId");
                            }
                            if (AppraiserAbrhs == misSession.userabrhs && AppraisalStatusId == 4) {
                                if (id == 'txtAppraiserFeed' + rowiDx) {
                                    $("#" + id).val($("#txtSelf" + rowiDx).val());
                                    var rtng = $tr.find('input[name=rdbselfTeRating' + eACompetencyFormDetailId + ']:checked')[0];
                                    var ratingId = (typeof (rtng) !== 'undefined' && rtng.value !== "0") ? rtng.value : null;
                                    $("input[name=rdbappraiserTeRating" + eACompetencyFormDetailId + "][value=" + ratingId + "]").prop('checked', true);
                                    $("#appraiserTeRating" + eACompetencyFormDetailId + " .rating-button").removeClass('active');
                                    $("input[name=rdbappraiserTeRating" + eACompetencyFormDetailId + "][value=" + ratingId + "]").parent().addClass('active');
                                }
                            }
                        });
                    });
                }
                else {
                    $("#ckbTechnicalSelfCommentsCopy").prop('checked', false);
                    return false;
                }
            }, false, false, true);
        }
        else {
            misConfirm("Are you sure you want to clear the data?", "Confirm", function (isConfirmed) {
                if (isConfirmed) {
                    $('#gridAppraisalTechnicalCompetency tbody tr').each(function (index, item) {
                        var $inputs = $(this).find(':input');
                        var $tr = $(this);
                        var rowiDx = '';
                        var items = {};
                        var eACompetencyFormDetailId = 0;
                        $inputs.each(function (idx, itm) {
                            var id = $(this)[0].id;
                            if ($(this)[0].type == 'hidden' && !(id.indexOf('ddlRating') > -1)) {
                                rowiDx = $(this).val();
                                eACompetencyFormDetailId = $(this).attr("data-attr-CompetencyFormDetailId");
                                items.EAParameterDetailId = $(this).attr("data-attr-EAParameterDetailId");
                                items.CompetencyFormDetailId = $(this).attr("data-attr-CompetencyFormDetailId");
                            }
                            if (AppraiserAbrhs == misSession.userabrhs && AppraisalStatusId == 4) {
                                if (id == 'txtAppraiserFeed' + rowiDx) {
                                    $("#" + id).val('');
                                    var rtng = $tr.find('input[name=rdbselfTeRating' + eACompetencyFormDetailId + ']:checked')[0];
                                    var ratingId = (typeof (rtng) !== 'undefined' && rtng.value !== "0") ? rtng.value : null;
                                    $("input[name=rdbappraiserTeRating" + eACompetencyFormDetailId + "][value=" + ratingId + "]").prop('checked', false);
                                    $("#appraiserTeRating" + eACompetencyFormDetailId + " .rating-button").removeClass('active');
                                    //$("input[name=rdbappraiserTeRating" + eACompetencyFormDetailId + "][value=" + ratingId + "]").parent().addClass('active');
                                }
                            }
                        });
                    });
                }
                else {
                    $("#ckbTechnicalSelfCommentsCopy").prop('checked', true);
                    return false;
                }
            }, false, false, true);
        }
    });

    // Technical Competency Appraiser Comments Copy by Approver
    $(document).on('change', '#ckbTechnicalAppraiserCommentsCopy', function () {
        var isChecked = $("#ckbTechnicalAppraiserCommentsCopy").is(':checked');
        if (isChecked == true) {
            misConfirm("Are you sure you want to copy the data?", "Confirm", function (isConfirmed) {
                if (isConfirmed) {
                    $('#gridAppraisalTechnicalCompetency tbody tr').each(function (index, item) {
                        var $inputs = $(this).find(':input');
                        var $tr = $(this);
                        var rowiDx = '';
                        var items = {};
                        var eACompetencyFormDetailId = 0;
                        $inputs.each(function (idx, itm) {
                            var id = $(this)[0].id;
                            if ($(this)[0].type == 'hidden' && !(id.indexOf('ddlRating') > -1)) {
                                rowiDx = $(this).val();
                                eACompetencyFormDetailId = $(this).attr("data-attr-CompetencyFormDetailId");
                                items.EAParameterDetailId = $(this).attr("data-attr-EAParameterDetailId");
                                items.CompetencyFormDetailId = $(this).attr("data-attr-CompetencyFormDetailId");
                            }
                            if (ApproverAbrhs == misSession.userabrhs && AppraisalStatusId == 5) {
                                if (id == 'txtApproverFeed' + rowiDx) {
                                    $("#" + id).val($("#txtAppraiserFeed" + rowiDx).val());
                                    var rtng = $tr.find('input[name=rdbappraiserTeRating' + eACompetencyFormDetailId + ']:checked')[0];
                                    var ratingId = (typeof (rtng) !== 'undefined' && rtng.value !== "0") ? rtng.value : null;
                                    $("input[name=rdbapproverTeRating" + eACompetencyFormDetailId + "][value=" + ratingId + "]").prop('checked', true);
                                    $("#approverTeRating" + eACompetencyFormDetailId + " .rating-button").removeClass('active');
                                    $("input[name=rdbapproverTeRating" + eACompetencyFormDetailId + "][value=" + ratingId + "]").parent().addClass('active');
                                }
                            }
                        });
                    });
                }
                else {
                    $("#ckbTechnicalAppraiserCommentsCopy").prop('checked', false);
                    return false;
                }
            }, false, false, true);
        }
        else {
            misConfirm("Are you sure you want to clear the data?", "Confirm", function (isConfirmed) {
                if (isConfirmed) {
                    $('#gridAppraisalTechnicalCompetency tbody tr').each(function (index, item) {
                        var $inputs = $(this).find(':input');
                        var $tr = $(this);
                        var rowiDx = '';
                        var items = {};
                        var eACompetencyFormDetailId = 0;
                        $inputs.each(function (idx, itm) {
                            var id = $(this)[0].id;
                            if ($(this)[0].type == 'hidden' && !(id.indexOf('ddlRating') > -1)) {
                                rowiDx = $(this).val();
                                eACompetencyFormDetailId = $(this).attr("data-attr-CompetencyFormDetailId");
                                items.EAParameterDetailId = $(this).attr("data-attr-EAParameterDetailId");
                                items.CompetencyFormDetailId = $(this).attr("data-attr-CompetencyFormDetailId");
                            }
                            if (ApproverAbrhs == misSession.userabrhs && AppraisalStatusId == 5) {
                                if (id == 'txtApproverFeed' + rowiDx) {
                                    $("#" + id).val("");
                                    var rtng = $tr.find('input[name=rdbappraiserTeRating' + eACompetencyFormDetailId + ']:checked')[0];
                                    var ratingId = (typeof (rtng) !== 'undefined' && rtng.value !== "0") ? rtng.value : null;
                                    $("input[name=rdbapproverTeRating" + eACompetencyFormDetailId + "][value=" + ratingId + "]").prop('checked', false);
                                    $("#approverTeRating" + eACompetencyFormDetailId + " .rating-button").removeClass('active');
                                    //$("input[name=rdbapproverTeRating" + eACompetencyFormDetailId + "][value=" + ratingId + "]").parent().addClass('active');
                                }
                            }
                        });
                    });
                }
                else {
                    $("#ckbTechnicalAppraiserCommentsCopy").prop('checked', true);
                    return false;
                }
            }, false, false, true);
        }
    });

    // Behavioural Competency Self Comments Copy by Appraiser
    $(document).on('change', '#ckbBehaviouralSelfCommentsCopy', function () {
        var isChecked = $("#ckbBehaviouralSelfCommentsCopy").is(':checked');
        if (isChecked == true) {
            misConfirm("Are you sure you want to copy data?", "Confirm", function (isConfirmed) {
                if (isConfirmed) {
                    $('#gridAppraisalBehaviouralCompetency tbody tr').each(function (index, item) {
                        var $inputs = $(this).find(':input');
                        var $tr = $(this);
                        var rowiDx = '';
                        var items = {};
                        var eACompetencyFormDetailId = 0;
                        $inputs.each(function (idx, itm) {
                            var id = $(this)[0].id;
                            if ($(this)[0].type == 'hidden' && !(id.indexOf('ddlRating') > -1)) {
                                rowiDx = $(this).val();
                                eACompetencyFormDetailId = $(this).attr("data-attr-CompetencyFormDetailId");
                                items.EAParameterDetailId = $(this).attr("data-attr-EAParameterDetailId");
                                items.CompetencyFormDetailId = $(this).attr("data-attr-CompetencyFormDetailId");
                            }
                            if (AppraiserAbrhs == misSession.userabrhs && AppraisalStatusId == 4) {
                                if (id == 'txtAppraiserFeed' + rowiDx) {
                                    $("#" + id).val($("#txtSelf" + rowiDx).val());
                                    var rtng = $tr.find('input[name=rdbselfTeRating' + eACompetencyFormDetailId + ']:checked')[0];
                                    var ratingId = (typeof (rtng) !== 'undefined' && rtng.value !== "0") ? rtng.value : null;
                                    $("input[name=rdbappraiserTeRating" + eACompetencyFormDetailId + "][value=" + ratingId + "]").prop('checked', true);
                                    $("#appraiserTeRating" + eACompetencyFormDetailId + " .rating-button").removeClass('active');
                                    $("input[name=rdbappraiserTeRating" + eACompetencyFormDetailId + "][value=" + ratingId + "]").parent().addClass('active');
                                }
                            }
                        });
                    });
                }
                else {
                    $("#ckbBehaviouralSelfCommentsCopy").prop('checked', false);
                    return false;
                }
            }, false, false, true);
        }
        else {
            misConfirm("Are you sure you want to clear the data?", "Confirm", function (isConfirmed) {
                if (isConfirmed) {
                    $('#gridAppraisalBehaviouralCompetency tbody tr').each(function (index, item) {
                        var $inputs = $(this).find(':input');
                        var $tr = $(this);
                        var rowiDx = '';
                        var items = {};
                        var eACompetencyFormDetailId = 0;
                        $inputs.each(function (idx, itm) {
                            var id = $(this)[0].id;
                            if ($(this)[0].type == 'hidden' && !(id.indexOf('ddlRating') > -1)) {
                                rowiDx = $(this).val();
                                eACompetencyFormDetailId = $(this).attr("data-attr-CompetencyFormDetailId");
                                items.EAParameterDetailId = $(this).attr("data-attr-EAParameterDetailId");
                                items.CompetencyFormDetailId = $(this).attr("data-attr-CompetencyFormDetailId");
                            }
                            if (AppraiserAbrhs == misSession.userabrhs && AppraisalStatusId == 4) {
                                if (id == 'txtAppraiserFeed' + rowiDx) {
                                    $("#" + id).val('');
                                    var rtng = $tr.find('input[name=rdbselfTeRating' + eACompetencyFormDetailId + ']:checked')[0];
                                    var ratingId = (typeof (rtng) !== 'undefined' && rtng.value !== "0") ? rtng.value : null;
                                    $("input[name=rdbappraiserTeRating" + eACompetencyFormDetailId + "][value=" + ratingId + "]").prop('checked', false);
                                    $("#appraiserTeRating" + eACompetencyFormDetailId + " .rating-button").removeClass('active');
                                    //$("input[name=rdbappraiserTeRating" + eACompetencyFormDetailId + "][value=" + ratingId + "]").parent().addClass('active');
                                }
                            }
                        });
                    });
                }
                else {
                    $("#ckbBehaviouralSelfCommentsCopy").prop('checked', true);
                    return false;
                }
            }, false, false, true);
        }
    });

    // Behavioural Competency Appraiser Comments Copy by Approver
    $(document).on('change', '#ckbBehaviouralAppraiserCommentsCopy', function () {
        var isChecked = $("#ckbBehaviouralAppraiserCommentsCopy").is(':checked');
        if (isChecked == true) {
            misConfirm("Are you sure you want to copy data?", "Confirm", function (isConfirmed) {
                if (isConfirmed) {
                    $('#gridAppraisalBehaviouralCompetency tbody tr').each(function (index, item) {
                        var $inputs = $(this).find(':input');
                        var $tr = $(this);
                        var rowiDx = '';
                        var items = {};
                        var eACompetencyFormDetailId = 0;
                        $inputs.each(function (idx, itm) {
                            var id = $(this)[0].id;
                            if ($(this)[0].type == 'hidden' && !(id.indexOf('ddlRating') > -1)) {
                                rowiDx = $(this).val();
                                eACompetencyFormDetailId = $(this).attr("data-attr-CompetencyFormDetailId");
                                items.EAParameterDetailId = $(this).attr("data-attr-EAParameterDetailId");
                                items.CompetencyFormDetailId = $(this).attr("data-attr-CompetencyFormDetailId");
                            }
                            if (ApproverAbrhs == misSession.userabrhs && AppraisalStatusId == 5) {
                                if (id == 'txtApproverFeed' + rowiDx) {
                                    $("#" + id).val($("#txtAppraiserFeed" + rowiDx).val());
                                    var rtng = $tr.find('input[name=rdbappraiserTeRating' + eACompetencyFormDetailId + ']:checked')[0];
                                    var ratingId = (typeof (rtng) !== 'undefined' && rtng.value !== "0") ? rtng.value : null;
                                    $("input[name=rdbapproverTeRating" + eACompetencyFormDetailId + "][value=" + ratingId + "]").prop('checked', true);
                                    $("#approverTeRating" + eACompetencyFormDetailId + " .rating-button").removeClass('active');
                                    $("input[name=rdbapproverTeRating" + eACompetencyFormDetailId + "][value=" + ratingId + "]").parent().addClass('active');
                                }
                            }
                        });
                    });
                }
                else {
                    $("#ckbBehaviouralAppraiserCommentsCopy").prop('checked', false);
                    return false;
                }
            }, false, false, true);
        }
        else {
            misConfirm("Are you sure you want to clear the data?", "Confirm", function (isConfirmed) {
                if (isConfirmed) {
                    $('#gridAppraisalBehaviouralCompetency tbody tr').each(function (index, item) {
                        var $inputs = $(this).find(':input');
                        var $tr = $(this);
                        var rowiDx = '';
                        var items = {};
                        var eACompetencyFormDetailId = 0;
                        $inputs.each(function (idx, itm) {
                            var id = $(this)[0].id;
                            if ($(this)[0].type == 'hidden' && !(id.indexOf('ddlRating') > -1)) {
                                rowiDx = $(this).val();
                                eACompetencyFormDetailId = $(this).attr("data-attr-CompetencyFormDetailId");
                                items.EAParameterDetailId = $(this).attr("data-attr-EAParameterDetailId");
                                items.CompetencyFormDetailId = $(this).attr("data-attr-CompetencyFormDetailId");
                            }
                            if (ApproverAbrhs == misSession.userabrhs && AppraisalStatusId == 5) {
                                if (id == 'txtApproverFeed' + rowiDx) {
                                    $("#" + id).val('');
                                    var rtng = $tr.find('input[name=rdbappraiserTeRating' + eACompetencyFormDetailId + ']:checked')[0];
                                    var ratingId = (typeof (rtng) !== 'undefined' && rtng.value !== "0") ? rtng.value : null;
                                    $("input[name=rdbapproverTeRating" + eACompetencyFormDetailId + "][value=" + ratingId + "]").prop('checked', false);
                                    $("#approverTeRating" + eACompetencyFormDetailId + " .rating-button").removeClass('active');
                                    //$("input[name=rdbapproverTeRating" + eACompetencyFormDetailId + "][value=" + ratingId + "]").parent().addClass('active');
                                }
                            }
                        });
                    });
                }
                else {
                    $("#ckbBehaviouralAppraiserCommentsCopy").prop('checked', true);
                    return false;
                }
            }, false, false, true);
        }
    });

    // Goal Self Comments Copy by Appraiser
    $(document).on('change', '#ckbGoalSelfCommentsCopy', function () {
        var isChecked = $("#ckbGoalSelfCommentsCopy").is(':checked');
        if (isChecked == true) {
            misConfirm("Are you sure you want to copy data?", "Confirm", function (isConfirmed) {
                if (isConfirmed) {
                    $('#gridAppraisalGoals tbody tr').each(function (index, item) {
                        var $inputs = $(this).find(':input');
                        var rowiDx = '';
                        goalItems = new Object();
                        $inputs.each(function (idx, itm) {
                            var id = $(this)[0].id;
                            if ($(this)[0].type == 'hidden') {
                                rowiDx = $(this).val();
                                goalItems.UserGoalId = $(this).attr("data-attr-UserGoalId");
                            }
                            if (AppraiserAbrhs == misSession.userabrhs && AppraisalStatusId == 4) {
                                if (id == 'txtAppraiserFeed' + rowiDx) {
                                    $("#" + id).val($('#txtSelf' + rowiDx).val());
                                }
                            }
                        });
                    });
                }
                else {
                    $("#ckbGoalSelfCommentsCopy").prop('checked', false);
                    return false;
                }
            }, false, false, true);
        }
        else {
            misConfirm("Are you sure you want to clear the data?", "Confirm", function (isConfirmed) {
                if (isConfirmed) {
                    $('#gridAppraisalGoals tbody tr').each(function (index, item) {
                        var $inputs = $(this).find(':input');
                        var rowiDx = '';
                        goalItems = new Object();
                        $inputs.each(function (idx, itm) {
                            var id = $(this)[0].id;
                            if ($(this)[0].type == 'hidden') {
                                rowiDx = $(this).val();
                                goalItems.UserGoalId = $(this).attr("data-attr-UserGoalId");
                            }
                            if (AppraiserAbrhs == misSession.userabrhs && AppraisalStatusId == 4) {
                                if (id == 'txtAppraiserFeed' + rowiDx) {
                                    $("#" + id).val('');
                                }
                            }
                        });
                    });
                }
                else {
                    $("#ckbGoalSelfCommentsCopy").prop('checked', true);
                    return false;
                }
            }, false, false, true);
        }
    });

    // Goal Appraiser Comments Copy by Approver
    $(document).on('change', '#ckbGoalAppraiserCommentsCopy', function () {
        var isChecked = $("#ckbGoalAppraiserCommentsCopy").is(':checked');
        if (isChecked == true) {
            misConfirm("Are you sure you want to copy data?", "Confirm", function (isConfirmed) {
                if (isConfirmed) {
                    $('#gridAppraisalGoals tbody tr').each(function (index, item) {
                        var $inputs = $(this).find(':input');
                        var rowiDx = '';
                        goalItems = new Object();
                        $inputs.each(function (idx, itm) {
                            var id = $(this)[0].id;
                            if ($(this)[0].type == 'hidden') {
                                rowiDx = $(this).val();
                                goalItems.UserGoalId = $(this).attr("data-attr-UserGoalId");
                            }
                            if (ApproverAbrhs == misSession.userabrhs && AppraisalStatusId == 5) {
                                if (id == 'txtApproverFeed' + rowiDx) {
                                    $("#" + id).val($('#txtAppraiserFeed' + rowiDx).val());
                                }
                            }
                        });
                    });
                }
                else {
                    $("#ckbGoalAppraiserCommentsCopy").prop('checked', false);
                    return false;
                }
            }, false, false, true);
        }
        else {
            misConfirm("Are you sure you want to clear the data?", "Confirm", function (isConfirmed) {
                if (isConfirmed) {
                    $('#gridAppraisalGoals tbody tr').each(function (index, item) {
                        var $inputs = $(this).find(':input');
                        var rowiDx = '';
                        goalItems = new Object();
                        $inputs.each(function (idx, itm) {
                            var id = $(this)[0].id;
                            if ($(this)[0].type == 'hidden') {
                                rowiDx = $(this).val();
                                goalItems.UserGoalId = $(this).attr("data-attr-UserGoalId");
                            }
                            if (ApproverAbrhs == misSession.userabrhs && AppraisalStatusId == 5) {
                                if (id == 'txtApproverFeed' + rowiDx) {
                                    $("#" + id).val('');
                                }
                            }
                        });
                    });
                }
                else {
                    $("#ckbGoalAppraiserCommentsCopy").prop('checked', true);
                    return false;
                }
            }, false, false, true);
        }
    });

    // Achievements Appraiser Comments Copy by Approver
    $(document).on('change', '#ckbAchievementsAppraiserCommentsCopy', function () {
        var isChecked = $("#ckbAchievementsAppraiserCommentsCopy").is(':checked');
        if (isChecked == true) {
            misConfirm("Are you sure you want to copy data?", "Confirm", function (isConfirmed) {
                if (isConfirmed) {
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
                            if (ApproverAbrhs == misSession.userabrhs && AppraisalStatusId == 5) {
                                if (id == 'txtApproverAchievementsFeed' + rowiDx) {
                                    $("#" + id).val($('#txtAppraiserAchievementsFeed' + rowiDx).val());
                                }
                            }
                        });
                    });
                }
                else {
                    $("#ckbAchievementsAppraiserCommentsCopy").prop('checked', false);
                    return false;
                }
            }, false, false, true);
        }
        else {
            misConfirm("Are you sure you want to clear the data?", "Confirm", function (isConfirmed) {
                if (isConfirmed) {
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
                            if (ApproverAbrhs == misSession.userabrhs && AppraisalStatusId == 5) {
                                if (id == 'txtApproverAchievementsFeed' + rowiDx) {
                                    $("#" + id).val('');
                                }
                            }
                        });
                    });
                }
                else {
                    $("#ckbAchievementsAppraiserCommentsCopy").prop('checked', true);
                    return false;
                }
            }, false, false, true);
        }
    });

    $("#btnCloseAppraisalForm").click(function () {
        hasModifyRight = false;
        $("#teamAppraisalFormPopup").modal("hide");
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
            case "Tab4":
                saveEmployeeAchievementCommentsAsync();
                break;
            case "Tab5":
                addUpdateEmployeeAppraisalPromotionAsync();
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
                saveEmployeeAchievementCommentsAsync();
                break;
            case "Tab5":
                addUpdateEmployeeAppraisalPromotionAsync();
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
            ApproverAbrhs = result.ApproverAbrhs;
            AppraiseeAbrhs = result.AppraiseeAbrhs;
            hasModifyRight = result.IsModifyRight;

            //Rating Div
            if ((AppraiserAbrhs == misSession.userabrhs && AppraisalStatusId > 3) || (ApproverAbrhs == misSession.userabrhs && AppraisalStatusId > 4)) {
                $("#divRating").append('<div style="display: inline-block;padding-left: 25px;"><div class="sign-avatar rattingcircle" style="background:#3ade03;" id="lblAppraiseeRatingWeighted"></div>Appraisee Rating</div>');
                $("#divRating").append('<div style="display: inline-block;padding-left: 25px;"><div class="sign-avatar rattingcircle" style="background: #34af0b;" id="lblAppraiserRatingWeighted"></div>Appraiser Rating</div>');
                $("#divRating").append('<div style="display: inline-block;padding-left: 25px;"><div class="sign-avatar rattingcircle" style="background: #257909;" id="lblApproverRatingWeighted"></div>Approver Rating</div>');

                $("#divNormalRating").append('<div style="display: inline-block;padding-left: 25px;"><div class="sign-avatar rattingcircle" style="background:#3ade03;" id="lblAppraiseeRatingNormal"></div>Appraisee Rating</div>');
                $("#divNormalRating").append('<div style="display: inline-block;padding-left: 25px;"><div class="sign-avatar rattingcircle" style="background: #34af0b;" id="lblAppraiserRatingNormal"></div>Appraiser Rating</div>');
                $("#divNormalRating").append('<div style="display: inline-block;padding-left: 25px;"><div class="sign-avatar rattingcircle" style="background: #257909;" id="lblApproverRatingNormal"></div>Approver Rating</div>');
            }

            $("#lblAppraiseeRatingWeighted").html(result.SelfOverallRatingWeighted);
            $("#lblAppraiserRatingWeighted").html(result.AppraiserOverallRatingWeighted);
            $("#lblApproverRatingWeighted").html(result.ApproverOverallRatingWeighted);

            $("#lblAppraiseeRatingNormal").html(result.SelfOverallRatingNormal);
            $("#lblAppraiserRatingNormal").html(result.AppraiserOverallRatingNormal);
            $("#lblApproverRatingNormal").html(result.ApproverOverallRatingNormal);

            //Change Save and Next Button Text.
            if (AppraiserAbrhs == misSession.userabrhs && AppraisalStatusId === 4) {
                $("#btnSaveAsDraft").html("<i class='fa fa-save'></i>&nbsp;Save &amp; Continue");
                $("#btnReferBack").css("display", "block");
            }

            else if (ApproverAbrhs == misSession.userabrhs && AppraisalStatusId == 5) {
                $("#btnSaveAsDraft").html("<i class='fa fa-save'></i>&nbsp;Save &amp; Continue");
                $("#btnReferBack").css("display", "block");
            }
            else {
                $("#btnSaveAsDraft").html("Next&nbsp;<i class='fa fa-arrow-circle-o-right'></i>");
                $("#btnReferBack").hide();
            }

            if (AppraisalStatusId > 5) {
                $("#btnSaveAsDraft").html("Next&nbsp;<i class='fa fa-arrow-circle-o-right'></i>");
            }
            $("#btnSaveAsDraft").removeClass("hidden");

            $("#txtReviewFrom").val(result.ReviewFrom);
            $("#txtReviewTo").val(result.ReviewTo);

            if (result.AppraisalStatusId >= 4) {
                bindAppraisalAchievements(result);
                // For Promotions enable/disable Divs.
                if (result.IsModifyRight == false && result.AppraisalStatusId >= 5 && (result.ApproverAbrhs == misSession.userabrhs || result.AppraiserAbrhs == misSession.userabrhs)) {
                    $("#appraiserPromotionsDiv").find("input,button,textarea,select").attr("disabled", "disabled");
                    $("#appraiserHPDiv").find("input,button,textarea,select").attr("disabled", "disabled");
                    if ((result.AppraiserRecommendedForDesignationId != null && result.AppraiserRecommendedForDesignationId > 0) || (result.AppraiserRecommendationComment != '' && result.AppraiserRecommendationComment != null) || (result.AppraiserRecommendedPercentage > 0)) {
                        bindPromotionsDesignation(result.AppraiserRecommendedForDesignationId || 0, result.Approver1RecommendedForDesignationId || 0);
                        $("#ckbRecommendedDesignationAprs").attr('checked', 'checked');
                        $("#ddlRecDesigAppraiser").val(result.AppraiserRecommendedForDesignationId);
                        $("#txtAppraiserRemarks").val(result.AppraiserRecommendationComment);
                        $("#txtAppraiserPercRecommendation").val(result.AppraiserRecommendedPercentage);
                        showHidePromotionsControls(1);
                    }
                    if (result.AppraiserMarkedHighPotential) {
                        $("#ckbHPAprs").attr('checked', 'checked');
                        $("#txtAppraiserRemarksHP").val(result.AppraiserHighPotentialComment);
                        showHidePromotionsControls(3);
                    }
                    if ((result.Approver1RecommendedForDesignationId != null && result.Approver1RecommendedForDesignationId > 0) || (result.Approver1RecommendationComment != '' && result.Approver1RecommendationComment != null) || (result.Approver1RecommendedPercentage > 0)) {
                        $("#ApproverPromotionsDivInner").show();
                        $("#ckbRecommendedDesignationAprv").attr('checked', 'checked');
                        $("#ddlRecDesigApprover").val(result.Approver1RecommendedForDesignationId);
                        $("#txtApproverRemarks").val(result.Approver1RecommendationComment);
                        $("#txtApproverPercRecommendation").val(result.Approver1RecommendedPercentage);
                        showHidePromotionsControls(2);
                    }
                    if (result.Approver1MarkedHighPotential) {
                        $("#approverHPDivInner").show();
                        $("#ckbHPAprv").attr('checked', 'checked');
                        $("#txtApproverRemarksHP").val(result.Approver1HighPotentialComment);
                        showHidePromotionsControls(4);
                    }

                    $("#ApproverPromotionsDiv").find("input,button,textarea,select").attr("disabled", "disabled");
                    $("#approverHPDiv").find("input,button,textarea,select").attr("disabled", "disabled");
                    if ((result.AppraiserRecommendedForDesignationId != null && result.AppraiserRecommendedForDesignationId > 0) || (result.AppraiserRecommendationComment != '' && result.AppraiserRecommendationComment != null) || (result.AppraiserRecommendedPercentage > 0)) {
                        $("#ApproverPromotionsDivInner").hide();
                        bindPromotionsDesignation(result.AppraiserRecommendedForDesignationId || 0, result.Approver1RecommendedForDesignationId || 0);
                        $("#ckbRecommendedDesignationAprs").attr('checked', 'checked');
                        $("#ddlRecDesigAppraiser").val(result.AppraiserRecommendedForDesignationId);
                        $("#txtAppraiserRemarks").val(result.AppraiserRecommendationComment);
                        $("#txtAppraiserPercRecommendation").val(result.AppraiserRecommendedPercentage);
                        showHidePromotionsControls(1);
                    }
                    if (result.AppraiserMarkedHighPotential) {
                        $("#approverHPDivInner").hide();
                        $("#ckbHPAprs").attr('checked', 'checked');
                        $("#txtAppraiserRemarksHP").val(result.AppraiserHighPotentialComment);
                        showHidePromotionsControls(3);
                    }
                    if ((result.Approver1RecommendedForDesignationId != null && result.Approver1RecommendedForDesignationId > 0) || (result.Approver1RecommendationComment != '' && result.Approver1RecommendationComment != null) || (result.Approver1RecommendedPercentage > 0)) {
                        $("#ApproverPromotionsDivInner").show();
                        $("#ckbRecommendedDesignationAprv").attr('checked', 'checked');
                        $("#ddlRecDesigApprover").val(result.Approver1RecommendedForDesignationId);
                        $("#txtApproverRemarks").val(result.Approver1RecommendationComment);
                        $("#txtApproverPercRecommendation").val(result.Approver1RecommendedPercentage);
                        showHidePromotionsControls(2);
                    }
                    if (result.Approver1MarkedHighPotential) {
                        $("#approverHPDivInner").show();
                        $("#ckbHPAprv").attr('checked', 'checked');
                        $("#txtApproverRemarksHP").val(result.Approver1HighPotentialComment);
                        showHidePromotionsControls(4);
                    }
                    if (result.AppraisalStatusId == 6 || result.AppraisalStatusId == 7) {
                        $("#ApproverPromotionsDiv").find("input,button,textarea,select").attr("disabled", "disabled");
                        $("#approverHPDiv").find("input,button,textarea,select").attr("disabled", "disabled");
                        $("#appraiserPromotionsDiv").find("input,button,textarea,select").attr("disabled", "disabled");
                        $("#appraiserHPDiv").find("input,button,textarea,select").attr("disabled", "disabled");
                    }

                }
                if ((result.IsModifyRight == true && result.AppraisalStatusId == 5 && result.ApproverAbrhs == misSession.userabrhs)) {
                    $("#appraiserPromotionsDiv").find("input,button,textarea,select").attr("disabled", "disabled");
                    $("#appraiserHPDiv").find("input,button,textarea,select").attr("disabled", "disabled");
                    bindPromotionsDesignation(result.AppraiserRecommendedForDesignationId || 0, result.Approver1RecommendedForDesignationId || 0);
                    if ((result.AppraiserRecommendedForDesignationId != null && result.AppraiserRecommendedForDesignationId > 0) || (result.AppraiserRecommendationComment != '' && result.AppraiserRecommendationComment != null) || (result.AppraiserRecommendedPercentage > 0)) {
                        $("#ckbRecommendedDesignationAprs").attr('checked', 'checked');
                        $("#ddlRecDesigAppraiser").val(result.AppraiserRecommendedForDesignationId);
                        $("#txtAppraiserRemarks").val(result.AppraiserRecommendationComment);
                        $("#txtAppraiserPercRecommendation").val(result.AppraiserRecommendedPercentage);
                        showHidePromotionsControls(1);
                    }
                    if (result.AppraiserMarkedHighPotential) {
                        $("#ckbHPAprs").attr('checked', 'checked');
                        $("#txtAppraiserRemarksHP").val(result.AppraiserHighPotentialComment);
                        showHidePromotionsControls(3);
                    }
                    if ((result.Approver1RecommendedForDesignationId != null && result.Approver1RecommendedForDesignationId > 0) || (result.Approver1RecommendationComment != '' && result.Approver1RecommendationComment != null) || (result.Approver1RecommendedPercentage > 0)) {
                        $("#ApproverPromotionsDivInner").show();
                        $("#ckbRecommendedDesignationAprv").attr('checked', 'checked');
                        $("#ddlRecDesigApprover").val(result.Approver1RecommendedForDesignationId);
                        $("#txtApproverRemarks").val(result.Approver1RecommendationComment);
                        $("#txtApproverPercRecommendation").val(result.Approver1RecommendedPercentage);
                        showHidePromotionsControls(2);
                    }
                    if (result.Approver1MarkedHighPotential) {
                        $("#approverHPDivInner").show();
                        $("#ckbHPAprv").attr('checked', 'checked');
                        $("#txtApproverRemarksHP").val(result.Approver1HighPotentialComment);
                        showHidePromotionsControls(4);
                    }
                }
                if ((result.IsModifyRight == true && result.AppraisalStatusId == 4 && result.AppraiserAbrhs == misSession.userabrhs)) {
                    $("#ApproverPromotionsDiv").find("input,button,textarea,select").attr("disabled", "disabled");
                    $("#approverHPDiv").find("input,button,textarea,select").attr("disabled", "disabled");
                    bindPromotionsDesignation(result.AppraiserRecommendedForDesignationId || 0, result.Approver1RecommendedForDesignationId || 0);
                    if ((result.AppraiserRecommendedForDesignationId != null && result.AppraiserRecommendedForDesignationId > 0) || (result.AppraiserRecommendationComment != '' && result.AppraiserRecommendationComment != null) || (result.AppraiserRecommendedPercentage > 0)) {
                        $("#ApproverPromotionsDivInner").hide();
                        $("#ckbRecommendedDesignationAprs").attr('checked', 'checked');
                        $("#ddlRecDesigAppraiser").val(result.AppraiserRecommendedForDesignationId);
                        $("#txtAppraiserRemarks").val(result.AppraiserRecommendationComment);
                        $("#txtAppraiserPercRecommendation").val(result.AppraiserRecommendedPercentage);
                        showHidePromotionsControls(1);
                    }
                    if (result.AppraiserMarkedHighPotential) {
                        $("#approverHPDivInner").hide();
                        $("#ckbHPAprs").attr('checked', 'checked');
                        $("#txtAppraiserRemarksHP").val(result.AppraiserHighPotentialComment);
                        showHidePromotionsControls(3);
                    }
                    if ((result.Approver1RecommendedForDesignationId != null && result.Approver1RecommendedForDesignationId > 0) || (result.Approver1RecommendationComment != '' && result.Approver1RecommendationComment != null) || (result.Approver1RecommendedPercentage > 0)) {
                        $("#ApproverPromotionsDivInner").show();
                        $("#ckbRecommendedDesignationAprv").attr('checked', 'checked');
                        $("#ddlRecDesigApprover").val(result.Approver1RecommendedForDesignationId);
                        $("#txtApproverRemarks").val(result.Approver1RecommendationComment);
                        $("#txtApproverPercRecommendation").val(result.Approver1RecommendedPercentage);
                        showHidePromotionsControls(2);
                    }
                    if (result.Approver1MarkedHighPotential) {
                        $("#approverHPDivInner").show();
                        $("#ckbHPAprv").attr('checked', 'checked');
                        $("#txtApproverRemarksHP").val(result.Approver1HighPotentialComment);
                        showHidePromotionsControls(4);
                    }
                }
                if (result.AppraisalStatusId == 6 || result.AppraisalStatusId == 7) {
                    $("#btnReferBack").hide();
                    $("#ApproverPromotionsDiv").find("input,button,textarea,select").attr("disabled", "disabled");
                    $("#approverHPDiv").find("input,button,textarea,select").attr("disabled", "disabled");
                    $("#appraiserPromotionsDiv").find("input,button,textarea,select").attr("disabled", "disabled");
                    $("#appraiserHPDiv").find("input,button,textarea,select").attr("disabled", "disabled");
                }
            }
        });

}

function bindPromotionsDesignation(designationIdByAppraiser, designationIdByApprover) {
    $('#ddlRecDesigAppraiser').empty();
    $('#ddlRecDesigApprover').empty();
    var JsonObject = {
        empAppraisalSettingId: $("#hdnEmpAppraisalSettingId").val()
    };
    calltoAjax(misApiUrl.getPromotionDesignationsByUserId, "POST", JsonObject,
        function (result) {
            if (result != null && result.length > 0) {
                $('#ddlRecDesigAppraiser').append("<option value = 0>Select</option>");
                $('#ddlRecDesigApprover').append("<option value = 0>Select</option>");
                for (var x = 0; x < result.length; x++) {
                    $('#ddlRecDesigAppraiser').append("<option value = '" + result[x].Value + "'>" + result[x].Text + "</option>");
                    $('#ddlRecDesigApprover').append("<option value = '" + result[x].Value + "'>" + result[x].Text + "</option>");
                }
                if (designationIdByAppraiser > 0) {
                    $('#ddlRecDesigAppraiser').val(designationIdByAppraiser);
                }
                if (designationIdByApprover > 0) {
                    $('#ddlRecDesigApprover').val(designationIdByApprover);
                }
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
    $("#spndate").html(appraisalData.SelfSubmitDate);

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
               "sTitle": (formData.IsModifyRight == true && formData.AppraisalStatusId == 4 && formData.AppraiserAbrhs == misSession.userabrhs) ? "Appraiser Comments <span class='spnError'><b>*</b></span>&nbsp;<input type='checkbox' id='ckbTechnicalSelfCommentsCopy'>&nbsp;Copy Data" : "Appraiser Comments <span class='spnError'><b>*</b></span>",
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
           },
            {
                "data": "ApproverComment",
                "sTitle": (formData.IsModifyRight == true && formData.AppraisalStatusId == 5 && formData.ApproverAbrhs == misSession.userabrhs) ? "Approver Comments <span class='spnError'><b>*</b></span>&nbsp;<input type='checkbox' id='ckbTechnicalAppraiserCommentsCopy'>&nbsp;Copy Data" : "Approver Comments <span class='spnError'><b>*</b></span>",
                "sClass": "col-max-width-120 relative-pos",
                "visible": (formData.AppraisalStatusId == 6 && formData.AppraiseeAbrhs != misSession.userabrhs) || (formData.AppraiserAbrhs == misSession.userabrhs || formData.ApproverAbrhs == misSession.userabrhs) || false,
                mRender: function (data, type, row) {
                    var isEmpAccess = (formData.IsModifyRight == true && formData.AppraisalStatusId == 5 && formData.ApproverAbrhs == misSession.userabrhs);
                    var enabled = (isEmpAccess == false) ? "disabled='disabled'" : "";
                    var validationClass = "form-control max-height-txt approver-feedback";
                    validationClass += ((isEmpAccess == false) ? "" : " openPopup");
                    var html = "<textarea " + enabled + " id ='txtApproverFeed" + row.CompetencyFormDetailId + "' style='width:100%' placeholder='Enter your comments here...' rows='3' maxlength='4000' class='" + validationClass + "' onkeypress='return blockSpecialChar(event)'>" + row.ApproverComment + "</textarea>" +
                                    '<div class="btn-group ' + ((isEmpAccess == true) ? "" : "radioButtonDisabled") + '" data-toggle="buttons" style="width:100%" id ="approverTeRating' + row.CompetencyFormDetailId + '">' +
                                    '<label class="rating-button btn btn-default ' + (row.ApproverRatingId == 1 ? 'active' : '') + '"><input name="rdbapproverTeRating' + row.CompetencyFormDetailId + '" value="1" type="radio" ' + (row.ApproverRatingId == 1 ? 'checked' : '') + '>1</label>' +
                                    '<label class="rating-button btn btn-default ' + (row.ApproverRatingId == 2 ? 'active' : '') + '"><input name="rdbapproverTeRating' + row.CompetencyFormDetailId + '" value="2" type="radio" ' + (row.ApproverRatingId == 2 ? 'checked' : '') + '>2</label>' +
                                    '<label class="rating-button btn btn-default ' + (row.ApproverRatingId == 3 ? 'active' : '') + '"><input name="rdbapproverTeRating' + row.CompetencyFormDetailId + '" value="3" type="radio" ' + (row.ApproverRatingId == 3 ? 'checked' : '') + '>3</label>' +
                                    '<label class="rating-button btn btn-default ' + (row.ApproverRatingId == 4 ? 'active' : '') + '"><input name="rdbapproverTeRating' + row.CompetencyFormDetailId + '" value="4" type="radio" ' + (row.ApproverRatingId == 4 ? 'checked' : '') + '>4</label>' +
                                    '<label class="rating-button btn btn-default ' + (row.ApproverRatingId == 5 ? 'active' : '') + '"><input name="rdbapproverTeRating' + row.CompetencyFormDetailId + '" value="5" type="radio" ' + (row.ApproverRatingId == 5 ? 'checked' : '') + '>5</label></div>';
                    return html;
                }
            },
        ],
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
               "sTitle": (formData.IsModifyRight == true && formData.AppraisalStatusId == 4 && formData.AppraiserAbrhs == misSession.userabrhs) ? "Appraiser Comments <span class='spnError'><b>*</b></span>&nbsp;<input type='checkbox' id='ckbBehaviouralSelfCommentsCopy'>&nbsp;Copy Data" : "Appraiser Comments <span class='spnError'><b>*</b></span>",
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
           },
            {
                "sTitle": (formData.IsModifyRight == true && formData.AppraisalStatusId == 5 && formData.ApproverAbrhs == misSession.userabrhs) ? "Approver Comments <span class='spnError'><b>*</b></span>&nbsp;<input type='checkbox' id='ckbBehaviouralAppraiserCommentsCopy'>&nbsp;Copy Data" : "Approver Comments <span class='spnError'><b>*</b></span>",
                "data": "ApproverComment",
                "sClass": "col-max-width-120 relative-pos",
                "visible": (formData.AppraisalStatusId == 6 && formData.AppraiseeAbrhs != misSession.userabrhs) || (formData.AppraiserAbrhs == misSession.userabrhs || formData.ApproverAbrhs == misSession.userabrhs) || false,
                mRender: function (data, type, row) {
                    var isEmpAccess = (formData.IsModifyRight == true && formData.AppraisalStatusId == 5 && formData.ApproverAbrhs == misSession.userabrhs);
                    var enabled = (isEmpAccess == false) ? "disabled='disabled'" : "";
                    var validationClass = "form-control max-height-txt approver-feedback";
                    validationClass += ((isEmpAccess == false) ? "" : " openPopup");
                    var html = "<textarea " + enabled + " id ='txtApproverFeed" + row.CompetencyFormDetailId + "' style='width:100%' placeholder='Enter your comments here...' rows='3' maxlength='4000' class='" + validationClass + "' onkeypress='return blockSpecialChar(event)'>" + row.ApproverComment + "</textarea>" +
                                    '<div class="btn-group ' + ((isEmpAccess == true) ? "" : "radioButtonDisabled") + '" data-toggle="buttons" style="width:100%" id ="approverTeRating' + row.CompetencyFormDetailId + '">' +
                                    '<label class="rating-button btn btn-default ' + (row.ApproverRatingId == 1 ? 'active' : '') + '"><input name="rdbapproverTeRating' + row.CompetencyFormDetailId + '" value="1" type="radio" ' + (row.ApproverRatingId == 1 ? 'checked' : '') + '>1</label>' +
                                    '<label class="rating-button btn btn-default ' + (row.ApproverRatingId == 2 ? 'active' : '') + '"><input name="rdbapproverTeRating' + row.CompetencyFormDetailId + '" value="2" type="radio" ' + (row.ApproverRatingId == 2 ? 'checked' : '') + '>2</label>' +
                                    '<label class="rating-button btn btn-default ' + (row.ApproverRatingId == 3 ? 'active' : '') + '"><input name="rdbapproverTeRating' + row.CompetencyFormDetailId + '" value="3" type="radio" ' + (row.ApproverRatingId == 3 ? 'checked' : '') + '>3</label>' +
                                    '<label class="rating-button btn btn-default ' + (row.ApproverRatingId == 4 ? 'active' : '') + '"><input name="rdbapproverTeRating' + row.CompetencyFormDetailId + '" value="4" type="radio" ' + (row.ApproverRatingId == 4 ? 'checked' : '') + '>4</label>' +
                                    '<label class="rating-button btn btn-default ' + (row.ApproverRatingId == 5 ? 'active' : '') + '"><input name="rdbapproverTeRating' + row.CompetencyFormDetailId + '" value="5" type="radio" ' + (row.ApproverRatingId == 5 ? 'checked' : '') + '>5</label></div>';
                    return html;
                }
            },
        ],
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
                 "sWidth": "250px",
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
                "sTitle": (formData.IsModifyRight == true && formData.AppraisalStatusId == 4 && formData.AppraiserAbrhs == misSession.userabrhs) ? "Appraiser Comments <span class='spnError'><b>*</b></span>&nbsp;<input type='checkbox' id='ckbGoalSelfCommentsCopy'>&nbsp;Copy Data" : "Appraiser Comments <span class='spnError'><b>*</b></span>",
                "sClass": "col-max-width-200 relative-pos",
                "sWidth": "250px",
                mRender: function (data, type, row) {
                    var isEmpAccess = (formData.IsModifyRight == true && formData.AppraisalStatusId == 4 && formData.AppraiserAbrhs == misSession.userabrhs);
                    var enabled = (isEmpAccess == false) ? "disabled='disabled'" : "";
                    var validationClass = "form-control max-height-txt scroll-max-height-200 appraiser-feedback" + ((isEmpAccess == false) ? "" : " validation-required openPopup");
                    return "<textarea " + enabled + " id ='txtAppraiserFeed" + row.UserGoalId + "' style='width:100%;' placeholder='Enter your comments here...' rows='3' maxlength='4000' class='" + validationClass + "' onkeypress='return blockSpecialChar(event)'>" + row.AppraiserComment + "</textarea>";
                }
            },
            {
                "sTitle": (formData.IsModifyRight == true && formData.AppraisalStatusId == 5 && formData.ApproverAbrhs == misSession.userabrhs) ? "Approver Comments <span class='spnError'><b>*</b></span>&nbsp;<input type='checkbox' id='ckbGoalAppraiserCommentsCopy'>&nbsp;Copy Data" : "Approver Comments <span class='spnError'><b>*</b></span>",
                "data": "ApproverComment",
                "sClass": "col-max-width-120 relative-pos",
                "sWidth": "250px",
                "visible": (formData.AppraisalStatusId == 6 && formData.AppraiseeAbrhs != misSession.userabrhs) || (formData.AppraiserAbrhs == misSession.userabrhs || formData.ApproverAbrhs == misSession.userabrhs) || false,
                mRender: function (data, type, row) {
                    var isEmpAccess = (formData.IsModifyRight == true && formData.AppraisalStatusId == 5 && formData.ApproverAbrhs == misSession.userabrhs);
                    var enabled = (isEmpAccess == false) ? "disabled='disabled'" : "";
                    var validationClass = "form-control max-height-txt approver-feedback";
                    validationClass += ((isEmpAccess == false) ? "" : " openPopup");
                    return "<textarea " + enabled + " id ='txtApproverFeed" + row.UserGoalId + "' style='width:100%' placeholder='Enter your comments here...' rows='3' maxlength='4000' class='" + validationClass + "' onkeypress='return blockSpecialChar(event)'>" + row.ApproverComment + "</textarea>";
                }
            }
        ],

    });
}

// Generate Dynamic Controls for add Achivements.
function AddNewControl() {
    generateControls('dynamicAddAchievements');
}

var dynamicId = 0;
function generateControls(containerId, maxNoOfTextBoxes, minNoOfMandatoryTxtBoxes) {
    maxNoOfTextBoxes = maxNoOfTextBoxes || 10;
    if (containerId) {
        var txtCount = $("#" + containerId).find('.itemRow').length;
        if (txtCount < maxNoOfTextBoxes) {
            $("#" + containerId).append(getDynamicControls(dynamicId, minNoOfMandatoryTxtBoxes || 1, '', 0));
            dynamicId += 1;
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

var dynamicReloadId = 0;
function generateControlsForReload(containerId, maxNoOfTextBoxes, minNoOfMandatoryTxtBoxes, achievementId, achievement) {
    maxNoOfTextBoxes = maxNoOfTextBoxes || 10;
    if (containerId) {
        var txtCount = $("#" + containerId).find('.itemRow').length;
        if (txtCount < maxNoOfTextBoxes) {
            $("#" + containerId).append(getDynamicControls(dynamicReloadId, minNoOfMandatoryTxtBoxes || 1, '', achievementId));
            dynamicReloadId += 1;
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
                "sClass": "width-per-35",
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
            },
            {
                "sTitle": (formData.IsModifyRight == true && formData.AppraisalStatusId == 5 && formData.ApproverAbrhs == misSession.userabrhs) ? "Approver Comments <span class='spnError'><b>*</b></span>&nbsp;<input type='checkbox' id='ckbAchievementsAppraiserCommentsCopy'>&nbsp;Copy Data" : "Approver Comments <span class='spnError'><b>*</b></span>",
                "sClass": "col-max-width-200 relative-pos",
                "visible": (formData.AppraisalStatusId == 6 && formData.AppraiseeAbrhs != misSession.userabrhs) || (formData.AppraiserAbrhs == misSession.userabrhs || formData.ApproverAbrhs == misSession.userabrhs) || false,
                mRender: function (data, type, row) {
                    var isEmpAccess = (formData.IsModifyRight == true && formData.AppraisalStatusId == 5 && formData.ApproverAbrhs == misSession.userabrhs);
                    var enabled = (isEmpAccess == false) ? "disabled='disabled'" : "";
                    var validationClass = "form-control max-height-txt approver-feedback";
                    validationClass += ((isEmpAccess == false) ? "" : " openPopup");
                    return "<textarea " + enabled + " id ='txtApproverAchievementsFeed" + row.UserAchievementId + "' style='width:100%' placeholder='Enter your comments here...' rows='3' maxlength='4000' class='" + validationClass + "' onkeypress='return blockSpecialChar(event)'>" + row.ApproverComment + "</textarea>";
                }
            }
        ],

    });
}

function removeControls(item) {
    $(item).closest('.itemRow').remove()
}

function showHidePromotionsControls(controlId) {

    if (controlId == 1) {
        if ($("#ckbRecommendedDesignationAprs").prop("checked") == false) {
            $("#divAppraiserPromotionsControls").hide();
            $("#ddlRecDesigAppraiser").removeClass("select-validate validation-required error-validation");
            $("#txtAppraiserRemarks").removeClass("validation-required error-validation");
            $("#txtAppraiserPercRecommendation").removeClass("validation-required error-validation");
        }
        else {
            $("#divAppraiserPromotionsControls").show();
            $("#ddlRecDesigAppraiser").addClass("select-validate validation-required");
            $("#txtAppraiserRemarks").addClass("validation-required");
            $("#txtAppraiserPercRecommendation").addClass("validation-required");
        }

    }
    if (controlId == 2) {
        if ($("#ckbRecommendedDesignationAprv").prop("checked") == false) {
            $("#divApproverPromotionsControls").hide();
            $("#ddlRecDesigApprover").removeClass("select-validate validation-required error-validation");
            $("#txtApproverRemarks").removeClass("validation-required error-validation");
            $("#txtApproverPercRecommendation").removeClass("validation-required error-validation");
        }
        else {
            $("#divApproverPromotionsControls").show();
            $("#ddlRecDesigApprover").addClass("select-validate validation-required");
            $("#txtApproverRemarks").addClass("validation-required");
            $("#txtApproverPercRecommendation").addClass("validation-required");
        }
    }
    if (controlId == 3) {
        if ($("#ckbHPAprs").prop("checked") == false) {
            $("#divAppraiserHPControls").hide();
            $("#txtAppraiserRemarksHP").removeClass("validation-required error-validation");
        }
        else {
            $("#divAppraiserHPControls").show();
            $("#txtAppraiserRemarksHP").addClass("validation-required");
        }
    }
    if (controlId == 4) {
        if ($("#ckbHPAprv").prop("checked") == false) {
            $("#divApproverHPControls").hide();
            $("#txtApproverRemarksHP").removeClass("validation-required error-validation");
        }
        else {
            $("#divApproverHPControls").show();
            $("#txtApproverRemarksHP").addClass("validation-required");
        }
    }
}

// Save Calls
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
            $("#lblApproverRatingWeighted").html(data.ApproverOverallRatingWeighted);
        });
}

function getAppraisalFormData() {

    var i = 0;
    var collection = [];

    $('#gridAppraisalTechnicalCompetency tbody tr').each(function (index, item) {
        var $inputs = $(this).find(':input');
        var $tr = $(this);
        var rowiDx = '';
        var items = {};
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
            if (AppraiserAbrhs == misSession.userabrhs && AppraisalStatusId == 4) {
                if (id == 'txtAppraiserFeed' + rowiDx) {
                    items.Comment = $("#" + id).val();
                    var rtng = $tr.find('input[name=rdbappraiserTeRating' + eACompetencyFormDetailId + ']:checked')[0];
                    items.RatingId = (typeof (rtng) !== 'undefined' && rtng.value !== "0") ? rtng.value : null;
                }
            }
            if (ApproverAbrhs == misSession.userabrhs && AppraisalStatusId == 5) {
                if (id == 'txtApproverFeed' + rowiDx) {
                    items.Comment = $("#" + id).val();
                    var rtng = $tr.find('input[name=rdbapproverTeRating' + eACompetencyFormDetailId + ']:checked')[0];
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
        var items = {};
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
            if (AppraiserAbrhs == misSession.userabrhs && AppraisalStatusId == 4) {
                if (id == 'txtAppraiserFeed' + rowiDx) {
                    items.Comment = $("#" + id).val();
                    var rtng = $tr.find('input[name=rdbappraiserTeRating' + eACompetencyFormDetailId + ']:checked')[0];
                    items.RatingId = (typeof (rtng) !== 'undefined' && rtng.value !== "0") ? rtng.value : null;
                }
            }
            if (ApproverAbrhs == misSession.userabrhs && AppraisalStatusId == 5) {
                if (id == 'txtApproverFeed' + rowiDx) {
                    items.Comment = $("#" + id).val();
                    var rtng = $tr.find('input[name=rdbapproverTeRating' + eACompetencyFormDetailId + ']:checked')[0];
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
            if (AppraiserAbrhs == misSession.userabrhs && AppraisalStatusId == 4) {
                if (id == 'txtAppraiserFeed' + rowiDx) {
                    goalItems.Comment = $("#" + id).val();
                }
            }
            if (ApproverAbrhs == misSession.userabrhs && AppraisalStatusId == 5) {
                if (id == 'txtApproverFeed' + rowiDx) {
                    goalItems.Comment = $("#" + id).val();
                }
            }
        });
        goalCollection.push(goalItems);
    });

    return goalCollection;
}

//Tab 4. Save Achievements.
//(ii) For Appraiser and Approver.
function SaveEmployeeAchievementComments() {
    var JsonObject = {
        EmpAppraisalSettingId: $("#hdnEmpAppraisalSettingId").val(),
        DetailList: getAchievementsCommentsFormData()
    };
    if (achievementsCommntsCheck > 0) {
        calltoAjax(misApiUrl.saveEmployeeAppraisalAchievement, "POST", JsonObject,
      function (result) { });
    }
}

var achievementsCheck = 0;
function getAchievementsFormData() {
    var achievementscollection = new Array();
    var items;
    $('.itemRow').each(function () {
        achievementsCheck = achievementsCheck + 1;
        var id = $(this).closest(".itemRow").attr("id").split('-')[1];
        items = new Object();
        items.UserAchievementId = $(this).closest(".itemRow").attr("data-attr-UserAchievementId");
        items.Comment = $("#achievements" + id).val();
        achievementscollection.push(items);
    });
    return achievementscollection;
}

var achievementsCommntsCheck = 0;

function getAchievementsCommentsFormData() {
    var i = 0;
    var achievementsCollection = new Array();
    var achievementsItems;
    $('#gridAppraisalAchievements tbody tr').each(function (index, item) {
        var $inputs = $(this).find(':input');
        var rowiDx = '';
        achievementsItems = new Object();
        $inputs.each(function (idx, itm) {
            achievementsCommntsCheck = achievementsCommntsCheck + 1;
            var id = $(this)[0].id;
            if ($(this)[0].type == 'hidden') {
                rowiDx = $(this).val();
                achievementsItems.UserAchievementId = $(this).attr("data-attr-UserAchievementId");
            }
            if (AppraiserAbrhs == misSession.userabrhs && AppraisalStatusId == 4) {
                if (id == 'txtAppraiserAchievementsFeed' + rowiDx) {
                    achievementsItems.Comment = $("#" + id).val();
                }
            }
            if (ApproverAbrhs == misSession.userabrhs && AppraisalStatusId == 5) {
                if (id == 'txtApproverAchievementsFeed' + rowiDx) {
                    achievementsItems.Comment = $("#" + id).val();
                }
            }
        });
        achievementsCollection.push(achievementsItems);
    });

    return achievementsCollection;
}

//Tab 5. Promotions
function SaveEmployeePromotions() {
    var JsonObject = {};
    if (AppraiserAbrhs == misSession.userabrhs && AppraisalStatusId == 4) {
        var percentage = $("#txtAppraiserPercRecommendation").val() == '' ? 0 : $("#txtAppraiserPercRecommendation").val();
        var promotionDesignationId = 0;
        var promotionRemarks = '';
        var recommendationPercentage = 0;
        if ($("#ckbRecommendedDesignationAprs").is(':checked')) {
            promotionDesignationId = $("#ddlRecDesigAppraiser").val();
            promotionRemarks = $("#txtAppraiserRemarks").val();
            recommendationPercentage = percentage;
        }
        var highPotentialRemarks = '';
        if ($("#ckbHPAprs").is(':checked')) {
            highPotentialRemarks = $("#txtAppraiserRemarksHP").val();
        }
        JsonObject = {
            EmpAppraisalSettingId: $("#hdnEmpAppraisalSettingId").val(),
            IsPromoted: $("#ckbRecommendedDesignationAprs").is(':checked'),
            PromotionDesignationId: promotionDesignationId,
            PromotionRemarks: promotionRemarks,
            RecommendationPercentage: (recommendationPercentage == null || recommendationPercentage == '') ? 0 : recommendationPercentage,
            IsHighPotential: $("#ckbHPAprs").is(':checked'),
            HighPotentialRemarks: highPotentialRemarks,
            UserAbrhs: misSession.userabrhs
        };
    }
    if (ApproverAbrhs == misSession.userabrhs && AppraisalStatusId == 5) {
        var percentageApprover = $("#txtApproverPercRecommendation").val() == '' ? 0 : $("#txtApproverPercRecommendation").val();
        var promotionDesignationId = 0;
        var promotionRemarks = '';
        var recommendationPercentage = 0;
        if ($("#ckbRecommendedDesignationAprv").is(':checked')) {
            promotionDesignationId = $("#ddlRecDesigApprover").val();
            promotionRemarks = $("#txtApproverRemarks").val();
            recommendationPercentage = percentageApprover;
        }
        var highPotentialRemarks = '';
        if ($("#ckbHPAprv").is(':checked')) {
            highPotentialRemarks = $("#txtApproverRemarksHP").val();
        }
        JsonObject = {
            EmpAppraisalSettingId: $("#hdnEmpAppraisalSettingId").val(),
            IsPromoted: $("#ckbRecommendedDesignationAprv").is(':checked'),
            PromotionDesignationId: promotionDesignationId,
            PromotionRemarks: promotionRemarks,
            RecommendationPercentage: (recommendationPercentage == null || recommendationPercentage == '') ? 0 : recommendationPercentage,
            IsHighPotential: $("#ckbHPAprv").is(':checked'),
            HighPotentialRemarks: highPotentialRemarks
        };
    }

    calltoAjax(misApiUrl.saveEmployeeAppraisalPromotion, "POST", JsonObject,
      function (result) { });
}

//Tab 6. Final Submit Call.
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
                            BindTeamAppraisal();
                            $("#teamAppraisalFormPopup").modal("hide");
                            $("#btnSaveAsDraft").addClass("hidden");
                            misAlert("You have successfully submited your teams appraisal.", "Success", "success");
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
            $("#lblApproverRatingWeighted").html(data.ApproverOverallRatingWeighted);

            $("#lblAppraiseeRatingNormal").html(data.SelfOverallRatingNormal);
            $("#lblAppraiserRatingNormal").html(data.AppraiserOverallRatingNormal);
            $("#lblApproverRatingNormal").html(data.ApproverOverallRatingNormal);
        });
}

//auto save employee appraisal goal
function addUpdateEmployeeAppraisalGoalAsync() {
    //console.log('Appraisal goals auto saved');
    var JsonObject = {
        EmpAppraisalSettingId: $("#hdnEmpAppraisalSettingId").val(),
        DetailList: getGoalsFormData()
    };
    if (goalCheck > 0) {
        calltoAjaxWithoutLoader(misApiUrl.saveEmployeeAppraisalGoalAsync, "POST", JsonObject,
            function (result) { });
    }
}

//auto save employee appraisal achievement for upper level
function saveEmployeeAchievementCommentsAsync() {
    //console.log('Achievements auto saved for upper level');
    var JsonObject = {
        EmpAppraisalSettingId: $("#hdnEmpAppraisalSettingId").val(),
        DetailList: getAchievementsCommentsFormData()
    };
    if (achievementsCommntsCheck > 0) {
        calltoAjaxWithoutLoader(misApiUrl.saveEmployeeAppraisalAchievementAsync, "POST", JsonObject,
            function (result) { });
    }
}

//auto save employee appraisal promotion 
function addUpdateEmployeeAppraisalPromotionAsync() {

    var JsonObject = {};
    if (AppraiserAbrhs == misSession.userabrhs && AppraisalStatusId == 4) {
        var promotionDesignationId = 0;
        var promotionRemarks = '';
        var recommendationPercentage = 0;
        if ($("#ckbRecommendedDesignationAprs").is(':checked')) {
            promotionDesignationId = $("#ddlRecDesigAppraiser").val();
            promotionRemarks = $("#txtAppraiserRemarks").val();
            recommendationPercentage = $("#txtAppraiserPercRecommendation").val();
        }
        var highPotentialRemarks = '';
        if ($("#ckbHPAprs").is(':checked')) {
            highPotentialRemarks = $("#txtAppraiserRemarksHP").val();
        }
        JsonObject = {
            EmpAppraisalSettingId: $("#hdnEmpAppraisalSettingId").val(),
            IsPromoted: $("#ckbRecommendedDesignationAprs").is(':checked'),
            PromotionDesignationId: promotionDesignationId,
            PromotionRemarks: promotionRemarks,
            RecommendationPercentage: (recommendationPercentage == null || recommendationPercentage == '') ? 0 : recommendationPercentage,
            IsHighPotential: $("#ckbHPAprs").is(':checked'),
            HighPotentialRemarks: highPotentialRemarks,
            UserAbrhs: misSession.userabrhs
        };
    }
    if (ApproverAbrhs == misSession.userabrhs && AppraisalStatusId == 5) {
        var promotionDesignationId = 0;
        var promotionRemarks = '';
        var recommendationPercentage = 0;
        if ($("#ckbRecommendedDesignationAprv").is(':checked')) {
            promotionDesignationId = $("#ddlRecDesigApprover").val();
            promotionRemarks = $("#txtApproverRemarks").val();
            recommendationPercentage = $("#txtApproverPercRecommendation").val();
        }
        var highPotentialRemarks = '';
        if ($("#ckbHPAprv").is(':checked')) {
            highPotentialRemarks = $("#txtApproverRemarksHP").val();
        }
        JsonObject = {
            EmpAppraisalSettingId: $("#hdnEmpAppraisalSettingId").val(),
            IsPromoted: $("#ckbRecommendedDesignationAprv").is(':checked'),
            PromotionDesignationId: promotionDesignationId,
            PromotionRemarks: promotionRemarks,
            RecommendationPercentage: (recommendationPercentage == null || recommendationPercentage == '') ? 0 : recommendationPercentage,
            IsHighPotential: $("#ckbHPAprv").is(':checked'),
            HighPotentialRemarks: highPotentialRemarks
        };
    }

    calltoAjaxWithoutLoader(misApiUrl.saveEmployeeAppraisalPromotionAsync, "POST", JsonObject,
      function (result) { });
}
/***************************************************************/