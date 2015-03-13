app.controller "ModalItemCtrl", ModalItemCtrl = ["$scope", "$modalInstance", "item", "Order", "$filter", "$http","$modal", ($scope, $modalInstance, item, Order, $filter, $http, $modal) ->
	$scope.item = item

	$scope.addToCart = (item) ->
		new_order_item = {
			item_id: item.id,
			qty: item.ordered
		}
		if item.orderitem_id
			Order.updateInCart(new_order_item, item.orderitem_id)
		else
			Order.addToCart(new_order_item)


	$scope.inCart = (kod) ->
		found = $filter('getById')(Order.itemList, kod)
		if found
			true

	$scope.closeModal = ->
		$modalInstance.close()
		
	$scope.$on "$routeChangeStart", ->
	  $modalInstance.close()

	$scope.itemShowImage = (item) ->
		modalInstance = $modal.open(
			templateUrl: "items/modal_image.html"
			controller: "ModalImageCtrl"
			windowClass: 'modal-item'
			resolve:
				item: ->
					item
		)
]