class ApplicationController < ActionController::Base
  include ActionController::Cookies
  include Devise::Controllers::Helpers

  def fallback_index_html
    render file: Rails.root.join('public', 'index.html'), layout: false
  end
end
