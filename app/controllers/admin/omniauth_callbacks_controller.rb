class Admin::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def openid_connect
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
