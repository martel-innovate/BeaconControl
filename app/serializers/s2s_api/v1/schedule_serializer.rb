module S2sApi
  module V1
    class ScheduleSerializer < BaseSerializer
      attributes :id, :name, :beacon, :kind_name, :start_date, :end_date, :start_time, :end_time, :customer_id, :application_id

      has_one :coupon, root: :template
    end
  end
end
