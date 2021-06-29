function onMealCategoryTabClick() {
    getMealCategories();
}

function getMealCategories() {
    calltoAjax(misApiUrl.getMealCategory, "POST", '',
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#tblMealCategory").dataTable({
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
                        "sTitle": "Meal Category Name",
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        mRender: function (data, type, row) {
                            var html = '<div>';
                            html += '<button type="button" data-toggle="tooltip" class="btn btn-sm btn-success"' + 'onclick="showPopupEditMealCategory(' + row.Value + ',\'' + row.Text + '\')" title="Edit"><i class="fa fa-pencil-square-o" aria-hidden="true"></i></button>';
                            html += '&nbsp;<button type="button" data-toggle="tooltip" class="btn btn-sm btn-danger"' + 'onclick="deleteMealCategory(' + row.Value + ')" title="Delete"><i class="fa fa-trash" aria-hidden="true"></i></button>';
                            return html;
                        }
                    },
                ]
            });
        });
}

function showPopupEditMealCategory(mealCategoryId, mealCategoryName) {
    $("#popupMealCategory").modal("show");
    $("#btnAddMealCategory").hide();
    $("#btnUpdateMealCategory").show();
    $("#popupMealCategoryTitle").text("Update meal category");
    $("#hdnMealCategoryId").val(mealCategoryId);
    $("#mealCategoryName").val(mealCategoryName);
}

function showPopupAddMealCategory() {
    $("#popupMealCategory").modal("show");
    $("#btnAddMealCategory").show();
    $("#btnUpdateMealCategory").hide();
    $("#popupMealCategoryTitle").text("Update meal category");
    $("#mealCategoryName").val("");
}

function deleteMealCategory(mealCategoryId) {
    var reply = misConfirm("Are you sure you want to delete meal category", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                mealCategoryId: mealCategoryId,
                userAbrhs: misSession.userabrhs
            };
            calltoAjax(misApiUrl.deleteMealCategory, "POST", jsonObject,
                function (result) {
                    if (result) {
                        misAlert("Request processed successfully", "Success", "success");
                        getMealCategories();
                    }
                    else
                        misAlert("Unable to process request. Try again", "Error", "error");
                });
        }
    });
}

function addMealCategory() {
    if (!validateControls('modalMealCategory')) {
        return false;
    }
    var jsonObject = {
        mealCategoryName: $("#mealCategoryName").val(),
        userAbrhs: misSession.userabrhs
    };
    calltoAjax(misApiUrl.addMealCategory, "POST", jsonObject,
    function (result) {
        if (result == 1) {
            misAlert("Request processed successfully", "Success", "success");
            getMealCategories();
            $("#popupMealCategory").modal("hide");
            $("#mealCategoryName").val("");
        }
        else if (result == 2)
            misAlert("Meal category with same name already exists", "Warning", "warning");
        else
            misAlert("Unable to process request. Try again", "Error", "error");
    });
}

function updateMealCategory() {
    if (!validateControls('modalMealCategory')) {
        return false;
    }
    var jsonObject = {
        mealCategoryId: $("#hdnMealCategoryId").val(),
        mealCategoryName: $("#mealCategoryName").val(),
        userAbrhs: misSession.userabrhs
    };
    calltoAjax(misApiUrl.updateMealCategory, "POST", jsonObject,
    function (result) {
        if (result == 1) {
            misAlert("Request processed successfully", "Success", "success");
            getMealCategories();
            $("#popupMealCategory").modal("hide");
        }
        else if (result == 2)
            misAlert("Meal category with same name already exists", "Warning", "warning");
        else
            misAlert("Unable to process request. Try again", "Error", "error");
    });
}

$("#btnClosePopupMealCategory").click(function () {
    $("#popupMealCategory").modal("hide");
    $("#mealCategoryName").val("");
});
