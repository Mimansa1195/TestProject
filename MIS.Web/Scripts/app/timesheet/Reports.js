
$(document).ready(function () {
    if (misPermissions.isDelegatable) {
        var html = '';
        if (!misPermissions.isDelegated) {
            html = '<button id="btnUserDelegation" type="button" class="btn btn-success"><i class="fa fa-bolt"></i>&nbsp;Delegate</button>';
        }
        else {
            html = '<button id="btnUserDelegation" type="button" class="btn btn-success"><i class="fa fa-lightbulb-o" style="color: yellow;font-size: 20px;"></i>&nbsp;Delegate</button>';
        }
        $("#divDeligation").html(html);
    }

    bindTeamDropDown();
    bindYearDropDown();
});

function bindTeamDropDown() {
    $('#teamSelect').multiselect('destroy');
    $('#teamSelect').empty();
    $('#teamSelect').multiselect();
    var jsonObject = {
        'userAbrhs': misSession.userabrhs,
        'menuAbrhs': misPermissions.menuAbrhs
    };
    calltoAjax(misApiUrl.listTeamByUserId, "POST", jsonObject,
               function (result) {
                   
                   $('#teamSelect').multiselect("destroy");
                   $('#teamSelect').empty();
                   $.each(result, function (index, value) {
                       $("#teamSelect").append("<option value = '" + value.Value + "'>" + value.Text + "</option>");
                   });
                   $('#teamSelect').multiselect({
                       includeSelectAllOption: true,
                       enableFiltering: true,
                       enableCaseInsensitiveFiltering: true,
                       buttonWidth: false,
                       onDropdownHidden: function (event) {
                       }
                   });
               });
}

function bindYearDropDown() {
    $('#yearSelect').empty();
    var jsonObject = {
        'userAbrhs': misSession.userabrhs,
    };
    calltoAjax(misApiUrl.listYears, "POST", jsonObject,
        function (result) {
            $("#yearSelect").append("<option value='0'>Select</option>");
            $.each(result, function (idx, item) {
                $("#yearSelect").append("<option>" + item + "</option>");
            });
        });
}

$('#yearSelect').change(function () {
    $('#weekSelect').empty();
    var jsonObject = {
        'year': $('#yearSelect').val()
    };
    calltoAjax(misApiUrl.listWeeks, "POST", jsonObject,
        function (result) {
            $("#weekSelect").append("<option value='0'>Select</option>");
            $.each(result, function (idx, item) {
                $("#weekSelect").append("<option>" + item + "</option>");
            });
        });
});

function ProcessData() {
    if (!validateControls('divReport')) {
        return false;
    }
    var jsonObject = {
        'team': $('#teamSelect').val().toString(),
        'year': $('#yearSelect').val(),
        'week': $('#weekSelect').val(),
        'userAbrhs': misSession.userabrhs
    };
    calltoAjax(misApiUrl.generateTimesheetReport, "POST", jsonObject,
        function (result) {
            misAlert("Timesheet has been sent on your email id, Successfully.", 'Success', 'success');
        });
}