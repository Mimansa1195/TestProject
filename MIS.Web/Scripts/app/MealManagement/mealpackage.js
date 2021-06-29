$(document).ready(function () {
    getMealPackages();
});

function getMealPackages() {
    calltoAjax(misApiUrl.getMealPackagesList, "POST", '',
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#tblMealPackage").dataTable({
                "responsive": true,
                "autoWidth": false,
                "paging": true,
                "bDestroy": true,
                "searching": true,
                "ordering": false,
                "info": false,
                "deferRender": true,
                "aaData": resultData,
                "aoColumns": [
                    {
                        "mData": "MealPackage",
                        "sTitle": "Meal Package",
                    },
                     {
                         "mData": "MealPeriod",
                         "sTitle": "Period",
                     },
                    {
                        "mData": "MealType",
                        "sTitle": "Type",
                    },
                     {
                         "mData": "MealCategory",
                         "sTitle": "Category",
                     },
                     
                       {
                           "mData": "CreatedDate",
                           "sTitle": "Date",
                       },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        mRender: function (data, type, row) {
                            var html = '<div>';
                            html += '<button type="button" data-toggle="tooltip" class="btn btn-sm btn-success"' + 'onclick="editMealPackage(' + row.MealPackageId + ')" title="Edit"><i class="fa fa-pencil-square-o" aria-hidden="true"></i></button>';
                            if (row.IsActive == true)
                                html += '&nbsp;<button type="button" data-toggle="tooltip" class="btn btn-sm btn-danger"' + 'onclick="changePackageStatus(' + row.MealPackageId + ')" title="Deactive"><i class="fa fa-times" aria-hidden="true"></i></button>';
                            else
                                html += '&nbsp;<button type="button" data-toggle="tooltip" class="btn btn-sm btn-success"' + 'onclick="changePackageStatus(' + row.MealPackageId + ')" title="Active"><i class="fa fa-check" aria-hidden="true"></i></button>';
                            return html;
                        }
                    },
                ]
            });
        });
}

function bindMealCategoryDropDown(ControlId, SelectedId) {
    $(ControlId).empty();
    $(ControlId).append($("<option></option>").val(0).html("Select"));
    calltoAjax(misApiUrl.getMealCategory, "POST", '',
       function (result) {
           $.each(result, function (idx, item) {
               $(ControlId).append($("<option></option>").val(item.Value).html(item.Text));
           });
           if (SelectedId > 0) {
               $(ControlId).val(SelectedId)
           }
       });
}

function bindMealPeriodDropDown(ControlId, SelectedId) {
    $(ControlId).empty();
    $(ControlId).append($("<option></option>").val(0).html("Select"));
    calltoAjax(misApiUrl.getMealPeriod, "POST", '',
       function (result) {
           $.each(result, function (idx, item) {
               $(ControlId).append($("<option></option>").val(item.Value).html(item.Text));
           });
           if (SelectedId > 0) {
               $(ControlId).val(SelectedId)
           }
       });
}

function bindMealTypeDropDown(ControlId, SelectedId) {
    $(ControlId).empty();
    $(ControlId).append($("<option></option>").val(0).html("Select"));
    calltoAjax(misApiUrl.getMealType, "POST", '',
       function (result) {
           $.each(result, function (idx, item) {
               $(ControlId).append($("<option></option>").val(item.Value).html(item.Text));
           });
           if (SelectedId > 0) {
               $(ControlId).val(SelectedId)
           }
       });
}

function addPackage() {
    if (!validateControls('addMealModal')) {
        return false;
    }

    var jsonObject = {
        MealPeriodId: $("#ddlMealPeriod").val(),
        MealTypeId: $("#ddlMealType").val(),
        MealCategoryId: $("#ddlMealCategory").val() || 0,
        UserAbrhs: misSession.userabrhs,
    }
    calltoAjax(misApiUrl.addMealPackages, "POST", jsonObject,
        function (result) {
            if (result == 1) {
                misAlert("Meal package added successfully", "Success", "success");
                getMealPackages();
                $("#mypopupAddMealPackage").modal("hide");
            }
            if (result == 2) {
                misAlert("same package Already Exist !", "Success", "success");
            }
            if (result == 3) {
                misAlert("Error", "Error", "error");
            }
        });
}

function changePackageStatus(mealPackageId) {
    var jsonObject = {
        MealPackageId: mealPackageId,
        UserAbrhs: misSession.userabrhs,
    }
    calltoAjax(misApiUrl.deleteMealPackages, "POST", jsonObject,
        function (result) {
            if (result == 1) {
                misAlert("Meal package deleted successfully", "Success", "success");
                getMealPackages();
            }
        });
}

function editMealPackage(mealPackageId) {
    _mealPackageId = mealPackageId;
    var jsonObject = {
        MealPackageId: mealPackageId,
    }
    calltoAjax(misApiUrl.getMealPackagesEdit, "POST", jsonObject,
        function (result) {
            if (result != null) {
                bindMealCategoryDropDown("#ddlMealCategoryEdit", result.MealCategoryId);
                bindMealPeriodDropDown("#ddlMealPeriodEdit", result.MealPeriodId);
                bindMealTypeDropDown("#ddlMealTypeEdit", result.MealTypeId);
                $("#mypopupEditMealPackage").modal("show");
            }
        });
}

function updatePackage() {
    if (!validateControls('editMealModal')) {
        return false;
    }

    var jsonObject = {
        MealPackageId: _mealPackageId,
        MealPeriodId: $("#ddlMealPeriodEdit").val(),
        MealTypeId: $("#ddlMealTypeEdit").val(),
        MealCategoryId: $("#ddlMealCategoryEdit").val(),
        UserAbrhs: misSession.userabrhs,
    }
    calltoAjax(misApiUrl.updateMealPackages, "POST", jsonObject,
        function (result) {
            if (result == 1) {
                misAlert("Meal package updated successfully", "Success", "success");
                getMealPackages();
                $("#mypopupEditMealPackage").modal("hide");
            }
            if (result == 2) {
                misAlert("Package not Available !", "Error", "error");
            }
            if (result == 3) {
                misAlert("Error", "Error", "error");
            }
        });
}


function addMealPackage() {
    bindMealCategoryDropDown("#ddlMealCategory", 0);
    bindMealPeriodDropDown("#ddlMealPeriod", 0);
    bindMealTypeDropDown("#ddlMealType", 0);
    $("#mypopupAddMealPackage").modal("show");
}

$("#btnCloseAddPackage").click(function () {
    $("#mypopupAddMealPackage").modal("hide");
});

$("#btnCloseEditPackage").click(function () {
    $("#mypopupEditMealPackage").modal("hide");
});