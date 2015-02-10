dashboard.controller "ActivitiesIndexCtrl", ActivitiesIndexCtrl = ["$scope", "$http", "$location", ($scope, $http, $location) ->

	$http.get("/dashboard/api/activities").success (data) ->
		$scope.activities = data
]