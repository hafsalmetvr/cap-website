/* Controllers */
angular.module('cap.controllers.mentee', []).

controller('DashboardCtrl', ['$scope', '$element', '$http', '$timeout', '$window', '$cookies', 'customer',
  function($scope, $element, $http, $timeout, $window, $cookies, customer) {
  	$scope.init = function() {
			/* fetch the logged in identity */
			customer.get(function(result) {
				$scope.customer = result;
				console.log($scope.customer);

        $http.get('/rest/dashboard').success(function(data, status) {
        	console.log(data);
        	$scope.mentors = data.mentors;
        	$scope.saqList = data.saqs;
        }).error(function(data, status){
          console.log(data);
        });

			});
		}
  }
]).

controller('MentorCtrl', ['$scope', '$element', '$http', '$timeout', '$window', '$cookies',
  function($scope, $element, $http, $timeout, $window, $cookies) {
  }
]).
controller('QuestionnairePageCtrl', ['$scope', '$element', '$http', '$timeout', '$cookies', 'customer',
	function($scope, $element, $http, $timeout, $cookies, customer) {
	}
]).
controller('QuestionnaireCtrl', ['$scope', '$element', '$http', '$timeout', '$window', '$cookies',
  function($scope, $element, $http, $timeout, $window, $cookies) {
  }
]);

