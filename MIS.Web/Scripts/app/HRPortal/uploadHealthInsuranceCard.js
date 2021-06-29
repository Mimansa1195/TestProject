var base64FormData;

$(document).ready(function () {
    bindEmployeeDetails();

    $("#btnSaveForm").click(function () {
        uploadHealthInsuranceCard();
    });

    $("#btnClose").click(function () {
        $("#modal-uploadHealthInsuranceCard").modal('hide');
    });
});

function bindEmployeeDetails() {
    calltoAjax(misApiUrl.getAllActiveEmployees, "GET", null,
        function (result) {
            if (result != null)
                $.each(result, function (index, item) {
                    $("#employee").append("<option value = '" + item.EmployeeId + "' >" + item.EmployeeName + "</option>");
                });
            $('#employee').select2();

        });
}

function checkFileIsValid(sender) {
    var validExts = new Array(".pdf");
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
    var selectedFile = document.getElementById("healthInsuranceCard").files;
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

function uploadHealthInsuranceCard() {
    var extn = getFileExtension($("#healthInsuranceCard").val().replace(/^.*\\/, ""));
    var fileNameWithoutExtention = trimExtension($("#healthInsuranceCard").val().replace(/^.*\\/, ""));
    var fileName = fileNameWithoutExtention + "_" + $.now() + "." + extn;
    if (!validateControls('modal-uploadHealthInsuranceCard')) {
        return false;
    }
    var jsonObject = {
        UserId: $("#employee").val(),
        FileName: fileName,
        FileData: base64FormData,
        CreatedDate: $.now(),
        CreatedByAbrs: sessionStorage['misSession.username']
    }
    calltoAjax(misApiUrl.uploadHealthInsuranceCard, "POST", jsonObject, function (result) {
        var resultData = $.parseJSON(JSON.stringify(result));
        if (resultData) {
            GetEmployeeHEalthInsuranceCardDetails();
            misAlert("Your form has been uploaded successfully", "Success", "success");

        }
        else
            misAlert('Your request cannot be processed, please try after some time or contact to MIS team for further assistance.', 'Error', 'error');
    });
}