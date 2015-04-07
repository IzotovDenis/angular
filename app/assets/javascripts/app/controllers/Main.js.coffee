app.controller "MainCtrl", MainCtrl = ["$scope","$http", "Group", "User", "Order", "System",  "$location", "$modal", "Page", "$window", "$timeout", "$route", ($scope, $http, Group, User,Order, System, $location, $modal, Page, $window, $timeout, $route) ->
	
	# Привязываем фабрики
	$scope.order = Order
	$scope.user = User
	$scope.system = System
	$scope.title = Page

	# Может ли пользователь видеть цены, оформлять заказы?
	$scope.canOrder = ->
		User.can_order

	$scope.newQuery = {}

	# Метод установки скидки
	$scope.setDiscount = (value) ->
		User.setDiscount(value)

	# Получить текущего пользователя
	User.getCurrent().then ((res) ->
		Order.getCurrentIds()
	), (reason) ->
		console.log('error')

	$scope.$on "$routeChangeStart", ->
	  $scope.aa = false

	# Метода поиска
	$scope.enterFind = (newQuery) ->
		unless (newQuery.query == undefined || newQuery.query.length == 0)
			query = "query=" + newQuery.query
			if newQuery.group
				query += "&group=" + System.group.id
			if newQuery.attr
				query += "&attr=" + newQuery.attr
			$location.url('/find?' + query)


	# Что то для работы с модалью заказа
	# TODO: разобраться, переименовать
	$scope.open = ->
	  modalInstance = $modal.open(
	    templateUrl: "modal.html"
	    controller: "ModalOrderCtrl"
	    windowClass: 'modal-order'
	  )

	# Кнопка скачать прайс-лис
	$scope.downloadPricelist = ->
		if $scope.canOrder()
			$window.location.replace("pricelist.zip")
		else
			modalInstance = $modal.open(
				templateUrl: "items/modal_price.html"
				controller: "ModalPriceCtrl"
			)


	# Показать выбранную группу меню
	# TODO: скрывать другие открытые ветки 
	$scope.showSelected = (sel) ->
		if sel
			$scope.newQuery.group = false
			$location.url('/groups/' + sel.id)

	# Настрокий дерева меню
	$scope.treeOptions = {
	    nodeChildren: "children",
	    dirSelectable: false,
	    injectClasses: {
	        ul: "nav nav-pills nav-stacked nav-tree",
	        li: "",
	        liSelected: "a7",
	        iExpanded: "a3",
	        iCollapsed: "a4",
	        iLeaf: "a5",
	        label: "a6",
	        labelSelected: "a6"
	    }
	}

	$scope.relS = ->
		$route.reload()

	$scope.$watch (->
		$scope.httpError), ((newVal,oldVal) ->
			if $scope.httpError
				console.log("start----")
				console.log($scope.httpError)
				console.log("end----"))
]