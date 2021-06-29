var _ajaxCallBasePath = window.location.pathname;
var UserRole, UserDesignation, IsHRVerifier;
function getcurrentUser() {

    var jsonObject = {
        'userAbrhs': misSession.userabrhs
    };
    calltoAjax(misApiUrl.getUserDetailsByUserId, "POST", jsonObject,
        function (data) {
            UserRole = (data.RoleName);
            UserDesignation = (data.Designation);
            IsHRVerifier = data.IsHRVerifier;
            GetPendingRequest();
            GetApprovedRejectedRequest();
    });
}

$(document).ready(function () {

    getcurrentUser();
   
});

function approveRequest(ApplicationId, status, period) {
    prompt(period);
    var Remarks = prompt("Enter Remarks", "Approved");
    if (Remarks != null) {
        var data = new Object();
        var isForwarded = false;

        data.leaveApplicationId = parseInt(ApplicationId);
        data.status = status;
        data.remarks = Remarks;
        data.period = period;

        var jsondata = JSON.stringify(data);
        $.ajax({
            url: _ajaxCallBasePath + "/TakeActionOnDataChangeRequest",
            type: 'POST',
            contentType: "application/json; charset=utf-8",
            data: jsondata,
            dataType: 'json',
            success: function(data) {
                //console.log(data);
                if (data.d.Result == true)
                    GetPendingRequest();
                GetApprovedRejectedRequest();
                misAlert("Approved", 'Success', 'success');
            }
        });
    }
}

function RejectRequest(ApplicationId, period) {
    var reply = misConfirm("Are you sure you want to reject this request ?", "Confirm", function (reply) {
        if (reply) {
            var rejectLeaveRemarks = prompt("Enter Remarks", "Rejected");
            if (rejectLeaveRemarks != null) {
                var data = new Object();

                data.leaveApplicationId = ApplicationId;
                data.status = "RJ";
                data.remarks = rejectLeaveRemarks;
                data.period = period;

                var jsondata = JSON.stringify(data);
                $.ajax({
                    url: _ajaxCallBasePath + "/TakeActionOnDataChangeRequest",
                    type: 'POST',
                    contentType: "application/json; charset=utf-8",
                    data: jsondata,
                    dataType: 'json',
                    success: function (data) {
                        if (data.d.Result == true)
                            GetPendingRequest();
                        GetApprovedRejectedRequest();
                        misAlert("Rejected", 'Success', 'success');
                    }
                });
            }
        }
    });
}

function GetPendingRequest() {
    
    var data = new Object();
    data.status = "PA";
    var jsondata = JSON.stringify(data);
    $.ajax({
        url: _ajaxCallBasePath + "/GetDataChangeRequest",
        type: 'POST',
        contentType: "application/json; charset=utf-8",
        data: jsondata,
        dataType: 'json',
        success: function (data) {
            //console.log(data);
            if (IsHRVerifier == true) {
              //  alert(UserDesignation);
                ShowPendingRequestForHR(data);
            } else {
                ShowPendingRequest(data);
            }
        }
    });
}

function GetApprovedRejectedRequest() {
    var data = new Object();
    data.status = "AP";
    var jsondata = JSON.stringify(data);
    $.ajax({
        url: _ajaxCallBasePath + "/GetDataChangeRequest",
        type: 'POST',
        contentType: "application/json; charset=utf-8",
        data: jsondata,
        dataType: 'json',
        success: function (data) {
            //console.log(data);
            if (IsHRVerifier == true) {
                
                ShowApprovedRejectedRequestForHR(data);
            } else {
                ShowApprovedRejectedRequest(data);
            }
        }
    });
}

function ShowPendingRequest(data) {
    $("#pendingRequestGrid").html('');
    _result = data.d.Result;
    //console.log(_result);
    if (_result == null) {
        $("#pendingRequestGrid").html("<h3 align = 'center'>No data to display.</h3>");
    }
    else {

        $("#pendingRequestGrid").kendoGrid({
            dataSource: {
                data: _result,
                pageSize: 6
            },
            height: 320,
            filterable: {
                mode: "row"
            },
            editable: { mode: "inline" },
            pageable: true,
            columns:
            [
            {
                title: "EmployeeName",
                // template: '<a  onclick="ViewLeaveApplication(#:LeaveApplicationId#)" >#:EmployeeName#</a>',
                width: 50,
                field: "EmployeeName",
                width: 35,
                title: "Employee Name",
                filterable: {
                    cell: {
                        showOperators: false,
                        operator: "contains"
                    }
                }
            },

            {
                field: "Category",
                width: 35,
                title: "Category",
                filterable: {
                    cell: {
                        showOperators: false,
                        operator: "contains"
                    }
                }
            },
             {
                 field: "ChangePeriod",
                 width: 35,
                 title: "Period",
                 filterable: false
             },
            {
                field: "Reason",
                width: 35,
                title: "Reason of Request",
                filterable: false
            },
            {
                field: "Remarks",
                width: 35,
                title: "Remarks",
                filterable: false
            },

            {
              title: "Approve",
              template: '<input type = "button" class="k-button" value = "Approve" onclick="approveRequest(#:DataChangeRequestApplicationId#,' + "'PV'" + ',\'#:ChangePeriod#\')"/>',
              width: 20
          },
            {
                title: "Reject",
                template: '<input type = "button" class="k-button" value = "Reject" onclick="RejectRequest(#:DataChangeRequestApplicationId#,\'#:ChangePeriod#\')"/>',
                width: 20
            }
            ]
        });
    }
}

function ShowApprovedRejectedRequest(data) {
    _result = data.d.Result;
    $("#approvedGrid").html('');
        if (_result == null) {
            $("#approvedGrid").html("<h3 align = 'center'>No data to display.</h3>");
        }
        else {

            $("#approvedGrid").kendoGrid({
                dataSource: {
                    data: _result,
                    pageSize: 6
                },
                height: 320,
                filterable: {
                    mode: "row"
                },
                editable: { mode: "inline" },
                pageable: true,
                columns:
                [
                {
                    title: "EmployeeName",
                    // template: '<a  onclick="ViewLeaveApplication(#:LeaveApplicationId#)" >#:EmployeeName#</a>',
                    width: 50,
                    field: "EmployeeName",
                    width: 35,
                    title: "Employee Name",
                    filterable: {
                        cell: {
                            showOperators: false,
                            operator: "contains"
                        }
                    }
                },

                {
                    field: "Category",
                    width: 35,
                    title: "Category",
                    filterable: {
                        cell: {
                            showOperators: false,
                            operator: "contains"
                        }
                    }
                },
                 {
                     field: "ChangePeriod",
                     width: 35,
                     title: "Period",
                     filterable: false
                 },
                {
                    field: "Reason",
                    width: 35,
                    title: "Reason of Request",
                    filterable: false
                },
                {
                    field: "Remarks",
                    width: 35,
                    title: "Remarks",
                    filterable: false
                },

                {
                    field: "Status",
                    width: 35,
                    title: "Status",
                    filterable: false
                },
            
                ]
            });
        }
}

function ShowPendingRequestForHR(data) {
            _result = data.d.Result;
            if (_result == null) {
                $("#pendingRequestGrid").html("<h3 align = 'center'>No data to display.</h3>");
            }
            else {

                $("#pendingRequestGrid").kendoGrid({
                    dataSource: {
                        data: _result,
                        pageSize: 6
                    },
                    height: 320,
                    filterable: {
                        mode: "row"
                    },
                    editable: { mode: "inline" },
                    pageable: true,
                    columns:
                    [
                    {
                        title: "EmployeeName",
                        // template: '<a  onclick="ViewLeaveApplication(#:LeaveApplicationId#)" >#:EmployeeName#</a>',
                        width: 50,
                        field: "EmployeeName",
                        width: 35,
                        title: "Employee Name",
                        filterable: {
                            cell: {
                                showOperators: false,
                                operator: "contains"
                            }
                        }
                    },

                    {
                        field: "Category",
                        width: 35,
                        title: "Category",
                        filterable: {
                            cell: {
                                showOperators: false,
                                operator: "contains"
                            }
                        }
                    },
                     {
                         field: "ChangePeriod",
                         width: 35,
                         title: "Period",
                         filterable: false
                     },
                    {
                        field: "Reason",
                        width: 35,
                        title: "Reason of Request",
                        filterable: false
                    },
                    {
                        field: "Remarks",
                        width: 35,
                        title: "Remarks",
                        filterable: false
                    },

                    {
                        field: "Status",
                        width: 35,
                        title: "Status",
                        filterable: false
                    },
                  {
                      title: "Approve",
                      template: '<input type = "button" class="k-button" value = "Verify" onclick="approveRequest(#:DataChangeRequestApplicationId#,' + "'AP'" + ',\'#:ChangePeriod#\')"/>',
                      width: 20
                  },
                    {
                        title: "Reject",
                        template: '<input type = "button" class="k-button" value = "Reject" onclick="RejectRequest(#:DataChangeRequestApplicationId#,\'#:ChangePeriod#\')"/>',
                        width: 20
                    }
                    ]
                });

            }
}

function ShowApprovedRejectedRequestForHR(data) {
            _result = data.d.Result;
            if (_result == null) {
                $("#approvedGrid").html("<h3 align = 'center'>No data to display.</h3>");
            }
            else {

                $("#approvedGrid").kendoGrid({
                    dataSource: {
                        data: _result,
                        pageSize: 6
                    },
                    height: 320,
                    filterable: {
                        mode: "row"
                    },
                    editable: { mode: "inline" },
                    pageable: true,
                    columns:
                    [
                    {
                        title: "EmployeeName",
                        // template: '<a  onclick="ViewLeaveApplication(#:LeaveApplicationId#)" >#:EmployeeName#</a>',
                        width: 50,
                        field: "EmployeeName",
                        width: 35,
                        title: "Employee Name",
                        filterable: {
                            cell: {
                                showOperators: false,
                                operator: "contains"
                            }
                        }
                    },

                    {
                        field: "Category",
                        width: 35,
                        title: "Category",
                        filterable: {
                            cell: {
                                showOperators: false,
                                operator: "contains"
                            }
                        }
                    },
                     {
                         field: "ChangePeriod",
                         width: 35,
                         title: "Period",
                         filterable: false
                     },
                    {
                        field: "Reason",
                        width: 35,
                        title: "Reason of Request",
                        filterable: false
                    },
                    {
                        field: "Remarks",
                        width: 35,
                        title: "Remarks",
                        filterable: false
                    },

                    {
                        field: "Status",
                        width: 35,
                        title: "Status",
                        filterable: false
                    },
                   
                    ]
                });

            }
        }

    
