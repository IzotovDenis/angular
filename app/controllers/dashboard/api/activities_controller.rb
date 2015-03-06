class Dashboard::Api::ActivitiesController < Dashboard::ApiController
  respond_to :json

  def index
    if params[:user_id]
      @activities = Activity.includes(:user).where(:user_id=>params[:user_id]).order("updated_at DESC").limit(20)
    else
  	 @activities = Activity.where.not(user_id: '').includes(:user).limit(7000).order("updated_at DESC")
    end
  end

    private
  # Use callbacks to share common setup or constraints between actions.

end
