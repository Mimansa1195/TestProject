var _refId;

$(function () {
    blockContainer('One moment please while we collect your information...');
    var url = window.location.search;
    if (url == '') {
        misSession.signoff();
    }
    else {
        url = url.replace("?", '');
        if (url.indexOf('=') === -1) {
            misSession.signoff();
        }
        else {
            if (url.split('=')[0] != "RefId") {
                misSession.signoff();
            }
            else {
                _refId = url.split('=')[1];
                var jsonObject = {
                    passwordResetCode: _refId,
                };
                $.ajax({
                    url: misApiUrl.validateQueryString,
                    type: "GET",
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    data: jsonObject,
                    global: false,
                    success: function (data) {
                        if (data == null) {
                            updateBlockedContainer('Your password reset link has expired...');
                            setTimeout(function () { misSession.signoff(); }, 1500);
                        }
                        else {
                            $("#userName").val(data);
                            unBlockContainer();
                            $("#loginContainer").show();
                        }
                    },
                    error: function() {
                        blockContainer('Your request cannot be processed, please try after some time or contact to MIS team for further assistance.');
                        setTimeout(function () { misSession.signoff(); }, 1500);
                    }
                });
            }
        }
    }
});

function resetPassword() {
    if (!validateControls('passwordResetDiv')) {
        return false;
    }
    if (!confirmPassword()) {
        return false;
    }
    var jsonObject = {
        passwordResetCode: _refId,
        userName: $("#userName").val(),
        password: $("#password").val(),
    };
    $.ajax({
        url: misApiUrl.resetPassword,
        type: "GET",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: jsonObject,
        success: function (data) {
            if (data == 1) {
                misCountdownAlert('Your password has been reset successfully. Please sign in again', 'Success', 'success', function () {
                    misSession.signoff();
                }, false, 5);
            }
            else if (data == 2) {
                misAlert("You are not authorised to view this page", "Warning", "warning");
                misSession.signoff();
            }
            else if (data == 3) {
                misAlert("Your new password can not be same as old password.", "Warning", "warning");
            }
            else//error
            {
                misAlert("Error occured", "Error", "error");
            }
        }
    });
}

function confirmPassword() {
    var pass1 = document.getElementById("password").value;
    var pass2 = document.getElementById("confirmPassword").value;
    if (pass1 != pass2) {
        $("#password_match").html("Password and confirm password does not match.");
        return false;
    }
    else {
        $("#password_match").html("");
    }
    return true;
}