app.factory "Item", Item = [ ->
	item = {}
	item.page = 1
	item.busy = false
	item.url = ""
	item.end = false
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
	item.list = []
	item.setItems = (newItems) ->
		item.list = newItems
		item.end = true

	showPagin = ->
		if item.totalEntries > item.itemsPerPage
			item.itemsPagin = true

	item.firstLoad = (newItems, url, total_entries) ->
		item.show_pagin = false
		item.itemsControl = true
		item.totalEntries = total_entries
		item.busy = true
		item.list = newItems
		item.url = url
		item.end = false
		if item.list.length < 20
			item.end = true
		item.busy = false
		showPagin()

	item.getItems = ->
		item.list
	console.log(item.fixedView)
	return item
]