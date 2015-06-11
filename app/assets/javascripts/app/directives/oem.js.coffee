app.directive "goFind", ["$location", "$document", ($location, $document) ->
  restrict: "A"
  link: ($scope, elem, attrs) ->  
    elem.bind "click", ->
    	$location.url('find?query=' + attrs.goFind)
    	$scope.$apply()
]


app.directive "itemoem", ->
	restrict: "E"
	replace: true
	transclude: true
	template: "<div class='oems'></div>"
	scope: {
		oems: "="
	}
	link: (scope, element, attrs) ->
		render = ->
			if scope.oems
				html = ""
				oem = scope.oems.split(/,|;/)
				i = 0
				while i < oem.length
					html += "<span class='oem cursor-pointer'>"+oem[i].trim()+"</span>"
					i++
			element.html html
		setTimeout(render,0)