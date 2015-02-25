app.controller "FindCtrl", GroupCtrl = ["$scope", "$http", "$location","Item", "$routeParams", "$modal", "Page", ($scope, $http, $location, Item, $routeParams, $modal, Page) ->

	# Устанавливаем урл для запроса, необходим для infinity-scroll
	url = "/api" + $location.url()

	# Отправляем запрос на поиск
	$http.get(url).success (data) ->
		# Добавляем первые товары в фабрику
		Item.firstLoad(data.items, url)

	# Устанавливаем h1 страницы
	$scope.title = "Результат поиска " + $routeParams.query
	# Устанавливаем титл страницы
	Page.setTitle("Поиск " + "\"" + $routeParams.query + "\"")
]