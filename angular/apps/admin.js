'use strict';

var app = angular.module('cap', [
  'ngRoute',
  'ngAnimate',
  'ngCookies',
  'cap.controllers',
  'cap.controllers.admin',
  'cap.filters',
  'cap.router',
  'cap.services',
  'cap.directives'
]);

app.config(function($interpolateProvider) {
    $interpolateProvider.startSymbol('[[');
    $interpolateProvider.endSymbol(']]');
});

app.config(['$routeProvider', '$locationProvider', function($routes, $location) {

}]);
