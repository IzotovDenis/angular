json.banners @banners
json.offers @offers.each do |offer|
	json.variang offer.variant
	json.thumb offer.store["thumb"] if offer.store
	json.text offer.store["text"] if offer.store
	json.title offer.title
	json.id offer.id
end
json.items @items do |item|
	json.partial! "api/items/item.json", item: item
end
json.csfr form_authenticity_token