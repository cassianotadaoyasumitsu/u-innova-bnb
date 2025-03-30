# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    Rails.logger.debug "=== OAuth Debug Info ==="
    Rails.logger.debug "GOOGLE_CLIENT_ID: #{ENV['GOOGLE_CLIENT_ID']}"
    Rails.logger.debug "GOOGLE_CLIENT_SECRET: #{ENV['GOOGLE_CLIENT_SECRET']}"
    Rails.logger.debug "Request URL: #{request.url}"
    Rails.logger.debug "Callback URL: #{user_google_oauth2_omniauth_callback_path}"
    Rails.logger.debug "Auth Hash: #{request.env['omniauth.auth'].to_hash}"
    Rails.logger.debug "======================"
    
    user = User.from_omniauth(request.env['omniauth.auth'])

    if user.persisted?
      sign_in user
      redirect_to root_path, event: :authentication
    else
      session['devise.google_data'] = request.env['omniauth.auth'].except(:extra)
      redirect_to new_user_registration_url, alert: "Não foi possível criar sua conta. Por favor, tente novamente ou entre em contato com o suporte."
    end
  end

  def failure
    Rails.logger.debug "=== OAuth Failure Debug Info ==="
    Rails.logger.debug "Failure Reason: #{params[:message]}"
    Rails.logger.debug "======================"
    redirect_to root_path, alert: "Não foi possível fazer login com o Google. Por favor, tente novamente."
  end
end 