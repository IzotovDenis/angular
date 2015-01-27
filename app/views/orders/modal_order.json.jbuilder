json.order_items @order_items do |order_item|
	json.id order_item.id
	json.thumb image_tag (order_item.item.image.thumb.url)
	json.kod order_item.item.properties['Код товара']
	json.article order_item.item.article
	json.full_title order_item.item.full_title
	json.qty_avaiable helper_item_qty(order_item.item.qty)
	json.qty_order order_item.qty
	json.amount number_to_currency(order_item.amount)
	json.price price(order_item.item.price)
end
