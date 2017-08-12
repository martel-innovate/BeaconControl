class PlaceSerializer < ApplicationSerializer
  attributes :id, :type, :name, :address, :zip_code, :city, :opening_hours, :has_opening_hours, :entrance, :website, :phone, :email
end
