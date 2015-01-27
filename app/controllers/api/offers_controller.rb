class Api::OffersController < ApiController
	before_action :set_offer, only: [:show]
  include OrderItemsHelper
  respond_to :json

  def show
    @order_list = order_list(current_order)
  	@items = @offer.items.able.includes(:prices).page(params[:page])
  end

  	private
	# Use callbacks to share common setup or constraints between actions.
	def set_offer
	  @offer = Offer.find(params[:id])
	end
end
