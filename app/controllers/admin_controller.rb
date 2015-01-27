class AdminController < ApplicationController
layout 'admin'
before_filter :verify_admin
helper_method :xeditable?


def xeditable? object = nil
  true # Or something like current_user.xeditable?
end
  
private
def verify_admin
  redirect_to root_url unless current_user.try(:admin?)
end
end
