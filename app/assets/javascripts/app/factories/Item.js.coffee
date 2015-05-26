app.factory "Item", Item = ["Order","$filter", (Order,$filter) ->
	item = {}
	item.page = 1
	item.busy = false
	item.url = ""
	item.fixedView = false
	item.itemsControl = false
	item.itemsPagin = false
	item.totalEntries = 1000
	item.itemsPerPage = 60
	item.userView = 'list'

	item.itemsView = ->
		if item.fixedView
			item.fixedView
		else
			item.userView

	item.setUserView = (val) ->
		item.userView = val

	item.list = []
	item.setItems = (newItems) ->
		item.list = newItems

	showPagin = ->
		if item.totalEntries > item.itemsPerPage
			item.itemsPagin = true

	item.firstLoad = (newItems, url, total_entries) ->
		angular.forEach(newItems, (value) ->
			value.oems = item.setOem(value.oems)
			item.list.push(value)
		)
		item.show_pagin = false
		item.itemsControl = true
		item.totalEntries = total_entries
		item.busy = true
		item.url = url
		item.end = false
		item.busy = false
		showPagin()
		item.setOrderQty()

	item.setOem = (str) ->
		if str
			oem = str.split(/,|;/)
			angular.forEach(oem, (value) ->
				value = value.trim()
			)
			return oem
		else
			return null



	item.setOrderQty = ->
		angular.forEach(item.list, (value) ->
			if value
				found = $filter('getById')(Order.itemIds, value.id)
				if found
					value.ordered = found.qty
					value.orderitem_id = found.id
				else
					delete value.ordered
					delete value.orderitem_id
		)

	item.getItems = ->
		item.list
	console.log(item.fixedView)
	return item
]