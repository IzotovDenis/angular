app.factory "Order", ["$http", "$q", ($http, $q) ->
	order = this
	order.current = {}
	order.itemList = {}

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
		defer = $q.defer()
		$http.post('api/order_items', item).success((res) ->
			order.getCurrent()
			defer.resolve res
		).error (err, status) ->
			defer.reject(err)
		defer.promise

	order.deleteFromCart = (item) ->
		$http.delete("api/order_items/" + item.order_item_id).success((data) ->
			order.itemList.splice(order.itemList.indexOf(item), 1)
			order.getCurrent())
	order
]