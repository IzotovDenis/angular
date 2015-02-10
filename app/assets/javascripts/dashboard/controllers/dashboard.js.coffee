dashboard.controller "MainCtrl", MainCtrl = ["$scope", "$http", "$timeout", ($scope, $http, $timeout) ->

	countUp = ->
		$http.get('/dashboard/api/stat').success (data) ->
			$scope.stat = data

	countUp()
]