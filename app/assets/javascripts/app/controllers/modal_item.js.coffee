app.controller "ModalItemCtrl", ModalItemCtrl = ["$scope", "$modalInstance", "item", "Order", "$filter", "$http", ($scope, $modalInstance, item, Order, $filter, $http) ->
	$scope.item = item

	$scope.addToCart = (item) ->
		new_order_item = {
			item_id: item.id,
			qty: item.ordered
		}
		Order.addToCart(new_order_item)

	$scope.inCart = (kod) ->
		found = $filter('getById')(Order.itemList, kod)
		if found
			true

	$scope.closeModal = ->
		$modalInstance.close()
		
	$scope.$on "$routeChangeStart", ->
	  $modalInstance.close()
]