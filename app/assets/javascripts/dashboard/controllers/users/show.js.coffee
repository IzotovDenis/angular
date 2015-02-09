dashboard.controller "UsersShowCtrl", UsersEditCtrl = ["$scope", "$http", "$routeParams", "$location", ($scope, $http, $routeParams, $location) ->

	$scope.user = []
	$scope.activities = []
	$scope.orders = []

	$http.get('api/users/' + $routeParams.userId).success (data) ->
		$scope.user = data

	$http.get('api/activities?user_id='+$routeParams.userId).success (data) ->
		$scope.activities = data

	$http.get('api/orders?user_id='+$routeParams.userId).success (data) ->
		$scope.orders = data

	$scope.editUser = (id) ->
		$location.url("users/" + id + "/edit")

	$scope.updateRole = ->
		console.log($scope.user.role)

]