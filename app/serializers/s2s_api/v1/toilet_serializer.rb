module S2sApi
  module V1
    class ToiletSerializer < BaseSerializer
      attributes :id, :name, :accessible_text, :kind_text, :description, :created_at, :updated_at, :customer_id, :application_id

      def accessible_text
        object.accessible_text
      end

      def kind_text
        object.kind_text
      end
    end
  end
end
