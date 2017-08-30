module S2sApi
  module V1
    class AddressSerializer < BaseSerializer
      attributes :id, :street, :zip, :city, :latitude, :longtitude
    end
  end
end
