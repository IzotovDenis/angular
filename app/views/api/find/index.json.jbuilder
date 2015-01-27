json.title "Результаты поиска #{@query}"
json.items @items do |item|
	json.partial! "api/items/item.json", item: item
end