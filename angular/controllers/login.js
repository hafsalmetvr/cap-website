/* Controllers */
angular.module('cap.controllers.login', []).

controller('PasswordCtrl', ['$scope', '$element', '$http', '$timeout', '$window', '$cookies',
    function($scope, $element, $http, $timeout, $window, $cookies) {

        $scope.init = function(token){
            $scope.password  = '';
            $scope.password2 = '';
            $scope.token     = token;
            $scope.success   = false;
            $scope.inProgress = false;
        }

        $scope.submitPassword = function(){
            $scope.inProgress = true;

            console.log($scope.token_value);
            /* validate new and confirm pwords */
            if (
                ($scope.password != '' && $scope.password2 != '') &&
                ($scope.password === $scope.password2)
                ) {

                var params = {
                    'password': $scope.password,
                    'password2': $scope.password2,
                    'token': $scope.token
                }

                $http.post("/password",angular.toJson(params)).success(function(data, status) {
                    if(data.success){
                        $scope.success = true;
                        $scope.msg = "Password changed successfully";
                        $window.location.href = "/dashboard";
                    } else {
                        $scope.success = false;
                        $scope.msg = "Unable to set your password.  Please contact your administrator.";
                        $scope.inProgress = false;
                    }
                }).error(function(data, success){
                    $scope.success = false;
                    $scope.msg = "Unable to set your password.  Please contact your administrator.";
                    $scope.inProgress = false;
                });

            } else {
                $scope.inProgress = false;
                $scope.msg = "Please make sure the passwords match.";
            }
        }
    }
]).
controller('LoginCtrl', ['$scope', '$element', '$http', '$timeout', '$window', '$cookies',
    function($scope, $element, $http, $timeout, $window, $cookies) {

        $scope.init = function(){
            $scope.email = '';
            $scope.password = '';
            $scope.success = false;
        }

        $scope.submitLogin = function() {
            console.log('submit login');
            if ($scope.loginForm.$pristine) {
                return;
            }
            if (!$scope.loginForm.$valid) {
                $scope.msg = "Your email or password was incorrect.";
            } else {

                $scope.inProgress = true;
                $scope.success    = true;
                $scope.msg        = "Logging in...";

                var params = {
                    'email': $scope.email,
                    'password': $scope.password,
                }

                $http({
                    method: 'post',
                    url: "/login",
                    data: angular.toJson(params),
                    headers: {
                        'Content-Type': 'application/json'
                    }
                }).success(function(data, status) {
                    if(data.login){
                        $scope.inProgress = false;

                        $timeout(function() {
                            $window.location.href = '/dashboard';
                        });
                        //document.location.href = "./dashboard";
                    } else {
                        $scope.inProgress = false;
                        $scope.success = false;
                        $scope.msg = data.message || "Your email or password was incorrect.";
                    }

                }).error(function(data, success){
                    $scope.success = false;
                    $scope.inProgress = false;
                    $scope.msg = "An internal error ocurred. Please contact your administrator.";
                });
            }
        }

    }
]).
controller('ResetPasswordCtrl', ['$scope', '$window', '$http',
	function($scope, $window, $http) {
        $scope.init = function(){
            $scope.email = '';
            $scope.success = false;
        }

        $scope.submitResetPassword = function() {
            console.log('submit login');
            if ($scope.resetPasswordForm.$pristine) {
                return;
            }

            if (!$scope.resetPasswordForm.$valid) {
                $scope.msg = "That email address is invalid.";
            } else {
                $scope.inProgress = true;
                $scope.success    = true;
                $scope.msg        = "Sending reset password email...";

                var params = {
                    'email': $scope.email,
                }

                $http({
                    method: 'post',
                    url: "/password-email",
                    data: angular.toJson(params),
                    headers: {
                        'Content-Type': 'application/json'
                    }
                }).success(function(data, status) {
                    if(data.success){
                        $scope.inProgress = false;
                        $scope.success = true;
                        $scope.msg = data.message;
                    } else {
                        $scope.inProgress = false;
                        $scope.success = false;
                        $scope.msg = data.message || "Your email address was not found.";
                    }

                }).error(function(data, success){
                    $scope.success = false;
                    $scope.inProgress = false;
                    $scope.msg = "An internal error ocurred. Please contact your administrator.";
                });
            }
        }


	}
]);
