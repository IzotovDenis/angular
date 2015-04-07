# coding: utf-8
class Api::FindController < ApiController
  include FindHelper
  after_action :set_activity
  respond_to :json
  def index
    @query = params[:query]
    @items = Item.search(str_query(params[:query], params[:attr]), set_options)
    respond_with @items
  end

  private

  def set_activity
  activity_save :controller=>"find", :action=>action_name, :text=>@query, :result=>@items.total_entries, :page=>params[:page]
  end

  def set_options
    options = {}
    options[:sql] = {:include => :prices, :joins => :group, :select=>"distinct items.*, groups.title as group_title, groups.id as group_id"}
    options[:field_weights] = {:kod => 1000, :article => 60, :oem => 5,:full_name => 20}
    options[:order_by] = 'properties["Код товара"]'
    options[:per_page] = 60
    options[:with] = {:group_id => params[:group].to_i} if params[:group]
    options[:page] = params[:page]
    options
  end

  def set_options_ids
    options = set_options
    options[:group_by] = :group_id
    options[:per_page] = 50
    options.except(:page)
    options
  end

end