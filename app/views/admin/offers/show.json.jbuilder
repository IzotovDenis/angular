json.id @offer.id
json.title @offer.title
json.text @offer.store['text']
json.items @offer.items do |item|
	json.id item.id
	json.title item.properties["Полное наименование"]
	json.kod item.properties["Код товара"]
	json.article item.article
	json.img item.image.thumb.url
end