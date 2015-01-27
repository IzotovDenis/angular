dashboard.controller "MainCtrl", MainCtrl = ["$scope", "$http", ($scope, $http) ->

	$http.get('api/orders').success (data) ->
		$scope.orders = data

	$http.get('api/activities/').success (data) ->
		$scope.activities = data

	$http.get('api/users/').success (data) ->
		$scope.users = data
]