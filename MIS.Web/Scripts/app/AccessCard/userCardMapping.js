var _userCardMappingId;
var _employeeAbrhs, _isStaff = false, _nextDate;

$(document).ready(function () {
    getNextWorkingDate();
    $('#userType').prop('checked', true);
    $("#txtFrom").val("");

    $("#userType").change(function () {
        if ($("#userType").is(':checked')) {
            $("#employeeDetail").show();
            $("#staffDetail").hide();
            $("#isPimco").show();
        }
        else {
            $("#staffDetail").show();
            $("#employeeDetail").hide();
            $("#isPimco").show();
        }
    });

    loadUserCardMappingGrid();
});

    function getNextWorkingDate() {
    calltoAjax(misApiUrl.getNextWorkingDate, "POST", "",
        function (result) {
            _nextDate = new Date(result);
        });
}

    function loadUserUnMappedCardHistoryGrid() {
    calltoAjax(misApiUrl.getAllUserCardUnMappedHistory, "POST", '',
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#tblUnMappedCardHistory").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'User Card Mapping',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'User Card Mapping' },
                        { extend: 'pdf', filename: 'User Card Mapping' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                        { extend: 'print', filename: 'User Card Mapping' },
                        ]
                    }
                ],
                "responsive": true,
                "autoWidth": true,
                "paging": true,
                "bDestroy": true,
                "ordering": true,
                "order": [],
                "info": true,
                "deferRender": true,
                "aaData": resultData,
                "aoColumns": [
                    {
                        "mData": "EmployeeId",
                        "sTitle": "Employee Id",
                    },
                    {
                        "mData": "EmployeeName",
                        "sTitle": "Employee Name",
                    },
                    {
                        "mData": "AccessCardNo",
                        "sTitle": "Card Number",
                    },
                    {
                        "mData": "Status",
                        "sTitle": "Status",
                    },
                   
                    {
                        "mData": "AssignedFrom",
                        "sTitle": "Assigned From"
                    },
                    {
                        "mData": "AssignedTill",
                        "sTitle": "Assigned Till"
                    },
                    {
                        "mData": "DeActivatedOn",
                        "sTitle": "De-activated On"
                    },
                    {
                        "mData": "DeActivatedBy",
                        "sTitle": "De-activated By"
                    },

                    {
                        "mData": null,
                        "sTitle": "Access For",
                        'bSortable': false,
                        "sClass": "text-center",
                        mRender: function (data, type, row) {
                            var html = '<div>';
                            if (row.IsPimcoUserCardMapping)
                                html += 'Pimco';
                            else
                                html += 'Non-Pimco'
                            html += '</div>'
                            return html;
                        }
                    },
                    {
                        "mData": "AssignedOn",
                        "sTitle": "Assigned On"
                    },
                    {
                        "mData": "CreatedBy",
                        "sTitle": "Assigned By"
                    },
                   
                ]
            });
        });
}

    function loadUserCardMappingGrid() {
    calltoAjax(misApiUrl.getAllUserCardMapping, "POST", '',
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#tblUserCardMapping").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                 {
                     filename: 'User Card Mapping',
                     extend: 'collection',
                     text: 'Export',
                     buttons: [{ extend: 'copy' },
                                { extend: 'excel', filename: 'User Card Mapping' },
                                { extend: 'pdf', filename: 'User Card Mapping' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                                { extend: 'print', filename: 'User Card Mapping' },
                     ]
                 }
                ],
                "responsive": true,
                "autoWidth": true,
                "paging": true,
                "bDestroy": true,
                "ordering": true,
                "order": [],
                "info": true,
                "deferRender": true,
                "aaData": resultData,
                "aoColumns": [
                    {
                        "mData": "EmployeeId",
                        "sTitle": "Employee Id",
                    },
                    {
                        "mData": "EmployeeName",
                        "sTitle": "Employee Name",
                    },
                    {
                        "mData": "AccessCardNo",
                        "sTitle": "Card Number",
                    },
                    {
                        "mData": "AssignedFrom",
                        "sTitle": "Assigned From"
                    },
                    {
                        "mData": "Status",
                        "sTitle": "Status",
                    },
                    {
                        "mData": "AssignedOn",
                        "sTitle": "Assigned On"
                    },
                    {
                        "mData": "CreatedBy",
                        "sTitle": "Assigned By"
                    },

                    {
                        "mData": null,
                        "sTitle": "Access For",
                        'bSortable': false,
                        "sClass": "text-center",
                        mRender: function (data, type, row) {
                            var html = '<div>';
                            if (row.IsPimcoUserCardMapping)
                                html += 'Pimco';
                            else
                                html += 'Non-Pimco'
                            html += '</div>'
                            return html;
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        "sClass": "text-center",
                        mRender: function (data, type, row) {
                            var html = '<div>';
                            if (row.IsFinalised)
                                html += '<button type="button" data-toggle="tooltip" class="btn btn-sm btn-danger"' + 'onclick="deleteUserCardMapping(' + row.UserCardMappingId + ',\'' + row.EmployeeName + '\')" title="Un Finalise"><i class="fa fa-times" aria-hidden="true"></i></button>';
                            else {
                                html += '<button type="button" data-toggle="tooltip" class="btn btn-sm btn-success"' + 'onclick="finaliseUserCardMapping(' + row.UserCardMappingId + ')" title="Finalise"><i class="fa fa-check" aria-hidden="true"></i></button>&nbsp';
                                html += '<button type="button" data-toggle="tooltip" class="btn btn-sm btn-warning"' + 'onclick="editUserCardMapping(' + row.UserCardMappingId + ', \'' + row.AssignedDateNew + '\')" title="Edit"><i class="fa fa-edit" aria-hidden="true"></i></button>&nbsp';
                                html += '<button type="button" data-toggle="tooltip" class="btn btn-sm btn-danger"' + 'onclick="deleteUserCardMapping(' + row.UserCardMappingId + ',\'' + row.EmployeeName + '\')" title="Delete"><i class="fa fa-trash" aria-hidden="true"></i></button>';
                            }
                            html += '</div>'
                            return html;
                        }
                    },
                ]
            });
        });
}

    function deleteUserCardMapping(userCardMappingId,EmployeeName) {
    var d = new Date();
    var month = d.getMonth() + 1;
    var day = d.getDate();
    var output = (month < 10 ? '0' : '') + month + '/' + (day < 10 ? '0' : '') + day + '/' + d.getFullYear();
    $("#txtTillDate").val(output);
    $("#txtEmpName").val(EmployeeName);
    $("#deleteModal").modal('show');
    $("#hdnCardId").val(userCardMappingId);
    $('#datePicker').datepicker({
        format: "mm/dd/yyyy",
        autoclose: true,
    }).datepicker('setEndDate', new Date());
}

    function deleteUserCard() {
        var reply = misConfirm("Are you sure you want to delete the mapping", "Confirm", function (reply) {
            if (reply) {
                var jsonObject = {
                    userCardMappingId: $("#hdnCardId").val(),
                    userAbrhs: misSession.userabrhs,
                    aasignedTill: $("#txtTillDate").val()
                };

                calltoAjax(misApiUrl.deleteUserCardMapping, "POST", jsonObject,
                    function (result) {
                        if (result === 1) {
                            misAlert("Request processed successfully.", "Success", "success");
                            $("#deleteModal").modal('hide');
                            loadUserCardMappingGrid();
                            loadUserUnMappedCardHistoryGrid();
                           }
                        else if (result === 2)
                            misAlert("Deactivation date should be greater than or equal to issued date. Try again", "Warning", "warning");
                        else
                            misAlert("Unable to process request. Try again", "Error", "error");

                    });
            }
        });
    }

    function finaliseUserCardMapping(userCardMappingId) {
        var reply = misConfirm("Are you sure you want to finalise the mapping", "Confirm", function (reply) {
            if (reply) {
                var jsonObject = {
                    userCardMappingId: userCardMappingId,
                    userAbrhs: misSession.userabrhs
                };

                calltoAjax(misApiUrl.finaliseUserCardMapping, "POST", jsonObject,
                    function (result) {
                        if (result)
                            misAlert("Request processed successfully.", "Success", "success");
                        else
                            misAlert("Unable to process request. Try again", "Error", "error");
                        loadUserCardMappingGrid()
                    });
            }
        });
    }

    function addNewMapping() {
        $("#modal-addUserCardMapping").modal('show');
        $("#userCardMappingModalTitle").text("Add new user-access card mapping");
        $("#updateUserAccessCardbtn").hide();
        $("#addUserAccessCardbtn").show();
        $("#editEmployee").hide();
        $("#employeeDetail").show();
        $("#staffDetail").hide();
        $("#isPimco").show();
        $(".select2-container").show();
        $("#btnSwitch").show();
        bindUnmappedUsers();
        bindUnmappedStaff();
        bindAccessCards(0);
        $("#isPimcoUserCardMapping").attr("checked", false);
        $('#userType').prop('checked', true);
        $(".toggle").removeClass("off");
        $("#assignedDate").show();
        
        $('#fromPicker').datepicker({
            format: "mm/dd/yyyy",
            autoclose: true,
        }).datepicker('setDate', new Date());
        
        $('#fromPicker').datepicker({
            format: "mm/dd/yyyy",
            autoclose: true,
        }).datepicker('setEndDate', _nextDate);
        $("#joingDiv").hide();
    }
   
    function editUserCardMapping(userCardMappingId, assignedFrom) {

        var givenDate = new Date(assignedFrom);
        $('#fromPicker').datepicker({
            format: "mm/dd/yyyy",
            autoclose: true,
        }).datepicker('setEndDate', _nextDate);

        _userCardMappingId = userCardMappingId;
        $("#modal-addUserCardMapping").modal('show');
        $("#btnSwitch").hide();
        $("#staffDetail").hide();
        $("#employeeDetail").show();
        $("#assignedDate").show();

        $('#fromPicker').datepicker({
            format: "mm/dd/yyyy",
            autoclose: true,
        }).datepicker('setDate', givenDate);

        $("#isPimco").show();
        $("#userCardMappingModalTitle").text("Modify user-acess card mapping");
        $("#updateUserAccessCardbtn").show();
        $("#addUserAccessCardbtn").hide();
        $("#editEmployee").empty(); $("#editEmployee").show();
        $("#employee").hide();
        $(".select2-container").hide();
        $("#isPimcoUserCardMapping").attr("checked", false);
       
        bindAccessCards(1); //value = 1 when this function is called under edit . value = 0 when called under add
        getUserCardMappingInfo(userCardMappingId);
    }

    var _employeeName;
    var _accessCardNo;

    function finalAddUserCardMapping() {
     
                if ($("#userType").is(':checked')) {
                    $("#staff").removeClass("validation-required");
                    $("#employee").addClass("validation-required");
                }
                else {
                    $("#employee").removeClass("validation-required");
                    $("#staff").addClass("validation-required");
                    //$('#isPimcoUserCardMapping').prop('checked', false);
                }
                if (!validateControls('modal-addUserCardMapping')) {
                    return false;
                }
                var isPimcoUserCardMapping = false;

                if ($("#isPimcoUserCardMapping").is(':checked'))
                    isPimcoUserCardMapping = true;

                if ($("#userType").is(':checked')) {
                    _employeeAbrhs = $("#employee").val();
                    _employeeName = $("#employee option:selected").text();
                  
                    _isStaff = false;
                }
                else {
                    _isStaff = true;
                    _employeeAbrhs = $("#staff").val();
                    _employeeName = $("#staff option:selected").text();
                }

                _accessCardNo = $("#accessCardNo option:selected").text();

                var dt = $("#txtFrom").val();
                var jsonObject = {
                    accessCardId: $("#accessCardNo").val(),
                    employeeAbrhs: _employeeAbrhs,
                    isPimcoUserCardMapping: isPimcoUserCardMapping,
                    userAbrhs: misSession.userabrhs,
                    isStaff: _isStaff,
                    fromDate: dt
                };

                calltoAjax(misApiUrl.addUserAccessCardMapping, "POST", jsonObject,
                    function (result) {
                        if (result.Success === 1) {
                            
                            reply = misConfirm("Access Card No. " + _accessCardNo + " has been assigned to " + _employeeName+ " successfully. \nAre you sure you want to finalize this access card?", "Confirm",
                                function (reply) {
                                    if (reply) {
                                        var jsonObject = {
                                            userCardMappingId: result.UserMappingId,
                                            userAbrhs: misSession.userabrhs
                                        };
                                        calltoAjax(misApiUrl.finaliseUserCardMapping, "POST", jsonObject,
                                            function (result) {
                                                if (result)
                                                    misAlert("Access card has been finalized successfully.", "Success", "success");
                                                else
                                                    misAlert("Unable to process request. Try again", "Error", "error");
                                            });
                                    }
                                    bindUnmappedUsers();
                                    bindUnmappedStaff();
                                    bindAccessCards(0);
                                    $("#joingDiv").hide();
                                    loadUserCardMappingGrid();
                                    loadUserUnMappedCardHistoryGrid();
                                });
                          
                        }
                        else if (result.Success === 2)
                            misAlert("Assign from date should be greater than assign till date of old card. Try again", "Warning", "warning");
                        else if (result.Success === 0)
                            misAlert("Unable to process request. Try again", "Error", "error");
                    });
    }

    function bindUnmappedStaff() {
        $('#staff').empty();
        $("#staff").append("<option value='0'>Select</option>");

        calltoAjax(misApiUrl.getAllUnmappedStaff, "POST", '',
            function (result) {
                $.each(result, function (index, result) {
                    $("#staff").append("<option value=" + result.StaffAbrhs + ">" + result.StaffName + "</option>");
                });
            });
        //$('#staff').select2();
    }

    function bindUnmappedUsers() {
        $('#employee').empty();
        $("#employee").append("<option value='0'>Select</option>");

        calltoAjax(misApiUrl.getAllUnmappedUser, "POST", '',
            function (result) {
                $.each(result, function (index, result) {
                    $("#employee").append("<option value=" + result.EmployeeAbrhs + ">" + result.EmployeeName + "</option>");
                });
            });
        //$('#employee').select2();
    }

    $("#employee").on('change', function () {
   
    if ($("#employee").val() != 0) {
        $("#joingDiv").show();
        calltoAjax(misApiUrl.getAllUnmappedUser, "POST", '',
            function (result) {
                $.each(result, function (index, result) {
                    if (result.EmployeeAbrhs == $("#employee").val())
                        $("#joiningDate").val(result.JoiningDate);
                });
            });
    }
    else
        $("#joingDiv").hide();

    });

    $("#userType").change(function () {
    if (!$("#userType").is(':checked')) {
        $("#joingDiv").hide();
    }
    else {
        if($("#employee").val() != 0)
            $("#joingDiv").show();
        else
            $("#joingDiv").hide();
    }
});

    function bindAccessCards(value) {
        $('#accessCardNo').empty();
        $("#accessCardNo").append("<option value='0'>Select</option>");

        calltoAjax(misApiUrl.getAllUnmappedAccessCard, "POST", '',
            function (result) {
                $.each(result, function (index, result) {
                    $("#accessCardNo").append("<option value=" + result.Id + ">" + result.EntityName + "</option>");
                });
            });
        $('#accessCardNo').select2();

        if (value === 1) {
            var jsonObject = {
                userCardMappingId: _userCardMappingId,
            };
            calltoAjax(misApiUrl.getUserCardMappingInfoById, "POST", jsonObject,
                function (result) {
                    $("#accessCardNo").append("<option value=" + result.AccessCardId + ">" + result.AccessCardNo + "</option>");
                    $("#accessCardNo").val(result.AccessCardId);
                });
        }
    }

    function changeUserCardMappingPreference() {
        if ($('input:checkbox[id=isPimcoUserCardMapping]').is(':checked') === false)
            $("#isPimcoUserCardMapping").attr("checked", false);
        else
            $("#isPimcoUserCardMapping").attr("checked", true);
    }

    function getUserCardMappingInfo(userCardMappingId) {
        $("#employee").empty();
        var jsonObject = {
            userCardMappingId: userCardMappingId,
        };
        calltoAjax(misApiUrl.getUserCardMappingInfoById, "POST", jsonObject,
            function (result) {
                if (result !== null) {
                    $("#editEmployee").text(result.EmployeeName);
                    if (result.IsPimcoUserCardMapping === true)
                        $("#isPimcoUserCardMapping").attr("checked", true);
                    else
                        $("#isPimcoUserCardMapping").attr("checked", false);
                }
                else
                    misAlert("Unable to process request. Try again", "Error", "error");
            });
    }

    function updateUserCardMapping() {

        $("#employee").removeClass("validation-required")
        $("#staff").removeClass("validation-required")
        //$("#txtFrom").removeClass("validation-required");

        if (!validateControls('modal-addUserCardMapping')) {
            return false;
        }

        var isPimcoUserCardMapping = false;
        if ($("#isPimcoUserCardMapping").is(':checked'))
            isPimcoUserCardMapping = true;
        var jsonObject = {
            userCardMappingId: _userCardMappingId,
            accessCardId: $("#accessCardNo").val(),
            isPimcoUserCardMapping: isPimcoUserCardMapping,
            assignedFrom: $("#txtFrom").val(),
            userAbrhs: misSession.userabrhs
        };
        calltoAjax(misApiUrl.updateUserAccessCardMapping, "POST", jsonObject,
            function (result) {
                if (result) {
                    misAlert("Request processed successfully", "Success", "success");
                    $("#modal-addUserCardMapping").modal('hide');
                    loadUserCardMappingGrid();
                    loadUserUnMappedCardHistoryGrid();
                }
                else
                    misAlert("Unable to process request. Try again", "Error", "error");
            });
    }

    $("#btnClose").click(function () {
        $("#modal-addUserCardMapping").modal('hide');
    });
