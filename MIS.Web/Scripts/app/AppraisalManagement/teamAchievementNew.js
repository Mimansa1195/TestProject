var goalCycleId;
$(function () {
    bindAllReportingEmployees();
    $('#ddlEmployeeForAchievemet').multiselect({
        includeSelectAllOption: true,
        enableFiltering: true,
        enableCaseInsensitiveFiltering: true,
        buttonWidth: false,
        onDropdownHidden: function (event) {
        }
    });
    $("#ddlEmployeeForAchievemet").change(function () {
        getTeamAchievement();
    });

    $("#financialYearForTeamAchievement").change(function () {
        getTeamAchievement();
    });
});

function bindAllReportingEmployees() {
    $("#ddlEmployeeForAchievemet").multiselect('destroy');
    $("#ddlEmployeeForAchievemet").empty();
    $('#ddlEmployeeForAchievemet').multiselect();
    calltoAjax(misApiUrl.getAllEmployeesReportingToUser, "POST", '',
        function (result) {
            if (result != null && result.length > 0) {

                for (var x = 0; x < result.length; x++) {
                    $("#ddlEmployeeForAchievemet").append("<option value = '" + result[x].EmployeeAbrhs + "'>" + result[x].EmployeeName + "</option>");
                }
                $('#ddlEmployeeForAchievemet').multiselect("destroy");
                $('#ddlEmployeeForAchievemet').multiselect({
                    includeSelectAllOption: true,
                    enableFiltering: true,
                    enableCaseInsensitiveFiltering: true,
                    buttonWidth: false,
                    onDropdownHidden: function (event) {
                    }
                });
                $("#ddlEmployeeForAchievemet").multiselect('selectAll', false);
                $("#ddlEmployeeForAchievemet").multiselect('updateButtonText');
                bindFinancialYearForTeamAchievement();
            }
        });
}

function bindFinancialYearForTeamAchievement() {
    var jsonObject = {
        forTeam: true
    }
    calltoAjax(misApiUrl.getAllGoalCycleIdToViewAchievement, "POST", jsonObject,
        function (result) {
            if (result.length > 0) {
                $("#financialYearForTeamAchievement").empty();
                $("#financialYearForTeamAchievement").append("<option value='0'>All</option>");
                $.each(result, function (index, result) {
                    var frmyear = result.AppraisalYear;
                    var endYear = result.AppraisalYear + 1;
                    var FY = frmyear + " - " + endYear;
                    $("#financialYearForTeamAchievement").append("<option value=" + result.GoalCycleId + ">" + result.FinancialYearName + "</option>");
                });
                $("#financialYearForTeamAchievement").val(result[0].GoalCycleId);
                var goalCycleId = result[0].GoalCycleId;
                $("#txtHiddenGoalCycleId").val(goalCycleId);
                getTeamAchievement();
            }
        });
}

function getTeamAchievement() {
    var userAbrhs = "";
    if ($('#ddlEmployeeForAchievemet').val() !== null) {
        userAbrhs = $('#ddlEmployeeForAchievemet').val().join(",");
    }
    var jsonObject = {
        achievementCycleId: $("#financialYearForTeamAchievement").val(),
        userAbrhs: userAbrhs
    };
    calltoAjax(misApiUrl.getTeamsAchievement, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblViewTeamAchievementsList").dataTable({
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
                                columns: [0, 1, 2, 3, 6, 7, 8, 9],
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
                        "mData": "AppraisalYear",
                        "sTitle": "Appraisal Year",
                        "swidth": "80px"
                    },
                    {
                        "mData": "SubmittedDate",
                        "sTitle": "Submitted On",
                        "swidth": "80px"
                    },
                    {
                        "mData": null,
                        "sTitle": "Achievements",
                        "sClass": "none",
                        "sWidth": "200px",
                        mRender: function (data, type, row) {
                            var length = data.AchievementData.length;
                            var html = "";
                            for (var i = 0; i < length; i++) {
                                html = html + '<br><br>' + data.AchievementData[i].Achievement;
                            }
                            return html;
                        }
                    },
                ],
                //'rowCallback': function (row, data, dataIndex) {
                //    var table = $("#tblViewTeamAchievementsList").DataTable();
                //    table.columns([0, 1, 2, 3]).visible(false);
                //},
                "fnInitComplete": function (row) {
                    //if (typeof (data) == 'undefined' || data === null || !(data.length > 0)) {
                    var table = $("#tblViewTeamAchievementsList").DataTable();
                    table.columns([0, 1, 2, 3]).visible(false);
                    //}
                }
            });
        }

    );
}


