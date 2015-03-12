module FindHelper

	def str_query(query)
		string = query.dup
		string.gsub!(/[^0-9A-Za-z]/, ' ')
		string.gsub!(/(\d)/, ' \1 ')
		d = []
		d << ["(#{string} | *#{string}*)"]
		string.split(" ").each do |i|
			d << ["(#{i} | *#{i}*)"]
		end
		string.delete!(" ")
		d = d.join(" & ")
		d = "( #{d} )"
		d << " | (#{string} | *#{string}*)"

	end

end
