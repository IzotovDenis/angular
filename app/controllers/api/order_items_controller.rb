class Api::OrderItemsController < ApiController
  include OrderItemsHelper

  load_and_authorize_resource only: [:create,:update,:destroy]
  before_action :set_order_item, only: [:update, :destroy, :set_activity]

  def create
  	if order_item_params
      @item = Item.find(order_item_params[:item_id])
      @order_item = OrderItem.find_or_initialize_by(:order=>current_order,:item=>@item)
      @order_item.qty = order_item_params[:qty]
      @order_item.save
      render :json => @order_item
    end
  end

  def update
    @order_item.update(order_item_params)
  end

  def destroy
    @order_item.destroy
    render :json => @order_item
  end

  private

    def set_order_item
      @order_item = OrderItem.find(params[:id])
    end

    def order_item_params
      @params = params.require(:order_item).permit(:item_id, :qty)
    end

end
