module ApplicationHelper
include OrdersHelper

def resource_name
:user
end

def helper_item_qty(qty)
	case qty
		when 0
			"0"
		when 1..9
			qty.to_s
		when 10..49
			"10-49"
		when 50..100
			"50-100"
		else
			"> 100"
	end
end

def resource
@resource ||= User.new
end

def devise_mapping
@devise_mapping ||= Devise.mappings[:user]
end

def price(value)
	if value == 0
		"по запросу"
	else
		number_with_precision(value, precision: 2) 
	end
end

def cy_value(currency_name)
if @currency = Currency.where(:name=>currency_name)
@currency.first.rate
end
end

def page_title(page_title)
content_for :title, "#{page_title.to_s} | #{t(:title)}"
end

def groups
Group.all.arrange_serializable(:order=>:position)
end

def find_attributes
[[ "Везде","anywhere"],
[ "Код товара","code"],
[ "Артикул","article"],
[ "Наименование","title"],
[ "ОЕМ","OEM"]]
end

def user_roles(role = false)
@roles = {'user'=>'Пользователь','buyer'=>'Покупатель','superbuyer'=>'Супер покупатель','admin'=>'Администратор','dev'=>'Джедай'}
@avaiable = {'user'=>'Пользователь','buyer'=>'Покупатель','superbuyer'=>'Супер покупатель'}
if role
@roles[role] ? @roles[role] : role
else 
@avaiable
end
end


end
