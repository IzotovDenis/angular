class Admin::OffersController < AdminController
before_action :set_offer, only: [:show, :edit, :update, :destroy]
before_action :item_ids, only: [:create, :update]
respond_to :html
include OffersHelper

def index
  respond_with @offers = Offer.all
end

def create
	@offer = Offer.new(new_offer)
    if @offer.save
      set_offer_items(@offer.variant, @offer.id, @item_ids)
    end
  redirect_to admin_offers_path
end

def show
    
end

def destroy
  destroy_offer_items(@offer.variant, @offer.id)
  @offer.destroy
  redirect_to admin_offers_path
end

def update
  old_variant = @offer.variant
  if @offer.update(new_offer)
    destroy_offer_items(old_variant, @offer.id)
    set_offer_items(@offer.variant, @offer.id, @item_ids)
  end
  redirect_to admin_offers_path
end

def new
	@offer = Offer.new(:variant=>"new")
end

def edit

end

	private
  	def offer_params
        params.require(:offer).permit(:title, :text, :items, :variant, :items_array, :thumb)
    end

    def new_offer
    	offer = {}
    	offer['title'] = offer_params['title']
    	offer['store'] = {}
    	offer['store']['text'] = offer_params['text']
      offer['store']['thumb'] = offer_params['thumb']
    	offer['variant'] = offer_params['variant']
      offer
    end

    def set_offer
      @offer = Offer.find(params[:id])
    end

    def item_ids
      @item_ids = params[:items_array].split(",")
    end
end