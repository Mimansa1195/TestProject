$(document).ready(function () {
    GetSharedDocumentByToUser();
});

function GetSharedDocumentByToUser() {
    var jsonObject = {
        userAbrhs: misSession.userabrhs
    }
    calltoAjax(misApiUrl.getSharedDocumentByToUser, "POST", jsonObject,
        function (result) {
            SuccesfulGetSharedDocumentByToUser(result);
        });
}

function SuccesfulGetSharedDocumentByToUser(msg) {
    var data = $.parseJSON(JSON.stringify(msg));
    $("#tblShareDocumentList").dataTable({
        "responsive": true,
        "autoWidth": false,
        "paging": true,
        "bDestroy": true,
        "ordering": true,
        "order": [],
        "info": true,
        "deferRender": false,
        "aaData": data,
        "aoColumns": [
            {
                "mData": "Description",
                "sTitle": "Title",
            },
            {
                "mData": "SharedBy",
                "sTitle": "Shared By",
            },
            {
                "mData": "TagNames",
                "sTitle": "Tag Names",
            },
            {
                "mData": "ShowDate",
                "sTitle": "Date",
                "sWidth": '100px',
            },
            {
                "mData": null,
                "sTitle": "View",
                'bSortable': false,
                "sClass": "text-left",
                "sWidth": "100px",
                mRender: function (data, type, row) {
                    html = '<button type="button" class="btn btn-sm teal" data-toggle"model" data-target="#mypopupViewDocModal"' + 'onclick="ViewDocument(\'' + row.Path + '\')" data-toggle="tooltip" title="View"><i class="fa fa-eye"> </i></button>';
                    return  html;
                }
            },
        ]
    });
}

function ViewDocument(path) {
    var path = misApiRootUrl + path;
    $('#mypopupViewDocModal').modal("show");
    $("#frame").attr("src", path );
}

