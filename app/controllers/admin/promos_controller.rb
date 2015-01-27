class Admin::PromosController < AdminController
  before_action :set_promo, only: [:show, :edit, :update, :destroy]
	def index
		@promos = Promo.all
		@pcatalogs = Pcatalog.all
	end

	def destroy

	end

	def new
		@promo = Promo.new
	end

	def edit

	end

	def update
		@promo.update(promo_params)
		redirect_to admin_promos_path
	end

	def create
		@promo = Promo.new(promo_params)
		@promo.save
		redirect_to admin_promos_path
	end

	def destroy
		@promo.destroy
		redirect_to admin_promos_path
	end

	def sort
		params[:promo].each_with_index do |id,index|
			promo = Promo.find_by_id(id)
			promo.update_attribute('position',index+1)
		end
		render nothing: true
	end

	private

	def set_promo
		@promo = Promo.find(params[:id])
	end

	def promo_params
      params.require(:promo).permit(:name, :file, :brand, :pcatalog_id)
    end
end