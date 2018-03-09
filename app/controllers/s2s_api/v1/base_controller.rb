###
# Copyright (c) 2015, Upnext Technologies Sp. z o.o.
# All rights reserved.
#
# This source code is licensed under the BSD 3-Clause License found in the
# LICENSE.txt file in the root directory of this source tree.
###

module S2sApi
  module V1
    require "s2s_api_responder"

    class BaseController < ApplicationController
      before_action :keycloak_authorize!
      skip_before_action :keycloak_authorize!, only: [:get_keycloak_token]

      rescue_from StandardError do |e|
        Rails.logger.info e.message
        Rails.logger.debug e

        render json: {}, status: 500
      end

      rescue_from ActiveRecord::RecordNotFound do |e|
        Rails.logger.info e.message

        render json: {}, status: 404
      end

      rescue_from CanCan::AccessDenied do |e|
        Rails.logger.info e.message

        render json: {}, status: 403
      end

      respond_to :json

      def get_keycloak_token
        require 'rest-client'
        require 'json'

        client_id = params[:client_id] || ''

        access_token = ""
        payload = {}
        payload['grant_type'] = params[:grant_type] || ''
        payload['username'] = params[:username] || ''
        payload['password'] = params[:password] || ''
        payload['client_id'] = client_id
        payload['client_secret'] = params[:client_secret] || ''
        payload['scope'] = client_id + '/admin'

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

      def current_admin
        email = keycloak_get_user_email()
        @current_admin ||= begin
          admin = Admin.find_by(email: email)
          admin ? AdminDecorator.new(admin) : nil
        end
      end

      def current_account
        @current_account ||= current_admin.account
      end

      def doorkeeper_authorize!
        super(:s2s_api)
      end

      def raw_authorize!
        unless Doorkeeper::Application.find_by(uid: params[:client_id], secret: params[:client_secret])
          render json: {}, status: 403
        end
      end

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
        roles = response["resource_access"][AppConfig.keycloak_client_id]["roles"]
        isAdmin = roles.include? 'admin'
        active = response["active"]
        unless isAdmin && active
          render json: {}, status: 403
        end
      end

      def keycloak_get_user_email
        require 'json'

        token = request.headers['HTTP_AUTHORIZATION'].split(" ")[1]

        response = RestClient.get(
          AppConfig.keycloak_user_info_endpoint,
          'Content-Type' => 'application/x-www-form-urlencoded',
          'Authorization' => 'Bearer ' + token,
        )
        response = JSON.parse(response.body)
        email = response["email"]
        return email
      end

      def collection_action?
        action_name == 'index'
      end
    end
  end
end
