/* Controllers */
angular.module('cap.controllers.mentor', []).

controller('DashboardCtrl', ['$scope', '$element', '$http', '$timeout', '$window', '$cookies', 'customer', 'overlay',
  function($scope, $element, $http, $timeout, $window, $cookies, customer, overlay) {
  	$scope.init = function() {
  		overlay.message('loading your dashboard...').loading(true).show();

			/* fetch the logged in identity */
			customer.get(function(result) {
				$scope.customer = result;
				console.log($scope.customer);

        $http.get('/rest/dashboard').success(function(data, status) {
        	console.log(data);
        	$scope.mentees = data.mentees;
        	$scope.forms = data.forms;
        	$scope.saqList = data.saqList;

        	overlay.loading(false).hide();
        }).error(function(data, status){
          console.log(data);
        	overlay.loading(false).hide();
        });

			});
		}
  }
]).

controller('MenteeCtrl', ['$scope', '$element', '$http', '$timeout', '$cookies', 'customer', 'overlay',
	function($scope, $element, $http, $timeout, $cookies, customer, overlay) {
		/* can only edit my note */
		$scope.createNoteModal = function() {
			$scope.modal = {
				'shareWith' : 'mentee'
			};
		}

		$scope.editNoteModal = function(idx) {
			var note = $scope.myNotes[idx];
			$scope.modal = {
				'noteIdx':idx,
				'note': note,
				'shareWith' : 'mentee'
			};

		}

		$scope.createNote = function() {
			console.log('create note');
			var note = $scope.modal.note;
			console.log(note);
			$scope.createInProgress = true;

			$http.post('/rest/note/'+note.id,{'note':note,'customerId':$scope.menteeId}).success(function(data,status) {
	    	$scope.createInProgress = false;
	    	console.log(data);
	    	if (data.success) {
	    		$scope.myNotes.unshift(data.note);
	    	}
	    	$scope.success = true;
	    	$scope.msg = 'Successfully created note.';
				$('#create-note-modal').modal('hide');

			}).error(function(data, status) {
				$scope.inProgress= false;
				console.log('failed to create note');
				console.log(data);
			});
		}


		$scope.saveNote = function() {
			console.log('ave note');
			var note = $scope.modal.note;
			console.log(note);
			$scope.inProgress = {'myNotes': {}};
			$scope.inProgress['myNotes'][note.noteIdx] = true;

			$http.put('/rest/note/'+note.id,note).success(function(data,status) {
	    	$scope.inProgress = false;
	    	console.log(data);
	    	if (data.success) {
	    		$scope.myNotes[$scope.modal.noteIdx] = note;
	    	}
	    	$scope.success = true;
	    	$scope.msg = 'Successfully updated note.';
				$('#edit-note-modal').modal('hide');

			}).error(function(data, status) {
				$scope.inProgress= false;
				console.log('failed to save note');
				console.log(data);
			});
		}

		$scope.viewNoteModal = function(idx,type) {
			var note = $scope[type][idx];
			$scope.modal = {
				'noteIdx':idx,
				'type':type,
				'note': note,
				'shareWith' : 'mentee'
			};
		}

		/* can only delete my notes */
		$scope.deleteNote = function(idx) {
			$scope.inProgress = {'myNotes': {}};
			$scope.inProgress['myNotes'][idx] = true;
			var note = $scope.myNotes[idx];
			console.log('delete note: ');
			console.log(note);
	    $http.delete('/rest/note/'+note.id).success(function(data, status) {
	    	$scope.inProgress = false;
	    	console.log(data);
	    	if (data.success) {
	    		console.log('delete note from scope with idx:'+idx);
	    		console.log($scope.myNotes);
	    		$scope.myNotes = $scope.myNotes.splice(idx,1);
	    	}
	    	$scope.success = true;
	    	$scope.msg = 'Successfully deleted note';

	    }).error(function(data, status){
	    	$scope.inProgress = false;
	      console.log(data);
	    });

		}

		$scope.init = function(menteeId) {
  		overlay.message('loading mentee information...').loading(true).show();

			/* get list of saqs for this mentee */
			$scope.menteeId = menteeId;
			$scope.inProgress = true;
			/* get listr of mentees */
	    $http.get('/rest/mentee/'+$scope.menteeId).success(function(data, status) {
	    	$scope.inProgress = false;
	    	console.log(data);
	    	$scope.saqList = data.saqs;
	    	$scope.forms = data.forms;
	    	$scope.mentors = data.mentors;
	    	$scope.myNotes     = data.myNotes;
	    	$scope.sharedNotes = data.sharedNotes;

        overlay.loading(false).hide();
	    }).error(function(data, status){
	    	$scope.inProgress = false;
	      console.log(data);
        overlay.loading(false).hide();
	    });
		}
	}
]).
controller('QuestionnaireCtrl', ['$scope', '$element', '$http', '$timeout', '$window', '$cookies',
  function($scope, $element, $http, $timeout, $window, $cookies) {
  }
]).
controller('QuestionnairePageCtrl', ['$scope', '$element', '$http', '$timeout', '$cookies', 'customer', 'overlay', '$window',
	function($scope, $element, $http, $timeout, $cookies, customer, overlay, $window) {
  	overlay.message('loading questions...').loading(true).show();
  	$scope.continue = function(nextUrl) {
  		$window.location.href = '/dashboard';
  		$window.open(nextUrl,'_blank');
  	}

	}
]).

/* do i need this? */
controller('MentorCtrl', ['$scope', '$element', '$http', '$timeout', '$window', '$cookies',
  function($scope, $element, $http, $timeout, $window, $cookies) {
  }
]);
