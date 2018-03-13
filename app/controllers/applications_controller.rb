###
# Copyright (c) 2015, Upnext Technologies Sp. z o.o.
# All rights reserved.
#
# This source code is licensed under the BSD 3-Clause License found in the
# LICENSE.txt file in the root directory of this source tree.
###

class ApplicationsController < AdminController
  inherit_resources
  load_and_authorize_resource

  before_action :build_rpush_apps, only: [
    :edit, :set_apns_production_cert, :set_apns_sandbox_cert
  ]
  before_action :build_app_settings, only: [
    :edit
  ]

  def create
    application = Application::Factory.new(current_admin, permitted_params)

    app = application.create

    sql = "select * from oauth_applications where owner_id = " + app.id.to_s
    oauthApp = ActiveRecord::Base.connection.execute(sql).first
    clientID = oauthApp[2]
    secretID = oauthApp[3]

    access_token = get_keycloak_token()
    create_keycloak_client(access_token, clientID, secretID)

    if app.persisted?
      redirect_to application_activities_path(app)
    else
      redirect_to :back
    end
  end

  def update
    @application.update_attributes(permitted_params)

    redirect_to :back
  end

  def destroy
    @application.destroy
    redirect_to :back
  end

  def set_apns_sandbox_cert
    rpush_app = RpushApnsApp.new(
      cert_permitted_params[:apns_app_sandbox_attributes].merge(
        environment: 'sandbox',
        application: @application
      )
    ).app

    if rpush_app.valid?
      @application.apns_app_sandbox = rpush_app
      @application.save
    end

    redirect_to edit_application_path(@application)
  end

  def set_apns_production_cert
    rpush_app = RpushApnsApp.new(
      cert_permitted_params[:apns_app_production_attributes].merge(
        environment: 'production',
        application: @application
      )
    ).app

    if rpush_app.valid?
      @application.apns_app_production = rpush_app
      @application.save
    end

    redirect_to edit_application_path(@application)
  end

  private

  def get_keycloak_token
    require 'rest-client'
    require 'json'

    access_token = ""
    payload = {}
    payload['grant_type'] = 'password'
    payload['username'] = AppConfig.keycloak_realm_admin_username
    payload['password'] = AppConfig.keycloak_realm_admin_password
    payload['client_id'] = 'admin-cli'
    payload['client_secret'] = AppConfig.keycloak_realm_admin_secret

    response = RestClient.post(
      AppConfig.keycloak_token_endpoint,
      payload,
      'Content-Type' => 'application/x-www-form-urlencoded'
    )
    access_token = JSON.parse(response.body)["access_token"]
    return access_token
  end

  def create_keycloak_client(access_token, clientID, secretID)
    require 'rest-client'
    require 'json'

    if ENV["KEYCLOAK_CLIENTS_ENDPOINT"].nil?
      keycloak_url = "https://auth.s.orchestracities.com/auth/admin/realms/default/clients"
    else
      keycloak_url = ENV["KEYCLOAK_ADMIN_CLIENTS_ENDPOINT"]
    end
    payload = {
      'clientId' => 'beacon-manager-'+clientID,
      'name' => 'Test beacon app',
      'description' => 'Test beacon app',
      'rootUrl' => 'beacon.s.orchestracities.com',
      'adminUrl' => 'beacon.s.orchestracities.com',
      'surrogateAuthRequired' => false,
      'enabled' => true,
      'clientAuthenticatorType' => 'client-secret',
      'secret' => secretID,
      'redirectUris' => ['beacon.s.orchestracities.com/*', 'http://localhost:3000/*'],
      'webOrigins' => ['beacon.s.orchestracities.com'],
      "notBefore" => 0,
      "bearerOnly" => false,
      "consentRequired" => false,
      "standardFlowEnabled" => true,
      "implicitFlowEnabled" => true,
      "directAccessGrantsEnabled" => true,
      "serviceAccountsEnabled" => true,
      "authorizationServicesEnabled" => true,
      "publicClient" => false,
      "frontchannelLogout" => false,
      "protocol" => "openid-connect",
      "attributes" => {
        "saml.assertion.signature" => "false",
        "saml.force.post.binding" => "false",
        "saml.multivalued.roles" => "false",
        "saml.encrypt" => "false",
        "saml_force_name_id_format" => "false",
        "saml.client.signature" => "false",
        "saml.authnstatement" => "false",
        "saml.server.signature" => "false",
        "saml.server.signature.keyinfo.ext" => "false",
        "saml.onetimeuse.condition" => "false"
      },
      "fullScopeAllowed" => false,
      "nodeReRegistrationTimeout" => -1,
      "clientTemplate" => "Default Orchestra Cities Client Template",
      "useTemplateConfig" => false,
      "useTemplateScope" => true,
      "useTemplateMappers" => true,
      "access" => {
          "view" => true,
          "configure" => true,
          "manage" => true
      }
    }
    response = RestClient.post(
      keycloak_url,
      payload.to_json,
      'Content-Type' => 'application/json',
      'Authorization' => 'Bearer ' + access_token
    )
    return response
  end

  def permitted_params
    params.require(:application).permit(
      *test_app_permitted_params,
      application_settings_attributes: [:id, :extension_name, :type, :key, :value]
    )
  end

  def test_app_permitted_params
    application.test ? [] : [:name]
  end

  def cert_permitted_params
    params.require(:application).permit(
      apns_app_sandbox_attributes: [:id, :passphrase, :cert_p12],
      apns_app_production_attributes: [:id, :passphrase, :cert_p12]
    )
  end

  def begin_of_association_chain
    current_admin
  end

  def resource
    super.decorate
  end

  def collection
    @applications = super.decorate
  end

  def application
    @application ||= Application.new
  end
  helper_method :application

  def build_rpush_apps
    @application.apns_app_sandbox    || @application.build_apns_app_sandbox
    @application.apns_app_production || @application.build_apns_app_production
  end

  def build_app_settings
    ApplicationSetting::Factory.new(@application).build
  end
end
