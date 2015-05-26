class ApiController < ApplicationController
	include ActivityHelper
	include OrdersHelper
	before_action :check_abb
  protected

  def check_abb
	@can_view_price = true if can? :view_price, Item
  end
  
  def json_request?
    request.format.json?
  end
end
