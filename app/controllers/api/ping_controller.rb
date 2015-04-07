# coding: utf-8
class Api::PingController < ApiController
  respond_to :json

  def index
  	render :json => {"success" => true}
  end
end
