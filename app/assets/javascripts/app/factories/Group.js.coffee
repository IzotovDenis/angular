app.factory "Group", ["$resource",($resource) ->
	$resource("api/groups/:id.json", {id: "@id"}, {
	update: {
		method: "PUT"
					},
	tree: {
		method: "get",
		url: "api/groups/tree",
		isArray: true
				}
	})
]