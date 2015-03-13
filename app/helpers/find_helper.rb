# coding: utf-8
module FindHelper

	def str_query(query)
		#создаем копию запроса
		string = query.dup
		#Оставляем только разрешенные символы
		string.gsub!(/[^0-9A-Za-zА-Яа-я]/, ' ')
		# Формируем строку для поиска
		d = string_find(string)
		#Если в строке цифра добавляем разделяем ее пробелами
		string.gsub!(/(\d)/, ' \1 ')
		d << " | #{string_find(string)}"
		string.delete!(" ")
		d << " | (#{string} | *#{string}*)"
	end

	def string_find(string)
		d = []
		d << ["(#{string} | *#{string}*)"]
		string.split(" ").each do |i|
			d << ["(#{i} | *#{i}*)"]
		end
		d = d.join(" & ")
		d = "( #{d} )"
		return d
	end


	def te
		string.gsub!(/(\d)/, ' \1 ')
	end
end