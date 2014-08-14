/* Controllers */
angular.module('cap.controllers.admin', []).

controller('SAQCtrl', ['$scope', '$element', '$http', '$timeout', '$cookies', 'customer',
	function($scope, $element, $http, $timeout, $cookies, customer) {
	}
]).
controller('MentorCtrl', ['$scope', '$element', '$http', '$timeout', '$cookies', 'customer',
	function($scope, $element, $http, $timeout, $cookies, customer) {
		$scope.init = function(mentorId) {
			$scope.mentorId = mentorId;

			/* get listr of mentees */
	    $http.get('/rest/mentor/'+$scope.mentorId, {
	        headers: {'Content-Type': 'application/json'}
	    }).success(function(data, status) {
	    	console.log(data);
	    	$scope.mentees = data.mentees;
	    }).error(function(data, status){
	      console.log(data);
	    });
	  }
	}
]).
controller('MenteeCtrl', ['$scope', '$element', '$http', '$timeout', '$cookies', 'customer',
	function($scope, $element, $http, $timeout, $cookies, customer) {
	}
]).
controller('AdminCtrl', ['$scope', '$element', '$http', '$timeout', '$cookies', 'customer',
	function($scope, $element, $http, $timeout, $cookies, customer) {
	}
]).
controller('SettingsCtrl', ['$scope', '$element', '$http', '$timeout', '$cookies', 'customer',
	function($scope, $element, $http, $timeout, $cookies, customer) {
    $scope.init = function(){
      $scope.inProgress = false;
    	$scope.reminderFrequencies = ['DAILY','WEEKLY','MONTHLY','QUARTERLY'];
    	console.log($scope.reminderFrequencies);

    	/* get current settings */z
      $http.get('/rest/settings', {
          headers: {'Content-Type': 'application/json'}
      }).success(function(data, status) {
      	console.log(data);
      	$scope.settings = data.settings;

      }).error(function(data, status){
        console.log(data);
      });
    }

    $scope.saveSettings = function(){
      if($scope.settingsForm.$valid) {
      	$scope.inProgress = true;
        $http.post("/rest/settings", angular.toJson($scope.settings)).success(function(data, status) {
        	console.log('saved settings');
        	console.log(data);
          $scope.success = true;
          $scope.msg = "Settings have been changed successfully.";
          $scope.inProgress = false;
        }).error(function(data, success){
        	$scope.success = false;
        	$scope.msg = "An error occurred while saving your settings. Please contact the administrator.";
          $scope.inProgress = false;
        });
      }
    }
	}
]).

controller('CreateAccountCtrl', ['$scope', '$element', '$http', '$timeout', '$cookies', 'customer',
	function($scope, $element, $http, $timeout, $cookies, customer) {
    $scope.init = function(){
      $scope.inProgress = false;
      $scope.create = {};
    	/* get current settings */
      $http.get('/rest/customer', {
          headers: {'Content-Type': 'application/json'}
      }).success(function(data, status) {
      	console.log(data);
      	$scope.roles = data.roles;
      	$scope.create.role_id = $scope.roles[0].id;

      }).error(function(data, status){
        console.log(data);
      });

    }

    $scope.createAccount = function(){
    	$scope.success = false;
    	$scope.msg = null;
      if($scope.createAccountForm.$valid) {
      	$scope.inProgress = true;

        $http.post("/rest/customer", angular.toJson($scope.create)).success(function(data, status) {
        	console.log('created customer');
        	console.log(data);
        	if (data.success) {
        		console.log('success');
	          $scope.success = true;
	          $scope.msg = "The account was created and confirmation email has been sent to: "+ $scope.create.email;
	         } else {
	         	console.log('error');
	         	$scope.success = false;
	         	$scope.msg = data.message;
	         }
          $scope.inProgress = false;
        }).error(function(data, success){
        	$scope.success = false;
        	$scope.msg = "An error occurred while creating the account. Please contact the administrator.";
          $scope.inProgress = false;
        });
      }
    }
	}
]).

controller('DashboardCtrl', ['$scope', '$element', '$http', '$timeout', '$cookies', 'customer',
	function($scope, $element, $http, $timeout, $cookies, customer) {
		console.log('dboardctrl');

		$scope.paginate_questionairs = function() {
			$scope.current_ques_page = 1;
			$scope.que_pages = $scope.questionairs.length / $scope.ques_page_interval;
			if ($scope.que_pages > parseInt($scope.que_pages))
				$scope.que_pages = parseInt($scope.que_pages) + 1;
			$scope.visible_questionairs = $scope.questionairs.slice(0, $scope.ques_page_interval);
		}
		$scope.select_ques_page = function(ques_page) {
			if (ques_page == 0) {
				ques_page = $scope.current_ques_page + 1;
			} else if (ques_page == -1) {
				ques_page = $scope.current_ques_page - 1;
			}
			var last_ques_page = ques_page - 1;
			var start = (last_ques_page * $scope.ques_page_interval);
			var end = $scope.ques_page_interval * ques_page;
			$scope.current_ques_page = ques_page;
			$scope.visible_questionairs = $scope.questionairs.slice(start, end);
		}
		$scope.paginate_mentors = function() {
			$scope.current_mentor_page = 1;
			$scope.mentor_pages = $scope.mentors.length / $scope.mentor_page_interval;
			if ($scope.mentor_pages > parseInt($scope.mentor_pages))
				$scope.mentor_pages = parseInt($scope.mentor_pages) + 1;
			$scope.visible_mentors = $scope.mentors.slice(0, $scope.mentor_page_interval);
		}
		$scope.select_mentor_page = function(mentor_page) {
			if (mentor_page == 0) {
				mentor_page = $scope.current_mentor_page + 1;
			} else if (mentor_page == -1) {
				mentor_page = $scope.current_mentor_page - 1;
			}
			var last_mentor_page = mentor_page - 1;
			var start = (last_mentor_page * $scope.mentor_page_interval);
			var end = $scope.mentor_page_interval * mentor_page;
			$scope.current_mentor_page = mentor_page;
			$scope.visible_mentors = $scope.mentors.slice(start, end);
		}
		$scope.paginate_mentees = function() {
			$scope.current_mentee_page = 1;
			$scope.mentee_pages = $scope.mentees.length / $scope.mentee_page_interval;
			if ($scope.mentee_pages > parseInt($scope.mentee_pages))
				$scope.mentee_pages = parseInt($scope.mentee_pages) + 1;
			$scope.visible_mentees = $scope.mentees.slice(0, $scope.mentee_page_interval);
		}
		$scope.select_mentee_page = function(mentee_page) {
			if (mentee_page == 0) {
				mentee_page = $scope.current_mentee_page + 1;
			} else if (mentee_page == -1) {
				mentee_page = $scope.current_mentee_page - 1;
			}
			var last_mentee_page = mentee_page - 1;
			var start = (last_mentee_page * $scope.mentee_page_interval);
			var end = $scope.mentee_page_interval * mentee_page;
			$scope.current_mentee_page = mentee_page;
			$scope.visible_mentees = $scope.mentees.slice(start, end);
		}

		$scope.init = function(user, role) {
			console.log('dboardctrl init');
			/* fetch the logged in identity */
			customer.get(function(result) {
				$scope.customer = result;
				console.log($scope.customer);

        $http.get('/rest/dashboard', {
            headers: {
                'Content-Type': 'application/json'
            }
        }).success(function(data, status) {
        	console.log(data);
        	$scope.saqList = data.saqList;
        	$scope.mentors = data.mentors;
        	$scope.mentees = data.mentees;
        	$scope.admins  = data.admins;

        }).error(function(data, status){
          console.log(data);
        });

			});
			return;

			$scope.user_id = user;
			$scope.role_id = role;
			$scope.show_popup = false;
			$scope.ques_page_interval = 5;
			$scope.mentor_page_interval = 5;
			$scope.mentee_page_interval = 5;
			if ($scope.role_id == 4) {
				$scope.user_type = "Administrator";
				$scope.get_questionairs();
				$scope.get_mentors();
				$scope.get_mentees();
			} else if ($scope.role_id == 5) {
				$scope.user_type = "Mentor";
				$scope.get_mentor_mentees();
			} else {
				$scope.user_type = "Mentee";
				$scope.get_mentee_saq_list();
				$scope.get_notes();
				$scope.edit_flag = false;
			}
		}
		$scope.range = function(n) {
			return new Array(n);
		}
		$scope.getClass = function(page) {
			if (page == $scope.current_page)
				return "current";
			else
				return '';
		}
		$scope.get_questionairs = function() {
			$http.get("/user/saqlist").success(function(data) {
				$scope.questionairs = data.data;
				$scope.paginate_questionairs();
			}).error(function(data, status) {
				console.log(data || "Request failed");
			});
		}
		$scope.get_mentee_saq_list = function() {
			$http.get("/user/adminmentee/" + $scope.user_id).success(function(data) {
				$scope.questionairs = data.data;
				$scope.paginate_questionairs();
			}).error(function(data, status) {
				console.log(data || "Request failed");
			});
		}

		$scope.get_mentors = function() {
			$http.get("/user/adminmentor").success(function(data) {
				$scope.mentors = data.data;
				$scope.paginate_mentors();
			}).error(function(data, status) {
				console.log(data || "Request failed");
			});
		}

		$scope.activate = function(mentor) {
			params = {
				'mentor_id': mentor.id,
				'new_status': 1
			}
			$http({
				method: 'post',
				url: "/user/adminmentor",
				data: $.param(params),
				headers: {
					'Content-Type': 'application/x-www-form-urlencoded'
				}
			}).success(function(data, status) {
				mentor.status = 'ACTIVE';
			}).error(function(data, success) {});
		}
		$scope.de_activate = function(mentor) {
			params = {
				'mentor_id': mentor.id,
				'new_status': 2
			}
			$http({
				method: 'post',
				url: "/user/adminmentor",
				data: $.param(params),
				headers: {

					'Content-Type': 'application/x-www-form-urlencoded'
				}
			}).success(function(data, status) {
				mentor.status = 'INACTIVE';
			}).error(function(data, success) {});
		}
		$scope.get_mentor_mentees = function() {
			$http.get("/user/adminmentor/" + $scope.user_id).success(function(data) {
				$scope.mentees = data.data;
				$scope.paginate_mentees();
			}).error(function(data, status) {
				console.log(data || "Request failed");
			});
		}
		$scope.get_mentees = function() {
			$http.get("/user/adminmentee").success(function(data) {
				$scope.mentees = data.data;
				$scope.paginate_mentees();

			}).error(function(data, status) {
				console.log(data || "Request failed");
			});
		}
		$scope.hide_popup_divs = function() {
			$('#assign_mentee_mentor').css('display', 'none');
			$('#assign_mentee_saq').css('display', 'none');
			$('#create_new_note').css('display', 'none');
		}
		$scope.assign = function(mentee) {
			$scope.hide_popup_divs();
			$('#assign_mentee_mentor').css('display', 'block');
			$scope.show_popup = true;
			$scope.selected_mentee = mentee;
		}
		$scope.assign_mentee_a_mentor = function(mentor) {
			params = {
				'mentor': mentor.id,
				'mentee': $scope.selected_mentee.id
			}
			$http({
				method: 'post',
				url: "/user/adminmentee",
				data: $.param(params),
				headers: {

					'Content-Type': 'application/x-www-form-urlencoded'
				}
			}).success(function(data, status) {
				$scope.mentee.status = 'ASSIGNED'
				$scope.show_popup = false;
			}).error(function(data, success) {
				console.log(data || "Request failed")
			});
		}
		$scope.assign_saq = function(saq) {
			$scope.show_popup = true;
			$scope.selected_saq = saq;
			$scope.saq_mentee = '';
			$scope.hide_popup_divs();
			$('#assign_mentee_saq').css('display', 'block');
		}
		$scope.assign_mentee_a_saq = function(mentee) {
			params = {
				'mentee_id': mentee.id,
				'questionnaire_id': $scope.selected_saq.id
			}
			$http({
				method: 'post',
				url: "/user/saqlist",
				data: $.param(params),
				headers: {

					'Content-Type': 'application/x-www-form-urlencoded'
				}
			}).success(function(data, status) {}).error(function(data, success) {});
		}
		$scope.search_mentors = function() {

			params = {
				'key': $scope.mentor_search_key
			}
			$http({
				method: 'post',
				url: "/user/searchmentor",
				data: $.param(params),
				headers: {

					'Content-Type': 'application/x-www-form-urlencoded'
				}
			}).success(function(data, status) {

				$scope.mentors_result = data.data;

			}).error(function(data, success) {
				console.log(data || "Request failed");
			});
		}
		$scope.search_mentees = function() {

			params = {
				'key': $scope.mentee_search_key
			}
			$http({
				method: 'post',
				url: "/user/searchmentee",
				data: $.param(params),
				headers: {

					'Content-Type': 'application/x-www-form-urlencoded'
				}
			}).success(function(data, status) {

				$scope.mentees_result = data.data;

			}).error(function(data, success) {
				console.log(data || "Request failed");
			});
		}
		$scope.get_notes = function() {
			$http.get("/user/notes/").success(function(data) {
				$scope.menteenotes = data.data;
			}).error(function(data, status) {
				console.log(data || "Request failed");
			});
		}
		$scope.create_note = function() {
			$scope.hide_popup_divs();
			$('#create_new_note').css('display', 'block');
			$scope.show_popup = true;
		}
		$scope.edit_note = function(note) {
			edit_note(note, $scope);
		}
		$scope.validate_note = function() {
			validate_note($scope);
		}
		$scope.clear_current_note = function() {
			clear_current_note($scope);
		}
		$scope.save_new_note = function() {
			save_new_note($scope, $http);
		}
		$scope.delete_note = function(note) {

			delete_note(note, $scope, $http);
		}

	}
]);
