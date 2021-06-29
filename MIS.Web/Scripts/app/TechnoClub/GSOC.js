$(document).ready(function () {
    bindGSOCProjects();
    loadSubscriptionSummaryGrid();

    $("#btnSubscribe").click(function () {
        uploadMyForm();

    });

    $("#btnClose").click(function () {
        $("#mypopupSubscribe").modal('hide');
    });
    $("#project").on("change", function () {
        var projectId = $("#project").val();
        if (projectId > 0) {
            var jsonObject = {
                projectId: projectId
            }
            calltoAjax(misApiUrl.getProjectDetails, "POST", jsonObject,
                function (result) {
                    var resultData = $.parseJSON(JSON.stringify(result));
                    if (resultData.FilePath != null) {
                        $("#btnPropose").html("Subscribe");
                        viewProjectPdfInWeb(resultData.FilePath);
                    }

                    else {
                        $("#btnPropose").html("Propose");
                        $("#pdfContainer").addClass("hidden");
                    }

                });
        }
        else {
            $("#btnPropose").html("Subscribe");
            $("#pdfContainer").addClass("hidden");
        }


    });
});
function subscribeUsers() {
    if ($("#project").val() > 0) {
        $("#mypopupSubscribe").modal('show');
        var textValue = $("#project option:selected").text();
        if (textValue == "Others") {
            $("#title").prop('disabled', false);
            $("#title").val("");
        }
        else {
            $("#title").val(textValue);
            $("#title").prop('disabled', true);
        }

        $("#brief").val(""),
            $("#expectedResult").val(""),
            $("#solution").val(""),
            $("#timeline").val(""),
            $("#futurePlans").val(""),
            $("#title").removeClass("error-validation"),
            $("#brief").removeClass("error-validation"),
            $("#expectedResult").removeClass("error-validation"),
            $("#solution").removeClass("error-validation"),
            $("#timeline").removeClass("error-validation"),
            $("#futurePlans").removeClass("error-validation")
    }
    else
        misAlert("Please select a project first.", "Warning", "warning");
}
function bindGSOCProjects() {
    $("#project").html(""); //to clear the previously selected value
    $("#project").select2();
    $("#project").append("<option value='0'>Select</option>");
    calltoAjax(misApiUrl.getGSOCProjects, "POST", "",
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            $.each(resultData, function (idx, item) {
                $("#project").append($("<option></option>").val(item.Value).html(item.Text));
            });
        });
}
function loadSubscriptionSummaryGrid() {
    calltoAjax(misApiUrl.getUserWiseSubscribedProjects, "POST", "",
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            _AllNews = resultData
            $("#tblSubscribersInfo").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                    {
                        filename: 'Project Subscription List',
                        extend: 'collection',
                        text: 'Export',
                        buttons: [{ extend: 'copy' },
                        { extend: 'excel', filename: 'Project Subscription List' },
                        { extend: 'pdf', filename: 'Project Subscription List' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                        { extend: 'print', filename: 'Project Subscription List' },
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
                        "sTitle": "Project Title",
                    },
                    {
                        "mData": null,
                        "sTitle": "File Name",
                        mRender: function (data, type, row) {
                            if (row.FilePath != null && row.FilePath != "")
                                return row.FilePath;
                            else
                                return "";
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Status",
                        mRender: function (data, type, row) {
                            if (row.Status === "Cancelled")
                                return '<span class="label label-danger">Cancelled</span>';
                            if (row.Status === "Approved")
                                return '<span class="label label-success">Approved</span>';
                            else
                                return '<span class="label label-info">Submitted</span>';
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Subscribed On",
                        mRender: function (data, type, row) {
                            return toddMMMYYYYHHMMSSAP(row.SubscribedOn);
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Action",
                        'bSortable': false,
                        "sClass": "text-center",
                        "sWidth": "110px",
                        mRender: function (data, type, row) {
                            var html = '<div>';
                            if (row.Status == "Submitted")
                                html += '<button type="button" data-toggle="tooltip" class="btn btn-sm btn-danger"' + 'onclick="changeSubscriptionStatus(\'' + row.GSOCProjectSubscriberId + '\')" title="Unsubscribe"><i class="fa fa-times" aria-hidden="true"></i></button>';
                            if (row.FilePath != null && row.FilePath != "") {
                                var extention = getFileExtension(row.FilePath);
                                html += '&nbsp;<button type="button" class="btn btn-sm teal" onclick="fetchFormInformation(\'' + row.FilePath + '\')" data-toggle="tooltip" title="Download"><i class="fa fa-download"> </i></button>';
                                if (extention == "pdf") {
                                    html += '&nbsp;<button type="button" class="btn btn-sm teal" onclick="viewProjectPdfInPopup(\'' + row.FilePath + '\')" data-toggle="tooltip" title="View"><i class="fa fa-eye"></i></button>';
                                    //html += '&nbsp;<button type="button" class="btn btn-sm teal" data-toggle"model" data-target="#mypopupViewDocModal" onclick="viewDocumentInPopup(\'' + row.UsersFormName + '\' ,\'' + row.UserFormAbrhs + '\')" data-toggle="tooltip" title="View"><i class="fa fa-eye"> </i></button>';
                                }
                            }

                            return html;
                        }
                    },
                ]
            });
        });
}
function viewProjectPdfInPopup(projectPath) {
    var extention = getFileExtension(projectPath);
    var jsonObject = {
        fileName: projectPath
    }
    calltoAjax(misApiUrl.viewUploadedDocInPopUp, "POST", jsonObject,
        function (resultData) {
            if (resultData != null && resultData != '') {
                if (extention == "pdf") {
                    $("#objViewPdf").attr("data", resultData);
                    document.getElementById("header1").innerHTML = projectPath;
                    //$("#modalTitle").html(resume);
                    $("#viewDocumentModal").modal("show");
                }
                //else {
                //    downloadFileFromBase64(projectPath, resultData);
                //}
            }
            else {
                misAlert('The file you have requested does not exist. Please try after some time or contact to MIS team for further assistance.', 'Oops...', 'info');
            }
        });

}
function viewProjectPdfInWeb(projectPath) {
    var extention = getFileExtension(projectPath);
    var jsonObject = {
        fileName: projectPath
    }
    calltoAjax(misApiUrl.viewProjectPdf, "POST", jsonObject,
        function (resultData) {
            if (resultData != null && resultData != '') {
                $("#pdfContainer").removeClass("hidden");
                $("#pdfContainer").html('<embed src="' + resultData + '" style="width: 100%;height:1000px" toolbar=0 />')
                $('embed').load(function () {
                    $('embed').contents().find("#buttons").hide();
                });
            }
            else {
                misAlert('The file you have requested does not exist. Please try after some time or contact to MIS team for further assistance.', 'Oops...', 'info');
            }
        });

}
function checkFileIsValid(sender) {
    var validExts = new Array(".xlsx", ".xls", ".pdf", ".doc", ".docx");
    var fileExt = sender.value;
    fileExt = fileExt.substring(fileExt.lastIndexOf('.'));
    if (validExts.indexOf(fileExt) < 0) {
        misAlert("Invalid file selected. Supported extensions are " + validExts.toString(), "Warning", "warning");
        $("#fuForm").val("");
        return false;
    } else {
        convertToBase64();
        return true;
    }
}
function convertToBase64() {
    var selectedFile = document.getElementById("fuForm").files;
    if (selectedFile.length > 0) //Check File is not Empty
    {
        var fileToLoad = selectedFile[0];
        var fileReader = new FileReader();
        fileReader.onload = function (fileLoadedEvent) {
            base64FormData = fileLoadedEvent.target.result;
        };
        fileReader.readAsDataURL(fileToLoad);
    }
}
function uploadMyForm() {
    if (!validateControls('mypopupSubscribe')) {
        return false;
    }
    var fileName = $("#fuForm").val().replace(/^.*[\\\/]/, '');
    var jsonObject = {
        projectId: $("#project").val(),
        title: $("#title").val(),
        fileName: fileName,
        base64FormData: base64FormData
    };
    calltoAjax(misApiUrl.subscribeForGSOCProject, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            switch (resultData) {
                case 0:
                    misAlert('Your request cannot be processed, please try after some time or contact to MIS team for further assistance.', 'Error', 'error');
                case 1:
                    misAlert("You have successfully subscribed.", "Success", "success");
                    $("#mypopupSubscribe").modal('hide');
                    loadSubscriptionSummaryGrid();
                    break;
                case 2:
                    misAlert("You have already subscribed for this project.", "Warning", "warning");
                    break;

            }
        });
}
function fetchFormInformation(filePath) {
    var jsonObject = {
        filePath: filePath,
    }
    calltoAjax(misApiUrl.fetchUploadedDocument, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            if (resultData != null && resultData != '') {
                downloadFileFromBase64(filePath, resultData);
            }
            else {
                misAlert('The file you have requested does not exist. Please try after some time or contact to MIS team for further assistance.', 'Oops...', 'info');

            }
        });
}

function changeSubscriptionStatus(gsocSubscriptionId) {
    var jsonObject = {
        gsocSubscriptionId: gsocSubscriptionId,
    }
    misConfirm("Are you sure you want to unsubscribe this project?", "Confirm", function (isConfirmed) {
        if (isConfirmed) {
            calltoAjax(misApiUrl.changeSubscriptionStatus, "POST", jsonObject,
                function (result) {
                    var resultData = $.parseJSON(JSON.stringify(result));
                    if (resultData) {
                        misAlert("Your subscription has been cancelled successfully.", "Success", "success");
                        loadSubscriptionSummaryGrid();
                    }
                    else
                        misAlert('Your request cannot be processed, please try after some time or contact to MIS team for further assistance.', 'Error', 'error');
                });
        }
    });
}

function downloadSampleFile(value) {
    var filePath = "SampleDocument" + "." + value
    var jsonObject = {
        filePath: filePath 
    }
    calltoAjax(misApiUrl.fetchSampleDocument, "POST", jsonObject,
        function (result) {
            var resultData = $.parseJSON(JSON.stringify(result));
            if (resultData != null && resultData != '') {
                downloadFileFromBase64(filePath, resultData);
            }
            else {
                misAlert('The file you have requested does not exist. Please try after some time or contact to MIS team for further assistance.', 'Oops...', 'info');

            }
        });
}