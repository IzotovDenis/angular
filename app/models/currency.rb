class Currency < ActiveRecord::Base
	belongs_to :user
	has_many :rates

	def rate
		if rates.last
			rates.last.value
		else
			0
		end
	end
	
end
