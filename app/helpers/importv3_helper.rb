module Importv3Helper

	def parse_groups(importsession_id)
		file = "public/uploads/imports/#{importsession_id}/import.xml"
		parser = Saxerator.parser(File.new(file))
		parser.for_tag("Группа").each do |tag|
			tree_to_a(tag).each do |xml_group|
				group = Group.find_or_initialize_by(cid: xml_group['cid'])
				xml_group['importsession_id'] = importsession_id
				group.update(xml_group)
			end
		end
	end

	def parse_items(importsession_id)
		time = Time.now
		file = "public/uploads/imports/#{importsession_id}/import.xml"
		parser = Saxerator.parser(File.new(file))
		parser.for_tag("Товар").each do |tag|
			hash = parse_item(tag)
			hash['importsession_id'] = importsession_id
			item = Item.find_or_initialize_by(cid: hash['cid'])
			if item.update(hash)
				puts item.full_title
				#save_image(importsession_id, tag["Картинка"], item.id)
			end
		end
		puts Time.now-time
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
		item['properties']['Размер'] = item_tag(tag["Размер"]) if tag["Размер"]
		return item
	end
	
	def save_image(importsession_id, image_tag, item_id)
		file = "#{Rails.root}/public/uploads/imports/#{importsession_id}/#{image_tag}"
		if image_tag
			ImageWorker.perform_async(file, item_id)
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

	def set_group(importsession_id)
		groups = Group.where("importsession_id"=>importsession_id)
		groups.each do |group|
			Item.where(:group_cid=>group.cid).update_all(:group_id=>group.id)
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

	def set_parent_group
		groups = Group.all
		groups.each do |group|
			if group.parent_cid
				parent = Group.where(:cid=>group.parent_cid).first
				group.parent_id = parent.id
			else
				group.parent_id = nil
			end
			group.save
		end
	end

# Удаление старых групп
	def remove_old_groups(importsession_id)
		# Поиск групп не из текущей сессии обмена
		groups = Group.where.not(importsession_id: importsession_id)
		if groups
			groups.each do |group|
				group.items each do |item|
					group.destroy
				end
			end
		end
	end

# Делаем группы скрытыми
	def set_disabled_group
		@group = Group.disableded
		@group.each do |group|
			group.set_disabled
		end
	end

# Импорт
	def import1c(importsession_id)
			# проверяем тип выгрузки
			importsession = Importsession.find(importsession_id)
			if importsession.exchange_type == "changes"
				# Действия для изменений
				change_import(importsession_id)
			elsif importsession.exchange_type == "full"
				# Действия для полной выгрузки
				full_import(importsession_id)
			end
	end


#Полный импорт
	def full_import(importsession_id)
		#Импортируем группы
		parse_groups(importsession_id)
		#Устанавливаем иерархию
		set_parent_group
		#Скрываем скрытые папки
		set_disabled_group
		#Импортируем товары
		parse_items(importsession_id)
		#Привязываем товары к группе
		set_group(importsession_id)
		#Импортируем цены
		get_offers(importsession_id)
		sort_items
		Group.set_new_item_time
		return true
	end

	def change_import(importsession_id)
		parse_items(importsession_id)
		get_offers(importsession_id)
		set_group(importsession_id)
		sort_items
		Group.set_new_item_time
		return true
	end

# Выгрузка цен и остатков
	def get_offers(importsession_id)
		time = Time.now
		file = "public/uploads/imports/#{importsession_id}/offers.xml"
		parser = Saxerator.parser(File.new(file))
		price_types = Hash[Pricetype.pluck(:cid, :id)]
		parser.for_tag("Предложение").take(1000).each do |tag|
			item = Item.find_by_cid(tag["Ид"])
			next if !item
			item.qty = tag["Количество"].to_i
			item.save
			next unless tag["Цены"]

			if tag["Цены"]["Цена"]
				if tag["Цены"]["Цена"].class.to_s == "Saxerator::Builder::HashElement"
					el = [tag["Цены"]["Цена"]]
				else
					el = tag["Цены"]["Цена"]
				end
			else	
				el = []
			end

			el.each do |offer|
				if price_types[offer["ИдТипаЦены"]]
					hash = parsing_price(offer)
					hash['pricetype_id'] = price_types[offer["ИдТипаЦены"]].to_i
					hash['item_id'] = item.id
					price = Price.find_or_initialize_by(:item_id=>hash['item_id'],:pricetype_id=>hash['pricetype_id'])
					price.update(hash)
				else
					next
				end
			end
		end
		puts Time.now-time
	end

	def get_offers1(importsession_id)
		time = Time.now
		file = "public/uploads/imports/#{importsession_id}/offers.xml"
		parser = Saxerator.parser(File.new(file))
		price_types = Hash[Pricetype.pluck(:cid, :id)]
		parser.for_tag("Предложение").each do |tag|
			item = Item.find_by_cid(tag["Ид"])
			next if !item
			item.qty = tag["Количество"].to_i

			unless tag["Цены"]
				item.save
				next
			end

			if tag["Цены"]["Цена"]
				if tag["Цены"]["Цена"].class.to_s == "Saxerator::Builder::HashElement"
					el = [tag["Цены"]["Цена"]]
				else
					el = tag["Цены"]["Цена"]
				end
			else	
				el = []
			end

			el.each do |offer|
				if price_types[offer["ИдТипаЦены"]]
					item.bids[offer["ИдТипаЦены"]] = parsing_price(offer)
					item.save
				else
					next
				end
			end
		end
		puts Time.now-time
	end
	

	def parsing_price(tag)
		hash = Hash.new
		hash['title'] = item_tag(tag["Представление"])
		hash['value'] = item_tag(tag["ЦенаЗаЕдиницу"]).gsub(",",".").to_f 
		hash['unit'] = item_tag(tag["Единица"])
		hash['cy'] = item_tag(tag["Валюта"]) 
		return hash
	end

	def sort_items
		Group.find_each do |group|
			items = group.items.able.sort_by &:full_title
			items.each_with_index do |item,index|
				item.update_attribute('position', index)
			end
		end
	end

end


