//angular.module('misApp', []).service('UserService', ['$http', function ($http) {

//    this.callToAngularApiWithHeader = function (url, method, data, headers) {
//        return $http({
//            url: url,
//            method: method || 'GET',
//            headers: headers || {},
//            params: (typeof data != 'undefined') ? JSON.stringify(data) : {},
//            contentType: "application/json; charset=utf-8",
//            dataType: "json",
//        });
//    }

//    this.callToAngularApi = function (url, method, data) {
//        var token = misSession.token;
//        if (token) {
//            return this.callToAngularApiWithHeader(url, method, data, { 'Token': token });
//        }
//        else {
//            misSession.logout();
//            redirectToURL(misAppUrl.login);
//        }
//    }
//}]);