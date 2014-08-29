'use strict';

/* Directives */

angular.module('cap.directives', []).

/*
directive('ngEnter', [
  function() {
    return {
      restrict:"EAC",
      link: function(scope, element, attrs) {
        element.bind("keypress", function(event) {
          if(event.which === 13) {
            scope.$apply(function(){
              scope.$eval(attrs.ngEnter);
            });
            event.preventDefault();
          }
        });
      }
    };
  }
]).
*/
directive('capOverlay', ['$rootScope',
  function($rootScope) {
    return {
      restrict: 'A',
      compile: function(element, attr, transclude) {
        return function(scope, element, attr, controller) {
          $rootScope.$on('overlay-message', function(e, data) {
            scope.message = data.message;
          });

          element.click(function() {
            console.log('broadcast overlay clicked');
            $rootScope.$broadcast('overlay-clicked');
          });
        }
      }
    }
  }
]).

directive('capFooter', ['footer',
  function(footer) {
    return {
      restrict: 'C',
      replace: false,
      compile: function(element, attr, transclude) {
        return function(scope, element, attr) {
          attr.footer = attr.footer || '#footer';
          attr.scroll = attr.scroll || 'window';

          footer.init(attr.footer, attr.scroll);
        }
      }
    }
  }
]).

directive('answerTypeSelect', ['$http', 'overlay',
  function($http, overlay) {
    return {
      restrict: 'E',
      scope:{'percentComplete':'='},
      templateUrl: '/answer-type/select',
      link: function(scope, element, attr) {
        console.log('fetching a select answer type');
        scope.success = false;
        scope.inProgress = false;

        var url = '/rest/answer/select/'+attr.questionId;
        if (attr.customerId) {
          url += '/'+attr.customerId;
        }

        scope.save = function() {
          /* grab any selected answers from the model */
          console.log('answers are2:');
          console.log(scope.answerId);
          var answers = [];

          answers.push({
            'answerId':scope.answerId,
            'answerText':null,
            'answerEnumId':null
          });

          $http.post(url,{
            'customerId':attr.customerId,
            'questionId':attr.questionId,
            'answers':answers
          }).success(function(data, status) {
            /* do something? */
            console.log(data);
          }).error(function(data, status) {

          });

        }


        $http.get(url).success(function(data, status) {
          scope.inProgress = false;
          console.log(data);
          scope.answers = data.answers;
          scope.disabled = data.disabled;
          if (data.customerAnswers[0]) {
            /* select can only have 1 answer */
            scope.answerId = data.customerAnswers[0].answerId;
          }
          overlay.loading(false).hide();

        }).error(function(data, status){
          scope.inProgress = false;
          console.log(data);
          overlay.loading(false).hide();
        });

      }
    };
  }
]).

directive('answerTypeTextarea', ['$http', 'overlay',
  function($http, overlay) {
    return {
      restrict: 'E',
      scope:{'percentComplete':'='},
      templateUrl: '/answer-type/textarea',
      link: function(scope, element, attr) {
        console.log('fetching a textarea answer type');
        scope.success = false;
        scope.inProgress = false;

        var url = '/rest/answer/textarea/'+attr.questionId;
        if (attr.customerId) {
          url += '/'+attr.customerId;
        }

        scope.$watch('answerText', _.debounce(function(n,o) {
          if (n && n!==o) {
            console.log('calling save');
            scope.save();
          }
        },500));


        scope.save = function() {
          /* grab any selected answers from the model */
          console.log('answers are:');
          console.log(scope.answerText);
          var answers = [];

          answers.push({
            'answerId':scope.answers[0].id,
            'answerText':scope.answerText,
            'answerEnumId':null
          });


          $http.post(url,{
            'customerId':attr.customerId,
            'questionId':attr.questionId,
            'answers':answers
          }).success(function(data, status) {
            /* do something? */
            console.log(data);
          }).error(function(data, status) {

          });

        }



        $http.get(url).success(function(data, status) {
          scope.inProgress = false;
          console.log(data);
          scope.answers = data.answers;
          scope.disabled = data.disabled;
          if (data.customerAnswers[0]) {
            /* textarea can only have 1 answer */
            scope.answerText = data.customerAnswers[0].answerText;
          }
          overlay.loading(false).hide();

        }).error(function(data, status){
          scope.inProgress = false;
          overlay.loading(false).hide();
          console.log(data);
        });

      }
    };
  }
]).
directive('answerTypeText', ['$http', 'overlay',
  function($http, overlay) {
    return {
      restrict: 'E',
      scope:{'percentComplete':'='},
      templateUrl: '/answer-type/text',
      link: function(scope, element, attr) {
        console.log('fetching a text answer type');
        scope.success = false;
        scope.inProgress = false;

        var url = '/rest/answer/text/'+attr.questionId;
        if (attr.customerId) {
          url += '/'+attr.customerId;
        }

        scope.$watch('answerText', _.debounce(function(n,o) {
          if (n && n!==o) {
            console.log('calling save');
            scope.save();
          }
        },500));

        scope.save = function() {
          /* grab any selected answers from the model */
          console.log('answers are2:');
          console.log(scope.answerText);
          var answers = [];

          answers.push({
            'answerId':scope.answers[0].id,
            'answerText':scope.answerText,
            'answerEnumId':null
          });


          $http.post(url,{
            'customerId':attr.customerId,
            'questionId':attr.questionId,
            'answers':answers
          }).success(function(data, status) {
            /* do something? */
            console.log(data);
          }).error(function(data, status) {

          });

        }


        $http.get(url).success(function(data, status) {
          scope.inProgress = false;
          console.log(data);
          scope.answers = data.answers;
          scope.disabled = data.disabled;

          if (data.customerAnswers[0]) {
            /* textarea can only have 1 answer */
            scope.answerText = data.customerAnswers[0].answerText;
          }
          overlay.loading(false).hide();

        }).error(function(data, status){
          scope.inProgress = false;
          console.log(data);
          overlay.loading(false).hide();

        });

      }
    };
  }
]).
directive('answerTypeMultiselect', ['$http', 'answer',
  function($http, answer) {
    return {
      restrict: 'E',
      scope:{'percentComplete':'='},
      templateUrl: '/answer-type/multiselect',
      link: function(scope, element, attr) {
        console.log('fetching a multiselect answer type');
        scope.success = false;
        scope.inProgress = false;
        var url = '/rest/answer/multiselect/'+attr.questionId;
        if (attr.customerId) {
          url += '/'+attr.customerId;
        }


        scope.save = function() {
          /* grab any selected answers from the model */
          console.log('answers are2:');
          console.log(scope.answerId);
          var answers = [];

          angular.forEach(scope.answerId, function(answerId) {
            answers.push({
              'answerId':answerId,
              'answerText':null,
              'answerEnumId':null
            });
          });

          $http.post(url,{
            'customerId':attr.customerId,
            'questionId':attr.questionId,
            'answers':answers
          }).success(function(data, status) {
            /* do something? */
            console.log(data);
          }).error(function(data, status) {

          });

        }

        $http.get(url).success(function(data, status) {
          scope.inProgress = false;
          console.log(data);
          scope.answers = data.answers;
          scope.disabled = data.disabled;
          scope.answerId = [];

          if (data.customerAnswers[0]) {
            console.log('got customer answers');
            /* loop through the answers and set checked to true or false depending on customer answers */
            angular.forEach(scope.answers, function(a) {
              console.log(a);
              a.checked = false;
              angular.forEach(data.customerAnswers, function(ca) {
                console.log('ca: '+ca.answerId+" a: "+a.id);
                if (a.id === ca.answerId) {
                  console.log('answrer '+a.id+' is checked');
                  scope.answerId.push(a.id);
                }
              });
            });
          }
          overlay.loading(false).hide();

        }).error(function(data, status){
          scope.inProgress = false;
          console.log(data);
          overlay.loading(false).hide();
        });

      }
    };
  }
]).

directive('answerTypeCheckbox', ['$http', 'overlay',
  function($http, overlay) {
    return {
      restrict: 'E',
      scope:{'percentComplete':'='},
      templateUrl: '/answer-type/checkbox',
      link: function(scope, element, attr) {
        console.log('fetching a checkbox answer type');
        scope.success = false;
        scope.inProgress = false;

        var url = '/rest/answer/checkbox/'+attr.questionId;
        if (attr.customerId) {
          url += '/'+attr.customerId;
        }

        scope.save = function() {
          /* grab any selected answers from the model */
          console.log('answers are2:');
          console.log(scope.answerId);
          var answers = [];

          angular.forEach(scope.answers, function(answer) {
            if (answer.checked) {
              answers.push({
                'answerId':answer.id,
                'answerText':null,
                'answerEnumId':null
              });
            }
          });

          $http.post(url,{
            'customerId':attr.customerId,
            'questionId':attr.questionId,
            'answers':answers
          }).success(function(data, status) {
            /* do something? */
            console.log(data);
          }).error(function(data, status) {

          });

        }

        $http.get(url).success(function(data, status) {
          scope.inProgress = false;
          console.log(data);
          scope.answers = data.answers;
          scope.disabled = data.disabled;
          if (data.customerAnswers[0]) {
            console.log('got customer answers');
            /* loop through the answers and set checked to true or false depending on customer answers */
            angular.forEach(scope.answers, function(a) {
              console.log(a);
              a.checked = false;
              angular.forEach(data.customerAnswers, function(ca) {
                console.log('ca: '+ca.answerId+" a: "+a.id);
                if (a.id === ca.answerId) {
                  console.log('answrer '+a.id+' is checked');
                  a.checked = true;
                }
              });
            });
          }
          overlay.loading(false).hide();

        }).error(function(data, status){
          scope.inProgress = false;
          console.log(data);
          overlay.loading(false).hide();
        });

      }
    };
  }
]).

directive('answerTypeRadio', ['$http', 'overlay',
  function($http, overlay) {
    return {
      scope:{'percentComplete':'='},
      restrict: 'E',
      templateUrl: '/answer-type/radio',
      link: function(scope, element, attr) {
        console.log('fetching a radio answer type');
        scope.success = false;
        scope.inProgress = false;
        scope.questionId = attr.questionId;

        var url = '/rest/answer/radio/'+attr.questionId;
        if (attr.customerId) {
          url += '/'+attr.customerId;
        }

        scope.save = function(a) {
          /* grab any selected answers from the model */
          console.log('radio answers are:');
          scope.selectedAnswerId = a;
          var answers = [];
          answers.push({
            'answerId':a,
            'answerText':null,
            'answerEnumId':null
          });

          $http.post(url,{
            'customerId':attr.customerId,
            'questionId':attr.questionId,
            'answers':answers
          }).success(function(data, status) {
            /* do something? */
            console.log(data);
          }).error(function(data, status) {

          });

        }


        $http.get(url).success(function(data, status) {
          scope.inProgress = false;
          console.log(data);
          scope.answers = data.answers;
          scope.disabled = data.disabled;
          if (data.customerAnswers[0]) {
            console.log('got customer answers');
            /* loop through the answers and set checked to true or false depending on customer answers */
            angular.forEach(scope.answers, function(a) {
              console.log(a);
              angular.forEach(data.customerAnswers, function(ca) {
                console.log('ca: '+ca.answerId+" a: "+a.id);
                if (a.id === ca.answerId) {
                  console.log('answrer '+a.id+' is checked');
                  scope.selectedAnswerId = a.id;
                }
              });
            });
          }
          overlay.loading(false).hide();
        }).error(function(data, status){
          scope.inProgress = false;
          console.log(data);
          overlay.loading(false).hide();
        });

      }
    };
  }
]).

directive('answerTypeEnum', ['$http', 'overlay',
  function($http, overlay) {
    return {
      scope:{"startQuestionNumber":"=","endQuestionNumber":"=","percentComplete":'='},
      restrict: 'E',
      templateUrl: '/answer-type/enum',
      controller: function() {

      },
      controller: ['$scope', '$element', '$attrs', '$transclude',
        function($scope, $element, $attrs, $transclude) {
          console.log('fetching an enum answer type');
          $scope.success = false;
          $scope.inProgress = false;
          $scope.questionId = $attrs.questionId;
          var url = '/rest/answer/enum/'+$attrs.questionId;
          if ($attrs.customerId) {
            url += '/'+$attrs.customerId;
          }


          $scope.save = function() {
            /* grab any selected answers from the model */
            var answers = [];

            angular.forEach($scope.answers, function(answer) {
              answers.push({
                'answerId':answer.id,
                'answerText':null,
                'answerEnumId': answer.selectedEnumId
              });
            });

            $http.post(url,{
              'customerId':$attrs.customerId,
              'questionId':$attrs.questionId,
              'answers':answers
            }).success(function(data, status) {
              /* do something? */
              console.log(data);
              $scope.percentComplete = data.percentComplete;
            }).error(function(data, status) {

            });

          }

          $http.get(url).success(function(data, status) {
            $scope.inProgress = false;
            console.log(data);
            $scope.answers = data.answers;
            $scope.disabled = data.disabled;
            $scope.startQuestionNumber = $scope.answers[0].answerNumber;
            $scope.endQuestionNumber = $scope.answers[$scope.answers.length-1].answerNumber;
            $scope.percentComplete = data.percentComplete;

            console.log("start: "+$scope.startQuestionNumber);
            //scope.disabled = false;
            /* loop through the answers and set checked to true or false depending on customer answers */
            angular.forEach($scope.answers, function(a) {

              /* figure out the enumColsClass: how many enums do we have? */
              var totalCols = 12 //bootstrap total columns
              var maxCols = 10; //no more than 12 columns (col-xs-1)
              if (a.answerEnums.length <= maxCols) {
                maxCols = a.answerEnums.length;
              } else {
                /* find an acceptable maxCols */
                var leastDistance = maxCols;
                for (var i = maxCols; i > 0; i--) {
                  if (a.answerEnums.length % i) {
                    var l = i - (a.answerEnums.length % i);
                    if (l < leastDistance) {
                      leastDistance = l;
                      maxCols = i;
                    }
                  } else {
                    /* winner! */
                    maxCols = i;
                    break;
                  }
                };
              }
              $scope.enumColsClass = 'col-xs-'+ parseInt(Math.floor(totalCols/maxCols));
              w = parseInt( (Math.floor(100/maxCols) ) );
              $scope.enumColsClass += ' width-'+w; /* make sure this class exists! */

              if (data.customerAnswers[0]) {
                angular.forEach(data.customerAnswers, function(ca) {
                  if (a.id === ca.answerId) {
                    a.selectedEnumId = ca.answerEnumId
                  }
                });
              }
            });
            overlay.loading(false).hide();
          }).error(function(data, status){
            $scope.inProgress = false;
            console.log(data);
            overlay.loading(false).hide();
          });

        }
      ],
      compile: function(element, attr, transclude) {
        return function(scope, element, attr, controller) {
        }
      }
    };
  }
]).

directive("fileread", [
  function () {
    return {
      scope: {
        fileread: "="
      },
      link: function (scope, element, attributes) {
        element.bind("change", function (changeEvent) {
          scope.$apply(function () {
            scope.fileread = changeEvent.target.files[0];
            // or all selected files:
            // scope.fileread = changeEvent.target.files;
          });
        });
      }
    }
  }
]);
