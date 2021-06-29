$(document).ready(function () {
    getMealPeriods();
});

function getMealPeriods() {
    calltoAjax(misApiUrl.getMealPeriod, "POST", '',
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#tblMealPeriod").dataTable({
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
                        "sTitle": "Meal Period Name",
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        mRender: function (data, type, row) {
                            var html = '<div>';
                            html += '<button type="button" data-toggle="tooltip" class="btn btn-sm btn-success"' + 'onclick="showPopupEditMealPeriod(' + row.Value + ',\'' + row.Text + '\')" title="Edit"><i class="fa fa-pencil-square-o" aria-hidden="true"></i></button>';
                            html += '&nbsp;<button type="button" data-toggle="tooltip" class="btn btn-sm btn-danger"' + 'onclick="deleteMealPeriod(' + row.Value + ')" title="Delete"><i class="fa fa-trash" aria-hidden="true"></i></button>';
                            return html;
                        }
                    },
                ]
            });
        });
}

function showPopupEditMealPeriod(mealPeriodId, mealPeriodName) {
    $("#popupMealPeriod").modal("show");
    $("#btnAddMealPeriod").hide();
    $("#btnUpdateMealPeriod").show();
    $("#popupMealPeriodTitle").text("Update meal period");
    $("#hdnMealPeriodId").val(mealPeriodId);
    $("#mealPeriodName").val(mealPeriodName);
}

function showPopupAddMealPeriod() {
    $("#popupMealPeriod").modal("show");
    $("#btnAddMealPeriod").show();
    $("#btnUpdateMealPeriod").hide();
    $("#popupMealPeriodTitle").text("Add meal period");
    $("#mealPeriodName").val("");
}

function deleteMealPeriod(mealPeriodId) {
    var reply = misConfirm("Are you sure you want to delete meal period", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                mealPeriodId: mealPeriodId,
                userAbrhs: misSession.userabrhs
            };
            calltoAjax(misApiUrl.deleteMealPeriod, "POST", jsonObject,
                function (result) {
                    if (result)
                    {
                        misAlert("Request processed successfully", "Success", "success");
                        getMealPeriods();
                    }
                    else
                        misAlert("Unable to process request. Try again", "Error", "error");
                });
        }
    });
}

function addMealPeriod() {
    if (!validateControls('modalMealPeriod')) {
        return false;
    }
    var jsonObject = {
        mealPeriodName: $("#mealPeriodName").val(),
        userAbrhs: misSession.userabrhs
    };
    calltoAjax(misApiUrl.addMealPeriod, "POST", jsonObject,
    function (result) {
        if (result == 1) {
            misAlert("Request processed successfully", "Success", "success");
            getMealPeriods();
            $("#popupMealPeriod").modal("hide");
            $("#mealPeriodName").val("");
        }
        else if(result == 2)
            misAlert("Meal period with same name already exists", "Warning", "warning");
        else
            misAlert("Unable to process request. Try again", "Error", "error");
    });
}

function updateMealPeriod() {
    if (!validateControls('modalMealPeriod')) {
        return false;
    }
    var jsonObject = {
        mealPeriodId: $("#hdnMealPeriodId").val(),
        mealPeriodName: $("#mealPeriodName").val(),
        userAbrhs: misSession.userabrhs
    };
    calltoAjax(misApiUrl.updateMealPeriod, "POST", jsonObject,
    function (result) {
        if (result == 1) {
            misAlert("Request processed successfully", "Success", "success");
            getMealPeriods();
            $("#popupMealPeriod").modal("hide");
        }
        else if (result == 2)
            misAlert("Meal period with same name already exists", "Warning", "warning");
        else
            misAlert("Unable to process request. Try again", "Error", "error");
    });
}

$("#btnClosePopupMealPeriod").click(function () {
    $("#popupMealPeriod").modal("hide");
    $("#mealPeriodName").val("");
});
