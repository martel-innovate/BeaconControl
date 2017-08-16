class AdvertismentDecorator < ApplicationDecorator
  def name
    object.name
  end

  def validity
  end
end
