var today = new Date();
var currentDate = new Date(today.getFullYear(), (today.getMonth()), (today.getDate() - 30));
var _controlId = "";
var _selectedTableId;
var _selectAll = "";
var rows_selected = [];
var tableNestedAllocatedAsset = "";
var tableNestedDeAllocatedAsset = "";
var employeeName = "";
var table;
$(document).ready(function () {
    bindPendingForDeallocation();

    $("a[href = '#tabAllocateAsset']").on('click', function () {
        table = "";
        bindUsersAllocatedAsset();
    });
    $("a[href = '#tabViewAssetAllocationHistory']").on('click', function () {
        table = "";
        bindUsersDeAllocatedAsset();
    });
    $("a[href = '#tabPendingDeAllocateAsset']").on('click', function () {
        table = "";
        bindPendingForDeallocation();
    });
    $("#btnAllocateNewAssetToUser").click(function () {
        $("#modalPopUpAllocateAssetTitle").text("Allocate Assets");

        $('#ddlAssetType').multiselect({
            includeSelectAllOption: true,
            enableFiltering: true,
            enableCaseInsensitiveFiltering: true,
            buttonWidth: false,
            onDropdownHidden: function (event) {
            }
        });

        $('#ddlAssets').multiselect({
            includeSelectAllOption: true,
            enableFiltering: true,
            enableCaseInsensitiveFiltering: true,
            buttonWidth: false,
            onDropdownHidden: function (event) {
            }
        });

        //$("#hdnAssetRequestId").val(0);
        //$("#hdnAssetId").val(0);
        $("#divEmpDetails").hide();
        $("#btnAllocateAsset").hide();
        $("#btnUpdateAllocatedAsset").hide();
        $("#txtRemarks").val('');
        $("#allocateFrom input").val('');
        $("#ddlEmployees").removeAttr("disabled", true);
        bindEmployeeList(0);
        bindAssetTypeDropdown(0, 0);

        $("#modalPopUpAllocateAsset").modal('show');
    });

    $("#ddlEmployees").change(function () {
        $("#divEmpDetails").hide();
        if ($("#ddlEmployees").val() == '0') {
            $("#divEmpDetails").hide();
            $("#btnAllocateAsset").hide();
        }
        else {
            getuserData();
            $("#divEmpDetails").show();
            $("#btnAllocateAsset").show();
        }
    });

    $('#allocateFrom').datepicker({
        autoclose: true,
        todayHighlight: true,
    }).datepicker('setStartDate', currentDate);

    // For DeAllocatetion
    // Handle click on checkbox
    $('body').on('click', '#tblNestedAllocatedAsset tbody input[type="checkbox"]', function (e) {
        var $row = $(this).closest('tr');
        // Get row data
        var data = tableNestedAllocatedAsset.row($row).data();
        // Get row ID
        var rowId = data[0];
        // Determine whether row ID is in the list of selected row IDs
        var index = $.inArray(rowId, rows_selected);
        // If checkbox is checked and row ID is not in list of selected row IDs
        if (this.checked && index === -1) {
            rows_selected.push(rowId);
            //$(this).parent().parent("tr").addClass("selected");
            // Otherwise, if checkbox is not checked and row ID is in list of selected row IDs
        } else if (!this.checked && index !== -1) {
            rows_selected.splice(index, 1);
        }
        // Update state of "Select all" control
        updateDataTableSelectAllCtrlUn(tableNestedAllocatedAsset);
        // Prevent click event from propagating to parent
        e.stopPropagation();
    });

    // Handle click on "Select all " control
    $('body').on('click', '#nestedAllocatedAsset', function (e) {
        if (this.checked) {
            $('input[type="checkbox"]', '#tblNestedAllocatedAsset').prop('checked', true);
            var count = $('#tblNestedAllocatedAsset tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        } else {
            $('input[type="checkbox"]', '#tblNestedAllocatedAsset').prop('checked', false);
            var count = $('#tblNestedAllocatedAsset tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        }
        // Prevent click event from propagating to parent
        e.stopPropagation();
    })

    // Handle click on "Select all " control
    $('#tblNestedAllocatedAsset tbody').on('click', 'input[Name="UnCheckbox"]', function (e) {
        if (this.checked) {
            $('input[type="checkbox"]', '#tblNestedAllocatedAsset').prop('checked', true);
            var count = $('#tblNestedAllocatedAsset tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        } else {
            $('input[type="checkbox"]', '#tblNestedAllocatedAsset').prop('checked', false);
            var count = $('#tblNestedAllocatedAsset tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        }
        // Prevent click event from propagating to parent
        e.stopPropagation();
    })

    // Handle click on tableLeaveReviewRequestPending cells with checkboxes
    $('#tblNestedAllocatedAsset tbody').on('click', 'input[type="checkbox"]', function (e) {
        if (e.target.name != "UnCheckbox") {
            $(this).parent().find('input[type="checkbox"]').trigger('click');
            var count = $('#tblNestedAllocatedAsset tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        }
        else {
            var count = $('#tblNestedAllocatedAsset tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        }
    });

    // Handle table draw event
    if (tableNestedAllocatedAsset) {
        tableNestedAllocatedAsset.on('draw', function () {
            // Update state of "Select all" control
            updateDataTableSelectAllCtrlUn(tableNestedAllocatedAsset);
        });
    }


    //For Collection

    // For DeAllocatetion
    // Handle click on checkbox
    $('body').on('click', '#tblNestedDeAllocatedAsset tbody input[type="checkbox"]', function (e) {
        var $row = $(this).closest('tr');
        // Get row data
        var data = tableNestedDeAllocatedAsset.row($row).data();
        // Get row ID
        var rowId = data[0];
        // Determine whether row ID is in the list of selected row IDs
        var index = $.inArray(rowId, rows_selected);
        // If checkbox is checked and row ID is not in list of selected row IDs
        if (this.checked && index === -1) {
            rows_selected.push(rowId);
            //$(this).parent().parent("tr").addClass("selected");
            // Otherwise, if checkbox is not checked and row ID is in list of selected row IDs
        } else if (!this.checked && index !== -1) {
            rows_selected.splice(index, 1);
        }
        // Update state of "Select all" control
        updateDataTableSelectAllCtrlUn(tableNestedDeAllocatedAsset);
        // Prevent click event from propagating to parent
        e.stopPropagation();
    });

    // Handle click on "Select all " control
    $('body').on('click', '#nestedDeAllocatedAsset', function (e) {
        if (this.checked) {
            $('input[type="checkbox"]', '#tblNestedDeAllocatedAsset').prop('checked', true);
            var count = $('#tblNestedDeAllocatedAsset tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        } else {
            $('input[type="checkbox"]', '#tblNestedDeAllocatedAsset').prop('checked', false);
            var count = $('#tblNestedDeAllocatedAsset tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        }
        // Prevent click event from propagating to parent
        e.stopPropagation();
    })

    // Handle click on "Select all " control
    $('#tblNestedDeAllocatedAsset tbody').on('click', 'input[Name="UnCheckbox"]', function (e) {
        if (this.checked) {
            $('input[type="checkbox"]', '#tblNestedDeAllocatedAsset').prop('checked', true);
            var count = $('#tblNestedDeAllocatedAsset tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        } else {
            $('input[type="checkbox"]', '#tblNestedDeAllocatedAsset').prop('checked', false);
            var count = $('#tblNestedDeAllocatedAsset tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        }
        // Prevent click event from propagating to parent
        e.stopPropagation();
    })

    // Handle click on tableLeaveReviewRequestPending cells with checkboxes
    $('#tblNestedDeAllocatedAsset tbody').on('click', 'input[type="checkbox"]', function (e) {
        if (e.target.name != "UnCheckbox") {
            $(this).parent().find('input[type="checkbox"]').trigger('click');
            var count = $('#tblNestedDeAllocatedAsset tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        }
        else {
            var count = $('#tblNestedDeAllocatedAsset tbody').find("input[type=checkbox]:checked").size()
            $("#general i .counter").text(count);
        }
    });

    // Handle table draw event
    if (tableNestedDeAllocatedAsset) {
        tableNestedDeAllocatedAsset.on('draw', function () {
            // Update state of "Select all" control
            updateDataTableSelectAllCtrlUn(tableNestedDeAllocatedAsset);
        });
    }

    $("#popoverGuidelines").popover({
        html: true,
        content: function () {
            return $("#popoverGuidelines-content").html();
        },
        title: function () {
            return $("#popoverGuidelines-title").html();
        }
    });

    getSampleLink();

});

function checkfileIsExceltp(sender) {
    var validExts = new Array(".xlsx", ".xls");
    var fileExt = sender.value;
    fileExt = fileExt.substring(fileExt.lastIndexOf('.'));
    if (validExts.indexOf(fileExt) < 0) {
        etpAlert("Invalid file selected, valid files are of " + validExts.toString());
        $('#btnUploadAllocateAsset').attr('disabled', true);
        return false;
    } else {
        $('#btnUploadAllocateAsset').attr('disabled', false);
        return true;
    }
}

$("#btnUploadAllocateAsset").click(function (e) {
    if (misSession.userabrhs && misSession.token) {
        var form = document.getElementById("frmUploadAllocatedAssets");
        form.submit();
    }
    else {
        misSession.logout();
        redirectToURL(misAppUrl.login);
    }
});

$("#btnExcelAllocate").click(function () {
    var uploadUrl = misApiUrl.uploadAllocatedAssets + "?userAbrhs=" + misSession.userabrhs + "&token=" + misSession.token;
    $("#frmUploadAllocatedAssets").attr("action", uploadUrl);
    $('#btnUploadAllocateAsset').attr('disabled', true);
    $("#modalPopUpAllocateAssetFromExcel").modal('show');
    document.getElementById('myiframe').src = '';
    $("#allocatedAssetsFile").val('');
});

function updateDataTableSelectAllCtrlUn(tableAssigned) {
    var tableAssigned = tableAssigned.table().node();
    var $chkbox_all = $('tbody input[type="checkbox"]', tableAssigned);
    var $chkbox_checked = $('tbody input[type="checkbox"]:checked', tableAssigned);
    var chkbox_select_all = $('thead input[name="select_all"]', tableAssigned).get(0);

    // If none of the checkboxes are checked
    if ($chkbox_checked.length === 0) {
        chkbox_select_all.checked = false;
        if ('indeterminate' in chkbox_select_all) {
            chkbox_select_all.indeterminate = false;
        }

        // If all of the checkboxes are checked
    } else if ($chkbox_checked.length === $chkbox_all.length) {
        chkbox_select_all.checked = true;
        if ('indeterminate' in chkbox_select_all) {
            chkbox_select_all.indeterminate = false;
        }

        // If some of the checkboxes are checked
    } else {

        chkbox_select_all.checked = true;
        if ('indeterminate' in chkbox_select_all) {
            chkbox_select_all.indeterminate = true;
        }
    }
}

$("#ddlAssetType").change(function () {
    bindAssetsList();
});

function bindAssetTypeDropdown(selectedId, assetId) {
    calltoAjax(misApiUrl.getAssetTypes, "POST", "",
        function (result) {
            $('#ddlAssetType').multiselect("destroy");
            $('#ddlAssetType').empty();
            if (result.length != 0) {
                $('#ddlAssetType').multiselect("destroy");
                $('#ddlAssetType').empty();
                $.each(result, function (index, item) {
                    $('<option>').val(item.Value).text(item.Text).appendTo('#ddlAssetType');
                });
            }
            //else {
            //    $('<option selected>').val("0").text("No data found").appendTo('#ddlAssetType');
            //}
            $('#ddlAssetType').multiselect({
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                buttonWidth: false,
                onDropdownHidden: function (event) {
                }
            });

            bindAssetsList();
        });
}

function bindAssetsList() {
    var assetTypeIds = "";
    if ($("#ddlAssetType").val() !== null) {
        assetTypeIds = $("#ddlAssetType").val().join(',');
    }
    var jsonObject = {
        assetTypeIds: assetTypeIds
    };
    calltoAjax(misApiUrl.getAllUnAllocatedAssets, "POST", jsonObject,
        function (result) {
            $('#ddlAssets').multiselect("destroy");
            $('#ddlAssets').empty();
            if (result.length != 0) {
                $.each(result, function (index, value) {
                    $('<option>').val(value.AssetId).text(value.Assets).appendTo('#ddlAssets');
                });
            }
            //else {
            //    $('<option selected>').val("0").text("No data found").appendTo('#ddlAssets');
            //}
            $('#ddlAssets').multiselect({
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                buttonWidth: false,
                onDropdownHidden: function (event) {
                }
            });

        });
}

function getSampleLink() {
    var jsonObject = {
        sampleType: "ALLOCATE"
    };

    calltoAjax(misApiUrl.getSampleDocumentUrl, "POST", jsonObject,
        function (result) {
            $("#linkSampleAllocatedAsset").attr("href", result);
        });
}

function getuserData() {
    var jsonObject = {
        userAbrhs: $("#ddlEmployees").val()
    }
    calltoAjax(misApiUrl.getUserPrfileData, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            var imagepath = data.ImagePath === "" ? "../img/avatar-sign.png" : misApiProfileImageUrl + data.ImagePath;
            var LoginUserName = data.FirstName + ' ' + data.LastName;
            $("#imagepath").attr("src", imagepath);
            $("#rManager").html(data.Manager);
            $("#displayJoiningDate").html(data.DisplayJoiningDate);
            $("#empCode").html(data.EmployeeId);
        });
}

function bindEmployeeList(selectedId) {
    $("#ddlEmployees").empty();
    $("#ddlEmployees").append("<option value = '0'>Select</option>");
    var jsonObject = {
        status: 1
    };
    calltoAjax(misApiUrl.getAllEmployeesByStatus, "POST", jsonObject,
        function (result) {
            $.each(result, function (idx, item) {
                $("#ddlEmployees").append($("<option></option>").val(item.EmployeeAbrhs).html(item.Name));
            });
            if (selectedId != "0") {
                $("#ddlEmployees").val(selectedId);
                getuserData();
                $("#divEmpDetails").show();
            }
        });
}

function format(data) {
    $("#tblNestedAllocatedAsset").dataTable({
        // "dom": 'lBfrtip',
        "buttons": [
            {
                filename: 'Asset Details For IT Department',
                extend: 'collection',
                text: 'Export',
                buttons: [{ extend: 'copy' },
                { extend: 'excel', filename: 'Asset Details For IT Department' },
                { extend: 'pdf', filename: 'Asset Details For IT Department' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                { extend: 'print', filename: 'Asset Details For IT Department' },
                ]
            }
        ],
        "responsive": true,
        "autoWidth": false,
        "paging": false,
        "bDestroy": true,
        "ordering": true,
        "order": [], // disable default sorting
        "info": false,
        "deferRender": true,
        "searching": false,
        "aaData": data,
        "aoColumns": [
            {
                'targets': 0,
                'searchable': false,
                'width': '1%',
                'orderable': false,
                'bSortable': false,
                "sTitle": '<input name="select_all" value="1" id="nestedAllocatedAsset" type="checkbox" />',
                'className': 'dt-body-center',
                'render': function (data, type, full, meta) {
                    if (full.HasDeleteRights) {
                        if (full.Selected) {
                            return '<input type="checkbox" name="id[' + full.AssetRequestId + ']" value="' + full.AssetRequestId + '" checked="' + full.AssetRequestId + '">';
                        }
                        else {
                            return '<input type="checkbox" name="id[' + full.AssetRequestId + ']" value="' + full.AssetRequestId + '">';
                        }
                    }
                    else
                        return '';

                }
            },
            //{
            //    'targets': 0,
            //    "sTitle": '<input name="select_all"  value="1" id="nestedAllocatedAsset" type="checkbox" />',
            //    'searchable': false,
            //    'width': '20',
            //    'orderable': false,
            //    'className': 'dt-body-center',
            //    'render': function (data, type, full, meta) {
            //          var  html = '<input type="checkbox"  name="UnCheckbox" value="' + full.AssetRequestId + '">';
            //        return html;
            //    }
            //},
            {
                "mData": null,
                "sTitle": "Asset",
                'bSortable': true,
                "sClass": "text-center",
                "sWidth": "140px",
                mRender: function (data, type, row) {
                    return data.AssetType + "(" + data.Brand + "_" + data.Model + ")";
                }
            },
            {
                "mData": "SerialNo",
                "sTitle": "S.No",
                "sClass": "text-center",
                "sWidth": "80px",
            },
            {
                "mData": "FromDate",
                "sTitle": "Allocated From",
                "sWidth": "80px",
                "sClass": "text-center",
            },
            {
                "mData": "Remarks",
                "sTitle": "Remarks",
                "sClass": "text-center",
                "sWidth": "80px",
            },
            {
                "mData": "AssignedOn",
                "sTitle": "Assigned On",
                "sWidth": "80px",
            },
            {
                "mData": "AssignedBy",
                "sTitle": "Assigned By",
            },
            {
                "mData": null,
                "sTitle": "Action",
                'bSortable': false,
                "sClass": "text-center",
                "sWidth": "140px",
                mRender: function (data, type, row) {
                    var html = "";
                    if (row.HasDeleteRights)
                        html = '<div><button type="button"  title="Mark asset lost"  class="btn btn-sm btn-warning"' + 'onclick="deAllocateLostAsset(' + row.AssetRequestId + ',\'' + row.EmployeeName + '\',\'' + row.FromDateText + '\')"><i class="fa fa-trash" aria-hidden="true"></i></button></div>';

                    return html;
                }
            },
        ], 'rowCallback': function (row, data, dataIndex) {
            var rowId = data.AssetRequestId;
            // If row ID is in the list of selected row IDs
            if ($.inArray(rowId, rows_selected) !== -1) {
                //$(row).find('input[type="checkbox"]').prop('checked', true);
                //$(row).addClass('selected');
            }
        }
    });
    tableNestedAllocatedAsset = $("#tblNestedAllocatedAsset").DataTable();
}

function formatPendingForCollection(data) {
    $("#tblNestedDeAllocatedAsset").dataTable({
        // "dom": 'lBfrtip',
        "buttons": [
            {
                filename: 'Asset Details For IT Department',
                extend: 'collection',
                text: 'Export',
                buttons: [{ extend: 'copy' },
                { extend: 'excel', filename: 'Asset Details For IT Department' },
                { extend: 'pdf', filename: 'Asset Details For IT Department' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                { extend: 'print', filename: 'Asset Details For IT Department' },
                ]
            }
        ],
        "responsive": true,
        "autoWidth": false,
        "paging": false,
        "bDestroy": true,
        "ordering": true,
        "order": [], // disable default sorting
        "info": false,
        "deferRender": true,
        "searching": false,
        "aaData": data,
        "aoColumns": [
            {
                'targets': 0,
                'searchable': false,
                'width': '1%',
                'orderable': false,
                'bSortable': false,
                "sTitle": '<input name="select_all" value="1" id="nestedDeAllocatedAsset" type="checkbox" />',
                'className': 'dt-body-center',
                'render': function (data, type, full, meta) {
                    if (full.HasCollectRights) {
                        if (full.Selected) {
                            return '<input type="checkbox" name="id[' + full.AssetRequestId + ']" value="' + full.AssetRequestId + '" checked="' + full.AssetRequestId + '">';
                        }
                        else {
                            return '<input type="checkbox" name="id[' + full.AssetRequestId + ']" value="' + full.AssetRequestId + '">';
                        }
                    }
                    else
                        return '';
                }
            },
            {
                "mData": null,
                "sTitle": "Asset",
                'bSortable': true,
                "sClass": "text-center",
                "sWidth": "140px",
                mRender: function (data, type, row) {
                    return data.AssetType + "(" + data.Brand + "_" + data.Model + ")";
                }
            },
            {
                "mData": "SerialNo",
                "sTitle": "S.No",
                "sClass": "text-center",
                "sWidth": "80px",
            },
            {
                "mData": "FromDate",
                "sTitle": "Allocated From",
                "sWidth": "80px",
                "sClass": "text-center",
            },
            {
                "mData": "TillDate",
                "sTitle": "Allocated Till",
                "sWidth": "80px",
                "sClass": "text-center",
            },
            {
                "mData": "Remarks",
                "sTitle": "Remarks",
                "sClass": "text-center",
                "sWidth": "80px",
            },
            {
                "mData": "AssignedOn",
                "sTitle": "Assigned On",
                "sWidth": "80px",
            },
            {
                "mData": "AssignedBy",
                "sTitle": "Assigned By",
            },
        ], 'rowCallback': function (row, data, dataIndex) {
            var rowId = data.AssetRequestId;
            // If row ID is in the list of selected row IDs
            if ($.inArray(rowId, rows_selected) !== -1) {
                //$(row).find('input[type="checkbox"]').prop('checked', true);
                //$(row).addClass('selected');
            }
        }
    });
    tableNestedDeAllocatedAsset = $("#tblNestedDeAllocatedAsset").DataTable();
}

function formatDeAllocatedAsset(data) {

    $("#tblNestedViewDeAllocatedAsset").dataTable({
        // "dom": 'lBfrtip',
        "buttons": [
            {
                filename: 'Asset Details For IT Department',
                extend: 'collection',
                text: 'Export',
                buttons: [{ extend: 'copy' },
                { extend: 'excel', filename: 'Asset Details For IT Department' },
                { extend: 'pdf', filename: 'Asset Details For IT Department' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                { extend: 'print', filename: 'Asset Details For IT Department' },
                ]
            }
        ],
        "responsive": true,
        "autoWidth": false,
        "paging": false,
        "bDestroy": true,
        "ordering": true,
        "order": [], // disable default sorting
        "info": false,
        "deferRender": true,
        "searching": false,
        "aaData": data,
        "aoColumns": [
            {
                "mData": null,
                "sTitle": "Asset",
                'bSortable': true,
                "sClass": "text-center",
                //"sWidth": "140px",
                mRender: function (data, type, row) {
                    return data.AssetType + "(" + data.Brand + "_" + data.Model + ")";
                }
            },
            {
                "mData": "SerialNo",
                "sTitle": "S.No",
                "sClass": "text-center",
                //"sWidth": "80px",
            },
            {
                "mData": "FromDate",
                "sTitle": "Allocated From",
                //"sWidth": "80px",
                "sClass": "text-center",
            },
            {
                "mData": "TillDate",
                "sTitle": "Allocated Till",
                //"sWidth": "80px",
                "sClass": "text-center",
            },
            {
                "mData": null,
                "sTitle": "Status",
                'bSortable': true,
                "sClass": "text-center",
                "sWidth": "80px",
                mRender: function (data, type, row) {
                    if (data.Status == "Lost")
                        var html = '<span class="label label-danger">' + data.Status + '</span>';
                    if (data.Status == "Collected")
                        var html = '<span class="label label-success">' + data.Status + '</span>';

                    return html;
                }
            },
            {
                "mData": "DeAllocationRemarks",
                "sTitle": "Remarks",
                "sClass": "text-center",
                //"sWidth": "80px",
            },
            {
                "mData": "AssignedOn",
                "sTitle": "Assigned On",
                "sClass": "text-center",
                //"sWidth": "80px",
            },
            {
                "mData": "AssignedBy",
                "sTitle": "Assigned By",
                "sClass": "text-center none",
            },
            //{
            //    "mData": "DeAllocationRemarks",
            //    "sTitle": "De Allocation Remarks",
            //    "sClass": "text-center none",
            //    //"sWidth": "80px",
            //},
            {
                "mData": "ModifiedOn",
                "sTitle": "De Allocated On",
                "sClass": "text-center none",
                //"sWidth": "80px",
            },
            {
                "mData": "ModifiedBy",
                "sTitle": "De Allocated By",
                "sClass": "text-center none",
            },
            {
                "mData": "CollectedOn",
                "sTitle": "Collected On",
                "sClass": "text-center none",
                //"sWidth": "80px",
            },
            {
                "mData": "CollectedBy",
                "sTitle": "Collected By",
                "sClass": "text-center none",
            },
        ]
    });
}

function bindUsersAllocatedAsset() {
    if ($.fn.DataTable.isDataTable('#tblAllocatedAsset')) {
        $('#tblAllocatedAsset').DataTable().destroy();
    }
    $('#tblAllocatedAsset tbody').empty();
    var jsonObject = {
        actionCode: "AA"
    };
    calltoAjax(misApiUrl.getAllUsersAssetsDetail, "POST", jsonObject,
        function (result) {
            var resultdata = $.parseJSON(JSON.stringify(result));
            $("#tblAllocatedAsset").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'Asset Details For IT Department',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'Asset Details For IT Department' },
                        { extend: 'pdf', filename: 'Asset Details For IT Department' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                        { extend: 'print', filename: 'Asset Details For IT Department' },
                        ]
                    }
                ],
                "responsive": true,
                "autoWidth": false,
                "paging": true,
                "bDestroy": true,
                "ordering": true,
                "order": [], // disable default sorting
                "info": true,
                "deferRender": true,
                "aaData": resultdata,
                "aoColumns": [
                    {
                        "className": 'details-control',
                        "orderable": false,
                        "mData": null,
                        "defaultContent": ''
                    },
                    {
                        "mData": null,
                        "sTitle": "Employee",
                        'bSortable': true,
                        "sClass": "text-center",
                        //"sWidth": "70px",
                        mRender: function (data, type, row) {
                            return '<img  style="width:70px; height:70px" src=' + data.ImagePath + " /> <br><span>" + data.EmployeeName + "</span>";
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Asset",
                        'bSortable': true,
                        "sClass": "text-center",
                        //"sWidth": "140px",
                        mRender: function (data, type, row) {
                            return data.AssetType + "(" + data.Brand + "_" + data.Model + ")";
                        }
                    },
                    {
                        "mData": "SerialNo",
                        "sTitle": "S.No",
                        "sClass": "text-center",
                        //"sWidth": "80px",
                    },
                    {
                        "mData": "AssetCount",
                        "sTitle": "Asset Count",
                        //"sWidth": "30px",
                        "sClass": "text-center",
                    },
                    {
                        "mData": "FromDate",
                        "sTitle": "Allocated From",
                        //"sWidth": "80px",
                        "sClass": "text-center",
                    },
                    //{
                    //    "mData": "Remarks",
                    //    "sTitle": "Remarks",
                    //    "sClass": "text-center",
                    //    //"sWidth": "80px",
                    //},

                ], "rowCallback": function (row, data) {
                    if (data.AssetCount == 0) {
                        $('td:eq(0)', row).removeClass("details-control");
                    } else {
                    }
                }, "order": [[1, 'asc']]
            });

            table = $('#tblAllocatedAsset').DataTable();

        });
}

$(document).on("click", '#tblAllocatedAsset tbody td.details-control', function (e) {

    // Add event listener for opening and closing details
    // $('#tblAllocatedAsset tbody').on('click', 'td.details-control', function (e) {
    var tr = $(this).closest('tr');
    var row = table.row(tr);
    if (row.child.isShown()) {
        row.child.hide();
        $("#tblAllocatedAsset tbody tr").removeClass('shown expand');

    }
    else {
        table.rows().eq(0).each(function (idx) {
            var row = table.row(idx);
            if (row.child.isShown()) {
                row.child.hide();
            }
        });
        var html = '<div class="row"><div class="col-md-12">' +
            '<table id="tblNestedAllocatedAsset" data-filter-control="true" data-toolbar="#toolbar" class="table table-hover"></table>' +
            '<div class="row"><div class="text-center">' +
            '<button type="button" class="btn btn-danger m-b-1" onclick="showModalPopupToDeAllocate()"><span class="fa fa-times">&nbsp De Allocate</button>' +
            '</div></div>' +
            '</div ></div > ';
        employeeName = row.data().EmployeeName;
        jsonObject = {
            userAbrhs: row.data().UserAbrhs,
            actionCode: "AA"
        }
        calltoAjax(misApiUrl.getAssetsByUserAbrhs, "POST", jsonObject,
            function (result) {
                var resultdata = $.parseJSON(JSON.stringify(result));
                row.child(html).show();
                format(resultdata);
                $("#tblAllocatedAsset tbody tr").removeClass('shown expand');
                tr.addClass('shown expand');

            });
    }

});

function bindPendingForDeallocation() {
    if ($.fn.DataTable.isDataTable('#tblPendingDeAllocatedAsset')) {
        $('#tblPendingDeAllocatedAsset').DataTable().destroy();
    }
    $('#tblPendingDeAllocatedAsset tbody').empty();
    var jsonObject = {
        actionCode: "DA"
    };
    calltoAjax(misApiUrl.getAllUsersAssetsDetail, "POST", jsonObject,
        function (result) {
            var resultdata = $.parseJSON(JSON.stringify(result));
            $("#tblPendingDeAllocatedAsset").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'Asset Details For IT Department',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'Asset Details For IT Department' },
                        { extend: 'pdf', filename: 'Asset Details For IT Department' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                        { extend: 'print', filename: 'Asset Details For IT Department' },
                        ]
                    }
                ],
                "responsive": true,
                "autoWidth": false,
                "paging": true,
                "bDestroy": true,
                "ordering": true,
                "order": [], // disable default sorting
                "info": true,
                "deferRender": true,
                "aaData": resultdata,
                "aoColumns": [

                    {
                        "className": 'details-control',
                        "orderable": false,
                        "mData": null,
                        "defaultContent": ''
                    },
                    {
                        "mData": null,
                        "sTitle": "Employee",
                        'bSortable': true,
                        "sClass": "text-center",
                        //"sWidth": "70px",
                        mRender: function (data, type, row) {
                            return '<img  style="width:70px; height:70px" src=' + data.ImagePath + " /> <br><span>" + data.EmployeeName + "</span>";
                        }
                    },

                    {
                        "mData": null,
                        "sTitle": "Asset",
                        'bSortable': true,
                        "sClass": "text-center",
                        //  "sWidth": "140px",
                        mRender: function (data, type, row) {
                            return data.AssetType + "(" + data.Brand + "_" + data.Model + ")";
                        }
                    },
                    {
                        "mData": "Status",
                        "sTitle": "S.No",
                        "sClass": "text-center",
                        // "sWidth": "80px",
                    },
                    {
                        "mData": "AssetCount",
                        "sTitle": "Asset Count",
                        "sClass": "text-center",
                        // "sWidth": "30px",
                    },
                    {
                        "mData": "FromDate",
                        "sTitle": "Allocated From",
                        "sClass": "text-center",
                        //  "sWidth": "80px",
                    },
                    {
                        "mData": "TillDate",
                        "sTitle": "Allocated Till",
                        "sClass": "text-center",
                        //  "sWidth": "80px",
                    },
                    {
                        "mData": "HasCollectRights",
                        "sTitle": "HasCollectRights"

                        //  "sWidth": "80px",
                    },
                    //{
                    //    "mData": "Remarks",
                    //    "sTitle": "Remarks",
                    //    "sClass": "text-center",
                    //    "sWidth": "80px",
                    //},
                ],
                "fnInitComplete": function (row) {
                    var tableNew = $('#tblPendingDeAllocatedAsset').DataTable();
                    tableNew.columns([7]).visible(false);
                    //}
                }
                , "rowCallback": function (row, data) {
                    if (data.AssetCount == 0) {
                        $('td:eq(0)', row).removeClass("details-control");
                    } else {
                    }
                }, "order": [[1, 'asc']]
            });

            table = $('#tblPendingDeAllocatedAsset').DataTable();
        });

    // Add event listener for opening and closing details
}

$(document).on("click", '#tblPendingDeAllocatedAsset tbody td.details-control', function (e) {
    // Add event listener for opening and closing details

    var tr = $(this).closest('tr');
    var row = table.row(tr);
    if (row.child.isShown()) {
        row.child.hide();
        $("#tblPendingDeAllocatedAsset tbody tr").removeClass('shown expand');
    }
    else {
        table.rows().eq(0).each(function (idx) {
            var row = table.row(idx);
            if (row.child.isShown()) {
                row.child.hide();
            }
        });

        employeeName = row.data().EmployeeName;
        var hasCollectRight = row.data().HasCollectRights;

        var html = '<div class="row"><div class="col-md-12">' +
            '<table id="tblNestedDeAllocatedAsset" data-filter-control="true" data-toolbar="#toolbar" class="table table-hover"></table>';

        if (hasCollectRight) {
            html += '<div class="row"><div class="text-center">' +
                '<button type="button" class="btn btn-success m-b-1" onclick="markAssetsCollected()"><span class="fa fa-check">&nbspMark Collected</button>' +
                '</div></div>';
        }
        html += '</div ></div > ';

        jsonObject = {
            userAbrhs: row.data().UserAbrhs,
            actionCode: "DA"
        }
        calltoAjax(misApiUrl.getAssetsByUserAbrhs, "POST", jsonObject,
            function (result) {
                var resultdata = $.parseJSON(JSON.stringify(result));
                row.child(html).show();
                formatPendingForCollection(resultdata)
                $("#tblPendingDeAllocatedAsset tbody tr").removeClass('shown expand');
                tr.addClass('shown expand');
            });
    }

});

function bindUsersDeAllocatedAsset() {
    if ($.fn.DataTable.isDataTable('#tblAllocatedAssetHistory')) {
        $('#tblAllocatedAssetHistory').DataTable().destroy();
    }
    $('#tblAllocatedAssetHistory tbody').empty();

    var jsonObject = {
        actionCode: "GG"
    };
    calltoAjax(misApiUrl.getAllUsersAssetsDetail, "POST", jsonObject,
        function (result) {
            var resultdata = $.parseJSON(JSON.stringify(result));
            $("#tblAllocatedAssetHistory").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'Asset Details For IT Department',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'Asset Details For IT Department' },
                        { extend: 'pdf', filename: 'Asset Details For IT Department' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                        { extend: 'print', filename: 'Asset Details For IT Department' },
                        ]
                    }
                ],
                "responsive": true,
                "autoWidth": false,
                "paging": true,
                "bDestroy": true,
                "ordering": true,
                "order": [], // disable default sorting
                "info": true,
                "deferRender": true,
                "aaData": resultdata,
                "aoColumns": [
                    {
                        "className": 'details-control',
                        "orderable": false,
                        "mData": null,
                        "defaultContent": ''
                    },
                    {
                        "mData": null,
                        "sTitle": "Employee",
                        'bSortable': true,
                        "sClass": "text-center",
                        //"sWidth": "70px",
                        mRender: function (data, type, row) {
                            return '<img  style="width:70px; height:70px" src=' + data.ImagePath + " /> <br><span>" + data.EmployeeName + "</span>";
                        }
                    },

                    {
                        "mData": null,
                        "sTitle": "Asset",
                        'bSortable': true,
                        "sClass": "text-center",
                        // "sWidth": "140px",
                        mRender: function (data, type, row) {
                            return data.AssetType + "(" + data.Brand + "_" + data.Model + ")";
                        }
                    },
                    //{
                    //    "mData": null,
                    //    "sTitle": "Status",
                    //    'bSortable': true,
                    //    "sClass": "text-center",
                    //  //  "sWidth": "80px",
                    //    mRender: function (data, type, row) {
                    //        if (data.Status == "Lost")
                    //            var html = '<span class="label label-danger">' + data.Status + '</span>';
                    //        if (data.Status == "Collected")
                    //            var html = '<span class="label label-success">' + data.Status + '</span>';

                    //        return html;
                    //    }
                    //},

                    {
                        "mData": "AssetCount",
                        "sTitle": "Asset Count",
                        "sClass": "text-center",
                        // "sWidth": "30px",
                    },
                    {
                        "mData": "FromDate",
                        "sTitle": "Allocated From",
                        "sClass": "text-center",
                        //   "sWidth": "80px",
                    },
                    {
                        "mData": "TillDate",
                        "sTitle": "Allocated Till",
                        "sClass": "text-center",
                        //  "sWidth": "80px",
                    },
                    //{
                    //    "mData": "Remarks",
                    //    "sTitle": "Remarks",
                    //    "sClass": "text-center",
                    //    "sWidth": "80px",
                    //},

                ], "rowCallback": function (row, data) {
                    if (data.AssetCount == 0) {
                        $('td:eq(0)', row).removeClass("details-control");
                    } else {
                    }
                }, "order": [[1, 'asc']]
            });

            table = $('#tblAllocatedAssetHistory').DataTable();
        });
}

$(document).on("click", '#tblAllocatedAssetHistory tbody td.details-control', function (e) {

    // Add event listener for opening and closing details
    var tr = $(this).closest('tr');
    var row = table.row(tr);
    if (row.child.isShown()) {
        row.child.hide();
        $("#tblAllocatedAssetHistory tbody tr").removeClass('shown expand');
    }
    else {

        var html = '<div class="row"><div class="col-md-12">' +
            '<table id="tblNestedViewDeAllocatedAsset" data-filter-control="true" data-toolbar="#toolbar" class="table table-hover"></table>' +

            '</div ></div > ';

        table.rows().eq(0).each(function (idx) {
            var row = table.row(idx);
            if (row.child.isShown()) {
                row.child.hide();
            }
        });
        jsonObject = {
            userAbrhs: row.data().UserAbrhs,
            actionCode: "GG"
        }
        calltoAjax(misApiUrl.getAssetsByUserAbrhs, "POST", jsonObject,
            function (result) {
                var resultdata = $.parseJSON(JSON.stringify(result));
                row.child(html).show();
                formatDeAllocatedAsset(resultdata);
                $("#tblAllocatedAssetHistory tbody tr").removeClass('shown expand');
                tr.addClass('shown expand');
            });
    }
});

function editAssetRequests(assetRequestId, assetTypeId, assetId, userAbrhs, fromDate, remarks) {
    $("#modalPopUpAllocateAsset").modal("show");
    $("#modalPopUpAllocateAssetTitle").text("Update Users Asset Detail");
    $("#hdnAssetRequestId").val(assetRequestId);
    $("#hdnAssetId").val(assetId);
    $("#hdnAssetTypeId").val(assetTypeId);
    $("#btnAllocateAsset").hide();
    $("#btnUpdateAllocatedAsset").show();
    $("#txtRemarks").val(remarks);

    $('#allocateFrom').datepicker({
        autoclose: true,
        todayHighlight: true,
        format: "mm/dd/yyyy"
    }).datepicker('setStartDate', fromDate)
    $('#allocateFrom').datepicker({
    }).datepicker("setDate", fromDate);

    bindEmployeeList(userAbrhs);
    bindAssetTypeDropdown(assetTypeId, assetId);
    $("#ddlEmployees").attr("disabled", true);
}

$("#btnAllocateAsset").click(function () {
    addUpdateUsersAssetsDetail("AS");
});

$("#btnUpdateAllocatedAsset").click(function () {
    addUpdateUsersAssetsDetail("EA");
});

function addUpdateUsersAssetsDetail(actionCode) {
    if (!validateControls('modalPopUpAllocateAsset')) {
        return false;
    }
    var assetIds;

    if ($("#ddlAssets").val() === null) {
        misAlert("Please select asset.", "Warning", "warning");
        return false;
    }
    else {
        assetIds = $("#ddlAssets").val().join(',');

        var jsonObject = {
            AssetRequestIds: "",
            UserAbrhs: $("#ddlEmployees").val(),
            AssetIds: assetIds,
            FromDate: $("#allocateFrom input").val(),
            Remarks: $("#txtRemarks").val(),
            ActionCode: actionCode,
            IsActive: true
        };
        calltoAjax(misApiUrl.addUpdateUsersAssetsDetail, "POST", jsonObject,
            function (result) {
                if (result == 1) {
                    misAlert("Request processed successfully", "Success", "success");
                    bindUsersAllocatedAsset();
                    $("#modalPopUpAllocateAsset").modal("hide");
                }
                else if (result == 2) {
                    misAlert("Asset aasigned already", "Warning", "warning");
                }
                else
                    misAlert("Unable to process request. Try again", "Error", "error");
            });

    }
}

$("#btnClose").click(function () {
    $("#modalPopUpAllocateAsset").modal('hide');
});

//function deAllocateAsset(assetRequestId, employeeName, fromDate) {
//    $("#modalPopUpDeAllocate").modal('show');
//    $("#txtEmpName").val(employeeName);
//    $("#hdnAssetRequestId").val(assetRequestId);
//    $('#allocateTill').datepicker({
//        autoclose: true,
//        todayHighlight: true,
//        format: "mm/dd/yyyy"
//    }).datepicker('setDate', new Date());

//    $("#allocateTill input").attr("disabled", true);
//}

function deAllocateLostAsset(assetRequestId, employeeName, fromDate) {
    $("#modalPopUpDeAllocateLostAsset").modal('show');
    $("#txtReason").val("");
    $("#txtReason").removeClass("error-validation");
    $("#txtEmpNameForLostAsset").val(employeeName);
    $("#hdnLostAssetRequestId").val(assetRequestId);
    $('#allocateTillForLostAsset').datepicker({
        autoclose: true,
        todayHighlight: true,
        format: "mm/dd/yyyy"
    }).datepicker('setDate', new Date());

    $("#allocateTillForLostAsset input").attr("disabled", true);
}

$("#btnDeAllocate").click(function () {
    if (!validateControls('modalPopUpDeAllocate'))
        return false;

    var reply = misConfirm("<span style='color:red;'>Are you sure you want to de-allocate this asset?</span>", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                AssetRequestIds: _selectedAssetRequestIds,
                TillDate: $('#allocateTill input').val(),
                IsActive: false,
                ActionCode: 'DA',
            };
            calltoAjax(misApiUrl.addUpdateUsersAssetsDetail, "POST", jsonObject,
                function (result) {
                    if (result == 1) {
                        misAlert("Request processed successfully", "Success", "success");
                        $("#modalPopUpDeAllocate").modal('hide');
                        bindUsersAllocatedAsset();
                    }
                    else
                        misAlert("Unable to process request. Try again", "Error", "error");
                });
        }
    }, true, true, true);
});

$("#btnDeAllocateLostAsset").click(function () {
    if (!validateControls('modalPopUpDeAllocateLostAsset'))
        return false;
    var reply = misConfirm("<span style='color:red;'>Are you sure you want to mark this asset lost?</span>", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                AssetRequestIds: $("#hdnLostAssetRequestId").val(),
                TillDate: $('#allocateTillForLostAsset input').val(),
                Remarks: $('#txtReason').val(),
                ActionCode: 'AL',
                IsActive: false
            };
            calltoAjax(misApiUrl.addUpdateUsersAssetsDetail, "POST", jsonObject,
                function (result) {
                    if (result == 1) {
                        misAlert("Request processed successfully", "Success", "success");
                        $("#modalPopUpDeAllocateLostAsset").modal('hide');
                        bindUsersAllocatedAsset();
                    }
                    else
                        misAlert("Unable to process request. Try again", "Error", "error");
                });
        }
    }, true, true, true);
});

$("#btnMarkCollected").click(function () {
    var reply = misConfirm("<span style='color:red;'>Are you sure you want to mark it as collected?</span>", "Confirm", function (reply) {
        if (reply) {
            var jsonObject = {
                AssetRequestIds: _selectedAssetRequestIds,
                ActionCode: 'AC',
            };
            calltoAjax(misApiUrl.addUpdateUsersAssetsDetail, "POST", jsonObject,
                function (result) {
                    if (result == 1) {
                        $("#modalPopUpCollectAssets").modal("hide");
                        misAlert("Request processed successfully", "Success", "success");
                        bindPendingForDeallocation();
                    }
                    else
                        misAlert("Unable to process request. Try again", "Error", "error");
                });
        }
    }, true, true, true);
});

// Bulk de allocate Section 
var _selectedAssetRequestIds = "";
function showModalPopupToDeAllocate() {
    var selectedAssetRequestIds = [];
    var selectedAssets = [];

    $("#tblNestedAllocatedAsset").DataTable().$('input[type="checkbox"]').each(function () {
        if (this.checked) {
            selectedAssetRequestIds.push($(this).val());
            selectedAssets.push(this.parentNode.nextElementSibling.firstChild.nodeValue.trim());
        }
    });
    selectedAssets = jQuery.unique(selectedAssets);
    var Names = selectedAssets.join();
    _selectedAssetRequestIds = selectedAssetRequestIds.join();
    $("#txtEmpName").val(employeeName);
    $("#assetNames").html(Names);
    if (selectedAssets.length > 0) {
        $("#modalPopUpDeAllocate").modal("show");
        $('#allocateTill').datepicker({
            autoclose: true,
            todayHighlight: true,
            format: "mm/dd/yyyy"
        }).datepicker('setDate', new Date());

        $("#allocateTill input").attr("disabled", true);
    }
    else {
        misAlert("Please select asset.", "Warning", "warning");
    }
}

function markAssetsCollected() {
    var selectedAssetRequestIds = [];
    var selectedAssets = [];
    $("#tblNestedDeAllocatedAsset").DataTable().$('input[type="checkbox"]').each(function () {
        if (this.checked) {
            selectedAssetRequestIds.push($(this).val());
            selectedAssets.push(this.parentNode.nextElementSibling.firstChild.nodeValue.trim());
        }
    });
    selectedAssets = jQuery.unique(selectedAssets);
    var Names = selectedAssets.join();
    _selectedAssetRequestIds = selectedAssetRequestIds.join();
    $("#assetNamesForCollection").html(Names);
    $("#txtEmpNameForCollection").val(employeeName);
    if (selectedAssets.length > 0) {
        $("#modalPopUpCollectAssets").modal("show");
    }
    else {
        misAlert("Please select asset.", "Warning", "warning");
    }
}

