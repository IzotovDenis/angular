json.id item.id
json.title item.properties["Полное наименование"]
json.kod item.properties["Код товара"]
json.article item.article
json.img item.image.thumb.url
if can? :view_price, @item
	json.qty helper_item_qty(item.qty)
end