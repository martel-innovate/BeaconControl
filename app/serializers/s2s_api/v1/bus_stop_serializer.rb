module S2sApi
  module V1
    class BusStopSerializer < BaseSerializer
      attributes :id, :name, :latitude, :longtitude, :radius, :created_at, :updated_at, :customer_id, :application_id
    end
  end
end
