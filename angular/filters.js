'use strict';

/* Filters */
angular.module('cap.filters', []).

//- shared
filter('pluralize', ['$filter', 'pluralizeWords',
	function($filter, pluralizeWords) {
		return function(number, word) {
			return pluralizeWords[word](number);
		};
	}
]);
