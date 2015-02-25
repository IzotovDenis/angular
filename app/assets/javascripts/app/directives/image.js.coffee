app.directive "itemImage", ->
	restrict: "E"
	transclude: true
	scope: {
		image: "="
	}
	link: (scope, element, attrs) ->

		scope.$watch (->
			scope.image), ((newVal,oldVal) ->
				if newVal
					setImage()
				)

		setImage = ->
			if scope.image.exist
				html = "<img src="+scope.image[attrs.size]+"></img>"
			else
				html = "<div class='"+attrs.size+"'></div>"
			element.append html

app.directive "itemOrdered", ["Order", "$filter", (Order, $filter) ->
	restrict: "E"
	link: (scope, element, attrs) ->
		scope.$watch (->
			Order.itemList), ((newVal,oldVal) ->
				found = $filter('getById')(Order.itemList, scope.item.kod)
				if found
					scope.item.ordered = found.qty
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
		scope.$watch (->
			scope.value), ((newVal,oldVal) ->
				setPrice()
				)
]

app.directive "labeltext",  ->
	restrict: "E"
	scope:	{
		variant: "="
	}
	link: (scope, element, attrs) ->
      if scope.variant is "special"
        text = "акция"
      if scope.variant is "hit"
        text = "популярный"
      if scope.variant is "new"
        text = "новинка"
      element.html text

