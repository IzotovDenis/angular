dashboard.controller "MainCtrl", MainCtrl = ["$scope", "$http", "$timeout", ($scope, $http, $timeout) ->

	countUp = ->
		$http.get('/dashboard/api/stat').success (data) ->
			$scope.stat = data

	countUp()

	loadCurrencies = ->
		$http.get('/dashboard/api/currencies').success (data) ->
			$scope.currencies = data

	loadCurrencies()

	$scope.addCurrency = ->
		$http.post('/dashboard/api/currencies', currency: $scope.newCurrency).success (data) ->
			loadCurrencies()
			$scope.newValForm = false
			$scope.newCurrency = {}
]