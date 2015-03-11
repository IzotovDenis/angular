app.controller "GroupIndexCtrl", GroupIndexCtrl = ["$scope", "$http", "Item", "Order", "OrderItem", "$location", "$routeParams", "$modal", "System", "Page", ($scope, $http, Item, Order, OrderItem, $location, $routeParams, $modal, System, Page) ->
	
	# Очищаемся System.group для скрытия чекбока "Искать в группе"
	System.group = {}

	# Делаем вид главной страницы плиткой
	Item.itemsView = "thumbs"

	# Убираем контроль панель на главной
	Item.itemsControl = false

	# Устанавливаем стандартный титл страницы
	Page.setDefaultTitle()

	# Запрос на получения данныйх для главной страницы
	$http.get("/api/groups").success (data) ->
		# Устанавливаем товары
		Item.setItems(data.items)
		# Записываем карусель
		$scope.sliders = data.sliders
		# Записываем новинки, акции, предложения
		$scope.offers = data.offers
]