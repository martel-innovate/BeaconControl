class Admin::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def openid_connect
    puts request
  end
end
