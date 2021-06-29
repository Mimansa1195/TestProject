$(document).ready(function () {
    getAllAssets();
});

function getAllAssets() {
    calltoAjax(misApiUrl.getAllAssetsDetail, "POST", '',
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
                        "mData": "AssetType",
                        "sTitle": "Asset Type",
                    },
                    {
                        "mData": "BrandName",
                        "sTitle": "Make",
                    },
                    {
                        "mData": "Model",
                        "sTitle": "Model",
                    },
                   
                    {
                        "mData": "SerialNumber",
                        "sTitle": "Serial Number",
                    },
                    {
                        "mData": "Description",
                        "sTitle": "Description",
                    },
                    {
                        "mData": null,
                        "sTitle": "Status",
                        'bSortable': false,
                        "sClass": "text-center",
                        "mRender": function (data, type, row) {
                            var html = "";
                            if (data.IsActive && !data.IsLost) {
                                html = '<span class="label label-success">Active</span>';
                            }
                            else if (data.IsActive && data.IsLost) {
                                html = '<span class="label label-danger">Lost</span>';
                            }
                            else {
                                html = '<span class="label label-warning">InActive</span>';
                            }
                            return html;
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Is Allocated",
                        'bSortable': false,
                        "sClass": "text-center",
                        "mRender": function (data, type, row) {
                            var html = "";
                            if ((data.IsFree || data.IsLost)) {
                                html = '<span class="label label-success">No</span>';
                            }
                            else{
                                html = '<span class="label label-info">Yes</span>';
                            }
                            return html;
                        }
                    },
                    
                    {
                        "mData": "AllocatedTo",
                        "sTitle": "Allocated To",
                    },
                    
                    {
                        "mData": "CreatedDate",
                        "sTitle": "Created On",
                    },
                    {
                        "mData": "CreatedBy",
                        "sTitle": "Created By",
                    },
                    {
                        "mData": "ModifiedOn",
                        "sTitle": "Modified On",
                    },
                    {
                        "mData": "ModifiedBy",
                        "sTitle": "Modified By",
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        "sClass": "text-center",
                        "mRender": function (data, type, row) {
                            if (data.IsActive && data.IsFree && !data.IsLost) {
                                var html = '<div>';
                                html += '<button type="button"  class="btn btn-sm btn-success"' + 'onclick="showPopupEditAssetDetail(' + row.AssetId + ', ' + row.BrandId + ', ' + row.AssetTypeId + ',\'' + row.Description + '\',\'' + row.Model + '\',\'' + row.SerialNumber + '\')" title="Edit"><i class="fa fa-edit" aria-hidden="true"></i></button>';
                                html += '&nbsp<button type="button"  class="btn btn-sm btn-danger"' + 'onclick="deleteAsset(' + row.AssetId + ')" title="Delete"><i class="fa fa-trash" aria-hidden="true"></i></button></div>';
                                return html;
                            }
                            else {
                                return "";
                            }
                        }
                    },
                ]
            });
        });
}

$("#btnAddNewAssetDetail").click(function () {
    showPopupAddNewAsset();
});


function showPopupAddNewAsset() {
    $("#hdnAssetId").val(0);
    $("#popupAssetDetails").modal("show");
    $("#btnAddAsset").show();
    $("#ddlAssetType").show();
    $("#ddlMake").show();
    $("#txtModel").show();
    $("#btnUpdateAsset").hide();
    $("#popupAssetDetailsTitle").text("Add Asset");

    $("#txtModel").val("");
    $("#txtSrNumber").val("");
    $("#txtDescription").val("");

    bindAssetTypeDropdown(0);
    getAssetsMake(0);
}

function bindAssetTypeDropdown(selectedId) {
    $("#ddlAssetType").empty();
    $("#ddlAssetType").append("<option value = '0'>Select</option>");
    calltoAjax(misApiUrl.getAssetTypesToManageAsset, "POST", "",
        function (result) {
            $.each(result, function(idx, item){
                $("#ddlAssetType").append($("<option></option>").val(item.Value).html(item.Text));
            });
            if (selectedId > 0) {
                $("#ddlAssetType").val(selectedId)
            }
        });
}

function getAssetsMake(selectedId) {
    $("#ddlMake").empty();
    $("#ddlMake").append("<option value = '0'>Select</option>");
    calltoAjax(misApiUrl.getAssetsBrand, "POST", "",
        function (result) {
            $.each(result, function (idx, item) {
                $("#ddlMake").append($("<option></option>").val(item.BrandId).html(item.BrandName));
            });
            if (selectedId > 0) {
                $("#ddlMake").val(selectedId)
            }
        });
}

$("#btnAddAsset").click(function () {
    addUpdateAssetsDetail();
});

$("#btnUpdateAsset").click(function () {
    addUpdateAssetsDetail();
});

function addUpdateAssetsDetail() {
    if (!validateControls('modalAssetDetails')) {
        return false;
    }
    var jsonObject = {
        AssetId: $("#hdnAssetId").val(),
        AssetTypeId: $("#ddlAssetType").val(),
        BrandId: $("#ddlMake").val(),
        Model: $("#txtModel").val(),
        SerialNumber: $("#txtSrNumber").val(),
        Description: $("#txtDescription").val(),
        IsActive: true
    };
    calltoAjax(misApiUrl.addUpdateAssetsDetail, "POST", jsonObject,
    function (result) {
        if (result == 1) {
            misAlert("Request processed successfully", "Success", "success");
            getAllAssets();
            $("#popupAssetDetails").modal("hide");
            $("#txtSrNumber").val('');
        }
        else if (result == 2) {
            misAlert("Asset exists already", "Warning", "warning");
        }
        else
            misAlert("Unable to process request. Try again", "Error", "error");
    });
}

function showPopupEditAssetDetail(assetId, brandId, assetTypeId, desc, model, srNumber) {
    $("#popupAssetDetails").modal("show");
    $("#popupAssetDetailsTitle").text("Update Asset");
    $("#hdnAssetId").val(assetId);
    $("#btnAddAsset").hide();
    $("#btnUpdateAsset").show();
    $("#txtModel").val(model);
    $("#txtSrNumber").val(srNumber);
    $("#txtDescription").val(desc);
    bindAssetTypeDropdown(assetTypeId);
    getAssetsMake(brandId);
}

function deleteAsset(assetId) {
    var reply = misConfirm("<span style='color:red;'>Are you sure you want to delete this asset. Once deleted, it can't be re-actived.</span>", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                AssetId: assetId,
                IsActive: false
            };
            calltoAjax(misApiUrl.addUpdateAssetsDetail, "POST", jsonObject,
                function (result) {
                    if (result == 1) {
                        misAlert("Request processed successfully", "Success", "success");
                        getAllAssets();
                    }
                    else if (result == 2) {
                        misAlert("Asset already exists", "Warning", "warning");
                    }
                    else
                        misAlert("Unable to process request. Try again", "Error", "error");
                });
        }
    }, true, true,true);
}

$("#btnClosePopupAssetDetails").click(function () {
    $("#popupAssetDetails").modal("hide");
});