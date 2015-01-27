class Admin::SearchesController < AdminController

def index
	@searches = Search.all.limit(100)
end

end