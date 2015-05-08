class Activity < ActiveRecord::Base
	belongs_to :user, :counter_cache => true
	after_save :set_activity_to_user
	scope :today, ->{where(:created_at=>DateTime.now.beginning_of_day..DateTime.now.end_of_day)}
	scope :yesterday, ->{where(:created_at=>DateTime.now.beginning_of_day-1.day..DateTime.now.end_of_day-1.day)}

	def set_activity_to_user
		User.where("id = ?",self.user_id).update_all(:last_activity_at=>self.updated_at)
	end
	
	def self.add_search arg
		@activity ={}
		@activity['user_id'] = arg[:user_id]
		@activity['model'] = 'search'
		@activity['log'] = arg.slice(:result,:text)
		return @activity
	end
end
