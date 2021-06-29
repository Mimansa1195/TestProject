$(document).ready(function () {
    BindMyAppraisal();
});

function openTechnicalCompetencyForm() {
    loadModal("addCompetencyForm", "addTechnicalCompetenciesContainer", misAppUrl.createTechnicalCompetencies, true);
}

function BindMyAppraisal() {
    var JsonObject = {
        AppraisalCycleId: 0,
        AppraisalSettingId: 0,
        LocationId: 0,
        VerticalIds: 1,
        DivisionIds: null,
        DepartmentIds: null,
        TeamIds: null,
        userAbrhs: misSession.userabrhs
    };
    calltoAjax(misApiUrl.getSelfAppraiselData, "POST", JsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            var ActualBindData = [];
            for (var i = 0; i < resultData.length; i++) {
                if (!resultData[i].IsFinalized && misSession.currentappraisalcycleid == resultData[i].AppraisalCycleId) {
                    $("#hdnCompetencyFormId").val(resultData[i].CompetencyFormId);
                    loadModal("addCompetencyForm", "addTechnicalCompetenciesContainer", misAppUrl.createTechnicalCompetencies, true);
                    $("#divAddTechnicalParamBtn").html('<a id="btnAddCompetencyForm" data-toggle="modal" class="btn btn-success pull-right" onclick="openTechnicalCompetencyForm()">Add/Update Technical Parameters</a>');
                }
                else {
                    ActualBindData.push(resultData[i]);
                }
            }
            $('#tblMyAppraisal').DataTable({
                "bDestroy": true,
                "bPaginate": false,
                "bFilter": false,
                "info": false,
                "ordering": false,
                "aaData": ActualBindData,
                "aoColumns": [
                     {
                         "mData": null,
                         "sTitle": "",
                         "sClass": "text-center",
                         mRender: function (data, type, row) {
                             return "<td class='halign-center'><img  onerror=\"this.src='../img/avatar-sign.png'\"  src='" + misApiProfileImageUrl + data.EmployeePhotoName + "' class='img-circle' alt='User Image'><br/>" + data.EmployeeName + "<br/>" + data.DesignationName + "</td>";
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
                             //htmldetails += "<strong>appraisee </strong> <span class='text-color'>" + data.EmployeeName + "</span><br/> ";
                             htmldetails += "<strong>HR</strong> <span class='text-color'>" + data.HRName + "</span><br/> ";
                             if (misSession.currentappraisalcycleid == data.AppraisalCycleId)
                                 htmldetails += "<strong>Appraisal Cycle</strong> <span class='label label-success'>" + data.AppraisalCycleName + "</span><br/> ";
                             else
                                 htmldetails += "<strong>Appraisal Cycle</strong> <span class='label label-danger'>" + data.AppraisalCycleName + "</span><br/> ";
                             htmldetails += "<strong>Status</strong> <span class='text-color'><a class='showForm small-text-value' data-toggle='tooltip' href='javascript:void(0);' title='" + data.AppraisalStatusName + "'  onclick='showStatusHistory(" + data.EmpAppraisalSettingId + ")'>" + data.AppraisalStatusName + "</a></span><br/>";
                             //htmldetails += "<strong>Self Appraisal</strong> <span class='text-color'>" + ((data.IsSelfAppraisal == true) ? 'Yes' : 'No') + "</span><br/>";
                             htmldetails += "</td>";
                             return htmldetails;
                         }
                     },
                      {
                          "mData": null,
                          "sTitle": "Details",
                          mRender: function (data, type, row) {
                              var htmldetails1 = "<td class='labels'>";
                              if (data.IsVisible == true) {

                                  htmldetails1 += "<strong>Appraisal Form</strong> <span class='text-color'><a class='showForm small-text-value appraisal-form-btn' data-toggle='tooltip' title='" + data.CompetencyFormName + "' href='javascript:void(0);' onclick='openForm(" + data.EmpAppraisalSettingId + ")'>" + data.CompetencyFormName + "</a></span><br/>";
                              }
                              else {
                                  htmldetails1 += "<strong>Appraisal Form</strong> <span data-toggle='tooltip' title='" + data.CompetencyFormName + "' class='text-color small-text-value'>" + data.CompetencyFormName + "</span><br/>";

                              }
                              htmldetails1 += "<strong>Self Appraisal</strong> <span class='text-color'>" + ((data.IsSelfAppraisal == true) ? 'Yes' : 'No') + "</span><br/>";

                              htmldetails1 += "<strong>Appraisal Starts From</strong> <span class='text-color'>" + data.StartDate + "</span><br/>";
                              if (data.AppraisalStatges != '') {

                                  $.each(data.AppraisalStatges.split(","), function (key, splitvalue) {

                                      var b = splitvalue.split("#");
                                      if (b[0] == 1) {
                                          htmldetails1 += "<strong>Self Appraisal End Date</strong> <span class='text-color'>" + b[1] + "</span><br/>";
                                      }
                                      if (b[0] == 2) {
                                          htmldetails1 += "<strong>Appraiser Review End Date</strong> <span class='text-color'>" + b[1] + "</span><br/>";
                                      }
                                      if (b[0] == 3) {
                                          htmldetails1 += "<strong>Approval End Date</strong> <span class='text-color'>" + b[1] + "</span><br/>";
                                      }
                                      if (b[0] == 4) {
                                          htmldetails1 += "<strong>Accept/Closure End Date</strong> <span class='text-color'>" + b[1] + "</span><br/>";
                                      }
                                  });
                              }
                              htmldetails1 += "<strong>Appraisal Ends By</strong> <span class='text-color'>" + data.EndDate + "</span><br/>";
                              htmldetails1 += "</td>";
                              return htmldetails1;
                          }
                      }
                ]
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

function openForm(empAppraisalSettingId) {
    $("#hdnEmpAppraisalSettingId").val(empAppraisalSettingId);
    loadModal("selfAppraisalFormPopup", "modalBodyAppraisalForm", misAppUrl.appraisalFormSelf, true);
}