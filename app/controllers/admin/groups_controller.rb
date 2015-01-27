class Admin::GroupsController < AdminController
	include Importv2Helper
before_action :set_group, only: [:show, :edit, :update, :destroy, :sort_items]
	def index
		@groups = Group.roots
	end

	def show
		@groups = @group.children
		@items = @group.items.able
	end

	def update
		@group.update(group_params)
		redirect_to admin_group_path(@group)
	end

	def sort
		params[:group].each_with_index do |id,index|
			Group.find_by_id(id).update_attribute('position',index+1)
		end
		render nothing: true
	end

	def sort_items
		@item_ids = @group.items.order("title").map { |item| item.id}
		helper_sort_items(@item_ids)
		@group.update_attribute("sort_type","auto")
		redirect_to admin_group_path(@group)
	end

	  	private
	# Use callbacks to share common setup or constraints between actions.
	def group_params
      params.require(:group).permit(:sort_type)
    end

    def set_group
      @group = Group.find(params[:id])
    end
end