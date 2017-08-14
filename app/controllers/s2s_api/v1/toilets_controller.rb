###
# Copyright (c) 2015, Upnext Technologies Sp. z o.o.
# All rights reserved.
#
# This source code is licensed under the BSD 3-Clause License found in the
# LICENSE.txt file in the root directory of this source tree.
###

module S2sApi
  module V1
    class ToiletsController < BaseController
      inherit_resources
      load_and_authorize_resource

      self.responder = S2sApiResponder

      actions :index
      def index
        render json: to_custom_json(search_by_timestamp)
      end

      private

      def search_by_timestamp
        search_params[:timestamp] ? @bus_stops.where('updated_at > ?', search_params[:timestamp]) : @bus_stops
      end

      def to_custom_json(collection)
        collection.map { |c|
          {
            id: c.id,
            name: c.name,
            type: c.kind,
            accessible: c.accessible,
            description: c.description,
            address: {
              street: c.address.street,
              zip: c.address.zip,
              city: c.address.city,
              latitude: c.address.latitude,
              longtitude: c.address.longtitude
            },
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
