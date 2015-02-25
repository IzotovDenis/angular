module GroupsHelper

	#Сортировка товаров во всех группах
	def order_all
		Group.able.all.each do |group|
			sort_group(group.id)
		end
	end

	# Сортировка товара в группе с сохранением
	def sort_group(group_id)
		@items = Item.where(:group_id=>group_id).able.includes(:prices).sort_by &:full_title
			@items.each_with_index do |item, index|
				item.update_attribute("position", index+1)
			end
	end

end
