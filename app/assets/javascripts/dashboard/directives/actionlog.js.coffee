dashboard.directive "actionlog", ->
	restrict: "E"
	transclude: true
	scope: {
		log: "="
		controller: "="
		action: "="
	}
	link: (scope, element, attrs) ->
		renderFind = ->
			html = "Искал: " + scope.log.text + " Результатов: " + scope.log.result

		renderGroup = ->
			switch (scope.action)
				when "index"
					html = "Зашел на главную"
				when "show"
					html = "Зашел в группу " + scope.log.group
			html

		switch (scope.controller)
			when "find"
				html = renderFind()
			when "groups"
				html = renderGroup()

		element.append html


