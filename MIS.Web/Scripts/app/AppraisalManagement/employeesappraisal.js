$(document).ready(function () {
    showLoader('tblEmplpyeeAppraisal', true);

    fetchAppraisalCycleFilter(misSession.currentappraisalcycleid);

    $('#ddlAppraisalStatusFilter').multiselect({
        includeSelectAllOption: true,
        enableFiltering: true,
        enableCaseInsensitiveFiltering: true,
        buttonWidth: false,
        onDropdownHidden: function (event) {
        }
    });

    $('#ddlApproverFilter').multiselect({
        includeSelectAllOption: true,
        enableFiltering: true,
        enableCaseInsensitiveFiltering: true,
        buttonWidth: false,
        onDropdownHidden: function (event) {
        }
    });

    $('#ddlAppraiserFilter').multiselect({
        includeSelectAllOption: true,
        enableFiltering: true,
        enableCaseInsensitiveFiltering: true,
        buttonWidth: false,
        onDropdownHidden: function (event) {
        }
    });
});

function fetchAppraisalCycleFilter(selectedId) {
    $('#ddlAppraisalCycleFilter').empty();
    calltoAjax(misApiUrl.getAppraisalCycleList, "POST", '',
        function (result) {
            if (result != null && result.length > 0) {
                $('#ddlAppraisalCycleFilter').append("<option value = 0>All</option>");
                for (var x = 0; x < result.length; x++) {
                    $('#ddlAppraisalCycleFilter').append("<option value = '" + result[x].Value + "'>" + result[x].Text + "</option>");
                }
                if (selectedId > 0) {
                    $('#ddlAppraisalCycleFilter').val(selectedId);
                }
            }
            fetchAppraisalStatusFilter();
        });
}

function fetchAppraisalStatusFilter() {
    $('#ddlAppraisalStatusFilter').multiselect('destroy');
    $('#ddlAppraisalStatusFilter').empty();
    $('#ddlAppraisalStatusFilter').multiselect();
    var selectValue = 0;
    calltoAjax(misApiUrl.getAppraisalStatus, "POST", '',
        function (result) {
            $.each(result, function (index, value) {
                $('<option selected>').val(value.Value).text(value.Text).appendTo('#ddlAppraisalStatusFilter');
            });
            $('#ddlAppraisalStatusFilter').multiselect("destroy");
            $('#ddlAppraisalStatusFilter').multiselect({
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                buttonWidth: false,
                onDropdownHidden: function (event) {
                }
            });
            fetchAppraiserFilter();
        });
}

function fetchAppraiserFilter() {
    $('#ddlAppraiserFilter').multiselect('destroy');
    $('#ddlAppraiserFilter').empty();
    $('#ddlAppraiserFilter').multiselect();
    var jsonObject = {
        'VerticalId': 1,
    };
    calltoAjax(misApiUrl.getAppraiserListByIDs, "POST", jsonObject,
        function (result) {
            $.each(result, function (index, value) {
                $('<option selected>').val(value.Value).text(value.Text).appendTo('#ddlAppraiserFilter');
            });
            $('#ddlAppraiserFilter').multiselect("destroy");
            $('#ddlAppraiserFilter').multiselect({
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                buttonWidth: false,
                onDropdownHidden: function (event) {
                }
            });
            fetchApproverFilter();
        });
}

function fetchApproverFilter() {
    $('#ddlApproverFilter').multiselect('destroy');
    $('#ddlApproverFilter').empty();
    $('#ddlApproverFilter').multiselect();
    var jsonObject = {
        'VerticalId': 1,
    };
    calltoAjax(misApiUrl.getApproverListByIDs, "POST", jsonObject,
        function (result) {
            $.each(result, function (index, value) {
                $('<option selected>').val(value.Value).text(value.Text).appendTo('#ddlApproverFilter');
            });
            $('#ddlApproverFilter').multiselect("destroy");
            $('#ddlApproverFilter').multiselect({
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                buttonWidth: false,
                onDropdownHidden: function (event) {
                }
            });

            BindEmployeesAppraisal();
        });
}

$("#ddlAppraisalCycleFilter").change(function () {
    BindEmployeesAppraisal();
});

$("#ddlApproverFilter").change(function () {
    BindEmployeesAppraisal();
});

$("#ddlAppraiserFilter").change(function () {
    BindEmployeesAppraisal();
});

$("#ddlAppraisalStatusFilter").change(function () {
    BindEmployeesAppraisal();
});

//$("#btnFilterSearch").click(function () {
//    if (!validateControls('divEmpAppraisal')) {
//        return false;
//    }
//    BindEmployeesAppraisal();
//});

function BindEmployeesAppraisal() {
    var statusIds = (($('#ddlAppraisalStatusFilter').val() != null && typeof $('#ddlAppraisalStatusFilter').val() != 'undefined' && $('#ddlAppraisalStatusFilter').val().length > 0) ? $('#ddlAppraisalStatusFilter').val().join(',') : '0');
    var AppraiserIds = (($('#ddlAppraiserFilter').val() != null && typeof $('#ddlAppraiserFilter').val() != 'undefined' && $('#ddlAppraiserFilter').val().length > 0) ? $('#ddlAppraiserFilter').val().join(',') : '0');
    var ApproverIds = (($('#ddlApproverFilter').val() != null && typeof $('#ddlApproverFilter').val() != 'undefined' && $('#ddlApproverFilter').val().length > 0) ? $('#ddlApproverFilter').val().join(',') : '0');

    var JsonObject = {
        AppraisalCycleId: $("#ddlAppraisalCycleFilter").val() || misSession.currentappraisalcycleid,
        AppraisalStatusIds: statusIds,
        AppraiserIds: AppraiserIds,
        ApproverIds: ApproverIds
    };
    calltoAjax(misApiUrl.getAllEmployeesAppraisal, "POST", JsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $('#tblEmplpyeeAppraisal').DataTable({
                "responsive": true,
                "autoWidth": false,
                "paging": true,
                "bDestroy": true,
                "searching": true,
                "ordering": true,
                "order": [],
                "info": true,
                "deferRender": true,
                "aaData": resultData,
                "aoColumns": [
                    {
                        "mData": null,
                        "sTitle": "Image",
                        "sClass": "text-center",
                        mRender: function (data, type, row) {
                            return "<td class='halign-center'><img  onerror=\"this.src='../img/avatar-sign.png'\"  src='" + misApiProfileImageUrl + data.EmployeePhotoName + "' class='img-circle' alt='User Image'><br/><b>" + data.EmployeeName + "</b></a><br/>" + data.DesignationName + "</td>";
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Details",
                        mRender: function (data, type, row) {
                            var htmldetails = "<td class='labels'>";
                            htmldetails += "<strong>Appraiser</strong> <span class='text-color'>" + data.AppraiserName + "</span><br/> ";
                            if (data.Approver1Name != null && data.Approver1Name != '') {
                                htmldetails += "<strong>Approver</strong> <span class='text-color'>" + data.Approver1Name + "</span><br/> ";
                            }
                            if (data.Approver2Name != null && data.Approver2Name != '') {
                                htmldetails += "<strong>Approver 2</strong> <span class='text-color'>" + data.Approver2Name + "</span><br/>";
                            }
                            if (data.Approver3Name != null && data.Approver3Name != '') {
                                htmldetails += "<strong>Approver 3</strong> <span class='text-color'>" + data.Approver3Name + "</span><br/> ";
                            }
                            htmldetails += "<strong>Status</strong> <span class='text-color'><a class='showForm small-text-value' data-toggle='tooltip' href='javascript:void(0);' title='" + data.AppraisalStatusName + "'  onclick='showStatusHistory(" + data.EmpAppraisalSettingId + ")'>" + data.AppraisalStatusName + "</a></span><br/>";
                            if (data.IsVisible == true) {
                                htmldetails += "<div> <strong>Appraisal Form</strong> <span class='text-color'><a class='showForm small-text-value appraisal-form-btn' data-toggle='tooltip' title='" + data.CompetencyFormName + "' href='javascript:void(0);' onclick='openForm(" + data.EmpAppraisalSettingId + ")'>" + data.CompetencyFormName + "</a></span></div><br/>"; //" + (Hashing.keyExists("tabId") ? Hashing.get('tabId') : 0) + "
                            }
                            else {
                                htmldetails += "<div><strong>Appraisal Form</strong> <span data-toggle='tooltip' title='" + data.CompetencyFormName + "' class='text-color small-text-value'>" + data.CompetencyFormName + "</span></div><br/>";
                            }
                            htmldetails += "</td>";
                            return htmldetails;
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Details",
                        mRender: function (data, type, row) {
                            var dates = "<td class='labels'>";
                            if (misSession.currentappraisalcycleid == data.AppraisalCycleId)
                                dates += "<strong>Appraisal Cycle</strong> <span class='label label-success'>" + data.AppraisalCycleName + "</span><br/> ";
                            else
                                dates += "<strong>Appraisal Cycle</strong> <span class='label label-danger'>" + data.AppraisalCycleName + "</span><br/> ";

                            dates += "<strong>Self Appraisal</strong> <span class='text-color'>" + ((data.IsSelfAppraisal == true) ? 'Yes' : 'No') + "</span><br/>";
                            dates += "<strong>Appraisal Starts From</strong> <span class='text-color'>" + data.StartDate + "</span><br/>";
                            if (data.AppraisalStatges != '') {
                                $.each(data.AppraisalStatges.split(","), function (key, splitvalue) {
                                    var b = splitvalue.split("#");
                                    if (b[0] == 1) {
                                        dates += "<strong>Self Appraisal End Date</strong> <span class='text-color'>" + b[1] + "</span><br/>";
                                    }
                                    if (b[0] == 2) {
                                        dates += "<strong>Appraiser Review End Date</strong> <span class='text-color'>" + b[1] + "</span><br/>";
                                    }
                                    if (b[0] == 3) {
                                        dates += "<strong>Approval End Date</strong> <span class='text-color'>" + b[1] + "</span><br/>";
                                    }
                                    if (b[0] == 4) {
                                        dates += "<strong>Accept/Closure End Date</strong> <span class='text-color'>" + b[1] + "</span><br/>";
                                    }
                                });
                            }
                            dates += "<strong>Appraisal Ends By</strong> <span class='text-color'>" + data.EndDate + "</span><br/>";
                            dates += "</td>";
                            return dates;
                        }
                    }
                ],
            });
        });
}

function showStatusHistory(empAppraisalSettingId) {
    BindStatusHistory(empAppraisalSettingId);
    $('#popupAppraisalHirtory').modal('show');
}

function BindStatusHistory(empAppraisalSettingId) {
    var JsonObject = {
        empAppraisalSettingId: empAppraisalSettingId,
        userAbrhs: misSession.userabrhs
    };
    calltoAjax(misApiUrl.getStatusHistory, "POST", JsonObject,
        function (result) {
            var resultdata = $.parseJSON(JSON.stringify(result));
            $('#grdappraisalHirtory').DataTable({
                "bDestroy": true,
                "bPaginate": false,
                "bFilter": false,
                "info": false,
                "aaData": resultdata,
                "aoColumns": [
                    { "sTitle": "#", "mData": "RowNo" },
                    { "sTitle": "Date", "mData": "Date", "sWidth": "125px" },
                    { "sTitle": "Appraisal Status", "mData": "FeedbackStatusName" },
                    { "sTitle": "Description", "mData": "Description" },
                    { "sTitle": "Comment", "mData": "Comment" },
                ],
            });
        });
}

$("#btnClose").click(function () {
    $('#popupAppraisalHirtory').modal('hide');
});

function ViewHistory() {
    window.open('/ViewHistory/History?userId=' + $('#hdnLoginUserId').val());
}

function openCompetencyForm(empAbrhs) {
    var JsonObject = {
        empAbrhs: empAbrhs,
        userAbrhs: misSession.userabrhs
    };
    calltoAjax(misApiUrl.empHistory, "POST", JsonObject,
        function (result) {
            $('#empHirtoryTA').modal('show');
            $('#grdempHirtoryTAGrid').html(result);
        });
}

function openForm(empAppraisalSettingId) {
    $("#hdnEmpAppraisalSettingId").val(empAppraisalSettingId);
    loadModal("teamAppraisalFormPopup", "modalBodyAppraisalForm", misAppUrl.appraisalFormForManagement, true);
}

