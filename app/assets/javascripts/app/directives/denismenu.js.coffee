app.directive "denismenu", [ "$timeout", ($timeout)  ->
	restrict: "A"
	link: ($scope, elem, attrs) ->  
		elem.bind "mouseover", ->
			$scope.inTimeout = attrs.id
			$scope.cinTimeout = false
			$timeout (->
				if $scope.inTimeout == attrs.id
					$scope.inTimeout = false
					$scope.aa = attrs.id
					$scope.$apply()
				return
			), 400

		elem.bind "mouseleave", ->
			$scope.inTimeout = false
			$scope.$apply()
			$timeout (->
				if $scope.cinTimeout == true
					$scope.cinTimeout = false
					$scope.inTimeout = false
					$scope.aa = false
					$scope.$apply()
				return
			), 1
			$scope.cinTimeout = true
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