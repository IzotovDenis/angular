class Admin::ItemsController < AdminController
	respond_to :json
	before_action :set_item, only: [:show, :edit, :update, :destroy]

	def sort
		params[:item].each_with_index do |id,index|
			item = Item.find_by_id(id)
			item.update_attribute('position',index+1)
			@group = item.group
		end
		@group.update_attribute("sort_type","manual")
		render nothing: true
	end

  def show
  	if @item
  		@group = @item.group
	  	respond_to do |format|
		  format.html # show.html.erb
		  format.json
      format.js
		end
	end
  end

  def range
  	range = (params[:start]..params[:end]).to_a
  	@items = Item.where("properties -> 'Код товара' IN (?)", range)
  end

  def recent
  	@offers = Offer.all
  	@items = Item.where("label ? :key", :key=>"new").includes(:group)
  end

	private
	# Use callbacks to share common setup or constraints between actions.
		def set_item
		@item = Item.where("properties -> 'Код товара' = :value", :value=>params[:id]).first
		end
end
