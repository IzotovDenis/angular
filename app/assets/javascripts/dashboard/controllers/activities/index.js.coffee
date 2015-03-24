dashboard.controller "ActivitiesIndexCtrl", ActivitiesIndexCtrl = ["$scope", "$http", "$location", ($scope, $http, $location) ->
	$scope.loading = true
	$scope.activs = []

	$http.get("/dashboard/api/activities").success (data) ->
		$scope.activities = data
		angular.forEach(data, (value) ->
			if $scope.activs.length == 0
				addUser($scope.activs, value)
			else
				if $scope.activs[$scope.activs.length-1].id == value.user.id
					addActivity($scope.activs, value)
				else
					addUser($scope.activs, value)
		)
		$scope.loading = false

	$http.get("/dashboard/api/activities/user_online").success (data) ->
		$scope.online = data

	$scope.loading = ->
		$scope.loading
	addUser = (array, activity) ->
		array.push(activity.user)
		array[array.length-1].activities = []
		array[array.length-1].activities.push(activity)

	addActivity = (array, activity) ->
		array[array.length-1].activities.push(activity)
]