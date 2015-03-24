app.controller "FindCtrl", GroupCtrl = ["$scope", "$http", "$location","Item", "$routeParams", "$modal", "Page", ($scope, $http, $location, Item, $routeParams, $modal, Page) ->

	$scope.find_success = true
	# Устанавливаем урл для запроса, необходим для infinity-scroll
	

	# Отправляем запрос на поиск
	sendRequest = ->
		url = "/api" + $location.url()
		if Item.list.length < 0
			Item.itemsControl = false
		$http.get(url).success (data) ->
			if data.items.length > 0
				$scope.total_count = data.total_count
				console.log(data.total_count)
				# Устанавлием "занят", отключая infinity-scroll пока не закгрузится новая страница
				Item.busy = true
				$scope.find_success = true
				# Добавляем первые товары в фабрику
				Item.firstLoad(data.items, url, data.total_entries)
				Item.itemsControl = true
			else
				Item.list = []
				Item.busy = false
				Item.end = true
				$scope.find_success = false
				Item.itemsControl = false

	sendRequest()


	# Устанавливаем h1 страницы
	$scope.title = "Результат поиска " + $routeParams.query
	# Устанавливаем титл страницы
	Page.setTitle("Поиск " + "\"" + $routeParams.query + "\"")
]