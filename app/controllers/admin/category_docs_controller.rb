class Admin::CategoryDocsController < AdminController
  before_action :set_category, only: [:show, :edit, :update, :destroy]
	def index
		@categories = CategoryDoc.all
	end

	def destroy

	end

	def new
		@category = CategoryDoc.new
	end

	def update
		@pcatalog.update(pcatalog_params)
		redirect_to admin_promos_path
	end

	def create
		@category = CategoryDoc.new(category_params)
		@category.save
		redirect_to admin_category_docs_path
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

	def category_params
      params.require(:category_doc).permit(:name)
    end
end