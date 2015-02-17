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

def import_item
	parser = Saxerator.parser(File.new("/home/den/import.xml"))
	parser.for_tag("Товар").each do |tag|
		item = {}
		item['cid'] = tag["Ид"]
		item['full_title'] = tag["ПолноеНаименование"]
		item['article'] = tag["Артикул"]
		puts item
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


