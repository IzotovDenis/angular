app.controller "OrderShowCtrl", OrderShowCtrl = ["$scope", "$http", "$location", "$routeParams", "Order", ($scope, $http, $location, $routeParams, Order) ->
	console.log($scope.order)
	$http.get("/api/orders/" + $routeParams.orderId).success (data) ->
		$scope.order = data
		console.log(data)

	$scope.checkAll = (val) ->
		angular.forEach($scope.order.items, (value) ->
			value.checked = val
		)

	$scope.checkCheck = ->
		arr = []
		empty = true
		i = 0
		console.log($scope.order)
		while i < $scope.order.items.length
			arr.push($scope.order.items[i])
			console.log($scope.order.items[i])
			i++
		console.log(arr)
]