###
# Copyright (c) 2015, Upnext Technologies Sp. z o.o.
# All rights reserved.
#
# This source code is licensed under the BSD 3-Clause License found in the
# LICENSE.txt file in the root directory of this source tree.
###

module S2sApi
  module V1
    class BusStopsController < BaseController
      inherit_resources
      load_and_authorize_resource

      self.responder = S2sApiResponder

      actions :index
      def index
        render json: to_custom_json(@bus_stops.where('updated_at > ?', search_params[:timestamp]))
      end

      private

      def to_custom_json(collection)
        collection.map { |c|
          {
            id: c.id,
            name: c.name,
            lat: c.latitude,
            lng: c.longtitude,
            radius: c.radius,
            timestamp: c.updated_at
          }
        }.to_json
      end

      def search_params
        params.permit(:timestamp)
      end
    end
  end
end
