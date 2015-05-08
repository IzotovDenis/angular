app.directive "keyFocus", ["$document", ($document) ->
	restrict: "A"
	link: (scope, elem, attrs) ->
		elem.bind "keydown", (e) ->
			if e.keyCode is 38
				unless scope.$first
					console.log elem[0]
					console.log scope
					elem[0].previousElementSibling.querySelector(".order-qty").focus()
				if scope.$first
					console.log elem[0]
					console.log($document[0].querySelector(".find-input").focus())
			else if e.keyCode is 40
				unless scope.$last
					elem[0].nextElementSibling.querySelector(".order-qty").focus()  
		elem.bind "keyup", (e) ->
			if e.keyCode is 13
				unless scope.$last
					console.log e
					elem[0].nextElementSibling.querySelector(".order-qty").focus()  
]

app.directive "findInput", ["$document", ($document) ->
	restrict: "A"
	link: (scope, elem, attrs) ->
		elem.bind "keydown", (e) ->
			if e.keyCode is 40
				if $document[0].querySelector(".order-qty")
					$document[0].querySelector(".order-qty").focus()
]

app.directive "focusMe", [ ->
	restrict: "A"
	link: (scope, elem, attrs) ->
		elem.on "click", (e) ->
			console.log(this)
			elem[0].select()
]

app.directive 'disableAnimation', ($animate) ->
	restrict: 'A'
	link: ($scope, $element, $attrs) ->
		$attrs.$observe 'disableAnimation', (value) ->
			$animate.enabled !value, $element
				