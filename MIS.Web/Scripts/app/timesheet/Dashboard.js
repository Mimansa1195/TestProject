var _selectedWeek, _currentWeek, _selectedYear, _startDate, _endDate, _weekId, _timeZone, _changeWeek;

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

    _timeZone = new Date().toString().match(/\(.+\)/);
    _changeWeek = 0;
    fetchCurrentWeek();
});

$('#btnPreviousWeek').click(function () {
    _changeWeek = _changeWeek - 1;
    _selectedWeek = _selectedWeek - 1;
    fetchPreviousWeek();
});

$('#btnNextWeek').click(function () {
    if (_selectedWeek === _currentWeek) {
        misAlert("You are already viewing latest week, unable to navigate next week", "Warning", "warning");
    } else {
        _changeWeek = _changeWeek + 1;
        _selectedWeek = _selectedWeek + 1;
        fetchNextWeek();
    }
});


function fetchCurrentWeek() {

    var jsonObject = {
        'userAbrhs': misSession.userabrhs,
        'changeWeek': _changeWeek,
    };
    calltoAjax(misApiUrl.fetchWeekInfo, "POST", jsonObject,
        function (result) {
            if (result != undefined) {
                $('#lblSelectedWeek').html("Week # " + result.WeekNo + " (" + result.DisplayStartDate + " - " + result.DisplayEndDate + ")");
                _currentWeek = result.WeekNo;
                _selectedWeek = result.WeekNo;
                _selectedYear = result.Year;
                _startDate = new Date(result.DisplayStartDate);
                _endDate = new Date(result.DisplayEndDate);
                _currentStartDate = new Date(result.DisplayStartDate);
                fetchCompletedTimeSheets();
                fetchPendingTimeSheets();
            }
        });
}


function fetchPreviousWeek() {
    var localDate = moment(_startDate).format('MM/DD/YYYY');
    var jsonObject = {
        'userAbrhs': misSession.userabrhs,
        'changeWeek': _changeWeek,
    };
    calltoAjax(misApiUrl.fetchWeekInfo, "POST", jsonObject,
        function (result) {
            successFetchWeek(result);
        });
}

function fetchNextWeek() {
    var localDate = moment(_startDate).format('MM/DD/YYYY');
    var jsonObject = {
        'userAbrhs': misSession.userabrhs,
        'changeWeek': _changeWeek,
    };
    calltoAjax(misApiUrl.fetchWeekInfo, "POST", jsonObject,
        function (result) {
            successFetchWeek(result);
        });
}

function successFetchWeek(msg) {
    var result = msg;
    if (result != undefined) {
        $('#lblSelectedWeek').html("Week # " + result.WeekNo + " (" + result.DisplayStartDate + " - " + result.DisplayEndDate + ")");
        _selectedWeek = result.WeekNo;
        _selectedYear = result.Year;
        _startDate = new Date(result.DisplayStartDate);
        _endDate = new Date(result.DisplayEndDate);
        fetchCompletedTimeSheets();
        fetchPendingTimeSheets();
    }
}


function fetchCompletedTimeSheets() {
    var jsonObject = {
        'weekNo': _selectedWeek,
        'year': _selectedYear,
        'userAbrhs': misSession.userabrhs,
        'menuAbrhs': misPermissions.menuAbrhs
    };
    calltoAjax(misApiUrl.fetchCompletedTimeSheets, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tbldivCompleteReviewReviewList").dataTable({
                "responsive": true,
                "autoWidth": false,
                "paging": true,
                "bDestroy": true,
                "ordering": true,
                "order": [],
                "info": true,
                "deferRender": true,
                "aaData": data,
                "aoColumns": [
                  {
                      "mData": null,
                      "sTitle": "Employee Name",
                      mRender: function (data, type, row) {
                          var html = data.EmployeeName + "";//<span class='spnError' style='display:" + data.Applicant + "'>*</span>
                          return html;
                      }
                  },
                  {
                      "mData": null,
                      "sTitle": "Manager Name",
                      mRender: function (data, type, row) {
                          var html = data.ManagerName + "";//<span class='spnError' style='display:" + data.Reviewer + "'>*</span>
                          return html;
                      }
                  },
                    {
                        "mData": "TotalHoursLogged",
                        "sTitle": "Total Hours Logged",
                    },
                ]
            });
        });
}

function fetchPendingTimeSheets() {
    var jsonObject = {
        'weekNo': _selectedWeek,
        'year': _selectedYear,
        'userAbrhs': misSession.userabrhs,
        'menuAbrhs': misPermissions.menuAbrhs
    };
    calltoAjax(misApiUrl.fetchPendingTimeSheets, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tbldivInCompleteReviewList").dataTable({
                "responsive": true,
                "autoWidth": false,
                "paging": true,
                "bDestroy": true,
                "ordering": true,
                "order": [],
                "info": true,
                "deferRender": true,
                "aaData": data,
                "aoColumns": [
                     {
                         "mData": null,
                         "sTitle": "Employee Name",
                         mRender: function (data, type, row) {
                             var html = data.EmployeeName + "<span class='spnError' style='display:" + data.Applicant + "'>*</span>";
                             return html;
                         }
                     },
                     {
                         "mData": null,
                         "sTitle": "Manager Name",
                         mRender: function (data, type, row) {
                             var html = data.ManagerName + "<span class='spnError' style='display:" + data.Reviewer + "'>*</span>";
                             return html;
                         }
                     },
                ]
            });
        });
}

