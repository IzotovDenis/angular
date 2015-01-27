class Admin::ActivitiesController < AdminController

def index
	@activities = Activity.where.not(user_id: '').limit(300).order("created_at DESC").includes(:user)
end

end