# coding: utf-8
class Api::FindController < ApiController
  include FindHelper
  after_action :set_activity
  respond_to :json
  def index
    @query = params[:query]
    @items = Item.search(str_query(params[:query]), set_options)
    respond_with @items
  end

  private

  def set_activity
  activity_save :controller=>"find", :action=>action_name, :text=>@query, :result=>@items.total_entries, :page=>params[:page]
  end

  def set_options
    options = {}
    options[:sql] = {:include => :prices, :joins => :group, :select=>"distinct items.*, groups.title as group_title"}
    options[:field_weights] = {:kod => 90, :article => 60, :oem => 5,:full_name => 20}
    options[:order_by] = 'properties["Код товара"]'
    options[:with] = {:group_id => params[:group].to_i} if params[:group]
    options[:page] = params[:page]
    options[:indices] = set_indices
    options
  end

  def set_indices
    case params[:attr]
      when "code"
        indices = ['item_kod_core']
      when "article"
        indices = ['item_article_core']
      when "title"
        indices = ['item_title_core']
      when "oem"
        indices = ['item_oem_core']
      else
        indices = ['item_core']
      end
    indices
  end

end