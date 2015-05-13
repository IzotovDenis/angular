app.directive "itemImage", ->
	restrict: "E"
	transclude: true
	scope: {
		image: "="
	}
	link: (scope, element, attrs) ->
		setImage = ->
			if scope.image.exist
				html = "<img src="+scope.image[attrs.size]+"></img>"
			else
				html = "<div class='"+attrs.size+"'></div>"
			element.append html
		watch = scope.$watch (->
			scope.image), ((newVal,oldVal) ->
				if scope.image
					setImage()
					watch()
				)

app.directive "itemOrdered", ["Order", "$filter", (Order, $filter) ->
	restrict: "E"
	link: (scope, element, attrs) ->
		scope.$watch (->
			Order.itemIds), ((newVal,oldVal) ->
				if scope.item
					found = $filter('getById')(Order.itemIds, scope.item.id)
					if found
						scope.item.ordered = found.qty
						scope.item.orderitem_id = found.id
					else
						delete scope.item.ordered
						delete scope.item.orderitem_id
				)
]

app.directive "currency", ["User", (User) ->
	restrict: "E"
	scope:	{
		value: "="
		item: "="
	}
	link: (scope, element, attrs) ->
		setPrice = ->
			if scope.value == "0.00" && scope.item == true
				element.html "по запросу"
			else
				price = scope.value * (100-User.discount) / 100
				element.html accounting.formatMoney(price, "", 2, " ", ",")

		scope.$watch (->
			User.discount), ((newVal,oldVal) ->
				setPrice()
				)
		set = scope.$watch (->
			scope.value), ((newVal,oldVal) ->
				setPrice()
				)
		setPrice()
]

app.directive "labeltext",  ->
	restrict: "E"
	scope:	{
		variant: "="
	}
	link: (scope, element, attrs) ->
		console.log(scope.variant)
		if scope.variant is "special"
			text = "акция"
		if scope.variant is "hit"
			text = "популярный"
		if scope.variant is "new"
			text = "new"
		element.html text

