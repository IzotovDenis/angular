# coding: utf-8
class Api::ItemsController < ApiController
  respond_to :json
	before_action :set_item, only: [:show, :edit, :update, :destroy]

  def show
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
		@item = Item.joins(:group).where("properties -> 'Код товара' = :value", :value=>params[:id]).select('distinct items.*, groups.site_title as group_title').first
		end
end