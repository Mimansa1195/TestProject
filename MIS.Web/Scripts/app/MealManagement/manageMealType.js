function onMealTypeTabClick() {
    getMealTypes();
}

function getMealTypes() {
    calltoAjax(misApiUrl.getMealType, "POST", '',
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#tblMealType").dataTable({
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
                        "sTitle": "Meal Type Name",
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        mRender: function (data, type, row) {
                            var html = '<div>';
                            html += '<button type="button" data-toggle="tooltip" class="btn btn-sm btn-success"' + 'onclick="showPopupEditMealType(' + row.Value + ',\'' + row.Text + '\')" title="Edit"><i class="fa fa-pencil-square-o" aria-hidden="true"></i></button>';
                            html += '&nbsp;<button type="button" data-toggle="tooltip" class="btn btn-sm btn-danger"' + 'onclick="deleteMealType(' + row.Value + ')" title="Delete"><i class="fa fa-trash" aria-hidden="true"></i></button>';
                            return html;
                        }
                    },
                ]
            });
        });
}

function showPopupEditMealType(mealTypeId, mealTypeName) {
    $("#popupMealType").modal("show");
    $("#btnAddMealType").hide();
    $("#btnUpdateMealType").show();
    $("#popupMealTypeTitle").text("Update meal type");
    $("#hdnMealTypeId").val(mealTypeId);
    $("#mealTypeName").val(mealTypeName);
}

function showPopupAddMealType() {
    $("#popupMealType").modal("show");
    $("#btnAddMealType").show();
    $("#btnUpdateMealType").hide();
    $("#popupMealTypeTitle").text("Update meal type");
    $("#mealTypeName").val("");
}

function deleteMealType(mealTypeId) {
    var reply = misConfirm("Are you sure you want to delete meal type", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                mealTypeId: mealTypeId,
                userAbrhs: misSession.userabrhs
            };
            calltoAjax(misApiUrl.deleteMealType, "POST", jsonObject,
                function (result) {
                    if (result) {
                        misAlert("Request processed successfully", "Success", "success");
                        getMealTypes();
                    }
                    else
                        misAlert("Unable to process request. Try again", "Error", "error");
                });
        }
    });
}

function addMealType() {
    if (!validateControls('modalMealType')) {
        return false;
    }
    var jsonObject = {
        mealTypeName: $("#mealTypeName").val(),
        userAbrhs: misSession.userabrhs
    };
    calltoAjax(misApiUrl.addMealType, "POST", jsonObject,
    function (result) {
        if (result == 1) {
            misAlert("Request processed successfully", "Success", "success");
            getMealTypes();
            $("#popupMealType").modal("hide");
            $("#mealTypeName").val("");
        }
        else if (result == 2)
            misAlert("Meal type with same name already exists", "Warning", "warning");
        else
            misAlert("Unable to process request. Try again", "Error", "error");
    });
}

function updateMealType() {
    if (!validateControls('modalMealType')) {
        return false;
    }
    var jsonObject = {
        mealTypeId: $("#hdnMealTypeId").val(),
        mealTypeName: $("#mealTypeName").val(),
        userAbrhs: misSession.userabrhs
    };
    calltoAjax(misApiUrl.updateMealType, "POST", jsonObject,
    function (result) {
        if (result == 1) {
            misAlert("Request processed successfully", "Success", "success");
            getMealTypes();
            $("#popupMealType").modal("hide");
        }
        else if (result == 2)
            misAlert("Meal type with same name already exists", "Warning", "warning");
        else
            misAlert("Unable to process request. Try again", "Error", "error");
    });
}

$("#btnClosePopupMealType").click(function () {
    $("#popupMealType").modal("hide");
    $("#mealTypeName").val("");
});
