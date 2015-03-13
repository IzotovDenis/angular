app.controller "BrandShowCtrl", BrandShowCtrl = ["$scope", "$http", "$routeParams", "Item", ($scope, $http, $routeParams, Item) ->

	$scope.groups = []
	# Урл для запросов infinity-scroll
	url = "api/brands/"+ $routeParams.brandId
	if $routeParams.group_id
		url = url + "?group_id=" + $routeParams.group_id

	console.log(url)

	$http.get(url).success (data) ->
		$scope.brand = data.brand
		$scope.groups = data.groups
		Item.firstLoad(data.items, url)
]