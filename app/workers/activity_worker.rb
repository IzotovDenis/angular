class ActivityWorker
  include Sidekiq::Worker

  def perform(hash)
  	puts "start"
  	puts hash
  	if hash["controller"] == "find"
		@last_activity = Activity.where(:user_id=>hash["user_id"], :controller=>"find").last
		puts "cool"
			if @last_activity
			@last_query = @last_activity.log["text"].gsub(/[^0-9A-Za-z]/, ' ')
			puts @last_query
			query = hash["log"]["text"].gsub(/[^0-9A-Za-z]/, ' ')
			puts query
			regexp = /^(#{@last_query})/
				if regexp.match(query)
					puts "update"
					@last_activity.update(hash)
				else
					puts "create"
					Activity.create!(hash)
				end
			end
	end

	if hash["controller"] == "groups"
		Activity.create!(hash)
	end
  end
end