class ApplicationController < ActionController::API
  include ActionController::Cookies

  private

  SESSION_COOKIE_NAME = 'sms_session_id'

  def get_or_create_session_id
    session_id = cookies[SESSION_COOKIE_NAME]

    unless session_id.present?
      session_id = SecureRandom.uuid
      cookies[SESSION_COOKIE_NAME] = {
        value: session_id,
        httponly: true,
        secure: Rails.env.production?,
        same_site: :lax
      }
    end

    session_id
  end

  def current_session_id
    cookies[SESSION_COOKIE_NAME]
  end
end
