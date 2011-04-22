class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(resource)
    case resource
    when :user, User
      user_url(resource)
    else
      super
    end
  end
end
