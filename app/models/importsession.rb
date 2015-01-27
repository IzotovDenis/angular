class Importsession < ActiveRecord::Base
	has_many :imports
	include Importv2Helper

	def start_import(dir)
		import1c(dir, self.id)
	end
end
