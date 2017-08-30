module S2sApi
  module V1
    class GeofenceSerializer < BaseSerializer
      attributes :id, :name, :latitude, :longtitude, :radius, :enter_action, :exit_action, :active, :customer_id, :application_id
    end
  end
end
