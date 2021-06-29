$(document).ready(function () {
    if (misPermissions.isDelegatable) {
        var html = '';
        if (!misPermissions.isDelegated) {
            html = '<button id="btnUserDelegation" type="button" class="btn btn-success"><i class="fa fa-bolt"></i>&nbsp;Delegate</button>';
        }
        else {
            html = '<button id="btnUserDelegation" type="button" class="btn btn-success"><i class="fa fa-lightbulb-o" style="color: yellow;font-size: 20px;"></i>&nbsp;Delegate</button>';
        }
        $("#divDeligation").html(html);
    }

    //var ToDate = new Date();
    //var date = new Date(),
    //y = date.getFullYear(),
    //m = date.getMonth();
    //var FromDate = new Date(y, m, 1);
    //FromDate.setDate(FromDate.getDate());
    //$("#fromDateEmp input").val(toddmmyyyDatePicker(FromDate));
    //$("#tillDateEmp input").val(toddmmyyyDatePicker(ToDate));

    //$('#fromDateEmp').datepicker({
    //    format: "mm/dd/yyyy",
    //    autoclose: true,
    //    todayHighlight: true
    //}).datepicker('setEndDate', new Date()).on('changeDate', function (ev) {
    //    var fromStartDate = $('#fromDateEmp input').val();
    //    $('#tillDateEmp input').val('');
    //    $('#tillDateEmp').datepicker('setStartDate', fromStartDate).trigger('change');
    //});

    //$('#tillDateEmp').datepicker({
    //    format: "mm/dd/yyyy",
    //    autoclose: true,
    //    todayHighlight: true
    //}).datepicker('setEndDate', new Date());


    $('#fromDateEmp').datepicker({
        autoclose: true,
        todayHighlight: true
    }).datepicker('setDate', new Date());

    $('#tillDateEmp').datepicker({
        autoclose: true,
        todayHighlight: true
    }).datepicker('setDate', new Date());

    $('#fromDateEmp').datepicker({
        autoclose: true,
        todayHighlight: true
    }).datepicker('setEndDate', new Date()).on('changeDate', function (ev) {
        onFromDateChange();
    });

    $("#department").change(function () {
        getTeamsByDepartmentId(1);
    });

    $("#team").change(function () {
        getReportingManagersByTeamId(1);
    });

    $("#location").change(function () {
        getEmployees(1);
    });

    getDepartments(0);

   // processClubbedReport();

    $('#employeeName').multiselect({
        includeSelectAllOption: true,
        enableFiltering: true,
        enableCaseInsensitiveFiltering: true,
        buttonWidth: false,
        onDropdownHidden: function (event) {
        }
    });
    
});

function onFromDateChange() {
    var fromDate = $("#fromDateEmp input").val();
    $('#tillDateEmp input').val("");
    $('#tillDateEmp').datepicker({
        autoclose: true,
        todayHighlight: true
    }).datepicker('setStartDate', fromDate).datepicker('setEndDate', new Date());
}

function getDepartments(forRequest) {

    var jsonObject = {
        'userAbrhs': misSession.userabrhs,
        'menuAbrhs': misPermissions.menuAbrhs
    };
    calltoAjax(misApiUrl.getDepartmentOnReportToBasis, "POST", jsonObject,
        function (result) {
            $('#department').multiselect("destroy");
            $('#department').empty();
            $.each(result, function (index, value) {
                $('<option selected>').val(value.UserId).text(value.UserName).appendTo('#department');
            });
            $('#department').multiselect({
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                buttonWidth: false,
                onDropdownHidden: function (event) {
                }
            });
            getTeamsByDepartmentId(forRequest);
        });
}

function getLocation(forRequest) {
    calltoAjax(misApiUrl.getCompanyLocation, "POST", '',
        function (result) {
            $('#location').multiselect("destroy");
            $('#location').empty();
            $.each(result, function (index, value) {
                $('<option selected>').val(value.Value).text(value.Text).appendTo('#location');
            });
            $('#location').multiselect({
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                buttonWidth: false,
                onDropdownHidden: function (event) {
                }
            });
           // $('#location').multiselect('select', [misSession.companylocationid]);
            getEmployees(forRequest);
        });
}

function processClubbedReport() {
    if (!validateControls('reportFilter')) {
        return false;
    }
    loadClubbedReportGrid();
}

function getTeamsByDepartmentId(forRequest) {
    var departmentIds = (($('#department').val() !== null && typeof $('#department').val() !== 'undefined' && $('#department').val().length > 0) ? $('#department').val().join(',') : '0');
    var jsonObject = {
        departmentIds: departmentIds,
    };
    calltoAjax(misApiUrl.getTeamNames, "POST", jsonObject,
        function (result) {
            $('#team').multiselect("destroy");
            $('#team').empty();
            $.each(result, function (index, value) {
                $('<option selected>').val(value.TeamAbrhs).text(value.TeamName).appendTo('#team');
            });
            $('#team').multiselect({
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                buttonWidth: false,
                onDropdownHidden: function (event) {
                }
            });
            getReportingManagersByTeamId(forRequest);
        });
}

function getReportingManagersByTeamId(forRequest) {
    var teamIds = (($('#team').val() !== null && typeof $('#team').val() !== 'undefined' && $('#team').val().length > 0) ? $('#team').val().join(',') : '0');
    var jsonObject = {
        teamIds: teamIds,
    };
    calltoAjax(misApiUrl.getReportingManagersInATeam, "POST", jsonObject,
        function (result) {
            $('#reportingManager').multiselect("destroy");
            $('#reportingManager').empty();
            $.each(result, function (index, value) {
                $('<option selected>').val(value.EmployeeAbrhs).text(value.Name).appendTo('#reportingManager');
            });
          
            $('#reportingManager').multiselect({
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                buttonWidth: false,
                onDropdownHidden: function (event) {
                }
            });
              //getEmployees();
            getLocation(forRequest);
        });
}

function getEmployees(forRequest) {
    var departmentIds = (($('#department').val() !== null && typeof $('#department').val() !== 'undefined' && $('#department').val().length > 0) ? $('#department').val().join(',') : '0');
    var reportToIds = (($('#reportingManager').val() !== null && typeof $('#reportingManager').val() !== 'undefined' && $('#reportingManager').val().length > 0) ? $('#reportingManager').val().join(',') : '0');
    var locationIds = (($('#location').val() !== null && typeof $('#location').val() !== 'undefined' && $('#location').val().length > 0) ? $('#location').val().join(',') : '0');

    var jsonObject = {
        departmentId: departmentIds,
        date: $("#tillDateEmp input").val(),
        reportToAbrhs: reportToIds,
        menuAbrhs: misPermissions.menuAbrhs,
        locationIds: locationIds
    }
    calltoAjax(misApiUrl.getUsersForReports, "POST", jsonObject,
        function (result) {
            var employeeName = result.OrderedByEmployeeName;
            $('#employeeName').multiselect("destroy");
            $('#employeeName').empty();
            $.each(employeeName, function (index, value) {
                $('<option selected>').val(value.EmployeeAbrhs).text(value.Name).appendTo('#employeeName');
            });

            $('#employeeName').multiselect({
                includeSelectAllOption: true,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                buttonWidth: false,
                onDropdownHidden: function (event) {
                }
            });
            if (forRequest == 0) {
                loadClubbedReportGrid();
            }
        });
}

function loadClubbedReportGrid() {
    var teamIds = (($('#team').val() !== null && typeof $('#team').val() !== 'undefined' && $('#team').val().length > 0) ? $('#team').val().join(',') : '0');
    var departmentIds = (($('#department').val() !== null && typeof $('#department').val() !== 'undefined' && $('#department').val().length > 0) ? $('#department').val().join(',') : '0');
    var reportToAbrhs = (($('#reportingManager').val() !== null && typeof $('#reportingManager').val() !== 'undefined' && $('#reportingManager').val().length > 0) ? $('#reportingManager').val().join(',') : '0');
    var userIds = 0;
    userIds = (($('#employeeName').val() !== null && typeof $('#employeeName').val() !== 'undefined' && $('#employeeName').val().length > 0) ? $('#employeeName').val().join(',') : '0');
    var locationIds = (($('#location').val() !== null && typeof $('#location').val() !== 'undefined' && $('#location').val().length > 0) ? $('#location').val().join(',') : '0');
    var jsonObject = {
        fromDate: $("#fromDateEmp input").val(),
        endDate: $("#tillDateEmp input").val(),
        teamIds: teamIds,
        departmentIds: departmentIds,
        reportToAbrhs:'',
        empAbrhs: '',
        locationIds: locationIds,
        status: $("#status").val(),
    }
    calltoAjax(misApiUrl.getClubbedReport, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
           // $.fn.dataTable.moment('DD/MM/YYYY');
            $("#tblClubbedReportList").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'Clubbed Report',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{
                            extend: 'copy', exportOptions: {
                                columns: ':visible'
                            } },
                            {
                                extend: 'excel', filename: 'Clubbed Report',
                                exportOptions: {
                                    columns: ':visible',
                                    orthogonal:'export'
                                }
                            },
                            {
                                extend: 'pdf', filename: 'Clubbed Report',
                                exportOptions: {
                                    columns: ':visible'
                                } },
                            {
                                extend: 'print', filename: 'Clubbed Report',
                                exportOptions: {
                                    columns: ':visible'
                                }},
                        ]
                    },
                    {
                        extend: 'colvis',
                        postfixButtons: ['colvisRestore']
                    }, 
                ],
                //"responsive": true,
                //"autoWidth": true,
                "paging": true,
                "bDestroy": true,
                "ordering": true,
                "order": [],
                "info": true,
                "deferRender": false,
                "aaData": data,
                //"columnDefs": [
                //    { type: 'date-eu', targets: 0 }
                //],
                "aoColumns": [

                    {
                        "mData": "EmployeeName",
                        "sTitle": "Employee Name",
                    },
                    {
                        "mData": null,
                        "sTitle": "Employee Code",
                        mRender: function (data, type, row) {
                            if (row.EmpCode != null || row.EmpCode != "") 
                                return row.EmpCode;
                            else
                            return "";
                        }
                    },
                    {
                        "mData": "ManagerName",
                        "sTitle": "Manager Name",
                    },
                    {
                        "mData": "Department",
                        "sTitle": "Department",
                    },
                    {
                        "mData": "TeamName",
                        "sTitle": "Team Name",
                    },
                    {
                        "mData": "Location",
                        "sTitle": "Location",
                    },
                    {
                        "mData": "CL",
                        "sTitle": "CL",
                    },
                    {
                        "mData": "PL",
                        "sTitle": "PL",
                    },
                    {
                        "mData": "WFH",
                        "sTitle": "WFH",

                    },
                    {
                        "mData": "COFF",
                        "sTitle": "COFF",
                    },
                    {
                        "mData": "LNSA",
                        "sTitle": "LNSA",
                    },
                    {
                        "mData": "TotalDaysPresent",
                        "sTitle": "Working Days",
                    },
                    {
                        "mData": "TotalLoggedHours",
                        "sTitle": "Logged Hours",
                    },
                    {
                        "mData": "JoiningDate",
                        "sTitle": "Joining Date (DD/MM/YYYY)",
                    },
                    {
                        "mData": "RelievingDate",
                        "sTitle": "Relieving Date",
                    },
                    {
                        "mData": "Status",
                        "sTitle": "Status",
                    }
                ]
            });
        });
}