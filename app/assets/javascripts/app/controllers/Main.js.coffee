app.controller "MainCtrl", MainCtrl = ["$scope","$http", "Group", "User", "Order", "System",  "$location", "$modal", ($scope, $http, Group, User,Order, System, $location, $modal) ->
	
	$scope.order = Order
	$scope.user = User

	$scope.canOrder = ->
		User.can_order

	$scope.newQuery = {}

	$scope.system = System

	$scope.setDiscount = (value) ->
		User.setDiscount(value)

	User.getCurrent().then ((res) ->
		Order.getCurrent().then	((res) ->
			Order.current = res)
	), (reason) ->
		console.log('error')

	$scope.groups = Group.tree()

	$scope.enterFind = (newQuery) ->
		unless (newQuery.query == undefined || newQuery.query.length == 0)
			query = "query=" + newQuery.query
			if newQuery.group
				query += "&group=" + System.group.id
			if newQuery.attr
				query += "&attr=" + newQuery.attr
			$location.url('/find?' + query)

	$scope.keyalert = ->
		console.log("alert") 

	$scope.open = ->
	  modalInstance = $modal.open(
	    templateUrl: "modal.html"
	    controller: "ModalOrderCtrl"
	    windowClass: 'modal-order'
	  )

	$scope.showSelected = (sel) ->
		if sel
			$scope.newQuery.group = false
			$location.url('/groups/' + sel.id)

	$scope.treeOptions = {
	    nodeChildren: "children",
	    dirSelectable: false,
	    injectClasses: {
	        ul: "nav nav-pills nav-stacked nav-tree",
	        li: "",
	        liSelected: "a7",
	        iExpanded: "a3",
	        iCollapsed: "a4",
	        iLeaf: "a5",
	        label: "a6",
	        labelSelected: "a6"
	    }
	}
]