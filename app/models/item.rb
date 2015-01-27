class Item < ActiveRecord::Base
	include ThinkingSphinx::Scopes
	include ApplicationHelper
	has_many :attachments
	has_many :prices
	belongs_to :group
	belongs_to :user
	has_many :order_items
	has_many :orders, through: :order_items
	has_many :order_items_pop, -> (object){ where("order_items.created_at >= ?", Time.now-1.month)}, :class_name => 'OrderItem'
	mount_uploader :image, ImageUploader
	self.per_page = 20
	scope :able, ->{joins(:group).where(:groups => {:disabled => [nil,false]}).select('distinct items.*, groups.title as group_title').order("position")}

  sphinx_scope(:visible) {
    {:groups => {:disabled => [nil,false]}}
  }

	def price
		self.prices.empty? ? value = {'value'=>0,'cy'=>'руб'} : value = self.prices.first
		case value["cy"]
			when 'руб'
				val = value["value"].to_f
			else
				val = value["value"].to_f*cy_value(value["cy"]).to_f
		end
		val
	end

	def kod
		properties['Код товара']
	end
end