class Admin::CurrenciesController < AdminController
  before_action :set_currency, only: [:show, :edit, :update, :destroy]
  	def index

	end

	def destroy

	end

	def new

	end

	def edit

	end

	def update

	end

	def create
		@currency = Currency.new(currency_params)
		if @currency.save
			redirect_to admin_path
		end
	end

	def destroy

	end


	private

	def set_promo
		@currency = Currency.find(params[:id])
	end

	def currency_params
      params.require(:currency).permit(:name)
    end
end