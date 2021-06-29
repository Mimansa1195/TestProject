$(document).ready(function () {
    fetchProjectsAssignedToUser();
    showHideSubscriptionTab();
    bindExcludedUsers();
    bindEligibleTimesheetUsers();
    $('#btnSavePrefrences').click(function (e) {
        var selectedProjects = [];
        $("#tblProjectList").dataTable().$('input[type="checkbox"]').each(function () {
            if (this.checked) {
                selectedProjects.push($(this).val());
            }
        });
        savePrefrences(selectedProjects);
    });
});
//to hide this tab from user and trainee
function showHideSubscriptionTab() {
    var jsonObject = {
        userAbrhs: misSession.userabrhs
    }
    calltoAjax(misApiUrl.getUserDetailsByUserId, "POST", jsonObject,
        function (result) {
            if (result.RoleId == 1 || result.RoleId == 2 || result.RoleId == 3) {
                document.getElementById('hideTab').style.display = 'block';
                $("#changeHeading").html("Manage Projects And Timesheets");
            }
        });
}
function fetchProjectsAssignedToUser() {
    var jsonObject = {
        userAbrhs: misSession.userabrhs
    }
    calltoAjax(misApiUrl.fetchProjectsAssignedToUser, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblProjectList").dataTable({
                "responsive": true,
                "autoWidth": false,
                "paging": false,
                "bDestroy": true,
                "ordering": false,
                "order": [], 
                "info": false,
                "deferRender": false,
                "aaData": data,
                "aoColumns": [
                    {
                        'targets': 0,
                        'searchable': false,
                        'width': '1%',
                        'orderable': false,
                        'bSortable': false,
                        "sTitle": "#",
                        'className': 'dt-body-center',
                        'render': function (data, type, full, meta) {
                            if (full.Selected) {
                                return '<input type="checkbox" name="id[' + full.ProjectId + ']" value="' + full.ProjectId + '" checked="' + full.Selected + '">';
                            }
                            else {
                                return '<input type="checkbox" name="id[' + full.ProjectId + ']" value="' + full.ProjectId + '">';
                            }
                            
                        }
                    },
                    {
                        "mData": "ProjectName",
                        "sTitle": "Project Name",
                    },
                    {
                        "mData": "ParentProject",
                        "sTitle": "Parent Project",
                    },
                    {
                        "mData": "Role",
                        "sTitle": "Role",
                    },
                ]
            });

        });
}
function savePrefrences(selectedProjects) {
    var selectedProjects = selectedProjects.join();
    var jsonObject = {
        selectedProjects: selectedProjects,
        userAbrhs: misSession.userabrhs
    }
    calltoAjax(misApiUrl.saveProjectPrefrences, "POST", jsonObject,
        function (result) {
            fetchProjectsAssignedToUser();
            misAlert("Projects has been Assigned successfully.", 'Success', 'success');
        });
}
function bindExcludedUsers() {
    calltoAjax(misApiUrl.listExcludedUsersForTimesheeet, "POST", ' ' ,
        function (result) {
            if (result == null) {
                return;
            }
            $("#lstAllExcludedUsers").empty();
            $.each(result, function (idx, item) {
                $("#lstAllExcludedUsers").append($("<option></option>").val(item.MaxValue).html(item.Text));
             });
        });
}
function bindEligibleTimesheetUsers() {
    calltoAjax(misApiUrl.listEligibleUsersForTimesheeet, "POST", ' ' ,
        function (result) {
            if (result == null) {
                return;
            }
            $("#lstAllEligibleUsers").empty();
            $.each(result, function (idx, item) {
                $("#lstAllEligibleUsers").append($("<option></option>").val(item.MaxValue).html(item.Text));
            });
        });
}
$('#btnAddUser').click(function () {
    var endIndex = $('#lstAllExcludedUsers option:selected').length;
    if (endIndex == 0)
    misAlert("Please select employee.", 'Warning', 'warning');
    var combo1 = document.getElementById("lstAllExcludedUsers");
    var employeeAbrhs = combo1.options[combo1.selectedIndex].value;
    changeUserToEligible(employeeAbrhs);
    $('#lstAllExcludedUsers option:selected').slice(0, 1).appendTo('#lstAllEligibleUsers');
});
$('#btnRemoveUser').click(function () {
    var endIndex = $('#lstAllEligibleUsers option:selected').length;
    if (endIndex == 0)
        misAlert("Please select employee.", 'Warning', 'warning');
    var combo1 = document.getElementById("lstAllEligibleUsers");
    var employeeAbrhs = combo1.options[combo1.selectedIndex].value;
    excludeUser(employeeAbrhs);
    $('#lstAllEligibleUsers option:selected').slice(0, 1).appendTo('#lstAllExcludedUsers');
});
function changeUserToEligible(employeeAbrhs) {
    var jsonObject = {
        employeeAbrhs: employeeAbrhs
       }
    calltoAjax(misApiUrl.changeUserToEligibleForTimesheet, "POST", jsonObject,
        function (result) {
            misAlert("User marked as eligible to fill timesheets.", 'Success', 'success');
        });
}
function excludeUser(employeeAbrhs) {
    var jsonObject = {
        employeeAbrhs: employeeAbrhs
    }
    calltoAjax(misApiUrl.excludeUserForTimesheet, "POST", jsonObject,
        function (result) {
            misAlert("User marked as ineligible to fill timesheets.", 'Success', 'success');
        });
}
