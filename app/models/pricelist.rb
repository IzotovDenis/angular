class Pricelist < ActiveRecord::Base
	include PricelistHelper


	def self.create_new
		puts "start"
		if Pricelist.where(:status=>"progress").empty?
			@pricelist = Pricelist.create(:status=>"progress")
				if create_pricelist
					@pricelist.status = "success"
					@pricelist.save
					return "succcess"
				end
		else
			return "in progress"
		end
	end

	def self.current
		@pricelist = Pricelist.where(:status=>"success").last
	end

end
