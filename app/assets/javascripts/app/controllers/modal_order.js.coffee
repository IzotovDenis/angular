app.controller "ModalOrderCtrl", ModalOrderCtrl = ["$scope", "$modalInstance", "Order", "$http", "$window", ($scope, $modalInstance, Order, $http, $window) ->
	$scope.order = Order
	
	Order.getCurrent()

	$scope.addToCart = (item) ->
		new_order_item = {
			item_id: item.id,
			qty: item.qty
		}
		Order.addToCart(new_order_item)

	$scope.deleteFromCart = (item) ->
		Order.deleteFromCart(item)

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
]