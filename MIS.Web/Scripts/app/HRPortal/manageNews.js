$(document).ready(function () {

    $('#fromDate').datepicker({
        format: "mm/dd/yyyy",
        autoclose: true,
        todayHighlight: true
    }).on('changeDate', function (ev) {
        var fromStartDate = new Date(ev.date.valueOf());
        $('#tillDate input').val('');
        $('#tillDate').datepicker('setStartDate', fromStartDate).trigger('change');
    });

    $('#tillDate').datepicker({
        format: "mm/dd/yyyy",
        autoclose: true,
        todayHighlight: true
    });


    $('#fromDateEdit').datepicker({
        format: "mm/dd/yyyy",
        autoclose: true,
        todayHighlight: true
    }).on('changeDate', function (ev) {
        var fromStartDate = new Date(ev.date.valueOf());
        $('#tillDateEdit input').val('');
        $('#tillDateEdit').datepicker('setStartDate', fromStartDate).trigger('change');
    });

    $('#tillDateEdit').datepicker({
        format: "mm/dd/yyyy",
        autoclose: true,
        todayHighlight: true
    });
    $("#divActionController").hide();
    $("#isInternal").change(function () {
        $("#newsLink").val("");
        if (this.checked) {
            $("#divActionController").show();
            $('#controller').addClass('validation-required');
            $('#action').addClass('validation-required');
            $("#newsLink").attr("disabled", "disabled");
        }
        else {
            $("#divActionController").hide();
            $("#newsLink").val("");
            $("#newsLink").prop('disabled', false);
            $('#controller').removeClass('validation-required');
            $('#action').removeClass('validation-required');
            //$("#newsLink").attr("disabled", "disabled");
        }
    });
    $("#isEditInternal").change(function () {
        if (this.checked) {
            _actionId = 0;
            $("#divEditActionController").show();
            $('#editController').select2("val","0");
            $('#editAction').select2("val", "0");
            $('#editController').addClass('validation-required');
            $('#editAction').addClass('validation-required');
            $("#newsEditLink").attr("disabled", "disabled");
        }
        else {
            $("#divEditActionController").hide();
            $("#newsEditLink").val("");
            $("#newsEditLink").prop('disabled', false);
            $('#editController').removeClass('validation-required');
            $('#editAction').removeClass('validation-required');
            //$("#newsLink").attr("disabled", "disabled");
        }
    });

    loadNewsGrid();
});

function loadNewsGrid() {
    var jsonObject = {
        UserAbrhs: misSession.userabrhs
    };
    calltoAjax(misApiUrl.getAllNews, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            _AllNews = resultData
            $("#tblNewsList").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'News History',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'News History' },
                        { extend: 'pdf', filename: 'News History' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                        { extend: 'print', filename: 'News History' },
                        ]
                    }
                ],
                "responsive": true,
                "autoWidth": false,
                "paging": true,
                "bDestroy": true,
                "ordering": true,
                "order": [],
                "info": true,
                "deferRender": true,
                "aaData": resultData,
                "aoColumns": [
                    {
                        "mData": "NewsTitle",
                        "sTitle": "News Title",
                    },
                    {
                        "mData": "NewsDescription",
                        "sTitle": "Description",
                    },
                    {
                        "mData": "FromDateDisplay",
                        "sTitle": "From Date",
                    },
                    {
                        "mData": "TillDateDisplay",
                        "sTitle": "Till Date",
                    },
                    {
                        "mData": "CreatedDate",
                        "sTitle": "Created Date",
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        "sClass": "text-center",
                        "sWidth": "110px",
                        mRender: function (data, type, row) {
                            var html = '<div>';
                            html += '<button type="button" class="btn btn-sm teal"' + 'onclick="editNews(' + row.NewsId + ')" data-toggle="tooltip" title="Edit"><i class="fa fa-edit"></i></button>';
                            if (row.IsActive) {
                                html += '&nbsp;<button type="button" data-toggle="tooltip" class="btn btn-sm btn-success"' + 'onclick="changeStatus(' + row.NewsId + ')"  title="DeActivate"><i class="fa fa-check"></i></button>';
                            }
                            else {
                                html += '&nbsp;<button type="button" data-toggle="tooltip" class="btn btn-sm btn-danger"' + 'onclick="changeStatus(' + row.NewsId + ')"  title="Activate"><i class="fa fa-ban"></i></button>';
                            }
                            html += '&nbsp;<button type="button" data-toggle="tooltip" class="btn btn-sm btn-danger"' + 'onclick="deletedNews(' + row.NewsId + ')"  title="Delete"><i class="fa fa-trash"></i></button>';
                            html += '</div>'
                            return html;
                        }
                    },
                ]
            });
        });
}

function addNews() {
    bindControllers();
    $("#modaladdNews").modal('show');
    $('#controller').removeClass('validation-required');
    $('#action').removeClass('validation-required');
}

$("#btnSaveNews").click(function () {
    if (!validateControls('modaladdNews')) {
        return false;
    }

    var jsonObject = {
        NewsTitle: $("#newsTitle").val(),
        NewsDescription: $("#newsDescription").val(),
        FromDate: $("#fromDate input").val(),
        TillDate: $("#tillDate input").val(),
        Link: $("#newsLink").val(),
        IsInternal: $('#isInternal').is(":checked"),
        ActionId: $("#action").val(),
        UserAbrhs: misSession.userabrhs
    };

    calltoAjax(misApiUrl.addNews, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            switch (resultData) {
                case 1:
                    misAlert("News has been saved successfully", "Success", "success");
                    $("#modaladdNews").modal('hide');
                    loadNewsGrid();
                    break;
                case 2:
                    misAlert("News Allready Exist.", "Warning", "warning");
                    break;
            }
        });
});

$("#btnClose").click(function () {
    $("#modaladdNews").modal('hide');
});


$("#btnEditClose").click(function () {
    $("#modalEditNews").modal('hide');
});
var _actionId = 0;
function editNews(newsId) {
    $('#editController').removeClass('validation-required');
    $('#editAction').removeClass('validation-required');
    _NewsId = newsId;
    bindEditControllers();
    var jsonObject = {
        newsId: newsId,
        userAbrhs: misSession.userabrhs
    };

    calltoAjax(misApiUrl.getNews, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            _actionId = resultData.ActionId;
            $("#newsTitleEdit").val(resultData.NewsTitle);
            $("#newsDescriptionEdit").val(resultData.NewsDescription);
            $("#fromDateEdit input").val(toddmmyyyDatePicker(resultData.FromDate));
            $("#tillDateEdit input").val(toddmmyyyDatePicker(resultData.TillDate));
            if (resultData.IsInternal == true) {
                $('#isEditInternal').prop('checked', true);
                $("#divEditActionController").show();
                $('#editController').val(resultData.ControllerId);
                $('#editController').select2().trigger('change');
                $('#editAction').val(resultData.ActionId);
                //$('#editAction').select2().trigger('change');
                $("#newsEditLink").attr("disabled", "disabled");
                $("#newsEditLink").val(resultData.Link);
            }
            else {
                $('#isEditInternal').prop('checked', false);
                $("#divEditActionController").hide();
                $("#newsEditLink").val(resultData.Link);
                $("#newsEditLink").prop('disabled', false);
            }
            $("#tillDateEdit input").val(toddmmyyyDatePicker(resultData.TillDate));
            $("#modalEditNews").modal('show');
        });

}

function changeStatus(newsId) {
    var reply = misConfirm("Are you sure you want to change the status of selected news ?", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                newsId: newsId,
                userAbrhs: misSession.userabrhs
            };

            calltoAjax(misApiUrl.changesNewsStatus, "POST", jsonObject,
                function (result) {
                    if (result === 1) {
                        misAlert("News status has been updated successfully", "Success", "success");
                        loadNewsGrid();
                    }
                });
        }
    });
}

function deletedNews(newsId) {
    var reply = misConfirm("Are you sure you want to delete selected news ?", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                newsId: newsId,
                userAbrhs: misSession.userabrhs
            };

            calltoAjax(misApiUrl.deleteNews, "POST", jsonObject,
                function (result) {
                    if (result === 1) {
                        misAlert("News has been deleted successfully", "Success", "success");
                        loadNewsGrid();
                    }
                });
        }
    });
}

$("#btnUpdateNews").click(function () {
    if (!validateControls('modalEditNews')) {
        return false;
    }
    var jsonObject = {
        NewsId: _NewsId,
        NewsTitle: $("#newsTitleEdit").val(),
        NewsDescription: $("#newsDescriptionEdit").val(),
        FromDate: $("#fromDateEdit input").val(),
        TillDate: $("#tillDateEdit input").val(),
        Link: $("#newsEditLink").val(),
        IsInternal: $('#isEditInternal').is(":checked"),
        ActionId: $("#editAction").val(),
        UserAbrhs: misSession.userabrhs
    };

    calltoAjax(misApiUrl.updateNews, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            switch (resultData) {
                case 1:
                    misAlert("News has been updated successfully", "Success", "success");
                    $("#modalEditNews").modal('hide');
                    loadNewsGrid();
                    break;
                case 2:
                    misAlert("News not Exist.", "Warning", "warning");
                    break;
            }
        });
});
function bindControllers() {
    $("#controller").html(""); //to clear the previously selected value
    $("#controller").select2();
    $("#controller").append("<option value='0'>Select</option>");
    calltoAjax(misApiUrl.getActiveControllers, "POST", "",
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $.each(resultData, function (idx, item) {
                $("#controller").append($("<option></option>").val(item.MenuId).html(item.ControllerName));
            });
        });
}
function bindEditControllers() {
    $("#editController").html(""); //to clear the previously selected value
    $("#editController").select2();
    $("#editController").append("<option value='0'>Select</option>");
    calltoAjax(misApiUrl.getActiveControllers, "POST", "",
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $.each(resultData, function (idx, item) {
                $("#editController").append($("<option></option>").val(item.MenuId).html(item.ControllerName));
            });
        });
}
function bindActions() {
    var controllerName = $("#controller option:selected").text();
    $("#newsLink").val(controllerName + "/");
    var controllerId = $('#controller').val()
    bindActionAccToControllerId(controllerId);
}
function bindEditActions() {
    var controllerName = $("#editController option:selected").text();
    $("#newsEditLink").val(controllerName + "/");
    var controllerId = $('#editController').val()
    bindEditActionAccToControllerId(controllerId);
}
function bindActionAccToControllerId(controllerId) {
    $("#action").html(""); //to clear the previously selected value
    $("#action").select2();
    $("#action").append("<option value='0'>Select</option>");
    var jsonObject = {
        controllerId: controllerId,
    };
    calltoAjax(misApiUrl.getActionsByControllerId, "POST", jsonObject,
        function (result) {
            $.each(result, function (idx, item) {
                $("#action").append($("<option></option>").val(item.MenuId).html(item.ControllerName));
            });
        });
}
function bindEditActionAccToControllerId(controllerId) {
    $("#editAction").html(""); //to clear the previously selected value
    $("#editAction").select2();
    $("#editAction").append("<option value='0'>Select</option>");
    var jsonObject = {
        controllerId: controllerId,
    };
    calltoAjax(misApiUrl.getActionsByControllerId, "POST", jsonObject,
        function (result) {
            $.each(result, function (idx, item) {
                if (item.MenuId == _actionId)
                    $("#editAction").append($("<option selected></option>").val(item.MenuId).html(item.ControllerName));
                else
                    $("#editAction").append($("<option></option>").val(item.MenuId).html(item.ControllerName));
            });
        });
}
function createLink() {
    var controllerName = $("#controller option:selected").text();
    var actionName = $("#action option:selected").text();
    $("#newsLink").val(controllerName + "/" + actionName);
}
function createEditLink() {
    var controllerName = $("#editController option:selected").text();
    var actionName = $("#editAction option:selected").text();
    $("#newsEditLink").val(controllerName + "/" + actionName);
}