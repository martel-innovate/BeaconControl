class Admin::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def openid_connect
    if !request.env["omniauth.auth"].credentials.scope.split(" ").include?(AppConfig.keycloak_client_id+"/admin")
      redirect_to root_path
      set_flash_message(:notice, :failure, kind: "openid_connect", reason: "User is not a Beacon Manager Admin") if is_navigational_format?
      return
    end

    @admin = Admin.from_omniauth(request.env["omniauth.auth"])

    if @admin.persisted?
      sign_in_and_redirect @admin, event: :authentication
      set_flash_message(:notice, :success, kind: "openid_connect") if is_navigational_format?
    else
      session["devise.openid_connect_data"] = request.env["omniauth.auth"]
      sign_in_and_redirect @admin, event: :authentication
      set_flash_message(:notice, :success, kind: "openid_connect") if is_navigational_format?
    end
  end

  def failure
    redirect_to root_path
  end
end
