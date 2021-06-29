var _isAdminMode = false;
var _verticalId = 0;
var _projectId = 0;
var _mode = 0;
var _selectedNode;
var _role = "";

$(document).ready(function () {
    fetchRoleforCurrentUser();
    listTeamMembersforSelectedProject(0, 2);
    fetchSelectedProjectInfo(0);
});

$('#btnProjectPopup').click(function (e) {
    if (!validateControls('popupWindowProjectInfo')) {
        return false;
    }

    var name = $('#txtProjectName').val().trim();
    var description = $('#txtProjectDescription').val().trim();
    var industryTypeId = $('#ddlProjectIndustryType').val();
    var startDate = $('#txtProjectStartDate input').val().trim();
    var endDate = $('#txtProjectEndDate input').val().trim();
    var statusId = $('#ddlProjectStatus').val().trim();
    //if (name === "") {
    //    misAlert('Please enter Project Name.', 'Error', 'error');
    //    $('#txtProjectName').focus();
    //}
    //else if (industryTypeId === '0') {
    //    misAlert('Please Select Industry Type.', 'Error', 'error');

    //    $('#ddlProjectIndustryType').focus();
    //}
    //else if (statusId === '0') {
    //    misAlert('Please Select Project Status', 'Error', 'error');

    //    $('#ddlProjectStatus').focus();
    //} else
    {
        if (_mode === 0) { // create project
            saveProject(name, description, industryTypeId, startDate, endDate, statusId);
        } else {
            updateProject(name, description, industryTypeId, startDate, endDate, statusId);
        }
    }
});

$('#btnShareDocumentAdd').click(function () {
    var endIndex = $('#lstBoxShareDocAllUser option:selected').length;
    var combo1 = document.getElementById("lstBoxShareDocAllUser");
    var employeeAbrhs = combo1.options[combo1.selectedIndex].value;
    var projectId = $('#txtShareDocId').val();
    assignTeamMember(projectId, employeeAbrhs);
    $('#lstBoxShareDocAllUser option:selected').slice(0, 1).appendTo('#lstBoxShareDocSharedUser');
});

$('#btnShareDocumentRemove').click(function () {
    var projectId = $('#txtShareDocId').val();
    var combo1 = document.getElementById("lstBoxShareDocSharedUser");
    var employeeAbrhs = combo1.options[combo1.selectedIndex].value;
    unAssignTeamMember(projectId, employeeAbrhs);
    $('#lstBoxShareDocSharedUser option:selected').slice(0, 1).appendTo('#lstBoxShareDocAllUser');
});

function fetchRoleforCurrentUser() {
    var jsonObject = {
        'userAbrhs': misSession.userabrhs
    }
    calltoAjax(misApiUrl.fetchPimcoRoleforCurrentUser, "POST", jsonObject,
        function (result) {
            if (result === "Web Administrator" || result === "MIS Administrator" || result === "Management") {
                $("#h1").html("<strong>Verticals</strong>");
                _isAdminMode = true;
            } else {
                $("#h1").html("<strong>Projects</strong>");
                _isAdminMode = false;
            }
            listTreeRoots();
        });
}


function listTreeRoots() {
    bindTree();
    if (_isAdminMode) {
        var jsonObject = {
            'userAbrhs': misSession.userabrhs
        }
        calltoAjax(misApiUrl.listPimcoActiveVerticals, "POST", jsonObject,
            function (result) {
                $("#ProjectsTree").dynatree("getRoot").removeChildren();
                if (result == null) {
                    return;
                }
                for (i = 0; i < result.length; i++) {
                    $("#ProjectsTree").dynatree("getRoot").addChild({ title: result[i].Vertical, isFolder: true, key: result[i].VerticalId, isLazy: true, expand: false });
                }
            });
    } else {
        var jsonObject = {
            'userAbrhs': misSession.userabrhs
        }
        calltoAjax(misApiUrl.listPimcoRootProjects, "POST", jsonObject,
            function (result) {
                $("#ProjectsTree").dynatree("getRoot").removeChildren();
                if (result == null) {
                    return;
                }
                for (i = 0; i < result.length; i++) {
                    $("#ProjectsTree").dynatree("getRoot").addChild({ title: result[i].Name, isFolder: true, key: result[i].PimcoProjectId, verticalId: result[i].VerticalId, isLazy: true, expand: false });
                }
            });
    }
}

//=======Tree starts here==========

function bindTree() {
    $(function () {
        $("#ProjectsTree").dynatree({
            selectMode: 1,
            title: "Project Tree",
            onQueryActivate: function (activate, node) {
            },
            onActivate: function (node) {
                if (node.data.title != "No Verticals" || node.data.title != "No Projects") {
                }
            },
            onDeactivate: function (node) {
            },
            onQuerySelect: function (select, node) {
            },
            onSelect: function (select, node) {
                fetchVerticalIdandParentId(node);
            },
            onQueryExpand: function (expand, node) {
            },
            onExpand: function (expand, node) {
            },
            onLazyRead: function (node) {
                listProjects(node);
            },
            onFocus: function (node) {
                node.scheduleAction("activate", 2000);
            },
            onBlur: function (node) {
            },
            onClick: function (node, event) {
                node.select();
            },
            onDblClick: function (node, event) {
            },
            onKeydown: function (node, event) {
                switch (event.which) {
                    case 32: // [space]
                        return false;
                }
            },
            onCreate: function (node, span) {
                bindContextMenu(node, span);
            },
            onKeypress: function (node, event) {
            },
            onKeydown: function (node, event) {
                if ($(".contextMenu:visible").length > 0)
                    return false;

                switch (event.which) {
                    case 32: // [Space]
                        $(node.span).trigger("mousedown", {
                            preventDefault: true,
                            button: 2
                        })
                            .trigger("mouseup", {
                                preventDefault: true,
                                pageX: node.span.offsetLeft,
                                pageY: node.span.offsetTop,
                                button: 2
                            });
                        return false;
                    case 67:
                        if (event.ctrlKey) { // Ctrl-C
                            copyPaste("copy", node);
                            return false;
                        }
                        break;
                    case 86:
                        if (event.ctrlKey) { // Ctrl-V
                            copyPaste("paste", node);
                            return false;
                        }
                        break;
                    case 88:
                        if (event.ctrlKey) { // Ctrl-X
                            copyPaste("cut", node);
                            return false;
                        }
                        break;
                }
            },
        });
    });
}

function bindContextMenu(node, span) {
    $(span).contextMenu({ menu: "myMenu" }, function (action, el, pos) {
        clipboardNode = null;
        switch (action) {
            case "AddProject":
                clipboardNode = node;
                initAddProject(node);
                break;
            default:
                alert("Todo: appply action '" + action + "' to node " + node);
        }
    });
}

//=======Tree ends here==========

function initAddProject(node) {
    _mode = 0;
    fetchVerticalIdandParentId(node);
    if (_role === "Team Member") {
        misAlert("You don't have permissions to add Project to this project", 'Error', 'error');

    } else {
        showProjectPopup(0);
    }


}

//function ListActiveProjectIndustryType(industryTypeId) {
//    $('#ddlProjectIndustryType').empty();
//    $('#ddlProjectIndustryType').append('<option value=0>Select</option>');
//    var jsonObject = {
//        'userAbrhs': misSession.userabrhs
//    }
//    calltoAjax(misApiUrl.listPimcoActiveProjectIndustryType, "POST", jsonObject,
//        function (result) {
//            if (result != null && result.length > 0) {
//                for (var r = 0; r < result.length; r++) {
//                    $('#ddlProjectIndustryType').append('<option value=' + result[r].IndustryTypeId + '>' + result[r].IndustryType + '</option>');
//                }
//                if (industryTypeId > 0) {
//                    $('#ddlProjectIndustryType').val(industryTypeId);
//                }
//            }
//        });
//}

function ListActiveProjectStatus(statusId) {
    $('#ddlProjectStatus').empty();
    $('#ddlProjectStatus').append('<option value=0>Select</option>');
    var jsonObject = {
        'userAbrhs': misSession.userabrhs
    }
    calltoAjax(misApiUrl.listPimcoActiveProjectStatus, "POST", jsonObject,
        function (result) {
            if (result != null && result.length > 0) {
                for (var r = 0; r < result.length; r++) {
                    $('#ddlProjectStatus').append('<option value=' + result[r].ProjectStatusId + '>' + result[r].ProjectStatus + '</option>');
                }
                if (statusId > 0) {
                    $('#ddlProjectStatus').val(statusId);
                }
            }
        });
}

function fetchVerticalIdandParentId(node) {
    var selectedId = node.data.key;
    _selectedNode = node;
    if (_isAdminMode) {
        var path = node.getKeyPath().split("/");
        if (path.length === 2) {
            _verticalId = selectedId;
            _parentProjectId = 0;
        } else {
            _parentProjectId = selectedId;
            fetchSelectedProjectInfo(selectedId);
            listTeamMembersforSelectedProject(selectedId, 1);
        }
    } else {
        _parentProjectId = selectedId;
        fetchSelectedProjectInfo(selectedId);
        listTeamMembersforSelectedProject(selectedId, 1);
    }
}

function fetchSelectedProjectInfo(projectId) {
    var jsonObject = {
        'projectId': projectId,
        'userAbrhs': misSession.userabrhs
    }
    calltoAjax(misApiUrl.fetchPimcoSelectedProjectInfo, "POST", jsonObject,
        function (result) {
            if (result.length > 0) {
                //if (result[0].Role === "Project Owner") {
                var pTeamLead = false;
                var pOwner = false;
                //var pMember = false;
                if (result[0].Role === "Project Owner" || misSession.roleid === "1" || misSession.roleid === "2") {
                    pOwner = true;
                }
                if (result[0].Role === "Team Leader") {
                    pTeamLead = true;
                }

                //if (result[0].Role === "Team Member") {
                //    pMember = true;
                //}
                var data = $.parseJSON(JSON.stringify(result));
                $("#tblProjectInfoList").dataTable({
                    "responsive": true,
                    "autoWidth": false,
                    "paging": true,
                    "bDestroy": true,
                    "ordering": true,
                    "order": [],
                    "info": true,
                    "deferRender": false,
                    "aaData": data,
                    "aoColumns": [
                        {
                            "mData": "ProjectName",
                            "sTitle": "Project Name",
                        },
                        {
                            "mData": "ProjectDescription",
                            "sTitle": "Proj. Desc.",
                        },
                        {
                            "mData": "ShowStartDate",
                            "sTitle": "Start Date",
                        },
                        {
                            "mData": "ShowEndDate",
                            "sTitle": "End Date",
                        },
                        {
                            "mData": "Owners",
                            "sTitle": "Owners",
                        },
                        {
                            "mData": "NoofActiveTeamMembers",
                            "sTitle": "No. of TMs",
                        },
                        {
                            "mData": "CurrentStatus",
                            "sTitle": "Status",
                        },
                        {
                            "mData": null,
                            "sTitle": "Owners",
                            'bSortable': false,
                            "sClass": "text-left",
                            "visible": pOwner,
                            mRender: function (data, type, row) {
                                html = '<button type="button" class="btn btn-sm teal" data-toggle"model" data-target="#mypopupViewDocModal"' + 'onclick="manageTeam(' + row.ProjectId + ',\'' + row.ProjectName + '\',\'Owners\')"  title="Add Owners"><i class="fa fa-share-alt"> </i></button>';
                                return html;
                            }
                        },
                        {
                            "mData": null,
                            "sTitle": "TLs",
                            'bSortable': false,
                            "sClass": "text-left",
                            "visible": pOwner,
                            mRender: function (data, type, row) {
                                html = '<button type="button" class="btn btn-sm teal" data-toggle"model" data-target="#mypopupViewDocModal"' + 'onclick="manageTeam(' + row.ProjectId + ',\'' + row.ProjectName + '\',\'TL\')"  title="Add TL"><i class="fa fa-share-alt"> </i></button>';
                                return html;
                            }
                        },
                        {
                            "mData": null,
                            "sTitle": "Team",
                            'bSortable': false,
                            "sClass": "text-left",
                            "visible": pOwner || pTeamLead,
                            mRender: function (data, type, row) {
                                html = '<button type="button" class="btn btn-sm teal" data-toggle"model" data-target="#mypopupViewDocModal"' + 'onclick="manageTeam(' + row.ProjectId + ',\'' + row.ProjectName + '\',\'Team\')"  title="Add Team"><i class="fa fa-share-alt"> </i></button>';
                                return html;
                            }
                        },
                        {
                            "mData": null,
                            "sTitle": "Edit",
                            'bSortable': false,
                            "sClass": "text-left",
                            "visible": pOwner,
                            mRender: function (data, type, row) {
                                html = '<button type="button" class="btn btn-sm teal" data-toggle"model" data-target="#mypopupViewDocModal"' + 'onclick="editProject(' + row.ProjectId + ')"  title="Edit"><i class="fa fa-edit"> </i></button>';
                                return html;
                            }
                        },
                    ]
                });
                _verticalId = result[0].VerticalId;
                _role = result[0].Role;
                //}
            }
            else {
                var data = $.parseJSON(JSON.stringify(null));
                $("#tblProjectInfoList").dataTable({
                    "responsive": true,
                    "autoWidth": false,
                    "paging": true,
                    "bDestroy": true,
                    "ordering": true,
                    "order": [],
                    "info": true,
                    "deferRender": false,
                    "aaData": data,
                    "aoColumns": [
                        {
                            "mData": "ProjectName",
                            "sTitle": "Project Name",
                        },
                        {
                            "mData": "ProjectDescription",
                            "sTitle": "Description",
                        },
                        {
                            "mData": "ShowStartDate",
                            "sTitle": "Start Date",
                        },
                        {
                            "mData": "ShowEndDate",
                            "sTitle": "End Date",
                        },
                        {
                            "mData": "Owners",
                            "sTitle": "Owners",
                        },
                        {
                            "mData": "NoofActiveTeamMembers",
                            "sTitle": "No. of TMs",
                        },
                        {
                            "mData": "CurrentStatus",
                            "sTitle": "Status",
                        },
                        {
                            "mData": null,
                            "sTitle": "Owners",
                            'bSortable': false,
                            "sClass": "text-left",
                            mRender: function (data, type, row) {
                                html = '<button type="button" class="btn btn-sm teal" data-toggle"model" data-target="#mypopupViewDocModal"' + 'onclick="manageTeam(' + row.ProjectId + ',\'' + row.ProjectName + '\',\'Owners\')" data-toggle="tooltip" title="Add Owners"><i class="fa fa-share-alt"> </i></button>';
                                return html;
                            }
                        },
                        {
                            "mData": null,
                            "sTitle": "TLs",
                            'bSortable': false,
                            "sClass": "text-left",
                            mRender: function (data, type, row) {
                                html = '<button type="button" class="btn btn-sm teal" data-toggle"model" data-target="#mypopupViewDocModal"' + 'onclick="manageTeam(' + row.ProjectId + ',\'' + row.ProjectName + '\',\'TL\')" data-toggle="tooltip" title="Add TL"><i class="fa fa-share-alt"> </i></button>';
                                return html;
                            }
                        },
                        {
                            "mData": null,
                            "sTitle": "Team",
                            'bSortable': false,
                            "sClass": "text-left",
                            mRender: function (data, type, row) {
                                html = '<button type="button" class="btn btn-sm teal" data-toggle"model" data-target="#mypopupViewDocModal"' + 'onclick="manageTeam(' + row.ProjectId + ',\'' + row.ProjectName + '\',\'Team\')" data-toggle="tooltip" title="Add Team"><i class="fa fa-share-alt"> </i></button>';
                                return html;
                            }
                        },
                        {
                            "mData": null,
                            "sTitle": "Edit",
                            'bSortable': false,
                            "sClass": "text-left",
                            mRender: function (data, type, row) {
                                html = '<button type="button" class="btn btn-sm teal" data-toggle"model" data-target="#mypopupViewDocModal"' + 'onclick="editProject(' + row.ProjectId + ')" data-toggle="tooltip" title="Edit"><i class="fa fa-edit"> </i></button>';
                                return html;
                            }
                        },
                    ]
                });
            }
        });
}

function listTeamMembersforSelectedProject(projectId, isActive) {

    _projectId = projectId;
    var jsonObject = {
        'projectId': projectId,
        'userAbrhs': misSession.userabrhs
    }
    calltoAjax(misApiUrl.listPimcoTeamMembersforSelectedProject, "POST", jsonObject,
        function (result) {
            if (result.length != 0) {

                var activeEmployeesData = [], inActiveEmployeesData = [];
                var data;
                activeEmployeesData = getAllMatchedObject({ Status: 'Active' }, result);
                inActiveEmployeesData = getAllMatchedObject({ Status: 'Inactive' }, result);

                if (isActive === 1)
                    loadTeamMembersforSelectedProject(activeEmployeesData);
                else if (isActive === 0)
                    loadTeamMembersforSelectedProject(inActiveEmployeesData);
                else
                    loadTeamMembersforSelectedProject(result);
            }
            else {
                loadTeamMembersforSelectedProject("");
            }
        });

}

function loadTeamMembersforSelectedProject(listOfData) {
    var data = listOfData;
    $("#tblTeamInfoList").html("");
    $("#tblTeamInfoList").dataTable({
        "responsive": true,
        "autoWidth": false,
        "paging": true,
        "bDestroy": true,
        "ordering": true,
        "order": [],
        "info": true,
        "deferRender": false,
        "aaData": data,
        "aoColumns": [
            {
                "mData": null,
                "sTitle": "Name",
                'bSortable': false,
                "sClass": "text-left",
                "sWidth": "100px",
                mRender: function (data, type, row) {
                    return row.FirstName + " " + row.LastName;
                }
            },
            {
                "mData": "Role",
                "sTitle": "Role",
            },
            {
                "mData": "ShowStartedFrom",
                "sTitle": "Started From",
            },
            {
                "mData": null,
                "sTitle": "Left On",
                'bSortable': false,
                "sClass": "text-left",
                "sWidth": "100px",
                mRender: function (data, type, row) {
                    return toddMMMyyy(row.LeftOn);
                }
            },
            {
                "mData": "Status",
                "sTitle": "Status",
            },
            {
                "mData": "NoofTotalProjects",
                "sTitle": "No. of Total Projects",
            },
        ]
    });
}

function showProjectPopup(mode) {
    $('#txtProjectStartDate').datepicker({
        format: "mm/dd/yyyy",
        autoclose: true,
        todayHighlight: true
    }).on('changeDate', function (ev) {
        var fromStartDate = new Date(ev.date.valueOf());
        $('#txtProjectEndDate input').val('');
        $('#txtProjectEndDate').datepicker('setStartDate', fromStartDate).trigger('change');
    });

    $('#txtProjectEndDate').datepicker({
        format: "mm/dd/yyyy",
        autoclose: true,
        todayHighlight: true
    });


    //$('#txtProjectStartDate').datepicker({
    //    autoclose: true,
    //    changeMonth: true,
    //    changeYear: true,
    //    showOn: "button",
    //    buttonImage: "Images/datePicker.png",
    //    buttonImageOnly: true
    //});
    //$('#txtProjectEndDate').datepicker({
    //    autoclose: true,
    //    changeMonth: true,
    //    changeYear: true,
    //    showOn: "button",
    //    buttonImage: "Images/datePicker.png",
    //    buttonImageOnly: true
    //});
    if (mode === 0) {
        ListActiveProjectIndustryType(0);
        ListActiveProjectStatus(0);
        $('#modalTitle').text('Add New Project');
        $('#btnProjectPopup').html('Save');
        $('#txtProjectName').val('');
        $('#txtProjectDescription').val('');
        $('#ddlProjectIndustryType').val('0');
        $('#txtProjectEndDate input').val('');
        $('#ddlProjectStatus').val('0');
    } else {
        $('#modalTitle').text('Modify Project Info.');
        $('#btnProjectPopup').html('Update');
        fetchProjectInfo();
    }

    $('input').removeClass('error-validation');
    $('select').removeClass('error-validation');

    $('#popupWindowProjectInfo').modal("show");
}

function saveProject(name, description, industryTypeId, startDate, endDate, statusId) {
    var jsonObject = {
        'name': name,
        'description': description,
        'industryTypeId': industryTypeId,
        'startDate': startDate,
        'endDate': endDate,
        'statusId': statusId,
        'parentProjectId': _parentProjectId,
        'verticalId': _verticalId,
        'userAbrhs': misSession.userabrhs
    }
    calltoAjax(misApiUrl.savePimcoProject, "POST", jsonObject,
        function (result) {
            if (result === false) {
                misAlert(msg.Message, "error");
                $("#popupWindowProjectInfo").modal("hide");
            }
            else {
                misAlert("Project saved successfully", "Success", "success");
                $("#popupWindowProjectInfo").modal("hide");
            }
            listProjects(_selectedNode);
        });
}

function updateProject(name, description, industryTypeId, startDate, endDate, statusId) {
    var jsonObject = {
        'PimcoProjectId': _projectId,
        'Name': name,
        'Description': description,
        'IndustryTypeId': industryTypeId,
        'StartDate': startDate,
        'EndDate': endDate,
        'StatusId': statusId,
        'UserAbrhs': misSession.userabrhs
    }
    calltoAjax(misApiUrl.updatePimcoProject, "POST", jsonObject,
        function (result) {
            if (result === false) {
                misAlert("Error", "Error", "error");
                $("#popupWindowProjectInfo").modal("hide");
            }
            else {
                misAlert("Project updated successfully", "Success", "success");
                $("#popupWindowProjectInfo").modal("hide");
            }
            fetchSelectedProjectInfo(_projectId);
        });
}

function listProjects(node) {
    fetchVerticalIdandParentId(node);
    var jsonObject = {
        'verticalId': _verticalId,
        'parentProjectId': _parentProjectId,
        'userAbrhs': misSession.userabrhs
    }
    calltoAjax(misApiUrl.listPimcoProjects, "POST", jsonObject,
        function (result) {
            if (result == null) {
                node.setLazyNodeStatus(DTNodeStatus_Ok);
                return;
            }

            if (node && node.childList && node.childList.length > 0) {
                node.removeChildren();
            }

            for (var i = 0; i < result.length; i++) {
                node.addChild({ title: result[i].Name, isFolder: true, key: result[i].PimcoProjectId, isLazy: true, expand: false });
            }
        });
}
_addMemberRole = '';
function manageTeam(projectId, projectName, role) {
    if (role === "Owners") {
        _addMemberRole = "Project Owners";
    }
    else if (role === "TL") {
        _addMemberRole = "Team Leaders";
    }
    else if (role === "Team") {
        _addMemberRole = "Team Members";
    }
    document.getElementById('lblbShareDocTitle').innerHtml = projectId;
    document.getElementById('lstBoxShareDocAllUser').length = 0;
    document.getElementById('lstBoxShareDocSharedUser').length = 0;
    document.getElementById('txtShareDocId').value = projectId;
    $('#modalTitle').text(_addMemberRole + " for " + projectName);
    $('#popupWindowShareDocument').modal("show");
    $('#hUsers').html("Available Users");
    $('#hSharedUsers').html(_addMemberRole);
    listAllUsersAvailableForProject(projectId);
    listAllUsersAssignedToProject(projectId, _addMemberRole.replace('s', ''));
}

function listAllUsersAvailableForProject(projectId) {
    var jsonObject = {
        'projectId': projectId,
        'userAbrhs': misSession.userabrhs
    }
    calltoAjax(misApiUrl.listPimcoAllUsersAvailableForProject, "POST", jsonObject,
        function (result) {
            if (result == null) {
                return;
            }
            $("#lstBoxShareDocAllUser").empty();
            $.each(result, function (idx, item) {
                $("#lstBoxShareDocAllUser").append("<option value=" + item.EmployeeAbrhs + ">" + item.EmployeeName + "</option>");
            });
        });
}

function listAllUsersAssignedToProject(projectId, role) {
    var jsonObject = {
        'projectId': projectId,
        'role': role,
        'userAbrhs': misSession.userabrhs
    }
    calltoAjax(misApiUrl.listPimcoAllUsersAssignedToProject, "POST", jsonObject,
        function (result) {
            if (result == null) {
                return;
            }
            $("#lstBoxShareDocSharedUser").empty();
            $.each(result, function (idx, item) {
                $("#lstBoxShareDocSharedUser").append("<option value=" + item.EmployeeAbrhs + ">" + item.EmployeeName + "</option>");
            });
        });
}

function assignTeamMember(projectId, employeeAbrhs) {
    var jsonObject = {
        'PimcoProjectId': projectId,
        'EmployeeAbrhs': employeeAbrhs,
        'ProjectRole': _addMemberRole.replace('s', ''),
        'UserAbrhs': misSession.userabrhs
    }
    calltoAjax(misApiUrl.assignPimcoTeamMember, "POST", jsonObject,
        function (result) {
            fetchSelectedProjectInfo(_parentProjectId);
            listTeamMembersforSelectedProject(_parentProjectId, 1);
        });
}

function unAssignTeamMember(projectId, employeeAbrhs) {
    var jsonObject = {
        'PimcoProjectId': projectId,
        'EmployeeAbrhs': employeeAbrhs,
        'ProjectRole': _addMemberRole.replace('s', ''),
        'UserAbrhs': misSession.userabrhs
    }
    calltoAjax(misApiUrl.unAssignPimcoTeamMember, "POST", jsonObject,
        function (result) {
            fetchSelectedProjectInfo(_parentProjectId);
            listTeamMembersforSelectedProject(_parentProjectId, 0);
        });
}

function editProject(projectId) {
    _mode = 1;
    _projectId = projectId;
    showProjectPopup(1);
}

$("#btnCloseAddProject").click(function () {
    $("#popupWindowProjectInfo").modal("hide");
});

$("#btnCloseGroups").click(function () {
    $("#popupWindowShareDocument").modal("hide");
});

$(".project-data button").on('click', function () {
    $(".project-data button").removeClass("active");
    $(this).addClass("active");
    var state = $(this).attr("data-attr-state");
    var state1;
    if (state == "active") {
        state1 = 1;

    }
    else if (state == "inactive") {
        state1 = 0;
    }
    else {
        state1 = 2
    }
    listTeamMembersforSelectedProject(_projectId, state1);
});

