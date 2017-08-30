module S2sApi
  module V1
    class AdvertismentSerializer < BaseSerializer
      attributes :id, :name, :start_date, :end_date, :image_url, :customer_id, :application_id
    end
  end
end
