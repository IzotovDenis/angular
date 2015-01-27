app.directive "goFind", ["$location", "$document", ($location, $document) ->
  restrict: "A"
  link: ($scope, elem, attrs) ->  
    elem.bind "click", ->
    	$location.url('find?query=' + attrs.goFind)
    	$scope.$apply()
]