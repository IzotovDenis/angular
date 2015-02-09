dashboard.directive "itemImage", ->
	restrict: "E"
	transclude: true
	scope: {
		image: "="
	}
	link: (scope, element, attrs) ->
		if scope.image.exist
			html = "<img src="+scope.image[attrs.size]+"></img>"
		else
			html = "<img src=/assets/"+scope.image[attrs.size]+"></img>"
		element.append html