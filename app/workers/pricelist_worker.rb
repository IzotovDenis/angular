class PricelistWorker
  include Sidekiq::Worker
  include PricelistHelper

  def perform
		if Pricelist.where(:status=>"progress").empty?
			@pricelist = Pricelist.create(:status=>"progress")
			if create_pricelist
				@pricelist.status = "success"
				@pricelist.save
				return "succcess"
			else
				@pricelist.status = "error"
				@pricelist.save
			end
		else
			return "in progress"
		end
  end

end