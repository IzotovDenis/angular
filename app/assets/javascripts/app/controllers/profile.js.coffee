app.controller "ProfileCtrl", ProfileCtrl = ["$scope", "$http", "$location", ($scope, $http, $location) ->
	$http.get("/api/users").success (data) ->
		$scope.user = data
		$scope.profileSys = []
		$scope.pswd = []

	$scope.updateProfile = ->
		$http.patch("/api/users/"+$scope.user.id, user: $scope.user).success (data) ->
			$scope.user = data.user
			if data.errors && data.errors.length > 0
				$scope.profileSys.errors = data.errors
				$scope.profileSys.success = false
			else
				$scope.profileSys.errors = ""
				$scope.profileSys.success = true

	$scope.updatePassword = ->
		console.log($scope.newpass)
		$http.patch("/api/users/update_password", pswd: $scope.newPassword).success (data) ->
			if data.errors && data.errors.length > 0
				$scope.profileSys.errors = data.errors
				$scope.profileSys.success = false
			else
				$scope.profileSys.errors = ""
				$scope.profileSys.success = true
]