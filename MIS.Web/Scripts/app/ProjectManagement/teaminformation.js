$(document).ready(function () {
    listAllProjectsCreatedByUser();
});

function listAllProjectsCreatedByUser() {
    ShowProgressAsync('#centerPanel', true, "Error");
    CallAjaxToGet('ListProjectsCreatedByUser', [], function (msg) { successfulListProjectsCreatedByUser(msg); }, function (xhr, status, error) { errorListProjectsCreatedByUser(xhr, status, error); });
}

function successfulListProjectsCreatedByUser(msg) {
    bindProjectTree();
    $("#ProjectsTree").dynatree("getRoot").removeChildren();
    if (msg.d == null) {
        HideProgressAsync();
        return;
    }
    for (i = 0; i < msg.d.length; i++) {
        $("#ProjectsTree").dynatree("getRoot").addChild({ title: msg.d[i].ProjectName, isFolder: false, key: msg.d[i].ProjectId, isLazy: false, expand: false });
        HideProgressAsync();
    }
    HideProgressAsync();
}

function errorListProjectsCreatedByUser(xhr, status, error) {

}

$('#btnShareDocumentAdd').click(function () {
    var endIndex = $('#lstBoxShareDocAllUser option:selected').length;
    var combo1 = document.getElementById("lstBoxShareDocAllUser");
    var userId = combo1.options[combo1.selectedIndex].value;
    var projectId = $('#txtShareDocId').val();
    assignTeamMember(projectId, userId);
    $('#lstBoxShareDocAllUser option:selected').slice(0, 1).appendTo('#lstBoxShareDocSharedUser');
    e.preventDefault();
});

$('#btnShareDocumentRemove').click(function () {

    var projectId = $('#txtShareDocId').val();
    var combo1 = document.getElementById("lstBoxShareDocSharedUser");
    var userId = combo1.options[combo1.selectedIndex].value;
    unAssignTeamMember(projectId, userId);
    $('#lstBoxShareDocSharedUser option:selected').slice(0, 1).appendTo('#lstBoxShareDocAllUser');
    e.preventDefault();
});

$('#btnShareDocumentFinish').click(function () {
     $("#btnTeamInformation").click();
    popupStatus = disablePopup("backgroundPopup", "popupWindow", popupStatus);

});

//=======Tree starts here==========

function bindProjectTree() {
    $(function () {

        $("#ProjectsTree").dynatree({
            //  persist: true,
            selectMode: 1,

            // persist: true,
            title: "Event samples",
            //      checkbox: true,
            //      persist: true,
            onQueryActivate: function (activate, node) {
                //logMsg("onQueryActivate(%o, %o)", activate, node);
                //        return false;
            },
            onActivate: function (node) {

                if (node.data.title != "No Project") {
                    clipboardNode = node;
                    var groupId = node.data.key;
                    clipboardNodeId = node.data.key;
                    //ShowDocumentByGoupId(groupId, 10, 1, function () { HideProgressAsync(); });


                }


            },
            onDeactivate: function (node) {
                //logMsg("onDeactivate(%o)", node);
                $("#echoActive").text("-");
            },

            onQuerySelect: function (select, node) {
                alert("2");
                //logMsg("onQuerySelect(%o, %o)", select, node);
                var s = node.tree.getSelectedNodes().join(", ");
                //                    if (node.data.isFolder)
                //                        return false;
                // alert('selectedsss'+node);
                $("#echoSelected").text(s);
            },
            onSelect: function (select, node) {
                //logMsg("onSelect(%o, %o)", node);
                var s = node.tree.getSelectedNodes().join(", ");
                // alert('selected'+node);
                $("#echoSelected").text(s);
                alert("1");
            },

            onQueryExpand: function (expand, node) {
                // logMsg("onQueryExpand(%o, %o)", expand, node);
                return false;
            },
            onExpand: function (expand, node) {
                // logMsg("onExpand(%o, %o)", expand, node);
                alert("expanded");
            },

            onLazyRead: function (node) {
                return false;
                //logMsg("onLazyRead(%o)", node);
                //OnDocumentTreeViewExpandNodeClick(node);
            },

            onFocus: function (node) {
                return false;
                // logMsg("onFocus(%o)", node);

                $("#echoFocused").text(node.data.title);
                // Auto-activate focused node after 2 seconds
                //node.scheduleAction("activate", 2000);
            },
            onBlur: function (node) {
                //logMsg("onBlur(%o)", node);
                $("#echoFocused").text("-");
            },

            onClick: function (node, event) {
                getTeamInfo(node.data.key);
            },
            onDblClick: function (node, event) {
                //logMsg("onDblClick(%o, %o)", node, event);
                //   node.toggleSelect();
            },
            onKeydown: function (node, event) {
                // logMsg("onKeydown(%o, %o)", node, event);
                switch (event.which) {
                    case 32: // [space]
                        // node.toggleSelect();
                        return false;
                }
            },
            onCreate: function (node, span) {
                bindContextMenu(node, span);

            },

            onKeypress: function (node, event) {
                // logMsg("onKeypress(%o, %o)", node, event);
            },
            //start Drag n drop
            dnd: {
                onDragStart: function (node) {
                    /** This function MUST be defined to enable dragging for the tree.
                     *  Return false to cancel dragging of node.
                     */
                    logMsg("tree.onDragStart(%o)", node);
                    return true;
                },
                onDragStop: function (node) {
                    // This function is optional.
                    logMsg("tree.onDragStop(%o)", node);
                },
                autoExpandMS: 1000,
                preventVoidMoves: true, // Prevent dropping nodes 'before self', etc.
                onDragEnter: function (node, sourceNode) {
                    /** sourceNode may be null for non-dynatree droppables.
                     *  Return false to disallow dropping on node. In this case
                     *  onDragOver and onDragLeave are not called.
                     *  Return 'over', 'before, or 'after' to force a hitMode.
                     *  Return ['before', 'after'] to restrict available hitModes.
                     *  Any other return value will calc the hitMode from the cursor position.
                     */
                    logMsg("tree.onDragEnter(%o, %o)", node, sourceNode);
                    return true;
                },
                onDragOver: function (node, sourceNode, hitMode) {
                    /** Return false to disallow dropping this node.
                     *
                     */
                    // alert(node+sourceNode);
                    logMsg("tree.onDragOver(%o, %o, %o)", node, sourceNode, hitMode);
                    // Prevent dropping a parent below it's own child
                    if (node.isDescendantOf(sourceNode)) {
                        return false;
                    }
                    // Prohibit creating childs in non-folders (only sorting allowed)
                    //        if( !node.isFolder && hitMode == "over" )
                    //          return "after";
                },
                onDrop: function (node, sourceNode, hitMode, ui, draggable) {
                    /** This function MUST be defined to enable dropping of items on
                     * the tree.
                     */



                    logMsg("tree.onDrop(%o, %o, %s)", node, sourceNode, hitMode);
                    sourceNode.move(node, hitMode);
                    sourceNode.expand(true);
                    //UpdateDocumentGroup(sourceNode.data.key, '', node.data.key, 'Move');
                    // expand the drop target

                },
                onDragLeave: function (node, sourceNode) {
                    /** Always called if onDragEnter was called.
                     */

                    logMsg("tree.onDragLeave(%o, %o)", node, sourceNode);
                }
            },
            // close Drag n drop
            onKeydown: function (node, event) {
                // Eat keyboard events, when a menu is open
                if ($(".contextMenu:visible").length > 0)
                    return false;

                switch (event.which) {

                    // Open context menu on [Space] key (simulate right click)
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

                        // Handle Ctrl-C, -X and -V
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
            case "manageTeam":
                var projectId = node.data.key;
                var projectName = node.data.title;
                clipboardNode = node;
                showPopupManageTeam(projectId, projectName);
                break;
            default:
                alert("Todo: appply action '" + action + "' to node " + node);
        }
    });
}

//=======Tree ends here==========

function getTeamInfo(projectId){
    ShowProgressAsync('#centerPanel', true, "Error");
    CallAjaxToGet('GetTeamInfo', ['projectId', projectId], function (msg) { successfullGetTeamInfo(msg); }, function (xhr, status, error) { errorGetTeamInfo(xhr, status, error); });
}

function successfullGetTeamInfo(msg) {
    if (msg.d != null && msg.d.length > 0) {
        $("#divTeamMembersGridView").setTemplate($("#TemplateTeamInfo").html(), null, { filter_data: false });
        $("#divTeamMembersGridView").processTemplate(msg);
    } else {
      $("#divTeamMembersGridView").html('No team member associated with this project');
}
HideProgressAsync();
}

function errorGetTeamInfo(xhr, status, error) {
    misAlert("Unable to get Time Sheets associated", 'Error', 'error');
}

function showPopupManageTeam(projectId, projectName) {

    // groupDocId = groupId
    document.getElementById('lblbShareDocTitle').innerHtml = projectName;
    ShowProgressAsync('#centerPanel', true, "Error");
    document.getElementById('lstBoxShareDocAllUser').length = 0;
    document.getElementById('lstBoxShareDocSharedUser').length = 0;
    document.getElementById('txtShareDocId').value = projectId;
    $('#WindowContainer>div').hide();
    $('#modalTitle').text('Manage Team for Project: ' + projectName);
    $('#hSharedUsers').html("Current Team Members");
    $('#hUsers').html("Available Members");


    $('#popupWindowShareDocument').show();
    centerPopup("backgroundPopup", "popupWindow");
    popupStatus = loadPopup("backgroundPopup", "popupWindow", popupStatus, "0.7");
    getTeamMembersAvailableForProject(projectId);
    getTeamMembersAssociatedWithProject(projectId);

}

function getTeamMembersAvailableForProject(projectId) {
    ShowProgressAsync('#centerPanel', true, "Error");
    CallAjaxToGet('GetTeamMembersAvailableForProject', ['projectId', projectId], function (msg) { succesfulGetTeamMembersAvailableForProject(msg); }, function (xhr, status, error) { errorGetTeamMembersAvailableForProject(xhr, status, error); });
}

function succesfulGetTeamMembersAvailableForProject(msg) {
    var result = msg.d;
    if (result == null) {; return; }
    $("#lstBoxShareDocAllUser").setTemplate($("#createListBoxAllUserShareDocument").html(), null, { filter_data: false });
    $("#lstBoxShareDocAllUser").processTemplate(msg);
    HideProgressAsync();
}

function errorGetAllUserToShareDocument(msg) {
    HideProgressAsync();
    misAlert("Error Loading User", 'Error', 'error');
    return;
}

function getTeamMembersAssociatedWithProject(projectId) {
    ShowProgressAsync('#centerPanel', true, "Error");
    CallAjaxToGet('GetTeamMembersAssociatedWithProject', ['projectId', projectId], function (msg) { succesfulGetTeamMembersAssociatedWithProject(msg); }, function (xhr, status, error) { errorGetTeamMembersAssociatedWithProject(xhr, status, error); });
}

function succesfulGetTeamMembersAssociatedWithProject(msg) {
    var result = msg.d;
    if (result == null) {; return; }
    $("#lstBoxShareDocSharedUser").setTemplate($("#createListBoxAllUserShareDocument").html(), null, { filter_data: false });
    $("#lstBoxShareDocSharedUser").processTemplate(msg);
    HideProgressAsync();
}

function errorGetTeamMembersAssociatedWithProject(msg) {
    HideProgressAsync();
    misAlert("Error Loading User", 'Error', 'error');
    return;
}

function assignTeamMember(projectId, userId) {
    ShowProgressAsync('#centerPanel', true, "Error");
    CallAjaxToGet('AssignTeamMember', ['projectId', projectId, 'userId', userId], null, null);
}

function unAssignTeamMember(projectId, userId) {
    ShowProgressAsync('#centerPanel', true, "Error");
    CallAjaxToGet('UnAssignTeamMember', ['projectId', projectId, 'userId', userId], null, null);
}