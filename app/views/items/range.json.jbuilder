json.items @items do |item|
	json.partial! "items/item.json", item: item
end
