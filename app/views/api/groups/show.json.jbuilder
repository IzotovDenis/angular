json.id @group.id
json.title @group.title
json.price (can? :view_price, Item)
json.items @items do |item|
	json.partial! "api/items/item.json", item: item
end