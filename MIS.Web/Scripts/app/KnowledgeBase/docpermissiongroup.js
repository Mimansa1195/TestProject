$(document).ready(function () {

    GetAllDocumentPermissionGroup();

    $('#btnCloseDocPermission').click(function (e) {
        $("#popupWindowPermissionGroupMembers").modal("hide");
    });
    $('#btnPermissionGroupAdd').click(function (e) {
        var combo1 = document.getElementById("lstBoxGroupPermissionAllUser");
        var shareTo = combo1.options[combo1.selectedIndex].value;
        var groupId = $('#hdnPermissionGroupId').val();

        SaveDocumentPermissionGroupPermissions(groupId, shareTo);
        $('#lstBoxGroupPermissionAllUser option:selected').slice(0, 1).appendTo('#lstBoxGroupPermissionSharedUser');
        e.preventDefault();

    });
    $('#btnPermissionGroupRemove').click(function (e) {
        var groupId = $('#hdnPermissionGroupId').val();
        var combo1 = document.getElementById("lstBoxGroupPermissionSharedUser");
        var userId = combo1.options[combo1.selectedIndex].value;
        RemoveUserFromShareDocumentByuserId(userId, groupId);
        $('#lstBoxGroupPermissionSharedUser option:selected').slice(0, 1).appendTo('#lstBoxGroupPermissionAllUser');
    });

    $("#btnAddGroup").click(function (e) {
        $('#popupWindowAddNewDocPermissionGroup').modal("show");
    });

    $("#btnSavePermissionGroup").click(function () {
        if (!validateControls('divDocGroup')) {
            return false;
        }
        var group = $('#txtPermissionGroupName').val();
        var jsonObject = {
            'Name': group,
            'UserId': 0,
            'userAbrhs': misSession.userabrhs
        }
        calltoAjax(misApiUrl.saveDocumentPermissionGroup, "POST", jsonObject,
            function (result) {
                $("#popupWindowAddNewDocPermissionGroup").modal("hide");
                GetAllDocumentPermissionGroup();
            });
    });
});

    function SuccesfulSaveDocumentPermissionGroup(msg) {
        if (msg.IsSuccessful) {
            popupStatus = disablePopup("backgroundPopup", "popupWindow", popupStatus);

        }
        GetAllDocumentPermissionGroup();
    }

    function SaveDocumentPermissionGroupPermissions(groupId, shareTo) {
        var jsonObject = {
            'DocumentPermissionGroupPermissionsId':0,
            'DocumentPermissionGroupId': groupId,
            'UserId': shareTo,
            'userAbrhs': misSession.userabrhs
        }
        calltoAjax(misApiUrl.saveDocumentPermissionGroupPermissions, "POST", jsonObject,
            function (result) {
           
            });
    }

    function RemoveUserFromShareDocumentByuserId(userId, groupId) {
        var jsonObject = {
            'groupId': groupId,
            'userId': userId,
            'userAbrhs': misSession.userabrhs
        }
        calltoAjax(misApiUrl.deleteUserFromPermissionGroupByUserId, "POST", jsonObject,
            function (result) {

            });
    }

    function ShowPopupPermissionGroupMembers(groupId, title) {
        $("#groupName").html(" [" +title + "] ");
        document.getElementById('hdnPermissionGroupId').value = groupId;
        $('#popupWindowPermissionGroupMembers').modal("show");
        GetAllUserExceptOwnByPermissionGroup(groupId, function (groupId) {
            GetAllUserByPermissionGroupId(groupId);
        });
    }

    function GetAllDocumentPermissionGroup() {
        var jsonObject = {
            'userAbrhs': misSession.userabrhs
        }
        calltoAjax(misApiUrl.getAllDocumentPermissionGroup, "POST", jsonObject,
            function (result) {
                SuccesfulGetAllDocumentPermissionGroup(result);
            });
    }

    function SuccesfulGetAllDocumentPermissionGroup(msg) {
        var data = $.parseJSON(JSON.stringify(msg));
        $("#tblGroupsList").dataTable({
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
                    "mData": "Name",
                    "sTitle": "Name",
                },
                {
                    "mData": null,
                    "sTitle": "View",
                    'bSortable': false,
                    "sClass": "text-left",
                    "sWidth": "100px",
                    mRender: function (data, type, row) {
                        html = '<button type="button" class="btn btn-sm teal" data-toggle"model" data-target="#mypopupViewDocModal"' + 'onclick="ShowPopupPermissionGroupMembers(' + row.DocumentPermissionGroupId + ',\'' + row.Name + '\')" data-toggle="tooltip" title="View"><i class="fa fa-eye"> </i></button>';
                        return html;
                    }
                },
            ]
        });
    }

    function GetAllUserExceptOwnByPermissionGroup(groupId, callback) {
        var jsonObject = {
            'groupId': groupId,
            'companyId': 1,
            'companyLocationId': misSession.companylocationid,
            'userAbrhs': misSession.userabrhs
        }
        calltoAjax(misApiUrl.getAllUserExceptOwnByPermissionGroupId, "POST", jsonObject,
            function (result) {
                SuccesfulGetAllUserExceptOwnByPermissionGroup(result, callback, groupId);
            });
    }

    function SuccesfulGetAllUserExceptOwnByPermissionGroup(msg, callback, groupId) {
        $("#lstBoxGroupPermissionAllUser").empty();
        if (msg == null) {
            callback(groupId); return;
        }
        $.each(msg, function (idx, item) {
            $("#lstBoxGroupPermissionAllUser").append("<option value=" + item.UserId + ">" + item.FirstName + " " + item.LastName + "</option>");
        });
        callback(groupId);
    }
 
    function GetAllUserByPermissionGroupId(groupId) {
        var jsonObject = {
            'groupId': groupId,
            'userAbrhs': misSession.userabrhs
        }
        calltoAjax(misApiUrl.getAllUserByPermissionGroupId, "POST", jsonObject,
            function (result) {
                SuccesfulGetAllUserByPermissionGroupId(result);
            });
    }

    function SuccesfulGetAllUserByPermissionGroupId(result) {
        $("#lstBoxGroupPermissionSharedUser").empty();
        if (result == null) {
            return;
        }
        $.each(result, function (idx, item) {
            $("#lstBoxGroupPermissionSharedUser").append("<option value=" + item.UserId + ">" + item.FirstName + " " + item.LastName + "</option>");
        });
    }

    function DeletePermissionGroupFunction(groupId) {
        jConfirm('Are you sure? you want to delete selected Document ', 'Confirmation Dialog', function (r) {
            if (r == true) {
          
            }
            else {

            }
        });


    }

    $("#btnCloseAddGroup").click(function () {
        $("#popupWindowAddNewDocPermissionGroup").modal("hide");
    });






















