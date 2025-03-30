class ApplicationController < ActionController::Base
  # Allow modern browsers and mobile browsers
  allow_browser versions: { chrome: ">= 60", firefox: ">= 60", safari: ">= 12", edge: ">= 79" }

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role])
  end
end
