app.controller "ModalOrderCtrl", ModalOrderCtrl = ["$scope", "$modalInstance", "Order", "$http", "$window", "$timeout", ($scope, $modalInstance, Order, $http, $window, $timeout) ->

	$scope.order = Order
	$scope.order.current = {}
	$scope.itemList = []

	getOrder = ->
		Order.getCurrent()

	$timeout(getOrder, 500)

	$scope.addToCart = (item) ->
		Order.itemAdd(item)

	$scope.deleteItem = (item) ->
		items = [item]
		Order.deleteFromCart(items)

	$scope.checkAll = (val) ->
		angular.forEach($scope.order.current.items, (value) ->
			value.checked = val
		)

	$scope.deleteItems = (items) ->
		console.log(items)

	$scope.closeModal = ->
		$modalInstance.close()

	$scope.forwardOrder = ->
		$http.post('api/orders/forwarding', comment: $scope.orderComment).success (data) ->
			if data.status == "success"
				$modalInstance.close()
				$window.alert("Заказ успешно отправлен!")
				Order.getCurrent().then	((res) ->
					Order.current = res
					Order.itemIds = [])
			else
				$window.alert("Ошибка при отправке!")
				console.log("SOME ERROR")

	$scope.deleteItems = ->
		arr = []
		empty = true
		angular.forEach($scope.order.current.items, (value) ->
			if value.checked == true
				arr.push(value)
				empty = false
		)
		if empty == false
			Order.deleteFromCart(arr)
]