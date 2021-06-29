$(document).ready(function () {
    getAllAssets();
});

function getAllAssets() {
    calltoAjax(misApiUrl.getAllAssets, "POST", '',
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#tblAllAsset").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'All Assets List',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'All Assets List' },
                        { extend: 'pdf', filename: 'All Assets List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                        { extend: 'print', filename: 'All Assets List' },
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
                        "mData": "Make",
                        "sTitle": "Make",
                    },
                    {
                        "mData": "Model",
                        "sTitle": "Model",
                    },
                    {
                        "mData": "Description",
                        "sTitle": "Description",
                    },
                    {
                        "mData": "SerialNumber",
                        "sTitle": "Serial Number",
                    },
                    {
                        "mData": "AssetTag",
                        "sTitle": "Asset Tag",
                    },
                    {
                        "mData": "AttributeType",
                        "sTitle": "Attribute Type",
                    },
                    {
                        "mData": "AttributeValue",
                        "sTitle": "Attribute Value",
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        "sClass": "text-center",
                        mRender: function (data, type, row) {
                            var html = '<div>';
                            html += '<button type="button" data-toggle="tooltip" class="btn btn-sm btn-success"' + 'onclick="showPopupEditAssetDetail(' + row.AssetDetailId + ')" title="Edit"><i class="fa fa-edit" aria-hidden="true"></i></button>';
                            html += '&nbsp<button type="button" data-toggle="tooltip" class="btn btn-sm btn-danger"' + 'onclick="deleteAsset(' + row.AssetDetailId + ')" title="Delete"><i class="fa fa-trash" aria-hidden="true"></i></button></div>';
                            return html;
                        }
                    },
                ]
            });
        });
}

function showPopupAddNewAsset() {
    $("#popupAssetDetails").modal("show");
    $("#btnAddAsset").show();
    $("#assetType").show();
    $("#assetModel").show();
    $("#btnUpdateAsset").hide();
    $("#assetTypetext").hide();
    $("#assetModeltext").hide();
    $("#popupAssetDetailsTitle").text("Add asset");

    bindAssetTypeDropdown(0);
}

function bindAssetTypeDropdown(selectedId) {
    $("#assetType").empty();
    $("#assetType").append("<option value = '0'>Select</option>");
    calltoAjax(misApiUrl.getAssetTypes, "POST", '',
        function (result) {
            $.each(result, function (idx, item) {
                $("#assetType").append($("<option></option>").val(item.Value).html(item.Text));
            });
            if (selectedId > 0) {
                $("#assetType").val(selectedId)
            }
        });
}

function onAssetTypeChange(selectedId) {
    $("#assetModel").empty();
    $("#assetModel").append("<option value = '0'>Select</option>");
    var jsonObject = {
        assetTypeId: $("#assetType").val(),
    };
    calltoAjax(misApiUrl.getAssetModels, "POST", jsonObject,
        function (result) {
            $.each(result, function (idx, item) {
                $("#assetModel").append($("<option></option>").val(item.Value).html(item.Text));
            });
            //if (selectedId > 0) {
            //    $("#assetModel").val(selectedId)
            //}
        });
}

function addAsset() {
    if (!validateControls('modalAssetDetails')) {
        return false;
    }
    var jsonObject = {
        AssetId: $("#assetModel").val(),
        SerialNumber: $("#serialNumber").val(),
        AssetTag: $("#assetTag").val(),
        AttributeType: $("#attributeType").val(),
        AttributeValue: $("#attributeValue").val(),
        UserAbrhs: misSession.userabrhs
    };
    calltoAjax(misApiUrl.addAssetDetails, "POST", jsonObject,
        function (result) {
            if (result) {
                misAlert("Request processed successfully", "Success", "success");
                getAllAssets();
                $("#popupAssetDetails").modal("hide");
                $("#serialNumber").val('');
                $("#assetTag").val('');
                $("#attributeType").val('');
                $("#attributeValue").val('');
            }
            else
                misAlert("Unable to process request. Try again", "Error", "error");
        });
}

function updateAsset() {
    if (!validateControls('modalAssetDetails')) {
        return false;
    }
    var jsonObject = {
        AssetDetailId: $("#hdnAssetDetailId").val(),
        SerialNumber: $("#serialNumber").val(),
        AssetTag: $("#assetTag").val(),
        AttributeType: $("#attributeType").val(),
        AttributeValue: $("#attributeValue").val(),
        UserAbrhs: misSession.userabrhs
    };
    calltoAjax(misApiUrl.updateAssetDetails, "POST", jsonObject,
        function (result) {
            if (result) {
                misAlert("Request processed successfully", "Success", "success");
                getAllAssets();
                $("#popupAssetDetails").modal("hide");
                $("#serialNumber").val('');
                $("#assetTag").val('');
                $("#attributeType").val('');
                $("#attributeValue").val('');
            }
            else
                misAlert("Unable to process request. Try again", "Error", "error");
        });
}

function showPopupEditAssetDetail(assetDetailId) {
    $("#popupAssetDetails").modal("show");
    $("#btnAddAsset").hide();
    $("#assetType").hide();
    $("#assetModel").hide();
    $("#assetType").removeClass("validation-required");
    $("#assetModel").removeClass("validation-required");
    $("#btnUpdateAsset").show();
    $("#assetTypetext").show();
    $("#assetModeltext").show();
    $("#popupAssetDetailsTitle").text("Update asset");
    $("#hdnAssetDetailId").val(assetDetailId);

    getAssetDetails(assetDetailId);
}

function getAssetDetails(assetDetailId) {
    var jsonObject = {
        assetDetailId: assetDetailId,
    };
    calltoAjax(misApiUrl.getAssetDetailsById, "POST", jsonObject,
        function (result) {
            if (result != null) {
                $("#assetTypetext").text(result.AssetType);
                $("#assetModeltext").text(result.Model);
                //bindAssetTypeDropdown(result.AssetTypeId);
                $("#serialNumber").val(result.SerialNumber);
                $("#assetTag").val(result.AssetTag);
                $("#attributeType").val(result.AttributeType);
                $("#attributeValue").val(result.AttributeValue);
            }
            else
                misAlert("Unable to process request. Try again", "Error", "error");
        });
}

function deleteAsset(assetDetailId) {
    var reply = misConfirm("Are you sure you want to delete asset", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                assetDetailId: assetDetailId,
                userAbrhs: misSession.userabrhs,
            }
            calltoAjax(misApiUrl.deleteAssetDetails, "POST", jsonObject,
                function (result) {
                    if (result) {
                        misAlert("Request processed successfully", "Success", "success");
                        getAllAssets();
                    }
                    else
                        misAlert("Unable to process request. Try again", "Error", "error");
                });
        }
    });
}

$("#btnClosePopupAssetDetails").click(function () {
    $("#popupAssetDetails").modal("hide");
});