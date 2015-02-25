class Api::OrdersController < ApiController
  respond_to :json
  before_action :set_order, only: [:show]
  load_and_authorize_resource only: [:index,:forwarding,:show]

  def index
  	@orders = current_user.orders.ready.order(:formed)
  end

  def current
  	@order = current_order
  	@order_items = @order.order_items.includes(:item=>:prices).order(:created_at) if @order
  end

  def show
    @order_items = @order.order_items.includes(:item=>:prices).order(:created_at)
  end
  
  def forwarding
  	@order = current_order
  	if @order.good?
      @order.comment = params[:comment]
      @order.formed = Time.now
      @order.save
  		ForwardingWorker.perform_async(@order.id)
  		render :json => {status: "success"}
  	else
  		render :json => {status: "error"}
  	end
  end

    private
  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end
end
