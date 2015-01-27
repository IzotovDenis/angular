app.controller "GroupCtrl", GroupCtrl = ["$scope", "$http", "Item", "Order", "OrderItem", "System", "$location", "$routeParams", "$modal", ($scope, $http, Item, Order, OrderItem, System, $location, $routeParams, $modal) ->
	
	Item.list = []
	Item.busy = true
	
	url = "/api/groups/" + $routeParams.groupId

	$http.get(url).success (data) ->
		$scope.group = data
		System.group = {}
		System.group.id = $scope.group.id
		System.group.title = $scope.group.title
		Item.firstLoad(data.items, url)
	
]