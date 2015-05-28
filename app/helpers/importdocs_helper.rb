module ImportdocsHelper

	def import_folders
		require 'csv'
		next_id = Folder.create(:name=>"sys").id-6
		Folder.last.destroy
		file = File.read("/home/den/folder.csv")
		csv = CSV.parse(file, :headers => true)
		csv.each do |line|
			folder = Folder.new(:name=>line['name'])
			if line["ancestry"]
				folder.parent_id = line['ancestry'].split("/").last.to_i+next_id
			end
			folder.save
		end
	end

	def import_doc
		require 'csv'
		ratio = 32
		file = File.read("/home/den/doc.csv")
		csv = CSV.parse(file, :headers => true)
		csv.each do |line|
			file = Ffile.new(:name=>line['name'])
			if line["folder_id"]
				file.folder_id = line["folder_id"].to_i+32
			end
			f = Dir.entries("/home/deployer/doc/file/#{line['id']}")
			f.delete(".")
			f.delete("..")
			f = f[0]
			file = File.open("/home/deployer/doc/file/#{line['id']}/#{d}")
			file.save
		end
		end
end