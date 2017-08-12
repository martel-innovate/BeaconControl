json.array!(@places) do |place|
  json.extract! place, :id, :type, :name, :address, :zip_code, :city, :opening_hours, :has_opening_hours, :entrance, :website, :phone, :email
  json.url place_url(place, format: :json)
end
