class ApplicationController < ActionController::Base
  include ActionController::Cookies
  include Devise::Controllers::Helpers
  
  # Skip CSRF for API endpoints (using cookie-based auth instead)
  skip_before_action :verify_authenticity_token, if: -> { request.path.start_with?('/api') }

  def fallback_index_html
    render file: Rails.root.join('public', 'index.html'), layout: false
  end
end
