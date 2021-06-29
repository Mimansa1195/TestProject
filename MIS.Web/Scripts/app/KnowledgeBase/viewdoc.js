var _documentTokenList = new Array();
var _AllDocumentTags;
$(document).ready(function () {
    ShowDocumentByGoupId(0, 10, 1);
    BindGroupTree(0);
    $('#btnShareDocumentFinish').click(function () {
        popupStatus = disablePopup("backgroundPopup", "popupWindow", popupStatus);
        
    });

    $('#btnShareDocumentAdd').click(function () {
        endIndex = $('#lstBoxShareDocAllUser option:selected').length;
        var combo1 = document.getElementById("lstBoxShareDocAllUser");
        var shareTo = combo1.options[combo1.selectedIndex].value;
        var docId = $('#txtShareDocId').val();
        var shareBy = 0;
        SaveShareDocument(docId, shareTo, shareBy);
        $('#lstBoxShareDocAllUser option:selected').slice(0, 1).appendTo('#lstBoxShareDocSharedUser');
    });

    $('#btnShareDocumentRemove').click(function () {

        var docId = $('#txtShareDocId').val();
        var combo1 = document.getElementById("lstBoxShareDocSharedUser");
        var userId = combo1.options[combo1.selectedIndex].value;
        RemoveUserFromShareDocumentByuserId(userId, docId);
        $('#lstBoxShareDocSharedUser option:selected').slice(0, 1).appendTo('#lstBoxShareDocAllUser');
        
    });

    $('#imgAllDocument').click(function (e) {
        $("#DocumentGrouptree").dynatree("getRoot").removeChildren();
        BindGroupTree(0);
        ShowDocumentByGoupId(0, 10, 1, function () { HideProgressAsync(); });
        
    });

    GetAllDocumentTagForTokenInput('#txtDocumentTags', 10);

    $('#btnreplacedocument').click(function () {
        
        var bool = false;
        if ($.trim($('#txtRetitleDocument').val()).length > 0) {
            var docId = $('#txtReDocumentId').val();
            var title = $('#txtRetitleDocument').val();
            UpdateDocument(docId, '', title, '');
        }
    });

    $('#btnSaveGroup').click(function (e) {
        var group = $('#groupName').val();
            var jsonObject = {
                'ParentId': groupParentId,
                'Name': $('#groupName').val(),
                'DeleteFlag':0,
                'UserID': 0,
                'UserAbrhs': misSession.userabrhs,
            };
            calltoAjax(misApiUrl.saveGroup, "POST", jsonObject,
                function (result) {
                    if (result > 0) {
                        $("#mypopupAddNewDocGroupModal").modal("hide");
                        misAlert("Folder has been created successfully.", 'Success', 'success');
                        if (groupParentId > 0) {
                            clipboardNode.addChild({ title: group, isFolder: true, key: result });
                        }
                        else {
                            $("#DocumentGrouptree").dynatree("getRoot").addChild({ title: group, isFolder: true, key: result, });
                            misAlert("Duplicate name  is not allowed.", 'Warning', 'warning');
                        }
                    }
                });
    });

    $('#btnSaveDocument').click(function () {
        
        if (base64FormData != "") {
            var path = $('#documentToUpload').val();
            var description = $('#txtDescription').val().trim();
            var fileDiscription = $("#txtFileDiscription").val().trim();
            var tagIds = $("#txtDocumentTags").val().toString();
            var groupId = clipboardNode.data.key;
            if (groupId > 0 || groupId == -1) {
                SaveDocument("",description, groupId, fileDiscription, tagIds);
            }
            else {
                misAlert('Error', 'Error','error');
                return;
            }
        }
        else {
            misAlert('Please fill required field', 'Warning','warning');
        }
    });

    $("#popupAddNewDocGroup").click(function (e) {
        ShowPopupForAddNewDocGroup(0);
        

    });

    $("#popupAddNewDocumentTag").click(function (e) {
        ShowPopupForAddNewDocumentTab();
        

    });

    $('#ddlTotalDocumentsView').change(function (e) {
        var selectedValue = $(this).val();

        
    });

    $('#btnSaveDocumentTag').click(function (e) {
        var tag = $('#txtTagName').val().trim();
        if (tag.length > 0) {
            callSaveDocumentTag(tag);
        }
        else {
            misAlert('Please fill required field', 'Warning', 'warning');
            return;
        }
        
    });

    $("#btnShareDocumentWithGroup").click(function () {
        var combo1 = document.getElementById("lstBoxShareDocAllGroups");
        var shareTogroup = combo1.options[combo1.selectedIndex].value;
        var docId = $('#txtDocIdShareDocWithgropus').val();
        var shareBy = 0;
        SaveShareDocumentWithGroup(docId, shareTogroup, shareBy);
        $('#lstBoxShareDocAllGroups option:selected').slice(0, 1).appendTo('#lstBoxShareDocSharedGroups');
        

    });

    $('#btnShareDocumentRemoveGroup').click(function () {
        var docId = $('#txtDocIdShareDocWithgropus').val();
        var combo1 = document.getElementById("lstBoxShareDocSharedGroups");
        var groupId = combo1.options[combo1.selectedIndex].value;
        RemoveGroupFromShareDocumentByGroupId(groupId, docId);
        $('#lstBoxShareDocSharedGroups option:selected').slice(0, 1).appendTo('#lstBoxShareDocAllGroups');
        
    });

    $('#btnShareDocumentFinishWithGroup').click(function (e) {
        popupStatus = disablePopup("backgroundPopup", "popupWindow", popupStatus);
        
    });

});

function ShowPopupForAddNewDocumentTab() {
    $('#spnErrorDocumentTag').html('');
    $("#txtTagName").val("");
    $("#mypopupAddNewDocumentTagModal").modal("show");
}

var clipboardNode = null;
var clipboardNodeId = null;
function ShowPopupForAddNewDocument(groupId) {
    groupDocId = groupId;
    $('#WindowContainer>div').hide();
    $('#modalTitle').text('Add New Document');
    $(".token-input-token-facebook").remove();
    $('#DocumentToUpload').val('');
    $('#txtDescription').val('');
    $('#txtFileDescription').val('');
    $('#txtDocumentTags').val('');
    $("#mypopupWindowAddNewDocumentModal").modal("show");
}

function ShowPopupShareDocument(docID, Title, path) {
    var extention = path.split('.').pop();
    if (extention != "pdf") {
        misAlert('You can only share Pdf file.', 'Warning', 'warning');
        return;
    }

    document.getElementById('lblbShareDocTitle').innerHtml = Title;
    document.getElementById('lstBoxShareDocAllUser').length = 0;
    document.getElementById('lstBoxShareDocSharedUser').length = 0;
    document.getElementById('txtShareDocId').value = docID;
    $("#mypopupWindowShareDocumentModal").modal("show");
    GetAllUserToShareDocument(docID, function (docID) {
        GetUserDetailBySharedDocId(docID);
    });
}

function ShowPopupShareDocumentWithGroups(docId, title, path) {
    var extention = path.split('.').pop();
    if (extention != "pdf") {
        misAlert('You can only share Pdf file.', 'Warning', 'warning');
        return;
    }
    document.getElementById('lblbShareDocTitleWithgropus').innerHtml = title;
    document.getElementById('lstBoxShareDocAllGroups').length = 0;
    document.getElementById('lstBoxShareDocSharedGroups').length = 0;
    document.getElementById('txtDocIdShareDocWithgropus').value = docId;
    $("#mypopupWindowShareDocumentWithGropusModal").modal("show");

    GetAllGroupExceptOwnByDocumentId(docId, function (docId) {
        GetAllGroupByDocumentId(docId);
    });

}

function ShowPopupForRenameDocGroup(node) {

    document.getElementById('docGroupRename').value = node.data.title;
    document.getElementById('docGroupRenameId').value = node.data.key;
    $('#WindowContainer>div').hide();
    $('#modalTitle').text('Rename Document');
    $('#popupWindowRenameDocGroup').show();
    centerPopup("backgroundPopup", "popupWindow");
    popupStatus = loadPopup("backgroundPopup", "popupWindow", popupStatus, "0.7");

}

function ShowPopupForAddNewDocGroup(parentId) {
    groupParentId = parentId;
    $('#spError-VD').html('');

    document.getElementById('groupName').value = "New Folder";
    $('#WindowContainer>div').hide();
    $('#modalTitle').text('Add New Folder');
    $("#mypopupAddNewDocGroupModal").modal("show");
}

function ShowPopupReplaceDocument(docId, title) {

    document.getElementById('txtReDocumentId').value = docId;
    document.getElementById('txtRetitleDocument').value = title;
    $("#mypopupWindowReplaceDocumentModal").modal("show");

}

function ViewDocument(path) {
    var jsonObject = {
        'path': path,
        'userAbrhs': misSession.userabrhs,
    };
    calltoAjax(misApiUrl.viewDocument, "POST", jsonObject,
        function (result) {

        });
}

function RemoveUserFromShareDocumentByuserId(userId, docId) {
    var jsonObject = {
        'userId': userId,
        'docId': docId,
        'userAbrhs': misSession.userabrhs,
    };
    calltoAjax(misApiUrl.deleteUserFromShareDocumentByUserId, "POST", jsonObject,
        function (result) {

        });
}

function UpdateDocumentGroup(docGroupId, name, moveParentId, action) {
    var jsonObject = {
            'docGroupId': docGroupId,
            'ParentId': moveParentId,
            'Name': name,
            'DeleteFlag': 0,
            'UserID': 0,
            'UserAbrhs': misSession.userabrhs,
            'action': action,
    };
    calltoAjax(misApiUrl.updateDocumentGroup, "POST", jsonObject,
        function (result) {

        });
}

function DeleteDocument(documentId, path) {
    var jsonObject = {
        'documentId': documentId,
        'path': path,
        'userAbrhs': misSession.userabrhs,
    };
    calltoAjax(misApiUrl.deleteDocument, "POST", jsonObject,
        function (result) {
            if (result == true) {
                if (clipboardNodeId != null) {
                    misAlert("Document deleted successfully", "Success", "success");
                    ShowDocumentByGoupId(clipboardNodeId, 10, 1, function () { });
                }
                else {
                    misAlert("Document deleted successfully", "Success", "success");
                    ShowDocumentByGoupId(0, 10, 1, function () { });
                }
            }
        });
}

function SaveDocument(path, description, groupId, fileDiscription, tags) {
    var jsonObject = {
        'path': fileName,
        'description': description,
        'groupId': groupId,
        'fileDiscription': fileDiscription,
        'tags': tags,
        'userAbrhs': misSession.userabrhs,
        'FileBase64': base64FormData
    };
    calltoAjax(misApiUrl.addNewDocument, "POST", jsonObject,
        function (result) {
            if (result == true) {
                $("#mypopupWindowAddNewDocumentModal").modal("hide");
                misAlert('Document Saved Successfully.', 'Success','success');
                ShowDocumentByGoupId(groupId, 10, 1, function () {
                });
            }
        });
}

function UpdateDocument(docId, path, title, action) {

    var jsonObject = {
        'path': fileName,
        'description': title,
        'DocId': docId,
        'userAbrhs': misSession.userabrhs,
        'FileBase64': base64FormData,
        'action': action,
    };
    calltoAjax(misApiUrl.updateDocument, "POST", jsonObject,
        function (result) {
            if (result == true)
                $("#mypopupWindowReplaceDocumentModal").modal("hide");
                misAlert('Document Updated Successfully.', 'Success', 'success');
            if (clipboardNodeId > 0) {
                ShowDocumentByGoupId(clipboardNodeId, 10, 1, function () {
                });
            }
            else {
                ShowDocumentByGoupId(0, 10, 1, function () {
                });
            }
        });
}

function GetAllUserToShareDocument(docId, callback) {
    var jsonObject = {
        docId: docId,
        companyLocationId: misSession.companylocationid,
        userAbrhs: misSession.userabrhs
    }
    calltoAjax(misApiUrl.getAllUsersToShareDocByDocId, "POST", jsonObject,
            function (result) {
                SuccesfulGetAllUserToShareDocument(result, callback, docId);
            });
}

function SuccesfulGetAllUserToShareDocument(msg, callback, docId) {
    var result = msg;
    if (result == null) { callback(docId); return; }
    $("#lstBoxShareDocAllUser").empty();
    $.each(result, function (idx, item) {
        $("#lstBoxShareDocAllUser").append("<option value=" + item.UserId + ">" + item.FirstName + " " + item.LastName + "</option>");
    });
    callback(docId);
}

function SaveShareDocument(docId, shareTo, shareBy) {

    var jsonObject = {
        'DocumentId': docId,
        'ShareTo': shareTo,
        'userAbrhs': misSession.userabrhs,
    };
    calltoAjax(misApiUrl.saveShareDocument, "POST", jsonObject,
        function (result) {
            if (result == false)
                misAlert('Error in sharing document', 'Error','error');
        });
}

function GetUserDetailBySharedDocId(docId) {
    var jsonObject = {
        DocId: docId,
        currentUserId: 1,
        userAbrhs: misSession.userabrhs
    }
    calltoAjax(misApiUrl.getUserDetailBySharedDocId, "POST", jsonObject,
            function (result) {
                $("#lstBoxShareDocSharedUser").empty();
                $.each(result, function (idx, item) {
                    $("#lstBoxShareDocSharedUser").append("<option value=" + item.UserId + ">" + item.FirstName + " " + item.LastName + "</option>");
                });
                //SuccesfulGetUserDetailBySharedDocId(result);
            });

}

function SuccesfulGetUserDetailBySharedDocId(msg) {
    var result = msg;
    $("#lstBoxShareDocSharedUser").setTemplate($("#createListBoxAllUserShareDocument1").html(), null, { filter_data: false });
    $("#lstBoxShareDocSharedUser").processTemplate(msg);
}

function SelectTreeNodeOnRightCLick(node) {
    $("#DocumentGrouptree").dynatree("getRoot").selectKey(node.data.key);


}

function editNode(node) {
    var prevTitle = node.data.title,
      tree = node.tree;
    tree.$widget.unbind();
    $(".dynatree-title", node.span).html("<input id='editNode' value='" + prevTitle + "'>");
    $("input#editNode")
      .focus()
      .keydown(function (event) {
          switch (event.which) {
              case 27: // [esc]
                  // discard changes on [esc]
                  $("input#editNode").val(prevTitle);
                  $(this).blur();
                  break;
              case 13: // [enter]
                  // simulate blur to accept new value
                  $(this).blur();

                  break;
          }
      }).blur(function (event) {
          var title = $("input#editNode").val();
          node.setTitle(title);
          tree.$widget.bind();
          node.focus();
          UpdateDocumentGroup(node.data.key, node.data.title, 0, 'Rename');

      });
}

var JSONObject;

function DeleteDocumentFunction(docId, path) {
    var reply = misConfirm("Are you sure you want to delete selected Document ", "Confirm", function (reply) {
        if (reply) {
            DeleteDocument(docId, path);
        }
    });
}

function bindContextMenu(node, span) {
    $(span).contextMenu({ menu: "myMenu" }, function (action, el, pos) {
        clipboardNode = null;
        switch (action) {
            case "cut":
            case "rename":
                if (node.data.key !== -1) {
                    editNode(node);
                } else {
                    misAlert("You can not rename policy.", "Warning", "warning");
                }
                clipboardNode = node;
                break;
            case "delete":
                clipboardNode = node;
                var groupId = node.data.key;
                if (node.data.key !== -1) {
                    var reply = misConfirm("Are you sure you want to delete selected group", "Confirm", function (reply) {
                        if (reply) {
                            DeleteDocumentGroupByGoupId(groupId);
                        }
                    });
                } else {
                    misAlert("You can not delete policy folder.", "Warning", "warning");
                }
                break;
            case "addNewFolder":
                var parentId = node.data.key;
                clipboardNode = node;
                if (node.data.key !== -1) {
                    ShowPopupForAddNewDocGroup(parentId);
                } else {
                    misAlert("You can not add sub folder to policy.", "Warning", "warning");
                }
                break;
            case "addNewDocument":
                clipboardNode = node;

                node.select();
                var groupId = node.data.key;
                ShowPopupForAddNewDocument(groupId);
                break;
            default:
                alert("Todo: appply action '" + action + "' to node " + node);
        }
    });
}

function BindDocumentGroupTree() {
    $(function () {
        $("#DocumentGrouptree").dynatree({
            selectMode: 1,
            title: "Event samples",
            onQueryActivate: function (activate, node) {
            },
            onActivate: function (node) {
                if (node.data.title != "No Folder") {
                    clipboardNode = node;
                    var groupId = node.data.key;
                    clipboardNodeId = node.data.key;
                    ShowDocumentByGoupId(groupId, 10, 1, function () {  });
                }
            },
            onDeactivate: function (node) {
                $("#echoActive").text("-");
            },
            onQuerySelect: function (select, node) {
                var s = node.tree.getSelectedNodes().join(", ");
                $("#echoSelected").text(s);
            },
            onSelect: function (select, node) {
                var s = node.tree.getSelectedNodes().join(", ");
                $("#echoSelected").text(s);
            },

            onQueryExpand: function (expand, node) {

            },
            onExpand: function (expand, node) {
            },
            onLazyRead: function (node) {
                OnDocumentTreeViewExpandNodeClick(node);
            },
            onFocus: function (node) {
                $("#echoFocused").text(node.data.title);
                node.scheduleAction("activate", 2000);
            },
            onBlur: function (node) {
                $("#echoFocused").text("-");
            },
            onClick: function (node, event) {
                node.select();
               
            },
            onDblClick: function (node, event) {
                node.toggleSelect();
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
            //start Drag n drop
            dnd: {
                onDragStart: function (node) {
                    return false;
                },
                onDragStop: function (node) {
               
                },
                autoExpandMS: 1000,
                preventVoidMoves: true, // Prevent dropping nodes 'before self', etc.
                onDragEnter: function (node, sourceNode) {
                    return true;
                },
                onDragOver: function (node, sourceNode, hitMode) {
                    return false;
                    if (node.isDescendantOf(sourceNode)) {
                        return false;
                    }
                },
                onDrop: function (node, sourceNode, hitMode, ui, draggable) {
                 
                    sourceNode.move(node, hitMode);
                    sourceNode.expand(true);
                    UpdateDocumentGroup(sourceNode.data.key, '', node.data.key, 'Move');
                },
                onDragLeave: function (node, sourceNode) {
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

var childGroupList;
var myArray = new Array();
function NodeValue(nodeName, nodeValue) {
    this.nodeName = nodeName;
    this.nodeValue = nodeValue;

}

function SendUrlForDocumentFileToView(location) {


    CallAjaxToGet("GetGoogleDocViewerCommonUrl", [], function (msg) { SuccessfullSendUrlForDocumentFileToView(msg, location); },
    function (xhr, status, error) { errorSendUrlForDocumentFileToView(xhr, status, error); });
}

function SuccessfullSendUrlForDocumentFileToView(msg, location) {
    HideProgressAsync();
    if (msg.d == null || msg.d == "") {
        misAlert('No Such File Was Present', 'Error','error');
        return;
    }

    window.open(msg.d + "Documents/" + location);

}

function ViewDocumentpopup(path, el) {
    var extention = path.split('.').pop();
    if (extention != "pdf") {
        $("#mypopupWindowViewDocumentModal").modal("show");
        $("#objViewPdf").attr("data", misApiRootUrl + path);
    }
    else {
        $("#mypopupWindowViewDocumentModal").modal("show");
        $("#objViewPdf").attr("data", misApiRootUrl + path);
    }
}

function DeleteDocumentGroupByGoupId(groupId) {

    var jsonObject = {
        'groupId': groupId,
        'userAbrhs': misSession.userabrhs,
    };
    calltoAjax(misApiUrl.deleteDocumentGroupByGoupId, "POST", jsonObject,
        function (result) {
            if (result == false) {
                return;
            }
            clipboardNode.remove();
            ShowDocumentByGoupId(0, 10, 1, function () {

            });
        });
}

function ShowDocumentByGoupId(groupId, pageSize, currentPage) {
    var jsonObject = {
        'groupId': groupId,
        'pageSize': pageSize,
        'currentPage': currentPage,
        'currentUserId': 0,
        'userAbrhs': misSession.userabrhs
    }
    calltoAjax(misApiUrl.getDocumentByGroupId, "POST", jsonObject,
        function (result) {
            SuccesfulShowDocumentByGrouId(result);
        });
}

function SuccesfulShowDocumentByGrouId(msg) {
    var data = $.parseJSON(JSON.stringify(msg));
    $("#tbldocumentGridViewList").dataTable({
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
                "sTitle": "View",
                'bSortable': false,
                "sClass": "text-left",
                "sWidth": "100px",
                mRender: function (data, type, row) {
                    var html = "";
                    var extention = data.Path.split('.').pop();
                    if (extention !=null) {
                        if ($.trim(extention) == $.trim('txt')) {
                            html = ' <img src="../Images/txtFile.png" alt="icon" title="Txt File" />';
                        }
                        else if ($.trim(extention) == $.trim('pdf')) {
                            html = ' <img src="../Images/pdfFile.png" alt="icon"  title="Pdf File" />';
                        }
                        else if ($.trim(extention) == $.trim('doc') || $.trim(extention) == $.trim('docx')) {
                            html = ' <img src="../Images/docFile.png" alt="icon"  title="Doc File" />';
                        }
                        else if ($.trim(extention) == $.trim('xlsx')) {
                            html = ' <img src="../Images/xlsxFile.png" alt="icon"  title="Xlsx File" />';
                        }
                    }
                    return html;
                }
            },
            {
                "mData": "Description",
                "sTitle": "Title",
            },
            {
                "mData": "GroupName",
                "sTitle": "Folder",
            },
            {
                "mData": "ShowDate",
                "sTitle": "Date",
            },
            {
                "mData": null,
                "sTitle": "Share with user",
                'bSortable': false,
                "sClass": "text-left",
                "sWidth": "100px",
                mRender: function (data, type, row) {
                    html = '<button type="button" class="btn btn-sm teal" data-toggle"model" data-target="#mypopupViewDocModal"' + 'onclick="ShowPopupShareDocument(' + row.DocId + ',\'' + row.Description + '\',\'' + row.Path + '\')" data-toggle="tooltip" title="View"><i class="fa fa-share-alt"> </i></button>';
                    return html;
                }
            },
            {
                "mData": null,
                "sTitle": "Share with group",
                'bSortable': false,
                "sClass": "text-left",
                "sWidth": "100px",
                mRender: function (data, type, row) {
                    html = '<button type="button" class="btn btn-sm teal" data-toggle"model" data-target="#mypopupViewDocModal"' + 'onclick="ShowPopupShareDocumentWithGroups(' + row.DocId + ',\'' + row.Description + '\',\'' + row.Path + '\')" data-toggle="tooltip" title="View"><i class="fa fa-share-alt"> </i></button>';
                    return html;
                }
            },
            {
                "mData": null,
                "sTitle": "Update",
                'bSortable': false,
                "sClass": "text-left",
                "sWidth": "100px",
                mRender: function (data, type, row) {
                    html = '<button type="button" class="btn btn-sm teal" data-toggle"model" data-target="#mypopupViewDocModal"' + 'onclick="ShowPopupReplaceDocument(' + row.DocId + ',\'' + row.Description + '\')" data-toggle="tooltip" title="View"><i class="fa fa-edit"> </i></button>';
                    return html;
                }
            },
            {
                "mData": null,
                "sTitle": "View",
                'bSortable': false,
                "sClass": "text-left",
                "sWidth": "100px",
                mRender: function (data, type, row) {
                    html = '<button type="button" class="btn btn-sm teal" data-toggle"model" data-target="#mypopupViewDocModal"' + 'onclick="ViewDocumentpopup(\'' + row.Path + '\')" data-toggle="tooltip" title="View"><i class="fa fa-eye"> </i></button>';
                    return html;
                }
            },
            {
                "mData": null,
                "sTitle": "Download",
                'bSortable': false,
                "sClass": "text-left",
                "sWidth": "100px",
                mRender: function (data, type, row) {
                    html = '<button type="button" class="btn btn-sm teal" data-toggle"model" data-target="#mypopupViewDocModal"' + 'onclick="MyDownloadDocument(\'' + row.Path + '\')" data-toggle="tooltip" title="View"><i class="fa fa-download"> </i></button>';
                    return html;
                }
            },
            {
                "mData": null,
                "sTitle": "Delete",
                'bSortable': false,
                "sClass": "text-left",
                "sWidth": "100px",
                mRender: function (data, type, row) {
                    html = '<button type="button" class="btn btn-sm teal" data-toggle"model" data-target="#mypopupViewDocModal"' + 'onclick="DeleteDocumentFunction(' + row.DocId + ',\'' + row.Path + '\')" data-toggle="tooltip" title="Delete"><i class="fa fa-trash"> </i></button>';
                    return html;
                }
            },
        ]
    });

}

function MyDownloadDocument(file) {
    var link = document.createElement('a');
    link.href = misApiRootUrl + file;
    link.download = misApiRootUrl + file;
    link.dispatchEvent(new MouseEvent('click'));
}

var groupParentId = null;
var groupDocId = null;

function GetChildGroup(msgChild) {
    var childParentId = msgChild.DocGroupId;
    var userId = 0;
    var jsonObject = {
        'parentId': childParentId,
        'userId': 0,
        'userAbrhs': misSession.userabrhs
    }
    calltoAjax(misApiUrl.getDocumentGroupsByParentId, "POST", jsonObject,
        function (result) {
            SuccesfulGetChildGroup(result, msgChild);
        });
}

function SuccesfulGetChildGroup(msg, msgChild) {
    if (msg == null) {
        $("#DocumentGrouptree").dynatree("getRoot").addChild({ title: msgChild.Name, isFolder: true, key: msgChild.DocGroupId });
        return;
    }
    $("#DocumentGrouptree").dynatree("getRoot").addChild({ title: msgChild.Name, isFolder: true, key: msgChild.DocGroupId, isLazy: true, expand: false });
}

function GetSubChildGroup(msgChild, node) {
    var childParentId = msgChild.DocGroupId;
    var userId = 0;
    var jsonObject = {
        'parentId': childParentId,
        'userId': 0,
        'userAbrhs': misSession.userabrhs
    }
    calltoAjax(misApiUrl.getDocumentGroupsByParentId, "POST", jsonObject,
        function (result) {
            SuccesfulGetSubChildGroup(result, msgChild, node);
        });
}

function SuccesfulGetSubChildGroup(msg, msgChild, node) {
    if (msg == null) {
        node.addChild({ title: msgChild.Name, isFolder: true, key: msgChild.DocGroupId });
        return;
    }
    node.addChild({ title: msgChild.Name, isFolder: true, key: msgChild.DocGroupId, isLazy: true, expand: false });
}

function BindGroupTree(parentId) {
    var jsonObject = {
        'parentId': parentId,
        'userId': 0,
        'userAbrhs': misSession.userabrhs
    }
    calltoAjax(misApiUrl.getDocumentGroupsByParentId, "POST", jsonObject,
        function (result) {
            SuccesfulBindGroupTree(result);
        });
}

function SuccesfulBindGroupTree(msg) {

    BindDocumentGroupTree();
    $("#DocumentGrouptree").dynatree("getRoot").removeChildren();
    if (msg == null) {
        return;
    }
    var _msgLen = msg.length;
    var _treeViewGorup = ' ';

    for (i = 0; i < _msgLen; i++) {

        var childParentId = msg[i].DocGroupId;
        $("#DocumentGrouptree").dynatree("getRoot").addChild({ title: msg[i].Name, isFolder: true, key: msg[i].DocGroupId, isLazy: true, expand: false });

    }
}

function OnDocumentTreeViewExpandNodeClick(node) {
    var nodeId = node.data.key;
    var userId = 0;
    var jsonObject = {
        'parentId': nodeId,
        'userId': 0,
        'userAbrhs': misSession.userabrhs
    }
    calltoAjax(misApiUrl.getDocumentGroupsByParentId, "POST", jsonObject,
        function (result) {
            SuccesfulOnDocumentTreeViewExpandNodeClick(result, node);
        });
}

function SuccesfulOnDocumentTreeViewExpandNodeClick(msg, node) {
    if (msg == null) { node.setLazyNodeStatus(DTNodeStatus_Ok); return; }

    var _msgLen = msg.length;

    for (var k = 0; k < _msgLen; k++) {

        node.addChild({ title: msg[k].Name, isFolder: true, key: msg[k].DocGroupId, isLazy: true, expand: false });
    }
}

function GetAllDocumentTagForTokenInput(inputControl, tokenLimit) {
    var jsonObject = {
        userAbrhs: misSession.userabrhs
    }
    calltoAjax(misApiUrl.getAllDocumentTags, "POST", jsonObject,
        function (result) {
            $("#txtDocumentTags").empty();
            $.each(result, function (index, result) {
                $("#txtDocumentTags").append("<option value = '" + result.id + "'>" + result.name + "</option>");
            });
        });
}

function callSaveDocumentTag(tagName) {
    var jsonObject = {
        'tagName': tagName,
        'userAbrhs': misSession.userabrhs,
    };
    calltoAjax(misApiUrl.addDocumentTag, "POST", jsonObject,
        function (result) {
            if (result.id>0) {
                misAlert('Document tag Added Sucessfully', 'Success', 'success');
                $("#mypopupAddNewDocumentTagModal").modal("hide");
                //_AllDocumentTags.push(result);
                //popupStatus = disablePopup("backgroundPopup", "popupWindow", popupStatus);
            }
            else {
                $('#spnErrorDocumentTag').addClass('fontRed');
                $('#spnErrorDocumentTag').html(data.Message);
            }
        });
}

function GetAllGroupExceptOwnByDocumentId(docId, callback) {
    var jsonObject = {
        'documentId': docId,
        'userAbrhs': misSession.userabrhs
    }
    calltoAjax(misApiUrl.getAllGroupExceptOwnByDocumentId, "POST", jsonObject,
        function (result) {
            SuccesfulGetAllGroupExceptOwnByDocumentId(result, callback, docId);
        });
}

function SuccesfulGetAllGroupExceptOwnByDocumentId(msg, callback, docId) {
    var result = msg;
    if (result == null) {
        callback(docId); return;
    }
    $("#lstBoxShareDocAllGroups").empty();
    $.each(result, function (idx, item) {
        $("#lstBoxShareDocAllGroups").append("<option value=" + item.DocumentPermissionGroupId + ">" + item.Name + "</option>");
    });
    callback(docId);
}

function GetAllGroupByDocumentId(docId) {
    var jsonObject = {
        'documentId': docId,
        'userAbrhs': misSession.userabrhs
    }
    calltoAjax(misApiUrl.getAllGroupByDocumentId, "POST", jsonObject,
        function (result) {
            SuccesfulGetAllGroupByDocumentId(result);
        });
}

function SuccesfulGetAllGroupByDocumentId(result) {
    if (result != null) {
        $("#lstBoxShareDocSharedGroups").empty();
        $.each(result, function (idx, item) {
            $("#lstBoxShareDocSharedGroups").append("<option value=" + item.DocumentPermissionGroupId + ">" + item.Name + "</option>");
        });
    }
   
}

function SaveShareDocumentWithGroup(docId, shareTogroup, shareBy) {
    var jsonObject = {
        'DocumentId': docId,
        'SharedGroupId': shareTogroup,
        'sharedById': shareBy,
        'userAbrhs': misSession.userabrhs,
    };
    calltoAjax(misApiUrl.saveSharedGroupDocument, "POST", jsonObject,
        function (result) {
            if (result == false)
                misAlert('Error adding User', 'Error', 'error');
        });
}

function RemoveGroupFromShareDocumentByGroupId(groupId, docId) {

    var jsonObject = {
        'groupId': groupId,
        'docId': docId,
        'userAbrhs': misSession.userabrhs,
    };
    calltoAjax(misApiUrl.deleteGroupFromSharedGroupByGroupId, "POST", jsonObject,
        function (result) {

        });
}

$("#btnClosereplacedocument").click(function () {
    $("#mypopupWindowReplaceDocumentModal").modal("hide");
});

$("#btnCloseDocumentTag").click(function () {
    $("#mypopupAddNewDocumentTagModal").modal("hide");
});

$("#btnCloseDocument").click(function () {
    $("#mypopupWindowAddNewDocumentModal").modal("hide");
});

$("#btnCloseGroup").click(function () {
    $("#mypopupAddNewDocGroupModal").modal("hide");
});

$("#btnCloseShareDocument").click(function () {
    $("#mypopupWindowShareDocumentModal").modal("hide");
});

$("#btnCloseShareDocumentGroups").click(function () {
    $("#mypopupWindowShareDocumentWithGropusModal").modal("hide");
});


/// For File Upload 

var base64FormData;
var fileName;
function checkFileIsValid(sender) {
    var controlId = sender.id;
    var validExts = new Array(".xlsx", ".xls", ".pdf");
    var fileExt = sender.value;
    fileExt = fileExt.substring(fileExt.lastIndexOf('.'));
    if (validExts.indexOf(fileExt) < 0) {
        misAlert("Invalid file selected. supported extensions are " + validExts.toString(), "Warning", "warning");
        $("#"+controlId).val("");
        return false;
    } else {
        convertToBase64(controlId);
        return true;
    }
}

function convertToBase64(controlId) {
    var selectedFile = document.getElementById(controlId).files;
    fileName = selectedFile[0].name;
    if (selectedFile.length > 0) //Check File is not Empty
    {
        var fileToLoad = selectedFile[0]; // Select the very first file from list
        var fileReader = new FileReader(); // FileReader function for read the file.
        fileReader.onload = function (fileLoadedEvent) // Onload of file read the file content
        {
            base64FormData = fileLoadedEvent.target.result;// Print data in console
        };
        fileReader.readAsDataURL(fileToLoad); // Convert data to base64
    }
}
