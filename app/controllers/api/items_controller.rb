# coding: utf-8
class Api::ItemsController < ApiController
	before_action :set_item, only: [:show, :edit, :update, :destroy]
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
