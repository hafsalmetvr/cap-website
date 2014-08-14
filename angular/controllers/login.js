/* Controllers */
angular.module('cap.controllers.login', []).

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
                        $scope.msg = data.msg || "Your email or password was incorrect.";
                    }

                }).error(function(data, success){
                    $scope.inProgress = false;
                    $scope.msg = "An internal error ocurred. Please contact your administrator.";
                });
            }
        }

    }
]).


controller('FooCtrl', ['$scope', '$window',
	function($scope, $window) {
	}
]);
