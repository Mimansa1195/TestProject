function promoteEmployee(employeeAbrhs, desigGroupAbrhs, name, empDesignation, empId, isIntern) {
    $("#PromoteEmployeeModal").modal('show');
    $("#hdnEmployeeId").val(employeeAbrhs);
    $("#txtName").val(name);
    $("#txtEmpDesignation").val(empDesignation);
    $("#txtEmpNewDesignation").html("");

    if (isIntern == "false") {
        $("#txtEmpCode").val(empId);
        $("#txtNewEmpCode").val(empId);
    }
    else
        $("#txtEmpCode").val(empId);
        $('#dtpPromotionDate').datepicker({
        format: "mm/dd/yyyy",
        autoclose: true,
        todayHighlight: true,
       // startDate: toddmmyyyDatePicker(misSession.fystartdate),
        endDate: toddmmyyyDatePicker(new Date()),
    }).on('changeDate', function (ev) {
        if ($("#txtEmpNewDesignation").val() > 0)
            bindDataToBeUpdated();
    });
    $("#dtpPromotionDate").datepicker("setDate",toddmmyyyDatePicker(new Date()));

    bindDesignationGrp(desigGroupAbrhs);
    bindDesignation(desigGroupAbrhs);
}
function bindDesignationGrp(DesigGrpAbrhs) {
    $("#txtEmpNewDesignationGroup").html(""); //to clear the previously selected value
    $("#txtEmpNewDesignationGroup").select2();
    $("#txtEmpNewDesignationGroup").append("<option value=''>Select All</option>");

    var jsonObject = {
        //userAbrhs: misSession.userabrhs
        isOnlyActive: true
    };
    calltoAjax(misApiUrl.getDesignationGroups, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $.each(resultData, function (idx, item) {
                $("#txtEmpNewDesignationGroup").append($("<option></option>").val(item.EntityAbrhs).html(item.EntityName));
            });

            $('#txtEmpNewDesignationGroup').val(DesigGrpAbrhs);
        });
}
function OnChangeDesigGroup() {
    var desigGroupAbrhs = $('#txtEmpNewDesignationGroup').val()
    bindDesignation(desigGroupAbrhs);
}
function bindDesignation(desigGroupAbrhs) {
    $("#txtEmpNewDesignation").html(""); //to clear the previously selected value
    $("#txtEmpNewDesignation").select2();
    $("#txtEmpNewDesignation").append("<option value='0'>Select</option>");

    var jsonObject = {
        desigGrpAbrhs: desigGroupAbrhs,
    };
    calltoAjax(misApiUrl.getDesignationsByDesigGrpId, "POST", jsonObject,
        function (result) {
            $.each(result, function (idx, item) {
                $("#txtEmpNewDesignation").append($("<option></option>").val(item.Value).html(item.Text));
            });
        });
}
function promoteUser() {
    if (!validateControls('PromoteEmployeeModal')) {
        return false;
    }
    var jsonObject = {
        employeeAbrhs: $("#hdnEmployeeId").val(),
        //empName: $("#txtName").val(),
        //oldDesignation: $("#txtEmpDesignation").val(),
        designationGrp: $("#txtEmpNewDesignationGroup").val(),
        newDesignationId: $("#txtEmpNewDesignation").val(),
        promotionDate: $("#txtPromotionDate").val(),
        //oldEmpCode: $("#txtEmpCode").val(),
        newEmpCode: $("#txtNewEmpCode").val(),
        userAbrhs: misSession.userabrhs,
        //isIntern: _isIntern
    };
    calltoAjax(misApiUrl.promoteUsers, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            if (resultData) {
                if (result == 4) {
                    swal("Warning!", "This employee code already exists.!", "warning")
                    //$("#PromoteEmployeeModal").modal('hide');
                    //$("#txtPromotionDate").val("");
                    //$("#txtNewEmpCode").val("");
                    //$("#txtEmpNewDesignation").html("");
                    //$("#tblDataUpdated").html("");
                    //getAllActiveEmployees();
                }
                else if (result == 3) {
                    swal("Warning!", "Old and new designations cannot be same.!", "warning")
                    $("#PromoteEmployeeModal").modal('hide');
                    $("#txtPromotionDate").val("");
                    $("#txtNewEmpCode").val("");
                    $("#txtEmpNewDesignation").html("");
                    $("#tblDataUpdated").html("");
                    getAllActiveEmployees();
                }
                else if (result == 2) {
                    swal("Success!", "Intern has been promoted successfully!", "success")
                    $("#PromoteEmployeeModal").modal('hide');
                    $("#txtPromotionDate").val("");
                    $("#txtNewEmpCode").val("");
                    $("#txtEmpNewDesignation").html("");
                    $("#tblDataUpdated").html("");
                    getAllActiveEmployees();
                }
                else if (result == 1) {
                    swal("Success!", "Employee has been promoted successfully!", "success")
                    $("#PromoteEmployeeModal").modal('hide');
                    $("#txtPromotionDate").val("");
                    $("#txtNewEmpCode").val("");
                    $("#txtEmpNewDesignation").html("");
                    $("#tblDataUpdated").html("");
                    getAllActiveEmployees();
                }
            }
                else
                    swal("Warning", "Error occured", "warning")
            
        }
    );
}
function bindDataToBeUpdated() {
    var empId = $("#hdnEmployeeId").val();
    var empDesigId = $("#txtEmpNewDesignation").val();
    var promotionDt = $("#txtPromotionDate").val();

    if (!empId || !empDesigId || !promotionDt)
        return false;

    var jsonObject = {
        userAbrhs: empId,
        empDesignationId: empDesigId,
        promotionDate: promotionDt
    }
    calltoAjax(misApiUrl.listOldAndNewLeaveBalanceByUserId, "POST", jsonObject, function (result) {

        var resultdata = $.parseJSON(JSON.stringify(result));
        var html = '<label class="control-label">Note:Old data to be replaced by new data</label>';
        html = '<table class="tbl-typical text-left">';
        if (resultdata) {
            if (resultdata.OldRole != null) {
                html += '<tr class="bg-primary"><td>Old Data</td><td>New Data</td></tr>' +
                    '<tr><td>CL: ' + (resultdata.OldClCount === null ? "NA" : resultdata.OldClCount) + '</td><td>CL: ' + (resultdata.NewClCount === null ? "NA" : resultdata.NewClCount) + '</td> </tr>' +

                    '<tr><td>PL: ' + (resultdata.OldPlCount === null ? "NA" : resultdata.OldPlCount) + '</td><td>PL: ' + (resultdata.NewPlCount === null ? "NA" : resultdata.NewPlCount) + '</td> </tr>' +

                    '<tr><td>5 CLOY: ' + (resultdata.OldCloyAvailable === null ? "NA" : resultdata.OldCloyAvailable) + '</td><td>5 CLOY: ' + (resultdata.NewCloyAvailable === null ? "NA" : resultdata.NewCloyAvailable) + '</td></tr>' +

                    '<tr><td>Role: ' + (resultdata.OldRole === null ? "NA" : resultdata.OldRole) + '</td><td>Role: ' + (resultdata.NewRole === null ? "NA" : resultdata.NewRole) + '</td> </tr>';

            }
            else {
                html += '<tr class="bg-primary"><td>Old Data</td><td>New Data</td></tr>' +
                    '<tr><td>CL: ' + (resultdata.OldClCount === null ? "NA" : resultdata.OldClCount) + '</td><td>CL: ' + (resultdata.NewClCount === null ? "NA" : resultdata.NewClCount) + '</td> </tr>' +

                    '<tr><td>PL: ' + (resultdata.OldPlCount === null ? "NA" : resultdata.OldPlCount) + '</td><td>PL: ' + (resultdata.NewPlCount === null ? "NA" : resultdata.NewPlCount) + '</td> </tr>' +

                    '<tr><td>5 CLOY: ' + (resultdata.OldCloyAvailable === null ? "NA" : resultdata.OldCloyAvailable) + '</td><td>5 CLOY: ' + (resultdata.NewCloyAvailable === null ? "NA" : resultdata.NewCloyAvailable) + '</td></tr>';

            }
        }
        html += '</table>';
        $("#tblDataUpdated").html(html);
    });
}
$("#btnClose").click(function () {
    $("#txtPromotionDate").val("");
    $("#txtNewEmpCode").val("");
    $("#txtEmpNewDesignation").html("");
    $("#tblDataUpdated").html("");
    $("#txtPromotionDate").removeClass("error-validation");
    $("#txtNewEmpCode").removeClass("error-validation");
});
$("#btnClose1").click(function () {
    $("#txtPromotionDate").val("");
    $("#txtNewEmpCode").val("");
    $("#txtEmpNewDesignation").html("");
    $("#tblDataUpdated").html("");
    $("#txtPromotionDate").removeClass("error-validation");
    $("#txtNewEmpCode").removeClass("error-validation");
});