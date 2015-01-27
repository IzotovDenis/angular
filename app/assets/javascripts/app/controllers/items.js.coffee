app.controller "ItemsCtrl", ItemCtrl = ["$scope", "Item", "$modal", "Order", "$filter", "$location", ($scope, Item, $modal, Order, $filter, $location) ->
	$scope.items = Item

	$scope.itemShow = (item) ->
	  modalInstance = $modal.open(
	    templateUrl: "items/modal.html"
	    controller: "ModalItemCtrl"
	    windowClass: 'modal-item'
	    resolve:
	      item: ->
	        item
	  )

	$scope.priceShow = (item) ->
	  modalInstance = $modal.open(
	    templateUrl: "items/modal_price.html"
	    controller: "ModalPriceCtrl"
	  )

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

	$scope.goFind = (query) ->
		$location.url('/find/' + query)

]