class Admin::OrdersController < AdminController
	before_action :set_order, only: [:show,:forward]

def index
	@start = DateTime.parse(params[:orders_from]).beginning_of_day.change(:offset =>"+1100") if params[:orders_from] && !params[:orders_from].blank?
	@end = DateTime.parse(params[:orders_to]).end_of_day.change(:offset =>"+1100") if params[:orders_to] && !params[:orders_to].blank?

	if @start && @end
		@orders = Order.period((@start)..(@end))
	elsif @start && !@end
		@orders = Order.formed_from(@start)
	elsif !@start && @end
		@orders = Order.formed_before(@end)
	else
	@orders = Order.today
	respond_to do |format|
      format.js {}
      format.html {}
    end
end
end

def show
	@order_items = @order.order_items.includes(:item,:prices)
end

def forward
	ForwardingWorker.perform_async(@order.id)
end

	private

		def set_order
			@order = Order.find(params[:id])
		end

end