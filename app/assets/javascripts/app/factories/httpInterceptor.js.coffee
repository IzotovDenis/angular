app.factory "httpInterceptor", ["$location", "$q", "$rootScope", ($location, $q, $rootScope) ->
	{	'responseError': (rejection) ->
			console.log(rejection.config.url)
			url = rejection.config.url
			if rejection.status == 0
				switch (true)
					when /api\/order_items/.test(url), /api\/orders/.test(url)
							alert("Ошибка, нет связи с сервером")	
					else
							$rootScope.httpError = true
							console.log($rootScope.httpError)
			if rejection.status == 500
				switch (true)
					when /api\/order_items/.test(url)
							alert("Ошибка при добавлении в корзину")
					else
							$rootScope.httpError = true
							console.log($rootScope.httpError)
			return $q.reject(rejection)
		'response': (response) ->
			if /api/.test(response.config.url)
				$rootScope.httpError = false
				console.log(response)
			return response
	}
]