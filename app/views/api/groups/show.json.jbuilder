json.group do
	json.id @group.id
	json.title @group.title
end
json.items @items do |item|
	json.partial! "api/items/item.json", item: item
end
json.total_entries @items.total_entries