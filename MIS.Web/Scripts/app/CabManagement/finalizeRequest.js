var tableNestedFinalizeCabRequest = "";
var rows_selected = [];
var Employee_selected = [];
var _selectedCabRequestIds = "";
var _statusOnBulkApprove = "";
var table = "";
var tableFinalized = "";

$(document).ready(function () {
    $("#txtDate").datepicker({ autoclose: true, todayHighlight: true }).datepicker("setDate", new Date());
    //getCompanyLocation();
    //getCabServiceType();
    getDateForFilter();
    table = "";
 
    $("#divDllDate").show();
    $("#DivDateText").hide();

    $('#ddlDateSelect').change(function () {
        bindCabShift();
    });

    $("#txtDate input").change(function () {
        bindCabShift();
    });

    $("#btnChangeTo").click(function () {
        var className = $("#dateSelectType").attr('class');
        if (className === "fa fa-calendar") {
            $("#dateSelectType").removeClass('fa fa-calendar');
            $("#dateSelectType").addClass('fa fa-list');
            $("#divDllDate").hide();
            $("#DivDateText").show();
        }
        else {
            $("#dateSelectType").removeClass('fa fa-list');
            $("#dateSelectType").addClass('fa fa-calendar');
            $("#divDllDate").show();
            $("#DivDateText").hide();
        }
        getDateForFilter();
        bindCabShift();
    });

    $("#ddlServiceType").change(function () {
        bindCabRoutes();
        bindCabShift();
    });

    $("#ddlCompanyLocation").change(function () {
        bindCabRoutes();
    });

    $("#btnSearchCabRequest").click(function () {
        if (!validateControls('tabPendingAndApprovedCabRequest'))
            return false;

        getCabRequestToFinalize();
    });

    $("#ddlDriver").change(function () {
        var jsonObject = {
            StaffId: $("#ddlDriver").val()
        };
        calltoAjax(misApiUrl.getDriverContactNo, "POST", jsonObject,
            function (result) {
                $("#driverContactNo").val(result);
            });
    });

    $("#finalizeBulkCabRequest").click(function () {
        bulkFinalizeCabRequests(_selectedCabRequestIds, _statusOnBulkApprove);
    });

    $("#btnCloseBulk").click(function () {
        $("#mypopupBulkFinalize").modal("hide");
    });

    $("#btnRejectCabRequest").click(function () {
        if (!validateControls("mypopupReviewCabrequestRemark")) {
            return false;
        }
        takeActionOnCabRequest($("#hdnCabRequestId").val(), "RJ");
    });

    $("#btnApproveCabRequest").click(function () {
        if (!validateControls("mypopupReviewCabrequestRemark")) {
            return false;
        }
        takeActionOnCabRequest($("#hdnCabRequestId").val(), "AP");
    });

    $('a[href="#tabPendingAndApprovedCabRequest"]').on('click', function () {
        if ($.fn.DataTable.isDataTable('#tblFinalizeCabRequest')) {
            $('#tblFinalizeCabRequest').DataTable().destroy();
        }
        $('#tblFinalizeCabRequest').empty();

        $("#txtDate").datepicker({ autoclose: true, todayHighlight: true }).datepicker("setDate", new Date());
        table = ""
        $("#dateSelectType").removeClass('fa fa-list');
        $("#dateSelectType").removeClass('fa fa-calendar');
        $("#dateSelectType").addClass('fa fa-calendar');
        $("#divDllDate").show();
        $("#DivDateText").hide();

        getCompanyLocation();
        getCabServiceType();
        getDateForFilter();
    });

    $('a[href="#tabFinalized"]').on('click', function () {
        if ($.fn.DataTable.isDataTable('#tblFinalizedRequest')) {
            $('#tblFinalizedRequest').DataTable().destroy();
        }
        $('#tblFinalizedRequest').empty();

        $("#txtDateForFinalized").datepicker({ autoclose: true, todayHighlight: true }).datepicker("setDate", new Date());
        tableFinalized = ""
        $("#dateSelectTypeForFinalized").removeClass('fa fa-list');
        $("#dateSelectTypeForFinalized").removeClass('fa fa-calendar');
        $("#dateSelectTypeForFinalized").addClass('fa fa-calendar');

        $("#divDllDateForFinalized").show();
        $("#DivDateTextForFinalized").hide();
        getDateForFilterForFinalized();
    });

    //Finalized

    $('#ddlDateSelectForFinalized').change(function () {
        bindCabShiftForFinalized();
    });

    $("#txtDateForFinalized input").change(function () {
        bindCabShiftForFinalized();
    });

    $("#btnChangeToForFinalized").click(function () {
        var className = $("#dateSelectTypeForFinalized").attr('class');
        if (className === "fa fa-calendar") {
            $("#dateSelectTypeForFinalized").removeClass('fa fa-calendar');
            $("#dateSelectTypeForFinalized").addClass('fa fa-list');
            $("#divDllDateForFinalized").hide();
            $("#DivDateTextForFinalized").show();
        }
        else {
            $("#dateSelectTypeForFinalized").removeClass('fa fa-list');
            $("#dateSelectTypeForFinalized").addClass('fa fa-calendar');
            $("#divDllDateForFinalized").show();
            $("#DivDateTextForFinalized").hide();
        }
        getDateForFilterForFinalized();
        bindCabShiftForFinalized();
    });

    $("#ddlServiceTypeForFinalized").change(function () {
        bindCabShiftForFinalized();
    });

    $("#ddlCompanyLocationForFinalized").change(function () {
        bindCabRoutesForFinalized();
    });

    $("#btnSearchFinalizedCabRequest").click(function () {
        if (!validateControls('tabFinalized'))
            return false;

        getFinalizedCabRequest();
    });

});

function getCabRequestToFinalize() {
    var dates = "";

    var className = $("#dateSelectType").attr('class');

    if (className === "fa fa-calendar") {
        if ($('#ddlDateSelect').val() !== null) {
            dates = $('#ddlDateSelect').val().join(',');
        }
    }
    else {
        dates = $("#txtDate input").val();
    }

    var companyLocationIds = "";
    if ($("#ddlCompanyLocation").val() !== null) {
        companyLocationIds = $("#ddlCompanyLocation").val().join(',');
    }

    var serviceTypeIds = "";
    if ($("#ddlServiceType").val() !== null) {
        serviceTypeIds = $("#ddlServiceType").val().join(',');
    }

    var shiftIds = "";
    if ($("#ddlShift").val() !== null) {
        shiftIds = $("#ddlShift").val().join(',');
    }

    var cabRouteIds = "";
    if ($("#ddlCabRoute").val() !== null) {
        cabRouteIds = $("#ddlCabRoute").val().join(',');
    }

    var data = {
        Dates: dates,
        CompanyLocationIds: companyLocationIds,
        ServiceTypeIds: serviceTypeIds,
        ShiftIds: shiftIds,
        CabRouteIds: cabRouteIds
    };

    calltoAjax(misApiUrl.getGroupedCabRequestToFinalize, "POST", data, function (result) {
        var data = $.parseJSON(JSON.stringify(result)); 
        $("#tblFinalizeCabRequest").dataTable({
            "dom": 'lBfrtip',
            "buttons": [
                {
                    filename: 'OR List',
                    extend: 'collection',
                    text: 'Export',
                    buttons: [{ extend: 'copy', },
                    { extend: 'excel', filename: 'OR List' },
                    { extend: 'pdf', filename: 'OR List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                    { extend: 'print', filename: 'OR List' },
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
            "aaData": data,
            "aoColumns": [
               
                {
                    "className": 'details-control',
                    "orderable": false,
                    "mData": null,
                    "defaultContent": '',
                    "sWidth": "10px"
                },
                {
                    "mData": "CabRouteId",
                    "sTitle": "CabRouteId",
                },
                {
                    "mData": "ShiftId",
                    "sTitle": "ShiftId",
                },
                {
                    "mData": "CompanyLocationId",
                    "sTitle": "CompanyLocationId",
                },
                {
                    "mData": "Date",
                    "sTitle": "Date",
                },
                {
                    "mData": "DateText",
                    "sTitle": "Date",
                    "sWidth": "80px"
                },
                {
                    "mData": "CompanyLocation",
                    "sTitle": "Company Location",
                    "sWidth": "80px"
                },
                {
                    "mData": "ServiceType",
                    "sTitle": "Service",
                    "sWidth": "80px"
                },
                {
                    "mData": "ShiftName",
                    "sTitle": "Time",
                    "sWidth": "80px"
                },
                {
                    "mData": "RequestCount",
                    "sTitle": "Count",
                    "sWidth": "80px"
                },
            ],
            "fnInitComplete": function (row) {
               var tableNew = $('#tblFinalizeCabRequest').DataTable();
                tableNew.columns([1, 2, 3, 4]).visible(false);
                //}
            }
        });

        table = $('#tblFinalizeCabRequest').DataTable();
    });
}

$(document).on("click", '#tblFinalizeCabRequest tbody td.details-control', function (e) {

    // Add event listener for opening and closing details
    // $('#tblAllocatedAsset tbody').on('click', 'td.details-control', function (e) {
    var tr = $(this).closest('tr');
    var row = table.row(tr);
    if (row.child.isShown()) {
        row.child.hide();
        $("#tblFinalizeCabRequest tbody tr").removeClass('shown expand');

    }
    else {
        table.rows().eq(0).each(function (idx) {
            var row = table.row(idx);
            if (row.child.isShown()) {
                row.child.hide();
            }
        });
        var html = '<div class="row m-t-1 m-b-1"><div class="col-md-12">' +
            '<table id="tblNestedFinalizeCabRequest" data-filter-control="true" data-toolbar="#toolbar" class="table table-hover"></table>' +
            '<div class="row"><div class="text-center">' +
             "<button type='button' class='btn btn-primary' onclick=\"showPopupOnFinalizeBulkCabRequest('FD')\" > <i class='fa fa-check'></i>&nbsp;Finalize</button>" +
            '</div></div>' +
            '</div ></div > ';

        var shiftId = row.data().ShiftId;
        var routeId = row.data().CabRouteId;
        var date = row.data().Date;
        var locationId = row.data().CompanyLocationId;

        var dateText = row.data().DateText;
        var shift = row.data().ShiftName;
        var compnyloc = row.data().CompanyLocation;
        var serviceType = row.data().ServiceType;


       var jsonObject = {
            Date : date,
           CompanyLocationId: locationId,
           ShiftId: shiftId,
           CabRouteId: routeId
        };
        calltoAjax(misApiUrl.getCabRequestToFinalize, "POST", jsonObject,
            function (result) {
                var resultdata = $.parseJSON(JSON.stringify(result));
                row.child(html).show();
                format(resultdata, dateText, shift, serviceType, compnyloc);
                $("#tblFinalizeCabRequest tbody tr").removeClass('shown expand');
                tr.addClass('shown expand');

            });
    }

});

function format(data, dateText, shift, serviceType, compnyloc) {
    var title = "Report_" + dateText + "_" + serviceType + "@" + shift + "_for_" + compnyloc;
    $("#tblNestedFinalizeCabRequest").dataTable({
        //dom: 'Bfrtip',
        //"buttons": [
        //    {
        //        filename: 'CabRequestData',
        //        extend: 'collection',
        //        text: 'Export',
        //        buttons: [
        //            {
        //                extend: 'copy',
        //                exportOptions: {
        //                    columns: ':visible'
        //                },
        //                title: title
        //            },
        //            {
        //                extend: 'print',
        //                exportOptions: {
        //                    // columns: [0, 1, 2, 5]
        //                    columns: ':visible'
        //                },
        //                title: title
        //            },
        //            {
        //                extend: 'excel',
        //                exportOptions: {
        //                    columns: ':visible'
        //                },
        //                title: title
        //            },
        //            {
        //                extend: 'pdf',
        //                exportOptions: {
        //                    // columns: [0, 1, 2, 5]
        //                    columns: ':visible'
        //                },
        //                title: title
        //            }
        //        ],
        //    },

        //    'colvis'
        //],
        "responsive": true,
        "autoWidth": false,
        "paging": false,
        "bDestroy": true,
        "ordering": true,
        "order": [],
        "info": false,
        "deferRender": true,
        "aaData": data,
        "searching": false,
        "aoColumns": [
            {
                'targets': 0,
                'searchable': false,
                'width': '1%',
                'orderable': false,
                'bSortable': false,
                "sTitle": '<input name="select_all" value="1" id="finalizeCabRequest" type="checkbox" />',
                'className': 'dt-body-center',
                'render': function (data, type, full, meta) {
                    if (full.Selected && full.StatusCode === "PF") {
                        return '<input type="checkbox" name="id[' + full.CabRequestId + ']" value="' + full.CabRequestId + '" checked="' + full.CabRequestId + '">';
                    }
                    else if (!full.Selected && full.StatusCode === "PF") {
                        return '<input type="checkbox" name="id[' + full.CabRequestId + ']" value="' + full.CabRequestId + '">';
                    }
                    else {
                        return '';
                    }
                }
            },
            {
                "mData": "EmployeeName",
                "sTitle": "Employee Name",
                "sWidth": "100px"
            },
            {
                "mData": "EmpContactNo",
                "sTitle": "Mobile No",
                "sWidth": "100px"
            },
            //{
            //    "mData": "DateText",
            //    "sTitle": "Date",
            //    "sWidth": "80px",
            //    "className": "none",
              
            //},
            //{
            //    "mData": "ServiceType",
            //    "sTitle": "Service Type",
            //    "sWidth": "80px",
            //    "className": "none",
            //},
            //{
            //    "mData": "ShiftName",
            //    "sTitle": "Time",
            //    "sWidth": "80px",
            //    "className": "none",
            //},
            {
                "mData": "ReportingManager",
                "sTitle": "Reporting Manager",
                "sWidth": "100px"
            },
            {
                "mData": "LocationName",
                "sTitle": "Location",
                "sWidth": "80px"
            },

            {
                "mData": null,
                "sTitle": "Status",
                "sWidth": "100px",
                "className": "all",
                mRender: function (data, type, row) {
                    var html = '<a onclick="showCabRemarksPopup(' + data.CabRequestId + ')">' + data.Status + '</a>';
                    return html;
                }
            },
            {
                "mData": "CreatedDate",
                "sTitle": "Requested On",
                "sWidth": "90px"
            },
            {
                "mData": null,
                "sTitle": "Action",
                "sWidth": "80px",
                mRender: function (data, type, row) {
                    var html = "";
                    if (row.StatusCode == "PA") {
                        html += '<button type="button" class="btn btn-sm btn-success" ' + 'onclick="approveCabRequest(' + row.CabRequestId + ')" data-toggle="tooltip" title="Approve"><i class="fa fa-check"> </i></button>&nbsp;'
                    }
                    if (row.StatusCode == "PF" || row.StatusCode == "PA") {
                        html += '<button type="button" class="btn btn-sm btn-danger" ' + 'onclick="rejectCabRequest(' + row.CabRequestId + ')" data-toggle="tooltip" title="Reject"><i class="fa fa-times"> </i></button>';
                    }
                    return html;
                }
            },
        ],
        "fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
            if (aData.StatusCode === "RJ") {
                $('td', nRow).css('background-color', '#f3a0a0');
            }
            else if (aData.StatusCode === "AP") {
                $('td', nRow).css('background-color', '#99ff99');
            }
        }
    });
    tableNestedFinalizeCabRequest = $("#tblNestedFinalizeCabRequest").DataTable();
}

function getDateForFilter() {
    $('#ddlDateSelect').multiselect("destroy");
    $('#ddlDateSelect').empty();
    var jsonObject = {
        ServiceTypeId: 1, 
        ForScreen: "ADMIN"
    };
    calltoAjax(misApiUrl.getDatesForPickAndDrop, "POST", jsonObject,
        function (result) {
            if (result.length > 0) {
                $('#ddlDateSelect').multiselect("destroy");
                $('#ddlDateSelect').empty();
                $.each(result, function (index, item) {
                    $('<option selected>').val(item.Date).text(item.DateText).appendTo('#ddlDateSelect');
                });
                getCompanyLocation();
            }
            $('#ddlDateSelect').multiselect({
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                buttonWidth: false,
                onDropdownHidden: function (event) {
                }
            });
        });


}

function getCompanyLocation() {
    $('#ddlCompanyLocation').multiselect("destroy");
    $('#ddlCompanyLocation').empty();

    calltoAjax(misApiUrl.getCompanyLocation, "POST", '',
        function (result) {
            if (result.length > 0) {
                $('#ddlCompanyLocation').multiselect("destroy");
                $('#ddlCompanyLocation').empty();
                $.each(result, function (index, item) {
                    if (parseInt(misSession.companylocationid) === item.Value) {
                        $('<option Selected>').val(item.Value).text(item.Text).appendTo('#ddlCompanyLocation');
                    }
                    else {
                        $('<option>').val(item.Value).text(item.Text).appendTo('#ddlCompanyLocation');
                    }
                });

                getCabServiceType();
            }
            $('#ddlCompanyLocation').multiselect({
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                buttonWidth: false,
                onDropdownHidden: function (event) {
                }
            });
        });
}

function getCabServiceType() {
    $("#ddlServiceType").multiselect("destroy");
    $("#ddlServiceType").empty();
    calltoAjax(misApiUrl.getCabServiceType, "POST", '',
        function (result) {
            if (result.length > 0) {
                $('#ddlServiceType').multiselect("destroy");
                $('#ddlServiceType').empty();

                $.each(result, function (index, item) {
                    $('<option selected>').val(item.ServiceTypeId).text(item.ServiceType).appendTo('#ddlServiceType');
                });
                bindCabShift()
            }
            $("#ddlServiceType").multiselect({
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                buttonWidth: false,
                onDropdownHidden: function (event) {
                }
            });
        });
}

function bindCabShift() {
    $("#ddlShift").multiselect("destroy");
    $("#ddlShift").empty();

    var dates = "";

    var className = $("#dateSelectType").attr('class');

    if (className === "fa fa-calendar") {
        if ($('#ddlDateSelect').val() !== null) {
            dates = $('#ddlDateSelect').val().join(',');
        }
    }
    else {
        dates = $("#txtDate input").val();
    }

    var serviceTypeIds = "";
    if ($("#ddlServiceType").val() !== null) {
        serviceTypeIds = $("#ddlServiceType").val().join(',');
    }

        var jsonObject = {
            ServiceTypeIds: serviceTypeIds,
            Dates: dates,
            ForScreen: "ADMIN"
        };
        calltoAjax(misApiUrl.getShiftDetails, "POST", jsonObject,
            function (result) {
                if (result.length > 0) {
                    $('#ddlShift').multiselect("destroy");
                    $('#ddlShift').empty();

                    $.each(result, function (index, item) {
                        $('<option selected>').val(item.NewShiftId).text(item.ShiftName).appendTo('#ddlShift');
                    });
                    bindCabRoutes();
                }
                $("#ddlShift").multiselect({
                    includeSelectAllOption: true,
                    enableFiltering: true,
                    enableCaseInsensitiveFiltering: true,
                    buttonWidth: false,
                    onDropdownHidden: function (event) {
                    }
                });
            });
}

function bindCabRoutes() {
    $("#ddlCabRoute").multiselect("destroy");
    $("#ddlCabRoute").empty();
   
    var companyLocationIds = "";
    if ($("#ddlCompanyLocation").val() !== null) {
        companyLocationIds = $("#ddlCompanyLocation").val().join(',');
    }

    var serviceTypeIds = "";
    if ($("#ddlServiceType").val() !== null) {
        serviceTypeIds = $("#ddlServiceType").val().join(',');
    }

    var jsonObject = {
        CompanyLocationIds: companyLocationIds,
        ServiceTypeIds: serviceTypeIds
    };

    calltoAjax(misApiUrl.getCabRoutes, "POST", jsonObject,
        function (result) {
            if (result.length > 0) {
                $("#ddlCabRoute").multiselect("destroy");
                $("#ddlCabRoute").empty();
             
                $.each(result, function (index, item) {
                    $('<option selected>').val(item.NewCabRouteId).text(item.CabRoute).appendTo('#ddlCabRoute');
                });
            }
            getCabRequestToFinalize();
            $("#ddlCabRoute").multiselect({
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                buttonWidth: false,
                onDropdownHidden: function (event) {
                }
            });
        });
}

// Handle click on checkbox
$('body').on('click', '#tblNestedFinalizeCabRequest tbody input[type="checkbox"]', function (e) {
    var $row = $(this).closest('tr');
    // Get row data
    var data = tableNestedFinalizeCabRequest.row($row).data();
    // Get row ID
    var rowId = data[0];
    // Determine whether row ID is in the list of selected row IDs
    var index = $.inArray(rowId, rows_selected);
    // If checkbox is checked and row ID is not in list of selected row IDs
    if (this.checked && index === -1) {
        rows_selected.push(rowId);
        // Otherwise, if checkbox is not checked and row ID is in list of selected row IDs
    } else if (!this.checked && index !== -1) {
        rows_selected.splice(index, 1);
    }
    // Update state of "Select all" control
    updateDataTableSelectAllCtrlUn(tableNestedFinalizeCabRequest);
    // Prevent click event from propagating to parent
    e.stopPropagation();
});

// Handle table draw event
if (tableNestedFinalizeCabRequest) {
    tableNestedFinalizeCabRequest.on('draw', function () {
        // Update state of "Select all" control
        updateDataTableSelectAllCtrlUn(tableNestedFinalizeCabRequest);
    });
}

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

// Handle click on "Select all " control
$('body').on('click', '#finalizeCabRequest', function (e) {
    if (this.checked) {
        $('input[type="checkbox"]', '#tblNestedFinalizeCabRequest').prop('checked', true);
        var count = $('#tblFinalizeCabRequest tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    } else {
        $('input[type="checkbox"]', '#tblNestedFinalizeCabRequest').prop('checked', false);
        var count = $('#tblNestedFinalizeCabRequest tbody').find("input[type=checkbox]:checked").size()
        $("#general i .counter").text(count);
    }
    // Prevent click event from propagating to parent
    e.stopPropagation();
})

function showPopupOnFinalizeBulkCabRequest(status) {
    $(".select2").select2();
    _statusOnBulkApprove = status;
    var selectedCabRequestIds = [];
    var selectedEmployees = [];
    var countRequestId = 0;
    var checkedCount = 0;
    $("#tblNestedFinalizeCabRequest").dataTable().$('input[type="checkbox"]').each(function () {
        if (this.checked) {
            selectedCabRequestIds.push($(this).val());
            selectedEmployees.push(this.parentNode.nextElementSibling.firstChild.nodeValue.trim());
            checkedCount++;
        }
        countRequestId++;
    });
    selectedEmployees = jQuery.unique(selectedEmployees);
    var Names = selectedEmployees.join(", ");
    _selectedCabRequestIds = selectedCabRequestIds.join();
    $("#employeesNames").html(Names);
    $("#driverName").val("");
    $("#driverContactNo").val("");
    $("#driverName").removeClass("error-validation");
    $("#driverContactNo").removeClass("error-validation");

    if (checkedCount == countRequestId && countRequestId > 0) {
        getCompanyLocationToFilterDriver();
        $("#mypopupBulkFinalize").modal("show");
        $('#driverType').prop('checked', true);

        $("#divExistingDriver").show();
        $("#divNewDriver").hide();

        $("#driverType").change(function () {
            if ($("#driverType").is(':checked')) {
                $("#divExistingDriver").show();
                $("#divNewDriver").hide();
            }
            else {
                $("#driverContactNo").val("");
                $("#divExistingDriver").hide();
                $("#divNewDriver").show();
            }
        });
        $(".toggle").removeClass("off");
    }
    else if (checkedCount < countRequestId  && countRequestId > 0) {
        misAlert("Please select all employees and finalize requests in one go.", "Warning", "warning");
    }
    else{
        misAlert("Please select employee.", "Warning", "warning");
    }
}

$('#ddlCompanyLocationForDriver').change(function () {
    bindDriverDetails();
    bindVehicleDetails();
});

function getCompanyLocationToFilterDriver() {
    $('#ddlCompanyLocationForDriver').multiselect("destroy");
    $('#ddlCompanyLocationForDriver').empty();

    calltoAjax(misApiUrl.getCompanyLocation, "POST", '',
        function (result) {
            if (result.length > 0) {
                $('#ddlCompanyLocationForDriver').multiselect("destroy");
                $('#ddlCompanyLocationForDriver').empty();
                $.each(result, function (index, item) {
                        $('<option Selected>').val(item.Value).text(item.Text).appendTo('#ddlCompanyLocationForDriver');
                });
            }
            bindDriverDetails();
            bindVehicleDetails();

            $('#ddlCompanyLocationForDriver').multiselect({
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                buttonWidth: false,
                onDropdownHidden: function (event) {
                }
            });
        });
  
}

function bindDriverDetails() {
    $("#ddlDriver").empty();
    $("#ddlDriver").append("<option value='0'>Select</option>");

    var companyLocationIds = "";
    if ($("#ddlCompanyLocationForDriver").val() !== null) {
        companyLocationIds = $("#ddlCompanyLocationForDriver").val().join(',');
    }
    var jsonObject = {
        locationIds: companyLocationIds
    };

    calltoAjax(misApiUrl.getDriverDetails, "POST", jsonObject,
        function (result) {
            if (result.length) {
                if (result.length > 0) {
                    $.each(result, function (key, value) {
                        $("#ddlDriver").append("<option value=" + value.StaffId + ">" + value.StaffName + "</option>");
                    });
                }
            }
        });
}

function bindVehicleDetails() {
    $("#ddlVehicle").empty();
    $("#ddlVehicle").append("<option value='0'>Select</option>");

    var companyLocationIds = "";
    if ($("#ddlCompanyLocationForDriver").val() !== null) {
        companyLocationIds = $("#ddlCompanyLocationForDriver").val().join(',');
    }
    var jsonObject = {
        locationIds: companyLocationIds
    };

    calltoAjax(misApiUrl.getVehicleDetails, "POST", jsonObject,
        function (result) {
            if (result.length) {
                if (result.length > 0) {
                    $.each(result, function (key, value) {
                        $("#ddlVehicle").append("<option value=" + value.VehicleId + ">" + value.VehicleName + "</option>");
                    });
                }
            }
        });
}

function showCabRemarksPopup(requestId) {
    var jsonObject = {
        'requestId': requestId,
        'type': "CAB",
    };
    calltoAjax(misApiUrl.getApproverRemarks, "POST", jsonObject,
        function (result) {
            if (result !== "ERROR") {
                if (result === "") {
                    result = "NA";
                }
                $("#cabRequestRemark").val(result);
                $("#cabRequestRemark").attr('disabled', true);
                $("#mypopupCabRequestRemark").modal("show");
            }
        });
}

function bulkFinalizeCabRequests(cabRequestIds, status) {
    var driverName = "";
    var driverId = 0;
    
    if ($("#driverType").is(':checked')) {
        $("#textDriver").removeClass('validation-required');
        $("#ddlDriver").addClass('validation-required');
        driverName = $("#ddlDriver option:selected").html();
        driverId = $("#ddlDriver").val();
    }
    else {
        $("#ddlDriver").removeClass('validation-required');
        $("#textDriver").addClass('validation-required');
        driverName = $("#textDriver").val();
        driverId = 0;
    }

    if (!validateControls('mypopupBulkFinalize'))
        return false;
    
    var driverContNo = $("#driverContactNo").val();
    var pattern = /^\d{10}$/;
    if (pattern.test(driverContNo) === false) {
        misAlert("Invalid contact number", "Warning", "warning");
        return false;
    }

    var finalizeObject = {
        CabRequestIds: cabRequestIds,
        MobileNo: driverContNo,
        StaffName: driverName,
        StaffId: driverId,
        StatusCode: status,
        VehicleId: $("#ddlVehicle").val()
    };

    var jsonObject = {
        forScreen: "ADMIN"
    };
    calltoAjax(misApiUrl.isValidTimeForCabBooking, "POST", jsonObject,
        function (result) {
            if (result != null) {
                if (!result) {
                    reply = misConfirm("You are finalizing requests before 7:00 PM. Are you sure you want to continue with this?", "Confirm", function (reply) {
                        if (reply) {
                            calltoAjax(misApiUrl.bulkFinalizeCabRequests, "POST", finalizeObject,
                                function (result) {
                                    if (result == 1) {
                                        $("#mypopupBulkFinalize").modal("hide");
                                        misAlert("Cab request has been finalized successfully", "Success", "success")
                                        $('body').removeClass('modal-open');
                                        $('.modal-backdrop').remove();
                                        getCabRequestToFinalize();
                                    } else {
                                        misAlert("Unable to process request. Please try again", "Error", "error");
                                    }
                                });
                        }
                    });
                }
                else {
                    calltoAjax(misApiUrl.bulkFinalizeCabRequests, "POST", finalizeObject,
                        function (result) {
                            if (result == 1) {
                                $("#mypopupBulkFinalize").modal("hide");
                                misAlert("Cab request has been finalized successfully", "Success", "success")
                                $('body').removeClass('modal-open');
                                $('.modal-backdrop').remove();
                                getCabRequestToFinalize();
                            } else {
                                misAlert("Unable to process request. Please try again", "Error", "error");
                            }
                        });
                }
            }
        });
}

function rejectCabRequest(cabRequestId) {
    $("#txtCabRequestRemark").removeClass("error-validation");
    $("#txtCabRequestRemark").val("");
    $("#mypopupReviewCabrequestRemark").modal('show');
    $("#btnRejectCabRequest").show();
    $("#btnApproveCabRequest").hide();
    $("#hdnCabRequestId").val(cabRequestId);
}

function approveCabRequest(cabRequestId) {
    $("#txtCabRequestRemark").removeClass("error-validation");
    $("#txtCabRequestRemark").val("");
    $("#mypopupReviewCabrequestRemark").modal('show');
    $("#btnApproveCabRequest").show();
    $("#btnRejectCabRequest").hide();
    $("#hdnCabRequestId").val(cabRequestId);
}

function takeActionOnCabRequest(cabRequestId, actionCode) {
    if (actionCode == "RJ") {
        var jsonObject = {
            CabRequestId: cabRequestId,
            StatusCode: actionCode,
            Remarks: $("#txtCabRequestRemark").val(),
            ForScreen: "ADMIN"
        };
        calltoAjax(misApiUrl.takeActionOnCabRequest, "POST", jsonObject,
            function (result) {
                if (result === 1) {
                    misAlert('Cab request has been rejected successfully.', "Success", "success");
                    $("#mypopupReviewCabrequestRemark").modal('hide');
                    getCabRequestToFinalize();
                }
                else if (result = 3) {
                    misAlert("Deadline crossed. Unable to fulfill your request.", "Oops", "warning");
                }
                else {
                    misAlert("Unable to process request. please try again", "Error", "error");
                }
            });
    }
    else {
        var jsonObject = {
            CabRequestId: cabRequestId,
            StatusCode: actionCode,
            Remarks: $("#txtCabRequestRemark").val(),
            ForScreen: "ADMIN"
        };
        calltoAjax(misApiUrl.takeActionOnCabRequest, "POST", jsonObject,
            function (result) {
                if (result == 1) {
                    misAlert('Cab Request has been approved successfully.', "Success", "success");
                    $("#mypopupReviewCabrequestRemark").modal('hide');
                    getCabRequestToFinalize();
                }
                else if (result = 3) {
                    misAlert("Deadline crossed. Unable to fulfill your request.", "Oops", "warning");
                }
                else {
                    misAlert("Unable to process request. please try again", "Error", "error");
                }
            });
    }
}

//----Finalized Tab

function getDateForFilterForFinalized() {
    $('#ddlDateSelectForFinalized').multiselect("destroy");
    $('#ddlDateSelectForFinalized').empty();
    var jsonObject = {
        ServiceTypeId: 1,
        ForScreen: "ADMIN"
    };
    calltoAjax(misApiUrl.getDatesForPickAndDrop, "POST", jsonObject,
        function (result) {
            if (result.length > 0) {
                $('#ddlDateSelectForFinalized').multiselect("destroy");
                $('#ddlDateSelectForFinalized').empty();
                $.each(result, function (index, item) {
                    $('<option Selected>').val(item.Date).text(item.DateText).appendTo('#ddlDateSelectForFinalized');
                });
            }
            getCompanyLocationForFinalized();
            $('#ddlDateSelectForFinalized').multiselect({
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                buttonWidth: false,
                onDropdownHidden: function (event) {
                }
            });
        });
}

function getCompanyLocationForFinalized() {
    $('#ddlCompanyLocationForFinalized').multiselect("destroy");
    $('#ddlCompanyLocationForFinalized').empty();

    calltoAjax(misApiUrl.getCompanyLocation, "POST", '',
        function (result) {
            if (result.length > 0) {
                $('#ddlCompanyLocationForFinalized').multiselect("destroy");
                $('#ddlCompanyLocationForFinalized').empty();
                $.each(result, function (index, item) {
                        $('<option Selected>').val(item.Value).text(item.Text).appendTo('#ddlCompanyLocationForFinalized');
                });
            }
            getCabServiceTypeForFinalized();
            $('#ddlCompanyLocationForFinalized').multiselect({
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                buttonWidth: false,
                onDropdownHidden: function (event) {
                }
            });
        });
}

function getCabServiceTypeForFinalized() {
    $("#ddlServiceTypeForFinalized").multiselect("destroy");
    $("#ddlServiceTypeForFinalized").empty();
    calltoAjax(misApiUrl.getCabServiceType, "POST", '',
        function (result) {
            if (result.length > 0) {
                $('#ddlServiceTypeForFinalized').multiselect("destroy");
                $('#ddlServiceTypeForFinalized').empty();

                $.each(result, function (index, item) {
                    $('<option Selected>').val(item.ServiceTypeId).text(item.ServiceType).appendTo('#ddlServiceTypeForFinalized');
                });
            }
            bindCabShiftForFinalized();
            $("#ddlServiceTypeForFinalized").multiselect({
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                buttonWidth: false,
                onDropdownHidden: function (event) {
                }
            });
        });
}

function bindCabShiftForFinalized() {
    $("#ddlShiftForFinalized").multiselect("destroy");
    $("#ddlShiftForFinalized").empty();

    var dates = "";

    var className = $("#dateSelectTypeForFinalized").attr('class');

    if (className === "fa fa-calendar") {
        if ($('#ddlDateSelectForFinalized').val() !== null) {
            dates = $('#ddlDateSelectForFinalized').val().join(',');
        }
    }
    else {
        dates = $("#txtDateForFinalized input").val();
    }

    var serviceTypeIds = "";
    if ($("#ddlServiceTypeForFinalized").val() !== null) {
        serviceTypeIds = $("#ddlServiceTypeForFinalized").val().join(',');
    }

    var jsonObject = {
        ServiceTypeIds: serviceTypeIds,
        Dates: dates,
        ForScreen: "ADMIN"
    };
    calltoAjax(misApiUrl.getShiftDetails, "POST", jsonObject,
        function (result) {
            if (result.length > 0) {
                $('#ddlShiftForFinalized').multiselect("destroy");
                $('#ddlShiftForFinalized').empty();

                $.each(result, function (index, item) {
                    $('<option Selected>').val(item.NewShiftId).text(item.ShiftName).appendTo('#ddlShiftForFinalized');
                });
            }
            bindCabRoutesForFinalized();
            $("#ddlShiftForFinalized").multiselect({
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                buttonWidth: false,
                onDropdownHidden: function (event) {
                }
            });
        });
}

function bindCabRoutesForFinalized() {
    $("#ddlCabRouteForFinalized").multiselect("destroy");
    $("#ddlCabRouteForFinalized").empty();

    var companyLocationIds = "";
    if ($("#ddlCompanyLocationForFinalized").val() !== null) {
        companyLocationIds = $("#ddlCompanyLocationForFinalized").val().join(',');
    }

    var serviceTypeIds = "";
    if ($("#ddlServiceTypeForFinalized").val() !== null) {
        serviceTypeIds = $("#ddlServiceTypeForFinalized").val().join(',');
    }

    var jsonObject = {
        CompanyLocationIds: companyLocationIds,
        ServiceTypeIds: serviceTypeIds
    };

    calltoAjax(misApiUrl.getCabRoutes, "POST", jsonObject,
        function (result) {
            if (result.length > 0) {
                $("#ddlCabRouteForFinalized").multiselect("destroy");
                $("#ddlCabRouteForFinalized").empty();

                $.each(result, function (index, item) {
                    $('<option Selected>').val(item.NewCabRouteId).text(item.CabRoute).appendTo('#ddlCabRouteForFinalized');
                });
            }
            getFinalizedCabRequest();
            $("#ddlCabRouteForFinalized").multiselect({
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                buttonWidth: false,
                onDropdownHidden: function (event) {
                }
            });
        });
}

function getFinalizedCabRequest() {
    var dates = "";

    var className = $("#dateSelectTypeForFinalized").attr('class');

    if (className === "fa fa-calendar") {
        if ($('#ddlDateSelectForFinalized').val() !== null) {
            dates = $('#ddlDateSelectForFinalized').val().join(',');
        }
    }
    else {
        dates = $("#txtDateForFinalized input").val();
    }

    var companyLocationIds = "";
    if ($("#ddlCompanyLocationForFinalized").val() !== null) {
        companyLocationIds = $("#ddlCompanyLocationForFinalized").val().join(',');
    }

    var serviceTypeIds = "";
    if ($("#ddlServiceTypeForFinalized").val() !== null) {
        serviceTypeIds = $("#ddlServiceTypeForFinalized").val().join(',');
    }

    var shiftIds = "";
    if ($("#ddlShiftForFinalized").val() !== null) {
        shiftIds = $("#ddlShiftForFinalized").val().join(',');
    }

    var cabRouteIds = "";
    if ($("#ddlCabRouteForFinalized").val() !== null) {
        cabRouteIds = $("#ddlCabRouteForFinalized").val().join(',');
    }

    var jsonObject = {
        Dates: dates,
        CompanyLocationIds: companyLocationIds,
        ServiceTypeIds: serviceTypeIds,
        ShiftIds: shiftIds,
        CabRouteIds: cabRouteIds
    };

    calltoAjax(misApiUrl.getGroupedFinalizedCabRequest, "POST", jsonObject, function (result) {
        var data = $.parseJSON(JSON.stringify(result)); //FD--Finalized
        $("#tblFinalizedRequest").dataTable({
            "dom": 'lBfrtip',
            "buttons": [
                {
                    filename: 'OR List',
                    extend: 'collection',
                    text: 'Export',
                    buttons: [{ extend: 'copy', },
                    { extend: 'excel', filename: 'OR List' },
                    { extend: 'pdf', filename: 'OR List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                    { extend: 'print', filename: 'OR List' },
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
            "aaData": data,
            "aoColumns": [
                {
                    "className": 'details-control',
                    "orderable": false,
                    "sWidth": "10px",
                    "mData": null,
                    "defaultContent": ''
                },
                {
                    "mData": "CabRouteId",
                    "sTitle": "CabRouteId",
                },
                {
                    "mData": "ShiftId",
                    "sTitle": "ShiftId",
                },
                {
                    "mData": "CompanyLocationId",
                    "sTitle": "CompanyLocationId",
                },
                {
                    "mData": "FCRequestId",
                    "sTitle": "FCRequestId",
                },
                {
                    "mData": "DateText",
                    "sTitle": "Date",
                  //  "sWidth": "80px"
                },
                {
                    "mData": "CompanyLocation",
                    "sTitle": "Location",
                    //"sWidth": "80px"
                },
                {
                    "mData": "ServiceType",
                    "sTitle": "Service",
                    //"sWidth": "80px"
                },
                {
                    "mData": "ShiftName",
                    "sTitle": "Time",
                   // "sWidth": "80px"
                },
                {
                    "mData": "RequestCount",
                    "sTitle": "Count",
                   // "sWidth": "80px"
                },
                {
                    "mData": "StaffName",
                    "sTitle": "Driver",
                    //"sWidth": "80px"
                },
                {
                    "mData": "StaffMobileNo",
                    "sTitle": "Mobile No",
                   // "sWidth": "80px"
                },
                {
                    "mData": "VehicleName",
                    "sTitle": "Vehicle",
                   // "sWidth": "80px"
                },
                //{
                //    "mData": "FinalizedOn",
                //    "sTitle": "Finalized On",
                //    "sWidth": "100px"
                //},
                ],
            "fnInitComplete": function (row) {
                //if (typeof (data) == 'undefined' || data === null || !(data.length > 0)) {
                var table = $("#tblFinalizedRequest").DataTable();
                table.columns([1, 2, 3, 4]).visible(false);
                //}
            }
        });

        tableFinalized = $('#tblFinalizedRequest').DataTable();
    });
}

$(document).on("click", '#tblFinalizedRequest tbody td.details-control', function (e) {

    // Add event listener for opening and closing details
    // $('#tblAllocatedAsset tbody').on('click', 'td.details-control', function (e) {
    var tr = $(this).closest('tr');
    var row = tableFinalized.row(tr);
    if (row.child.isShown()) {
        row.child.hide();
        $("#tblFinalizedRequest tbody tr").removeClass('shown expand');

    }
    else {
        tableFinalized.rows().eq(0).each(function (idx) {
            var row = tableFinalized.row(idx);
            if (row.child.isShown()) {
                row.child.hide();
            }
        });
        var html = '<div class="row m-t-1 m-b-1"><div class="col-md-12">' +
            '<table id="tblNestedFinalizedRequest" data-filter-control="true" data-toolbar="#toolbar" class="table table-hover"></table>' +
            '</div ></div > ';

       var shiftId = row.data().ShiftId;
       var fcRequestId = row.data().FCRequestId;
       var locationId = row.data().CompanyLocationId;
        var routeId = row.data().CabRouteId;
        var dateText = row.data().DateText;
        var shift = row.data().ShiftName;
        var compnyloc = row.data().CompanyLocation;
        var serviceType = row.data().ServiceType;
        var driver = row.data().StaffName;
        var driverNumbar = row.data().StaffMobileNo;
        var vehicle = row.data().VehicleName;

       var jsonObject = {
            FCRequestId : fcRequestId,
            CompanyLocationId: locationId,
           ShiftId: shiftId,
           CabRouteId: routeId
        };
        calltoAjax(misApiUrl.getFinalizedCabRequest, "POST", jsonObject,
            function (result) {
                var resultdata = $.parseJSON(JSON.stringify(result));
                row.child(html).show();
                formatFinalized(resultdata, dateText, shift, serviceType, compnyloc, driver, driverNumbar, vehicle);
                $("#tblFinalizedRequest tbody tr").removeClass('shown expand');
                tr.addClass('shown expand');
            });
    }
});

function formatFinalized(data, dateText, shift, serviceType, compnyloc, driver, driverNumbar, vehicle) {
    var title = "Cab Request on " + dateText;
    var date = dateText + " @ " + shift;
    var driverName = driver + " [" + driverNumbar + "]";
    $("#tblNestedFinalizedRequest").dataTable({
        dom: 'Bfrtip',
        "buttons": [
            {
                filename: 'CabRequestData',
                extend: 'collection',
                text: 'Export',
                buttons: [
                    {
                        extend: 'excel',
                        exportOptions: {
                            columns: [0, 1, 2, 3, 4, 5, 7, 8, 9,11,12]
                        },
                        title: title,
                    },
                    {
                        extend: 'pdf',
                        exportOptions: {
                            columns: [0, 1, 2, 5,11,12]
                           // columns: ':visible'
                        },
                        title: title,
                        customize: function (doc) {
                            doc.content.splice(0, 0, {
                                text: "Company Location: " + compnyloc + "\n" + "Date & Time: " + date + "\n" + "Cab Service: " + serviceType + "\n" + "Driver: " + driverName + "\n" + "Vehicle No. "+ vehicle+"\n\n"
                            });
                        }
                    }
                ],
            },

            'colvis'
        ],
        "responsive": true,
        "autoWidth": false,
        "paging": false,
        "bDestroy": true,
        "ordering": true,
        "order": [],
        "info": false,
        "deferRender": true,
        "aaData": data,
        "searching": false,
        "aoColumns": [
            {
                "mData": "EmployeeName",
                "sTitle": "Employee Name",
                "sWidth": "100px"
            },
            {
                "mData": "EmpContactNo",
                "sTitle": "Mobile No.",
                "sWidth": "100px"
            },
            {
                "mData": "ReportingManager",
                "sTitle": "Reporting Manager",
                "sWidth": "100px"
            },
            {
                "mData": null,
                "sTitle": "Date & Time",
                mRender: function (data, type, row) {
                    return date;
                }
            },
           
            {
                "mData": null,
                "sTitle": "Company Location",
                mRender: function (data, type, row) {
                    return compnyloc;
                }
            },
            //{
            //    "mData": "ServiceType",
            //    "sTitle": "Service",
            //    "sWidth": "80px",
              
            //},
            //{
            //    "mData": "ShiftName",
            //    "sTitle": "Time",
            //    "sWidth": "80px",
              
            //},
            {
                "mData": "LocationName",
                "sTitle": serviceType + " Location",
                "sWidth": "80px"
            },
            //{
            //    "mData": "LocationDetail",
            //    "sTitle": "Location Detail",
            //    "sWidth": "100px",
            //    "className": "none"
            //},
            {
                "mData": null,
                "sTitle": "Status",
                "sWidth": "100px",
                "className": "all",
                mRender: function (data, type, row) {
                    var html = '<a onclick="showCabRemarksPopup(' + data.CabRequestId + ')">' + data.Status + '</a>';
                    return html;
                }
            },
            {
                "mData": null,
                "sTitle": "Driver",
                "className": "none",
                mRender: function (data, type, row) {
                    return driver;
                }
            },
            {
                "mData": null,
                "sTitle": "Driver Number",
                "className": "none",
                mRender: function (data, type, row) {
                    return driverNumbar;
                }
            },
            {
                "mData": null,
                "sTitle": "Vehicle No.",
                "className": "none",
                mRender: function (data, type, row) {
                    return vehicle;
                }
            },
            {
                "mData": "CreatedDate",
                "sTitle": "Requested On",
                "sWidth": "90px",
                "className":"none"
            },
            {
                "mData": "LocationDetail",
                "sTitle": "Location Detail",
                "sWidth": "100px",
                "className": "none"
            },
            {
                "mData": null,
                "sTitle": "Remarks",
                "className": "none",
                mRender: function (data, type, row) {
                    return "";
                }
            },
        ],
        "fnInitComplete": function (row) {
            //if (typeof (data) == 'undefined' || data === null || !(data.length > 0)) {
            var table = $("#tblNestedFinalizedRequest").DataTable();
            table.columns([3,4,6, 7,8,9,11,12]).visible(false);
            //}
        }
    });
}




