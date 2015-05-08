class ApiController < ApplicationController
	include ActivityHelper
	include OrdersHelper

  protected

  def json_request?
    request.format.json?
  end
end
