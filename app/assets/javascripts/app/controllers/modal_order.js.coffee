app.controller "ModalOrderCtrl", ModalOrderCtrl = ["$scope", "$modalInstance", "Order", "$http", ($scope, $modalInstance, Order, $http) ->
	$scope.order = Order
	$scope.aler = (item) ->
		console.log(item.id)

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
			if data.success == true
				console.log("SEND")
				$modalInstance.close()
				Order.getCurrent().then	((res) ->
					Order.current = res)
			else
				console.log("SOME ERROR")
]