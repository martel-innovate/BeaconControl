###
# Copyright (c) 2015, Upnext Technologies Sp. z o.o.
# All rights reserved.
#
# This source code is licensed under the BSD 3-Clause License found in the
# LICENSE.txt file in the root directory of this source tree.
###

class ApplicationController < ActionController::Base
  force_ssl if: -> { AppConfig.force_ssl }
  before_action :set_application_url

  before_filter :configure_permitted_parameters, if: :devise_controller?

  def current_ability
    @current_ability ||= Ability.new(current_admin)
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end

  def set_application_url
    if ActionMailer::Base.default_url_options[:host] != request.host
      ActionMailer::Base.default_url_options[:host] = AppConfig.mailer_url_options[:host] = request.host
    end
  end
  protected

  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.for(:sign_up).push(added_attrs)
    devise_parameter_sanitizer.for(:sign_in).push(added_attrs)
    devise_parameter_sanitizer.for(:account_update).push(added_attrs)
  end

end
