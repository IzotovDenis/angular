module GroupsHelper

	def collapse_in(group)
		return '' unless @group
		return 'in' if @group.path_ids.include? group
	end
end
