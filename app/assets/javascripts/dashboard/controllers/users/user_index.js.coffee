dashboard.controller "UsersIndexCtrl", UsersIndexCtrl = ["$scope", "$http", "$location", ($scope, $http, $location) ->

	$http.get('api/users/').success (data) ->
		$scope.users = data

	$scope.showUser = (id) ->
		$location.url('users/' + id)
]