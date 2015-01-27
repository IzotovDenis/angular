app.controller "OfferShowCtrl", OfferShowCtrl = ["$scope", "$http", "Item", "Order", "OrderItem", "$location", "$routeParams", "$modal", ($scope, $http, Item, Order, OrderItem, $location, $routeParams, $modal) ->
	Item.list = []
	url = "/api/offers/" + $routeParams.offerId
	$http.get(url).success (data) ->
		$scope.offer = data
		Item.firstLoad(data.items, url)
]