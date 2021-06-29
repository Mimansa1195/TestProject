var _trainingId = 0;
var _trainingDetailId = 0;
var _status = 0;
$(document).ready(function () {
    bindTrainings();
    bindPendingTrainingRequests();
    bindReviewdTrainingRequests();
});
function showAddTrainingPopup() {
    $("#mypopupAddTraining").modal("show");
    $("#trainingDescription").val("");
    $("#document").val("");
    $('#fromDate').datepicker({
        format: "mm/dd/yyyy",
        autoclose: true,
        todayHighlight: true,
        startDate: toddmmyyyDatePicker(new Date()),
    }).on('changeDate', function (ev) {
        $('#tillDate input').val('');
        $('#tillDate').datepicker({
            format: "mm/dd/yyyy",
            autoclose: true,
            todayHighlight: true,
        }).on('changeDate', function (ev) {
            $('#tentativeDate input').val('');
            $('#tentativeDate').datepicker({
                format: "mm/dd/yyyy",
                autoclose: true,
                todayHighlight: true,
            }).datepicker('setStartDate', $("#tillDate input").val());
        }).datepicker('setStartDate', $("#fromDate input").val());
    }).datepicker("setDate", toddmmyyyDatePicker(new Date()));
}
$("#buttonClose").click(function () {
    $("#mypopupAddTraining").modal("hide");
    $("#trainingDescription").removeClass('error-validation');
    $("#tentativeDateEmp").removeClass('error-validation');
    $("#tillDateEmp").removeClass('error-validation');
    $("#trainingTitle").removeClass('error-validation');
    $("#fromDate").val("");
    $("#fromDateEmp").val("");
    $("#tillDate").val("");
    $("#tillDateEmp").val("");
    $("#trainingTitle").val("");
    $("#trainingDescription").val("");
    $("#tentativeDate").val("");
    $("#tentativeDateEmp").val("");
    $("#document").val("");
});
$("#btnClose").click(function () {
    $("#mypopupAddTraining").modal("hide");
    $("#trainingDescription").removeClass('error-validation');
    $("#tentativeDateEmp").removeClass('error-validation');
    $("#tillDateEmp").removeClass('error-validation');
    $("#trainingTitle").removeClass('error-validation');
    $("#fromDate").val("");
    $("#fromDateEmp").val("");
    $("#tillDate").val("");
    $("#tillDateEmp").val("");
    $("#trainingTitle").val("");
    $("#trainingDescription").val("");
    $("#tentativeDateEmp").val("");
    $("#document").val("");
});
$("#buttonCloseEdit").click(function () {
    $("#mypopupEditTraining").modal("hide");
    $("#trainingDescriptionEdit").removeClass('error-validation');
    $("#tentativeDateEmpEdit").removeClass('error-validation');
    $("#tillDateEmpEdit").removeClass('error-validation');
    $("#trainingTitleEdit").removeClass('error-validation');
    $("#fromDateEdit").val("");
    $("#fromDateEmpEdit").val("");
    $("#tillDateEdit").val("");
    $("#tillDateEmpEdit").val("");
    $("#trainingTitleEdit").val("");
    $("#trainingDescriptionEdit").val("");
    $("#tentativeDateEdit").val("");
    $("#tentativeDateEmpEdit").val("");
});
$("#btnCloseEdit").click(function () {
    $("#mypopupEditTraining").modal("hide");
    $("#trainingDescriptionEdit").removeClass('error-validation');
    $("#tentativeDateEmpEdit").removeClass('error-validation');
    $("#tillDateEmpEdit").removeClass('error-validation');
    $("#trainingTitleEdit").removeClass('error-validation');
    $("#fromDateEdit").val("");
    $("#fromDateEmpEdit").val("");
    $("#tillDateEdit").val("");
    $("#tillDateEmpEdit").val("");
    $("#trainingTitleEdit").val("");
    $("#trainingDescriptionEdit").val("");
    $("#tentativeDateEdit").val("");
    $("#tentativeDateEmpEdit").val("");
});
$("#btnSaveTraining").click(function () {
    var fileName = $("#document").val().replace(/^.*\\/, "");
    if (!validateControls('mypopupAddTraining')) {
        return false;
    }
    var jsonObject = {
        fromDate: $("#fromDateEmp").val(),
        endDate: $("#tillDateEmp").val(),
        tentativeDate: $("#tentativeDateEmp").val(),
        description: $("#trainingDescription").val(),
        title: $("#trainingTitle").val(),
        document: fileName,
        base64FormData: base64Data
    }
    calltoAjax(misApiUrl.addTrainings, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            switch (resultData) {
                case 1:
                    misAlert("Training session added successfully", "Success", "success");
                    $("#mypopupAddTraining").modal('hide');
                    $("#fromDate").val("");
                    $("#fromDateEmp").val("");
                    $("#tillDate").val("");
                    $("#tillDateEmp").val("");
                    $("#trainingDescription").val("");
                    $("#tentativeDateEmp").val("");
                    $("#trainingTitle").val("");
                    $("#document").val("");
                    bindTrainings();
                    break;
                case 2:
                    misAlert("Training sessions with this title already exists. Please check.", "Warning", "warning");
                    $("#mypopupAddTraining").modal('hide');
                    $("#fromDate").val("");
                    $("#fromDateEmp").val("");
                    $("#tillDate").val("");
                    $("#tillDateEmp").val("");
                    $("#jobDescription").val("");
                    $("#trainingTitle").val("");
                    $("#position").val("");
                    $("#document").val("");
                    break;
                case 0:
                    misAlert("Unable to process request. Try again", "Error", "error");
                    $("#mypopupAddTraining").modal('toggle');
                    break;
            }
        });
});
var base64Data;
function checkValidFile(sender) {
    var validExts = new Array(".pdf");
    var fileExt = sender.value;
    fileExt = fileExt.substring(fileExt.lastIndexOf('.'));
    if (validExts.indexOf(fileExt) < 0) {
        misAlert("Invalid file selected. Supported extension is " + validExts.toString(), "Warning", "warning");
        $("#document").val("");
        return false;
    } else {
        ToBase64();
        return true;
    }
}

function ToBase64() {
    var selectedFile = document.getElementById("document").files;
    if (selectedFile.length > 0) //Check File is not Empty
    {
        var fileToLoad = selectedFile[0];
        var fileReader = new FileReader();
        fileReader.onload = function (fileLoadedEvent) {
            base64Data = fileLoadedEvent.target.result;
        };
        fileReader.readAsDataURL(fileToLoad);
    }
}
function bindTrainings() {
    calltoAjax(misApiUrl.getAllTrainings, "POST", '',
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#tblTraining").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'Training sessions List',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'Training sessions List' },
                        { extend: 'pdf', filename: 'Training sessions List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                        { extend: 'print', filename: 'Training sessions List' },
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
                        "mData": "Title",
                        "sTitle": "Title",
                        // "sWidth" : "100px"

                    },
                    {
                        "mData": "Description",
                        "sTitle": "Description",
                        "className": "none"

                    },
                    {
                        "mData": "FromDate",
                        "sTitle": "Nomination From",

                    },
                    {
                        "mData": "EndDate",
                        "sTitle": "Nomination Till",
                    },
                    {
                        "mData": "TentativeDate",
                        "sTitle": "Tentative Date",
                    },
                    {
                        "mData": "CreatedDate",
                        "sTitle": "Created Date",
                        "className": "none",
                    },
                    {
                        "mData": null,
                        "sTitle": "Is Open", "orderable": false,
                        mRender: function (data, type, row) {
                            if (row.IsNominationClosed === true)
                                return '<span class="label label-danger"><i class="fa fa-times"></i>No</span>';
                            else
                                return '<span class="label label-success"> <i class="fa fa-check"></i>Yes </span>';
                        }
                    },
                    {
                        "mData": "Count",
                        "sTitle": "Nominees",
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        "sClass": "text-center",
                        "sWidth": "150px",
                        mRender: function (data, type, row) {
                            var q = new Date();
                            var m = q.getMonth() + 1;
                            var d = q.getDate();
                            var y = q.getFullYear();
                            var tDate = (m > 9 ? '' : '0') + m + '/' + (d > 9 ? '' : '0') + d + '/' + y;
                            var tFullDate = new Date(tDate);
                            var myDate = row.EndDate;
                            var myFullDate = new Date(myDate);
                            var _newDate = row.EndDate;
                            var html = '<div>';
                            html += '&nbsp;<button type="button" class="btn btn-sm btn-success" onclick="viewTrainingPopup(\'' + row.TrainingId + '\',\'' + row.Title + '\')" data-toggle="tooltip" title="View"><i class="fa fa-eye"> </i></button>';
                            html += '&nbsp;<button type="button" class="btn btn-sm teal" onclick="editTrainingPopup(\'' + row.TrainingId + '\')" data-toggle="tooltip" title="Edit"><i class="fa fa-pencil"> </i></button>';
                            if (row.IsNominationClosed == false && myFullDate >= tFullDate) {
                                html += '&nbsp;<button type="button" class="btn btn-sm btn-danger" onclick="changeTrainingStatus(\'' + row.TrainingId + '\',2' + ')" data-toggle="tooltip" title="Close Nominations"><i class="fa fa-times"> </i></button>';

                            } else if (row.IsNominationClosed == true && myFullDate >= tFullDate) {
                                html += '&nbsp;<button type="button" class="btn btn-sm btn-warning" onclick="changeTrainingStatus(\'' + row.TrainingId + '\',1' + ')" data-toggle="tooltip" title="Open Nominations"><i class="fa fa-check"> </i></button>';
                            }
                            return html;
                        }
                    },
                ]
            });
        });
}
function viewTrainingPopup(trainingId, title) {
    $("#modalViewTrainingDetails").modal("show");
    document.getElementById("header").innerHTML = "View Nominees For " + title + "";
    viewAppliedTraining(trainingId);
}
$("#btnRequestClose").click(function () {
    $("#modalViewTrainingDetails").modal("hide");
});
function viewAppliedTraining(trainingId) {
    var jsonObject = {
        trainingId: trainingId
    }
    calltoAjax(misApiUrl.getAllNomineesDetails, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#tblAppliedTraining").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'Trainee nominees List',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [
                        {
                            extend: 'excelHtml5', filename: 'Trainee nominees List',
                            exportOptions: {
                                columns: [0, 1, 2, 3, 4, 5, 6],
                                format: {
                                    body: function (data, column, row) {
                                        return row == 7 ? data.replace(/<br>/g, '' + "\r\n" + '') : data;
                                    }
                                }
                            }
                        },
                            //{ extend: 'pdf', filename: 'Achievement List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                            //{ extend: 'print', filename: 'Achievement List' },
                        ]
                    }],
                "responsive": true,
                "autoWidth": false,
                "paging": true,
                "bDestroy": true,
                "ordering": true,
                "footer": true,
                "order": [],
                "info": true,
                "deferRender": true,
                "aaData": resultData,
                "aoColumns": [
                    {
                        "mData": "AppliedBy",
                        "sTitle": "Nominee",
                        // "sWidth": "200px"

                    },
                    {
                        "mData": "EmployeeCode",
                        "sTitle": "Employee sCode",
                    },
                    {
                        "mData": "EmailId",
                        "sTitle": "EmailId",
                    },
                    {
                        "mData": "Description",
                        "sTitle": "Description",
                    },

                    {
                        "mData": "TentativeDate",
                        "sTitle": "Tentative Date",

                    },
                    {
                        "mData": "CreatedDate",
                        "sTitle": "Applied On",

                    },

                    {
                        "mData": "Status",
                        "sTitle": "Status",

                    },

                ],
                "fnInitComplete": function (row) {
                    //if (typeof (data) == 'undefined' || data === null || !(data.length > 0)) {
                    var table = $("#tblAppliedTraining").DataTable();
                    table.columns([ 1, 2,3]).visible(false);
                    //}
                }
            });
        });
}

function editTrainingPopup(trainingId) {
    _trainingId = trainingId;
    $('#tentativeDateEdit input').val('');
    $('#tentativeDateEdit').datepicker({
        format: "mm/dd/yyyy",
        autoclose: true,
        todayHighlight: true,
        startDate: toddmmyyyDatePicker(new Date()),
    });
    $('#fromDateEdit input').val('');
    $('#fromDateEdit').datepicker({
        format: "mm/dd/yyyy",
        autoclose: true,
        todayHighlight: true,
        startDate: toddmmyyyDatePicker(new Date()),
    }).on('changeDate', function (ev) {
        $('#tillDateEdit input').val('');
        $('#tillDateEdit').datepicker({
            format: "mm/dd/yyyy",
            autoclose: true,
            todayHighlight: true,
        }).on('changeDate', function (ev) {
            $('#tentativeDateEdit input').val('');
            $('#tentativeDateEdit').datepicker({
                format: "mm/dd/yyyy",
                autoclose: true,
                todayHighlight: true,
            }).datepicker('setStartDate', $("#tillDateEdit input").val());
        }).datepicker('setStartDate', $("#fromDateEdit input").val());
    }).datepicker("setDate", toddmmyyyDatePicker(new Date()));
    var jsonObject = {
        trainingId: trainingId
    }
    calltoAjax(misApiUrl.viewTrainingDetails, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            var fda = new Date(resultData.FromDate);
            var tda = new Date(resultData.EndDate);
            var tentativeda = new Date(resultData.TentativeDate);
            $("#fromDateEmpEdit").val(toddmmyyyDatePicker(fda));
            $("#tillDateEmpEdit").val(toddmmyyyDatePicker(tda));
            $("#tentativeDateEmpEdit").val(toddmmyyyDatePicker(tentativeda));
            $("#trainingTitleEdit").val(resultData.Title);
            $("#trainingDescriptionEdit").val(resultData.Description);
            
            $("#mypopupEditTraining").modal("show");
        });
}
$("#btnTrainingEdit").click(function () {
    if (!validateControls('mypopupEditTraining')) {
        return false;
    }
    var jsonObject = {
        fromDate: $("#fromDateEmpEdit").val(),
        endDate: $("#tillDateEmpEdit").val(),
        tentativeDate: $("#tentativeDateEmpEdit").val(),
        title: $("#trainingTitleEdit").val(),
        description: $("#trainingDescriptionEdit").val(),
       
        trainingId: _trainingId,
    };
    calltoAjax(misApiUrl.updateTrainingDetails, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            switch (resultData) {
                case 1:
                    misAlert("Training details has been updated successfully", "Success", "success");
                    $("#mypopupEditTraining").modal('hide');
                    bindTrainings();
                    break;
                case 2:
                    misAlert("This training session does not Exist.", "Warning", "warning");
                    break;
            }
        });
});
function changeTrainingStatus(trainingId, status) {
    var jsonObject = {
        trainingId: trainingId,
        status: status,
    }
    misConfirm("Are you sure you want to " + (status == 2 ? "deactivate" : "activate") + " this training session nominations opening?", "Confirm", function (isConfirmed) {
        if (isConfirmed) {
            calltoAjax(misApiUrl.changeTrainingStatus, "POST", jsonObject,
                function (result) {
                    var resultData = $.parseJSON(JSON.stringify(result));
                    if (resultData) {
                        misAlert("Your training session nominations opening has been " + (status == 2 ? "deactivated" : "activated") + " successfully.", "Success", "success");
                        bindTrainings();
                    }
                    else
                        misAlert('Your request cannot be processed, please try after some time or contact to MIS team for further assistance.', 'Error', 'error');
                });
        }
    });
}
function bindPendingTrainingRequests() {
    calltoAjax(misApiUrl.getTrainingRequests, "POST", '',
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#tblTrainingRequest").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'Training nominees List',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'Training nominees List' },
                        { extend: 'pdf', filename: 'Training nominees List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                        { extend: 'print', filename: 'Training nominees List' },
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
                        "mData": "AppliedBy",
                        "sTitle": "Nominee",
                        // "sWidth": "200px"

                    },
                    {
                        "mData": "Title",
                        "sTitle": "Title"

                    },
                    {
                        "mData": "Description",
                        "sTitle": "Description",
                        "className": "none"

                    },

                    {
                        "mData": "TentativeDate",
                        "sTitle": "Tentative Date",

                    },
                    {
                        "mData": "CreatedDate",
                        "sTitle": "Applied On",

                    },

                    {
                        "mData": "Status",
                        "sTitle": "Status",

                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        "sClass": "text-center",
                        "sWidth": "100px",
                        mRender: function (data, type, row) {
                            var html = '<div>';
                            if (row.StatusId == 1 && row.ApproverId == row.UserId) {
                                html += '&nbsp;<button type="button" class="btn btn-sm btn-info" onclick="viewRemarksPopup(\'' + row.TrainingDetailId + '\',2' + ')" data-toggle="tooltip" title="Approve"><i class="fa fa-check"> </i></button>';
                                html += '&nbsp;<button type="button" class="btn btn-sm btn-danger" onclick="viewRemarksPopup(\'' + row.TrainingDetailId + '\',3' + ')" data-toggle="tooltip" title="Reject"><i class="fa fa-times"> </i></button>';

                            }
                            else
                                html += '&nbsp;</div>';
                            return html;
                        }
                    },
                ]
            });
        });
}
function viewRemarksPopup(trainingDetailId, status) {
    $("#mypopupRemark").modal('show');
    _trainingDetailId = trainingDetailId;
    _status = status;
}
$("#btnRemarkClose").click(function () {
    $("#mypopupRemark").modal("hide");
    $("#trainingRemark").removeClass('error-validation');
    $("#trainingRemark").val("");
});
$("#submitTrainingRemark").click(function () {
    if (!validateControls('mypopupRemark')) {
        return false;
    }

    var jsonObject = {
        trainingDetailId: _trainingDetailId,
        statusId: _status,
        remarks: $("#trainingRemark").val()
    }
    calltoAjax(misApiUrl.takeActionOnTrainingRequest, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            if (resultData) {
                misAlert("Training request has been " + (_status == 2 ? "approved" : "rejected") + " successfully.", "Success", "success");
                $("#mypopupRemark").modal("hide");
                $("#trainingRemark").val("");
                //bindTrainings();
                bindPendingTrainingRequests();
                bindReviewdTrainingRequests();
            }
            else
                misAlert('Your request cannot be processed, please try after some time or contact to MIS team for further assistance.', 'Error', 'error');
        });

});
$("#buttonRemarkClose").click(function () {
    $("#mypopupRemark").modal("hide");
    $("#trainingRemark").removeClass('error-validation');
    $("#trainingRemark").val("");
});
function bindReviewdTrainingRequests() {
    calltoAjax(misApiUrl.getReviwedTrainingRequests, "POST", '',
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#tblRespondedRequest").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'Training nominees List',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'Training nominees List' },
                        { extend: 'pdf', filename: 'Training nominees List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                        { extend: 'print', filename: 'Training nominees List' },
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
                        "mData": "AppliedBy",
                        "sTitle": "Nominee",
                        // "sWidth": "200px"

                    },
                    {
                        "mData": "Description",
                        "sTitle": "Description",
                        "className": "none"

                    },
                    {
                        "mData": "Title",
                        "sTitle": "Title"

                    },
                    {
                        "mData": "TentativeDate",
                        "sTitle": "Tentative Date",

                    },
                    {
                        "mData": "CreatedDate",
                        "sTitle": "Applied On",

                    },
                    {
                        "mData": "Remarks",
                        "sTitle": "Remarks",

                    },
                    {
                        "mData": "Status",
                        "sTitle": "Status",

                    },

                ],
                "fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {

                    if (aData.StatusId == "4") {
                        $('td', nRow).css('background-color', '#c2cbd2');
                    }
                    else if (aData.StatusId == "3") {
                        $('td', nRow).css('background-color', '#f3a0a0');
                    }
                }
            });
        });
}