json.array! @orders do |order|
	json.id order.id
	json.positions order.count_position
	json.amount order.amount
	json.date Russian::strftime(order.formed, "%d %B %Y %H:%M")
	json.comment order.comment
end