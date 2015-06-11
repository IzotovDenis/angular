app.controller "ModalItemCtrl", ModalItemCtrl = ["$scope", "$modalInstance", "item", "Order", "$filter", "$http","$modal", ($scope, $modalInstance, item, Order, $filter, $http, $modal) ->
	$scope.item = item
	if item.ordered
		$scope.ordered = item.ordered
		$scope.orderitem_id = item.orderitem_id

	$http.get("/api/items/"+$scope.item.kod).success (data) ->
		if data.certificate && data.certificate.match(/doc&id=([0-9]*)/)
			id = data.certificate.match(/doc&id=([0-9]*)/)[1]
			data.certificate = "http://disk.planeta-avtodv.ru/docs/"+id
			console.log(data.certificate)
		$scope.item = data
		if $scope.ordered
			$scope.item.ordered = $scope.ordered
			$scope.item.orderitem_id = $scope.orderitem_id

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