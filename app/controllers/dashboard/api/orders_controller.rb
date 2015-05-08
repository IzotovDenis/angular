class Dashboard::Api::OrdersController < Dashboard::ApiController
  respond_to :json
  before_action :set_order, only: [:show]

  def index
    if params[:user_id]
     @orders = Order.ready.where(:user_id=>params[:user_id]).order('formed DESC')
    else
      @start = Date.strptime(params[:date], '%Y-%m-%d').beginning_of_day
      case params[:period]
        when "day"
          @end = @start + 1.day
        when "week"
          @end = @start + 1.week
        when "month"
          @end = @start + 1.month
      end 
      @orders = Order.ready.where(:formed=>@start..@end).order('formed DESC')
    end
  end

  def show
    respond_with @order
  end

    private
  # Use callbacks to share common setup or constraints between actions.
  def set_order
    if params[:current]
      user = User.where(:id=>params[:id]).first
      if user
        @order = user.current_order if user.current_order
      end
    else
      @order = Order.find(params[:id])
    end
  end
end
