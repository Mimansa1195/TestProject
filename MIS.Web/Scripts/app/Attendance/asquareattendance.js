$(document).ready(function () {
    var ToDate = new Date();
    var FromDate = new Date();
    FromDate.setDate(FromDate.getDate() - 15);
    $("#FromDate input").val(toddmmyyyDatePicker(FromDate));
    $("#ToDate input").val(toddmmyyyDatePicker(ToDate));

    $('#FromDate').datepicker({
        format: "mm/dd/yyyy",
        autoclose: true,
        todayHighlight: true
    }).on('changeDate', function (ev) {
        var fromStartDate = new Date(ev.date.valueOf());
        $('#ToDate input').val('');
        $('#ToDate').datepicker('setStartDate', fromStartDate).trigger('change');
    });

    $('#ToDate').datepicker({
        format: "mm/dd/yyyy",
        autoclose: true,
        todayHighlight: true
    });

    $("#frmUploadTp").attr("action", misApiUrl.uploadAttendance);
    $('#btnUploadFile').attr('disabled', true);

    $("#btnUploadFile").click(function (e) {
        if (!validateControls('divAttendanceUpload')) {
            return false;
        }
        var uploadUrl = misApiUrl.uploadAttendance + "?deviceId=" + $("#ddlDeviceId").val() + "&userAbrhs=" + misSession.userabrhs;
        $("#frmUploadTp").attr("action", uploadUrl);
        var form = document.getElementById("frmUploadTp");
        form.submit();
    });

    $("#openUploadPopup").click(function () {
        $("#AttendanceFileUpload").val('');
        $("#ddlDeviceId").val(0);
        document.getElementById('myiframe').src = '';
        $("#popupUploadFile").modal('show');
    });

    bindAttendanceUploadedList();

    $("#btnShowAttendance").click(function () {
        bindAttendanceUploadedList();
    });

});

function checkfileIsExceltp(sender) {
    var validExts = new Array(".xlsx", ".xls");
    var fileExt = sender.value;
    fileExt = fileExt.substring(fileExt.lastIndexOf('.'));
    if (validExts.indexOf(fileExt) < 0) {
        etpAlert("Invalid file selected, valid files are of " + validExts.toString());
        $('#btnUploadFile').attr('disabled', true);
        return false;
    } else {
        $('#btnUploadFile').attr('disabled', false);
        return true;
    }
}

function clearFileInput(id) {
    var oldInput = document.getElementById(id);
    var newInput = document.createElement("input");
    newInput.type = "file";
    newInput.id = oldInput.id;
    newInput.name = oldInput.name;
    newInput.className = oldInput.className;
    newInput.style.cssText = oldInput.style.cssText;
    oldInput.parentNode.replaceChild(newInput, oldInput);
}

function bindAttendanceUploadedList() {
    if (!validateControls('ReportDiv')) {
        return false;
    }

    var jsonObject = {
        fromDate: $("#FromDate input").val(),
        toDate: $("#ToDate input").val(),
    };

    calltoAjax(misApiUrl.getAttendanceUpload, "POST", jsonObject,
        function (result) {
            var resultdata = $.parseJSON(JSON.stringify(result));
            $("#tblAttendanceReport").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                 {
                     filename: 'ASquare Attendance Upload History',
                     extend: 'collection',
                     text: 'Export',
                     buttons: [{ extend: 'copy' },
                                { extend: 'excel', filename: 'ASquare Attendance Upload History' },
                                { extend: 'pdf', filename: 'ASquare Attendance Upload History' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                                { extend: 'print', filename: 'ASquare Attendance Upload History' },
                     ]
                 }
                ],
                "responsive": true,
                "autoWidth": false,
                "paging": true,
                "bDestroy": true,
                "searching": true,
                "ordering": true,
                "order": [],
                "info": true,
                "deferRender": true,
                "aaData": resultdata,
                "aoColumns": [
                    {
                        "mData": null,
                        "sTitle": "Date",
                        mRender: function (data, type, row) {
                            return '<a  onclick="showDetailedAttendance(' + row.AttendaceId + ')" >' + row.AttendaceDate + '</a>';
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Device Id",
                        mRender: function (data, type, row) {
                            return row.DeviceId;
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Uploaded On",
                        mRender: function (data, type, row) {
                            return row.CreatedDate;
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Uploaded By",
                        mRender: function (data, type, row) {
                            return row.CreatedBy;
                        }
                    },
                ]
            });

        });
}

function showDetailedAttendance(attendaceId) {
    var jsonObject = {
        AttendaceId: attendaceId,
    };

    calltoAjax(misApiUrl.getDetailAttendance, "POST", jsonObject,
        function (result) {
            var resultdata = $.parseJSON(JSON.stringify(result));
            $("#tblAttendanceDetail").dataTable({
                "dom": 'lBfrtip',
                "buttons": [
                 {
                     filename: 'ASquare Attendance',
                     extend: 'collection',
                     text: 'Export',
                     buttons: [{ extend: 'copy' },
                                { extend: 'excel', filename: 'ASquare Attendance' },
                                { extend: 'pdf', filename: 'ASquare Attendance' }, //, orientation: 'landscape', pageSize: 'LEGAL',
                                { extend: 'print', filename: 'ASquare Attendance' },
                     ]
                 }
                ],
                "responsive": true,
                "autoWidth": false,
                "paging": true,
                "bDestroy": true,
                "searching": true,
                "ordering": true,
                "order": [],
                "info": true,
                "deferRender": true,
                "aaData": resultdata,
                "aoColumns": [
                    {
                        "mData": null,
                        "sTitle": "Name",
                        mRender: function (data, type, row) {
                            return row.StaffName;
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Date",
                        mRender: function (data, type, row) {
                            return row.AttendaceDate;
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "In Time",
                        mRender: function (data, type, row) {
                            return row.InTime;
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Out Time",
                        mRender: function (data, type, row) {
                            return row.OutTime;
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Total Working Hours",
                        mRender: function (data, type, row) {
                            return row.TotalHours;
                        }
                    },
                    {
                        "mData": null,
                        "sTitle": "Uploaded On",
                        mRender: function (data, type, row) {
                            return row.CreatedDate;
                        }
                    },
                ]
            });

        });
}
