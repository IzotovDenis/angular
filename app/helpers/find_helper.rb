module FindHelper

	def str_query(query)
		string = query.dup
		string.gsub! '*', ' '
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
