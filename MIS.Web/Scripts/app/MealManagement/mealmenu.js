$(document).ready(function () {
    bindMealDishesDropDown();
    getAllMeals();

    $('#forDate').datepicker({ autoclose: true, todayHighlight: true });
    myDate = new Date();
    todatDate = ('0' + (myDate.getMonth() + 1)).slice(-2) + '/' + ('0' + myDate.getDate()).slice(-2) + '/' + myDate.getFullYear();
    $("#forDate").val(todatDate);

    //$("#forDate").datepicker({
    //    autoclose: true,
    //    todayHighlight: false,
    //    minDate: new Date(2016, 3, 1)
    //}).datepicker("setDate", new Date());

});


function bindMealPackagesDropDown(ControlId, SelectedId) {
    $(ControlId).empty();
    $(ControlId).append($("<option></option>").val(0).html("Select"));
    calltoAjax(misApiUrl.getMealPackages, "POST", '',
       function (result) {
           $.each(result, function (idx, item) {
               $(ControlId).append($("<option></option>").val(item.Value).html(item.Text));
           });
           if (SelectedId > 0) {
               $(ControlId).val(SelectedId)
           }
       });
}

function bindMealDishesDropDown() {
    calltoAjax(misApiUrl.getMealDishes, "POST", '',
       function (result) {
           _result = result;
       });
}

function bindDatawithJason(ControlId, SelectedId) {
    result=_result;
    $.each(result, function (idx, item) {
        $(ControlId).append($("<option></option>").val(item.Value).html(item.Text));
    });
    if (SelectedId > 0) {
        $(ControlId).val(SelectedId)
    }
}

function addMealMenu() {
    $("#divAddMenu .validation-required").removeClass("error-validation");
    $("#divAddMenu .select2-selection").removeClass("error-validation");
    bindMealPackagesDropDown("#ddlMealPackages", 0);
    bindDatawithJason("#ddlMealDishes", 0);
    $("#mypopupAddMealMenu").modal("show");
    $("#btnAddControlsContainer").html('');
    $("#forDate").val("");
}

$("#btnCloseAddMenu").click(function () {
    $("#mypopupAddMealMenu").modal("hide");
});

function getAllMeals() {
    calltoAjax(misApiUrl.getAllMeals, "POST", '',
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#tblMenuList").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                 {
                     filename: 'All Meal List',
                     extend: 'collection',
                     text: 'Export',
                     buttons: [{ extend: 'copy' },
                                { extend: 'excel', filename: 'All Meal List' },
                                { extend: 'pdf', filename: 'All Meal List' },
                                { extend: 'print', filename: 'All Meal List' },
                     ]
                 }
                ],
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
                        "mData": "MealDate",
                        "sTitle": "Meal Date",
                        "sWidth": "90px"
                    },
                     {
                         "mData": "MealPackage",
                         "sTitle": "Meal Package",
                     },
                    {
                        "mData": "Meal",
                        "sTitle": "Meal Of The Day"
                    },
                    {
                        "mData": null,                        
                        "sTitle": "Action",
                        'bSortable': false,
                        "sWidth": "110px",
                        mRender: function (data, type, row) {
                            var html = '<div>';
                            html += '<button type="button" data-toggle="tooltip" class="btn btn-sm btn-warning"' + 'onclick="EditMeal(' + row.MealPackagesId + ',\'' + row.Date + '\',true)" title="Clone"><i class="fa fa-clone"></i></button>';
                            html += '&nbsp;<button type="button" data-toggle="tooltip" class="btn btn-sm btn-success"' + 'onclick="EditMeal(' + row.MealPackagesId + ',\'' + row.Date + '\',false)" title="Edit"><i class="fa fa-edit"></i></button>';
                            html += '&nbsp;<button type="button" data-toggle="tooltip" class="btn btn-sm btn-danger"' + 'onclick="DeleteMeal(' + row.MealPackagesId + ',\'' + row.Date + '\')" title="Delete"><i class="fa fa-trash"></i></button>';
                            return html;
                        }
                    },
                ]
            });
        });
}

$("#btnAddControls").click(function () {
    generateControls('btnAddControlsContainer');
});

function generateControls(containerId, maxNoOfTextBoxes, minNoOfMandatoryTxtBoxes) {
    maxNoOfTextBoxes = maxNoOfTextBoxes || 20;
    if (containerId) {
        var txtCount = $("#" + containerId).find('.itemRow').length;
        if (txtCount < maxNoOfTextBoxes) {
            $("#" + containerId).append(getDynamicControls(txtCount, minNoOfMandatoryTxtBoxes || 1, ''));
        }
        else {
            misAlert("You can't add more than " + maxNoOfTextBoxes + " options!", 'Sorry', 'warning');
        }
        bindDatawithJason('#ddlMealDishes' + txtCount + '', 0);
    }
}

function getDynamicControls(idx, minNoOfMandatoryTxtBoxes, value) {
        return '<div class="col-md-12 itemRow">' +
               '<div class="row">' +
               '<div class="col-md-4"><div class="form-group"><label class="control-label">Meal Dish</label><div class="inputGroupContainer"><div class="input-group"><select class="form-control select2" id="ddlMealDishes' + idx + '"></select></div></div></div></div>' +
               '<div class="col-md-6"><div class="form-group"><label class="control-label">Menu Name</label><div class="inputGroupContainer"><div class="input-group"><input type="text" class="form-control validation-required" id="menuName' + idx + '"></div></div></div></div>' +
               '<div class="col-md-2" style="padding-top: 22px;"><span class="input-group-btn"><button class="btn btn-danger" style="background-color: #d2322d;" value="X" onclick="removeControls(this)">X</button></span></div>' +
               '</div></div>';
}

function removeControls(item) {
    $(item).closest('.itemRow').remove()
}

function saveMenus() {
    if (!validateControls('divAddMenu')) {
        return false;
    }

    var items = $("#btnAddControlsContainer .itemRow");
    if (items.length <= 0) {
        misAlert ("Please fill atleast one menu Item to create Menu.", 'Sorry', 'warning');
        return false;
    }

    // check for duplicate combination.
    var items = $("#btnAddControlsContainer .itemRow");
    var dishCombination = [];
    var duplicatecount = 0;
    $.each(items, function (idx, item) {
        var dishId = $(item).find('#ddlMealDishes' + idx).val();
        var dishName = $(item).find('#menuName' + idx).val() || 0;
        if (dishId > 0 && dishName > 0) {
            var combination = dishId + dishName;
            if ($.inArray(combination, dishCombination) == -1) {
                dishCombination.push(combination);
            }
            else {
                duplicatecount = duplicatecount + 1;
            }
        }

    });
    if (duplicatecount > 0) {
        misAlert ("Please add unique combination of Dish and Dish Name.", 'Sorry', 'warning');
        return false;
    }

    var mealCombination = [];
    $.each(items, function (idx, item) {
        var dishId = $(item).find('#ddlMealDishes' + idx).val();
        var menuName = $(item).find('#menuName' + idx).val();
        var mealCombinationDetail = {
            DishId: dishId,
            MenuName: menuName
        }
        mealCombination.push(mealCombinationDetail);
    });

    var jsonObject = {
        MealPackagesId: $('#ddlMealPackages').val(),
        MealDate: $("#forDate").val(),
        DishMenuList: mealCombination,
        UserAbrhs: misSession.userabrhs,
    }
    calltoAjax(misApiUrl.addMealoftheDay, "POST", jsonObject,
     function (result) {
         if (result == 1) {
             misAlert("Meal Of the Day Added Successfully", "Success", "success");
             getAllMeals();
             $("#mypopupAddMealMenu").modal("hide");
         }
     });
}

function DeleteMeal(mealPackagesId, date) {
    var reply = misConfirm("Are you sure you want to delete meal menu ", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                MealPackagesId: mealPackagesId,
                Date: new Date(date),
                UserAbrhs: misSession.userabrhs,
            }
            calltoAjax(misApiUrl.deleteMeal, "POST", jsonObject,
                function (result) {
                    if (result == 1) {
                        misAlert("Successfull", "Success", "success");
                        getAllMeals();
                    }
                });
        }
    });
}

function EditMeal(mealPackagesId, date, isClone) {
    $("#divUpdateMenu .select2-selection").removeClass("error-validation");
    $("#divUpdateMenu .validation-required").removeClass("error-validation");
    _isClone = isClone;
    var jsonObject = {
        MealPackagesId: mealPackagesId,
        Date: new Date(date),
        UserAbrhs: misSession.userabrhs,
    }
    calltoAjax(misApiUrl.getMealEdit, "POST", jsonObject,
        function (result) {
            bindMealPackagesDropDown("#ddlMealPackagesEdit", result.MealPackagesId);
            if (!isClone) {
                $("#forDateEdit").val(toddmmyyyDatePicker(result.MealDate));
            } else {
                $("#forDateEdit").val("");
            }
            $("#mypopupUpdateMealMenu").modal("show");
            //bindDatawithJason("#ddlMealDishesEdit", 0);
            $("#UpdateControlsContainer").html(" ");
            $.each(result.DishMenuList, function (key, item) {
                generateControlsWithValue('UpdateControlsContainer', 20, item.DishId, item.MenuName);
            });
        });
}

// for Edit Call

function generateControlsWithValue(containerId, maxNoOfTextBoxes, dishId, menuName) {
    var minNoOfMandatoryTxtBoxes;
    maxNoOfTextBoxes = maxNoOfTextBoxes || 20;
    if (containerId) {
        var txtCount = $("#" + containerId).find('.itemRow').length;
        if (txtCount < maxNoOfTextBoxes) {
            $("#" + containerId).append(getDynamicControlsWithValue(txtCount, minNoOfMandatoryTxtBoxes || 1, ''));
        }
        else {
            misAlert("You can't add more than " + maxNoOfTextBoxes + " Dishes!", 'Sorry', 'warning');
        }
        bindDatawithJason('#ddlMealDishesEdit' + txtCount + '', dishId);
        $('#menuNameEdit' + txtCount + '').val(menuName);
    }
}

function generateControlsWithoutValue(containerId, maxNoOfTextBoxes) {
    var minNoOfMandatoryTxtBoxes;
    maxNoOfTextBoxes = maxNoOfTextBoxes || 20;
    if (containerId) {
        var txtCount = $("#" + containerId).find('.itemRow').length;
        if (txtCount < maxNoOfTextBoxes) {
            $("#" + containerId).append(getDynamicControlsWithValue(txtCount, minNoOfMandatoryTxtBoxes || 1, ''));
        }
        else {
            misAlert("You can't add more than " + maxNoOfTextBoxes + " Dishes!", 'Sorry', 'warning');
        }
        bindDatawithJason('#ddlMealDishesEdit' + txtCount + '', 0);
        //$('#menuNameEdit' + txtCount + '').val(menuName);
    }
}

function getDynamicControlsWithValue(idx, minNoOfMandatoryTxtBoxes, value) {
    return '<div class="col-md-12 itemRow">' +
           '<div class="row">' +
           '<div class="col-md-4"><div class="form-group"><label class="control-label">Meal Dish</label><div class="inputGroupContainer"><div class="input-group"><select class="form-control select2" id="ddlMealDishesEdit' + idx + '"></select></div></div></div></div>' +
           '<div class="col-md-6"><div class="form-group"><label class="control-label">Menu Name</label><div class="inputGroupContainer"><div class="input-group"><input type="text" class="form-control validation-required" id="menuNameEdit' + idx + '"></div></div></div></div>' +
           '<div class="col-md-2" style="padding-top: 22px;"><span class="input-group-btn"><button class="btn btn-danger" style="background-color: #d2322d;" value="X" onclick="removeControls(this)">X</button></span></div>' +
           '</div></div>';
}

$("#btnUpdateControlsEdit").click(function () {
    generateControlsWithoutValue('UpdateControlsContainer', 20);
});

$("#btnCloseUpdateMenu").click(function () {
    $("#mypopupUpdateMealMenu").modal("hide");
});

function UpdateMenus() {
    if (!validateControls('divUpdateMenu')) {
        return false;
    }

    var items = $("#UpdateControlsContainer .itemRow");
    if (items.length <= 0) {
        misAlert("Please fill atleast one menu Item to create Menu.", 'Sorry', 'warning');
        return false;
    }

    // check for duplicate combination.
    var items = $("#UpdateControlsContainer .itemRow");
    var dishCombination = [];
    var duplicatecount = 0;
    $.each(items, function (idx, item) {
        var dishId = $(item).find('#ddlMealDishes' + idx).val();
        var dishName = $(item).find('#menuName' + idx).val() || 0;
        if (dishId > 0 && dishName > 0) {
            var combination = dishId + dishName;
            if ($.inArray(combination, dishCombination) == -1) {
                dishCombination.push(combination);
            }
            else {
                duplicatecount = duplicatecount + 1;
            }
        }

    });
    if (duplicatecount > 0) {
        misAlert("Please add unique combination of Dish and Dish Name.", 'Sorry', 'warning');
        return false;
    }

    var mealCombination = [];
    $.each(items, function (idx, item) {
        var dishId = $(item).find('#ddlMealDishesEdit' + idx).val();
        var menuName = $(item).find('#menuNameEdit' + idx).val();
        var mealCombinationDetail = {
            DishId: dishId,
            MenuName: menuName
        }
        mealCombination.push(mealCombinationDetail);
    });

    var jsonObject = {
        MealPackagesId: $('#ddlMealPackagesEdit').val(),
        MealDate: $("#forDateEdit").val(),
        DishMenuList: mealCombination,
        UserAbrhs: misSession.userabrhs,
    }
    calltoAjax(misApiUrl.updateMealoftheDay, "POST", jsonObject,
     function (result) {
         if (result == 1) {
             if (_isClone) {
                 misAlert("Meal Of the Day Clone Successfully", "Success", "success");
             }
             else {
                 misAlert("Meal Of the Day Updated Successfully", "Success", "success");
             }
             getAllMeals();
             $("#mypopupUpdateMealMenu").modal("hide");
         }
         if (result == 2) {
             if (_isClone) {
                 misAlert("Meal for this day allready exist", "Warning", "warning");
             }
             else {
                 misAlert("Meal for this day allready exist", "Warning", "warning");
             }
         }
         if (result == 3) {
             misAlert("Error", "Error", "error");
         }
     });
}
