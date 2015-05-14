class Api::GroupsController < ApiController
	before_action :set_group, only: [:show]
  after_action :set_activity, only: [:index, :show]
  include OrderItemsHelper
  respond_to :json

  def index
    @banners = Banner.all.select("id, image, location, label, link").group_by { |d| d[:location]  }
    @offers = Offer.all
    @items = Item.popular.limit(12)
    @order_list = order_list(current_order)
  end

  def tree
    respond_with Group.able.select("id, title, ancestry").arrange_serializable
  end

  def show
  	ids = @group.subtree_ids
  	respond_with @items = Item.able.includes(:prices).where(:group_id=>ids).page(params[:page])
  end

  	private
	# Use callbacks to share common setup or constraints between actions.
	def set_group
	  @group = Group.find(params[:id])
	end

  def set_activity
    unless params[:page] 
      activity_save :controller=>controller_name, :action=>action_name, :group=>(@group.title if @group), :group_id=>(@group.id if @group), :page=>params[:page]
    end  
  end

end
