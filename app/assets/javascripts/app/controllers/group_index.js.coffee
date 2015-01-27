app.controller "GroupIndexCtrl", GroupIndexCtrl = ["$scope", "$http", "Item", "Order", "OrderItem", "$location", "$routeParams", "$modal", ($scope, $http, Item, Order, OrderItem, $location, $routeParams, $modal) ->
	$http.get("/api/groups").success (data) ->
		Item.setItems(data.items)
		$scope.sliders = data.sliders
		$scope.offers = data.offers
		console.log($scope.offers)
]