class AdvertismentDecorator < ApplicationDecorator
  def name
    object.name
  end
end
