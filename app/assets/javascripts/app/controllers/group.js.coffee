app.controller "GroupCtrl", GroupCtrl = ["$scope", "$http", "Item", "Order", "OrderItem", "System", "$location", "$routeParams", "$modal", "Page", ($scope, $http, Item, Order, OrderItem, System, $location, $routeParams, $modal, Page) ->
	
	# Очищаем список товаров
	Item.list = []
	# Устанавлием "занят", отключая infinity-scroll пока не закгрузится новая страница
	Item.busy = true
	# Делаем вид в группах списком
	Item.itemsView = "list"

	# Показываем контроль панель в группах
	Item.itemsControl = true
	
	# Урл для запросов infinity-scroll
	url = "/api/groups/" + $routeParams.groupId

	# Отправляемся запрос
	$http.get(url).success (data) ->
		# Записываем группу в скопе
		$scope.group = data

		# Записываем текущую группу в сустем для отображения чекбока "искать в группе"
		System.group = {}
		System.group.id = $scope.group.id
		System.group.title = $scope.group.title

		# Устанавливаем тит страницы
		Page.setTitle($scope.group.title)

		# Записываем первые товары в фабрику
		Item.firstLoad(data.items, url)
	
]