app.directive "grouplist", ->
	restrict: "E"
	replace: true
	template: "<div> </div>"
	scope: {
		group: "="
	}
	link: (scope, element, attrs) ->
		render = (group, html, count) ->
			if group
				html += "<a href='groups/"+group.id+"' class='group_list group_level_" + count + "'>"+group.title+"</a>"
				if group.children
					if Array.isArray(group.children)
						i = 0
						while i < group.children.length
							html = render(group.children[i],html,count+1)
							i++
					else
						html = render(group.children, html, count+1)
				html

		renderTree = ->
			element.html render(scope.group, '', 0)

		scope.$watch (->
			scope.group), ((newVal,oldVal) ->
				renderTree()
				)