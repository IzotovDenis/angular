module Importv3Helper

	def import_group
		parser = Saxerator.parser(File.new("/home/den/import.xml"))
		a = ''
		parser.for_tag("Группа").each do |tag|
			tree_to_a(tag).each do |xml_group|
				group = Group.find_or_initialize_by(cid: xml_group['cid'])
				group.update(xml_group)
				puts group.title
			end
		end
	end

	def parse_items(importsession_id)
		file = "public/uploads/imports/#{importsession_id}/import.xml"
		parser = Saxerator.parser(File.new(file))
		parser.for_tag("Товар").each do |tag|
			hash = parse_item(tag)
			hash['importsession_id'] = importsession_id
			item = Item.find_or_initialize_by(cid: hash['cid'])
			if item.update(hash)
				puts "import item #{item.full_title}"
				puts tag["Картинка"]
				save_image1(importsession_id, tag["Картинка"])
			end
		end
	end 

	def parse_item(tag)
		item = {}
		item['cid'] = item_tag(tag["Ид"])
		item['full_title'] = item_tag(tag["ПолноеНаименование"])
		item['article'] = item_tag(tag["Артикул"])
		item['brand'] = item_tag(tag["Бренд"])
		item['title'] = item_tag(tag["Наименование"])
		item['certificate'] = item_tag(tag["СсылкаНаСертификат"])
		item['text'] = item_tag(tag["Описание"])
		item['group_cid'] = item_tag(tag["Группы"]["Ид"])
		item['cross'] = item_cross(tag["Кросс1"], tag["Кросс2"])
		item['properties'] = item_properties(tag["ЗначенияРеквизитов"])
		item['properties']['Применяемость'] = item_tag(tag["Применяемость"]) if tag["Применяемость"]
		return item
	end
	
	def save_image1(importsession_id,image_tag)
		if image_tag
			ImageWorker.perform_async(img,dir)
		end
	end

	def item_tag(string)
		string.strip if string
	end

	def item_cross(cross1,cross2)
		cross = []
		cross.push(item_tag(cross1)) if cross1
		cross.push(item_tag(cross2)) if cross2
		cross.empty? ? nil : cross 
	end

	def item_properties(array)
		hash = {}
		array["ЗначениеРеквизита"].each do |value|
			key_name = value["Наименование"]
			key_value = value["Значение"]
			hash[key_name] = key_value if key_value
		end
		hash
	end

	def save_image(el,item,dir)
		if el.at("Картинка")
			img = {'file'=> el.at("Картинка").content}
			img['item_id'] = item.id
			img['comment'] = el.at("Картинка").attribute('Описание').value if el.at("Картинка").attribute('Описание')
			ImageWorker.perform_async(img,dir)
		end 
	end


	def tree_to_a(tree, p = nil)
	  cid = tree["Ид"]
	  title = tree["Наименование"]
	    if tree["Группы"]["Группа"]
		  	if tree["Группы"]["Группа"].class.to_s == "Saxerator::Builder::HashElement"
		  		el = [tree["Группы"]["Группа"]]
		  	else
		  		el = tree["Группы"]["Группа"]
		  	end
	  	else	
	  	el = []
	  end
	  el.flat_map { |sub| tree_to_a(sub, cid) }
	  	.unshift("cid" => cid,"title"=> title ,"parent_cid" => p)
	end

end


