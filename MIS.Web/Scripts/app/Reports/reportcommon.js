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
    //var FromDate = new Date();
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
    //    $('#tillDateEmp').datepicker('setStartDate', fromStartDate);
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

    getDepartments(0);

   // getLocation();
    $('#employeeName').multiselect({
        includeSelectAllOption: true,
        enableFiltering: true,
        enableCaseInsensitiveFiltering: true,
        buttonWidth: false,
        onDropdownHidden: function (event) {
        }
    });
    $('#employeeCode').multiselect({
        includeSelectAllOption: true,
        enableFiltering: true,
        enableCaseInsensitiveFiltering: true,
        buttonWidth: false,
        onDropdownHidden: function (event) {
        }
    });

    $("#department").change(function () {
         getReportingManagersByDepartmentId(1);
    });

    $("#reportingManager").change(function () {
        getEmployeesAccordingToSelection(1);
    });

    $("#location").change(function () {
        getEmployeesAccordingToSelection(1);
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

function getLocation(requestFor) {
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
            getEmployeesAccordingToSelection(requestFor);
        });
}

function getDepartments(requestFor) {
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
                    //getTeamsByDepartmentId();
                   getReportingManagersByDepartmentId(requestFor);
               });
}

function getReportingManagersByDepartmentId(requestFor) {
    var departmentIds = (($('#department').val() !== null && typeof $('#department').val() !== 'undefined' && $('#department').val().length > 0) ? $('#department').val().join(',') : '0');
    var jsonObject = {
        departmentIds: departmentIds,
    };
    calltoAjax(misApiUrl.getReportingManagersInADepartment, "POST", jsonObject,
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
                   getLocation(requestFor);
               });
}

function getEmployeesAccordingToSelection(requestFor) {
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
            
            var employeeCode = result.OrderedByEmployeeCode;
            var employeeName = result.OrderedByEmployeeName;

            //$('#employeeCode').multiselect("destroy");
            //$('#employeeCode').empty();
            //$.each(employeeCode, function (index, value) {
            //    $('<option selected>').val(value.EmployeeAbrhs).text(value.EmployeeCode).appendTo('#employeeCode');
            //});

            //$('#employeeCode').multiselect({
            //    includeSelectAllOption: true,
            //    enableFiltering: true,
            //    enableCaseInsensitiveFiltering: true,
            //    buttonWidth: false,
            //    onDropdownHidden: function (event) {
            //    }
            //});

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
            if (requestFor == 0) {
                processReport();
            }
        });
}
