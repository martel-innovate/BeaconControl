class HomeSliderImageUploader < BaseUploader
  version :thumb do
    process :resize_to_fit => [200, 200]
  end
end
