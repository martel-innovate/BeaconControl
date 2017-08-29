module S2sApi
  module V1
    class ActionSerializer < BaseSerializer
      attributes :id, :name, :message, :active
    end
  end
end
