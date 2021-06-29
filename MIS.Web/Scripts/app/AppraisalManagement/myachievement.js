var _achievementList, _isValid;
$(document).ready(function () {
    setAchievementsFinancialYear();
    $("#btnAddAchievement").click(function () {
        $("#viewAchievementModal").modal({
            backdrop: 'static',
            keyboard: false
        });
         var financialYear = $("#showAppraisalYear").val();
            $("#viewAchievementModal").modal('show');
            $("#dynamicAddAchievement").empty();
    });
      $("#btnAddNewAchievement").click(function () {
        if (!validateControls('dynamicAddAchievement')) {
            return false;
        }
        generateAchievementControls('dynamicAddAchievement');
      });
});

function getValidityFalgToAddAchievement() {
    var jsonObject = {
        goalCycleId: $("#showAchievementYear").val()
    };
    calltoAjax(misApiUrl.getValidityFalgToAddAchievement, "POST", jsonObject,
        function (result) {
            if (result) {
                $("#btnAddAchievement").show();
            }
            else {
                $("#btnAddAchievement").hide();
            }
        });
}

function generateAchievementControls(containerId, maxNoOfTextBoxes, minNoOfMandatoryTxtBoxes) {
    maxNoOfTextBoxes = maxNoOfTextBoxes || 40;
    if (containerId) {
        var txtCount = $("#" + containerId).find('.itemRow').length;
        if (txtCount < maxNoOfTextBoxes) {
            $("#" + containerId).append(getDynamicControls(txtCount, minNoOfMandatoryTxtBoxes || 1, ''));
        }
        else {
            misAlert("You can't add more than " + maxNoOfTextBoxes + " achievements!", 'Sorry', 'warning');
        }
    }
}

function getDynamicControls(idx, minNoOfMandatoryTxtBoxes, value) {
    return '<div class="col-md-12 itemRow" id = "dynamicAddAchievementDiv-' + idx + '">' +
        '<div class="row">' +
        '<div class="col-md-11"><div class="form-group"><label>Achievement Detail<span class="spnError">*</span></label><textarea rows="2" cols="6" class="form-control validation-required" placeholder="Enter your achievement " id="achievement' + idx + '" maxlength="4000" data-mask="" data-attr-name="r2"></textarea></div></div>' +
        '<div class="col-md-1" style="padding-top: 22px;"><span class="input-group-btn"><button class="btn btn-danger" style="background-color: #d2322d;" value="X" onclick="removeControls(this)">X</button></span></div>' +
        '</div></div>';
}

function removeControls(item) {
    $(item).closest('.itemRow').remove();
}
function setAchievementsFinancialYear() {
    var jsonObject = {
        forTeam: false
    }
    calltoAjax(misApiUrl.getAllGoalCycleIdToViewAchievement, "POST", jsonObject,
        function (result) {
            $("#showAchievementYear").empty();
            $("#showAchievementYear").append("<option value='0'>Select</option>");
            if (result.length > 0) {
                $.each(result, function (index, result) {
                    $("#showAchievementYear").append("<option value=" + result.GoalCycleId + ">" + result.FinancialYearName + "</option>");
                })
                $("#showAchievementYear").val(result[0].GoalCycleId);
                var FY = new Date(result[0].FyStartDate);
                var goalCycleId = result[0].GoalCycleId;
                var fromyear = FY.getFullYear();
                var endyear = fromyear + 1;
                $("#cntYear").html(fromyear);
                $("#nxtYear").html(endyear);
                $("#showAppraisalYear").val(fromyear + ' - ' + endyear);
                $("#txtHiddenGoalCycleId").val(goalCycleId);
                getValidityFalgToAddAchievement();
                getUserMidYearAchievement();
            }
        });
}
$("#showAchievementYear").on('change', function () {
    getValidityFalgToAddAchievement();
    getUserMidYearAchievement();
});

$("#btnSubmitAchievement").click(function () {
    if (!validateControls('viewAchievementModal')) {
        return false;
    }
    if (getAchievementData().length === 0) {
        misAlert("No achievements have been added.", "Warning", "warning");
        return false;
    }
    else {
        misConfirm("<span style='color:red;'>This is one time activity. Once submitted, you won't be able to modify it or add achievements for the current financial year.</span>", "Confirm", function (isConfirmed) {
            if (isConfirmed) {
                submitUserMidYearAchievement();
            }
        }, false, true, true);
    }
})

function getAchievementData() {
    var collection = new Array();
    var items;
    $('.itemRow').each(function () {
        var id = $(this).closest(".itemRow").attr("id").split('-')[1];
        items = new Object();
        items.Achievement = $("#achievement" + id).val();
        collection.push(items);
    });
    return collection;
}

function submitUserMidYearAchievement() {
    var jsonObject = {
        AchievementData: getAchievementData(),
        GoalCycleId: $("#txtHiddenGoalCycleId").val()
    };
    calltoAjax(misApiUrl.submitUserMidYearAchievement, "POST", jsonObject,
        function (result) {
            if (result === 1) {
                misAlert("Your achievemets have been submitted successfully", "Success", "success");
                $("#btnAddAchievement").hide();
                getUserMidYearAchievement();
                $("#viewAchievementModal").modal('hide');
            }
            else if (result === 2) {
                misAlert("You have already submitted the achievement for the mentioned financial year.", "Warning", "warning");

            }
            else
                misAlert("Unable to process request. Please try again.", "Error", "error");
        });
}

function getUserMidYearAchievement() {
    var jsonObject = {
        achievementCycleId: $("#showAchievementYear").val()
    };
    calltoAjax(misApiUrl.getUserMidYearAchievement, "POST", jsonObject,
        function (result) {
            var data = $.parseJSON(JSON.stringify(result));
            $("#tblMyAchievements").dataTable({
                "responsive": true,
                "autoWidth": false,
                "paging": true,
                "bDestroy": true,
                "ordering": true,
                "footer": true,
                "order": [],
                "info": true,
                "deferRender": true,
                "aaData": data,
                "aoColumns": [
                    {
                        "sTitle": "Appraisal Year",
                        'bSortable': false,
                        "swidth": "100px",
                        mRender: function (data, type, row) {
                            var year = row.AppraisalYear;
                            var html = '<span class="halign-center circle-bg" style="font-size: 20px;">' + year + '</span>';
                            return html;
                        }
                    },
                    {
                        "mData": "SubmittedDate",
                        "sTitle": "Submitted On",
                        "swidth":"80px"
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        "sClass": "text-center",
                        "sWidth": "90px",
                        mRender: function (data, type, row) {
                            _achievementList = row.AchievementData;
                            var html = '';
                            html += '<button type="button" class="btn btn-sm btn-success"' + 'onclick="viewAchievements()" title="view"><i class="fa fa-eye" ></i></button>';
                            return html;
                        }
                    },
                ]
            });
        }
      
    );
}

function viewAchievements() {
    var data = $.parseJSON(JSON.stringify(_achievementList));
    $("#tblViewMyAchievements").dataTable({
        "responsive": true,
        "autoWidth": false,
        "paging": true,
        "bDestroy": true,
        "searching": true,
        "ordering": false,
        "info": false,
        "deferRender": true,
        "aaData": data,
        "aoColumns": [
            {
                "mData": "SNo",
                "sTitle": "S.No.",
                "swidth":"40px"
            },
            {
                "mData": "Achievement",
                "sTitle": "Achievement",
            }
        ]
    });

    $("#modalViewAchievementPopUp").modal('show');
}

function bindMyAchievement() {
    //    calltoAjax(misApiUrl.getAllMyAchievements, "GET", '',
    //        function (result) {
    //            var resultData = $.parseJSON(JSON.stringify(result));
    //            $("#tblMyAchievements").dataTable({
    //                "responsive": true,
    //                "autoWidth": false,
    //                "paging": true,
    //                "bDestroy": true,
    //                "searching": true,
    //                "ordering": false,
    //                "info": false,
    //                "deferRender": true,
    //                "aaData": resultData,
    //                "aoColumns": [
    //                     {
    //                         "mData": null,
    //                         "sTitle": "User",
    //                         "sClass": "text-center",
    //                         "sWidth": "200px",
    //                         mRender: function (data, type, row) {
    //                             return "<td class='halign-center'><img  onerror=\"this.src='../img/avatar-sign.png'\" src='" + data.EmployeePhotoName + "' class='img-circle' alt='User Image'><br/>" + data.EmployeeName + "<br/>" + data.DesignationName + "</td>";
    //                         }
    //                     },
    //                    {
    //                        "mData": "ActualFormName",
    //                        "sTitle": "Form",
    //                    },
    //                    {
    //                        "mData": "UsersFormName",
    //                        "sTitle": "My Achievement Form",
    //                    },
    //                    {
    //                        "mData": "Status",
    //                        "sTitle": "Status",
    //                    },
    //                    {
    //                        "mData": null,
    //                        "sTitle": "Uploaded On",
    //                        "sWidth": "100px",
    //                        mRender: function (data, type, row) {
    //                            return toddMMMYYYYHHMMSSAP(row.CreatedDate);
    //                        }
    //                    },
    //                    {
    //                        "mData": null,
    //                        "sTitle": "Action",
    //                        'bSortable': false,
    //                        "sClass": "text-center",
    //                        "sWidth": "120px",
    //                        mRender: function (data, type, row) {
    //                            var html = '';
    //                            if (row.IsActive === true)
    //                                html += '<button type="button" data-toggle="tooltip" class="btn btn-sm btn-success"' + 'onclick="changeMyFormStatus(\'' + row.UserFormAbrhs + '\',2' + ')" title="DeActivate"><i class="fa fa-check" aria-hidden="true"></i></button>';
    //                            //else
    //                            //    html += '<button type="button" data-toggle="tooltip" class="btn btn-sm btn-warning"' + 'onclick="changeMyFormStatus(\'' + row.UserFormAbrhs + '\',1' + ')" title="Activate"><i class="fa fa-times" aria-hidden="true"></i></button>';

    //                            //html += '&nbsp;<button type="button" data-toggle="tooltip" class="btn btn-sm btn-danger"' + 'onclick="changeMyFormStatus(\'' + row.UserFormAbrhs + '\',3' + ')" title="Delete"><i class="fa fa-trash" aria-hidden="true"></i></button>'

    //                            if (misPermissions.hasViewRights === true) {
    //                                var extention = getFileExtension(row.UsersFormName);
    //                                html += '&nbsp;<button type="button" class="btn btn-sm teal" onclick="fetchMyFormInformation(\'' + row.UsersFormName + '\' ,\'' + row.UserFormAbrhs + '\')" data-toggle="tooltip" title="Download"><i class="fa fa-download"> </i></button>';
    //                                if (extention === "pdf") {
    //                                    html += '&nbsp;<button type="button" class="btn btn-sm teal" onclick="viewDocumentInPopup(\'' + row.ActualFormName + '\' , \'' + row.UsersFormName + '\' ,\'' + row.UserFormAbrhs + '\')" data-toggle="tooltip" title="View"><i class="fa fa-eye"> </i></button>';
    //                                }
    //                            }
    //                            return html;
    //                        }
    //                    },
    //                ]
    //            });
    //        });
}

//status = 1:activate, 2:deactivate, 3:delete
function changeMyFormStatus(formAbrhs, status) {
    var jsonObject = {
        userFormAbrhs: formAbrhs,
        status: status
    }

    if (status !== 1) {
        misConfirm("Are you sure you want to " + (status === 2 ? "deactive" : "delete") + " this?", "Confirm", function (isConfirmed) {
            if (isConfirmed) {
                calltoAjax(misApiUrl.changeMyFormStatus, "POST", jsonObject,
                    function (result) {
                        var resultData = $.parseJSON(JSON.stringify(result));
                        if (resultData) {
                            misAlert("Your achievement doc has been " + (status === 2 ? "deactivated" : "deleted") + " successfully.", "Success", "success");
                            bindMyAchievement();
                        }
                        else
                            misAlert('Your request cannot be processed, please try after some time or contact to MIS team for further assistance.', 'Error', 'error');
                    });
            }
        });
    }
    else {
        calltoAjax(misApiUrl.changeMyFormStatus, "POST", jsonObject,
            function (result) {
                var resultData = $.parseJSON(JSON.stringify(result));
                if (resultData) {
                    misAlert("Your achievement doc has been activated successfully", "Success", "success");
                    bindMyAchievement();
                }
                else
                    misAlert('Your request cannot be processed, please try after some time or contact to MIS team for further assistance.', 'Error', 'error');
            });
    }
}

function fetchMyFormInformation(formaName, formAbrhs) {
    var jsonObject = {
        userFormAbrhs: formAbrhs,
    }
    calltoAjax(misApiUrl.fetchUserForm, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            if (resultData !== null && resultData !== '') {
                downloadFileFromBase64(formaName, resultData);
            }
            else {
                misAlert('The file you have requested does not exist. Please try after some time or contact to MIS team for further assistance.', 'Oops...', 'info');

            }
        });
}

function viewDocumentInPopup(formTitle, formName, userFormAbrhs) {
    var extention = getFileExtension(formName);
    var jsonObject = {
        userFormAbrhs: userFormAbrhs,
    }
    calltoAjax(misApiUrl.fetchUserForm, "POST", jsonObject, function (resultData) {
        if (resultData !== null && resultData !== '') {
            if (extention === "pdf") {
                $("#objViewPdf").attr("data", resultData);
                $("#modalTitle").html(formTitle);
                $("#viewDocumentModal").modal("show");
            }
            else {
                downloadFileFromBase64(formTitle, resultData);
            }
        }
        else {
            misAlert('The file you have requested does not exist. Please try after some time or contact to MIS team for further assistance.', 'Oops...', 'info');
        }
    });
}