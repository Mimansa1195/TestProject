function onMealDishTabClick() {
    getMealDishes();
}

function getMealDishes() {
    calltoAjax(misApiUrl.getMealDishes, "POST", '',
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#tblMealDish").dataTable({
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
                        "mData": "Text",
                        "sTitle": "Meal Dish Name",
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        mRender: function (data, type, row) {
                            var html = '<div>';
                            html += '<button type="button" data-toggle="tooltip" class="btn btn-sm btn-success"' + 'onclick="showPopupEditMealDish(' + row.Value + ',\'' + row.Text + '\')" title="Edit"><i class="fa fa-pencil-square-o" aria-hidden="true"></i></button>';
                            html += '&nbsp;<button type="button" data-toggle="tooltip" class="btn btn-sm btn-danger"' + 'onclick="deleteMealDish(' + row.Value + ')" title="Delete"><i class="fa fa-trash" aria-hidden="true"></i></button>';
                            return html;
                        }
                    },
                ]
            });
        });
}

function showPopupEditMealDish(mealDishId, mealDishName) {
    $("#popupMealDish").modal("show");
    $("#btnAddMealDish").hide();
    $("#btnUpdateMealDish").show();
    $("#popupMealDishTitle").text("Update meal dish");
    $("#hdnMealDishId").val(mealDishId);
    $("#mealDishName").val(mealDishName);
}

function showPopupAddMealDish() {
    $("#popupMealDish").modal("show");
    $("#btnAddMealDish").show();
    $("#btnUpdateMealDish").hide();
    $("#popupMealDishTitle").text("Add meal dish");
    $("#mealDishName").val("");
}

function deleteMealDish(mealDishId) {
    var reply = misConfirm("Are you sure you want to delete meal dish", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                mealDishId: mealDishId,
                userAbrhs: misSession.userabrhs
            };
            calltoAjax(misApiUrl.deleteMealDish, "POST", jsonObject,
                function (result) {
                    if (result) {
                        misAlert("Request processed successfully", "Success", "success");
                        getMealDishes();
                    }
                    else
                        misAlert("Unable to process request. Try again", "Error", "error");
                });
        }
    });
}

function addMealDish() {
    if (!validateControls('modalMealDish')) {
        return false;
    }
    var jsonObject = {
        mealDishName: $("#mealDishName").val(),
        userAbrhs: misSession.userabrhs
    };
    calltoAjax(misApiUrl.addMealDish, "POST", jsonObject,
    function (result) {
        if (result == 1) {
            misAlert("Request processed successfully", "Success", "success");
            getMealDishes();
            $("#popupMealDish").modal("hide");
            $("#mealDishName").val("");
        }
        else if (result == 2)
            misAlert("Meal dish with same name already exists", "Warning", "warning");
        else
            misAlert("Unable to process request. Try again", "Error", "error");
    });
}

function updateMealDish() {
    if (!validateControls('modalMealDish')) {
        return false;
    }
    var jsonObject = {
        mealDishId: $("#hdnMealDishId").val(),
        mealDishName: $("#mealDishName").val(),
        userAbrhs: misSession.userabrhs
    };
    calltoAjax(misApiUrl.updateMealDish, "POST", jsonObject,
    function (result) {
        if (result == 1) {
            misAlert("Request processed successfully", "Success", "success");
            getMealDishes();
            $("#popupMealDish").modal("hide");
        }
        else if (result == 2)
            misAlert("Meal dish with same name already exists", "Warning", "warning");
        else
            misAlert("Unable to process request. Try again", "Error", "error");
    });
}

$("#btnClosePopupMealDish").click(function () {
    $("#popupMealDish").modal("hide");
    $("#mealDishName").val("");
});
