class Price < ActiveRecord::Base
	belongs_to :item
	has_many :currencies, :foreign_key => :cy
end
