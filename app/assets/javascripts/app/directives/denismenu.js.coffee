app.directive "denismenu", [ "$timeout", ($timeout)  ->
	restrict: "A"
	link: ($scope, elem, attrs) ->  
		elem.bind "mouseover", ->
			console.log($scope.inTimeout)
			$scope.inTimeout = attrs.id
			$scope.cinTimeout = false
			inTimeout = true
			$timeout (->
				if $scope.inTimeout == attrs.id
					console.log("test")
					$scope.inTimeout = false
					$scope.aa = attrs.id
					$scope.$apply()
				return
			), 75

		elem.bind "mouseleave", ->
]

app.directive "denismenu1", [ "$timeout", ($timeout)  ->
	restrict: "A"
	link: ($scope, elem, attrs) ->  
		elem.bind "mouseover", ->
			$scope.inTimeout = false
			$scope.cinTimeout = false
			$scope.aa = attrs.id
			$scope.$apply()

		elem.bind "mouseleave", ->
			$timeout (->
				if $scope.cinTimeout == true
					$scope.cinTimeout = false
					$scope.aa = false
					$scope.$apply()
				return
			), 300
			$scope.cinTimeout = true
]