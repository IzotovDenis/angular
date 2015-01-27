@dashboard = angular.module("Dashboard", ["ngResource","ng-rails-csrf", "templates", "ngRoute", "ui.bootstrap", "ngSanitize"])

dashboard.config ["$routeProvider", "$locationProvider", ($routeProvider, $locationProvider) ->
	$locationProvider.html5Mode false
	$routeProvider.when '/users', templateUrl: 'dashboard/templates/users/index.html', controller: "UsersIndexCtrl"
	$routeProvider.when '/users/:userId', templateUrl: 'dashboard/templates/users/show.html', controller: "UsersShowCtrl"
	$routeProvider.when '/users/:userId/edit', templateUrl: 'dashboard/templates/users/edit.html', controller: "UsersEditCtrl"
	$routeProvider.when '/', templateUrl: 'dashboard/templates/dashboard.html', controller: "MainCtrl"

]