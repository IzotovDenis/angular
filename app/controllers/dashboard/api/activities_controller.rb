class Dashboard::Api::ActivitiesController < Dashboard::ApiController
  respond_to :json

  def index
    if params[:user_id]
      @activities = Activity.where(:user_id=>params[:user_id]).limit(20)
    else
  	 @activities = Activity.all.limit(20)
    end
    respond_with @activities
  end

    private
  # Use callbacks to share common setup or constraints between actions.

end
