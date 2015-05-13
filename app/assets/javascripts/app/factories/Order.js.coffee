app.factory "Order", ["$http", "$q", ($http, $q) ->
	order = this
	order.current = {}
	order.itemList = {}
	order.busy = false

	order.itemIds = {}

	order.getCurrentIds = ->
	  defer = $q.defer()
	  $http.get("api/orders/current?type=ids").success((res) ->
	    order.itemIds = res
	    defer.resolve res
	    return
	  ).error (err, status) ->
	    defer.reject err
	    return
	  defer.promise

	order.getCurrent = ->
	  defer = $q.defer()
	  $http.get("api/orders/current").success((res) ->
	    order.current = res
	    order.itemList = res.items
	    defer.resolve res
	    return
	  ).error (err, status) ->
	    defer.reject err
	    return
	  defer.promise

	order.addToCart = (item) ->
		console.log("start add")
		defer = $q.defer()
		$http.post('api/order_items', item).success((res) ->
			order.itemIds = res
			console.log(order.itemIds)
			defer.resolve res
		).error (err, status) ->
			defer.reject(err)
		defer.promise

	order.updateInCart = (item, orderitem_id) ->
		defer = $q.defer()
		$http.patch('api/order_items/'+orderitem_id, item).success((res) ->
			order.getCurrent()
			defer.resolve res
		).error (err, status) ->
			defer.reject(err)
		defer.promise

	order.deleteFromCart = (item) ->
		unless order.busy
			order.busy = true
			$http.delete("api/order_items/" + item.order_item_id).success((data) ->
				order.itemList.splice(order.itemList.indexOf(item), 1)
				order.getCurrent().then (res) ->
					order.busy = false)
				.error (err, status) ->
					order.busy = false
	order
]