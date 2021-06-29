$(document).ready(function () {
    bindAllEmployeesToView();
    $('#txtValidFrom').datepicker({
        autoclose: true,
        todayHighlight: true
    }).on('changeDate', function (ev) {
        onValidFromDateChange();
    });

    $('#ddlEmployeeAbrhsNew').multiselect({
        includeSelectAllOption: true,
        enableFiltering: true,
        enableCaseInsensitiveFiltering: true,
        buttonWidth: false,
        onDropdownHidden: function (event) {
        }
    });

    $('#notifyMgr').prop('checked', true);
    $(".select2").select2();

    $("#mapNewManager").click(function () {
        $("#txtHiddenMappingId").val("0");
        var userAbrhs = "0";
        var onshoreMgrAbrhs = "0";
        bindAllEmployees(userAbrhs);
        bindAllOnshoreManager(onshoreMgrAbrhs);
        $("#ddlUserAbrhs").attr("disabled", false);
        $('#notifyMgr').prop('checked', true);
        $(".toggle").removeClass("off");
        $("#txtClientSideCode").val(""),
            $('#txtValidFrom input').val("");
        $('#txtValidTill input').val("");
        $("#modalAddNewOnshoreManager").modal('show');
    });

    $("#ddlEmployeeAbrhsNew").change(function () {
        loadUsersMappedOnshoreManagerDetail();
    });

});

function bindAllEmployeesToView() {
    $("#ddlEmployeeAbrhsNew").multiselect('destroy');
    $("#ddlEmployeeAbrhsNew").empty();
    $('#ddlEmployeeAbrhsNew').multiselect();
    calltoAjax(misApiUrl.getAllEmployeesToMapOnshoreManager, "GET", '',
        function (result) {
            if (result != null && result.length > 0) {

                for (var x = 0; x < result.length; x++) {
                    $("#ddlEmployeeAbrhsNew").append("<option value = '" + result[x].UserAbrhs + "'>" + result[x].UserName + "</option>");
                }
                $('#ddlEmployeeAbrhsNew').multiselect("destroy");
                $('#ddlEmployeeAbrhsNew').multiselect({
                    includeSelectAllOption: true,
                    enableFiltering: true,
                    enableCaseInsensitiveFiltering: true,
                    buttonWidth: false,
                    onDropdownHidden: function (event) {
                    }
                });
                $("#ddlEmployeeAbrhsNew").multiselect('selectAll', false);
                $("#ddlEmployeeAbrhsNew").multiselect('updateButtonText');
            }
            loadUsersMappedOnshoreManagerDetail();
        });
}

function onValidFromDateChange() {
    var fromDate = $("#txtValidFrom input").val();
    $('#txtValidTill input').val("");
    $('#txtValidTill').datepicker({
        autoclose: true,
        todayHighlight: true
    }).datepicker('setStartDate', fromDate);
}

function loadUsersMappedOnshoreManagerDetail() {
    var userAbrhsList = "";
    if ($('#ddlEmployeeAbrhsNew').val() !== null) {
        userAbrhsList = $('#ddlEmployeeAbrhsNew').val().join(",");
    }
    var jsonObject = {
        userAbrhsList: userAbrhsList
    }
    calltoAjax(misApiUrl.fetchUsersOnshoreManagerData, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblMappedOnshoreMgr").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'All Pimco User Data',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'All Pimco User Data' },
                        { extend: 'pdf', filename: 'All Pimco User Data' },
                        { extend: 'print', filename: 'All Pimco User Data' },
                        ]
                    }
                ],
                "responsive": true,
                "autoWidth": false,
                "paging": true,
                "bDestroy": true,
                "ordering": true,
                "order": [], // disable default sorting
                "info": true,
                "deferRender": true,
                "aaData": data,
                "aoColumns": [
                    {
                        "mData": "UserName",
                        "sTitle": "Employee Name",
                    },
                    {
                        "mData": "ClntSideEmpId",
                        "sTitle": "Client Side Id",
                    },
                    {
                        "mData": "OnshoreMgrName",
                        "sTitle": "Onshore Manager"
                    },
                    {
                        "mData": "ValidFrom",
                        "sTitle": "Valid From",
                    },
                    {
                        "mData": "ValidTill",
                        "sTitle": "Valid Till"
                    },
                    {
                        "mData": "EnableNotification",
                        "sTitle": "Notify Manager"
                    },
                    {
                        "mData": "CreatedDate",
                        "sTitle": "Created On"
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        "sClass": "text-center",
                        "sWidth": "80px",
                        mRender: function (data, type, row) {
                            var html = '<div>';
                            html += '<button type="button" class="btn btn-sm btn-success" onclick="editUsersOnshoreMapping(' + data.MappingId + ',\'' + data.ClntSideEmpId + '\',' + data.NotifyManager + ',\'' + data.UserAbrhs + '\',\'' + data.OnshoreMgrAbrhs + '\',\'' + data.ValidFromDate + '\',\'' + data.ValidTillDate + '\')" data-toggle="tooltip" title="Edit"><i  class="fa fa-edit"></i></button>';
                            html += '&nbsp;<button type="button" class="btn btn-sm btn-danger" onclick="cancelOnshorManagerMapping(' + data.MappingId + ')" data-toggle="tooltip" title="Cancel"><i  class="fa fa-times"></i></button>';
                            return html;
                        }
                    },
                ],
            });
        });
}

function bindAllEmployees(userAbrhs) {
    calltoAjax(misApiUrl.getAllEmployeesToMapOnshoreManager, "GET", '',
        function (result) {
            $("#ddlUserAbrhs").empty();
            $("#ddlUserAbrhs").append("<option value = '0'>Select</option>");
            if (result != null) {
                $.each(result, function (index, val) {
                    $("#ddlUserAbrhs").append("<option value=" + val.UserAbrhs + ">" + val.UserName + "</option>");
                });
            }
            if (userAbrhs !== null && userAbrhs !== "") {
                $("#ddlUserAbrhs").val(userAbrhs);
            }
            else {
                $("#ddlUserAbrhs").val(0);
            }
        });
}

function bindAllOnshoreManager(onshoreMgrAbrhs) {
    calltoAjax(misApiUrl.getAllOnshoreManager, "GET", '',
        function (result) {
            $("#ddlOnshoreMgrAbrhs").empty();
            $("#ddlOnshoreMgrAbrhs").append("<option value = '0'>Select</option>");
            if (result != null) {
                $.each(result, function (index, val) {
                    $("#ddlOnshoreMgrAbrhs").append("<option value=" + val.OnshoreMgrAbrhs + ">" + val.OnshoreMgrName + "</option>");
                });
            }
            if (onshoreMgrAbrhs !== null && onshoreMgrAbrhs !== "") {
                $("#ddlOnshoreMgrAbrhs").val(onshoreMgrAbrhs);
            }
            else {
                $("#ddlOnshoreMgrAbrhs").val(0);
            }
        });
}

$("#btnSave").on("click", function () {
    var notifyMgr = false;
    if ($("#notifyMgr").is(":checked") == true) {
        notifyMgr = true;
    }
    if (!validateControls('modalAddNewOnshoreManager')) {
        return false;
    }
    var mappingData = {
        MappingId: $("#txtHiddenMappingId").val(),
        UserAbrhs: $("#ddlUserAbrhs").val(),
        ClntSideEmpId: $("#txtClientSideCode").val(),
        OnshoreMgrAbrhs: $("#ddlOnshoreMgrAbrhs").val(),
        ValidFrom: $("#txtValidFrom input").val(),
        ValidTill: $("#txtValidTill input").val(),
        NotifyManager: notifyMgr
    }
    calltoAjax(misApiUrl.addOrUpdateUsersOnshoreMgr, "POST", mappingData,
        function (result) {
            if (result.Status == 1) {
                misAlert("Request processed successfully.", "Success", "success");
                $("#modalAddNewOnshoreManager").modal('hide');
                loadUsersMappedOnshoreManagerDetail();
            }
            else if (result.Status == 2) {
                misAlert("Requested mapping exists.", "Duplicate", "warning");
            }
            else {
                misAlert("Request can not be processed.", "Error", "error");
            }
        });
});

function editUsersOnshoreMapping(mappingId, clntSideEmpId, notifyMgr, userAbrhs, onshoreMgrAbrhs, validFrom, validTill) {
    $("#txtHiddenMappingId").val(mappingId);
    bindAllEmployees(userAbrhs);
    bindAllOnshoreManager(onshoreMgrAbrhs);
    if (notifyMgr) {
        $('#notifyMgr').prop('checked', true);
        $(".toggle").removeClass("off");
    }
    else if (!notifyMgr) {
        $('#notifyMgr').prop('checked', false);
        $(".toggle").addClass("off");
    }
    $("#txtClientSideCode").val(clntSideEmpId),
        $('#txtValidFrom input').val(validFrom);
    $('#txtValidTill input').val(validTill);
    $("#ddlUserAbrhs").attr("disabled", true);
    $("#modalAddNewOnshoreManager").modal('show');
}

function cancelOnshorManagerMapping(mappingId) {
    reply = misConfirm("Are you sure you want to cancel this this mapping?", "Confirm",
        function (reply) {
            if (reply) {
                var jsonObject = {
                    mappingId: mappingId
                };
                calltoAjax(misApiUrl.cancelOnshorManagerMapping, "POST", jsonObject,
                    function (result) {
                        if (result == 1) {
                            misAlert("Request processed successfully.", "Success", "success");
                            loadUsersMappedOnshoreManagerDetail();
                        }
                        else {
                            misAlert("Request can not be processed.", "Error", "error");
                        }
                    });
            }
        });
}