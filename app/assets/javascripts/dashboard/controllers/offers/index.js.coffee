dashboard.controller "OffersIndexCtrl", OffersIndexCtrl = ["$scope", "$http", "$location", ($scope, $http, $location) ->

	$http.get("api/offers").success (data) ->
		$scope.offers = data

	$scope.destroyOffer = (id) ->
		$http.delete("api/offers/" + id).success (data) ->
			$scope.offers = data

]