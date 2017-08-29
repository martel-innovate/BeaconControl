module S2sApi
  module V1
    class HomeSliderSerializer < BaseSerializer
      attributes :id, :name, :start_date, :end_date, :slider1_url, :slider2_url, :customer_id, :application_id
    end
  end
end
