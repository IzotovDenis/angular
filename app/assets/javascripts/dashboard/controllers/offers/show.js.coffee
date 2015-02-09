dashboard.controller "OffersShowCtrl", OffersShowCtrl = ["$scope", "$http", "$location", "$routeParams", ($scope, $http, $location, $routeParams) ->

	unless $routeParams.offerId == "new"
		$http.get("api/offers/" + $routeParams.offerId).success (data) ->
			$scope.offer = data

	else
		$scope.offer = {}
		$scope.offer.items = []

	$http.get("api/groups/tree").success (data) ->
		$scope.groups = data

	$scope.itemRange = ->
		$http.get("api/offers/get_items", params: {type: "item_range", from: $scope.newRange.from, to: $scope.newRange.to}).success (data) ->
			addItems(data)

	$scope.itemGroup = ->
		$http.get("api/offers/get_items", params: {type: "item_group", group_id: $scope.newGroup.id}).success (data) ->
			addItems(data)

	$scope.itemCode = ->
		$http.get("api/offers/get_items", params: {type: "item_code", code: $scope.newItem.code}).success (data) ->
			addItems(data)

	$scope.deleteItem = (item) ->
		$scope.offer.items.splice( $scope.offer.items.indexOf(item), 1 )

	addItems = (new_items) ->
		i = 0
		while i < new_items.length
			$scope.offer.items.push new_items[i]
			i++

	$scope.$watch "image.base64", (newValue, oldValue) ->
		if newValue isnt oldValue
			img = "data:"+$scope.image.filetype+";base64,"+$scope.image.base64
			$scope.offer.thumb = img

	$scope.sendOffer = ->
		if $routeParams.offerId == "new"
			$http.post("api/offers/", offer: $scope.offer).success (data) ->
				console.log(data)
		else
			$http.patch("api/offers/"+$scope.offer.id, offer: $scope.offer).success (data) ->
				console.log(data)
]