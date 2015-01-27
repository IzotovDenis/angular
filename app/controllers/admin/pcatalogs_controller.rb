class Admin::PcatalogsController < AdminController
  before_action :set_pcatalog, only: [:show, :edit, :update, :destroy]
	def index
		@pcatalogs = Pcatalog.all
	end

	def destroy

	end

	def new
		@pcatalog = Pcatalog.new
		
	end

	def update
		@pcatalog.update(pcatalog_params)
		redirect_to admin_promos_path
	end

	def create
		@pcatalog = Pcatalog.new(pcatalog_params)
		@pcatalog.save
		redirect_to admin_promos_path
	end

	def destroy
		@pcatalog.destroy
		redirect_to admin_pcatalogs_path
	end

	def sort
		params[:pcatalog].each_with_index do |id,index|
			pcatalog = Pcatalog.find_by_id(id)
			pcatalog.update_attribute('position',index+1)
		end
		render nothing: true
	end

	private

	def set_pcatalog
		@pcatalog = Pcatalog.find(params[:id])
	end

	def pcatalog_params
      params.require(:pcatalog).permit(:name)
    end
end