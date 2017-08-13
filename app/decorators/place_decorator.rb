class PlaceDecorator < ApplicationDecorator

  def name
    object.name
  end

  def full_address
    "#{object.address}, #{object.zip_code} #{object.city}"
  end
end
