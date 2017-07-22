###
# Copyright (c) 2015, Upnext Technologies Sp. z o.o.
# All rights reserved.
#
# This source code is licensed under the BSD 3-Clause License found in the
# LICENSE.txt file in the root directory of this source tree. 
###

module S2sApi
  module V1
    class GeofencesController < BaseController
      inherit_resources
      load_and_authorize_resource

      self.responder = S2sApiResponder

      actions :index
      def index
        render json: to_custom_json(@geofences.where(search_params))
      end

      private

      def to_custom_json(geofences)
        geofences.map { |geofence|
          {
            id: geofence.id,
            name: geofence.name,
            lat: geofence.latitude,
            lng: geofence.longtitude,
            radius: geofence.radius,
            actionEnter: geofence.enter_action.name,
            contentEnter: geofence.enter_action.message,
            actionExit: geofence.exit_action.name,
            contentExit: geofence.exit_action.message,
            active: geofence.active,
            enterState: geofence.enter_action.active,
            exitState: geofence.exit_action.active
          }
        }.to_json
      end

      def collection
        super.includes(:enter_action, :exit_action)
      end

      def search_params
        params.permit(:active)
      end
    end
  end
end
