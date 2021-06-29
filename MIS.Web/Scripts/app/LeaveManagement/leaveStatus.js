var _ajaxCallBasePath = window.location.pathname, _result, _applicationId, _type;

$(document).ready(function () {
    var date = new Date();
    var month = date.getMonth();
    var year = date.getFullYear();
    $("#currentYear").html(year);
    $("#nextYear").html(year + 1);
    loadFinancialYearDDL();

    $('#financialYearScroll').on('change', function () {
        var year = parseInt($("#financialYearScroll").val());
        var tabId = $("#tabs a.active").attr('href');
        getDataByMonthYear(tabId);
        $("#currentYear").html(year);
        $("#nextYear").html(year + 1);
    });

    $('#tabs a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
        var targetTabId = $(e.target).attr("href"); // activated tab
        getDataByMonthYear(targetTabId);
    });
});

function loadFinancialYearDDL() {
    calltoAjax(misApiUrl.getFinancialYearsForUser, "POST", '', function (result) {
        if (result !== null)
            $.each(result, function (index, item) {
                $("#financialYearScroll").append($("<option></option>").val(item.StartYear).html(item.Text));
            });
        //$('#financialYearScroll [value=' + year + ']').prop('selected', true);
        var tabId = $("#tabs a.active").attr('href');
        getDataByMonthYear(tabId);
    });
}
function getDataByMonthYear(activeTabId) {
    var year = $("#financialYearScroll").val();

    if (activeTabId === "#tabApplyLeave")
        loadLeaveManagementGrid(year);
    else if (activeTabId === "#tabApplyWFH")
        loadWFHGrid(year);
    else if (activeTabId === "#tabApplyCompOff")
        loadCompOffGrid(year);
    else if (activeTabId === "#tabLWPChangeRequest") {
        loadLegitimateRequestGrid(year);
        loadDataChangeRequestGrid(year);
    }
    else if (activeTabId === "#tabApplyOnDutyReq")
        loadApplyOutingRequestGrid(year);
}
function loadLeaveManagementGrid(year) {
    var jsonObject = {
        'userAbrhs': misSession.userabrhs,
        year: year
    };
    calltoAjax(misApiUrl.listLeaveByUserId, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblLeaveHistory").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'Leave History List',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'Leave History List' },
                        { extend: 'pdf', filename: 'Leave History List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                        { extend: 'print', filename: 'Leave History List' },
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
                        "sTitle": "Period",
                        "sWidth": "90px",
                        mRender: function (data, type, row) {
                            var html = data.DisplayFromDate + " to " + data.DisplayTillDate;
                            return html;
                        }
                    },
                    {
                        "mData": "LeaveType",
                        "sTitle": "Type",
                    },
                    {
                        "mData": "Reason",
                        "sTitle": "Reason",
                    },
                    {
                        "mData": null,
                        "sTitle": "Remarks",
                        mRender: function (data, type, row) {
                            var html = '<a  onclick="showRemarksPopup(' + row.LeaveId + ',' + "'LEAVE'" + ')" >' + row.Remarks + '</a>';
                            return html;
                        }
                    },
                    {
                        "mData": "Status",
                        "sTitle": "Status",
                    },
                    {
                        "mData": null,
                        "sTitle": "Applied On",
                        "sWidth": "90px",
                        mRender: function (data, type, row) {
                            var html = data.DisplayApplyDate;
                            return html;
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        "sWidth": "120px",
                        mRender: function (data, type, row) {
                            var html = "";
                            var leaveType = "LEAVE";
                            if (row.CancelDisabled === "") {
                                html = '<button type="button" class="btn btn-sm btn-danger" data-toggle"model" data-target="#myModal"' + 'onclick="cancelLeave(' + row.LeaveId + ',\'' + leaveType + '\')" data-toggle="tooltip" title="Cancel"><i class="fa fa-times"></i></button>';
                            }
                            else {
                                html = "";
                            }

                            if ((row.Remarks === 'Marked by system' || row.Reason === 'No data found') && row.StatusCode === "AV") {
                                if (row.IsApplied === true)
                                    html = "LWP change request applied on " + row.LWPChangeRequestAppliedOn;
                                else
                                    html = "";
                            }
                            
                            return html;
                        }
                    },
                ],
                "fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                    if ((aData.Remarks === 'Marked by system' || aData.Reason === 'No data found') && aData.StatusCode === "AV") {
                        $('td', nRow).css('background-color', '#f3f3a0');
                    }
                    else if (aData.StatusCode === "CA") {
                        $('td', nRow).css('background-color', '#c2cbd2');
                    }
                    else if (aData.StatusCode === "RJ") {
                        $('td', nRow).css('background-color', '#f3a0a0');
                    }
                }
            });
        });
}

//data - toggle"model" data- target="#myLegitimateModal"




function cancelLeave(LeaveApplicationId, leaveType) {

    var reply = misConfirm("Are you sure you want to cancel this request ?", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                'leaveApplicationId': LeaveApplicationId,
                'remarks': "Cancelled",
                'userAbrhs': misSession.userabrhs,
                'isCancelByHR': 0,
                'forLeaveType': 'LEAVE',
                'type':"All"
            };
            calltoAjax(misApiUrl.cancelLeave, "POST", jsonObject,
                function (result) {
                    if (result === 0) {
                        misAlert("Request processed successfully", "Success", "success");
                        var year1 = $("#financialYearScroll").val();
                        if (leaveType === "WFH") {
                            loadWFHGrid(year1);
                        }
                        else {
                            loadLeaveManagementGrid(year1);
                        }
                    }
                    else if (result === 1) {
                        misAlert("Unable to process request. Please try again", "Error", "error");
                    }
                    else if (result === 2) {
                        misAlert("Oops ! Availed leave cannot be cancelled, please contact HR", "Warning", "warning");
                    }
                });
        }
    });


}
function loadWFHGrid(year) {
    var jsonObject = {
        'userAbrhs': misSession.userabrhs,
        year: year
    };
    calltoAjax(misApiUrl.listWorkFromHomeByUserId, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblWFHHistory").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'WFH History List',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'WFH History List' },
                        { extend: 'pdf', filename: 'WFH History List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                        { extend: 'print', filename: 'WFH History List' },
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
                        "sTitle": "Period",
                        "sWidth": "90px",
                        mRender: function (data, type, row) {
                            var html = data.DisplayFromDate;
                            return html;
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Half Day",
                        mRender: function (data, type, row) {
                            var html = "NO";
                            if (data.IsHalfDay) {
                                html = "YES";
                            }
                            return html;
                        }
                    },
                    {
                        "mData": "Reason",
                        "sTitle": "Reason",
                    },
                    {
                        "mData": null,
                        "sTitle": "Remarks",
                        mRender: function (data, type, row) {
                            var html = '<a  onclick="showRemarksPopup(' + row.LeaveId + ',' + "'WFH'" + ')" >' + row.Remarks + '</a>';
                            return html;
                        }
                    },
                    {
                        "mData": "Status",
                        "sTitle": "Status",
                    },
                    {
                        "mData": null,
                        "sTitle": "Applied On",
                        mRender: function (data, type, row) {
                            var html = data.DisplayApplyDate;
                            return html;
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        "sWidth": "120px",
                        mRender: function (data, type, row) {
                            var html = "";
                            var leaveType = "WFH";
                            if (row.CancelDisabled === "") {
                                html = '<button type="button" class="btn btn-sm btn-danger" data-toggle"model" data-target="#myModal"' + 'onclick="cancelLeave(' + row.LeaveId + ',\'' + leaveType + '\')" data-toggle="tooltip" title="Cancel"><i class="fa fa-times"></i></button>';
                            }
                            else {
                                html = "";
                            }
                            return html;
                        }
                    },
                ],
                "fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                    if (aData.Remarks === 'Marked by system' && aData.StatusCode === "AV") {
                        $('td', nRow).css('background-color', '#f3f3a0');
                    }
                    else if (aData.StatusCode === "CA") {
                        $('td', nRow).css('background-color', '#c2cbd2');
                    }
                    else if (aData.StatusCode === "RJ") {
                        $('td', nRow).css('background-color', '#f3a0a0');
                    }
                }
            });
        });
}
function loadCompOffGrid(year) {
    var jsonObject = {
        'userAbrhs': misSession.userabrhs,
        year: year
    };
    calltoAjax(misApiUrl.listCompOffByUserId, "POST", jsonObject, function (result) {

        var data = $.parseJSON(JSON.stringify(result));

        $("#tblCompOffHistory").dataTable({
            "dom": 'lBfrtip',
            "buttons": [
                {
                    filename: 'CompOff History List',
                    extend: 'collection',
                    text: 'Export',
                    buttons: [{ extend: 'copy' },
                    { extend: 'excel', filename: 'CompOff History List' },
                    { extend: 'pdf', filename: 'CompOff History List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                    { extend: 'print', filename: 'CompOff History List' },
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
                    "mData": "DisplayFromDate",
                    "sTitle": "Applied for"
                },
                {
                    "mData": "NoOfDays",
                    "sTitle": "Days"
                },
                {
                    "mData": "Reason",
                    "sTitle": "Reason",
                },
                {
                    "mData": null,
                    "sTitle": "Remarks",
                    mRender: function (data, type, row) {
                        var html = '<a  onclick="showRemarksPopup(' + row.LeaveId + ',' + "'COFF'" + ')" >' + row.Remarks + '</a>';
                        return html;
                    }
                },
                {
                    "mData": "Status",
                    "sTitle": "Status",
                },
                {
                    "mData": "DisplayApplyDate",
                    "sTitle": "Applied On",
                },
                {
                    "mData": null,
                    "sTitle": "Availability",
                    mRender: function (data, type, row) {
                        if (row.StatusId > 0) {
                            var lapseStatus = row.IsLapsed;
                            var availStatus = row.AvailabilityStatus;
                            if (availStatus === 2)    //"Availed"
                                return "Availed"
                            else if (availStatus === 1 && (row.StatusCode === "PA" || row.StatusCode === "PV"))   //"Available"
                            {
                                if (lapseStatus)
                                    return "Lapsed";
                                return "Pending"
                            }
                            else if (availStatus === 1 && row.StatusCode === "AP")   //"Available"
                            {
                                if (lapseStatus)
                                    return "Lapsed";
                                return "Available"
                            }
                            else if (availStatus === 3)   //"Partially Availed"
                            {
                                if (lapseStatus)
                                    return "Lapsed";
                                return "Available(1 of 2)"
                            }

                        }
                        else
                            return "NA";
                    }
                },
                {
                    "mData": null,
                    "sTitle": "Lapse Date",
                    mRender: function (data, type, row) {
                        var html = "";
                        if (row.StatusCode !== "AP") {
                            html += "Not Approved";
                        }
                        else {
                            html += row.LapseDate;
                        }
                        return html;
                    }
                },
            ],
            "fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                if (aData.StatusCode === "RJ") {
                    $('td', nRow).css('background-color', '#f3a0a0');
                }
                else {
                    if (aData.AvailabilityStatus === 2)    //"Availed"
                        $('td', nRow).css('background-color', '#ffffb3');
                    else if (aData.AvailabilityStatus === 1 && aData.StatusCode === "AP")   //"Available"
                    {
                        if (aData.IsLapsed)
                            $('td', nRow).css('background-color', '#ff8080');
                        //else if (aData.StatusCode === "PV" || aData.StatusCode === "PA")
                        //    $('td', nRow).css('background-color', '#93afbd');
                        else
                            $('td', nRow).css('background-color', '#99ff99');
                    }
                    else if (aData.AvailabilityStatus === 3)   //"Partially Availed"
                    {
                        if (aData.IsLapsed)
                            $('td', nRow).css('background-color', '#ff8080');
                        else
                            $('td', nRow).css('background-color', '#ecb3ff');
                    }

                    //if (aData.IsLapsed) {
                    //    $('td', nRow).css('background-color', '#ff8080');
                    //}
                    //else if (!aData.IsLapsed && aData.AvailabilityStatus == 1) { //not lapsed and available
                    //    $('td', nRow).css('background-color', '#99ff99');
                    //}
                    //else if (!aData.IsLapsed && aData.AvailabilityStatus == 2) { //not lapsed and availed
                    //    $('td', nRow).css('background-color', '#ffffb3');
                    //}
                }
            }
        });
    });
}
function loadDataChangeRequestGrid(year) {
    var jsonObject = {
        'userAbrhs': misSession.userabrhs,
        year: year
    };
    calltoAjax(misApiUrl.listDataChangeRequestByUserId, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblDataChangeHistory").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'Data Change Request History List',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'Data Change Request History List' },
                        { extend: 'pdf', filename: 'Data Change Request History List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                        { extend: 'print', filename: 'Data Change Request History List' },
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
                        "mData": "Category",
                        "sTitle": "Category"
                    },
                    {
                        "mData": "Reason",
                        "sTitle": "Reason",
                    },
                    {
                        "mData": null,
                        "sTitle": "Remarks",
                        mRender: function (data, type, row) {
                            var html = '<a  onclick="showRemarksPopup(' + row.LeaveId + ',' + "'DATACHANGE'" + ')" >' + row.Remarks + '</a>';
                            return html;
                        }
                    },
                    {
                        "mData": "Status",
                        "sTitle": "Status",
                    },
                    {
                        "mData": "DisplayApplyDate",
                        "sTitle": "Applied On",
                    }
                ]
            });
        });
}

function showRemarksPopup(applicationId, type) {
    var jsonObject = {
        'requestId': applicationId,
        'type': type,
    };
    calltoAjax(misApiUrl.getApproverRemarks, "POST", jsonObject,
        function (result) {
            if (result !== "ERROR") {
                if (result === "") {
                    result = "NA";
                }
                $("#reviewLeaveRemark").val(result);
                $("#reviewLeaveRemark").attr('disabled', true);
                $("#mypopupReviewLeaveRemark").modal("show");
            }
        });
}

$("#btnClose").click(function () {
    $("#mypopupReviewLeaveRemark").modal("hide");
});



$("#lWPChangeRequest").on("click", function () {
    var year = $("#financialYearScroll").val();
    loadLegitimateRequestGrid(year);
})

function loadLegitimateRequestGrid(year) {
    var jsonObject = {
        'userAbrhs': misSession.userabrhs,
        year: year
    };
    calltoAjax(misApiUrl.listLegitimatetByUserId, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblLegitimateHistory").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'Leave History List',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'Leave History List' },
                        { extend: 'pdf', filename: 'Leave History List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                        { extend: 'print', filename: 'Leave History List' },
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
                        "sTitle": "Period",
                        "sWidth": "90px",
                        mRender: function (data, type, row) {
                            var html = data.FromDate;
                            return html;
                        }
                    },
                    {
                        "mData": "LeaveType",
                        "sTitle": "Type",
                    },
                    {
                        "mData": "Reason",
                        "sTitle": "Reason",
                    },
                    {
                        "mData": null,
                        "sTitle": "Remarks",
                        mRender: function (data, type, row) {
                            var html = '<a  onclick="showLWPChangeReqRemarksPopup(' + row.LeaveId + ',' + "'LEGITIMATE'" + ')" >' + row.Remarks + '</a>';
                            return html;
                        }
                    },
                    {
                        "mData": "Status",
                        "sTitle": "Status",
                    },
                    {
                        "mData": null,
                        "sTitle": "Applied On",
                        "sWidth": "90px",
                        mRender: function (data, type, row) {
                            var html = data.DisplayApplyDate;
                            return html;
                        }
                    },

                ],
                "fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                    if (aData.StatusCode === "RJM" || aData.StatusCode === "RJH") {
                        $('td', nRow).css('background-color', '#f3a0a0');
                    }
                    else if (aData.StatusCode === "CA") {
                        $('td', nRow).css('background-color', '#c2cbd2');
                    }
                    else if (aData.StatusCode === "VD") {
                        $('td', nRow).css('background-color', '#99ff99');
                    }
                }
            });
        });
}


function showLWPChangeReqRemarksPopup(applicationId, type) {
    var jsonObject = {
        'requestId': applicationId,
        'type': type,
    };
    calltoAjax(misApiUrl.getApproverRemarks, "POST", jsonObject,
        function (result) {
            if (result !== "ERROR") {
                if (result === "") {
                    result = "NA";
                }
                $("#reviewLeaveRemark").val(result);
                $("#reviewLeaveRemark").attr('disabled', true);
                $("#mypopupReviewLeaveRemark").modal("show");
            }
        });
}



