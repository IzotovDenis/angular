@app = angular.module("App", ["ngResource", "treeControl","ng-rails-csrf", "templates", "ngRoute", "ui.bootstrap", "ngSanitize", "ngAnimate"])

app.config ["$routeProvider", "$locationProvider", ($routeProvider, $locationProvider) ->
	$locationProvider.html5Mode true
	$routeProvider.when '/groups/:groupId', templateUrl: 'groups/show.html', controller: 'GroupCtrl'
	$routeProvider.when '/brands', templateUrl: 'brands/index.html', controller: 'BrandIndexCtrl'
	$routeProvider.when '/brands/:brandId', templateUrl: 'brands/show.html', controller: 'BrandShowCtrl'
	$routeProvider.when '/items/:itemId', templateUrl: 'items/show.html', controller: 'ItemShowCtrl'
	$routeProvider.when '/find', templateUrl: 'find/index.html', controller: 'FindCtrl'
	$routeProvider.when '/profile', templateUrl: 'profile/index.html', controller: "ProfileCtrl"
	$routeProvider.when '/orders', templateUrl: 'orders/index.html', controller: "OrderIndexCtrl"
	$routeProvider.when '/orders/:orderId', templateUrl: 'orders/show.html', controller: "OrderShowCtrl"
	$routeProvider.when '/offers/:offerId', templateUrl: 'offers/show.html', controller: "OfferShowCtrl"
	$routeProvider.when '/info/:page', templateUrl: 'info/show.html', controller: "InfoShowCtrl"
	$routeProvider.when '/', templateUrl: 'groups/index.html', controller: "GroupIndexCtrl"
]

app.factory "OrderItem", ["$resource",($resource) ->
	$resource("api/order_items/:id.json", {id: "@id"}, {update: {method: "PUT"}})
]

app.factory "User", ["$resource",($resource) ->
	$resource("api/users/:id.json", {id: "@id"}, {update: {method: "PUT"}})
]

app.run ["$rootScope", ($rootScope)->
	$rootScope.appLoad = true
	]

