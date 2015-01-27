app.controller "FindCtrl", GroupCtrl = ["$scope", "$http", "$location","Item", "$routeParams", "$modal", ($scope, $http, $location, Item, $routeParams, $modal) ->
	url = "/api" + $location.url()
	$http.get(url).success (data) ->
		Item.firstLoad(data.items, url)
	$scope.title = "Результат поиска " + $routeParams.query
]