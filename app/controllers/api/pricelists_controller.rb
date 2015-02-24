class Api::PricelistsController < ApiController
IMAGES_PATH = File.join(Rails.root, "public", "sys", "pricelist")

  def download
    send_file(File.join(IMAGES_PATH, "ponomarev-pricelist.zip"))
  end

end
