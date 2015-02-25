app.controller "ItemShowCtrl", ItemShowCtrl = ["$scope", "$http", "$routeParams", "$modal", ($scope, $http, $routeParams, $modal) ->
	$http.get("/api/items/"+$routeParams.itemId).success (data) ->
		$scope.item = data
		console.log(data)
]