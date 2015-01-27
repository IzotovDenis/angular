class Dashboard::Api::OrdersController < Dashboard::ApiController
  respond_to :json
  before_action :set_order, only: [:show]
  load_and_authorize_resource only: [:index,:forwarding,:show]

  def index
    if params[:user_id]
      @orders = Order.where(:user_id=>params[:user_id])
    else
  	 @orders = Order.ready.order(:formed)
    end
    respond_with @orders
  end

    private
  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end
end
