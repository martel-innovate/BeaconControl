class HomeSliderDecorator < ApplicationDecorator
  def name
    object.name
  end
end
