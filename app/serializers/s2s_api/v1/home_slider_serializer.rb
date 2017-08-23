module S2sApi
  module V1
    class HomeSliderSerializer < BaseSerializer
      attributes :id, :name, :start_date, :end_date, :slider1_url, :slider2_url
    end
  end
end
