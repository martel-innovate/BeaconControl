###
# Copyright (c) 2015, Upnext Technologies Sp. z o.o.
# All rights reserved.
#
# This source code is licensed under the BSD 3-Clause License found in the
# LICENSE.txt file in the root directory of this source tree.
###

module Api
  module V1
    class BaseController < ApplicationController
      before_action :keycloak_authorize!
      skip_before_action :keycloak_authorize!, only: [:get_keycloak_token]

      def get_keycloak_token
        require 'rest-client'
        require 'json'

        access_token = ""
        payload = {}
        payload['grant_type'] = 'client_credentials'
        payload['client_id'] = params[:client_id] || ''
        payload['client_secret'] = params[:client_secret] || ''

        response = RestClient.post(
          AppConfig.keycloak_token_endpoint,
          payload,
          'Content-Type' => 'application/x-www-form-urlencoded'
        )
        response = JSON.parse(response.body)
        response[:created_at] = Time.now().to_i
        render json: response.to_json, status: 200
      end

      private

      def keycloak_authorize!
        require 'json'

        token = request.headers['HTTP_AUTHORIZATION'].split(" ")[1]

        payload = {
          'grant_type' => 'client_credentials',
          'client_id' => AppConfig.keycloak_client_id,
          'client_secret' => AppConfig.keycloak_client_secret,
          'token' => token
        }
        response = RestClient.post(
          AppConfig.keycloak_token_introspect_endpoint,
          payload,
          'Content-Type' => 'application/x-www-form-urlencoded'
        )

        response = JSON.parse(response.body)
        active = response["active"]
        unless active
          render json: {}, status: 403
        end
      end

      def application
        require 'json'

        token = request.headers['HTTP_AUTHORIZATION'].split(" ")[1]

        payload = {
          'grant_type' => 'client_credentials',
          'client_id' => AppConfig.keycloak_client_id,
          'client_secret' => AppConfig.keycloak_client_secret,
          'token' => token
        }
        response = RestClient.post(
          AppConfig.keycloak_token_introspect_endpoint,
          payload,
          'Content-Type' => 'application/x-www-form-urlencoded'
        )

        response = JSON.parse(response.body)
        client_id = (response['client_id']).split('-').last
        sql = 'select * from oauth_applications where uid = "' + client_id + '"'
        oauthApp = ActiveRecord::Base.connection.execute(sql).first
        app = Application.find(oauthApp[7])

        @application ||= app
      end

      def current_user
        @current_user ||= current_device.user
      end

      def current_device
        require 'json'

        token = request.headers['HTTP_AUTHORIZATION'].split(" ")[1]

        payload = {
          'grant_type' => 'client_credentials',
          'client_id' => AppConfig.keycloak_client_id,
          'client_secret' => AppConfig.keycloak_client_secret,
          'token' => token
        }
        response = RestClient.post(
          AppConfig.keycloak_token_introspect_endpoint,
          payload,
          'Content-Type' => 'application/x-www-form-urlencoded'
        )

        response = JSON.parse(response.body)
        client_id = (response['client_id']).split('-').last
        sql = 'select * from oauth_applications where uid = "' + client_id + '"'
        oauthApp = ActiveRecord::Base.connection.execute(sql).first
        device = MobileDevice.find(oauthApp[7])

        @current_device ||= device
      end
    end
  end
end
