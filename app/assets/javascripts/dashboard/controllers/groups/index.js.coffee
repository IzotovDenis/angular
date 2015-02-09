dashboard.controller "GroupsIndexCtrl", GroupsIndexCtrl = ["$scope", "$http", "$location", ($scope, $http, $location) ->

	$http.get("api/groups").success (data) ->
		$scope.groups = data

	$scope.setDisabled = (id) ->
		setDisbled()

	$scope.showGroup = (id) ->
		showGroup()

	$scope.sortGroups = ->
		sortGroups()

	$scope.sortItems = (group_id) ->
		sortItems()


]