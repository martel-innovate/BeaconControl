module S2sApi
  module V1
    class AdvertismentSerializer < ApplicationSerializer
      attributes :id, :name, :start_date, :end_date, :image_url
    end
  end
end
