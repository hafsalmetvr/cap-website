'use strict';

/* Services */

// Demonstrate how to register services
// In this case it is a simple value service.
angular.module('cap.services', []).
factory('customer', ['$http',
    function($http) {
        var self = this;
        self.customer = null;

        return {
            get: function(cb) {
                console.log('get customer');
                if (self.customer) {
                    return self.customer;
                }
                $http.get('/rest/customer/current', {
                    headers: {
                        'Content-Type': 'application/json'
                    }
                }).success(function(data, status) {
                    self.customer = data;
                    cb(null, self.customer);
                }).error(function(data, status){
                    cb(status,data)
                });

            },
        }
    }
]).
factory('answer', ['$http',
    function($http) {
        var self = this;
        self.answer = null;

        return {
            get: function(params, cb) {
            },
            save: function(params, cb) {
                console.log(params);
                cb(null,params);
            }
        }
    }
]).
factory('overlay', ['$rootScope',
    function($rootScope) {
        return {
            show: function() {
                console.log('show overlay');
                angular.element('#overlay').addClass('overlay');
                return this;
            },
            hide: function() {
                angular.element('#overlay').removeClass('overlay');
                return this;
            },
            loading: function(bool) {
                if (bool) {
                    angular.element('#overlay > .overlay-loading').removeClass('hide');
                } else {
                    angular.element('#overlay > .overlay-loading').addClass('hide');
                }
                return this;
            },
            message: function(message) {
                $rootScope.$broadcast('overlay-message',{'message':message});
                return this;
            }
        }
    }
]).


factory('share', function() {
    return {
        messages : {
            show : false,
            type : '',
            message : ''
        },
        loader : {
            show : false
        }
    };
});
