class AddPriceToOrderItems < ActiveRecord::Migration

	def self.up
	  add_column :order_items, :price, :float, :default => 0

	  OrderItem.reset_column_information
	  OrderItem.ready.all.each do |order_item|
	  	order_item.update_attribute("price", order_item.item.price)
	  end
	end

	def self.down
	  remove_column :orders_items, :price
	end

end
