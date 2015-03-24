class Dashboard::Api::ActivitiesController < Dashboard::ApiController
  respond_to :json

  def index
    if params[:user_id]
      @activities = Activity.includes(:user).where(:user_id=>params[:user_id]).order("updated_at DESC").limit(50)
    else
  	 @activities = Activity.where.not(user_id: '').includes(:user).limit(500).order("updated_at DESC")
    end
    # render :json => @activities.as_json(:only=>[:log, :updated_at, :action, :controller], :include=> {:user => {:only => [:name, :id]}} )
  end

  def user_online
    @users = User.online
    render :json => @users
  end

  private
  # Use callbacks to share common setup or constraints between actions.

end
