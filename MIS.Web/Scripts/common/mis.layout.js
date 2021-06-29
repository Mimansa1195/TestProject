var misLayout = function () {
    //var hasSubMenu = function (menuId, menus) {
    var hasSubMenu = function (menuAbrhs, menus) {
        //return isKeyValExist('ParentMenuId', menuId, menus);
        return isKeyValExist('ParentMenuAbrhs', menuAbrhs, menus);

    };

    var bindMenu = function () {
        if (misSession.token) {
            if (misSession.menus && misSession.menus.length > 0) {
                var menu = misSession.menus;
                var pgArry = window.location.pathname.substr(window.location.pathname.indexOf("/") + 1).split('/');
                var pgCtrl = '';
                var pgAct = '';

                if (pgArry.length > 0) {
                    pgCtrl = pgArry[pgArry.length - pgArry.length];
                    pgAct = pgArry[pgArry.length - 1];
                }

                var parent = menu.filter(function (el) {
                    //return (el.ParentMenuId === 0 && el.IsVisible !== false);
                    return (el.IsParentMenu === true && el.IsVisible !== false);
                });
                var html = '';
                $.each(parent, function (idx, item) {
                    var activeP = '';
                    var cssClass = item.CssClass || '';
                    if (item.ControllerName === pgCtrl) {
                        activeP = ' active';
                    }
                    var pLink = (item.IsLinkEnabled ? (misAppBaseUrl + "/" + item.ControllerName + '/' + item.ActionName) : 'javascript:void(0)');
                    //var hasChild = hasSubMenu(item.MenuId, menu);
                    var hasChild = hasSubMenu(item.MenuAbrhs, menu);

                    if (hasChild) {
                        if (activeP !== '') {
                            activeP += ' opened';
                        }
                        html += '<li class="magenta with-sub' + activeP + '">' +
                            '<span><i class="' + cssClass + '"></i><span class="lbl">' + item.MenuName + '</span></span>';
                        var child = menu.filter(function (el) {
                            //return (el.ParentMenuId === item.MenuId && el.IsVisible !== false);
                            return (el.ParentMenuAbrhs === item.MenuAbrhs && el.IsVisible !== false);

                        });
                        var cHtml = '<ul>';
                        $.each(child, function (chIdx, chItem) {
                            var activeC = '';
                            if (chItem.ControllerName === pgCtrl && chItem.ActionName === pgAct) {
                                activeC = ' class="active"';
                            }
                            var cLink = misAppBaseUrl + "/" + chItem.ControllerName + '/' + chItem.ActionName;
                            if (chItem.ControllerName === 'AccountsPortal' && chItem.ActionName === 'MyAccount')
                                cHtml += '<li' + activeC + '><a href="' + accountPortalUrl + '" target="_blank" ><span class="lbl">' + chItem.MenuName + '</span></a></li>';
                            else
                                cHtml += '<li' + activeC + '><a href="' + cLink + '"><span class="lbl">' + chItem.MenuName + '</span></a></li>';
                        });
                        cHtml += '</ul>';
                        html += cHtml;
                    }
                    else {
                        html += '<li class="magenta' + activeP + '"><a href="' + pLink + '"><i class="' + cssClass + '"></i><span class="lbl">' + item.MenuName + '</span></a>';
                    }
                    html += '</li>';
                });
                var $ul = $('<ul class="side-menu-list"></ul>');
                $("#navMenu").replaceWith($ul);
                $ul.append(html);
            }
            else {
                misSession.authenticate();
            }
        }
        else {
            misSession.logout();
            redirectToURL(misAppUrl.login);
        }
    };

    var layoutInit = function () {
        $('.panel').on('dragged.lobiPanel', function (ev, lobiPanel) {
            $('.dashboard-column').matchHeight();
        });

        $("#dashBoardSettings").click(function () {
            loadModal("myModalDashBoardSettings", "DashBoardSettings", misAppUrl.dashBoardSetting, true);
        });

        $("#skills").click(function () {
            loadModal("mypopupUpdateSkills", "skillsSettings", misAppUrl.skills, true);
        });

        $("#helpDoc").click(function () {
            loadModal("mypopupHelpDoc", "helpDocument", misAppUrl.helpDocument, true);
        });

        $("#updateProfile").click(function () {
            loadModal("mypopupUpdateProfile", "divUpdateProfile", misAppUrl.updateProfile, true);
        });

        $("#btnUpdateProfile").click(function () {
            loadModal("mypopupUpdateProfile", "divUpdateProfile", misAppUrl.updateProfile, true);
        });

        $("#btnUserDelegation").click(function () {
            loadModal("mypopupUserDelegation", "divUserDelegation", misAppUrl.userDelegation, true);
        });
        var imagepath = misSession.imagePath == "" ? "../img/avatar-sign.png" : misSession.imagePath;
        $("#userImage").attr("src", imagepath);
    };

    return {
        init: function () {
            bindMenu();
            layoutInit();
        },
    };
}();








