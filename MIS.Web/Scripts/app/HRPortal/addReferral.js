var _resume = "";
var _detailId = 0;
var _referredById = 0;
var _referralId = 0;
var rId = 0;
var _isFwdAll = false;
$(document).ready(function () {
    bindReferrals();
});
function showAddReferralPopup() {
    $("#mypopupAddReferral").modal("show");
    $("#position").val("");
    $("#jobDescription").val("");
    var FromDate = new Date();
    FromDate.setDate(FromDate.getDate());
    $("#fromDateEmp").val(toddmmyyyDatePicker(FromDate));
    $("#tillDate input").val();
    $('#fromDate').datepicker({
        format: "mm/dd/yyyy",
        autoclose: true,
        todayHighlight: true,
    }).datepicker('setStartDate', new Date()).trigger('change');
    $('#fromDate').datepicker({
        format: "mm/dd/yyyy",
        autoclose: true,
        todayHighlight: true,
    }).on('changeDate', function (ev) {
        $('#tillDate input').val('');
        $('#tillDate').datepicker('setStartDate', $("#fromDate input").val()).trigger('change');
    });
    $('#tillDate').datepicker({
        format: "mm/dd/yyyy",
        autoclose: true,
        todayHighlight: true
    }).on('changeDate', function (ev) {
        $('#tillDate').datepicker('setStartDate', $("#fromDate input").val()).trigger('change');

    });
}
$("#btnEditClose").click(function () {
    $("#editPopup").modal("hide");
    $("#positionEdit").removeClass('error-validation');
    $("#jobDescriptionEdit").removeClass('error-validation');
    $("#fromDateEmpEdit").removeClass('error-validation');
    $("#tillDateEmpEdit").removeClass('error-validation');
    $("#fromDateEdit").val("");
    $("#fromDateEmpEdit").val("");
    $("#tillDateEdit").val("");
    $("#tillDateEmpEdit").val("");
    $("#jobDescriptionEdit").val("");
    $("#positionEdit").val("");
});
$("#buttonClose").click(function () {
    $("#mypopupAddReferral").modal("hide");
    $("#position").removeClass('error-validation');
    $("#jobDescription").removeClass('error-validation');
    $("#fromDateEmp").removeClass('error-validation');
    $("#tillDateEmp").removeClass('error-validation');
    $("#fromDate").val("");
    $("#fromDateEmp").val("");
    $("#tillDate").val("");
    $("#tillDateEmp").val("");
    $("#jobDescription").val("");
    $("#position").val("");
});
$("#btnClose").click(function () {
    $("#mypopupAddReferral").modal("hide");
    $("#position").removeClass('error-validation');
    $("#jobDescription").removeClass('error-validation');
    $("#fromDateEmp").removeClass('error-validation');
    $("#tillDateEmp").removeClass('error-validation');
    $("#fromDate").val("");
    $("#fromDateEmp").val("");
    $("#tillDate").val("");
    $("#tillDateEmp").val("");
    $("#jobDescription").val("");
    $("#position").val("");
});
$("#btnViewClose").click(function () {
    $("#modalViewReferees").modal("hide");
});
$("#btnSaveReferral").click(function () {
    if (!validateControls('mypopupAddReferral')) {
        return false;
    }
    var jsonObject = {
        fromDate: $("#fromDateEmp").val(),
        endDate: $("#tillDateEmp").val(),
        position: $("#position").val(),
        description: $("#jobDescription").val(),
        userAbrhs: misSession.userabrhs
    }
    calltoAjax(misApiUrl.addReferral, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            switch (resultData) {
                case 1:
                    misAlert("Job posts added successfully", "Success", "success");
                    $("#mypopupAddReferral").modal('hide');
                    $("#fromDate").val("");
                    $("#fromDateEmp").val("");
                    $("#tillDate").val("");
                    $("#tillDateEmp").val("");
                    $("#jobDescription").val("");
                    $("#position").val("");
                    bindReferrals();
                    break;
                case 2:
                    misAlert("Job posts with this position already exists. Please check.", "Warning", "warning");
                    $("#mypopupAddReferral").modal('hide');
                    $("#fromDate").val("");
                    $("#fromDateEmp").val("");
                    $("#tillDate").val("");
                    $("#tillDateEmp").val("");
                    $("#jobDescription").val("");
                    $("#position").val("");
                    break;
                case 0:
                    misAlert("Unable to process request. Try again", "Error", "error");
                    $("#mypopupAddReferral").modal('toggle');
                    break;
            }
        });
});
function bindReferrals() {
    var jsonObject = {
        userAbrhs: misSession.userabrhs,
    }
    calltoAjax(misApiUrl.getAllReferral, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $("#tblReferral").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'Job Openings List',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'Job Openings List' },
                        { extend: 'pdf', filename: 'Job Openings List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                        { extend: 'print', filename: 'Job Openings List' },
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
                        "mData": "Position",
                        "sTitle": "Position",

                    },
                    {
                        "mData": "Description",
                        "sTitle": "Key Skills",
                        "sWidth": "300px"
                    },
                    {
                        "mData": null,
                        "sTitle": "Openings From",
                        mRender: function (data, type, row) {
                            return moment(row.FromDate).format('DD MMM YYYY');
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Openings Till",
                        mRender: function (data, type, row) {
                            return moment(row.EndDate).format('DD MMM YYYY');
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Created Date",
                        "className": "none",
                        //"sWidth": "200px",
                        mRender: function (data, type, row) {
                            return moment(row.CreatedDate).format('DD MMM YYYY');
                        }
                    },
                    {
                        "mData": "IsExpired",
                        "sTitle": "Is Open", "orderable": false,
                        mRender: function (data, type, row) {
                            if (row.IsExpired === true)
                                return '<span class="label label-danger"> <i class="fa fa-times"></i> </span>';
                            else
                                return '<span class="label label-info"> <i class="fa fa-check"></i> </span>';
                        }
                    },
                    {
                        "mData": "Count",
                        "sTitle": "Referrals",
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        "sClass": "text-center",
                        "sWidth": "300px",
                        mRender: function (data, type, row) {
                            var q = new Date();
                            var m = q.getMonth() + 1;
                            var d = q.getDate();
                            var y = q.getFullYear();
                            var tDate = (m > 9 ? '' : '0') + m + '/' + (d > 9 ? '' : '0') + d + '/' + y;
                            var tFullDate = new Date(tDate);
                            var myDate = row.EndDate.slice(0, 10);
                            var myFullDate = new Date(myDate);
                            var _newDate = row.EndDate;
                            var html = '<div>';
                            html += '&nbsp;<button type="button" class="btn btn-sm btn-success" onclick="viewReferralPopup(\'' + row.ReferralId + '\',\'' + row.Position + '\')" data-toggle="tooltip" title="View"><i class="fa fa-eye"> </i></button>';
                            html += '&nbsp;<button type="button" class="btn btn-sm teal" onclick="editReferralPopup(\'' + row.ReferralId + '\')" data-toggle="tooltip" title="Edit"><i class="fa fa-pencil"> </i></button>';
                            if (row.IsExpired == false && myFullDate >= tFullDate) {
                                html += '&nbsp;<button type="button" class="btn btn-sm btn-danger" onclick="changeReferralStatus(\'' + row.ReferralId + '\',2' + ')" data-toggle="tooltip" title="Close Position"><i class="fa fa-times"> </i></button>';

                            } else if (row.IsExpired == true && myFullDate >= tFullDate) {
                                html += '&nbsp;<button type="button" class="btn btn-sm btn-warning" onclick="changeReferralStatus(\'' + row.ReferralId + '\',1' + ')" data-toggle="tooltip" title="Open Position"><i class="fa fa-check"> </i></button>';
                            }
                            return html;
                        }
                    },
                ]
            });
        });
}
function editReferralPopup(referralId) {
    rId = referralId;
    var FromDate = new Date();
    FromDate.setDate(FromDate.getDate());
    // $("#fromDateEmpEdit").val(toddmmyyyDatePicker(FromDate));
    $("#tillDateEdit input").val();
    $('#fromDateEdit').datepicker({
        format: "mm/dd/yyyy",
        autoclose: true,
        todayHighlight: true,
    }).datepicker('setStartDate', new Date()).trigger('change');
    $('#fromDateEdit').datepicker({
        format: "mm/dd/yyyy",
        autoclose: true,
        todayHighlight: true,
    }).on('changeDate', function (ev) {
        $('#tillDateEdit input').val('');
        $('#tillDateEdit').datepicker('setStartDate', $("#fromDateEdit input").val()).trigger('change');
    });
    $('#tillDateEdit').datepicker({
        format: "mm/dd/yyyy",
        autoclose: true,
        todayHighlight: true
    }).on('changeDate', function (ev) {
        $('#tillDateEdit').datepicker('setStartDate', $("#fromDateEdit input").val()).trigger('change');

    });

    var jsonObject = {
        referralId: referralId,
        userAbrhs: misSession.userabrhs
    }
    calltoAjax(misApiUrl.viewReferralDetails, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            var fda = new Date(resultData.FromDate);
            //var m = fda.getMonth() + 1;
            //var d = fda.getDate();
            //var y = fda.getFullYear();
            //var fromDate = (m > 9 ? '' : '0') + m + '/' + (d > 9 ? '' : '0') + d + '/' + y;
            var tda = new Date(resultData.EndDate);
            //var tm = tda.getMonth() + 1;
            //var td = tda.getDate();
            //var ty = tda.getFullYear();
            //var endDate = (tm > 9 ? '' : '0') + tm + '/' + (td > 9 ? '' : '0') + td + '/' + ty;
            $("#fromDateEmpEdit").val(toddmmyyyDatePicker(fda));
            $("#tillDateEmpEdit").val(toddmmyyyDatePicker(tda));
            $("#positionEdit").val(resultData.Position);
            $("#jobDescriptionEdit").val(resultData.Description);
            $("#editPopup").modal("show");
        });
}
$("#btnEditReferral").click(function () {
    if (!validateControls('editPopup')) {
        return false;
    }
    var jsonObject = {
        fromDate: $("#fromDateEmpEdit").val(),
        endDate: $("#tillDateEmpEdit").val(),
        position: $("#positionEdit").val(),
        description: $("#jobDescriptionEdit").val(),
        referralId: rId,
        userAbrhs: misSession.userabrhs
    };
    calltoAjax(misApiUrl.updateReferrals, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            switch (resultData) {
                case 1:
                    misAlert("Referral has been updated successfully", "Success", "success");
                    $("#editPopup").modal('hide');
                    bindReferrals();
                    break;
                case 2:
                    misAlert("Referral does not Exist.", "Warning", "warning");
                    break;
            }
        });
});
function changeReferralStatus(referralId, status) {
    var jsonObject = {
        referralId: referralId,
        status: status,
        userAbrhs: misSession.userabrhs
    }
    misConfirm("Are you sure you want to " + (status == 2 ? "deactivate" : "activate") + " this opening?", "Confirm", function (isConfirmed) {
        if (isConfirmed) {
            calltoAjax(misApiUrl.changeReferralStatus, "POST", jsonObject,
                function (result) {
                    var resultData = $.parseJSON(JSON.stringify(result));

                    if (resultData) {
                        misAlert("Your form has been " + (status == 2 ? "deactivated" : "activated") + " successfully.", "Success", "success");
                        bindReferrals();
                    }
                    else
                        misAlert('Your request cannot be processed, please try after some time or contact to MIS team for further assistance.', 'Error', 'error');
                });
        }
    });
}
function viewReferralPopup(referralId, position) {
    document.getElementById("header").innerHTML = "View Referees For " + position + "";
    $("#modalViewReferees").modal("show");
    $('#tblViewReferral').empty();
    bindRequestedReferrals(referralId);
}
function bindRequestedReferrals(referralId) {
    _referralId = referralId;
    var jsonObject = {
        referralId: referralId,
        userAbrhs: misSession.userabrhs,
    }
    calltoAjax(misApiUrl.getAllRequestedReferrals, "POST", jsonObject,
        function (result) {
            //console.log(result)
            var resultData = $.parseJSON(JSON.stringify(result));
            /* Formatting function for row details */
            function format(JsonDataList) {
                //console
                if (JsonDataList.length > 0) {
                    var html = '<table class="tbl-typical fixed-header text-left"><thead><tr><th> <div>Forwarded To</div></th><th><div>Forwarded On</div></th><th><div>Status</div></th><th><div>Reminder<i class="fa fa-bell"></i></div></th></tr></thead> <tbody>';

                    for (var j = 0; j < JsonDataList.length; j++) {
                        if (JsonDataList[j].IsRelevant == 1)
                            html += '<tr><td>' + JsonDataList[j].ForwardedTo + '</td><td>' + (JsonDataList[j].ForwardedOn).slice(0, 11) + '</td><td>Relevant</td><td>Responded</td></tr>';
                        else if (JsonDataList[j].IsRelevant == 0)
                            html += '<tr><td>' + JsonDataList[j].ForwardedTo + '</td><td>' + (JsonDataList[j].ForwardedOn).slice(0, 11) + '</td><td>Irrelevant</td><td>Responded</td></tr>';
                        else
                            html += '<tr><td>' + JsonDataList[j].ForwardedTo + '</td><td>' + (JsonDataList[j].ForwardedOn).slice(0, 11) + '</td><td>Pending</td><td><button type="button" class="btn btn-sm btn-default" onclick="sendReminder(\'' + JsonDataList[j].ReferralReviewId + '\')" data-toggle="tooltip" title="Send Reminder"><i class="fa fa-envelope" style="color:#b348ae"></i></button></td></tr>';
                    }
                    html += '</tbody></table>';
                    return html;
                }

            }
            var table = $('#tblViewReferral').DataTable({

                "dom": 'lBfrtip',
                "responsive": true,
                "autoWidth": false,
                "paging": true,
                "bDestroy": true,
                "ordering": true,
                "info": true,
                "deferRender": true,
                "buttons": [
                    {
                        filename: 'Referrals List',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'Referrals List' },
                        { extend: 'pdf', filename: 'Referrals List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                        { extend: 'print', filename: 'Referrals List' },
                        ]
                    }
                ],
                "aaData": resultData,

                "aoColumns": [
                    {

                        "className": 'details-control',
                        "orderable": false,
                        "mData": null,
                        "defaultContent": ''
                    },
                    {
                        "mData": "ReferredBy",
                        "sTitle": "Referred By",
                    },
                    {
                        "mData": "RefereeName",
                        "sTitle": "Referee Name",
                    },
                    {
                        "mData": null,
                        "sTitle": "Referred On",
                        mRender: function (data, type, row) {
                            return moment(row.CreatedDate).format('DD MMM YYYY');
                        }
                    },
                    {
                        "mData": "Resume",
                        "sTitle": "Resume",
                        "sWidth": "320px",

                    },
                    {
                        "mData": "null",
                        "sTitle": "Forwarded",
                        "sWidth": "80px",
                        mRender: function (data, type, row) {
                            return row.JsonDataList.length;
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        "sClass": "text-center",
                        "sWidth": "200px",
                        mRender: function (data, type, row) {
                            var html = '<div>';

                            if (misPermissions.hasViewRights === true) {
                                var extention = getFileExtension(row.Resume);
                                html += '&nbsp;<button type="button" class="btn btn-sm btn-success" onclick="fwdReferralInformation(\'' + row.Resume + '\' ,\'' + row.ReferalDetailId + '\',\'' + row.ReferredById + '\')" data-toggle="tooltip" title="Forward"><i class="fa fa-arrow-circle-right"> </i></button>';
                                html += '&nbsp;<button type="button" class="btn btn-sm teal" onclick="fetchReferralInformation(\'' + row.Resume + '\' ,\'' + row.ReferalDetailId + '\',\'' + row.ReferredById + '\')" data-toggle="tooltip" title="Download"><i class="fa fa-download"> </i></button>';
                                if (extention == "pdf") {
                                    html += '&nbsp; <button type="button" class="btn btn-sm success" data-toggle"model" data-target="#mypopupViewDocModal" onclick="viewResumeInPopup(\'' + row.Resume + '\' , \'' + row.ReferalDetailId + '\' ,' + row.ReferredById + ')" data-toggle="tooltip" title="View"><i class="fa fa-eye"> </i></button>';
                                }
                            }

                            return html;
                        }
                    },
                ], "rowCallback": function (row, data) {
                    if (data.JsonDataList.length == 0) {
                        $('td:eq(0)', row).removeClass("details-control");
                    } else {
                    }
                }, "order": [[1, 'asc']]
            });

            // Add event listener for opening and closing details
            $('#tblViewReferral tbody').on('click', 'td.details-control', function () {
                var tr = $(this).closest('tr');
                var row = table.row(tr);

                if (row.child.isShown()) {
                    row.child.hide();
                    $("#tblViewReferral tbody tr").removeClass('shown expand');
                }

                else {
                    table.rows().eq(0).each(function (idx) {
                        var row = table.row(idx);
                        if (row.child.isShown()) {
                            row.child.hide();
                        }
                    });
                    row.child(format(row.data().JsonDataList)).show();
                    $("#tblViewReferral tbody tr").removeClass('shown expand');
                    tr.addClass('shown expand');

                }
            });
        });
}
function fwdReferralInformation(resume, detailId, referredById) {
    _isFwdAll = false;
    _resume = resume;
    _detailId = detailId;
    _referredById = referredById;
    $("#modalForwardReferees").modal("show");
    bindAllReviewers(detailId);
    $("#message").val("Please review the resume of the referee and mark relevant or irrelevant for the same.");
}
$("#btnFwdClose").click(function () {
    $("#modalForwardReferees").modal("hide");
});
function bindAllReviewers(detailId) {
    var jsonObject = {
        detailId: detailId
    }
    calltoAjax(misApiUrl.getReviewers, "POST", jsonObject,
        function (result) {
            $('#reviewersName').multiselect("destroy");
            $('#reviewersName').empty();
            $.each(result, function (index, value) {
                $('<option>').val(value.EmployeeAbrhs).text(value.EmployeeName).appendTo('#reviewersName');
            });
            $('#reviewersName').multiselect({
                includeSelectAllOption: false,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                buttonWidth: false,
                onDropdownHidden: function (event) {
                }
            });
        });
}
function sendMailForReferrals() {
    var empIds = (($('#reviewersName').val() !== null && typeof $('#reviewersName').val() !== 'undefined' && $('#reviewersName').val().length > 0) ? $('#reviewersName').val().join(',') : '0');

    if (_isFwdAll == true) {
        var jsonObject = {
            referralId: _referralId,
            empIds: empIds,
            message: $("#message").val(),
            appLinkUrl: misAppUrl.actionOnForwardedReferral,
            userAbrhs: misSession.userabrhs
        };
        calltoAjax(misApiUrl.forwardAllReferrals, "POST", jsonObject, function (result) {

            if (result === 1) {
                misAlert("Referrals has been forwarded successfully", "Success", "success");

            }
            $("#modalForwardReferees").modal("hide");
            bindRequestedReferrals(_referralId);
        });
    }
    else {
        var jsonObject = {
            detailId: _detailId,
            resume: _resume,
            referredById: _referredById,
            empIds: empIds,
            message: $("#message").val(),
            appLinkUrl: misAppUrl.actionOnForwardedReferral,
            userAbrhs: misSession.userabrhs
        };
        calltoAjax(misApiUrl.forwardReferrals, "POST", jsonObject, function (result) {

            if (result === 1) {
                misAlert("Referrals has been forwarded successfully", "Success", "success");

            }
            $("#modalForwardReferees").modal("hide");
            bindRequestedReferrals(_referralId);
        });
    }
}

function sendReminder(reviewId) {
    var jsonObject = {
        reviewId: reviewId,

    };
    calltoAjax(misApiUrl.sendReminder, "POST", jsonObject, function (result) {

        if (result === 1) {
            misAlert("Reminder for referral review has been sent successfully.", "Success", "success");

        }
        bindRequestedReferrals(_referralId);
    });
}
function fetchReferralInformation(resume, detailId, referredById) {
    var jsonObject = {
        referralDetailId: detailId,
        referredById: referredById
    }
    calltoAjax(misApiUrl.fetchReferralInformation, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            if (resultData != null && resultData != '') {
                downloadFileFromBase64(resume, resultData);
            }
            else {
                misAlert('The file you have requested does not exist. Please try after some time or contact to MIS team for further assistance.', 'Oops...', 'info');

            }
        });
}
function viewResumeInPopup(resume, detailId, referredBy) {
    var extention = getFileExtension(resume);
    var jsonObject = {
        detailId: detailId,
        referredById: referredBy
    }
    calltoAjax(misApiUrl.viewResume, "POST", jsonObject,
        function (resultData) {
            if (resultData != null && resultData != '') {
                if (extention == "pdf") {
                    $("#objViewPdf").attr("data", resultData);
                    document.getElementById("header1").innerHTML = resume;
                    //$("#modalTitle").html(resume);
                    $("#viewDocumentModal").modal("show");
                }
                else {
                    downloadFileFromBase64(resume, resultData);
                }
            }
            else {
                misAlert('The file you have requested does not exist. Please try after some time or contact to MIS team for further assistance.', 'Oops...', 'info');
            }
        });
}


$("#btnViewFwdAll").click(function () {
    _isFwdAll = true;
    $("#modalForwardReferees").modal("show");
    bindReviewersFwdAll();
    $("#message").val("Please review the resume of the referee and mark relevant or irrelevant for the same.");
});

function bindReviewersFwdAll() {
    calltoAjax(misApiUrl.getReviewersToForward, "POST", "",
        function (result) {
            $('#reviewersName').multiselect("destroy");
            $('#reviewersName').empty();
            $.each(result, function (index, value) {
                $('<option>').val(value.EmployeeAbrhs).text(value.EmployeeName).appendTo('#reviewersName');
            });
            $('#reviewersName').multiselect({
                includeSelectAllOption: false,
                enableFiltering: true,
                enableCaseInsensitiveFiltering: true,
                buttonWidth: false,
                onDropdownHidden: function (event) {
                }
            });
        });
}