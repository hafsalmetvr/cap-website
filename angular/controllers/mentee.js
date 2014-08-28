/* Controllers */
angular.module('cap.controllers.mentee', []).

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
        	$scope.mentors = data.mentors;
        	$scope.saqList = data.saqs;
          overlay.loading(false).hide();
        }).error(function(data, status){
          console.log(data);
          overlay.loading(false).hide();
        });

			});
		}
  }
]).

controller('MentorCtrl', ['$scope', '$element', '$http', '$timeout', '$window', '$cookies', 'overlay',
  function($scope, $element, $http, $timeout, $window, $cookies, overlay) {

    /* can only edit my note */
    $scope.createNoteModal = function() {
      $scope.modal = {
        'shareWith':'mentor'
      };
    }

    $scope.editNoteModal = function(idx) {
      var note = $scope.myNotes[idx];
      $scope.modal = {
        'noteIdx':idx,
        'note': note,
        'shareWith':'mentor'
      };

    }

    $scope.createNote = function() {
      console.log('create note');
      var note = $scope.modal.note;
      console.log(note);
      $scope.createInProgress = true;

      $http.post('/rest/note/'+note.id,{'note':note,'customerId':$scope.mentorId}).success(function(data,status) {
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
        'shareWith':'mentor'
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

    $scope.init = function(mentorId) {
      overlay.message('loading mentor information...').loading(true).show();
      /* get list of saqs for this mentee */
      $scope.mentorId = mentorId;
      $scope.inProgress = true;
      /* get listr of mentees */
      $http.get('/rest/mentor/'+$scope.mentorId).success(function(data, status) {
        $scope.inProgress = false;
        console.log(data);
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
controller('QuestionnairePageCtrl', ['$scope', '$element', '$http', '$timeout', '$cookies', 'customer', 'overlay', '$window',
	function($scope, $element, $http, $timeout, $cookies, customer, overlay, $window) {
    $scope.confirmContinue = false;
    $scope.inProgress = false;

    overlay.message('loading questions...').loading(true).show();
    $scope.init = function(qId, sectionNumber, pageNumber, cId) {
      $scope.qId = qId;
      $scope.sectionNumber = sectionNumber;
      $scope.pageNumber = pageNumber;
      $scope.cId = cId;
    };

    $scope.continue = function(nextUrl, qId, cId) {
      $scope.nextUrl = nextUrl;
      $scope.inProgress = true;
      $http.get('/rest/questionnaire/'+qId+'/'+cId).success(function(data, status) {
        console.log(data);

        if (data['completionStatus'] === "COMPLETED") {
          $scope.inProgress = false;
          console.log('show modal');
          /* display a confirmation before continuing */
          $('#confirm-continue-modal').modal('show');
        } else {
          $window.location.href = $scope.nextUrl;
        }

      }).error(function(data, status){
        console.log(data);
        //$window.location.href = $scope.nextUrl;
      });


    }

	}
]).
controller('QuestionnaireCtrl', ['$scope', '$element', '$http', '$timeout', '$window', '$cookies',
  function($scope, $element, $http, $timeout, $window, $cookies) {
  }
]);

