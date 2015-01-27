# coding: utf-8
module Importv2Helper
# Открытие файла xml, dir - каталог с файлом, type - тип файла import/offers
	def open_xml(dir,type)
		location = "#{dir}/#{type}.xml"
		file = File.open(location)
		Nokogiri::XML(file)
	end
# Проверяется полная выгрузка или изменения
	def check_changes(xml)
		xml.xpath('//Каталог').attr("СодержитТолькоИзменения").value == "false" ? false : true
	end

# Импорт групп из выгрузки
	def get_groups(xml, importsession_id)
		groups = xml.xpath('//Группа')
		groups.each do |el|
			hash = Hash.new
			hash['cid'] = el.at("Ид").content
			hash['title'] = el.at("Наименование").content
			hash['importsession_id'] = importsession_id
			if el.parent.parent.name == "Группа"
				hash['parent_cid'] = el.parent.parent.at('Ид').content
			end
			group = Group.find_or_initialize_by(cid: hash['cid'])
			group.update(hash)
			puts "Import #{hash['title']}"
		end
	end

# Установка иерархии групп
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

# Скрытие групп если родитель скрытый
	def set_disabled_group
		@group = Group.disableded
		@group.each do |group|
			group.set_disabled
		end
	end

# Импорт товаров, xml - файл, importsession_id - номер сессии импорта, dir - адрес расположения импорта
	def get_goods(xml, importsession_id, dir)
		goods = xml.xpath('//Товар')
		goods.each do |el|
			hash = parsing_item(el)
			item = Item.find_or_initialize_by(cid: hash['cid'])
			hash['importsession_id'] = importsession_id
			if item.update(hash)
				puts "import item #{item.full_title}"
				puts "import item #{item.id}"
				save_image(el,item,dir)
			end
		end
	end
# парсинг товара
	def parsing_item(el)
		hash = Hash.new
		hash['cid'] = el_value(el, "Ид")
		hash['article'] = el_value(el, "Артикул")
		hash['title'] = el_value(el, "Наименование")
		hash['full_title'] = el_value(el, "ПолноеНаименование")
		hash['brand'] = el_value(el, "Бренд")
		hash['text'] = el_value(el,"Описание")
		hash['certificate'] = el_value(el,"СсылкаНаСертификат")
		hash['group_cid'] =  el.at("Группы").at("Ид").content if el.at("Группы")
		hash['properties'] = set_properties(el)
		return hash
	end

# парсинг элемента xml
	def el_value(el, field)
		el.at(field) ? el.at(field).content : nil
	end
# парсинг ЗначенияРеквизитов
	def set_properties(el)
		hash = Hash.new
			el.xpath("ЗначенияРеквизитов/ЗначениеРеквизита/Значение").each do |property|
				prop_key = property.parent.at("Наименование").content
				hash[prop_key] = property.content
			end
		return hash
	end

# сохранение картинок
	def save_image(el,item,dir)
		if el.at("Картинка")
			img = {'file'=> el.at("Картинка").content}
			img['item_id'] = item.id
			img['comment'] = el.at("Картинка").attribute('Описание').value if el.at("Картинка").attribute('Описание')
			ImageWorker.perform_async(img,dir)
		end 
	end

	def remove_old_groups(importsession_id)
		# Поиск групп не из текущей сессии обмена
		groups = Group.where.not(importsession_id: importsession_id)
			if groups
				groups.each do |group|
					# Проверяем наличие товаров в группе.
					if group.items.empty?
						# Если нет то удаляем
						group.destroy
					end
				end
			end
	end

# Выгрузка цен и остатков
	def get_offers(xml,dir)
		offers = xml.xpath('//Предложение')
		offers.each do |el|
			item = Item.find_by_cid(el_value(el, 'Ид'))
			next unless item
			item.qty = el_value(el,'Количество').to_i
			item.save
			el.xpath("Цены/Цена").each do |el_price|
				hash =	parsing_price(el_price)
				hash['item_id'] = item.id
				if p_type = Pricetype.find_by_cid(hash['pricetype_cid']) 
					hash['pricetype_id'] = p_type.id
					hash.except!('pricetype_cid')
				else
					next
				end 
					price = Price.find_or_initialize_by(:item_id=>hash['item_id'],:pricetype_id=>hash['pricetype_id'])
					price.update(hash)
			end
		end
	end

# Парсинг цены
	def parsing_price(el)
		hash = Hash.new
		hash['title'] = el_value(el, 'Представление')
		hash['value'] = el_value(el, 'ЦенаЗаЕдиницу').gsub(",",".").to_f
		hash['unit'] = el_value(el, 'Единица')
		hash['cy'] = el_value(el, 'Валюта')
		hash['pricetype_cid'] = el_value(el, 'ИдТипаЦены')
		return hash
	end
# Установка групп для товаров
	def set_group(importsession_id)
		items = Item.where("importsession_id"=>importsession_id)
		items.each do |item|
			if item.group_cid
				group = Group.where(:cid=>item.group_cid).first
					if group
						item.group = group
						item.save
						puts "#{item.full_title} -- >> #{group.title}"
					end
			end
		end
	end


	def import1c(dir, importsession_id)
			xml_import = open_xml(dir, "import")
			xml_offers = open_xml(dir, "offers")
			if check_changes(xml_import)
				change_import(xml_offers, xml_import, dir, importsession_id)
			else
				full_import(xml_offers, xml_import, dir, importsession_id)
			end
	end

#Полный импорт
	def full_import(xml_offers, xml_import, dir, importsession_id)
		#Импортируем группы
		get_groups(xml_import, importsession_id)
		#Устанавливаем иерархию
		set_parent_group
		#Удаляем старые группы
		remove_old_groups(importsession_id)
		#Скрываем скрытые папки
		set_disabled_group
		#Импортируем товары
		get_goods(xml_import, importsession_id, dir)
		#Импортируем цены
		get_offers(xml_offers,dir)
		#Привязываем товары к группе
		set_group(importsession_id)
		return true
	end

# Измененный импорт
	def change_import(xml_offers, xml_import, dir, importsession_id)
		get_goods(xml_import, importsession_id, dir)
		get_offers(xml_offers,dir)
		set_group(importsession_id)
		return true
	end


end