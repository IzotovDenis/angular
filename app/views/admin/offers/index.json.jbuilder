json.array! @offers do |offer|
	json.id offer.id
	json.title offer.title
	json.items_count offer.items.count
end