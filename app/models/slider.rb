class Slider < ActiveRecord::Base
	mount_uploader :image, SliderUploader
	default_scope { order('position') }
end
