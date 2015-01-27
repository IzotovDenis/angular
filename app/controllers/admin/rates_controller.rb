class Admin::RatesController < AdminController
  before_action :set_rate, only: [:show, :edit, :update, :destroy]

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
		@rate = Rate.new(rate_params)
		if @rate.save
			redirect_to admin_path
		end
	end

	def destroy

	end


	private

	def set_rate
		@rate = Rate.find(params[:id])
	end

	def rate_params
      params.require(:rate).permit(:value, :currency_id)
    end
end