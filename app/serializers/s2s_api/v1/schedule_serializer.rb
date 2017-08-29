module S2sApi
  module V1
    class ScheduleSerializer < BaseSerializer
      attributes :id, :name, :beacon, :kind_name, :start_date, :end_date, :start_time, :end_time, :template, :active, :customer_id, :application_id

      def template
        coupon
      end
    end
  end
end
