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
    $('#AttendanceDate').datepicker({ autoclose: true, todayHighlight: true }).datepicker('setEndDate', new Date());
    var myDate = new Date();
    var date = ('0' + (myDate.getMonth() + 1)).slice(-2) + '/' + ('0' + myDate.getDate()).slice(-2) + '/' + myDate.getFullYear();
    $("#AttendanceDate input").val(date);
    loadLeaveBalanceForAllEmployeeGrid();
});
function removeAlphabets(e) {
    $("#" + e.id).val($("#" + e.id).val().replace(/[^0-9.]/g, ''));
}
function loadLeaveBalanceForAllEmployeeGrid() {
    var jsonObject = {
        employeeAbrhs: '',
    }
    calltoAjax(misApiUrl.listLeaveBalanceForAllUser, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblLeaveBalance").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'Leave Balance For All Employee',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'Leave Balance For All Employee' },
                        { extend: 'pdf', filename: 'Leave Balance For All Employee' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                        { extend: 'print', filename: 'Leave Balance For All Employee' },
                        ]
                    }
                ],
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
                            var html = data.Name;
                            return html;
                        }
                    },
                    {
                        "mData": "ClCount",
                        "sTitle": "CL Count",
                    },
                    {
                        "mData": "PlCount",
                        "sTitle": "PL Count",
                    },
                    {
                        "mData": "CompOffCount",
                        "sTitle": "Comp Off Count",
                    },
                    {
                        "mData": "LwpCount",
                        "sTitle": "LWP Counter",
                    },
                    {
                        "className": "none",
                        "mData": null,
                        "sTitle": "ML/PL(M)",
                        //"sTitle": null,
                        //sRender: function (data, type, row) {
                        //    if (data.GenderId == 1)
                        //        return PL(M)
                        //    else
                        //        return data.MlCount
                        //},
                        mRender: function (data, type, row) {
                            if (data.GenderId == 1)
                                return data.PlmCount
                            else
                                return data.MlCount
                        }
                    },
                    {
                        "mData": "CloyAvailable",
                        "sTitle": "CLOY",
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        mRender: function (data, type, row) {
                            var html = '<button type="button" class="btn btn-sm teal" id="btn" data-toggle"model" data-target="#myModal"' + 'onclick="updateLeaveByHR(\'' + row.EmployeeAbrhs + '\')" data-toggle="tooltip" title="Edit"><i class="fa fa-edit"> </i></button>';
                            return html;
                        }
                    },
                ]
            });
        });
}
function updateLeaveByHR(employeeAbrhs) {
    $("#mypopupUpdateLeaveByHR").modal("show");
    $("#allocationCount").val("");
    var jsonObject = {
        'employeeAbrhs': employeeAbrhs
    };
    calltoAjax(misApiUrl.listLeaveBalanceByUserId, "POST", jsonObject,
        function (result) {
            $("#employeeAbrhs").val(employeeAbrhs);
            $("#ClCount").val(result.ClCount);
            $("#PlCount").val(result.PlCount);
            $("#CompOffCount").val(result.CompOffCount);
            $("#LwpCount").val(result.LwpCount);
            if (result.GenderId == 2) {
                $("#mLCount").val(result.MlCount);
                document.getElementById('leaveType').innerHTML = 'ML';
                $("#leaveName").html("ML");
                $("#allocationCount").val(result.AllocationCount);
            }
            if (result.GenderId == 1) {
                $("#mLCount").val(result.PlmCount);
                document.getElementById('leaveType').innerHTML = 'PL(M)';
                $("#leaveName").html("PL(M)");
                $("#allocationCount").val(result.AllocationCount);
            }
            if ($("#allocationCount").val() > 1 && $('#lType').hasClass('active') == true) {
                $('#updateLeaveBalanceByHR').prop('disabled', true);
            }
            else
                $('#updateLeaveBalanceByHR').prop('disabled', false);
            if (result.CloyAvailable == "Available") {
                $("#5ClCount").val(1);
            }
            else {
                $("#5ClCount").val(2);
            }
        });
}
$("#cType").click(function () {
    $('#updateLeaveBalanceByHR').prop('disabled', false);
});
$("#lType").click(function () {
    if ($("#allocationCount").val() > 1) {
        $('#updateLeaveBalanceByHR').prop('disabled', true);
        //$('#updateLeaveBalanceByHR').addClass('disabled');
    }
});
function updateLeaveBalanceDetails() {
    var t = 0;
    if (!validateControls('employeeLeaveBalanceDiv'))
        return false;
    var Clcount5 = "";
    if ($("#5ClCount").val() == 1) {
        Clcount5 = "Available";
    }
    else {
        Clcount5 = "Availed";
    }
    if ($('#lType').hasClass('active') == true)
        t = 2;
    else t = 1;
    var jsonObject = {
        "type": t,
        "employeeAbrhs": $("#employeeAbrhs").val(),
        "ClCount": $("#ClCount").val(),
        "PlCount": $("#PlCount").val(),
        "CompOffCount": $("#CompOffCount").val(),
        "LwpCount": $("#LwpCount").val(),
        "Cloy": Clcount5,
        "mLCount": $("#mLCount").val(),
        "allocationCount": $("#allocationCount").val(),
        "userAbrhs": misSession.userabrhs
    };
    calltoAjax(misApiUrl.updateLeaveBalanceByHR, "POST", jsonObject,
        function (result) {
            if (result == true) {
                misAlert("Request processed successfully", "Success", "success");
                $("#mypopupUpdateLeaveByHR").modal("hide");
                loadLeaveBalanceForAllEmployeeGrid();
            } else {
                misAlert("Unable to process request. please try again", "Error", "error");
            }
        });
}
function getAttendanceForAllEmployees() {
    if ($("#AttendanceDate input").val() == "") {
        return false;
    }
    var jsonObject = {
        'date': $("#AttendanceDate input").val()
    };
    calltoAjax(misApiUrl.fetchAllEmployeesAttendance, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblAttendenceStatus").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'All Employees Attendance',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'All Employees Attendance' },
                        { extend: 'pdf', filename: 'All Employees Attendance' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                        { extend: 'print', filename: 'All Employees Attendance' },
                        ]
                    }
                ],
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
                            var html = data.UserName;
                            return html;
                        }
                    },
                    {
                        "mData": "Day",
                        "sTitle": "Day",
                    },
                    {
                        "mData": "InTime",
                        "sTitle": "In Time",
                    },
                    {
                        "mData": "OutTime",
                        "sTitle": "Out Time",
                    },
                    {
                        "mData": "WorkingHours",
                        "sTitle": "Working Hours",
                    },
                    {
                        "mData": "Remarks",
                        "sTitle": "Remarks",
                    },
                ]
            });
        });
}
$("#btnClose").click(function () {
    $("#mypopupUpdateLeaveByHR").modal("hide");
});
$("#AttendenceStatus").click(function () {
    getAttendanceForAllEmployees();
});