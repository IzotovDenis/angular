app.controller "OrderShowCtrl", OrderShowCtrl = ["$scope", "$http", "$location", "$routeParams", ($scope, $http, $location, $routeParams) ->

	$http.get("/api/orders/" + $routeParams.orderId).success (data) ->
		$scope.order = data
]