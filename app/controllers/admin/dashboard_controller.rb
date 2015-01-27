class Admin::DashboardController < AdminController
  	def index
  		@currencies = Currency.all
	end
end