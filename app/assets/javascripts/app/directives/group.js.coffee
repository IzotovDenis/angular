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
				if group.parent
					if Array.isArray(group.parent)
						i = 0
						while i < group.parent.length
							html = renderParent(group.parent[i],html,i)
							i++
				if group.current
					html += "<div class='content-title'><h4>" + group.current.site_title + "</h3></div>"
				if group.children
					if Array.isArray(group.children)
						i = 0
						while i < group.children.length
							html = renderParent(group.children[i],html,3)
							i++
				html

		renderParent = (group, html, count) ->
			if group.items_count > 0
				html_count = "<span class='items_count'>(" + group.items_count + ")</span>"
			else
				html_count = ""
			html += "<a href='groups/"+group.id+"' class='group_list group_level_" + count + "'>"+group.site_title+ " " + html_count + "</a>"

		renderTree = ->
			element.html render(scope.group, '', 0)

		scope.$watch (->
			scope.group), ((newVal,oldVal) ->
				renderTree()
				)
