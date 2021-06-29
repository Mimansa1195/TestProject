$(document).ready(function () {
    BindTeamAppraisal(4);
    fetchAppraisalCycleFilter(misSession.currentappraisalcycleid);

    $(".appraisal-data button").on('click', function () {
        $(".appraisal-data button").removeClass("active");
        $(this).addClass("active");
        var fetchFor = $(this).attr("data-attr-state");
        var fetchForId;
        if (fetchFor == "Either") {
            fetchForId = 4;
        }
        else if (fetchFor == "AppraiserL1") {
            fetchForId = 1;
        }
        else if (fetchFor == "ApproverL2") {
            fetchForId = 2;
        }
        else {
            fetchForId = 3
        }
        BindTeamAppraisal(fetchForId);
    });
});

function fetchAppraisalCycleFilter(selectedId) {
    $('#ddlAppraisalCycleMaster').empty();
    calltoAjax(misApiUrl.getAppraisalCycleList, "POST", '',
            function (result) {
                if (result != null && result.length > 0) {
                    $('#ddlAppraisalCycleMaster').append("<option value = 0>All</option>");
                    for (var x = 0; x < result.length; x++) {
                        $('#ddlAppraisalCycleMaster').append("<option value = '" + result[x].Value + "'>" + result[x].Text + "</option>");
                    }
                    if (selectedId > 0) {
                        $('#ddlAppraisalCycleMaster').val(selectedId);
                    }
                }
            });
}

function BindTeamAppraisal(fetchForId) {
    var JsonObject = {
        IsTeamData: true,
        AppraisalCycleId: $("#ddlAppraisalCycleMaster").val() || misSession.currentappraisalcycleid,
        AppraisalSettingId: 0,
        LocationId: 0,
        VerticalIds: 1,
        DivisionIds: null,
        DepartmentIds: null,
        TeamIds: null,
        EmployeeId: 0,
        FetchForId: fetchForId,
        userAbrhs: null
    };
    calltoAjax(misApiUrl.getEmpAppraisalSetting, "POST", JsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $('#tblTeamAppraisal').DataTable({
                "responsive": true,
                "autoWidth": false,
                "paging": true,
                "bDestroy": true,
                "searching": true,
                "ordering": true,
                "order": [],
                "info": true,
                "deferRender": true,
                "aaData": resultData,
                "aoColumns": [
                     {
                         "mData": null,
                         "sTitle": "Image",
                         "sClass": "text-center",
                         mRender: function (data, type, row) {
                             return "<td class='halign-center'><img  onerror=\"this.src='../img/avatar-sign.png'\"  src='" + misApiProfileImageUrl + data.EmployeePhotoName + "' class='img-circle' alt='User Image'><br/><b>" + data.EmployeeName + "</b></a><br/>" + data.DesignationName + "</td>";
                         }
                     },
                     {
                         "mData": null,
                         "sTitle": "Details",
                         mRender: function (data, type, row) {
                             var htmldetails = "<td class='labels'>";
                             htmldetails += "<strong>Appraiser</strong> <span class='text-color'>" + data.AppraiserName + "</span><br/> ";
                             if (data.Approver1Name != null && data.Approver1Name != '') {
                                 htmldetails += "<strong>Approver</strong> <span class='text-color'>" + data.Approver1Name + "</span><br/> ";
                             }
                             if (data.Approver2Name != null && data.Approver2Name != '') {
                                 htmldetails += "<strong>Approver 2</strong> <span class='text-color'>" + data.Approver2Name + "</span><br/>";
                             }
                             if (data.Approver3Name != null && data.Approver3Name != '') {
                                 htmldetails += "<strong>Approver 3</strong> <span class='text-color'>" + data.Approver3Name + "</span><br/> ";
                             }
                             htmldetails += "<strong>Status</strong> <span class='text-color'><a class='showForm small-text-value' data-toggle='tooltip' href='javascript:void(0);' title='" + data.AppraisalStatusName + "'  onclick='showStatusHistory(" + data.EmpAppraisalSettingId + ")'>" + data.AppraisalStatusName + "</a></span><br/>";
                             if (data.IsVisible == true) {
                                 htmldetails += "<div> <strong>Appraisal Form</strong> <span class='text-color'><a class='showForm small-text-value appraisal-form-btn' data-toggle='tooltip' title='" + data.CompetencyFormName + "' href='javascript:void(0);' onclick='openForm(" + data.EmpAppraisalSettingId + ")'>" + data.CompetencyFormName + "</a></span></div><br/>"; //" + (Hashing.keyExists("tabId") ? Hashing.get('tabId') : 0) + "
                             }
                             else {
                                 htmldetails += "<div><strong>Appraisal Form</strong> <span data-toggle='tooltip' title='" + data.CompetencyFormName + "' class='text-color small-text-value'>" + data.CompetencyFormName + "</span></div><br/>";
                             }
                             htmldetails += "</td>";
                             return htmldetails;
                         }
                     },
                       {
                           "mData": null,
                           "sTitle": "Details",
                           mRender: function (data, type, row) {
                               var dates = "<td class='labels'>";
                               if (misSession.currentappraisalcycleid == data.AppraisalCycleId)
                                   dates += "<strong>Appraisal Cycle</strong> <span class='label label-success'>" + data.AppraisalCycleName + "</span><br/> ";
                               else
                                   dates += "<strong>Appraisal Cycle</strong> <span class='label label-danger'>" + data.AppraisalCycleName + "</span><br/> ";

                               dates += "<strong>Self Appraisal</strong> <span class='text-color'>" + ((data.IsSelfAppraisal == true) ? 'Yes' : 'No') + "</span><br/>";
                               dates += "<strong>Appraisal Starts From</strong> <span class='text-color'>" + data.StartDate + "</span><br/>";
                               if (data.AppraisalStatges != '') {
                                   $.each(data.AppraisalStatges.split(","), function (key, splitvalue) {
                                       var b = splitvalue.split("#");
                                       if (b[0] == 1) {
                                           dates += "<strong>Self Appraisal End Date</strong> <span class='text-color'>" + b[1] + "</span><br/>";
                                       }
                                       if (b[0] == 2) {
                                           dates += "<strong>Appraiser Review End Date</strong> <span class='text-color'>" + b[1] + "</span><br/>";
                                       }
                                       if (b[0] == 3) {
                                           dates += "<strong>Approval End Date</strong> <span class='text-color'>" + b[1] + "</span><br/>";
                                       }
                                       if (b[0] == 4) {
                                           dates += "<strong>Accept/Closure End Date</strong> <span class='text-color'>" + b[1] + "</span><br/>";
                                       }
                                   });
                               }
                               dates += "<strong>Appraisal Ends By</strong> <span class='text-color'>" + data.EndDate + "</span><br/>";
                               dates += "</td>";
                               return dates;
                           }
                       },
                        {
                            "mData": null,
                            "sTitle": "Action",
                            mRender: function (data, type, row) {
                                var html1 = "";
                                if (parseInt(data.AppraisalStatusId) != 6 && parseInt(data.AppraisalStatusId) != 7 && misSession.currentappraisalcycleid == data.AppraisalCycleId) {
                                    html1 += "<div class='col-md-12'><button type ='button' class='btn btn-primary' id ='btnstatus' value='Dismiss Appraisal'  data-toggle='tooltip' title='Dismiss Appraisal'    onclick='UpdateStatusNew(" + data.EmpAppraisalSettingId + "," + data.AppraisalStatusId + "," + data.AppraiserId + "," + data.Approver1 + "," + data.IsSelfAppraisal + ",\"D\")' ><i class='fa fa-remove'></i></button> </div>";
                                }
                                else if (parseInt(data.AppraisalStatusId) == 7 && misSession.currentappraisalcycleid == data.AppraisalCycleId) {
                                    html1 += "Appraisal Dismissed";
                                    if (parseInt(data.AppraiserId) == parseInt($('#hdnLoginUserId').val())) {
                                        html1 += "<div class='col-md-12'>  <button type ='button' class='btn btn-primary' id ='btnRegenerate' value='Regenerate' data-toggle='tooltip' title='Regenrate'   onclick='UpdateStatusNew(" + data.EmpAppraisalSettingId + "," + data.AppraisalStatusId + "," + data.AppraiserId + "," + data.Approver1 + "," + data.IsSelfAppraisal + ",\"R\")' ><i class='fa fa-hand-pointer-o'></i></button></div>";
                                    }
                                }
                                return html1;
                            }
                        }
                ],
            });
        });
}

function showStatusHistory(empAppraisalSettingId) {
    BindStatusHistory(empAppraisalSettingId);
    $('#popupAppraisalHirtory').modal('show');
}

function BindStatusHistory(empAppraisalSettingId) {
    var JsonObject = {
        empAppraisalSettingId: empAppraisalSettingId,
        userAbrhs: misSession.userabrhs
    };
    calltoAjax(misApiUrl.getStatusHistory, "POST", JsonObject,
          function (result) {
              var resultdata = $.parseJSON(JSON.stringify(result));
              $('#grdappraisalHirtory').DataTable({
                  "bDestroy": true,
                  "bPaginate": false,
                  "bFilter": false,
                  "info": false,
                  "aaData": resultdata,
                  "aoColumns": [
                      { "sTitle": "#", "mData": "RowNo" },
                      { "sTitle": "Date", "mData": "Date", "sWidth": "125px" },
                      { "sTitle": "Appraisal Status", "mData": "FeedbackStatusName" },
                      { "sTitle": "Description", "mData": "Description" },
                      { "sTitle": "Comment", "mData": "Comment" },
                  ],
              });
          });
}

$("#btnClose").click(function () {
    $('#popupAppraisalHirtory').modal('hide');
});

function UpdateStatusNew(empAppraisalSettingId, AppraisalStatusId, AppraiserId, Approver1, IsSelfAppraisaer, Status) {
    misAlert("Dismiss appraisal feature is temporarily disabled.", "Sorry", "warning");

    //var Message;
    //if (Status == 'D') {
    //    Message = 'Are you sure you want to dismiss appraisal for this employee?';
    //}
    //else {
    //    Message = 'Are you sure you want to regenrate appraisal for this employee?';
    //}
    //var reply = misConfirm(Message, "Confirm", function (reply) {
    //    if (reply) {
    //        var JsonObject = {
    //            empAppraisalSettingId: parseInt(empAppraisalSettingId),
    //            statusId: Status,
    //            resonForDissmiss: '',
    //            userAbrhs: misSession.userabrhs
    //        };
    //        calltoAjax(misApiUrl.updateStatus, "POST", JsonObject,
    //              function (result) {

    //              });
    //    }
    //});
}

function ViewHistory() {
    window.open('/ViewHistory/History?userId=' + $('#hdnLoginUserId').val());
}

function openCompetencyForm(empAbrhs) {
    var JsonObject = {
        empAbrhs: empAbrhs,
        userAbrhs: misSession.userabrhs
    };
    calltoAjax(misApiUrl.empHistory, "POST", JsonObject,
          function (result) {
              $('#empHirtoryTA').modal('show');
              $('#grdempHirtoryTAGrid').html(result);
          });
}

//$('#btnSaveDissmissData').click(function () {
//    if (!validateControls('dissmissModel')) {
//        return false;
//    }
//    var empAppraisalSettingId = $('#hdnempAppraisalSettingId').val();
//    var statusID = $('#hdnStatus').val();
//    var data = {
//        empAppraisalSettingId: parseInt(empAppraisalSettingId),
//        statusId: statusID,
//        resonForDissmiss: $('#txtReason').val(),
//        TransById: parseInt($('#hdnLoginUserId').val()),
//    }
//    $('#dissmissModel').modal('hide');
//    ajaxPostcall("POST", data, "/AppraisalTeam/UpdateStatus", IsDataUpdate);
//});


function openForm(empAppraisalSettingId) {
    $("#hdnEmpAppraisalSettingId").val(empAppraisalSettingId);
    loadModal("teamAppraisalFormPopup", "modalBodyAppraisalForm", misAppUrl.appraisalFormUpperlevel, true);
}