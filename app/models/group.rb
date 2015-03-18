class Group < ActiveRecord::Base
	has_ancestry
	has_many :items
	scope :able, ->{ where(disabled: [false,nil]).order('title') }
  scope :disableded, -> {where(disabled: true)}


def self.arrange_as_array(options={}, hash=nil)                                                                                                                                                            
    hash ||= arrange(options)

    arr = []
    hash.each do |node, children|
      arr << node
      arr += arrange_as_array(options, children) unless children.empty?
    end
    arr
  end

  def self.array_for_select
    arrange_as_array(:order=>"title").each {|n| n.title ="#{'--' * n.depth} #{n.title}" }
  end

  def toggle_disabled
    val = !self.disabled
    self.disabled = val
    self.save
    self.subtree.each do |group|
      group.disabled = val
      group.save
    end
  end

  def set_disabled
    self.subtree.each do |group|
      group.disabled = true
      group.save
    end
  end

  def change_disabled(val)
    disabled = val
    save!
  end

end