var misLogin = function () {
    var handleLogin = function () {
        $('.login-form').validate({
            errorElement: 'span', //default input error message container
            errorClass: 'help-block', // default input error message class
            focusInvalid: false, // do not focus the last invalid input
            rules: {
                username: {
                    required: true
                },
                password: {
                    required: true
                },
                remember: {
                    required: false
                }
            },

            messages: {
                username: {
                    required: "Username is required."
                },
                password: {
                    required: "Password is required."
                }
            },
            invalidHandler: function (event, validator) { //display error alert on submit   
                var errors = validator.numberOfInvalids();
                //if (errors) {
                //    validator.showErrors();
                //    // Do any work after errors are shown here.
                //}
                if (errors > 1) {
                    showAlert('Enter your username and password.');
                }
                else {
                    if (validator.errorList && validator.errorList[0].message) {
                        showAlert(validator.errorList[0].message);
                    }
                }
            },
            highlight: function (element) { // hightlight error inputs
                $(element).closest('.form-group').addClass('has-error'); // set error class to the control group
            },
            success: function (label, validtr) {
                label.closest('.form-group').removeClass('has-error');
                label.remove();
                //
                var formElement = $(".login-form");
                var validator = $(formElement).validate();
                if (validator && validator.numberOfInvalids() === 0) {
                    hideAlert();
                }
                else {
                    //showAlert('Enter your username and password.');
                }
            },
            errorPlacement: function (error, element) {
                //if (element.closest('.form-control') && element.closest('.form-control')[0].id === 'password') {
                //    error.insertAfter(element.closest('.input-group'));
                //}
                //else {
                error.insertAfter(element.closest('.form-control'));
                //}
            },
            submitHandler: function (form) {
                hideAlert();
            }
        });
    }

    var showAlert = function (msg) {
        if (msg) {
            $('.alert-danger .message').html(msg);
        }
        $('.alert-danger').show();
    }
    var hideAlert = function () {
        $('.alert-danger').hide();
    }

    var validateLoginForm = function () {
        return $('.login-form').validate().form();
    }

    var validateCaptcha = function () {
        return ($('#g-recaptcha-response') && $('#g-recaptcha-response').val() !== '');
    }

    return {
        init: function () {
            handleLogin();
            misSession.login();
        },
        isFormValid: function () {
            return validateLoginForm();
        },
        authenticateUser: function () {
            if (!validateLoginForm()) {
                return false;
            }
            if (!validateCaptcha()) {
                showAlert('Please fill the captcha and try again.');
                return false;
            }
            
            hideAlert();            
            misSession.login($("#username").val(), $("#password").val(), $("#remember").is(':checked'), function (xhr, status, errorThrown) {
                if (xhr.responseJSON && !isEmpty(xhr.responseJSON) && !xhr.responseJSON.IsSuccessful) {
                    var response = xhr.responseJSON;
                    if (xhr.status === 302) {
                        misCountdownAlert('Your password has expired. Please change it now and login again. Redirecting', response.Message, 'warning', function () {
                            if (!isEmpty(response.Result) && response.Result.IsRedirect === true) {
                                redirectToURL(misAppUrl.passwordReset + response.Result.PasswordResetCode);
                            }
                            else {
                                redirectToURL(misAppUrl.login);
                            }
                        }, false, 10);
                    }
                    else if (xhr.status === 401) {//wrong password
                        if (!isEmpty(response.Result) && response.Result.LeftAttempts > 0) {
                            var message = 'The username or password you entered is not valid. ' + response.Result.LeftAttempts + ' attempts left.'
                            showAlert(message);
                        }
                        else {
                            showAlert('The username or password you entered is not valid. Please try again.');
                        }
                    }
                    else if (xhr.status === 410 || xhr.status === 403) {
                        misAlert(response.Message, response.Message, 'warning');
                    }
                    else {
                        showAlert('The username or password you entered is not valid. Please try again.');
                        return false;
                    }
                }
                else {
                    showAlert('The username or password you entered is not valid. Please try again.');
                    return false;
                }
            });
        },
        showAlert: function (msg) {
            showAlert(msg);
        },
        hideAlert: function () {
            hideAlert();
        },
        isCaptchaValid: function () {
            return validateCaptcha();
        }
    };
}();

$(document).keypress(function (e) {
    if (e.which === 13) {
        if ($("#btnLogin").attr("onclick").indexOf('userLogin') > -1) {
            misLogin.authenticateUser();
        }
        else if ($("#btnLogin").attr("onclick").indexOf('forgotPassword') > -1) {
            forgotPassword();
        }
        else {
            misLogin.showAlert('Invalid login form, contact to MIS team for further assistance.');
        }
    }
});

$(function () {
    $("#lnkForgotPassword").click(function () {
        contractDiv();
    });

    $("#lnkSignIn").click(function () {
        expandDiv();
    });

    fetchClientInfo();
    misLogin.init();
    var imagepath = typeof misSession.imagePath === "undefined" ? "../img/avatar-sign.png" : misSession.imagePath;
   $("#user-avatar").attr("src", imagepath);
});

function userLogin() {
    misLogin.authenticateUser();
}

function fetchClientInfo() {
    var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
    $.ajax({
        url: clientIPUrl,
        success: function (response) {
            var info = {
                device: (isMobile === true) ? "Mobile" : "Personal Computer"
            };
            if (typeof (response) === 'object') {
                $.extend(info, response);
            }
            localStorage.setItem('clientInfo', JSON.stringify(info));
        }
    });
}

function contractDiv() {
    $("#password").hide();

    misLogin.isFormValid();
    misLogin.hideAlert();

    $("#btnLogin").removeAttr("onclick");
    $("#btnLogin").attr("onclick", "forgotPassword()")
    $("#btnLogin").val("Reset Password");

    $("#lnkForgotPassword").hide();
    $("#lnkSignIn").show();

    $("#loginTitle").text("Reset Password");
}

function expandDiv() {
    $("#password").show();
    misLogin.isFormValid();
    misLogin.hideAlert();

    $("#btnLogin").removeAttr("onclick");
    $("#btnLogin").attr("onclick", "userLogin()")
    $("#btnLogin").val("Sign In");

    $("#lnkForgotPassword").show();
    $("#lnkSignIn").hide();

    $("#loginTitle").text("Sign In");
}

function forgotPassword() {       
    if ($("#username").val() === "") {
        misLogin.showAlert("Enter your username.");
        return false;
    }
    if (!misLogin.isCaptchaValid()) {
        misLogin.showAlert('Please fill the captcha and try again.');
        return false;
    }
    misLogin.hideAlert();
    var cIp = 'public';
    var cInfo = localStorage.getItem('clientInfo');
    if (cInfo !== 'null' && cInfo !== null) {
        var data = $.parseJSON(cInfo)
        if (typeof data === 'object') {
            cIp = data.query + ' (' + data.city + ', ' + data.country + ')';
        }
    }
    var jsonObject = {
        userName: $("#username").val(),
        redirectionLink: misAppUrl.passwordReset,
        clientIP: cIp
    };

    calltoAjaxAnonymous(misApiUrl.generateCodeForResetPassword, "POST", jsonObject,
                function (result) {
                    var resultData = $.parseJSON(JSON.stringify(result));
                    switch (resultData) {
                        case 1:
                            misLogin.showAlert("You are not authorised to perform the action");
                            break;
                        case 2:
                            misLogin.showAlert("Account is currently locked");
                            break;
                        case 3:
                            misLogin.showAlert("Error occured");
                            break;
                        case 4:
                            misAlert("Password reset link sent to your official email. Kindly visit to change.", "Success", "success");
                            break;
                    }
                });
    //$.ajax({
    //    url: misApiUrl.generateCodeForResetPassword,
    //    type: "POST",
    //    dataType: "json",
    //    data: jsonObject,
    //    success: function (data) {
    //        switch (data) {
    //            case 1: //user does not exists
    //                misLogin.showAlert("You are not authorised to perform the action");
    //                break;
    //            case 2: //user account is locked
    //                misLogin.showAlert("Account is currently locked");
    //                break;
    //            case 3: //error occured
    //                misLogin.showAlert("Error occured");
    //                break;
    //            case 4: //success
    //                misAlert("Password reset link sent to your official email. Kindly visit to change.", "Success", "success");
    //                expandDiv();
    //                break;
    //        }
    //    }
    //});
}