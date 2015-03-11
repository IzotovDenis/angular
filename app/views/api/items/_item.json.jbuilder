json.id item.id
json.title item.properties["Полное наименование"]
json.kod item.properties["Код товара"]
json.article item.article
if item.group_id
	json.group do
		json.title item.group_title
		json.id item.group_id
	end
end
json.certificate item.certificate
json.image do 
	json.exist item.image?
	json.img_thumb item.image.thumb.url
	json.img_thumb_m item.image.thumb_m.url
	json.img_item item.image.item.url
	json.img_large item.image.large.url
end
if item.properties
	json.properties do
		json.country item.properties['Страна изготовления']
		json.weight item.properties['Вес']
		if item.properties['ОЕМ']
			json.oems item.properties["ОЕМ"].split(",").each do |oem|
				json.oem oem.to_s
			end
		end
		json.type item.properties['Тип']
		json.in_pack item.properties['Количество в упаковке']
	end
end
if can? :view_price, item
	json.qty helper_item_qty(item.qty)
	json.price price(item.price)
end
if !item.label.blank?
	json.labels item.label do |key, value|
		json.variant key
		json.offer_id value
	end
end
json.text simple_format(item.text) if item.text