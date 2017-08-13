module S2sApi
  module V1
    class PlaceSerializer < BaseSerializer
      attributes :id, :type, :name, :address, :zip_code, :city, :opening_hours, :has_opening_hours, :website, :phone, :email
    end
  end
end