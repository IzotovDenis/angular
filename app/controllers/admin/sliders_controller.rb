class Admin::SlidersController < AdminController
  before_action :set_slider, only: [:show, :edit, :update, :destroy]

  def index
  	@sliders = Slider.all
  end

  def create
  	@slider = Slider.new(slider_params)
  		if @slider.save
  			redirect_to admin_sliders_path
  		end
  end

  def destroy
    if @slider.destroy
      redirect_to admin_sliders_path
    end
  end

  def sort
    params[:slider].each_with_index do |id,index|
      slider = Slider.find_by_id(id)
      slider.update_attribute('position',index+1)
    end
    render nothing: true
  end

	private

	def set_slider
		@slider = Slider.find(params[:id])
	end

	def slider_params
      params.require(:slider).permit(:image, action: [:link])
    end
end