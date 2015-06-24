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
							html = renderParent(group.parent[i],html)
							i++
				if group.current
					html += "<div class='content-title'><p class='lead'>" + group.current.site_title + "</p></div>"
				if group.children
					if Array.isArray(group.children)
						i = 0
						while i < group.children.length
							html = renderChild(group.children[i],html,3)
							i++
				html

		renderParent = (group, html) ->
			html += "<a href='groups/"+group.id+"' class='group_list group_parent'><span class='title'>"+group.site_title+"</span></a><span class='group_delimeter'> / </span>"

		renderChild = (group, html, count) ->
			if group.items_count > 0
				html_count = "<span class='items_count'>(" + group.items_count + ")</span>"
			else
				html_count = ""
			html += "<a href='groups/"+group.id+"' class='group_list group_level_" + count + "'><span class='title'>"+group.site_title+ " " + html_count + "</span></a>"

		renderTree = ->
			element.html render(scope.group, '', 0)

		scope.$watch (->
			scope.group), ((newVal,oldVal) ->
				renderTree()
				)
