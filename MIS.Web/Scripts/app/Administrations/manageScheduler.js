var _actionId;
var _ids;
$(document).ready(function () {
    loadSchedulerActions();
    var ToDate = new Date();
    var date = new Date();
    $("#runDate").datetimepicker({
        locale: 'en-gb',
        minDate: date,
        format: 'DD/MM/YYYY HH:mm',
    }).on('dp.change', function (e) {
        $(this).data('DateTimePicker').hide();
    });
    $("#nxtRunDateEdit").datetimepicker({
        locale: 'en-gb',
        minDate: date,
        format: 'DD/MM/YYYY HH:mm',
    }).on('dp.change', function (e) {
        $(this).data('DateTimePicker').hide();
    });
    $("#runDateEdit").datetimepicker({
        locale: 'en-gb',
        minDate: date,
        format: 'DD/MM/YYYY HH:mm',
    }).on('dp.change', function (e) {
        var fromStartDate = $('#runDateEdit input').val();
        $(this).data('DateTimePicker').hide();
        $('#nxtRunDateEdit input').val('');
        $('#nxtRunDateEdit').data("DateTimePicker").minDate(fromStartDate);
    });

    $("#btnClose").on('click', function () {
        $("#mypopupAddScheduler").modal('hide');
        $("#txtSchedulerName").removeClass('error-validation');
        $("#txtDescription").removeClass('error-validation');
        $("#txtFuncName").removeClass('error-validation');
        $("#repeatType").removeClass('error-validation');
        $("#runFor").removeClass('error-validation');
        $("#txtSchedulerName").val("");
        $("#txtDescription").val("");
        $("#txtFuncName").val("");
        $("#runFor").select2("val", "1");
        $("#IsCombinedEmail").attr('checked', false);
    });
    $("#saveScheduler").on('click', function () {
        saveNewScheduler();
    });
    $("#btnEditClose").on('click', function () {
        $("#mypopupEditScheduler").modal('hide');
    });
    $("#editScheduler").on('click', function () {
        updateSchedulerData();
    });
});

function loadSchedulerActions() {
    calltoAjax(misApiUrl.getSchedulerActions, "GET", '',
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            var table = $("#tblSchedulerActions").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'Scheduler List',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'Scheduler List' },
                        { extend: 'pdf', filename: 'Scheduler List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                        { extend: 'print', filename: 'Scheduler List' },
                        ]
                    }
                ],
                "responsive": true,
                "autoWidth": false,
                "scrollX": true,
                "scrollCollapse": true,
                "paging": false,
                "bDestroy": true,
                "searching": true,
                "ordering": true,
                "order": [],
                "info": true,
                "deferRender": true,
                "aaData": resultData,
                "aoColumns": [
                    { "mData": "ActionId", "sTitle": "ActionId", "bVisible": false, "orderable": false },
                    {
                        "mData": "SchedulerName", "sTitle": 'Scheduler Name',
                        mRender: function (data, type, row) {
                            var hidd = '';
                            hidd += '<input data-attr-ActionId="' + row.ActionId + '" id="hdnActionId' + row.ActionId + '" "hdnActionId' + row.ActionId + '" type="hidden" value="' + row.ActionId + '" />';
                            if (row.CssClass)
                                hidd += '<i class="' + row.CssClass + '"></i> ';
                            hidd += row.SchedulerName;
                            return hidd;
                        }
                    },
                    { "mData": "Description", "sTitle": "Description", "className": "none" },
                    { "mData": "FunctionName", "sTitle": "Function Name", "className": "none" },
                    {
                        "mData": "RepeatAfterPeriod", "sTitle": "Repeat After",
                        mRender: function (data, type, row) {
                            return row.RepeatAfterPeriod + " " + row.RepeatAfterType;
                        }
                    },
                    { "mData": "LastRunTime", "sTitle": "Last Run Time", "sWidth": "150px" },
                    { "mData": "NextRunTime", "sTitle": "Next Run Time", "sWidth": "150px" },
                    {
                        "mData": "LastRunResult", "sTitle": "Last Run Status",
                        mRender: function (data, type, row) {
                            if (row.LastRunResult && row.LastRunResult.toLowerCase() === "success")
                                return '<span class="label label-success">' + row.LastRunResult + '</span>';
                            else if (row.LastRunResult && row.LastRunResult.toLowerCase() === "failed")
                                return '<span class="label label-danger">' + row.LastRunResult + '</span>';
                            else
                                return '<span class="label label-default">' + (row.LastRunResult || "NA") + '</span>';
                        }
                    },
                    {
                        "mData": "RunFor", "sTitle": "Runs For",
                        mRender: function (data, type, row) {
                            return row.RunFor + (row.Ids ? (": " + row.Ids) : '');
                        }
                    },
                    {
                        "mData": "IsCombinedEmail", "sTitle": 'Combined Email', "className": "none",
                        mRender: function (data, type, row) {
                            if (row.IsCombinedEmail === true)
                                return '<span class="label label-success">Yes</span>';
                            else
                                return '<span class="label label-danger">No</span>';
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        "sWidth": "150px",
                        mRender: function (data, type, row) {
                            var html = '<div>';
                            html += '&nbsp;<button type="button" class="btn btn-sm teal"' + 'onclick="getDetailsOfScheduler(' + row.ActionId + ')" data-toggle="tooltip" title="Edit"><i class="fa fa-edit"></i></button>';
                            if (row.IsActive) {
                                html += '&nbsp;<button type="button" data-toggle="tooltip" class="btn btn-sm btn-danger"' + 'onclick="changeStatus(\'' + row.ActionId + '\' , 2)"  title="DeActivate"><i class="fa fa-ban"></i></button>';
                            }
                            else {
                                html += '&nbsp;<button type="button" data-toggle="tooltip" class="btn btn-sm btn-success"' + 'onclick="changeStatus(\'' + row.ActionId + '\' , 1)"  title="Activate"><i class="fa fa-check"></i></button>';
                            }

                            html += '</div>'
                            return html;
                        }
                    },
                ],
                "fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                    if (aData.IsActive === false && aData.IsDeleted === true) {
                        $('td', nRow).css('background-color', 'rgb(255, 216, 214)');
                    }
                }
            });
        });
}
function bindAllUsers() {
    calltoAjax(misApiUrl.listAllActiveUsers, "POST", '',
        function (result) {
            $('#employees').multiselect("destroy");
            $('#employees').empty();
            $.each(result, function (index, value) {
                $('<option>').val(value.EmployeeAbrhs).text(value.EmployeeName).appendTo('#employees');
            });
            $('#employees').multiselect({
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                buttonWidth: false,
                onDropdownHidden: function (event) {
                }
            });
        });

}
function bindUsersOnEdit() {
    var idArray = [];
    if (_ids != null) {
        var idArray = _ids.split(',');
        idArray = idArray.map(function (el) {
            return el.trim();
        });
    }
    calltoAjax(misApiUrl.listAllActiveUsers, "POST", '',
        function (result) {
            $('#employeesEdit').multiselect("destroy");
            $('#employeesEdit').empty();
            $.each(result, function (index, value) {
                if (idArray.includes(value.EmployeeAbrhs)) {
                    $("#employeesEdit").append("<option selected value = '" + value.EmployeeAbrhs + "'>" + value.EmployeeName + "</option>");
                }
                else {
                    $("#employeesEdit").append("<option value = '" + value.EmployeeAbrhs + "'>" + value.EmployeeName + "</option>");
                }
            });
            $('#employeesEdit').multiselect({
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                buttonWidth: false,
                onDropdownHidden: function (event) {
                }
            });
            _ids = null;
        });

    //calltoAjax(misApiUrl.listAllActiveUsers, "POST", '',
    //    function (result) {
    //        $('#employeesEdit').multiselect("destroy");
    //        $('#employeesEdit').empty();
    //        $.each(result, function (index, value) {
    //            $('<option>').val(value.EmployeeAbrhs).text(value.EmployeeName).appendTo('#employeesEdit');
    //        });
    //        $('#employeesEdit').multiselect({
    //            includeSelectAllOption: true,
    //            enableFiltering: true,
    //            enableCaseInsensitiveFiltering: true,
    //            buttonWidth: false,
    //            onDropdownHidden: function (event) {
    //            }
    //        });
    //    });

}
function bindAllUsersForEdit(ids) {
    var idArray = ids.split(',');
    idArray = idArray.map(function (el) {
        return el.trim();
    });
    calltoAjax(misApiUrl.listAllActiveUsers, "POST", '',
        function (result) {
            $('#employeesEdit').multiselect("destroy");
            $('#employeesEdit').empty();
            $.each(result, function (index, value) {
                if (idArray.includes(value.EmployeeAbrhs)) {
                    $("#employeesEdit").append("<option selected value = '" + value.EmployeeAbrhs + "'>" + value.EmployeeName + "</option>");
                }
                else {
                    $("#employeesEdit").append("<option value = '" + value.EmployeeAbrhs + "'>" + value.EmployeeName + "</option>");
                }
            });
            $('#employeesEdit').multiselect({
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                buttonWidth: false,
                onDropdownHidden: function (event) {
                }
            });
        });
}
function getEmployeeList() {
    var runFor = $("#runFor").val()
    if (runFor > 1) {
        $("#listEmp").show();
        bindAllUsers();
    }
    else {
        $("#listEmp").hide();
    }
}
function getEmployeeListOnEdit() {
    var runFor = $("#runForEdit").val()
    if (runFor > 1) {
        $("#listEmpEdit").show();
        bindUsersOnEdit();
    }
    else {
        $("#listEmpEdit").hide();
    }
}

function addScheduler() {
    $("#txtSchedulerName").removeClass('error-validation');
    $("#txtDescription").removeClass('error-validation');
    $("#txtFuncName").removeClass('error-validation');
    $("#repeatType").removeClass('error-validation');
    $("#runFor").removeClass('error-validation');
    $("#txtSchedulerName").val("");
    $("#txtDescription").val("");
    $("#txtFuncName").val("");
    $("#runFor").select2("val", "1");
    $("#IsCombinedEmail").attr('checked', false);
    $("#mypopupAddScheduler").modal('show');
}
function saveNewScheduler() {
    if (!validateControls('divAddScheduler')) {
        return false;
    }
    else if ($("#runFor").val() > 1) {
        if ($('#employees').val() == null)
            misAlert("Please select atleast one employee.", "Warning", "warning");
        else
            saveSchedulerAction();
    }
    else if ($("#runFor").val() == 1)
        saveSchedulerAction();
}
function saveSchedulerAction() {
    var userIds = 0;
    userIds = (($('#employees').val() !== null && typeof $('#employees').val() !== 'undefined' && $('#employees').val().length > 0) ? $('#employees').val().join(',') : '0');
    var jsonObject = {
        schedulerName: $("#txtSchedulerName").val(),
        description: $("#txtDescription").val(),
        functionName: $("#txtFuncName").val(),
        repeatAfterPeriod: $("#repeatPrd").val(),
        repeatAfterType: $("#repeatType").val(),
        runFor: $("#runFor").val(),
        ids: userIds,
        lastRunTime: $("#runDate input").val(),
        isCombinedEmail: $("#IsCombinedEmail").is(':checked') ? true : false
    }
    calltoAjax(misApiUrl.addNewScheduler, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            switch (resultData) {
                case 1:
                    misAlert("Scheduler added successfully.", "Success", "success");
                    $("#mypopupAddScheduler").modal('hide');
                    loadSchedulerActions();
                    break;
                case 2:
                    misAlert("Function with this name already exists. Please check.", "Warning", "warning");
                    $("#mypopupAddScheduler").modal('hide');
                    break;

                case 0:
                    misAlert("Unable to process request. Try again.", "Error", "error");
                    $("#mypopupAddScheduler").modal('toggle');
                    break;
            }
        });
}
function changeStatus(actionId, type) {
    misConfirm("Are you sure you want to " + (type === 2 ? "deactive" : "activate") + " this scheduler?", "Confirm", function (isConfirmed) {
        if (isConfirmed) {
            var JsonObject = {
                actionId: actionId,
                type: type
            };
            calltoAjax(misApiUrl.changeStatusOfScheduler, "POST", JsonObject,
                function (result) {
                    if (result === 2) {
                        misAlert("Scheduler has been deactivated successfully.", "Success", "success");
                        loadSchedulerActions();
                    }
                    else if (result === 1) {
                        misAlert("Scheduler has been activated successfully.", "Success", "success");
                        loadSchedulerActions();
                    }
                    else {
                        misAlert("Request failed to process.", "Danger", "danger");
                        loadSchedulerActions();

                    }
                });
        }
    });
}

function getDetailsOfScheduler(actionId) {
    _actionId = actionId;
    var jsonObject = {
        actionId: actionId,
    };
    calltoAjax(misApiUrl.getDetailsOfScheduler, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            if (resultData.RunFor !== "1") {
                $("#listEmpEdit").show();
                //bindAllUsersForEdit(resultData.Ids);
            }
            _ids = resultData.Ids;
            $("#runDateEdit").datetimepicker().on('dp.show', function (e) {
                $("#runDateEdit table tr td").removeClass("active");
                $("#runDateEdit table tr td[data-day='" + resultData.LastRunTime + "']").addClass("active");
                $("#runDateEdit input").val(resultData.LastRunTime)
            });
            $("#txtSchedulerNameEdit").val(resultData.SchedulerName);
            $("#txtDescriptionEdit").val(resultData.Description);
            $("#txtFuncNameEdit").val(resultData.FunctionName);
            $("#repeatPrdEdit").val(resultData.RepeatAfterPeriod);
            $("#repeatTypeEdit").val(resultData.RepeatAfterType);
            $("#runForEdit").select2("val", resultData.RunFor);
            $("#runDateEdit input").val(resultData.LastRunTime);
            $("#nxtRunDateEdit input").val(resultData.NextRunTime);
            $("#IsCombinedEmailEdit").prop('checked', resultData.IsCombinedEmail);
            $("#mypopupEditScheduler").modal('show');
        });
}

function updateSchedulerData() {
    var lastdate = $("#runDateEdit input").val() != "" && $("#runDateEdit input").val() != "NA" ? $("#runDateEdit input").val() : "";
    var nextDate = $("#nxtRunDateEdit input").val() != "" && $("#nxtRunDateEdit input").val() != "NA" ? $("#nxtRunDateEdit input").val() : "";
    var userIds = 0;
    userIds = (($('#employeesEdit').val() !== null && typeof $('#employeesEdit').val() !== 'undefined' && $('#employeesEdit').val().length > 0) ? $('#employeesEdit').val().join(',') : '0');
    var jsonObject = {
        actionId: _actionId,
        schedulerName: $("#txtSchedulerNameEdit").val(),
        description: $("#txtDescriptionEdit").val(),
        functionName: $("#txtFuncNameEdit").val(),
        repeatAfterPeriod: $("#repeatPrdEdit").val(),
        repeatAfterType: $("#repeatTypeEdit").val(),
        runFor: $("#runForEdit").val(),
        ids: userIds,
        lastRunTime: lastdate,
        nextRunTime: nextDate,
        isCombinedEmail: $("#IsCombinedEmailEdit").is(':checked') ? true : false
    }
    calltoAjax(misApiUrl.updateSchedulerData, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            switch (resultData) {
                case 1:
                    misAlert("Scheduler has been updated successfully", "Success", "success");
                    $("#mypopupEditScheduler").modal('hide');
                    loadSchedulerActions();
                    break;
                case 2:
                    misAlert("Scheduler does not Exist.", "Warning", "warning");
                    break;
            }
        });
}