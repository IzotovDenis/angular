class Api::OrderItemsController < ApiController
  include OrderItemsHelper
  after_action :set_activity
  load_and_authorize_resource only: [:create,:update,:destroy]
  before_action :set_order_item, only: [:update, :destroy, :set_activity]

  def create
  	if order_item_params
      @item = Item.find(order_item_params[:item_id])
      @order_item = OrderItem.find_or_initialize_by(:order=>current_order,:item=>@item)
      @order_item.qty = order_item_params[:qty]
      if @order_item.save
        render :json => current_order.order_items.select("item_id, qty, id")
      end
    end
  end

  def update
    if @order_item.update(order_item_params)
      render :json => current_order.order_items.select("item_id, qty, id")
    end
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

    def set_activity
      @item ||=@order_item.item
      activity_save :controller=>controller_name, :action=>action_name, :item_kod=>@item.properties['Код товара'],:item_title=>@item.properties['Полное наименование'], :qty=>@order_item.qty, :path=>URI(request.referer).path
    end

end
