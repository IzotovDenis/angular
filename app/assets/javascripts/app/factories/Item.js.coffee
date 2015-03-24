app.factory "Item", Item = ["$http", ($http) ->
	item = {}
	item.page = 1
	item.busy = false
	item.url = ""
	item.end = false
	item.itemsView = "list"
	item.itemsControl = true
	item.totalEntries = 0

	item.list = []
	item.setItems = (newItems) ->
		item.list = newItems
		item.end = true

	item.firstLoad = (newItems, url, total_entries) ->
		item.totalEntries = total_entries
		console.log(total_entries)
		item.busy = true
		item.list = newItems
		item.url = url
		item.end = false
		if item.list.length < 20
			item.end = true
		item.busy = false
		
	item.loadItems = ->
		if item.url.length > 1
			item.busy = true
			$http.get(item.url, params: {page: item.page}).success (data) ->
				items = data.items
				i = 0
				item.list = []
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