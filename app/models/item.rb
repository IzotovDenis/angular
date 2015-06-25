class Item < ActiveRecord::Base
	include ThinkingSphinx::Scopes
	include ApplicationHelper
	has_many :attachments
	has_many :prices
	belongs_to :group
	belongs_to :user
	has_many :order_items
	has_many :currencies, through: :prices
	has_many :orders, through: :order_items
	has_many :order_items_pop, -> (object){ where("order_items.created_at >= ?", Time.now-1.month)}, :class_name => 'OrderItem'
	scope :popular, -> {joins(:group).where(:groups => {:disabled => [nil,false]}).where.not(:items => {:image => nil}).select("items.id").order("RANDOM()")}
	mount_uploader :image, ImageUploader
	self.per_page = 60
	scope :able, ->{joins(:group).where(:groups => {:disabled => [nil,false]}).select('distinct items.*, groups.site_title as group_title').order("group_id, position")}

	def price
		id = '0fa9bc88-166f-11e0-9aa1-001e68eacf93'
		self.bids[id] ? value = self.bids[id] : value = {'value'=>0,'cy'=>'руб'}
		if value["cy"] == 'руб'
			val = value["value"].to_f
		else
			val = value["value"].to_f*cy_value(value["cy"]).to_f
		end
		val
	end

	def kod
		properties['Код товара']
	end


	def self.pg_result(price = false, properties = false)
		puts properties
		if properties
			@properties = 	"	replace(items.text, '\n', '<br>') as text,
								items.properties-> 'Страна изготовитель' as country,
								items.properties-> 'Применяемость' as applicability,
								items.properties-> 'Количество в упаковке' as in_pack,
								items.cross,
								items.properties-> 'Тип' as type,
								groups.title as group_title,
								items.group_id,
							"
		else
			@properties = ''
		end
		@properties += "items.certificate," if properties && price
		connection = ActiveRecord::Base.connection
		if price
			connection.execute(joins("LEFT JOIN currencies ON currencies.name = (items.bids->'0fa9bc88-166f-11e0-9aa1-001e68eacf93'->>'cy')")
					.joins(:group)
					.where(:groups => {:disabled => [nil,false]})
					.select("
							items.article,
							items.full_title as title,
							items.id,
							items.properties-> 'Код товара' as kod,
							items.properties-> 'ОЕМ' as oems,
							#{@properties}
							CASE  WHEN items.qty BETWEEN 0 AND 9 THEN items.qty::text
										WHEN items.qty BETWEEN 10 AND 49 THEN '10-49'::text
										WHEN items.qty BETWEEN 50 AND 100 THEN '50-100'::text
										ELSE '> 100'::text END as qty,
							CASE coalesce(items.image, 'null') WHEN 'null' THEN 'false'::boolean ELSE 'true' END AS image,
							items.created_at,
					coalesce((items.bids->'0fa9bc88-166f-11e0-9aa1-001e68eacf93'->>'value')::float*currencies.actual, '0.00') as price").to_sql)
		else
			connection.execute(joins(:group)
					.where(:groups => {:disabled => [nil,false]})
					.select("
							items.article,
							items.full_title as title,
							items.id,
							items.properties-> 'Код товара' as kod,
							items.properties-> 'OEM' as oem,
							#{@properties}
							CASE coalesce(items.image, 'null') WHEN 'null' THEN 'false'::boolean ELSE 'true' END AS image,
							items.created_at").to_sql)
		end
	end

end


