$(document).ready(function () {
    bindHelpDocument();
});

function bindHelpDocument() {
    calltoAjax(misApiUrl.fetchHelpDocumentInformation, "POST", '',
        function (resultData) {
            console.log(resultData);
            if (resultData != null && resultData != '')        
                $("#objViewHelpDocPdf").attr("data", resultData);            
            else
                misAlert('The file you have requested does not exist. Please try after some time or contact to MIS team for further assistance.', 'Oops...', 'info');            
        });
}