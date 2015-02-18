class Api::PricelistsController < ApiController
IMAGES_PATH = File.join(Rails.root, "public", "sys", "pricelist")

  def index
    send_file(File.join(IMAGES_PATH, "ponomarev-pricelist.zip"))
  end

end
