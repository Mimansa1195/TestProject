var morrisBarConfig = {
    element: '', //
    data: [], //
    //xkey: 'BatchName',
    //ykeys: ['MinimumScore', 'AverageScore', 'MaximumScore'],
    //labels: ['Min Score', 'Avg Score', 'Max Score'],
    //fillOpacity: 0.6,
    hideHover: 'auto',
    gridEnabled: true,
    //stacked: true, //
    resize: true,
    //pointFillColors: ['#ffffff'], //
    //pointStrokeColors: ['black'], //
    //barColors: ['blue', 'green', 'orange'],
    //yLabelFormat: formatY, //fun
    //xLabelFormat: formatX, //fun
    //hoverCallback: function (index, options, content, row) { //
    //    //return 'custom 1';
    //}
};
$(function () {
    // Fixed Header and column for table
    $(".main-container").on("scroll", function () {

        var scrollLeft = $(".main-container").scrollLeft();
        $("#tblTimeTable tr td.fixcolumn,#dvHeader tr td.fixcolumn").css({ 'left': scrollLeft });
        var scrollTop = $(".main-container").scrollTop() - 1;
        $("#dvHeader tr td").css({ 'top': scrollTop });
    });

    $('.site-logo').click(function () {
        misSession.validateToken(misSession.token, misSession.userabrhs);
    });

    $(document).on({
        'mouseenter': function (e) {
            $(this).tooltip('show');
        },
        'mouseeleave': function (e) {
            $(this).tooltip('hide');
        }
    }, "[data-toggle='tooltip']");

    //$("[data-toggle='tooltip']").tooltip({ trigger: "hover" });

    //$("body").on("focus", ".date-picker", function () {
    //    $(this).datepicker({ autoclose: true });
    //});

    //$(document).on('hidden.bs.modal', function () {
    //    $(this).find('form').trigger('reset');
    //})

    //$(document).ajaxStart($('div.main').block()).ajaxError($('div.main').unblock()).ajaxStop($('div.main').unblock());
});

var misCrypto = function () {
    var keyStr = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=';
    return {
        encode: function (input) {
            var output = "";
            var chr1, chr2, chr3 = "";
            var enc1, enc2, enc3, enc4 = "";
            var i = 0;

            do {
                chr1 = input.charCodeAt(i++);
                chr2 = input.charCodeAt(i++);
                chr3 = input.charCodeAt(i++);

                enc1 = chr1 >> 2;
                enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
                enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
                enc4 = chr3 & 63;

                if (isNaN(chr2)) {
                    enc3 = enc4 = 64;
                } else if (isNaN(chr3)) {
                    enc4 = 64;
                }

                output = output +
                    keyStr.charAt(enc1) +
                    keyStr.charAt(enc2) +
                    keyStr.charAt(enc3) +
                    keyStr.charAt(enc4);
                chr1 = chr2 = chr3 = "";
                enc1 = enc2 = enc3 = enc4 = "";
            } while (i < input.length);

            return output;
        },

        decode: function (input) {
            var output = "";
            var chr1, chr2, chr3 = "";
            var enc1, enc2, enc3, enc4 = "";
            var i = 0;

            /*/ remove all characters that are not A-Z, a-z, 0-9, +, /, or =*/
            var base64test = /[^A-Za-z0-9\+\/\=]/g;
            if (base64test.exec(input)) {
                misAlert("There were invalid base64 characters in the input text.\n" +
                    "Valid base64 characters are A-Z, a-z, 0-9, '+', '/',and '='\n" +
                    "Expect errors in decoding.");
            }
            input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");

            do {
                enc1 = keyStr.indexOf(input.charAt(i++));
                enc2 = keyStr.indexOf(input.charAt(i++));
                enc3 = keyStr.indexOf(input.charAt(i++));
                enc4 = keyStr.indexOf(input.charAt(i++));

                chr1 = (enc1 << 2) | (enc2 >> 4);
                chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
                chr3 = ((enc3 & 3) << 6) | enc4;

                output = output + String.fromCharCode(chr1);

                if (enc3 != 64) {
                    output = output + String.fromCharCode(chr2);
                }
                if (enc4 != 64) {
                    output = output + String.fromCharCode(chr3);
                }

                chr1 = chr2 = chr3 = "";
                enc1 = enc2 = enc3 = enc4 = "";

            } while (i < input.length);

            return output;
        }
    };
}();

function redirectToURL(url) {
    if (url) {
        window.location.href = url;
    }
}

//method to download excel file using api call
function downloadExcel(url) {
    try {
        if ($('#hidden-excel-form').length < 1)
            $('<form>').attr({ method: 'POST', id: 'hidden-excel-form', action: url }).appendTo('body');
        //<META http-equiv="key" content="value">
        //$('<input type="hidden" name="Authorization" value="Token ' + misSession.token + '" />').appendTo('#hidden-excel-form');
        //$('<META type="hidden" http-equiv=="Authorization" content="Token ' + misSession.token + '">').appendTo('#hidden-excel-form');
        $('head').append('<META http-equiv=="Authorization" content="Token ' + misSession.token + '">');
        $('#hidden-excel-form').bind("submit");
        $('#hidden-excel-form').submit();
    } catch (e) {

    }
}

//function to download file from base64
function downloadFileFromBase64(filename, base64String) {
    var element = document.createElement('a');
    element.setAttribute('href', base64String);
    element.setAttribute('download', filename);
    element.style.display = 'none';
    document.body.appendChild(element);
    element.click();
    document.body.removeChild(element);
}

//method to convert file into base64
function getBase64(file) {
    var reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = function () {
        return reader.result;
    };
    reader.onerror = function (error) {
        return error;
    };
}

function debugMis() {
}

function alertMis(message) {
    misAlert(message || "MIS Alert");
}

function misError() {
    misAlert('Your request cannot be processed, please try after some time or contact to MIS team for further assistance.', 'Error', 'error');
}

function calltoAjax(url, type, data, successCallback, errorCallback, doneCallback, cType) {
    var token = misSession.token;
    var userAbrhs = misSession.userabrhs;

    if (token && userAbrhs) {
        callToAjaxWithHeader(url, type, data, { 'Token': token, 'UserAbrhs': userAbrhs }, successCallback, errorCallback, doneCallback, cType)
    }
    else {
        misSession.logout();
        redirectToURL(misAppUrl.login);
    }
}

function callToAjaxWithHeader(url, type, data, headers, successCallback, errorCallback, doneCallback, cType) {
    $.ajax({
        type: type,
        contentType: cType || "application/json; charset=utf-8",
        url: url,
        headers: headers || {},
        data: (typeof data !== 'undefined' && data !== null && data !== '') ? JSON.stringify(data) : {},
        dataType: "json",
        beforeSend: function () {
            $.blockUI();
        },
        success: function (data, status, xhr) {
            if (typeof successCallback === 'function') {
                successCallback(data, status, xhr);
            }
            $.unblockUI();
        },
        error: function (xhr, status, errorThrown) {
            if (xhr.status === 500) {
                misCountdownAlert(errorThrown, 'Need MIS Support', 'warning', function () {
                    redirectToURL(misAppUrl.error);
                }, false, 20);
                return false;
            }
            if (xhr.status === 0 || xhr.status === 400 || xhr.status === 503) {
                misCountdownAlert(errorThrown, 'Service Unavailable', 'warning', function () {
                    redirectToURL(misAppUrl.maintenance);
                }, false, 10);
                return false;
            }
            else if (typeof errorCallback === 'function') {
                errorCallback(xhr, status, errorThrown);
            }
            else if (xhr.status === 401) {
                misSession.logout();
                if (!(window.location.pathname.toLowerCase().indexOf('login') > -1)) {
                    //redirectToURL(misAppUrl.login);
                    //misAlert('Your session has expired. Please log in.', 'Session Expired', 'warning');
                    misCountdownAlert('Your session has timed out. Please sign in again', 'Session Expired', 'warning', function () {
                        redirectToURL(misAppUrl.login);
                    }, false, 5);
                }
            }
            else {
                console.log('Error status: ' + xhr.status + errorThrown + ': ' + (typeof xhr.responseJSON != 'undefined' ? xhr.responseJSON.MessageDetail : errorThrown));
                //misAlert((typeof xhr.responseJSON != 'undefined' ? xhr.responseJSON.MessageDetail : errorThrown), (typeof xhr.responseJSON != 'undefined' ? xhr.responseJSON.Message : errorThrown));
                misError();
            }
        }
    }).done(function (data, status, xhr) {
        if (typeof doneCallback === 'function') {
            doneCallback(data, status, xhr);
        }
        $.unblockUI();
    });
}

function calltoAjaxWithoutLoader(url, type, data, successCallback, errorCallback, doneCallback, cType) {
    var token = misSession.token;
    var userAbrhs = misSession.userabrhs;

    if (token && userAbrhs) {
        callToAjaxWithHeaderWithoutLoader(url, type, data, { 'Token': token, 'UserAbrhs': userAbrhs }, successCallback, errorCallback, doneCallback, cType)
    }
    else {
        misSession.logout();
        redirectToURL(misAppUrl.login);
    }
}

function callToAjaxWithHeaderWithoutLoader(url, type, data, headers, successCallback, errorCallback, doneCallback, cType) {
    $.ajax({
        type: type,
        contentType: cType || "application/json; charset=utf-8",
        url: url,
        headers: headers || {},
        data: (typeof data !== 'undefined' && data !== null && data !== '') ? JSON.stringify(data) : {},
        dataType: "json",
        success: function (data, status, xhr) {
            if (typeof successCallback === 'function') {
                successCallback(data, status, xhr);
            }
        },
        error: function (xhr, status, errorThrown) {
            if (xhr.status === 500) {
                misCountdownAlert(errorThrown, 'Need MIS Support', 'warning', function () {
                    redirectToURL(misAppUrl.error);
                }, false, 20);
                return false;
            }
            if (xhr.status === 0 || xhr.status === 400 || xhr.status === 503) {
                misCountdownAlert(errorThrown, 'Service Unavailable', 'warning', function () {
                    redirectToURL(misAppUrl.maintenance);
                }, false, 10);
                return false;
            }
            else if (typeof errorCallback === 'function') {
                errorCallback(xhr, status, errorThrown);
            }
            else if (xhr.status === 401) {
                misSession.logout();
                if (!(window.location.pathname.toLowerCase().indexOf('login') > -1)) {
                    misCountdownAlert('Your session has timed out. Please sign in again', 'Session Expired', 'warning', function () {
                        redirectToURL(misAppUrl.login);
                    }, false, 5);
                }
            }
            else {
                console.log('Error status: ' + xhr.status + errorThrown + ': ' + (typeof xhr.responseJSON != 'undefined' ? xhr.responseJSON.MessageDetail : errorThrown));
                misError();
            }
        }
    }).done(function (data, status, xhr) {
        if (typeof doneCallback === 'function') {
            doneCallback(data, status, xhr);
        }
    });
}

function calltoAjaxAnonymous(url, type, data, successCallback, errorCallback, doneCallback, cType) {
    $.ajax({
        type: type,
        contentType: cType || "application/json; charset=utf-8",
        url: url,
        data: (typeof data !== 'undefined' && data !== null && data !== '') ? JSON.stringify(data) : {},
        dataType: "json",
        beforeSend: function () {
            $.blockUI();
        },
        success: function (data, status, xhr) {
            if (typeof successCallback === 'function') {
                successCallback(data, status, xhr);
            }
            $.unblockUI();
        },
        error: function (xhr, status, errorThrown) {
            if (typeof errorCallback === 'function') {
                errorCallback(xhr, status, errorThrown);
            }
            else {
                console.log('Anonymous Error status: ' + xhr.status + errorThrown + ': ' + (typeof xhr.responseJSON != 'undefined' ? xhr.responseJSON.MessageDetail : errorThrown));
                misError();
            }
        }
    }).done(function (data, status, xhr) {
        if (typeof doneCallback === 'function') {
            doneCallback(data, status, xhr);
        }
        $.unblockUI();
    });
}

// Sync Call
function calltoAjaxSync(url, type, data, successCallback, errorCallback, doneCallback, cType) {
    var token = misSession.token;
    var userAbrhs = misSession.userabrhs;

    if (token && userAbrhs) {
        callToAjaxWithHeaderSync(url, type, data, { 'Token': token, 'UserAbrhs': userAbrhs }, successCallback, errorCallback, doneCallback, cType)
    }
    else {
        misSession.logout();
        redirectToURL(misAppUrl.login);
    }
}

function callToAjaxWithHeaderSync(url, type, data, headers, successCallback, errorCallback, doneCallback, cType) {
    $.ajax({
        type: type,
        contentType: cType || "application/json; charset=utf-8",
        url: url,
        headers: headers || {},
        data: (typeof data !== 'undefined' && data !== null && data !== '') ? JSON.stringify(data) : {},
        dataType: "json",
        async: false,
        success: function (data, status, xhr) {
            if (typeof successCallback === 'function') {
                successCallback(data, status, xhr);
            }
        },
        error: function (xhr, status, errorThrown) {
            if (xhr.status === 401) {
                misSession.logout();
                if (!(window.location.pathname.toLowerCase().indexOf('login') > -1)) {
                    //redirectToURL(misAppUrl.login);
                    //misAlert('Your session has expired. Please log in.', 'Session Expired', 'warning');
                    misCountdownAlert('Your session has timed out. Please sign in again', 'Session Expired', 'warning', function () {
                        redirectToURL(misAppUrl.login);
                    }, false, 5);
                }
            }
            if (xhr.status === 0 || xhr.status === 400 || xhr.status === 503) {
                redirectToURL(misAppUrl.maintenance);
                return false;
            }
            else {
                console.log(errorThrown + ': ' + (typeof xhr.responseJSON != 'undefined' ? xhr.responseJSON.MessageDetail : errorThrown));
                //misAlert((typeof xhr.responseJSON != 'undefined' ? xhr.responseJSON.MessageDetail : errorThrown), (typeof xhr.responseJSON != 'undefined' ? xhr.responseJSON.Message : errorThrown));
                misError();
            }
            if (typeof errorCallback === 'function') {
                errorCallback(xhr, status, errorThrown);
            }
        }
    }).done(function (data, status, xhr) {
        if (typeof doneCallback === 'function') {
            doneCallback(data, status, xhr);
        }
    });
}

function showWait() {
    $(".blockOverlay").css("display", "block");
}

function hideWait() {
    $(".blockOverlay").css("display", "none");
}

function showLoader(containerId, isTable) {
    var wrapperElement = ((isTable === true) ? ('<tr id="dotLoadingContainer" class="col-md-12"><td style="border:none;">#</td></tr>') : '<div id="dotLoadingContainer">#</div>');
    var loadingElement = '<img src="../../img/dot-loader.gif" style="display: block;margin-left:auto;margin-right:auto;" />';
    if (typeof containerId != 'undefined') {
        $('#' + containerId).append(wrapperElement.replace('#', loadingElement));
    }
    else {
        //$('');
    }
}

function hideLoader(containerId) {
    if (typeof containerId != 'undefined') {
        $('#' + containerId).empty();
    }
    else {
        //$('');
    }
}

function setFooter() {
    var docHeight = $(window).height();
    var minHeight = docHeight - 191;
    $('.main').css({ "min-height": minHeight });
}

function setTestFooter() {
    var docHeight = $(window).height();
    var minHeight = docHeight - 141;
    $('.main').css({ "min-height": minHeight });
}

//alert notification
function misAlert(message, title, messageType, btnCallback, autoHide) {
    swal({
        title: title || "Oops...",
        text: message || "Something went wrong!",
        type: messageType || "error",
        html: true,
        allowOutsideClick: (autoHide !== false), //sets default true
        allowEscapeKey: (autoHide !== false),
        closeOnCancel: (autoHide !== false),
    }, function (result) {
        if (typeof btnCallback === 'function') {
            btnCallback(result);
        }
    });
}

//alert notification with countdown time
function misCountdownAlert(message, title, messageType, closeCallback, autoHide, closeInSeconds) {
    var tInSeconds = closeInSeconds || 5, displayText = displayText || '', timer;
    if (message) {
        displayText = message + "...#1";
    }
    swal({
        title: title || "Oops...",
        text: displayText.replace(/#1/, tInSeconds),
        type: messageType || "error",
        timer: tInSeconds * 1000,
        html: true,
        allowOutsideClick: (autoHide !== false), //sets default true
        allowEscapeKey: (autoHide !== false),
        showConfirmButton: true
    }, function (result) {
        if (typeof closeCallback === 'function') {
            closeCallback(result);
        }
    });
    timer = setInterval(function () {
        tInSeconds--;
        if (tInSeconds < 0) {
            clearInterval(timer);
        }
        $('.sweet-alert > p').html(displayText.replace(/#1/, tInSeconds));
    }, 1000);

}

//alert confirmation with Yes and No button
function misConfirm(message, title, btnCallback, autoHide, isHTMLData, closeOnConfirm, type) {
    swal({
        title: title || "Are you sure?",
        text: message || "Are you sure you want to do this?",
        type: type || 'warning',
        showCancelButton: true,
        confirmButtonClass: "btn-danger",
        confirmButtonText: "Yes",
        cancelButtonText: "No",
        closeOnCancel: true,
        allowOutsideClick: (autoHide === true), //sets default false,
        allowEscapeKey: (autoHide === true),
        closeOnConfirm: (closeOnConfirm === true),
        html: (isHTMLData === true)
    }, function (isConfirm) {
        if (typeof btnCallback === 'function') {
            btnCallback(isConfirm);
        }
    });
}

// get browser information
function getBrowserInfo() {
    var nVer = navigator.appVersion;
    var nAgt = navigator.userAgent;
    var browserName = navigator.appName;
    var fullVersion = '' + parseFloat(navigator.appVersion);
    var majorVersion = parseInt(navigator.appVersion, 10);
    var nameOffset, verOffset, ix;

    // In Opera, the true version is after "Opera" or after "Version"
    if ((verOffset = nAgt.indexOf("Opera")) != -1) {
        browserName = "Opera";
        fullVersion = nAgt.substring(verOffset + 6);
        if ((verOffset = nAgt.indexOf("Version")) != -1)
            fullVersion = nAgt.substring(verOffset + 8);
    }
    // In MSIE, the true version is after "MSIE" in userAgent
    else if ((verOffset = nAgt.indexOf("MSIE")) != -1) {
        browserName = "Microsoft Internet Explorer";
        fullVersion = nAgt.substring(verOffset + 5);
    }
    // In Chrome, the true version is after "Chrome" 
    else if ((verOffset = nAgt.indexOf("Chrome")) != -1) {
        browserName = "Chrome";
        fullVersion = nAgt.substring(verOffset + 7);
    }
    // In Safari, the true version is after "Safari" or after "Version" 
    else if ((verOffset = nAgt.indexOf("Safari")) != -1) {
        browserName = "Safari";
        fullVersion = nAgt.substring(verOffset + 7);
        if ((verOffset = nAgt.indexOf("Version")) != -1)
            fullVersion = nAgt.substring(verOffset + 8);
    }
    // In Firefox, the true version is after "Firefox" 
    else if ((verOffset = nAgt.indexOf("Firefox")) != -1) {
        browserName = "Firefox";
        fullVersion = nAgt.substring(verOffset + 8);
    }
    // In most other browsers, "name/version" is at the end of userAgent 
    else if ((nameOffset = nAgt.lastIndexOf(' ') + 1) <
        (verOffset = nAgt.lastIndexOf('/'))) {
        browserName = nAgt.substring(nameOffset, verOffset);
        fullVersion = nAgt.substring(verOffset + 1);
        if (browserName.toLowerCase() == browserName.toUpperCase()) {
            browserName = navigator.appName;
        }
    }
    // trim the fullVersion string at semicolon/space if present
    if ((ix = fullVersion.indexOf(";")) != -1)
        fullVersion = fullVersion.substring(0, ix);
    if ((ix = fullVersion.indexOf(" ")) != -1)
        fullVersion = fullVersion.substring(0, ix);

    majorVersion = parseInt('' + fullVersion, 10);
    if (isNaN(majorVersion)) {
        fullVersion = '' + parseFloat(navigator.appVersion);
        majorVersion = parseInt(navigator.appVersion, 10);
    }

    var browserInfo = 'Browser name  = ' + browserName + '<br>'
        + 'Full version  = ' + fullVersion + '<br>'
        + 'Major version = ' + majorVersion + '<br>'
        + 'navigator.appName = ' + navigator.appName + '<br>'
        + 'navigator.userAgent = ' + navigator.userAgent + '<br>';

    return {
        info: browserInfo,
        name: browserName,
        fullVersion: fullVersion,
        majorVersion: majorVersion,
        navigatorAppName: navigator.appName,
        navigatorUserAgent: navigator.userAgent
    };
}

//validate input value to min and max
//function validateMinMax(val, min, max) {
//    var value = $(val).val();
//    if (parseInt(value) < min || isNaN(value))
//        return min;
//    else if (parseInt(value) > max)
//        return max;
//    else return value;
//}

function isNumber(event) {
    event = (event) ? event : window.event;
    var charCode = (event.which) ? event.which : event.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
        return false;
    }
    return true;
}

$(document).on('keyup keydown', '.minMaxValidate', function (e) {
    validateMinMax(this, e);
});

function validateMinMax(t, e) {
    var min = parseInt($(t).attr('data-attr-min'));
    var max = parseInt($(t).attr('data-attr-max'));

    if (e.keyCode != 46 && e.keyCode != 8) {
        if (parseInt($(t).val()) > max) {
            e.preventDefault();
            $(t).val(max);
        }
        else if (parseInt($(t).val()) < min) {
            e.preventDefault();
            $(t).val(min);
        }
        else {
            //$(this).val($(this).val());
        }
    }
}

//scroll to id
function scrollToId(o) { var n = $("#" + o); "undefined" != typeof n && "" != n && $("html, body").animate({ scrollTop: ($(n).offset() ? ($(n).offset().top - 95) : 0) }, 1300).promise().then(function () { $(n).focus() }) }

//Checks valid date
function isValidDate(a) { var e = new Date(a); return !("Invalid Date" == e) }
//Check valid json data
function isValidJson(r) { try { JSON.parse(r) } catch (n) { return !1 } return !0 }
//Convert date to dd MMM yyyy
function toddMMMyyy(input) {
    if (input && input != null && !("Invalid Date" == new Date(input))) {
        return moment(input).format("DD MMM YYYY");
        ////var validDate = new Date(input);
        //var validDate = new Date(new Date(input).toUTCString().split(' ', 4).join(' '))
        //var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        //return validDate.getDate() + " " + months[validDate.getMonth()] + " " + validDate.getFullYear();
    }
    else {
        return '';
    }
}

function toddmmyyyDatePicker(input) {
    if (input && input != null && !("Invalid Date" == new Date(input))) {
        return moment(input).format("MM/DD/YYYY");
        ////var validDate = new Date(input);
        //var validDate = new Date(new Date(input).toUTCString().split(' ', 4).join(' '))
        //var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        //return validDate.getDate() + " " + months[validDate.getMonth()] + " " + validDate.getFullYear();
    }
    else {
        return '';
    }
}

//Convert datetime to DD MMM YYYY hh:mm:ss a
function toddMMMYYYYHHMMSSAP(input) {
    if (input && input != null && !("Invalid Date" == new Date(input))) {
        return moment(input).format('DD MMM YYYY hh:mm:ss a');
    }
    else {
        return '';
    }
}

//Convert datetime to date, ignoring time
function toDate(input) {

    if (input && input != null && !("Invalid Date" == new Date(input))) {
        return new Date(moment(input).format("DD MMM YYYY"));
        //var validDate = new Date(new Date(input).toUTCString().split(' ', 4).join(' '))
        //return validDate;
    }
    else {
        return '';
    }
}

//Convert seconds to HH:MM
var toHHMM = function (totalSeconds) {
    if (totalSeconds && totalSeconds != null) {
        var hours = Math.floor(totalSeconds / 3600);
        var minutes = Math.floor((totalSeconds - (hours * 3600)) / 60);
        var result = (hours < 10 ? "0" + hours : hours);
        result += ":" + (minutes < 10 ? "0" + minutes : minutes);
        return result;
    }
    else {
        return "00:00";
    }
}

//get Alphabet lower/upper case with index (n) = 0,1,...
function getAlphabet(n, isUpperCase) {
    if (!isNaN(n) && (n > -1 || n < 26)) {
        if (isUpperCase && isUpperCase === true) {
            return String.fromCharCode(65 + n);
        }
        else {
            return String.fromCharCode(97 + n);
        }
    }
}

//Check if keys value exist in array
function isKeyValExist(attr, val, arry) {
    var result = -1;
    $.each(arry, function (index, item) {
        if (item[attr].toString() == val.toString()) {
            //if ((''+ item[attr]) == (''+ val)) {
            result = index;
            return false; // break the loop
        }
    });
    return (result > -1);
}

//Check if object exist in array
function isMultiKeyValExist(keyValObj, arry) {
    var result = false;
    $.each(arry, function (index, item) {
        var matchedCounter = 0;
        $.each(Object.keys(keyValObj), function (sIdx, sKey) {
            var isMatched = isKeyValExist(sKey, keyValObj[sKey], [item]); //here make item an array
            if (isMatched) {
                matchedCounter++;
            }
        });
        if (Object.keys(keyValObj).length === matchedCounter) {
            result = true;
            return false; // break the loop
        }
    });
    return result;
}

//Check if object exist in array, return that
function getMatchedObject(keyValObj, arry) {
    var result = [];
    $.each(arry, function (index, item) {
        var matchedCounter = 0;
        $.each(Object.keys(keyValObj), function (sIdx, sKey) {
            var isMatched = isKeyValExist(sKey, keyValObj[sKey], [item]); //here make item an array
            if (isMatched) {
                matchedCounter++;
            }
        });
        if (Object.keys(keyValObj).length === matchedCounter) {
            result = item;
            return false; // break the loop
        }
    });
    return result;
}

//Check if object exist in array, return all matched array of object
function getAllMatchedObject(keyValObj, arry) {
    var result = [];
    $.each(arry, function (index, item) {
        var matchedCounter = 0;
        $.each(Object.keys(keyValObj), function (sIdx, sKey) {
            var isMatched = isKeyValExist(sKey, keyValObj[sKey], [item]); //here make item an array
            if (isMatched) {
                matchedCounter++;
            }
        });
        if (Object.keys(keyValObj).length === matchedCounter) {
            result.push(item);
        }
    });
    return result;
}

//Check if object exist in array, skip that and return all unmatched array of object
function getAllUnmatchedObject(keyValObj, arry) {
    var result = [];
    $.each(arry, function (index, item) {
        var unMatchedCounter = 0;
        $.each(Object.keys(keyValObj), function (sIdx, sKey) {
            var isMatched = isKeyValExist(sKey, keyValObj[sKey], [item]); //here make item an array
            if (!isMatched) {
                unMatchedCounter++;
            }
        });
        if (Object.keys(keyValObj).length === unMatchedCounter) {
            result.push(item);
        }
    });
    return result;
}

//pick javascript object's properties and get Object
function pickProperties(obj, keys) {
    return keys.map(k => k in obj ? { [k]: obj[k] } : {})
        .reduce((res, o) => Object.assign(res, o), {});
}

//remove javascript object's properties and get Object
function rejectProperties(obj, keys) {
    return Object.keys(obj)
        .filter(k => !keys.includes(k))
        .map(k => Object.assign({}, { [k]: obj[k] }))
        .reduce((res, o) => Object.assign(res, o), {});
}

//get a subset of a javascript object's properties i.e. whitelist certain attributes and fetch whitelisted/selected 
function pickPropertiesAndGetObjects(arry, keysArry) {
    var result = [];
    $.each(arry, function (index, item) {
        result.push(pickProperties(item, keysArry));
    });
    return result;
}

//get a subset of a javascript object's properties after removing few i.e. blacklist certain attributes and fetch remaining
function rejectPropertiesAndGetObjects(arry, keysArry) {
    var result = [];
    $.each(arry, function (index, item) {
        result.push(rejectProperties(item, keysArry));
    });
    return result;
}

//get file extension
function getFileExtension(fileName) {
    var fileExt = fileName.substring(fileName.lastIndexOf('.') + 1);
    return fileExt;
}

//trim and get string/filename without extension
function trimExtension(fileName) {
    return fileName.substring(0, fileName.lastIndexOf("."));
}

//trim all spaces from start and end
String.prototype.trimStartAndEnd = function () {
    return this.replace(/^\s+|\s+$/gm, '').replace(/^\s+|\s+$/gm, ''); //trim all spaces from start and end
}

//trim multiple spaces from a string and also trims start and end spaces
String.prototype.trimString = function () {
    //return this.replace(/\s\s+/g, ' ');
    return this.replace(/\s\s+/gm, ' ').replace(/^\s+|\s+$/gm, ''); //trim multiple spaces from a string  and all spaces from start and end
}

//trim all spaces from a string
String.prototype.trimAll = function () {
    //return this.replace(/^\s+|\s+$/gm, '');//trim all spaces from start and end
    return this.replace(/^\s+|\s+/gm, '');//trim all spaces from a string
}

//format capital letter with space in between
String.prototype.formatWithSpace = function () {
    return this.replace(/([A-Z])/g, ' $1').trim();
}

//remove strings in beginning and end
String.prototype.strim = function (needle) {
    if (needle !== '' && needle !== null) {
        var out = this;
        while (0 === out.indexOf(needle))
            out = out.substr(needle.length);
        while (out.length === out.lastIndexOf(needle) + needle.length)
            out = out.slice(0, out.length - needle.length);
        return out;
    }
    else {
        return needle;
    }
}

//extending object
//Object.defineProperty(Object.prototype, 'extend', {
//    value: function (obj) {
//        
//        for (var i in obj) {
//            if (obj.hasOwnProperty(i)) {
//                this[i] = obj[i];
//            }
//        }
//    },
//    enumerable: false
//});

//verify if object is empty
function isEmpty(obj) {
    for (var prop in obj) {
        if (obj.hasOwnProperty(prop))
            return false;
    }

    return JSON.stringify(obj) === JSON.stringify({});
}

//verify if array
function isArray(object) {
    if (object.constructor === Array) return true;
    else return false;
}

//method to serialize form data
$.fn.serializeObject = function () {
    var o = {};
    var a = this.serializeArray();
    $.each(a, function () {
        if (o[this.name] !== undefined) {
            if (!o[this.name].push) {
                o[this.name] = [o[this.name]];
            }
            o[this.name].push(this.value || '');
        } else {
            o[this.name] = this.value || '';
        }
    });
    return o;
};

//add hidden Input
$.fn.addHiddenInput = function (n, d) { var e = $('<input type="hidden" id="' + n + '" name="' + n + '" />'); e.val(d), $(this).find("[type=hidden][name=" + n + "]").remove(), $(this).append(e) };

//add hidden Input data
$.fn.addHiddenInputData = function (a) { var n = {}, r = function (a, d) { for (var i in a) { var t = a[i]; if (d) var f = d + "[" + i + "]"; else var f = i; "object" != typeof t ? n[f] = t : r(t, f) } }; r(a); var d = $(this); for (var i in n) d.addHiddenInput(i, n[i]) };

//method to validate control
function validateControls(e) {
    $(function () {
        $("#" + e + " .validation-required").change(function () {
            var e = $(this),
                i = e.prop("tagName");
            "TEXTAREA" == i || "INPUT" == i ? "" == e.val().trim() || "0:00" == e.val() ? e.addClass("error-validation") : e.removeClass("error-validation")
                : (i = e.hasClass("select-validate")) ? 0 == e.val() ? (a = !1, e.addClass("error-validation")) : e.removeClass("error-validation")
                    : (i = e.hasClass("select2")) ? 0 == e.val() ? (a = !1, e.closest("div").find(".select2-selection").addClass("error-validation")) : e.closest("div").find(".select2-selection").removeClass("error-validation")
                        : (i = e.hasClass("multipleSelect")) && ("undefined" == typeof e.find("option:selected").val() ? (a = !1, e.closest("div").find(".btn-group>.multiselect").addClass("error-validation")) : e.closest("div").find(".btn-group>.multiselect").removeClass("error-validation"))
        });
        $("#" + e + " .validation-required").keyup(function () {
            var e = $(this),
                i = e.prop("tagName");
            "TEXTAREA" == i || "INPUT" == i ? "" == e.val().trim() || "0:00" == e.val() ? e.addClass("error-validation") : e.removeClass("error-validation")
                : (i = e.hasClass("select-validate")) ? 0 == e.val() ? (a = !1, e.addClass("error-validation")) : e.removeClass("error-validation")
                    : (i = e.hasClass("select2")) ? 0 == e.val() ? (a = !1, e.closest("div").find(".select2-selection").addClass("error-validation")) : e.closest("div").find(".select2-selection").removeClass("error-validation")
                        : (i = e.hasClass("multipleSelect")) && ("undefined" == typeof e.find("option:selected").val() ? (a = !1, e.closest("div").find(".btn-group>.multiselect").addClass("error-validation")) : e.closest("div").find(".btn-group>.multiselect").removeClass("error-validation"))
        });
    });
    var a = !0,
        i = $("#" + e + " .validation-required");
    return i.each(function (e, i) {
        var s = $(this),
            l = s.prop("tagName");
        "TEXTAREA" == l || "INPUT" == l ? "" == s.val().trim() || "0:00" == s.val() ? (a = !1, s.addClass("error-validation")) : s.removeClass("error-validation")
            : (l = s.hasClass("select-validate")) ? 0 == s.val() ? (a = !1, s.addClass("error-validation")) : s.removeClass("error-validation")
                : (l = s.hasClass("select2")) ? 0 == s.val() ? (a = !1, s.closest("div").find(".select2-selection").addClass("error-validation")) : s.closest("div").find(".select2-selection").removeClass("error-validation")
                    : (l = s.hasClass("multipleSelect")) && ("undefined" == typeof s.find("option:selected").val() ? (a = !1, s.closest("div").find(".btn-group>.multiselect").addClass("error-validation")) : s.closest("div").find(".btn-group>.multiselect").removeClass("error-validation"))
    }), a
}

var misSession = {
    userabrhs: sessionStorage['misSession.userabrhs'],
    username: sessionStorage['misSession.username'],
    displayname: sessionStorage['misSession.displayname'],
    userrole: sessionStorage['misSession.userrole'],
    roleid: sessionStorage['misSession.roleid'],
    company: sessionStorage['misSession.company'],
    companyid: sessionStorage['misSession.companyid'],
    companylocation: sessionStorage['misSession.companylocation'],
    companylocationid: sessionStorage['misSession.companylocationid'],
    countryid: sessionStorage['misSession.countryid'],
    stateid: sessionStorage['misSession.stateid'],
    cityid: sessionStorage['misSession.cityid'],
    currentappraisalcycleid: sessionStorage['misSession.currentappraisalcycleid'],
    goalcycleid: sessionStorage['misSession.goalcycleid'],
    fystartdate: sessionStorage['misSession.fystartdate'],
    fyenddate: sessionStorage['misSession.fyenddate'],
    fystartyear: sessionStorage['misSession.fystartyear'],
    currentquarter: sessionStorage['misSession.currentquarter'],
    token: sessionStorage['misSession.token'],
    imagePath: sessionStorage['misSession.imagePath'],
    apiVersion: sessionStorage['misSession.apiVersion'],
    menus: ((typeof sessionStorage['misSession.menus'] != 'undefined') ? $.parseJSON(sessionStorage['misSession.menus']) : ''),
    authenticate: function (username, password, remember) {
        if (misSession.token && misSession.userabrhs) {
            misSession.validateToken(misSession.token, misSession.userabrhs);
        }
        else if (username && password) {
            misSession.login(username, password, remember);
        }
        else {
            misSession.logout();
            redirectToURL(misAppUrl.login);
        }
    },
    getKey: function (username, password) {
        if (username && password) {
            return 'Basic ' + misCrypto.encode([username, password].join(':'));
        }
        else {
            return '';
        }
    },
    login: function (username, password, remember, errorCallback) {
        var bInfo = [getBrowserInfo().name, getBrowserInfo().fullVersion].join(' ');
        var cInfo = localStorage.getItem('clientInfo');
        if (username && password) {
            callToAjaxWithHeader(misApiUrl.authenticate, 'POST', null, { 'Authorization': misSession.getKey(username, password), 'BrowserInfo': bInfo, 'ClientInfo': (cInfo == 'null' ? '' : cInfo) },
                function (data, status, xhr) {
                    //clear session
                    misSession.logout();
                    if (xhr.status == 200) {
                        //set token
                        misSession.token = data.Token;//xhr.getResponseHeader("Token");
                        sessionStorage['misSession.token'] = misSession.token;

                        misSession.userabrhs = data.UserAbrhs;
                        sessionStorage['misSession.userabrhs'] = misSession.userabrhs;

                        misSession.username = username;
                        sessionStorage['misSession.username'] = misSession.username;

                        //var tokenExpiry = xhr.getResponseHeader('TokenExpiry');
                        //successfn(data);
                        redirectToURL(misAppUrl.home);
                    }
                    else {
                        misAlert(xhr.statusText);
                    }
                },
                function (xhr, status, errorThrown) {
                    if (typeof errorCallback === 'function') {
                        errorCallback(xhr, status, errorThrown);
                    }
                    //else if (xhr.status == 401) {
                    //    if (typeof errorCallback === 'function') {
                    //        errorCallback(xhr, status, errorThrown);
                    //    }
                    //}
                    else {
                        console.log(errorThrown + ': ' + (typeof xhr.responseJSON != 'undefined' ? xhr.responseJSON.MessageDetail : errorThrown));
                        misError();
                    }
                });
        }
        else if (misSession.token && misSession.userabrhs) {
            misSession.validateToken(misSession.token, misSession.userabrhs);
        }
        else {
            misSession.logout();
        }
    },
    ping: function () {
        if (misSession.token && misSession.userabrhs) {
            calltoAjax(misApiUrl.ping, 'GET', null, function (data, status, xhr) {
                if (xhr.status == 200 && data.IsAlive) {
                    return true;
                }
                else {
                    misSession.logout();
                    if (!(window.location.pathname.toLowerCase().indexOf('login') > -1)) {
                        misCountdownAlert('Your session has timed out. Please sign in again', 'Session Expired', 'warning', function () {
                            redirectToURL(misAppUrl.login);
                        }, false, 5);
                    }
                    return false;
                }
            });
        }
        else {
            misSession.logout();
        }
    },
    validateToken: function (token, userAbrhs) {
        if (token && userAbrhs) { //&& userAbrhs
            callToAjaxWithHeader(misApiUrl.userInfo, 'POST', null, { 'Token': token, 'UserAbrhs': userAbrhs },
                function (data, status, xhr) {
                    if (xhr.status == 200) {
                        //Persist user details locally
                        //misSession.userabrhs = data.UserAbrhs;
                        //sessionStorage['misSession.userabrhs'] = misSession.userabrhs;

                        misSession.username = data.UserName;
                        sessionStorage['misSession.username'] = misSession.username;

                        misSession.displayname = data.DisplayName;
                        sessionStorage['misSession.displayname'] = misSession.displayname;

                        misSession.userrole = data.Role;
                        sessionStorage['misSession.userrole'] = misSession.userrole;

                        misSession.roleid = data.RoleId;
                        sessionStorage['misSession.roleid'] = misSession.roleid;

                        misSession.company = data.Company;
                        sessionStorage['misSession.company'] = misSession.company;

                        misSession.companyid = data.CompanyId;
                        sessionStorage['misSession.companyid'] = misSession.companyid;

                        misSession.companylocation = data.CompanyLocation;
                        sessionStorage['misSession.companylocation'] = misSession.companylocation;

                        misSession.companylocationid = data.CompanyLocationId;
                        sessionStorage['misSession.companylocationid'] = misSession.companylocationid;

                        misSession.countryid = data.CountryId;
                        sessionStorage['misSession.countryid'] = misSession.countryid;

                        misSession.stateid = data.StateId;
                        sessionStorage['misSession.stateid'] = misSession.stateid;

                        misSession.cityid = data.CityId;
                        sessionStorage['misSession.cityid'] = misSession.cityid;

                        misSession.currentappraisalcycleid = data.CurrentAppraisalCycleId;
                        sessionStorage['misSession.currentappraisalcycleid'] = misSession.currentappraisalcycleid;

                        misSession.goalcycleid = data.GoalCycleId;
                        sessionStorage['misSession.goalcycleid'] = misSession.goalcycleid;

                        misSession.fystartdate = data.FYStartDate;
                        sessionStorage['misSession.fystartdate'] = misSession.fystartdate;

                        misSession.fyenddate = data.FYEndDate;
                        sessionStorage['misSession.fyenddate'] = misSession.fyenddate;

                        misSession.fystartyear = data.FYStartYear;
                        sessionStorage['misSession.fystartyear'] = misSession.fystartyear;

                        misSession.currentquarter = data.CurrentQuarter;
                        sessionStorage['misSession.currentquarter'] = misSession.currentquarter;

                        misSession.imagePath = data.ImagePath;
                        sessionStorage['misSession.imagePath'] = misSession.imagePath;

                        misSession.apiVersion = data.AppVersion;
                        sessionStorage['misSession.apiVersion'] = misSession.apiVersion;

                        misSession.menus = data.Menus;
                        sessionStorage['misSession.menus'] = JSON.stringify(misSession.menus);

                        redirectToURL(misAppUrl.dashboard);
                    }
                    else {
                        misAlert(xhr.statusText);
                        redirectToURL(misAppUrl.login);
                    }
                });
        }
    },
    logout: function () {
        sessionStorage.removeItem('misSession.userabrhs');
        misSession.userabrhs = null;

        sessionStorage.removeItem('misSession.username');
        misSession.username = null;

        sessionStorage.removeItem('misSession.displayname');
        misSession.displayname = null;

        sessionStorage.removeItem('misSession.userrole');
        misSession.userrole = null;

        sessionStorage.removeItem('misSession.roleid');
        misSession.roleid = null;

        sessionStorage.removeItem('misSession.company');
        misSession.company = null;

        sessionStorage.removeItem('misSession.companyid');
        misSession.companyid = null;

        sessionStorage.removeItem('misSession.companylocation');
        misSession.companylocation = null;

        sessionStorage.removeItem('misSession.companylocationid');
        misSession.companylocationid = null;

        sessionStorage.removeItem('misSession.countryid');
        misSession.countryid = null;

        sessionStorage.removeItem('misSession.stateid');
        misSession.stateid = null;

        sessionStorage.removeItem('misSession.cityid');
        misSession.cityid = null;

        sessionStorage.removeItem('misSession.currentappraisalcycleid');
        misSession.currentappraisalcycleid = null;

        sessionStorage.removeItem('misSession.goalcycleid');
        misSession.goalcycleid = null;

        sessionStorage.removeItem('misSession.fystartdate');
        misSession.fystartdate = null;

        sessionStorage.removeItem('misSession.fyenddate');
        misSession.fyenddate = null;

        sessionStorage.removeItem('misSession.fystartyear');
        misSession.fystartyear = null;

        sessionStorage.removeItem('misSession.currentquarter');
        misSession.currentquarter = null;

        sessionStorage.removeItem('misSession.token');
        misSession.token = null;

        //sessionStorage.removeItem('misSession.imagePath');
        //misSession.imagePath = null;

        sessionStorage.removeItem('misSession.apiVersion');
        misSession.apiVersion = null;

        sessionStorage.removeItem('misSession.menus');
        misSession.menus = null;
    },
    signoff: function () {

        //if (misSession.token && misSession.userabrhs) {
        //    var jsonObject = { userAbrhs: misSession.userabrhs };
        //    misSession.logout();
        //    calltoAjax(misApiUrl.signOff, "POST", jsonObject,
        //     function (data, status, xhr) {
        //         redirectToURL(misAppUrl.login);
        //     }, function () {
        //         redirectToURL(misAppUrl.login);
        //     });
        //}
        misSession.logout();
        redirectToURL(misAppUrl.login);
    },
    validateAccess: function () {
        var pgArry = window.location.pathname.substr(window.location.pathname.indexOf("/") + 1).split('/');
        var pgCtrl = '';
        var pgAct = '';
        if (pgArry.length > 0) {
            pgCtrl = pgArry[pgArry.length - pgArry.length];
            pgAct = pgArry[pgArry.length - 1];
        }
        //authenticate access, before navigating
        if (!(pgCtrl.toLowerCase() === 'error')) {
            var searchObj = { 'ControllerName': pgCtrl, 'ActionName': pgAct };
            var hasValidAccess = isMultiKeyValExist(searchObj, misSession.menus);
            if (!hasValidAccess) {
                redirectToURL(misAppUrl.unauthorized);
            }
        }
    }
};

var misPermissions = function () {
    var pgArry = window.location.pathname.substr(window.location.pathname.indexOf("/") + 1).split('/');
    var pgCtrl = '';
    var pgAct = '';
    if (pgArry.length > 0) {
        pgCtrl = pgArry[pgArry.length - pgArry.length];
        pgAct = pgArry[pgArry.length - 1];
    }
    var searchObj = { 'ControllerName': pgCtrl, 'ActionName': pgAct };

    //if (!(misSession.menus.length > 0))
    //    misSession.logout();

    var accessObj = getMatchedObject(searchObj, misSession.menus);
    return {
        isDelegatable: (accessObj['IsDelegatable'] === true),
        isDelegated: (accessObj['IsDelegated'] === true),
        isTabMenu: (accessObj['IsTabMenu'] === true),
        menuAbrhs: (accessObj['MenuAbrhs']),
        parentMenuAbrhs: (accessObj['ParentMenuAbrhs']),

        hasViewRights: (accessObj['IsViewRights'] === true),
        hasAddRights: (accessObj['IsAddRights'] === true),
        hasModifyRights: (accessObj['IsModifyRights'] === true),
        hasDeleteRights: (accessObj['IsDeleteRights'] === true),
        hasApproveRights: (accessObj['IsApproveRights'] === true),
        hasAssignRights: (accessObj['IsAssignRights'] === true),
        hasActionRights: (accessObj['IsViewRights'] === true && (accessObj['IsAddRights'] === true || accessObj['IsModifyRights'] === true
            || accessObj['IsDeleteRights'] === true || accessObj['IsApproveRights'] === true || accessObj['IsAssignRights'] === true)),
    };
}();

//convert object into array
//Object.prototype.objectToArray = function () {
//    
//    var obj = this;
//    var arry = Object.keys(obj).map(function (k) {
//        return obj[k];
//    });
//    return arry;
//    //Object.keys(obj).map(function (k) { return obj[k] });
//}

//Load bootstrap multiselect without data
function loadEmptyMultiSelect(ddltarget) {
    var $ddl = $('#' + ddltarget);
    $ddl.multiselect();
}
//bootstrap multiselect dropdown
function destroyMultiselect(ddltarget) {
    var $ddl = $('#' + ddltarget);
    $ddl.empty();
    $ddl.multiselect('destroy');
}

//Load popup modal
function loadModal(a, n, d, o, i, j) { ("undefined" == typeof i || null == i) && (i = {}), $.ajaxSetup({ cache: !1 }); try { if (!(typeof (j) === "boolean")) { j = false; } var t = $("#" + a), e = $("#" + n); o && e.empty().append('<span class="loading" id="divLoading">Loading...</span>'), t.modal({ keyboard: j, backdrop: (j === false ? 'static' : true) }), $.get(d, i, function (a) { e.html(a) }).done(function () { o && $("#divLoading").hide() }).error(function (a) { }) } catch (c) { } }

// To hide Modal.
function hideModal(ModalId) {
    if (ModalId) {
        $("#" + ModalId).modal('hide');
    }
}

//method to block a container or page
function blockContainer(message, containerId) {
    var settings = {
        message: '<h4>' + (message || "One moment please...") + '</h4>',
        css: {
            border: 'none', padding: '15px', backgroundColor: '#fff', color: '#283146', opacity: 1,
            '-webkit-border-radius': '4px',
            '-moz-border-radius': '4px',
            '-webkit-box-shadow': '1px 1px 7px 1px #64daf6',
            'box-shadow': '1px 1px 7px 1px #64daf6'
        },
        overlayCSS: { opacity: 1, backgroundColor: '#283146', cursor: 'default' }
    };
    if (typeof containerId != 'undefined') {
        $('#' + containerId).block(settings);
    }
    else {
        $.blockUI(settings);
    }
}

//method to update blocked container message
function updateBlockedContainer(message) {
    $($('.blockMsg h4')[0]).html(message || "One moment please...")
}

//method to unblock the blocked container or page
function unBlockContainer(containerId) {
    if (typeof containerId != 'undefined') {
        $('#' + containerId).unblock();
    }
    else {
        $.unblockUI();
    }
}

//Load a page to html element container
//a=path, b=html container, c=options, d=cache
function loadUrlToId(a, b, c, d) { ("undefined" == typeof d || null == d) && (d = {}), $.ajaxSetup({ cache: !1 /*, headers: { 'Token': misSession.token }*/ }); try { (null == c || "undefined" == typeof c) && (c = {}), $.get(a, c, function (a) { $("#" + b).empty().append(a) }) } catch (a) { } return !1 }

//method to load editor to a container id
function loadEditorToId(containerId, height) {
    if (containerId) {
        var instance = CKEDITOR.instances[containerId];
        if (instance) { instance.destroy(true); }
        CKEDITOR.replace(containerId, {
            height: height || 100,
            //extraPlugins: 'imageuploader'
        });
    }
}

//method to load editor to container class
function loadEditorToClass(containerClass) {
    if (containerClass) {
        var $editors = $("." + containerClass);
        if ($editors.length) {
            $editors.each(function () {
                var editorId = $(this).attr("id");
                var instance = CKEDITOR.instances[editorId];
                if (instance) { instance.destroy(true); }
                CKEDITOR.replace(editorId);
            });
        }
    }
}

function isNumber(event) {
    event = (event) ? event : window.event;
    var charCode = (event.which) ? event.which : event.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
        return false;
    }
    return true;
}

function printDiv(divId) {
    Popup($("#" + divId).html());

}

function Popup(data) {
    var mywindow = window.open('', 'my div', 'height=400,width=600');
    mywindow.document.write('<html><head><title>my div</title>');
    /*optional stylesheet*/ //mywindow.document.write('<link rel="stylesheet" href="main.css" type="text/css" />');
    mywindow.document.write('</head><body >');
    mywindow.document.write(data);
    mywindow.document.write('</body></html>');

    mywindow.document.close(); // necessary for IE >= 10
    mywindow.focus(); // necessary for IE >= 10

    mywindow.print();
    mywindow.close();

    return true;
}

function CheckPasswordStrength(password) {
    var password_strength = document.getElementById("password_strength");

    //TextBox left blank.
    if (password.length == 0) {
        password_strength.innerHTML = "";
        return;
    }

    //Regular Expressions.
    var regex = new Array();
    regex.push("[A-Z]"); //Uppercase Alphabet.
    regex.push("[a-z]"); //Lowercase Alphabet.
    regex.push("[0-9]"); //Digit.
    regex.push("[$@$!%*#?&]"); //Special Character.

    var passed = 0;

    //Validate for each Regular Expression.
    for (var i = 0; i < regex.length; i++) {
        if (new RegExp(regex[i]).test(password)) {
            passed++;
        }
    }

    //Validate for length of Password.
    if (passed > 2 && password.length > 8) {
        passed++;
    }

    //Display status.
    var color = "";
    var strength = "";
    switch (passed) {
        case 0:
        case 1:
            strength = "Weak";
            color = "red";
            break;
        case 2:
            strength = "Good";
            color = "darkorange";
            break;
        case 3:
        case 4:
            strength = "Strong";
            color = "green";
            break;
        case 5:
            strength = "Very Strong";
            color = "darkgreen";
            break;
    }
    password_strength.innerHTML = strength;
    password_strength.style.color = color;
}

var specialKeys = new Array();
specialKeys.push(8); //Backspace
specialKeys.push(9); //Tab
specialKeys.push(46); //Delete
specialKeys.push(36); //Home
specialKeys.push(35); //End
specialKeys.push(37); //Left
specialKeys.push(39); //Right

function IsAlphaNumeric(e) {

    var keyCode = e.keyCode == 0 ? e.charCode : e.keyCode;
    var ret = ((keyCode >= 48 && keyCode <= 57) || (keyCode >= 65 && keyCode <= 90) || (keyCode == 38) || (keyCode == 47) || (keyCode == 44) || (keyCode >= 97 && keyCode <= 122) || (keyCode == 32) || (keyCode == 40) || (keyCode == 45) || (keyCode == 41) || (keyCode == 95) || (specialKeys.indexOf(e.keyCode) != -1 && e.charCode != e.keyCode));
    return ret;
}

function IsAlphaNumericValidate(e) {
    var controlname = e;
    cString = $("#" + controlname + "").val();
    var patt = /[^0-9a-zA-Z\_\-\(\ )\ \&\,\/\s]/
    if (!cString.match(patt)) {
    }
    else {
        misAlert("Please do not enter special characters !");
        return false;
        $("#" + controlname + "").val("");
        $("#" + controlname + "").focus();
    }
}

function blockSpecialChar(e) {
    evt = (e) ? e : event;
    var k = evt.which || evt.charCode || evt.keyCode || 0;
    return ((k > 64 && k < 91) || (k > 96 && k < 123) || k == 8 || (k >= 48 && k <= 57) || (k == 32 || k == 44 || k == 46 || k == 40 || k == 41 || k == 42 || k == 38 || k == 64 || k == 63 || k == 58 || k == 59));
}

function addElipsis(string, limit) {
    var dots = "...";
    if (string.length > limit) {
        string = string.substring(0, limit) + dots;
    }
    return string;
}