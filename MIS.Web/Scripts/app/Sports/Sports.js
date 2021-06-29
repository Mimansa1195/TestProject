var TeamsData;
var _TournamentScheduleId;

$(document).ready(function () {
    bindTournamentDropDown();
    bindTournamentCategoryDropDown();
    var MatchDate = new Date();
    MatchDate.setDate(MatchDate.getDate());
    $("#MatchDate input").val(toddmmyyyDatePicker(MatchDate));

    $('#MatchDate').datepicker({
        format: "mm/dd/yyyy",
        autoclose: true,
        todayHighlight: true
    }).datepicker().on('changeDate', function (ev) {
        bindTournamentTeamsDropDown();
    });

});

function resetControls() {
    _TournamentScheduleId = 0;
    $("#team1").html('');
    $("#hdnteam1").val('');
    $("#team1Score").html(0);
    $("#scoreupdatebuttom1").html('');
    $("#team2").html('');
    $("#team2Score").html(0);
    $("#hdnteam2").val('');
    $("#scoreupdatebuttom2").html('');
    $("#isLivebuttom2").html('');
}

function bindTournamentDropDown() {
    $("#ddlTournament").empty();
    $("#ddlTournament").append($("<option></option>").val(0).html("Select"));
    calltoAjax(misApiUrl.getTournaments, "POST", '',
       function (result) {
           $.each(result, function (idx, item) {
               $("#ddlTournament").append($("<option></option>").val(item.Value).html(item.Text));
           });
       });
}

function bindTournamentCategoryDropDown() {
    $("#ddlTournamentCategory").empty();
    $("#ddlTournamentCategory").append($("<option></option>").val(0).html("Select"));
    calltoAjax(misApiUrl.getTournamentCategories, "POST", '',
       function (result) {
           $.each(result, function (idx, item) {
               $("#ddlTournamentCategory").append($("<option></option>").val(item.Value).html(item.Text));
           });
       });
}

function bindRoundDropDown() {
    $("#ddlRound").empty();
    $("#ddlRound").append($("<option></option>").val(0).html("Select"));
    var jsonObject = {
        tournamentId: $("#ddlTournament").val(),
        tournamentCategoryId: $("#ddlTournamentCategory").val(),
    }
    calltoAjax(misApiUrl.getRounds, "POST", jsonObject,
       function (result) {
           $.each(result, function (idx, item) {
               $("#ddlRound").append($("<option></option>").val(item.Value).html(item.Text));
           });
       });
}

function bindTournamentTeamsDropDown() {
    resetControls();
    $("#ddlTeam").empty();
    $("#ddlTeam").append($("<option></option>").val(0).html("Select"));
    var jsonObject = {
        tournamentId: $("#ddlTournament").val(),
        tournamentCategoryId: $("#ddlTournamentCategory").val(),
        roundId: $("#ddlRound").val(),
        MatchDate: $('#MatchDate input').val()
    }
    calltoAjax(misApiUrl.getTournamentTeams, "POST", jsonObject,
       function (result) {
           TeamsData = result;
           $.each(result, function (idx, item) {
               $("#ddlTeam").append($("<option></option>").val(item.TournamentScheduleId).html('(' + item.TournamentUsers + ') Vs (' + item.TournamentVSUsers + ')'));
           });
       });
}

function GetTournamentTeamDetails() {
    $.each(TeamsData, function (idx, item) {
        if (item.TournamentScheduleId == $("#ddlTeam").val()) {
            _TournamentScheduleId = item.TournamentScheduleId;
            $("#team1").html(item.TournamentUsers);
            $("#hdnteam1").val(item.TournamentTeamId);
            $("#team1Score").html(0);
            $("#scoreupdatebuttom1").html('<button type="button" data-toggle="tooltip" class="btn btn-sm btn-success"' + 'onclick="UpdateScore(' + item.TournamentTeamId + ',1,team1)" style="border-radius: 50% !important;height: 45px;width: 45px;"><i class="fa fa-plus" aria-hidden="true"></i></button><button type="button" data-toggle="tooltip" class="btn btn-sm btn-danger"' + 'onclick="UpdateScore(' + item.TournamentTeamId + ',-1,team1)" style="border-radius: 50% !important;height: 45px;width: 45px;margin-left: 8px;"><i class="fa fa-minus" aria-hidden="true"></i></button>');
            $("#team2").html(item.TournamentVSUsers);
            $("#team2Score").html(0);
            $("#hdnteam2").val(item.TournamentVSTeamId);
            $("#scoreupdatebuttom2").html('<button type="button" data-toggle="tooltip" class="btn btn-sm btn-success"' + 'onclick="UpdateScore(' + item.TournamentVSTeamId + ',1,team2)" style="border-radius: 50% !important;height: 45px;width: 45px;"><i class="fa fa-plus" aria-hidden="true"></i></button><button type="button" data-toggle="tooltip" class="btn btn-sm btn-danger"' + 'onclick="UpdateScore(' + item.TournamentVSTeamId + ',-1,team2)" style="border-radius: 50% !important;height: 45px;width: 45px;margin-left: 8px;"><i class="fa fa-minus" aria-hidden="true"></i></button>');
            $("#isLivebuttom2").html('<button type="button" data-toggle="tooltip" class="btn btn-sm btn-primary"' + 'onclick="UpdateMatchStatus(1)" style="border-radius: 50% !important;height: 45px;width: 45px;"><i class="fa fa-check" aria-hidden="true"></i></button>');
            GetTournamentTeamScore(item.TournamentScheduleId);
        }
    });
}

function UpdateMatchStatus(status) {
    var jsonObject = {
        TournamentScheduleId: _TournamentScheduleId || 0,
        Status: status,
        UserAbrhs: misSession.userabrhs
    }
    calltoAjax(misApiUrl.updateMatchStatus, "POST", jsonObject,
       function (result) {
       });
}

function GetTournamentTeamScore() {
    var jsonObject = {
        TournamentScheduleId: _TournamentScheduleId,
        GameId: $("#ddlGameId").val(),
    }
    calltoAjax(misApiUrl.getTournamentTeamScore, "POST", jsonObject,
       function (result) {
           if (result) {
               for (var i = 0; i < result.length; i++) {
                   if ($("#hdnteam1").val() == result[i].TournamentTeamId) {
                       $("#team1Score").html(result[i].GameScore);
                   }
                   if ($("#hdnteam2").val() == result[i].TournamentTeamId) {
                       $("#team2Score").html(result[i].GameScore);
                   }
               }
           }
       });
}

function UpdateScore(TournamentTeamId, Score) {
    var jsonObject = {
        TournamentScheduleId: _TournamentScheduleId,
        TournamentTeamId: TournamentTeamId,
        GameId: $("#ddlGameId").val(),
        ScoreValue: Score,
        UserAbrhs: misSession.userabrhs
    }
    calltoAjax(misApiUrl.updateTeamsScore, "POST", jsonObject,
       function (result) {
           if (result) {
               GetTournamentTeamScore(_TournamentScheduleId);
           }
       });
}
