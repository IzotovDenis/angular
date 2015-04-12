# coding: utf-8
ThinkingSphinx::Index.define :item, :name => 'item_oem', :with => :active_record do
  # fields
  join group
  where "disabled = 'f' OR disabled IS NULL"
  indexes "properties -> 'ОЕМ'", :as => :oem, :sortable => true
  has created_at, updated_at, group_id, position

  set_property :ignore_chars => "-, (, )"
end