app.factory "Item", Item = ["$http", ($http) ->
	item = {}
	item.page = 1
	item.busy = false
	item.url = ""
	item.end = false
	item.itemsView = "list"
	item.itemsControl = true

	item.list = []
	item.setItems = (newItems) ->
		item.list = newItems
		item.end = true

	item.firstLoad = (newItems, url) ->
		item.busy = true
		item.list = newItems
		item.url = url
		item.end = false
		item.page = 2
		if item.list.length < 20
			item.end = true
		item.busy = false
		
	item.loadItems = ->
		unless item.end
			unless item.busy
				if item.url.length > 1
					item.busy = true
					$http.get(item.url, params: {page: item.page}).success (data) ->
						items = data.items
						i = 0
						while i < items.length
							item.list.push items[i]
							i++
						if items.length < 20
							item.end = true
						item.page = item.page + 1
						item.busy = false

	item.getItems = ->
		item.list
	return item
]