class Dashboard::Api::GroupsController < Dashboard::ApiController
  respond_to :json
  before_action :set_group, only: [:show]

  def index
    @groups = Group.roots
    respond_with @groups
  end

  def show
    @items = @group.items
  end

  def tree
    render json: Group.arrange_as_array(:order=>"position").each {|n| n.title ="#{'--' * n.depth} #{n.title}" }
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

end
