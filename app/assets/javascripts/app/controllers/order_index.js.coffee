app.controller "OrderIndexCtrl", OrderIndexCtrl = ["$scope", "$http", "$location", ($scope, $http, $location) ->
	$http.get("/api/orders").success (data) ->
		$scope.orders = data
		console.log($scope.orders)

	$scope.showOrder = (id) ->
		$location.url("/orders/"+id)
]