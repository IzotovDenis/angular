class Currency < ActiveRecord::Base
	belongs_to :user
	has_many :rates

	def rate
		if rates.count > 0
			rates.last.value
		else
			0
		end
	end
	
end
