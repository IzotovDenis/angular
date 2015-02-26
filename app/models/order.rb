class Order < ActiveRecord::Base
	belongs_to :user
	has_many :order_items, dependent: :destroy
	has_many :items, :through => :order_items
	accepts_nested_attributes_for :order_items
	scope :ready, ->{includes(:order_items, :user, :items=>:prices).where("formed IS NOT NULL").order("formed DESC")}
	scope :period, ->(period) {ready.where(:formed=>period)}
	scope :today, ->{where(:formed=>DateTime.now.beginning_of_day..DateTime.now.end_of_day).ready}
	scope :formed_from, ->(period) {where(["formed >= ?", period]).ready}
	scope :formed_before, ->(period) {where(["formed <= ?", period]).ready}

	after_save :update_orders_counter_cache
	after_destroy :update_orders_counter_cache

	def update_orders_counter_cache
  		self.user.orders_count = self.user.orders.ready.count
  		self.user.save
	end

	def complete
		self.formed = Time.now
      	self.order_items.each do |order_item|
      		order_item.set_price
      		self.total += order_item.price*order_item.qty
      	end
      	self.save!
	end

	def amount
		@total = 0
		self.order_items.includes(:item=>:prices).each do |order_item|
			@total += order_item.qty*order_item.item.price
		end
		@total
	end 

	def count_position
		self.order_items.count
	end

	def good?
		self.count_position >=1 && self.amount >=1
	end
end